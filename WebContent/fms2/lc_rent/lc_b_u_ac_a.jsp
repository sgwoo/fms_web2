<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.res_search.*, cust.member.*, acar.ext.*, acar.car_sche.*, acar.cls.*"%>
<%@ page import="acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	String fee_size 	= request.getParameter("fee_size")		==null?"1":request.getParameter("fee_size");
	String now_stat	 	= request.getParameter("now_stat")		==null?"":request.getParameter("now_stat");
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag9 = true;
	boolean flag12 = true;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	
	if(idx.equals("0") || idx.equals("99")){
	
		//관리지점,영업대리인
		cont_etc.setMng_br_id		(request.getParameter("mng_br_id")	==null?"":request.getParameter("mng_br_id"));
		
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
%>





<%
	if(idx.equals("8") || idx.equals("99")){
	
	//차량기본정보-----------------------------------------------------------------------------------------------
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	car.setColo				(request.getParameter("color")			==null?"":request.getParameter("color"));
	car.setCar_ext		(request.getParameter("car_ext")		==null?"":request.getParameter("car_ext"));
	car.setRemark			(request.getParameter("remark")			==null?"":request.getParameter("remark"));
	car.setIn_col			(request.getParameter("in_col")			==null?"":request.getParameter("in_col"));
	car.setGarnish_col			(request.getParameter("garnish_col")			==null?"":request.getParameter("garnish_col"));
	
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	
	pur.setUdt_st				(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));
	
	//=====[CAR_PUR] update=====
	flag2 = a_db.updateContPur(pur);
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("9") || idx.equals("99")){
	
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
	car.setPurc_gu			(request.getParameter("purc_gu")		==null?"":request.getParameter("purc_gu"));
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
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, fee_size);
	
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
	flag2 = a_db.updateFeeEtc(fee_etc);
		

	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		

</script>
<%	}%>


<%
	if(idx.equals("10") || idx.equals("99")){
	
	//계약기본정보-----------------------------------------------------------------------------------------------
	
	base.setDriving_ext	(request.getParameter("driving_ext")	==null?"":request.getParameter("driving_ext"));
	base.setDriving_age	(request.getParameter("driving_age")	==null?"":request.getParameter("driving_age"));
	base.setGcp_kd			(request.getParameter("gcp_kd")			==null?"":request.getParameter("gcp_kd"));
	base.setBacdt_kd		(request.getParameter("bacdt_kd")		==null?"":request.getParameter("bacdt_kd"));
	base.setCar_ja			(request.getParameter("car_ja")			==null? 0:AddUtil.parseDigit(request.getParameter("car_ja")));
	base.setOthers			(request.getParameter("others")			==null?"":request.getParameter("others"));
	//=====[cont] update=====
	flag1 = a_db.updateContBaseNew(base);
	
	
	//계약기타정보-----------------------------------------------------------------------------------------------
	
	cont_etc.setInsur_per	(request.getParameter("insur_per")	==null?"":request.getParameter("insur_per"));
	cont_etc.setCanoisr_yn(request.getParameter("canoisr_yn")	==null?"":request.getParameter("canoisr_yn"));
	cont_etc.setCacdt_yn	(request.getParameter("cacdt_yn")	==null?"":request.getParameter("cacdt_yn"));
	cont_etc.setEme_yn		(request.getParameter("eme_yn")		==null?"":request.getParameter("eme_yn"));
	cont_etc.setInsurant	(request.getParameter("insurant")	==null?"":request.getParameter("insurant"));		
	cont_etc.setCom_emp_yn(request.getParameter("com_emp_yn")		==null?"":request.getParameter("com_emp_yn"));	
	
	//=====[cont_etc] update=====
	flag3 = a_db.updateContEtc(cont_etc);
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>



<%
	if(idx.equals("15") || idx.equals("99")){
	
	
		
	
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
					flag1 = a_db.insertCommiNew(emp1);
				}else{
					//=====[commi] update=====
					flag1 = a_db.updateCommiNew(emp1);
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
					flag2 = a_db.insertCommiNew(emp2);
				}else{
					//=====[commi] update=====
					flag2 = a_db.updateCommiNew(emp2);
				}
			}

			//출고정보-------------------------------------------------------------------------------------------
	
			pur.setUdt_st			(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));
			pur.setCon_amt		(request.getParameter("con_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("con_amt")));
			pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
			pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
			pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
			pur.setEst_car_no	(request.getParameter("est_car_no")	==null?"":request.getParameter("est_car_no"));
			pur.setCar_num		(request.getParameter("car_num")		==null?"":request.getParameter("car_num"));
			pur.setDlv_brch		(car_off_nm[1]);
	
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
		
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('영업담당 영업사원 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('출고담당 영업사원 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag3){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag4){	%>	alert('출고정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("delete") && base.getCar_mng_id().equals("")){
	
		if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){
		
				flag1 = a_db.deleteCont(rent_mng_id, rent_l_cd);
				
				System.out.println("계약삭제("+rent_l_cd+")-----------------------");
		}		
		%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약 삭제 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>      
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>  
  <input type='hidden' name='rent_st'	 		value=''>   
  <input type='hidden' name="now_stat"			value="<%=now_stat%>">              
</form>
<script language='javascript'>

	var fm = document.form1;
	
	<%if(idx.equals("delete")){%>
	fm.action = '<%=from_page%>';
	<%}else{%>
	fm.action = 'lc_b_u_ac.jsp';	
	<%}%>
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>