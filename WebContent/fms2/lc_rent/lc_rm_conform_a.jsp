<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_mst.*, acar.car_office.*, acar.res_search.*, acar.client.*,  acar.ext.*,  acar.fee.*"%>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.car_register.*, acar.im_email.*, tax.*, acar.estimate_mng.*, acar.short_fee_mng.*, acar.bill_mng.*, cust.member.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

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
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	
	
		
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();

	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	

	
	
	
	
	//고객-------------------------------------------------------------------------------------------------------------
	
	//변경전데이타
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	client.setClient_nm	(request.getParameter("client_nm")==null?"":request.getParameter("client_nm"));
	client.setFirm_nm		(request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm"));
	client.setSsn1			(request.getParameter("ssn1")==null?"":request.getParameter("ssn1"));	
	//개인사업자는 생년월일만
	if(client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")) {
		client.setSsn2		("");
	}else{
		client.setSsn2		(request.getParameter("ssn2")==null?"":request.getParameter("ssn2"));
	}
	if(!client.getClient_st().equals("2")) {
		client.setEnp_no1	(request.getParameter("enp_no1")==null?"":request.getParameter("enp_no1"));
		client.setEnp_no2	(request.getParameter("enp_no2")==null?"":request.getParameter("enp_no2"));
		client.setEnp_no3	(request.getParameter("enp_no3")==null?"":request.getParameter("enp_no3"));
		client.setBus_cdt	(request.getParameter("bus_cdt")==null?"":request.getParameter("bus_cdt"));
		client.setBus_itm	(request.getParameter("bus_itm")==null?"":request.getParameter("bus_itm"));
		client.setOpen_year(request.getParameter("open_year").equals("")?"":AddUtil.ChangeString(request.getParameter("open_year")));
	}else{
		client.setNationality	(request.getParameter("nationality")==null?"":request.getParameter("nationality"));	
	}
	client.setO_addr		(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
	client.setO_zip			(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
	client.setHo_addr		(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
	client.setHo_zip		(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
	client.setUpdate_id	(user_id);
	
	client.setH_tel			(request.getParameter("c_h_tel")==null?"":request.getParameter("c_h_tel"));
	client.setO_tel			(request.getParameter("c_o_tel")==null?"":request.getParameter("c_o_tel"));
	client.setM_tel			(request.getParameter("c_m_tel")==null?"":request.getParameter("c_m_tel"));
	client.setFax				(request.getParameter("c_fax")==null?"":request.getParameter("c_fax"));
	client.setCon_agnt_o_tel	(request.getParameter("c_con_agnt_o_tel")==null?"":request.getParameter("c_con_agnt_o_tel"));
	client.setCon_agnt_m_tel	(request.getParameter("c_con_agnt_m_tel")==null?"":request.getParameter("c_con_agnt_m_tel"));
	client.setCon_agnt_fax		(request.getParameter("c_con_agnt_fax")==null?"":request.getParameter("c_con_agnt_fax"));
	client.setLic_no					(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));	
		
	
	flag1 = al_db.updateClient3(client);
	flag1 = al_db.updateNewClient2(client);
	
	TradeBean t_bean = new TradeBean();
	t_bean.setCust_code	(client.getVen_code());
	t_bean.setCust_name	(AddUtil.substringb(client.getFirm_nm(),30));
	t_bean.setS_idno		(client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
	t_bean.setId_no			(client.getSsn1()+client.getSsn2());
	t_bean.setDname			(AddUtil.substring(client.getClient_nm(),15));
	t_bean.setMail_no		(client.getO_zip());
	t_bean.setS_address	(AddUtil.substring(client.getO_addr(),30));
	t_bean.setUptae			(AddUtil.substringb(client.getBus_cdt(),30));
	t_bean.setJong			(AddUtil.substringb(client.getBus_itm(),30));
	t_bean.setUser_id		(user_id);
	t_bean.setMd_gubun	("Y");
		
	if(client.getClient_st().equals("2")){
		t_bean.setS_idno("8888888888");
	}
	
	flag2 = neoe_db.updateTrade(t_bean);
	
	base.setP_zip		(client.getO_zip());
	base.setP_addr	(client.getO_addr());
	base.setBus_id	(request.getParameter("bus_id")	==null?"":request.getParameter("bus_id"));
	base.setLic_no	(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));	
	
	base.setTest_lic_emp	(request.getParameter("test_lic_emp")==null?"":request.getParameter("test_lic_emp"));	
	base.setTest_lic_rel	(request.getParameter("test_lic_rel")==null?"":request.getParameter("test_lic_rel"));
	base.setTest_lic_result	(request.getParameter("test_lic_result")==null?"":request.getParameter("test_lic_result"));
	
	base.setTest_lic_emp2	(request.getParameter("test_lic_emp2")==null?"":request.getParameter("test_lic_emp2"));	
	base.setTest_lic_rel2	(request.getParameter("test_lic_rel2")==null?"":request.getParameter("test_lic_rel2"));
	base.setTest_lic_result2(request.getParameter("test_lic_result2")==null?"":request.getParameter("test_lic_result2"));	
	
	//=====[cont] update=====
	flag3 = a_db.updateContBaseNew(base);
	
	
	cont_etc.setBus_agnt_id	(request.getParameter("bus_agnt_id")==null?"":request.getParameter("bus_agnt_id"));
	if(client.getClient_st().equals("1")){
		cont_etc.setCom_emp_yn(request.getParameter("com_emp_yn")		==null?"":request.getParameter("com_emp_yn"));
	}
	cont_etc.setMng_type		(request.getParameter("mng_type")==null?"":request.getParameter("mng_type"));	
	cont_etc.setEst_area		(request.getParameter("est_area")		==null?"":request.getParameter("est_area"));
	cont_etc.setCounty			(request.getParameter("county")			==null?"":request.getParameter("county"));
	
	//=====[cont_etc] update=====
	flag3 = a_db.updateContEtc(cont_etc);	
	
	
	//계약 영업담당자 배정처리
	String  d_flag3 =  ad_db.call_sp_rent_busid2_auto_reg(rent_mng_id, rent_l_cd);


	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
	fee_rm.setCar_use	(request.getParameter("rm_car_use")==null?"":request.getParameter("rm_car_use"));
	//=====[fee_rm] update=====
	flag4 = a_db.updateFeeRm(fee_rm);
	
	
	//관계자-------------------------------------------------------------------------------------------------------------
		
	//car_mgr
	String mgr_id[] 			= request.getParameterValues("mgr_id");
	String mgr_st[] 			= request.getParameterValues("mgr_st");
	String mgr_nm[] 			= request.getParameterValues("mgr_nm");
	String mgr_ssn[] 			= request.getParameterValues("mgr_ssn");
	String mgr_addr[] 		= request.getParameterValues("mgr_addr");
	String mgr_tel[] 			= request.getParameterValues("mgr_tel");
	String mgr_m_tel[] 		= request.getParameterValues("mgr_m_tel");
	String mgr_lic_no[] 	= request.getParameterValues("mgr_lic_no");
	String mgr_etc[] 			= request.getParameterValues("mgr_etc");
	int mgr_size = mgr_st.length;
	for(int i = 0 ; i < mgr_size ; i++){
		CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, mgr_st[i]);
		mgr.setMgr_nm		(mgr_nm[i]);
		mgr.setSsn			(mgr_ssn[i]);
		mgr.setMgr_addr	(mgr_addr[i]);
		mgr.setLic_no		(mgr_lic_no[i]);
		mgr.setEtc			(mgr_etc[i]);
		mgr.setMgr_tel	(mgr_tel[i]);
		mgr.setMgr_m_tel(mgr_m_tel[i]);
		//=====[CAR_MGR] update=====
		flag5 = a_db.updateCarMgrNew(mgr);
		
		if(client.getLic_no().equals("") && mgr.getMgr_st().equals("차량이용자") && !mgr.getLic_no().equals("")){
			client.setLic_no(mgr.getLic_no());
			flag1 = al_db.updateNewClient2(client);
		}
	}
	
	
	//배/반차-------------------------------------------------------------------------------------------------------------
	
	String deli_plan_dt	= request.getParameter("deli_plan_dt")==null?"":request.getParameter("deli_plan_dt");
	String deli_plan_h	= request.getParameter("deli_plan_h")==null?"00":request.getParameter("deli_plan_h");
	String deli_plan_m	= request.getParameter("deli_plan_m")==null?"00":request.getParameter("deli_plan_m");
	String ret_plan_dt	= request.getParameter("ret_plan_dt")==null?"":request.getParameter("ret_plan_dt");
	String ret_plan_h	= request.getParameter("ret_plan_h")==null?"00":request.getParameter("ret_plan_h");
	String ret_plan_m	= request.getParameter("ret_plan_m")==null?"00":request.getParameter("ret_plan_m");
	
	if(!deli_plan_dt.equals("")){
		fee_rm.setDeli_plan_dt	(deli_plan_dt+""+deli_plan_h+""+deli_plan_m);
	}
	if(!ret_plan_dt.equals("")){
		fee_rm.setRet_plan_dt	(ret_plan_dt+""+ret_plan_h+""+ret_plan_m);
	}
	fee_rm.setDeli_loc(request.getParameter("deli_loc")==null?"":request.getParameter("deli_loc"));
	fee_rm.setRet_loc	(request.getParameter("ret_loc")==null?"":request.getParameter("ret_loc"));
			
	//=====[fee_rm] update=====
	flag6 = a_db.updateFeeRm(fee_rm);

	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	fee_etc.setSh_km				(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
	flag1 = a_db.updateFeeEtc(fee_etc);	
	
	
	//자동이체-------------------------------------------------------------------------------------------
		
	//cms_mng
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
		
	cms.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
	cms.setCms_bank		(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
	cms.setCms_dep_nm	(request.getParameter("cms_dep_nm")	==null?"":request.getParameter("cms_dep_nm"));
	cms.setCms_day		(request.getParameter("cms_day")	==null?"":request.getParameter("cms_day"));
	cms.setCms_tel		(request.getParameter("cms_tel")==null?"":request.getParameter("cms_tel"));
	cms.setCms_m_tel	(request.getParameter("cms_m_tel")==null?"":request.getParameter("cms_m_tel"));
	cms.setCms_email	(request.getParameter("cms_email")==null?"":request.getParameter("cms_email"));
	cms.setCms_dep_ssn	(request.getParameter("cms_dep_ssn")==null?"":request.getParameter("cms_dep_ssn"));
	cms.setUpdate_id	(user_id);
	//=====[cms_mng] update=====
	flag7 = a_db.updateContCmsMng(cms);
	
	//신용카드 자동출금
	ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
	
	card_cms.setCms_acc_no	(request.getParameter("c_cms_acc_no")	==null?"":request.getParameter("c_cms_acc_no"));
	card_cms.setCms_bank	(request.getParameter("c_cms_bank")	==null?"":request.getParameter("c_cms_bank"));
	if(!card_cms.getCms_acc_no().equals("") || !card_cms.getCms_bank().equals("")){
		card_cms.setCms_bank	(request.getParameter("c_cms_bank")	==null?"":request.getParameter("c_cms_bank"));
		card_cms.setCms_dep_nm(request.getParameter("c_cms_dep_nm")	==null?"":request.getParameter("c_cms_dep_nm"));
		card_cms.setCms_day		(request.getParameter("c_cms_day")	==null?"":request.getParameter("c_cms_day"));
		card_cms.setCms_tel		(request.getParameter("c_cms_tel")==null?"":request.getParameter("c_cms_tel"));
		card_cms.setCms_m_tel	(request.getParameter("c_cms_m_tel")==null?"":request.getParameter("c_cms_m_tel"));
		card_cms.setCms_email	(request.getParameter("c_cms_email")==null?"":request.getParameter("c_cms_email"));
		card_cms.setCms_dep_ssn	(request.getParameter("c_cms_dep_ssn")==null?"":request.getParameter("c_cms_dep_ssn"));
		card_cms.setUpdate_id	(user_id);
		//=====[cms_mng] update=====
		flag7 = a_db.updateContCardCmsMng(card_cms);
	}
	
	
	
	base.setUse_yn("Y");
	//=====[cont] insert=====
	flag8 = a_db.updateContBaseNew(base);
	
	
	//4. 고객FMS임시아이디 지정-----------------------------------------------------------------------------------------------
	MemberBean m_bean = m_db.getMemberCase(base.getClient_id(), "", "");
	int count2 = 0;
	if(m_bean.getMember_id().equals("")){
		//회원정보 등록
		MemberBean no_m_bean = m_db.getNoMemberCase(base.getClient_id(), "", "");
		
		int idcnt = m_db.checkMemberIdPwd("amazoncar", no_m_bean.getPwd());
		
		if(idcnt==0){
			count2 = m_db.insertMember(base.getClient_id(), "", "amazoncar", no_m_bean.getPwd(), "");
		}else{
			count2 = m_db.updateMemberUseYN(base.getClient_id()); //기존 use_yn='N'를'Y'로 처리 
		//	count2 = m_db.insertMember(base.getClient_id(), "", "amazoncar", no_m_bean.getPwd()+String.valueOf(idcnt+1), "");
		}
	}		
	
	
%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

</head>
<body>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 				value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	value='<%=from_page%>'>   
  <input type="hidden" name="rent_st" 	value="1">
</form>
<script language='javascript'>

<%		if(!flag1){	%>	alert('고객 수정 에러입니다.\n\n확인하십시오');			<%		}	%>
<%		if(!flag2){	%>	alert('더존거래처 수정 에러입니다.\n\n확인하십시오');	<%		}	%>
<%		if(!flag3){	%>	alert('고객 주소 수정에러입니다.\n\n확인하십시오');		<%		}	%>
<%		if(!flag4){	%>	alert('차량이용용도 수정 에러입니다.\n\n확인하십시오');	<%		}	%>
<%		if(!flag5){	%>	alert('관계자 수정 에러입니다.\n\n확인하십시오');		<%		}	%>
<%		if(!flag6){	%>	alert('배/반차 등록 에러입니다.\n\n확인하십시오');		<%		}	%>
<%		if(!flag7){	%>	alert('자동이체 등록 에러입니다.\n\n확인하십시오');		<%		}	%>
<%		if(!flag8){	%>	alert('담당자배정 에러입니다.\n\n확인하십시오');			<%		}	%>
<%		if(!flag9){	%>	alert('전자계약서 에러입니다.\n\n확인하십시오');			<%		}	%>

	var fm = document.form1;
	

	  alert("정상적으로 처리되었습니다.");

		fm.action = '/fms2/lc_rent/lc_c_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	
		parent.window.close();
	

		

</script>
</body>
</html>