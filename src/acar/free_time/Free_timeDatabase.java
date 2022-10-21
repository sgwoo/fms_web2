/**
 * 연차관리
 * @ author : Ryu Gill Sun
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 03. 27
 * @ last modify date : 
 */

package acar.free_time;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.text.*;
import acar.database.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.tour.TourBean;
import acar.exception.DatabaseException;

public class Free_timeDatabase
{
	private Connection conn = null;
	public static Free_timeDatabase db;
	
	public static Free_timeDatabase getInstance()
	{
		if(Free_timeDatabase.db == null)
			Free_timeDatabase.db = new Free_timeDatabase();
		return Free_timeDatabase.db;
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



    /**
     * 일정전체조회
     */

public Vector Free_List(String st_year, String st_mon, String user_id, String gubun, String dt, String gubun3, String ref_dt1, String ref_dt2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		  query = " select c.cm_check c_check, a.cm_check, a.work_id, a.doc_no, a.user_id USER_ID, a.start_date START_DATE, a.end_date END_DATE, \n " 
				+ " a.title TITLE, a.cancel, \n"
				+ " a.content CONTENT, a.reg_dt REG_DT, b.user_nm USER_NM, a.sch_kd SCH_KD, a.sch_chk SCH_CHK, a.sch_file SCH_FILE, decode(to_char( to_date(a.start_date), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm, decode(to_char( to_date(a.end_date), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm2 , b.user_nm \n"
        		+ " from \n"
				+ " (select work_id, cm_check, user_id, start_date, end_date, title, content, reg_dt, sch_kd, cancel, \n"
				+ " decode(sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상휴가') as sch_chk, sch_file, doc_no \n"
        		+ " from free_time \n"
				+ " ) a, \n"
				+ " users b, free_cancel c \n"
				+ " where a.user_id=b.user_id and a.doc_no = c.doc_no(+) and b.use_yn = 'Y' \n";
			
			//구분
		//	if(gubun.equals("1")) query += " and a.cm_check is null \n";
		//	if(gubun.equals("2")) query += " and a.cm_check is not null  and a.cancel is null \n";
		//	if(gubun.equals("3")) query += " and a.cm_check is not null  and a.cancel is not null \n";
			
			//당월조회 (당월이후)
			if(dt.equals("1")) query += " and  ( substr(replace(a.start_date,'-',''), 1, 6) >= substr(to_char(sysdate,'YYYYMMDD'), 1,6)    or  substr(replace(a.start_date,'-',''), 1, 8) >= substr(to_char(sysdate -1, 'yyyymmdd'), 1, 8)  )   \n";			
		//	if(dt.equals("1")) query += " and substr(replace(a.start_date,'-',''), 1, 6) >= substr(to_char(sysdate,'YYYYMMDD'), 1,6)  \n";

			//월별조회
			if(dt.equals("2")){					
			
				query += " and substr(a.start_date, 1,4) = '"+st_year+"' \n";

				if(st_mon.equals("1"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("2"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("3"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("4"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("5"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("6"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("7"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("8"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("9"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("10"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("11"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("12"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				}

			//조회기간
			if(dt.equals("3")){
				if(!ref_dt1.equals("") && !ref_dt2.equals(""))		query += " and replace(a.start_date,'-','') between '"+ref_dt1+"' and '"+ref_dt2+"' ";
				if(!ref_dt1.equals("") && ref_dt2.equals(""))		query += " and replace(a.start_date,'-','') = '"+ref_dt1+"'";
			}

			//휴가구분
			if(gubun3.equals("1")) query += " and a.sch_chk = '연차' \n";
			if(gubun3.equals("2")) query += " and a.sch_chk = '병가' \n";
			if(gubun3.equals("3")) query += " and a.sch_chk = '경조사' \n";
			if(gubun3.equals("4")) query += " and a.sch_chk = '공가' \n";
			if(gubun3.equals("5")) query += " and a.sch_chk = '포상휴가' \n";
			if(gubun3.equals("6")) query += " and a.sch_chk = '출산휴가' \n";
			if(gubun3.equals("8")) query += " and a.sch_chk  like  '%휴직%' \n";


			query += " order by a.cm_check desc,  a.cancel asc, a.start_date desc ";

//System.out.println("Free_List="+query);

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Free_List]"+e);
			System.out.println("[Free_timeDatabase:Free_List]"+query);
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
	 * 일정전체조회2 - gubun2(조건 검색 추가) (2018.02.13)
	 */
	public Vector Free_List(String st_year, String st_mon, String user_id, String gubun, String dt, String gubun2, String gubun2_word, String gubun3, String ref_dt1, String ref_dt2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		  query = " select c.cm_check c_check, a.cm_check, a.work_id, a.doc_no, a.user_id USER_ID, a.start_date START_DATE, a.end_date END_DATE, \n " 
				+ " a.title TITLE, a.cancel, \n"
				+ " a.content CONTENT, a.reg_dt REG_DT, b.user_nm USER_NM, a.sch_kd SCH_KD, a.sch_chk SCH_CHK, a.sch_file SCH_FILE, decode(to_char( to_date(a.start_date), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm, decode(to_char( to_date(a.end_date), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm2 , b.user_nm \n"
	    		+ " from \n"
				+ " (select work_id, cm_check, user_id, start_date, end_date, title, content, reg_dt, sch_kd, cancel, \n"
				+ " decode(sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상휴가') as sch_chk, sch_file, doc_no \n"
	    		+ " from free_time \n"
				+ " ) a, \n"
				+ " users b, free_cancel c \n"
				+ " where a.user_id=b.user_id and a.doc_no = c.doc_no(+) and b.use_yn = 'Y' \n";
			
			//당월조회 (당월이후)
			if(dt.equals("1")) query += " and  ( substr(replace(a.start_date,'-',''), 1, 6) >= substr(to_char(sysdate,'YYYYMMDD'), 1,6)    or  substr(replace(a.start_date,'-',''), 1, 8) >= substr(to_char(sysdate -1, 'yyyymmdd'), 1, 8)  )   \n";			
		
			//월별조회
			if(dt.equals("2")){					
			
				query += " and substr(a.start_date, 1,4) = '"+st_year+"' \n";
	
				if(st_mon.equals("1"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("2"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("3"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("4"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("5"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("6"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("7"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("8"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("9"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("10"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("11"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("12"))			query += " and to_number(substr(a.start_date, 5,2)) = '"+st_mon+"' \n";
				}
	
			//조회기간
			if(dt.equals("3")){
				if(!ref_dt1.equals("") && !ref_dt2.equals(""))		query += " and replace(a.start_date,'-','') between '"+ref_dt1+"' and '"+ref_dt2+"' ";
				if(!ref_dt1.equals("") && ref_dt2.equals(""))		query += " and replace(a.start_date,'-','') = '"+ref_dt1+"'";
			}
			
			//조건 조회 추가
			if(!gubun2_word.equals("")){
				if(gubun2.equals("user_nm")) query += " and b.user_nm like '%"+gubun2_word+"%' \n";
			}
	
			//휴가구분
			if(gubun3.equals("1")) query += " and a.sch_chk = '연차' \n";
			if(gubun3.equals("2")) query += " and a.sch_chk = '병가' \n";
			if(gubun3.equals("3")) query += " and a.sch_chk = '경조사' \n";
			if(gubun3.equals("4")) query += " and a.sch_chk = '공가' \n";
			if(gubun3.equals("5")) query += " and a.sch_chk = '포상휴가' \n";
			if(gubun3.equals("6")) query += " and a.sch_chk = '출산휴가' \n";
			if(gubun3.equals("8")) query += " and a.sch_chk  like  '%휴직%' \n";
	
			query += " order by a.cm_check desc,  a.cancel asc, a.start_date desc ";
			
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Free_List]"+e);
			System.out.println("[Free_timeDatabase:Free_List]"+query);
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
     * 일정세부조회
     */

    public Vector Free_per(String user_id, String doc_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
query = " SELECT   \n"+
		"  a.work_id, a.user_id USER_ID, a.start_date START_DATE, \n"+
		" a.end_date END_DATE, a.title TITLE, a.content CONTENT, a.ov_yn OV_YN, \n"+
		" a.reg_dt as reg_dt2, DECODE(a.reg_dt,'','',SUBSTR(a.reg_dt,1,4)||'-'||SUBSTR(a.reg_dt,5,2)||'-'||SUBSTR(a.reg_dt,7,2)) as  REG_DT, b.user_nm USER_NM, a.sch_kd SCH_KD, \n"+
		" DECODE(a.title, '연차', 1 ,'본인결혼' , 7 ,'자녀결혼' , 2 ,'부모결혼', 1 ,'형제결혼', 2 ,'훈련', 1 ,'포상휴가', '' ,'부모회갑', 1 ,'본인출산', 90 ,'배우자출산', 3 ,'부모사망', 5 ,'배우자부모사망', 5 ,'배우자사망', 7 ,'조부모사망', 5 ,'형제/자매사망',5, '동원훈련','3' ) FREE_DATE, \n"+
	    " a.sch_chk SCH_CHK, decode( to_char( to_date( a.start_date,'YYYYMMDD' ), 'd' ), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일',  '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm, sch_file, \n"+
	    " decode( to_char( to_date( a.end_date,'YYYYMMDD' ), 'd' ), '1', '일요일','2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm2, b.br_id, b.addr, \n"+
	    " decode( b.br_id, 'S1', '본사', 'B1', '부산', 'D1', '대전', 'S2','강남','J1','광주','G1','대구','I1','인천','S3','강서','S4','구로','U1','울산','S5','종로','S6','송파' ) br_nm, b.dept_id, \n"+
	     "   c.nm dept_nm,  \n"+
	    " b.id, b.user_nm, b.user_h_tel,  b.user_m_tel,  a.s_check, a.cm_check , \n"+
	   	" TRUNC(MONTHS_BETWEEN(to_date(a.end_date, 'YYYY/MM/DD hh24:mi:ss'), to_date(a.start_date, 'YYYY/MM/DD hh24:mi:ss')) * 31) +1 as DAY , d.user_nm2, d.user_id2, d.user_dt2, d.user_nm7, d.user_id7, d.user_dt7"+
		" FROM free_time a, users b, doc_settle d , code c \n"+  // 여기서 부터
		" where a.user_id= '"+user_id+"' and a.doc_no = '"+doc_no+"' and a.doc_no = d.doc_id and d.doc_st in '21'   and c.c_st='0002' and c.code=b.dept_id  and a.user_id=b.user_id(+)  \n";

//System.out.println("Free_per="+query);

      
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Free_per]"+e);
			System.out.println("[Free_timeDatabase:Free_per]"+query);
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
     * 일정세부조회
     */

    public Hashtable  getFree_work( String user_id,  String doc_no)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


		query = "select a.work_id, b.id w_id, b.user_h_tel work_tel, b.USER_NM WORK_NM,   c.nm  work_dept \n"
		        +" from free_time a, users b, code c  "
				+"where a.user_id= '"+user_id+"' and a.doc_no = '"+doc_no+"' and c.c_st='0002' and c.code=b.dept_id   and a.work_id=b.user_id(+)";
      
		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Free_Work]\n"+e);			
			System.out.println("[Free_timeDatabase:Free_Work]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	
	}	

	
	public Vector Free_item(String user_id, String doc_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = "select b.*, a.title, a.cm_check, a.s_check, decode(to_char( to_date(b.free_dt), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm \n"
		        +" from free_time a, free_time_item b "
				+"where a.user_id= '"+user_id+"' and a.doc_no = '"+doc_no+"' and a.user_id = b.user_id and a.doc_no = b.doc_no order by b.free_dt ";
      
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Free_item]"+e);
			System.out.println("[Free_timeDatabase:Free_item]"+query);
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
     * 스케쥴등록
     */

public String InsertFree(Free_timeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		
		String doc_no = "";


		int seq = 0;

 	  	query_seq = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(doc_no,9,4))+1), '0000')), '0001') doc_no "//nvl(max(seq)+1, 1), 
				   +" from free_time where doc_no LIKE to_char(sysdate,'YYYYMMDD')||'%'";

		 query="INSERT INTO free_time(USER_ID, DOC_NO, START_DATE, TITLE, CONTENT, REG_DT, SCH_KD, SCH_ST, SCH_CHK, WORK_ID, SCH_FILE, END_DATE, CM_CHECK)\n"
                + "values(?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, replace(?, '-', ''), ? )";

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
				doc_no = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setString(2, doc_no);
			pstmt.setString(3, bean.getStart_date());
			pstmt.setString(4, bean.getTitle());
			pstmt.setString(5, bean.getContent());
			pstmt.setString(6, bean.getSch_kd());
			pstmt.setString(7, bean.getSch_st());
			pstmt.setString(8, bean.getSch_chk());
			pstmt.setString(9, bean.getWork_id());
			pstmt.setString(10, bean.getSch_file());
			pstmt.setString(11, bean.getEnd_date());
			pstmt.setString(12, bean.getCm_check());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:InsertFree]\n"+e);
			System.out.println("[Free_timeDatabase:InsertFree]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return doc_no;
		}
	}


	/**
	 *	연차신청 팀장 승인
	 */


	public int S_check(Free_timeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

		query = " update free_time set\n"+
				" s_check = ? \n"+
				" where user_id=? and doc_no=?";		

		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getS_check());
			pstmt.setString(2, bean.getUser_id());
			pstmt.setString(3, bean.getDoc_no());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:S_check]\n"+e);
			System.out.println("[Free_timeDatabase:S_check]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
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
	
	public boolean InsertFreeItem(String doc_no, String user_id,  String free_dt, String count)
	{
		getConnection();
		PreparedStatement pstmt = null;	
		String query = "";
		boolean flag = true;		
	 	 

		 query="INSERT INTO free_time_item(USER_ID, DOC_NO, FREE_DT, reg_dt, count )\n"
                + "values(?, ?, replace(?, '-', ''), to_char(sysdate,'YYYYMMdd'), ?  )";



		try 
		{			
			conn.setAutoCommit(false);		 		
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, user_id);
			pstmt.setString(2, doc_no);
			pstmt.setString(3, free_dt);
			pstmt.setString(4, count);
					
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:InsertFreeItem]\n"+e);
			System.out.println("[Free_timeDatabase:InsertFreeItem]\n"+query);
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
	 *	총무팀장결재
	 */

	public int UpdateFreeCm_check(Free_timeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
	
		int seq = 0;

		query = " update free_time set\n"+
				" cm_check = ? \n"+
				" where user_id=? and doc_no=?";		

		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getCm_check());
			pstmt.setString(2, bean.getUser_id());
			pstmt.setString(3, bean.getDoc_no());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:UpdateFreeCm_check]\n"+e);
			System.out.println("[Free_timeDatabase:UpdateFreeCm_check]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
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


	/**
	 *	연차등록 삭제
	 */

	public int Free_del(Free_timeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";
		String query1 = "";
		String query2 = "";

		int cnt= 0;

		query = " DELETE  FROM free_time  where user_id=? and doc_no=?";					
				
		query1 = " DELETE  FROM free_time_item  where user_id=? and doc_no=?";
				
		query2 = " select count(*)  FROM free_time_item  where user_id= ? and doc_no=?";	
			

//System.out.println("Free_del="+query);

		try 
		{			
		
			conn.setAutoCommit(false);
		
							
			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, bean.getUser_id());
			pstmt2.setString(2, bean.getDoc_no());								 
	    	rs = pstmt2.executeQuery();	    
            if(rs.next())
				cnt = rs.getInt(1);
				
            rs.close();
			pstmt2.close();
			
			if (cnt > 0) {	
							
				pstmt1 = conn.prepareStatement(query1);	
				pstmt1.setString(1, bean.getUser_id());
				pstmt1.setString(2, bean.getDoc_no());				
				count = pstmt1.executeUpdate();
				pstmt1.close();
			}
			
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getUser_id());
			pstmt.setString(2, bean.getDoc_no());			
			count = pstmt.executeUpdate();
			pstmt.close();
						
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Free_del]\n"+e);
			System.out.println("[Free_timeDatabase:Free_del]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
              	if(pstmt != null)	pstmt.close();
              	if(pstmt1 != null)	pstmt1.close();
              	if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	/**
	 *	연차등록 수정
	 */

	public int UpdateFree(Free_timeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

		query = " update free_time set\n"+
				" start_date = ?, \n"+
				" end_date = ?, \n"+
				" title = ?, \n"+
				" content = ?, \n"+
				" sch_kd = ?, \n"+
				" sch_st = ?, \n"+
				" sch_chk = ?, \n"+
				" work_id = ?, \n"+
				" sch_file = ? \n"+
				" where user_id=? and doc_no = ?";		


		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getStart_date());
			pstmt.setString(2, bean.getEnd_date());
			pstmt.setString(3, bean.getTitle());
			pstmt.setString(4, bean.getContent());
			pstmt.setString(5, bean.getSch_kd());
			pstmt.setString(6, bean.getSch_st());
			pstmt.setString(7, bean.getSch_chk());
			pstmt.setString(8, bean.getWork_id());
			pstmt.setString(9, bean.getSch_file());
			pstmt.setString(10, bean.getUser_id());
			pstmt.setString(11, bean.getDoc_no());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:UpdateFree]\n"+e);
			System.out.println("[Free_timeDatabase:UpdateFree]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
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


	/**
     * 연차취소 등록
     */

	public int InsertCancelFree(Free_CancelBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		
		int can_seq = 0;

		query_seq = " select nvl(max(can_seq)+1, 1) from free_cancel ";	

		 query=" INSERT INTO free_cancel( " +
			   " DOC_NO, CAN_SEQ, USER_ID, REG_DT, CANCEL_DT, "+
			   " CANCEL_TIT, CANCEL_CMT, CM_CHECK )\n"+
               " values( " +
			   " ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, " +
 			   " ?, ?, ?)";


		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
				can_seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getDoc_no());
			pstmt.setInt   (2, can_seq);	
			pstmt.setString(3, bean.getUser_id());
			pstmt.setString(4, bean.getCancel_dt());
			pstmt.setString(5, bean.getCancel_tit());
			pstmt.setString(6, bean.getCancel_cmt());
			pstmt.setString(7, bean.getCm_check());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

			} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:InsertCancelFree]\n"+e);
			System.out.println("[Free_timeDatabase:InsertCancelFree]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	/**
	 *	총무팀장결재
	 */

	public int UpdateCancel(Free_timeBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";


		query = " update free_time set\n"+
				" cancel = ? \n"+
				" where user_id=? and doc_no=?";		


		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getCancel());
			pstmt.setString(2, bean.getUser_id());
			pstmt.setString(3, bean.getDoc_no());
			count2 = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:UpdateCancel]\n"+e);
			System.out.println("[Free_timeDatabase:UpdateCancel]\n"+query);
	  		e.printStackTrace();
	  		count2 = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}


	 /**
     * 일정세부조회
     */

    public Vector Free_CancelList(String user_id, String doc_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	query = " select a.reg_dt, a.user_id, a.doc_no, a.start_date, a.end_date, b.cancel_tit, b.cancel_cmt, c.user_nm, c.dept_id, b.cm_check, \n"+
			"  e.nm  dept_nm , d.user_id2, d.user_dt2, d.user_nm2,d.user_id3, d.user_dt3, d.user_nm3 "+
			" from free_time a, free_cancel b, users c , doc_settle d , code e "+
			" where b.user_id= '"+user_id+"' and b.doc_no = '"+doc_no+"' and a.doc_no=b.doc_no and a.doc_no = d.doc_id and d.doc_st in '22'    and e.c_st='0002' and e.code=c.dept_id   and a.user_id = c.user_id \n";



      
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Free_CancelList]"+e);
			System.out.println("[Free_timeDatabase:Free_CancelList]"+query);
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
	
	public int Cancel_free(String user_id, String start_date, String end_date)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";
		
		query = " DELETE  FROM sch_prv \n"+
				" where user_id='"+user_id+"' and start_year || start_mon || start_day  between replace('"+start_date+"', '-','') and replace('"+end_date+"', '-','') ";		


		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Cancel_free]\n"+e);
			System.out.println("[Free_timeDatabase:Cancel_free]\n"+query);
	  		e.printStackTrace();
	  		count2 = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}
	
	public int Cancel_free(String user_id, String start_date, String end_date, String doc_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";
		
		query = " DELETE  FROM sch_prv \n"+
				" where user_id='"+user_id+"' and nvl(doc_no,'"+doc_no+"')='"+doc_no+"' and start_year || start_mon || start_day  between replace('"+start_date+"', '-','') and replace('"+end_date+"', '-','') ";		


		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Cancel_free]\n"+e);
			System.out.println("[Free_timeDatabase:Cancel_free]\n"+query);
	  		e.printStackTrace();
	  		count2 = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}	

	//  count :년차 :F, 오전반차 :B1, 오후반차:B2 
	public boolean  Cancel_free_time(String user_id, String start_date, String count)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";
		boolean flag = true;
		
		query = " DELETE  FROM sch_prv \n"+
				" where user_id='"+user_id+"' and start_year || start_mon || start_day  =  replace('"+start_date+"', '-','') and  count='" + count + "' ";		
		
		
		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  }
	   	catch (Exception e)
	  	{
		  	System.out.println("[Free_timeDatabase:Cancel_free_time]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	//  count :년차 :F, 오전반차 :B1, 오후반차:B2 
	public boolean  Cancel_free_time(String user_id, String start_date, String count, String doc_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";
		boolean flag = true;
		
		query = " DELETE  FROM sch_prv \n"+
				" where user_id='"+user_id+"' and nvl(doc_no,'"+doc_no+"')='"+doc_no+"' and start_year || start_mon || start_day  =  replace('"+start_date+"', '-','') and  count='" + count + "' ";		
		
		
		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  }
	   	catch (Exception e)
	  	{
		  	System.out.println("[Free_timeDatabase:Cancel_free_time]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}		
	
			
	public boolean UpdateCancel_freetime(String doc_no, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";
				
		Vector vts = geFreeTimeLists(doc_no, user_id);
		int f_size = vts.size();
	 
	   
		int flag = 0;

		for(int i = 0 ; i < f_size ; i++)
			{
			FreetimeItemBean a_fl = (FreetimeItemBean)vts.elementAt(i);		
				
	       
			if(!Cancel_free_time( a_fl.getUser_id(), a_fl.getFree_dt(), a_fl.getCount(), doc_no ) )	flag += 1;
			
		}
						
		if(flag == 0)	return true;
		else 			return false;	
			
	}
	
	
	//free time detail
	public Vector geFreeTimeLists(String doc_no, String user_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
			
		query = " SELECT a.doc_no, a.free_dt, a.user_id ,a.count \n " +
				"  FROM free_time_item a " +
				" WHERE a.doc_no = ? and  a.user_id = ? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_no);
			pstmt.setString(2, user_id);
			rs = pstmt.executeQuery();
			
			while(rs.next())
			{
				FreetimeItemBean bean = new FreetimeItemBean();	
				bean.setDoc_no(rs.getString("DOC_NO")==null?"":rs.getString("DOC_NO"));
				bean.setUser_id(rs.getString("USER_ID")==null?"":rs.getString("USER_ID"));
				bean.setFree_dt(rs.getString("FREE_DT")==null?"":rs.getString("FREE_DT"));				
				bean.setCount(rs.getString("COUNT")==null?"":rs.getString("COUNT"));						
				vt.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
		  	System.out.println("[Free_timeDatabase:geFreeTimeLists]\n"+e);
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
	 *	연차신청내역중 급여관련 사항
	 */

	public boolean updateFreeItem(FreetimeItemBean bean)
	{		
	
		getConnection();
		PreparedStatement pstmt = null;	
		String query = "";
		boolean flag = true;	
	
		query = " update free_time_item set "+
				" ov_yn = ?,  mt_yn = ?, upd_dt = to_char(sysdate,'YYYYMMdd')  "+
				" where user_id=? and doc_no= ? and free_dt = replace(?, '-', '') ";		

		try 
		{			
						
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getOv_yn());
			pstmt.setString(2, bean.getMt_yn());
			pstmt.setString(3, bean.getUser_id());
			pstmt.setString(4, bean.getDoc_no());
			pstmt.setString(5, bean.getFree_dt());

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:updateFreeItem]\n"+e);
			System.out.println("[Free_timeDatabase:updateFreeItem]\n"+query);
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

	public int UpdateCancel_check(String doc_no, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";	

		query = " update free_cancel set\n"+
				" cm_check = 'Y' \n"+
				" where user_id=? and doc_no=?";		

//System.out.println("Cm_check="+query);
		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
		
			pstmt.setString(1, user_id);
			pstmt.setString(2, doc_no);

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:UpdateCancel_check]\n"+e);
			System.out.println("[Free_timeDatabase:UpdateCancel_check]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
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
	
	

//*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-//
	 /**
     * 유급휴가 현황
     */

public Vector Free_TotList_Y(String st_year, String st_mon, String dt, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subquery = "";


if(st_mon.equals("1") || st_mon.equals("2") || st_mon.equals("3") || st_mon.equals("4") || st_mon.equals("5") || st_mon.equals("6") || st_mon.equals("7") || st_mon.equals("8") || st_mon.equals("9")){
	st_mon = "0"+st_mon;
}

if(gubun.equals("31")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0003' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0003' ";

	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0003' ";
	}

}else if(gubun.equals("32")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0003' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0003' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0003' ";
	}

}else if(gubun.equals("51")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0005' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0005' ";

	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0005' ";
	}

}else if(gubun.equals("52")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0005' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0005' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0005' ";
	}

}else if(gubun.equals("11")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0001' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0001' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0001' ";
	}

}else if(gubun.equals("12")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0001' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0001' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0001' ";
	}

}else if(gubun.equals("41")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0020' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0020' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0020' ";
	}

}else if(gubun.equals("42")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0020' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0020' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0020' ";
	}

}else if(gubun.equals("21")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0002' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0002' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0002' ";
	}

}else if(gubun.equals("22")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0002' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0002' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0002' ";
	}

}else if(gubun.equals("71")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0007' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0007' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0007' ";
	}

}else if(gubun.equals("72")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0007' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0007' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0007' ";
	}

}else if(gubun.equals("81")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0008' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0008' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0008' ";
	}

}else if(gubun.equals("82")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0008' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0008' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0008' ";
	}

}else if(gubun.equals("91")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0009' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0009' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0009' ";
	}

}else if(gubun.equals("92")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0009' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0009' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0009' ";
	}

}else if(gubun.equals("101")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0010' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0010' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0010' ";
	}

}else if(gubun.equals("102")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0010' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0010' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0010' ";
	}

}else if(gubun.equals("111")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0011' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0011' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0011' ";
	}

}else if(gubun.equals("112")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0011' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0011' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0011' ";
	}

}else if(gubun.equals("121")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0012' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0012' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0012' ";
	}

}else if(gubun.equals("122")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0012' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0012' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0012' ";
	}

}else if(gubun.equals("131")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0013' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0013' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0013' ";
	}

}else if(gubun.equals("132")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0013' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0013' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0013' ";
	}

}else if(gubun.equals("141")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0014' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0014' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0014' ";
	}

}else if(gubun.equals("142")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0014' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0014' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0014' ";
	}

}else if(gubun.equals("151")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0015' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0015' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0015' ";
	}

}else if(gubun.equals("152")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0015' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0015' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0015' ";
	}

}else if(gubun.equals("161")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0016' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0016' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0016' ";
	}

}else if(gubun.equals("162")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0016' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0016' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0016' ";
	}

}else if(gubun.equals("171")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0017' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0017' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0017' ";
	}

}else if(gubun.equals("172")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0017' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0017' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0017' ";
	}
}else if(gubun.equals("181")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0018' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0018' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0018' ";
	}

}else if(gubun.equals("182")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0018' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0018' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0018' ";
	}
}

		  query = "SELECT '당일' as day, dept_id as dept_id_a, "+
					"sum( decode( hg, '3', 1 , 0 )) AA, "+
					"count(decode( hg, '3', 1 )) c_a, "+
					"sum( decode( hg, '51', 1 , 0 )) BB1, "+
					"count(decode( hg, '51', 1 )) c_b1, "+
					"sum( decode( hg, '52', 1 , 0 )) BB2, "+
					"count(decode( hg, '52', 1 )) c_b2, "+
					"sum( decode( hg, '53', 1 , 0 )) BB3, "+
					"count(decode( hg, '53', 1 )) c_b3, "+
					"sum( decode( hg, '6', 1 , 0 )) CC, "+
					"count(decode( hg, '6', 1 )) c_c, "+
					"sum( decode( hg, '7', 1 , 0 )) DD, "+
					"count(decode( hg, '7', 1 )) c_d, "+
					"sum( decode( hg, '9', 1 , 0 )) EE, "+
					"count(decode( hg, '9', 1 )) c_e, "+
					"count(hg) tot "+
					" FROM ( SELECT b.dept_id, a.start_year||a.start_mon||a.start_day as day, "+
					" 	   CASE "+
					" 	   WHEN a.sch_chk = '3' THEN '3' "+
					" 	   WHEN a.sch_chk = '4' THEN '51' "+
					"	   WHEN a.sch_chk = '5' THEN '52' "+
					" 	   WHEN a.sch_chk = '6' THEN '6' "+
					" 	   WHEN a.sch_chk = '7' THEN '7' "+
					" 	   WHEN a.sch_chk = '9' THEN '9' "+
					" 	   END hg "+
					" 	   FROM sch_prv a, users b "+
					" 	   WHERE a.USER_ID = b.USER_ID "+
					" 	   AND b.use_yn = 'Y' and nvl(a.ov_yn,'N') = 'N' and a.sch_chk in ('3','5','6','7','9', '4') ) "+subquery+"  ";
			query+= " GROUP BY dept_id ";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Free_TotList_Y]"+e);
			System.out.println("[Free_timeDatabase:Free_TotList_Y]"+query);
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
     * 무급휴가 현황
     */

