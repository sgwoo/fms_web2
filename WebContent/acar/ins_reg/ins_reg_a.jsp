<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.*, acar.util.*, acar.common.*,  acar.im_email.*, tax.*, acar.bill_mng.*, acar.user_mng.*"%>
<%@ page import="acar.insur.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>

<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	String ins_st 	= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	String ins_c_id = request.getParameter("ins_c_id")==null?"":request.getParameter("ins_c_id");
	String reg_cau 	= request.getParameter("reg_cau")==null?"":request.getParameter("reg_cau");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String ins_start_dt = request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt");
	String r_ins_start_dt = request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt");
	String ins_com_nm = request.getParameter("ins_com_nm")==null?"":request.getParameter("ins_com_nm");
	String car_use = request.getParameter("car_use")==null?"":request.getParameter("car_use");
	
	//���� ����
	String ins_com_id  = request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id");
	String gov_nm = request.getParameter("gov_nm")==null?"":request.getParameter("gov_nm");
		
	 Date d = new Date();
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	 String sysdate =   sdf.format(d);	
	
	int flag = 0;
	int tot_amt = 0;
	
	//�ߺ��Է� üũ-----------------------------------------------------
//	int over_cnt = ai_db.getCheckOverInsDt(car_no, ins_start_dt);
	int over_cnt = 0;
	
	//out.println("over_cnt:"+over_cnt);
		

	if(over_cnt == 0){
		//����-���� => ������ ���� ó��
		if(!ins_st.equals("0") && reg_cau.equals("4")){
			if(!ai_db.changeInsSts(c_id, AddUtil.parseInt(ins_st)-1, "2"))	flag += 1;
		}
		//����-�ߵ����� => ������ �ߵ����� ó��
		if(!ins_st.equals("0") && (reg_cau.equals("2")||reg_cau.equals("3")||reg_cau.equals("5")) ){
			if(!ai_db.changeInsSts(c_id, AddUtil.parseInt(ins_st)-1, "3"))	flag += 1;
		}
		
		//out.println("c_id:"+c_id);
		//out.println("ins_st:"+ins_st);
		//if(1==1)return;
		
		InsurBean ins = new InsurBean();
		
		ins.setCar_mng_id	(c_id);
		ins.setIns_st		(ins_st);
		ins.setIns_sts		("1");	//1:��ȿ, 2:����, 3:�ߵ�����, 4:������������
		ins.setIns_com_id	(request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id"));
		ins.setIns_con_no	(request.getParameter("ins_con_no")==null?"":request.getParameter("ins_con_no"));
		ins.setConr_nm		(request.getParameter("conr_nm")==null?"":request.getParameter("conr_nm"));
		ins.setCon_f_nm		(request.getParameter("con_f_nm")==null?"":request.getParameter("con_f_nm"));
		ins.setIns_rent_dt	(request.getParameter("ins_rent_dt")==null?"":request.getParameter("ins_rent_dt"));
		ins.setIns_start_dt	(request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt"));
		ins.setIns_exp_dt	(request.getParameter("ins_exp_dt")==null?"":request.getParameter("ins_exp_dt"));
		ins.setCar_use		(request.getParameter("car_use")==null?"":request.getParameter("car_use"));
		ins.setAge_scp		(request.getParameter("age_scp")==null?"":request.getParameter("age_scp"));
		ins.setAir_ds_yn	(request.getParameter("air_ds_yn")==null?"N":request.getParameter("air_ds_yn"));
		ins.setAir_as_yn	(request.getParameter("air_as_yn")==null?"N":request.getParameter("air_as_yn"));
		ins.setCar_rate		(request.getParameter("car_rate")==null?"":request.getParameter("car_rate"));
		ins.setExt_rate		(request.getParameter("ext_rate")==null?"":request.getParameter("ext_rate"));
		
		ins.setRins_pcp_amt	(request.getParameter("rins_pcp_amt")==null?0:Util.parseDigit(request.getParameter("rins_pcp_amt")));
		ins.setVins_pcp_kd	(request.getParameter("vins_pcp_kd")==null?"":request.getParameter("vins_pcp_kd"));
		ins.setVins_pcp_amt	(request.getParameter("vins_pcp_amt")==null?0:Util.parseDigit(request.getParameter("vins_pcp_amt")));
		ins.setVins_gcp_kd	(request.getParameter("vins_gcp_kd")==null?"":request.getParameter("vins_gcp_kd"));
		ins.setVins_gcp_amt	(request.getParameter("vins_gcp_amt")==null?0:Util.parseDigit(request.getParameter("vins_gcp_amt")));
		ins.setVins_bacdt_kd	(request.getParameter("vins_bacdt_kd")==null?"":request.getParameter("vins_bacdt_kd"));
		ins.setVins_bacdt_kc2	(request.getParameter("vins_bacdt_kc2")==null?"":request.getParameter("vins_bacdt_kc2"));
		ins.setVins_bacdt_amt	(request.getParameter("vins_bacdt_amt")==null?0:Util.parseDigit(request.getParameter("vins_bacdt_amt")));
//	ins.setVins_canoisr_kd	(request.getParameter("vins_canoisr_kd")==null?0:request.getParameter("vins_canoisr_kd"));
		ins.setVins_canoisr_amt	(request.getParameter("vins_canoisr_amt")==null?0:Util.parseDigit(request.getParameter("vins_canoisr_amt")));
		ins.setVins_cacdt_car_amt(request.getParameter("vins_cacdt_car_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_car_amt")));
		ins.setVins_cacdt_me_amt(request.getParameter("vins_cacdt_me_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_me_amt")));
		ins.setVins_cacdt_cm_amt(request.getParameter("vins_cacdt_cm_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_cm_amt")));
		ins.setVins_cacdt_amt	(request.getParameter("vins_cacdt_cm_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_cm_amt")));
		ins.setVins_spe		(request.getParameter("vins_spe")==null?"":request.getParameter("vins_spe"));
		ins.setVins_spe_amt	(request.getParameter("vins_spe_amt")==null?0:Util.parseDigit(request.getParameter("vins_spe_amt")));
		ins.setPay_tm		(request.getParameter("pay_tm")==null?"":request.getParameter("pay_tm"));
		ins.setEnable_renew	("Y");
		ins.setReg_id		(user_id);
		ins.setIns_kd		(request.getParameter("ins_kd")==null?"":request.getParameter("ins_kd"));
		ins.setReg_cau		(reg_cau);
		ins.setAuto_yn		(request.getParameter("auto_yn")==null?"N":request.getParameter("auto_yn"));
		ins.setAbs_yn		(request.getParameter("abs_yn")==null?"N":request.getParameter("abs_yn"));
		ins.setVins_cacdt_memin_amt	(request.getParameter("vins_cacdt_memin_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_memin_amt")));
		ins.setVins_cacdt_mebase_amt	(request.getParameter("vins_cacdt_mebase_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_mebase_amt")));
		ins.setBlackbox_yn		(request.getParameter("blackbox_yn")==null?"N":request.getParameter("blackbox_yn"));
		ins.setVins_share_extra_amt	(request.getParameter("vins_share_extra_amt")==null?0:Util.parseDigit(request.getParameter("vins_share_extra_amt")));
		ins.setVins_blackbox_amt	(request.getParameter("vins_blackbox_amt")==null?0:Util.parseDigit(request.getParameter("vins_blackbox_amt")));
		ins.setVins_blackbox_per	(request.getParameter("vins_blackbox_per")==null?"N":request.getParameter("vins_blackbox_per"));
		ins.setCom_emp_yn		(request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn"));
		ins.setFirm_emp_nm		(request.getParameter("firm_emp_nm")==null?"":request.getParameter("firm_emp_nm"));
		ins.setLong_emp_yn		(request.getParameter("long_emp_yn")==null?"":request.getParameter("long_emp_yn"));
		
		ins.setBlackbox_nm		(request.getParameter("blackbox_nm")==null?"":request.getParameter("blackbox_nm"));
		ins.setBlackbox_amt		(request.getParameter("blackbox_amt")==null?0:Util.parseDigit(request.getParameter("blackbox_amt")));
		ins.setBlackbox_no		(request.getParameter("blackbox_no")==null?"":request.getParameter("blackbox_no"));
		ins.setBlackbox_dt		(request.getParameter("blackbox_dt")==null?"":request.getParameter("blackbox_dt"));
		ins.setEnp_no		(request.getParameter("enp_no")==null?"":request.getParameter("enp_no"));
		ins.setLkas_yn		(request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn"));
		ins.setLdws_yn		(request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn"));
		ins.setAeb_yn		(request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn"));
		ins.setFcw_yn		(request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn"));
		ins.setEv_yn		(request.getParameter("ev_yn")==null?"":request.getParameter("ev_yn"));
		ins.setOthers		(request.getParameter("others")==null?"":request.getParameter("others"));
		ins.setOthers_device		(request.getParameter("others_device")==null?"":request.getParameter("others_device"));
		ins.setHook_yn		(request.getParameter("hook_yn")==null?"N":request.getParameter("hook_yn"));
		ins.setLegal_yn		(request.getParameter("legal_yn")==null?"N":request.getParameter("legal_yn"));

		String ex_ins_st =  String.valueOf(Integer.parseInt(ins_st)- 1);
		String ins_ext_dt = ins.getIns_start_dt().replaceAll("-","");
		if(ins.getCom_emp_yn().equals("Y")){
			ins.setCom_emp_start_dt		(ins.getIns_start_dt());
			ins.setClient_nm		(client_id);
			
			// ins_com_emp_info �� �����Ͱ� �ִ��� Ȯ��			
			if(ai_db.getInsComEmpInfoCnt(c_id, ex_ins_st) > 0){
				//������ ����	
				
				if(!ai_db.updateInsComEmpInfo(c_id, ex_ins_st, ins_ext_dt, user_id ))	flag += 1;
			}
			if(!ai_db.insertInsComEmpInfo(ins))	flag += 1;
			
		}else{
			Hashtable insComEmpInfo = ai_db.getInsComEmpInfo2(c_id);
			String com_emp_ext_dt = String.valueOf(insComEmpInfo.get("COM_EMP_EXT_DT"));
			ex_ins_st = String.valueOf(insComEmpInfo.get("INS_ST"));
			if(com_emp_ext_dt.equals("null")){
				if(!ai_db.updateInsComEmpInfo(c_id, ex_ins_st, sysdate, user_id ))	flag += 1;
			}
		}
				
		
		if(!ai_db.insertIns(ins))	flag += 1;
		
		tot_amt = request.getParameter("tot_amt")==null?0:Util.parseDigit(request.getParameter("tot_amt"));

		
		if(flag==0 && tot_amt>0){
			//����� ������ ����
			int pay_tm = Util.parseDigit(request.getParameter("pay_tm"));
			
			//���轺����
			Vector ins_scd = ai_db.getInsScds(c_id, ins_st);
			int ins_scd_size = ins_scd.size();
			
			//1ȸ��-----------------------------------------------------------------------------------------------------
			InsurScdBean scd = new InsurScdBean();
			scd.setCar_mng_id(c_id);
			scd.setIns_st(ins_st);
			scd.setIns_tm(Integer.toString(ins_scd_size+1));
			ins_start_dt = request.getParameter("ins_rent_dt")==null?"":request.getParameter("ins_rent_dt");
//		if(AddUtil.parseInt(Util.replace(ins_start_dt,"-","")) > 20050206){//2005��2��7�Ϻ��ʹ� ������ 15�� ����
//		if(AddUtil.parseInt(Util.replace(ins_start_dt,"-","")) > 20090203){//2009��2��31�Ϻ��ʹ� ������ 10�� ����
			if(ins.getIns_com_id().equals("0008") || ins.getIns_com_id().equals("0038") || ins.getIns_com_id().equals("0007")){
				ins_start_dt = c_db.addMonth(ins_start_dt, 1);
				ins_start_dt = ins_start_dt.substring(0,8)+"10";
				scd.setIns_est_dt(ins_start_dt);
				scd.setR_ins_est_dt(ai_db.getValidDt(ins_start_dt));
				scd.setPay_dt("");
				scd.setPay_yn("0");
			}else{
				scd.setIns_est_dt(ins_start_dt);
				scd.setR_ins_est_dt(ins_start_dt);
				scd.setPay_dt(ins_start_dt);
				scd.setPay_yn("1");
			}
			if(pay_tm > 1){
				scd.setPay_amt(request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt")));
			}else{
				scd.setPay_amt(request.getParameter("tot_amt")==null?0:Util.parseDigit(request.getParameter("tot_amt")));
			}
			scd.setIns_tm2("0");
			
			if(!ai_db.insertInsScd(scd)) flag += 1;
			
			//2ȸ�г��� ���-----------------------------------------------------------------------------------------------------
			if(pay_tm == 2){
				int est_amt = Util.parseDigit(request.getParameter("tot_amt"))-Util.parseDigit(request.getParameter("pay_amt"));
				String ins_est_dt = request.getParameter("ins_est_dt")==null?"":request.getParameter("ins_est_dt");
				InsurScdBean scd2 = new InsurScdBean();
				scd2.setCar_mng_id(c_id);
				scd2.setIns_st(ins_st);
				scd2.setIns_tm(Integer.toString(ins_scd_size+2));
//			if(AddUtil.parseInt(Util.replace(ins_start_dt,"-","")) > 20050206){ //2005��2��7�Ϻ��ʹ� ������ 15�� ����}
//			if(AddUtil.parseInt(Util.replace(ins_start_dt,"-","")) > 20090203){ //2009��2��31�Ϻ��ʹ� ������ 10�� ����}
				if(ins.getIns_com_id().equals("0008") || ins.getIns_com_id().equals("0038") || ins.getIns_com_id().equals("0007")){
					ins_est_dt = c_db.addMonth(ins_est_dt, 1);
					ins_est_dt = ins_est_dt.substring(0,8)+"10";
					scd2.setIns_est_dt(ins_est_dt);
				}else{
					scd2.setIns_est_dt(ins_est_dt);
				}
				//������/�ָ��� ��� ������ ó��
				scd2.setR_ins_est_dt(ai_db.getValidDt(scd2.getIns_est_dt()));
				scd2.setPay_amt(est_amt);
				scd2.setPay_yn("0");
				scd2.setPay_dt("");
				scd2.setIns_tm2("0");
				
				if(!ai_db.insertInsScd(scd2)) flag += 1;
			}
			
			//2ȸ�̻�г��� ���-----------------------------------------------------------------------------------------------------
			if(pay_tm > 2){
				int est_amt = Util.parseDigit(request.getParameter("tot_amt"))-Util.parseDigit(request.getParameter("pay_amt"));
				int pay_amt = est_amt/pay_tm;
				String ins_est_dt = request.getParameter("ins_est_dt")==null?"":request.getParameter("ins_est_dt");
				ins_start_dt = c_db.addMonth(ins_start_dt, 1);
				ins_start_dt = ins_start_dt.substring(0,8)+"10";
				for(int i=2 ; i<=pay_tm; i++){//2ȸ����6ȸ����
					InsurScdBean scd2 = new InsurScdBean();
					scd2.setCar_mng_id(c_id);
					scd2.setIns_st(ins_st);
					scd2.setIns_tm(Integer.toString(ins_scd_size+i));
					if(i==2){
						scd2.setIns_est_dt(ins_est_dt);
					}else{
						if(pay_tm==4){
							scd2.setIns_est_dt(c_db.addMonth(ins_est_dt, i+1));
						}else{
							scd2.setIns_est_dt(c_db.addMonth(ins_est_dt, i-2));
						}
					}
					//������/�ָ��� ��� ������ ó��
					scd2.setR_ins_est_dt(ai_db.getValidDt(scd2.getIns_est_dt()));
					scd2.setPay_amt(pay_amt);
					scd2.setPay_yn("0");
					scd2.setPay_dt("");
					scd2.setIns_tm2("0");
					
					if(!ai_db.insertInsScd(scd2)) flag += 1;
				}
			}
			
			//���谡�� �ڵ���ǥ ����----------------------------------------------------------------------------
			
			
			//�ڵ���ǥó����
			Vector vt = new Vector();
			int line = 0;
			int count =0;
			String acct_cont = "";
			String acct_code = "";
			
			//���αԾ� �ϰ�� ���������� ����
			if(user_id.equals("000177")){
				user_id ="000130";
			}
			
			
			UsersBean user_bean 	= umd.getUsersBean(user_id);
			Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
			String insert_id = String.valueOf(per.get("SA_CODE"));
			String dept_code = String.valueOf(per.get("DEPT_CODE"));
	//		System.out.println("dept_code=" + dept_code);
						
			//�����
			Hashtable ins_com = ai_db.getInsCom(ins.getIns_com_id());
			
			//cont_view
			Hashtable cont = a_db.getContViewUseYCarCase(ins.getCar_mng_id());
			String rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
			String rent_l_cd 	= String.valueOf(cont.get("RENT_L_CD"));
			
			String car_num = String.valueOf(cont.get("CAR_NO"));
			String car_name = String.valueOf(cont.get("CAR_NM"));
			
			//�뿩�������޺����
			if(ins.getCar_use().equals("1")){
				acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " ������";
				acct_code = "13300";
			//�����������޺����
			}else{
				acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " ������";
				acct_code = "13200";
			}
			
			if(ins.getIns_st().equals("0")) 			acct_cont = acct_cont+ " �ű� ���� ("+car_no+")";
			else  							acct_cont = acct_cont+ " ���� ���� ("+car_no+")";
			
			line++;
			
			//���޺����
			Hashtable ht1 = new Hashtable();
			ht1.put("DATA_GUBUN", 	"53");
			ht1.put("WRITE_DATE", 	ins.getIns_rent_dt());
			ht1.put("DATA_NO",    	"");
			ht1.put("DATA_LINE",  	String.valueOf(line));
			ht1.put("DATA_SLIP",  	"1");
			ht1.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
			ht1.put("NODE_CODE",  	"S101");
			ht1.put("C_CODE",     	"1000");
			ht1.put("DATA_CODE",  	"");
			ht1.put("DOCU_STAT",  	"0");
			ht1.put("DOCU_TYPE",  	"11");
			ht1.put("DOCU_GUBUN", 	"3");
			ht1.put("AMT_GUBUN",  	"3");//����
			ht1.put("DR_AMT",    	request.getParameter("tot_amt")==null?0:Util.parseDigit(request.getParameter("tot_amt")));
			ht1.put("CR_AMT",     	"0");
			ht1.put("ACCT_CODE",  	acct_code);
			ht1.put("CHECK_CODE1",	"A19");//��ǥ��ȣ
			ht1.put("CHECK_CODE2",	"A07");//�ŷ�ó
			ht1.put("CHECK_CODE3",	"A05");//ǥ������
			ht1.put("CHECK_CODE4",	"");
			ht1.put("CHECK_CODE5",	"");
			ht1.put("CHECK_CODE6",	"");
			ht1.put("CHECK_CODE7",	"");
			ht1.put("CHECK_CODE8",	"");
			ht1.put("CHECK_CODE9",	"");
			ht1.put("CHECK_CODE10",	"");
			ht1.put("CHECKD_CODE1",	"");//��ǥ��ȣ
			ht1.put("CHECKD_CODE2",	String.valueOf(ins_com.get("VEN_CODE")));//�ŷ�ó
			ht1.put("CHECKD_CODE3",	"");//ǥ������
			ht1.put("CHECKD_CODE4",	"");
			ht1.put("CHECKD_CODE5",	"");
			ht1.put("CHECKD_CODE6",	"");
			ht1.put("CHECKD_CODE7",	"");
			ht1.put("CHECKD_CODE8",	"");
			ht1.put("CHECKD_CODE9",	"");
			ht1.put("CHECKD_CODE10","");
			ht1.put("CHECKD_NAME1",	"");//��ǥ��ȣ
			ht1.put("CHECKD_NAME2",	String.valueOf(ins_com.get("VEN_NAME")));//�ŷ�ó
			ht1.put("CHECKD_NAME3",	acct_cont);//ǥ������
			ht1.put("CHECKD_NAME4",	"");
			ht1.put("CHECKD_NAME5",	"");
			ht1.put("CHECKD_NAME6",	"");
			ht1.put("CHECKD_NAME7",	"");
			ht1.put("CHECKD_NAME8",	"");
			ht1.put("CHECKD_NAME9",	"");
			ht1.put("CHECKD_NAME10","");
			ht1.put("INSERT_ID",	insert_id);
			
			line++;
			
			//�����ޱ�
			Hashtable ht2 = new Hashtable();
			ht2.put("DATA_GUBUN", 	"53");
			ht2.put("WRITE_DATE", 	ins.getIns_rent_dt());
			ht2.put("DATA_NO",    	"");
			ht2.put("DATA_LINE",  	String.valueOf(line));
			ht2.put("DATA_SLIP",  	"1");
			ht2.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
			ht2.put("NODE_CODE",  	"S101");
			ht2.put("C_CODE",     	"1000");
			ht2.put("DATA_CODE",  	"");
			ht2.put("DOCU_STAT",  	"0");
			ht2.put("DOCU_TYPE",  	"11");
			ht2.put("DOCU_GUBUN", 	"3");
			ht2.put("AMT_GUBUN",  	"4");//�뺯
			ht2.put("DR_AMT",    	"0");
			ht2.put("CR_AMT",     	request.getParameter("tot_amt")==null?0:Util.parseDigit(request.getParameter("tot_amt")));
			ht2.put("ACCT_CODE",  	"25300");
			ht2.put("CHECK_CODE1",	"A07");//�ŷ�ó
			ht2.put("CHECK_CODE2",	"A19");//��ǥ��ȣ
			ht2.put("CHECK_CODE3",	"F47");//�ſ�ī���ȣ
			ht2.put("CHECK_CODE4",	"A13");//project
			ht2.put("CHECK_CODE5",	"A05");//ǥ������
			ht2.put("CHECK_CODE6",	"");
			ht2.put("CHECK_CODE7",	"");
			ht2.put("CHECK_CODE8",	"");
			ht2.put("CHECK_CODE9",	"");
			ht2.put("CHECK_CODE10",	"");
			ht2.put("CHECKD_CODE1",	String.valueOf(ins_com.get("VEN_CODE")));//�ŷ�ó
			ht2.put("CHECKD_CODE2",	"");//��ǥ��ȣ
			ht2.put("CHECKD_CODE3",	"");//�ſ�ī���ȣ
			ht2.put("CHECKD_CODE4",	"");//project
			ht2.put("CHECKD_CODE5",	"0");//ǥ������
			ht2.put("CHECKD_CODE6",	"");
			ht2.put("CHECKD_CODE7",	"");
			ht2.put("CHECKD_CODE8",	"");
			ht2.put("CHECKD_CODE9",	"");
			ht2.put("CHECKD_CODE10","");
			ht2.put("CHECKD_NAME1",	String.valueOf(ins_com.get("VEN_NAME")));//�ŷ�ó
			ht2.put("CHECKD_NAME2",	"");//��ǥ��ȣ
			ht2.put("CHECKD_NAME3",	"");//�ſ�ī���ȣ
			ht2.put("CHECKD_NAME4",	"");//project
			ht2.put("CHECKD_NAME5",	acct_cont);//ǥ������
			ht2.put("CHECKD_NAME6",	"");
			ht2.put("CHECKD_NAME7",	"");
			ht2.put("CHECKD_NAME8",	"");
			ht2.put("CHECKD_NAME9",	"");
			ht2.put("CHECKD_NAME10","");
			ht2.put("INSERT_ID",	insert_id);
			
			vt.add(ht1);
			vt.add(ht2);
			
			if(line > 0 && vt.size() > 0){

				
				String row_id = neoe_db.insertDebtSettleAutoDocu(ins.getIns_start_dt(), vt);	//-> neoe_db ��ȯ
				
				if(row_id.equals("")){
					count = 1;
				}
			}
			

			//�ȳ����� (����ȭ�翡�� �ٽ� �Ｚȭ��� :���ϸ� �߼� ���� ) - 20100430 ����� ���濡 ���� ������߼� :�����븸 --> 20140618 ��� ���ŵ�� ���� �� ���� �߼�
			String email 	= request.getParameter("email")==null?"":request.getParameter("email");
			String bus_id2 	= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
		
		
			if(!ins.getIns_st().equals("0")){
				
				String subject 		= gov_nm+"��, �ڵ������� ���� �ȳ������Դϴ�.";
				
				int seqidx		= 0;
		
				
				if(!email.equals("")){
					//	1. d-mail ���-------------------------------
					DmailBean d_bean = new DmailBean();
					d_bean.setSubject			(subject);
					d_bean.setSql				("SSV:"+email.trim());
					d_bean.setReject_slist_idx	(0);
					d_bean.setBlock_group_idx	(0);
					d_bean.setMailfrom			("\"�Ƹ���ī\"<34000233@amazoncar.co.kr>");
					d_bean.setMailto			("\""+gov_nm+"\"<"+email.trim()+">");
					d_bean.setReplyto			("\"�Ƹ���ī\"<34000233@amazoncar.co.kr>");
					d_bean.setErrosto			("\"�Ƹ���ī\"<34000233@amazoncar.co.kr>");
					d_bean.setHtml				(1);
					d_bean.setEncoding			(0);
					d_bean.setCharset			("euc-kr");
					d_bean.setDuration_set		(1);
					d_bean.setClick_set			(0);
					d_bean.setSite_set			(0);
					d_bean.setAtc_set			(0);
					d_bean.setGubun				("insur");
					d_bean.setRname				("mail");
					d_bean.setMtype       		(0);
					d_bean.setU_idx       		(1);//admin����
					d_bean.setG_idx				(1);//admin����
					d_bean.setMsgflag     		(0);
					
					d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/ins/ins_gs_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&ins_start_dt="+r_ins_start_dt);
					seqidx = ImEmailDb.insertDEmail2(d_bean, "4", "", "+7");					
				}
				
		 
				String ins_name = String.valueOf(ins_com.get("INS_COM_NM"));
				String ins_tel 	= "";
				if ( ins_name.equals("�Ｚȭ��") ) {
			    		ins_tel = "1588-5114, ";
				} else if  ( ins_name.equals("����ȭ��") || ins_name.equals("DB���غ���") ) {
			    		ins_tel = "1588-0100,";
				} else if  ( ins_name.equals("����ī��������") ) {
								ins_tel = "1661-7977, ";					
				}
							
				//String msg 		= "[�ڵ������� ����] ������ "+ ins_name + " "+ ins_tel +" ����⵿�� ����Ÿ�ڵ��� 1588-6688 �Դϴ�. (��)�Ƹ���ī ";
				String msg 		= gov_nm+"���� �ȳ��Ͻʴϱ�, �Ƹ���ī�Դϴ�. ������ �뿩�ڵ��� ����ȸ�簡 ������ ���� ���ŵǾ������ �̿뿡 ���� ��Ź�帳�ϴ�. ������ ����� : "+ ins_name + " ("+ ins_tel +"), ����⵿ �� ���� : ����Ÿ����⵿ 1588-6688, SK��Ʈ���� 1670-5494  (��)�Ƹ���ī www.amazoncar.co.kr ";
				
				
				if(!bus_id2.equals("")){
					user_bean 	= umd.getUsersBean(bus_id2);
				}
		
				String sendname 	= "(��)�Ƹ���ī "+user_bean.getUser_nm();
				String sendphone 	= user_bean.getUser_m_tel();
			
				String etc1 = l_cd;
				String etc2 = ck_acar_id;

				//��� ����� ���� ���� ����
				Hashtable sms = c_db.getDmailSms(m_id, l_cd, "1");
				
				String destphone 	= String.valueOf(sms.get("TEL"));			
				String destname 	= String.valueOf(sms.get("NM"));
				
			
	   

				// jjlim add alimtalk
				// acar45 ���谻�� �� ����⵿�ȳ�
				if (!destphone.equals("")) {
					String customer_name = gov_nm;										// �� �̸�
					String insurance_name = String.valueOf(ins_com.get("INS_COM_NM"));	// ����� �̸�
					String insurance_phone 	= "";										// ����� ��ȭ
					if ( insurance_name.equals("�Ｚȭ��") ) {
						insurance_phone = "1588-5114 ";
					} else if  ( insurance_name.equals("����ȭ��") ) {
						insurance_phone = "1588-0100";
					} else if  ( insurance_name.equals("����ī��������") ) {
						insurance_phone = "1661-7977 ";	
					}
					String sos_service_info = "����Ÿ�ڵ��� (1588-6688)";								// ����⵿
					
					String marster_car_num = "1588-6688"; //������ �ڵ��� ����ó
					String sk_net_num = "1670-5494"; //sk��Ʈ���� ����ó
					
					String url_1 = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_sos.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
					String sos_url = ShortenUrlGoogle.getShortenUrl(url_1);
					
					Date today = new Date();
					SimpleDateFormat format = new SimpleDateFormat("yyyy�� MM�� dd��");
					String update_date = String.valueOf(format.format(today));
					
					/* List<String> fieldList = Arrays.asList(customer_name, insurance_name, insurance_phone, sos_service_info);
					at_db.sendMessageReserve("acar0112", fieldList, destphone,  sendphone, null , etc1,  etc2); */
					
					//acar0045-> acar0059 (������ȣ �߰�) -> acar0091 (��������) -> acar00112 (�ִ�ī����) -> acar0157 (sk��Ʈ���� �߰�) -> acar0232 -> acar0259
					List<String> fieldList = Arrays.asList(customer_name, car_num, car_name, insurance_name, insurance_phone, update_date, AddUtil.ChangeDate2(ins.getIns_start_dt()), AddUtil.ChangeDate2(ins.getIns_exp_dt()), marster_car_num, sk_net_num, sos_url);
					at_db.sendMessageReserve("acar0259", fieldList, destphone,  sendphone, null , etc1,  etc2);
				}


			}			
			
		}
		
		//���Ǻ����� ������ ó�� �޽��� �߼� �� ���ڹ��� ��� con_f_nm<>'�Ƹ���ī'
		if(!ins_st.equals("0") && !ins.getCon_f_nm().equals("�Ƹ���ī")){
			String  d_flag1 =  ai_db.call_sp_ins_day_msg();		
		}	
						
	}
%>
<form name='form1' method='post' action='../ins_mng/ins_u_frame.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="ins_st" value='<%=ins_st%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
</form>
<script>
<%	if(over_cnt == 0){//�ߺ�üũ
		if(flag != 0){%>
			alert('�����߻�!');
			location='about:blank';
<%		}else{	%>
			alert("��ϵǾ����ϴ�");
			var fm = document.form1;
			fm.target = "d_content";		
			fm.submit();
//			parent.parent.location='../ins_mng/ins_u_frame.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&ins_st=<%=ins_st%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>';
<%		}	%>
<%	}else{	%>
			alert('�̹� ��ϵ� ����Դϴ�.');
			location='about:blank';
<%	}	%>
</script>
</body>
</html>
