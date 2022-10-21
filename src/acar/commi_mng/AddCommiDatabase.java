package acar.commi_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.daily_sch.*;
import acar.account.*;
import acar.car_office.*;


public class AddCommiDatabase
{
	private Connection conn = null;
	public static AddCommiDatabase db;
	
	public static AddCommiDatabase getInstance()
	{
		if(AddCommiDatabase.db == null)
			AddCommiDatabase.db = new AddCommiDatabase();
		return AddCommiDatabase.db;
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
	

	//������Ȳ-----------------------------------------------------------------------------------------------


	//���޼����� ���� ����Ʈ ��ȸ : commi_sc_in.jsp
	public Vector getCommiList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String est_dt = "a.sup_dt";

		query = " select /*+  merge(b) */ "+
				"        b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.use_yn, b.firm_nm, b.dlv_dt, cr.car_no, cr.car_nm, cn.car_name,"+
				"        e.nm com_nm, d.car_off_nm, c.emp_nm, a.emp_id, a.emp_acc_nm, a.rec_ssn, a.rec_addr, "+
				"        (a.commi + decode(a.add_st1,'1',nvl(a.add_amt1,0),0) + decode(a.add_st2,'1',nvl(a.add_amt2,0),0) + decode(a.add_st3,'1',nvl(a.add_amt3,0),0)  +nvl(a.dlv_con_commi,0) +nvl(a.dlv_tns_commi,0)+nvl(a.agent_commi,0)   ) as commi, "+
				"        (a.inc_amt+a.res_amt+nvl(a.vat_amt,0)) as commi_fee, a.dif_amt,"+
				"        DECODE(a.sup_dt,'','',SUBSTR(a.sup_dt,1,4)||'-'||SUBSTR(a.sup_dt,5,2)||'-'||SUBSTR(a.sup_dt,7,2)) as sup_dt,"+
				"        decode(a.commi_st,'2','�븮��','�������') commi_st, "+
				"        nvl(c.emp_ssn, decode(c.emp_nm,a.emp_acc_nm,a.rec_ssn)) emp_ssn, "+
				"        nvl(c.emp_addr, decode(c.emp_nm,a.emp_acc_nm,a.rec_addr)) emp_addr, "+
				"        a.inc_amt, a.res_amt, a.vat_amt "+
				" from   commi a, cont_n_view b, car_off_emp c, car_off d, code e,  car_reg cr,  car_etc g, car_nm cn \n"+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	     and b.car_mng_id = cr.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	     and g.car_id=cn.car_id(+) and g.car_seq=cn.car_seq(+)  \n"+
				"        and a.emp_id=c.emp_id"+
				"        and c.car_off_id=d.car_off_id"+
				"        and d.car_comp_id=e.code "+
				"	     and e.c_st='0001' and e.code<>'0000' and a.agnt_st<>'2'";

		//��õ¡��
		if(gubun1.equals("1"))			query += " and a.inc_amt > 0 ";
		//���ݰ�꼭
		else if(gubun1.equals("2"))		query += " and a.vat_amt > 0 ";

//		if(gubun1.equals("1"))			query += " and a.commi > 0 ";
//		else if(gubun1.equals("2"))		query += " and a.dlv_con_commi > 0 ";
//		else if(gubun1.equals("3"))		query += " and a.dlv_tns_commi > 0 ";
//		else if(gubun1.equals("4"))		query += " and decode(a.agnt_st,'1',a.agent_commi,'4',a.commi) > 0 ";

		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt = to_char(sysdate,'YYYYMMDD')";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is null";
		//�˻�-����
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.sup_dt is not null";
		//�˻�-�̼���
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.sup_dt is null";
		//����
		}else if(gubun2.equals("6")){						query += " and "+est_dt+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' ";
		}
	
		if(!gubun4.equals(""))		query += " and d.car_comp_id='"+gubun4+"'";
		
