<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.cls.*,  acar.fee.*, acar.car_office.*,  acar.ext.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_mst.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	//if(1==1)return;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cls_st	 		= request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	
	String car_no 			= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_mng_id		= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String old_rent_mng_id 	= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 	= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	String from_page 		= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	boolean flag10 = true;
	boolean flag11 = true;
	boolean flag12 = true;
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();


	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");	
		
	//�����⺻����-----------------------------------------------------------------------------------------------
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);	
	
	//�ڵ����⺻����
	CarMstBean old_cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	
	
	//�縮�� ���� �����
	if(base.getCar_gu().equals("0")){
		
		//���������� ��������� ��ȯ
		String new_rent_l_cd2 = as_db.getNextRent_l_cd(rent_l_cd.substring(0, 7)+"S");//�ű԰���ڵ�
		flag8 = a_db.insertReContEtcRows2(rent_mng_id, rent_l_cd, new_rent_l_cd2, base.getRent_dt());
		
		
		//�������� ������ ���⺻����
		ContBaseBean old_base = a_db.getContBase(old_rent_mng_id, old_rent_l_cd);
		
		//�������� ���� �ִ� ������ ����� ��뿩�θ� N���� ����
		flag3 = a_db.updateUseynDt(old_rent_mng_id, old_rent_l_cd, base.getRent_dt());
				
		base.setCar_mng_id	(car_mng_id);
		base.setDlv_dt		(old_base.getDlv_dt());
		//=====[cont] update=====
		flag1 = a_db.updateContBaseNew(base);
		
		
		//���������� �����⺻ �ѱ��
		car = a_db.getContCarNew(old_rent_mng_id, old_rent_l_cd);
		car.setRent_mng_id	(rent_mng_id);
		car.setRent_l_cd	(rent_l_cd);
		car.setSh_car_amt	(request.getParameter("sh_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
		car.setSh_year		(request.getParameter("sh_year")	==null?"":request.getParameter("sh_year"));
		car.setSh_month		(request.getParameter("sh_month")	==null?"":request.getParameter("sh_month"));
		car.setSh_day		(request.getParameter("sh_day")		==null?"":request.getParameter("sh_day"));
		car.setSh_day_bas_dt(request.getParameter("sh_day_bas_dt")==null?"":request.getParameter("sh_day_bas_dt"));
		car.setSh_amt		(request.getParameter("sh_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
		car.setSh_ja		(request.getParameter("sh_ja")		==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
		car.setSh_km		(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
		car.setSh_km_bas_dt	(request.getParameter("sh_km_bas_dt")==null?"":request.getParameter("sh_km_bas_dt"));
		
		//=====[car_etc] update=====
		flag3 = a_db.updateContCarNew(car);
		
		//���������� �Һ� �ѱ��
		ContDebtBean c_debt = a_db.getContDebt(old_rent_mng_id, old_rent_l_cd);	
		c_debt.setRent_mng_id	(rent_mng_id);
		c_debt.setRent_l_cd		(rent_l_cd);
		flag3 = a_db.updateContDebt(c_debt);
		
		//���������� �������� �ѱ��
		ContPurBean c_pur = a_db.getContPur(old_rent_mng_id, old_rent_l_cd);
		c_pur.setRent_mng_id	(rent_mng_id);
		c_pur.setRent_l_cd		(rent_l_cd);
		flag3 = a_db.updateContPur(c_pur);
		
		//fee_etc
		fee_etc.setSh_car_amt	(request.getParameter("sh_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
		fee_etc.setSh_year		(request.getParameter("sh_year")	==null?"":request.getParameter("sh_year"));
		fee_etc.setSh_month		(request.getParameter("sh_month")	==null?"":request.getParameter("sh_month"));
		fee_etc.setSh_day		(request.getParameter("sh_day")		==null?"":request.getParameter("sh_day"));
		fee_etc.setSh_day_bas_dt(request.getParameter("sh_day_bas_dt")==null?"":request.getParameter("sh_day_bas_dt"));
		fee_etc.setSh_amt		(request.getParameter("sh_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
		fee_etc.setSh_ja		(request.getParameter("sh_ja")		==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
		fee_etc.setSh_km		(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
		fee_etc.setSh_tot_km	(request.getParameter("sh_tot_km")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_tot_km")));
		fee_etc.setSh_km_bas_dt	(request.getParameter("sh_km_bas_dt")==null?"":request.getParameter("sh_km_bas_dt"));
		fee_etc.setSh_init_reg_dt(request.getParameter("sh_init_reg_dt")==null?"":request.getParameter("sh_init_reg_dt"));
		if(fee_etc.getRent_mng_id().equals("")){
			fee_etc.setRent_mng_id	(rent_mng_id);
			fee_etc.setRent_l_cd	(rent_l_cd);
			fee_etc.setRent_st		("1");
			//=====[fee_etc] insert=====
			flag2 = a_db.insertFeeEtc(fee_etc);
		}else{
			//=====[fee_etc] update=====
			flag2 = a_db.updateFeeEtc(fee_etc);
		}
		
		//�縮�� ���� ���� ��� / �ڵ��������� ������������, ����������, �縮������ �ʱ�ȭ
		int sr_result = 0;
		sr_result = shDb.shRes_all_cancel(car_mng_id);
				
		
	//���� ���� �����
	}else if(base.getCar_gu().equals("1")){
		
		car.setCar_cs_amt	(request.getParameter("car_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_cs_amt")));
		car.setCar_cv_amt	(request.getParameter("car_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_cv_amt")));
		car.setCar_fs_amt	(request.getParameter("car_fs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_fs_amt")));
		car.setCar_fv_amt	(request.getParameter("car_fv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_fv_amt")));
		car.setOpt_cs_amt	(request.getParameter("opt_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("opt_cs_amt")));
		car.setOpt_cv_amt	(request.getParameter("opt_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("opt_cv_amt")));
		car.setClr_cs_amt	(request.getParameter("col_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("col_cs_amt")));
		car.setClr_cv_amt	(request.getParameter("col_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("col_cv_amt")));
		car.setSd_cs_amt	(request.getParameter("sd_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cs_amt")));
		car.setSd_cv_amt	(request.getParameter("sd_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cv_amt")));
		car.setSd_fs_amt	(request.getParameter("sd_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cs_amt")));
		car.setSd_fv_amt	(request.getParameter("sd_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cv_amt")));
		car.setDc_cs_amt	(request.getParameter("dc_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("dc_cs_amt")));
		car.setDc_cv_amt	(request.getParameter("dc_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("dc_cv_amt")));
		car.setS_dc1_amt	(request.getParameter("s_dc1_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc1_amt")));
		car.setS_dc2_amt	(request.getParameter("s_dc2_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc2_amt")));
		car.setS_dc3_amt	(request.getParameter("s_dc3_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc3_amt")));
		car.setPay_st		(request.getParameter("pay_st")		==null?"":request.getParameter("pay_st"));
		car.setSpe_tax		(request.getParameter("spe_tax")	==null? 0:AddUtil.parseDigit(request.getParameter("spe_tax")));
		car.setEdu_tax		(request.getParameter("edu_tax")	==null? 0:AddUtil.parseDigit(request.getParameter("edu_tax")));
		car.setS_dc1_re		(request.getParameter("s_dc1_re")	==null?"":request.getParameter("s_dc1_re"));
		car.setS_dc2_re		(request.getParameter("s_dc2_re")	==null?"":request.getParameter("s_dc2_re"));
		car.setS_dc3_re		(request.getParameter("s_dc3_re")	==null?"":request.getParameter("s_dc3_re"));
		car.setS_dc1_yn		(request.getParameter("s_dc1_yn")	==null?"":request.getParameter("s_dc1_yn"));
		car.setS_dc2_yn		(request.getParameter("s_dc2_yn")	==null?"":request.getParameter("s_dc2_yn"));
		car.setS_dc3_yn		(request.getParameter("s_dc3_yn")	==null?"":request.getParameter("s_dc3_yn"));		
		car.setCar_id		(request.getParameter("car_id")		==null?"":request.getParameter("car_id"));
		car.setCar_seq		(request.getParameter("car_seq")	==null?"":request.getParameter("car_seq"));
		car.setOpt			(request.getParameter("opt")		==null?"":request.getParameter("opt"));
		car.setOpt_code		(request.getParameter("opt_seq")	==null?"":request.getParameter("opt_seq"));
		car.setColo			(request.getParameter("col")		==null?"":request.getParameter("col"));
		car.setIn_col			(request.getParameter("in_col")			==null?"":request.getParameter("in_col"));
		car.setGarnish_col			(request.getParameter("garnish_col")			==null?"":request.getParameter("garnish_col"));
		car.setS_dc1_re_etc	(request.getParameter("s_dc1_re_etc")==null?"":request.getParameter("s_dc1_re_etc"));
		car.setS_dc2_re_etc	(request.getParameter("s_dc2_re_etc")==null?"":request.getParameter("s_dc2_re_etc"));
		car.setS_dc3_re_etc	(request.getParameter("s_dc3_re_etc")==null?"":request.getParameter("s_dc3_re_etc"));
		car.setS_dc1_per	(request.getParameter("s_dc1_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc1_per")));
		car.setS_dc2_per	(request.getParameter("s_dc2_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc2_per")));
		car.setS_dc3_per	(request.getParameter("s_dc3_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc3_per")));
		car.setJg_opt_st	(request.getParameter("jg_opt_st")==null?"":request.getParameter("jg_opt_st"));
		car.setJg_col_st	(request.getParameter("jg_col_st")==null?"":request.getParameter("jg_col_st"));
		car.setJg_tuix_st	(request.getParameter("jg_tuix_st")==null?"":request.getParameter("jg_tuix_st"));
		car.setJg_tuix_opt_st	(request.getParameter("jg_tuix_opt_st")==null?"":request.getParameter("jg_tuix_opt_st"));		
		
		//=====[car_etc] update=====
		flag1 = a_db.updateContCarNew(car);
		
		
		//�������� ���� ��� ������رݾ� ����
		if(!emp1.getRent_mng_id().equals("") && emp1.getCommi() >0){
			emp1.setCommi_car_amt(request.getParameter("commi_car_amt")==null? 0:AddUtil.parseDigit(request.getParameter("commi_car_amt")));
			emp1.setCommi		(request.getParameter("commi")		==null? 0:AddUtil.parseDigit(request.getParameter("commi")));
			//=====[commi] update=====
			flag1 = a_db.updateCommiNew(emp1);
		}
		
		
		//����Ÿ����-----------------------------------------------------------------------------------------------		
		//cont_etc
		ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		
		// ÷�ܾ�����ġ ����(Ʈ���� ���Ե� ���� �ɼǿ� ������ ��� ��� Y)		2017.11.27		start
		cont_etc.setLkas_yn		(request.getParameter("lkas_yn")			==null?"":request.getParameter("lkas_yn"));
		if(request.getParameter("lkas_yn_opt_st").equals("Y")){
			cont_etc.setLkas_yn("Y");
		}
		cont_etc.setLdws_yn		(request.getParameter("ldws_yn")			==null?"":request.getParameter("ldws_yn"));
		if(request.getParameter("ldws_yn_opt_st").equals("Y")){
			cont_etc.setLdws_yn("Y");
		}
		cont_etc.setAeb_yn		(request.getParameter("aeb_yn")			==null?"":request.getParameter("aeb_yn"));
		if(request.getParameter("aeb_yn_opt_st").equals("Y")){
			cont_etc.setAeb_yn("Y");
		}
		cont_etc.setFcw_yn		(request.getParameter("fcw_yn")			==null?"":request.getParameter("fcw_yn"));
		if(request.getParameter("fcw_yn_opt_st").equals("Y")){
			cont_etc.setFcw_yn("Y");
		}
		// ÷�ܾ�����ġ end
		cont_etc.setGarnish_yn	(request.getParameter("garnish_yn")		==null?"":request.getParameter("garnish_yn"));
		if(request.getParameter("garnish_yn_opt_st").equals("Y")){
			cont_etc.setGarnish_yn("Y");
		}
		cont_etc.setHook_yn	(request.getParameter("hook_yn")			==null?"":request.getParameter("hook_yn"));
		if(request.getParameter("hook_yn_opt_st").equals("Y")){
			cont_etc.setHook_yn("Y");
		}
		
		
		cont_etc.setCar_cng_yn		("Y");
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag2 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag2 = a_db.updateContEtc(cont_etc);
		}
		
	}
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	if(!old_cm_bean.getJg_code().equals(cm_bean.getJg_code())){
	
		//�ܰ�����NEW
		ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
		//20151211 ����,�縮�� ��� ǥ�ؾ�������Ÿ� ����  	
		fee_etc.setAgree_dist(30000);
		
		if(AddUtil.parseInt(ej_bean.getReg_dt()) >= 20220415){
			fee_etc.setAgree_dist(23000);
		}
		
		//���� +5000
		if(ej_bean.getJg_b().equals("1")){
			fee_etc.setAgree_dist(fee_etc.getAgree_dist()+5000);
		}				

		//LPG +10000 -> 20190418 +5000
		if(ej_bean.getJg_b().equals("2")){
			fee_etc.setAgree_dist(fee_etc.getAgree_dist()+5000);
		}
	
		//�׽��� ��������Ÿ� 2�� ���� - 20190801 �ʰ��δ�� 450�� ����
// 		if(cm_bean.getJg_code().equals("4854") || cm_bean.getJg_code().equals("5866") || cm_bean.getJg_code().equals("3871") || cm_bean.getJg_code().equals("4314111") || cm_bean.getJg_code().equals("6316111") || cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("3313112") || cm_bean.getJg_code().equals("3313113") || cm_bean.getJg_code().equals("3313114")){
		if(cm_bean.getCar_comp_id().equals("0056")){
			if(AddUtil.parseDecimal(fee_etc.getAgree_dist()).equals("0")){
				fee_etc.setOver_run_amt(450);
			}
		} 

		//=====[fee_etc] update=====
		flag6 = a_db.updateFeeEtc(fee_etc);	
	
	}
	
	
	//�������
	if(from_page.equals("/agent/lc_rent/lc_cng_car_frame.jsp")){
		//=====[cont] update=====
		flag2 = a_db.updateContSanction(rent_mng_id, rent_l_cd, "sanction_cancel", ck_acar_id, "");
	}
	
	

%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="c_st" 				value="fee">    
</form>
<script language='javascript'>
	var fm = document.form1;

	
<%		if(!flag1){	%>
		alert('����� �������� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');
<%		}	%>		

<%		if(!flag2){	%>
		alert('�°��� �⺻���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');
<%		}	%>		

<%		if(!flag3){	%>
		alert('�������̺� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');
<%		}	%>		

<%		if(!flag4){	%>
		alert('������ ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');
<%		}	%>		

<%		if(!flag5){	%>
		alert('��ǥ�ں��� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');
<%		}	%>		

<%		if(!flag6){	%>
		alert('���뺸�� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');
<%		}	%>		

<%		if(!flag7){	%>
		alert('�뿩�ὺ���� �̰� �����Դϴ�.\n\nȮ���Ͻʽÿ�');
<%		}	%>		

<%		if(!flag8){	%>
		alert('����� �⺻���� ���� �����Դϴ�.\n\nȮ���Ͻʽÿ�');
<%		}	%>		

	fm.action = '/agent/lc_rent/lc_b_u.jsp';
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>