package acar.plit;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import oracle.jdbc.*;
import oracle.sql.*;

public class PlItDatabase
{
	private Connection conn = null;
	public static PlItDatabase db;
	
	public static PlItDatabase getInstance()
	{
		if(PlItDatabase.db == null)
			PlItDatabase.db = new PlItDatabase();
		return PlItDatabase.db;
	}	
	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection("insa");				
	    }catch(Exception e){
	    	System.out.println(" i can't get a connection........");
	    }
	}
	
	private void closeConnection()
	{
		if ( conn != null ) 
		{
			connMgr.freeConnection("insa", conn);
			conn = null;
		}		
	}
	
	
	
	public Vector Insa_template_list(String table_nm, String st_year, String st_mon)
	{
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
	
		
		String query = " select * \n"
				+ " from "+ table_nm + " \n"
				+ " where p_year ='"+st_year+"' and p_mon = '"+ st_mon + "' \n ";
		
		if ( table_nm.equals("insa_template2") ||  table_nm.equals("insa_template4")) query = query + "  order by  t_gubun , t_dt " ; 
		
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
			System.out.println("[PlItDatabase:Insa_template_list]"+e);
			System.out.println("[PlItDatabase:Insa_template_list]"+query);
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
	
	public Vector Insa_template_list(String st_year, String st_mon)
	{
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
	
		
	//	String query = " select t_gubun, id, user_nm, sum(t_amt) t_amt \n"
		String query = " select  DECODE(GROUPING(t_gubun), 1, '합계', t_gubun) t_gubun, \n"
						+ " 	DECODE(GROUPING_ID(t_gubun, id), 1, '소계', id) id,user_nm, real_dt, count(t_gubun) t_cnt , sum(t_amt) t_amt  \n"
						+ " from insa_template2 \n"
						+ " where p_year ='"+st_year+"' and p_mon = '"+ st_mon + "' \n "
						+ " group by GROUPING SETS((t_gubun), (t_gubun, id, user_nm, real_dt), ()) 		 \n"  
						+ "  ORDER BY t_gubun, id ";
		 		
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
			System.out.println("[PlItDatabase:Insa_template_list]"+e);
			System.out.println("[PlItDatabase:Insa_template_list]"+query);
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
	
}	