public Vector Free_TotList_N(String st_year, String st_mon, String dt, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subquery = "";

if(st_mon.equals("1") || st_mon.equals("2") || st_mon.equals("3") || st_mon.equals("4") || st_mon.equals("5") || st_mon.equals("6") || st_mon.equals("7") || st_mon.equals("8") || st_mon.equals("9")){
	st_mon = "0"+st_mon;
}

if(gubun.equals("31")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0003' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0003' ";

	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0003' ";
	}

}else if(gubun.equals("32")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0003' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0003' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0003' ";
	}
}else if(gubun.equals("51")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0005' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0005' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0005' ";
	}

}else if(gubun.equals("52")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0005' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0005' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0005' ";
	}

}else if(gubun.equals("11")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0001' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0001' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0001' ";
	}

}else if(gubun.equals("12")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0001' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0001' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0001' ";
	}

}else if(gubun.equals("41")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0020' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0020' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0020' ";
	}

}else if(gubun.equals("42")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0020' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0020' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0020' ";
	}

}else if(gubun.equals("21")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0002' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0002' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0002' ";
	}

}else if(gubun.equals("22")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0002' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0002' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0002' ";
	}

}else if(gubun.equals("71")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0007' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0007' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0007' ";
	}

}else if(gubun.equals("72")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0007' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0007' ";
	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0007' ";
	}

}else if(gubun.equals("81")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0008' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0008' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0008' ";
	}

}else if(gubun.equals("82")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0008' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0008' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0008' ";
	}

}else if(gubun.equals("91")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0009' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0009' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0009' ";
	}

}else if(gubun.equals("92")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0009' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0009' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0009' ";
	}

}else if(gubun.equals("101")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0010' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0010' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0010' ";
	}

}else if(gubun.equals("102")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0010' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0010' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0010' ";
	}

}else if(gubun.equals("111")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0011' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0011' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0011' ";
	}

}else if(gubun.equals("112")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0011' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0011' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0011' ";
	}

}else if(gubun.equals("121")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0012' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0012' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0012' ";
	}

}else if(gubun.equals("122")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0012' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0012' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0012' ";
	}

}else if(gubun.equals("131")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0013' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0013' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0013' ";
	}

}else if(gubun.equals("132")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0013' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0013' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0013' ";
	}

}else if(gubun.equals("141")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0014' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0014' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0014' ";
	}

}else if(gubun.equals("142")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0014' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0014' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0014' ";
	}

}else if(gubun.equals("151")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0015' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0015' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0015' ";
	}

}else if(gubun.equals("152")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0015' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0015' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0015' ";
	}

}else if(gubun.equals("161")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0016' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0016' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0016' ";
	}

}else if(gubun.equals("162")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0016' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0016' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0016' ";
	}
}else if(gubun.equals("171")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0017' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0017' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0017' ";
	}

}else if(gubun.equals("172")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0017' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0017' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0017' ";
	}
}else if(gubun.equals("181")){
	if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0018' ";
	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0018' ";
	}else{
		subquery = " WHERE day = to_char( sysdate, 'yyyymmdd' ) and dept_id = '0018' ";
	}

}else if(gubun.equals("182")){
		if(!st_year.equals("")&&!st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 6) = '"+st_year+""+st_mon+"' and dept_id = '0018' ";

	}else if(!st_year.equals("")&&st_mon.equals("")){
		subquery = " WHERE substr(day, 0, 4) = '"+st_year+"' and dept_id = '0018' ";

	}else{
		subquery = " WHERE day = to_char( sysdate+1, 'yyyymmdd' ) and dept_id = '0018' ";
	}
}

		 query = "SELECT '당일' as day, dept_id as dept_id_a, "+
					"sum( decode( hg, '3', 1 , 0 )) AA, "+
					"count(decode( hg, '3', 1 )) c_a, "+
					"sum( decode( hg, '51', 1 , 0 )) BB1, "+
					"count(decode( hg, '51', 1 )) c_b1, "+
					"sum( decode( hg, '52', 1 , 0 )) BB2, "+
					"count(decode( hg, '52', 1 )) c_b2, "+
					"sum( decode( hg, '53', 1 , 0 )) BB3, "+
					"count(decode( hg, '53', 1 )) c_b3, "+
					"sum( decode( hg, '6', 1 , 0 )) CC, "+
					"count(decode( hg, '6', 1 )) c_c, "+
					"sum( decode( hg, '7', 1 , 0 )) DD, "+
					"count(decode( hg, '7', 1 )) c_d, "+
					"sum( decode( hg, '9', 1 , 0 )) EE, "+
					"count(decode( hg, '9', 1 )) c_e, "+
 					"sum( decode( hg, '8', 1 , 0 )) FF, "+
					"count(decode( hg, '8', 1 )) c_f, "+
					"count(hg) tot "+
					" FROM ( SELECT b.dept_id, a.start_year||a.start_mon||a.start_day as day, "+
					" 	   CASE "+
					" 	   WHEN a.sch_chk = '3' THEN '3' "+
					" 	   WHEN a.sch_chk = '4' THEN '51' "+
					"	   WHEN ( a.sch_chk = '5' and a.title = '기타') THEN '52' "+
					"	   WHEN ( a.sch_chk = '5' and a.title = '생리휴가') THEN '53' "+
					" 	   WHEN a.sch_chk = '6' THEN '6' "+
					" 	   WHEN a.sch_chk = '7' THEN '7' "+
					" 	   WHEN a.sch_chk = '9' THEN '9' "+
 					" 	   WHEN a.sch_chk = '8' THEN '8' "+
					" 	   END hg "+
					" 	   FROM sch_prv a, users b "+
					" 	   WHERE a.USER_ID = b.USER_ID "+
					" 	   AND b.use_yn = 'Y' and nvl(a.ov_yn,'N') = 'Y' and a.sch_chk in ('3','5','6','7','9', '4','8' ) ) "+subquery+"  ";
			query+= " GROUP BY dept_id ";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Free_TotList_Y]"+e);
			System.out.println("[Free_timeDatabase:Free_TotList_Y]"+query);
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
 * 휴가현황에서 클릭시 보여줄화면 
 */

