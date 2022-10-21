/**
 * 연차관리
 * @ author : Ryu Gill Sun
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 03. 27
 * @ last modify date : 
 */

package acar.actn_scan;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.text.*;
import acar.database.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class Actn_scanDatabase
{
	private Connection conn = null;
	public static Actn_scanDatabase db;
	
	public static Actn_scanDatabase getInstance()
	{
		if(Actn_scanDatabase.db == null)
			Actn_scanDatabase.db = new Actn_scanDatabase();
		return Actn_scanDatabase.db;
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
	 *	등록하기
	 */
	public int insertActn_scan_all(String actn_id, String actn_nm, String actn_dt, String actn_su, String reg_id, String filename1, String filename2, String filename3) throws SQLException
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " insert into actn_scan (actn_nm, actn_dt, actn_su, reg_id, FILE_NAME1, FILE_NAME2, FILE_NAME3, reg_dt, actn_id ) "+
				" VALUES(?, replace(?,'-',''), ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?)";
		try {
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,	actn_nm);
			pstmt.setString(2,	actn_dt);
			pstmt.setString(3,	actn_su);
			pstmt.setString(4,	reg_id);
			pstmt.setString(5,	filename1);
			pstmt.setString(6,	filename2);
			pstmt.setString(7,	filename3);
			pstmt.setString(8,	actn_id);
	    	count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[Actn_scanDatabase:insertActn_scan_all]"+e);
			System.out.println("[Actn_scanDatabase:insertActn_scan_all]"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	


//경매낙찰관리스캔 리스트 조회
public Vector Actn_scan_all(String dt, String st_year, String st_mon, String ref_dt1, String ref_dt2) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String subQuery = "";
		String query = "";

		query = " SELECT ACTN_ID, ACTN_NM, ACTN_DT, ACTN_SU, REG_ID, REG_DT, FILE_NAME1, FILE_NAME2, FILE_NAME3 FROM ACTN_SCAN \n";

		//당월조회
		if(dt.equals("1")) query += " where (substr(replace(ACTN_DT,'-',''), 1, 6) >= substr(to_char(sysdate,'YYYYMMDD'), 1,6) or substr(replace(ACTN_DT,'-',''), 1, 8) >= substr(to_char(sysdate -1, 'yyyymmdd'), 1, 8))   \n";			

		//월별조회
		if(dt.equals("2")){					
			
			query += " where substr(ACTN_DT, 1,4) = '"+st_year+"' \n";

			if(st_mon.equals("1"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
			if(st_mon.equals("2"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
			if(st_mon.equals("3"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
			if(st_mon.equals("4"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
			if(st_mon.equals("5"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
			if(st_mon.equals("6"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
			if(st_mon.equals("7"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
			if(st_mon.equals("8"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
			if(st_mon.equals("9"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
			if(st_mon.equals("10"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
			if(st_mon.equals("11"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
			if(st_mon.equals("12"))			query += " and to_number(substr(ACTN_DT, 5,2)) = '"+st_mon+"' \n";
		}

		//조회기간
		if(dt.equals("3")){
			if(!ref_dt1.equals("") && !ref_dt2.equals(""))		query += " where replace(ACTN_DT,'-','') between '"+ref_dt1+"' and '"+ref_dt2+"' ";
			if(!ref_dt1.equals("") && ref_dt2.equals(""))		query += " where replace(ACTN_DT,'-','') = '"+ref_dt1+"'";
		}

//System.out.println("[Actn_scanDatabase:Actn_scan_all]"+query);		

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
			System.out.println("[Actn_scanDatabase:Actn_scan_all]"+e);
			System.out.println("[Actn_scanDatabase:Actn_scan_all]"+query);
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
	 *	삭제하기
	 */
	public int deleteActn_scan(String actn_nm, String actn_dt, String actn_su) throws SQLException
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " delete from actn_scan where actn_nm = '"+actn_nm.trim()+"' and actn_dt='"+actn_dt+"' and actn_su ='"+actn_su+"' ";


		try {
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
	    	count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[Actn_scanDatabase:deleteActn_scan]"+e);
			System.out.println("[Actn_scanDatabase:deleteActn_scan]"+query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}



}
