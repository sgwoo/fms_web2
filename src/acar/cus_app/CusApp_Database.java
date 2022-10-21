/**
 * 고객지원 -> 영업지원
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004. 8. 11.
 * @ last modify date : 
 */
package acar.cus_app;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;

public class CusApp_Database
{
	private Connection conn = null;
	public static CusApp_Database db;
	
	public static CusApp_Database getInstance()
	{
		if(CusApp_Database.db == null)
			CusApp_Database.db = new CusApp_Database();
		return CusApp_Database.db;
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
	    	System.out.println(" I can't get a connection........");
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
	*	거래처평가 Bean에 데이터 넣기 2004.8.12.
	*/
	 private CusAppBean makeCusAppBean(ResultSet results) throws DatabaseException {

        try {
            CusAppBean bean = new CusAppBean();
			
			bean.setClient_id(results.getString("CLIENT_ID"));
			bean.setAaa(results.getString("AAA"));
			bean.setAab(results.getString("AAB"));
			bean.setAac(results.getString("AAC"));
			bean.setAad(results.getString("AAD"));
			bean.setAae(results.getString("AAE"));
			bean.setAba(results.getString("ABA"));
			bean.setAbb(results.getString("ABB"));
			bean.setAbc(results.getString("ABC"));
			bean.setAbd(results.getString("ABD"));
			bean.setAca(results.getString("ACA"));
			bean.setAcb(results.getString("ACB"));
			bean.setAcc(results.getString("ACC"));
			bean.setAda(results.getString("ADA"));
			bean.setAdb(results.getString("ADB"));
			bean.setBaa(results.getString("BAA"));
			bean.setBba(results.getString("BBA"));
			bean.setBbb(results.getString("BBB"));
			bean.setBbc(results.getString("BBC"));
			bean.setBbd(results.getString("BBD"));
			bean.setBca(results.getString("BCA"));
			bean.setBcb(results.getString("BCB"));
			bean.setBcc(results.getString("BCC"));
			bean.setBcd(results.getString("BCD"));
			bean.setBda(results.getString("BDA"));
			bean.setBdb(results.getString("BDB"));
			bean.setBdc(results.getString("BDC"));
			bean.setBdd(results.getString("BDD"));
			bean.setCaa(results.getString("CAA"));
			bean.setCbb(results.getString("CBB"));
			bean.setCcc(results.getString("CCC"));
			bean.setCdd(results.getString("CDD"));

			return bean;

        }catch (SQLException e) {
			System.out.println("[CusApp_Database:makeCusAppBean(ResultSet results)]"+e);
            throw new DatabaseException(e.getMessage());
        }
	}

	/*
	*	거래처 평가 내역 검색 : 2004.08.12.
	*/
	public CusAppBean getCus_app(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CusAppBean bean = new CusAppBean();

		String query = "SELECT client_id,aaa,aab,aac,aad,aae,aba,abb,abc,abd,aca,acb,acc,ada,adb,baa,bba,bbb,bbc,bbd,bca,bcb,bcc,bcd,bda,bdb,bdc,bdd,caa,cbb,ccc,cdd FROM cus_app WHERE client_id = ?";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client_id);
		    rs = pstmt.executeQuery();

            while(rs.next()){
				bean = makeCusAppBean(rs);
            }
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CusApp_Database:getCus_app(String client_id)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
    }

