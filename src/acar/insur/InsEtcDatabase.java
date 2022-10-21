package acar.insur;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.account.*;
import acar.common.*;
import acar.util.*;
import acar.mng_exp.*;

public class InsEtcDatabase
{
	private Connection conn = null;
	public static InsEtcDatabase db;
	
	public static InsEtcDatabase getInstance()
	{
		if(InsEtcDatabase.db == null)
			InsEtcDatabase.db = new InsEtcDatabase();
		return InsEtcDatabase.db;
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

	//보험현황-갱신예정리스트
	public Vector getInsStatList1_excel(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st, String mod_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		if(mod_st.equals("")) mod_st = "1";

		query = " select a.firm_emp_nm, a.ins_start_dt, a.ins_exp_dt, i.taking_p, DECODE(c.car_st,'2',c.reg_dt,c.rent_start_dt) AS rent_start_dt, c.rent_end_dt, a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.use_yn, a.con_f_nm, \n"+
				" CASE when c.car_st='5' THEN '1288147957' WHEN t.client_st='2' THEN SUBSTR(TEXT_DECRYPT(t.ssn, 'pw' ),0,6) ELSE t.enp_no END enp_no,  \n"+
				" decode(c.car_st,'5','(주)아마존카/'||c.firm_nm,c.firm_nm ) as firm_nm,  \n" +
				" i.car_no, i.car_nm, d.car_name, i.car_num, i.init_reg_dt, \n"+
				" f.ins_com_nm, a.ins_st, a.ins_con_no, h.migr_dt, decode(cc.cls_st,'8',cc.cls_dt) cls_dt, \n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.auto_yn,'Y',1,0) as auto,\n"+
				" decode(a.abs_yn,'Y',1,0) as abs,\n"+
				" decode(a.blackbox_yn,'Y',1,0) as blackbox,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하') as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.car_use,'1','영업용','2','업무용','3','개인용') car_use,"+
				" decode(a.vins_gcp_kd,'1','3000만원','2','1500만원','3','1억원','4','5000만원','5','1000만원','6','5억원', '7','2억원', '8','3억원') vins_gcp_kd,"+
				" decode(a.vins_bacdt_kd,'1','3억원','2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원') vins_bacdt_kd,"+
				" decode(a.vins_bacdt_kc2,'1','3억원','2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원') vins_bacdt_kc2,"+
				" decode(a.vins_canoisr_amt,0,'미가입','가입') vins_canoisr,"+
				" decode(a.vins_share_extra_amt,0,'미가입','가입') vins_share_extra, cu.user_nm,"+
				" decode(a.vins_cacdt_cm_amt,0,'미가입','가입') vins_cacdt,"+
				" decode(a.vins_spe_amt,0,'미가입','가입') vins_spe,"+
				" decode(a.vins_canoisr_amt,0,'N','Y') vins_canoisr2,"+
				" decode(a.vins_share_extra_amt,0,'N','Y') vins_share_extra2,"+
				" decode(a.vins_cacdt_cm_amt,0,'N','Y') vins_cacdt2,"+
				" decode(a.vins_spe_amt,0,'N','Y') vins_spe2, \n"+
			    " e.nm as car_kd, "+
				" mod(ROWNUM,"+mod_st+") mod_st, "+
			    " CASE WHEN t.client_st='1' and nvl(t.firm_type,'0')<>'10' and to_number(replace(i.dpm,' ','')) > 1000 and i.taking_p < 9 and d.car_name not like '%9인승%' AND d.s_st > '101' AND d.s_st < '600' AND NVL(a.com_emp_yn,'Y') = 'Y' AND c.car_st <> '2' THEN 'Y'  "+
				"	   ELSE 'N' END com_emp_yn, "+
				" decode(a.blackbox_nm,'',r2.com_nm,a.blackbox_nm) b_com_nm, "+
				" decode(a.blackbox_nm,'',r2.model_nm,'') as b_model_nm, "+
				" decode(a.blackbox_nm,'',r2.serial_no,a.blackbox_no) as b_serial_no, "+
				" decode(a.blackbox_nm,'',r2.tint_amt,a.blackbox_amt) as b_amt, "+
				" cd.doc_no, d.jg_code, a.conr_nm, a.con_f_nm\n"+
				" from (select * from insur where (car_mng_id, ins_st) in (select car_mng_id, max(TO_NUMBER(ins_st)) ins_st from insur where ins_sts='1' group by car_mng_id)) a,  \n"+
				"      cont_n_view c, cls_cont cc,  car_etc ce, users cu, \n"+
				"      ins_com f, sui h, car_reg i, ins_cls l, car_nm d, client t, \n"+
                "      (select car_mng_id, cust_id, deli_dt from rent_cont where  rent_st='4' and cust_st='4' and use_st='2') b, "+
				"      (SELECT car_mng_id, max(com_nm) com_nm, max(model_nm) model_nm, max(serial_no) serial_no, max(tint_amt) tint_amt "+
                "       FROM "+
                "            ( "+
                "              SELECT b.car_mng_id, a.com_nm, a.model_nm, a.serial_no, a.tint_amt FROM CAR_TINT a, cont b WHERE a.tint_st='3' AND a.tint_yn='Y' and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "+
                "              UNION all "+
                "              SELECT b.car_mng_id, a.blackbox_nm AS com_nm, '' model_nm, a.blackbox_num AS serial_no, a.blackbox_amt AS tint_amt FROM TINT a, cont b WHERE a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND a.BLACKBOX_AMT>0 "+
                "            ) "+
		        "       group by car_mng_id "+ 
		        "      ) r2, \n"+
				"       cls_etc cs, (select * from doc_settle where doc_st='11') cd, "+
				"      (select * from code where c_st='0041') e \n"+
				" where \n"+
				" a.car_mng_id=c.car_mng_id \n"+
				" and decode(c.use_yn,'Y','Y','','Y',decode(cc.cls_st,'8','Y','N'))='Y'\n"+//살아있거나 매입옵션 명의이전인 차량
				" and a.ins_com_id=f.ins_com_id"+
				" and c.mng_id=cu.user_id  "+
				" and a.car_mng_id=h.car_mng_id(+) "+
				" and a.car_mng_id=i.car_mng_id "+
				" and nvl(i.prepare,'0')<>'4'"+ //말소차량제외
				" and a.car_mng_id=l.car_mng_id(+) and a.ins_st=l.ins_st(+) "+
				" and c.rent_mng_id = ce.rent_mng_id and c.rent_l_cd =ce.rent_l_cd \n"+
				" and ce.car_id=d.car_id and ce.car_seq=d.car_seq and c.client_id = t.client_id "+
				" and c.rent_mng_id = cc.rent_mng_id(+) and c.rent_l_cd =cc.rent_l_cd(+) \n"+
                " and a.car_mng_id=b.car_mng_id(+) "+
				" and c.car_mng_id=r2.car_mng_id(+) \n"+
                " and c.rent_mng_id=cs.rent_mng_id(+) and c.rent_l_cd=cs.rent_l_cd(+) and cs.rent_l_cd=cd.doc_id(+) and i.car_kd=e.nm_cd "+
				" ";

			if(gubun2.equals("6")){
				query += " and a.ins_start_dt like to_char(sysdate,'YYYYMM')||'%'";
			}else{
				query += " and l.car_mng_id is null"; 
				query += " and nvl(h.migr_dt,a.ins_exp_dt) >= a.ins_exp_dt"; 
			}


			if(gubun1.equals("1"))		query += " and a.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and a.car_use<>'1'";

			if(gubun2.equals("1"))		query += " and a.ins_exp_dt < to_char(sysdate,'YYYYMMDD')";
			if(gubun2.equals("2"))		query += " and a.ins_exp_dt between to_char(sysdate-30,'YYYYMMDD') and to_char(sysdate+30,'YYYYMMDD')";
			if(gubun2.equals("3"))		query += " and a.ins_exp_dt like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun2.equals("4"))		query += " and a.ins_exp_dt like to_char(add_months(sysdate,1), 'YYYYMM')||'%'";
			if(gubun2.equals("5"))		query += " and a.ins_exp_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun2.equals("7"))		query += " and a.ins_exp_dt = to_char(sysdate+1,'YYYYMMDD')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and c.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and c.brch_id in ('S1','K1','K2')"; 

			if(gubun3.equals("1"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 801 and 1000 ";
			if(gubun3.equals("2"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 1501 and 1600 ";
			if(gubun3.equals("3"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 1901 and 2000 ";
			if(gubun3.equals("4"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) between 2001 and 2800 ";
			if(gubun3.equals("5"))		query += " and i.car_kd in ('1','2','3','9') and to_number(i.dpm) >= 2801 ";
			if(gubun3.equals("6"))		query += " and i.taking_p=7";
			if(gubun3.equals("7"))		query += " and i.taking_p between 8 and 10";
			if(gubun3.equals("8"))		query += " and i.taking_p=11";
			if(gubun3.equals("9"))		query += " and i.taking_p=12";
			if(gubun3.equals("10"))		query += " and i.car_kd in ('6','7','8') and i.car_nm||d.car_name like '%밴%'";
			if(gubun3.equals("11"))		query += " and i.car_kd in ('6','7','8') and i.car_nm||d.car_name not like '%밴%'";
			if(gubun3.equals("01"))		query += " and a.con_f_nm like '%아마존카%'";
			if(gubun3.equals("02"))		query += " and a.con_f_nm not like '%아마존카%'";
			if(gubun3.equals("0008") || gubun3.equals("0038")){
				query += " AND CASE WHEN a.car_use IN ('2','3') THEN '0008' WHEN a.car_use='1' AND t.client_st='1' AND d.s_st IN ('400','401','402','501','502','601','602','300','301','302') THEN '0008' ELSE '0038' end ='"+gubun3+"' ";
			}

			if(gubun3.length()==3)		query += " and d.s_st='"+gubun3+"'";



			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'\n";			
				else if(s_kd.equals("4"))		query += " and upper(c.rent_l_cd) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("2"))		query += " and (i.car_no like '%"+t_wd+"%' or i.first_car_no like '%"+t_wd+"%')\n";
				else if(s_kd.equals("5"))		query += " and i.car_nm||d.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("3"))		query += " and upper(i.car_num) like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("6"))		query += " and e.nm like upper('%"+t_wd+"%')\n";
				else if(s_kd.equals("7"))		query += " and a.ins_exp_dt like '"+t_wd+"%'\n";
				else if(s_kd.equals("8"))		query += " and f.ins_com_nm like '%"+t_wd+"%'\n";
			}

			query += " ORDER BY 1, 2, 4, 5, 7 \n";

			
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

			System.out.println("[InsEtcDatabase:getInsStatList1_excel]"+ query);
			System.out.println("[InsEtcDatabase:getInsStatList1_excel]"+ e);
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

	//보험현황-갱신예정
	public Hashtable getInsStat_excel(String car_mng_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.firm_emp_nm, a.ins_start_dt, a.ins_exp_dt, i.taking_p, DECODE(c.car_st,'2',c.reg_dt,c.rent_start_dt) AS rent_start_dt, c.rent_end_dt, a.car_mng_id, c.rent_mng_id, c.rent_l_cd, c.use_yn, a.con_f_nm, \n"+
				" CASE when c.car_st='5' THEN '1288147957' WHEN t.client_st='2' THEN SUBSTR(TEXT_DECRYPT(t.ssn, 'pw' ),0,6) ELSE t.enp_no END enp_no,  \n"+
				" decode(c.car_st,'5','(주)아마존카/'||c.firm_nm,c.firm_nm ) as firm_nm,  \n" +
				" i.car_no, i.car_nm, d.car_name, i.car_num, i.init_reg_dt, \n"+
				" f.ins_com_nm, a.ins_st, a.ins_con_no, h.migr_dt, decode(cc.cls_st,'8',cc.cls_dt) cls_dt, \n"+ 
				" (decode(a.air_ds_yn,'Y',1,0)+decode(a.air_as_yn,'Y',1,0)) as air,\n"+
				" decode(a.auto_yn,'Y',1,0) as auto,\n"+
				" decode(a.abs_yn,'Y',1,0) as abs,\n"+
				" decode(decode(a.blackbox_nm,'',r2.serial_no,a.blackbox_no),'',0,1) as blackbox,\n"+
				" decode(a.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','35세이상~49세이하',decode(g.driving_age,'0','26세이상','3','24세이상','1','21세이상','2','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','28세이상','11','49세이하')) as age_scp,\n"+
				" decode(a.ins_kd,'2','책임보험', '종합보험') as ins_kd,\n"+
				" decode(a.ins_sts,'1','유효', '2','만료', '3','중도해지','5','승계') as ins_sts,\n"+
				" decode(a.car_use,'1','영업용','2','업무용','3','개인용') car_use,"+
				" decode(a.vins_gcp_kd,'1','3000만원','2','1500만원','3','1억원','4','5000만원','5','1000만원','6','5억원', '7','2억원', '8','3억원',  decode(g.GCP_KD,'1','5천만원','2','1억원','3','5억원','4','2억원','8','3억원')) vins_gcp_kd,"+
				" decode(a.vins_bacdt_kd,'1','3억원','2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원') vins_bacdt_kd,"+
				" decode(a.vins_bacdt_kc2,'1','3억원','2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원') vins_bacdt_kc2,"+
				" decode(a.vins_canoisr_amt,0,'미가입','가입') vins_canoisr,"+
				" decode(a.vins_share_extra_amt,0,'미가입','가입') vins_share_extra, cu.user_nm,"+
				" decode(a.vins_cacdt_cm_amt,0,'미가입','가입') vins_cacdt,"+
				" decode(a.vins_spe_amt,0,'미가입','가입') vins_spe,"+
				" decode(a.vins_canoisr_amt,0,'N','Y') vins_canoisr2,"+
				" decode(a.vins_share_extra_amt,0,'N','Y') vins_share_extra2,"+
				" decode(a.vins_cacdt_cm_amt,0,'N','Y') vins_cacdt2,"+
				" decode(a.vins_spe_amt,0,'N','Y') vins_spe2, \n"+
			    " e.nm as car_kd, "+
			    " CASE WHEN DECODE(c.car_st,'5','1',t.client_st)<>'2' and nvl(t.firm_type,'0')<>'10' and (to_number(replace(i.dpm,' ','')) > 1000 OR i.FUEL_KD ='8' ) and i.taking_p < 9 and d.car_name not like '%9인승%' AND d.s_st > '101' AND d.s_st < '600' AND c.car_st <> '2' and NVL(j.COM_EMP_YN,'N')= 'Y' THEN 'Y'    "+
				"	   ELSE 'N' END com_emp_yn, "+
				" decode(a.blackbox_nm,'',r2.com_nm,a.blackbox_nm) b_com_nm, "+
				" decode(a.blackbox_nm,'',r2.model_nm,'') as b_model_nm, "+
				" decode(a.blackbox_nm,'',r2.serial_no,a.blackbox_no) as b_serial_no, "+
				" decode(a.blackbox_nm,'',r2.tint_amt,a.blackbox_amt) as b_amt, "+
				" cd.doc_no, i.car_use, a.enp_no, "+
				" decode(a.lkas_yn,'',j.lkas_yn,decode(a.lkas_yn,'','N',a.lkas_yn)) lkas_yn, decode(a.ldws_yn,'',j.ldws_yn,decode(a.ldws_yn,'','N',a.ldws_yn)) ldws_yn,  "+
				" decode(a.aeb_yn,'',j.aeb_yn,decode(a.aeb_yn,'','N',a.aeb_yn)) aeb_yn,  decode(a.fcw_yn,'',j.fcw_yn,decode(a.fcw_yn,'','N',a.fcw_yn)) fcw_yn, decode(a.ev_yn,'',j.ev_yn,decode(a.ev_yn,'','N',a.ev_yn)) ev_yn, \n"+
				" decode(a.hook_yn,'',j.hook_yn,decode(a.hook_yn,'','N',a.hook_yn)) hook_yn, \n"+
				" decode(a.legal_yn,'',j.legal_yn,decode(a.legal_yn,'','N',a.legal_yn)) legal_yn, \n"+
				" decode(a.others,'',g.others,a.others) others, a.others_device,  \n"+
				" d.s_st, d.diesel_yn, t.client_st, opt, d.CAR_COMP_ID, d.JG_CODE "+
				" from insur a,  \n"+
				"      cont_n_view c, cls_cont cc,  car_etc ce, users cu, \n"+
				"      ins_com f, sui h, car_reg i, ins_cls l, car_nm d, client t, \n"+
                "      (select car_mng_id, cust_id, deli_dt from rent_cont where  rent_st='4' and cust_st='4' and use_st='2') b, "+

				"      (SELECT car_mng_id, max(com_nm) com_nm, max(model_nm) model_nm, max(serial_no) serial_no, max(tint_amt) tint_amt "+
                "       FROM "+
                "            ( "+
                "              SELECT b.car_mng_id, a.com_nm, a.model_nm, a.serial_no, a.tint_amt FROM CAR_TINT a, cont b WHERE a.tint_st='3' AND a.tint_yn='Y' and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "+
                "              UNION all "+
                "              SELECT b.car_mng_id, a.blackbox_nm AS com_nm, '' model_nm, a.blackbox_num AS serial_no, a.blackbox_amt AS tint_amt FROM TINT a, cont b WHERE a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND a.BLACKBOX_AMT>0 "+
                "            ) "+
		        "       group by car_mng_id "+ 
		        "      ) r2, \n"+

				"       cls_etc cs, (select * from doc_settle where doc_st='11') cd, cont g, cont_etc j, "+
				"      (select * from code where c_st='0041') e \n"+
				" where \n"+
				" a.car_mng_id='"+car_mng_id+"' and a.ins_st='"+ins_st+"' and a.car_mng_id=c.car_mng_id \n"+
				" and decode(c.use_yn,'Y','Y','','Y',decode(cc.cls_st,'8','Y','N'))='Y'\n"+//살아있거나 매입옵션 명의이전인 차량
				" and a.ins_com_id=f.ins_com_id"+
				" and c.mng_id=cu.user_id  "+
				" and a.car_mng_id=h.car_mng_id(+) "+
				" and a.car_mng_id=i.car_mng_id "+
				" and nvl(i.prepare,'0')<>'4'"+ //말소차량제외
				" and a.car_mng_id=l.car_mng_id(+) and a.ins_st=l.ins_st(+) "+
				" and c.rent_mng_id = ce.rent_mng_id and c.rent_l_cd =ce.rent_l_cd \n"+
				" and ce.car_id=d.car_id and ce.car_seq=d.car_seq and c.client_id = t.client_id "+
				" and c.rent_mng_id = cc.rent_mng_id(+) and c.rent_l_cd =cc.rent_l_cd(+) \n"+
                " and a.car_mng_id=b.car_mng_id(+) "+
				" and c.car_mng_id=r2.car_mng_id(+) \n"+
                " and c.rent_mng_id=cs.rent_mng_id(+) and c.rent_l_cd=cs.rent_l_cd(+) and cs.rent_l_cd=cd.doc_id(+) "+
                " and c.RENT_L_CD = g.RENT_L_CD   and c.RENT_MNG_ID = g.RENT_MNG_ID  AND g.RENT_L_CD = j.RENT_L_CD and i.car_kd=e.nm_cd "+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();


		} catch (SQLException e) {

			System.out.println("[InsEtcDatabase:getInsStat_excel]"+ query);
			System.out.println("[InsEtcDatabase:getInsStat_excel]"+ e);
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

	//보험현황-갱신예정리스트
	public Vector getInsComempNotStatListRent(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " SELECT \n"+
                "        l.ins_start_dt, l.ins_exp_dt, nvl(g.enp_no, TEXT_DECRYPT(g.ssn, 'pw' ) ) as enp_no, b.rent_start_dt, b.rent_end_dt, b.car_mng_id, d.car_no, m.car_nm, c.car_name, \n"+
				"        b.rent_mng_id, b.rent_l_cd, g.enp_no, g.client_id, g.firm_nm, TEXT_DECRYPT(g.ssn, 'pw' )  ssn, j.user_nm bus_nm, k.user_nm bus_nm2, b.bus_id, b.bus_id2, \n"+
				"        g.con_agnt_email, n.ins_com_nm, \n"+
				"        decode(a.com_emp_yn,'Y','가입','N','미가입','') cont_com_emp_yn,  \n"+
				"        decode(l.com_emp_yn,'Y','가입','N','미가입','') ins_com_emp_yn  \n"+
				" from   cont b, car_reg d, car_etc e, car_nm c, client g, sui i, users j, users k, (select * from insur where ins_sts='1') l, cont_etc a, car_mng m, ins_com n \n"+
				" where \n"+
				"        nvl(b.use_yn,'Y')='Y' AND b.car_st IN ('1','3') \n"+
				"        and to_number(replace(d.dpm,' ','')) > 1000 \n"+
                "        and d.taking_p < 9 \n"+
                "        and c.car_name not like '%9인승%' \n"+
				"        and c.s_st < '600' \n"+
                "        AND g.client_st='1' \n"+
				"        and b.car_mng_id=d.car_mng_id \n"+
				"        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=c.CAR_ID and e.car_seq=c.car_seq and c.car_comp_id=m.car_comp_id and c.car_cd=m.code \n"+
				"        and b.client_id=g.client_id \n"+
				"        and b.car_mng_id=i.car_mng_id(+) and i.car_mng_id is NULL \n"+
				"        and b.bus_id=j.user_id and b.bus_id2=k.user_id \n"+
				"        and d.car_mng_id=l.car_mng_id \n"+
			    "        AND l.ins_com_id=n.ins_com_id(+) \n"+
				"        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
				"        and nvl(l.com_emp_yn,'N')='N' \n"+
				" ";
			
			if(gubun1.equals("1"))		query += " and l.ins_exp_dt between to_char(sysdate-30,'YYYYMMDD') and to_char(sysdate+30,'YYYYMMDD') \n";
			if(gubun1.equals("2"))		query += " and l.ins_exp_dt like to_char(sysdate,'YYYYMM')||'%' \n";
			if(gubun1.equals("3"))		query += " and l.ins_exp_dt like to_char(add_months(sysdate,1), 'YYYYMM')||'%' \n";
			if(gubun1.equals("4"))		query += " and l.ins_exp_dt between to_char(sysdate-15,'YYYYMMDD') and to_char(sysdate+15,'YYYYMMDD') \n";
			if(gubun1.equals("5"))		query += " and la.ins_exp_dt like to_char(sysdate, 'YYYY')||'%' \n";

			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			query += " g.firm_nm like '%"+t_wd+"%' \n";
				else if(s_kd.equals("2"))		query += " g.enp_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("3"))		query += " upper(b.rent_l_cd) like upper('%"+t_wd+"%') \n";
				else if(s_kd.equals("4"))		query += " d.car_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("5"))		query += " d.car_nm||c.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("6"))		query += " j.user_nm like '%"+t_wd+"%'\n";
				else if(s_kd.equals("7"))		query += " k.user_nm like '%"+t_wd+"%'\n";
			}

			query += " ORDER BY 1,2,3,4,6 \n";

			
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

//			System.out.println("[InsEtcDatabase:getInsComempNotStatList]"+ r_query);

		} catch (SQLException e) {
			
			System.out.println("[InsEtcDatabase:getInsComempNotStatList]"+ e);
			System.out.println("[InsEtcDatabase:getInsComempNotStatList]"+ r_query);
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

	//보험현황-갱신예정리스트
	public Vector getInsComempNotStatList(String s_kd, String t_wd, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " --임직원운전한정특약 대상 계약 리스트 - 법인고객 \n"+
                " SELECT \n"+
                "        '1' st, b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.rent_start_dt, b.rent_end_dt, d.car_no, m.car_nm, c.car_name, \n"+
				"        g.enp_no, g.client_id, g.firm_nm, j.user_nm bus_nm, k.user_nm bus_nm2, b.bus_id, b.bus_id2, \n"+
				"        l.ins_start_dt, l.ins_exp_dt, g.con_agnt_email, n.ins_com_nm, \n"+
				"        decode(a.com_emp_yn,'Y','가입','N','미가입','') cont_com_emp_yn,  \n"+
				"        decode(l.com_emp_yn,'Y','가입','N','미가입','') ins_com_emp_yn  \n"+
				" from   cont b, car_reg d, car_etc e, car_nm c, client g, sui i, users j, users k, (select * from insur where ins_sts='1') l, cont_etc a, car_mng m, ins_com n \n"+
				" where \n"+
				"        nvl(b.use_yn,'Y')='Y' AND b.car_st IN ('1','3','5') \n"+
				"        and to_number(replace(d.dpm,' ','')) > 1000 \n"+
                "        and d.taking_p < 9 \n"+
                "        and c.car_name not like '%9인승%' \n"+
				"        and c.s_st < '600' \n"+
                "        AND g.client_st='1' \n"+
				"        and b.car_mng_id=d.car_mng_id \n"+
				"        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=c.CAR_ID and e.car_seq=c.car_seq and c.car_comp_id=m.car_comp_id and c.car_cd=m.code \n"+
				"        and b.client_id=g.client_id \n"+
				"        and b.car_mng_id=i.car_mng_id(+) and i.car_mng_id is NULL \n"+
				"        and b.bus_id=j.user_id and b.bus_id2=k.user_id \n"+
				"        and d.car_mng_id=l.car_mng_id \n"+
			    "        AND l.ins_com_id=n.ins_com_id(+) \n"+
				"        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
				"        and nvl(l.com_emp_yn,'N')='"+gubun2+"' \n"+
				" ";

			r_query = " select a.* from ("+query+") a \n";

			
			if(gubun1.equals("1"))		r_query += " where a.ins_exp_dt between to_char(sysdate-30,'YYYYMMDD') and to_char(sysdate+30,'YYYYMMDD') \n";
			if(gubun1.equals("2"))		r_query += " where a.ins_exp_dt like to_char(sysdate,'YYYYMM')||'%' \n";
			if(gubun1.equals("3"))		r_query += " where a.ins_exp_dt like to_char(add_months(sysdate,1), 'YYYYMM')||'%' \n";
			if(gubun1.equals("4"))		r_query += " where a.ins_exp_dt between to_char(sysdate-15,'YYYYMMDD') and to_char(sysdate+15,'YYYYMMDD') \n";
			if(gubun1.equals("5"))		r_query += " where a.ins_exp_dt like to_char(sysdate, 'YYYY')||'%' \n";


			if(gubun1.equals("") && !t_wd.equals(""))	r_query += " where ";
			if(!gubun1.equals("") && !t_wd.equals(""))	r_query += " and ";


			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			r_query += " a.firm_nm like '%"+t_wd+"%' \n";
				else if(s_kd.equals("2"))		r_query += " a.enp_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("3"))		r_query += " upper(a.rent_l_cd) like upper('%"+t_wd+"%') \n";
				else if(s_kd.equals("4"))		r_query += " a.car_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("5"))		r_query += " a.car_nm||a.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("6"))		r_query += " a.bus_nm like '%"+t_wd+"%'\n";
				else if(s_kd.equals("7"))		r_query += " a.bus_nm2 like '%"+t_wd+"%'\n";
				else if(s_kd.equals("8"))		r_query += " a.ins_exp_dt like '"+t_wd+"%'\n";
			}

			r_query += " ORDER BY a.ins_start_dt, a.ins_exp_dt, a.enp_no, a.rent_start_dt, a.car_mng_id \n";

			
		try {
				pstmt = conn.prepareStatement(r_query);
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

//			System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);

		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsComempNotStatList]"+ e);
			System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);
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



	//보험현황-갱신예정리스트2
	public Vector getInsComempNotStatList(String s_kd, String t_wd, String gubun1, String gubun2,String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " --임직원운전한정특약 대상 계약 리스트 - 법인고객 \n"+
                " SELECT \n"+
                "        '1' st, b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.rent_start_dt, b.rent_end_dt, d.car_no, m.car_nm, c.car_name, \n"+
				"        g.enp_no, g.client_id, TEXT_DECRYPT(g.ssn, 'pw' ) ssn , g.firm_nm, j.user_nm bus_nm, k.user_nm bus_nm2, b.bus_id, b.bus_id2, \n"+
				"        l.ins_start_dt, l.ins_exp_dt, g.con_agnt_email, n.ins_com_nm, \n"+
				"        decode(a.com_emp_yn,'Y','가입','N','미가입','') cont_com_emp_yn,  \n"+
				"        decode(l.com_emp_yn,'Y','가입','N','미가입','') ins_com_emp_yn  \n"+
				" from   cont b, car_reg d, car_etc e, car_nm c, client g, sui i, users j, users k, (select * from insur where ins_sts='1') l, cont_etc a, car_mng m, ins_com n \n"+
				" where \n"+
				"        nvl(b.use_yn,'Y')='Y' AND b.car_st IN ('1','3','5') \n"+
				"        and to_number(replace(d.dpm,' ','')) > 1000 \n"+
                "        and d.taking_p < 9 \n"+
                "        and c.car_name not like '%9인승%' \n"+
				"        and c.s_st < '600' \n"+
                "        AND g.client_st='1' \n"+
				"        and b.car_mng_id=d.car_mng_id \n"+
				"        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=c.CAR_ID and e.car_seq=c.car_seq and c.car_comp_id=m.car_comp_id and c.car_cd=m.code \n"+
				"        and b.client_id=g.client_id \n"+
				"        and b.car_mng_id=i.car_mng_id(+) and i.car_mng_id is NULL \n"+
				"        and b.bus_id=j.user_id and b.bus_id2=k.user_id \n"+
				"        and d.car_mng_id=l.car_mng_id \n"+
			    "        AND l.ins_com_id=n.ins_com_id(+) \n"+
				"        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n";
		if(gubun2.equals("D")){
				query += "AND decode(l.com_emp_yn,'Y','가입','N','미가입','') ='가입' \n"+
						 "AND decode(a.com_emp_yn,'Y','가입','N','미가입','미가입') ='미가입' \n"+
						 " ";
		}else{
			query += "   and nvl(l.com_emp_yn,'N')='"+gubun2+"' \n"+
				" "; 
		}
			

			r_query = " select a.* from ("+query+") a \n";

			
			if(gubun1.equals("1"))		r_query += " where a.ins_exp_dt between to_char(sysdate-30,'YYYYMMDD') and to_char(sysdate+30,'YYYYMMDD') \n";
			if(gubun1.equals("2"))		r_query += " where a.ins_exp_dt like to_char(sysdate,'YYYYMM')||'%' \n";
			if(gubun1.equals("3"))		r_query += " where a.ins_exp_dt like to_char(add_months(sysdate,1), 'YYYYMM')||'%' \n";
			if(gubun1.equals("4"))		r_query += " where a.ins_exp_dt between to_char(sysdate-15,'YYYYMMDD') and to_char(sysdate+15,'YYYYMMDD') \n";
			if(gubun1.equals("5"))		r_query += " where a.ins_exp_dt like to_char(sysdate, 'YYYY')||'%' \n";
			if(gubun1.equals("6"))		{
				if(!st_dt.equals("") && end_dt.equals(""))	r_query += " where a.ins_exp_dt like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) r_query += " where a.ins_exp_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}


			if(gubun1.equals("") && !t_wd.equals(""))	r_query += " where ";
			if(!gubun1.equals("") && !t_wd.equals(""))	r_query += " and ";


			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			r_query += " a.firm_nm like '%"+t_wd+"%' \n";
				else if(s_kd.equals("2"))		r_query += " a.enp_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("3"))		r_query += " upper(a.rent_l_cd) like upper('%"+t_wd+"%') \n";
				else if(s_kd.equals("4"))		r_query += " a.car_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("5"))		r_query += " a.car_nm||a.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("6"))		r_query += " a.bus_nm like '%"+t_wd+"%'\n";
				else if(s_kd.equals("7"))		r_query += " a.bus_nm2 like '%"+t_wd+"%'\n";
				else if(s_kd.equals("8"))		r_query += " a.ins_exp_dt like '"+t_wd+"%'\n";
			}

			r_query += " ORDER BY a.ins_start_dt, a.ins_exp_dt, a.enp_no, a.rent_start_dt, a.car_mng_id \n";

			
		try {
				pstmt = conn.prepareStatement(r_query);
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

//			System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);

		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsComempNotStatList]"+ e);
			System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);
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

		//보험현황-갱신예정리스트2
	public Vector getInsComempNotStatList(String s_kd, String t_wd, String gubun1, String gubun2,String st_dt, String end_dt,String gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " --임직원운전한정특약 대상 계약 리스트 - 법인고객 \n"+
                " SELECT \n"+
                "        '1' st, b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.rent_start_dt, b.rent_end_dt, d.car_no, m.car_nm, c.car_name,  \n"+
				"        g.enp_no, g.client_id, TEXT_DECRYPT(g.ssn, 'pw' )  ssn , g.firm_nm, j.user_nm bus_nm, k.user_nm bus_nm2, b.bus_id, b.bus_id2, \n"+
				"        l.ins_start_dt, l.ins_exp_dt, g.con_agnt_email, n.ins_com_nm, \n"+
				"        decode(a.com_emp_yn,'Y','가입','N','미가입','') cont_com_emp_yn,  \n"+
				"        decode(l.com_emp_yn,'Y','가입','N','미가입','') ins_com_emp_yn, l.firm_emp_nm  \n"+
				" from   cont b, car_reg d, car_etc e, car_nm c, client g, sui i, users j, users k, (select * from insur where ins_sts='1') l, cont_etc a, car_mng m, ins_com n \n"+
				" where \n"+
				"        nvl(b.use_yn,'Y')='Y' \n";
		if(s_kd.equals("9")){ query += " AND b.car_st IN ('5')  \n"; }
		else{ query += " AND b.car_st IN ('1','3','5') AND g.client_st='1'  \n"; }
		query +="        and (to_number(replace(d.dpm,' ','')) > 1000 OR d.FUEL_KD = '8')  \n"+
                "        and d.taking_p < 9 \n"+
                "        and c.car_name not like '%9인승%' \n"+
				"        and c.s_st < '600' \n"+
				"        and b.car_mng_id=d.car_mng_id \n"+
				"        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=c.CAR_ID and e.car_seq=c.car_seq and c.car_comp_id=m.car_comp_id and c.car_cd=m.code \n"+
				"        and b.client_id=g.client_id \n"+
				"        and b.car_mng_id=i.car_mng_id(+) and i.car_mng_id is NULL \n"+
				"        and b.bus_id=j.user_id and b.bus_id2=k.user_id \n"+
				"        and d.car_mng_id=l.car_mng_id \n"+
			    "        AND l.ins_com_id=n.ins_com_id(+) \n"+
				"        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n";
		if(gubun2.equals("D")){
				query += "AND decode(l.com_emp_yn,'Y','가입','N','미가입','') ='가입' \n"+
						 "AND decode(a.com_emp_yn,'Y','가입','N','미가입','미가입') ='미가입' \n"+
						 " ";
		}else if(gubun2.equals("N") || gubun2.equals("Y")){
			query += "   and nvl(l.com_emp_yn,'N')='"+gubun2+"' \n"+
				" "; 
		}
			

			r_query = " select a.* from ("+query+") a \n";

			
			if(gubun1.equals("1"))		r_query += " where a.ins_exp_dt between to_char(sysdate-30,'YYYYMMDD') and to_char(sysdate+30,'YYYYMMDD') \n";
			if(gubun1.equals("2"))		r_query += " where a.ins_exp_dt like to_char(sysdate,'YYYYMM')||'%' \n";
			if(gubun1.equals("3"))		r_query += " where a.ins_exp_dt like to_char(add_months(sysdate,1), 'YYYYMM')||'%' \n";
			if(gubun1.equals("4"))		r_query += " where a.ins_exp_dt between to_char(sysdate-15,'YYYYMMDD') and to_char(sysdate+15,'YYYYMMDD') \n";
			if(gubun1.equals("5"))		r_query += " where a.ins_exp_dt like to_char(sysdate, 'YYYY')||'%' \n";
			if(gubun1.equals("6"))		{
				if(!st_dt.equals("") && end_dt.equals(""))	r_query += " where a.ins_exp_dt like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) r_query += " where a.ins_exp_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}


			if(gubun1.equals("") && !t_wd.equals(""))	r_query += " where ";
			if(!gubun1.equals("") && !t_wd.equals(""))	r_query += " and ";


			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			r_query += " a.firm_nm like '%"+t_wd+"%' \n";
				else if(s_kd.equals("2"))		r_query += " a.enp_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("3"))		r_query += " upper(a.rent_l_cd) like upper('%"+t_wd+"%') \n";
				else if(s_kd.equals("4"))		r_query += " a.car_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("5"))		r_query += " a.car_nm||a.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("6"))		r_query += " a.bus_nm like '%"+t_wd+"%'\n";
				else if(s_kd.equals("7"))		r_query += " a.bus_nm2 like '%"+t_wd+"%'\n";
				else if(s_kd.equals("8"))		r_query += " a.ins_exp_dt like '"+t_wd+"%'\n";
			}
			if(gubun3.equals("2")){
				r_query += " ORDER BY cont_com_emp_yn,a.ins_start_dt, a.ins_exp_dt, a.enp_no, a.rent_start_dt, a.car_mng_id \n";
			}else{
				r_query += " ORDER BY a.ins_start_dt, a.ins_exp_dt, a.enp_no, a.rent_start_dt, a.car_mng_id \n";
			}
			
			
		try {
				pstmt = conn.prepareStatement(r_query);
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

			//System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);

		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsComempNotStatList]"+ e);
			System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);
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
	
	//업무전용보험미가입현황
	public Vector getInsTaskNotStatList(String s_kd, String t_wd, String gubun1, String gubun2,String st_dt, String end_dt,String gubun3,String gubun4,String gubun5)
{
	getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Vector vt = new Vector();
	String query = "";
	String r_query = "";

	query = " --업무전용보험미가입현황 대상 계약 리스트 - 개인사업자 \n"+
            " SELECT \n"+
            "        '1' st, b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.rent_start_dt, b.rent_end_dt, d.car_no, m.car_nm, c.car_name,  \n"+
			"        g.enp_no, g.client_id, TEXT_DECRYPT(g.ssn, 'pw' )  ssn , g.firm_nm, j.user_nm bus_nm, k.user_nm bus_nm2, b.bus_id, b.bus_id2, \n"+
			"        l.ins_start_dt, l.ins_exp_dt, g.con_agnt_email, n.ins_com_nm, l.ins_st, \n"+
			"        decode(a.com_emp_yn,'Y','가입','N','미가입','선택') cont_com_emp_yn,  \n"+
			"        decode(l.com_emp_yn,'Y','가입','N','미가입','미가입') ins_com_emp_yn, l.firm_emp_nm  \n"+
			" from   cont b, car_reg d, car_etc e, car_nm c, client g, sui i, users j, users k, (select * from insur where ins_sts='1') l, cont_etc a, car_mng m, ins_com n \n"+
			" where \n"+
			"        nvl(b.use_yn,'Y')='Y' \n";
	if(s_kd.equals("9")){ query += " AND b.car_st IN ('5')  \n"; }
	else{ query += " AND b.car_st IN ('1','3','4','5') AND g.client_st NOT iN ('1','2')  \n"; }
	query +="        and (to_number(replace(d.dpm,' ','')) > 1000  OR d.fuel_kd IN ('7','8','9','10') )  \n"+
            "        and d.taking_p < 9 \n"+
            "        and c.car_name not like '%9인승%' \n"+
			"        and c.s_st < '600' \n"+
			"        and b.car_mng_id=d.car_mng_id \n"+
			"        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd \n"+
			"        and e.car_id=c.CAR_ID and e.car_seq=c.car_seq and c.car_comp_id=m.car_comp_id and c.car_cd=m.code \n"+
			"        and b.client_id=g.client_id \n"+
			"        and b.car_mng_id=i.car_mng_id(+) and i.car_mng_id is NULL \n"+
			"        and b.bus_id=j.user_id and b.bus_id2=k.user_id \n"+
			"        and d.car_mng_id=l.car_mng_id \n"+
		    "        AND l.ins_com_id=n.ins_com_id(+) \n"+
			"        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
			"        and g.client_id <> '055862' \n";
	if(gubun2.equals("D")){
			query += "AND decode(l.com_emp_yn,'Y','가입','N','미가입','선택') ='가입' \n"+
					 "AND decode(a.com_emp_yn,'Y','가입','N','미가입','미가입') ='미가입' \n"+
					 " ";
	}else if(gubun2.equals("N") || gubun2.equals("Y")){
		query += "   and nvl(l.com_emp_yn,'N')='"+gubun2+"' \n"+
			" "; 
	}
	
	 if(gubun4.equals("N") || gubun4.equals("Y") || gubun4.equals("S")){
			query += "   and nvl(a.com_emp_yn,'S')='"+gubun4+"' \n"+
				" "; 
		}
	 
	 if(!gubun5.equals("")){
			query += "   and l.ins_com_id = '"+gubun5+"' \n"+
				" "; 
		}

		r_query = " select a.*,  count(*) over(PARTITION BY  enp_no ) AS cnt  from ("+query+") a \n";

		
		if(gubun1.equals("1"))		r_query += " where a.ins_exp_dt between to_char(sysdate-30,'YYYYMMDD') and to_char(sysdate+30,'YYYYMMDD') \n";
		if(gubun1.equals("2"))		r_query += " where a.ins_exp_dt like to_char(sysdate,'YYYYMM')||'%' \n";
		if(gubun1.equals("3"))		r_query += " where a.ins_exp_dt like to_char(add_months(sysdate,1), 'YYYYMM')||'%' \n";
		if(gubun1.equals("4"))		r_query += " where a.ins_exp_dt between to_char(sysdate-15,'YYYYMMDD') and to_char(sysdate+15,'YYYYMMDD') \n";
		if(gubun1.equals("5"))		r_query += " where a.ins_exp_dt like to_char(sysdate, 'YYYY')||'%' \n";
		if(gubun1.equals("6"))		{
			if(!st_dt.equals("") && end_dt.equals(""))	r_query += " where a.ins_exp_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) r_query += " where a.ins_exp_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}


		if(gubun1.equals("") && !t_wd.equals(""))	r_query += " where ";
		if(!gubun1.equals("") && !t_wd.equals(""))	r_query += " and ";


		if(!t_wd.equals("")){
			if(s_kd.equals("1"))			r_query += " a.firm_nm like '%"+t_wd+"%' \n";
			else if(s_kd.equals("2"))		r_query += " a.enp_no like '%"+t_wd+"%' \n";
			else if(s_kd.equals("3"))		r_query += " upper(a.rent_l_cd) like upper('%"+t_wd+"%') \n";
			else if(s_kd.equals("4"))		r_query += " a.car_no like '%"+t_wd+"%' \n";
			else if(s_kd.equals("5"))		r_query += " a.car_nm||a.car_name like '%"+t_wd+"%'\n";
			else if(s_kd.equals("6"))		r_query += " a.bus_nm like '%"+t_wd+"%'\n";
			else if(s_kd.equals("7"))		r_query += " a.bus_nm2 like '%"+t_wd+"%'\n";
			else if(s_kd.equals("8"))		r_query += " a.ins_exp_dt like '"+t_wd+"%'\n";
		}
		
		if(gubun3.equals("3")){
			r_query += " ORDER BY a.ins_start_dt, a.ins_exp_dt, a.enp_no, a.rent_start_dt, a.car_mng_id \n";
		}else if(gubun3.equals("2")){
			r_query += " ORDER BY cont_com_emp_yn,a.ins_start_dt, a.ins_exp_dt, a.enp_no, a.rent_start_dt, a.car_mng_id \n";
		}else{
			r_query += " ORDER BY cnt desc, a.firm_nm \n";
		}
		
	try {
			pstmt = conn.prepareStatement(r_query);
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

		//System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);

	} catch (SQLException e) {
		
		System.out.println("[InsDatabase:getInsComempNotStatList]"+ e);
		System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);
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
	
	//보험현황-갱신예정
	public Hashtable getInsTaskNotStat(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " --업무전용보험미가입현황 대상 계약 리스트 - 개인사업자 \n"+
	            " SELECT \n"+
	            "        '1' st, b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.rent_start_dt, b.rent_end_dt, d.car_no, m.car_nm, c.car_name,  \n"+
				"        g.enp_no, g.client_id, TEXT_DECRYPT(g.ssn, 'pw' )  ssn , g.firm_nm, j.user_nm bus_nm, k.user_nm bus_nm2, b.bus_id, b.bus_id2, \n"+
				"        l.ins_start_dt, l.ins_exp_dt, g.con_agnt_email, n.ins_com_nm, l.ins_st, \n"+
				"        decode(a.com_emp_yn,'Y','가입','N','미가입','미가입') cont_com_emp_yn,  \n"+
				"        decode(l.com_emp_yn,'Y','가입','N','미가입','미가입') ins_com_emp_yn, l.firm_emp_nm  \n"+
				" from   cont b, car_reg d, car_etc e, car_nm c, client g, sui i, users j, users k, (select * from insur where ins_sts='1') l, cont_etc a, car_mng m, ins_com n \n"+
				" where  nvl(b.use_yn,'Y')='Y' \n"+
				" 		 and b.car_st IN ('1','3','4','5') AND g.client_st NOT iN ('1','2')  \n"+
				"        and (to_number(replace(d.dpm,' ','')) > 1000  OR d.fuel_kd IN ('7','8','9','10') )  \n"+
	            "        and d.taking_p < 9 \n"+
	            "        and c.car_name not like '%9인승%' \n"+
				"        and c.s_st < '600' \n"+
				"        and d.car_mng_id = '"+car_mng_id+"' \n"+
				"        and b.car_mng_id=d.car_mng_id \n"+
				"        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=c.CAR_ID and e.car_seq=c.car_seq and c.car_comp_id=m.car_comp_id and c.car_cd=m.code \n"+
				"        and b.client_id=g.client_id \n"+
				"        and b.car_mng_id=i.car_mng_id(+) and i.car_mng_id is NULL \n"+
				"        and b.bus_id=j.user_id and b.bus_id2=k.user_id \n"+
				"        and d.car_mng_id=l.car_mng_id \n"+
			    "        AND l.ins_com_id=n.ins_com_id(+) \n"+
				"        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
				"        and g.client_id <> '055862' \n";
		
			
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

			System.out.println("[InsEtcDatabase:getInsStat_excel]"+ query);
			System.out.println("[InsEtcDatabase:getInsStat_excel]"+ e);
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
	
	
	
	//보험현황-갱신예정리스트3
	public Vector getInsComempNotStatList3(String s_kd, String t_wd, String gubun1, String gubun2,String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " --임직원운전한정특약 대상 계약 리스트 - 법인고객 \n"+
                " SELECT \n"+
                "        '1' st, b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.rent_start_dt, b.rent_end_dt, d.car_no, m.car_nm, c.car_name, l.ins_con_no, \n"+
				"        g.enp_no, g.client_id, TEXT_DECRYPT(g.ssn, 'pw' ) ssn , g.firm_nm, j.user_nm bus_nm, k.user_nm bus_nm2, b.bus_id, b.bus_id2, \n"+
				"        l.ins_start_dt, l.ins_exp_dt, g.con_agnt_email, n.ins_com_nm, \n"+
				"        decode(a.com_emp_yn,'Y','가입','N','미가입','') cont_com_emp_yn,  \n"+
				"        decode(l.com_emp_yn,'Y','가입','N','미가입','') ins_com_emp_yn ,a.com_emp_sac_dt  \n"+
				" from   cont b, car_reg d, car_etc e, car_nm c, client g, sui i, users j, users k, (select * from insur where ins_sts='1') l, cont_etc a, car_mng m, ins_com n \n"+
				" where \n"+
				"        nvl(b.use_yn,'Y')='Y'  \n";
			if(s_kd.equals("9")){ query += " AND b.car_st IN ('5')  \n"; }
			else{ query += " AND b.car_st IN ('1','3','5') AND g.client_st='1'  \n"; }
		query +="        and to_number(replace(d.dpm,' ','')) > 1000 \n"+
                "        and d.taking_p < 9 \n"+
                "        and c.car_name not like '%9인승%' \n"+
				"        and c.s_st < '600' \n"+
				"        and b.car_mng_id=d.car_mng_id \n"+
				"        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=c.CAR_ID and e.car_seq=c.car_seq and c.car_comp_id=m.car_comp_id and c.car_cd=m.code \n"+
				"        and b.client_id=g.client_id \n"+
				"        and b.car_mng_id=i.car_mng_id(+) and i.car_mng_id is NULL \n"+
				"        and b.bus_id=j.user_id and b.bus_id2=k.user_id \n"+
				"        and d.car_mng_id=l.car_mng_id \n"+
			    "        AND l.ins_com_id=n.ins_com_id(+) \n"+
				"        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n";
		if(gubun2.equals("D")){
				query += "AND decode(l.com_emp_yn,'Y','가입','N','미가입','') ='가입' \n"+
						 "AND decode(a.com_emp_yn,'Y','가입','N','미가입','') ='미가입' \n"+
						 "AND n.ins_com_nm='렌터카공제조합' \n"+
						 "AND a.com_emp_sac_id is not null \n"+
					     "  ";
		}else{
			query += "   and nvl(l.com_emp_yn,'N')='"+gubun2+"' \n"+
				" "; 
		}
			

			r_query = " select a.* from ("+query+") a \n";

			
			if(gubun1.equals("1"))		r_query += " where a.ins_exp_dt between to_char(sysdate-30,'YYYYMMDD') and to_char(sysdate+30,'YYYYMMDD') \n";
			if(gubun1.equals("2"))		r_query += " where a.ins_exp_dt like to_char(sysdate,'YYYYMM')||'%' \n";
			if(gubun1.equals("3"))		r_query += " where a.ins_exp_dt like to_char(add_months(sysdate,1), 'YYYYMM')||'%' \n";
			if(gubun1.equals("4"))		r_query += " where a.ins_exp_dt between to_char(sysdate-15,'YYYYMMDD') and to_char(sysdate+15,'YYYYMMDD') \n";
			if(gubun1.equals("5"))		r_query += " where a.ins_exp_dt like to_char(sysdate, 'YYYY')||'%' \n";
			if(gubun1.equals("6"))		{
				if(!st_dt.equals("") && end_dt.equals(""))	r_query += " where a.ins_exp_dt like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) r_query += " where a.ins_exp_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}


			if(gubun1.equals("") && !t_wd.equals(""))	r_query += " where ";
			if(!gubun1.equals("") && !t_wd.equals(""))	r_query += " and ";


			if(!t_wd.equals("")){
				if(s_kd.equals("1"))			r_query += " a.firm_nm like '%"+t_wd+"%' \n";
				else if(s_kd.equals("2"))		r_query += " a.enp_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("3"))		r_query += " upper(a.rent_l_cd) like upper('%"+t_wd+"%') \n";
				else if(s_kd.equals("4"))		r_query += " a.car_no like '%"+t_wd+"%' \n";
				else if(s_kd.equals("5"))		r_query += " a.car_nm||a.car_name like '%"+t_wd+"%'\n";
				else if(s_kd.equals("6"))		r_query += " a.bus_nm like '%"+t_wd+"%'\n";
				else if(s_kd.equals("7"))		r_query += " a.bus_nm2 like '%"+t_wd+"%'\n";
				else if(s_kd.equals("8"))		r_query += " a.ins_exp_dt like '"+t_wd+"%'\n";
			}

			r_query += " ORDER BY a.ins_start_dt, a.ins_exp_dt, a.enp_no, a.rent_start_dt, a.car_mng_id \n";

			
		try {
				pstmt = conn.prepareStatement(r_query);
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

//			System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);

		} catch (SQLException e) {
			
			System.out.println("[InsDatabase:getInsComempNotStatList]"+ e);
			System.out.println("[InsDatabase:getInsComempNotStatList]"+ r_query);
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



	//임직원운전한정특약관리현황
	public Vector getInsComempStatList(String gubun1, String gubun2, String st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " SELECT TRUNC(TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD'),'YYYYMMDD')-TO_DATE(l.ins_exp_dt,'YYYYMMDD')) days, l.ins_exp_dt, \n"+
				"        DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2') client_st, a.com_emp_yn, a.com_emp_sac_id, NVL(h.scan_cnt,0) scan_cnt \n"+
				" FROM   CONT b, CAR_REG d, CAR_ETC e, CAR_NM c, CLIENT g, SUI i, (select * from insur where ins_sts='1') l, cont_etc a, users f, users f2, \n"+
                "        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) scan_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='LC_SCAN' AND SUBSTR(content_seq,21) IN ('40','41') group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h \n"+
                " WHERE  nvl(b.use_yn,'Y')='Y' AND b.car_st IN ('1','3','5') \n"+
                "        AND b.car_mng_id=d.car_mng_id \n"+
                "        and to_number(replace(d.dpm,' ','')) > 1000 \n"+
                "        and d.taking_p < 9 \n"+
                "        AND b.rent_mng_id=e.rent_mng_id AND b.rent_l_cd=e.rent_l_cd \n"+
                "        AND e.car_id=c.car_id AND e.CAR_seq=c.car_seq \n"+
                "        and c.car_name not like '%9인승%' \n"+
				"        and c.s_st < '600' \n"+
                "        and b.client_id=g.client_id \n"+
                "        and d.car_mng_id=i.car_mng_id(+) AND i.car_mng_id IS NULL \n"+
                "        AND d.car_mng_id=l.car_mng_id \n"+
                "        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
                "        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) \n"+
				"        and b.bus_id=f.user_id "+
				"        and b.bus_id2=f2.user_id "+
				" ";

		if(!gubun1.equals("")) query += " and b.brch_id='"+gubun1+"' \n";
		if(!gubun2.equals("")) query += " and f.user_nm||f2.user_nm like '%"+gubun2+"%' \n";

		//D-10 부터 D-day 까지
		if(st.equals(""))		query += " AND l.ins_exp_dt <= TO_CHAR(SYSDATE+10,'YYYYMMDD') \n";

		//D+1이상
	    if(st.equals("etc"))	query += " AND l.ins_exp_dt > TO_CHAR(SYSDATE+10,'YYYYMMDD') \n";

				

		r_query = " SELECT \n";

		if(st.equals(""))		r_query += " days, ins_exp_dt, \n";
		if(st.equals("etc"))	r_query += " 'D+1일 이상 경과' days, '' ins_exp_dt, \n";

		r_query +=  "       COUNT(DECODE(client_st,'1',DECODE(com_emp_yn,'Y',ins_exp_dt))) client_1_emp_y_cnt, \n"+
					"       COUNT(DECODE(client_st,'1',DECODE(com_emp_yn,'Y',DECODE(scan_cnt,0,'',ins_exp_dt)))) client_1_emp_y_scan_y_cnt, \n"+
					"       COUNT(DECODE(client_st,'1',DECODE(com_emp_yn,'Y',DECODE(scan_cnt,0,ins_exp_dt)))) client_1_emp_y_scan_n_cnt, \n"+
					"       COUNT(DECODE(client_st,'1',DECODE(com_emp_yn,'N',ins_exp_dt))) client_1_emp_n_cnt, \n"+
					"       COUNT(DECODE(client_st,'1',DECODE(com_emp_yn,'N',DECODE(scan_cnt,0,'',ins_exp_dt)))) client_1_emp_n_scan_y_cnt, \n"+
					"       COUNT(DECODE(client_st,'1',DECODE(com_emp_yn,'N',DECODE(scan_cnt,0,ins_exp_dt)))) client_1_emp_n_scan_n_cnt, \n"+
					"       COUNT(DECODE(client_st,'1',DECODE(com_emp_yn,'N',DECODE(com_emp_sac_id,'','',ins_exp_dt)))) client_1_emp_n_sac_y_cnt, \n"+
					"       COUNT(DECODE(client_st,'1',DECODE(com_emp_yn,'N',DECODE(com_emp_sac_id,'',ins_exp_dt)))) client_1_emp_n_sac_n_cnt, \n"+
					"       COUNT(DECODE(client_st,'1',DECODE(com_emp_yn,'',ins_exp_dt))) client_1_emp_null_cnt, \n"+
					"       COUNT(DECODE(client_st,'2',DECODE(com_emp_yn,'Y',ins_exp_dt))) client_2_emp_y_cnt, \n"+
					"       COUNT(DECODE(client_st,'2',DECODE(com_emp_yn,'N',ins_exp_dt))) client_2_emp_n_cnt, \n"+
					"       COUNT(DECODE(client_st,'2',DECODE(com_emp_yn,'',ins_exp_dt))) client_2_emp_null_cnt, \n"+
					"       COUNT(0) cnt  \n"+
					" FROM   ( "+query+")  \n";

		if(st.equals(""))		r_query += " GROUP BY days, ins_exp_dt order by days";


		try {
			pstmt = conn.prepareStatement(r_query);
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
			
			System.out.println("[InsDatabase:getInsComempStatList]"+ e);
			System.out.println("[InsDatabase:getInsComempStatList]"+ r_query);
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

	//임직원운전한정특약관리현황
	public Vector getInsComempStatSubList(String gubun1, String gubun2, String ins_exp_dt, String s_stat)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " SELECT TRUNC(TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD'),'YYYYMMDD')-TO_DATE(l.ins_exp_dt,'YYYYMMDD')) days, l.ins_exp_dt, \n"+
				"        DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2') client_st, a.com_emp_yn, a.com_emp_sac_id, a.com_emp_sac_dt, NVL(h.scan_cnt,0) scan_cnt, \n"+
				"        b.rent_mng_id, b.rent_l_cd, d.car_no, d.car_nm, g.firm_nm, f.user_nm as bus_nm, f2.user_nm as bus_nm2 \n"+
				" FROM   CONT b, CAR_REG d, CAR_ETC e, CAR_NM c, CLIENT g, SUI i, (select * from insur where ins_sts='1') l, cont_etc a, users f, users f2, \n"+
                "        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) scan_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='LC_SCAN' AND SUBSTR(content_seq,21) IN ('40','41') group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h \n"+
                " WHERE  nvl(b.use_yn,'Y')='Y' AND b.car_st IN ('1','3','5') \n"+
                "        AND b.car_mng_id=d.car_mng_id \n"+
                "        and to_number(replace(d.dpm,' ','')) > 1000 \n"+
                "        and d.taking_p < 9 \n"+
                "        AND b.rent_mng_id=e.rent_mng_id AND b.rent_l_cd=e.rent_l_cd \n"+
                "        AND e.car_id=c.car_id AND e.CAR_seq=c.car_seq \n"+
                "        and c.car_name not like '%9인승%' \n"+
				"        and c.s_st < '600' \n"+
                "        and b.client_id=g.client_id \n"+
                "        and d.car_mng_id=i.car_mng_id(+) AND i.car_mng_id IS NULL \n"+
                "        AND d.car_mng_id=l.car_mng_id \n"+
                "        and b.rent_mng_id=a.rent_mng_id and b.rent_l_cd=a.rent_l_cd \n"+
                "        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) \n"+
				"        and b.bus_id=f.user_id "+
				"        and b.bus_id2=f2.user_id "+
				" ";

		if(!gubun1.equals(""))		query += " and b.brch_id='"+gubun1+"' \n";
		if(!gubun2.equals(""))		query += " and f.user_nm||f2.user_nm like '%"+gubun2+"%' \n";
		if(!ins_exp_dt.equals(""))	query += " and l.ins_exp_dt='"+ins_exp_dt+"' \n";

		if(s_stat.equals("CLIENT_1_EMP_Y_CNT"))				query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='1' and a.com_emp_yn='Y' \n";
		if(s_stat.equals("CLIENT_1_EMP_Y_SCAN_Y_CNT"))		query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='1' and a.com_emp_yn='Y' and NVL(h.scan_cnt,0)>0 \n";
		if(s_stat.equals("CLIENT_1_EMP_Y_SCAN_N_CNT"))		query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='1' and a.com_emp_yn='Y' and NVL(h.scan_cnt,0)=0  \n";
		if(s_stat.equals("CLIENT_1_EMP_N_CNT"))				query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='1' and a.com_emp_yn='N' \n";
		if(s_stat.equals("CLIENT_1_EMP_N_SCAN_Y_CNT"))		query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='1' and a.com_emp_yn='N' and NVL(h.scan_cnt,0)>0 \n";
		if(s_stat.equals("CLIENT_1_EMP_N_SCAN_N_CNT"))		query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='1' and a.com_emp_yn='N' and NVL(h.scan_cnt,0)=0 \n";
		if(s_stat.equals("CLIENT_1_EMP_N_SAC_Y_CNT"))		query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='1' and a.com_emp_yn='N' and a.com_emp_sac_id is not null \n";
		if(s_stat.equals("CLIENT_1_EMP_N_SAC_N_CNT"))		query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='1' and a.com_emp_yn='N' and a.com_emp_sac_id is null \n";
		if(s_stat.equals("CLIENT_1_EMP_NULL_CNT"))			query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='1' and a.com_emp_yn is null \n";
		if(s_stat.equals("CLIENT_2_EMP_Y_CNT"))				query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='2' and a.com_emp_yn='Y' \n";
		if(s_stat.equals("CLIENT_2_EMP_N_CNT"))				query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='2' and a.com_emp_yn='N' \n";
		if(s_stat.equals("CLIENT_2_EMP_NULL_CNT"))			query += " and DECODE(decode(b.car_st,'5','1',g.client_st),'1','1','2')='2' and a.com_emp_yn is null \n";

		query += " order by l.ins_exp_dt, g.firm_nm, d.car_no \n";

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
			
			System.out.println("[InsDatabase:getInsComempStatSubList]"+ e);
			System.out.println("[InsDatabase:getInsComempStatSubList]"+ query);
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