public Vector Year_Mon_List(String br_id, String sch_chk, String day, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String today = "";

		if(day.equals("today")){
			today = " AND to_char(sysdate,'YYYYMMdd') BETWEEN a.start_date AND a.end_date"; 
		}else if(day.equals("nextday")){
			today = " AND TO_CHAR(sysdate+1, 'yyyymmdd') BETWEEN a.start_date AND a.end_date"; 
		}

  		  query = " select distinct hg, c.cm_check c_check, a.cm_check, a.work_id, a.doc_no, a.user_id USER_ID, a.start_date START_DATE, a.end_date END_DATE, \n " 
				+ " a.title TITLE, a.cancel, \n"
				+ " a.content CONTENT, a.reg_dt REG_DT, b.user_nm USER_NM, a.sch_kd SCH_KD, a.sch_chk SCH_CHK, a.sch_file SCH_FILE, decode(to_char( to_date(a.start_date), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm, decode(to_char( to_date(a.end_date), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm2 , b.user_nm \n"
        		+ " from \n"
				+ " (select work_id, cm_check, user_id, start_date, end_date, title, content, reg_dt, sch_kd, cancel, \n"
				+ " decode(sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상') as sch_chk2, sch_chk, sch_file, doc_no, \n"
				+ " CASE  WHEN sch_chk = '3' THEN '3'   WHEN  sch_chk = '4' THEN '51' WHEN  sch_chk = '5'	THEN '52' \n"
				+ " WHEN sch_chk = '6' THEN '6'  WHEN sch_chk = '7' THEN '7' WHEN sch_chk = '8' THEN '8' WHEN sch_chk = '9' THEN '9'   END hg \n"
        		+ " from free_time \n"
				+ " ) a, \n"
				+ " users b, free_cancel c, free_time_item d \n"
				+ " where a.user_id=b.user_id and a.doc_no = c.doc_no(+) and a.doc_no = d.doc_no(+) and b.dept_id = '"+br_id+"' and hg = '"+sch_chk+"' AND a.cancel is null /* and (a.start_date = "+today+" or a.end_date = "+today+" ) */ "+today+"\n";
			
		query += " order by a.cm_check desc,  a.cancel asc, a.start_date desc ";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Year_Mon_List]"+e);
			System.out.println("[Free_timeDatabase:Year_Mon_List]"+query);
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
 * 휴가현황에서 클릭시 보여줄화면 
 */

