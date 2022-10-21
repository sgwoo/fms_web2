package acar.car_scrap;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;

public class ScrapDatabase
{
	private Connection conn = null;
	public static ScrapDatabase db;
	
	public static ScrapDatabase getInstance()
	{
		if(ScrapDatabase.db == null)
			ScrapDatabase.db = new ScrapDatabase();
		return ScrapDatabase.db;
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
	

	// 대폐차 관리--------------------------------------------------------------------------------------------


	/**
	 *	대폐차 리스트
	 */
	public Vector getScrapList(String gubun, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

/*		query = " select DISTINCT a.car_no, b.car_nm from car_change a, car_reg b"+
				" where a.car_mng_id=b.car_mng_id and a.car_no like '%허%' and a.car_no!=b.car_no"+
				" and a.car_no like '"+gubun+"%"+t_wd+"%'"+                
				" order by a.car_no";
*/
		if(gubun.equals("서울")){
			query = " select max(a.car_mng_id) car_mng_id, a.car_no, c.car_nm from"+ 
					" (select DISTINCT b.car_no, a.car_mng_id from car_reg a, car_change b where a.car_mng_id=b.car_mng_id and a.car_no<>b.car_no) a,"+
					" car_reg b,"+ 
					" (select first_car_no, max(car_nm) car_nm from car_reg group by first_car_no) c"+
					" where a.car_no=b.car_no(+) and b.car_no is null and a.car_no=c.first_car_no"+
					" and a.car_no like '"+gubun+"%"+t_wd+"%'"+                
					" and a.car_no like '%허%'"+// and substr(a.car_no, 3,2) in ('34'),'71'
//					" and substr(a.car_no, 6,4) not in ('4333','4386','4455','4457','4462','4464','4465','4470','5826','3017')"+//20040427:감차차량번호 제외
					" group by a.car_no, c.car_nm "+
					" order by a.car_no";
		}else{
			query = " select max(a.car_mng_id) car_mng_id, a.car_no, c.car_nm from"+ 
					" (select DISTINCT b.car_no, a.car_mng_id from car_reg a, car_change b where a.car_mng_id=b.car_mng_id and a.car_no<>b.car_no) a,"+
					" car_reg b,"+ 
					" (select first_car_no, max(car_nm) car_nm from car_reg group by first_car_no) c"+
					" where a.car_no=b.car_no(+) and b.car_no is null and a.car_no=c.first_car_no"+
					" and a.car_no like '"+gubun+"%"+t_wd+"%'"+                
					" and a.car_no like '%허%'"+
//					" and substr(a.car_no, 6,4) not in ('4333','4386','4455','4457','4462','4464','4465','4470','5826','3017')"+//20040427:감차차량번호 제외
					" group by a.car_no, c.car_nm "+
					" order by a.car_no";

		}
		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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
			System.out.println("[ScrapDatabase:getScrapList]"+e);
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
	 *	대폐차 리스트
	 */
	public Vector getCar_no_history(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.car_mng_id, b.car_l_cd, a.cha_seq, a.car_no, b.car_num, a.cha_cau_sub, b.car_nm, "+
				//" decode(b.car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext, "+
				" c.nm car_ext, "+
				" decode(a.cha_cau, '1','사용본거지변경','2','용도변경','3','기타','') cha_cau,"+
				" DECODE(a.cha_dt,'','',SUBSTR(a.cha_dt,1,4)||'-'||SUBSTR(a.cha_dt,5,2)||'-'||SUBSTR(a.cha_dt,7,2)) as cha_dt"+				
				" from car_change a, car_reg b, (select * from code where c_st='0032') c "+
				" where a.car_mng_id=b.car_mng_id"+
				" and b.CAR_EXT =  c.NM_CD"+
				" and a.car_no='"+car_no+"'"+
				" order by a.car_mng_id, a.cha_dt ";

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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
			System.out.println("[ScrapDatabase:getCar_no_history]"+e);
			System.out.println("[ScrapDatabase:getCar_no_history]"+query);
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
	 *	대폐차 이력 명의변경일
	 */
	public String getEnd_cha_dt(String c_id, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String dt = "";
		String query = "";

		if(!seq.equals("")){
			query = " select "+
					" DECODE(cha_dt,'',' ',SUBSTR(cha_dt,1,4)||'-'||SUBSTR(cha_dt,5,2)||'-'||SUBSTR(cha_dt,7,2)) as cha_dt"+
					" from car_change"+
					" where car_mng_id='"+c_id+"' and cha_seq=to_char(to_number('"+seq+"')+1)";
		}else{
			query = " select "+
					" DECODE(max(cha_dt),'',' ',SUBSTR(max(cha_dt),1,4)||'-'||SUBSTR(max(cha_dt),5,2)||'-'||SUBSTR(max(cha_dt),7,2)) as cha_dt"+
					" from car_change"+
					" where car_mng_id='"+c_id+"' group by car_mng_id";
		}

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				dt = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ScrapDatabase:getEnd_cha_dt]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dt;
		}
	}	

	/**
	 *	대폐차 이력 최종명의변경일
	 */
	public String getEnd_cha_dt(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String dt = "";
		String query = "";

		query = " select "+
				" DECODE(max(cha_dt),'',' ',SUBSTR(max(cha_dt),1,4)||'-'||SUBSTR(max(cha_dt),5,2)||'-'||SUBSTR(max(cha_dt),7,2)) as cha_dt"+
				" from car_change"+
				" where car_no='"+car_no+"' group by cha_dt";

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				dt = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ScrapDatabase:getEnd_cha_dt]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dt;
		}
	}	
	
	/**
	 *	중복등록 확인
	 */
	public int getInsertYn(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(*) from car_reg where car_no='"+car_no+"'";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

	  	} catch (Exception e) {
			System.out.println("[ScrapDatabase:getInsertYn]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}			
	}

//----------------------------------------------------------------------------------------------
	// 대폐차관리 각테이블에 조회시 데이터 불량으로 직접 테이블생성해서 입력,수정,삭제 및 조회 관리
	// 2004.1.4.화. Yongsoon Kwon.
//----------------------------------------------------------------------------------------------
	/**
	 *	대폐차 리스트
	 */
	public Vector getScrapList_m(String gubun, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.seq, a.car_no, a.car_nm, a.reg_dt, a.car_ext, a.car_no_stat, a.end_dt, a.rent_l_cd, a.upd_dt, "+
				"        c.nm as car_ext_nm, "+
				"        decode(a.auto_yn,'Y','자동','N','지정','') as auto_yn, b.init_reg_dt "+
				" FROM   car_scrap a, "+
				"        ( select a.car_no, nvl(a.car_ext,c.car_ext) car_ext, c.init_reg_dt "+
				"          from   car_change a, "+
				"                 ( select car_no, max(cha_dt) cha_dt from car_change group by car_no ) b, car_reg c, "+
				"                 ( select car_mng_id from cont where car_st<>'4' group by car_mng_id ) d "+
				"          where  a.car_no=b.car_no and a.cha_dt=b.cha_dt and a.car_mng_id=c.car_mng_id and c.car_mng_id=d.car_mng_id "+
				"        ) b, "+
				"        (select * from code where c_st='0032') c "+
				" WHERE  a.car_no=b.car_no(+) and b.car_ext = c.nm_cd"+
				"   AND  (a.car_no_stat NOT LIKE '1' OR a.car_no_stat IS NULL)";	//<--추가(신규등록 번호는 대폐차 리스트에서는 빼기위해)

		if(gubun.equals("") && !t_wd.equals(""))	query += " and a.car_no LIKE '%"+t_wd+"%'";
		if(!gubun.equals("") && t_wd.equals(""))	query += " and decode(a.car_ext,'경기','파주',a.car_ext) like '%"+gubun+"%'";
		if(!gubun.equals("") && !t_wd.equals(""))	query += " and decode(a.car_ext,'경기','파주',a.car_ext) like '%"+gubun+"%'  and a.car_no LIKE '%"+t_wd+"%'";

		query += " ORDER BY a.reg_dt ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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
			System.out.println("[ScrapDatabase:getScrapList_m(String gubun, String s_kd, String t_wd)]"+e);
			System.out.println("[ScrapDatabase:getScrapList_m(String gubun, String s_kd, String t_wd)]"+query);
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
	 *	대폐차 중복체크
	 */
	public int getScrapCheck(String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = "SELECT count(*) FROM car_scrap WHERE car_no='"+gubun+"' AND (car_no_stat NOT LIKE '1' OR car_no_stat IS NULL)";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next()){
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ScrapDatabase:getScrapCheck(String gubun)]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	

	/**
    * 대폐차  등록 2005.1.4.화.
    */
	public int car_scrap_i(String car_no, String car_nm, String reg_dt, String car_ext){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "INSERT INTO car_scrap(seq, car_no, car_nm, reg_dt, car_ext) "+
				" SELECT nvl(lpad(max(seq)+1,6,'0'),'000001'),?,?, replace(?,'-',''),? FROM car_scrap ";
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_no);
			pstmt.setString(2, car_nm);
			pstmt.setString(3, reg_dt);
			pstmt.setString(4, car_ext);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

			System.out.println("[대폐차등록 - ScrapDatabase:car_scrap_i(car_no, car_nm, reg_dt)]");
			System.out.println("[car_no]"+car_no);
			System.out.println("[car_nm]"+car_nm);
			System.out.println("[reg_dt]"+reg_dt);
			System.out.println("[car_ext]"+car_ext);

		}catch(Exception e){
			System.out.println("[ScrapDatabase:car_scrap_i(car_no, car_nm, reg_dt)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	/**
	*	 대폐차 수정 2005.1.4.화.
	*/
	public int car_scrap_u(String seq, String car_no, String car_nm, String reg_dt, String car_ext){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
				
		query = " UPDATE car_scrap SET car_no=?, car_nm=?, reg_dt=?, car_ext=? WHERE seq=? ";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_no);
			pstmt.setString(2, car_nm);
			pstmt.setString(3, reg_dt);
			pstmt.setString(4, car_ext);
			pstmt.setString(5, seq);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(Exception e){
			System.out.println("[ScrapDatabase:car_scrap_u(seq, car_no, car_nm, reg_dt)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	/**
	*	 대폐차 삭제 2005.1.4.화.
	*/
	public int car_scrap_d(String seq){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
				
		query = " DELETE car_scrap WHERE seq=? ";
		
		try{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, seq);
			result = pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
		}catch(SQLException e){
			System.out.println("[ScrapDatabase:car_scrap_D(seq)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	
	//자동차번호 목록 조회
	public Vector getNewCarNumList(String car_no_stat, String car_no_leng, String car_ext, String searchStat, String rent_l_cd, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " SELECT a.seq, a.car_no, a.car_nm, a.reg_dt, a.car_ext, a.end_dt, a.car_no_stat, a.rent_l_cd, a.upd_dt, "+
				"        decode(a.auto_yn,'Y','자동','N','지정','') as auto_yn, "+
				"		 a.keep_yn, a.keep_etc, a.new_license_plate_yn "+
				" 	FROM   car_scrap a "+
				" 	WHERE  1=1 ";  
		if(car_no_stat.equals("1"))			{ 	query +=		" AND a.car_no_stat = '1'";		}
		else if(car_no_stat.equals("2"))	{	query +=    	" AND (a.car_no_stat = '2' OR a.car_no_stat = '3')";	}
		
		//차량번호 자리수 검색 추가(20190813)
		if(!car_no_leng.equals("")){
			if(car_no_leng.equals("7")){			query += "	AND LENGTH(a.car_no) = '7' ";		}
			else if(car_no_leng.equals("8")){		query += "	AND LENGTH(a.car_no) = '8' ";		}
		}
		
		if(car_ext != null && !car_ext.equals(""))	{	query += " AND car_ext like '%" +car_ext+ "%'";		}
		
		if(searchStat.equals("1")){		query +=	" AND a.rent_l_cd ='"+rent_l_cd+"'";		}
		if(searchStat.equals("2")){		query +=	" AND (a.rent_l_cd = '' OR a.rent_l_cd IS NULL )";		}
		if(searchStat.equals("3")){		query +=	" AND a.car_no = '"+car_no+"'";		}
		
		query += " ORDER BY car_no_stat, a.car_no, a.reg_dt desc";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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
			System.out.println("[ScrapDatabase:getNewCarNumList(String car_no_stat, String car_ext)]"+e);
			System.out.println("[ScrapDatabase:getNewCarNumList(String car_no_stat, String car_ext)]"+query);
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
	
	//자동차번호 목록 조회2 - 디테일
	public Vector getNewCarNumDetailList(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT distinct d.rent_l_cd, a.car_nm, d.reg_dt, e.user_nm reg_nm, f.car_num " +	//<--distinct 처리 (2017.12.15)
				" 	FROM car_mng a, car_etc b, car_nm c, cont d, users e, car_pur f " +	
				" 	WHERE a.car_comp_id = c.car_comp_id AND a.code = c.car_cd " +
				"     AND c.car_id = b.car_id " +
				"     AND b.rent_l_cd = d.rent_l_cd AND b.rent_l_cd = f.rent_l_cd" +
				"     AND d.bus_id = e.user_id " +
//				"     AND c.use_yn = 'Y' " +			//주석처리 (2017.12.15)
				"     AND b.rent_l_cd = '" +rent_l_cd+"'"+
				" ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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
			System.out.println("[ScrapDatabase:getNewCarNumDetailList(String rent_l_cd)]"+e);
			System.out.println("[ScrapDatabase:getNewCarNumDetailList(String rent_l_cd)]"+query);
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
	
	//자동차번호 목록 조회3 - 신규자동차번호 목록 조회(검색기능 및 쿼리조건이 추가되서 새로 작성(기존것도 사용!!))
	public Vector getNewCarNumList2(String sch_car_ext, String sch_reg_dt_str, String sch_reg_dt_end, String sch_end_dt_str, String sch_end_dt_end, String car_no_leng)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " SELECT * FROM " +
				"      (	SELECT a.seq, a.car_no, a.car_nm, a.reg_dt, a.car_ext, a.end_dt, a.car_no_stat, a.rent_l_cd, a.upd_dt, "+
				" 				   decode(c.use_yn,'N','해지',DECODE(a.auto_yn,'Y','자동','N','지정','')) as auto_yn, "+
				"				   a.keep_yn, a.keep_etc, a.new_license_plate_yn "+
				" 			  FROM car_scrap a, car_reg b, cont c " +
				"			  WHERE  a.car_no_stat = '1' " +
				"			    AND ((a.rent_l_cd IS NOT NULL OR a.rent_l_cd <> '') AND (b.init_reg_dt IS NULL OR b.init_reg_dt ='') AND a.car_no = b.car_no(+)) " +
				" 				AND a.rent_l_cd = c.rent_l_cd " +
				"			UNION ALL " + 
				"			SELECT a.seq, a.car_no, a.car_nm, a.reg_dt, a.car_ext, a.end_dt, a.car_no_stat, a.rent_l_cd, a.upd_dt, " + 
				"			 	   decode(a.auto_yn,'Y','자동','N','지정','') as auto_yn, " +
				"				   a.keep_yn, a.keep_etc, a.new_license_plate_yn "+
				"			  FROM car_scrap a " + 
				"			  WHERE  a.car_no_stat = '1' " + 
				"			    AND a.rent_l_cd IS  NULL " + 
				"      	)WHERE 1=1" ;
		
		if(!sch_car_ext.equals(""))	{	query += "	AND car_ext = '" + sch_car_ext + "'";	}
		if(!sch_reg_dt_str.equals("") &&  sch_reg_dt_end.equals(""))	{	query += "	AND reg_dt >= replace('" + sch_reg_dt_str + "','-','')" ;	}
		if( sch_reg_dt_str.equals("") && !sch_reg_dt_end.equals(""))	{	query += "	AND reg_dt <= replace('" + sch_reg_dt_end + "','-','')" ;	}
		if(!sch_reg_dt_str.equals("") && !sch_reg_dt_end.equals(""))	{	query += "	AND reg_dt between replace('" + sch_reg_dt_str + "','-','') and replace('" + sch_reg_dt_end +"','-','')" ;	}
		if(!sch_end_dt_str.equals("") &&  sch_end_dt_end.equals(""))	{	query += "	AND end_dt >= replace('" + sch_end_dt_str + "','-','')" ;	}
		if( sch_end_dt_str.equals("") && !sch_end_dt_end.equals(""))	{	query += "	AND end_dt <= replace('" + sch_end_dt_end + "','-','')" ;	}
		if(!sch_end_dt_str.equals("") && !sch_end_dt_end.equals(""))	{	query += "	AND end_dt between replace('" + sch_end_dt_str + "','-','') and replace('" + sch_end_dt_end +"','-','')" ;	}
		if(!car_no_leng.equals("")){
			if(car_no_leng.equals("7")){			query += "	AND LENGTH(car_no) = '7' ";		}
			else if(car_no_leng.equals("8")){		query += "	AND LENGTH(car_no) = '8' ";		}
		}
		
		query += "	ORDER BY DECODE(car_ext, '인천',1,'부산',2,'대전',3,'대구',4,'포천',5,'파주',6,7), car_no " ; 
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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
			System.out.println("[ScrapDatabase:getNewCarNumList2()]"+e);
			System.out.println("[ScrapDatabase:getNewCarNumList2()]"+query);
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
	
	
	//신규자동차번호 사용등록
	public int newCarNumReg(String car_num, String reg_dt, String end_dt, String car_ext){
		
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "INSERT INTO car_scrap(seq, car_no, reg_dt, end_dt, car_no_stat, car_ext) "+
				"	SELECT nvl(lpad(max(seq)+1,6,'0'),'000001'),?, replace(?,'-',''), replace(?,'-',''), '1', ? FROM car_scrap ";
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_num);
			pstmt.setString(2, reg_dt);
			pstmt.setString(3, end_dt);
			pstmt.setString(4, car_ext);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		}catch(Exception e){
			System.out.println("[ScrapDatabase:newCarNumReg(String car_num, String reg_dt, String end_dt)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	
	//car_scrap에 차량-번호 매핑 전 매핑유무 체크 
	public int getCarNoMappingYn(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int resultCnt = 0;
		String query = "";		
		query = " SELECT COUNT(*) FROM CAR_scrap WHERE car_no = '"+ car_no +"' AND rent_l_cd IS NOT NULL";
					
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				resultCnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScrapDatabase:getCarNoMappingYn]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return resultCnt;
		}
	}
	
	//car_scrap에 차량-번호 매핑 전 매핑유무 체크(자기 자신의 계약은 제외)		2017.12.12
	public int getCarNoMappingYn2(String car_no, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int resultCnt = 0;
		String query = "";		
		query = " SELECT COUNT(*) FROM CAR_SCRAP WHERE car_no = '"+ car_no +"' AND rent_l_cd <> '"+ rent_l_cd +"'";
					
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				resultCnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScrapDatabase:getCarNoMappingYn]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return resultCnt;
		}
	}
	
	//car_scrap에 차량-번호 매핑 전 매핑유무 체크 
	public String getCarNoMappingInfo(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String resultRent_l_cd = "";
		String query = "";		
		query = " SELECT rent_l_cd FROM CAR_SCRAP WHERE car_no = '"+ car_no +"'";
					
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				resultRent_l_cd = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScrapDatabase:getCarNoMappingInfo]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return resultRent_l_cd;
		}
	}
	
	//납품관리 수정시 car_scrap 테이블에도 update 해줌. (계약관계 연동을 위해..)
	public int updateCarScrap(String query)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		    count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[ScrapDatabase:updateCarScrap(String query)]\n"+e);
			System.out.println("[ScrapDatabase:updateCarScrap(String query)]\n"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
	//car_scrap 테이블 배정구분 상태 수정
	public int updateCarNoStat(String car_no_stat, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int count = 0;

		query = " UPDATE car_scrap SET car_no_stat = '"+ car_no_stat +"' WHERE seq = '"+ seq +"'";		
		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
		    count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ScrapDatabase:updateCarNoStat(String seq, String car_no_stat)]\n"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
	//차량번호-계약 맞바꾸기1
	public int changeCarNoMapping1(String car_no, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int count = 0;
		
		query = " UPDATE car_pur SET est_car_no =replace('"+car_no+"','-','') WHERE rent_l_cd='"+rent_l_cd+"'";

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
		    count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ScrapDatabase:changeCarNoMapping1(String car_no, String rent_l_cd)]\n"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
	//차량번호-계약 맞바꾸기2
	public int changeCarNoMapping2(String car_no, String rent_l_cd, String car_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int count = 0;
		
		query = " UPDATE car_scrap SET rent_l_cd ='"+rent_l_cd+"', car_nm = '"+car_nm+"',"+
				 " upd_dt = to_char(sysdate,'YYYYMMDD'), auto_yn = 'N'"+
				 " WHERE car_no='"+car_no+"'";
		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
		    count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ScrapDatabase:changeCarNoMapping2(String car_no, String rent_l_cd, String car_nm)]\n"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
	//납품관리
	public Hashtable getCarExtCount()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";

		query = " SELECT COUNT(*) AS cnt, "+
				" 		 SUM(DECODE(car_ext, '인천', 1, 0)) AS cnt1, "+
				" 		 SUM(DECODE(car_ext, '부산', 1, 0)) AS cnt2, "+
				" 		 SUM(DECODE(car_ext, '대전', 1, 0)) AS cnt3, "+
				" 		 SUM(DECODE(car_ext, '대구', 1, 0)) AS cnt4, "+
				" 		 SUM(DECODE(car_ext, '포천', 1, 0)) AS cnt5, "+
				" 		 SUM(DECODE(car_ext, '파주', 1, 0)) AS cnt6 "+
				" 	FROM car_scrap WHERE rent_l_cd IS NULL ";
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScrapDatabase:getCarExtCount]"+ e);
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
	
	//차량번호-계약 매핑삭제(2018.01.31)
	public int dropContMapping(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int count = 0;
		
		query = " UPDATE car_scrap SET rent_l_cd ='', car_nm = '',"+
				 " upd_dt = to_char(sysdate,'YYYYMMDD'), auto_yn = ''"+
				 " WHERE car_no='"+car_no+"'";
		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
		    count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[ScrapDatabase:dropContMapping(String car_no)]\n"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
	//계약 해지된 차량 검색 - 디테일(2018.01.31)
	public Hashtable getContListOne(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * FROM cont " +	
				" 	WHERE rent_l_cd ='"+rent_l_cd +"'";
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScrapDatabase:getContListOne(String rent_l_cd)]"+e);
			System.out.println("[ScrapDatabase:getContListOne(String rent_l_cd)]"+query);
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
	
	//신규자동차번호관리 1건조회 (20190813)
	public Hashtable getOneCarScrap(String seq, String car_no){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * FROM car_scrap WHERE car_no='"+car_no+"'";
		if(!seq.equals("")){	query += " AND seq = '"+seq+"'";			}
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScrapDatabase:getOneCarScrap(String seq, String car_no)]"+e);
			System.out.println("[ScrapDatabase:getOneCarScrap(String seq, String car_no)]"+query);
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
	
	//신규자동차번호관리 1건 수정(keep_yn, keep_etc) (20190813) / 신형번호판 여부 추가 (20201207)
	public int updateOneCarScrap(String seq, String car_no, String gubun, String etc, String mode) {
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
				
		query = " UPDATE car_scrap SET ";	
		
		if(mode.equals("keep_yn")){				query += " keep_yn = '"+gubun+"' ";	}
		else if(mode.equals("keep_etc")){		query += " keep_etc = '"+etc+"' ";	}
		else if(mode.equals("new_license_plate_yn")){	query += " new_license_plate_yn = '"+gubun+"' ";	}
		
		query += " WHERE seq='"+seq+"' and car_no='"+car_no+"'";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		}catch(Exception e){
			System.out.println("[getOneCarScrap(]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
}
