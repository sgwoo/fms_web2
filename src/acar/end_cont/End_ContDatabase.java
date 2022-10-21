package acar.end_cont;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.util.*;
import java.text.*;
import acar.database.*;


public class End_ContDatabase
{
	private Connection conn = null;
	public static End_ContDatabase db;
	
	public static End_ContDatabase getInstance()
	{
		if(End_ContDatabase.db == null)
			End_ContDatabase.db = new End_ContDatabase();
		return End_ContDatabase.db;
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
	

	/*계약만기 메모 등록*/
	public boolean insertEnd_Cont(End_ContBean memo) {
		getConnection();

       	PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		int s_seq = 0;
		
		boolean flag = true;

		query="INSERT INTO end_cont_mm (rent_mng_id, rent_l_cd, seq, reg_id, reg_dt, re_bus_id, content)"
                + " values( ?, ?, ?, ?, sysdate, ?, ? )";
	
		String query_id = " select   nvl(max(seq)+1 , 1 )  ID from end_cont_mm ";
		
		
		try 
			{			
				conn.setAutoCommit(false);
					
				pstmt1 = conn.prepareStatement(query_id);
	    		rs = pstmt1.executeQuery();
				while(rs.next())
				{
					s_seq = rs.getInt(1);
				}
				rs.close();
				pstmt1.close();
				
				pstmt2 = conn.prepareStatement(query);
				pstmt2.setString(1, memo.getRent_mng_id());
				pstmt2.setString(2, memo.getRent_l_cd());
				pstmt2.setInt(3, s_seq);
				pstmt2.setString(4, memo.getReg_id());
				pstmt2.setString(5, memo.getRe_bus_id());
				pstmt2.setString(6, memo.getContent());
				pstmt2.executeUpdate();
				pstmt2.close();
			    conn.commit();

					
	  	} catch (Exception e) {
			System.out.println("[End_ContDatabase:insertEnd_Cont]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
	  	} finally {
			try{
				conn.setAutoCommit(true);
				if ( rs != null )		rs.close();
				if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
		
		/*계약만기 담당자 조회*/
		
	public Hashtable selectEnd_Cont(String rent_mng_id, String rent_l_cd) {
	 
        getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
	

			query="select a.*, b.user_nm as re_bus_nm from end_cont a, users b where a.re_bus_id = b.user_id(+) and a.rent_mng_id = '"+rent_mng_id+"' and a.rent_l_cd = '"+rent_l_cd+"' ";

//System.out.println("selectEnd_Cont::"+query);
	
	try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();   
				
	    			
				if(rs.next())
				{				
					
					for(int pos =1; pos <= rsmd.getColumnCount();pos++)
					{
						 String columnName = rsmd.getColumnName(pos);
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
					}
					
				}
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				System.out.println("[End_ContDatabase:selectEnd_Cont]"+e);
				System.out.println("[End_ContDatabase:selectEnd_Cont]"+query);
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

	/*계약만기 담당자 변경*/
	public int updateEnd_Cont(String rent_mng_id, String rent_l_cd, String reg_id, String re_bus_id, String content) {
			getConnection();
	
	        PreparedStatement pstmt = null;
			int count = 0;
			String query = "";
	
			    query = " update end_cont set \n"+
						" reg_dt = to_char(sysdate,'YYYYMMDD'),  \n"+
						" reg_id = '"+reg_id+"',  \n"+
						" content	= '"+content+"',  \n"+
						" re_bus_id = '"+re_bus_id+"'"+
						" where rent_mng_id = '"+rent_mng_id+"' and rent_l_cd = '"+rent_l_cd+"' ";
	
	try 
			{			
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				count = pstmt.executeUpdate();
				pstmt.close();
				conn.commit();
			} catch (SQLException e) {
				System.out.println("[End_ContDatabase:updateEnd_Cont]\n"+e);
				System.out.println("[End_ContDatabase:updateEnd_Cont]\n"+query);
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

	/*계약만기 담당자 조회*/
	
	public int getCntEnd_Cont(String rent_mng_id, String rent_l_cd) {
	 
        getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		String query = "";

		query="select count(*) from end_cont where rent_mng_id = '"+rent_mng_id+"' and rent_l_cd = '"+rent_l_cd+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();   
			
			if(rs.next())
			{				
				cnt	= rs.getInt(1);
			}		
			rs.close();
			pstmt.close();
    			
		} catch (SQLException e) {
			System.out.println("[End_ContDatabase:getCntEnd_Cont]"+e);
			System.out.println("[End_ContDatabase:getCntEnd_Cont]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}
	
	/**
	 *	대여만료 메모
	 */
	public Vector getEndContMemo(String m_id, String l_cd) {
        getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query =	" select * from end_cont_mm "+
						" where RENT_MNG_ID='"+m_id+"' and RENT_L_CD='"+l_cd+"'";
	
		query += " order by REG_DT desc ";		

		try {
			pstmt = conn.prepareStatement(query);
			
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				End_ContBean ins_mm = new End_ContBean();
				ins_mm.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ins_mm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ins_mm.setSeq(rs.getInt("SEQ"));
				ins_mm.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				ins_mm.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				ins_mm.setRe_bus_id(rs.getString("RE_BUS_ID")==null?"":rs.getString("RE_BUS_ID"));
				ins_mm.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				
				vt.add(ins_mm);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {          
				System.out.println("[AddCarAccidDatabase:getEndContMemo]\n"+e);
				e.printStackTrace();          
            
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            closeConnection();
		}				
		return vt;
	}


}

	