public Vector Year_Mon_List2(String br_id, String sch_chk, String year, String mon, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String today = "";

		if(!year.equals("") && !mon.equals("")){
				String m_date = "";

				if(mon.equals("1")){			m_date = year+"0"+mon;}
				if(mon.equals("2")){			m_date = year+"0"+mon;}
				if(mon.equals("3")){			m_date = year+"0"+mon;}
				if(mon.equals("4")){			m_date = year+"0"+mon;}
				if(mon.equals("5")){			m_date = year+"0"+mon;}
				if(mon.equals("6")){			m_date = year+"0"+mon;}
				if(mon.equals("7")){			m_date = year+"0"+mon;}
				if(mon.equals("8")){			m_date = year+"0"+mon;}
				if(mon.equals("9")){			m_date = year+"0"+mon;}
				if(mon.equals("10")){		m_date = year+mon;}
				if(mon.equals("11")){		m_date = year+mon;}
				if(mon.equals("12")){		m_date = year+mon;}
				
				//today = " and substr(a.start_date, 1,6) < = '"+m_date+"' \n";
				//today += " and substr(a.end_date, 1,6) > = '"+m_date+"' \n";
				
				today = " and substr(a.start_date, 1,6) = '"+m_date+"' \n";
				
		}else if(!year.equals("") && mon.equals("")){
			String m_date = "";

			    /*
				if(mon.equals("1")){			m_date = year+"0"+mon;}
				if(mon.equals("2")){			m_date = year+"0"+mon;}
				if(mon.equals("3")){			m_date = year+"0"+mon;}
				if(mon.equals("4")){			m_date = year+"0"+mon;}
				if(mon.equals("5")){			m_date = year+"0"+mon;}
				if(mon.equals("6")){			m_date = year+"0"+mon;}
				if(mon.equals("7")){			m_date = year+"0"+mon;}
				if(mon.equals("8")){			m_date = year+"0"+mon;}
				if(mon.equals("9")){			m_date = year+"0"+mon;}
				if(mon.equals("10")){		m_date = year+mon;}
				if(mon.equals("11")){		m_date = year+mon;}
				if(mon.equals("12")){		m_date = year+mon;}
				
				today = " and substr(a.start_date, 1,6) < = '"+m_date+"' \n";
				today += " and substr(a.end_date, 1,6) > = '"+m_date+"' \n";
				
				*/
			
				today = " and substr(a.start_date, 1,4) = '"+year+"' \n";				
		}

		  query = " select distinct hg, c.cm_check c_check, a.cm_check, a.work_id, a.doc_no, a.user_id USER_ID, a.start_date START_DATE, a.end_date END_DATE, \n " 
				+ " a.title TITLE, a.cancel, \n"
				+ " a.content CONTENT, a.reg_dt REG_DT, b.user_nm USER_NM, a.sch_kd SCH_KD, a.sch_chk SCH_CHK, a.sch_file SCH_FILE, decode(to_char( to_date(a.start_date), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm, decode(to_char( to_date(a.end_date), 'd'), '1', '일요일', '2', '월요일', '3', '화요일', '4', '수요일', '5', '목요일', '6', '금요일', '7', '토요일' ) day_nm2 , b.user_nm \n"
        		+ " from \n"
				+ " (select work_id, cm_check, user_id, start_date, end_date, title, content, reg_dt, sch_kd, cancel, \n"
				+ " decode(sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상') as sch_chk2, sch_chk, sch_file, doc_no, \n"
				+ " CASE  WHEN sch_chk = '3' THEN '3'   WHEN  sch_chk = '4'  THEN '51' WHEN  sch_chk = '5'	THEN '52' \n"
				+ " WHEN sch_chk = '6' THEN '6'  WHEN sch_chk = '7' THEN '7'  WHEN sch_chk = '8' THEN '8' WHEN sch_chk = '9' THEN '9'   END hg \n"
        		+ " from free_time \n"
				+ " ) a, \n"
				+ " users b, free_cancel c, free_time_item d \n"
				+ " where a.user_id=b.user_id and a.doc_no = c.doc_no(+) and a.doc_no = d.doc_no(+) and b.dept_id = '"+br_id+"' and hg = '"+sch_chk+"' AND NVL(d.OV_YN,'N') <> '"+gubun+"' AND a.cancel is null /* and (a.start_date = "+today+" or a.end_date = "+today+" ) */ "+today+"\n";
			
		query += " order by a.cm_check desc,  a.cancel asc, a.start_date desc ";
		

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Year_Mon_List2]"+e);
			System.out.println("[Free_timeDatabase:Year_Mon_List2]"+query);
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

	public int UpdSchPrvOv(String user_id, String sch_date, String ov_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";

		int seq = 0;

		query = " UPDATE sch_prv set ov_yn = '"+ ov_yn + "' \n"+
				" where user_id='"+user_id+"' and start_year || start_mon || start_day  = replace('"+sch_date+"', '-','') ";		


		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			count2 = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:UpdSchPrvOv]\n"+e);
			System.out.println("[Free_timeDatabase:UpdSchPrvOv]\n"+query);
	  		e.printStackTrace();
	  		count2 = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}

   
	public int UpdSchPrvIwol(String user_id, String sch_date, String iwol_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";

		int seq = 0;

		query = " UPDATE sch_prv set iwol = '"+ iwol_yn + "' \n"+
				" where user_id='"+user_id+"' and start_year || start_mon || start_day  = replace('"+sch_date+"', '-','') ";		


		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			count2 = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:UpdSchPrvIwol]\n"+e);
			System.out.println("[Free_timeDatabase:UpdSchPrvIwol]\n"+query);
	  		e.printStackTrace();
	  		count2 = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}

