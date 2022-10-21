package acar.master_car;

import java.sql.*;
import java.util.*;
import acar.database.*;

public class Master_CarDatabase
{
	private Connection conn = null;
	public static Master_CarDatabase db;
	
	public static Master_CarDatabase getInstance()
	{
		if(Master_CarDatabase.db == null)
			Master_CarDatabase.db = new Master_CarDatabase();
		return Master_CarDatabase.db;
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
	    	System.out.println(" i can't get a connection........");
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
	


//마스타자동차이용내역 리스트 조회 : master_car_sc_in.jsp
	public Vector Master_CarList(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String gjyj_dt = "a.gjyj_dt";
		String js_dt = "a.js_dt";

		query = " select  e.user_nm, "+
				"        b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.use_yn, b.firm_nm, c.car_no, c.car_nm, cn.car_name, c.init_reg_dt,"+
				"        a.*, substr(a.gjyj_dt,1,4)||'-'||substr(a.gjyj_dt,5,2)||'-'||substr(a.gjyj_dt,7,2) as LGJYJ_DT, substr(a.gj_dt,1,4)||'-'||substr(a.gj_dt,5,2)||'-'||substr(a.gj_dt,7,2) as LGJ_DT, substr(a.js_dt,1,4)||'-'||substr(a.js_dt,5,2)||'-'||substr(a.js_dt,7,2) as LJS_DT "+
				" from   master_car a, cont_n_view b, users e,  car_reg c,  car_etc g, car_nm cn, code d \n"+
				" where  a.car_mng_id=b.car_mng_id and a.rent_l_cd=b.rent_l_cd and a.bus_id = e.user_id  and a.sbshm != '1'"+ //
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
				"	and c.car_ext = d.nm_cd  and d.c_st ='0032' \n"+
           		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
			
/*조회구분*/
		if(gubun1.equals("0")){	query += " ";
		}else if(gubun1.equals("1")){	query += "	and a.sbshm in ('타이어교체')";
		}else if(gubun1.equals("2")){	query += "	and a.sbshm in ('배터리충전')";
		}else if(gubun1.equals("3")){	query += "	and a.sbshm in ('잠금장치해제')";
		}else if(gubun1.equals("4")){	query += "	and a.sbshm in ( '%비상급유%')";
		}else if(gubun1.equals("5")){	query += "	and a.sbshm in ('견인')";
		}else if(gubun1.equals("6")){	query += "	and a.sbshm not not in ('견인', '배터리충전', '타이어교체', '잠금장치해제', '%비상급유%')";
		}

/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("5") && gubun3.equals("1")){		query += " and "+gjyj_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//당월-지출
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and "+gjyj_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.gj_dt is not null";
		//당월-미지출
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and "+gjyj_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.gj_dt is null";
		//전월-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " AND "+js_dt+" like substr(to_char( add_months( sysdate, - 1 ), 'YYYYMMDD' ), 1,6)||'%' ";
		//전월-지출
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " AND "+js_dt+" like substr(to_char( add_months( sysdate, - 1 ), 'YYYYMMDD' ), 1,6)||'%' and a.gj_dt like substr(to_char(add_months(sysdate, -1), 'YYYYMMDD'), 1,6)||'%'";
		//전월-미지출
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " AND "+js_dt+" like substr(to_char( add_months( sysdate, - 1 ), 'YYYYMMDD' ), 1,6)||'%' and a.gj_dt is null";
		//전월+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " AND "+js_dt+" like substr(to_char( add_months( sysdate, - 1 ), 'YYYYMMDD' ), 1,6)||'%'";
		//전월+연체-지출
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " AND "+js_dt+" like substr(to_char( add_months( sysdate, - 1 ), 'YYYYMMDD' ), 1,6)||'%' a.gj_dt like substr(to_char(add_months(sysdate, -1), 'YYYYMMDD'), 1,6)||'%'";
		//전월+연체-미지출
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " AND "+js_dt+" like substr(to_char( add_months( sysdate, - 1 ), 'YYYYMMDD' ), 1,6)||'%' and a.gj_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and "+gjyj_dt+" < to_char(sysdate,'YYYYMMDD')";
		//연체-지출
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and "+gjyj_dt+" < to_char(sysdate,'YYYYMMDD') and a.gj_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미지출
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and "+gjyj_dt+" < to_char(sysdate,'YYYYMMDD') and a.gj_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+gjyj_dt+" BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')";
		//기간-지출
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.gj_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','') and a.gj_dt is not null";
		//기간-미지출
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+gjyj_dt+" BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','') and a.gj_dt is null";
		//검색-지출
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and a.gj_dt is not null";
		//검색-미지출
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and a.gj_dt is null";
		}else if(gubun2.equals("1") && gubun3.equals("1")){	query += " and a.gj_dt is null";
		}

/*업체구분*/
		if(gubun4.equals("0")){	query += "  ";
		}else if(gubun4.equals("1")){	query += " and a.gubun = '1' ";
		}else if(gubun4.equals("5")){	query += " and a.gubun = '5' ";
		}else if(gubun4.equals("7")){	query += " and a.gubun = '7' ";
		}
		

		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(a.ggm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and nvl(a.sbgb_amt, 0) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(c.car_ext, '')||d.nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("99"))	query += " and b.car_mng_id = '"+t_wd+"'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by a.gubun, a.js_dt";
		else if(sort_gubun.equals("1"))	query += " order by a.gubun, b.use_yn desc, b.firm_nm "+sort+", a.gjyj_dt";
		else if(sort_gubun.equals("2"))	query += " order by a.gubun, b.use_yn desc, a.gjyj_dt "+sort+", b.firm_nm";
		else if(sort_gubun.equals("5"))	query += " order by a.gubun, b.use_yn desc, c.car_no "+sort+", b.firm_nm";		
			
		
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
			System.out.println("[Master_CarDatabase:Master_CarList]"+ e);
			System.out.println("[Master_CarDatabase:Master_CarList]"+ query);
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


	/**
	 *	일반지출 INSERT
	 */

	public boolean insertMaster_car(Master_CarBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "insert into master_car "
					  +"(CAR_MNG_ID, JS_SEQ, JS_DT, JS_TM, "
					  +" RENT_MNG_ID, RENT_L_CD, RENT_S_CD, BUS_ID, SBSHM, "
					  +" GMJM, GGM, CAR_NO, SIGG, M_TEL, "
					  +" SBGB_AMT, SSSSNY, JCSSNY, JSBB, GJYJ_DT, GJ_DT, "
					  +" REMARKS, TOT_DIST, GUBUN ) values "
					  +" ( "
					  +" ?, ?, replace(?, '-', ''), ?, "
					  +" ?, ?, ?, ?, ?,  "
					  +" ?, ?, ?, ?, ?,  "
					  +" ?, ?, ?, ?, ?, ?, "
					  +" ?, ?, ? )";
						

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getCar_mng_id());
			pstmt.setLong   (2,  bean.getJs_seq());

			pstmt.setString(3,  bean.getJs_dt());
			pstmt.setString(4,  bean.getJs_tm());

			pstmt.setString(5,  bean.getRent_mng_id());
			pstmt.setString(6,  bean.getRent_l_cd());
			pstmt.setString(7,  bean.getRent_s_cd());
			pstmt.setString(8,  bean.getBus_id());
			pstmt.setString(9,  bean.getSbshm());
			pstmt.setString(10,  bean.getGmjm());
			pstmt.setString(11,  bean.getGgm());
			pstmt.setString(12,  bean.getCar_no());
			pstmt.setString(13,  bean.getSigg());
			pstmt.setString(14,  bean.getM_tel());
			pstmt.setInt   (15,	 bean.getSbgb_amt());
			pstmt.setString(16,  bean.getSsssny());
			pstmt.setString(17,  bean.getJcssny());
			pstmt.setString(18,  bean.getJsbb());
			pstmt.setString(19,  bean.getGjyj_dt());
			pstmt.setString(20,  bean.getGj_dt());
			pstmt.setString(21,  bean.getRemarks());
			pstmt.setInt(22,  bean.getTot_dist());
			pstmt.setString(23,  bean.getGubun());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[Master_CarDatabase:insertMaster_car]"+e);
			System.out.println("[Master_CarDatabase:insertMaster_car]"+query);
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


	//차량번호로 차량관리번호 가져가기
	public Hashtable getCarMngID(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = " SELECT a.car_mng_id, b.rent_mng_id, b.rent_l_cd, b.mng_id from car_reg a, cont b where (a.car_no='"+car_no.trim()+"' or a.first_car_no='"+car_no.trim()+"' ) and nvl(b.use_yn,'Y')='Y' and a.car_mng_id=b.car_mng_id";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:getCarMngID]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	public Hashtable getReCarMngID(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "  SELECT a.car_mng_id, b.rent_mng_id, b.rent_l_cd, b.mng_id , b.rent_dt "+
					   " from car_reg a, cont b , ( select car_mng_id, max(rent_dt) rent_dt from cont group by car_mng_id) d "+
					   " where (a.car_no='"+car_no.trim()+"' or a.first_car_no='"+car_no.trim()+"' ) "+
					   " and a.car_mng_id=b.car_mng_id  and b.car_mng_id = d.car_mng_id  and b.rent_dt = d.rent_dt ";
		  

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:getReCarMngID]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	

//차량번호로 차량관리번호 가져가기
	public Hashtable getMaster_Car(String car_no, String gjyj_dt, String js_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		//--장기대여인 경우 - 연장없이 스케쥴만 연장한 경우 아래의 쿼리는 해당 데이타가 안나옴(수정)

query = " select a.*, b.rent_mng_id, b.rent_l_cd, '' rent_s_cd, b.car_st, b.bus_id2 as user_id, e.user_nm, d.st_dt, d.end_dt, c.cls_dt "+
		" from   (SELECT a.car_mng_id FROM car_reg a, (SELECT car_mng_id, MAX(cha_dt) cha_dt FROM car_change WHERE car_no ='"+car_no+"' GROUP BY car_mng_id ) b "+
        " WHERE a.CAR_MNG_ID = b.car_mng_id AND a.car_no = '"+car_no+"' ) a,"+
	    "   cont b, cls_cont c, users e,"+
		"(select rent_mng_id, rent_l_cd, min(rent_start_dt) st_dt, max(rent_end_dt) end_dt from fee group by rent_mng_id, rent_l_cd) d, "+
		" (SELECT rent_mng_id, rent_l_cd, min(rent_start_dt) st_dt, max(rent_end_dt) end_dt FROM fee_im GROUP BY rent_mng_id, rent_l_cd) im"+
		" where  a.car_mng_id=b.car_mng_id and b.car_st<>'2' "+
	    " and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+)"+
		" and b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+) AND b.rent_mng_id = im.rent_mng_id(+) AND b.rent_l_cd=im.rent_l_cd(+) and b.bus_id2=e.user_id "+
		" and ( '"+js_dt+"' between d.st_dt and nvl(c.cls_dt,d.end_dt) or '"+js_dt+"' between im.st_dt and nvl(c.cls_dt,im.end_dt) )"+
		" union all "+
//--단기대여인 경우
		" select a.*, b.rent_mng_id, b.rent_l_cd, c.rent_s_cd, b.car_st, decode(c.rent_st,'4',c.cust_id,c.bus_id) as user_id, e.user_nm, nvl(c.deli_dt,c.deli_plan_dt) st_dt, nvl(c.ret_dt,c.ret_plan_dt) end_dt, '' cls_dt "+
		" from   (SELECT a.car_mng_id FROM car_reg a, (SELECT car_mng_id, MAX(cha_dt) cha_dt FROM car_change WHERE car_no ='"+car_no+"' GROUP BY car_mng_id ) b "+
        " WHERE a.CAR_MNG_ID = b.car_mng_id AND a.car_no = '"+car_no+"' ) a,"+
		" cont b, rent_cont c, users e "+
		" where  a.car_mng_id=b.car_mng_id  AND a.CAR_MNG_ID = c.car_mng_id /* AND NVL(b.use_yn, 'N')='Y' */ and b.car_st='2' and c.use_st<>'5'"+
	    " and decode(c.rent_st,'4',c.cust_id,c.bus_id)=e.user_id "+
		" and '"+js_dt+"' between nvl(c.deli_dt,c.deli_plan_dt) and nvl(c.ret_dt,nvl(c.ret_plan_dt,decode(c.use_st,'2','99999999'))) ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:getMaster_Car]"+e);
			System.out.println("[Master_CarDatabase:getMaster_Car]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

//차량번호로 차량관리번호 가져가기 - 검사는 단기인 경우 보유차 관리담당자 
	public Hashtable getMaster_CarMaint(String car_no, String gjyj_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		//--장기대여인 경우 - 연장없이 스케쥴만 연장한 경우 아래의 쿼리는 해당 데이타가 안나옴(수정)

query = " select a.*, b.rent_mng_id, b.rent_l_cd, '' rent_s_cd, b.car_st, b.mng_id as user_id, e.user_nm, d.st_dt, d.end_dt, c.cls_dt  \n"+
		" from   (select distinct b.car_mng_id, b.car_no from car_reg a, car_change b where a.car_mng_id=b.car_mng_id and b.car_no ='"+car_no+"') a,"+
	    "   cont b, cls_cont c, users e,"+	    
	//	"(select rent_mng_id, rent_l_cd, min(rent_start_dt) st_dt, max(rent_end_dt) end_dt from fee group by rent_mng_id, rent_l_cd) d"+
		"( select f.rent_mng_id, f.rent_l_cd, min(f.rent_start_dt) st_dt, case when max(sf.use_e_dt) > max(f.rent_end_dt) then max(sf.use_e_dt) else max(f.rent_end_dt)  end end_dt from fee f, scd_fee sf \n"+
   		" where f.rent_mng_id = sf.rent_mng_id and f.rent_l_cd = sf.rent_l_cd  and  nvl(sf.bill_yn, 'Y') = 'Y'  group by f.rent_mng_id, f.rent_l_cd ) d  \n"+
		" where a.car_mng_id=b.car_mng_id and b.car_st <> '2' /*AND NVL(b.use_yn, 'N')='Y'*/  \n"+
	    "   and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+)  \n"+
		"   and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and b.bus_id2=e.user_id  \n"+
//		"   and '"+gjyj_dt+"' between d.st_dt and nvl(c.cls_dt,d.end_dt) \n"+		
		" union all \n"+
//--단기대여인 경우
		" select a.*, b.rent_mng_id, b.rent_l_cd, c.rent_s_cd, b.car_st, decode(c.rent_st,'4',c.cust_id,b.mng_id) as user_id, e.user_nm, nvl(c.deli_dt,c.deli_plan_dt) st_dt, nvl(c.ret_dt,c.ret_plan_dt) end_dt, '' cls_dt "+
		" from   (select distinct b.car_mng_id, b.car_no from car_reg a, car_change b where a.car_mng_id=b.car_mng_id and b.car_no ='"+car_no+"') a,"+
		" cont b, rent_cont c, users e "+
		" where  a.car_mng_id=b.car_mng_id and  a.car_mng_id = c.car_mng_id(+) and b.car_st='2' and c.use_st <>'5'"+
	    " and decode(c.rent_st,'4',c.cust_id,b.bus_id2)= e.user_id "+
		" and '"+gjyj_dt+"' between nvl(c.deli_dt,c.deli_plan_dt) and nvl(c.ret_dt,nvl(c.ret_plan_dt,decode(c.use_st,'2','99999999'))) ";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:getMaster_CarMaint]"+e);
			System.out.println("[Master_CarDatabase:getMaster_CarMaint]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}


	//차량번호로 차량관리번호 가져가기
	public Hashtable speed_Serach(String car_no, String js_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		query = " select a.*, b.rent_mng_id, b.rent_l_cd, '' rent_s_cd, b.car_st, b.mng_id as mng_id, e.user_nm, d.st_dt, d.end_dt, c.cls_dt    \n"+
				" from   (SELECT b.CAR_MNG_ID, b.car_no, B.CAR_NM, b.init_reg_dt, c.car_no AS car_no2, c.min_cha_seq, c.min_cha_dt, c.min_cha_dt AS s_cha_dt,    \n"+
				" TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') end_cha_dt FROM CAR_REG b, (SELECT car_mng_id,    \n"+
                " car_no, MIN(cha_seq) min_cha_seq, MAX(cha_seq) max_cha_seq, MIN(cha_dt) min_cha_dt, COUNT(*) cnt FROM CAR_CHANGE GROUP BY car_mng_id, \n"+
                " car_no ) c, CAR_CHANGE d WHERE b.car_mng_id=c.car_mng_id AND c.car_mng_id=d.car_mng_id(+) AND c.max_cha_seq+1=d.cha_seq(+) AND c.car_no ='"+car_no+"' \n"+//차량번호 
				" AND '"+js_dt+"' BETWEEN c.min_cha_dt AND TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD')  \n"+ //위반일자 
				" ORDER BY b.car_mng_id, c.min_cha_seq ) a, "+
				"   cont b, cls_cont c, users e,    "+	    
				"( select f.rent_mng_id, f.rent_l_cd, min(f.rent_start_dt) st_dt, case when max(sf.use_e_dt) > max(f.rent_end_dt) then max(sf.use_e_dt) else max(f.rent_end_dt)  end end_dt from fee f, scd_fee sf   \n"+
				" where f.rent_mng_id = sf.rent_mng_id and f.rent_l_cd = sf.rent_l_cd  and  nvl(sf.bill_yn, 'Y') = 'Y'  group by f.rent_mng_id, f.rent_l_cd ) d    \n"+
				" where a.car_mng_id=b.car_mng_id    \n"+ //  and b.car_st <> '2' , // '4' //--and b.car_st <> '2'  
				"   and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+)    \n"+
				"   and b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+)  and b.bus_id2=e.user_id    \n"+
				"   and '"+js_dt+"'   between nvl(b.rent_start_dt, b.rent_dt)  AND nvl(nvl(c.cls_dt, nvl(d.end_dt, b.rent_end_dt) ), to_char(sysdate -1 , 'yyyymmdd') )  \n"+		
			// 	"   and '"+js_dt+"' BETWEEN NVL(d.st_dt,b.rent_start_dt)  AND NVL(nvl(c.cls_dt,d.end_dt),b.rent_end_dt)  \n"+ //between d.st_dt and nvl(c.cls_dt,d.end_dt)
		//		" union all  \n"+
				" minus  \n"+
		//--단기대여인 경우
				" select a.*, b.rent_mng_id, b.rent_l_cd, c.rent_s_cd, b.car_st, decode(c.rent_st,'4',c.cust_id,b.mng_id) as mng_id, e.user_nm, nvl(c.deli_dt,c.deli_plan_dt) st_dt, nvl(c.ret_dt,c.ret_plan_dt) end_dt, '' cls_dt   "+
				" from   (SELECT b.CAR_MNG_ID, b.car_no, B.CAR_NM, b.init_reg_dt, c.car_no AS car_no2, c.min_cha_seq, c.min_cha_dt, c.min_cha_dt AS s_cha_dt,   \n"+
				" TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') end_cha_dt FROM CAR_REG b, (SELECT car_mng_id,   \n"+
                " car_no, MIN(cha_seq) min_cha_seq, MAX(cha_seq) max_cha_seq, MIN(cha_dt) min_cha_dt, COUNT(*) cnt FROM CAR_CHANGE GROUP BY car_mng_id,   \n"+
                " car_no ) c, CAR_CHANGE d WHERE b.car_mng_id=c.car_mng_id AND c.car_mng_id=d.car_mng_id(+) AND c.max_cha_seq+1=d.cha_seq(+) AND c.car_no ='"+car_no+"' \n"+//차량번호 
				" AND '"+js_dt+"' BETWEEN c.min_cha_dt AND TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD')   \n"+ //위반일자 
				" ORDER BY b.car_mng_id, c.min_cha_seq ) a, cont b, (select * from rent_cont where use_st <> '5') c, users e where  a.car_mng_id=b.car_mng_id and b.car_st='2'  "+
				" and a.car_mng_id=c.car_mng_id "+
	//			" and decode(nvl(c.rent_st, '99' ),'4',c.cust_id, '99', b.mng_id, c.bus_id)=e.user_id "+
	//			" and '"+js_dt+"'  BETWEEN decode(nvl(c.rent_st, '99' ) , '99', b.rent_start_dt, SUBSTR(nvl(c.deli_dt,c.deli_plan_dt),0,8) ) AND decode(nvl(c.rent_st, '99' ) , '99', nvl(b.rent_end_dt,  "+
	//			" to_char(sysdate -1 , 'yyyymmdd') ) , SUBSTR(nvl(c.ret_dt,nvl(c.ret_plan_dt,decode(c.use_st,'2','99999999'))),0,8) )  ";
				" and decode(c.rent_st,'4',c.cust_id,c.bus_id)=e.user_id \n "+
				" and '"+js_dt+"' BETWEEN SUBSTR(nvl(c.deli_dt,c.deli_plan_dt),0,8) AND SUBSTR(nvl(c.ret_dt,nvl(c.ret_plan_dt,decode(c.use_st,'2','99999999'))),0,8) ";
			


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Customer_Database:speed_Serach]"+e);
			System.out.println("[Customer_Database:speed_Serach]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

//마스타자동차 이력 리스트
	public Vector M_CarList(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select * "+
				" from master_car"+
				" where "+
				" car_mng_id='"+car_mng_id+"' order by js_dt";



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
			
			System.out.println("[Master_CarDatabase:M_CarList]"+ e);
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


	/** 
	 *	마스타자동차 제출자료
	 */
	public Vector getMasterCarComAcarExcelList()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select \n"+
				" b.car_no 차량번호, b.car_nm||' '||d.car_name 차종, replace(e.nm,'자동차','') 제조사, substr(b.init_reg_dt,1,4) as 연식, \n"+
				" decode(d.auto_yn,'Y','오토',decode(sign(instr(c.opt,'자동변속기')),1,'오토','수동')) 미션, \n"+
				" f.nm as 연료, \n"+
				" o.firm_nm 고객, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) 사무실, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) 휴대폰, \n"+
				" o.o_addr 주소, \n"+
				" o.CON_AGNT_EMAIL 이메일, \n"+
				" j.ins_com_nm 보험사, h.ins_start_dt||'~'||h.ins_exp_dt 대여기간, \n"+
				" '자배법 시행령에서 정한 금액' 대인배상Ⅰ, \n"+
				" decode(h.vins_pcp_kd,'1','무한','2','유한') 대인배상Ⅱ, \n"+
				" decode(h.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','미가입') 대물배상, \n"+
				" decode(h.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애, \n"+
				" decode(h.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상, \n"+
				" decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'만원') 자차차량, \n"+
				" decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'만원') 자차자기부담금, \n"+
				" decode(h.vins_canoisr_amt,0,'','가입') 무보험, \n"+
				" decode(h.car_use,'1','영업용','2','업무용') 보험종류, \n"+
				" decode(h.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상') 연령범위, \n"+
				" decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) 에어백, \n"+
				" h.con_f_nm 피보험자 \n"+
				" from cont a, car_reg b, car_etc c, car_nm d, client o, \n"+
				"      (select * from code where c_st='0001') e, \n"+
				"      (select * from code where c_st='0039') f, \n"+				
				"      (select a.* from insur a, (select car_mng_id, max(ins_exp_dt) ins_exp_dt from insur group by car_mng_id) b \n"+
				"         where a.car_mng_id=b.car_mng_id and a.ins_exp_dt=b.ins_exp_dt \n"+
				"      ) h, \n"+
				"      ins_com j \n"+
				" where \n"+
				" nvl(a.use_yn,'Y')='Y' \n"+
				" and nvl(b.prepare,'0') not in ('4','5') \n"+
				" and a.car_mng_id=b.car_mng_id \n"+
				" and a.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and d.car_comp_id=e.code \n"+
				" and a.client_id=o.client_id \n"+
				" and a.car_mng_id=h.car_mng_id(+) \n"+
				" and h.ins_com_id=j.ins_com_id(+) \n"+
				" and b.fuel_kd=f.nm_cd \n"+				
				" ";

		query += " order by d.jg_code";


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);

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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:getMasterCarComAcarExcelList]\n"+e);
			System.out.println("[Master_CarDatabase:getMasterCarComAcarExcelList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	일괄지출처리 
	 */
	public boolean updateAllMaster_CarPay(String gjyj_dt, String gj_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update master_car set "+
						"		gj_dt = replace(?, '-', '')"+
						" where gjyj_dt=replace(?, '-', '') and gj_dt is null";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  gj_dt);
			pstmt.setString(2,  gjyj_dt);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[Master_CarDatabase:updateAllMaster_CarPay]"+e);
			System.out.println("[Master_CarDatabase:updateAllMaster_CarPay]"+query);
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


	/** 
	 *	협력업체 - 아마존카 차량조회 
	 */
		public Vector amazoncar_list(String br_id, String st, String ref_dt1, String ref_dt2, String gubun, String gubun_nm, String gubun3, String q_sort_nm, String q_sort )
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        String subQuery = "";
        String gubunQuery = "";
        String sortQuery = "";
		

        if(st.equals("2")){	subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is not null and nvl(b.prepare,'1')<>'4'\n";	}
        else{        				subQuery = "and nvl(a.use_yn,'Y')='Y'";																}

        if(gubun.equals("car_no")){				gubunQuery = "and nvl(b.car_no,' ') like '%" + gubun_nm + "%'\n";															}
        else if(gubun.equals("car_nm")){				gubunQuery = "and j.car_nm||h.car_name like '%" + gubun_nm + "%'\n";														}
        else if(gubun.equals("dlv_dt")){				gubunQuery = "and a.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";				}
        else if(gubun.equals("init_reg_dt")){			gubunQuery = "and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";			}
        else if(gubun.equals("car_end_dt")){			gubunQuery = "and b.car_end_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n";			}
    	else if(gubun.equals("brch_id")){				gubunQuery = "and nvl(a.brch_id,' ') like '%" + gubun_nm +"%'\n";															}
    	else if(gubun.equals("car_ext")){				gubunQuery = "and m.nm like '%" + gubun_nm +"%'\n";	}
        else if(gubun.equals("rent_l_cd")){				gubunQuery = "and nvl(a.rent_l_cd,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("car_num")){				gubunQuery = "and nvl(b.car_num,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("emp_nm")){				gubunQuery = "and nvl(l.emp_nm,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("rpt_no")){				gubunQuery = "and nvl(f.rpt_no,' ') like '%" + gubun_nm +"%'\n";															}
        else if(gubun.equals("fuel_kd")){				gubunQuery = "and k.nm like '%" + gubun_nm +"%'\n";															}
        else{											gubunQuery = "and b.car_mng_id=' '\n";																						}
        
        /* 정렬 */
        	if(q_sort_nm.equals("car_no")){		sortQuery = "order by b.car_no " + q_sort + "\n";								}	
        	else if(q_sort_nm.equals("init_reg_dt")){	sortQuery = "order by b.init_reg_dt " + q_sort + "\n";							}
        	else if(q_sort_nm.equals("car_end_dt")){	sortQuery = "order by decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD')))) " + q_sort + "\n";							}
        	else if(q_sort_nm.equals("car_nm")){		sortQuery = "order by j.car_nm||h.car_name " + q_sort + "\n";					}
        	else if(q_sort_nm.equals("car_ext")){		sortQuery = "order by b.car_ext " + q_sort + "\n";								}	
        	else{										sortQuery = "order by b.init_reg_dt " + q_sort + "\n";				}        	

      query = "select u.max_scan, u.cha_seq, decode(a.car_st,'1','렌트','3','리스',decode(b.car_use,'1','렌트','2','리스','예비')) car_st, a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.reg_id as REG_ID,e.br_id as BR_ID,\n" 
			+ "b.car_mng_id as CAR_MNG_ID, nvl2(b.init_reg_dt,substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2),'') as INIT_REG_DT, nvl2(b.init_reg_dt,'ud','id') as REG_GUBUN, nvl2(b.car_no,b.car_no,nvl2(a.dlv_dt,'미등록','미출고')) as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "decode(f.dlv_est_dt,'','',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT, g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
			+ "i.cpt_cd as CPT_CD,l.emp_nm,\n"
			+ "decode(b.car_use,'1',decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))),'-') car_end_dt, \n"
			+ "k.nm as FUEL_KD, \n"
			+ "decode( a.car_st, '1', '렌트', '3', '리스', decode( b.car_use, '1', '렌트', '2', '리스', '예비' ) ) AS car_use,  \n"
			+ "m.nm AS car_ext, \n"
			+ "replace(u.max_scan2,u.max_scan,'') file_type ,  e1.user_nm mng_nm, e1.user_m_tel mng_nm_hp "
			+ "from cont a, car_reg b, client c, fee d, users e, users e1, car_pur f, car_etc g, allot i, car_nm h, car_mng j, cls_cont s, code m, \n" 
			+ "     (select a.car_mng_id, MAX(b.CHA_SEQ) AS cha_seq, max(b.SCANFILE) as max_scan, max(b.SCANFILE||b.file_type) as max_scan2 from car_reg a, car_change b where a.car_mng_id = b.car_mng_id group by a.car_mng_id ) u, \n"
			+ "     (select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
			+ "		 from commi a, car_off_emp b, car_off c\n" 
			+ "		 where a.agnt_st='2'\n"
			+ "		 and a.emp_id=b.emp_id\n"
			+ "		 and b.car_off_id=c.car_off_id) l, \n"
			+ "     (select * from code where c_st='0039') k "
			+ "where a.rent_mng_id like '%'\n"
			+ subQuery
			+ gubunQuery
			+ "and a.car_mng_id = b.car_mng_id(+) and a.car_mng_id = u.car_mng_id(+) \n"
			+ "and a.client_id = c.client_id\n"
			+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "and a.bus_id = e.user_id(+)\n"
			+ "and a.mng_id = e1.user_id(+)\n"
			+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=j.car_comp_id(+) and h.car_cd=j.code(+)\n"
			+ "and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"
			+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+) and b.car_no not in ('미등록','미출고')\n"
			+ "and m.c_st='0032' and nvl(b.car_ext,g.car_ext) = m.nm_cd \n"
			+ "and b.fuel_kd=k.nm_cd \n"
			+ sortQuery;


		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);

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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:amazoncar_list]\n"+e);
			System.out.println("[Master_CarDatabase:amazoncar_list]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}


//마스타자동차 차량검사 리스트 조회 : master_maint_sc_in.jsp
	public Vector Car_MaintList(String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String s_st)
	{	
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		query = " select a.*, u.user_nm  from ( \n"+
				"	 SELECT  ''  ag, '1' m1_chk, b.RENT_L_CD , b.FIRM_NM,  b.client_id, b.car_mng_id, a.js_dt , a.js_seq,  c.CAR_NO , a.ssssny, a.jsbb, a.tot_dist, \n"+
				"	  c.CAR_NM , a.GMJM, a.sbgb_amt,  a.remarks, c.init_reg_dt ,  '마스타자동차' gubun , b.mng_id  \n"+
				"	 FROM master_car a, cont_n_view b, car_reg c\n"+
				"	 where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.car_mng_id = c.car_mng_id(+)  \n"+
				"	 and a.sbshm = '1' and a.gubun = '1' \n"+
				"	 union all     \n"+ 
				"	 SELECT nvl(a.gubun,'') ag,   a.m1_chk, b.RENT_L_CD , b.FIRM_NM,  b.client_id, b.car_mng_id, a.che_dt js_dt, to_number(a.m1_no)  js_seq,  c.CAR_NO , a.che_type ssssny, '' jsbb, nvl(a.tot_dist,  0 ) tot_dist,  \n"+
				"	  c.CAR_NM , a.che_nm GMJM, a.che_amt sbgb_amt,  a.che_remark remarks, c.init_reg_dt , decode(a.m1_chk , '3', '성수', '4', '정일현대', '5', '일등전국물류', '6', '미스터박대리', '7', '협신자동차' , 'A' , '성서현대', '8', '차비서' , '9', '영등포자동차검사소') gubun ,  b.mng_id   \n"+
				"	 FROM car_maint_req a, cont_n_view b, car_reg c \n"+
				"	 where a.rent_l_cd = b.rent_l_cd  and b.car_mng_id = c.car_mng_id(+) and a.che_dt is not null and a.m1_chk in ('3', '4', '5' , '6' , '7' ) ) a, users u   \n"+
				"  where a.mng_id = u.user_id ";
	

/*상세조회&&세부조회*/

	   /*검색조건*/
		//if(!s_st.equals("3")){
			
			//당월
			if(gubun2.equals("5")){			query += " and a.js_DT like to_char(sysdate,'YYYYMM')||'%'";
			//전월
			}else if(gubun2.equals("2")){	query += " and a.js_DT like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
			//기간
			}else if(gubun2.equals("4")){	query += " and a.js_DT BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')";
			//검색
			}else if(gubun2.equals("1")){	query += " and a.js_DT is not null";
			}
			
			/*검색조건*/
			if(!t_wd.equals("")){
				if(s_kd.equals("1"))		query += " and a.FIRM_NM LIKE '%"+t_wd+"%' \n";			
				else if(s_kd.equals("2"))	query += " and u.user_nm like '%"+t_wd+"%' \n"; 
				else if(s_kd.equals("4"))	query += " and a.CAR_NO like upper('%"+t_wd+"%') \n";
			}
	
		if(!gubun3.equals("")) query += " and a.m1_chk = '"+gubun3+"' \n";		 
		
		query += " order by  a.js_dt desc , a.js_seq ";
		
		try {				pstmt = conn.prepareStatement(query);
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
			System.out.println("[Master_CarDatabase:Car_MaintList]"+ e);
			System.out.println("[Master_CarDatabase:Car_MaintList]"+ query);
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
	
//마스타자동차 차량검사 리스트 조회_new : master_maint_sc_in.jsp- 마스타 제외 -20191210
	public Vector Car_MaintList_new(String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String s_st)
	{	
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String query3 = "";
		 
		query2 = "	 SELECT  ''  ag, a.js_dt m1_dt , '1' m1_chk,  b.RENT_L_CD , b.FIRM_NM,  b.client_id, b.car_mng_id, a.js_dt , a.js_seq,  c.CAR_NO , a.ssssny, a.jsbb, a.tot_dist, \n"+
				 "	  c.CAR_NM , a.GMJM, a.sbgb_amt,  a.remarks, c.init_reg_dt ,  '마스타자동차' gubun , b.mng_id, u.user_nm  \n"+
				 "	 FROM master_car a, cont_n_view b, car_reg c, users u \n"+
				 "	 where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.car_mng_id = c.car_mng_id(+)  \n"+
				 "	 and a.sbshm = '1' and a.gubun = '1' \n" +
				 "	 and b.mng_id = u.user_id \n";

		query3 = "	 SELECT nvl(a.gubun,'') ag, a.m1_dt,   a.m1_chk, b.RENT_L_CD , b.FIRM_NM,  b.client_id, b.car_mng_id, a.che_dt js_dt, to_number(a.m1_no)  js_seq,  nvl(c.CAR_NO, a.m1_content) car_no , a.che_type ssssny, '' jsbb, nvl(a.tot_dist,  0 ) tot_dist,  \n"+
				 "	 c.CAR_NM , a.che_nm GMJM, a.che_amt sbgb_amt,  a.che_remark remarks, c.init_reg_dt , decode(a.m1_chk , '3', '성수', '4', '정일현대', '5', '일등전국물류', '6', '미스터박대리', '7', '협신자동차', '9', '영등포자동차검사소', '8' , '차비서' , 'A','성서현대' ) gubun ,  b.mng_id, u.user_nm  \n"+
				 "	 FROM car_maint_req a, cont_n_view b, car_reg c, users u \n"+
				 " 	 where a.rent_l_cd = b.rent_l_cd(+)  and b.car_mng_id = c.car_mng_id(+) and a.che_dt is not null and a.m1_chk in ('3', '4', '5' , '6' , '7' , '9' , '8' , 'A' ) \n" +
				 "	 and b.mng_id = u.user_id(+) \n";	

/*상세조회&&세부조회*/

	   /*검색조건*/	
		//당월
		if(gubun2.equals("5")){	
										query3 += " and a.che_dt like to_char(sysdate,'YYYYMM')||'%' \n";
		//전월
		}else if(gubun2.equals("2")){
										query3 += " and a.che_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' \n ";
		//기간
		}else if(gubun2.equals("4")){	
										query3 += " and a.che_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','') \n";
		//검색
		}else if(gubun2.equals("1")){	
										query3 += " and a.che_dt is not null \n";
		}
		/*검색조건*/
		if(!t_wd.equals("")){
			if(s_kd.equals("1")){		
										query3 += " and b.FIRM_NM LIKE '%"+t_wd+"%' \n";
			}else if(s_kd.equals("2")){	 
										query3 += " and u.user_nm like '%"+t_wd+"%' \n";
			}else if(s_kd.equals("4")){	
										query3 += " and c.CAR_NO like upper('%"+t_wd+"%') \n";
			}
		}
	
		if(!gubun3.equals("")){		
									query3 += " and a.m1_chk = '"+gubun3+"' \n";
		}
		
		
		
		query += 	" select a.* from ( "+ query3 +
					") a \n" +
					"  order by  a.js_dt desc , a.js_seq ";
		
		try {	pstmt = conn.prepareStatement(query);
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
			System.out.println("[Master_CarDatabase:Car_MaintList_new]"+ e);
			System.out.println("[Master_CarDatabase:Car_MaintList_new]"+ query);
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


//차량번호로 차량관리번호, 유효기간 시작일, 유효기간 종료일  갖고오기
	public Hashtable getMCar_MaintList(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		query = " select a.car_mng_id, a.car_no, a.init_reg_dt, a.car_kd, "+
			" a.car_use, a.car_ext, b.rent_mng_id, b.rent_l_cd, b.car_st,  d.st_dt, d.end_dt, c.cls_dt, trunc(months_between(sysdate, a.init_reg_dt )/12) as year_dt "+
			" from (SELECT DISTINCT b.car_mng_id, b.car_no, a.car_kd, a.car_use, a.car_ext, a.init_reg_dt FROM car_reg a, (select car_mng_id, car_no from car_change where scanfile is not null ) b where a.car_mng_id=b.car_mng_id and b.car_no ='"+car_no+"') a,"+
		    " cont b, cls_cont c, users e,"+
			" (select rent_mng_id, rent_l_cd, min(rent_start_dt) st_dt, max(rent_end_dt) end_dt from fee group by rent_mng_id, rent_l_cd) d"+
			" where  a.car_mng_id=b.car_mng_id and b.car_st<>'2' "+
		    " and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+)"+
			" and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and b.bus_id2=e.user_id ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:getMCar_MaintList]"+e);
			System.out.println("[Master_CarDatabase:getMCar_MaintList]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	차량검사등록 INSERT
	 */

	public boolean insertMaster_carMaint(MCarMaintBean bean)
	{
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;

		boolean flag = true;
		ResultSet rs = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		String query_seq = "";
		String query1 = "";
		String query2 = "";
		String query3 = "";
		int seq_no = 0;

		query_seq = " select nvl(max(seq_no)+1, 1) from car_maint where car_mng_id = '" + bean.getCar_mng_id() + "' ";	
		
		if( bean.getChe_kd().equals("점검")){
			query2 = "UPDATE car_reg SET test_st_dt ='" + bean.getChe_st_dt() + "', test_end_dt='" + bean.getChe_end_dt() + "' WHERE car_mng_id='" + bean.getCar_mng_id() + "' ";
		}else{
			query2 = "UPDATE car_reg SET maint_st_dt ='" + bean.getChe_end_dt() + "', maint_end_dt=to_char(add_months(to_date('" + bean.getChe_end_dt() + "', 'YYYYMMDD'), 12)-1, 'YYYYMMDD') WHERE car_mng_id='" + bean.getCar_mng_id() + "' ";
		}

		query3 = "UPDATE car_reg SET M1_CHK ='-', M1_DT='-' WHERE M1_CHK is not null and  M1_DT is not null and car_mng_id='" + bean.getCar_mng_id() + "' ";

		query1 = "insert into car_maint "
					  +"(SEQ_NO, CAR_MNG_ID, CHE_KD, CHE_ST_DT, "
					  +" CHE_END_DT, CHE_DT, CHE_NO, CHE_COMP, CHE_AMT, CHE_KM, reg_dt "
					  +" ) values "
					  +" ( "
					  +" ?, ?, decode(?,'정기','1','정밀','2'), ?, "
					  +" to_char(add_months(to_date(?, 'YYYYMMDD'), 0)-1, 'YYYYMMDD'), ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD') "
					  +" )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query_seq);
			rs = pstmt1.executeQuery();
			if(rs.next())	seq_no = rs.getInt(1);
			rs.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query2);
			rs1 = pstmt2.executeQuery();
            rs1.close();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query3);
			rs2 = pstmt3.executeQuery();			
            rs2.close();
			pstmt3.close();

			pstmt4 = conn.prepareStatement(query1);
			pstmt4.setInt   (1,	 seq_no				);
			pstmt4.setString(2,  bean.getCar_mng_id());
			pstmt4.setString(3,  bean.getChe_kd());
			pstmt4.setString(4,  bean.getChe_st_dt());
			pstmt4.setString(5,  bean.getChe_end_dt());
			pstmt4.setString(6,  bean.getChe_dt());
			pstmt4.setString(7,  bean.getChe_no());
			pstmt4.setString(8,  bean.getChe_comp());
			pstmt4.setInt   (9,	 bean.getChe_amt());
			pstmt4.setInt   (10, bean.getChe_km());
			pstmt4.executeUpdate();
			pstmt4.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[Master_CarDatabase:insertMaster_carMaint]"+e);
			System.out.println("[Master_CarDatabase:insertMaster_carMaint]"+query1);
			System.out.println("[Master_CarDatabase:insertMaster_carMaint]"+query2);
			System.out.println("[Master_CarDatabase:insertMaster_carMaint]"+query3);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null )		rs.close();
                if(rs1 != null )	rs1.close();
                if(rs2 != null )	rs2.close();
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
                if(pstmt3 != null)	pstmt3.close();
                if(pstmt4 != null)	pstmt4.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/* 서비스 내역 조회 */
	
 	public Master_CarBean getMasterCarInfo( String js_dt, int js_seq )
 	{
        getConnection();
	    PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        Master_CarBean bean = new Master_CarBean();
        
        query = " select a.* from master_car a \n"+
				" where a.js_dt='"+ js_dt+"' and a.js_seq="+js_seq;
			
        try{

			pstmt = conn.prepareStatement(query);
    		rs = pstmt.executeQuery();
    	    		
            if (rs.next()){
	         
			        bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					
					bean.setJs_dt(rs.getString("JS_DT")); 
					bean.setJs_seq(rs.getInt("JS_SEQ")); 
					bean.setSbgb_amt(rs.getInt("SBGB_AMT")); 
					bean.setRent_l_cd(rs.getString("RENT_L_CD")); 		
					bean.setCar_no(rs.getString("CAR_NO")); 				
										                
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException e){
			System.out.println("[Master_CarDatabase:getMasterCarInfo]\n"+e);
			e.printStackTrace();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
          	}catch(Exception ignore){}
            closeConnection();
            return bean;
        }    
    }
 
    /**
	 *	금액수정 
	 */
	public boolean updateMasterCarInfoAmt(String js_dt, int js_seq, int sbgb_amt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update master_car set "+
						"		sbgb_amt = ?"+
						" where js_dt=replace(?, '-', '') and js_seq = ?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1,  sbgb_amt);
			pstmt.setString(2,  js_dt);
			pstmt.setInt(3,  js_seq);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[Master_CarDatabase:updateMasterCarInfoAmt]"+e);
			System.out.println("[Master_CarDatabase:updateMasterCarInfoAmt]"+query);
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

	 /**
	 *	삭제 
	 */
	public boolean deleteMasterCarInfo(String js_dt, int js_seq)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " delete master_car "+
						" where js_dt=replace(?, '-', '') and js_seq = ?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  js_dt);
			pstmt.setInt(2,  js_seq);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[Master_CarDatabase:deleteMasterCarInfo]"+e);
			System.out.println("[Master_CarDatabase:deleteMasterCarInfo]"+query);
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
	
	 /**
		 *	삭제 
		 */
	public boolean deleteCarMaintReq(String che_dt, String m1_no)
		{
			getConnection();
			boolean flag = true;
			PreparedStatement pstmt = null;

			String query =  " delete car_maint_req "+
							" where che_dt=replace(?, '-', '') and m1_no = ?";

			try 
			{
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1,  che_dt);
				pstmt.setString(2,  m1_no);
				pstmt.executeUpdate();
				pstmt.close();

				conn.commit();
			    
		  	} catch (Exception e) {
				System.out.println("[Master_CarDatabase:deleteCarMaintReq]"+e);
				System.out.println("[Master_CarDatabase:deleteCarMaintReq]"+query);
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
		
	/** 
	 *	검사의뢰 제출자료
	 */
	public Vector getSsmotersComAcarExcelList(String gubun3, String gubun2, String s_kd, String st_dt, String end_dt, String gubun1, String t_wd, String gubun4)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select decode(b1.che_dt , null , decode(b1.use_yn, 'N', '3', 'X', '4', '1') , '2') gubun,   b1.gubun   ag,  \n"+
				"  b1.m1_dt 등록일자,  b.car_no 차량번호, b.car_nm||' '||d.car_name 차종, replace(e.nm,'자동차','') 제조사, substr(b.init_reg_dt,1,4) as 연식, \n"+
				" decode(d.auto_yn,'Y','오토',decode(sign(instr(c.opt,'자동변속기')),1,'오토','수동')) 미션, \n"+
				" f2.nm as 연료, \n"+
				" o.firm_nm 고객, \n"+
				" nvl(o.o_tel,o.con_agnt_o_tel) 사무실, \n"+
				" nvl(o.m_tel,o.con_agnt_m_tel) 휴대폰, \n"+
				" decode(jm.mgr_m_tel,'',decode(o.client_st,'2',nvl(o.m_tel,o.con_agnt_m_tel),jr.mgr_m_tel),jm.mgr_m_tel) 차량관리자, \n"+
				" decode(a.car_st, '4', nvl(jj.mgr_m_tel,jjj.mgr_m_tel), jj.mgr_m_tel) 실운전자, \n"+
				" o.o_addr 주소, \n"+			
				"  decode(rrm.car_mng_id, null, a.rent_start_dt||'~'||a.rent_end_dt , '월렌트차량' )   대여기간, \n"+					
				"  b.init_reg_dt 최초등록일, f.nm 등록지역, \n"+
				" decode(a.rent_way_cd,'1','일반식','기본식') 대여방식, g.user_nm 관리담당자,  g.user_m_tel 연락처, b1.m1_no, b1.rent_l_cd ,\n"+
				" b1.che_dt 검사일 , b1.che_type  종류 , b1.che_nm  검사소, b1.che_amt 검사금액,  b1.tot_dist 주행거리, b1.off_nm 업체, b1.off_id, a.car_st, b.car_end_dt 차령만료일 \n"+
				" from cont_n_view a, car_reg b , car_maint_req b1, car_etc c, car_nm d, client o, \n"+
				" (select * from car_mgr where mgr_st='계약담당자') jr,\n"+
				" (select * from car_mgr where mgr_st='차량관리자') jm,\n"+
				" (select * from car_mgr where mgr_st='차량이용자') jj,\n"+
				" (select * from car_mgr where mgr_st='추가이용자') jjj,\n"+
				" (select * from rent_cont where rent_st = '12' and use_st = '2' ) rrm,   \n"+    
				" (select * from code where c_st='0001') e, users g, (select * from code where c_st='0032') f, (select * from code where c_st='0039') f2 \n"+			
				" where \n"+
				" nvl(b.prepare,'0') not in ('4','5') \n"+
				" and b1.car_mng_id=b.car_mng_id   \n"+
				" and a.car_mng_id=b.car_mng_id \n"+
				" and b.car_mng_id = rrm.car_mng_id(+)  \n"+
				" and a.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and d.car_comp_id=e.code \n"+
				" and decode(rrm.car_mng_id, null, a.client_id, rrm.cust_id) =o.client_id \n"+
				" and a.rent_mng_id=jr.rent_mng_id(+) and a.rent_l_cd=jr.rent_l_cd(+) \n"+
				" and a.rent_mng_id=jm.rent_mng_id(+) and a.rent_l_cd=jm.rent_l_cd(+) \n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+) \n"+
				" and a.rent_mng_id=jjj.rent_mng_id(+) and a.rent_l_cd=jjj.rent_l_cd(+) \n"+
				" and a.car_mng_id = b1.car_mng_id and a.rent_l_cd = b1.rent_l_cd \n"+
				" and nvl(b1.mng_id, a.mng_id)=g.user_id and   b1.m1_chk  in ( '3' , '5' , '6' , '8', 'A')  "+
				" and f.nm_cd = b.car_ext  "+
				" and b.fuel_kd = f2.nm_cd "+
				" ";
		
		
		if(gubun3.equals("1")) {		
				
			if(gubun2.equals("1"))			query += " and b1.m1_dt = to_char(sysdate,'YYYYMMDD')";		
			else if(gubun2.equals("5"))		query += " and b1.m1_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("2"))		query += " and b1.m1_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";	
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and b1.m1_dt like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and b1.m1_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}		
		} else if(gubun3.equals("2"))	{
					
			if(gubun2.equals("1"))			query += " and b1.che_dt = to_char(sysdate,'YYYYMMDD')";		
			else if(gubun2.equals("5"))		query += " and b1.che_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("2"))		query += " and b1.che_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";	
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and b1.che_dt like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and b1.che_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}		
		}	
		
		 
		if(s_kd.equals("1"))			query += " and b1.che_dt is null   and nvl(b1.use_yn, 'Y' ) = 'Y'  ";		
		else if(s_kd.equals("2"))		query += " and b1.che_dt is not null   and nvl(b1.use_yn, 'Y' ) <> 'N'  ";
		else if(s_kd.equals("3"))		query += " and nvl(b1.use_yn, 'Y' ) = 'N' ";
		else if(s_kd.equals("4"))		query += " and nvl(b1.use_yn, 'Y' ) = 'X' ";
		
		if(gubun1.equals("4"))			query += " and b.car_no like  '%"+t_wd+"%'";	
		
		if(!gubun4.equals(""))	query += " and b1.off_id like '%"+gubun4+"%'";
				
		query += " order by  1,  2, 3 desc  , b1.off_id ";		
	
		try {
			stmt = conn.createStatement();
		    	rs = stmt.executeQuery( query);
		    	

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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:getSsmotersComAcarExcelList(]\n"+e);
			System.out.println("[Master_CarDatabase:getSsmotersComAcarExcelList(]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	/** 
	 *	성수자동차 청구관련 제출자료
	 */
	public Vector getSsmotersComAcarExcelList1(String gubun3, String gubun2, String s_kd, String st_dt, String end_dt, String s_type, String gubun4)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select decode(b1.che_dt , null , '1', '2') gubun,  b1.che_dt 검사일 ,   b1.req_dt 청구일, b1.jung_dt 정산일, \n"+
				"  b1.m1_dt 등록일자,  b.car_no 차량번호, b.car_nm 차종, " + 
				" substr(b.init_reg_dt,1,4) as 연식, \n"+			
				" f2.nm as 연료, \n"+
				" o.firm_nm 고객, \n"+
				" o.o_addr 주소, \n"+			
				"  a.rent_start_dt||'~'||a.rent_end_dt 대여기간, \n"+	
				"  b.init_reg_dt 최초등록일, f.nm 등록지역, \n"+
				" decode(a.rent_way_cd,'1','일반식','기본식') 대여방식, g.user_nm 관리담당자, g.user_m_tel 연락처, b1.m1_no, b1.rent_l_cd ,\n"+
				" b1.che_type  종류 , b1.che_nm  검사소, b1.che_amt 검사금액,  b1.tot_dist 주행거리 , b1.off_nm 업체   \n"+
				" from cont_n_view a, car_reg b , car_maint_req b1, car_etc c, car_nm d, client o, \n"+
				"      (select * from code where c_st='0001') e, users g, (select * from code where c_st='0032') f, (select * from code where c_st='0039') f2  \n"+			
				" where \n"+
				" nvl(b.prepare,'0') not in ('4','5') \n"+
				" and b1.car_mng_id=b.car_mng_id   \n"+
				" and a.car_mng_id=b.car_mng_id \n"+
				" and a.rent_l_cd=c.rent_l_cd \n"+
				" and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				" and d.car_comp_id=e.code \n"+
				" and a.client_id=o.client_id \n"+	
				" and a.car_mng_id = b1.car_mng_id and a.rent_l_cd = b1.rent_l_cd \n"+
				" and nvl(a.mng_id,a.bus_id2)=g.user_id and b1.m1_chk in (  '3' , '5' , '6' ,'7', '4' , '9' , '8' , 'A' ) "+
				" and f.nm_cd = b.car_ext "+
				" and f2.nm_cd = b.fuel_kd "+
				" ";
		
		
		if(gubun3.equals("1")) {		
				
			if(gubun2.equals("1"))			query += " and b1.m1_dt = to_char(sysdate,'YYYYMMDD')";		
			else if(gubun2.equals("5"))		query += " and b1.m1_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("2"))		query += " and b1.m1_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";	
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and b1.m1_dt like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and b1.m1_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}		
		} else if(gubun3.equals("2"))	{
					
			if(gubun2.equals("1"))			query += " and b1.che_dt = to_char(sysdate,'YYYYMMDD')";		
			else if(gubun2.equals("5"))		query += " and b1.che_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("2"))		query += " and b1.che_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";	
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and b1.che_dt like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and b1.che_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}		
		
		//청구
		} else if(gubun3.equals("3"))	{
					
			if(gubun2.equals("1"))			query += " and b1.req_dt = to_char(sysdate,'YYYYMMDD')";		
			else if(gubun2.equals("5"))		query += " and b1.req_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("2"))		query += " and b1.req_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";	
			else if(gubun2.equals("4")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += "  and b1.req_dt like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += "  and b1.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}		
			
		}	
				 
		if(s_kd.equals("1"))			query += " and b1.che_dt is null ";	
		else if(s_kd.equals("2"))		query += " and b1.che_dt is not null ";
		
		if(!gubun4.equals(""))	query += " and b1.off_id like '%"+gubun4+"%'";
			
		if(s_type.equals("1"))			query += " and b1.req_dt is null  order by  1,  2 ";	
		else if(s_type.equals("2"))		query += " and b1.req_dt is not null  order by  1,  3, 2";
	
		
	
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
	    	
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:getSsmotersComAcarExcelList1]\n"+e);
			System.out.println("[Master_CarDatabase:getSsmotersComAcarExcelList1]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
		
		/* 서비스 내역 조회 */
	
 	public CarMaintReqBean getCarMaintInfo( String m1_no, String rent_l_cd) 
 	{
        getConnection();
	    PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        CarMaintReqBean bean = new CarMaintReqBean();
        
        query = " select a.* , u.user_nm mng_nm, c.car_no car_no  from car_maint_req a, users u, car_reg c \n"+
				" where a.car_mng_id = c.car_mng_id and a.mng_id = u.user_id(+) and a.m1_no='"+ m1_no+"' and a.rent_l_cd = '"+rent_l_cd + "'";
			
        try{

			pstmt = conn.prepareStatement(query);
    		rs = pstmt.executeQuery();
    	    		
            if (rs.next()){
	         	         	       			
	         		bean.setM1_no(rs.getString("M1_NO")==null?"":rs.getString("M1_NO")); 
	         		bean.setMng_id(rs.getString("MNG_ID")==null?"":rs.getString("MNG_ID")); 
	         		bean.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID")); 
	         		bean.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD")); 
	         		bean.setM1_dt(rs.getString("M1_DT")==null?"":rs.getString("M1_DT")); 
	         		bean.setM1_content(rs.getString("M1_CONTENT")==null?"":rs.getString("M1_CONTENT")); 	         		
			        bean.setChe_dt(rs.getString("CHE_DT")==null?"":rs.getString("CHE_DT")); 
					bean.setChe_nm(rs.getString("CHE_NM")==null?"":rs.getString("CHE_NM"));  		
					bean.setTot_dist(rs.getInt("TOT_DIST")); 	
					bean.setChe_type(rs.getString("CHE_TYPE")==null?"":rs.getString("CHE_TYPE")); 	
					bean.setChe_amt(rs.getInt("CHE_AMT")); 	
					bean.setChe_remark(rs.getString("CHE_REMARK")==null?"":rs.getString("CHE_REMARK")); 	
					bean.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO")); 	
					bean.setMng_nm(rs.getString("MNG_NM")==null?"":rs.getString("MNG_NM")); 	
					bean.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT")); 	
					bean.setJung_dt(rs.getString("JUNG_DT")==null?"":rs.getString("JUNG_DT")); 			
					bean.setUse_yn(rs.getString("USE_YN")==null?"":rs.getString("USE_YN")); 			
					bean.setGubun(rs.getString("GUBUN")==null?"":rs.getString("GUBUN")); 	
					bean.setOff_id(rs.getString("OFF_ID")==null?"":rs.getString("OFF_ID")); 			
										                
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException e){
			System.out.println("[Master_CarDatabase:getCarMaintInfo]\n"+e);
			e.printStackTrace();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
          	}catch(Exception ignore){}
            closeConnection();
            return bean;
        }    
    }
        
       /**
	 *	검사의뢰 수정 
	 */
	public boolean updateCarMaintInfo(String car_mng_id, String m1_no,  String che_dt, String che_nm, int tot_dist, String che_type, int che_amt, String che_remark, String use_yn, String m1_content)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;

		String query =  " update car_maint_req set "+
						"       che_dt = replace(?, '-', '') , che_nm  = ? , tot_dist = ?, "+
						"		che_type = ?, che_amt = ? , che_remark = ?, upd_dt = to_char(sysdate,'YYYYMMdd'), use_yn = ? , m1_content = ? "+
						" where m1_no=? ";
						
		String query1 =  " update car_reg  set "+
						"       m1_chk  = '', update_dt = to_char(sysdate,'YYYYMMdd') "+
						" where car_mng_id =? ";				

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  che_dt);
			pstmt.setString(2,  che_nm);
			pstmt.setInt(3,  tot_dist);
			pstmt.setString(4,  che_type);
			pstmt.setInt(5,  che_amt);
			pstmt.setString(6,  che_remark);
			pstmt.setString(7,  use_yn);
			pstmt.setString(8,  m1_content);
			pstmt.setString(9,  m1_no);
			pstmt.executeUpdate();
			pstmt.close();

            if ( use_yn.equals("N") || use_yn.equals("X") ) {
            	pstmt1 = conn.prepareStatement(query1);
				pstmt1.setString(1,  car_mng_id);
				pstmt1.executeUpdate();
				pstmt1.close();            	
            }	
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[Master_CarDatabase:updateCarMaintInfo]"+e);
			System.out.println("[Master_CarDatabase:updateCarMaintInfo]"+query);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
 
	public boolean updateCarMaintReqDt(String m1_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_maint_req set req_dt=to_char(sysdate,'YYYYMMDD') where m1_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  m1_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[Master_CarDatabase:updateCarMaintReqDt\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	public boolean updateCarmaintReqCode(String m1_no, String req_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_maint_req set req_code=? where m1_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  req_code);
			pstmt.setString(2,  m1_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[Master_CarDatabase:updateCarmaintReqCode]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public boolean updateCarMaintJungDt(String m1_no, String jung_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_maint_req set jung_dt= replace(?, '-', '') where m1_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  jung_dt);
			pstmt.setString(2,  m1_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[Master_CarDatabase:updateCarMaintJungDt]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	//문서처리 리스트 조회
	public Vector getCarMaintReqDocList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select \n"+
				" b.doc_id as req_code, a.jung_dt, count(a.m1_no) cnt,  sum(a.che_amt) che_amt, \n"+
				" min(substr(a.che_dt,1,8)) min_dt, max(substr(a.che_dt,1,8)) max_dt, max(a.off_nm) off_nm \n"+
				" from car_maint_req a, \n"+
				"  (select b.doc_id, a.doc_step  from doc_settle a, ( select doc_id from doc_settle  where doc_st = '51' group by doc_id ) b  where a.doc_id = b.doc_id) b \n"+
				" where a.req_code=b.doc_id and a.jung_dt is not null \n";

		if(gubun1.equals("1"))							sub_query += " and a.jung_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("4"))						sub_query += " and a.jung_dt like to_char( add_months( sysdate, - 1 ), 'YYYYMM' )||'%'";
		else if(gubun1.equals("3"))						sub_query += " and ( a.jung_dt like to_char(sysdate,'YYYY')||'%'  or  b.doc_step <> '3'  ) "; //미결이 있따면 포함 
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and a.jung_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and a.jung_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		sub_query += " group by  a.jung_dt, b.doc_id";

		query = " select \n"+
				" a.*, b.user_id1, b.user_id2, b.user_id3, c.user_nm as user_nm1, d.user_nm as user_nm2, e.user_nm as user_nm3, b.user_dt1, b.user_dt2, b.user_dt3 , b.doc_no \n"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='51') b, users c, users d , users e  \n"+
				" where a.req_code=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and b.user_id3=e.user_id(+) \n"+
				" order by a.jung_dt desc ";

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
			System.out.println("[Master_CarDatabase:getCarMaintReqDocList]\n"+e);
			System.out.println("[Master_CarDatabase:getCarMaintReqDocList]\n"+query);
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
	
	
	//청구서작성 리스트 조회
	public Vector getCarMaintReqDocList2(String req_code, String pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, v.firm_nm , \n"+
				" cr.car_no, cr.car_nm  "+
				" from car_maint_req a, (select * from doc_settle where doc_st='51') b, users c, users d , cont_n_view v, car_reg cr  "+		
				" where a.req_code=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and a.rent_l_cd = v.rent_l_cd "+
				" and v.car_mng_id = cr.car_mng_id(+) and a.jung_dt is not null  and b.doc_id='"+req_code+"'";//and a.pay_dt is null 

		if(!pay_dt.equals(""))	query +=" and a.jigub_dt = replace('"+pay_dt+"','-','')";
//		else					query +=" and a.pay_dt is null";

		query += " order by a.che_dt, a.m1_no ";
			
			
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
			System.out.println("[Master_CarDatabase:getCarMaintReqDocList2]\n"+e);
			System.out.println("[Master_CarDatabase:getCarMaintReqDocList2]\n"+query);
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
	
	
			
		/* 서비스 내역 조회 */
	
 	public CarMaintReqBean getCarMaint( String m1_no) 
 	{
        getConnection();
	    PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        CarMaintReqBean bean = new CarMaintReqBean();
        
        query = " select a.* , u.user_nm mng_nm, c.car_no car_no  from car_maint_req a, users u, car_reg c \n"+
				" where a.car_mng_id = c.car_mng_id and a.mng_id = u.user_id(+) and a.m1_no='"+ m1_no+"'";
			
        try{

			pstmt = conn.prepareStatement(query);
    		rs = pstmt.executeQuery();
    	    		
            if (rs.next()){
	         	         	       			
	         		bean.setM1_no(rs.getString("M1_NO")==null?"":rs.getString("M1_NO")); 
	         		bean.setMng_id(rs.getString("MNG_ID")==null?"":rs.getString("MNG_ID")); 
	         		bean.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID")); 
	         		bean.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD")); 
	         		bean.setM1_dt(rs.getString("M1_DT")==null?"":rs.getString("M1_DT")); 
	         		bean.setM1_content(rs.getString("M1_CONTENT")==null?"":rs.getString("M1_CONTENT")); 	         		
			        bean.setChe_dt(rs.getString("CHE_DT")==null?"":rs.getString("CHE_DT")); 
					bean.setChe_nm(rs.getString("CHE_NM")==null?"":rs.getString("CHE_NM"));  		
					bean.setTot_dist(rs.getInt("TOT_DIST")); 	
					bean.setChe_type(rs.getString("CHE_TYPE")==null?"":rs.getString("CHE_TYPE")); 	
					bean.setChe_amt(rs.getInt("CHE_AMT")); 	
					bean.setChe_remark(rs.getString("CHE_REMARK")==null?"":rs.getString("CHE_REMARK")); 	
					bean.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO")); 	
					bean.setMng_nm(rs.getString("MNG_NM")==null?"":rs.getString("MNG_NM")); 	
					bean.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT")); 	
					bean.setJung_dt(rs.getString("JUNG_DT")==null?"":rs.getString("JUNG_DT")); 			
					bean.setUse_yn(rs.getString("USE_YN")==null?"":rs.getString("USE_YN")); 					
										                
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException e){
			System.out.println("[Master_CarDatabase:getCarMaintInfo]\n"+e);
			e.printStackTrace();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
          	}catch(Exception ignore){}
            closeConnection();
            return bean;
        }    
    }
  	

	//차량번호로 차량관리번호 가져가기
	public Hashtable Serach(String car_no, String js_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		query = " select a.*, b.rent_mng_id, b.rent_l_cd, '' rent_s_cd, b.car_st, b.mng_id as mng_id, e.user_nm, d.st_dt, d.end_dt, c.cls_dt  \n"+
		" from   (select distinct b.car_mng_id, b.car_no from car_reg a, car_change b where a.car_mng_id=b.car_mng_id and b.car_no ='"+car_no+"') a,"+
	    "   cont b, cls_cont c, users e,"+	    
	//	"(select rent_mng_id, rent_l_cd, min(rent_start_dt) st_dt, max(rent_end_dt) end_dt from fee group by rent_mng_id, rent_l_cd) d"+
		"( select f.rent_mng_id, f.rent_l_cd, min(f.rent_start_dt) st_dt, case when max(sf.use_e_dt) > max(f.rent_end_dt) then max(sf.use_e_dt) else max(f.rent_end_dt)  end end_dt from fee f, scd_fee sf \n"+
   		" where f.rent_mng_id = sf.rent_mng_id and f.rent_l_cd = sf.rent_l_cd  and  nvl(sf.bill_yn, 'Y') = 'Y'  group by f.rent_mng_id, f.rent_l_cd ) d  \n"+
		" where a.car_mng_id=b.car_mng_id and b.car_st <> '2'  \n"+
	    "   and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+)  \n"+
		"   and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and b.bus_id2=e.user_id  \n"+
		"   and '"+js_dt+"' between d.st_dt and nvl(c.cls_dt,d.end_dt) \n"+		
		" union all \n"+
//--단기대여인 경우
		" select a.*, b.rent_mng_id, b.rent_l_cd, c.rent_s_cd, b.car_st, decode(c.rent_st,'4',c.cust_id,b.mng_id) as mng_id, e.user_nm, nvl(c.deli_dt,c.deli_plan_dt) st_dt, nvl(c.ret_dt,c.ret_plan_dt) end_dt, '' cls_dt "+
		" from   (select distinct b.car_mng_id, b.car_no from car_reg a, car_change b where a.car_mng_id=b.car_mng_id and b.car_no ='"+car_no+"') a,"+
		" cont b, rent_cont c, users e "+
		" where  a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id(+) and b.car_st='2' and c.use_st <>'5'"+
	    " and decode(c.rent_st,'4',c.cust_id,c.bus_id)=e.user_id "+
		" and '"+js_dt+"' between nvl(c.deli_dt,c.deli_plan_dt) and nvl(c.ret_dt,nvl(c.ret_plan_dt,decode(c.use_st,'2','99999999'))) ";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
            rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Customer_Database:Serach]"+e);
			System.out.println("[Customer_Database:Serach]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	


	public boolean insertHj_car(CarMaintReqBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		String query2 = "";
		ResultSet rs = null;
		String m1_no ="";
		
		query2 = " SELECT to_char(SYSDATE,'YYYYMMDD')||NVL(LPAD(MAX(SUBSTR(m1_no,9,12))+1,4,'0'),'0001') AS m1_no FROM CAR_MAINT_REQ  where SUBSTR(m1_no,0,8 ) = to_char(SYSDATE,'YYYYMMDD')";

		String query = "insert into CAR_MAINT_REQ "
					  +"(M1_DT, M1_CHK, CHE_DT, CHE_TYPE, REG_DT, "
					  +" CHE_AMT, CHE_NM, REQ_DT, CAR_MNG_ID, "
					  +" RENT_L_CD, MNG_ID, M1_NO, OFF_ID,  OFF_NM, M1_CONTENT ) values "
					  +" ( "
					  +" replace(?, '-', ''), ?, replace(?, '-', ''), ?, to_char(sysdate,'YYYYMMDD'), "
					  +" ?, ?, replace(?, '-', ''), ?,  "
					  +" ?, ?, ?, ? ,?, ? )";
						
		try 
		{
			conn.setAutoCommit(false);
			pstmt2 = conn.prepareStatement(query2);
			rs = pstmt2.executeQuery();

			if(rs.next())
			{				
				m1_no = rs.getString(1);
			}
			rs.close();
			pstmt2.close();
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getM1_dt());
			pstmt.setString(2,  bean.getM1_chk());
			pstmt.setString(3,  bean.getChe_dt());
			pstmt.setString(4,  bean.getChe_type());
			pstmt.setInt	(5,  bean.getChe_amt());
			pstmt.setString(6,  bean.getChe_nm());
			pstmt.setString(7,  bean.getReq_dt());
			pstmt.setString(8,  bean.getCar_mng_id());
			pstmt.setString(9,  bean.getRent_l_cd());
			pstmt.setString(10,  bean.getMng_id());
			pstmt.setString(11,  m1_no);
			pstmt.setString(12, bean.getOff_id());
			pstmt.setString(13, bean.getChe_nm());
			pstmt.setString(14, bean.getM1_content());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[Master_CarDatabase:insertHj_car]"+e);
			System.out.println("[Master_CarDatabase:insertHj_car]"+query);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)	rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}


	//차량번호로 차량관리번호, 유효기간 시작일, 유효기간 종료일  갖고오기
	public Hashtable  getCarReqMaintInfo(String car_mng_id) 
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		query = " select  c.car_no , c.car_nm, c.car_form , b.br_addr  from car_reg c , branch b \n"+
			" where\n"+
			"  decode(c.car_ext, '2', 'K1', '7', 'I1', 'K2') = b.br_id(+) \n"+
			" and c.car_mng_id = '"+car_mng_id + "'";
		

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:getCarReqMaintInfo]"+e);
			System.out.println("[Master_CarDatabase:getCarReqMaintInfo]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	
		//차량번호로 
	public String getMasterCarNo(String a_c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String car_no = "";

	//	String query = "select replace(wm_concat(car_no), ',' ,' ') car_no from car_reg where car_mng_id in ( "+ a_c_id +" ) order by car_end_dt asc, car_doc_no asc ";
	    String  query = " select  replace(wm_concat(car_no), ',' ,' ') car_no from ( select car_no 	from car_reg where car_mng_id in ( "+ a_c_id +" )	order by car_end_dt asc , car_doc_no asc )  ";
				
	//	System.out.println("query=" + query);
		try 
		{
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery();
			if(rs.next()){
				car_no = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[AdminDatabase:getMasterCarNo]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return car_no;
		}			
	}
	
	
		//차량번호로 	
	public Hashtable  getMasterCarAddr(String a_c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";


		query = "	 select   b.br_addr , decode(c.car_ext, '2', '파주', '7', '인천', '포천') br_nm from car_reg c , branch b  \n"+
			     "   where 	 decode(c.car_ext, '2', 'K1', '7', 'I1', 'K2') = b.br_id(+)   \n"+
			     "   and  c.car_mng_id in ( "+ a_c_id +" )   and rownum = 1 ";
				

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:getMasterCarAddr]"+e);
			System.out.println("[Master_CarDatabase:getMasterCarAddr]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	
		//  검사 등록 여부 
	public int  getCarMaintCnt(String car_mng_id , String che_dt , int  che_comp)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int  cnt =0;
					
		query = " select count(0)  from car_maint  where car_mng_id='"+car_mng_id+"' and  che_dt = replace('"+ che_dt + "', '-', '') and che_amt= " + che_comp ;

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				cnt  = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			
			System.out.println("[TintDatabase:getCarMaintCnt]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}	
	
	
	public boolean updateCarReq(String m1_no, String rent_l_cd, String car_mng_id, String mng_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_maint_req set rent_l_cd =?, car_mng_id = ? , mng_id = ?  where m1_no=? ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  rent_l_cd);
			pstmt.setString(2,  car_mng_id);
			pstmt.setString(3,  mng_id);
			pstmt.setString(4,  m1_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[Master_CarDatabase:updateCarReq]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	public boolean deleteCarReq(String m1_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " delete  car_maint_req  where m1_no=? ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			
			pstmt.setString(1,  m1_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[Master_CarDatabase:deleteCarReq]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public boolean updateJungdt(String req_code, String off_id, String jung_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_maint_req  set jung_dt = replace(?, '-', '')  where req_code =? and off_id= ?  ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			
			pstmt.setString(1,  jung_dt);
			pstmt.setString(2,  req_code);
			pstmt.setString(3,  off_id);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[Master_CarDatabase:updateJungdt]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	/** 
	 *	 년도별검사 현황
	 */
	public Vector getSsmotersMaintList(String gubun1)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = "select \n" +
				"	 substr(a.jung_dt,1,6) ym, \n" +
				"	 count(a.m1_no) cnt0, \n" +
				"	 sum(a.che_amt) amt0, \n" +	 
				"	 count(decode(a.off_id,'007410',a.m1_no)) cnt1, \n" +
				"	 sum(decode(a.off_id,'007410',a.che_amt)) amt1, \n" +
				"	 count(decode(a.off_id,'011614',a.m1_no)) cnt2, \n" +
				"	 sum(decode(a.off_id,'011614',a.che_amt)) amt2, \n" +                 
	            "      count(decode(a.off_id,'000286',a.m1_no)) cnt3, \n" +
				"	 sum(decode(a.off_id,'000286',a.che_amt)) amt3, \n" +                 
	            "      count(decode(a.off_id,'011827',a.m1_no)) cnt4, \n" +
				"	 sum(decode(a.off_id,'011827',a.che_amt)) amt4,   \n" +              
	            "      count(decode(a.off_id,'010097',a.m1_no)) cnt5, \n" +
				"	 sum(decode(a.off_id,'010097',a.che_amt)) amt5	  \n" +               			
				"	from car_maint_req a, (select doc_id from doc_settle  where doc_st = '51' group by doc_id ) b \n" +
				"	   where a.req_code=b.doc_id and a.jung_dt is not null \n" +
				"		and  a.jung_dt like '"+ gubun1 + "%' and a.che_amt >0 		\n" +	
			 	"	 group by substr(a.jung_dt,1,6) order by substr(a.jung_dt,1,6) ";
		
		 		 
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
	    	
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[Master_CarDatabase:getSsmotersMaintList]\n"+e);
			System.out.println("[Master_CarDatabase:getSsmotersMaintList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	
	public String getServOff(String off_id){
		getConnection();
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String off_nm = "";

		query = "SELECT  off_nm "+
				" FROM serv_off WHERE off_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,off_id);
			rs = pstmt.executeQuery();

			if(rs.next())
			{				
				off_nm  = rs.getString(1);
			}
			rs.close();
			pstmt.close();	
		}catch(SQLException e){
			System.out.println("[Master_CarDatabase:getServOff(String off_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return off_nm;
		}		
	}
	
	
	// 교통안전공단 도래 5일전
	public boolean insertCyberts(CarMaintReqBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
									    
		String query = "insert into cyberts "
					  +"(CAR_NO, CAR_NUM, CAR_NAME, END_DT,"
					  +" CAR_TYPE, CAR_MNG_ID, RENT_L_CD, REG_DT, CAR_END_DT, CAR_YY, INIT_REG_DT ) values "
					  +" ( "
					  +" ?, ?, ?, ?,  ?, ?, ?, sysdate , ? , ? , ? )";
						
			
		try 
		{
			conn.setAutoCommit(false);
						
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getM1_no());
			pstmt.setString(2,  bean.getM1_content());
			pstmt.setString(3,  bean.getChe_nm());
			pstmt.setString(4,  bean.getReq_dt());	
			pstmt.setString(5,  bean.getChe_type());
			pstmt.setString(6,  bean.getCar_mng_id());
			pstmt.setString(7,  bean.getRent_l_cd());
			pstmt.setString(8,  bean.getJung_dt());
			pstmt.setString(9,  bean.getGubun());
			pstmt.setString(10,  bean.getM1_dt());
		
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[Master_CarDatabase:insertCyberts]"+e);
			System.out.println("[Master_CarDatabase:insertCyberts]"+query);
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
	
	
	public boolean deleteCyberts()
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
						    
		String query = "delete from cyberts " ;
						
		try 
		{
			conn.setAutoCommit(false);
						
			pstmt = conn.prepareStatement(query);			
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[Master_CarDatabase:deleteCyberts]"+e);
			System.out.println("[Master_CarDatabase:deleteCyberts]"+query);
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
	
	public boolean deleteAcctTemp()
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
						    
		String query = "delete from acct_temp " ;
						
		try 
		{
			conn.setAutoCommit(false);
						
			pstmt = conn.prepareStatement(query);			
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[Master_CarDatabase:deleteCyberts]"+e);
			System.out.println("[Master_CarDatabase:deleteCyberts]"+query);
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

	// 교통안전공단 도래 5일전
	public boolean insertAcctTemp(String c1, String c2, String c3, String c4)
		{
			getConnection();
			boolean flag = true;
			PreparedStatement pstmt = null;
			
			String query = "insert into acct_temp  "
						  +"(ACCT_CODE, ACCT_NM, ACCT_NO, ACCT_AMT, ACCT_DT ) values "					
						  +" ( "
						  +" ?, ?, replace(?, '-', '') , replace(?, ',', '') , sysdate )";
							
				
			try 
			{
				conn.setAutoCommit(false);
							
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1,  c1);
				pstmt.setString(2,  c2);
				pstmt.setString(3,  c3);
				pstmt.setString(4,  c4);	
							
				pstmt.executeUpdate();
				pstmt.close();

				conn.commit();

		  	} catch (Exception e) {
				System.out.println("[Master_CarDatabase:insertAcctTemp]"+e);
				System.out.println("[Master_CarDatabase:insertAcctTemp]"+query);
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