<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*, acar.con_ins.*,acar.cont.*,acar.client.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int o_1 			= request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1"));
	int grt_amt 		= request.getParameter("grt_amt")==null?0:AddUtil.parseDigit(request.getParameter("grt_amt"));
	int pp_amt 			= request.getParameter("pp_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_amt"));
	int t_ifee_s_amt 	= request.getParameter("ifee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("ifee_s_amt"));
	int t_fee_s_amt 	= request.getParameter("fee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int add_opt_amt		= request.getParameter("add_opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("add_opt_amt"));
	String lpg_setter 	= request.getParameter("lpg_setter")==null?"":request.getParameter("lpg_setter");
	String lpg_kit	 	= request.getParameter("lpg_kit")==null?"":request.getParameter("lpg_kit");
	String gi_st 		= request.getParameter("gi_st")==null?"":request.getParameter("gi_st");
	String s_st 		= request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String rent_dt 		= request.getParameter("rent_dt")==null?"":AddUtil.replace(request.getParameter("rent_dt"),"-","");
	String rent_start_dt= request.getParameter("rent_start_dt")==null?"":AddUtil.replace(request.getParameter("rent_start_dt"),"-","");
	String ext_rent_dt	= request.getParameter("ext_rent_dt")==null?"":AddUtil.replace(request.getParameter("ext_rent_dt"),"-","");
	String esti_stat	= request.getParameter("esti_stat")==null?"":request.getParameter("esti_stat");
	String rent_mng_id	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String est_from 	= request.getParameter("est_from")==null?"car_rent":request.getParameter("est_from");
	String rent_st 		= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String fee_rent_st	= request.getParameter("fee_rent_st")==null?"1":request.getParameter("fee_rent_st");
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");
	String comm_r_rt	= request.getParameter("comm_r_rt")==null?"":request.getParameter("comm_r_rt");
	String udt_st		= request.getParameter("udt_st")==null?"":request.getParameter("udt_st");
	String insur_per	= request.getParameter("insur_per")==null?"":request.getParameter("insur_per");
	String one_self		= request.getParameter("one_self")==null?"":request.getParameter("one_self");	
	
	String br_to_st	= request.getParameter("br_to_st")	==null?"":request.getParameter("br_to_st");
	String br_to		= request.getParameter("br_to")		==null?"":request.getParameter("br_to");
	String br_from		= request.getParameter("br_from")	==null?"":request.getParameter("br_from");
	
	int agree_dist	= request.getParameter("agree_dist")==null?0:AddUtil.parseDigit(request.getParameter("agree_dist"));
	int cls_n_mon	= request.getParameter("cls_n_mon")==null?0:AddUtil.parseDigit(request.getParameter("cls_n_mon"));
	int count = 0;
	
	
	if(!fee_rent_st.equals("")) rent_st = fee_rent_st;
	
	//위약금면제 무시
	cls_n_mon = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//보험정보
	String ins_st = ai_db.getInsSt(car_mng_id);
	InsurBean ins = ai_db.getIns(car_mng_id, ins_st);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(rent_dt.equals("")) rent_dt = base.getRent_dt();
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//CAR_NM : 차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	
	//첫번째대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	//해당대여정보
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	if(rent_st.equals("")){
		rent_st = Integer.toString(fee_size);
	}
	
	if(!rent_st.equals("1") && car_gu.equals("1")){
		car_gu = "0";
	}
	
	if(!rent_st.equals("1") && !ext_rent_dt.equals("")) 	rent_dt = ext_rent_dt;
	
	
	//견적관리번호 생성
	String est_id = Long.toString(System.currentTimeMillis());
	bean.setEst_type	("L");
	/*고객정보*/
	bean.setEst_id		(est_id);
	bean.setEst_nm		(client.getFirm_nm());
	bean.setEst_ssn		(client.getEnp_no1()+""+client.getEnp_no1()+""+client.getEnp_no1());
	bean.setEst_tel		(client.getO_tel());
	bean.setEst_fax		(client.getFax());
	
	/*차량정보*/
	bean.setCar_comp_id	(cm_bean.getCar_comp_id());
	bean.setCar_cd		(cm_bean.getCode());
	bean.setCar_id		(cm_bean.getCar_id());
	bean.setCar_seq		(cm_bean.getCar_seq());
	bean.setCar_amt		(request.getParameter("car_c_amt")	==null?0:AddUtil.parseDigit(request.getParameter("car_c_amt")));
	bean.setOpt			(request.getParameter("opt")		==null?"":request.getParameter("opt"));
	bean.setOpt_seq		(request.getParameter("opt_code")	==null?"":request.getParameter("opt_code"));
	bean.setOpt_amt		(request.getParameter("opt_c_amt")	==null?0:AddUtil.parseDigit(request.getParameter("opt_c_amt"))+add_opt_amt);
	bean.setCol			(request.getParameter("color")		==null?"":request.getParameter("color"));
	bean.setCol_amt		(request.getParameter("col_c_amt")	==null?0:AddUtil.parseDigit(request.getParameter("col_c_amt")));
	bean.setDc_amt		(request.getParameter("t_dc_amt")	==null?0:AddUtil.parseDigit(request.getParameter("t_dc_amt")));
	bean.setO_1			(o_1);
	
	//대여상품
	String a_a = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	if(a_a.equals(""))				a_a = base.getCar_st();
	if(a_a.equals("3"))				a_a = "1";
	else if(a_a.equals("1"))		a_a = "2";
	String rent_way = request.getParameter("rent_way")==null?"":request.getParameter("rent_way");
	if(rent_way.equals(""))			rent_way = fees.getRent_way();
	if(rent_way.equals("3"))		rent_way = "2";
	bean.setA_a			(a_a+""+rent_way);
	
	//대여기간
	bean.setA_b			(request.getParameter("con_mon")==null?"":request.getParameter("con_mon"));
	
	if(cls_n_mon >0){
		bean.setA_b(String.valueOf(AddUtil.parseInt(bean.getA_b())-cls_n_mon));
	}
	
	
	//등록지역
	String t_car_ext = request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	String a_h = t_car_ext;
	if(a_h.equals("")) a_h = car.getCar_ext();
	bean.setA_h			(a_h);
	
	//초기납입구분
	String pp_st = "";
	if(t_ifee_s_amt > 0) 			pp_st = "1";
	if(pp_amt+grt_amt > 0) 			pp_st = "2";
	if(pp_st.equals(""))			pp_st = "0";
	bean.setPp_st		(pp_st);
	//적용선납율
	bean.setPp_per		(request.getParameter("pere_r_per")==null?0:AddUtil.parseFloat(request.getParameter("pere_r_per")));
	//적용선납금액
	bean.setPp_amt		(pp_amt);
	//적용보증금율
	bean.setRg_8		(request.getParameter("gur_p_per")==null?0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
	//개시대여료적용개월수
	int g_10 = 0;
	if(t_ifee_s_amt>0 && t_fee_s_amt>0){
		g_10 = Math.round(t_ifee_s_amt/t_fee_s_amt);
		
		float g_10_f = Math.round(AddUtil.parseFloat(String.valueOf(t_ifee_s_amt))/AddUtil.parseFloat(String.valueOf(t_fee_s_amt)));
		g_10 = AddUtil.parseInt(String.valueOf(Math.round(g_10_f)));
	}
	bean.setG_10		(g_10);
	
	//잔존가치율
	String ro_13 = request.getParameter("ro_13")==null?"0":request.getParameter("ro_13");
	int opt_amt = request.getParameter("o_13_amt")==null?0:AddUtil.parseDigit(request.getParameter("o_13_amt"));
	bean.setRo_13		(AddUtil.parseFloat(ro_13));
	bean.setO_13		(AddUtil.parseFloat(request.getParameter("o_13")==null?"0":request.getParameter("o_13")));
	
	//적용잔가금액
	bean.setRo_13_amt	(opt_amt);
	//적용보증금액
	bean.setRg_8_amt	(grt_amt);
	//대여료DC율
	//bean.setFee_dc_per	();
	
	//적용영업수당율
	bean.setO_11		(request.getParameter("comm_r_rt")==null?0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
	
	//애니카보험가입여부
	String eme_yn = request.getParameter("eme_yn")==null?"":request.getParameter("eme_yn");
	if(eme_yn.equals("")) eme_yn = cont_etc.getEme_yn();
	String ins_good = "0";
	if(eme_yn.equals("Y"))	ins_good = "1";
	bean.setIns_good	(ins_good);
	//보험운전자연령
	String driving_age = request.getParameter("driving_age")==null?"":request.getParameter("driving_age");
	if(driving_age.equals("")) driving_age = base.getDriving_age();
	int ins_age = 0;
	if(driving_age.equals(""))			ins_age = 1;//"":선택없슴	->26세 1
	if(driving_age.equals("0"))			ins_age = 1;//0 :26세		->26세 1
	if(driving_age.equals("1"))			ins_age = 2;//1 :21세		->21세 2
	if(driving_age.equals("2"))			ins_age = 2;//2 :모든운전자	->21세 2
	if(driving_age.equals("3"))			ins_age = 3;//3 :24세		->24세 3
	bean.setIns_age		(Integer.toString(ins_age));
	//보험대물자손가입금액
	bean.setIns_dj		(request.getParameter("gcp_kd")==null?"":request.getParameter("gcp_kd"));
	if(bean.getIns_dj().equals("")) bean.setIns_dj(base.getGcp_kd());
	if(bean.getIns_dj().equals("")) bean.setIns_dj("1");
	
	//자차면책금
	bean.setCar_ja		(request.getParameter("car_ja")==null?0:AddUtil.parseDigit(request.getParameter("car_ja")));
	if(bean.getCar_ja() == 0) bean.setCar_ja(base.getCar_ja());
	
	//LPG 장착여부
	String lpg_yn = "0";
	if(lpg_setter.equals(""))	lpg_setter = car.getLpg_setter();
	if(lpg_setter.equals("2"))	lpg_yn = "1";
	bean.setLpg_yn		(lpg_yn);
	bean.setLpg_kit		(lpg_kit);
	
	//보증보험가입여부
	if(gi_st.equals(""))	gi_st = car.getLpg_setter();
	bean.setGi_yn		(gi_st);
	
	//고객신용도구분
	bean.setSpr_yn		(request.getParameter("spr_kd")==null?"":request.getParameter("spr_kd"));
	if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());
	if(bean.getSpr_yn().equals(""))		bean.setSpr_yn(cont_etc.getDec_gr());
	if(bean.getSpr_yn().equals(""))		bean.setSpr_yn("3");
	
	//등록자-장기계약번호
	bean.setReg_id		(request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd"));
	bean.setReg_dt		(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt")+"0000");
	if(bean.getReg_dt().equals(""))	bean.setReg_dt(base.getReg_dt()+"0000");
	//계약일자
	bean.setRent_dt		(rent_dt);
	if     (bean.getRent_dt().equals("") && rent_st.equals("1")) 	bean.setRent_dt(base.getRent_dt());
	else if(bean.getRent_dt().equals("") && !rent_st.equals("1"))	bean.setRent_dt(fees.getRent_dt());
	//연장계약
	if(!rent_st.equals("1")){
		bean.setRent_dt		(rent_start_dt);
		rent_dt = rent_start_dt;
	}
	//연장계약
	if(est_from.equals("lc_renew")){
		bean.setRent_dt		(rent_start_dt);
		rent_dt = rent_start_dt;
	}
	
	//재리스견적
	if(car_gu.equals("0")){
		bean.setEst_st("1");
		bean.setMgr_nm	(car_mng_id);
	}
	//중고차리스
	if(car_gu.equals("2")){
		bean.setEst_st("3");
		bean.setMgr_nm	(car_mng_id);
	}
	//연장계약
	if(!rent_st.equals("1")){
		bean.setEst_st("2");
	}
	//연장계약
	if(est_from.equals("lc_renew")){
		bean.setEst_st("2");
	}
	
	bean.setEst_from	(est_from);
	bean.setUdt_st		(udt_st);
	
	bean.setBr_to_st(br_to_st);
	bean.setBr_to(br_to);
	bean.setBr_from(br_from);	
	
	if(!cm_bean.getJg_code().equals("")){
		count = e_db.insertEstimate(bean);
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='/include/estimate_dt.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
  <input type="hidden" name="est_id" value="<%=est_id%>">          
  <input type="hidden" name="a_e" value="<%=s_st%>">
  <input type="hidden" name="from_page" value="car_rent">
  <input type="hidden" name="cmd" value="u">
  <input type="hidden" name="e_page" value="i">  
  <input type="hidden" name="rent_dt" value="<%=rent_dt%>">    
  <input type="hidden" name="esti_stat" value="<%=esti_stat%>">      
  <input type="hidden" name="l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="m_id" value="<%=rent_mng_id%>">      
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
  <input type="hidden" name="rent_st" value="">  
  <input type="hidden" name="fee_rent_st" value="<%=rent_st%>">    
  <input type="hidden" name="est_from" value="<%=est_from%>">  
  <input type="hidden" name="insur_per" value="<%=insur_per%>">  
  <input type="hidden" name="one_self" value="<%=one_self%>">      
</form>
<script>
<%	//if(1==1)return;%>
<%	if(count==1){%>

		var rent_dt = parseInt(document.form1.rent_dt.value);
		
		<%if(est_from.equals("lc_renew") || car_gu.equals("0") || car_gu.equals("2")){//재리스견적%>

			<%if(car_gu.equals("0")){//재리스견적%>
			document.form1.rent_st.value = '1';
			<%}else{%>
			document.form1.rent_st.value = '3';
			<%}%>
			
			<%//if(est_from.equals("lc_renew") || fee_size > 1){
				if(est_from.equals("lc_renew") || !rent_st.equals("1")){%>
			document.form1.rent_st.value = '2';
			<%}%>
			
			//재리스 견적프로그램 이동
			document.form1.action = getEstiShAction(rent_dt);
			
		
		<%}else{//신차견적%>
		
			//신차 견적프로그램 이동
			document.form1.action = getEstiAction(rent_dt);

		<%}%>		
		
		document.form1.submit();		
<%	}else{
		if(cm_bean.getJg_code().equals("")){%>
		alert("잔가코드가 없습니다. 차종관리에서 입력하십시오.");
		<%}else{%>
		alert("에러발생!");		
<%		}
	}%>

</script>
</body>
</html>