	/*
	*	만료예정 계약 검색 : 2004.08.11.
	*/
	public Vector getCus_AppList(String t_wd,String sort_gubun,String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "SELECT a.client_id, nvl(a.firm_nm,a.client_nm) firm_nm, a.client_nm, c.rent_dt, nvl(d.cnt,0) cnt, b.caa, b.cbb, b.ccc, b.cdd "+
						" FROM client a, cus_app b,  "+
						"	 (SELECT client_id, min(rent_dt) rent_dt FROM cont GROUP BY client_id) c, "+
						"	 (SELECT client_id, count(*) cnt FROM cont WHERE use_yn = 'Y' GROUP BY client_id) d "+
						" WHERE a.client_id = b.client_id(+) "+
						" AND a.client_id = c.client_id(+) "+
						" AND a.client_id = d.client_id(+) "+
						" AND firm_nm like '%"+t_wd+"%' "+
						" ORDER BY "+sort_gubun+" "+sort;

		try 
		{
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
			System.out.println("[CusApp_Database:getCus_AppList(String t_wd,String sort_gubun,String sort)]\n"+e);
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
	*	거래처 기초자료 조회 2004.08.13.
	*/
	public Hashtable getClientBase(String client_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "SELECT a.client_id, b.open_year, b.firm_price, b.firm_day, b.firm_price_y, b.firm_day_y, b.bus_cdt, b.bus_itm, "+
						"	   to_number(to_char(sysdate,'yyyy'))-to_number(substr(a.rent_dt,1,4))+1 YEAR_CNT, "+
						"	   a.rent_dt FIRST_RENT_DT "+
						"FROM (SELECT client_id, min(rent_dt) rent_dt FROM cont GROUP BY client_id) a, client b "+
						"WHERE a.client_id = b.client_id "+
						"  AND a.client_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,client_id);
			rs = pstmt.executeQuery();
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
            pstmt.close();
		}catch(Exception e){
			System.out.println("[CusApp_Database:getClientBase(String client_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return ht;
		}
	}


	/**
     * 거래처 평가항목 등록 2004.08.13.
     */
	public int insertCus_app(CusAppBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
		query = "INSERT INTO cus_app VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString( 1,bean.getClient_id());
			pstmt.setString( 2,bean.getAaa());
			pstmt.setString( 3,bean.getAab());
			pstmt.setString( 4,bean.getAac());
			pstmt.setString( 5,bean.getAad());
			pstmt.setString( 6,bean.getAae());
			pstmt.setString( 7,bean.getAba());
			pstmt.setString( 8,bean.getAbb());
			pstmt.setString( 9,bean.getAbc());
			pstmt.setString(10,bean.getAbd());
			pstmt.setString(11,bean.getAca());
			pstmt.setString(12,bean.getAcb());
			pstmt.setString(13,bean.getAcc());
			pstmt.setString(14,bean.getAda());
			pstmt.setString(15,bean.getAdb());
			pstmt.setString(16,bean.getBaa());
			pstmt.setString(17,bean.getBba());
			pstmt.setString(18,bean.getBbb());
			pstmt.setString(19,bean.getBbc());
			pstmt.setString(20,bean.getBbd());
			pstmt.setString(21,bean.getBca());
			pstmt.setString(22,bean.getBcb());
			pstmt.setString(23,bean.getBcc());
			pstmt.setString(24,bean.getBcd());
			pstmt.setString(25,bean.getBda());
			pstmt.setString(26,bean.getBdb());
			pstmt.setString(27,bean.getBdc());
			pstmt.setString(28,bean.getBdd());
			pstmt.setString(29,bean.getCaa());
			pstmt.setString(30,bean.getCbb());
			pstmt.setString(31,bean.getCcc());
			pstmt.setString(32,bean.getCdd());
			result = pstmt.executeUpdate();

		    pstmt.close();
			conn.commit();
		}catch(Exception e){
			System.out.println("[CusApp_Database:insertCus_app(CusAppBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	/**
     * 거래처 평가항목 등록 2004.08.13.
     */
	public int updateCus_app(CusAppBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
		query = "UPDATE cus_app SET aaa=?,aab=?,aac=?,aad=?,aae=?,aba=?,abb=?,abc=?,abd=?,aca=?,acb=?,acc=?,ada=?,adb=?,baa=?,bba=?,bbb=?,bbc=?,bbd=?,bca=?,bcb=?,bcc=?,bcd=?,bda=?,bdb=?,bdc=?,bdd=?,caa=?,cbb=?,ccc=?,cdd=? WHERE client_id=?";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString( 1,bean.getAaa());
			pstmt.setString( 2,bean.getAab());
			pstmt.setString( 3,bean.getAac());
			pstmt.setString( 4,bean.getAad());
			pstmt.setString( 5,bean.getAae());
			pstmt.setString( 6,bean.getAba());
			pstmt.setString( 7,bean.getAbb());
			pstmt.setString( 8,bean.getAbc());
			pstmt.setString( 9,bean.getAbd());
			pstmt.setString(10,bean.getAca());
			pstmt.setString(11,bean.getAcb());
			pstmt.setString(12,bean.getAcc());
			pstmt.setString(13,bean.getAda());
			pstmt.setString(14,bean.getAdb());
			pstmt.setString(15,bean.getBaa());
			pstmt.setString(16,bean.getBba());
			pstmt.setString(17,bean.getBbb());
			pstmt.setString(18,bean.getBbc());
			pstmt.setString(19,bean.getBbd());
			pstmt.setString(20,bean.getBca());
			pstmt.setString(21,bean.getBcb());
			pstmt.setString(22,bean.getBcc());
			pstmt.setString(23,bean.getBcd());
			pstmt.setString(24,bean.getBda());
			pstmt.setString(25,bean.getBdb());
			pstmt.setString(26,bean.getBdc());
			pstmt.setString(27,bean.getBdd());
			pstmt.setString(28,bean.getCaa());
			pstmt.setString(29,bean.getCbb());
			pstmt.setString(30,bean.getCcc());
			pstmt.setString(31,bean.getCdd());
			pstmt.setString(32,bean.getClient_id());
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[CusApp_Database:updateCus_app(CusAppBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
                if(pstmt != null) pstmt.close();
               	conn.setAutoCommit(true);
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

}