//대체근무자 연차여부
public Vector free_work_id(String st_dt, String end_dt, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String today = "";

		query = " SELECT a.dept_id, a.user_id, a.user_nm , b.yn, b.start_day day , decode(b.sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상') as sch_chk \n"+
				" ,DECODE(a.dept_id, '0001','영업팀', '0002','고객지원팀', '0003','총무팀', '0005','IT팀', '0007','부산지점', '0008','대전지점', '8888','협력업체','0009','강남지점','0010','광주지점','0011','대구지점','0012','인천지점','0013','수원지점','0014','강서지점','0015','구로지점','0016','울산지점','0017','광화문지점','0018','송파지점') dept_nm \n"+
				"  FROM  (SELECT dept_id, USER_ID, USER_NM, user_pos,  \n"+
				" decode(user_pos,'대표이사', 0, '이사', 1, '부장', 2, '팀장', 3, '차장', 4, '과장', 5, '대리', 6, 9) POS  \n"+
				" FROM USERS WHERE use_yn='Y' AND DEPT_ID IN ('0001','0002','0003','0005','0006', '0007', '0008', '0005','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020') ) a , \n"+
			    " (SELECT user_id, start_day, sch_chk , 'Y' AS YN FROM sch_prv WHERE sch_chk not in ('1','2','0')  \n"+
				" AND start_year = substr('"+st_dt+"', 0,4)  \n"+
				" AND start_mon = substr('"+st_dt+"', 6,2)  \n"+
				" AND start_day = substr('"+st_dt+"', 9,10) ) b \n"+
				" WHERE a.user_id = b.user_id(+) ";

		if(gubun.equals("124")){
			query += " AND a.user_id IN ('000124','000177','000153','000272')   \n"; //a.user_id not IN ('000004','000005','000006') and a.dept_id in ('0001','0002','0003')
		}else if(gubun.equals("456")){
			query += " AND a.user_id IN ('000004','000005','000026', '000237','000028')   \n";
		}else if(gubun.equals("78")){
			query += " AND ( a.dept_id IN ('0007','0008','0016') OR a.user_id = '000130' ) \n";
		}else if(gubun.equals("jst")){
			query += " AND a.dept_id in ('0001','0002','0003','0005','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020')  \n";
		}else if(gubun.equals("mrent")){
			query += " AND  a.dept_id in ('0003','0006' , '0002' )  \n";
		}else if(gubun.equals("ins")){
			query += " AND (a.dept_id = '0003' or a.user_id in ('000056','000153'))\n";
		}else{
			query += " and a.dept_id = '"+gubun+"' ";
		}
		
		query += " order by a.dept_id, decode(a.user_pos,'대표이사', 0, '이사', 1,  '부장', 2, '팀장', 3, '차장', 4, '과장', 5 , '대리', 6, 9),  a.user_id, b.yn \n";
		
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:free_work_id]"+e);
			System.out.println("[Free_timeDatabase:free_work_id]"+query);
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
 * 대체근무자 연차여부 수정 		2017.12.19
 * - 팀장님들은 팀장님들만 뜰 수 있도록 수정
 * - 이종준 팀장님은 IT마케팅팀이 뜨도록 수정
 * - 나머지 인원은 자신의 부서만 뜰 수 있도록 수정
 * - 본인은 조회 목록에서 제외
 */

