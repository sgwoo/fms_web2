package acar.coolmsg;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import oracle.jdbc.*;
import oracle.sql.*;

public class CoolMsgDatabase
{
	private Connection conn = null;
	public static CoolMsgDatabase db;
	
	public static CoolMsgDatabase getInstance()
	{
		if(CoolMsgDatabase.db == null)
			CoolMsgDatabase.db = new CoolMsgDatabase();
		return CoolMsgDatabase.db;
	}	
	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection("aview");				
	    }catch(Exception e){
	    	System.out.println(" i can't get a connection........");
	    }
	}
	
	private void closeConnection()
	{
		if ( conn != null ) 
		{
			connMgr.freeConnection("aview", conn);
			conn = null;
		}		
	}
	
	public boolean insertCoolMsgClob(CdAlertBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;

		int fldidx = 0;

		String query1 = "select AlertKey.nextval from cview.cd_alert";

		String query2 = "insert into cd_alert (fldidx, flddata, fldtype, fldwritedate)"+
						" values("+
							" ?, empty_clob(), ?, sysdate"+
						")";

		String query3 = "select flddata from cd_alert where fldidx=? for update";

		try 
		{

			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				fldidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setInt   (1, fldidx);
			pstmt2.setString(2, bean.getFldtype());
		    pstmt2.executeUpdate();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setInt   (1, fldidx);
	    	rs2 = pstmt3.executeQuery();
			if(rs2.next()){
				CLOB clob = ((OracleResultSet)rs2).getCLOB(1);
                Writer writer = clob.getCharacterOutputStream();
                ClobUtil.writeClob(writer, bean.getFlddata());
            }
			rs2.close();
			pstmt3.close();

			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CoolMsgDatabase:insertCoolMsgClob]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
                if(rs2 != null )		rs2.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt2 != null)		pstmt2.close();
				if(pstmt3 != null)		pstmt3.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	public boolean insertCoolMsg(CdAlertBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt2 = null;
		int fldidx = 0;

		String query2 = "insert into cd_alert (fldidx, flddata, fldtype, fldwritedate)"+
						" values("+
						"                       AlertKey.nextval, ?, ?, sysdate"+
						")";

		try 
		{
			conn.setAutoCommit(false);
			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, bean.getFlddata());
			pstmt2.setString(2, bean.getFldtype());
		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CoolMsgDatabase:insertCoolMsg]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt2 != null)		pstmt2.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	public CdAlertBean getCdAlertCase(String fldidx)
	{
		getConnection();
		CdAlertBean bean = new CdAlertBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";

		query = " select * from cd_alert where fldidx=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString   (1, fldidx);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){
				bean.setFldidx	(rs.getString(1));
				bean.setFlddata	(ClobUtil.getClobOutput(rs.getCharacterStream(2)));
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CoolMsgDatabase:getCdAlertCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	/**
     * 프로시져 호출
     */
    public String call_sp_sync_db_all() 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
		String query1 = "{CALL Sync_Db_All}";

	    try{

			cstmt = conn.prepareCall(query1);				
			cstmt.execute();
			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[CoolMsgDatabase:call_sp_sync_db_all]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	public Vector getBkAlertList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

       	String query =	" select * from bk_alert order BY fldwritedate DESC ";

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
			System.out.println("[CoolMsgDatabase:getBkAlertList]"+e);
			System.out.println("[CoolMsgDatabase:getBkAlertList]"+query);
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


	public boolean deleteCdMessage(String srchmessage)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from cd_message "+
						" where to_char(searchmessage) like '%"+srchmessage+"%' ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
						
		    pstmt.executeUpdate();

			conn.commit();
		    
	  	} catch (Exception e) {
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
