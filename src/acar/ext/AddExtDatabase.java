package acar.ext;

import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.cont.*;
import acar.account.*;
import acar.util.*;
import acar.con_ins_m.*;
import acar.con_ins_h.*;
import acar.accid.*;

public class AddExtDatabase
{
	private Connection conn = null;
	public static AddExtDatabase db;
	
	public static AddExtDatabase getInstance()
	{
		if(AddExtDatabase.db == null) 
			AddExtDatabase.db = new AddExtDatabase();
		return AddExtDatabase.db;	
	}	
	
 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
			{
	        	conn = connMgr.getConnection("acar");
	        }
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


	// ������Ȳ :: ������ ����-------------------------------------------------------------------------------

	
	/**
	 *	������ ����Ʈ ��ȸ - con_grt/grt_sc_in.jsp 
	 */
	public Vector getGrtList2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select "+
				"        b.use_yn, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, a.rent_st, decode(a.ext_st, '0','������','1','������','2','���ô뿩��','5','�°������') gubun,"+
				"        decode(a.rent_st, '1','','2','(��)') rent_st_nm, a.ext_st, a.ext_tm, decode(a.ext_pay_dt, '',nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0), nvl(a.ext_pay_amt,0)) ext_amt,"+
				"        a.ext_pay_amt, b.firm_nm, b.client_nm, b.rent_way, b.rent_way_cd, b.bus_id, h.cls_dt , "+
				"        b.con_mon, a.ext_s_amt, a.ext_v_amt, b.rent_dt, b.rent_start_dt, nvl(cr.car_no, '') car_no, "+
				"        decode(nvl(a.ext_EST_DT,a.ext_pay_dt), '', '', substr(nvl(a.ext_EST_DT,a.ext_pay_dt), 1, 4) || '-' || substr(nvl(a.ext_EST_DT,a.ext_pay_dt), 5, 2) || '-'||substr(nvl(a.ext_EST_DT,a.ext_pay_dt), 7, 2)) EXT_EST_DT,"+
				"        decode(a.EXT_PAY_DT, '', '', substr(a.EXT_PAY_DT, 1, 4) || '-' || substr(a.ext_PAY_DT, 5, 2) || '-'||substr(a.ext_PAY_DT, 7, 2)) EXT_PAY_DT, c.rent_suc_dt"+
				" from   scd_ext a, cont_n_view b, cont_etc c, client d , car_reg cr ,  cls_cont h \n"+
				" where  a.ext_st in ('0', '1', '2','5') \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and b.car_mng_id = cr.car_mng_id(+) \n"+
				"        and nvl(a.ext_s_amt,0)+nvl(a.ext_pay_amt,0) <> 0 and nvl(a.bill_yn,'Y')='Y' \n"+
				"        and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) \n"+
				"        and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+) \n"+
				"        and b.client_id=d.client_id \n"+
				" ";

		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and ( nvl(a.ext_est_dt,a.ext_pay_dt) like to_char(sysdate,'YYYYMM')||'%' or nvl(a.ext_est_dt,a.ext_pay_dt) is null)";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and nvl(a.ext_est_dt,a.ext_pay_dt) like to_char(sysdate,'YYYYMM')||'%' and a.ext_pay_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and ( nvl(a.ext_est_dt,a.ext_pay_dt) like to_char(sysdate,'YYYYMM')||'%' or nvl(a.ext_est_dt,a.ext_pay_dt) is null) and a.ext_pay_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and nvl(a.ext_est_dt,a.ext_pay_dt) = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and nvl(a.ext_est_dt,a.ext_pay_dt) = to_char(sysdate,'YYYYMMDD') and a.ext_pay_dt is not null";//
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and nvl(a.ext_est_dt,a.ext_pay_dt) = to_char(sysdate,'YYYYMMDD') and a.ext_pay_dt is null";
		//��ü-��ȹ
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and replace(b.rent_start_dt,'-','') < to_char(sysdate,'YYYYMMDD') and (a.ext_pay_dt is null or a.ext_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//��ü-����
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and replace(b.rent_start_dt,'-','') < to_char(sysdate,'YYYYMMDD') and a.ext_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//��ü-�̼���
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and replace(b.rent_start_dt,'-','') < to_char(sysdate,'YYYYMMDD') and a.ext_pay_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and nvl(a.ext_est_dt,a.ext_pay_dt) between '"+AddUtil.ChangeString(st_dt)+"' and '"+AddUtil.ChangeString(end_dt)+"'";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and nvl(a.ext_est_dt,a.ext_pay_dt) between '"+AddUtil.ChangeString(st_dt)+"' and '"+AddUtil.ChangeString(end_dt)+"' and a.ext_pay_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and nvl(a.ext_est_dt,a.ext_pay_dt) between '"+AddUtil.ChangeString(st_dt)+"' and '"+AddUtil.ChangeString(end_dt)+"' and a.ext_pay_dt is null";
		//����+��ü-��ȹ
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and (replace(nvl(nvl(a.ext_est_dt,a.ext_pay_dt),nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD'))),'-','') <= to_char(sysdate,'YYYYMMDD') and (a.ext_pay_dt is null or a.ext_pay_dt = to_char(sysdate,'YYYYMMDD')) or a.ext_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//����+��ü-����
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and (replace(nvl(nvl(a.ext_est_dt,a.ext_pay_dt),nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD'))),'-','') <= to_char(sysdate,'YYYYMMDD') and a.ext_pay_dt = to_char(sysdate,'YYYYMMDD') or a.ext_pay_dt = to_char(sysdate,'YYYYMMDD')) ";
		//����+��ü-�̼���
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and replace(nvl(nvl(a.ext_est_dt,a.ext_pay_dt),nvl(b.rent_start_dt,to_char(sysdate,'YYYYMMDD'))),'-','') <= to_char(sysdate,'YYYYMMDD') and a.ext_pay_dt is null";
		//�˻�-����
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.ext_pay_dt is not null";
		//�˻�-�̼���
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.ext_pay_dt is null and nvl(h.cls_st,'0') not in ('7','10')";
		}else{
		}


		if(!gubun4.equals(""))		query += " and a.ext_st='"+gubun4+"'";

		/*�˻�����*/
			
		if(!t_wd.equals("")){
			if(s_kd.equals("2"))		query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("5"))	query += " and (a.ext_s_amt+a.ext_v_amt) like '%"+t_wd+"%'\n";
			else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("8"))	query += " and b.bus_id2= '"+t_wd+"'\n";
			else if(s_kd.equals("9"))	query += " and cr.car_nm like '%"+t_wd+"%'\n";
			else if(s_kd.equals("10"))	query += " and d.enp_no like '%"+t_wd+"%'\n";
			else if(s_kd.equals("11"))	query += " and TEXT_DECRYPT(d.ssn, 'pw' )  like '%"+t_wd+"%'\n";
			else						query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		}

		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.ext_est_dt "+sort+", a.ext_pay_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.ext_pay_dt, a.ext_est_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.ext_pay_dt "+sort+", b.firm_nm, a.ext_est_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.ext_s_amt "+sort+", a.ext_pay_dt, b.firm_nm, a.ext_est_dt";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.car_no "+sort+", b.firm_nm, a.ext_est_dt";

		
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
			System.out.println("[AddExtDatabase:getGrtList2]\n"+e);
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
	 *	������,������,�ʱ�뿩�� insert
	 */
	
	public boolean insertGrt(ExtScdBean grt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "";
		query = " insert into scd_ext ("+
				" RENT_MNG_ID, RENT_L_CD, RENT_ST, RENT_SEQ, EXT_ST, EXT_ID,  EXT_TM, EXT_S_AMT, EXT_V_AMT, EXT_EST_DT, EXT_PAY_AMT, EXT_PAY_DT, GUBUN, bill_yn, update_id, update_dt)"+
				" values ( ?, ?, ?, '1', ?, '0', ?, ?, ?, replace(?, '-', ''), ?, replace(?, '-', ''), ?, 'Y', ?, to_char(sysdate,'YYYYMMDD'))";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  grt.getRent_mng_id	());
			pstmt.setString(2,  grt.getRent_l_cd	());
			pstmt.setString(3,  grt.getRent_st		());
			pstmt.setString(4,  grt.getExt_st		());
			pstmt.setString(5,  grt.getExt_tm		());
			pstmt.setInt   (6,  grt.getExt_s_amt	());
			pstmt.setInt   (7,  grt.getExt_v_amt	());
			pstmt.setString(8,  grt.getExt_est_dt	());
			pstmt.setInt   (9,  grt.getExt_pay_amt	());
			pstmt.setString(10, grt.getExt_pay_dt	());
			pstmt.setString(11, grt.getGubun		());
			pstmt.setString(12, grt.getUpdate_id	());
		    pstmt.executeUpdate();
			pstmt.close();
			
			
			conn.commit();
		    
	  	} catch (Exception e) {
		  	System.out.println("[AddExtDatabase:insertGrt]\n"+e);
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

	/**	
	 *	������,������,�ʱ�뿩��� insert
	 */
	
	public boolean insertGrtEtc(ExtScdBean grt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "";
		query = " insert into scd_ext ("+
				" RENT_MNG_ID, RENT_L_CD, RENT_ST, RENT_SEQ, EXT_ST, EXT_ID,  EXT_TM, EXT_S_AMT, EXT_V_AMT, EXT_EST_DT, EXT_PAY_AMT, EXT_PAY_DT, GUBUN, bill_yn, update_id, update_dt)"+
				" values ( ?, ?, ?, '1', ?, ?, ?, ?, ?, replace(?, '-', ''), ?, replace(?, '-', ''), ?, 'Y', ?, to_char(sysdate,'YYYYMMDD'))";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  grt.getRent_mng_id	());
			pstmt.setString(2,  grt.getRent_l_cd	());
			pstmt.setString(3,  grt.getRent_st		());
			pstmt.setString(4,  grt.getExt_st		());
			pstmt.setString(5,  grt.getExt_id		());
			pstmt.setString(6,  grt.getExt_tm		());
			pstmt.setInt   (7,  grt.getExt_s_amt	());
			pstmt.setInt   (8,  grt.getExt_v_amt	());
			pstmt.setString(9,  grt.getExt_est_dt	());
			pstmt.setInt   (10, grt.getExt_pay_amt	());
			pstmt.setString(11, grt.getExt_pay_dt	());
			pstmt.setString(12, grt.getGubun		());
			pstmt.setString(13, grt.getUpdate_id	());
		    pstmt.executeUpdate();
			pstmt.close();
						
			conn.commit();
		    
	  	} catch (Exception e) {
		  	System.out.println("[AddExtDatabase:insertGrtEtc]\n"+e);
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


	/**
	 *	������ update -- ��� main���� ����. ���� �׻� 1ȸ���� ���ؼ��� �����
	 */
	
	public boolean updateGrt(ExtScdBean grt)
	{
		int flag = 0;

		ExtScdBean old_grt = getAGrtScd(grt.getRent_mng_id(), grt.getRent_l_cd(), grt.getRent_st(), grt.getExt_st(), grt.getExt_tm());

		int old_amt		= old_grt.getExt_s_amt()+old_grt.getExt_v_amt();
		int new_amt		= grt.getExt_s_amt()+ grt.getExt_v_amt();
		int old_s_amt	= old_grt.getExt_s_amt();
		int new_s_amt	= grt.getExt_s_amt();
				
		String old_est_dt = old_grt.getExt_est_dt();
		String new_est_dt = grt.getExt_est_dt();
		
		//�Աݿ����ݾ� ���� 
		if((new_amt != old_amt))
		{
			int change_amt = new_amt - old_amt;
			//�ش�׷��� ����Ʈ�� ���� �����´�. why? ���ް�/�ΰ����� �ٽ� �������� �ϴϱ�.
			Vector grts = getGrtScdAll(grt.getRent_mng_id(), grt.getRent_l_cd(), grt.getRent_st(), grt.getExt_st());
			int grt_size = grts.size();
			for(int i = 0 ; i < grt_size ; i++)
			{
				ExtScdBean a_grt = (ExtScdBean)grts.elementAt(i);
				int before_amt 	= a_grt.getExt_s_amt()+a_grt.getExt_v_amt();
				int after_amt 	= before_amt + change_amt;
				int after_s_amt = 0;
				if(a_grt.getExt_st().equals("0"))	//�������ΰ�� �ΰ��� ����.
					after_s_amt = after_amt;
				else
					after_s_amt = Math.round((new Double(after_amt/1.1)).intValue());
				a_grt.setExt_s_amt	(after_s_amt);
				a_grt.setExt_v_amt	(after_amt - after_s_amt);
				a_grt.setExt_est_dt	(grt.getExt_est_dt());
				a_grt.setUpdate_id	(grt.getUpdate_id());
				if(!i_updateGrt(a_grt))	flag += 1;
				
				//�߿�����! �ϳ��� ���, �ٲ� �Աݿ������� �Ա�ó���׺��� ũ�� ��ȸ�� �� �����ؾ� �Ѵ�.
				if(((i+1) == grt_size) && (a_grt.getExt_pay_amt() != 0))
				{
					int balance_amt = (a_grt.getExt_s_amt()+a_grt.getExt_v_amt()) - a_grt.getExt_pay_amt();
					if(balance_amt != 0)
					{
						int balance_s_amt = 0;
						if(grt.getExt_st().equals("0") || grt.getExt_st().equals("7"))	//������,���ź����� �ΰ�� �ΰ��� ����.
							balance_s_amt = balance_amt;
						else
							balance_s_amt = (new Double(balance_amt/1.1)).intValue();
						
						ExtScdBean rest_grt = new ExtScdBean();
						rest_grt.setRent_mng_id	(a_grt.getRent_mng_id());
						rest_grt.setRent_l_cd	(a_grt.getRent_l_cd());
						rest_grt.setRent_st		(a_grt.getRent_st());
						rest_grt.setRent_seq	(a_grt.getRent_seq());
						rest_grt.setExt_st		(a_grt.getExt_st());
						rest_grt.setExt_id		(a_grt.getExt_id());
						rest_grt.setExt_tm		(String.valueOf(Integer.parseInt(a_grt.getExt_tm())+1));
						rest_grt.setExt_s_amt	(balance_s_amt);
						rest_grt.setExt_v_amt	(balance_amt - balance_s_amt);
						rest_grt.setExt_est_dt	(grt.getExt_est_dt());
						rest_grt.setUpdate_id	(a_grt.getUpdate_id());
											
						if(!insertGrt(rest_grt))	flag += 1;
					}//end of if
					
					//�뿩�� table�� �Աݱ���(�ܾ�) ����
					ContFeeBean fee = AddContDatabase.getInstance().getContFeeNew(grt.getRent_mng_id(), grt.getRent_l_cd(), grt.getRent_st());
					if(grt.getExt_st().equals("0"))				fee.setGrt_pay_yn("1");		//�������ܾ׻���
					else if(grt.getExt_st().equals("1"))		fee.setPp_pay_yn("1");		//�������ܾ׻���
					else if(grt.getExt_st().equals("2"))		fee.setIfee_pay_yn("1");		//�ʱ�뿩���ܾ׻���
					
					if(!AddContDatabase.getInstance().updateContFeeNew(fee))	flag += 1;					
				}//end of if
			}//end of for
		}
		//�Աݿ������� �ٲ� ��� �Ʒ�ȸ�� �Աݿ����ϸ�� ����
		else if(!new_est_dt.equals(old_est_dt))	
		{
			Vector grts = getGrtScdAll(grt.getRent_mng_id(), grt.getRent_l_cd(), grt.getRent_st(), grt.getExt_st());
			int grt_size = grts.size();
			for(int i = 0 ; i < grt_size ; i++)
			{
				ExtScdBean a_grt = (ExtScdBean)grts.elementAt(i);
				a_grt.setExt_est_dt(new_est_dt);
				if(!i_updateGrt(a_grt))	flag += 1;
			}				
		}
		if(flag == 0)	return true;
		else 			return false;
	}

	/**
	 *	������ ���� 
	 */
	public boolean receiptGrt(ExtScdBean grt)
	{
		int flag = 0;
		ExtScdBean old_grt = getAGrtScd(grt.getRent_mng_id(), grt.getRent_l_cd(), grt.getRent_st(), grt.getExt_st(), grt.getExt_tm());
		int old_amt = old_grt.getExt_s_amt()+old_grt.getExt_v_amt();
		int pay_amt = grt.getExt_pay_amt();
		
		//1.�Ա��� �ݾ��� ������� �ܾ�ȸ������(�Ա�-�ܾ׻���)
		if(pay_amt < old_amt)
		{
			if(!i_updateGrt(grt))	flag += 1;
			
			int rest_amt = old_amt - pay_amt;
			int rest_s_amt = 0;
		//	if(grt.getExt_st().equals("0"))	//�������ΰ�� �ΰ��� ����.
				rest_s_amt = rest_amt;  //�ܾ��� ���ް���ó��
		//	else
		//		rest_s_amt = (new Double(rest_amt/1.1)).intValue();
			
			ExtScdBean rest_grt = new ExtScdBean();
			rest_grt.setRent_mng_id(grt.getRent_mng_id());
			rest_grt.setRent_l_cd(grt.getRent_l_cd());
			rest_grt.setRent_st(grt.getRent_st());
			rest_grt.setExt_st(grt.getExt_st());
			rest_grt.setExt_tm(String.valueOf(Integer.parseInt(grt.getExt_tm())+1));
			rest_grt.setExt_s_amt(rest_s_amt);
			rest_grt.setExt_v_amt(rest_amt - rest_s_amt);
			rest_grt.setExt_est_dt(grt.getExt_est_dt());
					
			if(!insertGrt(rest_grt))	flag += 1;
			
			//�뿩�� table�� �Աݱ���(�ܾ�) ����
			ContFeeBean fee = AddContDatabase.getInstance().getContFeeNew(grt.getRent_mng_id(), grt.getRent_l_cd(), grt.getRent_st());
			if(grt.getExt_st().equals("0"))			  	fee.setGrt_pay_yn("1");		//�������ܾ׻���
			else if(grt.getExt_st().equals("1"))		fee.setPp_pay_yn("1");		//�������ܾ׻���
			else if(grt.getExt_st().equals("2"))		fee.setIfee_pay_yn("1");		//�ʱ�뿩���ܾ׻���
			
			if(!AddContDatabase.getInstance().updateContFeeNew(fee))	flag += 1;
		}
		//2. �Աݾװ� �Աݿ����ݾ��� ������� �׳� update(�ԱݿϷ�)
		else
		{
			if(!i_updateGrt(grt))	flag += 1;
			//�뿩�� table�� �Աݱ���(�ϳ�) ����
			ContFeeBean fee = AddContDatabase.getInstance().getContFeeNew(grt.getRent_mng_id(), grt.getRent_l_cd(), grt.getRent_st());
			if(grt.getExt_st().equals("0"))				    fee.setGrt_pay_yn("2");		//�����ݿϳ�
			else if(grt.getExt_st().equals("1"))			fee.setPp_pay_yn("2");		//�����ݿϳ�
			else if(grt.getExt_st().equals("2"))			fee.setIfee_pay_yn("2");		//�ʱ�뿩��ϳ�
			
			if(!AddContDatabase.getInstance().updateContFeeNew(fee))	flag += 1;
		}
		
		if(flag == 0)	return true;
		else			return false;
	}	
	
		
	

	/**
	 *	��ȸ�������ݽ����� ����
	 */
	
	public ExtScdBean getAGrtScd(String m_id, String l_cd, String r_st, String pp_st, String pp_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ExtScdBean ext = new ExtScdBean();	
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, RENT_ST, EXT_ST, EXT_TM, EXT_S_AMT, EXT_V_AMT, EXT_PAY_AMT,"+
				" decode(EXT_EST_DT, '', '', substr(EXT_EST_DT, 1, 4) || '-' || substr(EXT_EST_DT, 5, 2) || '-'||substr(EXT_EST_DT, 7, 2)) EXT_EST_DT,"+
				" decode(EXT_PAY_DT, '', '', substr(EXT_PAY_DT, 1, 4) || '-' || substr(EXT_PAY_DT, 5, 2) || '-'||substr(EXT_PAY_DT, 7, 2)) EXT_PAY_DT, incom_dt, incom_seq, seqid, update_id, update_dt "+
				" from scd_ext"+
				" where RENT_MNG_ID = ? and RENT_L_CD = ? and RENT_ST = ? and EXT_ST = ? and EXT_TM = ? and nvl(bill_yn, 'Y') = 'Y'";		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, r_st);
			pstmt.setString(4, pp_st);
			pstmt.setString(5, pp_tm);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{
				ext.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ext.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ext.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				ext.setExt_st(rs.getString("EXT_ST")==null?"":rs.getString("EXT_ST"));
				ext.setExt_tm(rs.getString("EXT_TM")==null?"":rs.getString("EXT_TM"));
				ext.setExt_s_amt(rs.getString("EXT_S_AMT")==null?0:Integer.parseInt(rs.getString("EXT_S_AMT")));
				ext.setExt_v_amt(rs.getString("EXT_V_AMT")==null?0:Integer.parseInt(rs.getString("EXT_V_AMT")));
				ext.setExt_est_dt(rs.getString("EXT_EST_DT")==null?"":rs.getString("EXT_EST_DT"));
				ext.setExt_pay_amt(rs.getString("EXT_PAY_AMT")==null?0:Integer.parseInt(rs.getString("EXT_PAY_AMT")));
				ext.setExt_pay_dt(rs.getString("EXT_PAY_DT")==null?"":rs.getString("EXT_PAY_DT"));
				ext.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				ext.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				ext.setSeqId(rs.getString("seqid")==null?"":rs.getString("seqid"));
				ext.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				ext.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				ext.setSeqId(rs.getString("seqid")==null?"":rs.getString("seqid"));
				ext.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				ext.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
		  	System.out.println("[AddExtDatabase:getAGrtScd(String m_id, String l_cd, String r_st, String pp_st, String pp_tm)]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ext;
		}				
	}
	

	/**
	 *	������, ������, �ʱ�뿩�� query (��ȿ�� �͸�. --- 0���� row ����)
	 *	pp_st - 0:������, 1:������, 2:�ʱ�뿩��
	 */
	
	public Vector getExtScd(String m_id, String l_cd, String r_st, String ext_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select RENT_MNG_ID, RENT_L_CD, RENT_ST, EXT_ST, EXT_TM, EXT_S_AMT, EXT_V_AMT,"+
						" decode(EXT_DT, '', '', substr(EXT_DT, 1, 4) || '-' || substr(EXT_DT, 5, 2) || '-'||substr(EXT_DT, 7, 2)) EXT_DT,"+
						" decode(EXT_EST_DT, '', '', substr(EXT_EST_DT, 1, 4) || '-' || substr(EXT_EST_DT, 5, 2) || '-'||substr(EXT_EST_DT, 7, 2)) EXT_EST_DT,"+
						" EXT_PAY_AMT,"+
						" decode(EXT_PAY_DT, '', '', substr(EXT_PAY_DT, 1, 4) || '-' || substr(EXT_PAY_DT, 5, 2) || '-'||substr(EXT_PAY_DT, 7, 2)) EXT_PAY_DT, incom_dt, incom_seq "+
						" from scd_ext"+
						" where RENT_MNG_ID = ? and RENT_L_CD = ? and EXT_ST = ? and (EXT_S_AMT+EXT_V_AMT) != 0 and nvl(bill_yn, 'Y') = 'Y' "+//and RENT_ST = ?
						" order by RENT_ST, to_number(EXT_TM)";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, m_id);
				pstmt.setString(2, l_cd);
//				pstmt.setString(3, r_st);
				pstmt.setString(3, ext_st);
		    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				ExtScdBean ext = new ExtScdBean();	
				ext.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ext.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ext.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				ext.setExt_st(rs.getString("EXT_ST")==null?"":rs.getString("EXT_ST"));
				ext.setExt_tm(rs.getString("EXT_TM")==null?"":rs.getString("EXT_TM"));
				ext.setExt_s_amt(rs.getString("EXT_S_AMT")==null?0:Integer.parseInt(rs.getString("EXT_S_AMT")));
				ext.setExt_v_amt(rs.getString("EXT_V_AMT")==null?0:Integer.parseInt(rs.getString("EXT_V_AMT")));
				ext.setExt_est_dt(rs.getString("EXT_EST_DT")==null?"":rs.getString("EXT_EST_DT"));
				ext.setExt_pay_amt(rs.getString("EXT_PAY_AMT")==null?0:Integer.parseInt(rs.getString("EXT_PAY_AMT")));
				ext.setExt_pay_dt(rs.getString("EXT_PAY_DT")==null?"":rs.getString("EXT_PAY_DT"));
				ext.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				ext.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				ext.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				vt.add(ext);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getExtScd]\n"+e);
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
	 *	������, ������, �ʱ�뿩�� query (��ȿ�� �͸�. --- 0���� row ����) -> ���ݰ�꼭 ����
	 *	pp_st - 0:������, 1:������, 2:�ʱ�뿩��
	 */
	
	public Vector getExtScd(String m_id, String l_cd, String ext_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query =  " select a.RENT_MNG_ID, a.RENT_L_CD, a.RENT_ST, a.EXT_ST, a.EXT_TM, a.EXT_S_AMT, a.EXT_V_AMT, a.seqid, b.pubcode,"+
						"        decode(j.tax_dt, '', '', substr(j.tax_dt, 1, 4) || '-' || substr(j.tax_dt, 5, 2) || '-'||substr(j.tax_dt, 7, 2)) EXT_DT,"+
						"        decode(a.EXT_EST_DT, '', '', substr(a.EXT_EST_DT, 1, 4) || '-' || substr(a.EXT_EST_DT, 5, 2) || '-'||substr(a.EXT_EST_DT, 7, 2)) EXT_EST_DT,"+
						"        a.EXT_PAY_AMT,"+
						"        decode(a.EXT_PAY_DT, '', '', substr(a.EXT_PAY_DT, 1, 4) || '-' || substr(a.EXT_PAY_DT, 5, 2) || '-'||substr(a.EXT_PAY_DT, 7, 2)) EXT_PAY_DT, "+
						"        incom_dt, incom_seq, substr(c.statusdate,15,2) pay_status,"+
						"	     decode(substr(c.statusdate,15,2) , '25' , '�����ڹ̵��' , '30' , '�����ڹ�Ȯ��' , '35' , '�����ڹ̽���' , '50' , '�����ڽ���' , '60' , '���Űź�' , '65' , '�����ڹ�����ҿ�û' , '66' , '�����ڹ�����ҿ�û' , '99' , '�߱����' , '11' , '�ߺ�����Ÿ' , '12' , 'ID����ġ' , '13' , '����������ġ' , '14' , '��Ÿ����' , decode( a.seqid , '' , '' , '���' ) ) status  \n"+
						" from   scd_ext a, payebill b,"+
						"        (select aa.rent_l_cd, aa.tm, aa.gubun, sum(aa.item_supply) item_supply, max(bb.tax_dt) tax_dt "+
					    "         from   tax_item_list aa, tax bb "+
				        "         where  aa.item_id=bb.item_id and aa.gubun in ('3','4','14') and bb.tax_st<>'C' group by aa.rent_l_cd, aa.tm, aa.gubun ) j,"+
//						"        (select aa.*, decode(gubun,'3','1','4','2','14','5') pp_st from tax aa where aa.tax_st='O' and aa.gubun in ('3','4','14') and aa.tax_supply > 0 and aa.doctype is null) k"+
						"	               ( "+
						"	                SELECT /*+ leading(t1 t2 a) use_nl(t1 t2 a) */ "+
						"	                       a.pubcode , "+
						"	                       MAX( a.statusdate||a.status ) statusdate "+
						"	                FROM   amazoncar.eb_history a "+
						"	                WHERE  a.status NOT IN ( '11' ) "+
						"	                GROUP  BY a.pubcode "+
						"	               ) c "+
						" where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ? and a.EXT_ST = ? and (a.EXT_S_AMT+a.EXT_V_AMT+a.ext_pay_amt) != 0"+//and RENT_ST = ?
						"        and a.seqid=b.seqid(+) and nvl(a.bill_yn, 'Y') = 'Y' "+
						"        and a.rent_l_cd=j.rent_l_cd(+) and a.rent_st=j.tm(+) and decode(a.ext_st,'1','3','2','4','5','14')=j.gubun(+) and a.ext_s_amt=j.item_supply(+)"+
//						"        and a.rent_l_cd=k.rent_l_cd(+) and a.rent_st=k.fee_tm(+) and a.ext_st=k.pp_st(+)"+
						"        and b.pubcode=c.pubcode(+) "+
						" order by a.RENT_ST, to_number(a.EXT_TM)";
		try {
				pstmt = conn.prepareStatement(query);


				
				pstmt.setString(1, m_id);
				pstmt.setString(2, l_cd);
				pstmt.setString(3, ext_st);
		    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				ExtScdBean ext = new ExtScdBean();	
				ext.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ext.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ext.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				ext.setExt_st(rs.getString("EXT_ST")==null?"":rs.getString("EXT_ST"));
				ext.setExt_tm(rs.getString("EXT_TM")==null?"":rs.getString("EXT_TM"));
				ext.setExt_s_amt(rs.getString("EXT_S_AMT")==null?0:Integer.parseInt(rs.getString("EXT_S_AMT")));
				ext.setExt_v_amt(rs.getString("EXT_V_AMT")==null?0:Integer.parseInt(rs.getString("EXT_V_AMT")));
				ext.setExt_est_dt(rs.getString("EXT_EST_DT")==null?"":rs.getString("EXT_EST_DT"));
				ext.setExt_pay_amt(rs.getString("EXT_PAY_AMT")==null?0:Integer.parseInt(rs.getString("EXT_PAY_AMT")));
				ext.setExt_pay_dt(rs.getString("EXT_PAY_DT")==null?"":rs.getString("EXT_PAY_DT"));
				ext.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				ext.setSeqId(rs.getString("SEQID")==null?"":rs.getString("SEQID"));
				ext.setPubCode(rs.getString("PUBCODE")==null?"":rs.getString("PUBCODE"));
				ext.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				ext.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				ext.setStatus(rs.getString("status")==null?"":rs.getString("status"));
				
				vt.add(ext);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getExtScd(String m_id, String l_cd, String ext_st)]\n"+e);
			System.out.println("[AddExtDatabase:getExtScd(String m_id, String l_cd, String ext_st)]\n"+query);
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
	 *	������, ������, �ʱ�뿩�� query (����)
	 *	pp_st - 0:������, 1:������, 2:�ʱ�뿩��
	 */
	
	public Vector getGrtScdAll(String m_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, RENT_ST, EXT_ST, EXT_TM, EXT_S_AMT, EXT_V_AMT, EXT_PAY_AMT,"+
				" decode(EXT_EST_DT, '', '', substr(EXT_EST_DT, 1, 4) || '-' || substr(EXT_EST_DT, 5, 2) || '-'||substr(EXT_EST_DT, 7, 2)) EXT_EST_DT,"+
				" decode(EXT_PAY_DT, '', '', substr(EXT_PAY_DT, 1, 4) || '-' || substr(EXT_PAY_DT, 5, 2) || '-'||substr(EXT_PAY_DT, 7, 2)) EXT_PAY_DT, incom_dt, incom_seq, update_id, update_dt "+
				" from scd_ext "+
				" where ext_st in ('0','1','2') and RENT_MNG_ID = ? and RENT_L_CD = ? and nvl(bill_yn, 'Y' ) = 'Y' "+
				" order by to_number(EXT_TM)";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				ExtScdBean grt = new ExtScdBean();	
				grt.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				grt.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				grt.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				grt.setExt_st(rs.getString("EXT_ST")==null?"":rs.getString("EXT_ST"));
				grt.setExt_tm(rs.getString("EXT_TM")==null?"":rs.getString("EXT_TM"));
				grt.setExt_s_amt(rs.getString("EXT_S_AMT")==null?0:Integer.parseInt(rs.getString("EXT_S_AMT")));
				grt.setExt_v_amt(rs.getString("EXT_V_AMT")==null?0:Integer.parseInt(rs.getString("EXT_V_AMT")));
				grt.setExt_est_dt(rs.getString("EXT_EST_DT")==null?"":rs.getString("EXT_EST_DT"));
				grt.setExt_pay_amt(rs.getString("EXT_PAY_AMT")==null?0:Integer.parseInt(rs.getString("EXT_PAY_AMT")));
				grt.setExt_pay_dt(rs.getString("EXT_PAY_DT")==null?"":rs.getString("EXT_PAY_DT"));
				grt.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				grt.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				grt.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				grt.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));

				vt.add(grt);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
		  	System.out.println("[AddExtDatabase:getGrtScdAll]\n"+e);
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
	 *	������, ������, �ʱ�뿩�� query (����)
	 *	pp_st - 0:������, 1:������, 2:�ʱ�뿩��
	 */
	
	public Vector getGrtScdAll(String m_id, String l_cd, String r_st, String pp_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, RENT_ST, EXT_ST, EXT_TM, EXT_S_AMT, EXT_V_AMT, EXT_PAY_AMT,"+
				" decode(EXT_EST_DT, '', '', substr(EXT_EST_DT, 1, 4) || '-' || substr(EXT_EST_DT, 5, 2) || '-'||substr(EXT_EST_DT, 7, 2)) EXT_EST_DT,"+
				" decode(EXT_PAY_DT, '', '', substr(EXT_PAY_DT, 1, 4) || '-' || substr(EXT_PAY_DT, 5, 2) || '-'||substr(EXT_PAY_DT, 7, 2)) EXT_PAY_DT, incom_dt, incom_seq, update_id, update_dt "+
				" from scd_ext "+
				" where RENT_MNG_ID = ? and RENT_L_CD = ? and RENT_ST = ? and EXT_ST = ? "+
				" order by to_number(EXT_TM)";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, r_st);
			pstmt.setString(4, pp_st);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				ExtScdBean grt = new ExtScdBean();	
				grt.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				grt.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				grt.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				grt.setExt_st(rs.getString("EXT_ST")==null?"":rs.getString("EXT_ST"));
				grt.setExt_tm(rs.getString("EXT_TM")==null?"":rs.getString("EXT_TM"));
				grt.setExt_s_amt(rs.getString("EXT_S_AMT")==null?0:Integer.parseInt(rs.getString("EXT_S_AMT")));
				grt.setExt_v_amt(rs.getString("EXT_V_AMT")==null?0:Integer.parseInt(rs.getString("EXT_V_AMT")));
				grt.setExt_est_dt(rs.getString("EXT_EST_DT")==null?"":rs.getString("EXT_EST_DT"));
				grt.setExt_pay_amt(rs.getString("EXT_PAY_AMT")==null?0:Integer.parseInt(rs.getString("EXT_PAY_AMT")));
				grt.setExt_pay_dt(rs.getString("EXT_PAY_DT")==null?"":rs.getString("EXT_PAY_DT"));
				grt.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				grt.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				grt.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				grt.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));

				vt.add(grt);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
		  	System.out.println("[AddExtDatabase:getGrtScdAll]\n"+e);
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
	 *	������, ������, �ʱ�뿩�� query (����)
	 *	pp_st - 0:������, 1:������, 2:�ʱ�뿩��
	 */
	 
	public ExtScdBean getGrtScdAll2(String m_id, String l_cd, String r_st, String pp_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ExtScdBean grt = new ExtScdBean();	
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, RENT_ST, EXT_ST, EXT_TM, EXT_S_AMT, EXT_V_AMT, EXT_PAY_AMT,"+
				" decode(EXT_EST_DT, '', '', substr(EXT_EST_DT, 1, 4) || '-' || substr(EXT_EST_DT, 5, 2) || '-'||substr(EXT_EST_DT, 7, 2)) EXT_EST_DT,"+
				" decode(EXT_PAY_DT, '', '', substr(EXT_PAY_DT, 1, 4) || '-' || substr(EXT_PAY_DT, 5, 2) || '-'||substr(EXT_PAY_DT, 7, 2)) EXT_PAY_DT, incom_dt, incom_seq, update_id, update_dt "+
				" from scd_ext"+
				" where RENT_MNG_ID = ? and RENT_L_CD = ? and RENT_ST = ? and EXT_ST = ? "+
				" order by to_number(EXT_TM)";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, r_st);
			pstmt.setString(4, pp_st);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{
				grt.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				grt.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				grt.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				grt.setExt_st(rs.getString("EXT_ST")==null?"":rs.getString("EXT_ST"));
				grt.setExt_tm(rs.getString("EXT_TM")==null?"":rs.getString("EXT_TM"));
				grt.setExt_s_amt(rs.getString("EXT_S_AMT")==null?0:Integer.parseInt(rs.getString("EXT_S_AMT")));
				grt.setExt_v_amt(rs.getString("EXT_V_AMT")==null?0:Integer.parseInt(rs.getString("EXT_V_AMT")));
				grt.setExt_est_dt(rs.getString("EXT_EST_DT")==null?"":rs.getString("EXT_EST_DT"));
				grt.setExt_pay_amt(rs.getString("EXT_PAY_AMT")==null?0:Integer.parseInt(rs.getString("EXT_PAY_AMT")));
				grt.setExt_pay_dt(rs.getString("EXT_PAY_DT")==null?"":rs.getString("EXT_PAY_DT"));
				grt.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				grt.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				grt.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				grt.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
		  	System.out.println("[AddGrtDatabase:getGrtScdAll2]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return grt;
		}			
	}	

	/**
	 *	��ȸ�� ������ update
	 */
	
	public boolean i_updateGrt(ExtScdBean grt)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;
		String query = " update scd_ext set"+
						" EXT_S_AMT = ?,"+
						" EXT_V_AMT = ?,"+
						" EXT_EST_DT = replace(?, '-', ''),"+
						" EXT_PAY_AMT = ?,"+
						" EXT_PAY_DT = replace(?, '-', ''),"+
						" seqid= ? , incom_dt = replace(?, '-', ''), incom_seq = ? , update_id = ?, update_dt = to_char(sysdate,'YYYYMMdd') "+
						" where RENT_MNG_ID = ? and RENT_L_CD = ? and RENT_ST = ? and EXT_ST = ? and EXT_TM = ?";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, grt.getExt_s_amt());
			pstmt.setInt(2, grt.getExt_v_amt());
			pstmt.setString(3, grt.getExt_est_dt());
			pstmt.setInt(4, grt.getExt_pay_amt());
			pstmt.setString(5, grt.getExt_pay_dt());
			pstmt.setString(6, grt.getSeqId());
			pstmt.setString(7, grt.getIncom_dt());
			pstmt.setInt(8, grt.getIncom_seq());
			pstmt.setString(9, grt.getUpdate_id());
			pstmt.setString(10, grt.getRent_mng_id());
			pstmt.setString(11, grt.getRent_l_cd());
			pstmt.setString(12, grt.getRent_st());
			pstmt.setString(13, grt.getExt_st());
			pstmt.setString(14, grt.getExt_tm());				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[AddExtDatabase:i_updateGrt]\n"+e);
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
	
