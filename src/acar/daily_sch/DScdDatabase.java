package acar.daily_sch;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;

public class DScdDatabase
{
	private Connection conn = null;
	public static DScdDatabase db;
	
	public static DScdDatabase getInstance()
	{
		if(DScdDatabase.db == null)
			DScdDatabase.db = new DScdDatabase();
		return DScdDatabase.db;
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
	 *老老诀公 殿废
	 */
	public boolean insertDScd(DailyScdBean scd)
	{
		getConnection();
		boolean flag = true;
		String query_seq="";
		String query="";
		Statement pstmt1 = null;
		Statement pstmt2 = null;
		ResultSet rs = null;
		try 
		{
			conn.setAutoCommit(false);

			query_seq = "SELECT ltrim(NVL(TO_CHAR(MAX(TO_NUMBER(seq))+1, '0000'), '0001')) seq"+
					  	" FROM SCH_DAILY"+
						" WHERE year='"+scd.getYear()+"' AND mon = '"+scd.getMon()+"' AND day ='"+scd.getDay()+"'";

			pstmt1 = conn.createStatement();
			rs = pstmt1.executeQuery(query_seq);

			if(rs.next())
			{
				scd.setSeq(rs.getString("seq")==null?"0001":rs.getString("seq"));
			}
			rs.close();
			pstmt1.close();

			query = "insert into sch_daily (YEAR, MON, DAY, SEQ, USER_ID, TITLE, CONTENT, STATUS) values "+
					"('"+scd.getYear()+"','"+scd.getMon()+"','"+scd.getDay()+"',\n"+
					" '"+scd.getSeq()+"','"+scd.getUser_id()+"','"+scd.getTitle()+"',\n"+
					" '"+scd.getContent()+"','"+scd.getStatus()+"')";

			pstmt2 = conn.createStatement();
			pstmt2.executeUpdate(query);
			pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[DScdDatabase:insertDScd]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				if(rs != null )		rs.close();
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
	
	/**
	 *老老诀公 荐沥
	 */
	public boolean updateDScd(DailyScdBean scd)
	{
		getConnection();
		boolean flag = true;
		Statement pstmt = null;												
		String query ="";
		try 
		{
			query = "update sch_daily set"+
						" USER_ID	= '"+scd.getUser_id()+"',"+
						" TITLE		= '"+scd.getTitle()+"',"+
						" CONTENT	= '"+scd.getContent()+"',"+
						" STATUS	= '"+scd.getStatus()+"'"+
						" where SEQ	= '"+scd.getSeq()+"' and"+
						" YEAR		= '"+scd.getYear()+"' and"+
						" MON		= '"+scd.getMon()+"' and"+
						" DAY		= '"+scd.getDay()+"'";

			conn.setAutoCommit(false);
			pstmt = conn.createStatement();
			pstmt.executeUpdate(query);
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
	  		System.out.println("[DScdDatabase:updateDScd]\n"+e);
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

	/**
	 */
	public DailyScdBean getDailyScd(String year, String mon, String day, String seq)
	{
		getConnection();
		DailyScdBean scd = new DailyScdBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" YEAR, MON, DAY, SEQ, USER_ID, TITLE, CONTENT, STATUS "+
							" from sch_daily "+
							" where YEAR = ? and"+
									" MON = ? and"+
									" DAY = ? and"+
									" SEQ = ?";
						
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, year);
				pstmt.setString(2, mon);
				pstmt.setString(3, day);
				pstmt.setString(4, seq);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				scd.setYear(rs.getString("YEAR")==null?"":rs.getString("YEAR"));
				scd.setMon(rs.getString("MON")==null?"":rs.getString("MON"));
				scd.setDay(rs.getString("DAY")==null?"":rs.getString("DAY"));
				scd.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				scd.setUser_id(rs.getString("USER_ID")==null?"":rs.getString("USER_ID"));
				scd.setTitle(rs.getString("TITLE")==null?"":rs.getString("TITLE"));
				scd.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				scd.setStatus(rs.getString("STATUS")==null?"":rs.getString("STATUS"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return scd;
		}
	}
	
	/**
	 */
	public Vector getDailyScds(String year, String mon, String day)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" YEAR, MON, DAY, SEQ, USER_ID, TITLE, CONTENT, STATUS"+
							" from sch_daily "+
							" where YEAR = ? and"+
									" MON = ? and"+
									" DAY = ?";
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, year);
				pstmt.setString(2, mon);
				pstmt.setString(3, day);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				DailyScdBean scd = new DailyScdBean();
				scd.setYear(rs.getString("YEAR")==null?"":rs.getString("YEAR"));
				scd.setMon(rs.getString("MON")==null?"":rs.getString("MON"));
				scd.setDay(rs.getString("DAY")==null?"":rs.getString("DAY"));
				scd.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				scd.setUser_id(rs.getString("USER_ID")==null?"":rs.getString("USER_ID"));
				scd.setTitle(rs.getString("TITLE")==null?"":rs.getString("TITLE"));
				scd.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				scd.setStatus(rs.getString("STATUS")==null?"":rs.getString("STATUS"));
				vt.add(scd);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
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