package acar.car_register;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;


public class CarMngDatabase
{
	private Connection conn = null;
	public static CarMngDatabase db;
	
	public static CarMngDatabase getInstance()
	{
		if(CarMngDatabase.db == null)
			CarMngDatabase.db = new CarMngDatabase();
		return CarMngDatabase.db;
	}	
	
 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection("acar");				
	    }catch(Exception e){
	    	System.out.println("I can't get a connection........");
	    }
	}
	
	private void closeConnection()
	{
		if ( conn != null ) 
		{
			connMgr.freeConnection("acar", conn);
			conn = null;
		}		
	}

	//select-----------------------------------------------------------------------------------------------------------------------------------------

	//자동차등록증 입/출고관리 리스트 조회
	public Vector getCarDocMngLists(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String where = "";
		query = " select"+ 
				" a.car_mng_id, a.car_doc_no, b.rent_mng_id, b.rent_l_cd,"+ 
				//" decode(a.car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext, "+ 
				" f.nm car_ext, "+ 
				" decode(a.car_use,'1','영업용','2','자가용') car_use,"+ 
				" a.car_no, a.car_nm,"+ 
				" c.seq, c.out_dt, c.out_id, c.out_st, c.cau, c.in_dt, e.user_nm as out_nm,"+ 
				" decode(c.out_st,'1','근저당설정','2','근저당해지','3','검사','4','구변검사','5','정밀검사','6','기타') out_st_nm"+ 
				" from car_reg a, cont b, car_doc_mng c, users e, (select * from code where c_st='0032') f"+ //, (select car_mng_id, max(out_dt) out_dt from car_doc_mng group by car_mng_id) d
				" where nvl(b.use_yn,'Y')='Y'"+ 
				" and a.car_mng_id=b.car_mng_id"+ 
				" and a.car_mng_id=c.car_mng_id(+)"+ 
//				" and c.car_mng_id=d.car_mng_id(+)"+ 
//				" and c.out_dt=d.out_dt(+)"+
				" and a.car_ext= f.nm_cd"+
				" and c.out_id=e.user_id(+)";

		if(t_wd.equals("")){
			if(!gubun1.equals("0"))		query += " and a.car_ext = '"+gubun1+"'";
			if(!gubun2.equals("0"))		query += " and a.car_use = '"+gubun2+"'";

			if(gubun3.equals("1"))		query += " and c.out_dt is not null and c.in_dt is not null";
			if(gubun3.equals("2"))		query += " and c.out_dt is not null and c.in_dt is null";

		}else{
			if(s_kd.equals("1"))		where = "a.car_doc_no";
			if(s_kd.equals("2"))		where = "a.car_no||' '||a.first_car_no";
			if(s_kd.equals("3"))		where = "a.car_nm";

			if(!t_wd.equals(""))		query += " and "+where+" like '%"+t_wd+"%'";
		}

		query += " ORDER BY a.init_reg_dt, a.car_doc_no ";

		try {
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarMngDatabase:getCarDocMngLists]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	//자동차등록증 입/출고 리스트 : 차량별
	public Vector getCarDocOIs(String car_mng_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.*, b.nm as out_st_nm, c.user_nm as out_id_nm FROM car_doc_mng a, code b, users c"+
				" WHERE a.car_mng_id=? and a.out_st=b.nm_cd and b.c_st='0011' and a.out_id=c.user_id"+
				" order by a.out_dt";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				CarDocBean bean = new CarDocBean();
				bean.setCar_mng_id		(rs.getString(1));
				bean.setSeq				(rs.getInt(2));
				bean.setOut_dt			(rs.getString(3));
				bean.setOut_id			(rs.getString(4));
				bean.setOut_st			(rs.getString(5));
				bean.setCau				(rs.getString(6));
				bean.setIn_dt			(rs.getString(7));
				bean.setOut_st_nm		(rs.getString(8));
				bean.setOut_id_nm		(rs.getString(9));
				vt.add(bean);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CarMngDatabase:getCarDocOIs]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	//자동차키 입/출고 리스트 : 차량별
	public Vector getCarKeyOIs(String car_mng_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.*, b.nm as key_kd_nm, c.user_nm as out_id_nm"+
				" FROM car_key_mng a, code b, users c"+
				" WHERE a.car_mng_id=? and a.key_kd=b.nm_cd and b.c_st='0012' and a.out_id=c.user_id"+
				" order by a.out_dt, a.seq";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				CarKeyBean bean = new CarKeyBean();
				bean.setCar_mng_id		(rs.getString(1));
				bean.setSeq				(rs.getInt(2));
				bean.setKey_kd			(rs.getString(3));
				bean.setOut_dt			(rs.getString(4));
				bean.setOut_id			(rs.getString(5));
				bean.setOut_st			(rs.getString(6));
				bean.setCau				(rs.getString(7));
				bean.setIn_dt			(rs.getString(8));
				bean.setKey_kd_nm		(rs.getString(9));
				bean.setOut_id_nm		(rs.getString(10));
				vt.add(bean);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CarMngDatabase:getCarKeyOIs]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	//자동차등록증 입/출고 한건 조회
	public CarDocBean getCarDoc(String car_mng_id, String seq)
	{
		getConnection();

		CarDocBean bean = new CarDocBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.*, b.nm as out_st_nm, c.user_nm as out_id_nm"+
				" FROM car_doc_mng a, code b, users c"+
				" WHERE a.car_mng_id=? and a.seq=? and a.out_st=b.nm_cd and b.c_st='0011' and a.out_id=c.user_id"+
				" order by a.out_dt";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, seq);

		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setCar_mng_id		(rs.getString(1));
				bean.setSeq				(rs.getInt(2));
				bean.setOut_dt			(rs.getString(3));
				bean.setOut_id			(rs.getString(4));
				bean.setOut_st			(rs.getString(5));
				bean.setCau				(rs.getString(6));
				bean.setIn_dt			(rs.getString(7));
				bean.setOut_st_nm		(rs.getString(8));
				bean.setOut_id_nm		(rs.getString(9));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CarMngDatabase:getCarDoc]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}

	//자동차키 입/출고 한건 조회
	public CarKeyBean getCarKey(String car_mng_id, String seq)
	{
		getConnection();

		CarKeyBean bean = new CarKeyBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.*, b.nm as key_kd_nm, c.user_nm as out_id_nm"+
				" FROM car_key_mng a, code b, users c"+
				" WHERE a.car_mng_id='"+car_mng_id+"' and a.seq="+seq+" and a.key_kd=b.nm_cd and b.c_st='0012' and a.out_id=c.user_id"+
				" order by a.out_dt";

		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setCar_mng_id		(rs.getString(1));
				bean.setSeq				(rs.getInt(2));
				bean.setKey_kd			(rs.getString(3));
				bean.setOut_dt			(rs.getString(4));
				bean.setOut_id			(rs.getString(5));
				bean.setOut_st			(rs.getString(6));
				bean.setCau				(rs.getString(7));
				bean.setIn_dt			(rs.getString(8));
				bean.setKey_kd_nm		(rs.getString(9));
				bean.setOut_id_nm		(rs.getString(10));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CarMngDatabase:getCarKey]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}

	//자동차키 보유 조회
	public CarKeyBean getCarKey(String car_mng_id)
	{
		getConnection();

		CarKeyBean bean = new CarKeyBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM car_key WHERE car_mng_id='"+car_mng_id+"'";

		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setCar_mng_id	(rs.getString(1));
				bean.setKey_yn		(rs.getString(2));
				bean.setKey_kd1		(rs.getInt(3));
				bean.setKey_kd2		(rs.getInt(4));
				bean.setKey_kd3		(rs.getInt(5));
				bean.setKey_kd4		(rs.getInt(6));
				bean.setKey_kd5		(rs.getInt(7));
				bean.setReg_id		(rs.getString(8));
				bean.setReg_dt		(rs.getString(9));
				bean.setUpd_id		(rs.getString(10));
				bean.setUpd_dt		(rs.getString(11));
				bean.setKey_kd5_nm	(rs.getString(12));

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CarMngDatabase:getCarKey(String car_mng_id)]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}

	//자동차키 입/출고관리 리스트 조회
	public Vector getCarKeyMngLists(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String key_yn)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String where = "";
		query = " select"+ 
				"        a.car_mng_id, a.car_doc_no, b.rent_mng_id, b.rent_l_cd,"+ 
				//"        decode(a.car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext, "+ 
				"        h.nm car_ext, "+ 
				"        decode(a.car_use,'1','영업용','2','자가용') car_use,"+ 
				"        a.car_no, a.car_nm,"+ 
				"        c.seq, c.out_dt, c.out_id, c.out_st, c.cau, c.in_dt, e.user_nm as out_nm,"+ 
				"        decode(c.out_st,'1','근저당설정','2','근저당해지','3','검사','4','구변검사','5','정밀검사','6','기타') out_st_nm,"+ 
				"        decode(c.key_kd,'1','일반보조키','2','카피보조키','3','리모콘','4','스마트키','5','기타') key_kd_nm,"+ 
				"        nvl((f.key_kd1+f.key_kd2+f.key_kd3+f.key_kd4+f.key_kd5),0) key_cnt, nvl(g.key_u_cnt,0) key_u_cnt, nvl((f.key_kd1+f.key_kd2+f.key_kd3+f.key_kd4+f.key_kd5-g.key_u_cnt),0) key_j_cnt"+
				" from   car_reg a, cont b, car_key_mng c, users e, car_key f,"+
				"        (select car_mng_id, max(out_dt) out_dt from car_key_mng group by car_mng_id) d, "+ 
				"        (select car_mng_id, count(*) key_u_cnt from car_key_mng where in_dt is null group by car_mng_id) g,"+
				"        (select * from code where c_st='0032') h"+
				" where  nvl(a.prepare,'0')<>'4' and nvl(b.use_yn,'Y')='Y' "+
				" and    a.car_mng_id=b.car_mng_id"+ 
				" and    a.car_mng_id=c.car_mng_id(+)"+ 
				" and    c.out_id=e.user_id(+)"+
				" and    c.car_mng_id=f.car_mng_id(+)"+
				" and    c.car_mng_id=d.car_mng_id(+) and c.out_dt=d.out_dt(+)"+
				" and    c.car_mng_id=g.car_mng_id(+)"+
				" and    a.car_ext = h.nm_cd";

