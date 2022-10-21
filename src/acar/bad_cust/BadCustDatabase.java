package acar.bad_cust;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;


public class BadCustDatabase
{
	private Connection conn = null;
	public static BadCustDatabase db;
	
	public static BadCustDatabase getInstance()
	{
		if(BadCustDatabase.db == null)
			BadCustDatabase.db = new BadCustDatabase();
		return BadCustDatabase.db;
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
	 *	불량임차인 리스트
	 */
	public Vector getBadCustAll(String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT * FROM BAD_CUST";

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))	query+= " where bc_nm like '%" + t_wd + "%'";
			if(s_kd.equals("2"))	query+= " where bc_addr like '%" + t_wd + "%'";
			if(s_kd.equals("3"))	query+= " where bc_firm_nm like '%" + t_wd + "%'";
			if(s_kd.equals("4"))	query+= " where bc_ent_no like '%" + t_wd + "%'";
			if(s_kd.equals("5"))	query+= " where replace(bc_lic_no,'-','') like replace('%"+t_wd+"%', '-','')";
			if(s_kd.equals("6"))	query+= " where replace(bc_m_tel,'-','') like replace('%"+t_wd+"%', '-','')";
			if(s_kd.equals("7"))	query+= " where bc_email like '%" + t_wd + "%'";
			if(s_kd.equals("8"))	query+= " where replace(bc_fax,'-','') like replace('%"+t_wd+"%', '-','')";
		}

		query += " order by reg_dt ";

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
			System.out.println("[BadCustDatabase:getBadCustAll]"+e);
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
	 *	불량임차인 정보
	 */
	public BadCustBean getBadCustBean(String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BadCustBean bean = new BadCustBean();
        String query = "";
        query = " SELECT SEQ, BC_NM, BC_LIC_NO, BC_ADDR, BC_FIRM_NM, BC_CONT, REG_ID, REG_DT, BC_ENT_NO, BC_M_TEL, BC_EMAIL, BC_FAX "+
				" FROM BAD_CUST where SEQ='" + seq +"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
	            bean.setSeq			(rs.getString("SEQ"));				
			    bean.setBc_nm		(rs.getString("BC_NM"));			
			    bean.setBc_ent_no	(rs.getString("BC_ENT_NO"));	
			    bean.setBc_lic_no	(rs.getString("BC_LIC_NO")==null?"":rs.getString("BC_LIC_NO"));	
			    bean.setBc_addr		(rs.getString("BC_ADDR")==null?"":rs.getString("BC_ADDR"));		
			    bean.setBc_firm_nm	(rs.getString("BC_FIRM_NM")==null?"":rs.getString("BC_FIRM_NM"));
				bean.setBc_cont		(rs.getString("BC_CONT")==null?"":rs.getString("BC_CONT"));		
			    bean.setReg_id		(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));		
			    bean.setReg_dt		(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
			    bean.setBc_m_tel	(rs.getString("BC_M_TEL")==null?"":rs.getString("BC_M_TEL"));	
			    bean.setBc_email	(rs.getString("BC_EMAIL")==null?"":rs.getString("BC_EMAIL"));		
			    bean.setBc_fax		(rs.getString("BC_FAX")==null?"":rs.getString("BC_FAX"));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[BadCustDatabase:getBadCustBean]"+e);
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

	/**
	 *	불량임차인 정보 (내용만)
	 */
	public String getBadCustCont(String bc_ent_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String content = "";
        String query = "";
        query = " SELECT bc_firm_nm, bc_cont FROM BAD_CUST where bc_ent_no=replace('"+bc_ent_no+"','-','')";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				content = "피해업체:"+rs.getString("BC_FIRM_NM") +", 피해내용:"+rs.getString("BC_CONT");
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[BadCustDatabase:getBadCustCont]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return content;
		}
	}	

	/**
	 *	불량임차인 주민등록번호 중복 체크
	 */
	public int checkEntNo(String bc_ent_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean flag = true;
		int count = 0;
		String query = "select count(*) from bad_cust where bc_ent_no=replace('"+bc_ent_no+"','-','')";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[BadCustDatabase:checkSSN]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	

	/**
	 *	불량임차인 주민등록번호 중복 체크
	 */
	public int checkEntNo(String bc_ent_no, String bc_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean flag = true;
		int count = 0;
		String query = "select count(0) from bad_cust where bc_ent_no=replace('"+bc_ent_no+"','-','') and replace(bc_nm,' ','')=replace('"+bc_nm+"',' ','')";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[BadCustDatabase:checkSSN]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	

	//불량임차인 삽입
	public int insertBadCust(BadCustBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		int count = 0;

		String id_sql = "select nvl(lpad(max(seq)+1,6,'0'),'000001') from BAD_CUST";
		String seq="";
		try{
			pstmt = conn.prepareStatement(id_sql);
	    	rs = pstmt.executeQuery();
	    	if(rs.next())
	    	{
	    		seq=rs.getString(1)==null?"":rs.getString(1);
	    	}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
	  		e.printStackTrace();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  	}
	  	
		if(seq.equals(""))	seq = "000001";
		bean.setSeq(seq);
		
		String query = " INSERT INTO BAD_CUST (SEQ,BC_NM,BC_ENT_NO,BC_LIC_NO,BC_ADDR, BC_FIRM_NM,BC_CONT,REG_ID,REG_DT,BC_M_TEL,BC_EMAIL,BC_FAX)"+
						" values (?,?,replace(?,'-',''),?,?, ?,?,?,to_char(sysdate,'YYYYMMDD'),?,?,?)";
		

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query);
            pstmt1.setString(1, bean.getSeq().trim());
            pstmt1.setString(2, bean.getBc_nm().trim());
			pstmt1.setString(3, bean.getBc_ent_no().trim());
			pstmt1.setString(4, bean.getBc_lic_no().trim());
			pstmt1.setString(5, bean.getBc_addr().trim());
			pstmt1.setString(6, bean.getBc_firm_nm().trim());
			pstmt1.setString(7, bean.getBc_cont().trim());
			pstmt1.setString(8, bean.getReg_id().trim());
			pstmt1.setString(9, bean.getBc_m_tel().trim());
			pstmt1.setString(10,bean.getBc_email().trim());
			pstmt1.setString(11,bean.getBc_fax().trim());
		    count = pstmt1.executeUpdate();
			pstmt1.close();

			conn.commit();
			
		} catch (SQLException e) {
			System.out.println("[BadCustDatabase:insertBadCust]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[BadCustDatabase:insertBadCust]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//불량임차인 수정
	public int updateBadCust(BadCustBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		
        String query = " UPDATE BAD_CUST SET"+
						" BC_LIC_NO=?, BC_ADDR=?, BC_FIRM_NM=?, BC_CONT=?, BC_M_TEL=?, BC_EMAIL=?, BC_FAX=?"+
						" WHERE SEQ=?";
 		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
            pstmt.setString(1, bean.getBc_lic_no().trim());
            pstmt.setString(2, bean.getBc_addr().trim());
            pstmt.setString(3, bean.getBc_firm_nm().trim());
            pstmt.setString(4, bean.getBc_cont().trim());
            pstmt.setString(5, bean.getBc_m_tel().trim());
            pstmt.setString(6, bean.getBc_email().trim());
            pstmt.setString(7, bean.getBc_fax().trim());
            pstmt.setString(8, bean.getSeq().trim());
			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[BadCustDatabase:updateBadCust]\n"+e);
			e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println("[BadCustDatabase:updateBadCust]\n"+e);
			e.printStackTrace();
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

	//불량임차인 삭제
	public int deleteBadCust(String where)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = " delete from BAD_CUST where bc_ent_no in "+where;

 		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[BadCustDatabase:deleteBadCust:seq]\n"+e);
			e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println("[BadCustDatabase:deleteBadCust]\n"+e);
			e.printStackTrace();
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

	/**
	 *	불량임차인 체크
	 */
	public Vector getBadCustRentCheck(String firm_nm, String nm, String ent_no, String lic_no, String m_tel, String h_tel, String o_tel, String email, String fax, String e_tel1, String e_tel2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT * FROM BAD_CUST"+
				" where ( REPLACE(REPLACE(REPLACE(bc_nm,' ',''),'(주)',''),'주식회사','') like REPLACE(REPLACE(REPLACE('%"+firm_nm+"%',' ',''),'(주)',''),'주식회사','') \n"+
			    " ";

		if(!nm.equals(""))			query +=" OR REPLACE(REPLACE(bc_nm,' ',''),'-','') = REPLACE(REPLACE('"+nm+"',' ',''),'-','') ";
		if(!ent_no.equals(""))		query +=" OR REPLACE(REPLACE(bc_ent_no,' ',''),'-','') = REPLACE(REPLACE('"+ent_no+"',' ',''),'-','') ";
		if(!lic_no.equals(""))		query +=" OR REPLACE(REPLACE(bc_lic_no,' ',''),'-','') = REPLACE(REPLACE('"+lic_no+"',' ',''),'-','') ";
		if(!m_tel.equals(""))		query +=" OR REPLACE(REPLACE(bc_m_tel,' ',''),'-','')  = REPLACE(REPLACE('"+m_tel+"',' ',''),'-','') ";
		if(!h_tel.equals(""))		query +=" OR REPLACE(REPLACE(bc_m_tel,' ',''),'-','')  = REPLACE(REPLACE('"+h_tel+"',' ',''),'-','') ";
		if(!o_tel.equals(""))		query +=" OR REPLACE(REPLACE(bc_m_tel,' ',''),'-','')  = REPLACE(REPLACE('"+o_tel+"',' ',''),'-','') ";
		if(!e_tel1.equals(""))		query +=" OR REPLACE(REPLACE(bc_m_tel,' ',''),'-','')  = REPLACE(REPLACE('"+e_tel1+"',' ',''),'-','') ";
		if(!e_tel2.equals(""))		query +=" OR REPLACE(REPLACE(bc_m_tel,' ',''),'-','')  = REPLACE(REPLACE('"+e_tel2+"',' ',''),'-','') ";
		if(!email.equals(""))		query +=" OR REPLACE(REPLACE(bc_email,' ',''),'-','')  = REPLACE(REPLACE('"+email+"',' ',''),'-','') ";
		if(!fax.equals(""))			query +=" OR REPLACE(REPLACE(bc_fax,' ',''),'-','')    = REPLACE(REPLACE('"+fax+"',' ',''),'-','') ";

		query +=" ) ";

		query += " order by reg_dt ";

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

			//System.out.println("[BadCustDatabase:getBadCustRentCheck]"+query);

		} catch (SQLException e) {
			System.out.println("[BadCustDatabase:getBadCustRentCheck]"+e);
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