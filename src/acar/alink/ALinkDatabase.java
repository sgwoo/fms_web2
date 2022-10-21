package acar.alink;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import oracle.jdbc.*;
import oracle.sql.*;

public class ALinkDatabase
{
	private Connection conn = null;
	public static ALinkDatabase db;
	
	public static ALinkDatabase getInstance()
	{
		if(ALinkDatabase.db == null)
			ALinkDatabase.db = new ALinkDatabase();
		return ALinkDatabase.db;
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
	 *	전자문서 리스트
	 */
	public Vector getALinkHisList(String table_nm, String doc_type, String rent_l_cd, String rent_st, String im_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct a.*, nvl(c.INDEX_STATUS,'대기상태') as DOC_STAT, c.REG_DATE "+
				" from   alink."+table_nm+" a, "+
				"	     (  "+	
				"	       SELECT  "+	
				"	              substr(a.KEY_INDEX,2) KEY_INDEX,  "+	
				"	              a.INDEX_STATUS, "+	
                "                 a.REG_DATE  "+	
				"	       FROM   alink.CONTRACT_STATUS a ,  "+	
				"	              (  "+	
				"                   SELECT   "+	
                "                          KEY_INDEX, MAX( REG_DATE ) KEEP( DENSE_RANK FIRST ORDER BY KEY_INDEX, REG_DATE DESC ) AS seq  "+	
                "                   FROM   alink.CONTRACT_STATUS   "+	
                "                   GROUP BY KEY_INDEX  "+	
				"	              ) b  "+	
				"	       WHERE  substr(a.KEY_INDEX,2)=substr(b.KEY_INDEX,2) "+	
				"	       AND    a.REG_DATE=b.seq  "+	
				"	     ) c  "+	
				" where  a.doc_type='"+doc_type+"' and a.rent_l_cd||a.rent_st||a.im_seq=KEY_INDEX(+) "+
				" ";

		query += " and a.rent_l_cd='"+rent_l_cd+"'";
		query += " and a.rent_st='"+rent_st+"'";
		query += " and nvl(a.im_seq,'-')=nvl('"+im_seq+"','-')";
		query += " order by reg_dt";

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
			System.out.println("[ALinkDatabase:getALinkHisList]\n"+e);
			System.out.println("[ALinkDatabase:getALinkHisList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public Vector getALinkHisStatList(String table_nm, String doc_type, String rent_l_cd, String rent_st, String im_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct  b.* "+
				" from   alink."+table_nm+" a, alink.CONTRACT_STATUS b "+
				" where  a.doc_type='"+doc_type+"'  "+
				" ";

		query += " and a.rent_l_cd='"+rent_l_cd+"'";
		query += " and a.rent_st='"+rent_st+"'";
		query += " and nvl(a.im_seq,'-')=nvl('"+im_seq+"','-')";


		query += " and a.rent_l_cd||a.rent_st||a.im_seq=substr(b.KEY_INDEX,2) ";


		query += " order by b.reg_date";

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
			System.out.println("[ALinkDatabase:getALinkHisStatList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public Vector getALinkHisListM(String table_nm, String doc_type, String rent_l_cd, String rent_st, String im_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		if(table_nm.equals("lc_rent_link")){			table_nm = "lc_rent_link_m";			}
		
		query = " select a.*, decode(a.doc_yn, 'Y','등록','U','수정','D','취소') AS DOC_YN_NM, decode(b.status, '0','대기','1','처리중','2','완료','9','에러') AS DOC_STAT, b.res_msg, b.status, TO_DATE(b.upd_ymd||b.upd_time,'YYYYMMDDhh24miss') reg_date "+
				" from   alink."+table_nm+" a, alink.TMSG_QUEUE b "+
				" where  a.doc_type='"+doc_type+"' and a.tmsg_seq=b.tmsg_seq "+
				" ";

		query += " and a.rent_l_cd='"+rent_l_cd+"'";
		query += " and a.rent_st='"+rent_st+"'";
		query += " and nvl(a.im_seq,'-')=nvl('"+im_seq+"','-')";
		query += " order by a.reg_dt";

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
			System.out.println("[ALinkDatabase:getALinkHisListM]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public Vector getALinkHisStatListM(String table_nm, String doc_type, String rent_l_cd, String rent_st, String im_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		if(table_nm.equals("lc_rent_link")){			table_nm = "lc_rent_link_m";			}

		query = " select c.tmsg_nm, b.*, decode(a.doc_yn, 'Y','등록','U','수정','D','취소') AS DOC_YN_NM, decode(b.status, '0','대기','1','처리중','2','완료','9','에러') AS DOC_STAT, TO_DATE(b.upd_ymd||b.upd_time,'YYYYMMDDhh24miss') reg_date, REPLACE(b.content,'D:/inetpub/wwwroot','') file_name "+
				" from   alink."+table_nm+" a, alink.TMSG_QUEUE b, alink.TMSG_KNCD c "+
				" where  a.doc_type='"+doc_type+"'  "+
				" ";

		query += " and a.rent_l_cd='"+rent_l_cd+"'";
		query += " and a.rent_st='"+rent_st+"'";
		query += " and nvl(a.im_seq,'-')=nvl('"+im_seq+"','-')";


		query += " and a.doc_code=b.link_key and b.tmsg_kncd=c.tmsg_kncd ";


		query += " order by b.upd_ymd, b.upd_time";

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
			System.out.println("[ALinkDatabase:getALinkHisStatListM]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public Vector getALinkSearchList(String table_nm, String doc_type, String rent_l_cd, String rent_st, String im_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.* "+
				" from   alink."+table_nm+" a "+
				" where  a.doc_type='"+doc_type+"' "+
				" ";

		if(!rent_l_cd.equals(""))									query += " and a.rent_l_cd='"+rent_l_cd+"'";
		if(!doc_type.equals("5") && !rent_st.equals(""))			query += " and a.rent_st='"+rent_st+"'";
		if(!im_seq.equals(""))										query += " and a.im_seq='"+im_seq+"'";



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
			System.out.println("[ALinkDatabase:getALinkSearchList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}


	public boolean insertALink(String doc_code, String table_nm, String doc_type, String rent_l_cd, String rent_st, String im_seq, String mgr_nm, String mgr_email, String mgr_m_tel, String user_id, String mgr_nm2, String mgr_email2, String mgr_m_tel2, String link_com)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		if(table_nm.equals("lc_rent_link")){				table_nm  =  "lc_rent_link_m";			}

		String query1 = "insert into alink."+table_nm+" (doc_code, doc_type, reg_id, reg_dt, client_user_nm, client_user_email, client_user_tel, rent_l_cd, rent_st, im_seq, doc_yn )"+
						" values("+
						"                               ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, 'Y' "+
						")";

		if(doc_type.equals("2")){
			query1 = "insert into alink.lc_rent_link_m (doc_code, doc_type, reg_id, reg_dt, client_user_nm, client_user_email, client_user_tel, rent_l_cd, rent_st, im_seq, rent_suc_client_user_nm, rent_suc_client_user_email, rent_suc_client_user_tel, doc_yn )"+
						" values("+
						"                               ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Y' "+
						")";
		}

		//월렌트 모바일용
		if(table_nm.equals("rm_rent_link_m")){
			query1 = "insert into alink.rm_rent_link_m (doc_code, doc_type, reg_id, reg_dt, client_user_nm, client_user_email, client_user_tel, rent_l_cd, rent_st, im_seq, TMSG_SEQ, DOC_YN )"+
						" values("+
						"                               ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, ?, ? "+
						")";
		}

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query2 = "{CALL P_ALINK_REG_DOC (?,?)}";


		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, doc_code);
			pstmt.setString(2, doc_type);
			pstmt.setString(3, user_id);
			pstmt.setString(4, mgr_nm);
			pstmt.setString(5, mgr_email);
			pstmt.setString(6, mgr_m_tel);
			pstmt.setString(7, rent_l_cd);
			pstmt.setString(8, rent_st);
			pstmt.setString(9, im_seq);
			if(doc_type.equals("2")){
				pstmt.setString(10, mgr_nm2);
				pstmt.setString(11, mgr_email2);
				pstmt.setString(12, mgr_m_tel2);
			}
			if(table_nm.equals("rm_rent_link_m")){
				pstmt.setString(10, "RM"+doc_code);
				pstmt.setString(11, "Y");
			}
		    pstmt.executeUpdate();
			pstmt.close();

			//신차잔가계산 프로시저 호출
			cstmt = conn.prepareCall(query2);				
			cstmt.setString(1, doc_code);
			cstmt.setString(2, table_nm);
			cstmt.execute();
			cstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:insertALink]"+ e);
			System.out.println("[ALinkDatabase:insertALink]"+ table_nm);
			System.out.println("[ALinkDatabase:insertALink]"+ query1);
			System.out.println("[ALinkDatabase:insertALink]rent_l_cd="+ rent_l_cd);
			System.out.println("[ALinkDatabase:insertALink]rent_st="+ rent_st);
			System.out.println("[ALinkDatabase:insertALink]user_id="+ user_id);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	public boolean insertALink(String doc_code, String table_nm, String doc_type, String rent_l_cd, String rent_st, String im_seq, String mgr_nm, String mgr_email, String mgr_m_tel, String user_id, String mgr_nm2, String mgr_email2, String mgr_m_tel2, String link_com, String cms_type)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query1 = "insert into alink."+table_nm+" (doc_code, doc_type, reg_id, reg_dt, client_user_nm, client_user_email, client_user_tel, rent_l_cd, rent_st, im_seq, doc_yn )"+
						" values("+
						"                               ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, 'Y' "+
						")";

		if(doc_type.equals("2")){
			query1 = "insert into alink.lc_rent_link (doc_code, doc_type, reg_id, reg_dt, client_user_nm, client_user_email, client_user_tel, rent_l_cd, rent_st, im_seq, rent_suc_client_user_nm, rent_suc_client_user_email, rent_suc_client_user_tel, doc_yn )"+
						" values("+
						"                               ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Y' "+
						")";
		}

		//월렌트 모바일용
		if(table_nm.equals("rm_rent_link_m")){
			query1 = "insert into alink.rm_rent_link_m (doc_code, doc_type, reg_id, reg_dt, client_user_nm, client_user_email, client_user_tel, rent_l_cd, rent_st, im_seq, TMSG_SEQ, DOC_YN, cms_type )"+
						" values("+
						"                               ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, ?, ?, '"+cms_type+"' "+
						")";
		}

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query2 = "{CALL P_ALINK_REG_DOC (?,?)}";


		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, doc_code);
			pstmt.setString(2, doc_type);
			pstmt.setString(3, user_id);
			pstmt.setString(4, mgr_nm);
			pstmt.setString(5, mgr_email);
			pstmt.setString(6, mgr_m_tel);
			pstmt.setString(7, rent_l_cd);
			pstmt.setString(8, rent_st);
			pstmt.setString(9, im_seq);
			if(doc_type.equals("2")){
				pstmt.setString(10, mgr_nm2);
				pstmt.setString(11, mgr_email2);
				pstmt.setString(12, mgr_m_tel2);
			}
			if(table_nm.equals("rm_rent_link_m")){
				pstmt.setString(10, "RM"+doc_code);
				pstmt.setString(11, "Y");
			}
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

			//신차잔가계산 프로시저 호출
			cstmt = conn.prepareCall(query2);				
			cstmt.setString(1, doc_code);
			cstmt.setString(2, table_nm);
			cstmt.execute();
			cstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:insertALink]"+ e);
			System.out.println("[ALinkDatabase:insertALink]"+ table_nm);
			System.out.println("[ALinkDatabase:insertALink]"+ query1);
			System.out.println("[ALinkDatabase:insertALink]rent_l_cd="+ rent_l_cd);
			System.out.println("[ALinkDatabase:insertALink]rent_st="+ rent_st);
			System.out.println("[ALinkDatabase:insertALink]user_id="+ user_id);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}


	public boolean call_sp_alink_reg_doc(String doc_code, String table_nm)
	{
		getConnection();
		boolean flag = true;

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query2 = "{CALL P_ALINK_REG_DOC (?,?)}";


		try 
		{

			conn.setAutoCommit(false);

			//프로시저 호출
			cstmt = conn.prepareCall(query2);				
			cstmt.setString(1, doc_code);
			cstmt.setString(2, table_nm);
			cstmt.execute();
			cstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:call_sp_alink_reg_doc]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	public boolean updateAlinkDocyn(String doc_code, String table_nm, String doc_yn)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " update alink."+table_nm+" set doc_yn=? where doc_code=? ";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_yn);
			pstmt.setString(2, doc_code);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:updateAlinkDocyn]"+ e);
			System.out.println("[ALinkDatabase:updateAlinkDocyn]"+ query);
			System.out.println("[ALinkDatabase:updateAlinkDocyn=doc_yn]"+ doc_yn);
			System.out.println("[ALinkDatabase:updateAlinkDocyn=doc_code]"+ doc_code);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	public boolean updateAlinkDocyn(String doc_code, String table_nm, String doc_yn, String cms_type)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " update alink."+table_nm+" set doc_yn=?, cms_type=? where doc_code=? ";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_yn);
			pstmt.setString(2, cms_type);
			pstmt.setString(3, doc_code);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:updateAlinkDocyn]"+ e);
			System.out.println("[ALinkDatabase:updateAlinkDocyn]"+ query);
			System.out.println("[ALinkDatabase:updateAlinkDocyn=doc_yn]"+ doc_yn);
			System.out.println("[ALinkDatabase:updateAlinkDocyn=doc_code]"+ doc_code);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}


	public boolean updateAlinkMgrNm(String doc_code, String table_nm, String mgr_nm, String mgr_email, String mgr_m_tel, String mgr_nm2, String mgr_email2, String mgr_m_tel2)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " update alink."+table_nm+" set client_user_nm=?, client_user_email=?, client_user_tel=? ";
		
		if(table_nm.equals("LC_RENT_LINK")){
			query += ", rent_suc_client_user_nm=?, rent_suc_client_user_email=?, rent_suc_client_user_tel=? ";
		}
		
		query += " where doc_code=? ";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, mgr_nm);
			pstmt.setString(2, mgr_email);
			pstmt.setString(3, mgr_m_tel);

			if(table_nm.equals("LC_RENT_LINK")){
				pstmt.setString(4, mgr_nm2);
				pstmt.setString(5, mgr_email2);
				pstmt.setString(6, mgr_m_tel2);
				pstmt.setString(7, doc_code);
			}else{
				pstmt.setString(4, doc_code);
			}
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:updateAlinkMgrNm]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	public boolean updateAlinkTmsgSeq(String doc_code, String table_nm, String tmsg_seq)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " update alink."+table_nm+" set tmsg_seq=? where doc_code=? ";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, tmsg_seq);
			pstmt.setString(2, doc_code);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:updateAlinkTmsgSeq]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	/**
	 *	전자문서 리스트
	 */
	public Hashtable getALink(String table_nm, String doc_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String col_nm = "";
		String col_va = "";


		query = " select a.*, to_char(a.reg_dt,'YYYYMMDD') s_reg_dt "+
				" from   alink."+table_nm+" a "+
				" where  a.doc_code='"+doc_code+"' "+
				" ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 col_nm = rsmd.getColumnName(pos);

					 col_va = (rs.getString(col_nm))==null?"":rs.getString(col_nm).trim();

					 if(col_va.equals("null")) col_va = "";

					 if(col_nm.equals("fee_s_amt") || col_nm.equals("fee_v_amt") || col_nm.equals("fee_amt")) col_va = "0";

					 ht.put(col_nm, col_va);
				}
			}
            rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ALinkDatabase:getALink]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public String getALinkXML(String table_nm, String doc_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String sendXML = "";
		String value = "";
		String col_nm = "";
		String col_va = "";

		query = " select a.* "+
				" from   alink."+table_nm+" a "+
				" where  a.doc_code='"+doc_code+"' "+
				" ";


		try {


			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{								

				sendXML += "<root> ";
				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());

					 if(!columnName.equals("DOC_CODE")){

						 col_nm = columnName;
						 col_va = (rs.getString(columnName))==null?"":rs.getString(columnName).trim();

						 value = "<"+col_nm+">"+col_va+"</"+col_nm+"> ";

						 sendXML += value;

					 }
				}

				sendXML += "</root>";

			}
            rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ALinkDatabase:getALink]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sendXML;
		}
	}


	/**
	 *	전자문서 리스트
	 */
	public Vector getAlinkSendList(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = "";
		String kd_query = "";
		String st_query = "";

		String dt1 = "";
		String dt2 = "";

		dt1 = "to_char(reg_dt,'YYYYMM')";
		dt2 = "to_char(reg_dt,'YYYYMMDD')";


		if(gubun5.equals("4"))			dt_query += " where "+dt1+" = to_char(sysdate,'YYYYMM') \n";					//당월
		else if(gubun5.equals("5"))		dt_query += " where "+dt1+" = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') \n";		//전월
		else if(gubun5.equals("1"))		dt_query += " where "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";					//당일
		else if(gubun5.equals("2"))		dt_query += " where "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";				//전일
		else if(gubun5.equals("3"))		dt_query += " where "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') \n";//2일
		else if(gubun5.equals("6")){
			if(!st_dt.equals("") && end_dt.equals(""))	dt_query += " where "+dt2+" like replace('%"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) dt_query += " where "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(company_name, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(acar_user_nm, ' '))";	

		if(!what.equals("") && !t_wd.equals("")){
			if(dt_query.equals(""))		kd_query += " where ";
			else						kd_query += " and ";

			kd_query += " "+what+" like upper('%"+t_wd+"%')  \n";
	
		}

		if(!gubun1.equals("")){
			if(dt_query.equals("") && kd_query.equals(""))						st_query += " where ";
			else																st_query += " and ";

			st_query += " doc_type = '"+gubun1+"' \n";
		}

		query = " select b.use_yn, b.rent_mng_id, nvl(c.INDEX_STATUS,'대기상태') as doc_stat, c.reg_date, a.* \n"+

			    " from   ( "+

				"	       SELECT 'lc_rent_link' as link_table, \n"+
				"                 decode(doc_type,'1','장기대여계약서','2','장기대여계약서(승계)','3','장기대여계약서(연장)') doc_type_nm, doc_type, doc_yn, \n"+
				"                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt, \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm   \n"+
				"          FROM   alink.lc_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'rm_rent_link' as link_table, \n"+
				"                 decode(rent_st||im_seq,'1','월렌트계약서',decode(im_seq,'','월렌트계약서(연장)','월렌트계약서(임의연장)')) doc_type_nm, doc_type, doc_yn, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm   \n"+
				"          FROM   alink.rm_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'cms_link' as link_table, \n"+
				"                 'CMS출금이체신청서' doc_type_nm, doc_type, doc_yn, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, '' rent_start_dt, '' rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm \n"+
				"          FROM   alink.cms_link \n"+dt_query+kd_query+st_query+

			    "        ) a, "+
				"        cont b, "+	
				"	     (  "+	
				"	       SELECT  "+	
				"	              a.KEY_INDEX,  "+	
				"	              a.INDEX_STATUS, "+	
                "                 a.REG_DATE  "+	
				"	       FROM   alink.CONTRACT_STATUS a ,  "+	
				"	              (  "+	
				"                   SELECT   "+	
                "                          KEY_INDEX, MAX( REG_DATE ) KEEP( DENSE_RANK FIRST ORDER BY KEY_INDEX, REG_DATE DESC ) AS seq  "+	
                "                   FROM   alink.CONTRACT_STATUS   "+	
                "                   GROUP BY KEY_INDEX  "+	
				"	              ) b  "+	
				"	       WHERE  substr(a.KEY_INDEX,2)=substr(b.KEY_INDEX,2) "+	
				"	       AND    a.REG_DATE=b.seq  "+	
				"	     ) c  "+	
				" where  a.rent_l_cd=b.rent_l_cd and a.rent_l_cd||a.rent_st||a.im_seq=substr(c.key_index,2) "+
				"        and nvl(c.INDEX_STATUS,'대기상태') in ('대기상태','송신','수신확인','수정요청','재송신','승인대기') and a.doc_yn<>'D' ";

			query += " order by a.reg_dt";

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
			System.out.println("[ALinkDatabase:getAlinkSendList]\n"+e);
			System.out.println("[ALinkDatabase:getAlinkSendList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public Vector getAlinkSendList(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String ck_acar_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = " where reg_id='"+ck_acar_id+"' ";
		String kd_query = "";
		String st_query = "";

		String dt1 = "";
		String dt2 = "";

		dt1 = "to_char(reg_dt,'YYYYMM')";
		dt2 = "to_char(reg_dt,'YYYYMMDD')";


		if(gubun5.equals("4"))			dt_query += " and "+dt1+" = to_char(sysdate,'YYYYMM') \n";					//당월
		else if(gubun5.equals("5"))		dt_query += " and "+dt1+" = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') \n";		//전월
		else if(gubun5.equals("1"))		dt_query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";					//당일
		else if(gubun5.equals("2"))		dt_query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";				//전일
		else if(gubun5.equals("3"))		dt_query += " and "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') \n";//2일
		else if(gubun5.equals("6")){
			if(!st_dt.equals("") && end_dt.equals(""))	dt_query += " and "+dt2+" like replace('%"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) dt_query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(company_name, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(acar_user_nm, ' '))";	

		if(!what.equals("") && !t_wd.equals("")){
			if(dt_query.equals(""))		kd_query += " where ";
			else						kd_query += " and ";

			kd_query += " "+what+" like upper('%"+t_wd+"%')  \n";
	
		}

		if(!gubun1.equals("")){
			if(dt_query.equals("") && kd_query.equals(""))						st_query += " where ";
			else																st_query += " and ";

			st_query += " doc_type = '"+gubun1+"' \n";
		}

		query = " select b.use_yn, b.rent_mng_id, nvl(c.INDEX_STATUS,'대기상태') as doc_stat, c.reg_date, a.* \n"+

			    " from   ( "+

				"	       SELECT 'lc_rent_link' as link_table, \n"+
				"                 decode(doc_type,'1','장기대여계약서','2','장기대여계약서(승계)','3','장기대여계약서(연장)') doc_type_nm, doc_type, doc_yn, \n"+
				"                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt, \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm   \n"+
				"          FROM   alink.lc_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'rm_rent_link' as link_table, \n"+
				"                 decode(rent_st||im_seq,'1','월렌트계약서',decode(im_seq,'','월렌트계약서(연장)','월렌트계약서(임의연장)')) doc_type_nm, doc_type, doc_yn, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm   \n"+
				"          FROM   alink.rm_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'cms_link' as link_table, \n"+
				"                 'CMS출금이체신청서' doc_type_nm, doc_type, doc_yn, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, '' rent_start_dt, '' rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm \n"+
				"          FROM   alink.cms_link \n"+dt_query+kd_query+st_query+

			    "        ) a, "+
				"        cont b, "+	
				"	     (  "+	
				"	       SELECT  "+	
				"	              a.KEY_INDEX,  "+	
				"	              a.INDEX_STATUS, "+	
                "                 a.REG_DATE  "+	
				"	       FROM   alink.CONTRACT_STATUS a ,  "+	
				"	              (  "+	
				"                   SELECT   "+	
                "                          KEY_INDEX, MAX( REG_DATE ) KEEP( DENSE_RANK FIRST ORDER BY KEY_INDEX, REG_DATE DESC ) AS seq  "+	
                "                   FROM   alink.CONTRACT_STATUS   "+	
                "                   GROUP BY KEY_INDEX  "+	
				"	              ) b  "+	
				"	       WHERE  substr(a.KEY_INDEX,2)=substr(b.KEY_INDEX,2) "+	
				"	       AND    a.REG_DATE=b.seq  "+	
				"	     ) c  "+	
				" where  a.rent_l_cd=b.rent_l_cd and a.rent_l_cd||a.rent_st||a.im_seq=substr(c.key_index,2) "+
				"        and nvl(c.INDEX_STATUS,'대기상태') in ('대기상태','송신','수신확인','수정요청','재송신','승인대기') and a.doc_yn<>'D' ";



			query += " order by a.reg_dt";



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
			System.out.println("[ALinkDatabase:getAlinkSendList]\n"+e);
			System.out.println("[ALinkDatabase:getAlinkSendList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public Vector getAlinkEndList(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = "";
		String kd_query = "";
		String st_query = "";

		String dt1 = "";
		String dt2 = "";

		dt1 = "to_char(reg_dt,'YYYYMM')";
		dt2 = "to_char(reg_dt,'YYYYMMDD')";


		if(gubun5.equals("4"))			dt_query += " where "+dt1+" = to_char(sysdate,'YYYYMM') \n";					//당월
		else if(gubun5.equals("5"))		dt_query += " where "+dt1+" = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') \n";		//전월
		else if(gubun5.equals("1"))		dt_query += " where "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";					//당일
		else if(gubun5.equals("2"))		dt_query += " where "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";				//전일
		else if(gubun5.equals("3"))		dt_query += " where "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') \n";//2일
		else if(gubun5.equals("6")){
			if(!st_dt.equals("") && end_dt.equals(""))	dt_query += " where "+dt2+" like replace('%"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) dt_query += " where "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(company_name, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(acar_user_nm, ' '))";	

		if(!what.equals("") && !t_wd.equals("")){
			if(dt_query.equals(""))		kd_query += " where ";
			else						kd_query += " and ";

			kd_query += " "+what+" like upper('%"+t_wd+"%')  \n";
	
		}

		if(!gubun1.equals("")){
			if(dt_query.equals("") && kd_query.equals(""))						st_query += " where ";
			else																st_query += " and ";

			st_query += " doc_type = '"+gubun1+"' \n";
		}

		query = " select b.use_yn, b.rent_mng_id, nvl(c.INDEX_STATUS,'대기상태') as doc_stat, to_char(c.reg_date,'YYYYMMDD') reg_date, decode(b.rent_st,'1','신규','3','대차','4','증차') cont_rent_st, a.* \n"+

			    " from   ( "+

				"	       SELECT 'lc_rent_link' as link_table, \n"+
				"                 decode(doc_type,'1','장기대여계약서','2','장기대여계약서(승계)','3','장기대여계약서(연장)','6','리스계약서','7','리스계약서(승계)') doc_type_nm, doc_type, \n"+
				"                 doc_code, client_st, replace(company_name,'$$','&') company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt, \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm, doc_yn, car_st   \n"+
				"          FROM   alink.lc_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'rm_rent_link' as link_table, \n"+
				"                 decode(rent_st||im_seq,'1','월렌트계약서',decode(im_seq,'','월렌트계약서(연장)','월렌트계약서(임의연장)')) doc_type_nm, doc_type, \n"+
			    "                 doc_code, client_st, replace(company_name,'$$','&') company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm, doc_yn, car_st   \n"+
				"          FROM   alink.rm_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'cms_link' as link_table, \n"+
				"                 'CMS출금이체신청서' doc_type_nm, doc_type, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, '' rent_start_dt, '' rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm, doc_yn, '' car_st \n"+
				"          FROM   alink.cms_link \n"+dt_query+kd_query+st_query+

			    "        ) a, "+
				"        cont b, "+	
				"	     (  "+	
				"	       SELECT  "+	
				"	              a.KEY_INDEX,  "+	
				"	              a.INDEX_STATUS, "+	
                "                 a.REG_DATE  "+	
				"	       FROM   alink.CONTRACT_STATUS a ,  "+	
				"	              (  "+	
				"                   SELECT   "+	
                "                          KEY_INDEX, MAX( REG_DATE ) KEEP( DENSE_RANK FIRST ORDER BY KEY_INDEX, REG_DATE DESC ) AS seq  "+	
                "                   FROM   alink.CONTRACT_STATUS   "+	
                "                   GROUP BY KEY_INDEX  "+	
				"	              ) b  "+	
				"	       WHERE  substr(a.KEY_INDEX,2)=substr(b.KEY_INDEX,2) "+	
				"	       AND    a.REG_DATE=b.seq  "+	
				"	     ) c  "+	
				" where  a.rent_l_cd=b.rent_l_cd and a.rent_l_cd||a.rent_st||a.im_seq=substr(c.key_index,2) and a.doc_yn<>'D' "+
				"        and nvl(c.INDEX_STATUS,'대기상태') =  '완료' ";



			query += " order by a.reg_dt";



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
			System.out.println("[ALinkDatabase:getAlinkEndList]\n"+e);
			System.out.println("[ALinkDatabase:getAlinkEndList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public Vector getAlinkEndList(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String ck_acar_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = " where reg_id='"+ck_acar_id+"' ";
		String kd_query = "";
		String st_query = "";

		String dt1 = "";
		String dt2 = "";

		dt1 = "to_char(reg_dt,'YYYYMM')";
		dt2 = "to_char(reg_dt,'YYYYMMDD')";


		if(gubun5.equals("4"))			dt_query += " and "+dt1+" = to_char(sysdate,'YYYYMM') \n";					//당월
		else if(gubun5.equals("5"))		dt_query += " and "+dt1+" = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') \n";		//전월
		else if(gubun5.equals("1"))		dt_query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";					//당일
		else if(gubun5.equals("2"))		dt_query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";				//전일
		else if(gubun5.equals("3"))		dt_query += " and "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') \n";//2일
		else if(gubun5.equals("6")){
			if(!st_dt.equals("") && end_dt.equals(""))	dt_query += " and "+dt2+" like replace('%"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) dt_query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(company_name, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(acar_user_nm, ' '))";	

		if(!what.equals("") && !t_wd.equals("")){
			if(dt_query.equals(""))		kd_query += " where ";
			else						kd_query += " and ";

			kd_query += " "+what+" like upper('%"+t_wd+"%')  \n";
	
		}

		if(!gubun1.equals("")){
			if(dt_query.equals("") && kd_query.equals(""))						st_query += " where ";
			else																st_query += " and ";

			st_query += " doc_type = '"+gubun1+"' \n";
		}

		query = " select b.use_yn, b.rent_mng_id, nvl(c.INDEX_STATUS,'대기상태') as doc_stat, to_char(c.reg_date,'YYYYMMDD') reg_date, a.* \n"+

			    " from   ( "+

				"	       SELECT 'lc_rent_link' as link_table, \n"+
				"                 decode(doc_type,'1','장기대여계약서','2','장기대여계약서(승계)','3','장기대여계약서(연장)') doc_type_nm, doc_type, \n"+
				"                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt, \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm, car_st   \n"+
				"          FROM   alink.lc_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'rm_rent_link' as link_table, \n"+
				"                 decode(rent_st||im_seq,'1','월렌트계약서',decode(im_seq,'','월렌트계약서(연장)','월렌트계약서(임의연장)')) doc_type_nm, doc_type, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm, car_st   \n"+
				"          FROM   alink.rm_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'cms_link' as link_table, \n"+
				"                 'CMS출금이체신청서' doc_type_nm, doc_type, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, '' rent_start_dt, '' rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm, '' car_st \n"+
				"          FROM   alink.cms_link \n"+dt_query+kd_query+st_query+

			    "        ) a, "+
				"        cont b, "+	
				"	     (  "+	
				"	       SELECT  "+	
				"	              a.KEY_INDEX,  "+	
				"	              a.INDEX_STATUS, "+	
                "                 a.REG_DATE  "+	
				"	       FROM   alink.CONTRACT_STATUS a ,  "+	
				"	              (  "+	
				"                   SELECT   "+	
                "                          KEY_INDEX, MAX( REG_DATE ) KEEP( DENSE_RANK FIRST ORDER BY KEY_INDEX, REG_DATE DESC ) AS seq  "+	
                "                   FROM   alink.CONTRACT_STATUS   "+	
                "                   GROUP BY KEY_INDEX  "+	
				"	              ) b  "+	
				"	       WHERE  substr(a.KEY_INDEX,2)=substr(b.KEY_INDEX,2) "+	
				"	       AND    a.REG_DATE=b.seq  "+	
				"	     ) c  "+	
				" where  a.rent_l_cd=b.rent_l_cd and a.rent_l_cd||a.rent_st||a.im_seq=substr(c.key_index,2) "+
				"        and nvl(c.INDEX_STATUS,'대기상태') =  '완료' ";



			query += " order by a.reg_dt";



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
			System.out.println("[ALinkDatabase:getAlinkEndList]\n"+e);
			System.out.println("[ALinkDatabase:getAlinkEndList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public Vector getAlinkCancelList(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = "";
		String kd_query = "";
		String st_query = "";

		String dt1 = "";
		String dt2 = "";


		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(company_name, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(acar_user_nm, ' '))";	

		if(!what.equals("") && !t_wd.equals("")){
			if(dt_query.equals(""))		kd_query += " where ";
			else						kd_query += " and ";

			kd_query += " "+what+" like upper('%"+t_wd+"%')  \n";
	
		}

		if(!gubun1.equals("")){
			if(dt_query.equals("") && kd_query.equals(""))						st_query += " where ";
			else																st_query += " and ";

			st_query += " doc_type = '"+gubun1+"' \n";
		}

		query = " select b.use_yn, b.rent_mng_id, nvl(c.INDEX_STATUS,'대기상태') as doc_stat, c.reg_date, a.* \n"+

			    " from   ( "+

				"	       SELECT 'lc_rent_link' as link_table, \n"+
				"                 decode(doc_type,'1','장기대여계약서','2','장기대여계약서(승계)','3','장기대여계약서(연장)') doc_type_nm, doc_type, doc_yn, \n"+
				"                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt, \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm   \n"+
				"          FROM   alink.lc_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'rm_rent_link' as link_table, \n"+
				"                 decode(rent_st||im_seq,'1','월렌트계약서',decode(im_seq,'','월렌트계약서(연장)','월렌트계약서(임의연장)')) doc_type_nm, doc_type, doc_yn, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm   \n"+
				"          FROM   alink.rm_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'cms_link' as link_table, \n"+
				"                 'CMS출금이체신청서' doc_type_nm, doc_type, doc_yn, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, '' rent_start_dt, '' rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm \n"+
				"          FROM   alink.cms_link \n"+dt_query+kd_query+st_query+

			    "        ) a, "+
				"        cont b, "+	
				"	     (  "+	
				"	       SELECT  "+	
				"	              a.KEY_INDEX,  "+	
				"	              a.INDEX_STATUS, "+	
                "                 a.REG_DATE  "+	
				"	       FROM   alink.CONTRACT_STATUS a ,  "+	
				"	              (  "+	
				"                   SELECT   "+	
                "                          KEY_INDEX, MAX( REG_DATE ) KEEP( DENSE_RANK FIRST ORDER BY KEY_INDEX, REG_DATE DESC ) AS seq  "+	
                "                   FROM   alink.CONTRACT_STATUS   "+	
                "                   GROUP BY KEY_INDEX  "+	
				"	              ) b  "+	
				"	       WHERE  substr(a.KEY_INDEX,2)=substr(b.KEY_INDEX,2) "+	
				"	       AND    a.REG_DATE=b.seq  "+	
				"	     ) c  "+	
				" where  a.rent_l_cd=b.rent_l_cd and a.rent_l_cd||a.rent_st||a.im_seq=substr(c.key_index,2) "+
				"        and ( nvl(c.INDEX_STATUS,'대기상태') in ('승인거절','기간종료','계약파기','삭제') or a.doc_yn='D' )";

		dt1 = "to_char(nvl(c.REG_DATE,a.reg_dt),'YYYYMM')";
		dt2 = "to_char(nvl(c.REG_DATE,a.reg_dt),'YYYYMMDD')";


		if(gubun5.equals("4"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM') \n";					//당월
		else if(gubun5.equals("5"))		query += " and "+dt1+" = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') \n";	//전월
		else if(gubun5.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";				//당일
		else if(gubun5.equals("2"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";				//전일
		else if(gubun5.equals("3"))		query += " and "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') \n";//2일
		else if(gubun5.equals("6")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('%"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}


		query += " order by a.reg_dt";



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
			System.out.println("[ALinkDatabase:getAlinkCancelList]\n"+e);
			System.out.println("[ALinkDatabase:getAlinkCancelList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public Vector getAlinkCancelList(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String ck_acar_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = " where reg_id='"+ck_acar_id+"' ";
		String kd_query = "";
		String st_query = "";

		String dt1 = "";
		String dt2 = "";


		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(company_name, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(acar_user_nm, ' '))";	

		if(!what.equals("") && !t_wd.equals("")){
			if(dt_query.equals(""))		kd_query += " where ";
			else						kd_query += " and ";

			kd_query += " "+what+" like upper('%"+t_wd+"%')  \n";
	
		}

		if(!gubun1.equals("")){
			if(dt_query.equals("") && kd_query.equals(""))						st_query += " where ";
			else																st_query += " and ";

			st_query += " doc_type = '"+gubun1+"' \n";
		}

		query = " select b.use_yn, b.rent_mng_id, nvl(c.INDEX_STATUS,'대기상태') as doc_stat, c.reg_date, a.* \n"+

			    " from   ( "+

				"	       SELECT 'lc_rent_link' as link_table, \n"+
				"                 decode(doc_type,'1','장기대여계약서','2','장기대여계약서(승계)','3','장기대여계약서(연장)') doc_type_nm, doc_type, doc_yn, \n"+
				"                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt, \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm   \n"+
				"          FROM   alink.lc_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'rm_rent_link' as link_table, \n"+
				"                 decode(rent_st||im_seq,'1','월렌트계약서',decode(im_seq,'','월렌트계약서(연장)','월렌트계약서(임의연장)')) doc_type_nm, doc_type, doc_yn, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm   \n"+
				"          FROM   alink.rm_rent_link \n"+dt_query+kd_query+st_query+

				"          UNION all \n"+

				"          SELECT 'cms_link' as link_table, \n"+
				"                 'CMS출금이체신청서' doc_type_nm, doc_type, doc_yn, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, '' rent_start_dt, '' rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm \n"+
				"          FROM   alink.cms_link \n"+dt_query+kd_query+st_query+

			    "        ) a, "+
				"        cont b, "+	
				"	     (  "+	
				"	       SELECT  "+	
				"	              a.KEY_INDEX,  "+	
				"	              a.INDEX_STATUS, "+	
                "                 a.REG_DATE  "+	
				"	       FROM   alink.CONTRACT_STATUS a ,  "+	
				"	              (  "+	
				"                   SELECT   "+	
                "                          KEY_INDEX, MAX( REG_DATE ) KEEP( DENSE_RANK FIRST ORDER BY KEY_INDEX, REG_DATE DESC ) AS seq  "+	
                "                   FROM   alink.CONTRACT_STATUS   "+	
                "                   GROUP BY KEY_INDEX  "+	
				"	              ) b  "+	
				"	       WHERE  substr(a.KEY_INDEX,2)=substr(b.KEY_INDEX,2) "+	
				"	       AND    a.REG_DATE=b.seq  "+	
				"	     ) c  "+	
				" where  a.rent_l_cd=b.rent_l_cd and a.rent_l_cd||a.rent_st||a.im_seq=substr(c.key_index,2) "+
				"        and ( nvl(c.INDEX_STATUS,'대기상태') in ('승인거절','기간종료','계약파기','삭제') or a.doc_yn='D' )";

		dt1 = "to_char(nvl(c.REG_DATE,a.reg_dt),'YYYYMM')";
		dt2 = "to_char(nvl(c.REG_DATE,a.reg_dt),'YYYYMMDD')";


		if(gubun5.equals("4"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM') \n";					//당월
		else if(gubun5.equals("5"))		query += " and "+dt1+" = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') \n";	//전월
		else if(gubun5.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";				//당일
		else if(gubun5.equals("2"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";				//전일
		else if(gubun5.equals("3"))		query += " and "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') \n";//2일
		else if(gubun5.equals("6")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('%"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}


		query += " order by a.reg_dt";



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
			System.out.println("[ALinkDatabase:getAlinkCancelList]\n"+e);
			System.out.println("[ALinkDatabase:getAlinkCancelList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public Vector getAlinkSendMList(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = "";
		String kd_query = "";
		String st_query = "";

		String dt1 = "";
		String dt2 = "";

		dt1 = "to_char(reg_dt,'YYYYMM')";
		dt2 = "to_char(reg_dt,'YYYYMMDD')";


		if(gubun5.equals("4"))			dt_query += " where "+dt1+" = to_char(sysdate,'YYYYMM') \n";					//당월
		else if(gubun5.equals("5"))		dt_query += " where "+dt1+" = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') \n";		//전월
		else if(gubun5.equals("1"))		dt_query += " where "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";					//당일
		else if(gubun5.equals("2"))		dt_query += " where "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";				//전일
		else if(gubun5.equals("3"))		dt_query += " where "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') \n";//2일
		else if(gubun5.equals("6")){
			if(!st_dt.equals("") && end_dt.equals(""))	dt_query += " where "+dt2+" like replace('%"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) dt_query += " where "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(company_name, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(acar_user_nm, ' '))";	

		if(!what.equals("") && !t_wd.equals("")){
			if(dt_query.equals(""))		kd_query += " where ";
			else						kd_query += " and ";

			kd_query += " "+what+" like upper('%"+t_wd+"%')  \n";
	
		}

		if(!gubun1.equals("")){
			if(dt_query.equals("") && kd_query.equals(""))						st_query += " where ";
			else																st_query += " and ";

			st_query += " doc_type = '"+gubun1+"' \n";
		}

		query = " select b.use_yn, b.rent_mng_id, c.res_msg, c.req_ymd, c.req_time, c.upd_ymd, c.upd_time, c.status, "+
				"        decode(a.doc_yn,'D','취소','Y','등록','U','수정') doc_yn_nm, "+
				"        nvl(c.res_msg,'대기') doc_stat, "+
			    "        c2.file_pdf, c2.file_zip, "+
		//		"        w.file_cnt17, w.file_cnt18, w.file_cnt37, w.file_cnt38, \n"+
				"        a.* \n"+

			    " from   ( "+

				"          SELECT 'rm_rent_link' as link_table, \n"+
				"                 decode(rent_st||im_seq,'1','월렌트계약서',decode(im_seq,'','월렌트계약서(연장)','월렌트계약서(임의연장)')) doc_type_nm, doc_type, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm, tmsg_seq, doc_yn   \n"+
				"          FROM   alink.rm_rent_link_m \n"+dt_query+kd_query+st_query+

			    "        ) a, "+

				"        cont b, "+	

				"	     alink.TMSG_QUEUE c, "+	

				"        ( SELECT link_key, MIN(DECODE(tmsg_kncd,'AC611',content)) file_pdf, MIN(DECODE(tmsg_kncd,'AC613',content)) file_zip FROM alink.TMSG_QUEUE GROUP BY link_key) c2 "+

		//		"        ( SELECT SUBSTR(content_seq,1,19) content_seq, \n"+
		//		"                 SUBSTR(SUBSTR(content_seq,1,19),1,6) rent_mng_id,  \n"+
		//		"                 SUBSTR(SUBSTR(content_seq,1,19),7,13) rent_l_cd, \n"+
		//		"                 COUNT(DECODE(SUBSTR(content_seq,21),'17',1)) file_cnt17, \n"+
		//		"                 COUNT(DECODE(SUBSTR(content_seq,21),'18',1)) file_cnt18, \n"+
		//		"                 COUNT(DECODE(SUBSTR(content_seq,21),'37',1)) file_cnt37, \n"+
		//		"                 COUNT(DECODE(SUBSTR(content_seq,21),'38',1)) file_cnt38  \n"+
		//		"          FROM   ACAR_ATTACH_FILE  \n"+
		//		"          where  content_code='LC_SCAN' AND isdeleted='N' \n"+
		//		"          group by SUBSTR(content_seq,1,19) \n"+ 
        //      "        ) w "+

				" where  a.rent_l_cd=b.rent_l_cd and a.tmsg_seq=c.tmsg_seq and a.doc_code=c2.link_key "+
		//		"	  and b.rent_mng_id=w.rent_mng_id(+) and b.rent_l_cd=w.rent_l_cd(+) "+
				" ";



			query += " order by a.reg_dt";



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
			System.out.println("[ALinkDatabase:getAlinkSendMList]\n"+e);
			System.out.println("[ALinkDatabase:getAlinkSendMList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public int getALinkCnt(String table_nm, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int count = 0;

		query = " select count(a.rent_l_cd) "+
				" from   alink."+table_nm+" a "+
				" where  a.rent_l_cd='"+rent_l_cd+"' "+
				" ";


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
			System.out.println("[ALinkDatabase:getALinkCnt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public int getALinkCntY(String table_nm, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int count = 0;

		query = " select count(a.rent_l_cd) "+
				" from   alink."+table_nm+" a "+
				" where  a.rent_l_cd='"+rent_l_cd+"' and doc_yn<>'D' "+
				" ";


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
			System.out.println("[ALinkDatabase:getALinkCnt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	전자문서 리스트
	 */
	public int getALinkCntY(String table_nm, String rent_l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int count = 0;
		if(table_nm.equals("lc_rent_link")){			table_nm =  "lc_rent_link_m"; 			}

		query = " select count(a.rent_l_cd) "+
				" from   alink."+table_nm+" a "+
				" where  a.rent_l_cd='"+rent_l_cd+"' and a.rent_st='"+rent_st+"' and doc_yn<>'D' "+
				" ";
		
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
			System.out.println("[ALinkDatabase:getALinkCnt(String table_nm, String rent_l_cd, String rent_st)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


/*월별 전자문서 / 인도인수증 카운트 */
public Vector Moncount(String year, String mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = "";
		String dt_query = "";

		if(!year.equals("") && !mon.equals("")){
			dt_query += " AND  substr(upd_ymd, 1,4) = '"+year+"' AND  to_number(substr(upd_ymd, 5,2)) = '"+mon+"' ";
		}else if(!year.equals("") && mon.equals("")){
			dt_query += " AND  substr(upd_ymd, 1,4) = '"+year+"'  ";
		}else if(year.equals("") && !mon.equals("")){
			dt_query += " AND  to_number(substr(upd_ymd, 5,2)) = '"+mon+"'  ";
		}else if(year.equals("") && mon.equals("")){
			dt_query += " ";
		}

		query = " select SUM(a.cnt1) AS AC611,  SUM(b.cnt2) AS AC111,  SUM(c.cnt3) AS AC711,  SUM(d.cnt4) AS AC811,  SUM(a.cnt1 + b.cnt2 + c.cnt3 -1300) AS ACTOT \n"+
		        " FROM  \n"+
			    " (SELECT COUNT(tmsg_kncd) cnt1 FROM alink.TMSG_QUEUE WHERE tmsg_kncd = 'AC611' "+dt_query+" ) a, \n"+
				" (SELECT COUNT(tmsg_kncd) cnt2 FROM alink.TMSG_QUEUE WHERE tmsg_kncd = 'AC111' "+dt_query+" ) b, \n"+
//				" (SELECT COUNT(tmsg_kncd) cnt3 FROM alink.TMSG_QUEUE WHERE tmsg_kncd in ('AC711','AC811') "+dt_query+" ) c \n"+
				" (SELECT COUNT(tmsg_kncd) cnt3 FROM alink.TMSG_QUEUE WHERE tmsg_kncd in ('AC711') "+dt_query+" ) c, \n"+
				" (SELECT COUNT(tmsg_kncd) cnt4 FROM alink.TMSG_QUEUE WHERE tmsg_kncd in ('AC811') "+dt_query+" ) d \n"+
				"	";
	
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
			System.out.println("[ALinkDatabase:Moncount]\n"+e);
			System.out.println("[ALinkDatabase:Moncount]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;

		}
	}


	/**
	 *	장기계약서 전자문서
	 */
	public Hashtable getAlinkEndLcRent(String rent_l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.reg_dt, c.reg_date, b.use_yn, b.rent_mng_id, nvl(c.INDEX_STATUS,'대기상태') as doc_stat, a.* \n"+

			    " from   ( "+

				"	       SELECT 'lc_rent_link' as link_table, \n"+
				"                 decode(doc_type,'1','장기대여계약서','2','장기대여계약서(승계)','3','장기대여계약서(연장)') doc_type_nm, doc_type, \n"+
				"                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt, \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm   \n"+
				"          FROM   alink.lc_rent_link "+
				"          WHERE  rent_l_cd='"+rent_l_cd+"' and rent_st='"+rent_st+"' "+
			    "        ) a, "+
				"        cont b, "+	
				"	     (  "+	
				"	       SELECT  "+	
				"	              a.KEY_INDEX,  "+	
				"	              a.INDEX_STATUS, "+	
                "                 to_char(a.REG_DATE,'YYYYMMDDhh24miss') REG_DATE"+	
				"	       FROM   alink.CONTRACT_STATUS a ,  "+	
				"	              (  "+	
				"                   SELECT   "+	
                "                          KEY_INDEX, MAX( REG_DATE ) KEEP( DENSE_RANK FIRST ORDER BY KEY_INDEX, REG_DATE DESC ) AS seq  "+	
                "                   FROM   alink.CONTRACT_STATUS   "+	
                "                   WHERE  KEY_INDEX like upper('%"+rent_l_cd+""+rent_st+"%') "+
                "                   GROUP BY KEY_INDEX  "+	
				"	              ) b  "+	
				"	       WHERE  a.KEY_INDEX like upper('%"+rent_l_cd+""+rent_st+"%') and substr(a.KEY_INDEX,2)=substr(b.KEY_INDEX,2) "+	
				"	       AND    a.REG_DATE=b.seq  "+	
				"	     ) c  "+	
				" where  a.rent_l_cd=b.rent_l_cd and a.rent_l_cd||a.rent_st||a.im_seq=substr(c.key_index,2) "+
				"        and nvl(c.INDEX_STATUS,'대기상태') =  '완료' \r\n";
		
		query += " union all \n"
				+ " select a.reg_dt, c.req_ymd||c.req_time AS reg_date, b.use_yn, b.rent_mng_id, '완료' as doc_stat, a.* \r\n" + 
				"\r\n" + 
				"			     from   ( \r\n" + 
				"\r\n" + 
				"					       SELECT 'lc_rent_link' as link_table, \r\n" + 
				"				                 decode(doc_type,'1','장기대여계약서','2','장기대여계약서(승계)','3','장기대여계약서(연장)') doc_type_nm, doc_type, \r\n" + 
				"				                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt, \r\n" + 
				"				                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \r\n" + 
				"				                 rent_l_cd, rent_st, im_seq, car_no, car_nm   \r\n" + 
				"				          FROM   alink.lc_rent_link_m \r\n" + 
				"				          WHERE  rent_l_cd='"+rent_l_cd+"' and rent_st='"+rent_st+"' \r\n" + 
				"			            ) a, \r\n" + 
				"				        cont b, 	\r\n" + 
				"					     (  	\r\n" + 
				"					       SELECT * FROM alink.tmsg_queue WHERE tmsg_kncd in ('AC711','AC811')	\r\n" + 
				"					     ) c  	\r\n" + 
				"				 where  a.rent_l_cd=b.rent_l_cd and a.doc_code=c.link_key ";

			query += " order by 1";



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
			System.out.println("[ALinkDatabase:getAlinkEndLcRent]\n"+e);
			System.out.println("[ALinkDatabase:getAlinkEndLcRent]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	/*월별 전자계약서 카운트 */
	public Vector MoncountPapyl(String year, String mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = "";
		String dt_query = "";

		if(!year.equals("") && !mon.equals("")){
			dt_query += " AND  substr(to_char(reg_dt,'YYYYMM'), 1,4) = '"+year+"' AND  to_number(substr(to_char(reg_dt,'YYYYMM'), 5,2)) = '"+mon+"' ";
		}else if(!year.equals("") && mon.equals("")){
			dt_query += " AND  substr(to_char(reg_dt,'YYYYMM'), 1,4) = '"+year+"'  ";
		}else if(year.equals("") && !mon.equals("")){
			dt_query += " AND  to_number(to_char(reg_dt,'YYYYMM'), 5,2)) = '"+mon+"'  ";
		}else if(year.equals("") && mon.equals("")){
			dt_query += " ";
		}
		
		//테스트
		query = " SELECT COUNT(*) AS papylCnt \n" +
				" from  ( \n" +	
				"     	 SELECT 'lc_rent_link' as link_table,\n" +
				" 			    decode(doc_type,'1','장기대여계약서','2','장기대여계약서(승계)','3','장기대여계약서(연장)') doc_type_nm, doc_type, \n" +
				"  	 		    doc_code, client_st, replace(company_name,'$$','&') company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt, \n" +
				" 		 		acar_user_nm, client_user_nm, client_user_email, client_user_tel, \n" +
				" 		 		rent_l_cd, rent_st, im_seq, car_no, car_nm, doc_yn \n" +
				" 		   FROM alink.lc_rent_link where 1=1 \n" + dt_query +
				" 		  UNION all \n" +
				" 		 SELECT 'rm_rent_link' as link_table, \n" +
				"  		 		decode(rent_st||im_seq,'1','월렌트계약서',decode(im_seq,'','월렌트계약서(연장)','월렌트계약서(임의연장)')) doc_type_nm, doc_type, \n" +
				" 				doc_code, client_st, replace(company_name,'$$','&') company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt, \n" +
				"  				acar_user_nm, client_user_nm, client_user_email, client_user_tel, \n" +
				"  				rent_l_cd, rent_st, im_seq, car_no, car_nm, doc_yn \n" +
				"  		   FROM alink.rm_rent_link where 1=1 \n" + dt_query +
				"  		  UNION all \n" +
				"  		 SELECT 'cms_link' as link_table, \n" +   
				"  				'CMS출금이체신청서' doc_type_nm, doc_type,\n" +          
				"  				doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, '' rent_start_dt, '' rent_end_dt, \n" +          
				"  				acar_user_nm, client_user_nm, client_user_email, client_user_tel, \n" +           
				"  				rent_l_cd, rent_st, im_seq, car_no, car_nm, doc_yn \n" +            
				" 	 	   FROM alink.cms_link where 1=1 \n" + dt_query +
				"  		 ) a, cont b \n" +
				" 		,(SELECT a.KEY_INDEX, a.INDEX_STATUS, a.REG_DATE \n" +   
				"  			FROM alink.CONTRACT_STATUS a , \n" +
				"  				(SELECT KEY_INDEX, MAX( REG_DATE ) KEEP( DENSE_RANK FIRST ORDER BY KEY_INDEX, REG_DATE DESC ) AS seq \n" +   
				" 				   FROM alink.CONTRACT_STATUS \n" +          
				"  			  	   GROUP BY KEY_INDEX ) b \n" +           
				"  			WHERE substr(a.KEY_INDEX,2)=substr(b.KEY_INDEX,2) \n" +           
				"  			  AND a.REG_DATE=b.seq \n" +            
				"     	  ) c \n" +  
				" where a.rent_l_cd=b.rent_l_cd\n" +
				"   and a.rent_l_cd||a.rent_st||a.im_seq=substr(c.key_index,2) \n" +   
				"   and a.doc_yn<>'D'  \n" +
				"   and nvl(c.INDEX_STATUS,'대기상태') =  '완료' \n" +
				" ";
				   
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
			System.out.println("[ALinkDatabase:MoncountPapyl(String year, String mon)]\n"+e);
			System.out.println("[ALinkDatabase:MoncountPapyl(String year, String mon)]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;

		}
	}

	//차량인도/인수증 리스트(채권양도통지서 및 위임장) (20190313)
	public Vector getAlinkDeliReceiptList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = "";
		String kd_query = "";
		String st_query = "";
		String bt_query = "";

		String dt1 = "";
		String dt2 = "";
		dt1 = "SUBSTR(c.reg_ymd,0,6)";
		dt2 = "SUBSTR(c.reg_ymd,0,8)";

		if(gubun2.equals("4"))			dt_query += " AND "+dt1+" = to_char(sysdate,'YYYYMM') \n";					//당월
		else if(gubun2.equals("5"))		dt_query += " AND "+dt1+" = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') \n";	//전월
		else if(gubun2.equals("1"))		dt_query += " AND "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";				//당일
		else if(gubun2.equals("2"))		dt_query += " AND "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";				//전일
		else if(gubun2.equals("3"))		dt_query += " AND "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') \n";//2일
		else if(gubun2.equals("6")){
			if(!st_dt.equals("") && end_dt.equals(""))	dt_query += " AND "+dt2+" like replace('%"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) dt_query += " AND "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(c.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(c.car_no||i.est_car_no||j.car_no, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.car_nm, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(c.acar_mng, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.cons_no, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(a.OFF_NM, ' '))";
		if(s_kd.equals("7"))	what = "upper(nvl(c.INS_COM_NM, ' '))";

		if(!what.equals("") && !t_wd.equals("")){
			kd_query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}
		if(gubun3.equals("on")){
			bt_query += " AND c.b_trf_yn = 'Y' and c.ins_req_amt <> '0' AND c.CONS_CAU = '사고대차회수' \n";
		}

		query = " SELECT a.cons_no||'-'||a.seq AS cons_no, a.OFF_NM, c.firm_nm, c.car_nm, c.car_no, b.CONTENT, c.reg_ymd, c.acar_mng, \n"+
				"		 nvl(b.res_msg,'대기') doc_stat \n"+
				"   FROM CONSIGNMENT a, alink.TMSG_QUEUE b, alink.CONSIGNMENT_LINK c, car_pur i, car_reg j \n"+
				"   WHERE a.CONS_NO||a.seq = b.LINK_KEY \n"+
			    "     AND a.CONS_NO||a.seq = c.cons_no \n"+
				"	AND a.rent_mng_id = i.rent_mng_id(+) AND a.rent_l_cd = i.rent_l_cd(+) \n "+
				" AND a.car_mng_id = j.car_mng_id(+) "+
				"     AND b.TMSG_TYPE ='2' \n"+
				dt_query + kd_query + bt_query +
			    "   GROUP BY a.cons_no||'-'||a.seq, a.OFF_NM, c.firm_nm, c.car_nm, c.car_no, b.CONTENT, c.reg_ymd, c.acar_mng, b.res_msg, a.cons_no, a.seq \n"+
				" ";

			query += " ORDER BY a.cons_no DESC, a.seq ASC";

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
			System.out.println("[ALinkDatabase:getAlinkDeliReceiptList(]\n"+e);
			System.out.println("[ALinkDatabase:getAlinkDeliReceiptList(]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	//전자계약서 - 액타소프트 (20190410)
	public boolean insertALink2(String doc_code, String table_nm, String doc_type, String rent_l_cd, String rent_st, String im_seq, String mgr_nm, String mgr_email, String mgr_m_tel, String user_id, String mgr_nm2, String mgr_email2, String mgr_m_tel2, String link_com, String cms_type, String repre_email, String doc_st, String cms_mail_yn)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		if(table_nm.equals("lc_rent_link")){				table_nm = "lc_rent_link_m";			}

		String query1 = "insert into alink."+table_nm+" (doc_code, doc_type, reg_id, reg_dt, client_user_nm, client_user_email, client_user_tel, rent_l_cd, rent_st, im_seq, "
				+ "tmsg_seq, repre_email, doc_st, doc_yn, cms_mail_yn )"+
						" values("+
						"                               ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Y', ? "+
						")";

		if(doc_type.equals("2")){
			query1 = "insert into alink.lc_rent_link_m (doc_code, doc_type, reg_id, reg_dt, client_user_nm, client_user_email, client_user_tel, rent_l_cd, rent_st, im_seq, "
					+ "tmsg_seq, repre_email, doc_st, doc_yn, cms_mail_yn, rent_suc_client_user_nm, rent_suc_client_user_email, rent_suc_client_user_tel )"+
						" values("+
						"                               ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Y', ?, ?, ?, ? "+
						")";
		}		

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query2 = "{CALL P_ALINK_REG_DOC (?,?)}";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, doc_code);
			pstmt.setString(2, doc_type);
			pstmt.setString(3, user_id);
			pstmt.setString(4, mgr_nm);
			pstmt.setString(5, mgr_email);
			pstmt.setString(6, mgr_m_tel);
			pstmt.setString(7, rent_l_cd);
			pstmt.setString(8, rent_st);
			pstmt.setString(9, im_seq);
			pstmt.setString(10, "LC"+doc_code);
			pstmt.setString(11, repre_email);
			pstmt.setString(12, doc_st);
			pstmt.setString(13, cms_mail_yn);
			if(doc_type.equals("2")){
				pstmt.setString(14, mgr_nm2);
				pstmt.setString(15, mgr_email2);
				pstmt.setString(16, mgr_m_tel2);
			}
			
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

			//신차잔가계산 프로시저 호출
			cstmt = conn.prepareCall(query2);				
			cstmt.setString(1, doc_code);
			cstmt.setString(2, table_nm);
			cstmt.execute();
			cstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:insertALink2]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}
	
	//장기대여 전자계약서 리스트(20190415)
	public Vector getAlinkSendLCList(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = "";
		String kd_query = "";
		String st_query = "";
		String list_query = "";

		String dt1 = "";
		String dt2 = "";

		dt1 = "to_char(reg_dt,'YYYYMM')";
		dt2 = "to_char(reg_dt,'YYYYMMDD')";

		if(gubun5.equals("4"))			dt_query += " where "+dt1+" = to_char(sysdate,'YYYYMM') \n";					//당월
		else if(gubun5.equals("5"))		dt_query += " where "+dt1+" = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') \n";		//전월
		else if(gubun5.equals("1"))		dt_query += " where "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";					//당일
		else if(gubun5.equals("2"))		dt_query += " where "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";				//전일
		else if(gubun5.equals("3"))		dt_query += " where "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') \n";//2일
		else if(gubun5.equals("6")){
			if(!st_dt.equals("") && end_dt.equals(""))	dt_query += " where "+dt2+" like replace('%"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) dt_query += " where "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(company_name, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(acar_user_nm, ' '))";	

		if(!what.equals("") && !t_wd.equals("")){
			if(dt_query.equals(""))		kd_query += " where ";
			else									kd_query += " and ";

			kd_query += " "+what+" like upper('%"+t_wd+"%')  \n";
		}

		if(!gubun1.equals("")){
			if(dt_query.equals("") && kd_query.equals(""))			st_query += " where ";
			else																				st_query += " and ";

			st_query += " doc_type = '"+gubun1+"' \n";
		}
		
		if(!gubun2.equals("")){
			if(gubun2.equals("1"))		list_query += " AND a.doc_yn <> 'D' AND c.status IN ('0','1') ";
			if(gubun2.equals("2"))		list_query += " AND a.doc_yn <> 'D' AND c.status ='2' ";
			if(gubun2.equals("3"))		list_query += " AND a.doc_yn = 'D' ";
		}

		query = " select b.use_yn, b.rent_mng_id, c.res_msg, c.req_ymd, c.req_time, c.upd_ymd, c.upd_time, c.status, "+
				"		 decode(b.rent_st,'1','신규','3','대차','4','증차') cont_rent_st, b.fee_rent_st,  "+
				"        decode(a.doc_yn,'D','취소','Y','등록','U','수정') doc_yn_nm, "+
				"        decode(c.tmsg_kncd, 'AC701', '인증서', 'AC702', '인증서', 'AC801', '비대면', 'AC802', '인증서') doc_st_nm, "+
				"        nvl(c.res_msg,'대기') doc_stat, "+
			    "        c2.file_pdf, c2.file_zip, "+
			//	"        w.file_cnt17, w.file_cnt18, w.file_cnt37, w.file_cnt38, \n"+
				"        a.* \n"+
			    " from   ( "+
				"          SELECT 'lc_rent_link' as link_table, \n"+
				"                 decode(doc_type,'1','장기대여계약서','2','장기대여계약서(승계)','3','장기대여계약서(연장)') doc_type_nm, doc_type, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm, tmsg_seq, doc_st, doc_yn   \n"+
				"          FROM   alink.lc_rent_link_m \n"+dt_query+kd_query+st_query+
			    "        ) a, "+
				"        cont_n_view b, "+
				"	     alink.TMSG_QUEUE c, "+
				"        ( SELECT link_key, MIN(DECODE(tmsg_kncd,'AC711',content, 'AC811', content)) file_pdf, MIN(DECODE(tmsg_kncd,'AC713',content, 'AC813', content)) file_zip FROM alink.TMSG_QUEUE GROUP BY link_key) c2 "+
		//		"        ( SELECT SUBSTR(content_seq,1,19) content_seq, \n"+
		//		"                 SUBSTR(SUBSTR(content_seq,1,19),1,6) rent_mng_id,  \n"+
		//		"                 SUBSTR(SUBSTR(content_seq,1,19),7,13) rent_l_cd, \n"+
		//		"                 COUNT(DECODE(SUBSTR(content_seq,21),'17',1)) file_cnt17, \n"+
		//		"                 COUNT(DECODE(SUBSTR(content_seq,21),'18',1)) file_cnt18, \n"+
		//		"                 COUNT(DECODE(SUBSTR(content_seq,21),'37',1)) file_cnt37, \n"+
		//		"                 COUNT(DECODE(SUBSTR(content_seq,21),'38',1)) file_cnt38  \n"+
		//		"          FROM   ACAR_ATTACH_FILE  \n"+
		//		"          where  content_code='LC_SCAN' AND isdeleted='N' \n"+
		//		"          group by SUBSTR(content_seq,1,19) \n"+ 
        //      "        ) w "+
				" where  a.rent_l_cd=b.rent_l_cd and a.tmsg_seq=c.tmsg_seq and a.doc_code=c2.link_key " +
		//		"	  and b.rent_mng_id=w.rent_mng_id(+) and b.rent_l_cd=w.rent_l_cd(+) "+
				" " + list_query +
				" ";

			query += " order by a.reg_dt";
			
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
			System.out.println("[ALinkDatabase:getAlinkSendLCList]\n"+e);
			System.out.println("[ALinkDatabase:getAlinkSendLCList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	//전자문서 비용관리 - 액타소프트 전자계약서 계약구분별 카운팅(20190712) - 완료건만
	public Hashtable getLCRentLinkMCount(String year, String mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String dt_query = "";

		if(!year.equals("") && !mon.equals("")){
			dt_query += " AND  substr(upd_ymd, 1,4) = '"+year+"' AND  to_number(substr(upd_ymd, 5,2)) = '"+mon+"' ";
		}else if(!year.equals("") && mon.equals("")){
			dt_query += " AND  substr(upd_ymd, 1,4) = '"+year+"'  ";
		}else if(year.equals("") && !mon.equals("")){
			dt_query += " AND  to_number(substr(upd_ymd, 5,2)) = '"+mon+"'  ";
		}else if(year.equals("") && mon.equals("")){
			dt_query += " ";
		}

		query = " SELECT a.cnt AS cnt1, b.cnt AS cnt2, c.cnt AS cnt3, d.cnt AS cnt4 \n"+
					 "	  FROM \n"+
					 "		(SELECT	COUNT(*) AS cnt FROM alink.TMSG_QUEUE a, alink.LC_RENT_LINK_M b, cont c \n"+
					 "			WHERE a.link_key = b.doc_code AND b.rent_l_cd = c.rent_l_cd(+)  AND a.tmsg_kncd in ('AC711','AC811') \n"+
  					 "				 AND (c.rent_st = '1' OR c.rent_st IS NULL) "+dt_query+" ) a, \n"+
  					 "		(SELECT	COUNT(*) AS cnt FROM alink.TMSG_QUEUE a, alink.LC_RENT_LINK_M b, cont c \n"+
					 "			WHERE a.link_key = b.doc_code AND b.rent_l_cd = c.rent_l_cd(+)  AND a.tmsg_kncd in ('AC711','AC811') \n"+
 					 "				 AND c.rent_st = '3' "+dt_query+" ) b, \n"+
 					 "		(SELECT	COUNT(*) AS cnt FROM alink.TMSG_QUEUE a, alink.LC_RENT_LINK_M b, cont c \n"+
					 "			WHERE a.link_key = b.doc_code AND b.rent_l_cd = c.rent_l_cd(+)  AND a.tmsg_kncd in ('AC711','AC811') \n"+
 					 "				 AND c.rent_st = '4' "+dt_query+" ) c, \n"+
 					 "		(SELECT	COUNT(*) AS cnt FROM alink.TMSG_QUEUE a, alink.LC_RENT_LINK_M b, cont c \n"+
					 "			WHERE a.link_key = b.doc_code AND b.rent_l_cd = c.rent_l_cd(+)  AND a.tmsg_kncd in ('AC711','AC811') \n"+
					 "				 AND c.rent_st in ('2', '5') "+dt_query+" ) d \n"+
					 " ";

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
			System.out.println("[ALinkDatabase:getLCRentLinkMCount]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	//전자문서 비용관리 - 액타소프트 전자계약서 계약구분별 카운팅(20190712) - 등록모두
	public Hashtable getLCRentLinkMRCount(String year, String mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String dt_query = "";

		if(!year.equals("") && !mon.equals("")){
			dt_query += " AND  substr(upd_ymd, 1,4) = '"+year+"' AND  to_number(substr(upd_ymd, 5,2)) = '"+mon+"' ";
		}else if(!year.equals("") && mon.equals("")){
			dt_query += " AND  substr(upd_ymd, 1,4) = '"+year+"'  ";
		}else if(year.equals("") && !mon.equals("")){
			dt_query += " AND  to_number(substr(upd_ymd, 5,2)) = '"+mon+"'  ";
		}else if(year.equals("") && mon.equals("")){
			dt_query += " ";
		}

		query = " SELECT a.cnt AS cnt1, b.cnt AS cnt2, c.cnt AS cnt3, d.cnt AS cnt4 \n"+
					 "	  FROM \n"+
					 "		(SELECT	COUNT(c.rent_st) AS cnt FROM alink.TMSG_QUEUE a, alink.LC_RENT_LINK_M b, cont c \n"+
					 "			WHERE a.link_key = b.doc_code AND b.rent_l_cd = c.rent_l_cd  AND a.tmsg_kncd in ('AC701','AC801') \n"+
  					 "				 AND c.rent_st = '1' "+dt_query+" ) a, \n"+
  					 "		(SELECT	COUNT(c.rent_st) AS cnt FROM alink.TMSG_QUEUE a, alink.LC_RENT_LINK_M b, cont c \n"+
					 "			WHERE a.link_key = b.doc_code AND b.rent_l_cd = c.rent_l_cd  AND a.tmsg_kncd in ('AC701','AC801') \n"+
 					 "				 AND c.rent_st = '3' "+dt_query+" ) b, \n"+
 					 "		(SELECT	COUNT(c.rent_st) AS cnt FROM alink.TMSG_QUEUE a, alink.LC_RENT_LINK_M b, cont c \n"+
					 "			WHERE a.link_key = b.doc_code AND b.rent_l_cd = c.rent_l_cd  AND a.tmsg_kncd in ('AC701','AC801') \n"+
 					 "				 AND c.rent_st = '4' "+dt_query+" ) c, \n"+
 					 "		(SELECT	COUNT(c.rent_st) AS cnt FROM alink.TMSG_QUEUE a, alink.LC_RENT_LINK_M b, cont c \n"+
					 "			WHERE a.link_key = b.doc_code AND b.rent_l_cd = c.rent_l_cd  AND a.tmsg_kncd in ('AC701','AC801') \n"+
					 "				 AND c.rent_st in ('2', '5') "+dt_query+" ) d \n"+
					 " ";

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
			System.out.println("[ALinkDatabase:getLCRentLinkMRCount]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}	
	
	//에이전트 전자계약서 리스트(20200226)
	public Vector getAgentAlinkSendLCList(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = "";
		String kd_query = "";
		String st_query = "";
		String list_query = "";

		String dt1 = "";
		String dt2 = "";

		dt1 = "to_char(reg_dt,'YYYYMM')";
		dt2 = "to_char(reg_dt,'YYYYMMDD')";

		if(gubun5.equals("4"))			dt_query += " where "+dt1+" = to_char(sysdate,'YYYYMM') \n";					//당월
		else if(gubun5.equals("5"))		dt_query += " where "+dt1+" = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') \n";		//전월
		else if(gubun5.equals("1"))		dt_query += " where "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";					//당일
		else if(gubun5.equals("2"))		dt_query += " where "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";				//전일
		else if(gubun5.equals("3"))		dt_query += " where "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') \n";//2일
		else if(gubun5.equals("6")){
			if(!st_dt.equals("") && end_dt.equals(""))	dt_query += " where "+dt2+" like replace('%"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) dt_query += " where "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(company_name, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(acar_user_nm, ' '))";	

		if(!what.equals("") && !t_wd.equals("")){
			if(dt_query.equals(""))		kd_query += " where ";
			else									kd_query += " and ";

			kd_query += " "+what+" like upper('%"+t_wd+"%')  \n";
		}

		if(!gubun1.equals("")){
			if(dt_query.equals("") && kd_query.equals(""))			st_query += " where ";
			else																				st_query += " and ";

			st_query += " doc_type = '"+gubun1+"' \n";
		}
		
		if(!gubun2.equals("")){
			if(gubun2.equals("1"))		list_query += " AND a.doc_yn <> 'D' AND c.status IN ('0','1') ";
			if(gubun2.equals("2"))		list_query += " AND a.doc_yn <> 'D' AND c.status ='2' ";
			if(gubun2.equals("3"))		list_query += " AND a.doc_yn = 'D' ";
		}

		query = " select b.use_yn, b.rent_mng_id, c.res_msg, c.req_ymd, c.req_time, c.upd_ymd, c.upd_time, c.status, "+
				"		 decode(b.rent_st,'1','신규','3','대차','4','증차') cont_rent_st, "+
				"        decode(a.doc_yn,'D','취소','Y','등록','U','수정') doc_yn_nm, "+
				"        nvl(c.res_msg,'대기') doc_stat, "+
			    "        c2.file_pdf, c2.file_zip, "+
				"        a.* \n"+
			    " from   ( "+
				"          SELECT 'lc_rent_link' as link_table, \n"+
				"                 decode(doc_type,'1','장기대여계약서','2','장기대여계약서(승계)','3','장기대여계약서(연장)') doc_type_nm, doc_type, \n"+
			    "                 doc_code, client_st, company_name, DECODE(client_st,'개인',resno,regno) regno, reg_id, to_char(reg_dt,'YYYYMMDD') reg_dt, rent_start_dt, rent_end_dt,  \n"+
				"                 acar_user_nm, client_user_nm, client_user_email, client_user_tel,  \n"+
				"                 rent_l_cd, rent_st, im_seq, car_no, car_nm, tmsg_seq, doc_yn   \n"+
				"          FROM   alink.lc_rent_link_m \n"+dt_query+kd_query+st_query+
			    "        ) a, "+
				"        cont b, "+
				"	     alink.TMSG_QUEUE c, "+
				"        ( SELECT link_key, MIN(DECODE(tmsg_kncd,'AC711',content,'AC811',content)) file_pdf, MIN(DECODE(tmsg_kncd,'AC713',content,'AC813',content)) file_zip FROM alink.TMSG_QUEUE GROUP BY link_key) c2 "+
				" where  a.rent_l_cd = b.rent_l_cd and a.tmsg_seq=c.tmsg_seq and a.doc_code=c2.link_key " +
				" and a.reg_id like '%"+user_id+"%' " +
				" " + list_query +
				" ";

			query += " order by a.reg_dt";
			
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
			System.out.println("[ALinkDatabase:getAgentAlinkSendLCList]\n"+e);
			System.out.println("[ALinkDatabase:getAgentAlinkSendLCList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
		

	public boolean insertALinkEdoc(String doc_code, String doc_type, String sign_type, String send_type, String doc_name, String url, String firm_nm, String receiver, String reg_id, String term_dt, String client_id, String rent_mng_id, String rent_l_cd, String cons_no, String ch_cd, String rent_st, String sign_st, String sign_client_st, String pdf_yn, String sign_key, String link_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query1 = "insert into alink.e_doc_mng (doc_code, doc_type, sign_type, send_type, doc_name, url, firm_nm, receiver, reg_id, reg_dt, term_dt, "+
						"                             client_id, rent_mng_id, rent_l_cd, cons_no, ch_cd, tsa_yn, pdf_yn, rent_st, sign_st, link_code, sign_client_st, use_yn, sign_key)"+
						" values("+
						"                               ?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate, to_date(replace(?, '-', ''),'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Y', ? "+
						")";
		
		CallableStatement cstmt = null;
		String sResult = "";
		        
    	String query2 = "{CALL P_ALINK_REG_CT_DOC (?,?)}";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, doc_code);
			pstmt.setString(2, doc_type);
			pstmt.setString(3, sign_type);
			pstmt.setString(4, send_type);
			pstmt.setString(5, doc_name);
			pstmt.setString(6, url);
			pstmt.setString(7, firm_nm);
			pstmt.setString(8, receiver);
			pstmt.setString(9, reg_id);
			pstmt.setString(10, term_dt);					
			pstmt.setString(11, client_id);
			pstmt.setString(12, rent_mng_id);
			pstmt.setString(13, rent_l_cd);
			pstmt.setString(14, cons_no);
			pstmt.setString(15, ch_cd);
			if(doc_type.equals("1")) {
				pstmt.setString(16, "Y");
			}else {
				pstmt.setString(16, "N");
			}
			pstmt.setString(17, pdf_yn);
			pstmt.setString(18, rent_st);
			pstmt.setString(19, sign_st);
			pstmt.setString(20, link_code);
			pstmt.setString(21, sign_client_st);
			pstmt.setString(22, sign_key);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			
			if(doc_type.equals("3") || doc_type.equals("4")) {
			
				//프로시저 호출
				cstmt = conn.prepareCall(query2);				
				cstmt.setString(1, doc_code);
				cstmt.setString(2, doc_name);
				cstmt.execute();
				cstmt.close();

				conn.commit();
			}


	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:insertALinkEdoc]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}	
	
	public boolean updateAlinkEdoc(Hashtable ht)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " update alink.CONFIRM_TEMPLATE_LINK set "+
		               "        var1=?, var2=?, var3=?, var4=?, var5=?, "+
		               "        var6=?, var7=?, var8=?, var9=?, var10=?, "+
		               "        var11=?, var12=?, var13=?, var14=?, var15=?, "+
		               "        var16=?, var17=?, var18=?, var19=?, var20=?, "+
		               "        var21=? "+
		               " ";
				
		query += " where doc_code=? ";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, String.valueOf(ht.get("VAR1")));
			pstmt.setString(2, String.valueOf(ht.get("VAR2")));
			pstmt.setString(3, String.valueOf(ht.get("VAR3")));
			pstmt.setString(4, String.valueOf(ht.get("VAR4")));
			pstmt.setString(5, String.valueOf(ht.get("VAR5")));
			pstmt.setString(6, String.valueOf(ht.get("VAR6")));
			pstmt.setString(7, String.valueOf(ht.get("VAR7")));
			pstmt.setString(8, String.valueOf(ht.get("VAR8")));
			pstmt.setString(9, String.valueOf(ht.get("VAR9")));
			pstmt.setString(10, String.valueOf(ht.get("VAR10")));
			pstmt.setString(11, String.valueOf(ht.get("VAR11")));
			pstmt.setString(12, String.valueOf(ht.get("VAR12")));
			pstmt.setString(13, String.valueOf(ht.get("VAR13")));
			pstmt.setString(14, String.valueOf(ht.get("VAR14")));
			pstmt.setString(15, String.valueOf(ht.get("VAR15")));
			pstmt.setString(16, String.valueOf(ht.get("VAR16")));
			pstmt.setString(17, String.valueOf(ht.get("VAR17")));
			pstmt.setString(18, String.valueOf(ht.get("VAR18")));
			pstmt.setString(19, String.valueOf(ht.get("VAR19")));
			pstmt.setString(20, String.valueOf(ht.get("VAR20")));
			pstmt.setString(21, String.valueOf(ht.get("VAR21")));
			pstmt.setString(22, String.valueOf(ht.get("DOC_CODE")));
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			
			System.out.println("[ALinkDatabase:updateAlinkEdoc] doc_code="+ String.valueOf(ht.get("DOC_CODE")));

	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:updateAlinkEdoc]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}
	
	/**
	 *	전자문서 리스트
	 */
	public Vector getAlinkEdocList(String doc_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select * from alink.CONFIRM_TEMPLATE_LINK_LIST where doc_code='"+doc_code+"' order by seq ";
				
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
			System.out.println("[ALinkDatabase:getAlinkEdocList]\n"+e);
			System.out.println("[ALinkDatabase:getAlinkEdocList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	
	
	// 전자문서_장기 계약서 단일 건 조회
	public Hashtable getLcRentLinkM(String rent_l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String col_nm = "";
		String col_va = "";
		
		query = " SELECT * FROM alink.LC_RENT_LINK_M " +
				" WHERE rent_l_cd = '" + rent_l_cd + "'" +
				" AND rent_st = '" +rent_st+ "'" +
				" AND DOC_YN = 'Y' ";


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
			System.out.println("[ALinkDatabase:getLcRentLinkM]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	
	// 전자문서_월렌트 계약서 단일 건 조회
	public Hashtable getRmRentLinkM(String rent_l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String col_nm = "";
		String col_va = "";
		
		query = " SELECT * FROM alink.RM_RENT_LINK_M " +
				" WHERE rent_l_cd = '" + rent_l_cd + "'" +
				" AND rent_st = '" +rent_st+ "'" +
				" AND DOC_YN != 'D' ";
		
		
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
			System.out.println("[ALinkDatabase:getLcRentLinkM]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	
	// 전자문서_인도인수증 단일 건 조회
	public Hashtable getConsignmentLink(String cons_no){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String col_nm = "";
		String col_va = "";
		
		query = " SELECT * FROM alink.CONSIGNMENT_LINK " +
				" WHERE cons_no = '" + cons_no + "'" +
				" AND cons_yn != 'D' ";
		
		
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
			System.out.println("[ALinkDatabase:getConsignmentLink]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	public boolean updateRmRentCardCms(String rent_l_cd, String rent_st, String c_cms_bank, String c_enp_no, String c_cms_dep_nm, String c_cms_acc_no, String c_cms_dep_ssn, String c_mm, String c_yyyy)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		
		String query = "UPDATE alink.RM_RENT_LINK_M SET "
					+ " c_cms_bank = ?, "
					+ " c_enp_no = ?, "
					+ " c_cms_dep_nm = ?, "
					+ " c_cms_acc_no = ?, "
					+ " c_cms_dep_ssn = ?, "
					+ " c_mm = ?, "
					+ " c_yyyy = ? ";

		query += " WHERE rent_l_cd = ? AND rent_st = ? AND DOC_YN != 'D' ";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, c_cms_bank);
			pstmt.setString(2, c_enp_no);
			pstmt.setString(3, c_cms_dep_nm);
			pstmt.setString(4, c_cms_acc_no);
			pstmt.setString(5, c_cms_dep_ssn);
			pstmt.setString(6, c_mm);
			pstmt.setString(7, c_yyyy);
			pstmt.setString(8, rent_l_cd);
			pstmt.setString(9, rent_st);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:updateRmRentCardCms]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}	
	}
	
	public boolean updateConsignmentLink(Map<String, String> map){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		
		String query = "UPDATE alink.CONSIGNMENT_LINK SET "
				+ " start_km = ?, "
				+ " end_km = ?, "
				+ " chk_a = ?, "
				+ " chk_b = ?, "
				+ " chk_c = ?, "
				+ " chk_d = ?, "
				+ " chk_e = ?, "
				+ " chk_f = ?, "
				+ " chk_g = ?, "
				+ " chk_h = ?, "
				+ " chk_i = ?, "
				+ " chk_j = ?, "
				+ " chk_k = ?, "
				+ " chk_l = ?, "
				+ " chk_m = ?, "
				+ " chk_n = ?, "
				+ " chk_o = ?, "
				+ " chk_p = ?, "
				+ " chk_q = ?, "
				+ " chk_r = ?, "
				+ " chk_s = ?, "
				+ " chk_t = ?, "
				+ " chk_u = ?, "
				+ " chk_v = ?, "
				+ " chk_w = ?, "
				+ " chk_x = ?, "
				+ " chk_y = ?, "
				+ " chk_z = ?, "
				+ " cons_type = ?, "
				+ " valuables = ?, "
				+ " cons_client_nm = ?, "
				+ " cons_client_tel = ?, "
				+ " cons_relationship = ? "
				+ " WHERE cons_no = ? AND cons_yn = 'Y' ";
		 
		
		try 
		{
			
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, map.get("start_km"));
			pstmt.setString(2, map.get("end_km"));
			pstmt.setString(3, map.get("chk_a"));
			pstmt.setString(4, map.get("chk_b"));
			pstmt.setString(5, map.get("chk_c"));
			pstmt.setString(6, map.get("chk_d"));
			pstmt.setString(7, map.get("chk_e"));
			pstmt.setString(8, map.get("chk_f"));
			pstmt.setString(9, map.get("chk_g"));
			pstmt.setString(10, map.get("chk_h"));
			pstmt.setString(11, map.get("chk_i"));
			pstmt.setString(12, map.get("chk_j"));
			pstmt.setString(13, map.get("chk_k"));
			pstmt.setString(14, map.get("chk_l"));
			pstmt.setString(15, map.get("chk_m"));
			pstmt.setString(16, map.get("chk_n"));
			pstmt.setString(17, map.get("chk_o"));
			pstmt.setString(18, map.get("chk_p"));
			pstmt.setString(19, map.get("chk_q"));
			pstmt.setString(20, map.get("chk_r"));
			pstmt.setString(21, map.get("chk_s"));
			pstmt.setString(22, map.get("chk_t"));
			pstmt.setString(23, map.get("chk_u"));
			pstmt.setString(24, map.get("chk_v"));
			pstmt.setString(25, map.get("chk_w"));
			pstmt.setString(26, map.get("chk_x"));
			pstmt.setString(27, map.get("chk_y"));
			pstmt.setString(28, map.get("chk_z"));
			pstmt.setString(29, map.get("cons_type"));
			pstmt.setString(30, map.get("valuables"));
			pstmt.setString(31, map.get("cons_client_nm"));
			pstmt.setString(32, map.get("cons_client_tel"));
			pstmt.setString(33, map.get("cons_relationship"));
			pstmt.setString(34, map.get("cons_no"));
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
		} catch (Exception e) {
			System.out.println("[ALinkDatabase: updateConsignmentLink]"+ e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
			closeConnection();
			return flag;
		}	
	}
	

	// 전자문서_전자계약서 데이터 insert. 장기 계약서 및 월렌트 계약서
	public boolean insertALinkRentLinkM(String doc_code, String doc_type, String rent_l_cd, String rent_st, String mgr_nm, String mgr_email, String mgr_m_tel, String user_id, String suc_mgr_nm, String suc_mgr_email, String suc_mgr_m_tel, String cms_type, String repre_email, String repre_m_tel, String doc_st, String send_type)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		
		String table_nm = "";
		if(doc_type.equals("4")){
			table_nm = "rm_rent_link_m";
		} else {
			table_nm = "lc_rent_link_m";
		}

		String query1 = "";
		
		if(table_nm.equals("lc_rent_link_m")){
			
			query1 = "insert into alink.lc_rent_link_m " + 
					"( doc_code, doc_type, reg_id, reg_dt, client_user_nm, client_user_email, client_user_tel, rent_l_cd, rent_st, " + 
					" tmsg_seq, repre_email, repre_m_tel, doc_st, doc_yn, cms_mail_yn, rent_suc_client_user_nm, rent_suc_client_user_email, rent_suc_client_user_tel, e_doc_yn )" +
						" values( " +
						"	?, ?, ?, sysdate, ?, ?, ?, ?, ?, " +
						" 	?, ?, ?, ?, 'Y', 'N', ?, ?, ?, 'Y' "+
						" ) ";
			
		} else if(table_nm.equals("rm_rent_link_m")){
			
			query1 = "insert into alink.rm_rent_link_m " + 
					"( doc_code, doc_type, reg_id, reg_dt, client_user_nm, client_user_email, client_user_tel, rent_l_cd, rent_st, "
					+ " tmsg_seq, doc_yn, cms_type, send_type, e_doc_yn ) "+
					" values ("+
					"	?, ?, ?, sysdate, ?, ?, ?, ?, ?, " +
					" 	?, 'Y', '"+cms_type+"', ?, 'Y' "+
					" ) ";
			
		}

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query2 = "{CALL P_ALINK_REG_DOC (?,?)}";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, doc_code);
			pstmt.setString(2, doc_type);
			pstmt.setString(3, user_id);
			pstmt.setString(4, mgr_nm);
			pstmt.setString(5, mgr_email);
			pstmt.setString(6, mgr_m_tel);
			pstmt.setString(7, rent_l_cd);
			pstmt.setString(8, rent_st);
			if(table_nm.equals("lc_rent_link_m")){
				pstmt.setString(9, "LC"+doc_code);
				pstmt.setString(10, repre_email);
				pstmt.setString(11, repre_m_tel);
				pstmt.setString(12, doc_st);
				pstmt.setString(13, suc_mgr_nm);
				pstmt.setString(14, suc_mgr_email);
				pstmt.setString(15, suc_mgr_m_tel);
			} else if(table_nm.equals("rm_rent_link_m")){
				pstmt.setString(9, "RM"+doc_code);
				pstmt.setString(10, send_type);
			}
			
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

			// 전자계약서 프로시저 호출
			cstmt = conn.prepareCall(query2);				
			cstmt.setString(1, doc_code);
			cstmt.setString(2, table_nm);
			cstmt.execute();
			cstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:insertALinkRentLinkM]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}
	
	// 전자문서 테이블 조회	
	public Vector getEdocMngList(String doc_type)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = "";

		query = "";
	
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
			System.out.println("[ALinkDatabase:getEdocMngList]\n"+e);
			System.out.println("[ALinkDatabase:getEdocMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;

		}
	}
	
	// 전자문서 데이터 단 건 조회.
	public Hashtable getEDocMng(String doc_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT * FROM alink.e_doc_mng WHERE doc_code='" + doc_code + "' ";

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
			System.out.println("[ALinkDatabase:getEDocMng]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	// 전자문서_장기 계약서 단일 건 조회
	public Hashtable getLcRentLinkM(String link_code){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String col_nm = "";
		String col_va = "";
		
		query = " SELECT * FROM alink.LC_RENT_LINK_M " +
				" WHERE tmsg_seq = '" + link_code + "'" +
				" AND DOC_YN = 'Y' ";

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
			System.out.println("[ALinkDatabase:getLcRentLinkM]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	// 전자문서_월렌트계약서 단일 건 조회
		public Hashtable getRmRentLinkM(String link_code){
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "";
			String col_nm = "";
			String col_va = "";
			
			query = " SELECT * FROM alink.RM_RENT_LINK_M " +
					" WHERE tmsg_seq = '" + link_code + "'" +
					" AND DOC_YN = 'Y' ";

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
				System.out.println("[ALinkDatabase:getLcRentLinkM]\n"+e);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return ht;
			}
		}
	
	// 전자문서 결과 처리 시 update 처리
	public boolean updateEdocResult(String doc_code, String end_name, String sign_type){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		
		String query = " UPDATE alink.e_doc_mng "
//				+ "SET end_dt = to_date(?, 'YYYYMMDD') ";
				+ "SET end_dt = sysdate ";
		
		if(!end_name.equals("")){
			query += ", end_file = ? ";
		}
		if(!sign_type.equals("")){
			query += ", sign_type = ? ";
		}
		
		query += " WHERE doc_code = ? ";

		try 
		{
//			System.out.println(query);
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			if(!end_name.equals("") && !sign_type.equals("")){
				pstmt.setString(1, end_name);
				pstmt.setString(2, sign_type);
				pstmt.setString(3, doc_code);
			} else if(!end_name.equals("") && sign_type.equals("")){
				pstmt.setString(1, end_name);
				pstmt.setString(2, doc_code);
			} else if(end_name.equals("") && !sign_type.equals("")){
				pstmt.setString(1, sign_type);
				pstmt.setString(2, doc_code);
			} else {
				pstmt.setString(1, doc_code);
			}
			
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase:updateEdocResult]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}
	
	
	// 전자문서 장기계약서 리스트
	public Vector getLcEdocMngList(String gubun1, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.doc_code, doc_name, a.rent_mng_id, a.rent_l_cd, a.rent_st,  firm_nm, j.car_nm||' '||i.car_name AS car_nm, c.car_no, d.user_nm, "
				+ " to_char(a.reg_dt, 'YYYY-MM-DD HH24:MI:SS') reg_dt, to_char(a.term_dt, 'YYYY-MM-DD') term_dt, "
				+ " DECODE(a.use_yn, 'Y', '등록', 'N', '취소') use_yn, "
				+ " DECODE(a.send_type, 'mail', '이메일', 'talk', '알림톡', 'park', '현장', 'driver', '기사') send_type, "
				+ " DECODE(a.sign_st, '1', '계약자', '2', '공동임차인', '3', '승계원계약자') sign_st, "
				+ " DECODE(a.sign_type, '0', '서명없음', '1', '인증서', '2', '자필서명') sign_type, "
				+ " TO_CHAR(a.end_dt, 'YYYY-MM-DD HH24:MI:SS') end_dt, a.end_file, "
				+ " DECODE( DECODE(o.cls_st, '4', '차종변경', '5', '계약승계'), '', NVL( "
				+ " DECODE(e.rent_st, '1', '', '연장'), DECODE(b.rent_st, '1', '신규', '2', '연장', '3', '대차', '4', '증차', '5', '연장', '6', '재리스', '7', '재리스') ), "
				+ " NVL( DECODE(e.rent_st, '1', '', DECODE(f.suc_rent_st, e.rent_st, '계약승계', DECODE(SIGN(TO_DATE(e.rent_dt, 'YYYYMMDD')-TO_DATE(o.cls_dt, 'YYYYMMDD')), 1, '연장', 0, '연장', ''))), "
				+ " DECODE(o.cls_st, '4', '차종변경', '5', '계약승계')) ) AS rent_type "
				+ " FROM alink.e_doc_mng a, cont b, car_reg c, users d, fee e, cont_etc f, car_etc h, car_nm i, car_mng j, "
				+ " ( SELECT rent_mng_id, reg_dt, cls_dt, cls_st FROM cls_cont WHERE cls_st IN ('4','5')) o "
				+ " WHERE a.rent_l_cd = b.rent_l_cd AND a.rent_mng_id = b.rent_mng_id "
				+ " AND b.car_mng_id = c.car_mng_id(+) AND a.reg_id = d.user_id "
				+ " AND a.rent_mng_id = h.rent_mng_id AND a.rent_l_cd = h.rent_l_cd AND h.car_id=i.car_id AND h.car_seq=i.car_seq "
				+ " AND i.car_comp_id=j.car_comp_id  AND i.car_cd=j.code AND b.rent_mng_id = o.rent_mng_id(+) AND b.reg_dt = o.reg_dt(+) "
				+ " AND a.rent_mng_id = e.rent_mng_id AND a.rent_l_cd = e.rent_l_cd  AND a.rent_st = e.rent_st "
				+ " AND a.rent_mng_id = f.rent_mng_id AND a.rent_l_cd = f.rent_l_cd "
				+ " AND a.doc_type = 1 AND a.doc_name != '월렌트계약서' ";
		
				
		// 날짜 검색
		if(gubun4.equals("1") && !gubun5.equals("")){
			if(gubun5.equals("1")){	// 당일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') = to_char(sysdate,'YYYYMMDD') ";
			} else if(gubun5.equals("2")){ // 전일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') = to_char(sysdate-1,'YYYYMMDD') ";
			} else if(gubun5.equals("3")){	// 2일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') BETWEEN to_char(sysdate-1,'YYYYMMDD') AND to_char(sysdate,'YYYYMMDD') ";
			} else if(gubun5.equals("4")){	// 당월
				query += " AND to_char(a.reg_dt, 'YYYYMM') = to_char(sysdate,'YYYYMM') ";
			} else if(gubun5.equals("5")){	// 전월
				query += " AND to_char(a.reg_dt, 'YYYYMM') = to_char(add_months(sysdate, -1),'YYYYMM') ";
			} else if(gubun5.equals("6")){	// 기간
				if(!st_dt.equals("") && end_dt.equals(""))	query += " AND to_char(a.reg_dt, 'YYYYMMDD') like replace('%"+st_dt+"%', '-','') \n";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " AND to_char(a.reg_dt, 'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
			}
		}
		
		// 구분 검색
		if(gubun1.equals("")){	// 장기계약서 전체
			query += "";
		} else if(gubun1.equals("1")){	// 신규 계약서
			query += " AND a.doc_name = '장기계약서' ";
		} else if(gubun1.equals("2")){	// 승계 계약서
			query += " AND a.doc_name = '계약승계계약서' ";
		} else if(gubun1.equals("3")){	// 연장 계약서
			query += " AND a.doc_name = '연장계약서' ";
		}
		
		//
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){
				query += " AND upper(a.firm_nm) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("2")){
				query += " AND upper(a.rent_l_cd) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("3")){
				query += " AND upper(c.car_no) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("4")){
				query += " AND upper(j.car_nm||' '||i.car_name) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("5")){
				query += " AND upper(d.user_nm) like upper('%"+t_wd+"%') ";
			}
		}
		
		query += " ORDER BY a.reg_dt DESC ";

		try {
//				System.out.println(query);
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
			System.out.println("[ALinkDatabase:getLcEdocMngList]\n"+e);
			System.out.println("[ALinkDatabase:getLcEdocMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	
	// 전자문서 월렌트 계약서 리스트
	public Vector getRmEdocMngList(String gubun1, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT a.doc_code, a.rent_mng_id, a.rent_l_cd, a.rent_st, a.firm_nm, c.car_nm, c.car_no, d.user_nm, "
				+ " to_char(a.reg_dt, 'YYYY-MM-DD HH24:MI:SS') reg_dt, to_char(a.term_dt, 'YYYY-MM-DD') term_dt, "
				+ " DECODE(a.use_yn, 'Y', '등록', 'N', '취소') use_yn, "
				+ " DECODE(a.send_type, 'mail', '이메일', 'talk', '알림톡', 'park', '현장', 'driver', '기사') send_type, "
				+ " DECODE(a.sign_type, '0', '서명없음', '1', '인증서', '2', '자필서명') sign_type, TO_CHAR(a.end_dt, 'YYYY-MM-DD HH24:MI:SS') end_dt, a.end_file, "
				+ " a.url "
				+ " FROM alink.e_doc_mng a, cont b, car_reg c, users d "
				+ " WHERE doc_type = '1' AND doc_name = '월렌트계약서' "
				+ " AND a.rent_l_cd = b.rent_l_cd AND a.rent_mng_id = b.rent_mng_id "
				+ " AND b.car_mng_id = c.car_mng_id AND a.reg_id = d.user_id ";
		
		
		// 날짜 검색
		if(gubun4.equals("1") && !gubun5.equals("")){
			if(gubun5.equals("1")){	// 당일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') = to_char(sysdate,'YYYYMMDD') ";
			} else if(gubun5.equals("2")){ // 전일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') = to_char(sysdate-1,'YYYYMMDD') ";
			} else if(gubun5.equals("3")){	// 2일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') BETWEEN to_char(sysdate-1,'YYYYMMDD') AND to_char(sysdate,'YYYYMMDD') ";
			} else if(gubun5.equals("4")){	// 당월
				query += " AND to_char(a.reg_dt, 'YYYYMM') = to_char(sysdate,'YYYYMM') ";
			} else if(gubun5.equals("5")){	// 전월
				query += " AND to_char(a.reg_dt, 'YYYYMM') = to_char(add_months(sysdate, -1),'YYYYMM') ";
			} else if(gubun5.equals("6")){	// 기간
				if(!st_dt.equals("") && end_dt.equals(""))	query += " AND to_char(a.reg_dt, 'YYYYMMDD') like replace('%"+st_dt+"%', '-','') \n";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " AND to_char(a.reg_dt, 'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
			}
		}
				
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){
				query += " AND upper(a.firm_nm) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("2")){
				query += " AND upper(a.rent_l_cd) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("3")){
				query += " AND upper(c.car_no) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("4")){
				query += " AND upper(c.car_nm) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("5")){
				query += " AND upper(d.user_nm) like upper('%"+t_wd+"%') ";
			}
		}
		
		query += " ORDER BY a.reg_dt DESC ";
		
		try {
		//		System.out.println(query);
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
			System.out.println("[ALinkDatabase:getRmEdocMngList]\n"+e);
			System.out.println("[ALinkDatabase:getRmEdocMngList]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	
	// 전자문서 인도인수증 리스트
	public Vector getDeliEdocMngList(String gubun1, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String b_trf_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT a.doc_code, NVL2(b.cons_no, b.cons_no||'-'||b.seq, a.cons_no) cons_no, b.off_nm, a.firm_nm, e.car_no, e.car_nm, d.user_nm,"
				+ " to_char(a.reg_dt, 'YYYY-MM-DD HH24:MI:SS') reg_dt, "
				+ " DECODE(a.use_yn, 'Y', '등록', 'N', '취소') use_yn, "
				+ " DECODE(a.send_type, 'mail', '이메일', 'talk', '알림톡', 'park', '현장', 'driver', '기사') send_type, "
				+ " TO_CHAR(a.end_dt, 'YYYY-MM-DD HH24:MI:SS') end_dt, a.end_file "
				+ " FROM alink.e_doc_mng a, "
				+ " (SELECT DISTINCT cons_no, seq, cons_no||seq AS temp_cons_no, off_nm FROM CONSIGNMENT) b, "
				+ " (SELECT DISTINCT cons_no, tmsg_seq, car_no, car_nm FROM alink.consignment_link WHERE cons_yn = 'Y') c, "
				+ " users d, alink.consignment_link e "
				+ " WHERE a.cons_no = b.temp_cons_no(+) AND a.doc_code = c.tmsg_seq(+) AND a.cons_no = e.cons_no(+) "
				+ " AND a.reg_id = d.user_id AND a.doc_type = '2'  ";
		
		
		// 날짜 검색
		if(gubun4.equals("1") && !gubun5.equals("")){
			if(gubun5.equals("1")){	// 당일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') = to_char(sysdate,'YYYYMMDD') ";
			} else if(gubun5.equals("2")){ // 전일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') = to_char(sysdate-1,'YYYYMMDD') ";
			} else if(gubun5.equals("3")){	// 2일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') BETWEEN to_char(sysdate-1,'YYYYMMDD') AND to_char(sysdate,'YYYYMMDD') ";
			} else if(gubun5.equals("4")){	// 당월
				query += " AND to_char(a.reg_dt, 'YYYYMM') = to_char(sysdate,'YYYYMM') ";
			} else if(gubun5.equals("5")){	// 전월
				query += " AND to_char(a.reg_dt, 'YYYYMM') = to_char(add_months(sysdate, -1),'YYYYMM') ";
			} else if(gubun5.equals("6")){	// 기간
				if(!st_dt.equals("") && end_dt.equals(""))	query += " AND to_char(a.reg_dt, 'YYYYMMDD') like replace('%"+st_dt+"%', '-','') \n";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " AND to_char(a.reg_dt, 'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
			}
		}
		
		//
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){	// 상호
				query += " AND upper(a.firm_nm) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("2")){	// 차량번호
				query += " AND upper(c.car_no) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("3")){	// 차명
				query += " AND upper(c.car_nm) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("4")){	// 송신자
				query += " AND upper(d.user_nm) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("5")){	// 탁송번호
				query += " AND upper(a.cons_no) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("6")){	// 탁송업체
				query += " AND upper(b.off_nm) like upper('%"+t_wd+"%') ";
			}
		}
		
		// 채권양도통지서 및 위임장 있는 것만 검색
		if( !b_trf_yn.equals("") ){
			query += " AND c.b_trf_yn = 'Y' ";
		}
		
		query += " ORDER BY a.reg_dt DESC ";
		
		try {
//			System.out.println(query);
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
			System.out.println("[ALinkDatabase:getDeliEdocMngList]\n"+e);
			System.out.println("[ALinkDatabase:getDeliEdocMngList]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	
	// 전자문서 확인서/요청서 리스트
	public Vector getConfirmEdocMngList(String gubun1, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.doc_code, a.doc_name, a.rent_l_cd, firm_nm, j.car_nm||' '||i.car_name AS car_nm, c.car_no, "
				+ " d.user_nm, to_char(a.reg_dt, 'YYYY-MM-DD HH24:MI:SS') reg_dt, to_char(a.term_dt, 'YYYY-MM-DD') term_dt, "
				+ " DECODE(a.send_type, 'mail', '이메일', 'talk', '알림톡', 'park', '현장', 'driver', '기사') send_type,  "
				+ " decode(a.sign_type, '0', '서명 없음', '1', '인증서', '2', '자필서명') sign_type, "
				+ " TO_CHAR(a.end_dt, 'YYYY-MM-DD HH24:MI:SS') end_dt, a.end_file "
				+ " FROM alink.e_doc_mng a, cont b, car_reg c, users d, car_etc h, car_nm i, car_mng j "
				+ " WHERE a.rent_l_cd = b.rent_l_cd(+)  AND a.rent_mng_id = b.rent_mng_id(+)  "
				+ " AND b.car_mng_id = c.car_mng_id(+) AND a.reg_id = d.user_id(+) "
				+ " AND a.rent_mng_id = h.rent_mng_id(+) AND a.rent_l_cd = h.rent_l_cd(+) AND h.car_id=i.car_id(+) AND h.car_seq=i.car_seq(+) "
				+ " AND i.car_comp_id = j.car_comp_id(+)  AND i.car_cd = j.code(+) AND a.doc_type IN ('3', '4') ";
		
				
		// 날짜 검색
		if(gubun4.equals("1") && !gubun5.equals("")){
			if(gubun5.equals("1")){	// 당일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') = to_char(sysdate,'YYYYMMDD') ";
			} else if(gubun5.equals("2")){ // 전일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') = to_char(sysdate-1,'YYYYMMDD') ";
			} else if(gubun5.equals("3")){	// 2일
				query += " AND to_char(a.reg_dt, 'YYYYMMDD') BETWEEN to_char(sysdate-1,'YYYYMMDD') AND to_char(sysdate,'YYYYMMDD') ";
			} else if(gubun5.equals("4")){	// 당월
				query += " AND to_char(a.reg_dt, 'YYYYMM') = to_char(sysdate,'YYYYMM') ";
			} else if(gubun5.equals("5")){	// 전월
				query += " AND to_char(a.reg_dt, 'YYYYMM') = to_char(add_months(sysdate, -1),'YYYYMM') ";
			} else if(gubun5.equals("6")){	// 기간
				if(!st_dt.equals("") && end_dt.equals(""))	query += " AND to_char(a.reg_dt, 'YYYYMMDD') like replace('%"+st_dt+"%', '-','') \n";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " AND to_char(a.reg_dt, 'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
			}
		}
		
		// 구분 검색
		if(!gubun1.equals("")){	// 문서 검색
			query += " AND a.doc_name = '" + gubun1 +"'";
		}
		
		//
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){	// 상호
				query += " AND upper(a.firm_nm) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("2")){	// 계약번호
				query += " AND upper(a.rent_l_cd) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("3")){	// 차량번호
				query += " AND upper(c.car_no) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("4")){	// 차명
				query += " AND upper(j.car_nm||' '||i.car_name) like upper('%"+t_wd+"%') ";
			} else if(s_kd.equals("5")){
				query += " AND upper(d.user_nm) like upper('%"+t_wd+"%') ";
			}
		}
		
		query += " ORDER BY a.reg_dt DESC ";

		try {
//				System.out.println(query);
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
			System.out.println("[ALinkDatabase:getConfirmEdocMngList]\n"+e);
			System.out.println("[ALinkDatabase:getConfirmEdocMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	
	public boolean discardEDoc(String link_code){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " UPDATE alink.E_DOC_MNG SET use_yn = 'N' WHERE link_code=? ";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, link_code);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[ALinkDatabase: discardEDoc]"+ e);
			System.out.println("[ALinkDatabase: discardEDoc]"+ query);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}
	
		// 전자문서 데이터 단 건 조회.
		public Hashtable getFirstEDocMng(String rent_l_cd, String doc_type){
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "";

			query = " SELECT * FROM alink.e_doc_mng "
					+ " WHERE rent_l_cd ='" + rent_l_cd + "'"
					+ " AND doc_type = '"+doc_type+"' "
					+ " AND sign_st = '1' AND use_yn = 'Y' ";

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
				System.out.println("[ALinkDatabase:getFirstEDocMng]\n"+e);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return ht;
			}
		}
		
		// 계약 건에 대한 최근 CMS 신청서 발송 건 조회 
		public Hashtable getCmsEDocMng(String rent_l_cd){
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "";
			
			query = " SELECT * FROM ( "
					+ " SELECT * FROM alink.e_doc_mng "
					+ " WHERE rent_l_cd = '"+rent_l_cd+"' "
					+ " AND USE_YN = 'Y' AND DOC_NAME LIKE '%CMS자동이체신청서%' "
					+ " ORDER BY REG_DT DESC "
					+ " ) WHERE rownum = 1 ";
			
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
				System.out.println("[ALinkDatabase: getCmsEDocMng]\n"+e);
				e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return ht;
			}
		}
	
		// 전자문서 이전 발송 건 유무 조회. 폐기 기능 있는 계약서만 해당
		public int getEDocMngOverCount(String rent_l_cd, String rent_mng_id, String rent_st)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			int count = 0;

			query = " SELECT count(*) FROM alink.e_doc_mng "
					+ " WHERE doc_type = '1' AND use_yn = 'Y' "
					+ " and rent_l_cd = '"+ rent_l_cd +"' AND rent_mng_id = '" + rent_mng_id + "' AND rent_st = '" + rent_st + "'" ;


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
				System.out.println("[ALinkDatabase:getEDocMngOverCount]\n"+e);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
		}
}