		/*�˻�����*/
			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("8"))	query += " and b.bus_id2='"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(b.dlv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(c.car_off_id, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and nvl(c.emp_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("13"))	query += " and nvl(a.emp_acc_nm, '') like '%"+t_wd+"%'\n";

		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.sup_dt "+sort+", b.dlv_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, e.nm "+sort+", d.car_off_nm, c.emp_nm";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, d.car_off_nm "+sort+", e.nm, c.emp_nm";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, b.dlv_dt "+sort+", b.firm_nm";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm";		
		
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
			System.out.println("[AddCommiDatabase:getCommiList]"+ e);
			System.out.println("[AddCommiDatabase:getCommiList]"+ query);
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
	
	//���޼����� ���� ����Ʈ ��ȸ :  ��õ¡�������� - ���ݰ�꼭����� ����
	public Vector getCommiList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String user_id, String emp_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String est_dt = "a.sup_dt";

		query = " select /*+  merge(b) */ "+
				"        b.rent_mng_id, b.rent_l_cd, b.fee_rent_st, b.car_mng_id, b.use_yn, b.firm_nm, b.dlv_dt, cr.car_no, cr.car_nm, cn.car_name,"+
				"        e.nm com_nm, d.car_off_nm, c.emp_nm, a.emp_id, a.emp_acc_nm, a.rec_ssn, a.rec_addr, "+
				"        (a.commi + decode(a.add_st1,'1',nvl(a.add_amt1,0),0) + decode(a.add_st2,'1',nvl(a.add_amt2,0),0) + decode(a.add_st3,'1',nvl(a.add_amt3,0),0)  +nvl(a.dlv_con_commi,0) +nvl(a.dlv_tns_commi,0)  + nvl(a.agent_commi,0)   ) as commi, "+
				"        (a.inc_amt+a.res_amt) as commi_fee, a.dif_amt, a.inc_amt, a.res_amt, "+
				"        DECODE(a.sup_dt,'','',SUBSTR(a.sup_dt,1,4)||'-'||SUBSTR(a.sup_dt,5,2)||'-'||SUBSTR(a.sup_dt,7,2)) as sup_dt,"+
				"        decode(a.sup_dt, '', '', SUBSTR(a.sup_dt,1,4))  sup_dt_y,  decode(a.sup_dt, '', '', SUBSTR(a.sup_dt,5,2))  sup_dt_m,  decode(a.sup_dt, '', '', SUBSTR(a.sup_dt,7,2)) sup_dt_d,"+
				"        decode(a.commi_st,'2','�븮��','�������') commi_st, "+
				"        nvl(c.emp_ssn, decode(c.emp_nm,a.emp_acc_nm,a.rec_ssn)) emp_ssn, "+
				"        nvl(c.emp_addr, decode(c.emp_nm,a.emp_acc_nm,a.rec_addr)) emp_addr, "+
				"        a.inc_amt, a.res_amt , b.rent_start_dt, b.rent_end_dt , a.tot_per "+
				" from   commi a, cont_n_view b, car_off_emp c, car_off d, code e,  car_reg cr,  car_etc g, car_nm cn \n"+
				" where  "+
//				"        nvl(a.vat_amt,0)=0 and 
		        "        a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	     and b.car_mng_id = cr.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	     and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  \n"+
				"        and a.emp_id=c.emp_id"+
				"        and c.car_off_id=d.car_off_id"+
				"        and d.car_comp_id=e.code "+
				"	     and e.c_st='0001' and e.code<>'0000' and a.agnt_st<>'2'" +
				"        and  c.emp_id = '" + emp_id + "' "  ;

		//��õ¡��
		if(gubun1.equals("1"))			query += " and a.inc_amt > 0 ";
		//���ݰ�꼭
		else if(gubun1.equals("2"))		query += " and a.vat_amt > 0 ";

//		if(gubun1.equals("1"))			query += " and a.commi > 0 ";
//		else if(gubun1.equals("2"))		query += " and a.dlv_con_commi > 0 ";
//		else if(gubun1.equals("3"))		query += " and a.dlv_tns_commi > 0 ";
//		else if(gubun1.equals("9"))		query += " and  c.emp_id =   '" + emp_id + "'";    //��õ¡��
		

		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt = to_char(sysdate,'YYYYMMDD')";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is null";
		//�˻�-����
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.sup_dt is not null";
		//�˻�-�̼���
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.sup_dt is null";
		}
	
		if(!gubun4.equals(""))		query += " and d.car_comp_id='"+gubun4+"'";
		
		/*�˻�����*/
			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("8"))	query += " and b.bus_id2='"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(b.dlv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(c.car_off_id, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and nvl(c.emp_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("13"))	query += " and nvl(a.emp_acc_nm, '') like '%"+t_wd+"%'\n";

		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.sup_dt "+sort+", b.dlv_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, e.nm "+sort+", d.car_off_nm, c.emp_nm";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, d.car_off_nm "+sort+", e.nm, c.emp_nm";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, b.dlv_dt "+sort+", b.firm_nm";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm";		
		else if(sort_gubun.equals("9"))	query += " order by a.sup_dt "+sort+", b.dlv_dt, b.firm_nm";
		else if(sort_gubun.equals("6"))	query += " order by b.use_yn desc, b.rent_end_dt "+sort+", b.firm_nm";
		
	//		System.out.println("[AddCommiDatabase:getCommiList]"+ query);
				
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
			System.out.println("[AddCommiDatabase:getCommiList]"+ e);
			System.out.println("[AddCommiDatabase:getCommiList]"+ query);
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

	//���޼����� ���� ����Ʈ ��ȸ : con_ins_sc_in.jsp
	public Vector getCommiList2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String est_dt = "a.sup_dt";

		query = " select /*+  merge(b) */ "+
				"        b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.use_yn, nvl(b.firm_nm,b.client_nm) firm_nm, b.dlv_dt, cr.car_no, cr.car_nm, cn.car_name,"+
				"        e.nm com_nm, d.car_off_nm, c.emp_nm, a.emp_id, "+
				"        (a.commi + decode(a.add_st1,'1',nvl(a.add_amt1,0),0) + decode(a.add_st2,'1',nvl(a.add_amt2,0),0) + decode(a.add_st3,'1',nvl(a.add_amt3,0),0) ) as commi, "+
				"        (a.inc_amt+a.res_amt) as commi_fee, a.dif_amt,"+
				"        DECODE(a.sup_dt,'','',SUBSTR(a.sup_dt,1,4)||'-'||SUBSTR(a.sup_dt,5,2)||'-'||SUBSTR(a.sup_dt,7,2)) as sup_dt,"+
				"        decode(a.commi_st,'2','�븮��','�������') commi_st, "+
				"        nvl(c.emp_ssn, decode(c.emp_nm,a.emp_acc_nm,a.rec_ssn)) emp_ssn, "+
				"        nvl(c.emp_addr, decode(c.emp_nm,a.emp_acc_nm,a.rec_addr)) emp_addr, "+
				"        a.inc_amt, a.res_amt,"+
				"        decode(h.car_cs_amt,0,0,(h.car_cs_amt+h.car_cv_amt+h.opt_cs_amt+h.opt_cv_amt+h.clr_cs_amt+h.clr_cv_amt-h.dc_cs_amt-h.dc_cv_amt - nvl(h.tax_dc_s_amt,0) - nvl(h.tax_dc_v_amt,0))) car_amt,"+
				"        decode(a.commi+h.car_cs_amt,0,0,trunc((a.commi/(h.car_cs_amt+h.car_cv_amt+h.opt_cs_amt+h.opt_cv_amt+h.clr_cs_amt+h.clr_cv_amt-h.dc_cs_amt-h.dc_cv_amt - nvl(h.tax_dc_s_amt,0) - nvl(h.tax_dc_v_amt,0))*100),1)) comm_rt,"+
				"        decode(a.commi+a.inc_amt,0,0,trunc((round((a.inc_amt+a.res_amt)/(a.commi + decode(a.add_st1,'1',nvl(a.add_amt1,0),0) + decode(a.add_st2,'1',nvl(a.add_amt2,0),0) + decode(a.add_st3,'1',nvl(a.add_amt3,0),0) ),3)*100),1)) tax_rt"+
				" from   commi a, cont_n_view b, car_off_emp c, car_off d, code e, car_etc h, car_reg cr , car_nm cn  "+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and a.emp_id=c.emp_id"+
				"        and c.car_off_id=d.car_off_id"+
				"        and b.car_mng_id = cr.car_mng_id and  b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd"+
				"	and h.car_id=cn.car_id(+)  and   h.car_seq=cn.car_seq(+)  \n"+                       		
				"        and d.car_comp_id=e.code "+
				"        and e.c_st='0001' and e.code<>'0000' and a.agnt_st<>'2'";

		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt = to_char(sysdate,'YYYYMMDD')";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is null";
		//�˻�-����
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.sup_dt is not null";
		//�˻�-�̼���
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.sup_dt is null";
		}
	
		if(!gubun4.equals(""))		query += " and d.car_comp_id='"+gubun4+"'";
		
		/*�˻�����*/
			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("8"))	query += " and b.bus_id2='"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(b.dlv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(c.car_off_id, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and nvl(c.emp_nm, '') like '%"+t_wd+"%'\n";

		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.sup_dt "+sort+", b.dlv_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, e.nm "+sort+", d.car_off_nm, c.emp_nm";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, d.car_off_nm "+sort+", e.nm, c.emp_nm";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, b.dlv_dt "+sort+", b.firm_nm";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm";		
		
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
			System.out.println("[AddCommiDatabase:getCommiList2]"+ e);
			System.out.println("[AddCommiDatabase:getCommiList2]"+ query);
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

	//���޼����� ���� �˻���� ��ȸ : con_ins_sc.jsp
	public Vector getCommiStat(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String est_dt = "b.dlv_dt";

		sub_query = " select /*+  merge(b) */ "+
					"        b.rent_mng_id, b.rent_l_cd, b.use_yn, b.firm_nm,  b.dlv_dt, cr.car_no, cr.car_nm,"+
					"        e.nm as com_nm, d.car_off_nm, c.emp_nm, a.emp_id, "+
					"        (a.commi + nvl(a.add_amt1,0) + nvl(a.add_amt2,0)+ nvl(a.add_amt3,0) ) as commi, (a.inc_amt+a.res_amt) as commi_fee, a.dif_amt,"+
					"        DECODE(a.sup_dt,'','',SUBSTR(a.sup_dt,1,4)||'-'||SUBSTR(a.sup_dt,5,2)||'-'||SUBSTR(a.sup_dt,7,2)) as sup_dt"+
					" from   commi a, cont_n_view b, car_off_emp c, car_off d, code e , car_reg cr \n"+
					" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id = cr.car_mng_id "+
					"        and a.emp_id=c.emp_id"+
					"        and c.car_off_id=d.car_off_id"+
					"        and d.car_comp_id=e.code"+
					"        and e.c_st='0001' and e.code<>'0000'"+
					"";

		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		sub_query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	sub_query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	sub_query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	sub_query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	sub_query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt = to_char(sysdate,'YYYYMMDD')";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	sub_query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	sub_query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	sub_query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	sub_query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is null";
		//�˻�-����
		}else if(gubun2.equals("5") && gubun3.equals("2")){	sub_query += " and a.sup_dt is not null";
		//�˻�-�̼���
		}else if(gubun2.equals("5") && gubun3.equals("3")){	sub_query += " and a.sup_dt is null";
		}
	
		if(!gubun4.equals(""))		sub_query += " and d.car_comp_id='"+gubun4+"'";
		
		if(!br_id.equals("S1") || !br_id.equals(""))		sub_query += " and nvl(b.brch_id, '')='"+br_id+"'";

		/*�˻�����*/
			
		if(s_kd.equals("1"))		sub_query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	sub_query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	sub_query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	sub_query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	sub_query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	sub_query += " and nvl(cr.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	sub_query += " and nvl(b.dlv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	sub_query += " and nvl(c.car_off_id, '') like '%"+t_wd+"%'\n";

		String query = "";
		query = " select '��ȹ' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where substr(ins_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) c\n"+
				" union all\n"+
				" select '����' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where substr(ins_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) c\n"+
				" union all\n"+
				" select '������' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where substr(ins_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt is null ) c\n"+
				" union all\n"+
				" select '����' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where substr(ins_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(pay_amt),0) tot_amt1 from ("+sub_query+") where substr(ins_est_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and pay_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(pay_amt),0) tot_amt2 from ("+sub_query+") where ins_est_dt = to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (pay_dt is null or pay_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(pay_amt),0) tot_amt3 from ("+sub_query+") where ins_est_dt < to_char(SYSDATE, 'YYYY-MM-DD') and pay_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) c";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{
				IncomingBean fee = new IncomingBean();
				fee.setGubun(rs.getString(1));
				fee.setGubun_sub(rs.getString(2));
				fee.setTot_su1(rs.getInt(3));
				fee.setTot_amt1(rs.getInt(4));
				fee.setTot_su2(rs.getInt(5));
				fee.setTot_amt2(rs.getInt(6));
				fee.setTot_su3(rs.getInt(7));
				fee.setTot_amt3(rs.getInt(8));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddCommiDatabase:getCommiStat]"+ e);
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
	 * ����� ���޼����� ����Ʈ
	 */
	public Vector getCommis(String emp_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " select /*+  merge(b) */ "+
				"        b.brch_id, a.RENT_MNG_ID, a.RENT_L_CD, a.EMP_ID, a.AGNT_ST, "+
				"        a.commi, a.add_amt1, a.add_amt2, a.add_amt3, a.add_st1, a.add_st2, a.add_st3, a.INC_AMT, a.RES_AMT, a.TOT_AMT, a.DIF_AMT, a.REL REL,"+
				"        decode(a.SUP_DT, '', '', substr(a.SUP_DT, 1, 4)||'-'||substr(a.SUP_DT, 5, 2)||'-'||substr(a.SUP_DT, 7, 2)) SUP_DT,"+
				"        b.firm_nm, c.car_nm, cn.car_name, c.car_no, b.dlv_dt,"+
				"        decode(a.commi_st,'2','�븮��','�������') commi_st, l.doc_no, a.dlv_con_commi, a.dlv_tns_commi, a.agent_commi "+
				" from   COMMI a, cont_n_view b, (select * from doc_settle where doc_st='1') l , car_reg c,  car_etc g, car_nm cn \n"+
				" where  a.EMP_ID = '"+emp_id+"' "+
				"        and a.agnt_st<>'2'"+
				"        and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd"+
				"        and a.rent_l_cd=l.doc_id(+)"+
				"	     and b.car_mng_id = c.car_mng_id and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	     and g.car_id=cn.car_id(+) and g.car_seq=cn.car_seq(+) \n"+
				" order by b.dlv_dt";
						
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				CommiBean commi = new CommiBean();
				commi.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				commi.setEmp_id(rs.getString("EMP_ID")==null?"":rs.getString("EMP_ID"));
				commi.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				commi.setAgnt_st(rs.getString("AGNT_ST")==null?"":rs.getString("AGNT_ST"));
				commi.setCommi(rs.getInt("COMMI"));
				commi.setInc_amt(rs.getInt("INC_AMT"));
				commi.setRes_amt(rs.getInt("RES_AMT"));
				commi.setTot_amt(rs.getInt("TOT_AMT"));
				commi.setDif_amt(rs.getInt("DIF_AMT"));
				commi.setSup_dt(rs.getString("SUP_DT")==null?"":rs.getString("SUP_DT"));
				commi.setRel(rs.getString("REL")==null?"":rs.getString("REL"));
				commi.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				commi.setDlv_dt(rs.getString("DLV_DT")==null?"":rs.getString("DLV_DT"));
				commi.setCar_name(rs.getString("CAR_NAME")==null?"":rs.getString("CAR_NAME"));
				commi.setCar_nm(rs.getString("CAR_NM")==null?"":rs.getString("CAR_NM"));
				commi.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO"));
				commi.setCommi_st(rs.getString("COMMI_ST")==null?"":rs.getString("COMMI_ST"));
				commi.setBrch_id(rs.getString("BRCH_ID")==null?"":rs.getString("BRCH_ID"));
				commi.setDoc_no(rs.getString("doc_no")==null?"":rs.getString("doc_no"));
				commi.setAdd_amt1(rs.getInt("add_amt1"));
				commi.setAdd_amt2(rs.getInt("add_amt2"));
				commi.setAdd_amt3(rs.getInt("add_amt3"));
				commi.setAdd_st1(rs.getString("add_st1")==null?"":rs.getString("add_st1"));
				commi.setAdd_st2(rs.getString("add_st2")==null?"":rs.getString("add_st2"));
				commi.setAdd_st3(rs.getString("add_st3")==null?"":rs.getString("add_st3"));
				commi.setDlv_con_commi(rs.getInt("dlv_con_commi"));
				commi.setDlv_tns_commi(rs.getInt("dlv_tns_commi"));
				commi.setAgent_commi(rs.getInt("agent_commi"));


				vt.add(commi);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
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
	 * �������
	 */
	public CarOffEmpBean getEmp(String m_id, String l_cd, String emp_id)
	{
		getConnection();

		CarOffEmpBean bean = new CarOffEmpBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		query = " SELECT E.EMP_ID, E.CAR_OFF_ID, O.CAR_OFF_NM, O.CAR_OFF_ST, O.OWNER_NM, O.CAR_OFF_TEL,"+
				" O.CAR_COMP_ID, C.nm CAR_COMP_NM, E.CUST_ST, E.EMP_NM, E.EMP_SSN, "+
				" E.EMP_M_TEL, E.EMP_POS, E.EMP_EMAIL, E.EMP_BANK, E.EMP_ACC_NO, E.EMP_ACC_NM, E.EMP_POST, E.EMP_ADDR"+
				" FROM CAR_OFF_EMP E, CAR_OFF O, CODE C, COMMI M"+
				" WHERE E.car_off_id = O.car_off_id AND"+
		  		" O.car_comp_id = C.CODE AND"+
				" C.c_st='0001' AND C.CODE <> '0000' AND"+
				" E.emp_id = M.emp_id and M.rent_mng_id='"+m_id+"' and M.rent_l_cd='"+l_cd+"' and M.agnt_st='1'";
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
			    bean.setEmp_id(rs.getString("EMP_ID"));						//�������ID
			    bean.setCar_off_id(rs.getString("CAR_OFF_ID"));				//������ID
			    bean.setCar_off_nm(rs.getString("CAR_OFF_NM"));				//�����Ҹ�Ī
			    bean.setCar_off_st(rs.getString("CAR_OFF_ST"));				//�����ұ���
	   		    bean.setOwner_nm(rs.getString("OWNER_NM"));					//������
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));			//�ڵ���ȸ��ID
			    bean.setCar_comp_nm(rs.getString("CAR_COMP_NM"));			//�ڵ���ȸ�� ��Ī
			    bean.setCar_off_tel(rs.getString("CAR_OFF_TEL"));			//�繫����ȭ
//	    		bean.setCar_off_fax(rs.getString("CAR_OFF_FAX"));			//�ѽ�
				bean.setCust_st(rs.getString("CUST_ST"));					//������
			    bean.setEmp_nm(rs.getString("EMP_NM"));						//����
			    bean.setEmp_ssn(rs.getString("EMP_SSN"));					//�ֹε�Ϲ�ȣ
			    bean.setEmp_m_tel(rs.getString("EMP_M_TEL"));				//�ڵ���
			    bean.setEmp_pos(rs.getString("EMP_POS"));					//����
				bean.setEmp_email(rs.getString("EMP_EMAIL"));				//�̸���
			    bean.setEmp_bank(rs.getString("EMP_BANK"));					//����
			    bean.setEmp_acc_no(rs.getString("EMP_ACC_NO"));				//���¹�ȣ
			    bean.setEmp_acc_nm(rs.getString("EMP_ACC_NM"));				//������
				bean.setEmp_post(rs.getString("EMP_POST"));
			    bean.setEmp_addr(rs.getString("EMP_ADDR"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
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

	//����� : ���޼�����-�ڵ���������� ���� (commi)
	public boolean insertCommi(CommiBean commi)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " insert into COMMI (RENT_MNG_ID, EMP_ID, RENT_L_CD, AGNT_ST, COMMI, INC_AMT,"+
						" RES_AMT, TOT_AMT, DIF_AMT, SUP_DT, REL, COMMI_ST) values"+
						"(?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?)";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, commi.getRent_mng_id());
			pstmt.setString(2, commi.getEmp_id());
			pstmt.setString(3, commi.getRent_l_cd());
			pstmt.setString(4, commi.getAgnt_st());
			pstmt.setInt   (5, commi.getCommi());
			pstmt.setInt   (6, commi.getInc_amt());
			pstmt.setInt   (7, commi.getRes_amt());
			pstmt.setInt   (8, commi.getTot_amt());
			pstmt.setInt   (9, commi.getDif_amt());
			pstmt.setString(10, commi.getSup_dt());
			pstmt.setString(11, commi.getRel());
			pstmt.setString(12, commi.getCommi_st());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	}
	  	catch(Exception e)
	  	{
			System.out.println("[AddCommiDatabase:insertCommi]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//���޼����� ���� ����Ʈ ��ȸ : con_ins_sc_in.jsp
	public Vector getCommiListPl(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String est_dt = "a.sup_dt";

		query = " select \n"+
				"        nvl(a.emp_acc_nm,c.emp_nm) as emp_nm, nvl(a.rec_ssn,c.emp_ssn) as emp_ssn, nvl(a.rec_addr,c.emp_addr) as emp_addr,"+//20091103 : �Ǽ��������� ���� 
				"        '940911' biz_code, \n"+
				"        (a.commi + decode(a.add_st1,'1',nvl(a.add_amt1,0),0) + decode(a.add_st2,'1',nvl(a.add_amt2,0),0) + decode(a.add_st3,'1',nvl(a.add_amt3,0),0)  + nvl(dlv_con_commi,0) +nvl(dlv_tns_commi,0) +nvl(agent_commi,0)   ) as commi, \n"+
				"        a.inc_amt, a.res_amt, \n"+
				"        decode(a.tot_per,'',decode(a.commi+a.inc_amt,0,0,trunc((round((a.inc_amt+a.res_amt)/(a.commi + decode(a.add_st1,'1',nvl(a.add_amt1,0),0) + decode(a.add_st2,'1',nvl(a.add_amt2,0),0) + decode(a.add_st3,'1',nvl(a.add_amt3,0),0) + nvl(dlv_con_commi,0) +nvl(dlv_tns_commi,0)+nvl(agent_commi,0)    ),3)*100),1)),a.tot_per) tax_rt, \n"+
				"        a.sup_dt \n"+
				" from   commi a, cont b, car_off_emp c, car_off d \n"+
				" where  a.agnt_st<>'2' \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.emp_id=c.emp_id \n"+
				"        and c.car_off_id=d.car_off_id";

		//20131101 ��õ¡���θ�, ���ݰ�꼭������� ����
		query += " and a.vat_amt = 0 ";

		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt = to_char(sysdate,'YYYYMMDD')";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is null";
		//�˻�-����
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.sup_dt is not null";
		//�˻�-�̼���
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.sup_dt is null";
		//����
		}else if(gubun2.equals("6")){						query += " and "+est_dt+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' ";
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddCommiDatabase:getCommiListPl]"+ e);
			System.out.println("[AddCommiDatabase:getCommiListPl]"+ query2);
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

	//�Ǽ����� ����Ʈ
	public Vector getEmpAccList(String  emp_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT emp_acc_nm FROM COMMI WHERE emp_id='"+emp_id + "' AND sup_dt IS NOT NULL GROUP BY emp_acc_nm";


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
			System.out.println("[AddCommiDatabase:getEmpAccList]"+ e);
			System.out.println("[AddCommiDatabase:getEmpAccList]"+ query);
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
	
	
	  //�Ǽ����� ����Ʈ ����
	public Hashtable  getEmpAccNm(String emp_id, String emp_acc_nm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";	
		
		query = " select substr(replace(a.rec_ssn, '-', ''), 0, 6) rec_ssn1, substr(replace(a.rec_ssn, '-', ''), 7) rec_ssn2, replace(a.rec_ssn, '-', '')  rec_ssn, a.rec_addr  from commi a where a.emp_id =  '"+emp_id+"' and a.emp_acc_nm = '"+ emp_acc_nm + "'  and rownum < 2   order by  a.sup_dt desc  "; 
			 		
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
			System.out.println("[AddCommiDatabase:getEmpAccNm]\n"+e);			
			System.out.println("[AddCommiDatabase:getEmpAccNm]\n"+query);			
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
	
	//������Ʈ�������
	public Vector getCommiAgentList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String est_dt = "a.sup_dt";

		//String est_dt = "replace(b.rent_start_dt,'-','')";

		query = " select /*+  merge(b) */ "+
				"        b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.use_yn, b.firm_nm, b.dlv_dt, cr.car_no, cr.car_nm, cn.car_name,"+
				"        e.nm com_nm, d.car_off_nm, c.emp_nm, a.emp_id, a.emp_acc_nm, a.rec_ssn, a.rec_addr, "+
				"        (nvl(a.commi,0) + decode(a.add_st1,'1',nvl(a.add_amt1,0),0) + decode(a.add_st2,'1',nvl(a.add_amt2,0),0) + decode(a.add_st3,'1',nvl(a.add_amt3,0),0)  +nvl(a.dlv_con_commi,0) +nvl(a.dlv_tns_commi,0)+nvl(a.agent_commi,0)   ) as commi, "+
				"        (a.inc_amt+a.res_amt+nvl(a.vat_amt,0)) as commi_fee, a.dif_amt,"+
				"        DECODE(a.sup_dt,'','',SUBSTR(a.sup_dt,1,4)||'-'||SUBSTR(a.sup_dt,5,2)||'-'||SUBSTR(a.sup_dt,7,2)) as sup_dt,"+
				"        b.rent_start_dt, "+
				"        decode(a.commi_st,'2','�븮��','�������') commi_st, "+
				"        nvl(c.emp_ssn, decode(c.emp_nm,a.emp_acc_nm,a.rec_ssn)) emp_ssn, "+
				"        nvl(c.emp_addr, decode(c.emp_nm,a.emp_acc_nm,a.rec_addr)) emp_addr, "+
				"        a.inc_amt, a.res_amt, a.vat_amt, "+
				"        c.agent_id, d2.car_off_nm as agent_off_nm, decode(nvl(a.vat_amt,0),0,decode(a.inc_amt,0,decode(d2.doc_st,'1','��õ¡��','2','���ݰ�꼭'),'��õ¡��'),'���ݰ�꼭') doc_st_nm  "+
				" from   commi a, cont_n_view b, car_off_emp c, car_off d, code e,  car_reg cr,  car_etc g, car_nm cn, (select * from car_off where car_comp_id='1000') d2, (select * from users where dept_id='1000') f \n"+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	     and b.car_mng_id = cr.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	     and g.car_id=cn.car_id(+) and g.car_seq=cn.car_seq(+)  \n"+
				"        and a.emp_id=c.emp_id"+
				"        and c.car_off_id=d.car_off_id"+
				"        and d.car_comp_id=e.code "+
				"	     and e.c_st='0001' and e.code<>'0000' and a.agnt_st<>'2'"+
				"        and c.agent_id=d2.car_off_id "+
				"        and c.emp_id=f.sa_code and replace(b.rent_dt,'-','') >= f.enter_dt "+
				" ";

		/*����ȸ&&������ȸ*/

		//���
		if(gubun2.equals("1"))		query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//����
		else if(gubun2.equals("2"))	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD')";
		//�Ⱓ
		else if(gubun2.equals("4"))	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//����
		else if(gubun2.equals("6"))	query += " and "+est_dt+" like to_char(add_months(SYSDATE,-1), 'YYYYMM')||'%' ";
		
	
		/*�˻�����*/
		if(!t_wd.equals("")){	
			if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
			else if(s_kd.equals("2"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("3"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("4"))	query += " and nvl(b.rent_start_dt, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("5"))	query += " and d2.car_off_nm like '%"+t_wd+"%'\n";
			else if(s_kd.equals("6"))	query += " and nvl(c.emp_nm, '') like '%"+t_wd+"%'\n";

			else if(s_kd.equals("99"))	query += " and d2.car_off_nm like '%"+t_wd+"%'  \n";

		}

		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/
		if(sort_gubun.equals("2"))		query += " order by b.use_yn desc, a.sup_dt "+sort+", b.rent_start_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.rent_start_dt "+sort+", b.firm_nm";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, d2.car_off_nm "+sort+", c.emp_nm";
		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm";		
		
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
			System.out.println("[AddCommiDatabase:getCommiAgentList]"+ e);
			System.out.println("[AddCommiDatabase:getCommiAgentList]"+ query);
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
	

	//���޼����� ���� ����Ʈ ��ȸ : commi_sc_in.jsp  - agent - ���ݰ�꼭����� ���� 
	public Vector getCommiReceiptList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String user_id, String emp_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String est_dt = "a.sup_dt";

		query = " select /*+  merge(b) */ "+
				"        b.rent_mng_id, b.rent_l_cd, b.fee_rent_st, b.car_mng_id, b.use_yn, nvl(b.firm_nm,b.client_nm) firm_nm, b.dlv_dt, cr.car_no, cr.car_nm, " + // b.car_name,"+
				"        e.nm com_nm, d.car_off_nm, c.emp_nm, a.emp_id, a.emp_acc_nm, a.rec_ssn, a.rec_addr, "+
				"        (a.commi + decode(a.add_st1,'1',nvl(a.add_amt1,0),0) + decode(a.add_st2,'1',nvl(a.add_amt2,0),0) + decode(a.add_st3,'1',nvl(a.add_amt3,0),0)  +nvl(a.dlv_con_commi,0) +nvl(a.dlv_tns_commi,0) +  nvl(a.agent_commi,0)   ) as commi, "+
				"        (a.inc_amt+a.res_amt+nvl(a.vat_amt,0)) as commi_fee, a.dif_amt, a.inc_amt, a.res_amt, a.vat_amt, "+
				"        DECODE(a.sup_dt,'','',SUBSTR(a.sup_dt,1,4)||'-'||SUBSTR(a.sup_dt,5,2)||'-'||SUBSTR(a.sup_dt,7,2)) as sup_dt,"+
				"        decode(a.sup_dt, '', '', SUBSTR(a.sup_dt,1,4))  sup_dt_y,  decode(a.sup_dt, '', '', SUBSTR(a.sup_dt,5,2))  sup_dt_m,  decode(a.sup_dt, '', '', SUBSTR(a.sup_dt,7,2)) sup_dt_d,"+
				"        decode(a.commi_st,'2','�븮��','�������') commi_st, "+
				"        nvl(c.emp_ssn, decode(c.emp_nm,a.emp_acc_nm,a.rec_ssn)) emp_ssn, "+
				"        nvl(c.emp_addr, decode(c.emp_nm,a.emp_acc_nm,a.rec_addr)) emp_addr, "+
				"        a.inc_amt, a.res_amt , b.rent_start_dt, b.rent_end_dt , a.tot_per "+
				" from   commi a, cont_n_view b, car_off_emp c, car_off d, code e, car_reg cr  "+//car_nm f, car_mng g, , car_etc h
				" where  nvl(a.vat_amt,0)=0 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and a.emp_id=c.emp_id"+
				"        and c.car_off_id=d.car_off_id"+
				"        and d.car_comp_id=e.code "+
				"        and b.car_mng_id = cr.car_mng_id(+)  \n "+
				"	     and e.c_st='0001' and e.code<>'0000' and a.agnt_st<>'2'" +
				"        and  (  b.bus_id = '"+user_id + "'  or c.emp_id = '" + emp_id + "' ) "  ;

		if(gubun1.equals("1"))			query += " and a.commi > 0 ";
		else if(gubun1.equals("2"))		query += " and a.dlv_con_commi > 0 ";
		else if(gubun1.equals("3"))		query += " and a.dlv_tns_commi > 0 ";
		else if(gubun1.equals("9"))		query += " and  c.emp_id =   '" + emp_id + "'";    //��õ¡��
		

		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.sup_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt = to_char(sysdate,'YYYYMMDD')";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.sup_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+est_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.sup_dt is null";
		//�˻�-����
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.sup_dt is not null";
		//�˻�-�̼���
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.sup_dt is null";
		}
	
		if(!gubun4.equals(""))		query += " and d.car_comp_id='"+gubun4+"'";
		
		/*�˻�����*/
			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("8"))	query += " and b.bus_id2='"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(b.dlv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(c.car_off_id, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and nvl(c.emp_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("13"))	query += " and nvl(a.emp_acc_nm, '') like '%"+t_wd+"%'\n";
	
		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.sup_dt "+sort+", b.dlv_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, e.nm "+sort+", d.car_off_nm, c.emp_nm";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, d.car_off_nm "+sort+", e.nm, c.emp_nm";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, b.dlv_dt "+sort+", b.firm_nm";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm";		
		else if(sort_gubun.equals("9"))	query += " order by a.sup_dt "+sort+", b.dlv_dt, b.firm_nm";
		
	//		System.out.println("[AddCommiDatabase:getCommiList]"+ query);
				
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
			System.out.println("[AddCommiDatabase:getCommiReceiptList]"+ e);
			System.out.println("[AddCommiDatabase:getCommiReceiptList]"+ query);
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
	
	//������� ������� �󼼳��� ��� (20180620)
	public boolean insertCommiDeduct(String deduct_st, int deduct_num, String emp_id, String deduct_dt, int deduct_amt, String deduct_content, String rent_l_cd, String rent_m_id, String reg_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " insert into COMMI_DEDUCT (DEDUCT_ST, DEDUCT_NUM, EMP_ID, DEDUCT_DT, DEDUCT_AMT, DEDUCT_CONTENT, RENT_L_CD, RENT_MNG_ID, REG_ID, REG_DT) "+
					   " values(?, ?, ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'))";
		try 
		{	
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, deduct_st);
			pstmt.setInt   (2, deduct_num);
			pstmt.setString(3, emp_id);
			pstmt.setString(4, deduct_dt);
			pstmt.setInt   (5, deduct_amt);
			pstmt.setString(6, deduct_content);
			pstmt.setString(7, rent_l_cd);
			pstmt.setString(8, rent_m_id);
			pstmt.setString(9, reg_id);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	}
	  	catch(Exception e)
	  	{
			System.out.println("[AddCommiDatabase:insertCommiDeduct]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//������� ������� �󼼳��� ��ȸ (20180620)
	public Vector getCommiDeductList(String deduct_st, String emp_id, String deduct_dt, String rent_l_cd, String rent_m_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		

		query = " SELECT a.DEDUCT_ST, a.DEDUCT_NUM, a.EMP_ID, a.DEDUCT_DT, a.DEDUCT_AMT, a.DEDUCT_CONTENT, a.RENT_L_CD, a.RENT_MNG_ID, a.REG_ID, a.REG_DT, \n"+
				"		 b.same_cnt \n"+
				"	FROM COMMI_DEDUCT a, "+
				"		 (SELECT COUNT(0)AS same_cnt, deduct_dt, EMP_ID, RENT_L_CD, RENT_MNG_ID "+
				"		   FROM commi_deduct "+
				"		   GROUP BY DEDUCT_DT, EMP_ID, RENT_L_CD, RENT_MNG_ID ) b \n"+
				//"  WHERE 1=1 and a.RENT_L_CD = b.RENT_L_CD AND a.RENT_MNG_ID = b.RENT_MNG_ID "+
				"  WHERE 1=1   "+
				"	 AND a.DEDUCT_DT = b.DEDUCT_DT AND a.EMP_ID = b.EMP_ID "+
				" ";
		
		//if(!emp_id.equals("")){			query += "    AND a.emp_id = '"+emp_id+"' \n";				}
		//if(!deduct_dt.equals("")){		query += "    AND a.deduct_dt = '"+deduct_dt+"' \n";		}
		//if(!rent_l_cd.equals("")){		query += "    AND a.rent_l_cd = '"+rent_l_cd+"' \n";		}
		//if(!rent_m_id.equals("")){		query += "    AND a.rent_mng_id = '"+rent_m_id+"' \n";		}
		
		query += "  ORDER BY deduct_dt, rent_l_cd, deduct_num ";
		
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
			System.out.println("[AddCommiDatabase:getCommiDeductList]"+ e);
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
	
	//������� ������� �Ѱ� ���� (20180622)
	public boolean deleteCommiDeduct(String emp_id, String deduct_dt, String rent_l_cd, String rent_m_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " DELETE FROM COMMI_DEDUCT "+
					   "  WHERE EMP_ID=? AND DEDUCT_DT=? AND RENT_L_CD=? AND RENT_MNG_ID=? ";
		try 
		{	
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, emp_id);
			pstmt.setString(2, deduct_dt);
			pstmt.setString(3, rent_l_cd);
			pstmt.setString(4, rent_m_id);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	}
	  	catch(Exception e)
	  	{
			System.out.println("[AddCommiDatabase:deleteCommiDeduct]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	
	  //���� �ֱ�  ���޼����� 
	public String  getMaxSetDt(String emp_id)
		{
			getConnection();
			Statement stmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "";	
			String s_dt = "";
			
			query = " select max(a.sup_dt) from commi a where a.emp_id =  '"+emp_id+"'"; 
				 		
			try {
				stmt = conn.createStatement();
			    rs = stmt.executeQuery(query);
			  
			    if(rs.next())
				{				
				    s_dt = rs.getString(1);						//�������ID
				  
				}
				rs.close();
				stmt.close();
			} catch (SQLException e) {
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null )		rs.close();
	                if(stmt != null)	stmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return s_dt;
			}
		
		}		
	
}
