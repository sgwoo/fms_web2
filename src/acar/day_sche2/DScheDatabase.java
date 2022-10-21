package acar.day_sche2;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;

public class DScheDatabase
{
	private Connection conn = null;
	public static DScheDatabase db;
	
	public static DScheDatabase getInstance()
	{
		if(DScheDatabase.db == null)
			DScheDatabase.db = new DScheDatabase();
		return DScheDatabase.db;
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
	 */
	public DayScheBean getDailyScd(String year, String mon, String day, String seq)
	{
		getConnection();
		DayScheBean scd = new DayScheBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" SEQ, YEAR, MON, DAY, USER_ID, TITLE, CONTENT, PR_DT, PR_ID, STATUS "+
							" from DAY_SCHE "+
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
				scd.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				scd.setYear(rs.getString("YEAR")==null?"":rs.getString("YEAR"));
				scd.setMon(rs.getString("MON")==null?"":rs.getString("MON"));
				scd.setDay(rs.getString("DAY")==null?"":rs.getString("DAY"));
				scd.setUser_id(rs.getString("USER_ID")==null?"":rs.getString("USER_ID"));
				scd.setTitle(rs.getString("TITLE")==null?"":rs.getString("TITLE"));
				scd.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				scd.setPr_dt(rs.getString("PR_DT")==null?"":rs.getString("PR_DT"));
				scd.setPr_id(rs.getString("PR_ID")==null?"":rs.getString("PR_ID"));
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

	/**하루치 전부
	 */
	public Vector getDailyScds(String year, String mon, String day)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String pr_dt = year+mon+day;
		String today = Util.getDate();
		today = today.substring(0,4)+today.substring(5,7)+today.substring(8,10);
		String query;
		if(Integer.parseInt(today) > Integer.parseInt(pr_dt)){
			query = " select"+
						" SEQ, YEAR, MON, DAY, USER_ID, TITLE, CONTENT, PR_DT, PR_ID, STATUS "+
					" from DAY_SCHE "+
					" where pr_dt = ? "+
					" order by seq";
		}else{
			query = " select"+
						" SEQ, YEAR, MON, DAY, USER_ID, TITLE, CONTENT, PR_DT, PR_ID, STATUS "+
					" from DAY_SCHE "+
					" where status='0' or "+
						" pr_dt = ? "+
					" order by status, day ";
		}
						
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1,pr_dt);
		    	rs = pstmt.executeQuery();
				
			while(rs.next())
			{
				DayScheBean scd = new DayScheBean();
				scd.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				scd.setYear(rs.getString("YEAR")==null?"":rs.getString("YEAR"));
				scd.setMon(rs.getString("MON")==null?"":rs.getString("MON"));
				scd.setDay(rs.getString("DAY")==null?"":rs.getString("DAY"));
				scd.setUser_id(rs.getString("USER_ID")==null?"":rs.getString("USER_ID"));
				scd.setTitle(rs.getString("TITLE")==null?"":rs.getString("TITLE"));
				scd.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				scd.setPr_dt(rs.getString("PR_DT")==null?"":rs.getString("PR_DT"));
				scd.setPr_id(rs.getString("PR_ID")==null?"":rs.getString("PR_ID"));
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

	/**
	 *일일업무 등록
	 */
	public boolean insertDScd(DayScheBean scd)
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

			query_seq = "SELECT ltrim(NVL(TO_CHAR(MAX(TO_NUMBER(seq))+1, '000000'), '000001')) seq"+
					  	" FROM DAY_SCHE";

			pstmt1 = conn.createStatement();
			rs = pstmt1.executeQuery(query_seq);

			if(rs.next())
			{
				scd.setSeq(rs.getString("seq")==null?"000001":rs.getString("seq"));
			}
			rs.close();
			pstmt1.close();

			query = "insert into day_sche (YEAR, MON, DAY, SEQ, USER_ID, TITLE, CONTENT, STATUS) values "+
					"('"+scd.getYear()+"','"+scd.getMon()+"','"+scd.getDay()+"',\n"+
					" '"+scd.getSeq()+"','"+scd.getUser_id()+"','"+scd.getTitle()+"',\n"+
					" '"+scd.getContent()+"','"+scd.getStatus()+"')";

			pstmt2 = conn.createStatement();
			pstmt2.executeUpdate(query);
			pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[DScheDatabase:insertDScd]\n"+e);
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
	 *스케쥴 체크된것만 처리
	 */
	public boolean update(String user_id, String seq[])
	{
		getConnection();
		boolean flag = true;
		Statement stmt = null;

		String query  = " update day_sche set PR_DT=(to_char(sysdate,'YYYYMMDD')), PR_ID='"+user_id+
											"', STATUS='1' where seq in (";

		try
		{
			conn.setAutoCommit(false);

			for(int i=0 ; i<seq.length ; i++){
				if(i == (seq.length -1))	query +=seq[i];
				else						query +=seq[i]+", ";
			}
			query+=")";
					
			stmt = conn.createStatement();
			stmt.executeUpdate(query);
			stmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[DScheDatabase:update]\n"+e);
	  		flag = false;
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				if(stmt != null )		stmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**
	* 내용수정하기
	*/
	public boolean updateDScd(DayScheBean scd)
	{
		getConnection();
		boolean flag = true;
		Statement stmt = null;
		String query = "";
		if(!scd.getPr_id().equals("")){
			query = "update day_sche set title='"+scd.getTitle()+"', "+
											" content='"+scd.getContent()+"', "+
											" pr_dt='"+scd.getPr_dt()+"', "+
											" pr_id='"+scd.getPr_id()+"', "+
											" status='1' "+
						" where year='"+scd.getYear()+"' and "+
								" mon='"+scd.getMon()+"' and "+
								" day='"+scd.getDay()+"' and "+
								" seq='"+scd.getSeq()+"'";
		}else{
			query = "update day_sche set title='"+scd.getTitle()+"', "+
											" content='"+scd.getContent()+"' "+
						" where year='"+scd.getYear()+"' and "+
								" mon='"+scd.getMon()+"' and "+
								" day='"+scd.getDay()+"' and "+
								" seq='"+scd.getSeq()+"'";
		}
		try
		{			
			conn.setAutoCommit(false);
			stmt = conn.createStatement(); 
			stmt.executeUpdate(query);
			stmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[DScheDatabase:updateDScd]\n"+e);
	  		flag = false;
	  		e.printStackTrace();
	  		conn.rollback();
		} finally {
			try{
				if(stmt != null )		stmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	체크된 스케쥴 삭제하기
	 */
	public boolean delete(String seq[])
	{
		getConnection();
		boolean flag = true;
		Statement stmt = null;
		String query  = " delete from day_sche where seq in (";

		try
		{
			conn.setAutoCommit(false);

			for(int i=0 ; i<seq.length ; i++){
				if(i == (seq.length -1))	query +=seq[i];
				else						query +=seq[i]+", ";
			}
			query+=")";
	
			stmt = conn.createStatement();
			stmt.executeUpdate(query);
			stmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[DScheDatabase:delete]\n"+e);
	  		flag = false;
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(stmt != null )		stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean del(String seq)
	{
		getConnection();
		boolean flag = true;
		Statement stmt = null;
		String query  = " delete from day_sche where seq='"+seq+"'";

		try
		{
			conn.setAutoCommit(false);

			stmt = conn.createStatement();
			stmt.executeUpdate(query);
			stmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[DScheDatabase:del]\n"+e);
	  		flag = false;
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(stmt != null )		stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
}