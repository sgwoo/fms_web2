<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.res_search.*,  acar.ext.*"%>
<%@ page import="acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//if(1==1)return;
	
	String auth_rw 			= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 			= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 				= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String car_gu 			= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 			= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	

	//차량기본정보-----------------------------------------------------------------------------------------------
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	car.setCar_cs_amt		(request.getParameter("car_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_cs_amt")));
	car.setCar_cv_amt		(request.getParameter("car_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_cv_amt")));
	car.setCar_fs_amt		(request.getParameter("car_fs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_fs_amt")));
	car.setCar_fv_amt		(request.getParameter("car_fv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_fv_amt")));
	car.setOpt_cs_amt		(request.getParameter("opt_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("opt_cs_amt")));
	car.setOpt_cv_amt		(request.getParameter("opt_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("opt_cv_amt")));
	car.setClr_cs_amt		(request.getParameter("col_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("col_cs_amt")));
	car.setClr_cv_amt		(request.getParameter("col_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("col_cv_amt")));
	car.setSd_cs_amt		(request.getParameter("sd_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cs_amt")));
	car.setSd_cv_amt		(request.getParameter("sd_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cv_amt")));
	car.setSd_fs_amt		(request.getParameter("sd_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cs_amt")));
	car.setSd_fv_amt		(request.getParameter("sd_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cv_amt")));
	car.setDc_cs_amt		(request.getParameter("dc_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("dc_cs_amt")));
	car.setDc_cv_amt		(request.getParameter("dc_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("dc_cv_amt")));
	car.setPay_st				(request.getParameter("pay_st")			==null?"":request.getParameter("pay_st"));
	car.setColo					(request.getParameter("color")			==null?"":request.getParameter("color"));
	car.setIn_col				(request.getParameter("in_col")			==null?"":request.getParameter("in_col"));
	car.setGarnish_col		(request.getParameter("garnish_col")			==null?"":request.getParameter("garnish_col"));
	car.setCar_ext			(request.getParameter("car_ext")		==null?"":request.getParameter("car_ext"));
	car.setPurc_gu			(request.getParameter("purc_gu")		==null?"":request.getParameter("purc_gu"));
	car.setRemark				(request.getParameter("remark")			==null?"":request.getParameter("remark"));
	car.setSh_car_amt		(request.getParameter("sh_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
	car.setSh_year			(request.getParameter("sh_year")		==null?"":request.getParameter("sh_year"));
	car.setSh_month			(request.getParameter("sh_month")		==null?"":request.getParameter("sh_month"));
	car.setSh_day				(request.getParameter("sh_day")			==null?"":request.getParameter("sh_day"));
	car.setSh_day_bas_dt(request.getParameter("sh_day_bas_dt")==null?"":request.getParameter("sh_day_bas_dt"));
	car.setSh_amt				(request.getParameter("sh_amt")			==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
	car.setSh_ja				(request.getParameter("sh_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
	car.setSh_km				(request.getParameter("sh_km")			==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
	car.setCommi_s_amt	(request.getParameter("commi_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("commi_s_amt")));
	car.setCommi_v_amt	(request.getParameter("commi_v_amt")==null? 0:AddUtil.parseDigit(request.getParameter("commi_v_amt")));
	car.setJg_opt_st		(request.getParameter("jg_opt_st")	==null?"":request.getParameter("jg_opt_st"));
	car.setJg_col_st		(request.getParameter("jg_col_st")	==null?"":request.getParameter("jg_col_st"));
	car.setAccid_serv_amt(request.getParameter("accid_serv_amt")==null? 0:AddUtil.parseDigit(request.getParameter("accid_serv_amt")));
	car.setSh_est_amt		(request.getParameter("sh_est_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_est_amt")));
	car.setSh_init_reg_dt(request.getParameter("sh_init_reg_dt")==null?"":request.getParameter("sh_init_reg_dt"));
	car.setAccid_serv_cont(request.getParameter("accid_serv_cont")==null?"":request.getParameter("accid_serv_cont"));
	car.setJg_tuix_st	(request.getParameter("jg_tuix_st")==null?"":request.getParameter("jg_tuix_st"));
	car.setJg_tuix_opt_st	(request.getParameter("jg_tuix_opt_st")==null?"":request.getParameter("jg_tuix_opt_st"));
	car.setStorage_s_amt	(request.getParameter("storage_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("storage_s_amt")));
	car.setStorage_v_amt	(request.getParameter("storage_v_amt")==null? 0:AddUtil.parseDigit(request.getParameter("storage_v_amt")));
	
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
	fee_etc.setSh_car_amt	(request.getParameter("sh_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
	fee_etc.setSh_year		(request.getParameter("sh_year")	==null?"":request.getParameter("sh_year"));
	fee_etc.setSh_month		(request.getParameter("sh_month")	==null?"":request.getParameter("sh_month"));
	fee_etc.setSh_day			(request.getParameter("sh_day")		==null?"":request.getParameter("sh_day"));
	fee_etc.setSh_day_bas_dt(request.getParameter("sh_day_bas_dt")	==null?"":request.getParameter("sh_day_bas_dt"));
	fee_etc.setSh_amt			(request.getParameter("sh_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
	fee_etc.setSh_ja			(request.getParameter("sh_ja")		==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
	fee_etc.setSh_km			(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
	fee_etc.setSh_init_reg_dt(request.getParameter("sh_init_reg_dt")	==null?"":request.getParameter("sh_init_reg_dt"));
		
	//=====[fee_etc] update=====
	flag6 = a_db.updateFeeEtc(fee_etc);
	
	
	//계약기본정보-----------------------------------------------------------------------------------------------
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//보유차 기본 보험
	base.setDriving_ext	("1");
	base.setDriving_age	("0");
	base.setGcp_kd			("2");
	base.setBacdt_kd		("2");
	base.setOthers			("");
	base.setReg_step		("4");
	base.setUse_yn			("Y");
	base.setDlv_dt			(request.getParameter("sh_init_reg_dt")==null?"":request.getParameter("sh_init_reg_dt"));
	
	//=====[cont] update=====
	flag2 = a_db.updateContBaseNew(base);


	//계약기타정보-----------------------------------------------------------------------------------------------
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//보유차 기본 보험
	cont_etc.setInsur_per	("1");
	cont_etc.setInsurant	("1");
	cont_etc.setCanoisr_yn("Y");
	cont_etc.setCacdt_yn	("N");
	cont_etc.setEme_yn		("N");
	cont_etc.setAir_ds_yn	("");
	cont_etc.setAir_as_yn	("");
	cont_etc.setAc_dae_yn	("");
	cont_etc.setPro_yn		("");
	cont_etc.setCyc_yn		("");
	cont_etc.setMain_yn		("");
	cont_etc.setMa_dae_yn	("");
	
	//관리지점,영업대리인
	cont_etc.setMng_br_id		(request.getParameter("mng_br_id")	==null?"":request.getParameter("mng_br_id"));
		
	
	//=====[cont_etc] update=====
	flag3 = a_db.updateContEtc(cont_etc);
	

	//영업소사원-------------------------------------------------------------------------------------------
	
	//commi
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "5");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "6");
	
	String emp_id[] 		= request.getParameterValues("emp_id");
	String car_off_nm[] = request.getParameterValues("car_off_nm");
	String sh_base_dt[] = request.getParameterValues("sh_base_dt");
	String commi[] 			= request.getParameterValues("commi");
	
	if(!emp_id[0].equals("")){
		
		emp1.setEmp_id		(emp_id[0]);
		emp1.setEmp_bank	(request.getParameter("emp_bank")	==null?"":request.getParameter("emp_bank"));
		emp1.setEmp_acc_no(request.getParameter("emp_acc_no")	==null?"":request.getParameter("emp_acc_no"));
		emp1.setEmp_acc_nm(request.getParameter("emp_acc_nm")	==null?"":request.getParameter("emp_acc_nm"));
		emp1.setCommi			(commi[0]==null?0:AddUtil.parseDigit(commi[0]));
		emp1.setSh_base_dt(sh_base_dt[0]==null?"":sh_base_dt[0]);
		emp1.setAgnt_st		("5");
		emp1.setCommi_st	("1");
		emp1.setBank_cd		(request.getParameter("emp_bank_cd")	==null?"":request.getParameter("emp_bank_cd"));
		emp1.setDlv_con_commi(request.getParameter("dlv_con_commi")	==null?0:AddUtil.parseDigit(request.getParameter("dlv_con_commi")));
		emp1.setFile_gubun1(request.getParameter("file_gubun1")	==null?"":request.getParameter("file_gubun1"));
		
		if(!emp1.getBank_cd().equals("")){
			emp1.setEmp_bank		(c_db.getNameById(emp1.getBank_cd(), "BANK"));
		}
		
		if(emp1.getRent_mng_id().equals("")){
			emp1.setRent_mng_id	(rent_mng_id);
			emp1.setRent_l_cd	(rent_l_cd);
			//=====[commi] insert=====
			flag9 = a_db.insertCommiNew(emp1);
		}else{
			//=====[commi] update=====
			flag9 = a_db.updateCommiNew(emp1);
		}
	}
	
		
	if(!emp_id[1].equals("")){
			
		emp2.setEmp_id		(emp_id[1]);
		emp2.setAgnt_st		("6");
		emp2.setCommi_st	("1");
		emp2.setCommi			(commi[1]==null?0:AddUtil.parseDigit(commi[1]));
		emp2.setSh_base_dt(sh_base_dt[1]==null?"":sh_base_dt[1]);
			
		if(emp2.getRent_mng_id().equals("")){
			emp2.setRent_mng_id	(rent_mng_id);
			emp2.setRent_l_cd	(rent_l_cd);
			//=====[commi] insert=====
			flag10 = a_db.insertCommiNew(emp2);
		}else{
			//=====[commi] update=====
			flag10 = a_db.updateCommiNew(emp2);
		}
	}



	//출고정보-------------------------------------------------------------------------------------------
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	pur.setUdt_st			(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));
	pur.setCon_amt		(request.getParameter("con_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("con_amt")));
	pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
	pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
	pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
	pur.setEst_car_no	(request.getParameter("est_car_no")	==null?"":request.getParameter("est_car_no"));
	pur.setCar_num		(request.getParameter("car_num")		==null?"":request.getParameter("car_num"));
	pur.setDlv_brch		(car_off_nm[1]);
		
	//=====[CAR_PUR] update=====
	flag11 = a_db.updateContPur(pur);


	//담당자자동배정
	
	//영업소별 관리담당 마지막배정자
	Vector max_mng_ids = rs_db.getBrchMaxMngIdLcContList(base.getBrch_id());
	int mng_users_size = max_mng_ids.size();
	String max_mng_id = "";
	
	for (int i = 0 ; i < mng_users_size ; i++){
		Hashtable user = (Hashtable)max_mng_ids.elementAt(i);
 		if(i==0){
			max_mng_id = String.valueOf(user.get("MNG_ID"));
 		}
	}
	
	//20151201 김태연 제외하고 모두
	//Vector mng_users = c_db.getUserList("", "", "RM_MNG_201512"); 
	//20171107 육아휴직 조영석 제외하고 모두
	Vector mng_users = c_db.getUserList("", "", "RM_MNG_201711"); 
	
	if(cont_etc.getMng_br_id().equals("K3")){	
		mng_users = c_db.getUserList("", "", "RM_MNG_K3"); 
	}else if(cont_etc.getMng_br_id().equals("B1")){	
		mng_users = c_db.getUserList("", "", "RM_MNG_B");
	}else if(cont_etc.getMng_br_id().equals("D1")){	
		mng_users = c_db.getUserList("", "", "RM_MNG_D");
	}else if(cont_etc.getMng_br_id().equals("G1")){	
		mng_users = c_db.getUserList("", "", "RM_MNG_G");
	}else if(cont_etc.getMng_br_id().equals("J1")){	
		mng_users = c_db.getUserList("", "", "RM_MNG_J");
	}
	
	int mng_user_size = mng_users.size();	
	
	int next_mng_idx = 0;
	
	for (int i = 0 ; i < mng_user_size ; i++){
		Hashtable user = (Hashtable)mng_users.elementAt(i);

       				//박근 조원규 정준형 조영석 제외
       				//if(String.valueOf(user.get("USER_NM")).equals("박근") || String.valueOf(user.get("USER_NM")).equals("조원규") || String.valueOf(user.get("USER_NM")).equals("정준형") || String.valueOf(user.get("USER_NM")).equals("조영석")) continue;
 		
		if(max_mng_id.equals(String.valueOf(user.get("USER_ID")))){
			next_mng_idx = i+1;
 		}
	}
					
	//마지막줄이면 첫줄사람으로 이동		
	if(next_mng_idx == mng_user_size){
		next_mng_idx = 0;
	}
	
	Hashtable next_user = (Hashtable)mng_users.elementAt(next_mng_idx);
		
	String next_mng_id = String.valueOf(next_user.get("USER_ID"));
				
	//System.out.println("#중고차 담담자 배정----------");
	//System.out.println("#영업소별 관리담당 마지막배정자 max_mng_id="+max_mng_id+"----------");
	//System.out.println("#영업소별 관리담당 배정자 next_mng_id="+next_mng_id+"----------");
	
	String bus_id2 = next_mng_id;
	base.setMng_id	(bus_id2);
		
	//=====[cont] insert=====
	flag1 = a_db.updateContBaseNew(base);
	
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 		value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="c_st" 				value="car">
</form>
<script language='javascript'>
	var fm = document.form1;

<%		if(!flag1){	%>
		alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		
	
<%		if(!flag2){	%>
		alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag3){	%>
		alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag6){	%>
		alert('대여기타 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag9){	%>
		alert('영업담당영업사원 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag10){%>
		alert('출고담당영업사원 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag11){%>
		alert('출고정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

	fm.action = 'lc_c_frame.jsp';
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>