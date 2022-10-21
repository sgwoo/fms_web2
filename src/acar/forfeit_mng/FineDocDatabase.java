package acar.forfeit_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;

public class FineDocDatabase
{
	private Connection conn = null;
	public static FineDocDatabase db;
	
	public static FineDocDatabase getInstance()
	{
		if(FineDocDatabase.db == null)
			FineDocDatabase.db = new FineDocDatabase();
		return FineDocDatabase.db;
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
	    	System.out.println("I can't get a connection........");
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


	//SEARCH-----------------------------------------------------------------------------------------------------------------------------------------

	/**
     * �ּ� ����Ʈ (������/��)
     */
	public Vector getZipSido(){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		
		//String sql = " select DISTINCT  max(sido) as sido from zip group by substr(zip_cd,1,2) order by sido";
		
		String sql = "select sido from zip group by sido order by sido";

		try {
			    pstmt = conn.prepareStatement(sql);
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
			System.out.println("[FineDocDatabase:getZipSido]\n"+e);
			System.out.println("[FineDocDatabase:getZipSido]\n"+sql);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}

	/**
     * �ּ� ����Ʈ (��/��/��)
     */
	public Vector getZipGugun(String sido){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sql = " select gugun from zip where sido='"+sido.trim()+"' group by gugun order by gugun ";

		try {
			    pstmt = conn.prepareStatement(sql);
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
			System.out.println("[FineDocDatabase:getZipGugun]\n"+e);
			System.out.println("[FineDocDatabase:getZipGugun]\n"+sql);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}

	//select-----------------------------------------------------------------------------------------------------------------------------------------

	//���·� û����� ����Ʈ
	public Vector getFineGovLists(String gubun1, String gubun2, String t_wd)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" SELECT * from fine_gov where gov_id > '0' ";

		if(!gubun1.equals(""))		query += " and nvl(addr,gov_nm) like '%"+gubun1+"%'";
		if(!gubun2.equals(""))		query += " and nvl(addr,gov_nm) like '%"+gubun2+"%'";
		if(!t_wd.equals(""))		query += " and gov_nm like '%"+t_wd+"%'";

		query += " ORDER BY decode(use_yn, '',1,'Y',2, 'N',3), to_number(gov_id) desc, zip ";
	//	System.out.println("[FineDocDatabase:getFineGovLists]\n"+query);
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while(rs.next()){
				FineGovBean bean = new FineGovBean();
				bean.setGov_id	(rs.getString(1));
				bean.setGov_nm	(rs.getString(2));
				bean.setMng_dept(rs.getString(3));
				bean.setTel		(rs.getString(4));
				bean.setFax		(rs.getString(5));
				bean.setZip		(rs.getString(6));
				bean.setAddr	(rs.getString(7));
				bean.setGov_st	(rs.getString(8));
				bean.setMng_nm	(rs.getString(9));
				bean.setMng_pos	(rs.getString(10));
				bean.setBank_nm	(rs.getString(11)==null?"":rs.getString(11));
				bean.setBank_no	(rs.getString(12)==null?"":rs.getString(12));
				bean.setVen_code(rs.getString(13)==null?"":rs.getString(13));
				bean.setVen_name(rs.getString(14)==null?"":rs.getString(14));
				bean.setUse_yn(rs.getString(15)==null?"":rs.getString(15));
				bean.setGov_nm2(rs.getString(16)==null?"":rs.getString(16));
				bean.setGov_dept_code(rs.getString(17)==null?"":rs.getString(17));
				vt.add(bean);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineGovLists]\n"+e);
			System.out.println("[FineDocDatabase:getFineGovLists]\n"+query);

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
	
	public Vector getPoliceListSearch(String t_wd)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" SELECT * from fine_gov where gov_id > '0' and gov_nm like '%������%' ";

		if(!t_wd.equals(""))		query += " and gov_nm like '%"+t_wd+"%'";

		query += " ORDER BY decode(use_yn, '',1,'Y',2, 'N',3), to_number(gov_id) desc, zip ";
	//	System.out.println("[FineDocDatabase:getFineGovLists]\n"+query);
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while(rs.next()){
				FineGovBean bean = new FineGovBean();
				bean.setGov_id	(rs.getString(1));
				bean.setGov_nm	(rs.getString(2));
				bean.setMng_dept(rs.getString(3));
				bean.setTel		(rs.getString(4));
				bean.setFax		(rs.getString(5));
				bean.setZip		(rs.getString(6));
				bean.setAddr	(rs.getString(7));
				bean.setGov_st	(rs.getString(8));
				bean.setMng_nm	(rs.getString(9));
				bean.setMng_pos	(rs.getString(10));
				bean.setBank_nm	(rs.getString(11)==null?"":rs.getString(11));
				bean.setBank_no	(rs.getString(12)==null?"":rs.getString(12));
				bean.setVen_code(rs.getString(13)==null?"":rs.getString(13));
				bean.setVen_name(rs.getString(14)==null?"":rs.getString(14));
				bean.setUse_yn(rs.getString(15)==null?"":rs.getString(15));
				bean.setGov_nm2(rs.getString(16)==null?"":rs.getString(16));
				vt.add(bean);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getPoliceListSearch]\n"+e);
			System.out.println("[FineDocDatabase:getPoliceListSearch]\n"+query);

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

	//���·� û����� �Ѱ� ��ȸ
	public FineGovBean getFineGov(String gov_id)
	{
		getConnection();

		FineGovBean bean = new FineGovBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM fine_gov WHERE gov_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, gov_id);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setGov_id	(rs.getString(1));
				bean.setGov_nm	(rs.getString(2));
				bean.setMng_dept(rs.getString(3));
				bean.setTel		(rs.getString(4));
				bean.setFax		(rs.getString(5));
				bean.setZip		(rs.getString(6));
				bean.setAddr	(rs.getString(7));
				bean.setGov_st	(rs.getString(8));
				bean.setMng_nm	(rs.getString(9));
				bean.setMng_pos	(rs.getString(10));
				bean.setBank_nm	(rs.getString(11)==null?"":rs.getString(11));
				bean.setBank_no	(rs.getString(12)==null?"":rs.getString(12));
				bean.setVen_code(rs.getString(13)==null?"":rs.getString(13));
				bean.setVen_name(rs.getString(14)==null?"":rs.getString(14));
				bean.setUse_yn	(rs.getString(15)==null?"":rs.getString(15));
				bean.setGov_nm2	(rs.getString(16)==null?"":rs.getString(16));
				bean.setGov_dept_code(rs.getString(17)==null?"":rs.getString(17));

			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineGov]\n"+e);
			System.out.println("[FineDocDatabase:getFineGov]\n"+query);
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

	//���·� ���ǽ�û���� �Ѱ� ��ȸ
	public FineDocBean getFineDoc(String doc_id)
	{
		getConnection();

		FineDocBean bean = new FineDocBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM fine_doc WHERE doc_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setDoc_id		(rs.getString(1));
				bean.setDoc_dt		(rs.getString(2));
				bean.setGov_id		(rs.getString(3));
				bean.setMng_dept	(rs.getString(4));
				bean.setPrint_dt	(rs.getString(5));
				bean.setReg_id		(rs.getString(6));
				bean.setReg_dt		(rs.getString(7));
				bean.setUpd_id		(rs.getString(8));	
				bean.setUpd_dt		(rs.getString(9));	
				bean.setGov_st		(rs.getString(10));
				bean.setMng_nm		(rs.getString(11));
				bean.setMng_pos		(rs.getString(12));
				bean.setH_mng_id	(rs.getString(13));
				bean.setB_mng_id	(rs.getString(14));

				bean.setApp_doc3	(rs.getString(15));
				bean.setApp_doc1	(rs.getString(16));
				bean.setApp_doc2	(rs.getString(17));
				bean.setApp_doc4	(rs.getString(18));
				bean.setPrint_id	(rs.getString(19));
				bean.setGov_nm		(rs.getString(20));
				bean.setGov_addr	(rs.getString(21));
				bean.setTitle		(rs.getString(22));
				bean.setEnd_dt		(rs.getString(23));
				bean.setFilename	(rs.getString(24));
				bean.setApp_doc5	(rs.getString(25));
				bean.setPost_num	(rs.getString(27));
				
				bean.setF_result	(rs.getString(28));
				bean.setF_reason	(rs.getString(29));
				bean.setGov_zip		(rs.getString(30));
				bean.setRegyn		(rs.getString(31));
				bean.setApp_docs	(rs.getString(32)==null?"":rs.getString(32));

				bean.setAmt1		(rs.getInt(33));
				bean.setAmt2		(rs.getInt(34));
				bean.setReq_dt		(rs.getString(35));
				bean.setIp_dt		(rs.getString(36));
						
				bean.setRemarks	(rs.getString(37));
				bean.setS_dt		(rs.getString(38));
				bean.setE_dt		(rs.getString(39));		
				bean.setScd_yn		(rs.getString(40));
				bean.setCms_code	(rs.getString(41));
				
				bean.setCltr_rat	(rs.getString(42));  //������
				bean.setCltr_amt	(rs.getInt(43));
				bean.setCltr_chk	(rs.getString(44));
				
				bean.setFund_yn	(rs.getString(46));  //�����ڱ� ����

				bean.setOff_id	(rs.getString(47));  //������
				bean.setSeq	(rs.getInt(48));
				
				bean.setApp_dt	(rs.getString(49));  //ī���Һ� ������
				bean.setCard_yn	(rs.getString(50));  //ī���Һ� ����
				
				
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineDoc]\n"+e);
			System.out.println("[FineDocDatabase:getFineDoc]\n"+query);
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

	//���·� ���ǽ�û���� ������ȣ �ߺ� üũ
	public int getDocIdChk(String doc_id)
	{
		getConnection();

		FineDocBean bean = new FineDocBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int count = 0;

		query = " SELECT count(*) FROM fine_doc WHERE doc_id=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				count = rs.getInt(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDocIdChk]\n"+e);
			System.out.println("[FineDocDatabase:getDocIdChk]\n"+query);
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

	//���·� ���ǽ�û���� ���·� �Ѱ� ��ȸ
	public FineDocListBean getFineDocList(String doc_id, String car_mng_id, String seq_no)
	{
		getConnection();

		FineDocListBean bean = new FineDocListBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT nvl(a.car_no,b.car_no) as car_no2, d.scan_file, c.vio_dt, d.car_st, a.* "+
				" FROM   fine_doc_list a, car_reg b, fine c, cont d "+
				" WHERE  a.doc_id=? and a.car_mng_id=? and a.seq_no=? "+
				"        and a.car_mng_id=b.car_mng_id "+
				"        and a.car_mng_id=c.car_mng_id and a.seq_no=c.seq_no and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
				"        and c.rent_mng_id=d.rent_mng_id and c.rent_l_cd=d.rent_l_cd "+
				"        ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			pstmt.setString(2, car_mng_id);
			pstmt.setString(3, seq_no);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setCar_no			(rs.getString(1));
				bean.setScan_file		(rs.getString(2));
				bean.setVio_dt			(rs.getString(3));
				bean.setCar_st			(rs.getString(4));
				bean.setDoc_id 			(rs.getString(5));
				bean.setCar_mng_id		(rs.getString(6));
				bean.setSeq_no			(rs.getInt(7));
				bean.setRent_mng_id		(rs.getString(8));
				bean.setRent_l_cd		(rs.getString(9));
				bean.setRent_s_cd		(rs.getString(10));
				bean.setFirm_nm			(rs.getString(11));
				bean.setSsn				(rs.getString(12));
				bean.setEnp_no			(rs.getString(13));
				bean.setRent_start_dt	(rs.getString(14));	
				bean.setRent_end_dt		(rs.getString(15));	
				bean.setPaid_no			(rs.getString(16));
				bean.setReg_id			(rs.getString(17));
				bean.setReg_dt			(rs.getString(18));
				bean.setUpd_id			(rs.getString(19));
				bean.setUpd_dt			(rs.getString(20));
				bean.setAmt1			(rs.getInt(22));
				bean.setAmt2			(rs.getInt(23));
				bean.setAmt3			(rs.getInt(24));
				bean.setAmt4			(rs.getInt(25));
				bean.setAmt5			(rs.getInt(26));
				bean.setAmt6			(rs.getInt(27));
				bean.setAmt7			(rs.getInt(28));
				bean.setVar1			(rs.getString(29));
				bean.setVar2			(rs.getString(30));
				bean.setVar3			(rs.getString(31));
				bean.setRent_st			(rs.getString(37));
				bean.setLic_no			(rs.getString(38));		//���������ȣ �߰�(20180828)
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineDocList]\n"+e);
			System.out.println("[FineDocDatabase:getFineDocList]\n"+query);
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

	//���·� ���ǽ�û���� ���·� �Ѱ� ��ȸ
	public FineDocListBean getFineDocList(String car_mng_id, String seq_no, String rent_mng_id, String rent_l_cd)
	{
		getConnection();

		FineDocListBean bean = new FineDocListBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT nvl(a.car_no,b.car_no) car_no2, d.scan_file, c.vio_dt, d.car_st, a.*  "+
				" FROM   fine_doc_list a, car_reg b, fine c, cont d "+
				" WHERE  a.car_mng_id=? and a.seq_no=? and a.rent_mng_id=? and a.rent_l_cd=? "+
				"        and a.car_mng_id=b.car_mng_id "+
				"        and a.car_mng_id=c.car_mng_id and a.seq_no=c.seq_no and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
				"        and c.rent_mng_id=d.rent_mng_id and c.rent_l_cd=d.rent_l_cd "+
				" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, seq_no);
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setCar_no			(rs.getString(1));
				bean.setScan_file		(rs.getString(2));
				bean.setVio_dt			(rs.getString(3));
				bean.setCar_st			(rs.getString(4));
				bean.setDoc_id 			(rs.getString(5));
				bean.setCar_mng_id		(rs.getString(6));
				bean.setSeq_no			(rs.getInt(7));
				bean.setRent_mng_id		(rs.getString(8));
				bean.setRent_l_cd		(rs.getString(9));
				bean.setRent_s_cd		(rs.getString(10));
				bean.setFirm_nm			(rs.getString(11));
				bean.setSsn				(rs.getString(12));
				bean.setEnp_no			(rs.getString(13));
				bean.setRent_start_dt	(rs.getString(14));	
				bean.setRent_end_dt		(rs.getString(15));	
				bean.setPaid_no			(rs.getString(16));
				bean.setReg_id			(rs.getString(17));
				bean.setReg_dt			(rs.getString(18));
				bean.setUpd_id			(rs.getString(19));
				bean.setUpd_dt			(rs.getString(20));
				bean.setAmt1			(rs.getInt(22));
				bean.setAmt2			(rs.getInt(23));
				bean.setAmt3			(rs.getInt(24));
				bean.setAmt4			(rs.getInt(25));
				bean.setAmt5			(rs.getInt(26));
				bean.setAmt6			(rs.getInt(27));
				bean.setAmt7			(rs.getInt(28));
				bean.setVar1			(rs.getString(29));
				bean.setVar2			(rs.getString(30));
				bean.setVar3			(rs.getString(31));
				bean.setRent_st			(rs.getString(37));
				bean.setLic_no			(rs.getString(38));
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineDocList]\n"+e);
			System.out.println("[FineDocDatabase:getFineDocList]\n"+query);
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

	//���·� ���ǽ�û���� ���·� ����Ʈ��ȸ : ������
	public Vector getFineDocLists(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		

		query = " SELECT a.doc_id, a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, a.rent_s_cd, a.rent_st, a.firm_nm, "+
				"        CASE WHEN e.CLIENT_ST = '1' THEN a.ssn else SUBSTR(a.SSN,1,6)||'*******' END AS ssn, "+
				"        a.enp_no, "+
				"		 DECODE(g.cust_id,'',e.client_st,ee.client_st) AS client_st, "+
				"        decode (a.rent_start_dt,'','',substr(a.rent_start_dt,1,8)) as  rent_start_dt, "+
				"        decode (a.rent_end_dt,'','',substr( a.rent_end_dt,1,8)) as rent_end_dt, "+
				"        a.paid_no, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, "+
				"        nvl(a.car_no,b.car_no) AS CAR_NO2, d.scan_file, c.vio_dt, d.car_st, c.file_name, c.file_type, c.vio_st, c.note, "+
				"        nvl(a.rent_s_cd,c.rent_s_cd) rent_s_cd2, "+
				"        decode(g.cust_id,'',d.client_id,g.cust_id) client_id, "+
				"		 DECODE(g.cust_id,'',NVL(d.P_ZIP,e.o_zip),NVL(dg.P_ZIP,ee.o_zip)) AS HO_ZIP, "+
				"        DECODE(g.cust_id,'',NVL(d.P_ADDR,e.o_addr),NVL(dg.P_ADDR,ee.o_addr)) AS HO_ADDR, "+
				"        nvl(f.fee_st,'�ű�') fee_st, decode(d.car_st,'4','(��)') rm_st, "+
				"        f.rent_start_dt r_s_dt, f.rent_end_dt AS r_e_dt, "+
				"        dg.rent_l_cd AS sub_rent_l_cd, dg.rent_mng_id  AS sub_rent_mng_id, "+
//				VV���������ȣ ��ȸ ���� ����-������Ͻ� ���� ��ȸ�ؼ� insert ��Ű�� ������� ����(20180829)
//				"		 DECODE(a.lic_no,'',DECODE(g.cust_id,'',DECODE(d.lic_no,'',DECODE(d.mgr_lic_no,'','-',d.mgr_lic_no),d.lic_no),DECODE(dg.lic_no,'',DECODE(dg.mgr_lic_no,'',DECODE(d.mgr_lic_no,'','-',d.mgr_lic_no),dg.mgr_lic_no),dg.lic_no)),a.lic_no) AS lic_no \n"+
//				VV��ǥ���� ���������ȣ�� ����  �����̿����� ���������ȣ�� �ִ°�� �����̿���(���������ȣ �̸�) �÷� ǥ�õǰ�..(20190718)
				"		 DECODE(a.lic_no,'',DECODE(g.cust_id,'',DECODE(d.lic_no,'',DECODE(d.mgr_lic_no,'','-',d.mgr_lic_no ||'<br>�����̿���('||d.mgr_lic_emp||')'),d.lic_no),DECODE(dg.lic_no,'',DECODE(dg.mgr_lic_no,'',DECODE(d.mgr_lic_no,'','-',d.mgr_lic_no ||'<br>�����̿���('||d.mgr_lic_emp||')'),dg.mgr_lic_no ||'<br>�����̿���('||dg.mgr_lic_emp||')'),dg.lic_no)),a.lic_no) AS lic_no \n"+
				" FROM   fine_doc_list a, car_reg b, fine c, cont d , car_pur p,  CLIENT e, "+
				"        ( "+
				"          SELECT '����' fee_st, RENT_MNG_ID, RENT_L_CD, rent_st, min(use_s_dt) as RENT_START_DT, max(use_e_dt) as RENT_END_DT "+
				"          FROM   scd_fee "+
				"          WHERE  tm_st2='3' and tm_st1='0' and bill_yn='Y' "+
				"          group by rent_mng_id, rent_l_cd, rent_st "+
				"        ) f, "+
				"        RENT_CONT g , cont dg  ,client ee    "+
			 	" WHERE a.doc_id=? and a.car_mng_id=b.car_mng_id "+
				"       and a.car_mng_id=c.car_mng_id(+) and a.seq_no=c.seq_no(+) and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) AND c.RENT_S_CD = g.rent_s_cd(+) "+
				"       and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd  AND a.rent_mng_id = p.rent_mng_id AND a.rent_l_cd = p.rent_l_cd  AND d.CLIENT_ID = e.CLIENT_ID "+
				"		AND g.sub_l_cd = dg.rent_l_cd(+)   AND dg.client_id = ee.client_id(+)  "+
				"       AND a.RENT_MNG_ID = f.rent_mng_id(+) AND a.RENT_L_CD = f.rent_l_cd(+) and a.rent_st=f.rent_st(+) \n";
				
		query += " ORDER BY nvl(c.reg_code,substr(b.car_no,length(b.car_no)-3,4)), p.dlv_est_dt, d.RENT_L_CD";
		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				FineDocListBean bean = new FineDocListBean();
				bean.setDoc_id 					(rs.getString("DOC_ID"));
				bean.setCar_mng_id				(rs.getString("CAR_MNG_ID"));
				bean.setSeq_no					(rs.getInt("SEQ_NO"));
				bean.setRent_mng_id			(rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd				(rs.getString("RENT_L_CD"));
				bean.setRent_s_cd				(rs.getString("RENT_S_CD2"));
				bean.setFirm_nm					(rs.getString("FIRM_NM"));
				bean.setSsn							(rs.getString("SSN"));
				bean.setEnp_no					(rs.getString("ENP_NO"));
				bean.setRent_start_dt			(rs.getString("RENT_START_DT"));	
				bean.setRent_end_dt			(rs.getString("RENT_END_DT"));	
				bean.setPaid_no					(rs.getString("PAID_NO"));
				bean.setReg_id						(rs.getString("REG_ID"));
				bean.setReg_dt						(rs.getString("REG_DT"));
				bean.setUpd_id						(rs.getString("UPD_ID"));
				bean.setUpd_dt						(rs.getString("UPD_DT"));
				bean.setCar_no					(rs.getString("CAR_NO2"));
				bean.setScan_file					(rs.getString("SCAN_FILE"));
				bean.setVio_dt						(rs.getString("VIO_DT"));
				bean.setCar_st						(rs.getString("CAR_ST"));
				bean.setFile_name				(rs.getString("FILE_NAME"));
				bean.setFile_type					(rs.getString("FILE_TYPE"));
				bean.setClient_id					(rs.getString("CLIENT_ID"));
				bean.setHo_zip						(rs.getString("HO_ZIP"));
				bean.setHo_addr					(rs.getString("HO_ADDR"));
				bean.setFee_st						(rs.getString("FEE_ST"));
				bean.setR_s_dt						(rs.getString("R_S_DT"));	
				bean.setR_e_dt						(rs.getString("R_E_DT"));	
				bean.setRent_st					(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				bean.setSub_rent_mng_id		(rs.getString("SUB_RENT_MNG_ID")==null?"":rs.getString("SUB_RENT_MNG_ID"));
				bean.setSub_rent_l_cd			(rs.getString("SUB_RENT_L_CD")==null?"":rs.getString("SUB_RENT_L_CD"));
				bean.setVar1						(rs.getString("RM_ST")==null?"":rs.getString("RM_ST"));
				bean.setLic_no						(rs.getString("LIC_NO")==null?"":rs.getString("LIC_NO"));
				bean.setClient_st					(rs.getString("CLIENT_ST"));
				bean.setVio_st						(rs.getString("VIO_ST")==null?"":rs.getString("VIO_ST"));
				bean.setNote					(rs.getString("NOTE")==null?"":rs.getString("NOTE"));
				
				vt.add(bean);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineDocLists]\n"+e);
			System.out.println("[FineDocDatabase:getFineDocLists]\n"+query);
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
	
	//�����û���� ����Ʈ��ȸ : ������
	public Vector getBankDocLists(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT decode(c.gov_st, '1' ,'�����ݱյ�', '���ݱյ�' ) car_st, c.filename scan_file, " +
				" decode(c.end_dt,null,'',substr(c.end_dt,1,4)||'-'||substr(c.end_dt,5,2)||'-'||substr(c.end_dt,7,2)) vio_dt, a.paid_no paid_no, count(a.seq_no) amt1, sum(a.amt3) amt2 , sum(a.amt4) + sum(a.amt5)  amt3,  " +
				" sum( round((a.amt4+a.amt5)/5+500, -3))  amt4  ,  sum(a.amt6) amt6 ," +
				" sum( nvl(g.car_fs_amt, 0) - nvl(g.dc_cs_amt, 0)  +   nvl(g.sd_cs_amt,0) )   as car_s_amt   " +
				"   FROM fine_doc_list a, fine_doc c,  car_etc g "+
				" WHERE a.doc_id =c.doc_id  and a.doc_id= ?  "+
				"  and a.rent_mng_id = g.rent_mng_id  and a.rent_l_cd = g.rent_l_cd " + 
				"group by c.gov_st , c.filename , c.end_dt , a.paid_no order by a.paid_no";
							


		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				FineDocListBean bean = new FineDocListBean();
							
				bean.setPaid_no			(rs.getString("PAID_NO"));
				bean.setAmt1			(rs.getInt("AMT1"));
				bean.setAmt2			(rs.getInt("AMT2"));
				bean.setAmt3			(rs.getInt("AMT3"));
				bean.setAmt4			(rs.getInt("AMT4"));
				bean.setAmt6			(rs.getInt("AMT6"));
				bean.setScan_file		(rs.getString("SCAN_FILE"));
				bean.setVio_dt			(rs.getString("VIO_DT"));
				bean.setCar_st			(rs.getString("CAR_ST"));
				bean.setAmt7			(rs.getInt("CAR_S_AMT"));   //�ΰ������� ���԰���
				vt.add(bean);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getBankDocLists]\n"+e);
			System.out.println("[FineDocDatabase:getBankDocLists]\n"+query);
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
	
	//�����û���� ����Ʈ��ȸ : ������
	public Vector getBankDocListsH(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT decode(c.gov_st, '1' ,'�����ݱյ�', '���ݱյ�' ) car_st, c.filename scan_file, " +
				" decode(c.end_dt,null,'',substr(c.end_dt,1,4)||'-'||substr(c.end_dt,5,2)||'-'||substr(c.end_dt,7,2)) vio_dt, a.paid_no paid_no, count(a.seq_no) amt1, sum(a.amt3) amt2 , sum(a.amt4) + sum(a.amt5)  amt3,  " +
				" sum( round((a.amt4+a.amt5)/5+500, -3))  amt4  ,  sum(a.amt6) amt6 ," +
				" sum( nvl(g.car_fs_amt, 0) - nvl(g.dc_cs_amt, 0)  +   nvl(g.sd_cs_amt,0) )   as car_s_amt   " +
				"   FROM fine_doc_list a, fine_doc c,  car_etc g "+
				" WHERE a.doc_id =c.doc_id  and a.doc_id= ?  "+
				"  and a.rent_mng_id = g.rent_mng_id  and a.rent_l_cd = g.rent_l_cd " + 
				"group by c.gov_st , c.filename , c.end_dt , a.paid_no order by a.paid_no";
							


		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
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
			System.out.println("[FineDocDatabase:getBankDocListsH]\n"+e);
			System.out.println("[FineDocDatabase:getBankDocListsH]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}
	
	
	//�����û���� ����Ʈ��ȸ : ������
	public Vector getBankDocListsG(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
				
         	
 		query = " SELECT decode(c.gov_st, '1' ,'�����ݱյ�', '���ݱյ�' ) car_st, c.filename scan_file,   \n" +
 				"		 decode(c.end_dt,null,'',substr(c.end_dt,1,4)||'-'||substr(c.end_dt,5,2)||'-'||substr(c.end_dt,7,2)) vio_dt,   \n" +
                " 		case when c.gov_id in ( '0080',  '0079', '0077' , '0087', '0063',  '0041' , '0046' , '0118' ) then  decode(sign(a.paid_no - 36),-1,36,0,36,48)   \n" +
                "       	 when c.gov_id in ( '0089' ) then to_number(a.paid_no)     \n" +
                "         	 when c.gov_id in ( '0086' , '0108' , '0057' ) then 48  \n" +
                "         	 when c.gov_id in ( '0011' ) then decode(c.fund_yn , 'Y', 60 , 48 )  \n" +
                "         	 when c.gov_id in ( '0018' , '0103', '0093' , '0102' ) then 60   else 36 end paid_no,     \n" +
                "		     count(a.seq_no) amt1, sum(a.amt3) amt2 , sum(a.amt4) + sum(a.amt5)  amt3,    \n" +
                " 	   	     sum( round((a.amt4+a.amt5)/5+500, -3))  amt4  ,  sum(a.amt6) amt6 ,   \n" +
                "		     sum( nvl(g.car_fs_amt, 0) - nvl(g.dc_cs_amt, 0)  +   nvl(g.sd_cs_amt,0) )   as car_s_amt  ,   \n" +
                "		     sum( nvl(g.car_fs_amt, 0) + nvl(g.car_fv_amt,0) )   as car_f_amt     \n" +
                "    FROM fine_doc_list a, fine_doc c, car_etc g   \n" +
                "	 WHERE a.doc_id =c.doc_id  and a.doc_id=  ?   \n" +
                "		  and a.rent_mng_id = g.rent_mng_id  and a.rent_l_cd = g.rent_l_cd 	  \n" +
                "	 group by c.gov_id, c.gov_st , c.filename , c.end_dt ,	  \n" +
                "		   case when c.gov_id in ( '0080', '0079',  '0077', '0087', '0063',  '0041' , '0046' , '0118' ) then  decode(sign(a.paid_no - 36),-1,36,0,36,48)  \n" +
                "               when c.gov_id in ( '0089' ) then  to_number(a.paid_no)     \n" +
                "	            when c.gov_id in ( '0086' , '0108' , '0057' ) then  48   \n" +
                "	            when c.gov_id in ( '0011' ) then decode(c.fund_yn , 'Y', 60 , 48 )   \n" +
                "               when c.gov_id in ( '0018', '0103', '0093' , '0102' ) then 60  else 36 end  \n" +
                "	 order by  \n" +
                "		   case when c.gov_id in ( '0080', '0079', '0077' , '0087', '0063',  '0041' , '0046', '0118' ) then  decode(sign(a.paid_no - 36),-1,36,0,36,48)  \n" +
                "               when c.gov_id in ( '0089' ) then to_number(a.paid_no)     \n" +
	            "	            when c.gov_id in ( '0086' , '0108' , '0057' ) then 48   \n" +
	            "	            when c.gov_id in ( '0011' ) then decode(c.fund_yn , 'Y', 60 , 48 )  \n" +
	            "               when c.gov_id in ( '0018', '0103', '0093' , '0102' ) then 60   else 36 end  \n" ;
		  		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
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
			System.out.println("[FineDocDatabase:getBankDocListsG]\n"+e);
			System.out.println("[FineDocDatabase:getBankDocListsG]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}
		

	//�����û���� ����Ʈ��ȸ : ������ :����ȣ�� -> �������� 
	public Vector getBankDocAllLists2(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT c.gov_id, a.doc_id, decode(ci.client_st, '2', substr(TEXT_DECRYPT(ci.ssn, 'pw' ) ,1,6), ci.enp_no) enp_no,  cc.rent_l_cd, cc.rent_dt, ci.O_ZIP, z.app_st, z.nm, z.addr, " +
				"	     decode(p.dlv_est_dt,null,'',substr(p.dlv_est_dt,1,4)||'-'||substr(p.dlv_est_dt,5,2)||'-'||substr(p.dlv_est_dt,7,2))  dlv_est_dt, " + 
				"	     a.firm_nm, c.filename lend_int, decode(c.end_dt,null,'',substr(c.end_dt,1,4)||'-'||substr(c.end_dt,5,2)||'-'||substr(c.end_dt,7,2)) end_dt, " +
				"        a.paid_no paid_no,  a.amt1 , a.amt2, a.amt3, a.amt4 , a.amt5,  a.amt6, nvl(d.car_nm, m.car_nm ) car_nm ,  n.car_name, nvl(d.car_no, '') car_no,  " +
				"        nvl(g.car_fs_amt, 0) + nvl(g.car_fv_amt, 0)  as car_f_amt , nvl(g.sd_cs_amt, 0) + nvl(g.sd_cv_amt, 0)  as sd_amt , " +	 //sd_amt:Ź��	
				"        nvl(f.grt_amt_s, 0) + nvl(f.pp_s_amt, 0) + nvl(f.pp_v_amt, 0) as pre_amt, d.car_doc_no, d.car_ext , d.car_num, d.acq_f_dt, d.acq_is_o," + 
				"        cc.rent_mng_id, cc.car_mng_id, c.doc_dt, g.opt,  "+
				"        y.pay_yn, y.t_alt_prn, y.t_alt_int, a.seq_no, " + 
				"        decode(y.car_mng_id, '', 'N', 'Y') scd_reg_yn, decode(y.pay_yn, 'N', '������', 'Y', '���οϷ�','') scd_pay_yn, "+
		//		"        case when substr(to_char((a.amt4+a.amt5)/5), length(to_char((a.amt4+a.amt5)/5)) ) = '0' then round((a.amt4+a.amt5)/5, -1) else  round((a.amt4+a.amt5)/5+5, -1) end dam_amt , ci.o_addr "+				
				"        round((a.amt4+a.amt5)/5+500, -3) dam_amt , ci.o_addr , p.rpt_no , g.colo, "+
		        "        decode(cc.dlv_dt,null,'',substr(cc.dlv_dt,1,4)||'-'||substr(cc.dlv_dt,5,2)||'-'||substr(cc.dlv_dt,7,2))  dlv_dt,  "+
				"        a.cardno, a.end_dt as card_end_dt , c.cltr_rat , nvl(g.ecar_pur_sub_amt, 0)  ecar_amt  "+
				"  FROM  fine_doc_list a, fine_doc c, car_etc g,  car_reg d , cont cc , client ci , car_pur p , fee f , car_nm n , car_mng m,  "+
				"        ( select z.code, z.c_st, nvl(z.app_st, '') app_st, k.nm, k.addr from code z, code_etc k where z.code=k.code(+) and z.c_st=k.c_st(+) ) z, "+
				"        ( select decode(sum(pay_yn), max(to_number(alt_tm)), 'Y', 'N') pay_yn, car_mng_id, sum(alt_prn) t_alt_prn, sum(alt_int) t_alt_int "+
				"          from scd_alt_case "+
				"          group by car_mng_id "+
				"        ) y "+
				"  WHERE a.doc_id= ? and a.doc_id =c.doc_id  and a.car_mng_id = d.car_mng_id(+) and a.rent_mng_id = g.rent_mng_id "+
				"  and a.rent_l_cd = g.rent_l_cd and a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd " +
				"  and a.rent_l_cd = p.rent_l_cd and a.rent_mng_id = p.rent_mng_id " +
				"  and g.car_id = n.car_id and g.car_seq = n.car_seq and n.car_comp_Id = m.car_comp_Id and n.car_cd = m.code  " +
				"  and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = f.rent_mng_id and f.rent_st = '1' " + 				
				"  and cc.client_id = ci.client_id "+
				"  and d.car_mng_id=y.car_mng_id(+) "+
				"  and c.gov_id=z.code and z.c_st='0003' "+			
				"  order by a.doc_id, a.paid_no, 4, 3 ";		
		

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			rs = pstmt.executeQuery();
	//	System.out.println(query);

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
			System.out.println("[FineDocDatabase:getBankDocAllLists2]\n"+e);
			System.out.println("[FineDocDatabase:getBankDocAllLists2]\n"+query);
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

	
		//�����û���� ����Ʈ��ȸ : ������ :����ȣ��
	public Vector getBankDocAllLists2_S(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		
		query = " SELECT c.gov_id, a.doc_id, ci.enp_no,  cc.rent_l_cd, cc.rent_dt, ci.O_ZIP, " +
				"	decode(p.dlv_est_dt,null,'',substr(p.dlv_est_dt,1,4)||'-'||substr(p.dlv_est_dt,5,2)||'-'||substr(p.dlv_est_dt,7,2))  dlv_est_dt, " + 
				"	decode(p.udt_est_dt,null,'',substr(p.udt_est_dt,1,4)||'-'||substr(p.udt_est_dt,5,2)||'-'||substr(p.udt_est_dt,7,2))  udt_est_dt, " + 
				"	decode(cc.dlv_dt,null,'',substr(cc.dlv_dt,1,4)||'-'||substr(cc.dlv_dt,5,2)||'-'||substr(cc.dlv_dt,7,2))  dlv_dt, " + 
				"	decode(d.init_reg_dt,null,'',substr(d.init_reg_dt,1,4)||'-'||substr(d.init_reg_dt,5,2)||'-'||substr(d.init_reg_dt,7,2))  init_reg_dt, " + 
				"	a.firm_nm ,  c.filename lend_int, decode(c.end_dt,null,'',substr(c.end_dt,1,4)||'-'||substr(c.end_dt,5,2)||'-'||substr(c.end_dt,7,2)) end_dt, " +
				"   a.paid_no paid_no,  a.amt1 , a.amt2, a.amt3, a.amt4 , a.amt5,  a.amt6, nvl(d.car_nm, m.car_nm ) car_nm , nvl(d.car_no, '') car_no,  " +
				"   nvl(g.car_fs_amt, 0) + nvl(g.car_fv_amt, 0)  as car_amt , " +		
				"   g.sd_cs_amt,    nvl(g.car_fs_amt, 0) - nvl(g.dc_cs_amt, 0)    as r_car_amt,   nvl(g.car_fs_amt, 0) - nvl(g.dc_cs_amt, 0)  +   nvl(g.sd_cs_amt,0)   as car_s_amt, \n"+	
				" round( a.amt6*0.002, -1)  r1_amt, round(a.amt6*0.004, -1) r2_amt,  \n"+	
				"  nvl(f.grt_amt_s, 0) + nvl(f.pp_s_amt, 0) + nvl(f.pp_v_amt, 0) as pre_amt, d.car_doc_no, d.car_ext , d.car_num, d.acq_f_dt, d.acq_is_o," + 
				"  cc.rent_mng_id, cc.car_mng_id, c.doc_dt, "+
				"  y.pay_yn, y.t_alt_prn, y.t_alt_int, a.seq_no, " + 
				"  decode(y.car_mng_id, '', 'N', 'Y') scd_reg_yn, decode(y.pay_yn, 'N', '������', 'Y', '���οϷ�','') scd_pay_yn, \n"+
		//		" case when substr(to_char((a.amt4+a.amt5)/5), length(to_char((a.amt4+a.amt5)/5)) ) = '0' then round((a.amt4+a.amt5)/5, -1) else  round((a.amt4+a.amt5)/5+5, -1) end dam_amt , ci.o_addr "+				
				"  round((a.amt4+a.amt5)/5+500, -3) dam_amt , ci.o_addr , p.rpt_no , g.colo , n.car_name car_name , m.car_comp_id , a.cardno "+		
				"  FROM fine_doc_list a, fine_doc c, car_etc g,  car_reg d , cont cc , client ci , car_pur p , fee f , car_nm n , car_mng m, \n"+
				"  ( select decode(sum(pay_yn), max(to_number(alt_tm)), 'Y', 'N') pay_yn, car_mng_id, \n"+
				"           sum(alt_prn) t_alt_prn, sum(alt_int) t_alt_int "+
				"    from scd_alt_case "+
				"    group by car_mng_id "+
				"  ) y "+
				" WHERE a.doc_id =c.doc_id  and a.car_mng_id = d.car_mng_id(+) and a.rent_mng_id = g.rent_mng_id "+
				"  and a.rent_l_cd = g.rent_l_cd and a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd " +
				"  and a.rent_l_cd = p.rent_l_cd and a.rent_mng_id = p.rent_mng_id " +
				"  and g.car_id = n.car_id and g.car_seq = n.car_seq and n.car_comp_Id = m.car_comp_Id and n.car_cd = m.code  " +
				"  and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = f.rent_mng_id and f.rent_st = '1' " + 				
				"  and cc.client_id = ci.client_id and a.doc_id= ? "+
				"  and d.car_mng_id=y.car_mng_id(+) "+
				"  order by a.doc_id, a.paid_no, 4, 3 ";
				 

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			rs = pstmt.executeQuery();
	//	System.out.println(query);

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
			System.out.println("[FineDocDatabase:getBankDocAllLists2_S]\n"+e);
			System.out.println("[FineDocDatabase:getBankDocAllLists2_S]\n"+query);
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

	//�����û���� ����Ʈ��ȸ : ������ :����ȣ�� - ī���Һΰ���  �������� ���� 
	public Vector getBankDocAllLists2_C(String doc_id, String gubun)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

	//	String query1 = " select F_getAfterDay(to_char(sysdate , 'yyyymmdd') , 1) from dual ";
		
		query = " SELECT c.gov_id, a.doc_id, ci.enp_no,  cc.rent_l_cd, " +
				"	decode(p.dlv_est_dt,null,'',substr(p.dlv_est_dt,1,4)||'-'||substr(p.dlv_est_dt,5,2)||'-'||substr(p.dlv_est_dt,7,2))  dlv_est_dt, \n"+
				"	decode(p.udt_est_dt,null,'',substr(p.udt_est_dt,1,4)||'-'||substr(p.udt_est_dt,5,2)||'-'||substr(p.udt_est_dt,7,2))  udt_est_dt, \n"+
				"	a.firm_nm ,  c.filename lend_int, decode(c.end_dt,null,'',substr(c.end_dt,1,4)||'-'||substr(c.end_dt,5,2)||'-'||substr(c.end_dt,7,2)) end_dt, \n"+
				"   a.paid_no paid_no,  a.amt1 , a.amt2, a.amt3, a.amt4 , a.amt5,  a.amt6, nvl(d.car_nm, m.car_nm ) car_nm , nvl(d.car_no, '') car_no,  \n"+
				"   nvl(g.car_fs_amt, 0) + nvl(g.car_fv_amt, 0)  as car_f_amt , \n"+
				"   nvl(g.dc_cs_amt, 0)  + nvl(g.dc_cv_amt, 0)   as car_dc_amt , \n"+				
				"  cc.rent_mng_id, cc.car_mng_id, c.doc_dt, a.seq_no, \n"+	
				"  n.car_name car_name , m.car_comp_id , a.cardno ,  c.app_dt , a.end_dt card_end_dt \n"+
				"  FROM fine_doc_list a, fine_doc c, car_etc g,  car_reg d , cont cc , client ci , car_pur p , car_nm n , car_mng m \n"+		
				" WHERE a.doc_id =c.doc_id  and a.car_mng_id = d.car_mng_id(+) and a.rent_mng_id = g.rent_mng_id \n"+
				"  and a.rent_l_cd = g.rent_l_cd and a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd \n"+
				"  and a.rent_l_cd = p.rent_l_cd and a.rent_mng_id = p.rent_mng_id \n"+
				"  and g.car_id = n.car_id and g.car_seq = n.car_seq and n.car_comp_Id = m.car_comp_Id and n.car_cd = m.code \n"+
				"  and c.card_yn = 'Y' and cc.client_id = ci.client_id ";
		
		if(gubun.equals("B"))		query += " and a.doc_id= '"+ doc_id + "'"; // ī�� ������ ���� ���ฮ��Ʈ ��¿�	
		if(gubun.equals("A"))		query += " and c.app_dt is not null and c.app_dt <> F_getValdDt(to_char(sysdate , 'yyyymmdd') , 1) and ( a.end_dt = to_char(sysdate , 'yyyymmdd') or p.udt_est_dt = F_getValdDt(to_char(sysdate , 'yyyymmdd') , 1)  )  "; // ī�� ����gn ����� �ǰ� �ٽ� ���ο�û�� �� 

		query += " order by a.doc_id, a.paid_no, a.rent_l_cd ";
				 

		try {
			pstmt = conn.prepareStatement(query);
			
			rs = pstmt.executeQuery();
	//	System.out.println(query);

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
			System.out.println("[FineDocDatabase:getBankDocAllLists2_C]\n"+e);
			System.out.println("[FineDocDatabase:getBankDocAllLists2_C]\n"+query);
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
	

	//�ְ��� �̼�ä�� ����Ʈ : ������
	public Vector getSettleDocLists(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.*"+
				" FROM fine_doc_list a"+
				" WHERE a.doc_id=?  order by seq_no ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				FineDocListBean bean = new FineDocListBean();
				bean.setDoc_id 			(rs.getString(1));
				bean.setCar_mng_id		(rs.getString(2));
				bean.setSeq_no			(rs.getInt(3));
				bean.setRent_mng_id		(rs.getString(4));
				bean.setRent_l_cd		(rs.getString(5));
				bean.setRent_s_cd		(rs.getString(6));
				bean.setFirm_nm			(rs.getString(7));
				bean.setSsn				(rs.getString(8));
				bean.setEnp_no			(rs.getString(9));
				bean.setRent_start_dt	(rs.getString(10));	
				bean.setRent_end_dt		(rs.getString(11));	
				bean.setPaid_no			(rs.getString(12));
				bean.setReg_id			(rs.getString(13));
				bean.setReg_dt			(rs.getString(14));
				bean.setUpd_id			(rs.getString(15));
				bean.setUpd_dt			(rs.getString(16));
				bean.setCar_no			(rs.getString(17));
				bean.setAmt1			(rs.getInt(18));
				bean.setAmt2			(rs.getInt(19));
				bean.setAmt3			(rs.getInt(20));
				bean.setAmt4			(rs.getInt(21));
				bean.setAmt5			(rs.getInt(22));
				bean.setAmt6			(rs.getInt(23));
				bean.setAmt7			(rs.getInt(24));
				
				bean.setVar1			(rs.getString(25));
				bean.setVar2			(rs.getString(26));
				bean.setVar3			(rs.getString(27));
			
				bean.setChk			(rs.getString(28));
				bean.setChecker_st		(rs.getString(29));
				bean.setServ_dt		(rs.getString(30));
				bean.setRep_cont		(rs.getString(31));
				bean.setServ_off_nm	(rs.getString(32));
				
				vt.add(bean);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getSettleDocLists]\n"+e);
			System.out.println("[FineDocDatabase:getSettleDocLists]\n"+query);
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
	
	
	//�ְ��� ��/������ ����Ʈ : ������
	public Vector getMyAccidDocLists(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.doc_id,  m.car_no, a.firm_nm, a.rent_start_dt, a.rent_end_dt, a.amt1, a.amt2, a.amt1-a.amt2 as amt3, m.ins_tel, m.ins_nm, m.ins_com, m.ins_num, decode(b.accid_st, '1','������','2','������','3','�ֹ�','4','��������','5','�������') as accid_st "+
				" FROM fine_doc_list a, my_accid m, ACCIDENT B "+
				" WHERE a.doc_id=? and a.car_mng_id  = m.car_mng_id(+) and m.ACCID_ID = b.ACCID_ID(+) and a.car_no = m.accid_id(+) and a.paid_no = m.seq_no(+)"+
				" order by B.accid_dt";

//System.out.println("getMyAccidDocLists "+query);

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				FineDocListBean bean = new FineDocListBean();
				bean.setDoc_id 			(rs.getString(1));
				bean.setCar_no			(rs.getString(2));
				bean.setFirm_nm			(rs.getString(3));
				bean.setRent_start_dt	(rs.getString(4));	
				bean.setRent_end_dt		(rs.getString(5));	
				bean.setAmt1			(rs.getInt(6));
				bean.setAmt2			(rs.getInt(7));
				bean.setAmt3			(rs.getInt(8));
				bean.setPaid_no			(rs.getString(9));		
				bean.setSsn				(rs.getString(10));			

	
				vt.add(bean);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getMyAccidDocLists]\n"+e);
			System.out.println("[FineDocDatabase:getMyAccidDocLists]\n"+query);
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
	

	//���·� ���ǽ�û���� ���·� ����Ʈ��ȸ : ������
	public Vector getFineDocLists_Car(String car_mng_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.*, b.car_no, d.scan_file, c.vio_dt, d.car_st FROM fine_doc_list a, car_reg b, fine c, cont d "+
				" WHERE a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id and a.seq_no=c.seq_no and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.rent_mng_id=d.rent_mng_id and c.rent_l_cd=d.rent_l_cd"+
				" and a.car_mng_id = ? order by a.doc_id";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				FineDocListBean bean = new FineDocListBean();
				bean.setDoc_id 			(rs.getString(1));
				bean.setCar_mng_id		(rs.getString(2));
				bean.setSeq_no			(rs.getInt(3));
				bean.setRent_mng_id		(rs.getString(4));
				bean.setRent_l_cd		(rs.getString(5));
				bean.setRent_s_cd		(rs.getString(6));
				bean.setFirm_nm			(rs.getString(7));
				bean.setSsn				(rs.getString(8));
				bean.setEnp_no			(rs.getString(9));
				bean.setRent_start_dt	(rs.getString(10));	
				bean.setRent_end_dt		(rs.getString(11));	
				bean.setPaid_no			(rs.getString(12));
				bean.setReg_id			(rs.getString(13));
				bean.setReg_dt			(rs.getString(14));
				bean.setUpd_id			(rs.getString(15));
				bean.setUpd_dt			(rs.getString(16));
				bean.setCar_no			(rs.getString(17));
				bean.setScan_file		(rs.getString(18));
				bean.setVio_dt			(rs.getString(19));
				bean.setCar_st			(rs.getString(20));
				vt.add(bean);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineDocLists_Car]\n"+e);
			System.out.println("[FineDocDatabase:getFineDocLists_Car]\n"+query);
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

	//���·� ���ǽ�û���� ���·� ����Ʈ��ȸ : ���·Ằ
	public Vector getFineDocLists_Fine(String car_mng_id, String seq_no)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.*, b.car_no, d.scan_file, c.vio_dt, d.car_st FROM fine_doc_list a, car_reg b, fine c, cont d "+
				" WHERE a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id and a.seq_no=c.seq_no and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.rent_mng_id=d.rent_mng_id and c.rent_l_cd=d.rent_l_cd"+
				" and a.car_mng_id = ? and a.seq_no = ? order by a.doc_id";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, seq_no);
			rs = pstmt.executeQuery();

			while(rs.next()){
				FineDocListBean bean = new FineDocListBean();
				bean.setDoc_id 			(rs.getString(1));
				bean.setCar_mng_id		(rs.getString(2));
				bean.setSeq_no			(rs.getInt(3));
				bean.setRent_mng_id		(rs.getString(4));
				bean.setRent_l_cd		(rs.getString(5));
				bean.setRent_s_cd		(rs.getString(6));
				bean.setFirm_nm			(rs.getString(7));
				bean.setSsn				(rs.getString(8));
				bean.setEnp_no			(rs.getString(9));
				bean.setRent_start_dt	(rs.getString(10));	
				bean.setRent_end_dt		(rs.getString(11));	
				bean.setPaid_no			(rs.getString(12));
				bean.setReg_id			(rs.getString(13));
				bean.setReg_dt			(rs.getString(14));
				bean.setUpd_id			(rs.getString(15));
				bean.setUpd_dt			(rs.getString(16));
				bean.setCar_no			(rs.getString(17));
				bean.setScan_file		(rs.getString(18));
				bean.setVio_dt			(rs.getString(19));
				bean.setCar_st			(rs.getString(20));
				vt.add(bean);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineDocLists_Fine]\n"+e);
			System.out.println("[FineDocDatabase:getFineDocLists_Fine]\n"+query);
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

	//����� �ߺ�üũ�ϱ�
	public int getFineGovNmChk(String gov_nm)
	{
		getConnection();

		FineGovBean bean = new FineGovBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int count = 0;

		query = " SELECT count(0) FROM fine_gov WHERE gov_nm=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, gov_nm);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				count = rs.getInt(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineGovNmChk]\n"+e);
			System.out.println("[FineDocDatabase:getFineGovNmChk]\n"+query);
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

	//���ǽ�û���� ���ο� ������ȣ ����
	public String getFineGovNoNext(String dept_nm)
	{
		getConnection();

		FineGovBean bean = new FineGovBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String next_id = "";

		query = " select '"+dept_nm+"'||to_char(sysdate,'YYYYMM')||'-'||nvl(ltrim(to_char(max(to_number(substr(doc_id,10,4))+1), '0000')), '0001') doc_id"+
				" from fine_doc "+
				" where substr(doc_id,1,9)='"+dept_nm+"'||to_char(sysdate,'YYYYMM')||'-'";

//System.out.println("getFineGovNoNext:: "+query);

		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				next_id = rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineGovNoNext]\n"+e);
			System.out.println("[FineDocDatabase:getFineGovNoNext]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return next_id;
		}				
	}

	//���ǽ�û���� ���ο� ������ȣ ����
	public String getSettleDocIdNext(String dept_nm)
	{
		getConnection();

		FineGovBean bean = new FineGovBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String next_id = "";

		query = " select '"+dept_nm+"'||to_char(sysdate,'YYYYMM')||'-'||nvl(ltrim(to_char(to_number(max(substr(doc_id,12,3))+1), '000')), '001') doc_id"+
				" from fine_doc "+
				" where substr(doc_id,1,11)='"+dept_nm+"'||to_char(sysdate,'YYYYMM')||'-'";

		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				next_id = rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getSettleDocIdNext]\n"+e);
			System.out.println("[FineDocDatabase:getSettleDocIdNext]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return next_id;
		}				
	}

	//���·� ��ȸ
	public Vector getFineSearchLists(String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "";
		query = " SELECT"+
				" a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, c.car_no, nvl(d.firm_nm,d.client_nm) firm_nm, TEXT_DECRYPT(d.ssn, 'pw' )  ssn, d.enp_no, e.rent_start_dt, e.rent_end_dt, a.vio_dt, a.vio_cont, a.paid_no, a.rec_dt, b.scan_file,"+
				" decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) doc_dt"+
				" from fine a, cont b, car_reg c, client d,"+
				" (select rent_mng_id, rent_l_cd, min(nvl(rent_start_dt,'-')) rent_start_dt, max(nvl(rent_end_dt,'-')) rent_end_dt from fee group by rent_mng_id, rent_l_cd) e,"+
				" (select b.car_mng_id, b.paid_no, b.rent_l_cd, max(a.doc_dt) doc_dt from fine_doc a, fine_doc_list b where a.doc_id=b.doc_id group by b.car_mng_id, b.paid_no, b.rent_l_cd) f, fine_gov g"+//, fine_gov g
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=c.car_mng_id"+
				" and b.client_id=d.client_id"+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				" and a.car_mng_id=f.car_mng_id(+) and a.paid_no=f.paid_no(+) AND a.RENT_L_CD=f.RENT_L_CD(+) "+
				" and a.pol_sta=g.gov_id(+)"+
				" and nvl(a.rec_dt,'99999999') > '20041231'"+//2005�����
				" and a.fault_st<>'2'  /*and a.note <> '��õ���·� �������Ϸ� �Ѳ����� ���'*/ ";//�������������

		if(!t_wd.equals(""))		query += " and a.pol_sta||g.gov_nm like '%"+t_wd+"%'";
		if(gubun1.equals("1"))		query += " and decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) is not null";
		if(gubun1.equals("2"))		query += " and decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) is null";

		if(gubun2.equals("1") && gubun3.equals("1"))		query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("1") && gubun3.equals("2"))		query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("1") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.notice_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.notice_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("2") && gubun3.equals("1"))		query += " and a.obj_end_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("2") && gubun3.equals("2"))		query += " and a.obj_end_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("2") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.obj_end_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.obj_end_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("3") && gubun3.equals("1"))		query += " and a.rec_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("3") && gubun3.equals("2"))		query += " and a.rec_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("3") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.rec_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.rec_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("4") && gubun3.equals("1"))		query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("4") && gubun3.equals("2"))		query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("4") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("5") && gubun3.equals("1"))		query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("5") && gubun3.equals("2"))		query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("5") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.paid_end_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.paid_end_dt like '%"+st_dt+"%'";	}
		}

//		if(gubun2.equals("2"))		dt = "a.obj_end_dt";
//		if(gubun2.equals("3"))		dt = "a.rec_dt";
//		if(gubun2.equals("4"))		dt = "nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1))";
//		if(gubun2.equals("5"))		dt = "a.paid_end_dt";

//		if(!st_dt.equals("") && !end_dt.equals(""))		
//									query += " and "+dt+" between '"+st_dt+"' and '"+end_dt+"'";
//		if(!st_dt.equals("") && end_dt.equals(""))		
//									query += " and "+dt+" like '%"+st_dt+"%'";

		query += " ORDER BY nvl(a.reg_code,substr(c.car_no,length(c.car_no)-3,4))";//a.rec_dt desc

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
//			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+query);
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+e);
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+query);
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

	//���·� ��ȸ
	public Vector getFineSearchLists(String t_wd, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "";

		query = " SELECT"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, decode(b.car_st,'4','1',nvl(a.rent_st,e.rent_st)) rent_st, "+
				"        c.car_no, nvl(d.firm_nm,d.client_nm) firm_nm, TEXT_DECRYPT(d.ssn, 'pw' )  ssn, d.enp_no, "+
				"        e.rent_start_dt, e.rent_end_dt, a.vio_dt, a.vio_cont, a.paid_no, a.rec_dt, b.scan_file,"+
				"        decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) doc_dt, decode(b.car_st,'4','(��)') rm_st "+
				" from   fine a, cont b, car_reg c, client d,"+
				"        (select rent_mng_id, rent_l_cd, min(nvl(rent_start_dt,'-')) rent_start_dt, max(nvl(rent_end_dt,'-')) rent_end_dt, max(to_number(rent_st)) rent_st "+
				"         from   fee "+
				"         group by rent_mng_id, rent_l_cd"+
				"        ) e,"+
				"        (select b.car_mng_id, b.paid_no, b.RENT_L_CD, max(a.doc_dt) doc_dt "+
				"         from   fine_doc a, fine_doc_list b "+
				"         where  a.doc_id=b.doc_id "+
				"         group by b.car_mng_id, b.paid_no, b.rent_l_cd"+
				"        ) f, fine_gov g"+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and a.car_mng_id=c.car_mng_id"+
				"        and b.client_id=d.client_id"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				"        and a.car_mng_id=f.car_mng_id(+) and a.paid_no=f.paid_no(+)  AND a.RENT_L_CD=f.RENT_L_CD(+) "+
				"        and a.pol_sta=g.gov_id(+)"+
				"        and nvl(a.rec_dt,'99999999') > '20041231'"+//2005�����
				"        and a.fault_st<>'2' and a.paid_st='1' ";//�������������, �����ں��游 ����

		if(!gubun5.equals("")){
			if(gubun4.equals("car_no"))			query += " and c.car_no like '%"+gubun5+"%'";
			if(gubun4.equals("firm_nm"))		query += " and nvl(d.firm_nm,d.client_nm) like '%"+gubun5+"%'";
		}

		if(!t_wd.equals(""))		query += " and a.pol_sta||g.gov_nm like '%"+t_wd+"%'";
		if(gubun1.equals("1"))		query += " and decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) is not null";
		if(gubun1.equals("2"))		query += " and decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) is null";

		if(gubun2.equals("1") && gubun3.equals("1"))		query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("1") && gubun3.equals("2"))		query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("1") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.notice_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.notice_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("2") && gubun3.equals("1"))		query += " and a.obj_end_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("2") && gubun3.equals("2"))		query += " and a.obj_end_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("2") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.obj_end_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.obj_end_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("3") && gubun3.equals("1"))		query += " and a.rec_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("3") && gubun3.equals("2"))		query += " and a.rec_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("3") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.rec_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.rec_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("4") && gubun3.equals("1"))		query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("4") && gubun3.equals("2"))		query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("4") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("5") && gubun3.equals("1"))		query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("5") && gubun3.equals("2"))		query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("5") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.paid_end_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.paid_end_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("6") && gubun3.equals("1"))		query += " and (a.reg_dt = to_char(SYSDATE, 'YYYYMMDD')   or a.re_reg_dt = to_char(SYSDATE, 'YYYYMMDD')  )";
		if(gubun2.equals("6") && gubun3.equals("2"))		query += " and (a.reg_dt = to_char(SYSDATE-1, 'YYYYMMDD') or a.re_reg_dt = to_char(SYSDATE-1, 'YYYYMMDD')) ";
		if(gubun2.equals("6") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and (a.reg_dt between '"+st_dt+"' and '"+end_dt+"' or a.re_reg_dt between '"+st_dt+"' and '"+end_dt+"') ";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and (a.reg_dt like '%"+st_dt+"%' or a.re_reg_dt like '%"+st_dt+"%')";	}
		}


		query += " ORDER BY nvl(a.reg_code,substr(c.car_no,length(c.car_no)-3,4))";

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
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+e);
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+query);
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

	//���·� ��ȸ
	public Vector getFineSearchLists000155(String id, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "";
		query = " SELECT"+
				" a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, c.car_no, nvl(d.firm_nm,d.client_nm) firm_nm, TEXT_DECRYPT(d.ssn, 'pw' ) ssn, d.enp_no, e.rent_start_dt, e.rent_end_dt, a.vio_dt, a.vio_cont, a.paid_no, a.rec_dt, b.scan_file,"+
				" decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) doc_dt"+
				" from fine a, cont b, car_reg c, client d,"+
				" (select rent_mng_id, rent_l_cd, min(nvl(rent_start_dt,'-')) rent_start_dt, max(nvl(rent_end_dt,'-')) rent_end_dt from fee group by rent_mng_id, rent_l_cd) e,"+
				" (select b.car_mng_id, b.paid_no, max(a.doc_dt) doc_dt from fine_doc a, fine_doc_list b where a.doc_id=b.doc_id group by b.car_mng_id, b.paid_no) f, fine_gov g"+//, fine_gov g
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=c.car_mng_id"+
				" and b.client_id=d.client_id"+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				" and a.car_mng_id=f.car_mng_id(+) and a.paid_no=f.paid_no(+)"+
				" and a.pol_sta=g.gov_id(+)"+
				" and nvl(a.rec_dt,'99999999') > '20041231'"+//2005�����
				" and a.fault_st<>'2'  ";//������������� , and a.note <> '��õ���·� �������Ϸ� �Ѳ����� ���'

		if(id.equals("000155")) query += " and a.reg_id in('000155','000096') ";

		if(!t_wd.equals(""))		query += " and a.pol_sta||g.gov_nm like '%"+t_wd+"%'";
		if(gubun1.equals("1"))		query += " and decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) is not null";
		if(gubun1.equals("2"))		query += " and decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) is null";

		if(gubun2.equals("1") && gubun3.equals("1"))		query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("1") && gubun3.equals("2"))		query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("1") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.notice_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.notice_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("2") && gubun3.equals("1"))		query += " and a.obj_end_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("2") && gubun3.equals("2"))		query += " and a.obj_end_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("2") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.obj_end_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.obj_end_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("3") && gubun3.equals("1"))		query += " and a.rec_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("3") && gubun3.equals("2"))		query += " and a.rec_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("3") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.rec_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.rec_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("4") && gubun3.equals("1"))		query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("4") && gubun3.equals("2"))		query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("4") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("5") && gubun3.equals("1"))		query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("5") && gubun3.equals("2"))		query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("5") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.paid_end_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.paid_end_dt like '%"+st_dt+"%'";	}
		}

