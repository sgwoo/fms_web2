<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.ext.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//if(1==1)return;
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
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
	int flag = 0;



	//계약기본정보-----------------------------------------------------------------------------------------------
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	base.setRent_end_dt	(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
	
	//=====[cont] update=====
	flag2 = a_db.updateContBaseNew(base);


	//대여기타정보-------------------------------------------------------------------------------------------
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	fee_etc.setSh_car_amt		(request.getParameter("sh_car_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
	fee_etc.setSh_year			(request.getParameter("sh_year")		==null?"":request.getParameter("sh_year"));
	fee_etc.setSh_month			(request.getParameter("sh_month")		==null?"":request.getParameter("sh_month"));
	fee_etc.setSh_day			(request.getParameter("sh_day")			==null?"":request.getParameter("sh_day"));
	fee_etc.setSh_day_bas_dt	(request.getParameter("sh_day_bas_dt")	==null?"":request.getParameter("sh_day_bas_dt"));
	fee_etc.setSh_amt			(request.getParameter("sh_amt")			==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
	fee_etc.setSh_ja			(request.getParameter("sh_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
	fee_etc.setSh_km			(request.getParameter("sh_km")			==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
	fee_etc.setSh_km_bas_dt		(request.getParameter("sh_km_bas_dt")	==null?"":request.getParameter("sh_km_bas_dt"));
	fee_etc.setBus_agnt_id		(request.getParameter("bus_agnt_id")	==null?"":request.getParameter("bus_agnt_id"));
	fee_etc.setBus_agnt_per		(request.getParameter("bus_agnt_per")	==null? 0:AddUtil.parseFloat(request.getParameter("bus_agnt_per")));
	fee_etc.setBus_agnt_r_per	(request.getParameter("bus_agnt_r_per")	==null? 0:AddUtil.parseFloat(request.getParameter("bus_agnt_r_per")));
	fee_etc.setCls_n_mon		(request.getParameter("cls_n_mon")		==null?"":request.getParameter("cls_n_mon"));
	
	if(fee_etc.getRent_mng_id().equals("")){
		fee_etc.setRent_mng_id		(rent_mng_id);
		fee_etc.setRent_l_cd		(rent_l_cd);
		fee_etc.setRent_st			(rent_st);
		//=====[fee_etc] insert=====
		flag1 = a_db.insertFeeEtc(fee_etc);
	}else{
		//=====[fee_etc] update=====
		flag1 = a_db.updateFeeEtc(fee_etc);
	}


	//대여정보-------------------------------------------------------------------------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	fee.setRent_st			(rent_st);//연장 일련번호
	fee.setExt_agnt			(request.getParameter("ext_agnt")	==null? "":request.getParameter("ext_agnt"));
	fee.setRent_dt			(request.getParameter("rent_dt")	==null? "":request.getParameter("rent_dt"));
	fee.setCon_mon			(request.getParameter("con_mon")		==null?"":request.getParameter("con_mon"));
	fee.setRent_start_dt	(request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt"));
	fee.setRent_end_dt		(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
	
	fee.setGrt_amt_s		(request.getParameter("grt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("grt_s_amt")));
	fee.setGur_per			(request.getParameter("gur_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_per")));
	fee.setGur_p_per		(request.getParameter("gur_p_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
	fee.setGrt_suc_yn		(request.getParameter("grt_suc_yn")		==null?"":request.getParameter("grt_suc_yn"));
	
	fee.setPp_s_amt			(request.getParameter("pp_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	fee.setPp_v_amt			(request.getParameter("pp_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("pp_v_amt")));
	fee.setPere_per			(request.getParameter("pere_per")		==null? 0:AddUtil.parseFloat(request.getParameter("pere_per")));
	fee.setPere_r_per		(request.getParameter("pere_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("pere_r_per")));
	fee.setPp_est_dt		(request.getParameter("pp_est_dt")		==null?"":request.getParameter("pp_est_dt"));
	
	fee.setIfee_s_amt		(request.getParameter("ifee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
	fee.setIfee_v_amt		(request.getParameter("ifee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ifee_v_amt")));
	fee.setPere_mth			(request.getParameter("pere_mth")		==null? 0:AddUtil.parseDigit(request.getParameter("pere_mth")));
	fee.setPere_r_mth		(request.getParameter("pere_r_mth")		==null? 0:AddUtil.parseDigit(request.getParameter("pere_r_mth")));
	fee.setIfee_suc_yn		(request.getParameter("ifee_suc_yn")	==null?"":request.getParameter("ifee_suc_yn"));	
	
	fee.setOpt_s_amt		(request.getParameter("opt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("opt_s_amt")));
	fee.setOpt_v_amt		(request.getParameter("opt_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("opt_v_amt")));
	fee.setOpt_chk			(request.getParameter("opt_chk")		==null?"":request.getParameter("opt_chk"));
	fee.setOpt_per			(request.getParameter("opt_per")		==null?"":request.getParameter("opt_per"));
	
	fee.setMax_ja			(request.getParameter("max_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("max_ja")));
	fee.setApp_ja			(request.getParameter("app_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("app_ja")));
	fee.setJa_s_amt			(request.getParameter("ja_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_s_amt")));
	fee.setJa_v_amt			(request.getParameter("ja_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_v_amt")));
	fee.setJa_r_s_amt		(request.getParameter("ja_r_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_r_s_amt")));
	fee.setJa_r_v_amt		(request.getParameter("ja_r_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_r_v_amt")));
	
	fee.setFee_s_amt		(request.getParameter("fee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_s_amt")));
	fee.setFee_v_amt		(request.getParameter("fee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_v_amt")));
	fee.setInv_s_amt		(request.getParameter("inv_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_s_amt")));
	fee.setInv_v_amt		(request.getParameter("inv_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_v_amt")));
	fee.setDc_ra			(request.getParameter("dc_ra")			==null? 0:AddUtil.parseFloat(request.getParameter("dc_ra")));
	fee.setBas_dt			(request.getParameter("bas_dt")			==null?"":request.getParameter("bas_dt"));
	
	fee.setCls_per			(request.getParameter("cls_per")		==null?"":request.getParameter("cls_per"));
	fee.setCls_r_per		(request.getParameter("cls_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("cls_r_per")));
	
	fee.setCredit_per		(request.getParameter("credit_per")		==null? 0:AddUtil.parseFloat(request.getParameter("credit_per")));
	fee.setCredit_r_per		(request.getParameter("credit_r_per")	==null? 0:AddUtil.parseFloat(request.getParameter("credit_r_per")));
	fee.setCredit_amt		(request.getParameter("credit_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("credit_amt")));
	fee.setCredit_r_amt		(request.getParameter("credit_r_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("credit_r_amt")));
	
	fee.setFee_sac_id		(request.getParameter("fee_sac_id")		==null?"":request.getParameter("fee_sac_id"));
	fee.setFee_pay_tm		(request.getParameter("fee_pay_tm")		==null?"":request.getParameter("fee_pay_tm"));
	fee.setFee_est_day		(request.getParameter("fee_est_day")	==null?"":request.getParameter("fee_est_day"));
	fee.setFee_pay_start_dt	(request.getParameter("fee_pay_start_dt")==null?"":request.getParameter("fee_pay_start_dt"));
	fee.setFee_pay_end_dt	(request.getParameter("fee_pay_end_dt")	==null?"":request.getParameter("fee_pay_end_dt"));
	fee.setFee_cdt			(request.getParameter("fee_cdt")		==null?"":request.getParameter("fee_cdt"));	
	
	fee.setFee_fst_dt		(request.getParameter("fee_fst_dt")		==null?"":request.getParameter("fee_fst_dt"));
	fee.setFee_fst_amt		(request.getParameter("fee_fst_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("fee_fst_amt")));
	
	
	
	//=====[fee] insert=====
	flag5 = a_db.insertContFee(fee);
	//=====[fee] update=====
	flag5 = a_db.updateContFeeNew(fee);
	
	
	//선수금 스케줄 생성
	
	/*보증금, 선납금, 개시대여료 table에 insert해준다*/
	ExtScdBean grt = new ExtScdBean();
	grt.setRent_mng_id	(rent_mng_id);
	grt.setRent_l_cd	(rent_l_cd);
	grt.setRent_st		(fee.getRent_st());
	grt.setRent_seq		("1");
	grt.setExt_id		("0");
	grt.setExt_st		("0");					//0:보증금
	grt.setExt_tm		("1");
	grt.setExt_est_dt	(fee.getGrt_est_dt());
	grt.setExt_s_amt	(0);  //초기화 (20071224 :승계인 경우는 0로)
	grt.setExt_v_amt	(0);  //초기화 
	//금액 별도일때(위 대여에 대한 승계가 아님)
	if(fee.getGrt_suc_yn().equals("1")){
		grt.setExt_s_amt	(fee.getGrt_amt_s());	//보증금은 부가세 없다
		grt.setExt_v_amt	(0);
	}
	grt.setUpdate_id	(user_id);
	if(!ae_db.insertGrt(grt))	flag += 1;
	
	ExtScdBean pp = new ExtScdBean();
	pp.setRent_mng_id	(rent_mng_id);
	pp.setRent_l_cd		(rent_l_cd);
	pp.setRent_st		(fee.getRent_st());
	pp.setExt_st		("1");					//1:선납금
	pp.setExt_tm		("1");
	pp.setRent_seq		("1");
	pp.setExt_id		("0");
	pp.setExt_est_dt	(fee.getPp_est_dt());
	pp.setExt_s_amt		(fee.getPp_s_amt());
	pp.setExt_v_amt		(fee.getPp_v_amt());
	pp.setUpdate_id		(user_id);
	if(!ae_db.insertGrt(pp))	flag += 1;

	ExtScdBean ifee = new ExtScdBean();
	ifee.setRent_mng_id	(rent_mng_id);
	ifee.setRent_l_cd	(rent_l_cd);
	ifee.setRent_st		(fee.getRent_st());
	ifee.setRent_seq	("1");
	ifee.setExt_id		("0");
	ifee.setExt_st		("2");					//2:개시대여료
	ifee.setExt_tm		("1");
	ifee.setExt_est_dt	(fee.getIfee_est_dt());
	if(fee.getIfee_suc_yn().equals("1")){
		ifee.setExt_s_amt(fee.getIfee_s_amt());
		ifee.setExt_v_amt(fee.getIfee_v_amt());
	}
	ifee.setUpdate_id	(user_id);
	if(!ae_db.insertGrt(ifee))	flag += 1;
	
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

	
<%		if(!flag2){	%>
		alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag5){	%>
		alert('대여정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag6){	%>
		alert('선수금스케줄 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag1){	%>
		alert('대여기타정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

	fm.action = 'lc_c_frame.jsp';
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>