	public boolean i_updateGrtEct(ExtScdBean grt)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;
		String query = " update scd_ext set"+
						" EXT_S_AMT = ?,"+
						" EXT_V_AMT = ?,"+
						" EXT_EST_DT = replace(?, '-', ''),"+
						" EXT_PAY_AMT = ?,"+
						" EXT_PAY_DT = replace(?, '-', ''),"+
						" seqid= ? , incom_dt = replace(?, '-', ''), incom_seq = ? , update_id = ?, update_dt = to_char(sysdate,'YYYYMMdd') "+
						" where RENT_MNG_ID = ? and RENT_L_CD = ? and RENT_ST = ? and EXT_ST = ? and EXT_TM = ? and EXT_ID = ?";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setInt   (1, grt.getExt_s_amt());
			pstmt.setInt   (2, grt.getExt_v_amt());
			pstmt.setString(3, grt.getExt_est_dt());
			pstmt.setInt   (4, grt.getExt_pay_amt());
			pstmt.setString(5, grt.getExt_pay_dt());
			pstmt.setString(6, grt.getSeqId());
			pstmt.setString(7, grt.getIncom_dt());
			pstmt.setInt   (8, grt.getIncom_seq());
			pstmt.setString(9, grt.getUpdate_id());
			pstmt.setString(10, grt.getRent_mng_id());
			pstmt.setString(11, grt.getRent_l_cd());
			pstmt.setString(12, grt.getRent_st());
			pstmt.setString(13, grt.getExt_st());
			pstmt.setString(14, grt.getExt_tm());				
			pstmt.setString(15, grt.getExt_id());				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[AddExtDatabase:i_updateGrtEct]\n"+e);
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
	