//		if(gubun2.equals("2"))		dt = "a.obj_end_dt";
//		if(gubun2.equals("3"))		dt = "a.rec_dt";
//		if(gubun2.equals("4"))		dt = "nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1))";
//		if(gubun2.equals("5"))		dt = "a.paid_end_dt";

//		if(!st_dt.equals("") && !end_dt.equals(""))		
//									query += " and "+dt+" between '"+st_dt+"' and '"+end_dt+"'";
//		if(!st_dt.equals("") && end_dt.equals(""))		
//									query += " and "+dt+" like '%"+st_dt+"%'";

		query += " ORDER BY nvl(a.reg_code,substr(c.car_no,length(c.car_no)-3,4))";//a.rec_dt desc
//	System.out.println("[FineDocDatabase:getFineSearchLists]\n"+query);
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
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+e);
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+query);
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

	//���·� ��ȸ 
	public Vector getFineSearchLists000155(String id, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "";
		query = " SELECT"+
				" a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, c.car_no, nvl(d.firm_nm,d.client_nm) firm_nm, TEXT_DECRYPT(d.ssn, 'pw' )  ssn, d.enp_no, e.rent_start_dt, e.rent_end_dt, a.vio_dt, a.vio_cont, a.paid_no, a.rec_dt, b.scan_file,"+
				" decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) doc_dt"+
				" from fine a, cont b, car_reg c, client d,"+
				" (select rent_mng_id, rent_l_cd, min(nvl(rent_start_dt,'-')) rent_start_dt, max(nvl(rent_end_dt,'-')) rent_end_dt from fee group by rent_mng_id, rent_l_cd) e,"+
				" (select b.car_mng_id, b.paid_no, max(a.doc_dt) doc_dt from fine_doc a, fine_doc_list b where a.doc_id=b.doc_id group by b.car_mng_id, b.paid_no) f, fine_gov g"+//, fine_gov g
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=c.car_mng_id"+
				" and b.client_id=d.client_id"+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				" and a.car_mng_id=f.car_mng_id(+) and a.paid_no=f.paid_no(+)"+
				" and a.pol_sta=g.gov_id(+)"+
				" and nvl(a.rec_dt,'99999999') > '20041231'"+//2005�����
				" and a.fault_st<>'2'  ";//������������� , and a.note <> '��õ���·� �������Ϸ� �Ѳ����� ���'

		if(!gubun5.equals("")){
			if(gubun4.equals("car_no"))			query += " and c.car_no like '%"+gubun5+"%'";
			if(gubun4.equals("firm_nm"))		query += " and nvl(d.firm_nm,d.client_nm) like '%"+gubun5+"%'";
		}

		if(id.equals("000155")) query += " and a.reg_id in('000155','000096') ";

		if(!t_wd.equals(""))		query += " and a.pol_sta||g.gov_nm like '%"+t_wd+"%'";
		if(gubun1.equals("1"))		query += " and decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) is not null";
		if(gubun1.equals("2"))		query += " and decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) is null";

		if(gubun2.equals("1") && gubun3.equals("1"))		query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("1") && gubun3.equals("2"))		query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("1") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.notice_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.notice_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("2") && gubun3.equals("1"))		query += " and a.obj_end_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("2") && gubun3.equals("2"))		query += " and a.obj_end_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("2") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.obj_end_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.obj_end_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("3") && gubun3.equals("1"))		query += " and a.rec_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("3") && gubun3.equals("2"))		query += " and a.rec_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("3") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.rec_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.rec_dt like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("4") && gubun3.equals("1"))		query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("4") && gubun3.equals("2"))		query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("4") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)) like '%"+st_dt+"%'";	}
		}
		if(gubun2.equals("5") && gubun3.equals("1"))		query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD')";
		if(gubun2.equals("5") && gubun3.equals("2"))		query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD')-1 ";
		if(gubun2.equals("5") && gubun3.equals("3"))		{
			if(!st_dt.equals("") && !end_dt.equals(""))	{   query += " and a.paid_end_dt between '"+st_dt+"' and '"+end_dt+"'";	}
			if(!st_dt.equals("") && end_dt.equals(""))	{   query += " and a.paid_end_dt like '%"+st_dt+"%'";	}
		}

