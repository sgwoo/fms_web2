/**
 * �λ�ī��
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 24
 * @ last modify date : 
 */

package acar.partner;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;


public class PartnerDatabase
{
	private Connection conn = null;
	public static PartnerDatabase db;
	
	public static PartnerDatabase getInstance()
	{
		if(PartnerDatabase.db == null)
			PartnerDatabase.db = new PartnerDatabase();
		return PartnerDatabase.db;
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
	 *	���¾�ü ��ü��ȸ 
	 */

	
	public Vector PartnerAll(String user_id, String auth_rw, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				 query = " select po_id, br_id, reg_dt, user_id, upd_dt, upd_id, po_gubun, "+
						 "        decode(po_gubun,'1','�ڵ��� ����','2','�����ü','3','Ź�۾�ü','4','�����','5','��Ÿ','6','��ǰ��ü','7','����⵿','8','�˻��ü')as po_gubun2, "+
						 "        po_nm, po_own, po_no, po_sta, po_item, po_o_tel, po_m_tel, po_fax, po_post, po_addr, po_web, po_note, \n"+
						 "        po_agnt_nm, po_agnt_m_tel, po_agnt_o_tel \n"+
						 " from   partner_office  where po_gubun not in ('9','N')\n";

				 query += " ORDER BY DECODE(po_gubun,'1',0,'2',2,'3',3,'6',4,'7',5,'8',6,'4',7), DECODE(po_sta,'Ư��',0, '����',1,'���',2,'�ֿ�',3,'�Ｚ',4,'���',5,'����',6,'�˻�',7,'Ź��',8,'����',9,'����⵿',10,'��ǰ',11),  po_id , DECODE(Br_id,'S1',0,'S2',1,'J1',2,'K1',3,'D1',4,'B1',5) ";

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
			System.out.println("[PartnerDatabase:PartnerAll]"+e);
			System.out.println("[PartnerDatabase:PartnerAll]"+query);
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
	 *	���¾�ü ����ϱ�
	 */
	
public int insertPartner(Partner_Bean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String userQuery = "";
		String po_id = "";

		int seq = 0;

 	  	query = " insert into partner_office \n"+
				" (po_id, br_id, reg_dt, user_id, upd_dt, upd_id, po_gubun, po_nm, po_own, po_no, po_sta,\n"+
				" po_item, po_o_tel, po_m_tel, po_fax, po_post, po_addr, po_web, po_note, po_agnt_nm, po_agnt_m_tel, po_agnt_o_tel, po_email \n"+
				" ) values ("+
				" ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? "+
				" )";		

		userQuery = "select nvl(lpad(max(po_id)+1,6,'0'),'000001') from partner_office";

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(userQuery);
			if(rs.next())
            	po_id = rs.getString(1).trim();
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, po_id.trim());
			pstmt.setString(2, bean.getBr_id());
			pstmt.setString(3, bean.getUser_id());
			pstmt.setString(4, bean.getUpd_dt());
			pstmt.setString(5, bean.getUpd_id());
			pstmt.setString(6, bean.getPo_gubun());
			pstmt.setString(7, bean.getPo_nm());
			pstmt.setString(8, bean.getPo_own());
			pstmt.setString(9, bean.getPo_no());
			pstmt.setString(10, bean.getPo_sta());
			pstmt.setString(11, bean.getPo_item());
			pstmt.setString(12, bean.getPo_o_tel());
			pstmt.setString(13, bean.getPo_m_tel());
			pstmt.setString(14, bean.getPo_fax());
			pstmt.setString(15, bean.getPo_post());
			pstmt.setString(16, bean.getPo_addr());
			pstmt.setString(17, bean.getPo_web());
			pstmt.setString(18, bean.getPo_note());
			pstmt.setString(19, bean.getPo_agnt_nm());
			pstmt.setString(20, bean.getPo_agnt_m_tel());
			pstmt.setString(21, bean.getPo_agnt_o_tel());
			pstmt.setString(22, bean.getPo_email());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[PartnerDatabase:insertPartner]\n"+e);
			System.out.println("[PartnerDatabase:insertPartner]\n"+query);
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

//�Ѱ���ȸ
public Hashtable Partner(String po_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

				 query = " select po_id, br_id, reg_dt, user_id, upd_dt, upd_id, po_gubun, "+
						 "        decode(po_gubun,'1','�ڵ��� ����','2','�����ü','3','Ź�۾�ü','4','�����','5','��Ÿ','6','��ǰ��ü')as po_gubun2, "+
						 "        po_nm, po_own, po_no, po_sta, po_item, po_o_tel, po_m_tel, po_fax, po_post, po_addr, po_web, po_note, "+
						 "        po_agnt_nm, po_agnt_m_tel, po_agnt_o_tel, nvl(po_email,'') po_email \n"+
						 " from   partner_office \n"+
						 " where  po_id = '"+po_id+"'";



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
			System.out.println("[PartnerDatabase:Partner]"+e);
			System.out.println("[PartnerDatabase:Partner]"+query);
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

//����
	public int Update_Partner(Partner_Bean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";


		query = " update partner_office set\n"+
				" upd_dt = to_char(sysdate,'YYYYMMDD'), \n"+
				" upd_id = ?, \n"+
				" br_id = ?, "+
				" po_gubun = ?, \n"+
				" po_nm =  ?, \n"+
				" po_own = ?, \n"+ 
				" po_no = ?, \n"+ 
				" po_sta = ?, \n"+
				" po_item = ?, \n"+
				" po_o_tel = ?, \n"+ 
				" po_m_tel = ?, \n"+ 
				" po_fax = ?, \n"+ 
				" po_post = ?, \n"+ 
				" po_addr = ?, \n"+ 
				" po_web = ?, \n"+ 
				" po_note = ?, \n"+ 
				" po_agnt_nm = ?, \n"+ 
				" po_agnt_m_tel = ?, \n"+ 
				" po_agnt_o_tel = ?, \n"+ 
				" po_email = ? \n"+ 
				" where po_id=? ";		

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUpd_id());
			pstmt.setString(2, bean.getBr_id());
			pstmt.setString(3, bean.getPo_gubun());
			pstmt.setString(4, bean.getPo_nm());
			pstmt.setString(5, bean.getPo_own());
			pstmt.setString(6, bean.getPo_no());
			pstmt.setString(7, bean.getPo_sta());
			pstmt.setString(8, bean.getPo_item());
			pstmt.setString(9, bean.getPo_o_tel());
			pstmt.setString(10, bean.getPo_m_tel());
			pstmt.setString(11, bean.getPo_fax());
			pstmt.setString(12, bean.getPo_post());
			pstmt.setString(13, bean.getPo_addr());
			pstmt.setString(14, bean.getPo_web());
			pstmt.setString(15, bean.getPo_note());
			pstmt.setString(16, bean.getPo_agnt_nm());
			pstmt.setString(17, bean.getPo_agnt_m_tel());
			pstmt.setString(18, bean.getPo_agnt_o_tel());
			pstmt.setString(19, bean.getPo_email());
			pstmt.setString(20, bean.getPo_id());


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[PartnerDatabase:Update_Partner]\n"+e);
			System.out.println("[PartnerDatabase:Update_Partner]\n"+query);
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


		

	/**
	 *	��󿬶��� �Ѱ� ����
	 */

public int Del_Partner(Partner_Bean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " DELETE  FROM partner_office \n"+
				" where po_id=?";		

		try 
		{	
			conn.setAutoCommit(false);		
		
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getPo_id());
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[PartnerDatabase:Del_Partner]\n"+e);
			System.out.println("[PartnerDatabase:Del_Partner]\n"+query);
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

/**
	 *	���¾�ü ���̵����
	 */
	public Vector Partner_idps(String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				 query = " select po_id, br_id, reg_dt, user_id, upd_dt, upd_id, po_gubun, "+
						 "        decode(po_gubun,'1','�ڵ��� ����','2','�����ü','3','Ź�۾�ü','4','�����','5','��Ÿ','6','��ǰ��ü')as po_gubun2, "+
						 "        po_nm, po_own, po_no, po_sta, po_item, po_o_tel, po_m_tel, po_fax, po_post, po_addr, po_web, po_note, \n"+
						 "        po_agnt_nm, po_agnt_m_tel, po_agnt_o_tel, po_login_id, po_login_ps, po_email\n"+
						 " from   partner_office  where po_login_id is not null\n";

				 query += "order by po_gubun, po_id";


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
			System.out.println("[PartnerDatabase:PartnerAll]"+e);
			System.out.println("[PartnerDatabase:PartnerAll]"+query);
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
	
	//�Ѱ���ȸ
public Hashtable Partner_Biz(String po_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

				 query = " select po_id, br_id, reg_dt, user_id, upd_dt, upd_id, po_gubun, "+
						 "        decode(po_gubun,'1','�ڵ��� ����','2','�����ü','3','Ź�۾�ü','4','�����','5','��Ÿ','6','��ǰ��ü')as po_gubun2, "+
						 "        po_nm, po_own, po_no, po_sta, po_item, po_o_tel, po_m_tel, po_fax, po_post, po_addr, po_web, po_note, "+
						 "        po_agnt_nm, po_agnt_m_tel, po_agnt_o_tel, po_login_id, po_login_ps, po_email \n"+
						 " from   partner_office \n"+
						 " where  po_id = '"+po_id+"'";



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
			System.out.println("[PartnerDatabase:Partner]"+e);
			System.out.println("[PartnerDatabase:Partner]"+query);
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

	// ���¾�ü ���̵����-����
	public int UpPartner_Biz(Partner_Bean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";


		query = " update partner_office set\n"+
				" upd_dt = to_char(sysdate,'YYYYMMDD'), \n"+
				" upd_id = ?, \n"+
				" po_gubun = ?, \n"+
				" po_nm =  ?, \n"+
				" po_own = ?, \n"+ 
				" po_no = ?, \n"+ 
				" po_sta = ?, \n"+
				" po_item = ?, \n"+
				" po_o_tel = ?, \n"+ 
				" po_m_tel = ?, \n"+ 
				" po_fax = ?, \n"+ 
				" po_post = ?, \n"+ 
				" po_addr = ?, \n"+ 
				" po_web = ?, \n"+ 
				" po_note = ?, \n"+ 
				" po_agnt_nm = ?, \n"+ 
				" po_agnt_m_tel = ?, \n"+ 
				" po_agnt_o_tel = ?, \n"+ 
				" po_login_id = ?, \n"+ 
				" po_login_ps = ?, \n"+ 
				" po_email = ? \n"+
				" where po_id=? ";		

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUpd_id());
			pstmt.setString(2, bean.getPo_gubun());
			pstmt.setString(3, bean.getPo_nm());
			pstmt.setString(4, bean.getPo_own());
			pstmt.setString(5, bean.getPo_no());
			pstmt.setString(6, bean.getPo_sta());
			pstmt.setString(7, bean.getPo_item());
			pstmt.setString(8, bean.getPo_o_tel());
			pstmt.setString(9, bean.getPo_m_tel());
			pstmt.setString(10, bean.getPo_fax());
			pstmt.setString(11, bean.getPo_post());
			pstmt.setString(12, bean.getPo_addr());
			pstmt.setString(13, bean.getPo_web());
			pstmt.setString(14, bean.getPo_note());
			pstmt.setString(15, bean.getPo_agnt_nm());
			pstmt.setString(16, bean.getPo_agnt_m_tel());
			pstmt.setString(17, bean.getPo_agnt_o_tel());
			pstmt.setString(18, bean.getPo_login_id());
			pstmt.setString(19, bean.getPo_login_ps());
			pstmt.setString(20, bean.getPo_email());
			pstmt.setString(21, bean.getPo_id());


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[PartnerDatabase:Update_Partner]\n"+e);
			System.out.println("[PartnerDatabase:Update_Partner]\n"+query);
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

	/**
	 *	���¾�ü ����ϱ�
	 */
	
public int insertPartner_Biz(Partner_Bean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String userQuery = "";
		String po_id = "";

		int seq = 0;

 	  	query = " insert into partner_office \n"+
				" (po_id, br_id, reg_dt, user_id, upd_dt, upd_id, po_gubun, po_nm, po_own, po_no, po_sta,\n"+
				" po_item, po_o_tel, po_m_tel, po_fax, po_post, po_addr, po_web, po_note, po_agnt_nm, po_agnt_m_tel, po_agnt_o_tel, po_login_id, po_login_ps, po_email \n"+
				" ) values ("+
				" ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? "+
				" )";		

		userQuery = "select nvl(lpad(max(po_id)+1,6,'0'),'000001') from partner_office";

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(userQuery);
			if(rs.next())
            	po_id = rs.getString(1).trim();
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, po_id.trim());
			pstmt.setString(2, bean.getBr_id());
			pstmt.setString(3, bean.getUser_id());
			pstmt.setString(4, bean.getUpd_dt());
			pstmt.setString(5, bean.getUpd_id());
			pstmt.setString(6, bean.getPo_gubun());
			pstmt.setString(7, bean.getPo_nm());
			pstmt.setString(8, bean.getPo_own());
			pstmt.setString(9, bean.getPo_no());
			pstmt.setString(10, bean.getPo_sta());
			pstmt.setString(11, bean.getPo_item());
			pstmt.setString(12, bean.getPo_o_tel());
			pstmt.setString(13, bean.getPo_m_tel());
			pstmt.setString(14, bean.getPo_fax());
			pstmt.setString(15, bean.getPo_post());
			pstmt.setString(16, bean.getPo_addr());
			pstmt.setString(17, bean.getPo_web());
			pstmt.setString(18, bean.getPo_note());
			pstmt.setString(19, bean.getPo_agnt_nm());
			pstmt.setString(20, bean.getPo_agnt_m_tel());
			pstmt.setString(21, bean.getPo_agnt_o_tel());
			pstmt.setString(22, bean.getPo_login_id());
			pstmt.setString(23, bean.getPo_login_ps());
			pstmt.setString(24, bean.getPo_email());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[PartnerDatabase:insertPartner]\n"+e);
			System.out.println("[PartnerDatabase:insertPartner]\n"+query);
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
	 *	���¾�ü ���̵���� ����
	 */

public int Del_Partner_Biz(Partner_Bean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " DELETE  FROM partner_office \n"+
				" where po_id=? and po_gubun = '9' ";		

		try 
		{	
			conn.setAutoCommit(false);		
		
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getPo_id());
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[PartnerDatabase:Del_Partner]\n"+e);
			System.out.println("[PartnerDatabase:Del_Partner]\n"+query);
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

	
	/**
	 *	���¾�ü ����ڰ��� - ������ǥ�߼۴��, ����� ���Ŵ����
	 */
	public Vector getFinMan(String s_kd, String use_yn, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	      if(s_kd.equals("JMJP")){
			s_kd = "�繫��ǥ";
			}
                   String sub_query = "";
                   if  ( gubun.equals("E") ) {
                          sub_query = " and fin_seq not in ( 85 ) ";	
                   }            		
		 query = " select * "+
				               " from   fin_man  where gubun = '"+s_kd +  "' and nvl(use_yn, 'N')  = '"+ use_yn + "' " + sub_query +" \n";
		 query += "order by gubun, sort ";


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
			System.out.println("[PartnerDatabase:getFinMan]"+e);
			System.out.println("[PartnerDatabase:getFinMan]"+query);
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
	

	public Vector getFinMan2(String s_kd, String use_yn, String gubun, String email)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
      
		if(s_kd.equals("JMJP")){
			s_kd = "�繫��ǥ";
		}

                   String sub_query = "";
                   if  ( gubun.equals("E") ) {
                          sub_query = " and fin_seq not in ( 85 ) ";	
                   }            		
		 query = " select * "+
				               " from   fin_man  where gubun = '"+s_kd +  "' and fin_email = '"+email+"' and nvl(use_yn, 'N')  = '"+ use_yn + "' " + sub_query +" \n";
		 query += "order by gubun, sort ";

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
			System.out.println("[PartnerDatabase:getFinMan]"+e);
			System.out.println("[PartnerDatabase:getFinMan]"+query);
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
	
	
	// ��ȸ 
	public FinManBean getFinManBase(int fin_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		FinManBean base = new FinManBean();
		String query = "";
			
		query = " select * "+
				" from FIN_MAN  "+
				" where  fin_seq = ? ";
				
		try
		{
			pstmt = conn.prepareStatement(query);		
			pstmt.setInt(1, fin_seq);
		   	rs = pstmt.executeQuery();
		
			while(rs.next())
			{
			
				base.setFin_seq(rs.getString("fin_seq")==null?0:Integer.parseInt(rs.getString("fin_seq")));			
				base.setCom_nm(rs.getString("com_nm")==null?"":rs.getString("com_nm"));
				base.setBr_nm(rs.getString("br_nm")==null?"":rs.getString("br_nm"));
				base.setAgnt_nm(rs.getString("agnt_nm")==null?"":rs.getString("agnt_nm"));
				base.setAgnt_title	(rs.getString("agnt_title")==null?"":rs.getString("agnt_title"));
				base.setFin_tel	(rs.getString("fin_tel")==null?"":rs.getString("fin_tel"));
				base.setFin_fax	(rs.getString("fin_fax")==null?"":rs.getString("fin_fax"));
				base.setFin_email	(rs.getString("fin_email")==null?"":rs.getString("fin_email"));		
				base.setFin_zip	(rs.getString("fin_zip")==null?"":rs.getString("fin_zip"));
				base.setFin_addr	(rs.getString("fin_addr")==null?"":rs.getString("fin_addr"));
				base.setUse_yn	(rs.getString("use_yn")==null?"":rs.getString("use_yn"));
				base.setGubun	(rs.getString("gubun")==null?"":rs.getString("gubun"));
				base.setFin_m_tel	(rs.getString("fin_m_tel")==null?"":rs.getString("fin_m_tel"));
				base.setSort(rs.getString("sort")==null?0:Integer.parseInt(rs.getString("sort")));			
		
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[PartnerDatabase:getFinManBase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return base;
		}
	}
	
	
		// ���¾�ü ����ڰ���-����
	public int UpdateFinMan(FinManBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " update fin_man set\n"+
				" com_nm = ?, \n"+
				" br_nm =  ?, \n"+
				" agnt_nm = ?, \n"+ 
				" agnt_title = ?, \n"+ 
				" fin_tel = ?, \n"+
				" fin_fax = ?, \n"+
				" fin_email = ?, \n"+ 
				" fin_zip = ?, \n"+ 
				" fin_addr = ?, \n"+ 
				" use_yn = ?, \n"+ 
				" gubun = ?, \n"+ 
				" fin_m_tel = ?, \n"+ 
				" sort = ? \n"+
				" where fin_seq =? ";		

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getCom_nm());
			pstmt.setString(2, bean.getBr_nm());
			pstmt.setString(3, bean.getAgnt_nm());
			pstmt.setString(4, bean.getAgnt_title());
			pstmt.setString(5, bean.getFin_tel());
			pstmt.setString(6, bean.getFin_fax());
			pstmt.setString(7, bean.getFin_email());
			pstmt.setString(8, bean.getFin_zip());
			pstmt.setString(9, bean.getFin_addr());
			pstmt.setString(10, bean.getUse_yn());
			pstmt.setString(11, bean.getGubun());
			pstmt.setString(12, bean.getFin_m_tel());
			pstmt.setInt(13, bean.getSort());
			pstmt.setInt(14, bean.getFin_seq());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[PartnerDatabase:UpdateFinMan]\n"+e);
			System.out.println("[PartnerDatabase:UpdateFinMan]\n"+query);
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

	/**
	 *	���¾�ü ����� ����ϱ�
	 */
	
public int insertFinMan(FinManBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String userQuery = "";
	
		int seq = 0;
		
 	  	query = " insert into fin_man \n"+
				" (fin_seq, com_nm, br_nm, agnt_nm, agnt_title, fin_tel, fin_fax, fin_email, fin_zip, fin_addr,\n"+
				" use_yn, gubun, fin_m_tel, sort \n"+
				" ) values ("+
				" ?, ?, ?, ?, ?, ? , ?, ?, ?, ? ,"+
				" ?, ?, ?, ? "+
				" )";		

		userQuery = "select nvl(max(fin_seq)+1,1) from fin_man";

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
     		rs = stmt.executeQuery(userQuery);
			if(rs.next())
            			seq = rs.getInt(1);
          	rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, seq);
			pstmt.setString(2, bean.getCom_nm());
			pstmt.setString(3, bean.getBr_nm());
			pstmt.setString(4, bean.getAgnt_nm());
			pstmt.setString(5, bean.getAgnt_title());
			pstmt.setString(6, bean.getFin_tel());
			pstmt.setString(7, bean.getFin_fax());
			pstmt.setString(8, bean.getFin_email());
			pstmt.setString(9, bean.getFin_zip());
			pstmt.setString(10, bean.getFin_addr());
			pstmt.setString(11, bean.getUse_yn());
			pstmt.setString(12, bean.getGubun());
			pstmt.setString(13, bean.getFin_m_tel());
			pstmt.setInt(14,  bean.getSort());					
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[PartnerDatabase:insertFinMan]\n"+e);
			System.out.println("[PartnerDatabase:insertFinMan]\n"+query);
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
	 *	���¾�ü ���̵���� ����
	 */

public int delFinMan(FinManBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " DELETE  FROM fin_man \n"+
				" where fin_seq =?  ";		

		try 
		{	
			conn.setAutoCommit(false);		
		
			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1, bean.getFin_seq());
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[PartnerDatabase:delFinMan]\n"+e);
			System.out.println("[PartnerDatabase:delFinMan]\n"+query);
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

	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/


	/**
	 *	���¾�ü ��ü��ȸ 
	 */
	public Vector getSostel_PartnerList(String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select po_id, br_id, reg_dt, user_id, upd_dt, upd_id, po_gubun, "+
				"        decode(po_gubun,'1','�ڵ��� ����','2','�����ü','3','Ź�۾�ü','6','��ǰ��ü','4','�����','5','��Ÿ','6','�Ƹ���ī�繫��') as po_gubun2, "+	
				"        po_nm, po_own, po_no, po_sta, po_item, po_o_tel, po_m_tel, po_fax, po_post, po_addr, po_web, po_note, po_agnt_nm, po_agnt_m_tel, po_agnt_o_tel \n"+
				" from   partner_office \n";

		

		if(t_wd.equals("�ڵ�������")){
									query += " where decode(po_gubun,'1','�ڵ�������','2','���¾�ü','3','���¾�ü','6','���¾�ü','4','�����','5','��Ÿ','7','����⵿','8','���¾�ü') like '%" + t_wd + "%'";
									query += " order by decode(po_sta,'����',1,'���',2,'�Ｚ',3,'���',4,'�ֿ�',5,6), po_item";
		}else{
			if(!t_wd.equals(""))	query += " where decode(po_gubun,'1','�ڵ�������','2','���¾�ü','3','���¾�ü','6','���¾�ü','4','�����','5','��Ÿ','7','����⵿','8','���¾�ü') like '%" + t_wd + "%'";

			if(t_wd.equals("��Ÿ")) query += " and po_nm not in ('�Ƹ���ī�����繫��','ä�ǰ���')";


			if(t_wd.equals("���¾�ü")){
				query += " order by decode(po_sta,'����',1,'����⵿',2,'�˻�',3,'Ź��',4,'��ǰ',5,6), po_nm";
			}else{
				query += " order by decode(po_gubun,'1','1','2','2','3','3','6','4','4','5','5','6','6','7'), decode(po_gubun,'1',po_nm,'0'), po_id";
			}

			
		}




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
			System.out.println("[PartnerDatabase:getSostel_PartnerList]"+e);
			System.out.println("[PartnerDatabase:getSostel_PartnerList]"+query);
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
	 *	���¾�ü ��ȸ 
	 */
	public Hashtable getSostel_Partner(String po_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select po_id, br_id, reg_dt, user_id, upd_dt, upd_id, po_gubun, "+
				"        decode(po_gubun,'1','�ڵ��� ����','2','�����ü','3','Ź�۾�ü','6','��ǰ��ü','4','�����','5','��Ÿ','6','�Ƹ���ī�繫��') as po_gubun2, "+	
				"        po_nm, po_own, po_no, po_sta, po_item, po_o_tel, po_m_tel, po_fax, po_post, po_addr, po_web, po_note \n"+
				" from   partner_office \n"+
				" where po_nm like '%" + po_nm + "%'";


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
			System.out.println("[PartnerDatabase:getSostel_Partner]"+e);
			System.out.println("[PartnerDatabase:getSostel_Partner]"+query);
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

	/**
	 *	���¾�ü �ǹ��� ��ȸ 
	 */
	public Hashtable getPartnerAgnt(String po_own, String po_m_tel)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select po_agnt_nm, po_agnt_m_tel \n"+
				" from   partner_office \n"+
				" where  replace(replace(po_own,' ',''),'����','') = '"+po_own+"' and po_m_tel='"+po_m_tel+"' ";



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
			System.out.println("[PartnerDatabase:getPartnerAgnt]"+e);
			System.out.println("[PartnerDatabase:getPartnerAgnt]"+query);
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


} // ������ ��ȣ