public Vector free_work_id2(String st_dt, String end_dt, String gubun, String my_id) {
	getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Vector vt = new Vector();
	String query = "";
	String today = "";

	query = " SELECT a.dept_id, a.user_id, a.user_nm , b.title, b.yn, b.start_day day , decode(b.sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상') as sch_chk, \n"+
			"        DECODE(a.dept_id, '0001','영업팀', '0002','고객지원팀', '0003','총무팀', '0005','IT팀', '0007','부산지점', '0008','대전지점', '8888','협력업체','0009','강남지점','0010','광주지점','0011','대구지점','0012','인천지점','0013','수원지점','0014','강서지점','0015','구로지점','0016','울산지점','0017','광화문지점','0018','송파지점') dept_nm \n"+
			" FROM   (SELECT dept_id, USER_ID, USER_NM, user_pos,  \n"+
			"                decode(user_pos,'대표이사', 0, '이사', 1, '부장', 2, '팀장', 3, '차장', 4, '과장', 5, '대리', 6, 9) POS  \n"+
			"         FROM   USERS "+
			"         WHERE  use_yn='Y' AND DEPT_ID IN ('0001','0002','0003','0005','0006', '0007', '0008', '0005','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020') "+
			"        ) a , \n"+
		    "        (SELECT user_id, start_day, sch_chk , 'Y' AS YN, title "+
			"         FROM   sch_prv "+
		    "         WHERE  sch_chk not in ('1','2','0')  \n"+
			"                AND start_year = substr('"+st_dt+"', 0,4)  \n"+
			"                AND start_mon = substr('"+st_dt+"', 6,2)  \n"+
			"                AND start_day = substr('"+st_dt+"', 9,10) "+
			"        ) b \n"+
			" WHERE a.user_id = b.user_id(+) ";

	if(gubun.equals("chief")){
		query += " AND a.user_id IN ('000004','000005','000026', '000237','000028')   \n";
	}else{
		query += " AND a.dept_id = '"+gubun+"' ";
	}
	
	query += " AND a.user_id NOT IN ('"+my_id+"')";
	
	query += " order by a.dept_id, decode(a.user_pos,'대표이사', 0, '이사', 1,  '부장', 2, '팀장', 3, '차장', 4, '과장', 5 , '대리', 6, 9),  a.user_id, b.yn \n";
	
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
				 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
			}
			vt.add(ht);	
		}
		rs.close();
		pstmt.close();

	} catch (SQLException e) {
		System.out.println("[Free_timeDatabase:free_work_id2]"+e);
		System.out.println("[Free_timeDatabase:free_work_id2]"+query);
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


/*************************************/
	/**
     * 휴직현황 조회
     */

public Vector absence_List(String st_year, String st_mon, String user_id, String gubun, String dt, String gubun3, String ref_dt1, String ref_dt2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		  query = " SELECT a.doc_no, a.user_id USER_ID, a.start_date START_DATE, a.end_date END_DATE, b.user_nm USER_NM, a.title,  \n"+
				  " decode(sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상') as SCH_CHK, \n"+
				  " d.nm as dept_nm , \n"+
				//  + "DECODE(b.dept_id, '0001','영업팀', '0002','고객지원팀', '0003','총무팀', '0005','IT팀', '0007','부산지점', '0008','대전지점', '8888','협력업체','0009','강남지점','0010','광주지점','0011','대구지점','0012','인천지점','0013','수원지점','0014','강서지점','0015','구로지점','0016','울산지점','0017','광화문지점','0018','송파지점') dept_nm,  \n"+
				  " DECODE(c.USER_id2,'000004','안보국','000005','정채달','000026','김광수','000053','제인학','000052','박영규','000237','이종준','XXXXXX','-') AS ok_mng, "+
				  " MONTHS_BETWEEN( LAST_DAY(TO_DATE(a.end_date, 'yyyymmdd')-14) + 1 , TRUNC(TO_DATE(a.start_date, 'yyyymmdd')+14, 'mm') ) m \n"+
				  " FROM  \n"+
				  " (SELECT title, work_id, cm_check, user_id, START_DATE, end_date, sch_chk, doc_no FROM free_time ) a, users b , code d,  (SELECT * FROM DOC_SETTLE WHERE doc_st = '21' )c \n"+
                  " WHERE a.user_id=b.user_id and b.dept_id = d.code and d.c_st='0002' AND a.doc_no = c.doc_id(+) AND b.use_yn = 'Y' AND a.sch_chk IN ('5','8') ";  
			
			//당월조회 (당월이후)
			if(dt.equals("1")) query += " AND substr(replace(a.end_date,'-',''), 1, 6)+1 >= substr(to_char(sysdate,'YYYYMMDD'), 1,6)   \n";			

			//월별조회
			if(dt.equals("2")){					
				
				//query += " and substr(a.start_date, 1,4) = '"+st_year+"' \n";
				String m_date = "";

				if(st_mon.equals("1")){			m_date = st_year+"0"+st_mon;}
				if(st_mon.equals("2")){			m_date = st_year+"0"+st_mon;}
				if(st_mon.equals("3")){			m_date = st_year+"0"+st_mon;}
				if(st_mon.equals("4")){			m_date = st_year+"0"+st_mon;}
				if(st_mon.equals("5")){			m_date = st_year+"0"+st_mon;}
				if(st_mon.equals("6")){			m_date = st_year+"0"+st_mon;}
				if(st_mon.equals("7")){			m_date = st_year+"0"+st_mon;}
				if(st_mon.equals("8")){			m_date = st_year+"0"+st_mon;}
				if(st_mon.equals("9")){			m_date = st_year+"0"+st_mon;}
				if(st_mon.equals("10")){		m_date = st_year+st_mon;}
				if(st_mon.equals("11")){		m_date = st_year+st_mon;}
				if(st_mon.equals("12")){		m_date = st_year+st_mon;}

					query += " and substr(a.start_date, 1,6) <= '"+m_date+"' AND SUBSTR(A.end_DATE,1,6) >= '"+m_date+"' \n";
				}

			//조회기간
			if(dt.equals("3")){
				if(!ref_dt1.equals("") && !ref_dt2.equals(""))		query += " AND replace(a.start_date,'-','') <=  '"+ref_dt1+"' and replace(a.end_date,'-','') >= '"+ref_dt2+"' ";
				if(!ref_dt1.equals("") && ref_dt2.equals(""))		query += " and replace(a.start_date,'-','') <= '"+ref_dt1+"' and replace(a.end_date,'-','') >= to_char(sysdate,'YYYYMMDD') ";
			}

			query += " order by a.start_date desc, B.DEPT_ID ";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:absence_List]"+e);
			System.out.println("[Free_timeDatabase:absence_List]"+query);
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



public Hashtable  absence_per( String user_id,  String doc_no)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT   \n"+
				" a.user_id USER_ID, a.start_date START_DATE, a.end_date END_DATE, a.title TITLE, a.content CONTENT, c.nm dept_nm, \n"+
				" MONTHS_BETWEEN( LAST_DAY(TO_DATE(a.end_date, 'yyyymmdd')-14) + 1 , TRUNC(TO_DATE(a.start_date, 'yyyymmdd')+14, 'mm') ) m, \n"+
				" b.user_nm USER_NM, b.id, d.user_nm2, d.user_id2, \n"+
				" e1.gubun AS gubunkk, e2.gubun AS gubunkm, e1.start_dt AS start_dtkk, e1.end_dt AS end_dtkk, e1.jse_dt AS jse_dtkk, e1.jse_mng AS jse_mngkk, e1.jss_dt AS jss_dtkk, e1.jss_mng AS jss_mngkk, \n"+
				" e2.start_dt AS start_dtkm, e2.end_dt AS end_dtkm, e2.jse_dt AS jse_dtkm, e2.jse_mng AS jse_mngkm, e2.jss_dt AS jss_dtkm, e2.jss_mng AS jss_mngkm ,\n"+
				" x.start_dt AS m_start_day,  x.end_dt AS m_end_day ,x.jse_dt as t_dt \n" +
				" FROM free_time a, users b, doc_settle d , code c, (SELECT * FROM  ABSENCE WHERE gubun = 'KK' ) e1, (SELECT * FROM  ABSENCE WHERE gubun = 'KM' ) e2 , (SELECT * FROM  ABSENCE WHERE gubun = 'XX' ) x  \n"+  // 여기서 부터
				" where a.user_id= '"+user_id+"' and a.doc_no = '"+doc_no+"' and a.doc_no = d.doc_id AND a.DOC_NO = e1.DOC_ID(+)  AND a.DOC_NO = e2.DOC_ID(+)  and a.DOC_NO=x.DOC_ID(+)  and d.doc_st in '21'  and c.c_st='0002' and c.code=b.dept_id  and a.user_id=b.user_id(+)   \n";

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:absence_per]\n"+e);			
			System.out.println("[Free_timeDatabase:absence_per]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	
	}

public Hashtable  absence_one( String gubun,  String doc_no)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


		query = " SELECT a.*, b.USER_NM AS jse_nm, c.USER_NM AS jss_nm  "+
				" FROM ABSENCE a, USERS b, USERS c "+
				" WHERE a.JSE_MNG = b.USER_ID AND a.JSS_MNG = c.USER_ID(+) AND a.doc_id = '"+doc_no+"'  AND a.gubun = '"+gubun+"' ";


		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:absence_one]\n"+e);			
			System.out.println("[Free_timeDatabase:absence_one]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	
	}

	/**
     * 등록
     */

