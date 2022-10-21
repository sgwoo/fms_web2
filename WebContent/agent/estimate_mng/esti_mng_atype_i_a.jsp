<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cmd = request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	String a_e = request.getParameter("a_e")==null?"":request.getParameter("a_e");
	String damdang_id = request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String ls_yn 	= request.getParameter("ls_yn")==null?"":request.getParameter("ls_yn");
	
	String est_id = "";
	String est_reg_yn = "Y";
	int count = 0;
	int est_size = 0;
	
	String set_code  = Long.toString(System.currentTimeMillis());
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	bean.setEst_nm		(request.getParameter("est_nm")==null?"":request.getParameter("est_nm"));
	bean.setEst_ssn		(request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn"));
	bean.setEst_tel		(request.getParameter("est_tel")==null?"":request.getParameter("est_tel"));
	bean.setEst_fax		(request.getParameter("est_fax")==null?"":request.getParameter("est_fax"));
	bean.setSpr_yn		(request.getParameter("spr_yn")==null?"0":request.getParameter("spr_yn"));
	bean.setVali_type	(request.getParameter("vali_type")==null?"":request.getParameter("vali_type"));
	bean.setDoc_type	(request.getParameter("doc_type")==null?"":request.getParameter("doc_type"));
	bean.setDir_pur_commi_yn		(request.getParameter("dir_pur_commi_yn")==null?"N":request.getParameter("dir_pur_commi_yn"));
	bean.setCaroff_emp_yn	(request.getParameter("caroff_emp_yn")==null?"":request.getParameter("caroff_emp_yn"));
	bean.setPp_ment_yn(request.getParameter("pp_ment_yn")==null?"N":request.getParameter("pp_ment_yn"));
	
	bean.setMgr_nm		(request.getParameter("mgr_nm")==null?"":request.getParameter("mgr_nm"));
	
	bean.setCar_comp_id	(request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id"));
	bean.setCar_cd		(request.getParameter("code")==null?"":request.getParameter("code"));
	bean.setCar_id		(request.getParameter("car_id")==null?"":request.getParameter("car_id"));
	bean.setCar_seq		(request.getParameter("car_seq")==null?"":request.getParameter("car_seq"));
	bean.setCar_amt		(request.getParameter("car_amt")==null?0:AddUtil.parseDigit(request.getParameter("car_amt")));
	bean.setOpt				(request.getParameter("opt")==null?"":request.getParameter("opt"));
	bean.setOpt_seq		(request.getParameter("opt_seq")==null?"":request.getParameter("opt_seq"));
	bean.setOpt_amt		(request.getParameter("opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("opt_amt")));
	bean.setOpt_amt_m			(request.getParameter("opt_amt_m")==null?0:AddUtil.parseDigit(request.getParameter("opt_amt_m")));
	bean.setCol				(request.getParameter("col")==null?"":request.getParameter("col"));
	bean.setIn_col		(request.getParameter("in_col")==null?"":request.getParameter("in_col"));
	bean.setGarnish_col		(request.getParameter("garnish_col")==null?"":request.getParameter("garnish_col"));
	bean.setCol_seq		(request.getParameter("col_seq")==null?"":request.getParameter("col_seq"));
	bean.setCol_amt		(request.getParameter("col_amt")==null?0:AddUtil.parseDigit(request.getParameter("col_amt")));
	bean.setDc				(request.getParameter("dc")==null?"":request.getParameter("dc"));
	bean.setDc_seq		(request.getParameter("dc_seq")==null?"":request.getParameter("dc_seq"));
	bean.setDc_amt		(request.getParameter("dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
	bean.setEsti_d_etc	(request.getParameter("esti_d_etc")==null?"":request.getParameter("esti_d_etc"));
	bean.setO_1			(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
	bean.setEst_email	(request.getParameter("est_email")==null?"":request.getParameter("est_email").trim());
	bean.setSet_code	(set_code);
	bean.setReg_id		(user_id);
	bean.setPrint_type(request.getParameter("print_type")==null?"1":request.getParameter("print_type"));
	bean.setRent_dt		(AddUtil.getDate(4));
	bean.setJg_opt_st	(request.getParameter("jg_opt_st")==null?"":request.getParameter("jg_opt_st"));
	bean.setJg_col_st	(request.getParameter("jg_col_st")==null?"":request.getParameter("jg_col_st"));
	bean.setTax_dc_amt(request.getParameter("tax_dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("tax_dc_amt")));
	bean.setConti_rat	(request.getParameter("conti_rat")==null?"":request.getParameter("conti_rat"));
	bean.setCompare_yn(request.getParameter("compare_yn")==null?"N":request.getParameter("compare_yn"));
	bean.setJg_tuix_st			(request.getParameter("jg_tuix_st")==null?"":request.getParameter("jg_tuix_st"));
	bean.setJg_tuix_opt_st	(request.getParameter("jg_tuix_opt_st")==null?"":request.getParameter("jg_tuix_opt_st"));
	bean.setLkas_yn			(request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn"));		// ������Ż ������
	bean.setLdws_yn			(request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn"));	// ������Ż �����
	bean.setAeb_yn			(request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn"));		// ������� ������
	bean.setFcw_yn			(request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn"));		// ������� �����
	bean.setGarnish_yn		(request.getParameter("garnish_yn")==null?"":request.getParameter("garnish_yn"));		// ���Ͻ�
	bean.setHook_yn		(request.getParameter("hook_yn")==null?"":request.getParameter("hook_yn"));		// ���ΰ�
	bean.setEtc				(request.getParameter("car_etc2")==null?"":request.getParameter("car_etc2"));	//�������(�������� �Ⱓ�� ���θ�ǵ� Ȱ��-���̰���� ��û)(2018.05.04)
	bean.setBigo			(request.getParameter("bigo")==null?"":request.getParameter("bigo"));			//������DC���(2018.05.04)
	bean.setGi_grade		(request.getParameter("gi_grade")==null?"":request.getParameter("gi_grade"));			//������������ ���
	bean.setInfo_st			(request.getParameter("info_st")==null?"":request.getParameter("info_st"));			//�ȳ���ǥ�⿩��
	
	if(bean.getCaroff_emp_yn().equals("4")){
		bean.setDamdang_nm		(request.getParameter("damdang_nm")==null?"":request.getParameter("damdang_nm"));
		bean.setDamdang_m_tel	(request.getParameter("damdang_m_tel")==null?"":request.getParameter("damdang_m_tel"));
	}
	
	// ������Ż ����, �����, ������� ����, ����� �ɼǿ� ���ԵǾ� ���� ��� ESTIMATE ���̺� lkas_yn, ldws_yn, aeb_yn, fcw_yn ���� Y�� ����(2017.11.20) 	start
	if(request.getParameter("lkas_yn_opt_st") != null && request.getParameter("lkas_yn_opt_st").equals("Y")){
		bean.setLkas_yn("Y");
	}
	if(request.getParameter("ldws_yn_opt_st") != null && request.getParameter("ldws_yn_opt_st").equals("Y")){
		bean.setLdws_yn("Y");
	}
	if(request.getParameter("aeb_yn_opt_st") != null && request.getParameter("aeb_yn_opt_st").equals("Y")){
		bean.setAeb_yn("Y");
	}
	if(request.getParameter("fcw_yn_opt_st") != null && request.getParameter("fcw_yn_opt_st").equals("Y")){
		bean.setFcw_yn("Y");
	}
	// ÷�ܾ��� ��ġ �ɼ� ���� end
	if(request.getParameter("garnish_yn_opt_st") != null && request.getParameter("garnish_yn_opt_st").equals("Y")){
		bean.setGarnish_yn("Y");
	}
	if(request.getParameter("hook_yn_opt_st") != null && request.getParameter("hook_yn_opt_st").equals("Y")){
		bean.setHook_yn("Y");
	}
	
	if(!damdang_id.equals(""))	bean.setReg_id		(damdang_id);
	
	//��������
	cm_bean = a_cmb.getCarNmCase(bean.getCar_id(), bean.getCar_seq());
	
	String jg_b_dt = e_db.getVar_b_dt("jg", bean.getRent_dt());
	String em_a_j  = e_db.getVar_b_dt("em", bean.getRent_dt());
		
	//��������
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
	
	//������ ���� ���
	if(ej_bean.getJg_g_7().equals("3")){
		bean.setEv_yn("Y");
	}
	
	String est_check1 = "";
	String est_check2 = "";
	String est_check3 = "";
	String est_check4 = ""; // ������å�� 10���� ������ ��� ���â ���� ���� Ȯ�� ���� 2017.12.27
	String est_check5 = "";
	
	//�Ƹ���ī �����ŷ�ó ���� (���ΰ� ����)
	Vector vt_chk1 = e_db.getEstimateCustRentCheck(bean.getEst_nm(), bean.getEst_ssn(), bean.getEst_tel(), bean.getEst_fax(), bean.getEst_email());
	int vt_chk1_size = vt_chk1.size(); 
		
	if(vt_chk1_size > 0){
		for (int i = 0 ; i < 1 ; i++){
       		Hashtable ht = (Hashtable)vt_chk1.elementAt(i);
       		if( String.valueOf(ht.get("BUS_ID")).equals(user_id) || String.valueOf(ht.get("BUS_ID2")).equals(user_id) ){
       			est_check1 = "";
       		}else{
       			est_check1 = "##����ȣ/�̸� or ����ڵ�Ϲ�ȣ or ����ó or FAX or �̸����ּҷ� �˻��� ���##\\n\\n["+String.valueOf(ht.get("FIRM_NM"))+" "+String.valueOf(ht.get("CLIENT_NM"))+"]�� ���� �Ƹ���ī ���뿩�� �̿��ϰ� �ִ� ���Դϴ�.\\n\\n���ʿ����� " +String.valueOf(ht.get("BUS_NM"))+ " " +String.valueOf(ht.get("BUS_POS"))+ " " +String.valueOf(ht.get("BUS_M_TEL"))+ "\\n��������� " +String.valueOf(ht.get("BUS_NM2"))+ " " +String.valueOf(ht.get("BUS_POS2"))+ " " +String.valueOf(ht.get("BUS_M_TEL2"))+ "\\n\\n��� �����Ͻðڽ��ϱ�?";               			
       		}                		
       	}			
	}else{
		est_check1 = "";
	}
	
	//�ֱ�30���̳� �������� (���ΰ� ����)
	Vector vt_chk2 = e_db.getEstimateCustEstCheck("1", bean.getEst_nm(), bean.getEst_ssn(), bean.getEst_tel(), bean.getEst_fax(), bean.getEst_email());
	int vt_chk2_size = vt_chk2.size();
	long reg_dt_estimate = 999999999999L;	//12�ڸ�
	
	if(vt_chk2_size > 0){
		for (int i = 0 ; i < vt_chk2_size ; i++){
       		Hashtable ht = (Hashtable)vt_chk2.elementAt(i);
       		if(est_check2.equals("")){
       			if( String.valueOf(ht.get("REG_ID")).equals(user_id)){
       				if(ht.get("REG_DT")!=null){
	   					if(reg_dt_estimate > Long.parseLong(String.valueOf(ht.get("REG_DT")))){
	   						//30���̳� ������ ���� ���� ������ �������� ����(����Ʈ���� �ǰ� ������)
	    					reg_dt_estimate = Long.parseLong(String.valueOf(ht.get("REG_DT")));
	  					}
       				}	
       			}else{
       				UsersBean user_bean 	= umd.getUsersBean(String.valueOf(ht.get("USER_NM")));
       				if(!user_bean.getDept_id().equals("1000")){
       					est_check2 = "##����ȣ/�̸� or ����ڵ�Ϲ�ȣ or ����ó or FAX or �̸����ּҷ� �˻��� ���##\\n\\n["+String.valueOf(ht.get("EST_NM"))+"]�� �ֱ� 30���̳� ������ ���Դϴ�.\\n\\n��������� " +String.valueOf(ht.get("USER_NM"))+ " "+ String.valueOf(ht.get("USER_POS"))+ " " +String.valueOf(ht.get("USER_M_TEL"))+ "\\n\\n��� �����Ͻðڽ��ϱ�?";
       				}
       			}
       		}
       	}
	}	
	
	//�ֱ�30���̳� ����Ʈ�������� (���ΰ� ����) -> 20160520 ���ϱ�� -> 20180509 agent FMS�� �ٽ� ����
	Vector vt_chk3 = e_db.getEstimateSpeCustEstCheck2("1", bean.getEst_nm(), bean.getEst_ssn(), bean.getEst_tel(), bean.getEst_fax(), bean.getEst_email());
	int vt_chk3_size = vt_chk3.size();
	if(vt_chk3_size > 0){
		for (int i = 0 ; i < vt_chk3_size ; i++){
  			Hashtable ht = (Hashtable)vt_chk3.elementAt(i);
  			//���� �������ؽ��� 30�� �̳��� ������Ʈ ������ �������� ������ �߰��� ����Ʈ �������� �ִ��� ��Ʈ����
  			if(ht.get("REG_DT")!=null && reg_dt_estimate != 999999999999L && (reg_dt_estimate < Long.parseLong(String.valueOf(ht.get("REG_DT"))))){
  			}else{
  				est_check3 = "##����ȣ/�̸� or ����ڵ�Ϲ�ȣ or ����ó or FAX or �̸����ּҷ� �˻��� ���##\\n\\n["+String.valueOf(ht.get("EST_NM"))+"]�� �ֱ� 30���̳� �Ƹ���ī ����Ʈ ������ ��û�� ���Դϴ�.\\n\\n��� �����Ͻðڽ��ϱ�?";
  			}	
        }                	
	}
	
	//������� ��Ͽ��� (���ΰ� ����)
	Vector vt_chk4 = e_db.getEstimatePurPreEstCheck("1", bean.getEst_nm(), bean.getEst_ssn(), bean.getEst_tel(), bean.getEst_fax(), bean.getEst_email());
	int vt_chk4_size = vt_chk4.size();
	if(vt_chk4_size > 0){
		for (int i = 0 ; i < vt_chk4_size ; i++){
  		Hashtable ht = (Hashtable)vt_chk4.elementAt(i);
  		if(est_check5.equals("")){
  			est_check5 = "##����ȣ/�̸� or ����ó�� �˻��� ���##\\n\\n["+String.valueOf(ht.get("FIRM_NM"))+"]�� �������� ���Դϴ�.\\n("+String.valueOf(ht.get("CAR_NM"))+")\\n\\n����� " +String.valueOf(ht.get("BUS_NM"))+ " "+ String.valueOf(ht.get("USER_POS"))+ " " +String.valueOf(ht.get("USER_M_TEL"))+ "\\n\\n�ߺ����θ� üũ�� �ּ���.\\n\\n��� �����Ͻðڽ��ϱ�?";               			
  		}	
		}
	}	
	//���ΰ� ������ ���Ʈ
	if(!est_check5.equals("")){
		for (int i = 0 ; i < vt_chk4_size ; i++){
  		Hashtable ht = (Hashtable)vt_chk4.elementAt(i);
  		if(!est_check5.equals("")){
  			if(String.valueOf(ht.get("BUS_NM")).equals(session_user_nm) || String.valueOf(ht.get("MEMO")).indexOf(session_user_nm) != -1){
  				est_check5 = "";
  			}
  		}
		}
	}
	
	String est_yn[] 		= request.getParameterValues("est_yn");
	String return_select[] 	= request.getParameterValues("return_select");
	String a_a[] 			= request.getParameterValues("a_a");
	String a_b[] 			= request.getParameterValues("a_b");
	String o_13[] 			= request.getParameterValues("o_13");
	String ro_13[] 			= request.getParameterValues("ro_13");
	String ro_13_amt[] 		= request.getParameterValues("ro_13_amt");
	String opt_chk[] 		= request.getParameterValues("opt_chk");
	String rg_8[] 			= request.getParameterValues("rg_8");
	String rg_8_amt[] 		= request.getParameterValues("rg_8_amt");
	String pp_per[] 		= request.getParameterValues("pp_per");
	String pp_amt[] 		= request.getParameterValues("pp_amt");
	String g_10[] 			= request.getParameterValues("g_10");
	String ins_per[] 		= request.getParameterValues("ins_per");
	//String insurant[] 		= request.getParameterValues("insurant");
	String ins_dj[] 		= request.getParameterValues("ins_dj");
	String ins_age[] 		= request.getParameterValues("ins_age");
	String car_ja[] 		= request.getParameterValues("car_ja");
// 	String gi_per[] 		= request.getParameterValues("gi_per");
// 	String gi_amt[] 		= request.getParameterValues("gi_amt");
	String udt_st[] 		= request.getParameterValues("udt_st");
	String o_11[] 			= request.getParameterValues("o_11");
	String fee_dc_per[] 	= request.getParameterValues("fee_dc_per");
	
	String b_agree_dist[] = request.getParameterValues("b_agree_dist");
	String agree_dist[] 	= request.getParameterValues("agree_dist");
	String b_o_13[] 			= request.getParameterValues("b_o_13");
	String rtn_run_amt_yn[] 			= request.getParameterValues("rtn_run_amt_yn");	// ȯ�޴뿩�� ���� ����. 0 ���� / 1 ������
	String loc_st[] 			= request.getParameterValues("loc_st");
	String tint_s_yn[] 		= request.getParameterValues("r_tint_s_yn");		// �������(�⺻��)
	String tint_sn_yn[] 		= request.getParameterValues("r_tint_sn_yn");		// ������� �̽ð� ����
	String tint_ps_yn[] 	= request.getParameterValues("r_tint_ps_yn");		// ��޽��� 
	String tint_ps_nm[] 	= request.getParameterValues("r_tint_ps_nm");		// ��޽��� ����
	String tint_ps_amt[] 	= request.getParameterValues("r_tint_ps_amt");		//	��޽��� �߰��ݾ�(���ް�)
	String tint_ps_st[] 	= request.getParameterValues("r_tint_ps_st");		// ��޽��� ���ð�
	String tint_n_yn[] 		= request.getParameterValues("r_tint_n_yn");		// ��ġ�� ������̼�
	String tint_bn_yn[] 		= request.getParameterValues("r_tint_bn_yn");		// ���ڽ� ������ ���� (��Ʈ��ķ,������..)
	String new_license_plate[] 	= request.getParameterValues("r_new_license_plate");	//������ȣ�ǽ�û 
	String tint_cons_yn[] 		= request.getParameterValues("r_tint_cons_yn");		// �߰�Ź�۷� üũ
	String tint_cons_amt[] 	= request.getParameterValues("r_tint_cons_amt");		// �߰�Ź�۷� �ݾ�
	String tint_eb_yn[] 	= request.getParameterValues("r_tint_eb_yn");		// �̵���������
	String ecar_loc_st[]	= request.getParameterValues("ecar_loc_st");
	String hcar_loc_st[]	= request.getParameterValues("hcar_loc_st");
	//String eco_e_tag[]		= request.getParameterValues("eco_e_tag");
	String com_emp_yn[]		= request.getParameterValues("com_emp_yn");
	
	String reg_code[] 		= new String[est_yn.length];
	
	String r_a_a[] 			= request.getParameterValues("r_a_a");
	String r_ins_per[] 			= request.getParameterValues("r_ins_per");
	String r_ins_dj[] 			= request.getParameterValues("r_ins_dj");
	String r_ins_age[] 			= request.getParameterValues("r_ins_age");
	String r_loc_st[] 			= request.getParameterValues("r_loc_st");
	String r_ecar_loc_st[]	= request.getParameterValues("r_ecar_loc_st");
	String r_hcar_loc_st[]	= request.getParameterValues("r_hcar_loc_st");
	// String r_eco_e_tag[]	= request.getParameterValues("r_eco_e_tag");
	String r_com_emp_yn[]		= request.getParameterValues("r_com_emp_yn");
		
	out.println("est_yn.length="+est_yn.length);
	
	out.println("<br>");
	
	bean.setInsurant		("1"); //20161005 �������� �̻�� - ��� �Ƹ���ī�� �����
	
	//4���� ���� : �ִ� 8��
	for(int j=0; j < est_yn.length; j++){
		
		if(est_yn[j].equals("Y")){
			
			String r_reg_code  = Long.toString(System.currentTimeMillis());
			
			if(AddUtil.lengthb(r_reg_code) < 18)	r_reg_code = r_reg_code+"4"+j;
			
			reg_code[j]	= r_reg_code;
			
			bean.setReg_code			(reg_code[j]);			
			bean.setA_b						(a_b[j]					==null?"":a_b[j]);
			bean.setO_13					(o_13[j]				==null?0 :AddUtil.parseFloat(o_13[j]));
			/* bean.setRo_13					(ro_13[j]				==null?0 :AddUtil.parseFloat(ro_13[j]));
			bean.setRo_13_amt			(ro_13_amt[j]		==null?0 :AddUtil.parseDigit(ro_13_amt[j])); */
			
			//������ �������϶� �ݳ����ϰ��
			if(bean.getPrint_type().equals("6")){
				if (return_select[j].equals("1")) {
					bean.setRo_13				(bean.getO_13());
					bean.setRo_13_amt			(0);
				} else {
					bean.setRo_13				(ro_13[j]			==null?0 :AddUtil.parseFloat(ro_13[j]));
					bean.setRo_13_amt			(ro_13_amt[j]		==null?0 :AddUtil.parseDigit(ro_13_amt[j]));
				}
			} else {
				bean.setRo_13				(ro_13[j]			==null?0 :AddUtil.parseFloat(ro_13[j]));
				bean.setRo_13_amt			(ro_13_amt[j]		==null?0 :AddUtil.parseDigit(ro_13_amt[j]));				
			}
			
			bean.setOpt_chk				(opt_chk[j]			==null?"":opt_chk[j]);
			bean.setRg_8					(rg_8[j]				==null?0 :AddUtil.parseFloat(rg_8[j]));
			bean.setRg_8_amt			(rg_8_amt[j]		==null?0 :AddUtil.parseDigit(rg_8_amt[j]));
			bean.setPp_per				(pp_per[j]			==null?0 :AddUtil.parseFloat(pp_per[j]));
			bean.setPp_amt				(pp_amt[j]			==null?0 :AddUtil.parseDigit(pp_amt[j]));
			bean.setG_10					(g_10[j]				==null?0 :AddUtil.parseDigit(g_10[j]));
			bean.setFee_dc_per		(fee_dc_per[j]	==null?0:AddUtil.parseFloat(fee_dc_per[j]));
			bean.setAgree_dist		(agree_dist[j]	==null?0 :AddUtil.parseDigit(agree_dist[j]));
			bean.setB_agree_dist	(b_agree_dist[j]==null?0 :AddUtil.parseDigit(b_agree_dist[j]));
			bean.setB_o_13				(b_o_13[j]			==null?0 :AddUtil.parseFloat(b_o_13[j]));
			bean.setRtn_run_amt_yn(rtn_run_amt_yn[j] == null ? "" : rtn_run_amt_yn[j]);
			
			//��Ʈ,����,���հ����϶��� ù��° ���ǰ� �����ϵ��� �Ѵ�.
			if(bean.getPrint_type().equals("2") || bean.getPrint_type().equals("3") || bean.getPrint_type().equals("4")){
				bean.setA_a					(r_a_a[j]			==null?"":r_a_a[j]);
				bean.setIns_per			(ins_per[0]		==null?"1":ins_per[0]);
				bean.setIns_dj			(ins_dj[0]		==null?"":ins_dj[0]);
				bean.setIns_age			(ins_age[0]		==null?"":ins_age[0]);
				bean.setCar_ja			(car_ja[0]		==null?0 :AddUtil.parseDigit(car_ja[0]));
				if(AddUtil.parseDigit(car_ja[0]) == 100000){	// ������å���� 10���� ������ ��� ���â ��� 2017.12.27
					est_check4 = "��å�� 10�������� ������ ��� ��������� ���������� �þƾ� �մϴ�.\\n\\n���������� �����̽��ϱ�?"; 
				}
// 				bean.setGi_per			(gi_per[0]		==null?0 :AddUtil.parseFloat(gi_per[0]));
// 				bean.setGi_amt			(gi_amt[0]		==null?0 :AddUtil.parseDigit(gi_amt[0]));
				bean.setUdt_st			(udt_st[0]		==null?"0":udt_st[0]);
				bean.setO_11				(o_11[0]			==null?0:AddUtil.parseFloat(o_11[0]));
				bean.setLoc_st			(loc_st[0]			==null?"":loc_st[0]);
				bean.setEcar_loc_st	(ecar_loc_st[0]==null?"0":ecar_loc_st[0]);
				bean.setHcar_loc_st	(hcar_loc_st[0]==null?"0":hcar_loc_st[0]);
				// bean.setEco_e_tag		(eco_e_tag[0]==null?"0":eco_e_tag[0]);	// �������ｺƼĿ �߱�
				bean.setCom_emp_yn	(com_emp_yn[0]	==null?"N":com_emp_yn[0]);
				bean.setTint_s_yn		(tint_s_yn[0]		==null?"N":tint_s_yn[0]);	// �������(�⺻��)
				bean.setTint_sn_yn		(tint_sn_yn[0]		==null?"N":tint_sn_yn[0]);	// ������� �̽ð� ����
				bean.setTint_ps_yn	(tint_ps_yn[0]		==null?"N":tint_ps_yn[0]);	// ��޽���
				bean.setTint_ps_nm	(tint_ps_nm[0]		==null?""  :tint_ps_nm[0]);	// ��޽��� ����
				bean.setTint_ps_amt	(tint_ps_amt[0]	==null?0	 :AddUtil.parseDigit(tint_ps_amt[0]));// ��޽��� �߰��ݾ�(���ް�)
				bean.setTint_ps_st	(tint_ps_st[0]		==null?""  :tint_ps_st[0]);	// ��޽��� ���ð�
				bean.setTint_n_yn		(tint_n_yn[0]		==null?"N":tint_n_yn[0]);	// ��ġ�� ������̼�
				bean.setTint_bn_yn		(tint_bn_yn[0]		==null?"N":tint_bn_yn[0]);	// ���ڽ� ������ ���� (��Ʈ��ķ,������..)
				bean.setNew_license_plate		(new_license_plate[0]		==null?"":new_license_plate[0]);	// ������ȣ�ǽ�û
				bean.setTint_cons_yn	(tint_cons_yn[0]		==null?"N"  :tint_cons_yn[0]);	// �߰�Ź�۷� ����
				bean.setTint_cons_amt	(tint_cons_amt[0]	==null?0	 :AddUtil.parseDigit(tint_cons_amt[0]));// �߰�Ź�۷� �ݾ�
				bean.setTint_eb_yn	(tint_eb_yn[0]	==null?"N":tint_eb_yn[0]);	//�̵���������
			//�����������϶� ù��° ���ǰ� �����ϵ��� �Ѵ�.
			}else if(bean.getPrint_type().equals("5")){
				bean.setA_a					(a_a[j]				==null?"":a_a[j]);
				bean.setIns_per			(r_ins_per[0]		==null?"1":r_ins_per[0]);
				bean.setIns_dj			(r_ins_dj[0]		==null?"":r_ins_dj[0]);
				bean.setIns_age			(r_ins_age[0]		==null?"":r_ins_age[0]);
				bean.setCar_ja			(car_ja[0]		==null?0 :AddUtil.parseDigit(car_ja[0]));
				if(AddUtil.parseDigit(car_ja[0]) == 100000){	// ������å���� 10���� ������ ��� ���â ��� 2017.12.27
					est_check4 = "��å�� 10�������� ������ ��� ��������� ���������� �þƾ� �մϴ�.\\n\\n���������� �����̽��ϱ�?"; 
				}
// 				bean.setGi_per		(gi_per[j]		==null?0 :AddUtil.parseFloat(gi_per[j]));
// 				bean.setGi_amt		(gi_amt[j]		==null?0 :AddUtil.parseDigit(gi_amt[j]));
				bean.setUdt_st		(udt_st[0]		==null?"0":udt_st[0]);
				bean.setO_11		(o_11[j]		==null?0:AddUtil.parseFloat(o_11[j]));
				bean.setLoc_st		(r_loc_st[0]	==null?"":r_loc_st[0]);
				bean.setEcar_loc_st	(r_ecar_loc_st[0]==null?"":r_ecar_loc_st[0]);
				bean.setHcar_loc_st	(r_hcar_loc_st[0]	==null?"":r_hcar_loc_st[0]);
				//bean.setEco_e_tag	(r_eco_e_tag[0]	==null?"":r_eco_e_tag[0]);	// �������ｺƼĿ �߱�
				bean.setCom_emp_yn	(r_com_emp_yn[0]==null?"N":r_com_emp_yn[0]);
				bean.setTint_s_yn	(tint_s_yn[0]	==null?"N":tint_s_yn[0]);		// �������(�⺻��)
				bean.setTint_sn_yn	(tint_sn_yn[0]	==null?"N":tint_sn_yn[0]);		// ������� �̽ð� ����
				bean.setTint_ps_yn	(tint_ps_yn[0]	==null?"N":tint_ps_yn[0]);		// ��޽���
				bean.setTint_ps_nm	(tint_ps_nm[0]	==null?""  :tint_ps_nm[0]);		// ��޽��� ����
				bean.setTint_ps_amt	(tint_ps_amt[0]==null?0	 :AddUtil.parseDigit(tint_ps_amt[0]));	// ��޽��� �߰��ݾ�(���ް�)
				bean.setTint_ps_st	(tint_ps_st[0]	==null?""  :tint_ps_st[0]);		// ��޽��� ���ð�
				bean.setTint_n_yn	(tint_n_yn[0]	==null?"N":tint_n_yn[0]);		// ��ġ�� ������̼�
				bean.setTint_bn_yn	(tint_bn_yn[0]	==null?"N":tint_bn_yn[0]);		// ���ڽ� ������ ���� (��Ʈ��ķ,������..)
				bean.setNew_license_plate		(new_license_plate[0]		==null?"":new_license_plate[0]);	// ������ȣ�ǽ�û
				bean.setTint_cons_yn	(tint_cons_yn[0]		==null?"N"  :tint_cons_yn[0]);	// �߰�Ź�۷� ����
				bean.setTint_cons_amt	(tint_cons_amt[0]	==null?0	 :AddUtil.parseDigit(tint_cons_amt[0]));// �߰�Ź�۷� �ݾ�
				bean.setTint_eb_yn	(tint_eb_yn[0]	==null?"N":tint_eb_yn[0]);		//�̵���������
			//������ ������ �μ��ݳ� ������ �� �ݳ��� ����
			}else if(bean.getPrint_type().equals("6")){
				bean.setEh_code			(reg_code[j]);		
				bean.setReturn_select		(return_select[j]		==null?"":return_select[j]);
				bean.setA_a					(a_a[j]				==null?"":a_a[j]);
				bean.setIns_per			(r_ins_per[0]		==null?"1":r_ins_per[0]);
				bean.setIns_dj			(r_ins_dj[0]		==null?"":r_ins_dj[0]);
				bean.setIns_age			(r_ins_age[0]		==null?"":r_ins_age[0]);
				bean.setCar_ja			(car_ja[0]		==null?0 :AddUtil.parseDigit(car_ja[0]));
				if(AddUtil.parseDigit(car_ja[0]) == 100000){	// ������å���� 10���� ������ ��� ���â ��� 2017.12.27
					est_check4 = "��å�� 10�������� ������ ��� ��������� ���������� �þƾ� �մϴ�.\\n\\n���������� �����̽��ϱ�?"; 
				}
// 				bean.setGi_per			(gi_per[j]		==null?0 :AddUtil.parseFloat(gi_per[j]));
// 				bean.setGi_amt			(gi_amt[j]		==null?0 :AddUtil.parseDigit(gi_amt[j]));
				bean.setUdt_st			(udt_st[0]		==null?"0":udt_st[0]);
				bean.setO_11				(o_11[j]			==null?0:AddUtil.parseFloat(o_11[j]));
				bean.setLoc_st			(r_loc_st[0]		==null?"":r_loc_st[0]);
				bean.setEcar_loc_st	(r_ecar_loc_st[0]==null?"":r_ecar_loc_st[0]);
				bean.setHcar_loc_st	(r_hcar_loc_st[0]==null?"":r_hcar_loc_st[0]);
				//bean.setEco_e_tag		(r_eco_e_tag[0]==null?"":r_eco_e_tag[0]);// �������ｺƼĿ �߱�
				bean.setCom_emp_yn	(r_com_emp_yn[0]==null?"N":r_com_emp_yn[0]);
				bean.setTint_s_yn		(tint_s_yn[0]	==null?"N":tint_s_yn[0]);		// �������(�⺻��)
				bean.setTint_sn_yn		(tint_sn_yn[0]	==null?"N":tint_sn_yn[0]);		// ������ù̽ð�����
				bean.setTint_ps_yn	(tint_ps_yn[0]	==null?"N":tint_ps_yn[0]);		// ��޽���
				bean.setTint_ps_nm	(tint_ps_nm[0]	==null?""  :tint_ps_nm[0]);		// ��޽��� ����
				bean.setTint_ps_amt	(tint_ps_amt[0]==null?0	 :AddUtil.parseDigit(tint_ps_amt[0]));	// ��޽��� �߰��ݾ�(���ް�)
				bean.setTint_ps_st	(tint_ps_st[0]	==null?""  :tint_ps_st[0]);		// ��޽��� ���ð�
				bean.setTint_n_yn		(tint_n_yn[0]	==null?"N":tint_n_yn[0]);		// ��ġ�� ������̼�
				bean.setTint_bn_yn		(tint_bn_yn[0]	==null?"N":tint_bn_yn[0]);		// ���ڽ� ������ ���� (��Ʈ��ķ,������..)
				bean.setNew_license_plate		(new_license_plate[0]		==null?"":new_license_plate[0]);	// ������ȣ�ǽ�û
				bean.setTint_cons_yn	(tint_cons_yn[0]		==null?"N"  :tint_cons_yn[0]);	// �߰�Ź�۷� ����
				bean.setTint_cons_amt	(tint_cons_amt[0]	==null?0	 :AddUtil.parseDigit(tint_cons_amt[0]));// �߰�Ź�۷� �ݾ�
				bean.setTint_eb_yn	(tint_eb_yn[0]	==null?"N":tint_eb_yn[0]);		// �̵��� ������
			//��ǰ��		
			}else{
				bean.setA_a					(a_a[j]				==null?"":a_a[j]);
				bean.setIns_per			(ins_per[j]		==null?"1":ins_per[j]);
				bean.setIns_dj			(ins_dj[j]		==null?"":ins_dj[j]);
				bean.setIns_age			(ins_age[j]		==null?"":ins_age[j]);
				bean.setCar_ja			(car_ja[j]		==null?0 :AddUtil.parseDigit(car_ja[j]));
				if(AddUtil.parseDigit(car_ja[j]) == 100000){		// ������å���� 10���� ������ ��� ���â ��� 2017.12.27
					est_check4 = "��å�� 10�������� ������ ��� ��������� ���������� �þƾ� �մϴ�.\\n\\n���������� �����̽��ϱ�?";
				}
// 				bean.setGi_per			(gi_per[j]		==null?0 :AddUtil.parseFloat(gi_per[j]));
// 				bean.setGi_amt			(gi_amt[j]		==null?0 :AddUtil.parseDigit(gi_amt[j]));
				bean.setUdt_st			(udt_st[j]		==null?"0":udt_st[j]);
				bean.setO_11				(o_11[j]			==null?0:AddUtil.parseFloat(o_11[j]));
				bean.setLoc_st			(loc_st[j]			==null?"":loc_st[j]);
				bean.setEcar_loc_st	(ecar_loc_st[j]	==null?"":ecar_loc_st[j]);
				bean.setHcar_loc_st	(hcar_loc_st[j]	==null?"":hcar_loc_st[j]);
				//bean.setEco_e_tag	(eco_e_tag[j]	==null?"":eco_e_tag[j]);// �������ｺƼĿ �߱�
				bean.setCom_emp_yn	(com_emp_yn[j]	==null?"N":com_emp_yn[j]);
				bean.setTint_s_yn		(tint_s_yn[j]		==null?"N":tint_s_yn[j]);			// �������(�⺻��)
				bean.setTint_sn_yn		(tint_sn_yn[j]		==null?"N":tint_sn_yn[j]);			// ������� �̽ð� ����
				bean.setTint_ps_yn	(tint_ps_yn[j]	==null?"N":tint_ps_yn[j]);		// ��޽���
				bean.setTint_ps_nm	(tint_ps_nm[j]	==null?""  :tint_ps_nm[j]);		// ��޽��� ����
				bean.setTint_ps_amt	(tint_ps_amt[j]	==null?0	 :AddUtil.parseDigit(tint_ps_amt[j]));		// ��޽��� �߰��ݾ�(���ް�)
				bean.setTint_ps_st	(tint_ps_st[j]	==null?""  :tint_ps_st[j]);		// ��޽��� ���ð�
				bean.setTint_n_yn		(tint_n_yn[j]		==null?"N":tint_n_yn[j]);			// ��ġ�� ������̼�
				bean.setTint_bn_yn		(tint_bn_yn[j]		==null?"N":tint_bn_yn[j]);			// ���ڽ� ������ ���� (��Ʈ��ķ,������..)
				bean.setNew_license_plate		(new_license_plate[j]	==null?"":new_license_plate[j]);	// ������ȣ�ǽ�û
				bean.setTint_cons_yn	(tint_cons_yn[j]		==null?"N"  :tint_cons_yn[j]);	// �߰�Ź�۷� ����
				bean.setTint_cons_amt	(tint_cons_amt[j]	==null?0	 :AddUtil.parseDigit(tint_cons_amt[j]));// �߰�Ź�۷� �ݾ�
				bean.setTint_eb_yn	(tint_eb_yn[j]	==null?"N":tint_eb_yn[j]);		//�̵���������				
			}
			
			bean.setIns_good	("0");//�ִ�ī���� �̰���
			bean.setLpg_yn		("0");//LPGŰƮ ������
			
			//��Ʈ,����,���հ����϶��� ù��° ���ǰ� �����ϵ��� �Ѵ�.
			if(bean.getPrint_type().equals("2") || bean.getPrint_type().equals("3") || bean.getPrint_type().equals("4")){
			}else{
				//����DC �����Ҷ�
				if(bean.getA_a().equals("11") || bean.getA_a().equals("12")){
					if(ls_yn.equals("Y")){
						bean.setDc_amt		(request.getParameter("dc_amt2")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt2")));
						bean.setO_1				(request.getParameter("o_12")==null?0:AddUtil.parseDigit(request.getParameter("o_12")));
					}else{
						bean.setDc_amt		(request.getParameter("dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
						bean.setO_1				(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
					}
				}else{
						bean.setDc_amt		(request.getParameter("dc_amt")==null?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
						bean.setO_1				(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
				}
			}
			
			//�������谡�Կ���
			if(bean.getGi_amt()>0)		bean.setGi_yn("1");//����
			else											bean.setGi_yn("0");//����
			
			//�ʱⳳ�Ա���
			bean.setPp_st		("0");
			if(bean.getG_10() > 0) 		bean.setPp_st		("1");//���ô뿩��
			if(bean.getPp_amt()+bean.getRg_8_amt() > 0) 				bean.setPp_st		("2");//������+������
			if(bean.getPp_per()+bean.getRg_8() > 0) 						bean.setPp_st		("2");//������+������			
			
			bean.setA_h		("7");//20130130 ��� ��õ���
			
			//������
			if(ej_bean.getJg_b().equals("5")){
				//20200221 ������ ���ּ����� ���� �ǵ������ ����
				//1.����, 2.����, 3.�λ�, 4.����, 5.����, 6.��õ, 7.��õ, 8.����, 9.����, 10.�뱸
				
				bean.setA_h	("1");
				
				// ���� ����ȭ����(�����: ����) �� ��� ������ �� �ּ����� ���� ���� ��õ���� ���. 2021.02.18.
				// ����ȭ���� �� ������ ���ּ��� ���� �ǵ������ ���. ����/��õ/����/����/�뱸/�λ� �� ������ ���ּ����� ��õ ���. 20210224
				// ����ȭ���� �� ������ ���ּ��� ���� �ǵ������ ���. ����/��õ/����/����/�뱸/�λ� �� ������ ���ּ����� �λ� ���. 20210520
				// ����ȭ���� �� ������ ���ּ��� ���� �ǵ������ ���. ����/��õ/����/����/�뱸/�λ� �� ������ ���ּ����� ��õ ���. 20210729
				// ���ּ����� ���� ���� ����ȭ������ �ǵ������ �뱸, ����¿����� �ǵ������ ��õ ���. 20220519
				if ( ej_bean.getJg_g_7().equals("3") && Integer.parseInt(cm_bean.getJg_code()) > 8000000 ) { // ģȯ���� ���л� ������ + �����ڵ� 8000000���� ū ���. ����ȭ����.
					bean.setA_h	("10");	// �뱸
				} else {		// ����ȭ���� �� ������. ����¿���.
					bean.setA_h	("7");
				}
				
			}
			
			//������
			if(ej_bean.getJg_b().equals("6")){
				bean.setA_h	("7"); //20191206 ������ ���� -> ��õ�� ���
				//bean.setA_h	("1"); //20200324  ������ �ǵ������ ��õ -> ����
			}
			
			//ģȯ����(�������� �������� ������ ģȯ������ �������ｺƼĿ �߱޼��ý� ����� ���)
			// 2021.02.08. �������ｺƼĿ ���ʿ�� �ּ�ó��.
			/* if(ej_bean.getJg_b().equals("3") || ej_bean.getJg_b().equals("4")){
				if(bean.getEco_e_tag().equals("1")){
					bean.setA_h	("1");//20171017 �������ｺƼĿ�� ����
				}
			} */			
			
			// out.println("j="+j);
			// out.println("a_h="+bean.getA_h());
			
			//20141223 ��������������� �����μ����� ������������Ÿ� �̹� ���
			if((bean.getUdt_st().equals("") && !bean.getLoc_st().equals("")) || AddUtil.parseInt(AddUtil.replace(bean.getRent_dt(),"-","")) >= 20141223){
				if(bean.getLoc_st().equals("1") || bean.getLoc_st().equals("2") || bean.getLoc_st().equals("3"))	bean.setUdt_st("1");
				if(bean.getLoc_st().equals("7"))	bean.setUdt_st("2");
				if(bean.getLoc_st().equals("4"))	bean.setUdt_st("3");
				if(bean.getLoc_st().equals("6"))	bean.setUdt_st("5");
				if(bean.getLoc_st().equals("5"))	bean.setUdt_st("6");
			}				
			
			int esti_idx = 2;			
			
			String a_est_id[]	 		= new String[esti_idx];
			
			float cls_a_b = AddUtil.parseFloat(bean.getA_b())/2;
			cls_a_b = Math.round(cls_a_b);	// ������� ������ �Ǵ� �뿩�Ⱓ�� �� �������� /2 �� �ݿø� ó��. 2021.02.18.
			
			for(int i = 0 ; i < esti_idx ; i++){
				EstimateBean a_bean = new EstimateBean();
				
				a_bean = bean;
				
				//�ߵ����������� ������� org, cls �����ʿ�
				//�ʰ�����δ�� ������� org, base �����ʿ�->20101207 ���� �ʰ�����δ���� ������� ����.
				if(i==0){
					a_bean.setJob("org");
					a_bean.setA_b(bean.getA_b());
				}else if(i==1){
					a_bean.setJob("cls");
					a_bean.setA_b(AddUtil.parseFloatCipher2(cls_a_b,0));
				}
				
				//������������
				if(a_bean.getA_a().equals("11") || a_bean.getA_a().equals("12")){
					if(ej_bean.getJg_i().equals("1")){
						a_bean.setFee_s_amt(0);
						a_bean.setFee_v_amt(0);
					}else{
						a_bean.setFee_s_amt(-1);
						a_bean.setFee_v_amt(-1);
					}
				}
				
				//��Ʈ��������
				if(a_bean.getA_a().equals("21") || a_bean.getA_a().equals("22")){
					if(ej_bean.getJg_h().equals("1")){
						a_bean.setFee_s_amt(0);
						a_bean.setFee_v_amt(0);
					}else{
						a_bean.setFee_s_amt(-1);
						a_bean.setFee_v_amt(-1);
					}
				}
				
				out.println("#### a_b="+a_bean.getA_b()+"-------------------------------<br>");
				
				
				//[20130226] Ʈ���Ϲݽ� �Ұ�
				if(AddUtil.parseInt(cm_bean.getJg_code()) > 9120 && AddUtil.parseInt(cm_bean.getJg_code()) < 9410){	
					//�ϹݽĺҰ�			
					if(a_bean.getA_a().equals("11") || a_bean.getA_a().equals("21")){
						est_reg_yn = "N";
					}					
				}
				if(AddUtil.parseInt(cm_bean.getJg_code()) > 9015410 && AddUtil.parseInt(cm_bean.getJg_code()) < 9045010){	
					//�ϹݽĺҰ�			
					if(a_bean.getA_a().equals("11") || a_bean.getA_a().equals("21")){
						est_reg_yn = "N";
					}					
				}
				
				//[20121120] ������ ������ �Ƹ���ī �Ǻ����ڸ� �Ҽ� ����.
				if(ej_bean.getJg_w().equals("1")){
					//20200207 ������ ������ �Ǻ����ڸ� �Ƹ���ī �� �����ϰ� ����Ǿ� �Ʒ� ���� �ּ�ó��
					if(a_bean.getA_a().equals("12")){
						if(a_bean.getIns_per().equals("1")){
							//est_reg_yn = "N";
						}
					}
					//�ϹݽĺҰ�			
					if(a_bean.getA_a().equals("11") || a_bean.getA_a().equals("21")){
						est_reg_yn = "N";
					}					
				}
				
				
				if(est_reg_yn.equals("Y")){
				
					//����������ȣ ����
					a_est_id[i] = Long.toString(System.currentTimeMillis())+""+String.valueOf(i);
					
					//fms4���� ������.
					if(AddUtil.lengthb(a_est_id[i]) < 15)	a_est_id[i] = a_est_id[i]+""+"4";
					
					a_bean.setEst_type		("F");
					a_bean.setEst_id		(a_est_id[i]);
				
				
					count = e_db.insertEstimate(a_bean);
				
								
					if(est_size==0) est_id = a_est_id[i];
				
					est_size++;
				}
			}
		}
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//��Ȯ��
	function cust_check(){
	
		var confirm_ment = '';
		
		<%	if(!est_check1.equals("")){ //�Ƹ���ī �����ŷ�ó�� ���%>                		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check1%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n--------------------------------\n\n\n<%=est_check1%>'
		}
		<%	}%>
		

		<%	if(!est_check2.equals("")){ //�ֱ�30�� �̳� ������ ���� ���%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check2%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n--------------------------------\n\n\n<%=est_check2%>'
		}
		<%	}%>
		
		<%	if(!est_check3.equals("")){ //�ֱ�7�� �̳� ����Ʈ���� ��û�� ���� ���%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check3%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n--------------------------------\n\n\n<%=est_check3%>'
		}
		<%	}%>
		
		<%	if(!est_check5.equals("")){ //��������� ���� ���%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check5%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n--------------------------------\n\n\n<%=est_check5%>'
		}
		<%	}%>		

		<%	if(!est_check4.equals("")){ //������å���� 10���� ������ ��� 2017.12.27%>		
		if(confirm_ment == ''){
			confirm_ment = '<%=est_check4%>'
		}else{
			confirm_ment = confirm_ment+'\n\n\n--------------------------------\n\n\n<%=est_check4%>'
		}
		<%	}%>
		
		sure = confirm(confirm_ment);
		
		if(sure){
			document.form1.action = "/agent/estimate_mng/esti_mng_abtype_proc.jsp";					
			document.form1.submit();	
		}else{
			document.form1.gubun1.value = '1';
			document.form1.gubun2.value = '';
			document.form1.gubun3.value = '';
			document.form1.gubun4.value = '2';
			document.form1.s_dt.value = '';
			document.form1.e_dt.value = '';		
			document.form1.target = 'd_content';								
			document.form1.action = "esti_mng_atype_u.jsp";						
			document.form1.submit();				
		}
	}
//-->
</script>
</head>
<body>
<form action="esti_mng_abtype_proc.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">  
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">
  <input type="hidden" name="gubun4" value="<%=gubun4%>">
  <input type="hidden" name="gubun5" value="<%=gubun5%>">
  <input type="hidden" name="gubun6" value="<%=gubun6%>">  
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">          
  <input type="hidden" name="t_wd" value="<%=t_wd%>"> 
        
  <input type='hidden' name="esti_type"		value="a">    
  <input type="hidden" name="est_id" 		value="<%=est_id%>">  
  <input type="hidden" name="est_size"		value="<%=est_size%>">  
  <input type="hidden" name="set_code" 		value="<%=set_code%>">
  <input type='hidden' name="reg_id"		value="<%=bean.getReg_id()%>">    
  <%for(int j=0; j < est_yn.length; j++){%>   
  <input type="hidden" name="reg_code" value="<%=reg_code[j]%>">          
  <%}%>    
  <input type="hidden" name="est_check1" 	value="<%=est_check1%>">
  <input type="hidden" name="est_check2" 	value="<%=est_check2%>">  
  <input type="hidden" name="est_check3" 	value="<%=est_check3%>">
  <input type="hidden" name="est_check4" 	value="<%=est_check4%>"><!-- ������å���� 10������ ��� 2017.12.27 -->
  <input type="hidden" name="est_check5" 	value="<%=est_check5%>">
</form>
<script>
<%	if(count==1){%>
		<%if(est_reg_yn.equals("Y")){%>
		
		<%if(!est_check1.equals("") || !est_check2.equals("") || !est_check3.equals("") || !est_check4.equals("") || !est_check5.equals("")){ //�Ƹ���ī �����ŷ�ó�� ��� || �ֱ�30�� �̳� ������ ���� ��� || �ֱ�7�� �̳� ����Ʈ���� ��û�� ���� ��� || ������å���� 10���� ������ ��� 2017.12.27%>              		
		cust_check();
		<%}else{%>
		document.form1.action = "/agent/estimate_mng/esti_mng_abtype_proc.jsp";				
		document.form1.submit();	
		<%}%>
		
		<%}else{%>	
		//alert('������ ���� �϶��� ���Ǻ����ڷ� �ؾ� �ϸ�, ������ ������ �Ϲݽ��� �������� �ʽ��ϴ�.');
		alert('������ ������ ���Ǻ����ڷ� �����ؾ� �մϴ�. ������ �� Ʈ���� �Ϲݽ� ������ ���� �ʽ��ϴ�. ');
		<%}%>
<%	}else{%>
		<%if(est_reg_yn.equals("N")){%>
		//alert('������ ���� �϶��� ���Ǻ����ڷ� �ؾ� �ϸ�, ������ ������ Ʈ���� �Ϲݽ��� �������� �ʽ��ϴ�.');
		alert('������ ������ ���Ǻ����ڷ� �����ؾ� �մϴ�. ������ �� Ʈ���� �Ϲݽ� ������ ���� �ʽ��ϴ�. ');
		<%}else{%>	
		alert("�����߻�!");
		<%}%>
<%	}%>
</script>
</body>
</html>