	public boolean deleteGrt(ExtScdBean grt)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;
		String query = " delete from scd_ext "+
						" where RENT_MNG_ID = ? and RENT_L_CD = ? and RENT_ST = ? and EXT_ST = ? and EXT_TM = ?";
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, grt.getRent_mng_id());
			pstmt.setString(2, grt.getRent_l_cd());
			pstmt.setString(3, grt.getRent_st());
			pstmt.setString(4, grt.getExt_st());
			pstmt.setString(5, grt.getExt_tm());				
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[AddExtDatabase:deleteGrt]\n"+e);
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


	
	// �ߵ���������� ����Ʈ ��ȸ + �����뿩�� ����(gubun5 �߰�) est_dt -> cls_dt 20100208
	public Vector getClsFeeScdList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String rtype)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		//�����
		String query1 = "";

		query1 = " select  \n"+
					" '�����' cls_gubun, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, d.cls_st, b.firm_nm, b.client_nm, b.client_id, e.enp_no, TEXT_DECRYPT(e.ssn, 'pw' )  ssn, \n"+
					" c.car_no, c.car_nm, cn.car_name, decode(a.ext_pay_dt, '','�̼���','����') gubun, a.ext_s_amt as s_amt, (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) as amt,"+
					" a.ext_tm as tm, decode(a.ext_tm,'1','','(��)') tm_st, a.dly_amt, to_number(a.dly_days) as dly_days, b.bus_id2, b.rent_st, b.r_site, b.mng_id, b.use_yn, \n"+
					" d.cls_dt, nvl(nvl(d.cls_est_dt, a.ext_est_dt), d.cls_dt)  as est_dt, a.ext_pay_dt as pay_dt, \n"+
					" decode(g.gi_st,'0','����','1','����') gi_st, g.gi_amt gi_amt , trim(nvl(t.accid_id, '-')) cr_gubun , decode(nvl(c.prepare, '1'), '9', '9', '4', '4',  '1')  prepare, sep.ip_amt AS pay_amt2, sep.ip_dt AS pay_dt2, \n"+
					" decode(d.cls_st,'1','��ุ��','2','�ߵ�����','4','��������','5','���°�','6','�Ű�','8','���Կɼ�','9','����','14','����Ʈ����') cls_st_nm \n"+
					" from scd_ext a, cont_n_view b,  cls_cont d,   car_reg c,  car_etc ce, car_nm cn , cls_guar sep, \n"+
					"	   (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) g, "+
					"	   client e, "+
					"	   (select a.* from tel_mm a, (select rent_mng_id, rent_l_cd, max(seq) seq from tel_mm where tm_st='9' group by rent_mng_id, rent_l_cd) b where a.tm_st = '9' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) t \n"+
					" where\n"+
					" a.ext_st = '4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
					" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd   "+
					" and a.rent_mng_id=sep.rent_mng_id(+) and a.rent_l_cd=sep.rent_l_cd(+)   "+
					" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) "+
					" and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) and b.client_id=e.client_id "+
					"	and b.car_mng_id = c.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                    "	and ce.car_id=cn.car_id(+)  and   ce.car_seq=cn.car_seq(+)  \n"+
					" and (a.ext_s_amt+a.ext_v_amt) >0  and nvl(a.bill_yn,'Y')='Y'";
		//�����뿩��
		String query2 = "";
		query2 = " select  '�뿩��' cls_gubun, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, b.cls_st, a.firm_nm, a.client_nm, '' client_id, e.enp_no, TEXT_DECRYPT(e.ssn, 'pw' )  ssn, "+
					" a.car_no, a.car_nm, a.car_name, decode(a.rc_yn, '1', '����','�̼���') gubun, a.fee_s_amt as s_amt, a.fee_amt as amt,"+
					" a.fee_tm as tm, decode(a.tm_st1,'0','','(��)') tm_st, 0 dly_amt, a.dly_day as dly_days, a.bus_id2, a.rent_st, c.r_site, c.mng_id, c.use_yn,"+
					" b.cls_dt, nvl(b.cls_est_dt, a.fee_est_dt) as est_dt, a.rc_dt as pay_dt,"+
					" '' gi_st, g.gi_amt gi_amt, '-' cr_gubun,  decode(nvl(cr.prepare, '1'), '9', '9', '4', '4',  '1') prepare, 0 pay_amt2, '' pay_dt2,  \n"+
					" decode(b.cls_st,'1','��ุ��','2','�ߵ�����','4','��������','5','���°�','6','�Ű�','8','���Կɼ�','9','����','14','����Ʈ����') cls_st_nm \n"+
					" from fee_view a, cls_cont b, cont c,  car_reg cr ,  "+
					"      (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) g, "+
					"      client e \n"+
					" where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.use_yn='N' and a.bill_yn='Y'"+
					" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) and c.client_id=e.client_id \n"+
					" and c.car_mng_id = cr.car_mng_id and b.cls_dt <= to_char(sysdate,'YYYYMMDD') and a.rc_dt is null and a.fee_est_dt < to_char(sysdate,'YYYYMMDD') ";

		String query = " select * from ( \n"+query1+"\n ) where rent_l_cd is not null ";		

		//����+��ü �̼����̸� �����뿩�ᵵ ����	
		if((gubun2.equals("3") || gubun2.equals("6")) && gubun3.equals("3")){
			//��ü
			query = " select * from ( \n"+query1+"\n union all \n"+query2+"\n ) where rent_l_cd is not null ";		
		}

		if(gubun5.equals("1")){			query += " and cls_gubun = '�뿩��'";
		}else if(gubun5.equals("2")){	query += " and cls_gubun = '�����'";
		}


		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and cls_dt like to_char(sysdate,'YYYYMM')||'%'";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and cls_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and cls_dt like to_char(sysdate,'YYYYMM')||'%' and pay_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and cls_dt = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and cls_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD')";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and cls_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null";
		//��ü-��ȹ
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and cls_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//��ü-����
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and cls_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD')";
		//��ü-�̼���
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and cls_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and ((est_dt BETWEEN  replace('"+st_dt+"' , '-', '')  AND replace('"+end_dt+"', '-', '') ) or (pay_dt BETWEEN  replace('"+st_dt+"' , '-', '')  AND replace('"+end_dt+"', '-', '')))";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and pay_dt BETWEEN  replace('"+st_dt+"' , '-', '')  AND replace('"+end_dt+"', '-', '')  and pay_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and est_dt BETWEEN  replace('"+st_dt+"' , '-', '')  AND replace('"+end_dt+"', '-', '')  and pay_dt is null";
		//����+��ü-��ȹ
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and cls_dt <= to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//����+��ü-����
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and cls_dt <= to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD')";
		//����+��ü-�̼���
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and cls_dt <= to_char(sysdate,'YYYYMMDD') and pay_dt is null";
		//�˻�-����
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and pay_dt is not null";
		//�˻�-�̼���
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and pay_dt is null";
		}

		/*��ü��ȸ*/
		if(gubun2.equals("3")){
				if(gubun4.equals("2")){	//�Ϲݿ�ü	
					query += " and dly_days between 1 and 30";
				}else if(gubun4.equals("3")){ //�νǿ�ü
					query += " and dly_days between 31 and 60";
				}else if(gubun4.equals("4")){ //�Ǽ���ü
					query += " and dly_days between 61 and 1000";
				}else{}
		}

		/*�˻�����*/			
		if(s_kd.equals("2"))		query += " and client_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and rent_l_cd like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and car_no like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and est_dt like '"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and r_site like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and bus_id2= '"+t_wd+"'\n";
		else if(s_kd.equals("11"))	query += " and mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and car_nm||car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and cls_dt like '"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and enp_no like '%"+t_wd+"%'\n";
		else if(s_kd.equals("13"))	query += " and ssn like '%"+t_wd+"%'\n";
		else if(s_kd.equals("14"))	query += " and cls_st='14' \n";
		else						query += " and firm_nm like '%"+t_wd+"%'\n";			

		//rtype  L: ���뿩 , M:����Ʈ 
		if(rtype.equals("L"))		query +=  " and cls_st<>'14' \n";
		else if(rtype.equals("M"))	query +=  " and cls_st='14' \n";
		
		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/
		if(sort_gubun.equals("0"))		query += " order by decode(prepare,1,1,9,2,4,3), decode( trim(cr_gubun), '����', 9, 0)  , decode(prepare,1,1,9,2,4,3),   cls_dt "+sort+", pay_dt, firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by decode(prepare,1,1,9,2,4,3), decode( trim(cr_gubun), '����', 9, 0) , decode(prepare,1,1,9,2,4,3),   firm_nm "+sort+", pay_dt, est_dt";
		else if(sort_gubun.equals("2"))	query += " order by decode(prepare,1,1,9,2,4,3), decode( trim(cr_gubun), '����', 9, 0) ,  decode(prepare,1,1,9,2,4,3),   pay_dt "+sort+", firm_nm, est_dt";
		else if(sort_gubun.equals("3"))	query += " order by decode(prepare,1,1,9,2,4,3),  decode( trim(cr_gubun), '����', 9, 0),   amt "+sort+", pay_dt, firm_nm, est_dt";
		else if(sort_gubun.equals("5"))	query += " order by decode(prepare,1,1,9,2,4,3),  decode( trim(cr_gubun), '����', 9, 0) , cls_st,   amt "+sort+", pay_dt, firm_nm, est_dt";
		
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
			System.out.println("[AddExtDatabase:getClsFeeScdList]\n"+e);
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
	

	
	
	// �ߵ���������� ����Ʈ ��ȸ + �����뿩�� ����(gubun5 �߰�) est_dt -> cls_dt 20100208
	public Vector getNewClsFeeScdList2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String rtype)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		//�����
		String query1 = "";

		query1 = " select  \n"+
					" '�����' cls_gubun, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, d.cls_st, b.firm_nm, b.client_nm, b.client_id, e.enp_no, TEXT_DECRYPT(e.ssn, 'pw' )  ssn, \n"+
					" c.car_no, c.car_nm, cn.car_name, decode(a.ext_pay_dt, '','�̼���','����') gubun, a.ext_s_amt as s_amt, (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) as amt,"+
					" a.ext_tm as tm, decode(a.ext_tm,'1','','(��)') tm_st, a.dly_amt, to_number(a.dly_days) as dly_days, b.bus_id2, b.rent_st, b.r_site, b.mng_id, b.use_yn, \n"+
					" d.cls_dt, nvl(nvl(d.cls_est_dt, a.ext_est_dt), d.cls_dt)  as est_dt, a.ext_pay_dt as pay_dt,  \n"+
				//	" decode(d.cls_st , '14',  decode( ct.ext_cnt ,  1 , 0 ,  fd.fdft_amt  ) ,  fd.fdft_amt)  fdft_amt  ,  nvl(ct.ext_cnt , 0) ext_cnt , \n"+
					" decode(d.cls_st , '14',  case when nvl(ct.ext_cnt,0)  = 1 and d.fdft_amt2 < 0 then 0 else fd.fdft_amt end, fd.fdft_amt)  fdft_amt ,  nvl(ct.ext_cnt , 0) ext_cnt , \n"+
					" decode(g.gi_st,'0','����','1','����') gi_st, g.gi_amt gi_amt , trim(nvl(t.accid_id, '-')) cr_gubun , decode(nvl(c.prepare, '1'), '9', '9', '4', '4',  '1')  prepare, sep.ip_amt AS pay_amt2, sep.ip_dt AS pay_dt2 \n"+
			//		" from scd_ext a, cont_n_view b,  cls_cont d,   car_reg c,  car_etc ce, car_nm cn , scd_ext_pay sep, \n"+
					" from scd_ext a, cont_n_view b,  cls_cont d,   car_reg c,  car_etc ce, car_nm cn , cls_guar sep, \n"+
					"	   (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) g, "+
					"	   client e, "+
			//		"	  ( select rent_mng_id, rent_l_cd , sum(decode(ext_tm, '1' , decode(sign( ext_s_amt + ext_v_amt -0) , -1 , 0 ,  ext_s_amt + ext_v_amt ) , '2' , decode(nvl(ext_cnt, 0)  , 9, ext_s_amt + ext_v_amt , 1 , ext_s_amt + ext_v_amt , 0 ) , 0 ) ) fdft_amt  from scd_ext   where ext_st = '4' and ext_tm in ( '1' , '2' ) and ext_s_amt + ext_v_amt <> 0 group by rent_mng_id, rent_l_cd ) fd,    \n"+                  
					"    ( select rent_mng_id, rent_l_cd, decode(ext_pay_dt, null, 1, 9 ) ext_cnt  from scd_ext where ext_st = '4' and ext_tm in ( '1' ) and ext_s_amt + ext_v_amt < 0   ) ct , \n"+
					"    ( select a.rent_mng_id, a.rent_l_cd , sum(decode(a.ext_tm, '1' , decode(sign( a.ext_s_amt + a.ext_v_amt -0) , -1 , 0 ,  ext_s_amt + ext_v_amt ) , '2' , decode(nvl(ext_cnt, 0)  , 9, ext_s_amt + ext_v_amt , 1 , ext_s_amt + ext_v_amt , 0 ) , 0 ) ) fdft_amt  \n"+
				   " 			from scd_ext a,  ( select rent_mng_id, rent_l_cd, decode(ext_pay_dt, null, 1, 9 ) ext_cnt  from scd_ext where ext_st = '4' and ext_tm in ( '1' ) and ext_s_amt + ext_v_amt < 0   ) b \n"+
				   "			where   a.ext_st = '4' and a.ext_tm in ( '1' , '2' ) and a.ext_s_amt + a.ext_v_amt <> 0   and a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)    group by a.rent_mng_id, a.rent_l_cd ) fd , \n"+								
					"	  (select a.* from tel_mm a, (select rent_mng_id, rent_l_cd, max(seq) seq from tel_mm where tm_st='9' group by rent_mng_id, rent_l_cd) b where a.tm_st = '9' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) t \n"+
					" where\n"+
					" a.ext_st = '4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
					" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd   "+
					" and a.rent_mng_id=sep.rent_mng_id(+) and a.rent_l_cd=sep.rent_l_cd(+)   "+
					" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) "+
					" and a.rent_mng_id=fd.rent_mng_id(+) and a.rent_l_cd=fd.rent_l_cd(+) "+
					" and a.rent_mng_id=ct.rent_mng_id(+) and a.rent_l_cd=ct.rent_l_cd(+) "+
					" and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) and b.client_id=e.client_id "+
					"	and b.car_mng_id = c.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
          		"	and ce.car_id=cn.car_id(+)  and   ce.car_seq=cn.car_seq(+)  \n"+
					" and (a.ext_s_amt+a.ext_v_amt) >0  and nvl(a.bill_yn,'Y')='Y'";
		//�����뿩��
		String query2 = "";
		query2 = " select  '�뿩��' cls_gubun, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, b.cls_st, a.firm_nm, a.client_nm, '' client_id, e.enp_no, TEXT_DECRYPT(e.ssn, 'pw' )  ssn, "+
					" a.car_no, a.car_nm, a.car_name, decode(a.rc_yn, '1', '����','�̼���') gubun, a.fee_s_amt as s_amt, a.fee_amt as amt,"+
					" a.fee_tm as tm, decode(a.tm_st1,'0','','(��)') tm_st, 0 dly_amt, a.dly_day as dly_days, a.bus_id2, a.rent_st, c.r_site, c.mng_id, c.use_yn,"+
					" b.cls_dt, nvl(b.cls_est_dt, a.fee_est_dt) as est_dt, a.rc_dt as pay_dt,  a.fee_amt  fdft_amt , 0 ext_cnt, \n"+ 
					" '' gi_st, g.gi_amt gi_amt, '-' cr_gubun,  decode(nvl(cr.prepare, '1'), '9', '9', '4', '4',  '1') prepare, 0 pay_amt2, '' pay_dt2  \n"+
					" from fee_view a, cls_cont b, cont c,  car_reg cr ,  "+
					"      (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) g, "+
					"      client e \n"+
					" where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.use_yn='N' and a.bill_yn='Y'"+
					" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) and c.client_id=e.client_id \n"+
					" and c.car_mng_id = cr.car_mng_id and b.cls_dt <= to_char(sysdate,'YYYYMMDD') and a.rc_dt is null and a.fee_est_dt < to_char(sysdate,'YYYYMMDD') ";

		String query = " select * from ( \n"+query1+"\n ) where rent_l_cd is not null ";		

		//����+��ü �̼����̸� �����뿩�ᵵ ����	
		if((gubun2.equals("3") || gubun2.equals("6")) && gubun3.equals("3")){
			//��ü
			query = " select * from ( \n"+query1+"\n union all \n"+query2+"\n ) where rent_l_cd is not null ";		
		}

		if(gubun5.equals("1")){			query += " and cls_gubun = '�뿩��'";
		}else if(gubun5.equals("2")){	query += " and cls_gubun = '�����'";
		}

		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and substr(cls_dt,1,7) = to_char(sysdate,'YYYYMM')";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and substr(cls_dt,1,7) = to_char(sysdate,'YYYYMM') and pay_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and substr(cls_dt,1,7) = to_char(sysdate,'YYYYMM') and pay_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and cls_dt = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and cls_dt = to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD')";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and cls_dt = to_char(sysdate,'YYYYMMDD') and pay_dt is null";
		//��ü-��ȹ
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and cls_dt < to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//��ü-����
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and cls_dt < to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD')";
		//��ü-�̼���
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and cls_dt < to_char(sysdate,'YYYYMMDD') and pay_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and ((est_dt BETWEEN  replace('"+st_dt+"' , '-', '')  AND replace('"+end_dt+"', '-', '') ) or (pay_dt BETWEEN  replace('"+st_dt+"' , '-', '')  AND replace('"+end_dt+"', '-', '')))";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and pay_dt BETWEEN  replace('"+st_dt+"' , '-', '')  AND replace('"+end_dt+"', '-', '')  and pay_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and est_dt BETWEEN  replace('"+st_dt+"' , '-', '')  AND replace('"+end_dt+"', '-', '')  and pay_dt is null";
		//����+��ü-��ȹ
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and cls_dt <= to_char(sysdate,'YYYYMMDD') and (pay_dt is null or pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//����+��ü-����
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and cls_dt <= to_char(sysdate,'YYYYMMDD') and pay_dt = to_char(sysdate,'YYYYMMDD')";
		//����+��ü-�̼���
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and cls_dt <= to_char(sysdate,'YYYYMMDD') and pay_dt is null";
		//�˻�-����
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and pay_dt is not null";
		//�˻�-�̼���
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and pay_dt is null";
		}

		/*��ü��ȸ*/
		if(gubun2.equals("3")){
				if(gubun4.equals("2")){	//�Ϲݿ�ü	
					query += " and dly_days between 1 and 30";
				}else if(gubun4.equals("3")){ //�νǿ�ü
					query += " and dly_days between 31 and 60";
				}else if(gubun4.equals("4")){ //�Ǽ���ü
					query += " and dly_days between 61 and 1000";
				}else{}
		}

		/*�˻�����*/
			
		if(s_kd.equals("2"))		query += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and est_dt like '"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and bus_id2= '"+t_wd+"'\n";
		else if(s_kd.equals("11"))	query += " and mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and car_nm||car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(cls_dt, '') like '"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and nvl(enp_no, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			
		
		//rtype  L: ���뿩 , M:����Ʈ 
		if(rtype.equals("L"))		query +=  " and cls_st not in ('14' )  \n";
		else if(rtype.equals("M"))	query +=  " and cls_st='14' \n";

		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/
		if(sort_gubun.equals("0"))		query += " order by decode(prepare,1,1,9,2,4,3), decode( trim(cr_gubun), '����', 9, 0)  ,     cls_dt "+sort+", pay_dt, firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by decode(prepare,1,1,9,2,4,3), decode( trim(cr_gubun), '����', 9, 0) ,   firm_nm "+sort+", pay_dt, est_dt";
		else if(sort_gubun.equals("2"))	query += " order by decode(prepare,1,1,9,2,4,3), decode( trim(cr_gubun), '����', 9, 0),    pay_dt "+sort+", firm_nm, est_dt";
		else if(sort_gubun.equals("3"))	query += " order by decode(prepare,1,1,9,2,4,3), decode( trim(cr_gubun), '����', 9, 0),    amt "+sort+", pay_dt, firm_nm, est_dt";
		else if(sort_gubun.equals("5"))	query += " order by decode(prepare,1,1,9,2,4,3), decode( trim(cr_gubun), '����', 9, 0), cls_st,   amt "+sort+", pay_dt, firm_nm, est_dt";
		
	  		
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
			System.out.println("[AddExtDatabase:getClsFeeScdList]\n"+e);
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
	
	// ���� -------------------------------------------------------------------------------------------------
	
	/**
	 *	�ߵ���������� ��ü�� ��� : cls_c.jsp
	 */
	public boolean calDelay(String m_id, String l_cd){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		//��ü�� �ִ� ���(�Ա�:�Ա���>�Աݿ�����, ���Ա�:���糯��>�Աݿ�����)
		String query1 = "";
		query1= " UPDATE scd_ext SET"+
				" dly_days=TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(ext_est_dt, 'YYYYMMDD')),"+
				" dly_amt=(TRUNC(((ext_s_amt)*0.18*TRUNC(TO_DATE(ext_est_dt, 'YYYYMMDD')- NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
				" WHERE rent_mng_id=? and rent_l_cd=? and ext_st = '4' "+
				" and SIGN(TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - NVL(TO_DATE(ext_est_dt, 'YYYYMMDD'), SYSDATE))) > 0";
	
		//��ü�� ���� ���(�Ա�:�Ա���=�Աݿ�����, �Ա���<�Աݿ�����(����), ���Ա�:���糯¥<�Աݿ�����)
		String query2 = "";
		query2= " UPDATE scd_ext set"+
				" dly_days = '0',"+
				" dly_amt = 0"+
				" WHERE rent_mng_id=? and rent_l_cd=?  and ext_st = '4'  "+
				" and SIGN(TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - NVL(TO_DATE(ext_est_dt, 'YYYYMMDD'), SYSDATE))) < 1";        
		try 
		{
			conn.setAutoCommit(false);
				
			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1, m_id);
			pstmt1.setString(2, l_cd);
		    pstmt1.executeUpdate();
			pstmt1.close();

		    pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, m_id);
			pstmt2.setString(2, l_cd);
		    pstmt2.executeUpdate();
			pstmt2.close();
		    
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:calDelay]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
			}
			
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	// �ߵ���������� �Ǻ� ������ ����Ʈ ��ȸ
	public Vector getClsScd(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query =  " select decode(a.ext_pay_dt, '','�̼���', '����') gubun, a.ext_tm, a.rent_seq, "+
						" a.ext_s_amt, a.ext_v_amt, a.ext_pay_amt, a.dly_amt, nvl(a.dly_days,'0') dly_days,"+
						" nvl2(a.ext_est_dt,substr(a.ext_est_dt,1,4)||'-'||substr(a.ext_est_dt,5,2)||'-'||substr(a.ext_est_dt,7,2),' ') ext_est_dt,\n"+
						" nvl2(k.tax_dt,substr(k.tax_dt,1,4)||'-'||substr(k.tax_dt,5,2)||'-'||substr(k.tax_dt,7,2),' ') ext_dt,\n"+
						" nvl2(a.ext_pay_dt,substr(a.ext_pay_dt,1,4)||'-'||substr(a.ext_pay_dt,5,2)||'-'||substr(a.ext_pay_dt,7,2),' ') ext_pay_dt\n"+
						" from scd_ext a,"+
						" (select aa.rent_l_cd, min(aa.tax_dt) tax_dt from tax aa where aa.tax_st<>'C' and aa.tax_bigo like '%�ߵ�����%' and aa.tax_supply > 0 group by aa.rent_l_cd) k"+
						" where a.ext_st = '4' and a.rent_l_cd=k.rent_l_cd(+) and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and nvl(a.bill_yn,'Y')<>'N'\n"+
						" order by a.ext_pay_dt, a.ext_est_dt , a.ext_tm ";


		try {
			stmt = conn.createStatement();
					
	    	rs = stmt.executeQuery(query);
	    	
	    	
			while(rs.next())
			{				
	            ExtScdBean bean = new ExtScdBean();

				bean.setRent_mng_id(m_id); 
				bean.setRent_l_cd(l_cd); 
				bean.setGubun(rs.getString("gubun")); 
				bean.setExt_tm(rs.getString("ext_tm")); 					
				bean.setExt_s_amt(rs.getInt("ext_s_amt")); 
				bean.setExt_v_amt(rs.getInt("ext_v_amt")); 
				bean.setExt_est_dt(rs.getString("ext_est_dt").trim());
				bean.setExt_pay_amt(rs.getInt("ext_pay_amt")); 
				bean.setExt_pay_dt(rs.getString("ext_pay_dt").trim());
				bean.setExt_dt(rs.getString("ext_dt").trim());
				bean.setDly_amt(rs.getInt("dly_amt")); 
				bean.setDly_days(rs.getString("dly_days")); 
				bean.setRent_seq(rs.getString("rent_seq")); 
				vt.add(bean);	
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getClsScd]\n"+e);
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

	// �ߵ���������� �Ǻ� ������ ����Ʈ ���
	public IncomingBean getClsScdCaseStat(String m_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		IncomingBean ins_m = new IncomingBean();

		String sub_query = "";
		sub_query = " select a.* from scd_ext a, cls_cont b"+
					" where a.ext_st = '4'  and  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st in ('2', '1') and nvl(a.bill_yn,'Y')='Y'"+
					" and a.rent_mng_id=? and b.rent_l_cd=? ";

		String query = "";
		query = " select a.*, b.*, c.* from\n"+
					" ( select count(0) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where ext_pay_dt is null) a, \n"+
					" ( select count(0) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where ext_pay_dt is not null) b, \n"+
					" ( select count(0) tot_su3, nvl(sum(dly_amt),0) tot_amt3 from ("+sub_query+") where dly_amt > 0) c";
		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, m_id);
			pstmt.setString(4, l_cd);
			pstmt.setString(5, m_id);
			pstmt.setString(6, l_cd);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{
				ins_m.setTot_su1(rs.getInt(1));
				ins_m.setTot_amt1(rs.getInt(2));
				ins_m.setTot_su2(rs.getInt(3));
				ins_m.setTot_amt2(rs.getInt(4));
				ins_m.setTot_su3(rs.getInt(5));
				ins_m.setTot_amt3(rs.getInt(6));
			}
			rs.close();
			pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getClsScdCaseStat]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_m;
		}
	}
	
	// ext_st : 4-> ���������
	public boolean updateClsScd(ExtScdBean cng_cls){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;

		String query = "";
		query =  " UPDATE scd_ext SET ext_est_dt=replace(?, '-', ''), ext_pay_dt=replace(?, '-', ''), ext_s_amt=?, ext_v_amt=?, ext_pay_amt=?,"+
				"  update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE rent_mng_id=? and rent_l_cd=? and ext_tm=? and ext_st = '4' ";

		try 
		{
			
			conn.setAutoCommit(false);
			    	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, cng_cls.getExt_est_dt());
			pstmt1.setString(2, cng_cls.getExt_pay_dt());
			pstmt1.setInt(3, cng_cls.getExt_s_amt());
			pstmt1.setInt(4, cng_cls.getExt_v_amt());
			pstmt1.setInt(5, cng_cls.getExt_pay_amt());
			pstmt1.setString(6, cng_cls.getUpdate_id());
			pstmt1.setString(7, cng_cls.getRent_mng_id());
			pstmt1.setString(8, cng_cls.getRent_l_cd());
			pstmt1.setString(9, cng_cls.getExt_tm());
		    pstmt1.executeUpdate();
			pstmt1.close();
		    
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateClsScd]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	
	/**
	 *	��������� �Ǻ� ������ ��ȸ�� ����(�� ����)
	 */
	public ExtScdBean getScd(String m_id, String l_cd, String cls_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ExtScdBean cls_scd = new ExtScdBean();
		String query =  " select a.* , nvl(b.jung_st, 'x') jung_st  from scd_ext a, cls_cont_etc b   "+
						" where  a.ext_st = '4'  and  a.RENT_MNG_ID=? and a.RENT_L_CD=? and a.EXT_TM=?  and  a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd= b.rent_l_cd (+) ";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, cls_tm);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				cls_scd.setRent_mng_id(m_id); 
				cls_scd.setRent_l_cd(l_cd); 
				cls_scd.setExt_tm(cls_tm); 					
				cls_scd.setExt_s_amt(rs.getInt("ext_s_amt")); 
				cls_scd.setExt_v_amt(rs.getInt("ext_v_amt")); 
				cls_scd.setExt_est_dt(rs.getString("ext_est_dt"));
				cls_scd.setExt_pay_amt(rs.getInt("ext_pay_amt")); 
				cls_scd.setExt_pay_dt(rs.getString("ext_pay_dt"));
				cls_scd.setDly_amt(rs.getInt("dly_amt")); 
				cls_scd.setDly_days(rs.getString("dly_days")); 
				cls_scd.setJung_st(rs.getString("jung_st")); 
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cls_scd;
		}				
	}
	
	
	/**
	 *	�ߵ���������� ������ �������� : �Ա�ó��, �Ա����, �Աݿ����� ����, �Ա����� ���� cls_c.jsp
	 */
	public boolean updateClsScd(ExtScdBean cng_cls, String cmd, String pay_yn, String vat_st){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;


		String query = "";
		query =  " UPDATE scd_ext SET ext_est_dt=replace(?, '-', ''), ext_pay_dt=replace(?, '-', ''), ext_s_amt=?, ext_v_amt=?, ext_pay_amt=?,"+
				"  update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?, incom_dt = replace(?, '-', ''), incom_seq = ? "+
				" WHERE  rent_mng_id=? and rent_l_cd=? and ext_tm=? and ext_st = '4' ";

		try 
		{
			conn.setAutoCommit(false);
		
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, cng_cls.getExt_est_dt());
			pstmt1.setString(2, cng_cls.getExt_pay_dt());
			pstmt1.setInt(3, cng_cls.getExt_s_amt());
			pstmt1.setInt(4, cng_cls.getExt_v_amt());
			pstmt1.setInt(5, cng_cls.getExt_pay_amt());
			pstmt1.setString(6, cng_cls.getUpdate_id());
			pstmt1.setString(7, cng_cls.getIncom_dt());
			pstmt1.setInt(8, cng_cls.getIncom_seq());
			pstmt1.setString(9, cng_cls.getRent_mng_id());
			pstmt1.setString(10, cng_cls.getRent_l_cd());
			pstmt1.setString(11, cng_cls.getExt_tm());
		    pstmt1.executeUpdate();
			pstmt1.close();


			//�ܾ׹߻��� ������ �߰�
			if(cmd.equals("p") && cng_cls.getExt_s_amt()+cng_cls.getExt_v_amt() != cng_cls.getExt_pay_amt()){
	
				String query_in = " INSERT INTO scd_ext"+
					" (rent_mng_id, rent_l_cd, rent_st, rent_seq, ext_st, ext_id, ext_tm, ext_s_amt, ext_v_amt,"+
					" ext_est_dt, ext_pay_amt, dly_amt, update_dt, update_id, bill_yn)"+//11
					" values "+
					" (?, ?,'9', '1', '4', '0', ?, ?, ?,  replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?)";			

				int	n_cls_tm = Integer.parseInt(cng_cls.getExt_tm())+1;
				int n_cls_amt = cng_cls.getExt_s_amt()+cng_cls.getExt_v_amt()-cng_cls.getExt_pay_amt();
				int n_cls_s_amt = 0;
				int n_cls_v_amt = 0;
				if(vat_st.equals("1")){ //����
					n_cls_s_amt = (new Double(n_cls_amt/1.1)).intValue();
					n_cls_v_amt = n_cls_amt-n_cls_s_amt;
				}else{
					n_cls_s_amt = n_cls_amt;
				}

				pstmt2 = conn.prepareStatement(query_in);
				pstmt2.setString(1, cng_cls.getRent_mng_id());
				pstmt2.setString(2, cng_cls.getRent_l_cd());
				pstmt2.setString(3, Integer.toString(n_cls_tm));				
			
				if ( pay_yn.equals("N")) {  // �ջ꿡�� �������� ������ ���߰���  
					pstmt2.setInt   (4, 0);
					pstmt2.setInt   (5, 0);
				} else {	
					pstmt2.setInt   (4, n_cls_s_amt);
					pstmt2.setInt   (5, n_cls_v_amt);
				}
							
				pstmt2.setString(6, cng_cls.getExt_est_dt());
				pstmt2.setInt   (7, 0);
				pstmt2.setInt   (8, 0);
				pstmt2.setString(9, cng_cls.getUpdate_id());
				pstmt2.setString(10, "Y");
				pstmt2.executeUpdate();
				pstmt2.close();
			}


			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateClsScd (vat_st )]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	
		
	/**
	 *	�ߵ����� ������ �̼�ó��
	 */
	public boolean getCreditScd(String table_nm, String m_id, String l_cd, String rent_st, String tm, String tm_st1, String user_id){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query1 = " UPDATE scd_ext SET update_dt=to_char(sysdate,'YYYYMMdd' ), update_id = ? ,   bill_yn='N' "+
						" WHERE ext_st = '4' and rent_mng_id=? and rent_l_cd=? and ext_tm=? ";

		String query2 = " UPDATE scd_fee SET update_dt=to_char(sysdate,'YYYYMMdd' ),   update_id = ? ,   bill_yn='N' "+
						" WHERE rent_mng_id=? and rent_l_cd=? and rent_st=? and fee_tm=? and tm_st1=?";
		try 
		{
			conn.setAutoCommit(false);

			if(table_nm.equals("scd_ext")){
				pstmt = conn.prepareStatement(query1);
				pstmt.setString(1, user_id);
				pstmt.setString(2, m_id);
				pstmt.setString(3, l_cd);
				pstmt.setString(4, tm);
			}else{
				pstmt = conn.prepareStatement(query2);
				pstmt.setString(1, user_id);
				pstmt.setString(2, m_id);
				pstmt.setString(3, l_cd);
				pstmt.setString(4, rent_st);
				pstmt.setString(5, tm);
				pstmt.setString(6, tm_st1);
			}
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:getCreditScd]\n"+e);
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
	
	// ��ȸ -------------------------------------------------------------------------------------------------

	// ��å�� ����Ʈ ��ȸ
	public Vector getInsurMList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String b_dt = "to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')";

/*
		query = " select    "+
					" a.car_mng_id, a.serv_id, a.accid_id, se.rent_mng_id, se.rent_l_cd, b.firm_nm,  b.client_nm,"+
					" cr.car_no, cr.car_nm, cn.car_name, decode(se.ext_pay_dt, '','�̼���','����') gubun,"+
					" decode(a.serv_st, '1','��ȸ����', '2','�Ϲݼ���', '3','��������', '4','������' , '13', '����', '') serv_st, a.off_id, c.off_nm,"+
					" a.rep_amt, a.sup_amt, a.add_amt, a.tot_amt, nvl(se.ext_s_amt, 0)+ nvl(se.ext_v_amt,0) cust_amt, a.serv_dt, b.use_yn, b.mng_id, b.rent_st,"+//b.bus_id2, 
					" nvl2(a.cust_req_dt,substr(a.cust_req_dt,1,4)||'-'||substr(a.cust_req_dt,5,2)||'-'||substr(a.cust_req_dt,7,2),'') cust_req_dt,"+
					" nvl2(se.ext_est_dt,substr(se.ext_est_dt,1,4)||'-'||substr(se.ext_est_dt,5,2)||'-'||substr(se.ext_est_dt,7,2),'') cust_plan_dt,"+
					" nvl2(se.ext_pay_dt,substr(se.ext_pay_dt,1,4)||'-'||substr(se.ext_pay_dt,5,2)||'-'||substr(se.ext_pay_dt,7,2),'') cust_pay_dt,"+
					" decode(g.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ') res_st,"+
					" decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm) cust_nm, se.ext_tm, decode(se.ext_tm,'1','','(��)') tm_st,"+
					" decode(f.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id, '12', g.mng_id   )) bus_id2,"+
					" TRUNC(NVL(TO_DATE(se.ext_pay_dt, 'YYYYMMDD'), "+b_dt+") - TO_DATE(se.ext_est_dt, 'YYYYMMDD')) as dly_days,"+
					" l.tax_dt as ext_dt, se.seqid \n"+
					" from service a, cont_n_view b, serv_off c, accident f, rent_cont g, client h, users i, cont j, scd_ext se,  car_reg cr,  car_etc ce , car_nm cn,  \n"+
					" (select bb.* from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st='O' and aa.gubun ='7' and bb.m_tax_no is null ) l,"+
					"        ( select a.m_tax_no, c.rent_l_cd, c.tm, c.rent_st, c.rent_seq "+
					"          from   tax a, tax b, tax_item_list c "+
					"          where  a.tax_supply=-b.tax_supply and a.gubun ='7'"+
					" 	               and a.m_tax_no=b.tax_no and b.item_id=c.item_id "+
					"        ) o "+
					" where"+
					" se.ext_st = '3' and se.rent_mng_id=a.rent_mng_id and se.rent_l_cd= a.rent_l_cd and se.ext_id = a.serv_id and  se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id  "+
					" and a.off_id=c.off_id(+)"+
					" and a.car_mng_id=f.car_mng_id(+) and a.accid_id=f.accid_id(+) and f.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.sub_l_cd=j.rent_l_cd(+)"+
					"	and b.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                 " and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+) \n"+
					" and a.rent_l_cd=l.rent_l_cd(+) and a.serv_id=l.fee_tm(+) "+
					" and a.rent_l_cd=o.rent_l_cd(+) and a.serv_id=o.tm(+) "+
					" and decode(nvl(o.m_tax_no,'-'),l.tax_no,'N','Y')='Y' "+
					" and nvl(se.ext_s_amt,0) > 0 and nvl(se.bill_yn,'Y')='Y' and nvl(a.no_dft_yn,'N') = 'N' " ;
*/

		query = " select  /*+ INDEX(se, SCD_EXT_IDX7) INDEX(cr, CAR_REG_PK)  */  "+
					" a.car_mng_id, a.serv_id, a.accid_id, se.rent_mng_id, se.rent_l_cd, b.firm_nm,  b.client_nm,"+
					" cr.car_no, cr.car_nm, cn.car_name, decode(se.ext_pay_dt, '','�̼���','����') gubun,"+
					" decode(a.serv_st, '1','��ȸ����', '2','�Ϲݼ���', '3','��������', '4','������' , '13', '����', '') serv_st, a.off_id, c.off_nm,"+
					" a.rep_amt, a.sup_amt, a.add_amt, a.tot_amt, nvl(se.ext_s_amt, 0)+ nvl(se.ext_v_amt,0) cust_amt, a.serv_dt, b.use_yn, b.mng_id, b.rent_st,"+//b.bus_id2, 
					" nvl2(a.cust_req_dt,substr(a.cust_req_dt,1,4)||'-'||substr(a.cust_req_dt,5,2)||'-'||substr(a.cust_req_dt,7,2),'') cust_req_dt,"+
					" nvl2(se.ext_est_dt,substr(se.ext_est_dt,1,4)||'-'||substr(se.ext_est_dt,5,2)||'-'||substr(se.ext_est_dt,7,2),'') cust_plan_dt,"+
					" nvl2(se.ext_pay_dt,substr(se.ext_pay_dt,1,4)||'-'||substr(se.ext_pay_dt,5,2)||'-'||substr(se.ext_pay_dt,7,2),'') cust_pay_dt,"+
					" decode(g.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ') res_st,"+
					" decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm) cust_nm, se.ext_tm, decode(se.ext_tm,'1','','(��)') tm_st,"+
					" decode(f.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id, '12', g.mng_id   )) bus_id2,"+
					" TRUNC(NVL(TO_DATE(se.ext_pay_dt, 'YYYYMMDD'), "+b_dt+") - TO_DATE(se.ext_est_dt, 'YYYYMMDD')) as dly_days,"+
					" l.tax_dt as ext_dt, se.seqid \n"+
					" from service a, cont_n_view b, serv_off c, accident f, rent_cont g, client h, users i, cont j, scd_ext se,  car_reg cr,  car_etc ce , car_nm cn,  \n"+
					" (select max(bb.tax_dt) tax_dt, aa.rent_l_cd, aa.tm, SUM(bb.tax_supply) tax_supply from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st<>'C' and aa.gubun ='7' GROUP BY aa.RENT_L_CD, aa.tm) l "+
					" where"+
					" se.ext_st = '3' and se.rent_mng_id=a.rent_mng_id and se.rent_l_cd= a.rent_l_cd and se.ext_id = a.serv_id and  se.rent_mng_id=b.rent_mng_id and se.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id  "+
					" and nvl(se.ext_s_amt,0) > 0 and nvl(se.bill_yn,'Y')='Y' and nvl(a.no_dft_yn,'N') = 'N' "+
					" and a.off_id=c.off_id(+)"+
					" and a.car_mng_id=f.car_mng_id(+) and a.accid_id=f.accid_id(+) and f.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.sub_l_cd=j.rent_l_cd(+)"+
					" and b.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id  and a.rent_l_cd = ce.rent_l_cd  \n"+
                    " and ce.car_id=cn.car_id  and    ce.car_seq=cn.car_seq \n"+
					" and se.rent_l_cd=l.rent_l_cd(+) and se.ext_id=l.tm(+)  AND se.ext_s_amt=l.tax_supply(+)   "+
					" ";


		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and nvl(se.ext_est_dt,a.cust_req_dt) like to_char(sysdate,'YYYYMM')||'%'";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) like to_char(sysdate,'YYYYMM')||'%' and se.ext_pay_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) like to_char(sysdate,'YYYYMM')||'%' and se.ext_pay_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) = to_char(sysdate,'YYYYMMDD') and se.ext_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) = to_char(sysdate,'YYYYMMDD') and se.ext_pay_dt is null";
		//��ü-��ȹ
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) < to_char(sysdate,'YYYYMMDD') and (se.ext_pay_dt is null or se.ext_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//��ü-����
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) < to_char(sysdate,'YYYYMMDD') and se.ext_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//��ü-�̼���
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) < to_char(sysdate,'YYYYMMDD') and se.ext_pay_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) BETWEEN '"+st_dt+"' AND '"+end_dt+"' and se.ext_pay_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) BETWEEN '"+st_dt+"' AND '"+end_dt+"' and se.ext_pay_dt is null";
		//����+��ü-��ȹ
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) <= to_char(sysdate,'YYYYMMDD') and (se.ext_pay_dt is null or se.ext_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//����+��ü-����
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) <= to_char(sysdate,'YYYYMMDD') and se.ext_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//����+��ü-�̼���
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and nvl(se.ext_est_dt,a.cust_req_dt) <= to_char(sysdate,'YYYYMMDD') and se.ext_pay_dt is null";
		//�˻�
		}

		/*��ü��ȸ*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//�Ϲݿ�ü		
				query += " and a.dly_days between 1 and 30";
			}else if(gubun4.equals("3")){ //�νǿ�ü
				query += " and a.dly_days between 31 and 60";
			}else if(gubun4.equals("4")){ //�Ǽ���ü
				query += " and a.dly_days between 61 and 1000";
			}else{}
		}

		/*�˻�����*/

		if(s_kd.equals("2"))		query += " and nvl(b.client_nm||h.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and (a.cust_amt) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("12"))	query += " and decode(f.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id))= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.serv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(c.off_nm, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm,b.firm_nm)||decode(g.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','�����뿩','6','��������','7','��������','8','������','11','������','12','����Ʈ'), '') like '%"+t_wd+"%'\n";			
			

		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/

		if(sort_gubun.equals("0"))		query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, se.ext_est_dt "+sort+", se.ext_pay_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm,b.firm_nm) "+sort+", se.ext_pay_dt, se.ext_est_dt";
		else if(sort_gubun.equals("2"))	query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, se.ext_pay_dt "+sort+", b.firm_nm, se.ext_est_dt";
		else if(sort_gubun.equals("3"))	query += " order by decode(b.bus_id2,'000004','1','0'), b.use_yn desc, a.cust_amt "+sort+", se.ext_pay_dt, b.firm_nm, se.ext_est_dt";
		else if(sort_gubun.equals("4"))	query += " order by decode(b.bus_id2,'000004','1','0'), cr.car_no "+sort+", b.firm_nm, se.ext_est_dt";
	
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
			System.out.println("[AddInsurMDatabase:getInsurMList]\n"+e);
			System.out.println("[AddInsurMDatabase:getInsurMList]\n"+query);
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
	
	
	// ���� -------------------------------------------------------------------------------------------------
	
	/**
	 *	��ü�� ��� : e_st -> 3:��å�� , 6:��/������
	 */
	public boolean calDelay(String m_id, String l_cd, String e_st){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		//��ü�� �ִ� ���(�Ա�:�Ա���>�Աݿ�����, ���Ա�:���糯��>�Աݿ�����)
		String query1 = "";
		query1= " UPDATE scd_ext SET"+
				" dly_days=TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(ext_est_dt, 'YYYYMMDD')),"+
				" dly_amt=(TRUNC(((ext_s_amt)*0.18*TRUNC(TO_DATE(ext_est_dt, 'YYYYMMDD')- NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
				" WHERE rent_mng_id=? and rent_l_cd=? and ext_st = ? "+// and accid_id=? and serv_id=?"+			
				" and SIGN(TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - NVL(TO_DATE(ext_est_dt, 'YYYYMMDD'), SYSDATE))) > 0";
		//��ü�� ���� ���(�Ա�:�Ա���=�Աݿ�����, �Ա���<�Աݿ�����(����), ���Ա�:���糯¥<�Աݿ�����)
		String query2 = "";
		query2= " UPDATE scd_ext set"+
				" dly_days = '0',"+
				" dly_amt = 0"+
				" WHERE rent_mng_id=? and rent_l_cd=? and  ext_st = ? "+// and accid_id=? and serv_id=?"+
				" and SIGN(TRUNC(NVL(TO_DATE(ext_pay_dt, 'YYYYMMDD'), SYSDATE) - NVL(TO_DATE(ext_est_dt, 'YYYYMMDD'), SYSDATE))) < 1";        
		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1, m_id);
			pstmt1.setString(2, l_cd);
			pstmt1.setString(3, e_st);
		    pstmt1.executeUpdate();
			pstmt1.close();

		    pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, m_id);
			pstmt2.setString(2, l_cd);
			pstmt2.setString(3, e_st);
		    pstmt2.executeUpdate();
			pstmt2.close();
		    
		   	conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:calDelay]\n"+e);
			System.out.println("[AddExtDatabase:calDelay]\n"+query1);
			System.out.println("[AddExtDatabase:calDelay]\n"+query2);
			System.out.println("[m_id]\n"+m_id);
			System.out.println("[l_cd]\n"+l_cd);
			System.out.println("[e_st]\n"+e_st);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
               	conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	// ��å�� �Ǻ� ������ ����Ʈ ���
	public IncomingBean getInsurMScdStat(String m_id, String l_cd, String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		IncomingBean ins_m = new IncomingBean();

		String sub_query = "";
		sub_query = " select * from scd_ext"+
					" where  ext_st = '3' and nvl(ext_s_amt, 0)+ nvl(ext_v_amt,0) > 0 "+
					" and rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'" ;//and car_mng_id='"+c_id+"'" and a.accid_id='"+accid_id+"' and a.serv_id='"+serv_id+"'";

		String query = "";
		query = " select a.*, b.*, c.* from\n"+
					" ( select count(0) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where  ext_st = '3' and ext_pay_dt is null) a, \n"+
					" ( select count(0) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where  ext_st = '3' and ext_pay_dt is not null) b, \n"+
					" ( select count(0) tot_su3, nvl(sum(dly_amt),0) tot_amt3 from ("+sub_query+") where  ext_st = '3' and dly_amt > 0) c";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{
				ins_m.setTot_su1(rs.getInt(1));
				ins_m.setTot_amt1(rs.getInt(2));
				ins_m.setTot_su2(rs.getInt(3));
				ins_m.setTot_amt2(rs.getInt(4));
				ins_m.setTot_su3(rs.getInt(5));
				ins_m.setTot_amt3(rs.getInt(6));
			}
			rs.close();
			pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getInsurMScdStat]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_m;
		}
	}
	
	
	
	// ��å�� �Ǻ� ������ ����Ʈ ��ȸ
	public Vector getInsurMScd(String m_id, String l_cd, String c_id, String accid_id, String serv_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select"+
					" a.accid_id, a.serv_id, decode(se.ext_pay_dt, '','�̼���','����') gubun,"+
					" decode(a.serv_st, '1','��ȸ����', '2','�Ϲݼ���', '3','��������', '4','��������', '5','�������','7','�縮������', '13', '����', '' ) serv_st,"+
					" a.off_id, nvl(f.off_nm, '��û����') off_nm, se.ext_tm, "+
					" a.rep_amt, a.sup_amt, a.add_amt, a.tot_amt, nvl(se.ext_s_amt,0)+ nvl(se.ext_v_amt,0) cust_amt, se.ext_pay_amt, se.dly_amt, se.dly_days,"+
					" nvl2(a.cust_req_dt,substr(a.cust_req_dt,1,4)||'-'||substr(a.cust_req_dt,5,2)||'-'||substr(a.cust_req_dt,7,2),' ') cust_req_dt,"+
					" nvl2(se.ext_est_dt,substr(se.ext_est_dt,1,4)||'-'||substr(se.ext_est_dt,5,2)||'-'||substr(se.ext_est_dt,7,2),' ') cust_plan_dt,"+
					" nvl2(se.ext_pay_dt,substr(se.ext_pay_dt,1,4)||'-'||substr(se.ext_pay_dt,5,2)||'-'||substr(se.ext_pay_dt,7,2),' ') cust_pay_dt,"+
					" nvl2(k.tax_dt,substr(k.tax_dt,1,4)||'-'||substr(k.tax_dt,5,2)||'-'||substr(k.tax_dt,7,2), nvl(j.tax_dt, '') ) ext_dt, "+
					" se.seqid, p.pubcode, se.ext_v_amt "+
					" from service a, cont c, client d, car_reg e, serv_off f, scd_ext se, payebill p, "+
					" (select aa.rent_l_cd, aa.tm, aa.gubun,  bb.tax_dt from tax_item_list aa, tax bb where aa.item_id=bb.item_id and bb.tax_st='O' and aa.gubun ='7' group by aa.rent_l_cd, aa.tm, aa.gubun , bb.tax_dt  having sum(aa.item_supply)>0) j,"+//accident b,
					" (select aa.rent_l_cd, aa.fee_tm, aa.gubun, max(aa.tax_dt) tax_dt from tax aa where aa.tax_st='O' and substr(aa.tax_g,1,3) in ('������','��å��') group by aa.rent_l_cd, aa.fee_tm, aa.gubun having sum(aa.tax_supply)>0) k"+
					" where"+
					" se.ext_st = '3' and se.rent_mng_id=a.rent_mng_id and se.rent_l_cd=a.rent_l_cd and se.ext_id= a.serv_id "+
					" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.client_id=d.client_id"+
					" and a.car_mng_id=e.car_mng_id and a.off_id=f.off_id(+)"+
					" and nvl(se.ext_s_amt,0) <> 0 "+
					" and nvl(se.bill_yn,'Y')='Y' "+
					" and a.rent_l_cd=j.rent_l_cd(+) and a.serv_id=j.tm(+)"+
					" and a.rent_l_cd=k.rent_l_cd(+) and a.serv_id=k.fee_tm(+)"+
					" and se.seqid=p.seqid(+)"+
					" and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and a.car_mng_id='"+c_id+"'"+
					" order by se.ext_pay_dt, se.ext_est_dt " ; 

	
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);

	    	
			while(rs.next())
			{				
	            InsMScdBean bean = new InsMScdBean();

				bean.setRent_mng_id	(m_id); 
				bean.setRent_l_cd	(l_cd); 
			    bean.setCar_mng_id	(c_id); 					
				bean.setServ_id		(rs.getString("serv_id")); 
				bean.setAccid_id	(rs.getString("accid_id")); 				
				bean.setGubun		(rs.getString("gubun")); 
				bean.setServ_st		(rs.getString("serv_st")); 
				bean.setOff_id		(rs.getString("off_id"));
				bean.setOff_nm		(rs.getString("off_nm")); 
				bean.setRep_amt		(rs.getInt("rep_amt")); 
				bean.setSup_amt		(rs.getInt("sup_amt")); 
				bean.setAdd_amt		(rs.getInt("add_amt")); 
				bean.setTot_amt		(rs.getInt("tot_amt")); 
				bean.setCust_amt	(rs.getInt("cust_amt")); 
				bean.setDly_amt		(rs.getInt("dly_amt")); 
				bean.setPay_amt		(rs.getInt("ext_pay_amt")); 
				bean.setDly_days	(rs.getString("dly_days")); 
				bean.setCust_req_dt	(rs.getString("cust_req_dt").trim());
				bean.setCust_plan_dt(rs.getString("cust_plan_dt").trim()); 
				bean.setCust_pay_dt	(rs.getString("cust_pay_dt")==null?"":rs.getString("cust_pay_dt"));
				bean.setExt_dt		(rs.getString("ext_dt")		==null?"":rs.getString("ext_dt"));
				bean.setExt_tm		(rs.getString("ext_tm")		==null?"":rs.getString("ext_tm"));
				bean.setSeqId		(rs.getString("seqid")		==null?"":rs.getString("seqid"));
				bean.setPubCode		(rs.getString("pubcode")	==null?"":rs.getString("pubcode"));
				bean.setExt_v_amt	(rs.getInt("ext_v_amt")); 
				vt.add(bean);	
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getInsurMScd]\n"+e);
			System.out.println("[AddExtDatabase:getInsurMScd]\n"+query);
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
	 *	��å�� �Ǻ� ������ ��ȸ�� ��å�� ����(�� ����) blii_doc_yn  0->�̹��� 1->����
	 */
	
	public InsMScdBean getScd(String m_id, String l_cd, String c_id, String accid_id, String serv_id, String ext_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		InsMScdBean ins_m_scd = new InsMScdBean();
		String query =  " select nvl(a.bill_doc_yn,'0') bill_doc_yn, a.rep_amt, a.sup_amt, a.add_amt, a.tot_amt, nvl(se.ext_s_amt,0)+ nvl(se.ext_v_amt,0) cust_amt, nvl(se.ext_s_amt,0) ext_s_amt, nvl(se.ext_v_amt,0) ext_v_amt, se.dly_amt, se.dly_days,"+
						" a.cust_req_dt, se.ext_est_dt, se.ext_pay_dt, se.ext_pay_amt, se.ext_tm  , nvl(a.saleebill_yn,'0') saleebill_yn , se.rent_st , a.agnt_email  from service a , scd_ext se "+
						" where se.ext_st ='3'  and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and se.RENT_MNG_ID=? and se.RENT_L_CD=? and a.CAR_MNG_ID=? and a.ACCID_ID=? and se.ext_id=? and se.ext_tm = ? ";
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, m_id		);
			pstmt.setString(2, l_cd		);
			pstmt.setString(3, c_id		);
			pstmt.setString(4, accid_id	);
			pstmt.setString(5, serv_id	);
			pstmt.setString(6, ext_tm	);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				ins_m_scd.setRent_mng_id(m_id); 
				ins_m_scd.setRent_l_cd(l_cd); 
			   ins_m_scd.setCar_mng_id(c_id); 					
				ins_m_scd.setServ_id(serv_id); 
				ins_m_scd.setAccid_id(accid_id); 				
				ins_m_scd.setRep_amt(rs.getInt("rep_amt")); 
				ins_m_scd.setSup_amt(rs.getInt("sup_amt")); 
				ins_m_scd.setAdd_amt(rs.getInt("add_amt")); 
				ins_m_scd.setTot_amt(rs.getInt("tot_amt")); 
				ins_m_scd.setCust_amt(rs.getInt("cust_amt")); 
				ins_m_scd.setDly_amt(rs.getInt("dly_amt")); 
				ins_m_scd.setPay_amt(rs.getInt("ext_pay_amt")); 
				ins_m_scd.setExt_s_amt(rs.getInt("ext_s_amt")); 
				ins_m_scd.setExt_v_amt(rs.getInt("ext_v_amt")); 
				ins_m_scd.setDly_days(rs.getString("dly_days")); 
				ins_m_scd.setCust_req_dt(rs.getString("cust_req_dt"));
				ins_m_scd.setCust_plan_dt(rs.getString("ext_est_dt")); 
				ins_m_scd.setCust_pay_dt(rs.getString("ext_pay_dt"));
				ins_m_scd.setExt_tm(rs.getString("ext_tm"));
				ins_m_scd.setBill_doc_yn(rs.getString("bill_doc_yn"));
				ins_m_scd.setSaleebill_yn(rs.getString("saleebill_yn"));
				ins_m_scd.setRent_st(rs.getString("rent_st"));
				ins_m_scd.setRent_st(rs.getString("agnt_email"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getScd]\n"+e);
			System.out.println(query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_m_scd;
		}				
	}
		
		
	/**
	 *	��å�� ������ �������� : �Ա�ó��, �Ա����, û���ݾ� ����, �Ա����� ���� ins_m_c.jsp
	 */
	
	public boolean updateInsMScd(InsMScdBean cng_ins_ms, String cmd, String pay_yn){
		
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;

		String query = "";
		query = " UPDATE scd_ext SET ext_est_dt=replace(?, '-', ''), ext_pay_dt=replace(?, '-', ''), ext_s_amt=?, ext_v_amt=?, ext_pay_amt=?, "+
				" ext_dt=replace(?, '-', ''), update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE ext_st = '3' and rent_mng_id=? and rent_l_cd=? and ext_id = ? and ext_tm = ? ";
				
		String query1 = "";
		query1 = " UPDATE service SET cust_pay_dt =replace(?, '-', ''),  "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE  rent_mng_id=? and rent_l_cd=? and serv_id = ?  ";		

		try 
		{
			conn.setAutoCommit(false);
							 	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, cng_ins_ms.getCust_plan_dt());
			pstmt1.setString(2, cng_ins_ms.getCust_pay_dt());
			pstmt1.setInt(3, cng_ins_ms.getExt_s_amt());
			pstmt1.setInt(4, cng_ins_ms.getExt_v_amt());
			pstmt1.setInt(5, cng_ins_ms.getPay_amt());
			pstmt1.setString(6, cng_ins_ms.getExt_dt());
			pstmt1.setString(7, cng_ins_ms.getUpdate_id());
			pstmt1.setString(8, cng_ins_ms.getRent_mng_id());
			pstmt1.setString(9, cng_ins_ms.getRent_l_cd());
			pstmt1.setString(10, cng_ins_ms.getServ_id()); //���� id
			pstmt1.setString(11, cng_ins_ms.getExt_tm());
		    pstmt1.executeUpdate();
			pstmt1.close();
		   				   
		   
		   //������ ���� ���̺� ����	
		   	pstmt3 = conn.prepareStatement(query1);
			pstmt3.setString(1, cng_ins_ms.getCust_pay_dt());
			pstmt3.setString(2, cng_ins_ms.getUpdate_id());
			pstmt3.setString(3, cng_ins_ms.getRent_mng_id());
			pstmt3.setString(4, cng_ins_ms.getRent_l_cd());
			pstmt3.setString(5, cng_ins_ms.getServ_id()); //���� id
			pstmt3.executeUpdate();	 
			pstmt3.close();

			//�ܾ׹߻��� ������ �߰�
			if(cmd.equals("p") && cng_ins_ms.getExt_s_amt()+cng_ins_ms.getExt_v_amt() != cng_ins_ms.getPay_amt()){
	
	
				String query_in = " INSERT INTO scd_ext"+
					" (rent_mng_id, rent_l_cd, rent_st, rent_seq, ext_st, ext_id, ext_tm, ext_s_amt, ext_v_amt,"+
					" ext_est_dt, ext_pay_amt, dly_amt, update_dt, update_id, bill_yn  )"+//11
					" values "+
					" (?, ?, '9', '1', '3', ?, ?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?)";			

				int	n_cls_tm = Integer.parseInt(cng_ins_ms.getExt_tm())+1;
				int n_cls_amt = cng_ins_ms.getExt_s_amt()+cng_ins_ms.getExt_v_amt()-cng_ins_ms.getPay_amt();
				int n_cls_s_amt = 0;
				int n_cls_v_amt = 0;
				
			//	n_cls_s_amt = (new Double(n_cls_amt/1.1)).intValue();
				n_cls_s_amt = n_cls_amt;
				n_cls_v_amt = n_cls_amt-n_cls_s_amt;
							   
				pstmt2 = conn.prepareStatement(query_in);
				pstmt2.setString(1, cng_ins_ms.getRent_mng_id());
				pstmt2.setString(2, cng_ins_ms.getRent_l_cd());
				pstmt2.setString(3, cng_ins_ms.getServ_id());
				pstmt2.setString(4, Integer.toString(n_cls_tm));			
				pstmt2.setInt   (5, n_cls_s_amt);
				pstmt2.setInt   (6, n_cls_v_amt);
				pstmt2.setString(7, cng_ins_ms.getCust_plan_dt());			
				pstmt2.setInt   (8, 0);
				pstmt2.setInt   (9, 0);
				pstmt2.setString(10, cng_ins_ms.getUpdate_id());
				pstmt2.setString(11, "Y");						    
				pstmt2.executeUpdate();
				pstmt2.close();
								
			}
							
			conn.commit();	    

		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateInsMScd(pay_yn)]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
                if(pstmt3 != null)	pstmt3.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**
	 *	��å�� ������ �������� : �Ա�ó��, �Ա����, û���ݾ� ����, �Ա����� ���� ins_m_c.jsp - �Աݿ���
	 */
	
	public boolean updateInsMScd(InsMScdBean cng_ins_ms, String cmd, String pay_yn, String incom_dt, int incom_seq){
		
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;

		String query = "";
		query = " UPDATE scd_ext SET ext_est_dt=replace(?, '-', ''), ext_pay_dt=replace(?, '-', ''), ext_s_amt=?, ext_v_amt=?, ext_pay_amt=?, "+
				" ext_dt=replace(?, '-', ''), update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? , incom_dt = replace(?, '-', ''), incom_seq = ? "+
				" WHERE ext_st = '3' and rent_mng_id=? and rent_l_cd=? and ext_id = ? and ext_tm = ? ";
				
		String query1 = "";
		query1 = " UPDATE service SET cust_pay_dt =replace(?, '-', ''),  "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE  rent_mng_id=? and rent_l_cd=? and serv_id = ?  ";		

		try 
		{
			conn.setAutoCommit(false);
							 	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, cng_ins_ms.getCust_plan_dt());
			pstmt1.setString(2, cng_ins_ms.getCust_pay_dt());
			pstmt1.setInt(3, cng_ins_ms.getExt_s_amt());
			pstmt1.setInt(4, cng_ins_ms.getExt_v_amt());
			pstmt1.setInt(5, cng_ins_ms.getPay_amt());
			pstmt1.setString(6, cng_ins_ms.getExt_dt());
			pstmt1.setString(7, cng_ins_ms.getUpdate_id());
			pstmt1.setString(8, incom_dt);
			pstmt1.setInt(9,  incom_seq);
			pstmt1.setString(10, cng_ins_ms.getRent_mng_id());
			pstmt1.setString(11, cng_ins_ms.getRent_l_cd());
			pstmt1.setString(12, cng_ins_ms.getServ_id()); //���� id
			pstmt1.setString(13, cng_ins_ms.getExt_tm());
		    pstmt1.executeUpdate();
			pstmt1.close();
		   				   
		   
		   //������ ���� ���̺� ����	
		   	pstmt3 = conn.prepareStatement(query1);
			pstmt3.setString(1, cng_ins_ms.getCust_pay_dt());
			pstmt3.setString(2, cng_ins_ms.getUpdate_id());
			pstmt3.setString(3, cng_ins_ms.getRent_mng_id());
			pstmt3.setString(4, cng_ins_ms.getRent_l_cd());
			pstmt3.setString(5, cng_ins_ms.getServ_id()); //���� id
			pstmt3.executeUpdate();	 
			pstmt3.close();

			//�ܾ׹߻��� ������ �߰�
			if(cmd.equals("p") && cng_ins_ms.getExt_s_amt()+cng_ins_ms.getExt_v_amt() != cng_ins_ms.getPay_amt()){
	
	
				String query_in = " INSERT INTO scd_ext"+
					" (rent_mng_id, rent_l_cd, rent_st, rent_seq, ext_st, ext_id, ext_tm, ext_s_amt, ext_v_amt,"+
					" ext_est_dt, ext_pay_amt, dly_amt, update_dt, update_id, bill_yn  )"+//11
					" values "+
					" (?, ?, '9', '1', '3', ?, ?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?)";			

				int	n_cls_tm = Integer.parseInt(cng_ins_ms.getExt_tm())+1;
				int n_cls_amt = cng_ins_ms.getExt_s_amt()+cng_ins_ms.getExt_v_amt()-cng_ins_ms.getPay_amt();
				int n_cls_s_amt = 0;
				int n_cls_v_amt = 0;
				
			//	n_cls_s_amt = (new Double(n_cls_amt/1.1)).intValue();
				n_cls_s_amt = n_cls_amt;
				n_cls_v_amt = n_cls_amt-n_cls_s_amt;
							   
				pstmt2 = conn.prepareStatement(query_in);
				pstmt2.setString(1, cng_ins_ms.getRent_mng_id());
				pstmt2.setString(2, cng_ins_ms.getRent_l_cd());
				pstmt2.setString(3, cng_ins_ms.getServ_id());
				pstmt2.setString(4, Integer.toString(n_cls_tm));
			
				pstmt2.setInt   (5, n_cls_s_amt);
				pstmt2.setInt   (6, n_cls_v_amt);
				pstmt2.setString(7, cng_ins_ms.getCust_plan_dt());
				pstmt2.setInt   (8, 0);
				pstmt2.setInt   (9, 0);
				pstmt2.setString(10, cng_ins_ms.getUpdate_id());
				pstmt2.setString(11, "Y");
						    
				pstmt2.executeUpdate();
				pstmt2.close();
								
			}
							
			conn.commit();    
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateInsMScd(pay_yn)]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
                if(pstmt3 != null)	pstmt3.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	/**
	 *	��å�� ������ �������� : �Ա�ó��, �Ա����, �Աݿ����� ����, �Ա����� ���� cls_c.jsp
	 */
	
	public boolean updateInsMScd(InsMScdBean cng_ins_ms ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt3 = null;
	
		String query = "";
			query = " UPDATE scd_ext SET ext_est_dt=replace(?, '-', ''), ext_pay_dt=replace(?, '-', ''), ext_s_amt=?, ext_v_amt=?, ext_pay_amt=?, "+
				" ext_dt=replace(?, '-', ''), update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?"+
				" WHERE ext_st = '3' and rent_mng_id=? and rent_l_cd=? and ext_id = ? and ext_tm =? ";

		String query1 = "";
		query1 = " UPDATE service SET cust_pay_dt =replace(?, '-', ''),  "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE  rent_mng_id=? and rent_l_cd=? and serv_id = ?  ";		
				
		try 
		{
			conn.setAutoCommit(false);
		
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, cng_ins_ms.getCust_plan_dt());
			pstmt1.setString(2, cng_ins_ms.getCust_pay_dt());
			pstmt1.setInt(3, cng_ins_ms.getExt_s_amt());
			pstmt1.setInt(4, cng_ins_ms.getExt_v_amt());
			pstmt1.setInt(5, cng_ins_ms.getPay_amt());
			pstmt1.setString(6, cng_ins_ms.getExt_dt());
			pstmt1.setString(7, cng_ins_ms.getUpdate_id());
			pstmt1.setString(8, cng_ins_ms.getRent_mng_id());
			pstmt1.setString(9, cng_ins_ms.getRent_l_cd());
			pstmt1.setString(10, cng_ins_ms.getServ_id());
			pstmt1.setString(11, cng_ins_ms.getExt_tm());
		    pstmt1.executeUpdate();
			pstmt1.close();
		    
		    //������ ���� ���̺� ����	
		   	pstmt3 = conn.prepareStatement(query1);
			pstmt3.setString(1, cng_ins_ms.getCust_pay_dt());
			pstmt3.setString(2, cng_ins_ms.getUpdate_id());
			pstmt3.setString(3, cng_ins_ms.getRent_mng_id());
			pstmt3.setString(4, cng_ins_ms.getRent_l_cd());
			pstmt3.setString(5, cng_ins_ms.getServ_id()); //���� id
			pstmt3.executeUpdate();	
			pstmt3.close();
		    
		    conn.commit();
		
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateInsMScd]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt3 != null)	pstmt3.close();
                conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	��������� �Ա� ��ҽ� ������ ���� 
	 */ 
	public boolean dropExtScd(String m_id, String l_cd, String rent_seq, String ext_tm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;

		String query1 = " delete from scd_ext"+
						" where RENT_MNG_ID=? and RENT_L_CD=? and  EXT_TM =  ? and EXT_ST= '4' and RENT_SEQ=?";

		
		try {
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1 , m_id);
			pstmt1.setString(2 , l_cd);
			pstmt1.setString(3 , ext_tm);
			pstmt1.setString(4 , rent_seq);
			pstmt1.executeUpdate();
			pstmt1.close();
		    		
			conn.commit();

		} catch (Exception e) {
			System.out.println("[AddClsDatabase:dropExtScd]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt1 != null)	pstmt1.close();
			
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**
	 *	��ȸ�������� ���� - �繫ȸ��
	 */
	
	public ExtScdBean getAScdIncom(String m_id, String l_cd, String ext_tm, int ext_amt, String pp_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ExtScdBean ext = new ExtScdBean();	
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, RENT_ST, EXT_ST, EXT_TM, EXT_S_AMT, EXT_V_AMT, EXT_PAY_AMT,"+
				" decode(EXT_EST_DT, '', '', substr(EXT_EST_DT, 1, 4) || '-' || substr(EXT_EST_DT, 5, 2) || '-'||substr(EXT_EST_DT, 7, 2)) EXT_EST_DT,"+
				" decode(EXT_PAY_DT, '', '', substr(EXT_PAY_DT, 1, 4) || '-' || substr(EXT_PAY_DT, 5, 2) || '-'||substr(EXT_PAY_DT, 7, 2)) EXT_PAY_DT"+
				" from scd_ext"+
				" where RENT_MNG_ID = ? and RENT_L_CD = ? and ext_tem = ? and (EXT_S_AMT + EXT_V_AMT) = ? and EXT_ST = ? ";		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, ext_tm);
			pstmt.setInt(4, ext_amt);
			pstmt.setString(5, pp_st);
		
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{
				ext.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ext.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ext.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				ext.setExt_st(rs.getString("EXT_ST")==null?"":rs.getString("EXT_ST"));
				ext.setExt_tm(rs.getString("EXT_TM")==null?"":rs.getString("EXT_TM"));
				ext.setExt_s_amt(rs.getString("EXT_S_AMT")==null?0:Integer.parseInt(rs.getString("EXT_S_AMT")));
				ext.setExt_v_amt(rs.getString("EXT_V_AMT")==null?0:Integer.parseInt(rs.getString("EXT_V_AMT")));
				ext.setExt_est_dt(rs.getString("EXT_EST_DT")==null?"":rs.getString("EXT_EST_DT"));
				ext.setExt_pay_amt(rs.getString("EXT_PAY_AMT")==null?0:Integer.parseInt(rs.getString("EXT_PAY_AMT")));
				ext.setExt_pay_dt(rs.getString("EXT_PAY_DT")==null?"":rs.getString("EXT_PAY_DT"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
		  	System.out.println("[AddExtDatabase:getAGrtScdIncom]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ext;
		}				
	} 
	 	
	/**
	 *	��å�� - �繫ȸ��
	 */
		
	public InsMScdBean getScdIns(String m_id, String l_cd, String serv_id, int ext_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		InsMScdBean ins_m_scd = new InsMScdBean();
		String query =  " select a.car_mng_id, a.accid_id, a.rep_amt, a.sup_amt, a.add_amt, a.tot_amt, nvl(se.ext_s_amt,0)+ nvl(se.ext_v_amt,0) cust_amt, nvl(se.ext_s_amt,0) ext_s_amt, nvl(se.ext_v_amt,0) ext_v_amt, se.dly_amt, se.dly_days,"+
						" a.cust_req_dt, se.ext_est_dt, se.ext_pay_dt, se.ext_pay_amt, se.ext_tm  from service a , scd_ext se "+
						" where se.ext_st ='3'  and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd and se.ext_id = a.serv_id and se.RENT_MNG_ID=? and se.RENT_L_CD=? and a.serv_id = ? and (se.ext_s_amt+se.ext_v_amt)= ? ";
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setInt(3, ext_amt);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				ins_m_scd.setRent_mng_id(m_id); 
				ins_m_scd.setRent_l_cd(l_cd); 
			    ins_m_scd.setCar_mng_id(rs.getString("car_mng_id")); 					
				ins_m_scd.setServ_id(serv_id); 
				ins_m_scd.setAccid_id(rs.getString("accid_id")); 				
				ins_m_scd.setRep_amt(rs.getInt("rep_amt")); 
				ins_m_scd.setSup_amt(rs.getInt("sup_amt")); 
				ins_m_scd.setAdd_amt(rs.getInt("add_amt")); 
				ins_m_scd.setTot_amt(rs.getInt("tot_amt")); 
				ins_m_scd.setCust_amt(rs.getInt("cust_amt")); 
				ins_m_scd.setDly_amt(rs.getInt("dly_amt")); 
				ins_m_scd.setPay_amt(rs.getInt("ext_pay_amt")); 
				ins_m_scd.setExt_s_amt(rs.getInt("ext_s_amt")); 
				ins_m_scd.setExt_v_amt(rs.getInt("ext_v_amt")); 
				ins_m_scd.setDly_days(rs.getString("dly_days")); 
				ins_m_scd.setCust_req_dt(rs.getString("cust_req_dt"));
				ins_m_scd.setCust_plan_dt(rs.getString("ext_est_dt")); 
				ins_m_scd.setCust_pay_dt(rs.getString("ext_pay_dt"));
				ins_m_scd.setExt_tm(rs.getString("ext_tm"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getScdIns]\n"+e);

	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_m_scd;
		}				
	} 	


	/**
	 *	������ �����Ա�ǥó�� updateExtGrtSeqId(m_id, l_cd, rent_st,  tm, SeqId)
	 */
	public boolean updateExtGrtSeqId( String m_id, String l_cd, String rent_st, String tm, String SeqId ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
			
		
		String query1 = " UPDATE scd_ext SET seqid= ? "+
						" WHERE ext_st = '0' and rent_mng_id=? and rent_l_cd=? and rent_st = ? and ext_tm= ?  ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, SeqId);
			pstmt.setString(2, m_id);
			pstmt.setString(3, l_cd);
			pstmt.setString(4, rent_st);
			pstmt.setString(5, tm);
		
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateExtGrtSeqId]\n"+e);
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
	
	/**
	 *	�����Ա�ǥó�� updateExtGrtSeqId(m_id, l_cd, rent_st,  ext_id, tm, SeqId, t_gubun) - ��å��, �޴������ ext_id��
	 */
	public boolean updateScdExtSeqId( String m_id, String l_cd, String rent_st, String ext_id, String tm, String SeqId, String t_gubun ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		
		String gubun = "";
		
		if ( t_gubun.equals("grt") ) {
			gubun = "0";
		} else if ( t_gubun.equals("car_ja") ) {	
			gubun = "3";	
		} else if ( t_gubun.equals("commi") ) {	
			gubun = "5";	
		}	
		
		
	//	String query1 = " UPDATE scd_ext SET seqid= ? "+
	//					" WHERE ext_st = ? and rent_mng_id=? and rent_l_cd=? and rent_st = ? and ext_tm= ?  ";
		
		String query1 = " UPDATE scd_ext SET seqid= ? "+
						" WHERE ext_st = ? and rent_mng_id=? and rent_l_cd=?  and ext_id = ?  and ext_tm= ?  ";				

      System.out.println("�Ա�ǥ seqid=" + SeqId + "| rent_l_cd=" + l_cd  ) ;
      
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, SeqId);
			pstmt.setString(2, gubun);
			pstmt.setString(3, m_id);
			pstmt.setString(4, l_cd);
			pstmt.setString(5, ext_id);
			pstmt.setString(6, tm);
		
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateScdExtSeqId]\n"+e);
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
	
	
	/**
	 *	�����Ա�ǥó�� updateExtGrtSeqId(m_id, l_cd, rent_st,  tm, SeqId, t_gubun)
	 */
	public boolean updateScdExtSeqId( String m_id, String l_cd, String rent_st, String tm, String SeqId, String t_gubun ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		
		String gubun = "";
		
		if ( t_gubun.equals("grt") ) {
			gubun = "0";
		} else if ( t_gubun.equals("car_ja") ) {	
			gubun = "3";	
		} else if ( t_gubun.equals("commi") ) {	
			gubun = "5";	
		}	
		
		String query1 = " UPDATE scd_ext SET seqid= ? "+
						" WHERE ext_st = ? and rent_mng_id=? and rent_l_cd=? and rent_st = ? and ext_tm= ?  ";
		
	
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, SeqId);
			pstmt.setString(2, gubun);
			pstmt.setString(3, m_id);
			pstmt.setString(4, l_cd);
			pstmt.setString(5, rent_st);
			pstmt.setString(6, tm);
		
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateScdExtSeqId]\n"+e);
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
	
	
	/**
	 *	��ȸ�������ݽ����� ����
	 */
	
	public ExtScdBean getAGrtScd2(String m_id, String l_cd, String r_st, String pp_st, String pp_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ExtScdBean ext = new ExtScdBean();	
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, RENT_ST, EXT_ST, EXT_TM, EXT_S_AMT, EXT_V_AMT, EXT_PAY_AMT,"+
				" decode(EXT_EST_DT, '', '', substr(EXT_EST_DT, 1, 4) || '-' || substr(EXT_EST_DT, 5, 2) || '-'||substr(EXT_EST_DT, 7, 2)) EXT_EST_DT,"+
				" decode(EXT_PAY_DT, '', '', substr(EXT_PAY_DT, 1, 4) || '-' || substr(EXT_PAY_DT, 5, 2) || '-'||substr(EXT_PAY_DT, 7, 2)) EXT_PAY_DT, incom_dt, incom_seq, update_id, update_dt "+
				" from scd_ext"+
				" where RENT_MNG_ID = ? and RENT_L_CD = ? and EXT_ST = ? and EXT_TM = ?";		

		if(!r_st.equals(""))	query += " and RENT_ST = '"+r_st+"' ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, pp_st);
			pstmt.setString(4, pp_tm);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{
				ext.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ext.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ext.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				ext.setExt_st(rs.getString("EXT_ST")==null?"":rs.getString("EXT_ST"));
				ext.setExt_tm(rs.getString("EXT_TM")==null?"":rs.getString("EXT_TM"));
				ext.setExt_s_amt(rs.getString("EXT_S_AMT")==null?0:Integer.parseInt(rs.getString("EXT_S_AMT")));
				ext.setExt_v_amt(rs.getString("EXT_V_AMT")==null?0:Integer.parseInt(rs.getString("EXT_V_AMT")));
				ext.setExt_est_dt(rs.getString("EXT_EST_DT")==null?"":rs.getString("EXT_EST_DT"));
				ext.setExt_pay_amt(rs.getString("EXT_PAY_AMT")==null?0:Integer.parseInt(rs.getString("EXT_PAY_AMT")));
				ext.setExt_pay_dt(rs.getString("EXT_PAY_DT")==null?"":rs.getString("EXT_PAY_DT"));
				ext.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				ext.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				ext.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				ext.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
		  	System.out.println("[AddExtDatabase:getAGrtScd2]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ext;
		}				
	}

	/**
	 *	��å�� ������ �������� : �Ա�ó��, �Ա����, û���ݾ� ����, �Ա����� ���� ins_m_c.jsp
	 */
	
	public boolean updateInsMScdSeqId(InsMScdBean cng_ins_ms){
		
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;

		String query = "";
		query = " UPDATE scd_ext SET seqid=? WHERE ext_st = '3' and rent_mng_id=? and rent_l_cd=? and ext_id = ? and ext_tm = ? ";
				
		try 
		{
			conn.setAutoCommit(false);
							 	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, cng_ins_ms.getSeqId());
			pstmt1.setString(2, cng_ins_ms.getRent_mng_id());
			pstmt1.setString(3, cng_ins_ms.getRent_l_cd());
			pstmt1.setString(4, cng_ins_ms.getServ_id()); //���� id
			pstmt1.setString(5, cng_ins_ms.getExt_tm());
		    pstmt1.executeUpdate();
			pstmt1.close();
		   				   		  				
			conn.commit();
		    
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateInsMScdSeqId(InsMScdBean)]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	��ȸ�������ݽ����� ����
	 */
	
	public ExtScdBean getAGrtScd(String m_id, String l_cd, String r_st, String pp_st, String pp_tm, String pp_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ExtScdBean ext = new ExtScdBean();	
		String query = "";
		query = " select"+
				" RENT_MNG_ID, RENT_L_CD, RENT_ST, EXT_ST, EXT_ID, EXT_TM, EXT_S_AMT, EXT_V_AMT, EXT_PAY_AMT,"+
				" decode(EXT_EST_DT, '', '', substr(EXT_EST_DT, 1, 4) || '-' || substr(EXT_EST_DT, 5, 2) || '-'||substr(EXT_EST_DT, 7, 2)) EXT_EST_DT,"+
				" decode(EXT_PAY_DT, '', '', substr(EXT_PAY_DT, 1, 4) || '-' || substr(EXT_PAY_DT, 5, 2) || '-'||substr(EXT_PAY_DT, 7, 2)) EXT_PAY_DT, incom_dt, incom_seq, seqid, update_id, update_dt "+
				" from scd_ext"+
				" where RENT_MNG_ID = ? and RENT_L_CD = ? and RENT_ST = ? and EXT_ST = ? and EXT_TM = ? and nvl(bill_yn, 'Y') = 'Y' and ext_id=? ";		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, r_st);
			pstmt.setString(4, pp_st);
			pstmt.setString(5, pp_tm);
			pstmt.setString(6, pp_id);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{
				ext.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ext.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ext.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				ext.setExt_st(rs.getString("EXT_ST")==null?"":rs.getString("EXT_ST"));
				ext.setExt_id(rs.getString("EXT_ID")==null?"":rs.getString("EXT_ID"));
				ext.setExt_tm(rs.getString("EXT_TM")==null?"":rs.getString("EXT_TM"));
				ext.setExt_s_amt(rs.getString("EXT_S_AMT")==null?0:Integer.parseInt(rs.getString("EXT_S_AMT")));
				ext.setExt_v_amt(rs.getString("EXT_V_AMT")==null?0:Integer.parseInt(rs.getString("EXT_V_AMT")));
				ext.setExt_pay_amt(rs.getString("EXT_PAY_AMT")==null?0:Integer.parseInt(rs.getString("EXT_PAY_AMT")));
				ext.setExt_est_dt(rs.getString("EXT_EST_DT")==null?"":rs.getString("EXT_EST_DT"));
				ext.setExt_pay_dt(rs.getString("EXT_PAY_DT")==null?"":rs.getString("EXT_PAY_DT"));
				ext.setIncom_dt(rs.getString("incom_dt")==null?"":rs.getString("incom_dt"));
				ext.setIncom_seq(rs.getString("incom_seq")==null?0:Integer.parseInt(rs.getString("incom_seq")));
				ext.setSeqId(rs.getString("seqid")==null?"":rs.getString("seqid"));
				ext.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				ext.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));

			}
			rs.close();
			pstmt.close();



		} catch (SQLException e) {
		  	System.out.println("[AddExtDatabase:getAGrtScd(String m_id, String l_cd, String r_st, String pp_st, String pp_tm, String pp_id)]\n"+e);
		  	System.out.println("[AddExtDatabase:getAGrtScd(String m_id, String l_cd, String r_st, String pp_st, String pp_tm, String pp_id)]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ext;
		}				
	}


	/**
	 *	 ��/������  �Ǻ� ������ ��ȸ�� ��/������ ����(�� ����) blii_doc_yn  0->�̹��� 1->����
	 */
	
	public MyAccidBean getAccidScd(String m_id, String l_cd, String c_id, String accid_id, int seq_no, String ext_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MyAccidBean my_scd = new MyAccidBean();
		
		String ext_id = accid_id + Integer.toString(seq_no);
				
		String query =  " select case when m.mc_v_amt > 0 then '1' else '0' end bill_doc_yn , nvl(se.ext_s_amt,0)+ nvl(se.ext_v_amt,0) req_amt, nvl(se.ext_s_amt,0) ext_s_amt, nvl(se.ext_v_amt,0) ext_v_amt, se.dly_amt, se.dly_days,"+
						" se.ext_est_dt, se.ext_pay_dt, se.ext_pay_amt, se.ext_tm, se.ext_id "+
						" from   scd_ext se, my_accid m, accident a  "+
						" where "+
						" se.RENT_MNG_ID =? and se.RENT_L_CD=? and m.CAR_MNG_ID=? and m.ACCID_ID=? and m.seq_no = ? and se.ext_id = ?  and se.ext_tm = ? "+
						" and se.ext_st ='6'  and se.rent_mng_id = a.rent_mng_id and se.rent_l_cd = a.rent_l_cd " +
						" and a.car_mng_id = m.car_mng_id and a.accid_id = m.accid_id " +  
						" and substr(se.ext_id,1,6) = m.accid_id and substr(se.ext_id,7) = to_char(m.seq_no) "+ 
						" ";
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, m_id		);
			pstmt.setString(2, l_cd		);
			pstmt.setString(3, c_id		);
			pstmt.setString(4, accid_id	);
			pstmt.setInt(5, seq_no	);
			pstmt.setString(6, ext_id	);
			pstmt.setString(7, ext_tm	);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				my_scd.setRent_mng_id(m_id); 
				my_scd.setRent_l_cd(l_cd); 
			    my_scd.setCar_mng_id(c_id); 
				my_scd.setAccid_id(accid_id); 	
				my_scd.setSeq_no(seq_no); 				
				my_scd.setIns_req_amt(rs.getInt("req_amt")); 
				my_scd.setMc_s_amt(rs.getInt("ext_s_amt")); 
				my_scd.setMc_v_amt(rs.getInt("ext_v_amt")); 						
				my_scd.setIns_pay_amt(rs.getInt("ext_pay_amt")); 
				my_scd.setIns_req_dt(rs.getString("ext_est_dt")); 
				my_scd.setIns_pay_dt(rs.getString("ext_pay_dt"));
				my_scd.setExt_tm(rs.getString("ext_tm"));
				my_scd.setExt_id(rs.getString("ext_id"));
				my_scd.setBill_doc_yn(rs.getString("bill_doc_yn"));
			}
			rs.close();
			pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getAccidScd]\n"+e);
			System.out.println(query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return my_scd;
		}				
	}
	
	/**
	 *	��/������ ������ �������� : �Ա�ó��, �Ա����, û���ݾ� ����, �Ա����� ����  - �Աݿ���
	 */
	
	public boolean updateAccidMScd(MyAccidBean my_scd, String cmd, String pay_yn, String incom_dt, int incom_seq){
		
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;

		String query = "";
		query = " UPDATE scd_ext SET ext_est_dt=replace(?, '-', ''), ext_pay_dt=replace(?, '-', ''), ext_s_amt=?, ext_v_amt=?, ext_pay_amt=?, "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? , incom_dt = replace(?, '-', ''), incom_seq = ? "+
				" WHERE ext_st = '6' and rent_mng_id=? and rent_l_cd=? and ext_id = ? and ext_tm = ? ";
												
		String query1 = "";
		query1 = " UPDATE my_accid SET PAY_DT =replace(?, '-', ''), pay_gu = ?, "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE  car_mng_id =? and accid_id=? and seq_no = ?  ";		

		try 
		{
			conn.setAutoCommit(false);
							 	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, my_scd.getIns_req_dt());
			pstmt1.setString(2, my_scd.getIns_pay_dt());
			pstmt1.setInt(3, my_scd.getMc_s_amt());
			pstmt1.setInt(4, my_scd.getMc_v_amt());
			pstmt1.setInt(5, my_scd.getIns_pay_amt());
			pstmt1.setString(6, my_scd.getUpdate_id());
			pstmt1.setString(7, incom_dt);
			pstmt1.setInt(8,  incom_seq);
			pstmt1.setString(9, my_scd.getRent_mng_id());
			pstmt1.setString(10, my_scd.getRent_l_cd());
			pstmt1.setString(11, my_scd.getExt_id()); //��� id + ����d
			pstmt1.setString(12, my_scd.getExt_tm());
		    pstmt1.executeUpdate();
			pstmt1.close();
		   				   
		   
		   //������ ���� ���̺� ����	
		   	pstmt3 = conn.prepareStatement(query1);
			pstmt3.setString(1, my_scd.getIns_pay_dt());
			pstmt3.setString(2, my_scd.getPay_gu());
			pstmt3.setString(3, my_scd.getUpdate_id());
			pstmt3.setString(4, my_scd.getCar_mng_id()); //car
			pstmt3.setString(5, my_scd.getAccid_id()); //���id
			pstmt3.setInt   (6, my_scd.getSeq_no());  //����				
			pstmt3.executeUpdate();	  
			pstmt3.close();

			//�ܾ׹߻��� ������ �߰�  -- �ܾ��� ���̳ʽ� �� ��������  ��������. - ������ û���Ҽ� ���ǰ� ����
			if(cmd.equals("p") && my_scd.getMc_s_amt()+my_scd.getMc_v_amt() != my_scd.getIns_pay_amt()  ){	
	                           if ( my_scd.getMc_s_amt()+my_scd.getMc_v_amt()-my_scd.getIns_pay_amt() > 9999  ) {
					String query_in = " INSERT INTO scd_ext"+
						" (rent_mng_id, rent_l_cd, rent_st, rent_seq, ext_st, ext_id, ext_tm, ext_s_amt, ext_v_amt,"+
						" ext_est_dt, ext_pay_amt, dly_amt, update_dt, update_id, bill_yn  )"+//11
						" values "+
						" (?, ?, '9', '1', '6', ?, ?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?)";			
	
					int	n_cls_tm = Integer.parseInt(my_scd.getExt_tm())+1;
					int n_cls_amt = my_scd.getMc_s_amt()+my_scd.getMc_v_amt()-my_scd.getIns_pay_amt();
					int n_cls_s_amt = 0;
					int n_cls_v_amt = 0;
					
					n_cls_s_amt = (new Double(n_cls_amt/1.1)).intValue();
					n_cls_v_amt = n_cls_amt-n_cls_s_amt;
								   
					pstmt2 = conn.prepareStatement(query_in);
					pstmt2.setString(1, my_scd.getRent_mng_id());
					pstmt2.setString(2, my_scd.getRent_l_cd());
					pstmt2.setString(3, my_scd.getExt_id());
					pstmt2.setString(4, Integer.toString(n_cls_tm));
				
					pstmt2.setInt   (5, n_cls_s_amt);
					pstmt2.setInt   (6, n_cls_v_amt);
					pstmt2.setString(7, my_scd.getIns_req_dt());
					pstmt2.setInt   (8, 0);
					pstmt2.setInt   (9, 0);
					pstmt2.setString(10, my_scd.getUpdate_id());
					pstmt2.setString(11, "Y");
							    
					pstmt2.executeUpdate();
					pstmt2.close();
				}	
								
			}
							
			conn.commit();
		    

		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateAccidMScd(pay_yn)]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
                if(pstmt3 != null)	pstmt3.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
 
 
	// ��ȸ -------------------------------------------------------------------------------------------------

	// ������/������ ����Ʈ ��ȸ - tax�ϴ� ���� - 20181105 �ӵ� 
	public Vector getInsurHList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select  \n"+
				"		a.car_mng_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, c.firm_nm, c.client_nm,\n"+
				"		cr.car_no, cr.car_nm, cn.car_name, decode(e.ext_pay_dt, '','�̼���','����') gubun, b.ins_com ot_ins2,\n"+
				"		decode(a.accid_st, '1','������', '2','������', '3','�ֹ�', '4','�������') accid_st, nvl(a.ot_ins,'') ot_ins,\n"+
				"		decode(b.req_gu, '1','������', '2','������') req_gu, decode(b.pay_gu, '1','������', '2','������', case when e.ext_tm='1' and e.ext_pay_dt is null then '' else '������' end) pay_gu, "+
				"		e.ext_s_amt mc_s_amt, e.ext_v_amt mc_v_amt, nvl(e.ext_s_amt, 0) + nvl(e.ext_v_amt, 0) req_amt, e.ext_pay_amt pay_amt, b.dly_days, c.use_yn, c.mng_id, c.rent_st,\n"+
				"		nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),'') accid_dt,\n"+
				"		nvl2(e.ext_est_dt,substr(e.ext_est_dt,1,4)||'-'||substr(e.ext_est_dt,5,2)||'-'||substr(e.ext_est_dt,7,2),'') req_dt,\n"+
				"		nvl2(e.ext_pay_dt,substr(e.ext_pay_dt,1,4)||'-'||substr(e.ext_pay_dt,5,2)||'-'||substr(e.ext_pay_dt,7,2),'') pay_dt,\n"+
				"		case when c.mng_id = '' then c.bus_id2 when c.mng_id is null then c.bus_id2 else c.mng_id end bus_id2, \n"+
				"		''  ext_dt,"+
				"		c.rent_dt2, e.ext_id , e.ext_tm , b.seq_no  \n"+
				" from	accident a, my_accid b, cont_n_view c, scd_ext e,  car_reg cr,  car_etc g, car_nm cn  \n"+
				" where\n"+
				"		a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id \n"+
				"		and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd\n"+
					"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                    		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)   \n"+			
				"		and nvl(b.bill_yn,'Y') = 'Y' "+
				"		and e.ext_st = '6' and e.rent_mng_id=a.rent_mng_id and e.rent_l_cd=a.rent_l_cd and e.ext_id = b.accid_id || to_char(b.seq_no) \n"+
				"		and b.req_amt > 0 and (e.ext_s_amt+e.ext_v_amt) > 0  AND b.req_st <> '3'  and e.ext_est_dt >= '20100101' " ;


		if(!gubun1.equals(""))		query += " and b.req_gu='"+gubun1+"'";



		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and e.ext_est_dt like to_char(sysdate,'YYYYMM')||'%'";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and e.ext_est_dt like to_char(sysdate,'YYYYMM')||'%' and e.ext_pay_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and e.ext_est_dt like to_char(sysdate,'YYYYMM')||'%' and e.ext_pay_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and e.ext_est_dt = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and e.ext_est_dt = to_char(sysdate,'YYYYMMDD') and e.ext_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and e.ext_est_dt = to_char(sysdate,'YYYYMMDD') and e.ext_pay_dt is null";
		//��ü-��ȹ
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and e.ext_est_dt < to_char(sysdate,'YYYYMMDD') and (e.ext_pay_dt is null or e.ext_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//��ü-����
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and e.ext_est_dt < to_char(sysdate,'YYYYMMDD') and e.ext_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//��ü-�̼���
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and e.ext_est_dt < to_char(sysdate,'YYYYMMDD') and e.ext_pay_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and e.ext_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and e.ext_pay_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and e.ext_pay_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and e.ext_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and e.ext_pay_dt is null";
		//����+��ü-��ȹ
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and e.ext_est_dt <= to_char(sysdate,'YYYYMMDD') and (e.ext_pay_dt is null or e.ext_pay_dt = to_char(sysdate,'YYYYMMDD'))";
		//����+��ü-����
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and e.ext_est_dt <= to_char(sysdate,'YYYYMMDD') and e.ext_pay_dt = to_char(sysdate,'YYYYMMDD')";
		//����+��ü-�̼���
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and e.ext_est_dt <= to_char(sysdate,'YYYYMMDD') and e.ext_pay_dt is null";
		//�˻�
		}

		/*��ü��ȸ*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//�Ϲݿ�ü		
				query += " and b.dly_days between 1 and 30";
			}else if(gubun4.equals("3")){ //�νǿ�ü
				query += " and b.dly_days between 31 and 60";
			}else if(gubun4.equals("4")){ //�Ǽ���ü
				query += " and b.dly_days between 61 and 1000";
			}else{}
		}

		/*�˻�����*/
			
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(c.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and b.req_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(c.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(c.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and case when c.mng_id = '' then c.bus_id2 when c.mng_id is null then c.bus_id2 else c.mng_id end = '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.accid_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.ot_ins, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("13"))	query += " and nvl(b.bus_id2,c.bus_id2) = '"+t_wd+"'\n";


		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/
	

		if(sort_gubun.equals("0"))		query += " order by c.use_yn desc, e.ext_est_dt "+sort+", e.ext_pay_dt, c.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by c.use_yn desc, c.firm_nm "+sort+", e.ext_pay_dt, e.ext_est_dt";
		else if(sort_gubun.equals("2"))	query += " order by c.use_yn desc, e.ext_pay_dt "+sort+", c.firm_nm, e.ext_est_dt";
		else if(sort_gubun.equals("3"))	query += " order by c.use_yn desc, b.req_amt "+sort+", e.ext_pay_dt, c.firm_nm, e.ext_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by cr.car_no "+sort+", c.firm_nm, e.ext_est_dt";



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
			System.out.println("[AddExtDatabase:getInsurHList]\n"+e);
			System.out.println("[AddExtDatabase:getInsurHList]\n"+query);
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
	
	// ������/������ �Ǻ� ������ ����Ʈ ���

	public IncomingBean getInsurHScdStat(String m_id, String l_cd, String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		IncomingBean ins_m = new IncomingBean();

		String sub_query = "";
		sub_query = " select * from scd_ext"+
					" where  ext_st = '6' and nvl(ext_s_amt, 0)+ nvl(ext_v_amt,0) > 0 "+
					" and rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'" ;//and car_mng_id='"+c_id+"'" and a.accid_id='"+accid_id+"' and a.serv_id='"+serv_id+"'";

		String query = "";
		query = " select a.*, b.*, c.* from\n"+
					" ( select count(0) tot_su1, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt1 from ("+sub_query+") where  ext_st = '6' and ext_pay_dt is null) a, \n"+
					" ( select count(0) tot_su2, nvl(sum(ext_s_amt+ext_v_amt),0) tot_amt2 from ("+sub_query+") where  ext_st = '6' and ext_pay_dt is not null) b, \n"+
					" ( select count(0) tot_su3, nvl(sum(dly_amt),0) tot_amt3 from ("+sub_query+") where  ext_st = '6' and dly_amt > 0) c";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{
				ins_m.setTot_su1(rs.getInt(1));
				ins_m.setTot_amt1(rs.getInt(2));
				ins_m.setTot_su2(rs.getInt(3));
				ins_m.setTot_amt2(rs.getInt(4));
				ins_m.setTot_su3(rs.getInt(5));
				ins_m.setTot_amt3(rs.getInt(6));
			}
			rs.close();
			pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getInsurHScdStat]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_m;
		}
	}
	
	
		// ������/������ �Ǻ� ������ ����Ʈ ��ȸ
	public Vector getInsurHScd(String m_id, String l_cd, String c_id, String accid_id, int seq_no, String ext_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
                   
		query = " select\n"+
					" a.accid_id, b.seq_no, decode(se.ext_pay_dt, '','�̼���','����') gubun,\n"+
					" decode(a.accid_st, '1','����', '2','����', '3','�ֹ�', '8','�ܵ�' , '6' , '����') accid_st, b.ins_com ot_ins,\n"+
					" decode(b.req_gu, '1','������', '2','������') req_gu, se.ext_tm, \n"+
					" decode(b.pay_gu,'',decode(se.ext_pay_dt,'',b.req_gu,b.pay_gu),b.pay_gu) pay_gu, \n"+
					" nvl(se.ext_s_amt,0)+ nvl(se.ext_v_amt,0) req_amt, se.ext_pay_amt pay_amt, se.dly_amt, se.dly_days, \n"+
					" nvl2(a.accid_dt,substr(a.accid_dt,1,4)||'-'||substr(a.accid_dt,5,2)||'-'||substr(a.accid_dt,7,2),'') accid_dt,\n"+
					" nvl2(se.ext_est_dt,substr(se.ext_est_dt,1,4)||'-'||substr(se.ext_est_dt,5,2)||'-'||substr(se.ext_est_dt,7,2),'') req_dt,\n"+
					" nvl2(se.ext_pay_dt,substr(se.ext_pay_dt,1,4)||'-'||substr(se.ext_pay_dt,5,2)||'-'||substr(se.ext_pay_dt,7,2),' ') pay_dt,\n"+
					" nvl2(j.tax_dt,substr(j.tax_dt,1,4)||'-'||substr(j.tax_dt,5,2)||'-'||substr(j.tax_dt,7,2),' ') ext_dt\n"+
					" from scd_ext se, accident a, my_accid b,\n"+
					"      (select a.rent_l_cd, a.car_mng_id, a.fee_tm||b.rent_seq as ext_id, (a.tax_supply+a.tax_value) as tax_amt, max(tax_dt) tax_dt "+
					"       from   tax a, tax_item_list b "+
					"       where  a.gubun in ('11','12') and a.tax_st<>'C' and a.item_id=b.item_id "+
					"       group by a.rent_l_cd, a.car_mng_id, a.fee_tm, b.rent_seq, (a.tax_supply+a.tax_value) "+
					"      ) j \n"+

					" where\n"+
					" se.ext_st = '6' "+
					" and nvl(se.ext_s_amt,0) <> 0 "+
					" and nvl(se.bill_yn,'Y')='Y' "+
					" and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and a.car_mng_id='"+c_id+"'"+
					" and se.rent_mng_id=a.rent_mng_id and se.rent_l_cd=a.rent_l_cd and substr(se.ext_id,1,6) = a.accid_id "+
					" and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id AND se.ext_id=b.ACCID_ID||b.SEQ_NO \n"+
					" and se.rent_l_cd=j.rent_l_cd(+) and se.ext_id=j.ext_id(+) and (se.ext_s_amt+se.ext_v_amt)=j.tax_amt(+) \n"+
					" order by se.ext_id, se.ext_tm, se.ext_pay_dt, se.ext_est_dt " ; 
	

	
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{				
				InsHScdBean bean = new InsHScdBean();

				bean.setRent_mng_id	(m_id); 
				bean.setRent_l_cd	(l_cd); 
			    bean.setCar_mng_id	(c_id); 	

				bean.setAccid_id	(rs.getString("accid_id")); 				
				bean.setGubun		(rs.getString("gubun")); 
				bean.setAccid_dt	(rs.getString("accid_dt")); 
				bean.setAccid_st	(rs.getString("accid_st")); 
				bean.setOt_ins		(rs.getString("ot_ins")==null?"":rs.getString("ot_ins").trim());
				bean.setReq_gu		(rs.getString("req_gu")==null?"":rs.getString("req_gu").trim()); 
				bean.setReq_amt		(rs.getInt   ("req_amt")); 
				bean.setPay_amt		(rs.getInt   ("pay_amt")); 
				bean.setDly_amt		(rs.getInt   ("dly_amt")); 
				bean.setDly_days	(rs.getString("dly_days")==null?"":rs.getString("dly_days").trim()); 
				bean.setReq_dt		(rs.getString("req_dt")==null?"":rs.getString("req_dt").trim());
				bean.setPay_dt		(rs.getString("pay_dt")==null?"":rs.getString("pay_dt").trim());
				bean.setExt_dt		(rs.getString("ext_dt")==null?"":rs.getString("ext_dt").trim());
				bean.setSeq_no		(rs.getInt   ("seq_no")); 
				bean.setPay_gu		(rs.getString("pay_gu")==null?"":rs.getString("pay_gu")); 
				bean.setExt_tm		(rs.getString("ext_tm")==null?"":rs.getString("ext_tm")); 

				vt.add(bean);	
			}

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getInsurHScd]\n"+e);
			System.out.println("[AddExtDatabase:getInsurHScd]\n"+query);
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
	 *	������/������ �Ǻ� ������ ��ȸ�� ��å�� ����(�� ����)
	 */
	public InsHScdBean getScd(String m_id, String l_cd, String c_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		InsHScdBean ins_h_scd = new InsHScdBean();
		String query =  " select a.req_amt, a.pay_amt, a.dly_amt, a.dly_days,"+
						" a.req_dt, a.pay_dt from my_accid a, accident b"+
						" where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id "+
						" and b.RENT_MNG_ID=? and b.RENT_L_CD=? and b.CAR_MNG_ID=? and b.ACCID_ID=?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, c_id);
			pstmt.setString(4, accid_id);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				ins_h_scd.setRent_mng_id(m_id); 
				ins_h_scd.setRent_l_cd(l_cd); 
			    ins_h_scd.setCar_mng_id(c_id); 					
				ins_h_scd.setAccid_id(accid_id); 				
				ins_h_scd.setReq_amt(rs.getInt("req_amt")); 
				ins_h_scd.setPay_amt(rs.getInt("pay_amt")); 
				ins_h_scd.setDly_amt(rs.getInt("dly_amt")); 
				ins_h_scd.setDly_days(rs.getString("dly_days")); 
				ins_h_scd.setReq_dt(rs.getString("req_dt"));
				ins_h_scd.setPay_dt(rs.getString("pay_dt"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddInsurHDatabase:getScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_h_scd;
		}				
	}

	/**
	 *	��/������ �Ǻ� ������ ��ȸ�� ��å�� ����(�� ����) mc_v_amt > 0 bill_doc_yn 1:���� 0:�̹��� 
	 */
	
	public InsHScdBean getHScd(String m_id, String l_cd, String c_id, String accid_id, int seq_no, String ext_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		InsHScdBean ins_h_scd = new InsHScdBean();
		
		String ext_id = "";
		ext_id = accid_id + Integer.toString(seq_no);
	
		
		String query =  " select nvl(se.ext_s_amt,0)+ nvl(se.ext_v_amt,0) req_amt, nvl(se.ext_s_amt,0) ext_s_amt, nvl(se.ext_v_amt,0) ext_v_amt, se.dly_amt, se.dly_days,"+
						" se.ext_est_dt, se.ext_pay_dt, se.ext_pay_amt, se.ext_tm, se.ext_id , case when a.mc_v_amt > 0 then '1' else '0' end bill_doc_yn  from my_accid a, accident b,  scd_ext se "+
						" where se.ext_st ='6'  and se.rent_mng_id = b.rent_mng_id and se.rent_l_cd = b.rent_l_cd " +
						" and substr(se.ext_id, 1, 6) = b.accid_id and b.accid_id = a.accid_id and a.accid_id = ?  and a.seq_no = ? " +   
						" and se.RENT_MNG_ID=? and se.RENT_L_CD=? and a.CAR_MNG_ID=? and se.ext_id=? and se.ext_tm = ? ";
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, accid_id		);
			pstmt.setInt(2, seq_no		);
			pstmt.setString(3, m_id		);
			pstmt.setString(4, l_cd		);
			pstmt.setString(5, c_id		);
			pstmt.setString(6, ext_id	);
			pstmt.setString(7, ext_tm	);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				ins_h_scd.setRent_mng_id(m_id); 
				ins_h_scd.setRent_l_cd(l_cd); 
			    ins_h_scd.setCar_mng_id(c_id); 					
				ins_h_scd.setAccid_id(accid_id); 	
				ins_h_scd.setSeq_no(seq_no); 	
				ins_h_scd.setExt_id(rs.getString("ext_id")); 					
				ins_h_scd.setReq_amt(rs.getInt("req_amt")); 				
				ins_h_scd.setDly_amt(rs.getInt("dly_amt")); 
				ins_h_scd.setPay_amt(rs.getInt("ext_pay_amt")); 
				ins_h_scd.setExt_s_amt(rs.getInt("ext_s_amt")); 
				ins_h_scd.setExt_v_amt(rs.getInt("ext_v_amt")); 
				ins_h_scd.setDly_days(rs.getString("dly_days")); 				
				ins_h_scd.setReq_dt(rs.getString("ext_est_dt")); 
				ins_h_scd.setPay_dt(rs.getString("ext_pay_dt"));
				ins_h_scd.setExt_tm(rs.getString("ext_tm"));
				ins_h_scd.setBill_doc_yn(rs.getString("bill_doc_yn"));
				
			}
			rs.close();
			pstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getHScd]\n"+e);
			System.out.println(query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ins_h_scd;
		}				
	}
	

	
	/**
	 *	������/������ ������ �������� : �Ա�ó��, �Ա����, û���ݾ� ����, �Ա����� ���� ins_m_c.jsp
	 */	
	public boolean updateInsHScd(InsHScdBean cng_ins_hs, String cmd, String pay_yn){
		
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;

		String query = "";
		query = " UPDATE scd_ext SET ext_est_dt=replace(?, '-', ''), ext_pay_dt=replace(?, '-', ''), ext_s_amt=?, ext_v_amt=?, ext_pay_amt=?, "+
				" ext_dt=replace(?, '-', ''), update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE ext_st = '6' and rent_mng_id=? and rent_l_cd=? and ext_id = ? and ext_tm = ? ";
				
		String query1 = "";
		query1 = " UPDATE MY_ACCID SET pay_dt =replace(?, '-', ''), pay_gu = ? ,  "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE car_mng_id=? and accid_id=? and seq_no = ?  ";		

		try 
		{
			conn.setAutoCommit(false);
							 	
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, cng_ins_hs.getReq_dt());
			pstmt1.setString(2, cng_ins_hs.getPay_dt());
			pstmt1.setInt(3, cng_ins_hs.getExt_s_amt());
			pstmt1.setInt(4, cng_ins_hs.getExt_v_amt());
			pstmt1.setInt(5, cng_ins_hs.getPay_amt());
			pstmt1.setString(6, cng_ins_hs.getExt_dt());
			pstmt1.setString(7, cng_ins_hs.getUpdate_id());
			pstmt1.setString(8, cng_ins_hs.getRent_mng_id());
			pstmt1.setString(9, cng_ins_hs.getRent_l_cd());
			pstmt1.setString(10, cng_ins_hs.getExt_id()); //accid || seq_no
			pstmt1.setString(11, cng_ins_hs.getExt_tm());
		    pstmt1.executeUpdate();
			pstmt1.close();
		   				   
		   
		   //������ ���� ���̺� ����	
		   	pstmt3 = conn.prepareStatement(query1);
			pstmt3.setString(1, cng_ins_hs.getPay_dt());
			pstmt3.setString(2, cng_ins_hs.getPay_gu());
			pstmt3.setString(3, cng_ins_hs.getUpdate_id());
			pstmt3.setString(4, cng_ins_hs.getCar_mng_id());
			pstmt3.setString(5, cng_ins_hs.getAccid_id());
			pstmt3.setInt(6, cng_ins_hs.getSeq_no()); //���� id
			pstmt3.executeUpdate();	 
			pstmt3.close();

			//�ܾ׹߻��� ������ �߰�
			if(cmd.equals("p") && cng_ins_hs.getExt_s_amt()+cng_ins_hs.getExt_v_amt() != cng_ins_hs.getPay_amt()){
		
				String query_in = " INSERT INTO scd_ext"+
					" (rent_mng_id, rent_l_cd, rent_st, rent_seq, ext_st, ext_id, ext_tm, ext_s_amt, ext_v_amt,"+
					" ext_est_dt, ext_pay_amt, dly_amt, update_dt, update_id, bill_yn  )"+//11
					" values "+
					" (?, ?, '9', '1', '6', ?, ?, ?, ?, replace(?, '-', ''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?)";			

				int	n_cls_tm = Integer.parseInt(cng_ins_hs.getExt_tm())+1;
				int n_cls_amt = cng_ins_hs.getExt_s_amt()+cng_ins_hs.getExt_v_amt()-cng_ins_hs.getPay_amt();
				int n_cls_s_amt = 0;
				int n_cls_v_amt = 0;
				
				n_cls_s_amt = (new Double(n_cls_amt/1.1)).intValue();
				n_cls_v_amt = n_cls_amt-n_cls_s_amt;
							   
				pstmt2 = conn.prepareStatement(query_in);
				pstmt2.setString(1, cng_ins_hs.getRent_mng_id());
				pstmt2.setString(2, cng_ins_hs.getRent_l_cd());
				pstmt2.setString(3, cng_ins_hs.getExt_id());
				pstmt2.setString(4, Integer.toString(n_cls_tm));
			
				pstmt2.setInt   (5, n_cls_s_amt);
				pstmt2.setInt   (6, n_cls_v_amt);
				pstmt2.setString(7, cng_ins_hs.getReq_dt());			
				pstmt2.setInt   (8, 0);
				pstmt2.setInt   (9, 0);
				pstmt2.setString(10, cng_ins_hs.getUpdate_id());
				pstmt2.setString(11, "Y");
						    
				pstmt2.executeUpdate();
				pstmt2.close();
								
			}
		
						
			conn.commit();
		    
			    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateInsHScd(pay_yn)]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
                if(pstmt3 != null)	pstmt3.close();
				conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	/**
	 *	��/������ ������ �������� : �Ա�ó��, �Ա����, �Աݿ����� ����, �Ա����� ���� cls_c.jsp
	 */
	
	public boolean updateInsHScd(InsHScdBean cng_ins_hs ){
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt3 = null;
					
		String query = "";
			query = " UPDATE scd_ext SET ext_est_dt=replace(?, '-', ''), ext_pay_dt=replace(?, '-', ''), ext_s_amt=?, ext_v_amt=?, ext_pay_amt=?, "+
				" ext_dt=replace(?, '-', ''), update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?"+
				" WHERE ext_st = '6' and rent_mng_id=? and rent_l_cd=? and ext_id = ? and ext_tm =? ";

		String query1 = "";
		query1 = " UPDATE my_accid SET pay_dt =replace(?, '-', ''),  "+
				" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
				" WHERE car_mng_id=? and accid_id=? and seq_no = ?  ";		
				
		try 
		{
			conn.setAutoCommit(false);
		
			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, cng_ins_hs.getReq_dt());
			pstmt1.setString(2, cng_ins_hs.getPay_dt());
			pstmt1.setInt(3, cng_ins_hs.getExt_s_amt());
			pstmt1.setInt(4, cng_ins_hs.getExt_v_amt());
			pstmt1.setInt(5, cng_ins_hs.getPay_amt());
			pstmt1.setString(6, cng_ins_hs.getExt_dt());
			pstmt1.setString(7, cng_ins_hs.getUpdate_id());
			pstmt1.setString(8, cng_ins_hs.getRent_mng_id());
			pstmt1.setString(9, cng_ins_hs.getRent_l_cd());
			pstmt1.setString(10, cng_ins_hs.getExt_id()); //accid || seq_no
			pstmt1.setString(11, cng_ins_hs.getExt_tm());
				
		    pstmt1.executeUpdate();
			pstmt1.close();
		    
		      //������ ���� ���̺� ����	
		   	pstmt3 = conn.prepareStatement(query1);
		   	pstmt3.setString(1, cng_ins_hs.getPay_dt());
			pstmt3.setString(2, cng_ins_hs.getUpdate_id());
			pstmt3.setString(3, cng_ins_hs.getCar_mng_id());
			pstmt3.setString(4, cng_ins_hs.getAccid_id());
			pstmt3.setInt(5, cng_ins_hs.getSeq_no()); //���� id
			pstmt3.executeUpdate();	
			pstmt3.close();
		    
		    conn.commit();
		
		    
	  	} catch (Exception e) {
			System.out.println("[AddExtDatabase:updateInsHScd]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt3 != null)	pstmt3.close();
                conn.setAutoCommit(true);
			}
			catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	��/������ ���� - �߸�ó���Ͽ� �ܾ� �߻��� ���� .deleteHSc;	
	 */
	
	public boolean deleteHScd(InsHScdBean cng_ins_hs )
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		
		query = " DELETE from  scd_ext   WHERE ext_st = '6' and rent_mng_id=? and rent_l_cd=? and ext_id = ? and ext_tm =? ";
				
		try
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cng_ins_hs.getRent_mng_id());
			pstmt.setString(2, cng_ins_hs.getRent_l_cd());
			pstmt.setString(3, cng_ins_hs.getExt_id()); //accid || seq_no
			pstmt.setString(4, cng_ins_hs.getExt_tm());
			
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	}
	  	catch (Exception e)
	  	{
		  	System.out.println("[AddExtDatabase:deleteHScd]\n"+e);
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
	 *	��������Ȳ
	 */
	public Vector getGrtStatList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT d.ven_code, MIN(d.firm_nm) firm_nm, min(decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ) ,d.enp_no)) enp_no, SUM(b.grt_amt_s) grt_amt \n"+
				" FROM   CONT a, FEE b, \n"+
				"        ( SELECT rent_mng_id, rent_l_cd, MAX(to_number(rent_st)) rent_st \n"+
				"          FROM   FEE \n"+
				"          GROUP BY rent_mng_id, rent_l_cd \n"+
				"        ) c, \n"+
				"        CLIENT d, \n"+
				"        ( select rent_mng_id, rent_l_cd, sum(ext_pay_amt) pay_amt \n"+
				"          from   scd_ext \n"+
				"          where  ext_st='0' and ext_pay_amt>0 \n"+
				"          group by rent_mng_id, rent_l_cd \n"+
				"        ) e \n"+
				" WHERE  NVL(a.use_yn,'Y')='Y' AND a.car_st<>'2' and a.rent_l_cd not like 'RM%' \n"+
				"        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd AND b.rent_st=c.rent_st \n"+
				"        AND b.grt_amt_s>0 \n"+
				"        AND a.client_id=d.client_id \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				" GROUP BY d.ven_code \n"+
				" ORDER BY d.ven_code \n"+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getGrtStatList]\n"+e);
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
	 *	�������� ���Աݾ�  insert 2014-12-24 ryugs  -- ������ - 20181121 �������� û��/ �Ա� ���̺� (cls_guar��� )
	 */
	
	public boolean insertScd_Ext_Pay(String rent_mng_id, String rent_l_cd, String car_mng_id, int pay_amt, String pay_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "";
		query = " insert into SCD_EXT_PAY ("+
				" RENT_MNG_ID, RENT_L_CD, CAR_MNG_ID, PAY_AMT, PAY_DT)"+
				" values ( ?, ?, ?, ?, replace(?, '-', ''))";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  rent_mng_id);
			pstmt.setString(2,  rent_l_cd);
			pstmt.setString(3,  car_mng_id);
			pstmt.setInt   (4,  pay_amt);
			pstmt.setString(5, pay_dt);
		    pstmt.executeUpdate();
			pstmt.close();
			
			
			conn.commit();
		    
	  	} catch (Exception e) {
		  	System.out.println("[AddExtDatabase:insertScd_Ext_Pay]\n"+e);
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

 //�� �̻� ��� ���� -20181121 
	public ScdExtPayBean getExtPay(String m_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ScdExtPayBean ext = new ScdExtPayBean();	
		String query = "";
		query = " select "+
				" RENT_MNG_ID, RENT_L_CD, PAY_AMT, "+				
				" decode(PAY_DT, '', '', substr(PAY_DT, 1, 4) || '-' || substr(PAY_DT, 5, 2) || '-'||substr(PAY_DT, 7, 2)) PAY_DT "+
				" from SCD_EXT_PAY "+
				" where RENT_MNG_ID = ? and RENT_L_CD = ? ";		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);			
	    	rs = pstmt.executeQuery();
	    	
			if(rs.next())
			{			
				ext.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ext.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ext.setPay_amt(rs.getString("PAY_AMT")==null?0:Integer.parseInt(rs.getString("PAY_AMT")));
				ext.setPay_dt(rs.getString("PAY_DT")==null?"":rs.getString("PAY_DT"));			
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
		  	System.out.println("[AddExtDatabase:getExtPay]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ext;
		}				
	}
	
	
	/**
	 *	���ź����� ����Ʈ ��ȸ - con_ecar/ecar_sc_in.jsp 
	 */
	public Vector getEcarList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select "+
				"        b.use_yn, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, a.rent_st, decode(a.ext_st, '0','������','1','������','2','���ô뿩��','5','�°������','7','���ź�����') gubun,"+
				"        decode(a.rent_st, '1','','2','(��)') rent_st_nm, a.ext_st, a.ext_tm, decode(a.ext_pay_dt, '',nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0), nvl(a.ext_pay_amt,0)) ext_amt,"+
				"        a.ext_pay_amt, b.firm_nm, b.client_nm, b.rent_way, b.rent_way_cd, b.bus_id, "+
				"        b.con_mon, a.ext_s_amt, a.ext_v_amt, b.rent_dt, b.rent_start_dt, nvl(cr.car_no, '') car_no, "+
				"        decode(nvl(a.ext_EST_DT,a.ext_pay_dt), '', '', substr(nvl(a.ext_EST_DT,a.ext_pay_dt), 1, 4) || '-' || substr(nvl(a.ext_EST_DT,a.ext_pay_dt), 5, 2) || '-'||substr(nvl(a.ext_EST_DT,a.ext_pay_dt), 7, 2)) EXT_EST_DT,"+
				"        decode(a.EXT_PAY_DT, '', '', substr(a.EXT_PAY_DT, 1, 4) || '-' || substr(a.ext_PAY_DT, 5, 2) || '-'||substr(a.ext_PAY_DT, 7, 2)) EXT_PAY_DT, c.rent_suc_dt"+
				" from   scd_ext a, cont_n_view b, cont_etc c, client d , car_reg cr ,  cls_cont h, car_etc e \n"+
				" where  a.ext_st ='7' \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and b.car_mng_id = cr.car_mng_id(+) \n"+
				"        and nvl(a.ext_s_amt,0) <> 0 and nvl(a.bill_yn,'Y')='Y' \n"+
				"        and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) \n"+
				"        and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+) \n"+
				"        and b.client_id=d.client_id \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"        and e.ecar_pur_sub_amt>0 "+
				" ";

		/*����ȸ&&������ȸ*/

		//���-����
		if(gubun2.equals("1") && gubun3.equals("2")){	    query += " and a.ext_pay_dt like to_char(sysdate,'YYYYMM')||'%' ";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and a.ext_est_dt like to_char(sysdate,'YYYYMM')||'%' and a.ext_pay_dt is null";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and a.ext_pay_dt = to_char(sysdate,'YYYYMMDD') ";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and a.ext_est_dt = to_char(sysdate,'YYYYMMDD') and a.ext_pay_dt is null";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.ext_pay_dt between '"+AddUtil.ChangeString(st_dt)+"' and '"+AddUtil.ChangeString(end_dt)+"' ";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and a.ext_est_dt between '"+AddUtil.ChangeString(st_dt)+"' and '"+AddUtil.ChangeString(end_dt)+"' and a.ext_pay_dt is null";
		//�˻�-����
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.ext_pay_dt is not null";
		//�˻�-�̼���
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.ext_pay_dt is null and nvl(h.cls_st,'0') not in ('7','10')";
		}


		/*�˻�����*/			
		if(!t_wd.equals("")){
			if(s_kd.equals("2"))		query += " and b.client_nm like '%"+t_wd+"%'\n";
			else if(s_kd.equals("3"))	query += " and b.rent_l_cd like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("4"))	query += " and cr.car_no like '%"+t_wd+"%'\n";
			else if(s_kd.equals("5"))	query += " and a.ext_s_amt like '%"+t_wd+"%'\n";
			else if(s_kd.equals("6"))	query += " and b.brch_id like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("7"))	query += " and b.r_site like '%"+t_wd+"%'\n";
			else if(s_kd.equals("8"))	query += " and b.bus_id2= '"+t_wd+"'\n";
			else if(s_kd.equals("9"))	query += " and cr.car_nm like '%"+t_wd+"%'\n";
			else if(s_kd.equals("10"))	query += " and d.enp_no like '%"+t_wd+"%'\n";
			else if(s_kd.equals("11"))	query += " and TEXT_DECRYPT(d.ssn, 'pw' )  like '%"+t_wd+"%'\n";
			else						query += " and b.firm_nm like '%"+t_wd+"%'\n";			
		}

		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.ext_est_dt "+sort+", a.ext_pay_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.ext_pay_dt, a.ext_est_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.ext_pay_dt "+sort+", b.firm_nm, a.ext_est_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.ext_s_amt "+sort+", a.ext_pay_dt, b.firm_nm, a.ext_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.car_no "+sort+", b.firm_nm, a.ext_est_dt";

		
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
			System.out.println("[AddExtDatabase:getEcarList]\n"+e);
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
	
	// ����������� ������Ȳ		2018.02.05 - ������ �������� 
	public Vector getClsFeeScdWarrList(String br_id, String gubun0, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		//�����
		String query1 = "";
	
		query1 =	" select a.rent_mng_id , a.rent_l_cd ,  cn.car_mng_id ,  a.cls_dt, cn.firm_nm, cn.client_nm , cr.car_no, cr.car_nm, c.fdft_amt, g.gi_amt,  b.pay_amt , b.pay_dt , sp.ip_dt gi_pay_dt, sp.ip_amt gi_pay_amt , sp.req_amt gi_req_amt , sp.req_dt gi_req_dt ,  \n" +
						"  cn.bus_id2,   decode(c.fdft_amt - b.pay_amt, 0, 0, 1)  dft_gubun, nvl(t.accid_id, '-') cr_gubun , decode(nvl(cr.prepare, '1'), '9', '9', '4', '4',  '1')  prepare, \n" +
						" to_number(se.dly_days) as dly_days , se.ext_tm as tm, decode(se.ext_tm,'1','','(��)') tm_st , nvl(nvl(a.cls_est_dt, se.ext_est_dt), a.cls_dt)  as est_dt , g.gi_end_dt \n"+								
						"		from cls_cont a, cls_guar sp, cont_n_view cn, car_reg cr ,  \n"+
						"	   (select a.* from tel_mm a, (select rent_mng_id, rent_l_cd, max(seq) seq from tel_mm where tm_st='9' group by rent_mng_id, rent_l_cd) b where a.tm_st = '9' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) t , \n"+
						"		(select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) g, 	\n"+		
					   "      ( select a.* from scd_ext a, ( select rent_mng_id , rent_l_cd , max(ext_tm) ext_tm  from scd_ext where ext_st = '4' and ext_s_amt+ ext_v_amt > 0  group by rent_mng_id, rent_l_cd ) b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and a.ext_st = '4' and a.ext_tm = b.ext_tm and a.ext_s_amt + ext_v_amt  > 0)  se ,\n"+		
				    	"	    ( select rent_mng_id, rent_l_cd , sum(ext_pay_amt) pay_amt, max(ext_pay_dt) pay_dt  \n"+
						"		  from scd_ext where ext_st = '4' and ext_pay_amt > 0 group by rent_mng_id, rent_l_cd ) b ,  \n"+
					   "			 (  select a.rent_mng_id, a.rent_l_cd, sum(decode(a.ext_tm, '1' , decode(sign( a.ext_s_amt + a.ext_v_amt -0) , -1 , 0 ,  ext_s_amt + ext_v_amt ) , '2' , decode(nvl(b.m_cnt, 0) , 1, ext_s_amt + ext_v_amt ,  0 ) ) ) fdft_amt  \n"+
						"			from scd_ext a,  ( select rent_mng_id, rent_l_cd , count(0) m_cnt  from scd_ext where ext_st = '4' and ext_tm in ( '1' ) and ext_s_amt + ext_v_amt < 0 group by rent_mng_id, rent_l_cd   ) b  \n"+			
						"			 	where   a.ext_st = '4' and a.ext_tm in ( '1' , '2' ) \n"+
						"		            and a.ext_s_amt + a.ext_v_amt <> 0  \n"+
						"		            and a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)    group by a.rent_mng_id, a.rent_l_cd ) c 	\n"+
						"		where  a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd \n"+
						"		   and a.rent_mng_id = cn.rent_mng_id and a.rent_l_cd = cn.rent_l_cd \n"+
						"		   and cn.car_mng_id = cr.car_mng_id    \n"+
						"		   and a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+) \n"+
						"		   and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) \n"+
						" 			and a.rent_mng_id = t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) \n"+
						" 			and a.rent_mng_id = se.rent_mng_id(+) and a.rent_l_cd=se.rent_l_cd(+) \n"+
						"		    and a.rent_mng_id = sp.rent_mng_id(+) and a.rent_l_cd = sp.rent_l_cd(+)  and a.cls_st not in ('14' )    ";
						
		//��ü
		String query = " select * from ( \n"+query1+"\n ) where rent_l_cd is not null and fdft_amt > 0 ";		
	
		
		/*����ȸ&&������ȸ*/
		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and cls_dt like to_char(sysdate,'YYYYMM')||'%' ";	
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and cls_dt BETWEEN  replace('"+st_dt+"' , '-', '')  AND replace('"+end_dt+"', '-', '') ";
		//���� - ��ȹ
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += "and cls_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
			
		}
		/*�˻�����*/
			
		if(s_kd.equals("2"))		query += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(car_no, '') like '%"+t_wd+"%'\n";	
		else if(s_kd.equals("10"))	query += " and nvl(cls_dt, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			

		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/
	
		if(sort_gubun.equals("0"))		query += " order by dft_gubun desc , cls_dt "+sort+", pay_dt, firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by dft_gubun desc,   gi_pay_dt "+sort+", pay_dt, est_dt";
		
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
			System.out.println("[AddExtDatabase:getClsFeeScdWarrList]\n"+e);
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
	
	// �����뿩����Ȳ - �����ݰ��� ����Ʈ 
	public Vector getScdPpCostBaseStat(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";  
		
		query =	" SELECT DECODE(c.use_yn,'N','����','����') gubun, decode(b.gubun2,'1','������','2','���ô뿩��','3','�뿩��') gubun2_nm, "+
				"       a.rent_mng_id, a.rent_l_cd, a.rent_st, d.client_id, d.firm_nm, d.ven_code, e.car_no, a.rent_start_dt, a.rent_end_dt, a.con_mon, \r\n" + 
				"       decode(b.gubun2,'1',a.pp_s_amt,'2',a.ifee_s_amt,'3',b.f_rest_amt) f_rest_amt, "+
				"       a.pp_s_amt, (a.pp_s_amt+a.pp_v_amt) pp_amt, "+
				"       a.ifee_s_amt, (a.ifee_s_amt+a.ifee_v_amt) ifee_amt, "+				
				"       f.ext_pay_amt, f.ext_pay_dt, \r\n" + 
				"       b.min_est_dt, a.rent_end_dt AS max_est_dt, b.gubun2, b.rc_amt, b.rest_amt, trunc(b.rest_amt*1.1) r_rest_amt, \r\n" + 
				"       DECODE(g.cls_st,'1','����','8','����','2','�ߵ�����','5','���°�','7','����������','10','����������',g.cls_st) cls_st, g.cls_dt, decode(b.gubun2,'1',decode(a.pp_chk,'0','�յ����','�ϰ�����')) pp_chk \r\n" + 
				"FROM   fee a, \r\n" + 
				"       ( SELECT rent_mng_id, rent_l_cd, rent_st, gubun2, "+
				"                min(est_dt) min_est_dt, MAX(est_dt) max_est_dt, max(rest_amt) f_rest_amt, SUM(rc_amt) rc_amt, min(DECODE(substr(est_dt,1,6),substr(rc_dt,1,6),rest_amt)) rest_amt \r\n" + 
				"         FROM   scd_pp_cost where use_yn='Y' \r\n" ;
		
		if(!gubun2.equals("")) {
			query += " and gubun2='"+gubun2+"' ";
		} 
		
		if(!gubun3.equals("")) {  
			query += " and est_dt<='"+gubun3+"' ";
		}

		query+= "         GROUP BY rent_mng_id, rent_l_cd, rent_st, gubun2 \r\n" + 
				"       ) b, \r\n" + 
				"       cont c, client d, car_reg e,\r\n" + 
				"       ( SELECT rent_mng_id, rent_l_cd, rent_st, ext_st, SUM(ext_pay_amt) ext_pay_amt, MAX(ext_pay_dt) ext_pay_dt \r\n" + 
				"         FROM   scd_ext \r\n" + 
				"         WHERE  ext_st in ('1','2') \r\n" + 
				"         GROUP BY rent_mng_id, rent_l_cd, rent_St, ext_st \r\n" + 
				"       ) f,\r\n" + 
				"       cls_cont g\r\n" + 
				"WHERE  a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND a.RENT_ST=b.rent_st \r\n" + 
				"       AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd\r\n" + 
				"       AND c.client_id=d.client_id\r\n" + 
				"       AND c.car_mng_id=e.car_mng_id(+) \r\n" + 
				"       AND b.rent_mng_id=f.rent_mng_id(+) AND b.rent_l_cd=f.rent_l_cd(+) AND b.RENT_ST=f.rent_st(+) and b.gubun2=f.ext_st(+) \r\n" + 
				"       AND a.rent_mng_id=g.rent_mng_id(+) AND a.rent_l_cd=g.rent_l_cd(+)\r\n"; 
		
		
		if(!gubun1.equals("")) {
			query += " and nvl(c.use_yn,'Y')='"+gubun1+"' ";
		}
		
		//�������ڰ� ������ �ܾ��ִ°͸� ���´�.
		//if(!gubun3.equals("")) {  
		//	query += " and b.rest_amt > 0 ";
		//}		
		
		if(!t_wd.equals("")) {
			if(s_kd.equals("1"))	query += " and e.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("2"))	query += " and d.firm_nm like '%"+t_wd+"%'";
			if(s_kd.equals("3"))	query += " and a.rent_l_cd = '"+t_wd+"'";
			if(s_kd.equals("4"))	query += " and a.rent_start_dt like '"+t_wd+"%'";
			if(s_kd.equals("5"))	query += " and a.rent_mng_id like '"+t_wd+"%'";
		}  
		
		query +="ORDER BY a.rent_end_dt  "; 
									
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
			System.out.println("[AddExtDatabase:getScdPpCostBaseStat]\n"+e);
			System.out.println("[AddExtDatabase:getScdPpCostBaseStat]\n"+query);
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
	
	// �����뿩����Ȳ - ������(�յ����) ����Ʈ 
	public Vector getScdPpCostBase2Stat(String s_kd, String t_wd, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = ""; 
		
		query =	" SELECT DECODE(b.use_yn,'N','����','����') gubun, a.rent_mng_id, a.rent_l_cd, a.rent_st, i.client_id, i.firm_nm, i.ven_code, h.car_no, a.rent_start_dt, a.rent_end_dt, a.con_mon, \r\n" + 
				"			 a.pp_s_amt, (a.pp_s_amt+a.pp_v_amt) pp_amt, e.ext_pay_amt, e.ext_pay_dt, \r\n" + 
				"			 g.min_est_dt, g.max_est_dt, g.a_amt AS rc_amt, g.b_amt AS rest_amt, \r\n" + 
				"			 DECODE(f.cls_st,'1','����','8','����','2','�ߵ�����','5','���°�','7','����������','10','����������',f.cls_st) cls_st, f.cls_dt\r\n" + 
				"FROM   fee a, cont b, cont_etc c, fee_etc d, cls_cont f,  \r\n" + 
				"       (SELECT a.rent_l_cd, MIN(a.tax_out_dt) min_est_dt, MAX(a.tax_out_dt) max_est_dt, SUM(a.fee_s_amt+a.fee_v_amt) scd_amt, SUM(DECODE(b.tax_dt,'',0,a.fee_s_amt+a.fee_v_amt)) a_amt,  SUM(DECODE(b.tax_dt,'',a.fee_s_amt+a.fee_v_amt,0)) b_amt  \r\n" + 
				"        FROM   scd_fee a, \r\n" + 
				"               (SELECT b.rent_l_cd, b.tm, b.rent_st, b.rent_seq, MAX(c.tax_dt) tax_dt, SUM(b.item_supply) item_supply, SUM(b.item_value) item_value \r\n" + 
				"                FROM   tax_item_list b, tax c \r\n" + 
				"                WHERE b.gubun='1' AND b.rent_seq='2' AND b.item_id=c.item_id AND c.tax_st<>'C' ";
		
		if(!gubun2.equals("")) {
			query += " and c.tax_dt<='"+gubun2+"' ";
		}
		
        query+="                GROUP BY b.rent_l_cd, b.tm, b.rent_st, b.rent_seq\r\n" + 
				"               ) b\r\n" + 
				"        WHERE  a.tm_st2='4' AND a.bill_yn='Y' AND a.rent_l_cd=b.rent_l_cd(+) AND a.rent_st=b.rent_st(+) AND a.rent_seq=b.rent_seq(+) AND a.fee_tm=b.tm(+) \r\n" + 
				"        GROUP BY a.rent_l_cd) g,\r\n" + 
				"        car_reg h, client i,\r\n" + 
				"			 (SELECT rent_mng_id, rent_l_cd, rent_st, SUM(ext_pay_amt) ext_pay_amt, MAX(ext_pay_dt) ext_pay_dt \r\n" + 
				"				FROM   scd_ext \r\n" + 
				"				WHERE  ext_st='1' \r\n" + 
				"				GROUP BY rent_mng_id, rent_l_cd, rent_St \r\n" + 
				"			 ) e          \r\n" + 
				"WHERE  a.pp_chk='0' AND a.pp_s_amt >0 AND a.rent_l_cd=b.rent_l_cd AND b.RENT_L_Cd=c.rent_l_cd AND a.rent_l_cd=d.rent_l_cd AND a.RENT_ST=d.rent_st\r\n" + 
				"AND a.rent_l_cd=f.rent_l_cd(+) AND nvl(f.cls_st,'0') NOT IN ('7')\r\n" + 
				"AND a.rent_l_cd=g.rent_l_cd(+)\r\n" + 
				"AND b.car_mng_id=h.car_mng_id(+) AND b.client_id=i.client_id  \r\n" + 
				"AND a.rent_l_cd=e.rent_l_cd(+) AND a.RENT_ST=e.rent_st(+)\r\n" + 
				"";
		
		if(!gubun1.equals("")) {
			query += " and nvl(b.use_yn,'Y')='"+gubun1+"' ";
		}
		
		if(!t_wd.equals("")) {
			if(s_kd.equals("1"))	query += " and h.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("2"))	query += " and i.firm_nm like '%"+t_wd+"%'";
			if(s_kd.equals("3"))	query += " and a.rent_l_cd = '"+t_wd+"'";
			if(s_kd.equals("4"))	query += " and a.rent_start_dt like '"+t_wd+"%'";
		}
		
		query +="ORDER BY a.rent_start_dt ";
									
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
			System.out.println("[AddExtDatabase:getScdPpCostBase2Stat]\n"+e);
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
	
	
	// �����뿩����Ȳ - �����ݰ��� ����Ʈ 
	public Vector getScdPpCostBaseStat(String s_kd, String t_wd)
	{
		getConnection(); 
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query =	" SELECT DECODE(c.use_yn,'N','����','����') gubun, a.rent_mng_id, a.rent_l_cd, a.rent_st, d.firm_nm, e.car_no, a.rent_start_dt, a.rent_end_dt, a.con_mon, \r\n" + 
				"       a.pp_s_amt, (a.pp_s_amt+a.pp_v_amt) pp_amt, f.ext_pay_amt, f.ext_pay_dt, \r\n" + 
				"       b.min_est_dt, a.rent_end_dt AS max_est_dt, b.rc_amt, b.rest_amt, trunc(b.rest_amt*1.1) r_rest_amt,\r\n" + 
				"       DECODE(g.cls_st,'1','����','8','����','2','�ߵ�����','5','���°�','7','����������','10','����������',g.cls_st) cls_st, g.cls_dt, decode(a.pp_chk,'0','�յ����','�ϰ�����') pp_chk \r\n" + 
				"FROM   fee a, \r\n" + 
				"       ( SELECT rent_mng_id, rent_l_cd, rent_st, min(est_dt) min_est_dt, MAX(est_dt) max_est_dt, SUM(rc_amt) rc_amt, min(DECODE(est_dt,rc_dt,rest_amt)) rest_amt \r\n" + 
				"         FROM   scd_pp_cost \r\n" + 
				"         GROUP BY rent_mng_id, rent_l_cd, rent_st\r\n" + 
				"       ) b, \r\n" + 
				"       cont c, client d, car_reg e,\r\n" + 
				"       ( SELECT rent_mng_id, rent_l_cd, rent_st, SUM(ext_pay_amt) ext_pay_amt, MAX(ext_pay_dt) ext_pay_dt \r\n" + 
				"         FROM   scd_ext \r\n" + 
				"         WHERE  ext_st='1' AND ext_tm='1' \r\n" + 
				"         GROUP BY rent_mng_id, rent_l_cd, rent_St\r\n" + 
				"       ) f,\r\n" + 
				"       cls_cont g\r\n" + 
				"WHERE  a.pp_s_amt >0 \r\n" + 
				"       AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND a.RENT_ST=b.rent_st \r\n" + 
				"       AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd\r\n" + 
				"       AND c.client_id=d.client_id\r\n" + 
				"       AND c.car_mng_id=e.car_mng_id\r\n" + 
				"       AND a.rent_mng_id=f.rent_mng_id AND a.rent_l_cd=f.rent_l_cd AND a.RENT_ST=f.rent_st\r\n" + 
				"       AND a.rent_mng_id=g.rent_mng_id(+) AND a.rent_l_cd=g.rent_l_cd(+)\r\n" + 
				"  ";
		
		
				if(s_kd.equals("1"))	query += " and e.car_no like '%"+t_wd+"%'";
				if(s_kd.equals("2"))	query += " and d.firm_nm like '%"+t_wd+"%'";
				if(s_kd.equals("3"))	query += " and a.rent_l_cd = '"+t_wd+"'";
									
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
			System.out.println("[AddExtDatabase:getScdPpCostBaseStat]\n"+e);
			System.out.println("[AddExtDatabase:getScdPpCostBaseStat]\n"+query);
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
	
	// �����뿩����Ȳ - �������� 
	public Vector getScdPpCostCaseStat(String rent_mng_id, String rent_l_cd, String rent_st, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query =	"SELECT a.rent_mng_id, a.rent_l_cd, a.rent_st, a.tm, a.est_dt, a.est_amt, a.rc_dt, a.rc_amt, a.sum_amt, a.rest_amt, a.use_yn, a.gubun, a.reg_code\r\n" + 
				"FROM   scd_pp_cost a\r\n" + 
				"WHERE  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.rent_st='"+rent_st+"' and a.gubun2='"+gubun2+"' \r\n" + 
				"ORDER BY DECODE(a.gubun,'�����������',4,'ȯ��(����)',3,'����',2,1), a.rc_dt, a.est_dt ";
									
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
			System.out.println("[AddExtDatabase:getScdPpCostCaseStat]\n"+e);
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
	
	// �����뿩����Ȳ - �������� 
	public Vector getScdPpCostCase2Stat(String rent_mng_id, String rent_l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query =	"SELECT a.rent_mng_id, a.rent_l_cd, a.rent_st, a.fee_tm as tm, a.fee_est_dt as est_dt, a.tax_out_dt, b.tax_dt, (a.fee_s_amt+a.fee_v_amt) as est_amt, (b.item_supply+b.item_value) tax_amt, a.rc_dt, a.rc_amt, 0 sum_amt, 0 rest_amt, a.bill_yn as use_yn, '' gubun, '' reg_code\r\n" + 
				"FROM   scd_fee a, \r\n" + 
				"               (SELECT b.rent_l_cd, b.tm, b.rent_st, b.rent_seq, MAX(c.tax_dt) tax_dt, SUM(b.item_supply) item_supply, SUM(b.item_value) item_value \r\n" + 
				"                FROM   tax_item_list b, tax c \r\n" + 
				"                WHERE b.gubun='1' AND b.rent_seq='2' AND b.item_id=c.item_id AND c.tax_st<>'C' AND c.tax_dt<'20191201'\r\n" + 
				"                GROUP BY b.rent_l_cd, b.tm, b.rent_st, b.rent_seq\r\n" + 
				"               ) b\r\n" + 
				"WHERE  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.rent_st='"+rent_st+"' and a.tm_st2='4' and a.tm_st1='0' and a.bill_yn='Y' \r\n" + 
				"       AND a.rent_l_cd=b.rent_l_cd(+) AND a.rent_st=b.rent_st(+) AND a.rent_seq=b.rent_seq(+) AND a.fee_tm=b.tm(+)"+
				"ORDER BY a.fee_est_dt ";
									
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
			System.out.println("[AddExtDatabase:getScdPpCostCase2Stat]\n"+e);
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
		
	
	// �����뿩����Ȳ - ��������  - ���� ������ (-) ��꼭����
	public Hashtable getScdPpCostCaseClsTax(String rent_mng_id, String rent_l_cd, String rent_st, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		
		query =	"SELECT b.tax_dt, b.tax_supply \r\n" + 
				"FROM   tax_item_list a, tax b\r\n" + 
				"WHERE  a.rent_l_cd='"+rent_l_cd+"' AND a.gubun=decode('"+gubun2+"','1','3','2','4')\r\n" + 
				"       AND a.item_id=b.item_id AND b.tax_st<>'C'\r\n" + 
				"       AND b.tax_value < 0  ";
									
		try {
			pstmt = conn.prepareStatement(query);	    
	    	rs = pstmt.executeQuery();	    	    	
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{						
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getScdPpCostCaseClsTax]\n"+e);
			System.out.println("[AddExtDatabase:getScdPpCostCaseClsTax]\n"+query);
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
		
	// ���͹ݿ������� 
	public Vector getScdPpCostMonStat(String s_year, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String s_query = "";
		
		if(!gubun2.equals("")) {
			s_query += " and gubun2='"+gubun2+"' "; 
		}				
		
		query = "SELECT TO_NUMBER('"+s_year+"')-1||'12' as dt, TO_NUMBER('"+s_year+"')-1||'1231' as est_dt, 0 est_amt, 0 amt1, 0 amt2, 0 amt3, 0 amt4, 0 amt4_1, 0 amt4_2, SUM(rest_amt) rest_amt \r\n" + 
				"FROM   (SELECT rent_mng_id, rent_l_cd, rent_st, gubun2, min(DECODE(substr(est_dt,1,6),substr(rc_dt,1,6),rest_amt)) rest_amt \r\n" + 
				"        FROM   scd_pp_cost \r\n" + 
				"        where  est_dt<=TO_NUMBER('"+s_year+"')-1||'1231' and use_yn='Y' \r\n" + s_query + 
				"        GROUP BY rent_mng_id, rent_l_cd, rent_st, gubun2\r\n" + 
				"       )\r\n" + 
				"UNION all\r\n" + 
				"SELECT SUBSTR(est_dt,1,6) as dt, SUBSTR(est_dt,1,6)||to_char(last_day(to_date(substr(est_dt,1,6),'YYYYMM')),'DD') as est_dt, \r\n" + 
				"       SUM(DECODE(tm,'0',0,'99',0,est_amt)) est_amt, \r\n" + 
				"       SUM(DECODE(tm,'0',DECODE(SUBSTR(gubun,1,4),'�°��̰�',0,rest_amt),0)) amt1, \r\n" + 
				"       SUM(DECODE(tm,'0',0,'99',0,rc_amt)) amt2, \r\n" + 
				"       SUM(DECODE(tm,'99',rc_amt,0)) amt3, \r\n" + 
				"       SUM(DECODE(tm,'0',DECODE(SUBSTR(gubun,1,4),'�°��̰�',0,rest_amt),0))-SUM(DECODE(tm,'0',0,'99',0,rc_amt))-SUM(DECODE(tm,'99',rc_amt,0)) amt4, \r\n" + 
				"       SUM(DECODE(tm,'0',DECODE(SUBSTR(gubun,1,4),'�°��̰�',0,DECODE(car_use,1,rest_amt)),0))-SUM(DECODE(tm,'0',0,'99',0,DECODE(car_use,1,rc_amt)))-SUM(DECODE(tm,'99',DECODE(car_use,1,rc_amt),0)) amt4_1,\r\n" + 
				"       SUM(DECODE(tm,'0',DECODE(SUBSTR(gubun,1,4),'�°��̰�',0,DECODE(car_use,1,0,rest_amt)),0))-SUM(DECODE(tm,'0',0,'99',0,DECODE(car_use,1,0,rc_amt)))-SUM(DECODE(tm,'99',DECODE(car_use,1,0,rc_amt),0)) amt4_2,\r\n" + 
				"       0 rest_amt\r\n" + 
				"FROM   scd_pp_cost\r\n" + 
				"where  est_dt LIKE '"+s_year+"'||'%' AND use_yn='Y' \r\n" + s_query +
				"GROUP BY SUBSTR(est_dt,1,6)\r\n" + 
				"ORDER BY 1";
		
											
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
			System.out.println("[AddExtDatabase:getScdPpCostMonStat]\n"+e);
			System.out.println("[AddExtDatabase:getScdPpCostMonStat]\n"+query);
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
	
	
	// ���͹ݿ������� 
	public long getScdPpCostMonStatChkAmt(String s_year, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		long amt = 0;
		String query = "";
		String s_query = "";
		
		if(!gubun2.equals("")) {
			s_query += " and gubun2='"+gubun2+"' ";
		}				
		
		query = "SELECT nvl(SUM(rest_amt),0) rest_amt \r\n" + 
				"FROM   (SELECT rent_mng_id, rent_l_cd, rent_st, gubun2, min(DECODE(substr(est_dt,1,6),substr(rc_dt,1,6),rest_amt)) rest_amt \r\n" + 
				"        FROM   scd_pp_cost \r\n" + 
				"        where  est_dt<='"+s_year+"' and use_yn='Y' \r\n" + s_query + 
				"        GROUP BY rent_mng_id, rent_l_cd, rent_st, gubun2\r\n" + 
				"       )\r\n" + 
				"";
		
											
		try {
			pstmt = conn.prepareStatement(query);	    
	    	rs = pstmt.executeQuery();	    	    	
			if(rs.next())
			{		
				amt = rs.getLong(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddExtDatabase:getScdPpCostMonStatChkAmt]\n"+e);
			System.out.println("[AddExtDatabase:getScdPpCostMonStatChkAmt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return amt;
		}
	}	
	
	// ����������  - �����ݰ��� ����Ʈ 
	public Vector getScdPpCostDayStat(String s_kd, String t_wd, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		
		query =	"SELECT a.rent_mng_id, a.rent_l_cd, a.rent_st, a.gubun2, a.est_amt, a.rc_amt, decode('"+s_kd+"','1',a.est_amt,a.rc_amt) amt, d.firm_nm, d.client_nm, e.car_no, \r\n" + 
				"       decode(d.client_st,'2',substr(text_decrypt(d.ssn, 'pw'),1,6),d.enp_no) enp_no \r\n" + 
				"FROM   scd_pp_cost a, cont c, client d, car_reg e, fee b \r\n" + 
				"WHERE  a.est_dt like substr(replace('"+t_wd+"','-',''),1,6)||'%' and a.use_yn='Y' and decode('"+s_kd+"','1',a.est_amt,a.rc_amt) <> 0 and a.tm not in ('0','99')  \r\n" + 
				"       AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd\r\n" + 
				"       AND c.client_id=d.client_id\r\n" + 
				"       AND c.car_mng_id=e.car_mng_id\r\n" + 
				"       AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st \r\n";
		
		//query += " and nvl(b.pp_chk,'1')<>'0' ";
		
		if(!gubun2.equals("")) {
			query += " and nvl(a.gubun2,'1')='"+gubun2+"' ";
		}			
		
		query+=	"order by decode(a.gubun,'����',1,2), decode(a.tm,'1',1,2), b.rent_start_dt ";
											
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
			System.out.println("[AddExtDatabase:getScdPpCostDayStat]\n"+e);
			System.out.println("[AddExtDatabase:getScdPpCostDayStat]\n"+query);
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
	
	// �������͹ݿ��ݾ�  
	public Vector getScdPpCostAccountStat(String est_dt, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	 	
		 
		query =	"SELECT decode(a.car_use,'1','��Ʈ','����') car_use,\r\n" + 
				"       SUM(DECODE(a.tm,'0',decode(SUBSTR(gubun,1,4),'�°��̰�',0,a.rest_amt))) amt1,\r\n" + 
				"       SUM(DECODE(a.tm,'0',0,'99',0,a.rc_amt)) amt2,\r\n" + 
				"       SUM(DECODE(a.tm,'99',a.rc_amt)) amt3\r\n" + 
				"FROM  scd_pp_cost a \r\n" + 
				"WHERE a.est_dt LIKE substr(replace('"+est_dt+"','-',''),1,6)||'%' AND a.use_yn='Y' \r\n" ;
		
		
		if(!gubun2.equals("")) {
			query += " and nvl(a.gubun2,'1')='"+gubun2+"' ";
		}		
		
		query+=	"GROUP BY a.car_use ";
											
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
			System.out.println("[AddExtDatabase:getScdPpCostAccountStat]\n"+e);
			System.out.println("[AddExtDatabase:getScdPpCostAccountStat]\n"+query);
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
	
	public boolean updateScdPpCost(Vector vt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		query = " update scd_pp_cost set est_amt=?, rc_amt=?, sum_amt=?, rest_amt=? where RENT_MNG_ID=? and RENT_L_CD=? and RENT_ST=? and tm=? and gubun2=? ";
		try 
		{
			conn.setAutoCommit(false);
			for(int i = 0 ; i < vt.size() ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				pstmt = conn.prepareStatement(query);
				pstmt.setInt   (1,  AddUtil.parseDigit(String.valueOf(ht.get("EST_AMT"))));
				pstmt.setInt   (2,  AddUtil.parseDigit(String.valueOf(ht.get("RC_AMT"))));
				pstmt.setInt   (3,  AddUtil.parseDigit(String.valueOf(ht.get("SUM_AMT"))));
				pstmt.setInt   (4,  AddUtil.parseDigit(String.valueOf(ht.get("REST_AMT"))));
				pstmt.setString(5,  String.valueOf(ht.get("RENT_MNG_ID")));
				pstmt.setString(6,  String.valueOf(ht.get("RENT_L_CD")));
				pstmt.setString(7,  String.valueOf(ht.get("RENT_ST")));
				pstmt.setString(8,  String.valueOf(ht.get("TM")));
				pstmt.setString(9,  String.valueOf(ht.get("GUBUN2")));
			    pstmt.executeUpdate();							
			}	
			pstmt.close();	
			conn.commit();
	  	} catch (Exception e) {
		  	System.out.println("[AddExtDatabase:updateScdPpCost]\n"+e);
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