//		if(gubun2.equals("2"))		dt = "a.obj_end_dt";
//		if(gubun2.equals("3"))		dt = "a.rec_dt";
//		if(gubun2.equals("4"))		dt = "nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1))";
//		if(gubun2.equals("5"))		dt = "a.paid_end_dt";

//		if(!st_dt.equals("") && !end_dt.equals(""))		
//									query += " and "+dt+" between '"+st_dt+"' and '"+end_dt+"'";
//		if(!st_dt.equals("") && end_dt.equals(""))		
//									query += " and "+dt+" like '%"+st_dt+"%'";

		query += " ORDER BY nvl(a.reg_code,substr(c.car_no,length(c.car_no)-3,4))";//a.rec_dt desc
//	System.out.println("[FineDocDatabase:getFineSearchLists]\n"+query);
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
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+e);
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+query);
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

	//���·� ��ȸ
	public Vector getFineSearchLists(String t_wd)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "";
		query = " SELECT"+
				" a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, c.car_no, nvl(d.firm_nm,d.client_nm) firm_nm, TEXT_DECRYPT(d.ssn, 'pw' )  ssn, d.enp_no, e.rent_start_dt, e.rent_end_dt, a.vio_dt, a.vio_cont, a.paid_no, a.rec_dt, b.scan_file,"+
				" decode(f.doc_dt,'', nvl(a.obj_dt3,nvl(a.obj_dt2,a.obj_dt1)), f.doc_dt) doc_dt"+
				" from fine a, cont b, car_reg c, client d,"+
				" (select rent_mng_id, rent_l_cd, min(nvl(rent_start_dt,'-')) rent_start_dt, max(nvl(rent_end_dt,'-')) rent_end_dt from fee group by rent_mng_id, rent_l_cd) e,"+
				" (select b.car_mng_id, max(a.doc_dt) doc_dt from fine_doc a, fine_doc_list b where a.doc_id=b.doc_id group by b.car_mng_id) f"+//, fine_gov g
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=c.car_mng_id"+
				" and b.client_id=d.client_id"+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				" and a.car_mng_id=f.car_mng_id(+)";

		if(!t_wd.equals(""))		query += " and c.car_no like '%"+t_wd+"%'";

		query += " ORDER BY a.vio_dt ";//a.rec_dt desc

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
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+e);
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+query);
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

	//���·� ���ǽ�û����������� ��ȸ
	public Vector getFineDocLists(String id_st, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt_query = "";
		String dt = "a.doc_dt";//��������

		//���� ������ ��� �������ڵ� �˻������ϵ���
		if (id_st.equals("�ѹ�")){ 
			if ( brch_id.equals("L")) { //���� ����
			    if ( gubun4.equals("2") ) {
			    	dt = "a.end_dt";
			    }	
			}
		}		
		
		//���� ������ ��� �������ڵ� �˻������ϵ���
		if (id_st.equals("����")){ 
			if ( brch_id.equals("R")) { //���� ����
			    if ( gubun4.equals("2") ) {
			    	dt = "a.print_dt";
			    }	
			}
		}		
		
		//������ȸ
		if(gubun2.equals("1"))		dt_query = " and "+dt+"=to_char(sysdate-2,'YYYYMMDD')";
		if(gubun2.equals("2"))		dt_query = " and "+dt+"=to_char(sysdate-1,'YYYYMMDD')";
		if(gubun2.equals("3"))		dt_query = " and "+dt+"=to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("4"))		dt_query = " and substr("+dt+",1,6)=to_char(sysdate,'YYYYMM')";
		if(gubun2.equals("5"))		dt_query = " and "+dt+" between replace(nvl('"+st_dt+"','00000000'), '-', '') and replace(nvl('"+end_dt+"','99999999'), '-', '')";
		if(gubun2.equals("6"))		dt_query = " and substr("+dt+",1,4)=to_char(sysdate,'YYYY')";
		if(gubun2.equals("7"))		dt_query = " and substr("+dt+",1,6) = to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";
	
		if(id_st.equals("�ѹ�")){ 
			if ( brch_id.equals("L")) { //���� ����
				
				query = " SELECT"+
						"  a.regyn, a.doc_id, a.doc_dt,a.cltr_chk, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id, a.req_dt, a.ip_dt,"+
						" b.nm as gov_nm, c.cnt, c.amt, a.app_doc5, a.end_dt, a.req_dt, a.scd_yn , a.cms_code , a.fund_yn "+
						" from fine_doc a, (select * from code where c_st = '0003') b, (select doc_id, count(*) cnt, SUM((amt4 + amt5)/2) amt from fine_doc_list group by doc_id) c"+
						" where"+
						" a.gov_id=b.code and a.doc_id=c.doc_id and a.doc_id like '%�ѹ�%'"+dt_query;
	
					if(!gubun1.equals(""))		query += " and b.code ='"+gubun1+"'";
	
				//�˻�� ������...
				if(!t_wd.equals("")){
					query = " select"+ 
							" DISTINCT  b.nm as gov_nm, a.*, c.cnt  "+ 
							" from fine_doc a, fine_doc_list d, (select * from code where c_st = '0003') b,  (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c , car_reg i "+ 
							" where "+ 
							" a.gov_id=b.code"+ 
							" and a.doc_id=c.doc_id(+)"+ 
							" and a.doc_id=d.doc_id(+) and a.doc_id like '%�ѹ�%' "+
							" and d.car_mng_id=i.car_mng_id"+dt_query; 
							 		
					if(s_kd.equals("2"))	query += " and i.car_no like '%"+t_wd+"%'";				
					if(s_kd.equals("3"))	query += " and b.code ='"+t_wd+"'";
				
	
				}

		   } else { //��������
		   		query = " SELECT"+
						" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
						" b.ins_com_nm as gov_nm, c.cnt"+
						" from fine_doc a, ins_com b, (select doc_id, count(*) cnt from ins_doc_list group by doc_id) c"+
						" where"+
						" a.gov_id=b.ins_com_id and a.doc_id=c.doc_id and a.doc_id like '%�ѹ�%'"+dt_query;
	
					if(!gubun1.equals(""))		query += " and b.ins_com_id='"+gubun1+"'";
	
				//�˻�� ������...
				if(!t_wd.equals("")){
					query = " select"+ 
							" DISTINCT  a.*, b.ins_com_nm as gov_nm, j.cnt"+ 
							" from fine_doc a, ins_com b, ins_doc_list c, insur d, ins_cls e, car_reg i,"+ 
							" (select doc_id, count(*) cnt from ins_doc_list group by doc_id) j"+ 
							" where "+ 
							" a.gov_id=b.ins_com_id"+ 
							" and a.doc_id=c.doc_id"+ 
							" and c.car_mng_id=d.car_mng_id and c.ins_st=d.ins_st"+ 
							" and c.car_mng_id=e.car_mng_id and c.ins_st=e.ins_st"+ 
							" and c.car_mng_id=i.car_mng_id"+ 
							" and a.doc_id=j.doc_id";
	
					if(s_kd.equals("2"))	query += " and c.car_no_b||c.car_no_a||i.car_no like '%"+t_wd+"%'";
					if(s_kd.equals("5"))	query += " and e.req_dt like '%"+t_wd+"%'";
					if(s_kd.equals("6"))	query += " and e.exp_dt like '%"+t_wd+"%'";
	
				}
		   	
		   }	
		
		}else if(id_st.equals("����")){//�ڵ������ſ�û����

			query = " SELECT"+
					" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
					" decode(a.gov_nm,'',e.nm||' '||d.car_off_nm||'��',a.gov_nm) as r_gov_nm, c.cnt, a.remarks "+
					" from fine_doc a, car_off_emp b, (select doc_id, count(*) cnt from car_pur_doc_list group by doc_id) c, car_off d, (select * from code where c_st='0001') e"+
					" where"+
					" a.gov_id=b.emp_id(+) "+
					" and b.car_off_id=d.car_off_id(+)"+
					" and a.doc_id=c.doc_id "+
					" and d.car_comp_id=e.code(+) "+
					" and a.doc_id like '%����%'"+dt_query;

			if(!gubun1.equals(""))		query += " and decode(a.gov_nm,'',e.nm||' '||d.car_off_nm||'��',a.gov_nm)||b.emp_nm like '%"+gubun1+"%'";

			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select"+ 
						" DISTINCT  a.*, decode(a.gov_nm,'',h.nm||' '||d.car_off_nm||'��',a.gov_nm) as r_gov_nm, j.cnt"+ 
						" from   fine_doc a, car_off_emp b, car_pur_doc_list c, car_off d, cont e, car_reg i, client f, "+ 
						"        (select doc_id, count(*) cnt from car_pur_doc_list group by doc_id) j, code h"+ 
						" where "+ 
						" a.gov_id=b.emp_id"+ 
						" and a.doc_id=c.doc_id"+ 
						" and b.car_off_id=d.car_off_id"+ 
						" and c.rent_mng_id=e.rent_mng_id and c.rent_l_cd=e.rent_l_cd"+ 
						" and e.car_mng_id=i.car_mng_id"+ 
						" and a.doc_id=j.doc_id and d.car_comp_id=h.code and h.c_st='0001'"+
						" and e.client_id=f.client_id "+
						" ";

				if(s_kd.equals("1"))	query += " and c.rent_l_cd like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and i.first_car_no||' '||i.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and f.firm_nm like '%"+t_wd+"%'";


			}

		}else if(id_st.equals("Ư��")){//�ڵ������ſ�û����  doc_id = 'Ư��' ���� ������ ��ϵ����� ��ȸ�ÿ��� Ư���� �ѹ��� �ٲ㼭 ������.

			query = " SELECT"+
					" '�ѹ�'||substr(a.DOC_ID, 3) AS doc_id, a.doc_id AS sdoc_id, SUBSTR(a.DOC_ID, 12) AS num, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
					" decode(a.gov_nm,'',e.nm||' '||d.car_off_nm||'��',a.gov_nm) as r_gov_nm, a.remarks, c.AMT1, c.firm_nm "+
					" from fine_doc a, car_off_emp b, ( SELECT doc_id,MAX(firm_nm) firm_nm,  SUM(amt1) amt1 FROM FINE_DOC_LIST GROUP BY doc_id) c,  car_off d, (select * from code where c_st='0001') e"+
					" where"+
					" a.DOC_ID = c.DOC_ID  AND  a.gov_id=b.emp_id(+)"+
					" and b.car_off_id=d.car_off_id(+)"+
					" and d.car_comp_id=e.code(+) "+
					" and a.doc_id like '%Ư��%'"+dt_query;

			if(!t_wd.equals("")){
				if(s_kd.equals("1"))	query += " and a.mng_nm||a.mng_pos like '%"+t_wd+"%'";  /*����ó*/
//				if(s_kd.equals("2"))	query += " and c.rent_l_cd like '%"+t_wd+"%'";			/*����ȣ*/
//				if(s_kd.equals("3"))	query += " and c.var1 like '%"+t_wd+"%'";				/*������*/
//				if(s_kd.equals("4"))	query += " and c.firm_nm like '%"+t_wd+"%'";			/*ī����*/
			}else{
				query += " and a.mng_nm||a.mng_pos like '%�����ڵ���%'";  /*�˻�� ������ �����ڵ����� �⺻ �˻���� ������*/
			}

		}else if(id_st.equals("ä���߽�")){//�ְ���

			query = " SELECT '1' id_st,"+
					" a.*, c.cnt, decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm, d.file_name, d.file_type, d.seq  file_seq "+
					" from fine_doc a, client b, (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c , (SELECT * FROM ACAR_ATTACH_FILE where NVL(isdeleted,'N') <> 'Y') d  "+
					" where"+
					" a.gov_id=b.client_id and a.doc_id=c.doc_id(+)  and a.doc_id like '%ä���߽�%' AND a.doc_id = d.content_seq(+) "+dt_query;


			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select  "+ 
						" DISTINCT '1' id_st,  a.*, j.cnt,  decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm , d.file_name, d.file_type, d.seq  file_seq  "+ 
						" from fine_doc a, client b, fine_doc_list c, "+ 
						" (select doc_id, count(*) cnt from fine_doc_list group by doc_id) j , (SELECT * FROM ACAR_ATTACH_FILE where NVL(isdeleted,'N') <> 'Y') d "+ 
						" where "+ 
						" a.gov_id=b.client_id"+ 
						" and a.doc_id=c.doc_id(+) AND a.doc_id = d.content_seq(+) "+ 
						" and a.doc_id=j.doc_id(+)";

				if(s_kd.equals("1"))	query += " and b.firm_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and c.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and c.rent_l_cd like '%"+t_wd+"%'";

			}
		
		}else if(id_st.equals("����")){//�ְ���

			query = " SELECT '2' id_st, "+
					" a.*, c.cnt, decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+
					" from fine_doc a, ins_com b, (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					" a.gov_id=b.ins_com_id and a.doc_id=c.doc_id(+)  and a.doc_id like '%����%'"+dt_query;


			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select "+ 
						" DISTINCT  '2' id_st,  a.*, j.cnt,  decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+ 
						" from fine_doc a, client b, fine_doc_list c, "+ 
						" (select doc_id, count(*) cnt from fine_doc_list group by doc_id) j"+ 
						" where "+ 
						" a.gov_id=b.client_id"+ 
						" and a.doc_id=c.doc_id(+)"+ 
						" and a.doc_id=j.doc_id(+)";

				if(s_kd.equals("1"))	query += " and a.gov_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and c.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and c.rent_l_cd like '%"+t_wd+"%'";
			}
		
		}else if(id_st.equals("���")){//��Ұ��

			query = " SELECT '3' id_st, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
					" a.*, c.cnt, decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+
					" from fine_doc a, cont_n_view b , (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					"  a.doc_id=c.doc_id(+) 	AND a.MNG_POS = b.rent_l_cd(+)  and a.doc_id like '%��Ұ��%'"+dt_query;


			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select "+ 
						" DISTINCT  '3' id_st,  d.rent_mng_id, d.rent_l_cd, d.car_mng_id, a.*, j.cnt,  decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+ 
						" from fine_doc a, client b, fine_doc_list c, cont_n_view d "+ 
						" (select doc_id, count(*) cnt from fine_doc_list group by doc_id) j"+ 
						" where "+ 
						" a.gov_id=b.client_id 	AND a.MNG_POS = d.rent_l_cd(+) "+ 
						" and a.doc_id=c.doc_id(+)"+ 
						" and a.doc_id=j.doc_id(+)";

				if(s_kd.equals("1"))	query += " and a.gov_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and c.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and c.rent_l_cd like '%"+t_wd+"%'";
			}

		}else if(id_st.equals("�Ҽ�")){//�Ҽ�

			query = " SELECT '4' id_st, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
					" a.*, c.cnt, decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+
					" from fine_doc a, cont_n_view b , (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					"  a.doc_id=c.doc_id(+) 	AND a.MNG_POS = b.rent_l_cd(+)  and a.doc_id like '�Ҽ�%'"+dt_query;


			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select "+ 
						" DISTINCT  '4' id_st,  d.rent_mng_id, d.rent_l_cd, d.car_mng_id, a.*, j.cnt,  decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+ 
						" from fine_doc a, client b, fine_doc_list c, cont_n_view d "+ 
						" (select doc_id, count(*) cnt from fine_doc_list group by doc_id) j"+ 
						" where "+ 
						" a.gov_id=b.client_id 	AND a.MNG_POS = d.rent_l_cd(+) "+ 
						" and a.doc_id=c.doc_id(+)"+ 
						" and a.doc_id=j.doc_id(+)";

				if(s_kd.equals("1"))	query += " and a.gov_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and c.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and c.rent_l_cd like '%"+t_wd+"%'";
			}


		}else if(id_st.equals("����")){//���ع��� û��(�޴�����)

			query = " SELECT "+
					" a.*, b.ins_com_nm, c.cnt, decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+
					" from fine_doc a, ins_com b, (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					" a.doc_id like '%����%' and a.gov_id=b.ins_com_id and a.doc_id=c.doc_id(+) "+dt_query;

			if(!gubun1.equals(""))		query += " and a.gov_id='"+gubun1+"'";

			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select "+ 
						" DISTINCT  a.*, b.ins_com_nm, j.cnt,  decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+ 
						" from fine_doc a, ins_com b, fine_doc_list c, "+ 
						" (select doc_id, count(*) cnt from fine_doc_list group by doc_id) j"+ 
						" where "+ 
						" a.doc_id like '%����%' and a.gov_id=b.ins_com_id"+ 
						" and a.doc_id=c.doc_id(+)"+ 
						" and a.doc_id=j.doc_id(+)";

				if(s_kd.equals("1"))	query += " and c.firm_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and c.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and c.rent_l_cd like '%"+t_wd+"%'";
			}

		}else if(id_st.equals("ȯ��")){//ȯ�� ���ǽ�û����

			query = " SELECT"+
					" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
					" b.gov_nm, c.cnt"+
					" from fine_doc a, fine_gov b, (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					" a.gov_id=b.gov_id and a.doc_id=c.doc_id and a.doc_id like '%ȯ��%'"+dt_query;

				if(!gubun1.equals(""))		query += " and b.gov_id='"+gubun1+"'";

			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select"+ 
						" DISTINCT "+
						" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
						" b.gov_nm, j.cnt"+ 
						" from fine_doc a, fine_gov b, fine_doc_list c, fine d, cont e, client f, rent_cont g, rent_cust h, car_reg i,"+ 
						" (select doc_id, count(*) cnt from fine_doc_list group by doc_id) j, users l"+ 
						" where "+ 
						" a.gov_id=b.gov_id"+ 
						" and a.doc_id=c.doc_id and a.doc_id like '%����%'"+dt_query + 
						" and c.car_mng_id=d.car_mng_id and c.seq_no=d.seq_no and c.rent_mng_id=d.rent_mng_id and c.rent_l_cd=d.rent_l_cd"+ 
						" and c.rent_mng_id=e.rent_mng_id and c.rent_l_cd=e.rent_l_cd"+ 
						" and e.client_id=f.client_id"+ 
						" and c.rent_s_cd=g.rent_s_cd(+)"+ 
						" and g.cust_id=h.cust_id(+)"+ 
						" and c.car_mng_id=i.car_mng_id"+ 
						" and a.doc_id=j.doc_id"+
						" and a.reg_id=l.user_id"+
						" ";

				if(s_kd.equals("1"))	query += " and nvl(f.firm_nm,f.client_nm)||h.cust_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and i.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and d.paid_no like '%"+t_wd+"%'";
				if(s_kd.equals("4"))	query += " and d.vio_dt like '%"+t_wd+"%'";
				if(s_kd.equals("5"))	query += " and l.user_nm like '%"+t_wd+"%'";

			}
		
		}else if(id_st.equals("����")){//�ڵ������� 

			query = " SELECT"+
					" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.ip_dt, a.end_dt, a.title,"+
					" b.nm as gov_nm, c.cnt"+
					" from fine_doc a, (SELECT * FROM CODE where C_ST='0001' and CODE <> '0000' and app_st='1' ) b, (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					" a.gov_id=b.code and a.doc_id=c.doc_id and a.doc_id like '%����%'"+dt_query;

			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select"+ 
						" DISTINCT "+
						" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
						" b.gov_nm, j.cnt"+ 
						" from fine_doc a, fine_gov b, fine_doc_list c, fine d, cont e, client f, rent_cont g, rent_cust h, car_reg i,"+ 
						" (select doc_id, count(*) cnt from fine_doc_list group by doc_id) j, users l"+ 
						" where "+ 
						" a.gov_id=b.gov_id"+ 
						" and a.doc_id=c.doc_id and a.doc_id like '%����%'"+dt_query + 
						" and c.car_mng_id=d.car_mng_id and c.seq_no=d.seq_no and c.rent_mng_id=d.rent_mng_id and c.rent_l_cd=d.rent_l_cd"+ 
						" and c.rent_mng_id=e.rent_mng_id and c.rent_l_cd=e.rent_l_cd"+ 
						" and e.client_id=f.client_id"+ 
						" and c.rent_s_cd=g.rent_s_cd(+)"+ 
						" and g.cust_id=h.cust_id(+)"+ 
						" and c.car_mng_id=i.car_mng_id"+ 
						" and a.doc_id=j.doc_id"+
						" and a.reg_id=l.user_id"+
						" ";

				if(s_kd.equals("1"))	query += " and nvl(f.firm_nm,f.client_nm)||h.cust_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and i.car_no like '%"+t_wd+"%'";
				
				if(s_kd.equals("3"))	query += " and a.gov_id like '%"+t_wd+"%'";
				
			}	
				
		}else{//���·� ���ǽ�û����
			
			id_st = "���·�";			//���������߰����� ����(20180801) (id_st = '����' �� �Ѿ��. ���·���� �̿ܿ� �߰� �б�� ���� ó���ؾ���.)
			query = " SELECT"+
					" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
					" DECODE(a.compl_etc,'1','����24','2','�μ�','3','FAX','4','Ȩ���������', a.compl_etc) as compl_etc, "+ //ó�������߰�(20180726)
					" b.gov_nm, b.gov_nm2, c.cnt"+
					" from fine_doc a, fine_gov b, (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					" a.gov_id=b.gov_id and a.doc_id=c.doc_id and a.doc_id like '%����%'"+dt_query;

				if(!gubun1.equals(""))		query += " and b.gov_id='"+gubun1+"'";

			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select"+ 
						" DISTINCT "+
						" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
						" DECODE(a.compl_etc,'1','����24','2','�μ�','3','FAX','4','Ȩ���������', a.compl_etc) as compl_etc, "+ //ó�������߰�(20180726)
						" b.gov_nm, b.gov_nm2, j.cnt"+ 
						" from fine_doc a, fine_gov b, fine_doc_list c, fine d, cont e, client f, rent_cont g, rent_cust h, car_reg i,"+ 
						" (select doc_id, count(*) cnt from fine_doc_list group by doc_id) j, users l"+ 
						" where "+ 
						" a.gov_id=b.gov_id"+ 
						" and a.doc_id=c.doc_id and a.doc_id like '%����%'"+dt_query + 
						" and c.car_mng_id=d.car_mng_id and c.seq_no=d.seq_no and c.rent_mng_id=d.rent_mng_id and c.rent_l_cd=d.rent_l_cd"+ 
						" and c.rent_mng_id=e.rent_mng_id and c.rent_l_cd=e.rent_l_cd"+ 
						" and e.client_id=f.client_id"+ 
						" and c.rent_s_cd=g.rent_s_cd(+)"+ 
						" and g.cust_id=h.cust_id(+)"+ 
						" and c.car_mng_id=i.car_mng_id"+ 
						" and a.doc_id=j.doc_id"+
						" and a.reg_id=l.user_id"+
						" ";

				if(s_kd.equals("1"))	query += " and nvl(f.firm_nm,f.client_nm)||h.cust_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and i.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and d.paid_no like '%"+t_wd+"%'";
				if(s_kd.equals("4"))	query += " and d.vio_dt like '%"+t_wd+"%'";
				if(s_kd.equals("5"))	query += " and l.user_nm like '%"+t_wd+"%'";
				if(s_kd.equals("6"))	query += " and b.gov_nm like '%"+t_wd+"%'";
				if(s_kd.equals("7"))	query += " and a.doc_id like '%"+t_wd+"%'";
			}
			if(!gubun3.equals("")){	//ó������� �˻�(20180828)
				if(gubun3.equals("1")){		query += " and a.compl_etc = '1'";		}	//����24
				if(gubun3.equals("2")){		query += " and a.compl_etc = '2'";		}	//�μ�
				if(gubun3.equals("3")){		query += " and a.compl_etc = '3'";		}	//FAX
				if(gubun3.equals("4")){		query += " and a.compl_etc = '4'";		}	//Ȩ���������
				if(gubun3.equals("5")){		query += " and a.compl_etc is null";	}	//��ó��
			}
		}

		if(id_st.equals("����")){ 
				query += " ORDER BY a.doc_id asc";
		}else if(id_st.equals("����")){ 
				query += " ORDER BY a.doc_id desc";
		}else if(id_st.equals("�ѹ�")){ 
				query += " ORDER BY   a.end_dt desc,  a.doc_id asc";						
		}else if(id_st.equals("���·�")){
			//ó������� ���� ����	>> 1 : ����24 ���� , 2 : �μ� ����, 3 : FAX ����, 4 : Ȩ���������, 5: ��ó�� ���� ��ܿ� �߰� (20180801)
			if(!t_wd.equals("")){
				query += " ORDER BY a.doc_id asc";
			}else{
				if(sort.equals("1")){	
					query += " ORDER BY DECODE(a.compl_etc,'1','1','2','2','3','3','4','4','','5'), a.doc_id asc";
				}else if(sort.equals("2")){
					query += " ORDER BY DECODE(a.compl_etc,'2','1','1','2','3','3','4','4','','5'), a.doc_id asc";
				}else if(sort.equals("3")){
					query += " ORDER BY DECODE(a.compl_etc,'3','1','1','2','2','3','4','4','','5'), a.doc_id asc";	
				}else if(sort.equals("4")){
					query += " ORDER BY DECODE(a.compl_etc,'4','1','1','2','2','3','3','4','','5'), a.doc_id asc";
				}else if(sort.equals("5")){
					query += " ORDER BY DECODE(a.compl_etc,'','1','1','2','2','3','3','4','4','5'), a.doc_id asc";
				}else{
					query += " ORDER BY a.doc_id asc";
				}
			}
		}else if(id_st.equals("ä���߽�")){ 
				query += " ORDER BY a.doc_id desc";
		}else{
				query += " ORDER BY a.doc_id asc";
		}
		
		try {
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();
		   	
	//	   	System.out.println("getFineSearchLists: "+query);

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
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+e);
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+query);
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
	
	
	//������Ȳ - s_cpt ������ 
		public Vector getFineDocLists(String id_st, String br_id, String gubun, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_cpt)
		{
			getConnection();
			Vector vt = new Vector();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			String dt_query = "";
			String dt = "a.doc_dt";//��������

			//���� ������ ��� �������ڵ� �˻������ϵ���			
			if ( brch_id.equals("L")) { //���� ����
			    if ( gubun4.equals("2") ) {
			    	dt = "a.end_dt";
			    }	
			}
						
			//������ȸ
			if(gubun2.equals("1"))		dt_query = " and "+dt+"=to_char(sysdate-2,'YYYYMMDD')";
			if(gubun2.equals("2"))		dt_query = " and "+dt+"=to_char(sysdate-1,'YYYYMMDD')";
			if(gubun2.equals("3"))		dt_query = " and "+dt+"=to_char(sysdate,'YYYYMMDD')";
			if(gubun2.equals("4"))		dt_query = " and substr("+dt+",1,6)=to_char(sysdate,'YYYYMM')";
			if(gubun2.equals("5"))		dt_query = " and "+dt+" between replace(nvl('"+st_dt+"','00000000'), '-', '') and replace(nvl('"+end_dt+"','99999999'), '-', '')";
			if(gubun2.equals("6"))		dt_query = " and substr("+dt+",1,4)=to_char(sysdate,'YYYY')";
			if(gubun2.equals("7"))		dt_query = " and substr("+dt+",1,6) = to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";
			  
			  
			query = " SELECT"+
					"  a.regyn, a.doc_id, a.doc_dt,a.cltr_chk, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id, a.req_dt, a.ip_dt,"+
					" b.nm as gov_nm, c.cnt, c.amt, a.app_doc5, a.end_dt, a.req_dt, a.scd_yn , a.cms_code , a.fund_yn "+
					" from fine_doc a, "
					+ "(select b.*, a.gubun from code b, code_etc a where b.c_st = '0003' and b.CODE <> '0000' and b.C_ST=a.C_ST(+)  and b.CODE=a.CODE(+)  ) b, "				
					+ "(select doc_id, count(*) cnt, SUM((amt4 + amt5)/2) amt from fine_doc_list group by doc_id) c"+
					" where"+
					" a.gov_id=b.code and a.doc_id=c.doc_id and a.doc_id like '%�ѹ�%'"+dt_query;

			if(!gubun.equals(""))		query += " and b.gubun ='"+gubun+"'";

			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select"+ 
						" DISTINCT  b.nm as gov_nm, a.*, c.cnt  "+ 
						" from fine_doc a, fine_doc_list d, (select b.*, a.gubun from code b, code_etc a where b.c_st = '0003' and b.CODE <> '0000' and b.C_ST=a.C_ST(+)  and b.CODE=a.CODE(+)) b,  (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c , car_reg i "+ 
						" where "+ 
						" a.gov_id=b.code"+ 
						" and a.doc_id=c.doc_id(+)"+ 
						" and a.doc_id=d.doc_id(+) and a.doc_id like '%�ѹ�%' "+
						" and d.car_mng_id=i.car_mng_id(+) "+dt_query; 
						 		
				if(s_kd.equals("2"))	query += " and i.car_no like '%"+t_wd+"%'";			
				if(s_kd.equals("4"))	query += " and d.rent_l_cd like '%"+t_wd+"%'";			
				if(s_kd.equals("3"))	query += " and b.code ='"+t_wd+"'";					

			}			
		
			query += " ORDER BY   a.end_dt desc,  a.doc_id desc";			
			
			try {
				pstmt = conn.prepareStatement(query);
			   	rs = pstmt.executeQuery();
			   	
		//	   	System.out.println("getFineSearchLists: "+query);

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
				System.out.println("[FineDocDatabase:getFineSearchLists]\n"+e);
				System.out.println("[FineDocDatabase:getFineSearchLists]\n"+query);
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
		
	
	//ä���߽� �ݼ��ּ�
	public Vector getFineDocFResultLists(String id_st, String client_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " SELECT"+
					" a.* "+
					" from fine_doc a, client b, (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
					" where "+
					" a.gov_id=b.client_id and a.doc_id=c.doc_id(+) and gov_id = '" + client_id + "' and a.doc_id like '%ä���߽�%' and a.f_result = '1'";

		try {
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();
		   	
		 //  	System.out.println(query);

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
			System.out.println("[FineDocDatabase:getFineDocFResultLists]\n"+e);
			System.out.println("[FineDocDatabase:getFineDocFResultLists]\n"+query);
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
			

	//û������� ���·� ����Ʈ
	public Vector getFineLists(String gov_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

			query = " select"+ 
					" d.car_mng_id, d.seq_no, d.rent_mng_id, d.rent_l_cd,"+ 
					" i.car_no, f.firm_nm, h.cust_nm, nvl(h.cust_nm,f.firm_nm) firm_nm2, d.paid_no, d.vio_dt, d.vio_cont"+ 
					" from fine_doc a, fine_gov b, fine_doc_list c, fine d, cont e, client f, rent_cont g, rent_cust h, car_reg i,"+ 
					" (select doc_id, count(*) cnt from fine_doc_list group by doc_id) j"+ 
					" where "+ 
					" a.gov_id='"+gov_id+"' and a.gov_id=b.gov_id"+ 
					" and a.doc_id=c.doc_id"+ 
					" and c.car_mng_id=d.car_mng_id and c.seq_no=d.seq_no and c.rent_mng_id=d.rent_mng_id and c.rent_l_cd=d.rent_l_cd"+ 
					" and c.rent_mng_id=e.rent_mng_id and c.rent_l_cd=e.rent_l_cd"+ 
					" and e.client_id=f.client_id"+ 
					" and c.rent_s_cd=g.rent_s_cd(+)"+ 
					" and g.cust_id=h.cust_id(+)"+ 
					" and c.car_mng_id=i.car_mng_id"+ 
					" and a.doc_id=j.doc_id";

		query += " ORDER BY a.doc_id, d.vio_dt";


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
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+e);
			System.out.println("[FineDocDatabase:getFineSearchLists]\n"+query);
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

	/*���ǽ�û���� ���� ���ű�� ����Ʈ(�ڵ�ȭ)  ��ȸ*/
	public Vector getFineDocRegGovList(String br_id)
	{
		getConnection();

		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt = "a.est_dt";
		String search = "";
		String t_wd_yn = "";

		query = " select b.gov_id, b.gov_nm"+
				" from fine_doc a, fine_gov b"+
				" where a.gov_id=b.gov_id"+
				" group by b.gov_id, b.gov_nm order by b.gov_nm, b.gov_id";

		try{
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
			System.out.println("[FineDocDatabase:getFineDocRegGovList]\n"+e);
			System.out.println("[FineDocDatabase:getFineDocRegGovList]\n"+query);
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

	//insert-----------------------------------------------------------------------------------------------------------------------------------------

	//���·� û����� �Ѱ� ���
	public boolean insertFineGov(FineGovBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String query = "", gov_id = "";
			
	//	String id_sql = " select nvl(ltrim(to_char(to_number(max(gov_id)+1), '000')), '001') gov_id from fine_gov ";
		String id_sql = " select nvl(ltrim(to_char(to_number(max(to_number(gov_id))+1), '0000')), '0001') gov_id from fine_gov ";	//gov_id : 4�ڸ����� ����(20190524)

		query = " INSERT INTO fine_gov "+
				" (gov_id, gov_nm, mng_dept, tel, fax, zip, addr, gov_st, mng_nm, mng_pos, bank_nm, bank_no, ven_code, ven_name, use_yn, gov_nm2, gov_dept_code) VALUES"+//
				" ( ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(id_sql);
	    	rs = pstmt1.executeQuery();
	    	if(rs.next())
	    		gov_id=rs.getString(1);
			rs.close();
            pstmt1.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		gov_id				);
			pstmt.setString	(2,		bean.getGov_nm	()	);
			pstmt.setString	(3,		bean.getMng_dept()	);
			pstmt.setString	(4,		bean.getTel		()	);
			pstmt.setString	(5,		bean.getFax		()	);
			pstmt.setString	(6,		bean.getZip		()	);
			pstmt.setString	(7,		bean.getAddr	()	);
			pstmt.setString	(8,		bean.getGov_st	()	);
			pstmt.setString	(9,		bean.getMng_nm	()	);
			pstmt.setString	(10,	bean.getMng_pos	()	);
			pstmt.setString	(11,	bean.getBank_nm	()	);
			pstmt.setString	(12,	bean.getBank_no	()	);
			pstmt.setString	(13,	bean.getVen_code()	);
			pstmt.setString	(14,	AddUtil.substringb(bean.getVen_name(),30));
			pstmt.setString	(15,	bean.getUse_yn()	);
			pstmt.setString	(16,	bean.getGov_nm2()	);
			pstmt.setString	(17,	bean.getGov_dept_code()	);

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[FineDocDatabase:insertFineGov]\n"+e);
			System.out.println("[gov_id					]\n"+gov_id					);
			System.out.println("[bean.getGov_nm		()	]\n"+bean.getGov_nm		()	);
			System.out.println("[bean.getMng_dept	()	]\n"+bean.getMng_dept	()	);
			System.out.println("[bean.getTel		()	]\n"+bean.getTel		()	);
			System.out.println("[bean.getFax		()	]\n"+bean.getFax		()	);
			System.out.println("[bean.getZip		()	]\n"+bean.getZip		()	);
			System.out.println("[bean.getAddr		()	]\n"+bean.getAddr		()	);
			System.out.println("[bean.getGov_st		()	]\n"+bean.getGov_st		()	);
			System.out.println("[bean.getMng_nm		()	]\n"+bean.getMng_nm		()	);
			System.out.println("[bean.getMng_pos	()	]\n"+bean.getMng_pos	()	);
			System.out.println("[bean.getBank_nm	()	]\n"+bean.getBank_nm	()	);
			System.out.println("[bean.getBank_no	()	]\n"+bean.getBank_no	()	);
			System.out.println("[bean.getVen_code	()	]\n"+bean.getVen_code	()	);
			System.out.println("[bean.getVen_name	()	]\n"+bean.getVen_name	()	);
			System.out.println("[bean.getUse_yn		()	]\n"+bean.getUse_yn	()	);
			System.out.println("[bean.getGov_nm2		()	]\n"+bean.getGov_nm2	()	);
			System.out.println("[bean.getGov_dept_code		()	]\n"+bean.getGov_dept_code	()	);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//���·� ���ǽ�û���� �Ѱ� ���
	public boolean insertFineDoc(FineDocBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO fine_doc ( "+
				"       doc_id, doc_dt, gov_id, mng_dept, print_dt, reg_id, reg_dt, upd_id, upd_dt, "+
				"       gov_st, mng_nm, mng_pos, h_mng_id, b_mng_id, app_doc3, app_doc1, app_doc2, app_doc4, print_id, "+  //10
				"	    gov_nm, gov_addr, title, end_dt, filename, app_doc5, gov_zip, app_docs, "+  //8
				"       remarks, s_dt, e_dt , ip_dt, f_reason, f_result, cltr_rat, cltr_amt, off_id, seq, card_yn,  fund_yn ) VALUES "+ //12
				"	 (  ?, replace(?, '-', ''), ?, ?,  replace(?, '-', '') , ?, to_char(sysdate,'YYYYMMDD'), '', '', "+
				"	    ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,   " +  //10
				"       ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?, " +  //8
				"       ?, replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', '') , ?,  ? , ?, ?, ?, ?, ?, ?  )";  //12


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getDoc_id	());
			pstmt.setString	(2,		bean.getDoc_dt	());
			pstmt.setString	(3,		bean.getGov_id	());
			pstmt.setString	(4,		bean.getMng_dept());
			pstmt.setString	(5,		bean.getPrint_dt());			
			pstmt.setString	(6,		bean.getReg_id	());

			pstmt.setString	(7,		bean.getGov_st	());
			pstmt.setString	(8,		bean.getMng_nm	());
			pstmt.setString	(9,		bean.getMng_pos ());
			pstmt.setString	(10,	bean.getH_mng_id());
			pstmt.setString	(11,	bean.getB_mng_id());
			pstmt.setString	(12,	bean.getApp_doc3());
			pstmt.setString	(13,	bean.getApp_doc1());
			pstmt.setString	(14,	bean.getApp_doc2());
			pstmt.setString	(15,	bean.getApp_doc4());
			pstmt.setString	(16,	bean.getPrint_id());  //10
		
			pstmt.setString	(17,	bean.getGov_nm	());
			pstmt.setString	(18,	bean.getGov_addr());
			pstmt.setString	(19,	bean.getTitle	());
			pstmt.setString	(20,	bean.getEnd_dt	());
			pstmt.setString	(21,	bean.getFilename());			
			pstmt.setString	(22,	bean.getApp_doc5());			
			pstmt.setString	(23,	bean.getGov_zip());
			pstmt.setString	(24,	bean.getApp_docs());  //3
			
			pstmt.setString	(25,	bean.getRemarks());
			pstmt.setString	(26,	bean.getS_dt());
			pstmt.setString	(27,	bean.getE_dt());
			pstmt.setString	(28,	bean.getIp_dt());
			
			pstmt.setString	(29,	bean.getF_reason());
			pstmt.setString	(30,	bean.getF_result());
			
			pstmt.setString	(31,	bean.getCltr_rat());
			pstmt.setInt	(32,	bean.getCltr_amt());
			
			pstmt.setString	(33,	bean.getOff_id());
			pstmt.setInt	(34,	bean.getSeq());   //10
			pstmt.setString	(35,	bean.getCard_yn());
			pstmt.setString	(36,	bean.getFund_yn()); //�����ڱ� ����

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[FineDocDatabase:insertFineDoc]\n"+e);
			System.out.println("[FineDocDatabase:insertFineDoc]\n"+query);
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

	//���·� ���ǽ�û���� ���·� �Ѱ� ���
	public boolean insertFineDocList(FineDocListBean bean, String doc_dt)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO fine_doc_list (doc_id, car_mng_id, seq_no, rent_mng_id, rent_l_cd, rent_s_cd,"+
					"   firm_nm, ssn, enp_no, rent_start_dt, rent_end_dt, paid_no, reg_id, reg_dt, upd_id, upd_dt,"+
					"   car_no, amt1, amt2, amt3, amt4, amt5, amt6, amt7, "+
					"   var1, var2, var3, chk, rent_st, lic_no ) VALUES"+
					" ( ?, ?, ?, ?, ?,    ?, "+
					"   ?, replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''),   replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), '', '',"+
					"   ?, ?, ?, ?, ?, ?, ?, ?, "+
					"    ?, ?, ?, '', ?, ?)";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getDoc_id 		());
			pstmt.setString	(2,		bean.getCar_mng_id	());
			pstmt.setInt	(3,		bean.getSeq_no		());
			pstmt.setString	(4,		bean.getRent_mng_id ());
			pstmt.setString	(5,		bean.getRent_l_cd	());

			pstmt.setString	(6,		bean.getRent_s_cd	());
			pstmt.setString	(7,		bean.getFirm_nm		());
			pstmt.setString	(8,		bean.getSsn			());
			pstmt.setString	(9,		bean.getEnp_no		());
			pstmt.setString	(10,	bean.getRent_start_dt());

			pstmt.setString	(11,	bean.getRent_end_dt	());
			pstmt.setString	(12,	bean.getPaid_no		());
			pstmt.setString	(13,	bean.getReg_id		());

			pstmt.setString	(14,	bean.getCar_no		());
			pstmt.setInt	(15,	bean.getAmt1		());
			pstmt.setInt	(16,	bean.getAmt2		());
			pstmt.setInt	(17,	bean.getAmt3		());
			pstmt.setInt	(18,	bean.getAmt4		());
			pstmt.setInt	(19,	bean.getAmt5		());
			pstmt.setInt	(20,	bean.getAmt6		());
			pstmt.setInt	(21,	bean.getAmt7		());
			
			pstmt.setString	(22,	bean.getVar1		());
			pstmt.setString	(23,	bean.getVar2		());
			pstmt.setString	(24,	bean.getVar3		());
			pstmt.setString	(25,	bean.getRent_st		());
			pstmt.setString	(26,	bean.getLic_no		());	//���������ȣ�߰�(20180830)

			pstmt.executeUpdate();
			pstmt.close();
		
			conn.commit();
			updateFineObj_dt(bean.getCar_mng_id(), bean.getRent_mng_id(), bean.getRent_l_cd(), Integer.toString(bean.getSeq_no()), doc_dt);

	  	} catch (Exception e) {
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+e);
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+query);
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getSsn()+"]");
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

	//���·� ���ǽ�û���� ���·� �Ѱ� ���
	public boolean insertAccidDocList(FineDocListBean bean, String doc_dt)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO fine_doc_list (doc_id, car_mng_id, seq_no, rent_mng_id, rent_l_cd, rent_s_cd,"+
					"   firm_nm, ssn, enp_no, rent_start_dt, rent_end_dt, paid_no, reg_id, reg_dt, upd_id, upd_dt,"+
					"   car_no, amt1, amt2, amt3, amt4, amt5, amt6, amt7, var1, var2, var3) VALUES"+
					" ( ?, ?, ?, ?, ?,    ?, "+
					"   ?, replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''),   replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), '', '',"+
					"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getDoc_id 		());
			pstmt.setString	(2,		bean.getCar_mng_id	());
			pstmt.setInt	(3,		bean.getSeq_no		());
			pstmt.setString	(4,		bean.getRent_mng_id ());
			pstmt.setString	(5,		bean.getRent_l_cd	());

			pstmt.setString	(6,		bean.getRent_s_cd	());
			pstmt.setString	(7,		bean.getFirm_nm		());
			pstmt.setString	(8,		bean.getSsn			());
			pstmt.setString	(9,		bean.getEnp_no		());
			pstmt.setString	(10,	bean.getRent_start_dt());

			pstmt.setString	(11,	bean.getRent_end_dt	());
			pstmt.setString	(12,	bean.getPaid_no		());
			pstmt.setString	(13,	bean.getReg_id		());

			pstmt.setString	(14,	bean.getCar_no		());
			pstmt.setInt	(15,	bean.getAmt1		());
			pstmt.setInt	(16,	bean.getAmt2		());
			pstmt.setInt	(17,	bean.getAmt3		());
			pstmt.setInt	(18,	bean.getAmt4		());
			pstmt.setInt	(19,	bean.getAmt5		());
			pstmt.setInt	(20,	bean.getAmt6		());
			pstmt.setInt	(21,	bean.getAmt7		());
			pstmt.setString	(22,	bean.getVar1		());
			pstmt.setString	(23,	bean.getVar2		());
			pstmt.setString	(24,	bean.getVar3		());

			pstmt.executeUpdate();
			pstmt.close();
		
			conn.commit();


	  	} catch (Exception e) {
			System.out.println("[FineDocDatabase:insertAccidDocList]\n"+e);
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

	//update-----------------------------------------------------------------------------------------------------------------------------------------
	
	
	//���·� û����� ����24�� ����
	public boolean updateFineGovNm2(FineGovBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE fine_gov SET"+
					" gov_nm2		= ?,"+
					" gov_dept_code	= ?"+
					" WHERE gov_id = ?";

		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getGov_nm2()	);
			pstmt.setString	(2,		bean.getGov_dept_code()	);
			pstmt.setString	(3,		bean.getGov_id()	);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[FineDocDatabase:updateFineGovNm2]\n"+e);

			System.out.println("[bean.getGov_nm2	()]\n"+bean.getGov_nm2	());
			System.out.println("[bean.getGov_dept_code	()]\n"+bean.getGov_dept_code	());
			System.out.println("[bean.getGov_id		()]\n"+bean.getGov_id	());

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

	//���·� û����� �Ѱ� ����
	public boolean updateFineGov(FineGovBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE fine_gov SET"+
					" gov_nm		= ?,"+
					" mng_dept		= ?,"+  
					" tel			= ?,"+
					" fax			= ?,"+  
					" zip			= ?,"+ 
					" addr			= ?,"+ 
					" gov_st		= ?,"+
					" mng_nm		= ?,"+
					" mng_pos		= ?,"+
					" bank_nm		= ?,"+
					" bank_no		= ?,"+
					" ven_code		= ?,"+
					" ven_name		= ?,"+
					" use_yn		= ?,"+
					" gov_nm2		= ?,"+
					" gov_dept_code	= ?"+
				" WHERE gov_id = ?";

		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getGov_nm	()	);
			pstmt.setString	(2,		bean.getMng_dept()	);
			pstmt.setString	(3,		bean.getTel		()	);
			pstmt.setString	(4,		bean.getFax		()	);
			pstmt.setString	(5,		bean.getZip		()	);
			pstmt.setString	(6,		bean.getAddr	()	);
			pstmt.setString	(7,		bean.getGov_st	()	);
			pstmt.setString	(8,		bean.getMng_nm	()	);
			pstmt.setString	(9,		bean.getMng_pos	()	);
			pstmt.setString	(10,	bean.getBank_nm	()	);
			pstmt.setString	(11,	bean.getBank_no	()	);
			pstmt.setString	(12,	bean.getVen_code()	);
			pstmt.setString	(13,	AddUtil.substringb(bean.getVen_name(),30)	);
			pstmt.setString	(14,	bean.getUse_yn	()	);
			pstmt.setString	(15,	bean.getGov_nm2	()	);
			pstmt.setString	(16,	bean.getGov_dept_code()	);
			pstmt.setString	(17,	bean.getGov_id	()	);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[FineDocDatabase:updateFineGov]\n"+e);

			System.out.println("[bean.getGov_nm		()]\n"+bean.getGov_nm	());
			System.out.println("[bean.getMng_dept	()]\n"+bean.getMng_dept	());
			System.out.println("[bean.getTel		()]\n"+bean.getTel		());
			System.out.println("[bean.getFax		()]\n"+bean.getFax		());
			System.out.println("[bean.getZip		()]\n"+bean.getZip		());
			System.out.println("[bean.getAddr		()]\n"+bean.getAddr		());
			System.out.println("[bean.getGov_st		()]\n"+bean.getGov_st	());
			System.out.println("[bean.getMng_nm		()]\n"+bean.getMng_nm	());
			System.out.println("[bean.getMng_pos	()]\n"+bean.getMng_pos	());
			System.out.println("[bean.getBank_nm	()]\n"+bean.getBank_nm	());
			System.out.println("[bean.getBank_no	()]\n"+bean.getBank_no	());
			System.out.println("[bean.getVen_code	()]\n"+bean.getVen_code	());
			System.out.println("[bean.getVen_name	()]\n"+bean.getVen_name	());
			System.out.println("[bean.getUse_yn		()]\n"+bean.getUse_yn	());
			System.out.println("[bean.getGov_nm2	()]\n"+bean.getGov_nm2	());
			System.out.println("[bean.getGov_dept_code()]\n"+bean.getGov_dept_code());
			System.out.println("[bean.getGov_id		()]\n"+bean.getGov_id	());

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

	//���·� ���ǽ�û����  �Ѱ� ����
	public boolean updateFineDoc(FineDocBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE fine_doc SET"+
					" doc_dt		= replace(?, '-', ''),"+
					" gov_id		= ?,"+
					" mng_dept		= ?,"+  
					" upd_id		= ?,"+  
					" upd_dt		= to_char(sysdate,'YYYYMMDD'),"+
					" gov_st		= ?,"+
					" mng_nm		= ?,"+  
					" mng_pos		= ?,"+  
					" h_mng_id		= ?,"+  
					" b_mng_id		= ?,"+  
					" gov_addr		= ?,"+  
					" title			= ?,"+  
					" end_dt		= replace(?, '-', ''),"+  
					" filename		= ?,"+
					" app_doc1		= ?,"+  
					" app_doc2		= ?,"+  
					" app_doc3		= ?,"+  
					" app_doc4		= ?,"+    
					" app_doc5		= ?,"+    
					" post_num		= ?,"+
					" f_result		= ?,"+  
					" f_reason		= ?,"+     
					" remarks		= ?,"+     
					" ip_dt		= replace(?, '-', ''),"+  
					" s_dt		=  replace(?, '-', ''),"+   
					" e_dt		= replace(?, '-', ''),"+   
					" cltr_rat		= ?,"+  
					" cltr_amt		= ?,"+  
					" app_docs		= ?, "+  
					" off_id		= ?, "+  
					" seq		= ?  "+  				
				" WHERE doc_id = ?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getDoc_dt	());
			pstmt.setString	(2,		bean.getGov_id	());
			pstmt.setString	(3,		bean.getMng_dept());
			pstmt.setString	(4,		bean.getUpd_id	());

			pstmt.setString	(5,		bean.getGov_st	());
			pstmt.setString	(6,		bean.getMng_nm	());
			pstmt.setString	(7,		bean.getMng_pos ());
			pstmt.setString	(8,		bean.getH_mng_id());
			pstmt.setString	(9,		bean.getB_mng_id());

			pstmt.setString	(10,	bean.getGov_addr());
			pstmt.setString	(11,	bean.getTitle	());
			pstmt.setString	(12,	bean.getEnd_dt	());
			pstmt.setString	(13,	bean.getFilename());
			
			pstmt.setString	(14,	bean.getApp_doc1());
			pstmt.setString	(15,	bean.getApp_doc2());
			pstmt.setString	(16,	bean.getApp_doc3());
			pstmt.setString	(17,	bean.getApp_doc4());
			pstmt.setString	(18,	bean.getApp_doc5());
			pstmt.setString	(19,	bean.getPost_num());

			pstmt.setString	(20,	bean.getF_result());
			pstmt.setString	(21,	bean.getF_reason());
			pstmt.setString	(22,	bean.getRemarks());
			pstmt.setString	(23,	bean.getIp_dt());
			pstmt.setString	(24,	bean.getS_dt());
			pstmt.setString	(25,	bean.getE_dt());			
			
			pstmt.setString	(26,	bean.getCltr_rat());
			pstmt.setInt     (27,	bean.getCltr_amt());
			pstmt.setString	(28,	bean.getApp_docs());

			pstmt.setString	(29,	bean.getOff_id());
			pstmt.setInt    (30,	bean.getSeq());
									
			pstmt.setString	(31,	bean.getDoc_id	());

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[FineDocDatabase:updateFineDoc]\n"+e);
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

	//���·� ���ǽ�û���� ����
	public boolean updateFineObj_dt(String c_id, String m_id, String l_cd, String seq_no, String doc_dt)
	{
		getConnection();

		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String query = "", query2 = "";
		boolean flag = true;
		String dt = "obj_dt1";
		String obj_dt1 = "", obj_dt2 = "", obj_dt3 = "";

		query2 = " select obj_dt1, obj_dt2, obj_dt3 from fine where car_mng_id=? and seq_no = ? and rent_mng_id=? and rent_l_cd=?";

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query2);
			pstmt.setString	(1,		c_id.trim());
			pstmt.setInt	(2,		AddUtil.parseInt(seq_no));
			pstmt.setString	(3,		m_id.trim());
			pstmt.setString	(4,		l_cd.trim());
	    	rs = pstmt.executeQuery();
	    	if(rs.next()){
	    		obj_dt1=rs.getString(1)==null?"":rs.getString(1);
	    		obj_dt2=rs.getString(2)==null?"":rs.getString(2);
	    		obj_dt3=rs.getString(3)==null?"":rs.getString(3);
			}
			rs.close();
			pstmt.close();

			if(!obj_dt1.equals(""))	dt = "obj_dt2";	
			if(!obj_dt2.equals(""))	dt = "obj_dt3";	

			query = " update fine set "+dt+"=replace(?, '-', '') where car_mng_id=? and seq_no = ? and rent_mng_id=? and rent_l_cd=?";

			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString	(1,		doc_dt.trim());
			pstmt1.setString	(2,		c_id.trim());
			pstmt1.setInt		(3,		AddUtil.parseInt(seq_no));
			pstmt1.setString	(4,		m_id.trim());
			pstmt1.setString	(5,		l_cd.trim());
			pstmt1.executeUpdate();
			pstmt1.close();
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[FineDocDatabase:updateFineObj_dt]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//���·� ���� �μ⿩�� ���
	public void changePrint_dt(String doc_id, String user_id)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " update fine_doc set print_dt=to_char(sysdate,'YYYYMMDD'), print_id=? where doc_id=?";

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		user_id.trim()	 );
			pstmt.setString	(2,		doc_id.trim()	 );
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		
		 }catch(Exception se){
           try{
				System.out.println("[FineDocDatabase:changePrint_dt]"+se);
				se.printStackTrace();
				flag = false;
                conn.rollback();
            }catch(SQLException _ignored){}
       
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
		}
	}
	
		//���·� ���ǽ�û����  ����
	public boolean deleteFineDoc(String doc_id)
	{
		getConnection();

		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
	
		String query = "";
		String query1 = "";
		
		boolean flag = true;
			
		query = " DELETE fine_doc "+
			    " WHERE doc_id = ? ";

				
		query1 = " DELETE fine_doc_list "+
			    " WHERE doc_id = ? ";
			    
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	doc_id);
			pstmt.executeUpdate();
			pstmt.close();		
			
			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1,	doc_id);
			pstmt1.executeUpdate();
			pstmt1.close();
			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[FineDocDatabase:deleteFineDoc]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
		
		//������� �ݾ� ���� ����	
	public boolean updateFineDocList(String doc_id, String gov_id, int cltr_rat)
	{
		
		int flag = 0;
		
		float loan_amt = 0;
		int loan_amt1 = 0;		
		int loan_amt4 = 0;
				
		float loan_a_amt = 0;
		float loan_b_amt = 0;
	
		int loan_a_amt1 = 0;
		int loan_b_amt1 = 0;
						
		float  tax_amt = 0;  //��漼
		float  tax_a_amt = 0;  //��漼
		float  tax_b_amt = 0;  //��漼
		int    tax_amt1 = 0; //��漼
		int    tax_a_amt1 = 0; //��漼
		int    tax_b_amt1 = 0; //��漼
		
		int dam_amt = 0;  //�㺸������
		float  dam_f_amt = 0;  //�㺸������	
		
		int ecar_pur_amt = 0; //���ź�����
			
	    String cal_amt = "";
	         		
				
	//	System.out.println("doc_id =" + doc_id );
					
		Vector vts = getBankDocAllLists3(doc_id);
		int f_size = vts.size();
		
	//	System.out.println("gov_id =" + gov_id );
		 
		for(int i = 0 ; i < f_size ; i++)
			{
				FineDocListBean a_fl = (FineDocListBean)vts.elementAt(i);			
				
				 //�Ե�ĳ��Ż, ��ȯĳ��Ż, ȿ��ĳ��Ż, �츮���̳��� , ktĳ��Ż, ibkĳ��Ż, hk ��������, ����ĳ��Ż, ��������, SBI 3 ��������,  �ѱ���Ƽ�׷�ĳ��Ż, ��������(0072)	, SBI 4 ����(0073), �ϳ�����(0074),  aj�κ���Ʈ(0076) ,  bnkĳ��Ż(0102)
				// kbĳ��Ż(0078) , ��������(0081) , ��������(0083), �ﱹ����(0084) ,kb����(0085), ��������(0088), �μ�����(0089), ������������(0090), �ѽ���������(0094) , ��Ÿ����(0104)
				// ��ȭ����(0111), ibk����(0113) , �Ե�ī��(0114) ,  ��ȭ��������(0115)
				if (       gov_id.equals("0038") || gov_id.equals("0040") || gov_id.equals("0039") || gov_id.equals("0051") || gov_id.equals("0057") || gov_id.equals("0059") || gov_id.equals("0058") 
						|| gov_id.equals("0060") || gov_id.equals("0028") || gov_id.equals("0068") || gov_id.equals("0069") || gov_id.equals("0073") || gov_id.equals("0072") || gov_id.equals("0074") 
						|| gov_id.equals("0076") || gov_id.equals("0077") || gov_id.equals("0078") || gov_id.equals("0081") || gov_id.equals("0083") || gov_id.equals("0084") || gov_id.equals("0085")  
						|| gov_id.equals("0088") || gov_id.equals("0089") || gov_id.equals("0090") || gov_id.equals("0092") || gov_id.equals("0094") || gov_id.equals("0100") || gov_id.equals("0101")  
						|| gov_id.equals("0102") || gov_id.equals("0103") || gov_id.equals("0104") || gov_id.equals("0110") || gov_id.equals("0111") || gov_id.equals("0113") || gov_id.equals("0114") 
						|| gov_id.equals("0115")	) 
				{
				 		   loan_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt3())) *  90/100;
			   	} else if (gov_id.equals("0009") || gov_id.equals("0001") || gov_id.equals("0003") || gov_id.equals("0099") || gov_id.equals("0086") || gov_id.equals("0010") || gov_id.equals("0079") 
			   			|| gov_id.equals("0056") || gov_id.equals("0091") || gov_id.equals("0116") || gov_id.equals("0093") ) { //����ĳ��Ż or �������� or �ϳ����� , �ѱ�ĳ��Ż(0099) , ������(0086) -201808���� ,  �޸���,kdbĳ��Ż(20191119���� ), ��ť��(0056-20200212����), dbĳ��Ż(0091-202009����)
			        	   loan_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt3())) *  90/100;
				} else if (gov_id.equals("0055") || gov_id.equals("0064") || gov_id.equals("0065") || gov_id.equals("0075") || gov_id.equals("0080") || gov_id.equals("0082") || gov_id.equals("0087")
						 ) 
				{ //����ĳ��Ż , BSĳ��Ż, �޸���, ��ȭ����, ���ĳ��Ż. orix,  �����̾�����, ����ĳ��Ż(0091), �Ե����丮��(0093) 
						   loan_amt = Math.round(AddUtil.parseFloat(Integer.toString(a_fl.getAmt3())) /  AddUtil.parseFloat("1.1"));
			   	} else if (gov_id.equals("0043") || gov_id.equals("0044") || gov_id.equals("0041") || gov_id.equals("0002") || gov_id.equals("0063") || gov_id.equals("0118") ) { //�λ�ĳ��Ż , nh ĳ��Ż, �ϳ�ĳ��Ż,DGBĳ��Ż, �޸�����������,
						   loan_a_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt3())) - (AddUtil.parseFloat(Integer.toString(a_fl.getAmt3()))*10/100 ); 	
			               loan_a_amt1 = (int) loan_a_amt;		
			      	       loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1);	
			    } else if (gov_id.equals("0018") ) { //�Ｚī��  20160318 80->90, �������(0037) 20160712
	            	       loan_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt3())) *  90/100;	
			    } else if (gov_id.equals("0109") ) { //����ī��������(0109)
			    	  	   loan_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt3())) *  80/100;				    
	            } else if (gov_id.equals("0037") || gov_id.equals("0005") ) { //������� - 20180508
						//	 loan_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt3())) /  AddUtil.parseFloat("1.1") *  87/100;	
	            	       loan_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt7())) *  80/100;
	            } else if (gov_id.equals("0046")  ) { //�츮ī�� - 20210401 	��������(Ź�۷�����)		
	            		loan_a_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt7())) *  80/100;	     
	            		loan_a_amt1 = (int) loan_a_amt;
	            		loan_a_amt1 = AddUtil.th_rnd(loan_a_amt1); 
	                   	
			    } else if ( gov_id.equals("0033")  ) { //,
						loan_a_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt7())) * 100/100;	
			            loan_a_amt1 = (int) loan_a_amt;		
			      	    loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1);	    
			    } else if (gov_id.equals("0026")  ) { //�뱸����	 
			      		   loan_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt7())) * 100/100;	
			    } else if (gov_id.equals("0004") ||  gov_id.equals("0025")  ) { // ��������	  �λ����� 
			      		   loan_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt7())) * 90/100;	
			    } else if (gov_id.equals("0029") ) { //��������(0029) 
			    	   loan_a_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt3())) *  90/100;	  //���԰���90%
		               loan_a_amt1 = (int) loan_a_amt;
		      	       loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1);	//�ʸ����� 
			    } else if (gov_id.equals("0011") ||  gov_id.equals("0108") ) { //����ĳ��Ż ,����Ŀ�Ӽ�(0108) 
						   loan_a_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt3())) ; 
			               loan_a_amt1 = (int) loan_a_amt;		
			      	  //        loan_a_amt1 = AddUtil.ml_th_rnd(loan_a_amt1);	 	
			      	       loan_a_amt1 = AddUtil.hun_th_rnd(loan_a_amt1);	 	//20170912 ���� 
			  //    } else if ( gov_id.equals("0056") ) { //kt���԰��� ����
			  //    				loan_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt3())) ; 
					      	 	          	   	      				  
			    } else {
			 	    	   loan_amt =  0;
			   	}
			   	
				loan_amt4 = AddUtil.parseInt(Integer.toString(a_fl.getAmt4()) );
				
				loan_amt1 = (int) loan_amt;							
				
				if (       gov_id.equals("0043") || gov_id.equals("0044") || gov_id.equals("0041") || gov_id.equals("0002")  || gov_id.equals("0011") || gov_id.equals("0108")   || gov_id.equals("0063")  
						|| gov_id.equals("0029") || gov_id.equals("0033") || gov_id.equals("0046")  || gov_id.equals("0118") ) {
						loan_amt1 = loan_a_amt1 ;
			    } else if (gov_id.equals("0026")        ) { //�뱸����, ��������	 	
				        loan_amt1 = loan_amt1 ;
			//	} else if (gov_id.equals("0018") ||  gov_id.equals("0037")  ) { //�Ｚī��	 ����(20191213)	
				} else if (gov_id.equals("0037")  ) { //�Ｚī��	 	
				        loan_amt1 =AddUtil.th_rnd(loan_amt1);  
			//	} else if (gov_id.equals("0037") ) { //�������	 	
			//	        loan_amt1 =AddUtil.hun_th_rnd(loan_amt1);  	        
				   //     System.out.println("samsung="+ loan_amt1);    
				} else {		
						loan_amt1 = AddUtil.ten_th_rnd(loan_amt1);
			    }    
                                
             //     
				if (loan_amt4 > 0 ) {
					if (loan_amt1 > loan_amt4) loan_amt1 = loan_amt4;					
				}	
						
				//ecar_
				//���ź������� �ִ� ��� �̹� �ݿ��Ǿ� ����.
			//	ecar_pur_amt = AddUtil.parseInt(Integer.toString(a_fl.getAmt8()) );   //���ź����� 
		     //	loan_amt1 = loan_amt1 - ecar_pur_amt;    
								
				 //����, �λ�, �Ｚī��, ����, dgb, orix �� ��漼 -- ����ĳ��Ż���� (20130911)
		//	       if ( gov_id.equals("0043") || gov_id.equals("0041") || gov_id.equals("0018")  || gov_id.equals("0058")  || gov_id.equals("0063")   || gov_id.equals("0064") ||  gov_id.equals("0079")   ||  gov_id.equals("0086")  ) {   
			//	       	 tax_amt = (AddUtil.parseFloat(Integer.toString(a_fl.getAmt3()))/ AddUtil.parseFloat("1.1") )* 2/100;
			//      	 tax_amt1 = (int) tax_amt;   
		//		       	 tax_amt1 = AddUtil.l_th_rnd(tax_amt1);		          
			//       }	
			   
			//	if ( gov_id.equals("0011") &&  a_fl.getFee_st().equals("Y") ) {   //����ĳ��Ż�̰� �����ڱ��̸� 
			//		    	 tax_amt = (AddUtil.parseFloat(Integer.toString(a_fl.getAmt3()))/ AddUtil.parseFloat("1.1") )* 2/100;
			//		       	 tax_amt1 = (int) tax_amt;   
			//		       	 tax_amt1 = AddUtil.l_th_rnd(tax_amt1);		
			//		       	 System.out.println(a_fl.getAmt3() + " _ tax_amt1="+ tax_amt1);
			//	}	
					
				a_fl.setAmt1( a_fl.getAmt1());
				a_fl.setAmt2( a_fl.getAmt2());
				a_fl.setAmt3( a_fl.getAmt3());			
				a_fl.setAmt4(loan_amt1);				
				a_fl.setAmt5( a_fl.getAmt5());
			//	a_fl.setAmt5( tax_amt1*2 );
				
				// �㺸����
				 if (gov_id.equals("0058") ) { //����ĳ��Ż -20120504	 - �ϳ�ĳ��Ż �㺸�ݾ� 50%->20% ����
				       dam_amt = 1000000;
				 } else if (gov_id.equals("0018") ) { //�Ｚī��	 - ��漼 ���� 20180824)
				       dam_amt =  getDamAmt(loan_amt1, 0 );	
				//       dam_amt =  getDamAmt( a_fl.getAmt4(),0);
				 } else if (  gov_id.equals("0002")   ) { //������� , ��������,  ��ȯ����
				       dam_amt =  getDamAmt1( a_fl.getAmt3());		      	      
			     } else if (  gov_id.equals("0044")   )   { 
      			       dam_amt = loan_amt1 +  a_fl.getAmt5() ;
      		     } else if (   gov_id.equals("0025") || gov_id.equals("0004")  )   {   //�������� , �λ�����, �������, ��������, ��������(11/05)
      			       dam_amt = 0 ;      
      			 } else if (  gov_id.equals("0041")   ||  gov_id.equals("0055")  ||  gov_id.equals("0069")   ||  gov_id.equals("0102")  ||  gov_id.equals("0118")  )   { 
      			       dam_amt =  (loan_amt1 +  a_fl.getAmt5() ) / 5  ; 
      			 } else if (    gov_id.equals("0011")   ||  gov_id.equals("0108")  )   { //����Ŀ�Ӽ�(0108)
     			       dam_amt =  (loan_amt1 +  a_fl.getAmt5() ) / 2  ;      
      			 } else if ( gov_id.equals("0076")  ||  gov_id.equals("0081")   ||  gov_id.equals("0074")   ||  gov_id.equals("0090") ||  gov_id.equals("0084") ) { //, aj�κ���Ʈ	- ������ 50% , �ﱹ(0084-20190617)
      			       dam_amt =  getDamAmt2( a_fl.getAmt3());	
      			 } else if (   gov_id.equals("0101") ||  gov_id.equals("0114")  ) { //, jt ���� 	- �����  50% , �Ե�ī��(0114) -202104����
      			       dam_amt =  getDamAmt2( a_fl.getAmt4());	   
      			 } else if (   gov_id.equals("0059") ) { //, ht ���� 	- �����  30% 
      			       dam_amt =  getDamAmt3( a_fl.getAmt4());   
      			 } else if (gov_id.equals("0072")    ) { //�������� - ������� 10% (2019����)
     			       dam_amt =  getDamAmtRate( 10,  a_fl.getAmt4());		    
      			 } else if (gov_id.equals("0093")   ) { //�Ե����丮�� - ������� 70% (201903������ * ������ �㺸������) , �Һδ� �㺸���� Ʋ�� - �Ե����丮���� �㺸���� ó��. (202204)
      			    //   dam_amt =  getDamAmtRate( cltr_rat,  a_fl.getAmt4());	
      			       dam_amt =  getDamAmtRate( 60,  a_fl.getAmt4());
      			 } else if (gov_id.equals("0046")   ) { //�츮ī��(0046)- �������� 
    			       dam_amt =  a_fl.getAmt7();        
      			 } else if (gov_id.equals("0033")  || gov_id.equals("0029") ) { //�������� - ������� 120% (201905������ * ������ �㺸������) , ��������(0029) - 2021�����
      			       dam_amt =  getDamAmtRate( 120,  a_fl.getAmt4());		        
      			 } else if (gov_id.equals("0064") ) { //�޸���
      			  	   dam_amt =  getDamAmt4( loan_amt1 +  a_fl.getAmt5() , 3);	          		
      			 } else if (gov_id.equals("0065") ||  gov_id.equals("0038") ||  gov_id.equals("0057")   ) { //��ȭ������ , ktĳ��Ż 50->100% 20140724 , �Ե�ĳ��Ż(0038>20140820 100%) , ibkĳ��Ż(0057, 50���ѵ� 202012)
      			  	   dam_amt =   a_fl.getAmt4();	
      			 } else if (gov_id.equals("0028")   ) { //�������� - ������� 110% (202009������ * ������ �㺸������) 
    			       dam_amt =  getDamAmtRate( 110,  a_fl.getAmt4());		 	   
      			// } else if ( gov_id.equals("0028")  ) { //�ϳ�����, ��������(20170412����)
      			//  	   dam_amt =  a_fl.getAmt3() ;  		          		
      		//	  } else if (gov_id.equals("0079") ) { //  //�޸���ĳ��Ż 
      		//	  	dam_amt =  getDamAmt4( loan_amt1 +  a_fl.getAmt5() );	    
      		 //	  //	dam_amt = loan_amt1 +  a_fl.getAmt5() ;  			 	
      			 } else if (gov_id.equals("0078") ||  gov_id.equals("0080")   ||  gov_id.equals("0087") ||  gov_id.equals("0103")      ) { //kb ĳ��Ż  , ktĳ��Ż, IBKĳ��Ż ,kb����ī��  ������� 10%
      				   dam_amt =  (loan_amt1 +  a_fl.getAmt5() ) /10  ;       			      
      			 } else if (gov_id.equals("0001") ) { //�ϳ�����
      				   dam_amt =  getDamAmtRate( 60,  a_fl.getAmt4());	
      			  //	   dam_f_amt =  AddUtil.parseFloat(Integer.toString(a_fl.getAmt4()) ) *60/100; 
      			  //	   dam_amt = (int)  dam_f_amt;
      			//  	System.out.println(a_fl.getAmt4() + ":" + dam_f_amt + " :" + dam_amt );
      			 //	   dam_amt =  AddUtil.th_rnd(dam_amt);          				
     		//	 } else if (gov_id.equals("0029") ) { //��������(0029)
     		//	       dam_amt =  getDamAmt111( a_fl.getAmt3());	    
      			  /* } else if (gov_id.equals("0029") ) { //��������
      			   	dam_f_amt = AddUtil.parseFloat(Integer.toString(a_fl.getAmt3())) /  AddUtil.parseFloat("1.1") *  50/100;	          			  
      			  	dam_amt = (int)  dam_f_amt;
      		  	  	dam_amt =  getDamAmt4( dam_amt +dam_amt, 3);	*/          		
		//  	System.out.println(a_fl.getAmt4() + ":" + dam_f_amt + " :" + dam_amt );
      		//	 	dam_amt =  AddUtil.th_rnd(dam_amt);	
      			 } else if (gov_id.equals("0083")   ) { //��������
      			       dam_amt =  getDamAmt7( a_fl.getAmt3());	
      			 } else if (gov_id.equals("0115")   ) { //��ȭ���� 
    			       dam_amt =  getDamAmtRound4( a_fl.getAmt3(), 30);	      
      			 } else if (gov_id.equals("0089") || gov_id.equals("0111") ) { //�μ�����(0089) , ��ȭ����(0111)
      			       dam_amt =  getDamAmt11( a_fl.getAmt3());	          	      	
      			 } else if (gov_id.equals("0085")  ) { //kb����, ������������ - �������԰��� - 50%
      			       dam_amt =  getDamAmt10(  a_fl.getAmt3() );
      			 } else {
      		    	   dam_amt =  (loan_amt1 +  a_fl.getAmt5() ) / 2  ;
      		     }	
          		          
				a_fl.setAmt6(dam_amt);
				a_fl.setDoc_id(a_fl.getDoc_id());
				a_fl.setRent_mng_id(a_fl.getRent_mng_id());
				a_fl.setRent_l_cd(a_fl.getRent_l_cd());
								
				if(!i_updateFineBankList(a_fl))	flag += 1;				
		}
						
		if(flag == 0)	return true;
		else 			return false;	
			
	}
		
	
		//������� - �󼼳��� ����ڵ� �ο�  - allot  	
	public boolean updateFineDocListAllot(String doc_id, String cms_code)
	{
		int flag = 0;
	         						
	//	System.out.println("doc_id =" + doc_id );
					
		Vector vts = getBankDocAllLists3(doc_id);
		int f_size = vts.size();
					 
		for(int i = 0 ; i < f_size ; i++)
			{
				FineDocListBean a_fl = (FineDocListBean)vts.elementAt(i);			
	          		      						
				if(!i_updateAllotList(a_fl.getRent_mng_id(), a_fl.getRent_l_cd(), cms_code))	flag += 1;
				if(!i_updateCarRegList(a_fl.getCar_mng_id(), cms_code))	flag += 1;
		}
						
		if(flag == 0)	return true;
		else 			return false;
			
	}
			
		
	/**
	 *	�������ݾ� ����- �ѵ��� ����..
	 */	
	public boolean updateFineDocAmt4(String doc_id, int seq_no, int amt3, int amt4, int amt5, int amt6 )
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;
		String query = " update fine_doc_list set"+					
						" amt3 = ?,  amt4 = ? , amt5 = ?, amt6 = ? "+					
						" where doc_id = ? and seq_no = ?";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, amt3);	
			pstmt.setInt(2, amt4);	
			pstmt.setInt(3, amt5);			
			pstmt.setInt(4, amt6);			
			pstmt.setString(5, doc_id);
			pstmt.setInt(6, seq_no);
			
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[FineDocDatabase:updateFineDocAmt4]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
		
	
	/**
	 *	��ȸ�� ������ update
	 */
	
	public boolean i_updateFineBankList(FineDocListBean fl)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;
		String query = " update fine_doc_list set"+
						" amt1 = ?,"+
						" amt2 = ?,"+
						" amt3 = ?,"+
						" amt4 = ?, "+
						" amt5 = ?, "+
						" amt6 = ? "+
						" where RENT_MNG_ID = ? and RENT_L_CD = ? and DOC_ID = ?";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, fl.getAmt1());
			pstmt.setInt(2, fl.getAmt2());
			pstmt.setInt(3, fl.getAmt3());
		    pstmt.setInt(4, fl.getAmt4());
		    pstmt.setInt(5, fl.getAmt5());
		    pstmt.setInt(6, fl.getAmt6());
			pstmt.setString(7, fl.getRent_mng_id());
			pstmt.setString(8, fl.getRent_l_cd());
			pstmt.setString(9, fl.getDoc_id());				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[FineDocDatabase:i_updateFineBankList]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
		
	
	/**
	 *	��ȸ�� allot  ����ڵ�  update
	 */
	
	public boolean i_updateAllotList(String rent_mng_id, String rent_l_cd, String cms_code)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;
		String query = " update allot set  cms_code = ? "+
						" where RENT_MNG_ID = ? and RENT_L_CD = ?  and cms_code is null ";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
		
		    pstmt.setString(1, cms_code.trim());	
			pstmt.setString(2, rent_mng_id.trim());
			pstmt.setString(3, rent_l_cd.trim());
					
	//		System.out.println("cms_code = " + cms_code);
	//		System.out.println("rent_mng_id = " + rent_mng_id);
	//		System.out.println("rent_l_cd = " + rent_l_cd);
					
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[FineDocDatabase:i_updateAllotList]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	
	/**
	 *	��ȸ�� allot  ����ڵ�  update
	 */
	
	public boolean i_updateCarRegList(String car_mng_id,  String cms_code)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;
		String query = " update car_reg set  cms_code = ? "+
						" where car_mng_id = ? and cms_code is null   ";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
		
		    pstmt.setString(1, cms_code.trim());	
			pstmt.setString(2, car_mng_id.trim());
	
					
	//		System.out.println("cms_code = " + cms_code);
	//		System.out.println("car_mng_id = " + car_mng_id);
	
					
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[FineDocDatabase:i_updateCarRegList]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	
	//�����û���� ����Ʈ��ȸ : ������
	public Vector getBankDocAllLists3(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

			
		query = " SELECT a.doc_id, a.rent_mng_id, a.rent_l_cd, a.amt4, a.amt5, " +
				"  nvl(f.fee_s_amt, 0) + nvl(f.fee_v_amt,0) amt1 , ( nvl(f.fee_s_amt, 0) + nvl(f.fee_v_amt,0))*to_number(f.con_mon) amt2, " +
				"  nvl(g.car_fs_amt, 0) + nvl(g.car_fv_amt, 0) - nvl(g.dc_cs_amt, 0)  - nvl(g.dc_cv_amt, 0)  + nvl(g.sd_cs_amt, 0)  + nvl(g.sd_cv_amt, 0) amt3 ," +
				" decode(c.gov_id, '0046', nvl(g.car_fs_amt, 0) + nvl(g.car_fv_amt, 0) - nvl(g.dc_cs_amt, 0) - nvl(g.dc_cv_amt, 0),  nvl(g.car_fs_amt, 0) - nvl(g.dc_cs_amt, 0)  + nvl(g.sd_cs_amt, 0) ) amt7 , \n " +
				" cd.nm  , a.amt6  , d.car_mng_id ,  \n " +
				" nvl(g.ecar_pur_sub_amt, 0)  as amt8 , c.fund_yn \n"+ //���ź����� 
				"  FROM fine_doc_list a, fine_doc c, car_etc g,  car_reg d , cont cc , fee f , "+
				"    ( select * from code where c_st = '0003' ) cd \n  "+
				" WHERE a.doc_id =c.doc_id  and a.car_mng_id = d.car_mng_id(+) and a.rent_mng_id = g.rent_mng_id "+
				"  and a.rent_l_cd = g.rent_l_cd and a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd  \n" +
				"  and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = f.rent_mng_id and f.rent_st = '1'    and c.gov_id = cd.code(+)  \n " +
				"  and a.doc_id= ? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			rs = pstmt.executeQuery();
			
			while(rs.next())
			{
				FineDocListBean bean = new FineDocListBean();	
				bean.setDoc_id(rs.getString("DOC_ID")==null?"":rs.getString("DOC_ID"));
				bean.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				bean.setAmt1(rs.getString("amt1")==null?0:Integer.parseInt(rs.getString("amt1")));
				bean.setAmt2(rs.getString("amt2")==null?0:Integer.parseInt(rs.getString("amt2")));
				bean.setAmt3(rs.getString("amt3")==null?0:Integer.parseInt(rs.getString("amt3")));
				bean.setAmt4(rs.getString("amt4")==null?0:Integer.parseInt(rs.getString("amt4")));
				bean.setAmt5(rs.getString("amt5")==null?0:Integer.parseInt(rs.getString("amt5")));
				bean.setAmt7(rs.getString("amt7")==null?0:Integer.parseInt(rs.getString("amt7")));
				bean.setAmt6(rs.getString("amt6")==null?0:Integer.parseInt(rs.getString("amt6")));
				bean.setAmt8(rs.getString("amt8")==null?0:Integer.parseInt(rs.getString("amt8"))); // ���ź����� �߰� - 2021-04
				bean.setServ_off_nm(rs.getString("nm")==null?"":rs.getString("nm"));
				bean.setCar_mng_id(rs.getString("car_mng_id")==null?"":rs.getString("car_mng_id"));
				bean.setFee_st(rs.getString("fund_yn")==null?"":rs.getString("fund_yn"));  //�����ڱݿ���
			
				vt.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
		  	System.out.println("[FineDocDatabase:getBankDocAllLists3]\n"+e);
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
	
	
	
	//�����û���� ����Ʈ��ȸ : ������ - cms ����°� �����Ҷ� 
	public Vector getMemberCmsList(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		
		query = " SELECT a.doc_id, a.rent_mng_id, a.rent_l_cd,  nvl(g.cms_code, '9951572587' ) cms_code,  u.ama_id, i.ama_id , cm.cms_start_dt " +
				"  FROM fine_doc_list a, fine_doc c, allot g  , cms.member_user u , cms_info i , cms_mng cm  "+
				" WHERE a.doc_id =c.doc_id  and  a.rent_mng_id = g.rent_mng_id  and a.rent_l_cd = g.rent_l_cd " +
				"   and  a.rent_mng_id = cm.rent_mng_id and a.rent_l_cd = cm.rent_l_cd  \n" + 
				"  and a.rent_l_cd = u.cms_primary_seq(+)  " + 
				"  and a.doc_id= ?  and u.ama_id is not null   and  nvl(g.cms_code, '9951572587' ) = i.org_code and i.ama_id <> u.ama_id  order by cm.cms_start_dt  ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
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
			System.out.println("[FineDocDatabase:getMemberCmsList]\n"+e);
			System.out.println("[FineDocDatabase:getMemberCmsList]\n"+query);
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
	
	//fee max
	public String getMaxRentSt(String rent_l_cd)
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String rent_st = "";

		query = "select rent_l_cd, max(to_number(rent_st)) rent_st from fee  where rent_l_cd = ? group by rent_l_cd ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_l_cd);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				rent_st = rs.getString(2);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getMaxRentSt]\n"+e);
			System.out.println("[FineDocDatabase:getMaxRentSt]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rent_st;
		}				
	}



//20090611 - Ryu Gill Sun	
//���·� ���ǽ�û����������� ��ȸ
	public Vector getFineGovList(String id_st, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt_query = "";
		String dt = "a.doc_dt";//��������

		//������ȸ
		if(gubun2.equals("1"))		dt_query = " and "+dt+"=to_char(sysdate-2,'YYYYMMDD')";
		if(gubun2.equals("2"))		dt_query = " and "+dt+"=to_char(sysdate-1,'YYYYMMDD')";
		if(gubun2.equals("3"))		dt_query = " and "+dt+"=to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("4"))		dt_query = " and substr("+dt+",1,6)=to_char(sysdate,'YYYYMM')";
		if(gubun2.equals("5"))		dt_query = " and "+dt+" between replace(nvl('"+st_dt+"','00000000'), '-', '') and replace(nvl('"+end_dt+"','99999999'), '-', '')";

	
		query = " select x.gov_nm, x.mng_dept, x.zip, x.addr, x.tel " +
				" from fine_gov x, "+
				" (SELECT"+
				" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
				" b.gov_nm, c.cnt"+
				" from fine_doc a, fine_gov b, (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
				" where"+
				" a.gov_id=b.gov_id and a.doc_id=c.doc_id and a.doc_id like '%����%'"+dt_query +" )z "+
				" where x.gov_id = z.gov_id ";
		query += " ORDER BY z.doc_id desc";
				if(!gubun1.equals(""))		query += " and b.gov_id='"+gubun1+"'";



			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select"+ 
						" DISTINCT "+
						" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.print_dt, a.reg_id, a.reg_dt, a.upd_id, a.upd_dt, a.gov_st, a.mng_nm, a.mng_pos, a.h_mng_id, a.b_mng_id, a.app_doc3, a.app_doc1, a.app_doc2, a.app_doc4, a.print_id,"+
						" b.gov_nm, j.cnt, b.zip, b.addr, b.mng_dept, b.tel"+ 
						" from fine_doc a, fine_gov b, fine_doc_list c, fine d, cont e, client f, rent_cont g, rent_cust h, car_reg i,"+ 
						" (select doc_id, count(*) cnt from fine_doc_list group by doc_id) j, users l"+ 
						" where "+ 
						" a.gov_id=b.gov_id"+ 
						" and a.doc_id=c.doc_id and a.doc_id like '%����%'"+dt_query + 
						" and c.car_mng_id=d.car_mng_id and c.seq_no=d.seq_no and c.rent_mng_id=d.rent_mng_id and c.rent_l_cd=d.rent_l_cd"+ 
						" and c.rent_mng_id=e.rent_mng_id and c.rent_l_cd=e.rent_l_cd"+ 
						" and e.client_id=f.client_id"+ 
						" and c.rent_s_cd=g.rent_s_cd(+)"+ 
						" and g.cust_id=h.cust_id(+)"+ 
						" and c.car_mng_id=i.car_mng_id"+ 
						" and a.doc_id=j.doc_id"+
						" and a.reg_id=l.user_id"+
						" ";

				if(s_kd.equals("1"))	query += " and nvl(f.firm_nm,f.client_nm)||h.cust_nm like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and i.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and d.paid_no like '%"+t_wd+"%'";
				if(s_kd.equals("4"))	query += " and d.vio_dt like '%"+t_wd+"%'";
				if(s_kd.equals("5"))	query += " and l.user_nm like '%"+t_wd+"%'";

		query += " ORDER BY a.doc_id desc";
			}
		

		try {
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();
		   	
//	System.out.println("getFineGovList="+query);

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
			System.out.println("[FineDocDatabase:getFineGovList]\n"+e);
			System.out.println("[FineDocDatabase:getFineGovList]\n"+query);
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
	
//�ְ� �������� ��ȸ
	public Vector getFineGovList2(String id_st, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt_query = "";
		String dt = "a.doc_dt";//��������

		//������ȸ
		if(gubun2.equals("1"))		dt_query = " and "+dt+"=to_char(sysdate-2,'YYYYMMDD')";
		if(gubun2.equals("2"))		dt_query = " and "+dt+"=to_char(sysdate-1,'YYYYMMDD')";
		if(gubun2.equals("3"))		dt_query = " and "+dt+"=to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("4"))		dt_query = " and substr("+dt+",1,6)=to_char(sysdate,'YYYYMM')";
		if(gubun2.equals("5"))		dt_query = " and "+dt+" between replace(nvl('"+st_dt+"','00000000'), '-', '') and replace(nvl('"+end_dt+"','99999999'), '-', '')";

	
		query = " SELECT"+
					" a.doc_id, a.doc_dt, a.gov_id, a.mng_dept, a.GOV_NM, a.GOV_ADDR addr, c.cnt, decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+
					" from fine_doc a, client b, (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					" a.gov_id=b.client_id and a.doc_id=c.doc_id(+)  and a.doc_id like '%ä���߽�%'"+dt_query;


			//�˻�� ������...
			if(!t_wd.equals("")){
				query = " select"+ 
						" DISTINCT  a.*, j.cnt, decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+ 
						" from fine_doc a, client b, fine_doc_list c, "+ 
						" (select doc_id, count(*) cnt from fine_doc_list group by doc_id) j"+ 
						" where "+ 
						" a.gov_id=b.client_id"+ 
						" and a.doc_id=c.doc_id(+)"+ 
						" and a.doc_id=j.doc_id(+)";

				if(s_kd.equals("1"))	query += " and a.gov_nm = '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and c.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and c.rent_l_cd like '%"+t_wd+"%'";

			}
	
		try {
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();
		   	
//	System.out.println("getFineGovList2="+query);

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
			System.out.println("[FineDocDatabase:getFineGovList2]\n"+e);
			System.out.println("[FineDocDatabase:getFineGovList2]\n"+query);
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
	 *	���·���� ����Ʈ �Ѱ� ����
	 */

	public boolean updateFineListCase(FineDocListBean fl)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;

		String query = " update fine_doc_list set "+
						" FIRM_NM		= ?, "+
						" SSN			= replace(?,'-',''), "+
						" ENP_NO		= replace(?,'-',''), "+
						" RENT_START_DT = replace(?,'-',''), "+
						" RENT_END_DT	= replace(?,'-',''), "+
						" PAID_NO		= ?, "+
						" CAR_NO		= ?, "+
						" LIC_NO		= ?  "+		//���������ȣ �߰�(20180828)
						" where DOC_ID = ? and CAR_MNG_ID = ? and SEQ_NO = ?";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fl.getFirm_nm		());
			pstmt.setString(2, fl.getSsn			());
			pstmt.setString(3, fl.getEnp_no			());
		    pstmt.setString(4, fl.getRent_start_dt	());
		    pstmt.setString(5, fl.getRent_end_dt	());
			pstmt.setString(6, fl.getPaid_no		());
			pstmt.setString(7, fl.getCar_no			());
			pstmt.setString(8, fl.getLic_no			());	//���������ȣ �߰�(20180828)
			pstmt.setString(9, fl.getDoc_id 		());				
			pstmt.setString(10, fl.getCar_mng_id	());
			pstmt.setInt   (11, fl.getSeq_no		());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[FineDocDatabase:updateFineListCase]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	/**
	 *	���·���� ����Ʈ �Ѱ� ����
	 */

	public boolean deleteFineListCase(FineDocListBean fl)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;

		String query = " delete from fine_doc_list "+
						" where DOC_ID = ? and CAR_MNG_ID = ? and SEQ_NO = ?";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fl.getDoc_id 		());				
			pstmt.setString(2, fl.getCar_mng_id		());
			pstmt.setInt   (3, fl.getSeq_no			());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[FineDocDatabase:deleteFineListCase]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	


	//�����û �� ���� ��Ͻ� �ش� ���� ����
	
	public boolean updateFineDocListCar()
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
		
		
		query = "update fine_doc_list a set  (a.car_mng_id)  = ( select b.car_mng_id from cont b where a.rent_l_cd = b.rent_l_cd and a.car_mng_ID = '0' and b.car_mng_id is not null ) "+
             	" where exists (select 'x' from  cont b where a.rent_l_cd = b.rent_l_cd and a.car_mng_ID = '0' and b.car_mng_id is not null )";

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}
		catch (Exception e)
	  	{
		  	System.out.println("[FineDocDatabase:updateFineDocListCar]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
/**
     * ��ĵ���ϸ���Ʈ
     */
	public Vector getFind_scan(String rent_mng_id, String rent_l_cd){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " SELECT RENT_MNG_ID, RENT_L_CD, FILE_ST, FILE_TYPE, MAX(SEQ) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) SEQ "+
						" ,MAX(FILE_NAME) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) FILE_NAME "+
						" ,MAX(FILE_PATH) KEEP(DENSE_RANK LAST ORDER BY FILE_PATH) FILE_PATH "+
						" ,MAX(REG_ID) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) REG_ID "+
						" ,MAX(REG_DT) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) REG_DT "+
						" FROM LC_SCAN WHERE rent_mng_id = '"+rent_mng_id+"'  AND rent_l_cd = '"+rent_l_cd+"' "+
						" AND file_st IN ( '17', '18', '2', '4' ) GROUP BY RENT_MNG_ID, RENT_L_CD, FILE_ST, FILE_TYPE ";

//System.out.println("getFind_scan:: "+query);

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
			System.out.println("[FineDocDatabase:getFind_scan]\n"+e);
			System.out.println("[FineDocDatabase:getFind_scan]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}	

	/**
     * ��ĵ���ϸ���Ʈ
     */
	public Vector getFind_scan(String rent_mng_id, String rent_l_cd, String client_id, String rent_s_cd){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
//		String query = "  SELECT * FROM LC_SCAN where rent_mng_id = '"+rent_mng_id+"' and rent_l_cd = '"+rent_l_cd+"' and file_st in ('17','18','2','4') ";
/*
		String query = " SELECT RENT_MNG_ID, RENT_L_CD, FILE_ST, FILE_TYPE, MAX(SEQ) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) SEQ "+
						" ,MAX(FILE_NAME) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) FILE_NAME "+
						" ,MAX(FILE_PATH) KEEP(DENSE_RANK LAST ORDER BY FILE_PATH) FILE_PATH "+
						" ,MAX(REG_ID) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) REG_ID "+
						" ,MAX(REG_DT) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) REG_DT "+
						" FROM LC_SCAN WHERE rent_mng_id = '"+rent_mng_id+"'  AND rent_l_cd = '"+rent_l_cd+"' "+
						" AND file_st IN ( '17', '18', '2', '4' ) GROUP BY RENT_MNG_ID, RENT_L_CD, FILE_ST, FILE_TYPE ";
*/
		String query =  " "+
						" SELECT '' rent_mng_id, RENT_S_CD rent_l_cd, FILE_ST, FILE_TYPE,  \n"+
						" MAX(SEQ) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) SEQ ,  \n"+
						" MAX(RENT_ST) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) RENT_ST ,  \n"+
						" MAX(FILE_NAME) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) FILE_NAME ,  \n"+
						" MAX(FILE_PATH) KEEP(DENSE_RANK LAST ORDER BY FILE_PATH) FILE_PATH ,  \n"+
						" MAX(REG_ID) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) REG_ID ,  \n"+
						" MAX(REG_DT) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) REG_DT  \n"+
						" FROM sc_scan  \n"+
						" WHERE  rent_s_cd = '"+rent_s_cd+"' AND file_st IN ( '17', '18','4' )  \n"+
						" GROUP BY rent_s_cd, FILE_ST, FILE_TYPE UNION all \n"+
						//�뿩�����İ�༭ JPG
						" SELECT RENT_MNG_ID, RENT_L_CD, FILE_ST, FILE_TYPE,  \n"+
						"        MAX(SEQ)       KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) SEQ ,  \n"+
						"        MAX(RENT_ST)       KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) RENT_ST ,  \n"+
						"        MAX(FILE_NAME) KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) FILE_NAME ,  \n"+
						"        MAX(FILE_PATH) KEEP(DENSE_RANK LAST ORDER BY FILE_PATH) FILE_PATH ,  \n"+
						"        MAX(REG_ID)    KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) REG_ID ,  \n"+
						"        MAX(REG_DT)    KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) REG_DT  \n"+
						" FROM   LC_SCAN  \n"+
						" WHERE  rent_mng_id = '"+rent_mng_id+"' AND rent_l_cd = '"+rent_l_cd+"' AND file_st IN ( '17', '18' )  \n"+
						" GROUP BY RENT_MNG_ID, RENT_L_CD, FILE_ST, FILE_TYPE  \n"+
						//����ڵ���� JPG - ���λ���
						" UNION ALL \n"+
						" SELECT a.RENT_MNG_ID, a.RENT_L_CD, a.FILE_ST, a.FILE_TYPE,  \n"+
						"        MAX(a.SEQ)       KEEP(DENSE_RANK LAST ORDER BY a.FILE_NAME) SEQ ,  \n"+
						"        MAX(a.RENT_ST)       KEEP(DENSE_RANK LAST ORDER BY a.FILE_NAME) RENT_ST ,  \n"+
						"        MAX(a.FILE_NAME) KEEP(DENSE_RANK LAST ORDER BY a.FILE_NAME) FILE_NAME ,  \n"+
						"        MAX(a.FILE_PATH) KEEP(DENSE_RANK LAST ORDER BY a.FILE_PATH) FILE_PATH ,  \n"+
						"        MAX(a.REG_ID)    KEEP(DENSE_RANK LAST ORDER BY a.FILE_NAME) REG_ID ,  \n"+
						"        MAX(a.REG_DT)    KEEP(DENSE_RANK LAST ORDER BY a.FILE_NAME) REG_DT  \n"+
						" FROM   lc_scan a, cont b ,  \n"+
						"        ( SELECT MAX(a.reg_dt||a.file_name||a.rent_mng_id) AS seq \n"+
						"	       FROM   lc_scan a, cont b  \n"+
						"          WHERE  a.file_st = '2' AND b.client_id='"+client_id+"' AND a.rent_mng_id=b.rent_mng_id  AND a.rent_l_cd=b.rent_l_cd \n"+
						"	     ) c, client d  \n"+
						" WHERE  a.file_st IN ('2') AND b.client_id='"+client_id+"'  \n"+
						"	     AND a.rent_mng_id=b.rent_mng_id  AND a.rent_l_cd=b.rent_l_cd  AND a.reg_dt||a.file_name||a.rent_mng_id=c.seq \n"+
						"	     and b.client_id=d.client_id and d.client_st not in ('2') \n"+
						" GROUP BY a.RENT_MNG_ID,  a.RENT_L_CD,  a.FILE_ST, a.FILE_TYPE,  a.file_name,  a.FILE_PATH, a.REG_ID,  a.REG_DT   \n"+
                        //�ź��� JPG - ���θ� �ʿ�
						" UNION ALL \n"+
						" SELECT a.RENT_MNG_ID, a.RENT_L_CD, a.FILE_ST, a.FILE_TYPE,  \n"+
						"        MAX(a.SEQ)       KEEP(DENSE_RANK LAST ORDER BY a.FILE_NAME) SEQ ,  \n"+
						"        MAX(a.RENT_ST)       KEEP(DENSE_RANK LAST ORDER BY a.FILE_NAME) RENT_ST ,  \n"+
						"        MAX(a.FILE_NAME) KEEP(DENSE_RANK LAST ORDER BY a.FILE_NAME) FILE_NAME ,  \n"+
						"        MAX(a.FILE_PATH) KEEP(DENSE_RANK LAST ORDER BY a.FILE_PATH) FILE_PATH ,  \n"+
						"        MAX(a.REG_ID)    KEEP(DENSE_RANK LAST ORDER BY a.FILE_NAME) REG_ID ,  \n"+
						"        MAX(a.REG_DT)    KEEP(DENSE_RANK LAST ORDER BY a.FILE_NAME) REG_DT  \n"+
						" FROM   lc_scan a, cont b ,  \n"+
						"        ( SELECT MAX(a.reg_dt||a.file_name||a.rent_mng_id) AS seq \n"+
						"	       FROM   lc_scan a, cont b  \n"+
						"          WHERE  a.file_st = '4' AND b.client_id='"+client_id+"' AND a.rent_mng_id=b.rent_mng_id  AND a.rent_l_cd=b.rent_l_cd \n"+
						"	     ) c , client d \n"+
						" WHERE  a.file_st IN ('4')  AND b.client_id='"+client_id+"' \n"+
						"	     AND a.rent_mng_id=b.rent_mng_id  AND a.rent_l_cd=b.rent_l_cd AND a.reg_dt||a.file_name||a.rent_mng_id = c.seq \n"+
						"	     AND b.CLIENT_ID = d.client_id  and d.client_st in ('2') \n"+
						" GROUP BY a.RENT_MNG_ID,  a.RENT_L_CD,  a.FILE_ST, a.FILE_TYPE,  a.file_name,  a.FILE_PATH, a.REG_ID,  a.REG_DT   \n";       
	
//System.out.println("getFind_scan:: "+query);

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
			System.out.println("[FineDocDatabase:getFind_scan]\n"+e);
			System.out.println("[FineDocDatabase:getFind_scan]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}	


//�ְ��� ��/������ ����Ʈ : ������  -rgs
	public Vector getMyAccidDocLists_2(String doc_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT  e.client_st,p.FILENAME, b.ACCID_CONT2, e.CLIENT_NM, e.O_ADDR, e.O_ZIP, e.ENP_NO, TEXT_DECRYPT(e.ssn, 'pw' )  SSN, a.doc_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, c.CAR_NO as our_car_no, m.car_no, m.car_nm, a.firm_nm, a.rent_start_dt, a.rent_end_dt, a.amt1, a.amt2, a.amt1-a.amt2 as amt3, a.amt4, a.amt5, a.var1, m.ins_tel, m.ins_nm, m.ins_com, decode(b.accid_st, '1','����','2','����','3','�ֹ�','8','�ܵ�','��Ÿ') as accid_st, B.ACCID_DT, b.accid_id , m.seq_no, "+
               "   v.rent_dt2, v.rent_start_dt v_rent_start_dt , v.rent_end_dt v_rent_end_dt , v.con_mon  , f.grt_amt_s grt_amt , f.fee_s_amt + f.fee_v_amt fee_amt ,  C.CAR_NM AS our_car_nm,   cn.car_name , "+ 
               " m.use_st, m.use_et, m.day_amt, m.use_day , m.ins_num,  nvl(m.use_hour, '0') use_hour,  m.ot_fault_per   "+ 
				" FROM  PIC_RESRENT_ACCID p, fine_doc_list a, my_accid m, ACCIDENT B , car_reg c, cont_n_view v , fee f ,  car_etc g, car_nm cn, client e \n"+
				" WHERE  a.doc_id='"+doc_id+"' and a.car_mng_id  = m.car_mng_id(+) and b.CAR_MNG_ID = c.CAR_MNG_ID(+) and m.ACCID_ID = b.ACCID_ID(+) and a.car_no = m.accid_id(+) and a.paid_no = m.seq_no(+)"+
				" and a.rent_mng_id = v.rent_mng_id and a.rent_l_cd  = v.rent_l_cd and v.rent_mng_id = f.rent_mng_id and v.rent_l_cd = f.rent_l_cd and v.fee_rent_st = f.rent_st "  +
				"	and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+) AND m.CAR_MNG_ID = p.CAR_MNG_ID(+) AND m.ACCID_ID = p.ACCID_ID (+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  and v.client_id = e.client_id"+
				" order by  m.OT_FAULT_PER desc, B.accid_dt";


//System.out.println("getMyAccidDocLists_2::: "+query);
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
			System.out.println("[FineDocDatabase:getMyAccidDocLists_2]"+e);
			System.out.println("[FineDocDatabase:getMyAccidDocLists_2]"+query);
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


//���·� ���ǽ�û���� ������ȣ�� ���� SEQ_NO �������� ��������.
	public int Seq_no_Next(String doc_id)
	{
		getConnection();

		FineDocBean bean = new FineDocBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int count = 0;

		query = " SELECT max(seq_no) as SEQ_NO FROM FINE_DOC_LIST where  doc_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:Seq_no_Next]\n"+e);
			System.out.println("[FineDocDatabase:Seq_no_Next]\n"+query);
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
	 *	�����Ƿ� 1�� ����
	 */

	public int bank_doc_list_del(FineDocListBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " DELETE  FROM FINE_DOC_LIST \n"+
				" where doc_id=? and rent_l_cd = ? ";		

		try 
		{	
			conn.setAutoCommit(false);		
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getDoc_id());
			pstmt.setString(2, bean.getRent_l_cd());


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:bank_doc_list_del]\n"+e);
			System.out.println("[FineDocDatabase:bank_doc_list_del]\n"+query);
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


	public Hashtable getFineGovList(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();
	
		query = " select b.gov_nm, b.zip, b.addr, b.mng_dept" + 
						" from fine_doc a, fine_gov b "+ 
						" where a.gov_id=b.gov_id"+ 
				     	" and a.doc_id = '"+doc_id+"'";
		

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineGovList]\n"+e);
			System.out.println("[FineDocDatabase:getFineGovList]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	

	}


	/**
     * ������� ��༭ ��ĵ���ϸ���Ʈ
     */
	public Vector getBank_scan(String car_mng_id, String rent_l_cd, String chk){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		if ( chk.equals("1")) {
			query =  "  SELECT a.* FROM LC_SCAN a, cont b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.car_mng_id = '"+car_mng_id+"' and b.rent_l_cd = '"+rent_l_cd+"' and a.file_st in ('17','18') ";
		} else if ( chk.equals("2")) {
			query =  "  SELECT a.* FROM LC_SCAN a, cont b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.car_mng_id = '"+car_mng_id+"' and b.rent_l_cd = '"+rent_l_cd+"' and a.file_st in ('10') ";
		} else if ( chk.equals("3")) {	
			query = "  SELECT a.* FROM car_change a, cont b WHERE a.car_mng_id = b.car_mng_id and b.car_mng_id = '"+car_mng_id+"'  ";
		} 
		
//System.out.println("getBank_scan:: "+query);

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
			System.out.println("[FineDocDatabase:getBank_scan]\n"+e);
			System.out.println("[FineDocDatabase:getBank_scan]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}	


/**
     * ������� ��༭ ��ĵ���ϸ���Ʈ
     */
	public Vector getBank_scan2(String car_mng_id, String rent_l_cd){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "  SELECT a.* FROM LC_SCAN a, cont b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.car_mng_id = '"+car_mng_id+"' and b.rent_l_cd = '"+rent_l_cd+"' and a.file_st in ('17','18','2','4') ";

//System.out.println("getBank_scan:: "+query);

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
			System.out.println("[FineDocDatabase:getBank_scan]\n"+e);
			System.out.println("[FineDocDatabase:getBank_scan]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}

	//���·� ���ǽ�û���� ���·� ����Ʈ��ȸ : ������
	public Vector getAccidMyDocLists(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.* "+
				" FROM fine_doc_list a"+
			 	" WHERE a.doc_id=? "+
				"       order by a.seq_no "; 									



//	System.out.println("getFineDocLists:::"+query);
		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				FineDocListBean bean = new FineDocListBean();
				bean.setDoc_id 			(rs.getString("DOC_ID"));
				bean.setCar_mng_id		(rs.getString("CAR_MNG_ID"));
				bean.setSeq_no			(rs.getInt("SEQ_NO"));
				bean.setRent_mng_id		(rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd		(rs.getString("RENT_L_CD"));
				bean.setRent_s_cd		(rs.getString("RENT_S_CD"));
				bean.setFirm_nm			(rs.getString("FIRM_NM"));
				bean.setSsn				(rs.getString("SSN"));
				bean.setEnp_no			(rs.getString("ENP_NO"));
				bean.setRent_start_dt	(rs.getString("RENT_START_DT"));	
				bean.setRent_end_dt		(rs.getString("RENT_END_DT"));	
				bean.setPaid_no			(rs.getString("PAID_NO"));
				bean.setReg_id			(rs.getString("REG_ID"));
				bean.setReg_dt			(rs.getString("REG_DT"));
				bean.setUpd_id			(rs.getString("UPD_ID"));
				bean.setUpd_dt			(rs.getString("UPD_DT"));
				bean.setCar_no			(rs.getString("CAR_NO"));
				bean.setVar1			(rs.getString("VAR1"));
				bean.setVar2			(rs.getString("VAR2"));
				bean.setVar3			(rs.getString("VAR3"));
				bean.setAmt1			(rs.getInt("AMT1"));
				bean.setAmt2			(rs.getInt("AMT2"));
				bean.setAmt3			(rs.getInt("AMT3"));				
				vt.add(bean);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getAccidMyDocLists]\n"+e);
			System.out.println("[FineDocDatabase:getAccidMyDocLists]\n"+query);
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

	//���·� ���ǽ�û���� ���·� �Ѱ� ��ȸ
	public FineDocListBean getAccidMyDocList(String doc_id, String car_mng_id, String seq_no)
	{
		getConnection();

		FineDocListBean bean = new FineDocListBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.*"+
				" FROM fine_doc_list a "+
				" WHERE a.doc_id=? and a.car_mng_id=? and a.seq_no=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			pstmt.setString(2, car_mng_id);
			pstmt.setString(3, seq_no);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setDoc_id 			(rs.getString(1));
				bean.setCar_mng_id		(rs.getString(2));
				bean.setSeq_no			(rs.getInt(3));
				bean.setRent_mng_id		(rs.getString(4));
				bean.setRent_l_cd		(rs.getString(5));
				bean.setRent_s_cd		(rs.getString(6));
				bean.setFirm_nm			(rs.getString(7));
				bean.setSsn				(rs.getString(8));
				bean.setEnp_no			(rs.getString(9));
				bean.setRent_start_dt	(rs.getString(10));	
				bean.setRent_end_dt		(rs.getString(11));	
				bean.setPaid_no			(rs.getString(12));
				bean.setReg_id			(rs.getString(13));
				bean.setReg_dt			(rs.getString(14));
				bean.setUpd_id			(rs.getString(15));
				bean.setUpd_dt			(rs.getString(16));
				bean.setCar_no			(rs.getString(17));
				bean.setAmt1			(rs.getInt(18));
				bean.setAmt2			(rs.getInt(19));
				bean.setAmt3			(rs.getInt(20));
				bean.setAmt4			(rs.getInt(21));
				bean.setAmt5			(rs.getInt(22));
				bean.setAmt6			(rs.getInt(23));
				bean.setAmt7			(rs.getInt(24));
				bean.setVar1			(rs.getString(25));
				bean.setVar2			(rs.getString(26));
				bean.setVar3			(rs.getString(27));
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getAccidMyDocList]\n"+e);
			System.out.println("[FineDocDatabase:getAccidMyDocList]\n"+query);
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
	 *	���·���� ����Ʈ �Ѱ� ����
	 */
	public boolean updateAccidMyDocListCase(FineDocListBean fl)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;

		String query = " update fine_doc_list set "+
						" FIRM_NM		= ?, "+
						" SSN			= replace(?,'-',''), "+
						" ENP_NO		= replace(?,'-',''), "+
						" RENT_START_DT = replace(?,'-',''), "+
						" RENT_END_DT	= replace(?,'-',''), "+
						" PAID_NO		= ?,  "+
						" CAR_NO		= ?,  "+
						" VAR3			= ?,  "+
						" VAR2			= ?,  "+
						" AMT1			= ?   "+
						" where DOC_ID = ? and CAR_MNG_ID = ? and SEQ_NO = ?";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,	fl.getFirm_nm		());
			pstmt.setString(2,	fl.getSsn			());
			pstmt.setString(3,	fl.getEnp_no		());
		    pstmt.setString(4,	fl.getRent_start_dt	());
		    pstmt.setString(5,	fl.getRent_end_dt	());
			pstmt.setString(6,	fl.getPaid_no		());
			pstmt.setString(7,	fl.getCar_no		());
			pstmt.setString(8,	fl.getVar3			());
			pstmt.setString(9,	fl.getVar2			());
			pstmt.setInt   (10,	fl.getAmt1			());
			pstmt.setString(11, fl.getDoc_id 		());				
			pstmt.setString(12, fl.getCar_mng_id	());
			pstmt.setInt   (13, fl.getSeq_no		());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[FineDocDatabase:updateAccidMyDocListCase]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	


//����ó������
	public void upregyn(String doc_id, String yn)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " update fine_doc set regyn=? where doc_id=?";

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		yn.trim()	 );
			pstmt.setString	(2,		doc_id.trim()	 );
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		
		 }catch(Exception se){
           try{
				System.out.println("[FineDocDatabase:regyn]"+se);
				System.out.println("[FineDocDatabase:regyn]"+query);
				se.printStackTrace();
				flag = false;
                conn.rollback();
            }catch(SQLException _ignored){}
       
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
		}
	}

	//�㺸 ����,��������
	public void upcltr_chk(String doc_id, String cltr_chk)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " update fine_doc set cltr_chk=? where doc_id=?";

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		cltr_chk.trim()	 );
			pstmt.setString	(2,		doc_id.trim()	 );
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		
		 }catch(Exception se){
           try{
				System.out.println("[FineDocDatabase:upcltr_chk]"+se);
				System.out.println("[FineDocDatabase:upcltr_chk]"+query);
				se.printStackTrace();
				flag = false;
                conn.rollback();
            }catch(SQLException _ignored){}
       
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
		}
	}

	/**
	 *	���·���� ����Ʈ �Ѱ� ����
	 */
	public boolean updateFineDocCms(String doc_id, String cms_code)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;

		String query = " update fine_doc set cms_code = ? where  DOC_ID = ? ";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		cms_code.trim()	 );
			pstmt.setString	(2,		doc_id.trim()	 );
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[FineDocDatabase:updateFineDocCms]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	
	/**
     * ������� ��������� ��ĵ���ϸ���Ʈ
     */
	public Vector getBank_scanreg(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		
		String query = "  SELECT a.* FROM car_change a, cont b WHERE a.car_mng_id = b.car_mng_id and b.car_mng_id = '"+car_mng_id+"'  ";

//System.out.println("getBank_scanreg:: "+query);

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
			System.out.println("[getBank_scanreg:getBank_scan]\n"+e);
			System.out.println("[getBank_scanreg:getBank_scan]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}	


	//������Ǽ������ �������  = �߽����� 
	public void changeReq_dt(String doc_id, String user_id, int amt1, int amt2)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " update fine_doc set req_dt=to_char(sysdate,'YYYYMMDD'), amt1 = ?, amt2 = ? where doc_id=?";

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setInt	(1,		amt1	 );
			pstmt.setInt	(2,		amt2	 );
			pstmt.setString	(3,		doc_id.trim()	 );
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		
		 }catch(Exception se){
           try{
				System.out.println("[FineDocDatabase:changeReq_dt]"+se);
				se.printStackTrace();
				flag = false;
                conn.rollback();
            }catch(SQLException _ignored){}
       
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
		}
	}

//������Ǽ������ �������  = �Ա����� 

public int updateIp_dt(String doc_id, String ip_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " update fine_doc set ip_dt=replace('"+ip_dt+"','-','') where doc_id='"+doc_id+"' ";

		try 
		{	
			conn.setAutoCommit(false);		
		
			pstmt = conn.prepareStatement(query);

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:updateIp_dt]\n"+e);
			System.out.println("[FineDocDatabase:updateIp_dt]\n"+query);
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



//���·� û���� ��ĵ����
public Hashtable getFind_file(String doc_id, String m_id, String l_cd, String c_id, String vio_dt)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();
	
		query = " SELECT a.doc_id, a.rent_mng_id, a.rent_l_cd, nvl(a.car_no,b.car_no) AS CAR_NO2, d.scan_file, c.vio_dt, d.car_st, NVL(c.file_name,aaf.FILE_NAME) FILE_NAME, NVL(c.file_type,aaf.FILE_TYPE) FILE_TYPE,  nvl(a.rent_s_cd,c.rent_s_cd) rent_s_cd2, d.client_id, aaf.SEQ, aaf.SAVE_FOLDER, aaf.SAVE_FILE "+
				" FROM fine_doc_list a, car_reg b, fine c, cont d , car_pur p, (SELECT * FROM ACAR_ATTACH_FILE WHERE ISDELETED = 'N' ) aaf "+
			 	" WHERE a.car_mng_id=b.car_mng_id /* AND aaf.ISDELETED = 'N' */ "+
				"       and a.car_mng_id=c.car_mng_id(+) and a.seq_no=c.seq_no(+) and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
				"       and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd  AND a.rent_mng_id = p.rent_mng_id AND a.rent_l_cd = p.rent_l_cd AND c.RENT_MNG_ID||c.RENT_L_CD||c.CAR_MNG_ID||c.SEQ_NO||'1' = aaf.CONTENT_SEQ(+)  "+
				"       and a.doc_id='"+doc_id+"' and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'  and d.client_id='"+c_id+"' and c.vio_dt = '"+vio_dt+"' "; 									
		
		query += " ORDER BY nvl(c.reg_code,substr(b.car_no,length(b.car_no)-3,4)), p.dlv_est_dt, d.RENT_L_CD";//c.rec_dt desc		

//System.out.println("[FineDocDatabase:getFind_file]\n"+query);

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFind_file]\n"+e);
			System.out.println("[FineDocDatabase:getFind_file]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	

	}

//���·� û���� ��ĵ����
public Hashtable getFind_file6(String doc_id, String m_id, String l_cd, String c_id, String vio_dt)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();
	
		query = " SELECT a.doc_id, a.rent_mng_id, a.rent_l_cd, nvl(a.car_no,b.car_no) AS CAR_NO2, d.scan_file, c.vio_dt, d.car_st, NVL(c.file_name,aaf.FILE_NAME) FILE_NAME, NVL(c.file_type,aaf.FILE_TYPE) FILE_TYPE,  nvl(a.rent_s_cd,c.rent_s_cd) rent_s_cd2, d.client_id, nvl(rc.cust_id,'') cust_id,  aaf.SEQ, aaf.SAVE_FOLDER, aaf.SAVE_FILE "+
				" FROM fine_doc_list a, car_reg b, fine c, cont d , car_pur p , rent_cont rc , "+
				" (SELECT a.* FROM ACAR_ATTACH_FILE a, (SELECT MAX(seq) AS seq FROM ACAR_ATTACH_FILE WHERE ISDELETED='N' and content_code = 'FINE' and content_seq like '"+m_id+l_cd+"%') b WHERE a.seq = b.seq and a.content_code = 'FINE' ) aaf  "+
			 	" WHERE a.car_mng_id=b.car_mng_id "+
				"       and a.car_mng_id=c.car_mng_id(+) and a.seq_no=c.seq_no(+) and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
				"       and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd  AND a.rent_mng_id = p.rent_mng_id AND a.rent_l_cd = p.rent_l_cd  AND a.rent_s_cd = rc.RENT_S_CD(+) AND c.RENT_MNG_ID||c.RENT_L_CD||c.CAR_MNG_ID||c.SEQ_NO||'1' = aaf.CONTENT_SEQ(+) "+
				"       and a.doc_id='"+doc_id+"' and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'  and d.client_id='"+c_id+"' and c.vio_dt = '"+vio_dt+"' /*order by p.dlv_est_dt, d.RENT_L_CD */"; 									
		
		query += " ORDER BY nvl(c.reg_code,substr(b.car_no,length(b.car_no)-3,4)), p.dlv_est_dt, d.RENT_L_CD";//c.rec_dt desc		

	//System.out.println("[FineDocDatabase:getFind_file6]\n"+query);			

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFind_file6]\n"+e);
			System.out.println("[FineDocDatabase:getFind_file6]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	

	}
	
	
	//���·� û���� ��ĵ����
public Hashtable getFind_file6(String doc_id, String m_id, String l_cd, String c_id, String vio_dt, String car_mng_id, int seq_no)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();
	
		query = " SELECT a.doc_id, a.rent_mng_id, a.rent_l_cd, nvl(a.car_no,b.car_no) AS CAR_NO2, d.scan_file, c.vio_dt, d.car_st, NVL(c.file_name,aaf.FILE_NAME) FILE_NAME, NVL(c.file_type,aaf.FILE_TYPE) FILE_TYPE,  nvl(a.rent_s_cd,c.rent_s_cd) rent_s_cd2, d.client_id, rc.cust_id, aaf.SEQ, aaf.SAVE_FOLDER, aaf.SAVE_FILE "+
				" FROM fine_doc_list a, car_reg b, fine c, cont d , car_pur p , rent_cont rc , "+
				" (SELECT a.* FROM ACAR_ATTACH_FILE a, (SELECT MAX(seq) AS seq FROM ACAR_ATTACH_FILE WHERE ISDELETED='N' and content_code = 'FINE' and content_seq like '"+m_id+l_cd+car_mng_id+seq_no+"1%') b WHERE a.seq = b.seq and a.content_code = 'FINE' ) aaf  "+
			 	" WHERE a.car_mng_id=b.car_mng_id "+
				"       and a.car_mng_id=c.car_mng_id(+) and a.seq_no=c.seq_no(+) and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) "+
				"       and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd  AND a.rent_mng_id = p.rent_mng_id AND a.rent_l_cd = p.rent_l_cd  AND a.rent_s_cd = rc.RENT_S_CD(+) AND c.RENT_MNG_ID||c.RENT_L_CD||c.CAR_MNG_ID||c.SEQ_NO||'1' = aaf.CONTENT_SEQ(+) "+
				"       and a.doc_id='"+doc_id+"' and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'  and d.client_id='"+c_id+"' and c.vio_dt = '"+vio_dt+"' /*order by p.dlv_est_dt, d.RENT_L_CD */"; 									
		
		query += " ORDER BY nvl(c.reg_code,substr(b.car_no,length(b.car_no)-3,4)), p.dlv_est_dt, d.RENT_L_CD ";//c.rec_dt desc		

	//System.out.println("[FineDocDatabase:getFind_file6]\n"+query);			

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFind_file6]\n"+e);
			System.out.println("[FineDocDatabase:getFind_file6]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	

	}


//���·� ���ǽ�û���� ���·� �Ѱ� ���

	public boolean insertFineDocListCar_exp(FineDocListBean bean, String doc_dt)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO fine_doc_list (doc_id, car_mng_id, seq_no, rent_mng_id, rent_l_cd, rent_s_cd,"+
					"   firm_nm, ssn, enp_no, rent_start_dt, rent_end_dt, paid_no, reg_id, reg_dt, upd_id, upd_dt,"+
					"   car_no, amt1, amt2, amt3, amt4, amt5, amt6, amt7, var1, var2, var3) VALUES"+
					" ( ?, ?, ?, ?, ?,    ?, "+
					"   ?, replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''),   replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), '', '',"+
					"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

//System.out.println(query);
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getDoc_id 		());
			pstmt.setString	(2,		bean.getCar_mng_id	());
			pstmt.setInt	(3,		bean.getSeq_no		());
			pstmt.setString	(4,		bean.getRent_mng_id ());
			pstmt.setString	(5,		bean.getRent_l_cd	());

			pstmt.setString	(6,		bean.getRent_s_cd	());
			pstmt.setString	(7,		bean.getFirm_nm		());
			pstmt.setString	(8,		bean.getSsn			());
			pstmt.setString	(9,		bean.getEnp_no		());
			pstmt.setString	(10,	bean.getRent_start_dt());

			pstmt.setString	(11,	bean.getRent_end_dt	());
			pstmt.setString	(12,	bean.getPaid_no		());
			pstmt.setString	(13,	bean.getReg_id		());

			pstmt.setString	(14,	bean.getCar_no		());
			pstmt.setInt	(15,	bean.getAmt1		());
			pstmt.setInt	(16,	bean.getAmt2		());
			pstmt.setInt	(17,	bean.getAmt3		());
			pstmt.setInt	(18,	bean.getAmt4		());
			pstmt.setInt	(19,	bean.getAmt5		());
			pstmt.setInt	(20,	bean.getAmt6		());
			pstmt.setInt	(21,	bean.getAmt7		());
			pstmt.setString	(22,	bean.getVar1		());
			pstmt.setString	(23,	bean.getVar2		());
			pstmt.setString	(24,	bean.getVar3		());



			pstmt.executeUpdate();
			pstmt.close();
		
			conn.commit();

			updateFineObj_dt(bean.getCar_mng_id(), bean.getRent_mng_id(), bean.getRent_l_cd(), Integer.toString(bean.getSeq_no()), doc_dt);

	  	} catch (Exception e) {
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+e);
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getDoc_id()+"]");
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getCar_mng_id()+"]");
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getSeq_no()+"]");
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getRent_mng_id()+"]");
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getRent_l_cd()+"]");
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getRent_s_cd()+"]");
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getFirm_nm()+"]");
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getSsn()+"]");
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getEnp_no()+"]");
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getRent_start_dt()+"]");
			System.out.println("[FineDocDatabase:insertFineDocList]\n"+bean.getCar_no()+"]");

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

