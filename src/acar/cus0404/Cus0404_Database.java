/**
 * 순회방문 관리
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 11. 17. 월.
 * @ last modify date : 
 */
package acar.cus0404;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;
import acar.client.*;

public class Cus0404_Database
{
	private Connection conn = null;
	public static Cus0404_Database db;
	
	public static Cus0404_Database getInstance()
	{
		if(Cus0404_Database.db == null)
			Cus0404_Database.db = new Cus0404_Database();
		return Cus0404_Database.db;
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
	*	순회방문업체 조회 - 2003.11.17.월.
	*	- 
	*/
	public ClientBean[] getClientList(ConditionBean cnd){

		getConnection();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Collection<ClientBean> col = new ArrayList<ClientBean>();
		String query = "SELECT a.client_id, b.client_st, b.client_nm, b.firm_nm, b.o_tel, b.m_tel "+
			" FROM cont a, client b "+
			" WHERE a.client_id = b.client_id "+
			" AND a.mng_id = '000010' "+
			" AND use_yn = 'Y' "+
			" GROUP BY a.client_id, b.client_st, b.client_nm, b.firm_nm, b.o_tel, b.m_tel order BY a.client_id, b.client_st, b.client_nm, b.firm_nm, b.o_tel, b.m_tel";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while(rs.next())
			{
				ClientBean client = new ClientBean();				
				client.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				client.setClient_st(rs.getString("CLIENT_ST")==null?"":rs.getString("CLIENT_ST"));
				client.setClient_nm(rs.getString("CLIENT_NM")==null?"":rs.getString("CLIENT_NM"));
				client.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				client.setO_tel(rs.getString("O_TEL")==null?"":rs.getString("O_TEL"));
				client.setM_tel(rs.getString("M_TEL")==null?"":rs.getString("M_TEL"));
				
				col.add(client);
			}
            rs.close();
            pstmt.close();
		}catch(SQLException e){
			System.out.println("[Cus0404_Database:getClientList(ConditionBean cnd)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return (ClientBean[])col.toArray(new ClientBean[0]);
	}
	
}