//		if(!key_yn.equals(""))			query += " and f.key_yn='"+key_yn+"'";

		if(t_wd.equals("")){
			if(!gubun1.equals("0"))		query += " and a.car_ext = '"+gubun1+"'";
			if(!gubun2.equals("0"))		query += " and a.car_use = '"+gubun2+"'";

			if(gubun3.equals("1"))		query += " and c.out_dt is not null and c.in_dt is not null";
			if(gubun3.equals("2"))		query += " and c.out_dt is not null and c.in_dt is null";

		}else{
			if(s_kd.equals("1"))		where = "a.car_doc_no";
			if(s_kd.equals("2"))		where = "a.car_no||' '||a.first_car_no";
			if(s_kd.equals("3"))		where = "a.car_nm";

			if(!t_wd.equals(""))		query += " and "+where+" like '%"+t_wd+"%'";
		}

		query += " ORDER BY a.init_reg_dt, a.car_doc_no ";

		try {
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CarMngDatabase:getCarKeyMngLists]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	//자동차키 보유현황 : 차량별
	public Hashtable getCarKeyCnt(String car_mng_id)
	{
		getConnection();
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String where = "";
		query = " select"+
				//총수
				" a.*,"+
				//반출수
				" nvl(b.key_u_kd1,0) key_u_kd1,"+
				" nvl(b.key_u_kd2,0) key_u_kd2,"+
				" nvl(b.key_u_kd3,0) key_u_kd3,"+
				" nvl(b.key_u_kd4,0) key_u_kd4,"+
				" nvl(b.key_u_kd5,0) key_u_kd5,"+
				//보유수
				" a.key_kd1-nvl(b.key_u_kd1,0) key_j_kd1,"+
				" a.key_kd2-nvl(b.key_u_kd2,0) key_j_kd2,"+
				" a.key_kd3-nvl(b.key_u_kd3,0) key_j_kd3,"+
				" a.key_kd4-nvl(b.key_u_kd4,0) key_j_kd4,"+
				" a.key_kd5-nvl(b.key_u_kd5,0) key_j_kd5,"+
				//합계
				" nvl((a.key_kd1+a.key_kd2+a.key_kd3+a.key_kd4+a.key_kd5),0) key_kd,"+
				" nvl((b.key_u_kd1+b.key_u_kd2+b.key_u_kd3+b.key_u_kd4+b.key_u_kd5),0) key_u_kd,"+
				" nvl((a.key_kd1+a.key_kd2+a.key_kd3+a.key_kd4+a.key_kd5),0)-nvl((b.key_u_kd1+b.key_u_kd2+b.key_u_kd3+b.key_u_kd4+b.key_u_kd5),0) key_j_kd"+
				" from car_key a, "+
				" ("+
				" 	select "+
				" 	car_mng_id, "+
				" 	count(decode(key_kd,'1',key_kd)) key_u_kd1,"+
				" 	count(decode(key_kd,'2',key_kd)) key_u_kd2,"+
				" 	count(decode(key_kd,'3',key_kd)) key_u_kd3,"+
				" 	count(decode(key_kd,'4',key_kd)) key_u_kd4,"+
				" 	count(decode(key_kd,'5',key_kd)) key_u_kd5	"+		
				" 	from car_key_mng where out_dt is not null and in_dt is null"+
				" 	group by car_mng_id"+
				" ) b"+
				" where a.car_mng_id='"+car_mng_id+"'"+
				" and a.car_mng_id=b.car_mng_id(+)";

		try {
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CarMngDatabase:getCarKeyCnt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	//자동차키 보유현황 리스트
	public Vector getCarKeyCntStatLists(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String key_yn)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String where = "";
		query = " select"+ 
				" a.car_mng_id, a.car_doc_no, b.rent_mng_id, b.rent_l_cd,"+ 
				//" decode(a.car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext, "+ 
				" g.nm car_ext, "+ 
				" decode(a.car_use,'1','영업용','2','자가용') car_use,"+ 
				" a.car_no, a.car_nm,"+ 
				" f.key_yn, nvl(f.key_kd1,0) key_kd1, nvl(f.key_kd2,0) key_kd2, nvl(f.key_kd3,0) key_kd3, nvl(f.key_kd4,0) key_kd4, nvl(f.key_kd5,0) key_kd5,"+
				" nvl((f.key_kd1+f.key_kd2+f.key_kd3+f.key_kd4+f.key_kd5),0) key_kd"+
				" from car_reg a, cont b, car_key f, (select * from code where c_st='0032') g"+
				" where nvl(a.prepare,'0')<>'4' and nvl(b.use_yn,'Y')='Y'"+ 
				" and a.car_mng_id=b.car_mng_id"+ 
				" and a.car_mng_id=f.car_mng_id(+)"+
				" and a.car_ext= g.nm_cd";

		if(t_wd.equals("")){
			if(!gubun1.equals("0"))		query += " and a.car_ext = '"+gubun1+"'";
			if(!gubun2.equals("0"))		query += " and a.car_use = '"+gubun2+"'";
			if(!gubun3.equals("0"))		query += " and f.key_yn='"+gubun3+"'";

		}else{
			if(s_kd.equals("1"))		where = "a.car_doc_no";
			if(s_kd.equals("2"))		where = "a.car_no||' '||a.first_car_no";
			if(s_kd.equals("3"))		where = "a.car_nm";

			if(!t_wd.equals(""))		query += " and "+where+" like '%"+t_wd+"%'";
		}

		query += " ORDER BY a.init_reg_dt, a.car_doc_no ";

		try {
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CarMngDatabase:getCarKeyCntStatLists]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	//insert-----------------------------------------------------------------------------------------------------------------------------------------

	//자동차등록증 입/출고관리 등록
	public boolean insertCarDoc(CarDocBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO car_doc_mng VALUES"+
					" ( ?, ?, replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''))";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCar_mng_id	());
			pstmt.setInt	(2,		bean.getSeq			());
			pstmt.setString	(3,		bean.getOut_dt		());
			pstmt.setString	(4,		bean.getOut_id		());
			pstmt.setString	(5,		bean.getOut_st		());
			pstmt.setString	(6,		bean.getCau			());
			pstmt.setString	(7,		bean.getIn_dt		());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CarMngDatabase:insertCarDoc]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
                if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//자동차키 입/출고관리 등록
	public boolean insertCarKeyOI(CarKeyBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO car_key_mng VALUES"+
					" ( ?, ?, ?, replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''))";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCar_mng_id	());
			pstmt.setInt	(2,		bean.getSeq			());
			pstmt.setString	(3,		bean.getKey_kd		());
			pstmt.setString	(4,		bean.getOut_dt		());
			pstmt.setString	(5,		bean.getOut_id		());
			pstmt.setString	(6,		bean.getOut_st		());
			pstmt.setString	(7,		bean.getCau			());
			pstmt.setString	(8,		bean.getIn_dt		());

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CarMngDatabase:insertCarKeyOI]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//자동차키 등록
	public boolean insertCarKey(CarKeyBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO car_key VALUES"+
					" ( ?, ?, ?, ?, ?,   ?, ?, ?, to_char(sysdate,'YYYYMMDD'), '','', ?)";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCar_mng_id	());
			pstmt.setString	(2,		bean.getKey_yn		());
			pstmt.setInt	(3,		bean.getKey_kd1		());
			pstmt.setInt	(4,		bean.getKey_kd2		());
			pstmt.setInt	(5,		bean.getKey_kd3		());
			pstmt.setInt	(6,		bean.getKey_kd4		());
			pstmt.setInt	(7,		bean.getKey_kd5		());
			pstmt.setString	(8,		bean.getReg_id		());
			pstmt.setString	(9,		bean.getKey_kd5_nm	());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[CarMngDatabase:insertCarKey]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//자동차키 등록
	public boolean insertCarKey(String car_mng_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO car_key VALUES"+
					" ( ?, ?, 0, 0, 0,   0, 0, '000029', to_char(sysdate,'YYYYMMDD'), '','')";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		car_mng_id);
			pstmt.setString	(2,		"N");

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CarMngDatabase:insertCarKey]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	//update-----------------------------------------------------------------------------------------------------------------------------------------


	//자동차등록증 입/출고관리 수정
	public boolean updateCarDoc(CarDocBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE car_doc_mng SET"+
					" out_dt		= replace(?, '-', ''),"+
					" out_id		= ?,"+  
					" out_st		= ?,"+
					" cau			= ?,"+  
					" in_dt			= replace(?, '-', '')"+ 
				" WHERE car_mng_id = ? and seq = ?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getOut_dt		());
			pstmt.setString	(2,		bean.getOut_id		());
			pstmt.setString	(3,		bean.getOut_st		());
			pstmt.setString	(4,		bean.getCau			());
			pstmt.setString	(5,		bean.getIn_dt		());
			pstmt.setString	(6,		bean.getCar_mng_id	());
			pstmt.setInt	(7,		bean.getSeq			());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CarMngDatabase:updateCarDoc]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//자동차키 입/출고관리 수정
	public boolean updateCarKeyOI(CarKeyBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE car_key_mng SET"+
					" key_kd		= ?,"+  
					" out_dt		= replace(?, '-', ''),"+
					" out_id		= ?,"+  
					" out_st		= ?,"+
					" cau			= ?,"+  
					" in_dt			= replace(?, '-', '')"+ 
				" WHERE car_mng_id = ? and seq = ?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getKey_kd		());
			pstmt.setString	(2,		bean.getOut_dt		());
			pstmt.setString	(3,		bean.getOut_id		());
			pstmt.setString	(4,		bean.getOut_st		());
			pstmt.setString	(5,		bean.getCau			());
			pstmt.setString	(6,		bean.getIn_dt		());
			pstmt.setString	(7,		bean.getCar_mng_id	());
			pstmt.setInt	(8,		bean.getSeq			());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CarMngDatabase:updateCarKeyOI]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//자동차키 수정
	public boolean updateCarKey(CarKeyBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE car_key SET"+
					" key_yn		= ?,"+  
					" key_kd1		= ?,"+
					" key_kd2		= ?,"+  
					" key_kd3		= ?,"+
					" key_kd4		= ?,"+  
					" key_kd5		= ?,"+ 
					" key_kd5_nm	= ?,"+ 
					" upd_id		= ?,"+ 
					" upd_dt		= to_char(sysdate,'YYYYMMDD')"+ 
				" WHERE car_mng_id = ?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getKey_yn		());
			pstmt.setInt	(2,		bean.getKey_kd1		());
			pstmt.setInt	(3,		bean.getKey_kd2		());
			pstmt.setInt	(4,		bean.getKey_kd3		());
			pstmt.setInt	(5,		bean.getKey_kd4		());
			pstmt.setInt	(6,		bean.getKey_kd5		());
			pstmt.setString	(7,		bean.getKey_kd5_nm	());
			pstmt.setString	(8,		bean.getUpd_id		());
			pstmt.setString	(9,		bean.getCar_mng_id	());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[CarMngDatabase:updateCarKey]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

}