//���·� ���ǽ�û���� ���·� ����Ʈ��ȸ : ������
public Vector getFineDocListsCar_exp(String doc_id)
	{
		getConnection();

		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";


		query = " SELECT DISTINCT a.car_mng_id, a.exp_st, a.exp_est_dt, a.exp_dt, a.car_no, b.car_nm, b.init_reg_dt, \n"+
				" decode(e.cha_dt,'','',e.cha_dt||'[�뵵����]-'||e.cha_cau_sub) cha_cont,  \n"+
				" decode(c.migr_dt,'','',c.migr_dt||'[�Ű�]-'||d.firm_nm) sui_cont, d.FIRM_NM,decode(c.migr_dt,'','',c.migr_dt) AS migr_dt  \n"+
				" from gen_exp a, car_reg b, sui c, client d, car_change e, car_change f, FINE_DOC_LIST h,  \n"+
				" (select car_mng_id from cont where use_yn='Y' and car_st<>'2') g \n"+
				" where a.exp_st='3' and substr(a.exp_end_dt,5,4)='1231' and a.rtn_est_amt>0 /* and a.rtn_amt=0 */ and a.rtn_req_dt is not null /* and a.rtn_dt is null */ and a.exp_est_dt<>a.exp_end_dt \n"+
				" and a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id(+) and c.client_id=d.client_id(+) \n"+
				" and a.car_mng_id=e.car_mng_id(+) and a.rtn_cau_dt=e.cha_dt(+) and e.car_mng_id=f.car_mng_id(+) and e.cha_seq-1=f.cha_seq(+) \n"+
				" and a.car_mng_id=g.car_mng_id(+) AND a.CAR_MNG_ID = h.CAR_MNG_ID \n"+
//				" and (c.migr_dt is not null or (c.migr_dt is null and e.cha_dt is not null and g.car_mng_id is not null and substr(a.exp_dt,1,6)||'00' < e.cha_dt)) \n"+
				" AND h.DOC_ID = '"+doc_id+"' ";

//System.out.println("getFineDocListsCar_exp( "+query);

		try{
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
			System.out.println("[FineDocDatabase:getFineDocListsCar_exp]\n"+e);
			System.out.println("[FineDocDatabase:getFineDocListsCar_exp]\n"+query);
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
     * ������� ��������� ��ĵ���ϸ���Ʈ
     */
	public Vector getBank_scantax(String car_mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "  SELECT a.car_no, c.* FROM car_reg a, cont b, LC_SCAN c WHERE b.RENT_MNG_ID=c.RENT_MNG_ID AND b.RENT_L_CD=c.RENT_L_CD AND a.CAR_MNG_ID = b.CAR_MNG_ID AND  b.car_mng_id = '"+car_mng_id+"' and c.file_st = '10' ";
				query += " ORDER BY 4,3  ";
//System.out.println("getBank_scantax:: "+query);

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
			System.out.println("[getBank_scanreg:getBank_scantax]\n"+e);
			System.out.println("[getBank_scanreg:getBank_scantax]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}	
	
	//�Ｚī�� 20% �㺸 -3 roundup.
	public int getDamAmt(int loan_amt, int tax_amt)
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int dam_amt = 0;

	//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/2+500, -3)  from  dual ";  length(to_char(( " + loan_amt + " + " + tax_amt + ")/5)) ) 
				 
	//	query = "  select case when substr(to_char(( " + loan_amt + " + " + tax_amt + ")/2), length(to_char(( " + loan_amt + " + " + tax_amt + ")/2)) -3  ) = '0' then round(( " + loan_amt + " + " + tax_amt + ")/2, -3) else  round(( " + loan_amt + " + " + tax_amt + ")/2+500, -3) end  from dual ";
	//	query = "  select case when substr(to_char(( " + loan_amt + " + " + tax_amt + ")/5), length(to_char(( " + loan_amt + " + " + tax_amt + ")/5)) -3  ) = '0' then round(( " + loan_amt + " + " + tax_amt + ")/5, -3) else  round(( " + loan_amt + " + " + tax_amt + ")/5+500, -3) end  from dual ";
		query = "  select case when substr(to_char(( " + loan_amt + " + " + tax_amt + ")/5), length(to_char(( " + loan_amt + " + " + tax_amt + ")/5)) -4  ) = '0' then round(( " + loan_amt + " + " + tax_amt + ")/5, -4) else  round(( " + loan_amt + " + " + tax_amt + ")/5, -4) end  from dual "; //20191213


		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dam_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDamAmt]\n"+e);
			System.out.println("[FineDocDatabase:getDamAmt]\n"+query);
			e.printStackTrace();
		} finally {
			try{
             			   if(rs != null )		rs.close();
         				   if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dam_amt;
		}				
	}

		//������� - ���԰����� 50%,  -5 roundup.
	public int getDamAmt1(int car_amt)
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int dam_amt = 0;

	//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/5+500, -3)  from  dual ";
				 
		query = "  select case when substr(to_char(( " + car_amt  + ")/2), length(to_char(( " + car_amt + ")/2)) ) = '0' then round(( " + car_amt  + ")/2+500000, -6) else  round(( " + car_amt  + ")/2+500000, -6) end  from dual ";


		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dam_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDamAmt1]\n"+e);
			System.out.println("[FineDocDatabase:getDamAmt1]\n"+query);
			e.printStackTrace();
		} finally {
			try{
             			   if(rs != null )		rs.close();
         				   if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dam_amt;
		}				
	}
	
		//�������� - ������� 50%,  -1 roundup.
	public int getDamAmt2(int car_amt)
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int dam_amt = 0;

	//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/5+500, -3)  from  dual ";
				 
		query = "  select   round(( " + car_amt  + ")/2) end  from dual ";


		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dam_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDamAmt2]\n"+e);
			System.out.println("[FineDocDatabase:getDamAmt2]\n"+query);
			e.printStackTrace();
		} finally {
			try{
             			   if(rs != null )		rs.close();
         				   if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dam_amt;
		}				
	}
	
	
	
		//hk���� - ������� 30%,  -1 roundup.
	public int getDamAmtRate(int rate, int car_amt )
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int dam_amt = 0;

	//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/5+500, -3)  from  dual ";
				 
		query = "  select   round(( " + car_amt  + ")*"+rate+"/100 ) end  from dual ";


		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dam_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDamAmt2]\n"+e);
			System.out.println("[FineDocDatabase:getDamAmt2]\n"+query);
			e.printStackTrace();
		} finally {
			try{
             			   if(rs != null )		rs.close();
         				   if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dam_amt;
		}				
	}
	
	
	
	
		//hk���� - ������� 30%,  -1 roundup.
	public int getDamAmt3(int car_amt)
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int dam_amt = 0;

	//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/5+500, -3)  from  dual ";
				 
		query = "  select   round(( " + car_amt  + ")*0.3 ) end  from dual ";


		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dam_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDamAmt2]\n"+e);
			System.out.println("[FineDocDatabase:getDamAmt2]\n"+query);
			e.printStackTrace();
		} finally {
			try{
             			   if(rs != null )		rs.close();
         				   if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dam_amt;
		}				
	}
	
		
		//�޸����� - ���԰����� 50%,  -4 roundup.  -2 roundup
	public int getDamAmt4(int car_amt )
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int dam_amt = 0;

	//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/5+500, -3)  from  dual ";
				 
		query = "  select case when substr(to_char(( " + car_amt  + ")/2), length(to_char(( " + car_amt + ")/2)) ) = '0' then round(( " + car_amt  + ")/2+500, -3) else  round(( " + car_amt  + ")/2+500, -3) end  from dual ";


		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dam_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDamAmt4]\n"+e);
			System.out.println("[FineDocDatabase:getDamAmt4]\n"+query);
			e.printStackTrace();
		} finally {
			try{
             			   if(rs != null )		rs.close();
         				   if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dam_amt;
		}				
	}
	
 // 0089 10% round -4
	public int getDamAmt11(int car_amt )
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int dam_amt = 0;

	//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/5+500, -3)  from  dual ";
				 
		query = "  select case when substr(to_char(( " + car_amt  + ")*0.1), length(to_char(( " + car_amt + ")*0.1)) ) = '0' then round(( " + car_amt  + ")*0.1+5000, -4) else  round(( " + car_amt  + ")*0.1+5000, -4) end  from dual ";


		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dam_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDamAmt11]\n"+e);
			System.out.println("[FineDocDatabase:getDamAmt11]\n"+query);
			e.printStackTrace();
		} finally {
			try{
             			   if(rs != null )		rs.close();
         				   if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dam_amt;
		}				
	}
	
	 // ��������(0029) 50% round -4
		public int getDamAmt111(int car_amt )
		{
			getConnection();

			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			int dam_amt = 0;

		//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/5+500, -3)  from  dual ";
					 
			query = "  select case when substr(to_char(( " + car_amt  + ")*0.5), length(to_char(( " + car_amt + ")*0.5)) ) = '0' then round(( " + car_amt  + ")*0.5+5000, -4) else  round(( " + car_amt  + ")*0.5+5000, -4) end  from dual ";


			try{
				pstmt = conn.prepareStatement(query);
			   	rs = pstmt.executeQuery();

				if(rs.next())
				{
					dam_amt = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				System.out.println("[FineDocDatabase:getDamAmt11]\n"+e);
				System.out.println("[FineDocDatabase:getDamAmt11]\n"+query);
				e.printStackTrace();
			} finally {
				try{
	             			   if(rs != null )		rs.close();
	         				   if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return dam_amt;
			}				
		}
	
	public int getDamAmt7(int car_amt )
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int dam_amt = 0;

	//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/5+500, -3)  from  dual ";
				 
		query = "  select case when substr(to_char(( " + car_amt  + ")*0.7), length(to_char(( " + car_amt + ")*0.7)) ) = '0' then round(( " + car_amt  + ")*0.7+5000, -4) else  round(( " + car_amt  + ")*0.7+5000, -4) end  from dual ";


		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dam_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDamAmt7]\n"+e);
			System.out.println("[FineDocDatabase:getDamAmt7]\n"+query);
			e.printStackTrace();
		} finally {
			try{
             			   if(rs != null )		rs.close();
         				   if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dam_amt;
		}				
	}
	
			//�޸����� - ���԰����� 50%,  -4 roundup.
	public int getDamAmt4(int car_amt , int c_cnt)
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int dam_amt = 0;
		int add_amt = 0;
		if ( c_cnt == 2 ) { //���������
			add_amt = 50;			
		}  else if ( c_cnt == 3 ) { //õ��������
			add_amt = 500;			
		} else if ( c_cnt == 4)  { //����������
			add_amt = 5000;
		}	
				

	//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/5+500, -3)  from  dual ";
	
	
	//		select substr(to_char(( 47023810)/2), length(to_char(( 47023810)/2)) - 3,  length(to_char(( 47023810)/2)) ) from dual
	 
		query = "  select case when substr(to_char(( " + car_amt  + ")/2),  length(to_char(( " + car_amt + ")/2))  - " + c_cnt+ "  ,  length(to_char(( " + car_amt + ")/2)) ) = '0000' then round(( " + car_amt  + ")/2) else  round(( " + car_amt  + ")/2+"+add_amt + ", -" + c_cnt+ ") end  from dual ";


		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dam_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDamAmt4]\n"+e);
			System.out.println("[FineDocDatabase:getDamAmt4]\n"+query);
			e.printStackTrace();
		} finally {
			try{
             			   if(rs != null )		rs.close();
         				   if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dam_amt;
		}				
	}
	
	/* �������� 10%, */
	public int getDamAmt10(int car_amt )
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int dam_amt = 0;

	//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/5+500, -3)  from  dual ";
				 
		query = "  select case when substr(to_char(( " + car_amt  + ")/10), length(to_char(( " + car_amt + ")/10)) ) = '0' then round(( " + car_amt  + ")/10+500, -3) else  round(( " + car_amt  + ")/10+500, -3) end  from dual ";


		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dam_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDamAmt4]\n"+e);
			System.out.println("[FineDocDatabase:getDamAmt4]\n"+query);
			e.printStackTrace();
		} finally {
			try{
             			   if(rs != null )		rs.close();
         				   if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dam_amt;
		}				
	}
	
	//round -4 �ΰ��   0 �ΰ�� 5000 ���ϴ°� Ȯ��  -202010 Ȯ�εǸ� �ٸ� �޼ҵ� ����
	public int getDamAmtRound4(int car_amt, int rate )
	{
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int dam_amt = 0;

	//	query = " SELECT  round(( " + loan_amt + " + " + tax_amt + " )/5+500, -3)  from  dual ";
				 
		query = "  select case when substr(to_char(( " + car_amt  + ")*"+rate+"/100), length(to_char(( " + car_amt + ")*"+rate+"/100)) ) = '0' then round(( " + car_amt  + ")*"+rate+"/100+5000, -4) else  round(( " + car_amt  + ")*"+rate+"/100+5000, -4) end  from dual ";


		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				dam_amt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getDamAmt11]\n"+e);
			System.out.println("[FineDocDatabase:getDamAmt11]\n"+query);
			e.printStackTrace();
		} finally {
			try{
             			   if(rs != null )		rs.close();
         				   if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return dam_amt;
		}				
	}

	
	
		//�ְ��� �̼�ä�� ����Ʈ : ������
	public Vector getSettleDocLists(String doc_id, String s_kd, String t_wd)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.*"+
				" FROM fine_doc_list a"+
				" WHERE a.doc_id=? ";
		
		if(!t_wd.equals("")){		
			if(s_kd.equals("4"))	query += " and a.car_no like '%"+t_wd+"%'";				
			if(s_kd.equals("8"))	query += " and a.var3  ='"+t_wd+"'";	
		}
			
		query += "order by seq_no ";	
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				FineDocListBean bean = new FineDocListBean();
				bean.setDoc_id 			(rs.getString(1));
				bean.setCar_mng_id		(rs.getString(2));
				bean.setSeq_no			(rs.getInt(3));
				bean.setRent_mng_id		(rs.getString(4));
				bean.setRent_l_cd		(rs.getString(5));
				bean.setRent_s_cd		(rs.getString(6));
				bean.setFirm_nm			(rs.getString(7));
				bean.setSsn				(rs.getString(8));
				bean.setEnp_no			(rs.getString(9));
				bean.setRent_start_dt	(rs.getString(10));	
				bean.setRent_end_dt		(rs.getString(11));	
				bean.setPaid_no			(rs.getString(12));
				bean.setReg_id			(rs.getString(13));
				bean.setReg_dt			(rs.getString(14));
				bean.setUpd_id			(rs.getString(15));
				bean.setUpd_dt			(rs.getString(16));
				bean.setCar_no			(rs.getString(17));
				bean.setAmt1			(rs.getInt(18));
				bean.setAmt2			(rs.getInt(19));
				bean.setAmt3			(rs.getInt(20));
				bean.setAmt4			(rs.getInt(21));
				bean.setAmt5			(rs.getInt(22));
				bean.setAmt6			(rs.getInt(23));
				bean.setAmt7			(rs.getInt(24));
				
				bean.setVar1			(rs.getString(25));
				bean.setVar2			(rs.getString(26));
				bean.setVar3			(rs.getString(27));
			
				bean.setChk			(rs.getString(28));
				bean.setChecker_st		(rs.getString(29));
				bean.setServ_dt		(rs.getString(30));
				bean.setRep_cont		(rs.getString(31));
				bean.setServ_off_nm		(rs.getString(32));
				
				vt.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getSettleDocLists]\n"+e);
			System.out.println("[FineDocDatabase:getSettleDocLists]\n"+query);
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
	 *	 �ڵ��� ���� ����.. (doc_id, seq_no, rep_cont, checker_st, serv_off_nm, serv_dt, chk))
	 */	
	public boolean updateFineDocRecall(String doc_id, int seq_no, String rep_cont, String checker_st, String serv_off_nm, String serv_dt, String chk )
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;
		String query = " update fine_doc_list set "+					
						" rep_cont = ? , checker_st = ?, serv_off_nm = ?, serv_dt =replace(?, '-', '') , chk = ?  "+					
						" where doc_id = ? and seq_no = ?";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rep_cont);	
			pstmt.setString(2, checker_st);			
			pstmt.setString(3, serv_off_nm);			
			pstmt.setString(4, serv_dt);	
			pstmt.setString(5, chk);			
			pstmt.setString(6, doc_id);
			pstmt.setInt(7, seq_no);
			
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[FineDocDatabase:updateFineDocRecall]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	


