/**
 * 당직근무
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 07. 07
 * @ last modify date : 
 */

package acar.fax_word;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.util.*;
import java.text.*;
import acar.database.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class Fax_wordDatabase
{
	private Connection conn = null;
	public static Fax_wordDatabase db;
	
	public static Fax_wordDatabase getInstance()
	{
		if(Fax_wordDatabase.db == null)
			Fax_wordDatabase.db = new Fax_wordDatabase();
		return Fax_wordDatabase.db;
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
     *  지식전체조회
     */

public Vector Fax_word_list(String user_id) {
		getConnection();
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String subQuery = "";
		String query = "";

		
				query = " select a.*, b.user_nm \n"
						+ " from fax_word a, users b \n"
						+ " where a.user_id=b.user_id(+) \n"
						+ " and a.user_id='"+user_id+"'\n";

		
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
			System.out.println("[Fax_wordDatabase:Fax_word_list]"+e);
			System.out.println("[Fax_wordDatabase:Fax_word_list]"+query);
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
     * 지식인 리플 등록
     */

  public int insertFax_word(Fax_wordBean bean) {
		getConnection();

        PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		int seq = 0;


 	  	query_seq = " select nvl(max(seq)+1, 1) "
				   +" from fax_word ";	
                   
            query="INSERT INTO fax_word (user_id, seq, reg_dt, content)\n"
                + "values( ?, \n"
            	+ " ?,\n"
            	+ " to_char(sysdate,'YYYYMMDD'), \n"
            	+ " ? \n"
				+ " )";

try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);

            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString  (1, bean.getUser_id()	);
			pstmt.setInt   (2, seq				);
			pstmt.setString(3, bean.getContent()	);
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println("[Fax_wordDatabase:insertFax_word]\n"+e);
			System.out.println("[Fax_wordDatabase:insertFax_word]\n"+query);

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
     * 지식 삭제 
	*/

    public int DelFax_word(Fax_wordBean bean) {
		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " DELETE  FROM fax_word \n"+
				" where user_id=? and seq=? ";

	try {		
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, bean.getUser_id());
			pstmt.setInt(2, bean.getSeq());


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[Fax_wordDatabase:DelFax_word]\n"+e);
			System.out.println("[Fax_wordDatabase:DelFax_word]\n"+query);
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
