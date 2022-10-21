/**
 * 연차관리
 * @ author : Ryu Gill Sun
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 03. 27
 * @ last modify date : 
 */

package acar.closeday;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.text.*;
import acar.database.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class CloseDayDatabase
{
	private Connection conn = null;
	public static CloseDayDatabase db;
	
	public static CloseDayDatabase getInstance()
	{
		if(CloseDayDatabase.db == null)
			CloseDayDatabase.db = new CloseDayDatabase();
		return CloseDayDatabase.db;
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

public Vector CloseDay_List(String st_year, String st_mon, String user_id, String gubun, String dt, String gubun3, String ref_dt1, String ref_dt2, String jj_gub, String bs_gub, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		  query = " select a.*, \n"
				+ " b.user_nm USER_NM\n"
        		+ " from \n"
				+ " closeday a, \n"
				+ " users b \n"
				+ " where a.user_id=b.user_id  \n";
			
			if(dt.equals("1")) query += " and  ( substr(replace(a.reg_dt,'-',''), 1, 6) >= substr(to_char(sysdate,'YYYYMMDD'), 1,6)    or  substr(replace(a.reg_dt,'-',''), 1, 8) >= substr(to_char(sysdate -7, 'yyyymmdd'), 1, 8)  )   \n";			
	
			//월별조회
			if(dt.equals("2")){					
			
				query += " and substr(a.reg_dt, 1,4) = '"+st_year+"' \n";

				if(st_mon.equals("1"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("2"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("3"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("4"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("5"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("6"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("7"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("8"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("9"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("10"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("11"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				if(st_mon.equals("12"))			query += " and to_number(substr(a.reg_dt, 6,2)) = '"+st_mon+"' \n";
				}

			//조회기간
			if(dt.equals("3")){
				if(!ref_dt1.equals("") && !ref_dt2.equals(""))		query += " and replace(a.reg_dt,'-','') between '"+ref_dt1+"' and '"+ref_dt2+"' ";
				if(!ref_dt1.equals("") && ref_dt2.equals(""))		query += " and replace(a.reg_dt,'-','') = '"+ref_dt1+"'";
			}

			//휴가구분
			if(bs_gub.equals("1")) query += " and b.dept_id in ('0001','0002','0003','0007','0008')";
			if(bs_gub.equals("2")) query += " and b.dept_id = '0001'";
			if(bs_gub.equals("3")) query += " and b.dept_id = '0002'";
			if(bs_gub.equals("4")) query += " and b.dept_id = '0003'";
			if(bs_gub.equals("5")) query += " and b.dept_id = '0007'";
			if(bs_gub.equals("6")) query += " and b.dept_id = '0008'";
			if(bs_gub.equals("7")) query += " and b.user_id in('000004','000005','000006')";


			query += " order by a.closeday desc,  a.reg_dt desc ";

//System.out.println("CloseDay_List="+query);

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
			System.out.println("[CloseDayDatabase:CloseDay_List]"+e);
			System.out.println("[CloseDayDatabase:CloseDay_List]"+query);
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

    public Vector CloseDay_per(String user_id, String doc_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
query = " SELECT   \n"+
		" a.*, b.user_nm USER_NM, b.id, \n"+
		" decode( b.br_id, 'S1', '본사', 'B1', '부산', 'D1', '대전' ) br_nm, b.dept_id, decode( b.dept_id, '0001', '영업팀', '0002', '고객지원팀', '0003', '총무팀', '0004', '임원', '0007', '부산지점', '0008',  '대전지점' ) dept_nm "+
		" FROM closeday a, users b, doc_settle d\n"+  // 여기서 부터
		" where a.user_id= '"+user_id+"' and a.doc_no = '"+doc_no+"' and a.doc_no = d.doc_id and d.doc_st in '23' and a.user_id=b.user_id  \n";

//System.out.println("CloseDay_per="+query);

      
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
			System.out.println("[CloseDayDatabase:CloseDay_per]"+e);
			System.out.println("[CloseDayDatabase:CloseDay_per]"+query);
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

 	
 public Vector CloseDay_day(String user_id, String yday)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
query = " SELECT   \n"+
		" a.*, b.user_nm USER_NM, b.id, \n"+
		" decode( b.br_id, 'S1', '본사', 'B1', '부산', 'D1', '대전' ) br_nm, b.dept_id, decode( b.dept_id, '0001', '영업팀', '0002', '고객지원팀', '0003', '총무팀', '0004', '임원', '0007', '부산지점', '0008',  '대전지점' ) dept_nm "+
		" FROM closeday a, users b, doc_settle d\n"+  // 여기서 부터
		" where a.user_id= '"+user_id+"' and a.closeday = '"+yday+"' and a.doc_no = d.doc_id and d.doc_st in '23' and a.user_id=b.user_id  \n";

//System.out.println("CloseDay_per="+query);

      
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
			System.out.println("[CloseDayDatabase:CloseDay_per]"+e);
			System.out.println("[CloseDayDatabase:CloseDay_per]"+query);
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

public String InputCloseDay(CloseDayBean bean)
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
				   +" from closeday where substr(doc_no,1,8)=to_char(sysdate,'YYYYMMDD')";	// and user_id = '" + bean.getUser_id() + "'

		 query="INSERT INTO closeday(USER_ID, DOC_NO, closeday, CONTENT, REG_DT)\n"
                + "values(?, ?, replace(?, '-', ''), ?, to_char(sysdate,'YYYYMMDD'))";

//System.out.println("InputCloseDay="+query);			

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next()){
				doc_no = rs.getString(1)==null?"":rs.getString(1);
			}
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setString(2, doc_no);
			pstmt.setString(3, bean.getCloseday());
			pstmt.setString(4, bean.getContent());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CloseDayDatabase:InputCloseDay]\n"+e);
			System.out.println("[CloseDayDatabase:InputCloseDay]\n"+query);
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


	public int CloseDay_Check(CloseDayBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

		query = " update closeday set\n"+
				" check_dt = sysdate, \n"+
				" check_id = ? \n"+
				" where user_id=? and doc_no=?";		

//System.out.println("S_check="+query);
		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getCheck_id());
			pstmt.setString(2, bean.getUser_id());
			pstmt.setString(3, bean.getDoc_no());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CloseDayDatabase:CloseDay_Check]\n"+e);
			System.out.println("[CloseDayDatabase:CloseDay_Check]\n"+query);
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

	
	public int CloseDay_del(CloseDayBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

		query = " DELETE  FROM closeday  where user_id=? and doc_no=?";					
				
		

//System.out.println("CloseDay_del="+query);

		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setString(2, bean.getDoc_no());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CloseDayDatabase:CloseDay_del]\n"+e);
			System.out.println("[CloseDayDatabase:CloseDay_del]\n"+query);
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
	
	

}