//�ڵ������ �ѽ� �Ѱ���ȸ
public Hashtable getPur_doc_review(String doc_id, String m_id, String l_cd)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();


	
		query = " SELECT '�ѹ�'||SUBSTR(a.doc_id, 3) AS doc_id, a.seq_no, a.rent_l_cd, a.rent_mng_id, a.var1, a.var2, b.doc_id as s_doc_id, b.DOC_DT, b.MNG_DEPT, b.MNG_NM, b.MNG_POS "+
				" , b.GOV_ID "+
				" FROM fine_doc_list a, fine_doc b"+
			 	" WHERE a.doc_id=b.doc_id "+
				" and a.doc_id='"+doc_id+"'"; 									
		

	//System.out.println("[FineDocDatabase:getPur_doc_review]\n"+query);			

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getPur_doc_review]\n"+e);
			System.out.println("[FineDocDatabase:getPur_doc_review]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	

	}




	/**
     * ������� ī����� �ѽ� ������ Ȯ��.
     */
	public Vector getPur_doc_review_select(String doc_id){

		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query ="";
			
		query = " SELECT '�ѹ�'||SUBSTR(a.doc_id, 3) AS doc_id, a.rent_l_cd, a.seq_no, a.rent_mng_id, a.var1, a.var2, b.doc_id as s_doc_id, b.DOC_DT, b.MNG_DEPT, b.MNG_NM, b.MNG_POS "+
				" , b.GOV_ID, a.paid_no "+
				" FROM fine_doc_list a, fine_doc b"+
			 	" WHERE a.doc_id=b.doc_id "+
				" and a.doc_id='"+doc_id+"' "; 	
		
//System.out.println("getPur_doc_review_select:: "+query);

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
			System.out.println("[FineDocDatabase:getPur_doc_review_select]\n"+e);
			System.out.println("[FineDocDatabase:getPur_doc_review_select]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}	

//���ǽ�û���� ���ο� ������ȣ ����
	public String getFineGovNoNext2(String dept_nm)
	{
		getConnection();

		FineGovBean bean = new FineGovBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String next_id = "";

		query = " select '"+dept_nm+"'||to_char(sysdate,'YYYYMMDD')||'-'||nvl(ltrim(to_char(to_number(max(substr(doc_id,12,3))+1), '000')), '001') doc_id"+
				" from fine_doc "+
				" where substr(doc_id,1,11)='"+dept_nm+"'||to_char(sysdate,'YYYYMMDD')||'-'";

//System.out.println("getFineGovNoNext:: "+query);

		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				next_id = rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineGovNoNext]\n"+e);
			System.out.println("[FineDocDatabase:getFineGovNoNext]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return next_id;
		}				
	}



	/**
	 *	����� ��ȯ������ ��� ���� Ȯ�� 20130529
	 */	

public int updateFineDocScd_yn(String doc_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " update fine_doc set scd_yn='Y' where doc_id='"+doc_id+"' ";

		try 
		{	
			conn.setAutoCommit(false);		
		
			pstmt = conn.prepareStatement(query);

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:updateFineDocScd_yn]\n"+e);
			System.out.println("[FineDocDatabase:updateFineDocScd_yn]\n"+query);
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

	


//���/���/�Ҽ� ���� ����Ʈ
	public Vector getFineKSKBSSLists(String id_st, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String m_id, String l_cd, String c_id, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";


	
			query = " SELECT '3' id_st, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
					" a.*, c.cnt, decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+
					" from fine_doc a, cont_n_view b , (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					"  a.doc_id=c.doc_id(+) 	AND a.MNG_POS = b.rent_l_cd(+)  and a.doc_id like '%"+gubun1+"%' AND substr(a.doc_dt,1,4)=to_char(sysdate,'YYYY') "+
					" AND b.RENT_L_CD = '"+l_cd+"'  AND b.RENT_MNG_ID = '"+m_id+"'  AND b.car_mng_id = '"+c_id+"' ";
/*
					" UNION ALL "+
					" SELECT '4' id_st, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
					" a.*, c.cnt, decode(a.f_reason, '1', '�̻簨', '2', '�����κ���', '3', '�󹮺���', '4', '�������', '5', '�ּҺҸ�', '6', '�����κҸ�', '') f_reason_nm "+
					" from fine_doc a, cont_n_view b , (select doc_id, count(*) cnt from fine_doc_list group by doc_id) c"+
					" where"+
					"  a.doc_id=c.doc_id(+) 	AND a.MNG_POS = b.rent_l_cd(+)  and a.doc_id like '�Ҽ�%' AND substr(a.doc_dt,1,4)=to_char(sysdate,'YYYY') "+
					" AND b.RENT_L_CD = '"+l_cd+"'  AND b.RENT_MNG_ID = '"+m_id+"'  AND b.car_mng_id = '"+c_id+"' ";
*/


		try {
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();
		   	
//System.out.println("getFineKSKBSSLists: "+query);

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
			System.out.println("[FineDocDatabase:getFineKSKBSSLists]\n"+e);
			System.out.println("[FineDocDatabase:getFineKSKBSSLists]\n"+query);
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
	

	public Hashtable getReg_msprint(String doc_id, String rent_l_cd, String rent_mng_id)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();
	
			
		query = " SELECT c.gov_id, a.doc_id, ci.enp_no,  cc.rent_l_cd, cc.rent_dt, ci.O_ZIP, " +
				"	decode(p.dlv_est_dt,null,'',substr(p.dlv_est_dt,1,4)||'-'||substr(p.dlv_est_dt,5,2)||'-'||substr(p.dlv_est_dt,7,2))  dlv_est_dt, " + 
				"	a.firm_nm ,  c.filename lend_int, decode(c.end_dt,null,'',substr(c.end_dt,1,4)||'-'||substr(c.end_dt,5,2)||'-'||substr(c.end_dt,7,2)) end_dt, " +
				"   a.paid_no paid_no,  a.amt1 , a.amt2, a.amt3, a.amt4 , a.amt5,  a.amt6, nvl(d.car_nm, m.car_nm ) car_nm ,  n.car_name, nvl(d.car_no, '') car_no,  " +
				"   nvl(g.car_fs_amt, 0) + nvl(g.car_fv_amt, 0)  as car_amt , " +		
				"  nvl(f.grt_amt_s, 0) + nvl(f.pp_s_amt, 0) + nvl(f.pp_v_amt, 0) as pre_amt, d.car_doc_no, d.car_ext , d.car_num, d.acq_f_dt, d.acq_is_o," + 
				"  cc.rent_mng_id, cc.car_mng_id, c.doc_dt, "+
				"  y.pay_yn, y.t_alt_prn, y.t_alt_int, a.seq_no, " + 
				"  decode(y.car_mng_id, '', 'N', 'Y') scd_reg_yn, decode(y.pay_yn, 'N', '������', 'Y', '���οϷ�','') scd_pay_yn, "+
				"  round((a.amt4+a.amt5)/5+500, -3) dam_amt , ci.o_addr , p.rpt_no , g.colo , decode(cc.dlv_dt,null,'',substr(cc.dlv_dt,1,4)||'-'||substr(cc.dlv_dt,5,2)||'-'||substr(cc.dlv_dt,7,2))  dlv_dt  "+
				"  FROM fine_doc_list a, fine_doc c, car_etc g,  car_reg d , cont cc , client ci , car_pur p , fee f , car_nm n , car_mng m, "+
				"  ( select decode(sum(pay_yn), max(to_number(alt_tm)), 'Y', 'N') pay_yn, car_mng_id, "+
				"           sum(alt_prn) t_alt_prn, sum(alt_int) t_alt_int "+
				"    from scd_alt_case "+
				"    group by car_mng_id "+
				"  ) y "+
				" WHERE a.doc_id =c.doc_id  and a.car_mng_id = d.car_mng_id(+) and a.rent_mng_id = g.rent_mng_id "+
				"  and a.rent_l_cd = g.rent_l_cd and a.rent_mng_id = cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd " +
				"  and a.rent_l_cd = p.rent_l_cd and a.rent_mng_id = p.rent_mng_id " +
				"  and g.car_id = n.car_id and g.car_seq = n.car_seq and n.car_comp_Id = m.car_comp_Id and n.car_cd = m.code  " +
				"  and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = f.rent_mng_id and f.rent_st = '1' " + 				
				"  and cc.client_id = ci.client_id and d.car_mng_id=y.car_mng_id(+)  "+
				"  and a.doc_id= '"+doc_id+"' AND a.RENT_L_CD = '"+rent_l_cd+"' AND a.RENT_MNG_ID = '"+rent_mng_id+"'"+
				"  order by a.doc_id, a.paid_no, 4, 3 ";
		

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getReg_msprint]\n"+e);
			System.out.println("[FineDocDatabase:getReg_msprint]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	

	}


public Vector getFineDocLists_sc(String doc_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		
		query = " SELECT doc_id, rent_mng_id, rent_l_cd from FINE_DOC_LIST " + 				
				"  where doc_id= ? "+
				"  order by doc_id";
				 

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_id);
			rs = pstmt.executeQuery();
	//	System.out.println(query);

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
			System.out.println("[FineDocDatabase:getFineDocLists_sc]\n"+e);
			System.out.println("[FineDocDatabase:getFineDocLists_sc]\n"+query);
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

    //������Ǽ���  

public boolean  updateCtrl(String doc_id)
	{
		int flag = 0;
		String query = "";
					
		Vector vts = getBankDocAllLists3(doc_id);
		int f_size = vts.size();
								
		for(int i = 0 ; i < f_size ; i++)
			{
												
				FineDocListBean a_fl = (FineDocListBean)vts.elementAt(i);			
	          		      						
				if(!insertCtrl(a_fl.getRent_mng_id(), a_fl.getRent_l_cd(), a_fl.getAmt6(), a_fl.getServ_off_nm() ))	flag += 1;							
				
		}
						
		if(flag == 0)	return true;
		else 			return false;	
			
	}
		
	/**
	 *	CTRL INSRET
	 */
	
	public boolean insertCtrl(String rent_mng_id, String rent_l_cd, int amt, String  code_nm)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;
		String query = " insert into cltr ( rent_mng_id, rent_l_cd, cltr_id,  cltr_amt, cltr_user )  "+
					" values ( ?, ?, ?, ?, ?) ";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
		
		    pstmt.setString(1, rent_mng_id.trim());
			pstmt.setString(2,  rent_l_cd.trim());
			pstmt.setString(3, "03") ;
			pstmt.setInt(4, amt) ;
			pstmt.setString(5, code_nm) ;
						
	//		System.out.println("rent_mng_id = " + rent_mng_id);
	//		System.out.println("rent_l_cd = " + rent_l_cd);
					
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[FineDocDatabase:insertCtrl]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally
		{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	

	public String getServ_dt(String doc_id)
	{
		getConnection();

		FineGovBean bean = new FineGovBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String next_id = "";

		query = " SELECT DISTINCT(serv_dt) FROM fine_doc_list  "+
				" WHERE doc_id ='"+doc_id+"' ";

//System.out.println("getFineGovNoNext:: "+query);

		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				next_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getServ_dt]\n"+e);
			System.out.println("[FineDocDatabase:getServ_dt]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return next_id;
		}				
	}


	//ä�ǰ��� �����ּ� ���� 

public int updateFineDocEmail(String doc_id, String email)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";

		query = " update fine_doc set remarks  = '"+email+"'  where doc_id='"+doc_id+"' ";

		try 
		{	
			conn.setAutoCommit(false);		
		
			pstmt = conn.prepareStatement(query);

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:updateFineDocEmail]\n"+e);
			System.out.println("[FineDocDatabase:updateFineDocEmail]\n"+query);
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

	//���·� ���ǽ�û�����ϰ���� ����Ʈ
	public Vector getFineDocRegList(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String dt_query = "";
		String dt = "a.reg_dt";//��������	
		
		//������ȸ
		if(gubun2.equals("1"))		dt_query = " and "+dt+"=to_char(sysdate-2,'YYYYMMDD')";
		if(gubun2.equals("2"))		dt_query = " and "+dt+"=to_char(sysdate-1,'YYYYMMDD')";
		if(gubun2.equals("3"))		dt_query = " and "+dt+"=to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("4"))		dt_query = " and substr("+dt+",1,6)=to_char(sysdate,'YYYYMM')";
		if(gubun2.equals("5"))		dt_query = " and "+dt+" between replace(nvl('"+st_dt+"','00000000'), '-', '') and replace(nvl('"+end_dt+"','99999999'), '-', '')";	


		query = " SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.seq_no, \n"+
				"        a.reg_dt, a.reg_id, f.user_nm AS reg_nm,  \n"+
				"        g.gov_nm, a.vio_dt, a.vio_pla, a.vio_cont, a.paid_no,  \n"+
				"        nvl(b.cnt,0) cnt, b.min_doc_dt, b.max_doc_dt, \n"+
				"        d.firm_nm, e.car_no, e.car_nm, c.car_st \n"+
				" FROM   fine a,  \n"+
				"        (SELECT rent_mng_id, rent_l_cd, car_mng_id, seq_no,  \n"+
				"                count(0) cnt, min(a.doc_dt) min_doc_dt, max(a.doc_dt) max_doc_dt \n"+
				"         FROM   fine_doc a, fine_doc_list b  \n"+
				"         WHERE  a.doc_id LIKE '����%' AND a.doc_id=b.doc_id \n"+
				"         GROUP BY rent_mng_id, rent_l_cd, car_mng_id, seq_no \n"+
				"        ) b, \n"+
				"        cont c, client d, car_reg e, users f, fine_gov g \n"+
				" WHERE  a.paid_st='1' AND a.fault_st='1' AND a.vio_cont<>'�����̳�' \n"+dt_query+
				"        AND a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+) AND a.car_mng_id=b.car_mng_id(+) AND a.seq_no=b.seq_no(+) \n"+
				"        AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd \n"+
				"        AND c.client_id=d.client_id \n"+
				"        AND c.car_mng_id=e.car_mng_id \n"+
				"        AND a.reg_id=f.user_id  \n"+
				"        AND a.pol_sta=g.gov_id \n"+
				" ";

		if(gubun1.equals("1"))		query += " and nvl(b.cnt,0)=0";
		if(gubun1.equals("2"))		query += " and nvl(b.cnt,0)>0";
		
		if(s_kd.equals("6") && t_wd.equals("������")) {
			query += " and g.gov_nm like '%������%' and a.pol_sta not in ('411','302')"; //��õ��������, ��õ������ ����
		}else {
			query += " and NVL(a.note,'-') NOT LIKE '%�Ѳ�����%���%'";
		}


		//�˻�� ������...
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))	query += " and d.firm_nm like '%"+t_wd+"%'";
			if(s_kd.equals("2"))	query += " and e.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("3"))	query += " and a.paid_no like '%"+t_wd+"%'";
			if(s_kd.equals("5"))	query += " and f.user_nm like '%"+t_wd+"%'";
			if(s_kd.equals("6"))	query += " and g.gov_nm like '%"+t_wd+"%'";
		}
		
		query +=" ORDER BY DECODE(b.cnt,'',0,1), a.reg_dt";

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
			System.out.println("[FineDocDatabase:getFineDocRegList]\n"+e);
			System.out.println("[FineDocDatabase:getFineDocRegList]\n"+query);
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
	
	//���·� ���ǽ�û�����ϰ���� �����ڵ� �ߺ� üũ
	public int getRegCodeChk(String reg_code)
	{
		getConnection();

		FineDocBean bean = new FineDocBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int count = 0;

		query = " SELECT count(*) FROM ins_excel WHERE reg_code=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, reg_code);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				count = rs.getInt(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getRegCodeChk]\n"+e);
			System.out.println("[FineDocDatabase:getRegCodeChk]\n"+query);
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

	//���·� ���ǽ�û�ϰ���� ó�� ���ν���
	public String call_sp_fine_doc_all_reg(String reg_code)
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_FINE_DOC_ALL_REG  (?)}";
		
		try {

			//ó�� ���ν��� ȣ��
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:call_sp_fine_doc_all_reg]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
				if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}
	
	//���·����ǽ�û���� ó������ ����(20180726)
	public boolean changeComplete_etc(String doc_id, String compl_etc)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " update fine_doc set compl_etc=? where doc_id=?";

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		compl_etc.trim()	 );
			pstmt.setString	(2,		doc_id.trim()		 );
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		
		 }catch(Exception se){
           try{
				System.out.println("[FineDocDatabase:changeComplete_etc]"+se);
				se.printStackTrace();
				flag = false;
                conn.rollback();
            }catch(SQLException _ignored){}
       
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public Hashtable getFineDocMail(String client_id)
	{
		getConnection();
		Vector vt = new Vector();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		Hashtable ht = new Hashtable();
	
		query = ""+
				" SELECT * \r\n" + 
				" FROM (SELECT * FROM FINE_DOC WHERE DOC_ID = (SELECT max(DOC_ID) keep(DENSE_RANK FIRST ORDER BY DOC_DT desc) DOC_ID  FROM FINE_DOC  WHERE GOV_ID = '"+client_id+"')) a, \r\n" + 
				" (SELECT * FROM ACAR_ATTACH_FILE where NVL(isdeleted,'N') <> 'Y') b\r\n" + 
				" WHERE a.doc_id like '%ä���߽�%' AND a.doc_id = b.content_seq(+) "+
				"";
		
		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[FineDocDatabase:getFineDocMail]\n"+e);
			System.out.println("[FineDocDatabase:getFineDocMail]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	

	}
	
	//���ǽ�û����ǥ�� - ����ó ���� ����(20190814)
	public boolean updateFineDoc_MngDept(String doc_id, String mng_dept){
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;
		String query = " update fine_doc set mng_dept = '"+mng_dept+"' where doc_id ='"+doc_id+"' ";
		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e){
		  	System.out.println("[FineDocDatabase:updateFineDoc_MngDept]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}
		finally{
			try{
				conn.setAutoCommit(true);	
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	//�����ڱ����� ���� 
		public boolean updateBankDocFund(String doc_id){
			boolean flag = true;
			getConnection();
			PreparedStatement pstmt = null;
			String query = " update fine_doc set fund_yn = 'Y' where doc_id ='"+doc_id+"' ";
			try{
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				conn.commit();
		  	}
		  	catch (Exception e){
			  	System.out.println("[FineDocDatabase:updateBankDocFund]\n"+e);
		  		e.printStackTrace();
		  		flag = false;
		  		conn.rollback();
			}
			finally{
				try{
					conn.setAutoCommit(true);	
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}
		}
		
		//�����û���� ����������޿�û ���� �Ѱ� ��ȸ
		public FineDocListBean getFineDocCardDebtList(String rent_mng_id, String rent_l_cd)
		{
			getConnection();

			FineDocListBean bean = new FineDocListBean();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";

			query = " SELECT b.card_yn, b.app_dt, a.doc_id, a.rent_mng_id, a.rent_l_cd, a.amt1, a.amt2, a.amt3, a.amt4, b.gov_id, c.nm, a.end_dt, a.cardno, a.card_dt "+
					" FROM   fine_doc_list a, fine_doc b, code c "+
					" WHERE  a.doc_id like '�ѹ�%' and a.rent_mng_id=? and a.rent_l_cd=? "+
					"        and a.doc_id=b.doc_id and b.card_yn='Y' and b.gov_id=c.code and c.c_st='0003' "+
					"        ";

			try{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, rent_mng_id);
				pstmt.setString(2, rent_l_cd);				
			   	rs = pstmt.executeQuery();

				if(rs.next())
				{
					bean.setRent_st			(rs.getString(1));
					bean.setVio_dt			(rs.getString(2));
					bean.setDoc_id 			(rs.getString(3));
					bean.setRent_mng_id		(rs.getString(4));
					bean.setRent_l_cd		(rs.getString(5));
					bean.setAmt1			(rs.getInt(6));
					bean.setAmt2			(rs.getInt(7));
					bean.setAmt3			(rs.getInt(8));
					bean.setAmt4			(rs.getInt(9));
					bean.setClient_id		(rs.getString(10));
					bean.setFirm_nm			(rs.getString(11));
					bean.setEnd_dt			(rs.getString(12));
					bean.setCardno			(rs.getString(13));
					bean.setCard_dt			(rs.getString(14));
				}
				rs.close();
	            pstmt.close();
			} catch (SQLException e) {
				System.out.println("[FineDocDatabase:getFineDocCardDebtList]\n"+e);
				System.out.println("[FineDocDatabase:getFineDocCardDebtList]\n"+query);
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
	
		// finedoc �׸� ����
		public boolean updateFineDoc(String doc_id, String col_nm, String gubun)
		{
			getConnection();

			PreparedStatement pstmt = null;		
			String query = "";
			boolean flag = true;
		
			try 
			{
				conn.setAutoCommit(false);
				
				query = " update fine_doc set "+col_nm+"=replace(?, '-', '') where doc_id=? ";

				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,		gubun.trim());
				pstmt.setString	(2,		doc_id.trim());				
				pstmt.executeUpdate();
				pstmt.close();
				conn.commit();
					
		  	} catch (Exception e) {
				System.out.println("[FineDocDatabase:updateFineDoc]\n"+e);
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
		
		//����ī�� �����Һΰ��� ī�� ���� 		
		public void call_p_card_debt_batch(String doc_id) {
			getConnection();

			String query = "{CALL P_CARD_DEBT_BATCH(?) }";
			
			String sResult = "";

			CallableStatement cstmt = null;

			try {
				cstmt = conn.prepareCall(query);

				cstmt.setString(1, doc_id);
				cstmt.execute();
				cstmt.close();
			
			} catch (SQLException e) {
				System.out.println("[FineDocDatabase:call_p_card_debt_batch]\n" + e);
				e.printStackTrace();
			} finally {
				try {
					if (cstmt != null)
						cstmt.close();
				} catch (Exception ignore) {
				}
				closeConnection();
			}
		}
		
		public String  getAfterDt(String app_dt)
		{
			getConnection();
			
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			String after_dt = "";

			query = " select F_getValdDt(replace(?, '-', ''), 2) from dual ";

			try{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, app_dt);
			   	rs = pstmt.executeQuery();

				if(rs.next())
				{
					after_dt = rs.getString(1);
				}
				rs.close();
	            pstmt.close();
			} catch (SQLException e) {
				System.out.println("[FineDocDatabase:getAfterDt]\n"+e);
				System.out.println("[FineDocDatabase:getAfterDt]\n"+query);
				e.printStackTrace();
			} finally {
				try{
	                if(rs != null )		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return after_dt;
			}				
		}
		
		
		public String  getAfterDt(String app_dt, int i)
		{
			getConnection();
		
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			String after_dt = "";

			query = " select F_getValdDt(replace(?, '-', ''), "+ i + ") from dual ";

			try{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, app_dt);
			   	rs = pstmt.executeQuery();

				if(rs.next())
				{
					after_dt = rs.getString(1);
				}
				rs.close();
	            pstmt.close();
			} catch (SQLException e) {
				System.out.println("[FineDocDatabase:getAfterDt]\n"+e);
				System.out.println("[FineDocDatabase:getAfterDt]\n"+query);
				e.printStackTrace();
			} finally {
				try{
	                if(rs != null )		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return after_dt;
			}				
		}
		
		
		// finedoclist �׸� ���� - ����ĳ��Ż �� ������ݱ���� ����� ���� 
		public boolean updateFineDocList(String doc_id, String rent_mng_id, String rent_l_cd , int amt4)
		{
			getConnection();

			PreparedStatement pstmt = null;		
			String query = "";
			boolean flag = true;
		
			try 
			{
				conn.setAutoCommit(false);
				
				query = " update fine_doc_list set amt4="+amt4 + " where doc_id=? and rent_mng_id = ? and rent_l_cd = ?  ";

				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,		doc_id.trim());
				pstmt.setString	(2,		rent_mng_id.trim());		
				pstmt.setString	(3,		rent_l_cd.trim());		
		
				pstmt.executeUpdate();
				pstmt.close();
				conn.commit();
					
		  	} catch (Exception e) {
				System.out.println("[FineDocDatabase:updateFineDocList]\n"+e);
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
		
		// finedoclist �׸� ���� - ����ĳ��Ż �� ������ݱ���� ����� ���� 
		public boolean updateFineDocList(String doc_id, String rent_mng_id, String rent_l_cd , int amt, String col_nm)
				{
					getConnection();

					PreparedStatement pstmt = null;		
					String query = "";
					boolean flag = true;
				
					try 
					{
						conn.setAutoCommit(false);
						
						query = " update fine_doc_list set "+col_nm +"=" +amt + " where doc_id=? and rent_mng_id = ? and rent_l_cd = ?  ";

						pstmt = conn.prepareStatement(query);
						pstmt.setString	(1,		doc_id.trim());
						pstmt.setString	(2,		rent_mng_id.trim());		
						pstmt.setString	(3,		rent_l_cd.trim());		
				
						pstmt.executeUpdate();
						pstmt.close();
						conn.commit();
							
				  	} catch (Exception e) {
						System.out.println("[FineDocDatabase:updateFineDocList]\n"+e);
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

