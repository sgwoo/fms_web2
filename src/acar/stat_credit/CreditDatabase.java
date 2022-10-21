package acar.stat_credit;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import acar.cont.*;
import acar.fee.*;
import acar.cls.*;


public class CreditDatabase
{
	private Connection conn = null;
	public static CreditDatabase s_db;
	
	public static CreditDatabase getInstance()
	{
		if(CreditDatabase.s_db == null)
			CreditDatabase.s_db = new CreditDatabase();
		return CreditDatabase.s_db;	
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

	// ��ȸ -------------------------------------------------------------------------------------------------

	//�̼�ä�� ����Ʈ ��ȸ
	public Vector getCreditList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select decode(rtrim(a.credit_st),'-','1','����','2','�߽�','3','����','4','����','5'), a.*, a.car_nm as car_nm2 from credit_view a, car_etc b  \n"+
		               " where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
		               " and a.amt > 0 ";

		/*����ȸ&&������ȸ*/

		//���-�̼���
		if(gubun2.equals("1") && gubun3.equals("3")){	query += " and a.cls_dt like to_char(sysdate,'YYYYMM')||'%'";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and a.cls_dt = to_char(sysdate,'YYYYMMDD')";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and a.cls_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.cls_dt > '20030101'";
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.cls_dt > '20030101'";
		}

		if(!br_id.equals("S1") && !br_id.equals(""))		query += " and a.rent_l_cd like '"+br_id+"%'";

		if(gubun4.equals("2"))			  query += " and a.cls_gubun ='�����'";
		else if(gubun4.equals("3"))		query += " and a.cls_gubun ='�뿩��'";

		/*�˻�����*/
			
		if(s_kd.equals("2"))		query += " and nvl(a.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(a.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(a.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(a.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(a.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and a.bus_id2= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and nvl(a.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.credit_st, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(a.firm_nm, '') like '%"+t_wd+"%'\n";			

		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/

		if(sort_gubun.equals("1"))		query += " order by 1 asc, a.use_yn desc, a.firm_nm "+sort+", a.cls_dt";
		else if(sort_gubun.equals("2"))	query += " order by 1 asc, a.use_yn desc, a.cls_dt "+sort+", a.firm_nm";
		else if(sort_gubun.equals("3"))	query += " order by 1 asc, a.use_yn desc, a.amt "+sort+", a.firm_nm, a.cls_dt";
	
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
	    		    	
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
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[CreditDatabase:getCreditList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	// �ߵ���������� �Ǻ� ������ ����Ʈ ��ȸ
	public Vector getCreditScd(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query =  " select * from credit_view where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
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
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[CreditDatabase:getCreditScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	�ߵ����� ������ �̼�ó��
	 */
	public boolean updateCreditScd(String cmd, String table_nm, String m_id, String l_cd, String rent_st, String tm, String tm_st1){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String sub_query = "";
		if(table_nm.equals("scd_ext")){	sub_query = " and ext_tm='"+tm+"'";
		}else{							sub_query = " and rent_st='"+rent_st+"' and fee_tm='"+tm+"'";
			if(tm_st1.equals("")){		sub_query += " and tm_st1='"+tm_st1+"'";
			}
		}

		//�̼����
		String query1 = " UPDATE "+table_nm+" SET bill_yn='Y' WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' "+sub_query;

		//�����ٻ���
		String query2 = " DELETE FROM "+table_nm+" WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' "+sub_query;

		try 
		{		
			conn.setAutoCommit(false);

			if(cmd.equals("c")){
				pstmt = conn.prepareStatement(query1);
			}else{
				pstmt = conn.prepareStatement(query2);			
			}
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[CreditDatabase:updateCreditScd]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

}