public int Insert_Absence(AbsenceBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;

		int count = 0;
		String query = "";

		 query="INSERT INTO ABSENCE(DOC_ID, SEQ, GUBUN, START_DT, END_DT, JSE_DT, JSE_MNG )\n"
                + "values(?, ?, ?, ?, ?, ?, ? )";


		try 
		{			
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getDoc_id());
			pstmt.setInt(2, bean.getSeq());
			pstmt.setString(3, bean.getGubun());
			pstmt.setString(4, bean.getStart_dt());
			pstmt.setString(5, bean.getEnd_dt());			
			pstmt.setString(6, bean.getJse_dt());
			pstmt.setString(7, bean.getJse_mng());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Insert_Absence]\n"+e);
			System.out.println("[Free_timeDatabase:Insert_Absence]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
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

//보험료납부유예 수정
public int Update_Absence_Jse(AbsenceBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;

		int count = 0;
		String query = "";

		query = " update ABSENCE set "+
				" START_DT = ?, END_DT= ?, JSE_DT= ?, JSE_MNG = ?   "+
				" where DOC_ID=? and SEQ= ? and GUBUN = ? ";		


		try 
		{			
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getStart_dt());
			pstmt.setString(2, bean.getEnd_dt());			
			pstmt.setString(3, bean.getJse_dt());
			pstmt.setString(4, bean.getJse_mng());
			pstmt.setString(5, bean.getDoc_id());
			pstmt.setInt(6, bean.getSeq());
			pstmt.setString(7, bean.getGubun());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Update_Absence_Jse]\n"+e);
			System.out.println("[Free_timeDatabase:Update_Absence_Jse]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
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

//보험료납부재개
public int Update_Absence_Jss(AbsenceBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;

		int count = 0;
		String query = "";

		query = " update ABSENCE set "+
				" JSS_DT= ?, JSS_MNG = ?   "+
				" where DOC_ID=? and SEQ= ? and GUBUN = ? ";		

		try 
		{			
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getJss_dt());
			pstmt.setString(2, bean.getJss_mng());
			pstmt.setString(3, bean.getDoc_id());
			pstmt.setInt(4, bean.getSeq());
			pstmt.setString(5, bean.getGubun());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:Update_Absence_Jss]\n"+e);
			System.out.println("[Free_timeDatabase:Update_Absence_Jss]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
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

   
	public int tour_update(String user_id, String st_dt , String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
	
	
		query = " update ps_box set  ps_str_dt = replace(?, '-', '') , ps_end_dt = replace(? , '-', '')  \n"+
				" where user_id=? and jigub = 'Y' and ps_str_dt is null ";		
	
		try 
		{	
			conn.setAutoCommit(false);		
		
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, st_dt);
			pstmt.setString(2, end_dt);
			pstmt.setString(3, user_id);
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	
		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:tour_del]\n"+e);
			System.out.println("[Free_timeDatabase:tour_del]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
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

	//휴가등록전 대체근무자 지정여부 체크(20190821)
	public Vector getWork_idCheck(String st_dt, String end_dt, String user_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		query = " SELECT a.*, b.* FROM FREE_TIME a, USERS b " +
					 "	WHERE a.user_id = b.user_id AND a.work_id = '"+user_id+"' AND (REPLACE('"+st_dt+"','-','') BETWEEN a.start_date AND a.end_date OR REPLACE('"+end_dt+"','-','') BETWEEN a.start_date AND a.end_date) "+
				     "        AND a.content NOT LIKE '%휴직%' ";  //휴직은 제외한다.
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();   
				
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:getWork_idCheck]"+e);
			System.out.println("[Free_timeDatabase:getWork_idCheck]"+query);
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
	 *	업무대체자 변경
	 */

	public int UpdateFreeWorkCng(String user_id, String doc_no, String work_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		int count2 = 0;
		String query1 = "";
		String query2 = "";		


		query1 = " update free_time set\n"+
				" work_id = ? \n"+
				" where user_id=? and doc_no=?";		
		
		query2 = " update SCH_PRV set\n"+
				" work_id = ? \n"+
				" where user_id=? and doc_no=?";		


		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, work_id);
			pstmt.setString(2, user_id);
			pstmt.setString(3, doc_no);
			count2 = pstmt.executeUpdate();
			pstmt.close();
			
			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, work_id);
			pstmt2.setString(2, user_id);
			pstmt2.setString(3, doc_no);
			count2 = pstmt2.executeUpdate();
			pstmt2.close();
			
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:UpdateFreeWorkCng]\n"+e);
	  		e.printStackTrace();
	  		count2 = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}
	
	//휴가현황 20200315
	public Vector getFreeTimeStat(String dt, String st_year, String st_mon){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		//기간
		if(dt.equals("2")) {
			query = "SELECT a.nm, a.dept_id, nvl(b.cnt0,0) cnt0, \r\n" + 
					"       NVL(b.cnt1,0) cnt1, NVL(b.cnt2,0) cnt2, NVL(b.cnt3,0) cnt3, NVL(b.cnt4,0) cnt4, NVL(b.cnt5,0) cnt5, NVL(b.cnt6,0) cnt6, \r\n" + 
					"       NVL(b.cnt7,0) cnt7, NVL(b.cnt8,0) cnt8, NVL(b.cnt9,0) cnt9, NVL(b.cnt10,0) cnt10, NVL(b.cnt11,0) cnt11, NVL(b.cnt12,0) cnt12, NVL(c.cnt13,0) cnt13\r\n" + 
					"FROM   (SELECT a.br_id, a.dept_id, b.nm, nvl(b.loan_st,'0') loan_st FROM users a, code b WHERE a.dept_id=b.code AND b.c_st='0002' AND a.use_yn='Y' AND a.dept_id NOT IN ('1000','8888','0004') GROUP BY a.br_id, a.dept_id, b.nm, b.loan_st) a, \r\n" + 
					"       (select  \r\n" + 
					"               b.dept_id, b.loan_st, count(0) cnt0, \r\n" + 
					"               COUNT(DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'3',a.user_id))) cnt1,\r\n" + 
					"               COUNT(DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'6',a.user_id))) cnt2,\r\n" + 
					"               COUNT(DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'9',a.user_id))) cnt3,\r\n" + 
					"               COUNT(DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'7',a.user_id))) cnt4,\r\n" + 
					"               COUNT(DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'4',a.user_id))) cnt5,\r\n" + 
					"               COUNT(DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'5',a.user_id))) cnt6,\r\n" + 
					"               COUNT(DECODE(d.ov_yn,'N',a.user_id)) cnt7,\r\n" + 
					"               COUNT(DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'5',DECODE(a.title,'생리휴가',a.user_id)))) cnt8,\r\n" + 
					"               COUNT(DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'5',DECODE(a.title,'생리휴가','',a.user_id)))) cnt9, \r\n" + 
					"               COUNT(DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'5','','8','',a.user_id))) cnt10,\r\n" + 
					"               COUNT(DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'8',a.user_id))) cnt11,\r\n" + 
					"               COUNT(DECODE(d.ov_yn,'Y',a.user_id)) cnt12\r\n" + 
					"        from   free_time a, \r\n" + 
					"               (SELECT DECODE(dept_id,'9999',NVL(dept_out,dept_id),dept_id) dept_id, user_id, user_nm, use_yn, nvl(loan_st,'0') FROM users WHERE id NOT LIKE 'develop%') b, \r\n" + 
					"               (SELECT doc_no, NVL(ov_yn,'N') ov_yn, COUNT(0) cnt FROM free_time_item GROUP BY doc_no, NVL(ov_yn,'N')) d \r\n" + 
					"        WHERE  \r\n";
					
			if(!st_year.equals("") && !st_mon.equals("")) {
				query += "'"+st_year+""+st_mon+"' BETWEEN SUBSTR(A.START_DATE,1,6) AND SUBSTR(a.end_date,1,6)\r\n"; 
			}else if(!st_year.equals("") && st_mon.equals("")) {
				query += "'"+st_year+"' BETWEEN SUBSTR(A.START_DATE,1,4) AND SUBSTR(a.end_date,1,4)\r\n";
			}else{
				query += " 1=1 ";	
			}
					
			query +="               and a.cancel is NULL  \r\n" + 
					"               AND a.user_id=b.user_id \r\n" + 
					"               and a.doc_no=d.doc_no(+) \r\n" + 
					"        GROUP BY b.dept_id, b.loan_st \r\n" + 
					"       ) b,\r\n" + 
					"       (select  \r\n" + 
					"               b.dept_id, nvl(b.loan_st,') loan_st, count(0) cnt13 \r\n" + 
					"        from   sch_prv a, users b  \r\n" + 
					"        WHERE  \r\n";
					
			if(!st_year.equals("") && !st_mon.equals("")) {
				query += " a.start_year||a.start_mon = '"+st_year+""+st_mon+"' \r\n"; 
			}else if(!st_year.equals("") && st_mon.equals("")) {
				query += " a.start_year = '"+st_year+"' \r\n";
			}else{
				query += " 1=1 ";	
			}
					
			query +="               and a.sch_chk='0'  \r\n" + 
					"               AND a.user_id=b.user_id \r\n" +  
					"        GROUP BY b.dept_id, b.loan_st \r\n" + 
					"       ) c\r\n" + 					
					"WHERE  a.dept_id=b.dept_id(+) and a.loan_st=b.loan_st(+) and a.dept_id=c.dept_id(+) and a.loan_st=c.loan_st(+)     \r\n" + 
					"ORDER BY DECODE(a.br_id,'S1',1,2), a.dept_id";
		//당일,명일	
		}else {
			query = "SELECT a.nm, a.dept_id, a.loan_st, nvl(b.cnt0,0) cnt0, \r\n" + 
					"       NVL(b.cnt1,0) cnt1, NVL(b.cnt2,0) cnt2, NVL(b.cnt3,0) cnt3, NVL(b.cnt4,0) cnt4, NVL(b.cnt5,0) cnt5, NVL(b.cnt6,0) cnt6, \r\n" + 
					"       NVL(b.cnt7,0) cnt7, NVL(b.cnt8,0) cnt8, NVL(b.cnt9,0) cnt9, NVL(b.cnt10,0) cnt10, NVL(b.cnt11,0) cnt11, NVL(b.cnt12,0) cnt12,\r\n" + 
					"       NVL(b.cnt2_1,0) cnt2_1, NVL(b.cnt2_2,0) cnt2_2, NVL(b.cnt2_3,0) cnt2_3, NVL(b.cnt2_4,0)  cnt2_4,  NVL(b.cnt2_5,0)  cnt2_5,  NVL(b.cnt2_6,0)  cnt2_6, \r\n" + 
					"       NVL(b.cnt2_7,0) cnt2_7, NVL(b.cnt2_8,0) cnt2_8, NVL(b.cnt2_9,0) cnt2_9, NVL(b.cnt2_10,0) cnt2_10, NVL(b.cnt2_11,0) cnt2_11, NVL(b.cnt2_12,0) cnt2_12,\r\n" +
					"       NVL(b.cnt13,0) cnt13, NVL(b.cnt2_13,0) cnt2_13 "+
					"FROM   (SELECT a.br_id, a.dept_id, b.nm, nvl(a.loan_st,'0') loan_st FROM users a, code b WHERE a.dept_id=b.code AND b.c_st='0002' AND a.use_yn='Y' AND a.dept_id NOT IN ('1000','8888','0004') GROUP BY a.br_id, a.dept_id, b.nm, a.loan_st) a, \r\n" + 
					"       (select  \r\n" + 
					"               b.dept_id, b.loan_st, count(0) cnt0, \r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'3',a.user_id)))) cnt1,\r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'6',a.user_id)))) cnt2,\r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'9',a.user_id)))) cnt3,\r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'7',a.user_id)))) cnt4,\r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'4',a.user_id)))) cnt5,\r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'5',a.user_id)))) cnt6,\r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'N',a.user_id))) cnt7,\r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'5',DECODE(a.title,'생리휴가',a.user_id))))) cnt8,\r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'5',DECODE(a.title,'생리휴가','',a.user_id))))) cnt9,\r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'5','','8','',a.user_id)))) cnt10,\r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'8',a.user_id)))) cnt11,\r\n" + 
					"               COUNT(DECODE(a.st,'1',DECODE(d.ov_yn,'Y',a.user_id))) cnt12,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'3',a.user_id)))) cnt2_1,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'6',a.user_id)))) cnt2_2,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'9',a.user_id)))) cnt2_3,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'7',a.user_id)))) cnt2_4,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'4',a.user_id)))) cnt2_5,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'N',DECODE(a.sch_chk,'5',a.user_id)))) cnt2_6,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'N',a.user_id))) cnt2_7,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'5',DECODE(a.title,'생리휴가',a.user_id))))) cnt2_8,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'5',DECODE(a.title,'생리휴가','',a.user_id))))) cnt2_9,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'5','','8','',a.user_id)))) cnt2_10,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'Y',DECODE(a.sch_chk,'8',a.user_id)))) cnt2_11,\r\n" + 
					"               COUNT(DECODE(a.st,'2',DECODE(d.ov_yn,'Y',a.user_id))) cnt2_12,\r\n" +
					"               COUNT(DECODE(a.st,'3',a.user_id)) cnt13,\r\n" +					
					"               COUNT(DECODE(a.st,'4',a.user_id)) cnt2_13\r\n" +					
					"        from   (\n"+
					"                SELECT '1' st, doc_no, user_id, sch_chk, title FROM free_time WHERE to_char(sysdate,'YYYYMMDD') BETWEEN START_DATE AND end_date and cancel is NULL\r\n" + 
					"                UNION ALL \r\n" + 
					"                SELECT '2' st, doc_no, user_id, sch_chk, title FROM free_time WHERE to_char(sysdate+1,'YYYYMMDD') BETWEEN START_DATE AND end_date and cancel is NULL\r\n" + 
					"                UNION ALL \r\n" + 
					"                SELECT '3' st, '' doc_no, user_id, sch_chk, title FROM sch_prv WHERE start_year||start_mon||start_day=to_char(sysdate,'YYYYMMDD') and sch_chk='0' \r\n" + 
					"                UNION ALL \r\n" + 
					"                SELECT '4' st, '' doc_no, user_id, sch_chk, title FROM sch_prv WHERE start_year||start_mon||start_day=to_char(sysdate+1,'YYYYMMDD') and sch_chk='0'\r\n" + 
					"               ) a, \r\n" + 
					"               (SELECT DECODE(dept_id,'9999',NVL(dept_out,dept_id),dept_id) dept_id, user_id, user_nm, use_yn, nvl(loan_st,'0') loan_st FROM users WHERE id NOT LIKE 'develop%') b, \r\n" + 
					"               (SELECT doc_no, NVL(ov_yn,'N') ov_yn, COUNT(0) cnt FROM free_time_item GROUP BY doc_no, NVL(ov_yn,'N')) d \r\n" + 
					"        WHERE  a.user_id=b.user_id \r\n" + 
					"               and a.doc_no=d.doc_no(+) \r\n" + 
					"        GROUP BY b.dept_id, b.loan_st \r\n" + 
					"       ) b\r\n" + 
					"WHERE  a.dept_id=b.dept_id(+) and a.loan_st=b.loan_st(+) \r\n" + 
					"ORDER BY DECODE(a.br_id,'S1',1,2), a.dept_id";
		}
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();   
				
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:getFreeTimeStat]"+e);
			System.out.println("[Free_timeDatabase:getFreeTimeStat]"+query);
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
	
	//휴가현황 20200315
	public Vector getFreeTimeStatList(String dt, String st_year, String st_mon, String dept_id, String gubun1, String gubun2){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
			query = "select  \r\n" + 
					"               b.dept_id,  \r\n" + 
					"                         b.user_nm, A.START_DATE, a.end_date, \r\n" + 
					"                         decode(to_char( to_date(A.START_DATE,'YYYYMMDD'), 'd'), '1', '일', '2', '월', '3', '화', '4', '수', '5', '목', '6', '금', '7', '토' ) s_day_nm,\r\n" + 
					"                         decode(to_char( to_date(a.end_date,'YYYYMMDD'), 'd'), '1', '일', '2', '월', '3', '화', '4', '수', '5', '목', '6', '금', '7', '토' ) e_day_nm,\r\n" + 
					"                         a.reg_dt, a.title, a.content, a.cm_check, A.CANCEL, d.cnt, c.cm_check,\r\n" + 
					"                         CASE when a.cm_check IS NOT NULL AND A.CANCEL IS NULL THEN '완료'\r\n" + 
					"                              when a.cm_check IS NOT NULL AND a.cancel='Y' AND c.cm_check IS NOT NULL THEN '취소'\r\n" + 
					"                              WHEN a.cm_check IS NULL AND A.CANCEL IS NULL THEN '대기' \r\n" + 
					"                              WHEN c.cm_check IS NULL AND A.CANCEL='Y' THEN '취소대기'\r\n" + 
					"                              ELSE '' END st" + 
					"        from   free_time a, \r\n" + 
					"               (SELECT DECODE(dept_id,'9999',NVL(dept_out,dept_id),dept_id) dept_id, user_id, user_nm, use_yn FROM users WHERE id NOT LIKE 'develop%') b, \r\n" + 
					"               (SELECT doc_no, NVL(ov_yn,'N') ov_yn, COUNT(0) cnt FROM free_time_item GROUP BY doc_no, NVL(ov_yn,'N')) d, free_cancel c  \r\n" + 
					"        WHERE  \r\n";
				

			
			//기간
			if(dt.equals("2")) {			
				if(!st_year.equals("") && !st_mon.equals("")) {
					query += "'"+st_year+""+st_mon+"' BETWEEN SUBSTR(A.START_DATE,1,6) AND SUBSTR(a.end_date,1,6)\r\n"; 
				}else if(!st_year.equals("") && st_mon.equals("")) {
					query += "'"+st_year+"' BETWEEN SUBSTR(A.START_DATE,1,4) AND SUBSTR(a.end_date,1,4)\r\n";
				}else{
					query += " 1=1 ";	
				}			
			}else {
				//당일
				if(gubun1.equals("1")) {
					query += "to_char(sysdate,'YYYYMMDD')   BETWEEN A.START_DATE AND a.end_date\r\n";
				//명일	
				}else{
					query += "to_char(sysdate+1,'YYYYMMDD') BETWEEN A.START_DATE AND a.end_date\r\n";
				}				
			}
		
		if(gubun2.equals("1")) {
			query += " and d.ov_yn='N' and a.sch_chk='3' \r\n";
		}else if(gubun2.equals("2")) {	
			query += " and d.ov_yn='N' and a.sch_chk='6' \r\n";
		}else if(gubun2.equals("3")) {	
			query += " and d.ov_yn='N' and a.sch_chk='9' \r\n";
		}else if(gubun2.equals("4")) {	
			query += " and d.ov_yn='N' and a.sch_chk='7' \r\n";
		}else if(gubun2.equals("5")) {	
			query += " and d.ov_yn='N' and a.sch_chk='4' \r\n";
		}else if(gubun2.equals("6")) {	
			query += " and d.ov_yn='N' and a.sch_chk='5' \r\n";
		}else if(gubun2.equals("8")) {	
			query += " and d.ov_yn='Y' and a.sch_chk='5' and a.title='생리휴가' \r\n";
		}else if(gubun2.equals("9")) {	
			query += " and d.ov_yn='Y' and a.sch_chk='5' and nvl(a.title,'-')<>'생리휴가' \r\n";
		}else if(gubun2.equals("10")) {	
			query += " and d.ov_yn='Y' and a.sch_chk not in ('5','8') \r\n";
		}else if(gubun2.equals("11")) {	
			query += " and d.ov_yn='Y' and a.sch_chk='8' \r\n";
		}
					
			query +="               AND a.user_id=b.user_id and b.dept_id='"+dept_id+"' AND a.cancel is null \r\n" + 
					"               and a.doc_no=c.doc_no(+) \r\n" + 
					"               and a.doc_no=d.doc_no(+) \r\n" +
					"ORDER BY A.CANCEL desc, A.START_DATE desc, a.user_id";
			
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();   
				
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:getFreeTimeStatList]"+e);
			System.out.println("[Free_timeDatabase:getFreeTimeStatList]"+query);
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
	
	
	public Hashtable getVacationMagam(String user_id){
		getConnection();
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
	
		query = " SELECT a.user_id, a.end_dt, a.vacation, a.save_dt, a.remain, a.due_dt   	  \n"+			
				" from  VACATION_MAGAM a, (SELECT user_id, max(save_dt) save_dt FROM VACATION_MAGAM GROUP BY user_id )  b  \n"+		
			    " where a.save_dt = b.save_dt and a.user_id = b.user_id		 \n"+			
				"	AND a.USER_ID = ? \n" ;
			
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user_id);		
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

		}catch(SQLException e){
			System.out.println("[Free_timeDatabase:getVacationMagam(String user_id)]"+e);
			System.out.println("[Free_timeDatabase:getVacationMagam(String user_id)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}
	
	public float  getIwolUseCnt( String user_id, String st_dt, String ed_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		float iw_cnt = 0;
		String query = "";

		query = " select sum(decode(count, 'B1', 0.5, 'B2', 0.5, '오전반차',0.5,'오후반차',0.5,'오전반휴',0.5,'오후반휴',0.5 , 1)) AS su  \n"+	
				" FROM sch_prv "+
				" WHERE user_id = ? and start_year||start_mon||start_day BETWEEN  replace(?, '-', '') and replace (?, '-' , '') and nvl(gj_ck,'Y') = 'Y' and  sch_chk ='3'  and iwol ='Y' ";


		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user_id);		
			pstmt.setString(2, st_dt);		
			pstmt.setString(3, ed_dt);	
			rs = pstmt.executeQuery();
			if(rs.next())
			{		
				iw_cnt = rs.getFloat(1);
			}
			rs.close();
			pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:getIwolUseCnt]\n"+e);			
			System.out.println("[Free_timeDatabase:getIwolUseCnt]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return iw_cnt;
		}	
	}
	
	public Hashtable  TodayHomeworkStat()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT COUNT(DECODE(b.loan_st,'',a.user_id)) cnt1,\r\n"
				+ "       COUNT(DECODE(b.loan_st,'1',a.user_id)) cnt2,\r\n"
				+ "       COUNT(DECODE(b.loan_st,'2',a.user_id)) cnt3\r\n"
				+ "FROM   sch_prv a, users b \r\n"
				+ "WHERE  a.start_year||a.start_mon||a.start_day=to_char(sysdate,'YYYYMMDD') and a.sch_chk='0' AND a.user_id=b.user_id \n"
				+ " ";

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[Free_timeDatabase:TodayHomeworkStat]\n"+e);			
			System.out.println("[Free_timeDatabase:TodayHomeworkStat]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	
	}
	
}
