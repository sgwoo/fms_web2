<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.car_mst.*, acar.car_office.*, acar.res_search.*, acar.client.*, cust.member.*, acar.ext.*, acar.car_sche.*, acar.estimate_mng.*"%>
<jsp:useBean id="cm_db" 	scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="m_db" 		scope="page" class="cust.member.MemberDatabase"/>
<jsp:useBean id="a_db" 		scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" 	scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ae_db" 	scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="al_db" 	scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_bean" 	scope="page" class="acar.car_mst.CarMstBean"/>
<jsp:useBean id="rs_db" 	scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="coe_bean" 	scope="page" class="acar.car_office.CarOffEmpBean"/>
<jsp:useBean id="coh_bean" 	scope="page" class="acar.car_office.CarOffEdhBean"/>
<jsp:useBean id="ad_db" 	scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ec_db" 	scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	String fee_size 	= request.getParameter("fee_size")		==null?"":request.getParameter("fee_size");
	String zip_cnt 		= request.getParameter("zip_cnt")		==null?"":request.getParameter("zip_cnt");
	String now_stat	 	= request.getParameter("now_stat")		==null?"":request.getParameter("now_stat");
	
	String t_zip[] 		= request.getParameterValues("t_zip");
	String t_addr[] 	= request.getParameterValues("t_addr");
	
	int t_zip_size = 0;
	
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
	boolean flag13 = true;	// 첨단안전장치 수정 flag 값		2018.02.13
	boolean flag14 = true;	// 첨단안전장치 쿨메신저 알림	2018.02.13
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	// 2018.02.13
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	if(fee_size.equals("")){
		fee_size 	= String.valueOf(af_db.getMaxRentSt(rent_mng_id, rent_l_cd));
	}
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차종변수
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//commi
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	
%>


<%
	if(idx.equals("0") || idx.equals("99")){
	
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		//계약구분,영업구분
		base.setRent_st			(request.getParameter("rent_st")	==null?"":request.getParameter("rent_st"));
		base.setRent_dt			(request.getParameter("rent_dt")	==null?"":request.getParameter("rent_dt"));
		base.setBus_st			(request.getParameter("bus_st")		==null?"":request.getParameter("bus_st"));
		base.setAgent_emp_id(request.getParameter("agent_emp_id")==null?"":request.getParameter("agent_emp_id"));

		//=====[cont] update=====
		flag1 = a_db.updateContBaseNew(base);

		
		//계약기타정보-----------------------------------------------------------------------------------------------
		
		
		//영업대리인
		cont_etc.setBus_agnt_id		(request.getParameter("bus_agnt_id")	==null?"":request.getParameter("bus_agnt_id"));
		
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag2 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag2 = a_db.updateContEtc(cont_etc);
		}
		
		//대여정보---------------------------------------------------------------------------------------------------
		
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, fee_size);
		//관리구분
		fee.setRent_way			(request.getParameter("rent_way")	==null?"":request.getParameter("rent_way"));
		if(fee_size.equals("1")){
			fee.setRent_dt		(request.getParameter("rent_dt")	==null?"":request.getParameter("rent_dt"));
		}
		//=====[fee] update=====
		flag3 = a_db.updateContFeeNew(fee);
		
		if(fee.getRent_way().equals("1")){
			cont_etc.setMain_yn		("Y");
			cont_etc.setMa_dae_yn	("Y");
		}else{
			cont_etc.setMain_yn		("");
			cont_etc.setMa_dae_yn	("");
		}
		flag2 = a_db.updateContEtc(cont_etc);
		
		
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		fee_etc.setBus_agnt_id	(request.getParameter("bus_agnt_id")==null?"":request.getParameter("bus_agnt_id"));
		
		flag4 = a_db.updateFeeEtc(fee_etc);
		
		%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag3){	%>	alert('대여정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>



<%
	if(idx.equals("1") || idx.equals("99")){
	
		t_zip_size = t_zip.length;
		
		String o_client_id = base.getClient_id();
		
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		//고객,지점,우편물주소,우편물수취인
		base.setClient_id		(request.getParameter("client_id")	==null?"":request.getParameter("client_id"));
		base.setR_site			(request.getParameter("site_id")	==null?"":request.getParameter("site_id"));
		base.setP_zip				(t_zip[0]);
		base.setP_addr			(t_addr[0]);
		base.setTax_agnt		(request.getParameter("tax_agnt")	==null?"":request.getParameter("tax_agnt"));
		base.setLic_no			(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));	
		base.setMgr_lic_no	(request.getParameter("mgr_lic_no")==null?"":request.getParameter("mgr_lic_no"));	
		base.setMgr_lic_emp	(request.getParameter("mgr_lic_emp")==null?"":request.getParameter("mgr_lic_emp"));	
		base.setMgr_lic_rel	(request.getParameter("mgr_lic_rel")==null?"":request.getParameter("mgr_lic_rel"));	
		
		base.setTest_lic_emp	(request.getParameter("test_lic_emp")==null?"":request.getParameter("test_lic_emp"));	
		base.setTest_lic_rel	(request.getParameter("test_lic_rel")==null?"":request.getParameter("test_lic_rel"));
		base.setTest_lic_result	(request.getParameter("test_lic_result")==null?"":request.getParameter("test_lic_result"));
		
		
		//=====[cont] update=====
		flag1 = a_db.updateContBaseNew(base);
		
		
		
		//관계자정보-----------------------------------------------------------------------------------------------
		
		//car_mgr
		String mgr_id[] 			= request.getParameterValues("mgr_id");
		String mgr_st[] 			= request.getParameterValues("mgr_st");
		String mgr_com[] 			= request.getParameterValues("mgr_com");
		String mgr_dept[] 			= request.getParameterValues("mgr_dept");
		String mgr_nm[] 			= request.getParameterValues("mgr_nm");
		String mgr_title[] 			= request.getParameterValues("mgr_title");
		String mgr_tel[] 			= request.getParameterValues("mgr_tel");
		String mgr_m_tel[] 			= request.getParameterValues("mgr_m_tel");
		String mgr_email[] 			= request.getParameterValues("mgr_email");
		
		int mgr_size = mgr_st.length;
		
		for(int i = 0 ; i < mgr_size ; i++){
			
			CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, mgr_st[i]);
			//근무처,부서,성명,직위,전화번호,휴대폰,이메일
			mgr.setMgr_nm		(mgr_nm[i]);
			mgr.setMgr_dept		(mgr_dept[i]);
			mgr.setMgr_title	(mgr_title[i]);
			mgr.setMgr_tel		(mgr_tel[i]);
			mgr.setMgr_m_tel	(mgr_m_tel[i]);
			mgr.setMgr_email	(mgr_email[i].trim());
			mgr.setCom_nm		(mgr_com[i]);
			
			if(i == 0){
				mgr.setMgr_zip		(t_zip[1]);
				mgr.setMgr_addr		(t_addr[1]);
			}
			
			if(mgr.getMgr_st().equals("추가운전자")){
				if(mgr.getMgr_nm().equals("")){
					mgr.setMgr_nm	(request.getParameter("mgr_lic_emp5")	==null?"":request.getParameter("mgr_lic_emp5"));
				}
				mgr.setLic_no		(request.getParameter("mgr_lic_no5")	==null?"":request.getParameter("mgr_lic_no5"));
				mgr.setEtc			(request.getParameter("mgr_lic_rel5")	==null?"":request.getParameter("mgr_lic_rel5"));
				mgr.setLic_result	(request.getParameter("mgr_lic_result5")	==null?"":request.getParameter("mgr_lic_result5"));
			}
			
			
			if(mgr.getRent_mng_id().equals("")){
				mgr.setRent_mng_id	(rent_mng_id);
				mgr.setRent_l_cd	(rent_l_cd);
				mgr.setMgr_id		(String.valueOf(i));
				mgr.setMgr_st		(mgr_st[i]);
				if(!mgr_st[i].equals("")){
					//=====[CAR_MGR] insert=====
					flag2 = a_db.insertCarMgr(mgr);
				}
			}else{
				//=====[CAR_MGR] update=====
				flag2 = a_db.updateCarMgrNew(mgr);
			}
		}
		
		//추가운전면허정보만 있고 추가운전자가 없는 경우 처리
		CarMgrBean mgr5 = a_db.getCarMgr(rent_mng_id, rent_l_cd, "추가운전자");
		if(mgr5.getRent_mng_id().equals("")){
			mgr5.setRent_mng_id	(rent_mng_id);
			mgr5.setRent_l_cd	(rent_l_cd);
			mgr5.setMgr_id		(String.valueOf(mgr_size));
			mgr5.setMgr_st		("추가운전자");
			mgr5.setMgr_nm		(request.getParameter("mgr_lic_emp5")	==null?"":request.getParameter("mgr_lic_emp5"));
			mgr5.setLic_no		(request.getParameter("mgr_lic_no5")	==null?"":request.getParameter("mgr_lic_no5"));
			mgr5.setEtc			(request.getParameter("mgr_lic_rel5")	==null?"":request.getParameter("mgr_lic_rel5"));
			mgr5.setLic_result	(request.getParameter("mgr_lic_result5")	==null?"":request.getParameter("mgr_lic_result5"));
			if(!mgr5.getMgr_nm().equals("") || !mgr5.getLic_no().equals("")){
				//=====[CAR_MGR] insert=====
				flag2 = a_db.insertCarMgr(mgr5);
			}
		}
		
		
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
		
		
		if(o_client_id.equals("000228") && !o_client_id.equals(base.getClient_id())){
			//고객별 최종스캔 동기화
			String  d_flag1 =  ad_db.call_sp_lc_rent_scanfile_syn(rent_mng_id, rent_l_cd, user_id);					
		}
		%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('관계자정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("2") || idx.equals("99")){
	
		t_zip_size = t_zip.length;
		
		//계약기타정보-----------------------------------------------------------------------------------------------
		

		//연대보증여부,면제조건,결재자
		cont_etc.setClient_guar_st	(request.getParameter("client_guar_st")==null?"":request.getParameter("client_guar_st"));
		cont_etc.setGuar_st			(request.getParameter("guar_st")==null?"":request.getParameter("guar_st"));
		cont_etc.setGuar_con		(request.getParameter("guar_con")==null?"":request.getParameter("guar_con"));
		cont_etc.setGuar_sac_id		(request.getParameter("guar_sac_id")==null?"":request.getParameter("guar_sac_id"));
		
		cont_etc.setClient_share_st	(request.getParameter("client_share_st")==null?"":request.getParameter("client_share_st"));
		//cont_etc.setDlv_con_commi_yn(request.getParameter("dlv_con_commi_yn")	==null?"":request.getParameter("dlv_con_commi_yn")); //출고보전수당 지급여부
		//cont_etc.setDir_pur_commi_yn(request.getParameter("dir_pur_commi_yn")	==null?"":request.getParameter("dir_pur_commi_yn")); //특판출고 실적이관가능여부
		
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] insert=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag1 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag1 = a_db.updateContEtc(cont_etc);
		}
		
		base.setTest_lic_emp2	(request.getParameter("test_lic_emp2")==null?"":request.getParameter("test_lic_emp2"));	
		base.setTest_lic_rel2	(request.getParameter("test_lic_rel2")==null?"":request.getParameter("test_lic_rel2"));
		base.setTest_lic_result2(request.getParameter("test_lic_result2")==null?"":request.getParameter("test_lic_result2"));
		
		//=====[cont] update=====
		flag1 = a_db.updateContBaseNew(base);
				
		
		//연대보증인-----------------------------------------------------------------------------------------------
		
		//cont_gur
		String gur_id[] 	= request.getParameterValues("gur_id");
		String gur_nm[] 	= request.getParameterValues("gur_nm");
		String gur_ssn[] 	= request.getParameterValues("gur_ssn");
		String gur_tel[] 	= request.getParameterValues("gur_tel");
		String gur_rel[] 	= request.getParameterValues("gur_rel");
		
		int gur_size = gur_nm.length;
		
		for(int i = 0 ; i < gur_size ; i++){
		
			if(!gur_nm[i].equals("") && cont_etc.getGuar_st().equals("1")){
				ContGurBean gur = a_db.getContGur(rent_mng_id, rent_l_cd, gur_id[i]);
				//성명,주민등록번호,주소,연락처,관계
				gur.setGur_nm		(gur_nm[i]);
				gur.setGur_ssn		(gur_ssn[i]);
				gur.setGur_zip		(t_zip[i+2]);
				gur.setGur_addr		(t_addr[i+2]);
				gur.setGur_tel		(gur_tel[i]);
				gur.setGur_rel		(gur_rel[i]);
				
				if(gur.getRent_l_cd().equals("")){
					gur.setRent_mng_id	(rent_mng_id);
					gur.setRent_l_cd	(rent_l_cd);
					gur.setGur_id		(gur_id[i]);
					//=====[CONT_GUR] update=====
					flag2 = a_db.insertContGur(gur);
				}else{
					//=====[CONT_GUR] update=====
					flag2 = a_db.updateContGur(gur);
				}
			}
		}%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('연대보증인 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("3") || idx.equals("99")){
	
		//약식재무제표||고객테이블-----------------------------------------------------------------------------------------------
		
		
		
		String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
		String client_st 	= request.getParameter("client_st")==null?"":request.getParameter("client_st");
		String fin_seq 		= request.getParameter("fin_seq")==null?"":request.getParameter("fin_seq");
		String seq 		= cont_etc.getFin_seq();
		
		if(!client_st.equals("2")){
			
			ClientFinBean c_fin = al_db.getClientFin(client_id, seq);
			
			//newFMS 재무제표
			c_fin.setC_kisu		(request.getParameter("c_kisu")==null?"":request.getParameter("c_kisu"));
			c_fin.setC_ba_year 	(request.getParameter("c_ba_year")==null?"":AddUtil.ChangeString(request.getParameter("c_ba_year")));
			c_fin.setC_asset_tot(request.getParameter("c_asset_tot").equals("")?0:AddUtil.parseDigit2(request.getParameter("c_asset_tot")));
			c_fin.setC_cap		(request.getParameter("c_cap").equals("")?0:AddUtil.parseDigit2(request.getParameter("c_cap")));
			c_fin.setC_cap_tot	(request.getParameter("c_cap_tot").equals("")?0:AddUtil.parseDigit2(request.getParameter("c_cap_tot")));
			c_fin.setC_sale		(request.getParameter("c_sale").equals("")?0:AddUtil.parseDigit2(request.getParameter("c_sale")));
			c_fin.setF_kisu		(request.getParameter("f_kisu")==null?"":request.getParameter("f_kisu"));
			c_fin.setF_ba_year	(request.getParameter("f_ba_year")==null?"":AddUtil.ChangeString(request.getParameter("f_ba_year")));
			c_fin.setF_asset_tot(request.getParameter("f_asset_tot").equals("")?0:AddUtil.parseDigit2(request.getParameter("f_asset_tot")));
			c_fin.setF_cap		(request.getParameter("f_cap").equals("")?0:AddUtil.parseDigit2(request.getParameter("f_cap")));
			c_fin.setF_cap_tot	(request.getParameter("f_cap_tot").equals("")?0:AddUtil.parseDigit2(request.getParameter("f_cap_tot")));
			c_fin.setF_sale		(request.getParameter("f_sale").equals("")?0:AddUtil.parseDigit2(request.getParameter("f_sale")));
			c_fin.setC_profit	(request.getParameter("c_profit").equals("")?0:AddUtil.parseDigit2(request.getParameter("c_profit")));
			c_fin.setF_profit	(request.getParameter("f_profit").equals("")?0:AddUtil.parseDigit2(request.getParameter("f_profit")));
			c_fin.setC_ba_year_s(request.getParameter("c_ba_year_s")==null?"":AddUtil.ChangeString(request.getParameter("c_ba_year_s")));
			c_fin.setF_ba_year_s(request.getParameter("f_ba_year_s")==null?"":AddUtil.ChangeString(request.getParameter("f_ba_year_s")));
			
			if(c_fin.getF_seq().equals("")){
				
				c_fin.setClient_id(client_id);
				
				flag1 = al_db.insertClientFin(c_fin);
				
				//고객재무제표
				ClientFinBean c_fin2 = al_db.getClientFin(client_id);
				
				//계약기타정보-----------------------------------------------------------------------------------------------
				
				//cont_etc
				cont_etc.setFin_seq		(c_fin2.getF_seq());
				
				if(cont_etc.getRent_mng_id().equals("")){
					//=====[cont_etc] update=====
					cont_etc.setRent_mng_id	(rent_mng_id);
					cont_etc.setRent_l_cd	(rent_l_cd);
					flag2 = a_db.insertContEtc(cont_etc);
				}else{
					//=====[cont_etc] update=====
					flag2 = a_db.updateContEtc(cont_etc);
				}
			}else{
				flag1 = al_db.updateClientFin(c_fin);
			}
		}else{
			ClientBean client = al_db.getClient(client_id);
			client.setCom_nm	(request.getParameter("com_nm")==null?"":request.getParameter("com_nm"));
			client.setJob		(request.getParameter("job")==null?"":request.getParameter("job"));
			client.setPay_st	(request.getParameter("c_pay_st")==null?"":request.getParameter("c_pay_st"));
			client.setPay_type	(request.getParameter("pay_type")==null?"":request.getParameter("pay_type"));
			client.setWk_year	(request.getParameter("wk_year")==null?"":request.getParameter("wk_year"));
			flag3 = al_db.updateNewClient2(client);
		}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('약식제무재표 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag3){	%>	alert('고객정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("4") || idx.equals("5") || idx.equals("99")){
		
		//고객신용사항-----------------------------------------------------------------------------------------------
		
		//연대보증인정보
		Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
		int gur_size = gurs.size();
		
		String e_seq[] 		= request.getParameterValues("e_seq");
		String eval_gu[] 	= request.getParameterValues("eval_gu");
		String eval_nm[] 	= request.getParameterValues("eval_nm");
		String eval_gr[] 	= request.getParameterValues("eval_gr");
		String eval_off[] 	= request.getParameterValues("eval_off");
		String eval_s_dt[] 	= request.getParameterValues("eval_s_dt");
		String ass1_type[] 	= request.getParameterValues("ass1_type");
		String ass2_type[] 	= request.getParameterValues("ass2_type");
		String eval_b_dt[] 	= request.getParameterValues("eval_b_dt");
		String eval_score[] 	= request.getParameterValues("eval_score");
		
		int eval_size = eval_gu.length;
		
		for(int i = 0 ; i < eval_size ; i++){
			
			ContEvalBean eval = new ContEvalBean();
			if(!eval_gu[i].equals("")){
				eval = a_db.getContEval(rent_mng_id, rent_l_cd, eval_gu[i], "");
			}
			
			eval.setEval_gu		(eval_gu[i]);
			eval.setEval_nm		(eval_nm[i]);
			eval.setEval_gr		(eval_gr[i]);
			eval.setEval_off	(eval_off[i]);
			eval.setEval_s_dt	(eval_s_dt[i]);
			eval.setEval_score(eval_score[i]);
			eval.setAss1_type	(ass1_type[i]);
			eval.setAss2_type	(ass2_type[i]);
			eval.setAss1_addr	(t_addr[5+(2*i)]);
			eval.setAss1_zip	(t_zip [5+(2*i)]);
			eval.setAss2_addr	(t_addr[6+(2*i)]);
			eval.setAss2_zip	(t_zip [6+(2*i)]);
			eval.setEval_b_dt	(eval_b_dt[i]);
			
			if(!eval.getRent_l_cd().equals("")){
				//=====[CONT_EVAL] update=====
				flag1 = a_db.updateContEval(eval);
			}else{
				eval.setRent_mng_id	(rent_mng_id);
				eval.setRent_l_cd	(rent_l_cd);
				eval.setE_seq		(a_db.getNextEvalSeq(rent_mng_id, rent_l_cd));
				//=====[CONT_EVAL] insert=====
				flag1 = a_db.insertContEval(eval);
			}
		}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(idx.equals("6") || idx.equals("99")){
	
	
	%>
<script language='javascript'>
</script>
<%	}%>


<%
	if(idx.equals("7") || idx.equals("99")){
	
		//계약기타정보-----------------------------------------------------------------------------------------------
		
		
		//판정신용등급,판정담당자,판정일자,결재자,결재일자
		cont_etc.setDec_gr		(request.getParameter("dec_gr")==null?"":request.getParameter("dec_gr"));
		cont_etc.setDec_f_id	(request.getParameter("dec_f_id")==null?"":request.getParameter("dec_f_id"));
		cont_etc.setDec_f_dt	(request.getParameter("dec_f_dt")==null?"":AddUtil.ChangeString(request.getParameter("dec_f_dt")));
		cont_etc.setDec_l_id	(request.getParameter("dec_l_id")==null?"":request.getParameter("dec_l_id"));
		cont_etc.setDec_l_dt	(request.getParameter("dec_l_dt")==null?"":AddUtil.ChangeString(request.getParameter("dec_l_dt")));
		cont_etc.setDec_etc		(request.getParameter("dec_etc")==null?"":request.getParameter("dec_etc"));
		
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag1 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag1 = a_db.updateContEtc(cont_etc);
		}
		
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		base.setSpr_kd		(request.getParameter("dec_gr")==null?"":request.getParameter("dec_gr"));
		
		//=====[cont] update=====
		flag2 = a_db.updateContBase(base);
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("8_1") || idx.equals("99")){
	
	//차량기본정보-----------------------------------------------------------------------------------------------
	
	String o_car_ext = car.getCar_ext();
	
	car.setColo		(request.getParameter("color")			==null?"":request.getParameter("color"));
	car.setIn_col		(request.getParameter("in_col")			==null?"":request.getParameter("in_col"));
	car.setGarnish_col	(request.getParameter("garnish_col")			==null?"":request.getParameter("garnish_col"));
	car.setEco_e_tag	(request.getParameter("eco_e_tag")		==null?"":request.getParameter("eco_e_tag"));	
	car.setCar_ext		(request.getParameter("car_ext")		==null?"":request.getParameter("car_ext"));
	
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	String n_car_ext = car.getCar_ext();
	
	//car_pur
	ContPurBean pur2 = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	String o_udt_st = pur2.getUdt_st();
	
	pur2.setUdt_st			(request.getParameter("udt_st")			==null?"":request.getParameter("udt_st"));	// 차량 인수지
	pur2.setCons_amt1		(request.getParameter("cons_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt1")));		// 인수 시 탁송료
	pur2.setEcar_loc_st	(request.getParameter("ecar_loc_st")		==null?"":request.getParameter("ecar_loc_st"));	// 전기차 고객주소지
	pur2.setHcar_loc_st	(request.getParameter("hcar_loc_st")		==null?"":request.getParameter("hcar_loc_st"));	// 수소차 고객주소지
	
	//=====[CAR_PUR] update=====
	flag2 = a_db.updateContPur(pur2);
	
	
	String n_udt_st = pur2.getUdt_st();
	
	//차량인수지 변경시 차종관리자에게 메시지 발송
	if(!o_udt_st.equals("") && !o_udt_st.equals(n_udt_st)){
		if(base.getUse_yn().equals("Y")){
			
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 		= "장기계약 차량인수지 변동";
			String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ]  &lt;br&gt; &lt;br&gt; 장기계약의 차량인수지가 ("+c_db.getNameByIdCode("0035", "", o_udt_st)+" -> "+c_db.getNameByIdCode("0035", "", n_udt_st)+") 변동하였습니다.  &lt;br&gt; &lt;br&gt; 확인바랍니다.";
			String url 		= "/agent/lc_rent/lc_b_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
			String target_id = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
			
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("엑셀견적관리자");
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			
			flag3 = cm_db.insertCoolMsg(msg);
			
		}
	}
	
	//전기차 실등록지역 변경시 전기차견적담당자에게 메시지 발송
	if(ej_bean.getJg_g_7().equals("3") && !o_car_ext.equals("") && !o_car_ext.equals(n_car_ext)){
		if(fee_size.equals("1") && cont_etc.getRent_suc_dt().equals("")){
			
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 			= "장기계약 전기차 등록지역 변동";
			String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ]  &lt;br&gt; &lt;br&gt; 장기계약의 전기차 등록지역이 변동하였습니다. 확인바랍니다.";
			String url 			= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
			String target_id = nm_db.getWorkAuthUser("전기차담당");
			String m_url 		= "/fms2/lc_rent/lc_b_frame.jsp";
			
			
			//CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			//if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("전기차담당");
						
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			flag3 = cm_db.insertCoolMsg(msg);
		}
	}		
	//수소차 실등록지역 변경시 전기차견적담당자에게 메시지 발송
	if(ej_bean.getJg_g_7().equals("4") && !o_car_ext.equals("") && !o_car_ext.equals(n_car_ext)){
		if(fee_size.equals("1") && cont_etc.getRent_suc_dt().equals("")){
			
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 			= "장기계약 수소차 등록지역 변동";
			String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ]  &lt;br&gt; &lt;br&gt; 장기계약의 수소차 등록지역이 변동하였습니다. 확인바랍니다.";
			String url 			= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
			String target_id = nm_db.getWorkAuthUser("엑셀견적관리자");
			String m_url 		= "/fms2/lc_rent/lc_b_frame.jsp";
			
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("전기차담당");
						
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			flag3 = cm_db.insertCoolMsg(msg);
		}
	}			
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(idx.equals("8") || idx.equals("99")){
	
	//차량기본정보-----------------------------------------------------------------------------------------------
	
	String o_car_ext = car.getCar_ext();
	
	car.setSun_per		(request.getParameter("sun_per")		==null? 0:AddUtil.parseDigit(request.getParameter("sun_per")));
	car.setAdd_opt		(request.getParameter("add_opt")		==null?"":request.getParameter("add_opt"));
	car.setAdd_opt_amt	(request.getParameter("add_opt_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("add_opt_amt")));
	car.setRemark		(request.getParameter("remark")			==null?"":request.getParameter("remark"));
	car.setExtra_set	(request.getParameter("extra_set")		==null?"":request.getParameter("extra_set"));
	car.setExtra_amt	(request.getParameter("extra_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("extra_amt")));
	car.setHipass_yn	(request.getParameter("hipass_yn")		==null?"":request.getParameter("hipass_yn"));
	car.setBluelink_yn	(request.getParameter("bluelink_yn")		==null?"":request.getParameter("bluelink_yn"));
	car.setTint_b_yn	(request.getParameter("tint_b_yn")		==null?"":request.getParameter("tint_b_yn"));
	car.setTint_s_yn	(request.getParameter("tint_s_yn")		==null?"":request.getParameter("tint_s_yn"));
	car.setTint_ps_yn	(request.getParameter("tint_ps_yn")		==null?"":request.getParameter("tint_ps_yn"));	// 고급썬팅 유무	2017.12.26
	car.setTint_ps_nm	(request.getParameter("tint_ps_nm")	==null?"":request.getParameter("tint_ps_nm"));	// 고급썬팅 내용
	car.setTint_ps_amt(request.getParameter("tint_ps_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tint_ps_amt")));	// 고급썬팅 금액
	car.setTint_n_yn	(request.getParameter("tint_n_yn")		==null?"":request.getParameter("tint_n_yn"));
	car.setTint_bn_yn	(request.getParameter("tint_bn_yn")		==null?"":request.getParameter("tint_bn_yn"));
	car.setTint_bn_nm	(request.getParameter("tint_bn_nm")		==null?"":request.getParameter("tint_bn_nm"));
	car.setTint_sn_yn	(request.getParameter("tint_sn_yn")		==null?"":request.getParameter("tint_sn_yn"));	// 전면썬팅 미시공 할인
	car.setNew_license_plate		(request.getParameter("new_license_plate")		==null ? "0":request.getParameter("new_license_plate"));	// 신형번호판 신청 여부 디폴트 0(구형번호판)
	car.setTint_cons_yn		(request.getParameter("tint_cons_yn")		==null?"":request.getParameter("tint_cons_yn"));
	car.setTint_cons_amt	(request.getParameter("tint_cons_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tint_cons_amt")));
	car.setTint_eb_yn	(request.getParameter("tint_eb_yn")		==null?"":request.getParameter("tint_eb_yn"));
	car.setTint_s_per	(request.getParameter("tint_s_per")		==null? 0:AddUtil.parseDigit(request.getParameter("tint_s_per")));
	car.setServ_b_yn	(request.getParameter("serv_b_yn")		==null?"":request.getParameter("serv_b_yn"));
	car.setServ_sc_yn	(request.getParameter("serv_sc_yn")		==null?"":request.getParameter("serv_sc_yn"));
	
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	// 번호판 구분 변경 시 번호판관리담당자(류길선 과장님), 주차장출납(조선희 사원님) 메신저 발송
	String prev_new_license_plate = request.getParameter("prev_new_license_plate")	==	null ? "0" : request.getParameter("prev_new_license_plate");
	String new_license_plate = request.getParameter("new_license_plate")					==	null ? "0" : request.getParameter("new_license_plate");
	if(!prev_new_license_plate.equals(new_license_plate)){
		
		// 매매주문서 스캔 파일 등록 여부 조회
		String content_code = "LC_SCAN";
		String content_seq  = rent_mng_id+""+rent_l_cd;
		int attach_count = 0;
		attach_count = c_db.getAcarAttachFileCount(content_code, content_seq, 15);	
		
		if(attach_count>0){	// 매매주문서 스캔 파일이 등록된 경우에만 발송
					
			String msg_subject 		= "번호판 구분 변경";
			String target_id1 = "000096";	// 번호판 관리 담당자(류길선 과장님)
			//String target_id2 = "000298";	// 주차장 출납(조선희 사원님)->출산휴가
			//주차장출납 출산휴가로 번호판관리담당자 연차시 업무대체자로
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id1);
			if(!cs_bean.getUser_id().equals(""))	target_id1 = cs_bean.getWork_id();
			//사용자 정보 조회
			UsersBean target_bean1 	= umd.getUsersBean(target_id1);
			//UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			UsersBean sender_bean	= umd.getUsersBean(user_id);
			
			String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			
			String msg = "[ "+rent_l_cd+" "+firm_nm+" ]의 번호판 구분이  &lt;br&gt; &lt;br&gt; ";
			if(prev_new_license_plate.equals("0") && new_license_plate.equals("1")) msg += "구형에서 신형으로";
			else if(prev_new_license_plate.equals("1") && new_license_plate.equals("0")) msg += "신형에서 구형으로";
			msg += "변경되었습니다.  &lt;br&gt; &lt;br&gt; 확인 바랍니다.  &lt;br&gt; &lt;br&gt; 변경자: "+sender_bean.getUser_nm();
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
						"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
						"    <SUB>"+msg_subject+"</SUB>"+
						"    <CONT>"+msg+"</CONT>";
	
			//받는사람
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
			//xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
	
			//보낸사람
			xml_data += "    <SENDER></SENDER>"+
	
						"    <MSGICON>10</MSGICON>"+
						"    <MSGSAVE>1</MSGSAVE>"+
						"    <LEAVEDMSG>1</LEAVEDMSG>"+
						"    <FLDTYPE>1</FLDTYPE>"+
						"  </ALERTMSG>"+
						"</COOLMSG>";
			
			CdAlertBean msg1 = new CdAlertBean();
			msg1.setFlddata(xml_data);
			msg1.setFldtype("1");
			
			flag3 = cm_db.insertCoolMsg(msg1);
		}
	}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("9") || idx.equals("99")){
	
	//차량기본정보-----------------------------------------------------------------------------------------------
	
	
	
	int o_car_amt = car.getCar_fs_amt()+car.getCar_fv_amt()+car.getDc_cs_amt()+car.getDc_cv_amt();
	
	car.setPurc_gu		(request.getParameter("purc_gu")	==null?"":request.getParameter("purc_gu"));
	car.setCar_origin	(request.getParameter("car_origin")	==null?"":request.getParameter("car_origin"));
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
	car.setS_dc1_re_etc	(request.getParameter("s_dc1_re_etc")	==null?"":request.getParameter("s_dc1_re_etc"));
	car.setS_dc2_re_etc	(request.getParameter("s_dc2_re_etc")	==null?"":request.getParameter("s_dc2_re_etc"));
	car.setS_dc3_re_etc	(request.getParameter("s_dc3_re_etc")	==null?"":request.getParameter("s_dc3_re_etc"));
	car.setS_dc1_per	(request.getParameter("s_dc1_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc1_per")));
	car.setS_dc2_per	(request.getParameter("s_dc2_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc2_per")));
	car.setS_dc3_per	(request.getParameter("s_dc3_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc3_per")));
		

	car.setImport_card_amt		(request.getParameter("import_card_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("import_card_amt")));
	car.setImport_cash_back		(request.getParameter("import_cash_back")	==null? 0:AddUtil.parseDigit(request.getParameter("import_cash_back")));
	car.setImport_bank_amt		(request.getParameter("import_bank_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("import_bank_amt")));
	car.setR_import_cash_back	(request.getParameter("r_import_cash_back")	==null? 0:AddUtil.parseDigit(request.getParameter("r_import_cash_back")));
	car.setR_import_bank_amt	(request.getParameter("r_import_bank_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("r_import_bank_amt")));
  	int ecar_pur_sub_amt_old = car.getEcar_pur_sub_amt();
	if(ecar_pur_sub_amt_old == 0){
		car.setEcar_pur_sub_amt		(request.getParameter("ecar_pur_sub_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ecar_pur_sub_amt")));
		car.setEcar_pur_sub_st		(request.getParameter("ecar_pur_sub_st")==null?"":request.getParameter("ecar_pur_sub_st"));
	}
			
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	
	if(car_gu.equals("1") && fee_size.equals("1") && !now_stat.equals("계약승계") && !now_stat.equals("차종변경") && car.getEcar_pur_sub_amt()>0 && car.getEcar_pur_sub_st().equals("2")){
		//친환경차 구매보조금
		ExtScdBean ecar_pur = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "7", "1");//기존 등록 여부 조회
		int ecar_pur_gbn = 1;	//기존
		if(ecar_pur == null || ecar_pur.getRent_l_cd().equals("")){
			ecar_pur_gbn = 0;	//신규
			ecar_pur = new ExtScdBean();
			ecar_pur.setRent_mng_id	(rent_mng_id);
			ecar_pur.setRent_l_cd		(rent_l_cd);
			ecar_pur.setRent_st			("1");
			ecar_pur.setRent_seq		("1");
			ecar_pur.setExt_id			("0");
			ecar_pur.setExt_st			("7");
			ecar_pur.setExt_tm			("1");
			ecar_pur.setExt_est_dt	("");		
		}
		ecar_pur.setExt_s_amt			(car.getEcar_pur_sub_amt());
		ecar_pur.setExt_v_amt			(0);
		ecar_pur.setUpdate_id			(user_id);
		
		if(ecar_pur_sub_amt_old == 0){
			//=====[scd_ext] update=====
			if(ecar_pur_gbn == 1)	flag6 = ae_db.updateGrt(ecar_pur);
			else									flag6 = ae_db.insertGrt(ecar_pur);			
		}
	}
	
	//제조사 할인후 차량가격 표기
	if(base.getCar_gu().equals("1") && AddUtil.parseInt(fee_size)<=1){
		cont_etc.setView_car_dc	(request.getParameter("view_car_dc")	==null? 0:AddUtil.parseDigit(request.getParameter("view_car_dc")));
		flag2 = a_db.updateContEtc(cont_etc);
	}
	
	int n_car_amt = car.getCar_fs_amt()+car.getCar_fv_amt()+car.getDc_cs_amt()+car.getDc_cv_amt();
	
	if(o_car_amt < n_car_amt || o_car_amt > n_car_amt){
		//금액변동이 있었음->영업팀장에게 메시지 전달
		if(base.getUse_yn().equals("Y")){
			
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 		= "장기계약 차가변동";
			String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ]  &lt;br&gt; &lt;br&gt; 장기계약의 차량금액이 변동하였습니다. 확인바랍니다.";
			String url 		= "/agent/lc_rent/lc_b_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
			String target_id = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
			
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("엑셀견적관리자");
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			
			if((o_car_amt-n_car_amt) > 10000 || (o_car_amt-n_car_amt) < -10000){
				flag3 = cm_db.insertCoolMsg(msg);
			}
			
		}
	}
	
	if((o_car_amt < n_car_amt || o_car_amt > n_car_amt) && emp1.getCommi_car_amt()>0){
		int commi_car_amt = car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt();
		if(AddUtil.parseInt(base.getRent_dt()) >= 20190701 ){
			commi_car_amt = commi_car_amt -car.getTax_dc_s_amt()-car.getTax_dc_v_amt();
		}
		emp1.setCommi_car_amt(commi_car_amt);
		//=====[commi] update=====
		flag1 = a_db.updateCommiNew(emp1);	
	}	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('중고차가정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("10") || idx.equals("99")){
	
	//계약기본정보-----------------------------------------------------------------------------------------------
	
	base.setDriving_ext	(request.getParameter("driving_ext")		==null?"":request.getParameter("driving_ext"));
	base.setDriving_age	(request.getParameter("driving_age")		==null?"":request.getParameter("driving_age"));
	base.setGcp_kd		(request.getParameter("gcp_kd")			==null?"":request.getParameter("gcp_kd"));
	base.setBacdt_kd	(request.getParameter("bacdt_kd")		==null?"":request.getParameter("bacdt_kd"));
	base.setCar_ja		(request.getParameter("car_ja")			==null? 0:AddUtil.parseDigit(request.getParameter("car_ja")));
	base.setOthers		(request.getParameter("others")			==null?"":request.getParameter("others"));
	//=====[cont] update=====
	flag1 = a_db.updateContBaseNew(base);
	
	//차량기본정보-----------------------------------------------------------------------------------------------
	
	car.setImm_amt		(request.getParameter("imm_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("imm_amt")));
	//=====[car_etc] update=====
	flag2 = a_db.updateContCarNew(car);
	
	//계약기타정보-----------------------------------------------------------------------------------------------
	
	
	cont_etc.setInsur_per	(request.getParameter("insur_per")	==null?"":request.getParameter("insur_per"));
	cont_etc.setCanoisr_yn	(request.getParameter("canoisr_yn")	==null?"":request.getParameter("canoisr_yn"));
	cont_etc.setCacdt_yn	(request.getParameter("cacdt_yn")	==null?"":request.getParameter("cacdt_yn"));
	cont_etc.setEme_yn	(request.getParameter("eme_yn")		==null?"":request.getParameter("eme_yn"));
	cont_etc.setJa_reason	(request.getParameter("ja_reason")	==null?"":request.getParameter("ja_reason"));
	cont_etc.setRea_appr_id	(request.getParameter("rea_appr_id")	==null?"":request.getParameter("rea_appr_id"));
	cont_etc.setAir_ds_yn	(request.getParameter("air_ds_yn")	==null?"":request.getParameter("air_ds_yn"));
	cont_etc.setAir_as_yn	(request.getParameter("air_as_yn")	==null?"":request.getParameter("air_as_yn"));
	cont_etc.setAc_dae_yn	(request.getParameter("ac_dae_yn")	==null?"":request.getParameter("ac_dae_yn"));
	cont_etc.setPro_yn	(request.getParameter("pro_yn")		==null?"":request.getParameter("pro_yn"));
	cont_etc.setCyc_yn	(request.getParameter("cyc_yn")		==null?"":request.getParameter("cyc_yn"));
	cont_etc.setMain_yn	(request.getParameter("main_yn")	==null?"":request.getParameter("main_yn"));
	cont_etc.setMa_dae_yn	(request.getParameter("ma_dae_yn")	==null?"":request.getParameter("ma_dae_yn"));
	cont_etc.setInsurant	(request.getParameter("insurant")	==null?"":request.getParameter("insurant"));
	
	if(cont_etc.getInsur_per().equals("2")){
		cont_etc.setIp_insur		(request.getParameter("ip_insur")	==null?"":request.getParameter("ip_insur"));
		cont_etc.setIp_agent		(request.getParameter("ip_agent")	==null?"":request.getParameter("ip_agent"));
		cont_etc.setIp_dam		(request.getParameter("ip_dam")		==null?"":request.getParameter("ip_dam"));
		cont_etc.setIp_tel		(request.getParameter("ip_tel")		==null?"":request.getParameter("ip_tel"));
		cont_etc.setCacdt_me_amt	(request.getParameter("cacdt_me_amt")	==null?0:AddUtil.parseDigit(request.getParameter("cacdt_me_amt")));
		cont_etc.setCacdt_memin_amt	(request.getParameter("cacdt_memin_amt")==null?0:AddUtil.parseDigit(request.getParameter("cacdt_memin_amt")));
		cont_etc.setCacdt_mebase_amt	(request.getParameter("cacdt_mebase_amt")==null?0:AddUtil.parseDigit(request.getParameter("cacdt_mebase_amt")));
	}else if(cont_etc.getInsur_per().equals("1")){
		cont_etc.setIp_insur("");
		cont_etc.setIp_agent("");
		cont_etc.setIp_dam	("");
		cont_etc.setIp_tel	("");
	}
	cont_etc.setBlackbox_yn	(request.getParameter("blackbox_yn")	==null?"":request.getParameter("blackbox_yn"));
	cont_etc.setLegal_yn	(request.getParameter("legal_yn")	==null?"":request.getParameter("legal_yn"));
	cont_etc.setEv_yn		(request.getParameter("ev_yn")	==null?"":request.getParameter("ev_yn"));
	
	cont_etc.setCom_emp_yn	(request.getParameter("com_emp_yn")		==null?"":request.getParameter("com_emp_yn"));
	cont_etc.setOthers_device(request.getParameter("others_device")	==null?"":request.getParameter("others_device"));
	if(cont_etc.getRent_mng_id().equals("")){
		//=====[cont_etc] update=====
		cont_etc.setRent_mng_id	(rent_mng_id);
		cont_etc.setRent_l_cd	(rent_l_cd);
		flag3 = a_db.insertContEtc(cont_etc);
	}else{
		//=====[cont_etc] update=====
		flag3 = a_db.updateContEtc(cont_etc);
	}
	
	
	//보험약정/계약이 틀린경우 메시지 발송
	String ins_chk1 	= request.getParameter("ins_chk1")==null?"":request.getParameter("ins_chk1");
	String ins_chk2 	= request.getParameter("ins_chk2")==null?"":request.getParameter("ins_chk2");
	String ins_chk3 	= request.getParameter("ins_chk3")==null?"":request.getParameter("ins_chk3");
	String ins_chk4 	= request.getParameter("ins_chk4")==null?"":request.getParameter("ins_chk4");


	if(!ins_chk1.equals("") || !ins_chk2.equals("") || !ins_chk3.equals("")  || !ins_chk4.equals("") ){
		
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 		= "보험 현재 가입과 약정이 틀림";
			String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ] "+ins_chk1+" "+ins_chk2+" "+ins_chk3+" "+ins_chk4;
			String url 		= "/agent/lc_rent/lc_b_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
			String target_id = nm_db.getWorkAuthUser("대전보험담당");
			
			cont = cont + ec_db.getContCngInsCngMsg(rent_mng_id, rent_l_cd, "1");
			
			//보험변경요청 프로시저 호출
			String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, rent_l_cd, "1");
			
			
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals("")){
				if(target_id.equals(nm_db.getWorkAuthUser("대전보험담당"))){
					target_id = nm_db.getWorkAuthUser("부산보험담당");
					//대전,부산보험담당자 모두 휴가일때
					cs_bean = csd.getCarScheTodayBean(target_id);
					if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
				}else{
					target_id = nm_db.getWorkAuthUser("대전보험담당");
				}
			}
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			
			//flag12 = cm_db.insertCoolMsg(msg);
		
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("11") || idx.equals("99")){
	
	//차량기본정보-----------------------------------------------------------------------------------------------
	
	
	car.setGi_st		(request.getParameter("gi_st")			==null?"":request.getParameter("gi_st"));
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	//이행보증보험-----------------------------------------------------------------------------------------------
	
	String gi_rent_st = request.getParameter("gi_rent_st")==null?"":request.getParameter("gi_rent_st"); 
	
	//gua_ins
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, gi_rent_st);
	
	String o_gi_st = gins.getGi_st();
	
	gins.setGi_st		(request.getParameter("gi_st")			==null?"":request.getParameter("gi_st"));
	
		
		if(gins.getGi_no().equals("")){
			gins.setGi_no("0");
			if(!fee_size.equals("1")){
				gins.setGi_no("[연장]"+fee_size);
			}
		}
		if(gins.getGi_st().equals("0")){
			gins.setGi_reason	(request.getParameter("gi_reason")==null?"":request.getParameter("gi_reason"));
			gins.setGi_sac_id	(request.getParameter("gi_sac_id")==null?"":request.getParameter("gi_sac_id"));
			gins.setGi_jijum	("");
			gins.setGi_amt		(0);
			gins.setGi_fee		(0);
		}else if(gins.getGi_st().equals("1")){
			gins.setGi_reason	("");
			gins.setGi_sac_id	("");
			gins.setGi_jijum	(request.getParameter("gi_jijum")==null?"":request.getParameter("gi_jijum"));
			gins.setGi_amt		(request.getParameter("gi_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_amt")));
			gins.setGi_fee		(request.getParameter("gi_fee")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_fee")));
			if(!gins.getGi_st().equals(o_gi_st)){
				
				//이행보증보험 가입여부 보증보험담당자에게 메시지 통보
						
				UsersBean gins_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("보증보험담당자"));
										
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>보증보험가입 계약등록</SUB>"+
		  				"    <CONT>보증보험가입 계약등록 : "+rent_l_cd+"</CONT>"+
 						"    <URL></URL>";
				xml_data3 += "    <TARGET>"+gins_target_bean.getId()+"</TARGET>";
				xml_data3 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
				CdAlertBean msg3 = new CdAlertBean();
				msg3.setFlddata(xml_data3);
				msg3.setFldtype("1");
			
				flag12 = cm_db.insertCoolMsg(msg3);
			}
		}
		
		if(gins.getRent_mng_id().equals("")){
			//=====[gua_ins] insert=====
			gins.setRent_mng_id	(rent_mng_id);
			gins.setRent_l_cd	(rent_l_cd);
			gins.setRent_st		(fee_size);
			flag2 = a_db.insertGiInsNew(gins);
		}else{
			//=====[gua_ins] update=====
			flag2 = a_db.updateGiInsNew(gins);
		}
		
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, fee_size);
	
		fee.setCredit_per		(request.getParameter("credit_per")		==null? 0:AddUtil.parseFloat(request.getParameter("credit_per")));
		fee.setCredit_r_per		(request.getParameter("credit_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("credit_r_per")));
		fee.setCredit_amt		(request.getParameter("credit_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("credit_amt")));
		fee.setCredit_r_amt		(request.getParameter("credit_r_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("credit_r_amt")));
		
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);		
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('이행보증보험 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("12") || idx.equals("99")){
	

	
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, fee_size);
	
		int old_fee_s_amt = fee.getFee_s_amt();
		int old_inv_s_amt = fee.getInv_s_amt();
		String old_pp_chk = fee.getPp_chk();
		
		fee.setExt_agnt		(request.getParameter("ext_agnt")		==null? "":request.getParameter("ext_agnt"));
		fee.setRent_dt		(request.getParameter("ext_rent_dt")		==null? "":request.getParameter("ext_rent_dt"));
				
		fee.setCon_mon			(request.getParameter("con_mon")		==null?"":request.getParameter("con_mon"));
		fee.setGur_per			(request.getParameter("gur_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_per")));
		fee.setGur_p_per		(request.getParameter("gur_p_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
		fee.setPere_per			(request.getParameter("pere_per")		==null? 0:AddUtil.parseFloat(request.getParameter("pere_per")));
		fee.setPere_r_per		(request.getParameter("pere_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("pere_r_per")));
		fee.setMax_ja			(request.getParameter("max_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("max_ja")));
		fee.setApp_ja			(request.getParameter("app_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("app_ja")));
		fee.setPere_mth			(request.getParameter("pere_mth")		==null? 0:AddUtil.parseDigit(request.getParameter("pere_mth")));
		fee.setPere_r_mth		(request.getParameter("pere_r_mth")		==null? 0:AddUtil.parseDigit(request.getParameter("pere_r_mth")));
		fee.setOpt_chk			(request.getParameter("opt_chk")		==null?"":request.getParameter("opt_chk"));
		fee.setOpt_per			(request.getParameter("opt_per")		==null?"":request.getParameter("opt_per"));
		fee.setCls_per			(request.getParameter("cls_per")		==null?"":request.getParameter("cls_per"));
		fee.setCls_r_per		(request.getParameter("cls_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("cls_r_per")));
		fee.setCls_n_per		(request.getParameter("cls_n_per")		==null? 0:AddUtil.parseFloat(request.getParameter("cls_n_per")));
		fee.setDc_ra			(request.getParameter("dc_ra")			==null? 0:AddUtil.parseFloat(request.getParameter("dc_ra")));
		fee.setBas_dt			(request.getParameter("bas_dt")			==null?"":request.getParameter("bas_dt"));
		fee.setPp_est_dt		(request.getParameter("pp_est_dt")		==null?"":request.getParameter("pp_est_dt"));
		fee.setGrt_amt_s		(request.getParameter("grt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("grt_s_amt")));
		fee.setPp_s_amt			(request.getParameter("pp_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("pp_s_amt")));
		fee.setPp_v_amt			(request.getParameter("pp_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("pp_v_amt")));
		fee.setIfee_s_amt		(request.getParameter("ifee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
		fee.setIfee_v_amt		(request.getParameter("ifee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ifee_v_amt")));
		fee.setJa_s_amt			(request.getParameter("ja_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_s_amt")));
		fee.setJa_v_amt			(request.getParameter("ja_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_v_amt")));
		fee.setJa_r_s_amt		(request.getParameter("ja_r_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_r_s_amt")));
		fee.setJa_r_v_amt		(request.getParameter("ja_r_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_r_v_amt")));
		fee.setOpt_s_amt		(request.getParameter("opt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("opt_s_amt")));
		fee.setOpt_v_amt		(request.getParameter("opt_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("opt_v_amt")));
		fee.setFee_s_amt		(request.getParameter("fee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_s_amt")));
		fee.setFee_v_amt		(request.getParameter("fee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_v_amt")));
		fee.setInv_s_amt		(request.getParameter("inv_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_s_amt")));
		fee.setInv_v_amt		(request.getParameter("inv_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_v_amt")));
		fee.setFee_sac_id		(request.getParameter("fee_sac_id")		==null?"":request.getParameter("fee_sac_id"));
		fee.setFee_pay_tm		(request.getParameter("fee_pay_tm")		==null?"":request.getParameter("fee_pay_tm"));
		fee.setFee_est_day		(request.getParameter("fee_est_day")		==null?"":request.getParameter("fee_est_day"));
		fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt")	==null?"":request.getParameter("fee_pay_start_dt"));
		fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt")		==null?"":request.getParameter("fee_pay_end_dt"));
		fee.setFee_sh			(request.getParameter("fee_sh")			==null?"":request.getParameter("fee_sh"));
		fee.setFee_pay_st		(request.getParameter("fee_pay_st")		==null?"":request.getParameter("fee_pay_st"));
		fee.setFee_bank			(request.getParameter("fee_bank")		==null?"":request.getParameter("fee_bank"));
		fee.setFee_cdt			(request.getParameter("fee_cdt")		==null?"":request.getParameter("fee_cdt"));
		fee.setDef_st			(request.getParameter("def_st")			==null?"":request.getParameter("def_st"));
		fee.setDef_remark		(request.getParameter("def_remark")		==null?"":request.getParameter("def_remark"));
		fee.setDef_sac_id		(request.getParameter("def_sac_id")		==null?"":request.getParameter("def_sac_id"));
		fee.setPrv_dlv_yn		(request.getParameter("prv_dlv_yn")		==null?"":request.getParameter("prv_dlv_yn"));
		fee.setCredit_per		(request.getParameter("credit_per")		==null? 0:AddUtil.parseFloat(request.getParameter("credit_per")));
		fee.setCredit_r_per		(request.getParameter("credit_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("credit_r_per")));
		fee.setCredit_amt		(request.getParameter("credit_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("credit_amt")));
		fee.setCredit_r_amt		(request.getParameter("credit_r_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("credit_r_amt")));
		fee.setFee_fst_amt		(request.getParameter("fee_fst_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_fst_amt")));
		fee.setGrt_suc_yn		(request.getParameter("grt_suc_yn")		==null?"":request.getParameter("grt_suc_yn"));
		fee.setIfee_suc_yn		(request.getParameter("ifee_suc_yn")		==null?"":request.getParameter("ifee_suc_yn"));	
		fee.setFee_chk			(request.getParameter("fee_chk")		==null?"":request.getParameter("fee_chk"));
		fee.setB_max_ja			(request.getParameter("b_max_ja")		==null? 0:AddUtil.parseFloat(request.getParameter("b_max_ja")));
		fee.setPp_chk			(request.getParameter("pp_chk")		==null?"":request.getParameter("pp_chk"));
		fee.setIns_s_amt		(request.getParameter("ins_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ins_s_amt")));
		fee.setIns_v_amt		(request.getParameter("ins_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ins_v_amt")));
		fee.setIns_total_amt	(request.getParameter("ins_total_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ins_total_amt")));
		
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);
		
		int new_fee_s_amt = fee.getFee_s_amt();
		int new_inv_s_amt = fee.getInv_s_amt();
		
		int fee_oldnew_amt = (old_fee_s_amt-new_fee_s_amt);//+(old_inv_s_amt-new_inv_s_amt)
		//대여료 계약요금 변경시 문자 보내기
		if(fee.getRent_st().equals("1") && (fee_oldnew_amt>0 || fee_oldnew_amt<0)){
		
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 		= "장기계약 대여료 계약요금 변동";
			String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ] 장기계약의 대여료 계약요금이 변동하였습니다. 확인바랍니다.";
			String url 		= "/agent/lc_rent/lc_b_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
			String target_id = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
			
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("엑셀견적관리자");
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			
			flag3 = cm_db.insertCoolMsg(msg);
		}
		
		String new_pp_chk = fee.getPp_chk();
		String pp_incom_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fee.getRent_st(), "1"); 
		
		//선납금 계산서발행구분 변경시 문자 보내기
		if(fee.getRent_st().equals("1") && !old_pp_chk.equals("") && !old_pp_chk.equals(new_pp_chk) && fee.getPp_s_amt() > 0 && (pp_incom_st.equals("입금") || pp_incom_st.equals("잔액") )){		
				
					//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
					
					String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
					String sub 		= "장기계약 선납금 계산서발행구분 변동";
					String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ] 장기계약의 선납금 계산서발행구분이 변동하였습니다. 확인바랍니다.";
					String url 		= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
					String target_id = nm_db.getWorkAuthUser("스케줄생성자");
					String target_id2 = nm_db.getWorkAuthUser("입금담당");
					String m_url  = "/fms2/lc_rent/lc_b_frame.jsp";
					
					CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
					if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("스케줄변경담당자");
					CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id2);
					if(!cs_bean2.getUser_id().equals(""))	target_id2 = nm_db.getWorkAuthUser("출금담당");
					
					//사용자 정보 조회
					UsersBean target_bean 	= umd.getUsersBean(target_id);
					UsersBean target_bean2 	= umd.getUsersBean(target_id2);
					UsersBean sender_bean 	= umd.getUsersBean(user_id);
					
					String xml_data = "";
					xml_data =  "<COOLMSG>"+
				  				"<ALERTMSG>"+
		  						"    <BACKIMG>4</BACKIMG>"+
		  						"    <MSGTYPE>104</MSGTYPE>"+
		  						"    <SUB>"+sub+"</SUB>"+
				  				"    <CONT>"+cont+"</CONT>"+
		 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
					xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
					xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
		  						"    <MSGICON>10</MSGICON>"+
		  						"    <MSGSAVE>1</MSGSAVE>"+
		  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
				  				"    <FLDTYPE>1</FLDTYPE>"+
		  						"  </ALERTMSG>"+
		  						"</COOLMSG>";
					
					CdAlertBean msg = new CdAlertBean();
					msg.setFlddata(xml_data);
					msg.setFldtype("1");
					
					flag3 = cm_db.insertCoolMsg(msg);
		}
		
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, fee_size);
		
		fee_etc.setCms_not_cau		(request.getParameter("cms_not_cau")	==null?"":request.getParameter("cms_not_cau"));
		fee_etc.setBus_agnt_id		(request.getParameter("ext_bus_agnt_id")==null?"":request.getParameter("ext_bus_agnt_id"));
		fee_etc.setBus_agnt_per		(request.getParameter("bus_agnt_per")	==null? 0:AddUtil.parseFloat(request.getParameter("bus_agnt_per")));
		fee_etc.setBus_agnt_r_per	(request.getParameter("bus_agnt_r_per")	==null? 0:AddUtil.parseFloat(request.getParameter("bus_agnt_r_per")));
		fee_etc.setCls_n_mon			(request.getParameter("cls_n_mon")	==null?"":request.getParameter("cls_n_mon"));
		fee_etc.setCls_n_amt			(request.getParameter("cls_n_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("cls_n_amt")));
		fee_etc.setBc_b_g					(request.getParameter("bc_b_g")		==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_g")));
		fee_etc.setBc_b_u					(request.getParameter("bc_b_u")		==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_u")));
		fee_etc.setBc_b_ac				(request.getParameter("bc_b_ac")	==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_ac")));
		fee_etc.setBc_b_g_cont		(request.getParameter("bc_b_g_cont")	==null?"":request.getParameter("bc_b_g_cont"));
		fee_etc.setBc_b_u_cont		(request.getParameter("bc_b_u_cont")	==null?"":request.getParameter("bc_b_u_cont"));
		fee_etc.setBc_b_e1				(request.getParameter("bc_b_e1")	==null? 0:AddUtil.parseFloat(request.getParameter("bc_b_e1")));
		fee_etc.setBc_b_e2				(request.getParameter("bc_b_e2")	==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_e2")));
		fee_etc.setBc_b_ac_cont		(request.getParameter("bc_b_ac_cont")	==null?"":request.getParameter("bc_b_ac_cont"));
		fee_etc.setBc_etc					(request.getParameter("bc_etc")		==null?"":request.getParameter("bc_etc"));
		fee_etc.setAgree_dist_yn	(request.getParameter("agree_dist_yn")	==null?"":request.getParameter("agree_dist_yn"));
		fee_etc.setAgree_dist			(request.getParameter("agree_dist")	==null? 0:AddUtil.parseDigit(request.getParameter("agree_dist")));
		fee_etc.setOver_run_amt		(request.getParameter("over_run_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("over_run_amt")));
		fee_etc.setCust_est_km		(request.getParameter("cust_est_km")	==null? 0:AddUtil.parseDigit(request.getParameter("cust_est_km")));
		fee_etc.setCredit_sac_id	(request.getParameter("credit_sac_id")		==null?"":request.getParameter("credit_sac_id"));
		fee_etc.setCredit_sac_dt	(request.getParameter("credit_sac_dt")		==null?"":request.getParameter("credit_sac_dt"));
		fee_etc.setDc_ra_st				(request.getParameter("dc_ra_st")		==null?"":request.getParameter("dc_ra_st"));
		fee_etc.setDc_ra_sac_id		(request.getParameter("dc_ra_sac_id")		==null?"":request.getParameter("dc_ra_sac_id"));
		fee_etc.setDc_ra_etc			(request.getParameter("dc_ra_etc")		==null?"":request.getParameter("dc_ra_etc"));
		fee_etc.setCon_etc				(request.getParameter("con_etc")	==null?"":request.getParameter("con_etc"));
		fee_etc.setDriver_add_amt	(request.getParameter("driver_add_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("driver_add_amt")));
		fee_etc.setDriver_add_v_amt(request.getParameter("driver_add_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("driver_add_v_amt")));	//운전자추가요금(부가세) 추가 (2018.03.30)
		fee_etc.setReturn_select	(request.getParameter("return_select")	==null?"":request.getParameter("return_select"));
		fee_etc.setRtn_run_amt		(request.getParameter("rtn_run_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("rtn_run_amt")));
		fee_etc.setRtn_run_amt_yn	(request.getParameter("rtn_run_amt_yn")	==null?"":request.getParameter("rtn_run_amt_yn"));
				
		if(fee.getOpt_chk().equals("0")){
			fee_etc.setAgree_dist_yn("3"); //매입옵션없음
		}else{
			if(fee.getRent_way().equals("1")){
				fee_etc.setAgree_dist_yn("2"); //50%만 납부(일반식)
			}else{
				fee_etc.setAgree_dist_yn("1"); //전액면제(기본식)
			}	
		}
		
		if(fee_etc.getRent_mng_id().equals("")){
			fee_etc.setRent_mng_id	(rent_mng_id);
			fee_etc.setRent_l_cd	(rent_l_cd);
			fee_etc.setRent_st		("1");
			//=====[fee_etc] insert=====
			flag6 = a_db.insertFeeEtc(fee_etc);
		}else{
			//=====[fee_etc] update=====
			flag6 = a_db.updateFeeEtc(fee_etc);
		}
		
		
		//계약기타정보-----------------------------------------------------------------------------------------------
		
		if(fee_etc.getRent_st().equals("1")){
			
			cont_etc.setGrt_suc_m_id	(request.getParameter("grt_suc_m_id")	==null?"":request.getParameter("grt_suc_m_id"));
			cont_etc.setGrt_suc_l_cd	(request.getParameter("grt_suc_l_cd")	==null?"":request.getParameter("grt_suc_l_cd"));
			cont_etc.setGrt_suc_c_no	(request.getParameter("grt_suc_c_no")	==null?"":request.getParameter("grt_suc_c_no"));
			cont_etc.setGrt_suc_o_amt	(request.getParameter("grt_suc_o_amt")==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_o_amt")));
			cont_etc.setGrt_suc_r_amt	(request.getParameter("grt_suc_r_amt")==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_r_amt")));
			cont_etc.setCls_etc	(request.getParameter("cls_etc")		==null?"":request.getParameter("cls_etc"));
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
		
		
		if(car_gu.equals("1") && fee_size.equals("1")){
			car.setTax_dc_s_amt				(request.getParameter("tax_dc_s_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tax_dc_s_amt")));
			car.setTax_dc_v_amt				(request.getParameter("tax_dc_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tax_dc_v_amt")));
			int ecar_pur_sub_amt_old2 = car.getEcar_pur_sub_amt();
			if(ecar_pur_sub_amt_old2 == 0){
				car.setEcar_pur_sub_amt		(request.getParameter("ecar_pur_sub_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ecar_pur_sub_amt")));
				car.setEcar_pur_sub_st		(request.getParameter("ecar_pur_sub_st")==null?"":request.getParameter("ecar_pur_sub_st"));
			}
			//=====[car_etc] update=====
			flag1 = a_db.updateContCarNew(car);
			
			if(car_gu.equals("1") && fee_size.equals("1") && !now_stat.equals("계약승계") && !now_stat.equals("차종변경") && car.getEcar_pur_sub_amt()>0 && car.getEcar_pur_sub_st().equals("2")){
				//친환경차 구매보조금
				ExtScdBean ecar_pur = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "7", "1");//기존 등록 여부 조회
				int ecar_pur_gbn = 1;	//기존
				if(ecar_pur == null || ecar_pur.getRent_l_cd().equals("")){
					ecar_pur_gbn = 0;	//신규
					ecar_pur = new ExtScdBean();
					ecar_pur.setRent_mng_id	(rent_mng_id);
					ecar_pur.setRent_l_cd		(rent_l_cd);
					ecar_pur.setRent_st			(fee.getRent_st());
					ecar_pur.setRent_seq		("1");
					ecar_pur.setExt_id			("0");
					ecar_pur.setExt_st			("7");
					ecar_pur.setExt_tm			("1");
					ecar_pur.setExt_est_dt	("");		
				}
				ecar_pur.setExt_s_amt			(car.getEcar_pur_sub_amt());
				ecar_pur.setExt_v_amt			(0);
				ecar_pur.setUpdate_id			(user_id);
				if(ecar_pur_sub_amt_old2 == 0){
					//=====[scd_ext] update=====
					if(ecar_pur_gbn == 1)	flag6 = ae_db.updateGrt(ecar_pur);
					else									flag6 = ae_db.insertGrt(ecar_pur);			
				}
			}
		}
		
		
		//영업담당 영업사원
		
		String emp_id[] 	= request.getParameterValues("emp_id");
		String car_off_nm[] = request.getParameterValues("car_off_nm");
		
		if(fee_etc.getRent_st().equals("1") && !emp_id[0].equals("")){
		
			float o_comm_r_rt = emp1.getComm_r_rt();
			
			emp1.setEmp_id			(emp_id[0]);
			
			emp1.setComm_r_rt		(request.getParameter("comm_r_rt")	==null? 0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
			emp1.setCommi			(request.getParameter("commi")		==null? 0:AddUtil.parseDigit(request.getParameter("commi")));
			emp1.setCommi_car_amt		(request.getParameter("commi_car_amt")==null? 0:AddUtil.parseDigit(request.getParameter("commi_car_amt")));
			emp1.setCommi_car_st		(request.getParameter("commi_car_st")==null?"1":request.getParameter("commi_car_st"));
			emp1.setAgnt_st			("1");
			emp1.setCommi_st		("1");
			
			float n_comm_r_rt = emp1.getComm_r_rt();
			
			if(emp1.getRent_mng_id().equals("")){
				emp1.setRent_mng_id	(rent_mng_id);
				emp1.setRent_l_cd	(rent_l_cd);
				//=====[commi] insert=====
				flag4 = a_db.insertCommiNew(emp1);
			}else{
				//=====[commi] update=====
				flag4 = a_db.updateCommiNew(emp1);
			}
			
			//영업수당 수정시 영업팀장에게 메시지 발송		
			if(o_comm_r_rt > n_comm_r_rt || o_comm_r_rt < n_comm_r_rt){
		
				//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
				String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
				String sub 		= "장기계약 계약영업수당 변동";
				String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ] 장기계약의 미결현황에서 계약영업수당이 변동하였습니다. 확인바랍니다.";
				String url 		= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
				String target_id = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
			
				
				CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
				if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("엑셀견적관리자");
			
				//사용자 정보 조회
				UsersBean target_bean 	= umd.getUsersBean(target_id);
				UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
	  					"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  					"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
	  					"</COOLMSG>";
			
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");
			
				flag3 = cm_db.insertCoolMsg(msg);
			}				
		}
		
			//선수금 스케줄 생성
			
			//보증금
			ExtScdBean grt = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fee.getRent_st(), "0", "1");//기존 등록 여부 조회
			int grt_gbn = 1;	//기존
			if(grt == null || grt.getRent_l_cd().equals("")){
				grt_gbn = 0;	//신규
				grt = new ExtScdBean();
				grt.setRent_mng_id	(rent_mng_id);
				grt.setRent_l_cd	(rent_l_cd);
				grt.setRent_st		(fee.getRent_st());
				grt.setRent_seq		("1");
				grt.setExt_id		("0");
				grt.setExt_st		("0");
				grt.setExt_tm		("1");
			}
			//금액 별도일때(위 대여에 대한 승계가 아님)
			if(fee.getRent_st().equals("1") || fee.getGrt_suc_yn().equals("1")){
				grt.setExt_s_amt	(fee.getGrt_amt_s());	//보증금은 부가세 없다
				grt.setExt_v_amt	(0);
				grt.setExt_est_dt	(fee.getPp_est_dt());
			}
			grt.setUpdate_id	(user_id);
			//=====[scd_pre] update=====
			if(grt_gbn == 1)	flag6 = ae_db.updateGrt(grt);
			else				flag6 = ae_db.insertGrt(grt);
			
			
			//선납금
			ExtScdBean pp = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fee.getRent_st(), "1", "1");//기존 등록 여부 조회
			int pp_gbn = 1;		//기존
			if(pp == null || pp.getRent_l_cd().equals("")){
				pp_gbn = 0;		//신규
				pp = new ExtScdBean();
				pp.setRent_mng_id	(rent_mng_id);
				pp.setRent_l_cd		(rent_l_cd);
				pp.setRent_st		(fee.getRent_st());
				pp.setRent_seq		("1");
				pp.setExt_id		("0");
				pp.setExt_st		("1");
				pp.setExt_tm		("1");
			}
			pp.setExt_s_amt			(fee.getPp_s_amt());
			pp.setExt_v_amt			(fee.getPp_v_amt());
			pp.setExt_est_dt		(fee.getPp_est_dt());
			pp.setUpdate_id	(user_id);
			//=====[scd_pre] update=====
			if(pp_gbn == 1)		flag6 = ae_db.updateGrt(pp);
			else				flag6 = ae_db.insertGrt(pp);
			
			
			//개시대여료
			ExtScdBean ifee = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fee.getRent_st(), "2", "1");//기존 등록 여부 조회
			int ifee_gbn = 1;	//기존
			if(ifee == null || ifee.getRent_l_cd().equals("")){
				ifee_gbn = 0;	//신규
				ifee = new ExtScdBean();
				ifee.setRent_mng_id	(rent_mng_id);
				ifee.setRent_l_cd	(rent_l_cd);
				ifee.setRent_st		(fee.getRent_st());
				ifee.setRent_seq	("1");
				ifee.setExt_id		("0");
				ifee.setExt_st		("2");
				ifee.setExt_tm		("1");
			}
			if(fee.getRent_st().equals("1") || !fee.getIfee_suc_yn().equals("0")){
				ifee.setExt_s_amt	(fee.getIfee_s_amt());
				ifee.setExt_v_amt	(fee.getIfee_v_amt());
				ifee.setExt_est_dt	(fee.getPp_est_dt());
			}
			ifee.setUpdate_id	(user_id);
			//=====[scd_pre] update=====
			if(ifee_gbn == 1)	flag6 = ae_db.updateGrt(ifee);
			else				flag6 = ae_db.insertGrt(ifee);

	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('대여정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag2){	%>	alert('선수금스케줄 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag3){	%>	alert('자동이체 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag4){	%>	alert('영업사원 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag5){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag6){	%>	alert('선수금스케줄 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("12_2") || idx.equals("99")){
	
		t_zip_size = t_zip.length;
	
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, fee_size);
		
		fee.setFee_sh			(request.getParameter("fee_sh")			==null?"":request.getParameter("fee_sh"));
		fee.setFee_pay_st		(request.getParameter("fee_pay_st")		==null?"":request.getParameter("fee_pay_st"));
		fee.setFee_bank			(request.getParameter("fee_bank")		==null?"":request.getParameter("fee_bank"));
		fee.setFee_cdt			(request.getParameter("fee_cdt")		==null?"":request.getParameter("fee_cdt"));
		fee.setDef_st			(request.getParameter("def_st")			==null?"":request.getParameter("def_st"));
		fee.setDef_remark		(request.getParameter("def_remark")		==null?"":request.getParameter("def_remark"));
		fee.setDef_sac_id		(request.getParameter("def_sac_id")		==null?"":request.getParameter("def_sac_id"));
		
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);
		
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, fee.getRent_st());
		
		fee_etc.setCms_not_cau	(request.getParameter("cms_not_cau")==null?"":request.getParameter("cms_not_cau"));
		
		if(fee_etc.getRent_mng_id().equals("")){
			fee_etc.setRent_mng_id	(rent_mng_id);
			fee_etc.setRent_l_cd	(rent_l_cd);
			fee_etc.setRent_st		("1");
			//=====[fee_etc] insert=====
			flag6 = a_db.insertFeeEtc(fee_etc);
		}else{
			//=====[fee_etc] update=====
			flag6 = a_db.updateFeeEtc(fee_etc);
		}
		
		//자동이체-------------------------------------------------------------------------------------------
		
		//cms_mng
		ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
		
		
		cms.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
		cms.setCms_bank		(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
		cms.setCms_dep_nm	(request.getParameter("cms_dep_nm")	==null?"":request.getParameter("cms_dep_nm"));
		cms.setCms_day		(request.getParameter("cms_day")	==null?"":request.getParameter("cms_day"));
		cms.setCms_dep_post	(t_zip[AddUtil.parseDigit(zip_cnt)]);
		cms.setCms_dep_addr	(t_addr[AddUtil.parseDigit(zip_cnt)]);
		cms.setCms_etc		(rent_l_cd);
		cms.setCms_tel		(request.getParameter("cms_tel")==null?"":request.getParameter("cms_tel"));
		cms.setCms_m_tel	(request.getParameter("cms_m_tel")==null?"":request.getParameter("cms_m_tel"));
		cms.setCms_email	(request.getParameter("cms_email")==null?"":request.getParameter("cms_email"));
		cms.setCms_dep_ssn	(request.getParameter("cms_dep_ssn")==null?"":request.getParameter("cms_dep_ssn"));
		cms.setBank_cd		(request.getParameter("cms_bank_cd")	==null?"":request.getParameter("cms_bank_cd"));
		
		if(!cms.getBank_cd().equals("")){
			cms.setCms_bank		(c_db.getNameById(cms.getBank_cd(), "BANK"));
		}
		
		if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("")){
			
			if(cms.getSeq().equals("")){
				cms.setRent_mng_id	(rent_mng_id);
				cms.setRent_l_cd	(rent_l_cd);
				cms.setReg_st		("1");
				cms.setReg_id		(user_id);
				cms.setCms_st		("1");
				//=====[cms_mng] insert=====
				flag3 = a_db.insertContCmsMng(cms);
			}else{
				cms.setUpdate_id	(user_id);
				//=====[cms_mng] update=====
				flag3 = a_db.updateContCmsMng(cms);
			}
		}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('대여정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag6){	%>	alert('대여기타 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(idx.equals("13") || idx.equals("99")){
	
	//계약기본정보-----------------------------------------------------------------------------------------------
	
	base.setTax_type	(request.getParameter("tax_type")		==null?"1":request.getParameter("tax_type"));
	//=====[cont] update=====
	flag1 = a_db.updateContBaseNew(base);
	
	//계약기타정보-----------------------------------------------------------------------------------------------
	
	
	cont_etc.setRec_st	(request.getParameter("rec_st")		==null?"":request.getParameter("rec_st"));
	cont_etc.setEle_tax_st	(request.getParameter("ele_tax_st")	==null?"":request.getParameter("ele_tax_st"));
	cont_etc.setTax_extra	(request.getParameter("tax_extra")	==null?"":request.getParameter("tax_extra"));
	
	if(cont_etc.getRent_mng_id().equals("")){
		//=====[cont_etc] insert=====
		cont_etc.setRent_mng_id	(rent_mng_id);
		cont_etc.setRent_l_cd	(rent_l_cd);
		flag2 = a_db.insertContEtc(cont_etc);
	}else{
		//=====[cont_etc] update=====
		flag2 = a_db.updateContEtc(cont_etc);
	}
	
	//부가세환급차량 계산서별도발행여부
	String print_car_st 	= request.getParameter("print_car_st")==null?"":request.getParameter("print_car_st");
	if(!print_car_st.equals("")){
		ClientBean client = al_db.getNewClient(base.getClient_id());
		client.setPrint_car_st		(print_car_st);
		client.setUpdate_id		(user_id);
		if(al_db.updateNewClient2(client)){
			//수정완료
		}
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("14") || idx.equals("99")){
	
	
		
		//대여정보-------------------------------------------------------------------------------------------
		
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		fee.setPrv_dlv_yn		(request.getParameter("prv_dlv_yn")		==null?"":request.getParameter("prv_dlv_yn"));
		fee.setPrv_mon_yn		(request.getParameter("prv_mon_yn")		==null?"":request.getParameter("prv_mon_yn"));
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);
		
		//출고지연대차-------------------------------------------------------------------------------------------
		
		String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
		
		if(taecha_no.equals("")){
			taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
		}
				
		//출고지연대차
		ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
		
		String tae_car_mng_id = request.getParameter("tae_car_mng_id")	==null?"":request.getParameter("tae_car_mng_id");
		
		if(!tae_car_mng_id.equals("") && fee.getPrv_dlv_yn().equals("Y")){
			taecha.setCar_mng_id		(tae_car_mng_id);
			taecha.setCar_no			(request.getParameter("tae_car_no")		==null?"":request.getParameter("tae_car_no"));
			taecha.setCar_nm			(request.getParameter("tae_car_nm")		==null?"":request.getParameter("tae_car_nm"));
			taecha.setCar_id			(request.getParameter("tae_car_id")		==null?"":request.getParameter("tae_car_id"));
			taecha.setCar_seq			(request.getParameter("tae_car_seq")		==null?"":request.getParameter("tae_car_seq"));
			taecha.setCar_rent_st	(request.getParameter("tae_car_rent_st")	==null?"":request.getParameter("tae_car_rent_st"));
			taecha.setCar_rent_et	(request.getParameter("tae_car_rent_et")	==null?"":request.getParameter("tae_car_rent_et"));
			taecha.setRent_fee		(request.getParameter("tae_rent_fee")		==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_fee")));
			taecha.setReq_st			(request.getParameter("tae_req_st")		==null?"":request.getParameter("tae_req_st"));
			taecha.setTae_st			(request.getParameter("tae_tae_st")		==null?"":request.getParameter("tae_tae_st"));
			taecha.setTae_sac_id	(request.getParameter("tae_sac_id")		==null?"":request.getParameter("tae_sac_id"));
			taecha.setRent_inv		(request.getParameter("tae_rent_inv")		==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_inv")));
			taecha.setEst_id			(request.getParameter("tae_est_id")		==null?"":request.getParameter("tae_est_id"));
			taecha.setRent_s_cd		(request.getParameter("tae_s_cd")		==null?"":request.getParameter("tae_s_cd"));
			taecha.setF_req_yn		(request.getParameter("tae_f_req_yn")		==null?"":request.getParameter("tae_f_req_yn"));
			taecha.setRent_fee_st	(request.getParameter("tae_rent_fee_st")	==null?"":request.getParameter("tae_rent_fee_st"));
			taecha.setRent_fee_cls	(request.getParameter("tae_rent_fee_cls")	==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_fee_cls")));
			
			if(taecha.getRent_mng_id().equals("")){
				taecha.setRent_mng_id	(rent_mng_id);
				taecha.setRent_l_cd		(rent_l_cd);
				//=====[gua_ins] insert=====
				flag2 = a_db.insertTaechaNew(taecha);
			}else{
				//=====[gua_ins] update=====
				flag2 = a_db.updateTaechaNew(taecha);
			}
			
			//스케줄담당자에게 메시지 발송
			if(AddUtil.parseInt(taecha.getRent_fee()) >0 && taecha.getF_req_yn().equals("Y") && taecha.getF_req_dt().equals("")){
				UsersBean tae_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("스케줄생성자"));
										
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>출고전대차 선입금 계약</SUB>"+
		  				"    <CONT>출고전대차 선입금 계약 : "+rent_l_cd+"</CONT>"+
 						"    <URL></URL>";
				xml_data3 += "    <TARGET>"+tae_target_bean.getId()+"</TARGET>";
				xml_data3 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
				CdAlertBean msg3 = new CdAlertBean();
				msg3.setFlddata(xml_data3);
				msg3.setFldtype("1");
			
				flag12 = cm_db.insertCoolMsg(msg3);
				
				taecha.setF_req_dt	(AddUtil.getDate(4));
				flag8 = a_db.updateTaechaNew(taecha);
			}
			//20210101 이후 출고전대차 월대여료가 있고, 신차해지요금정삼이 견적서에 표기되어 있지 않음인 경우 권용식과장한테 메시지 발송
			if(taecha.getRent_fee_cls().equals("0") && AddUtil.parseInt(taecha.getRent_fee()) >0  && AddUtil.parseInt(AddUtil.replace(taecha.getCar_rent_st(),"-","")) >= 20210101){				
				UsersBean tae_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("엑셀견적관리자"));
				
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
	  						"    <BACKIMG>4</BACKIMG>"+
	  						"    <MSGTYPE>104</MSGTYPE>"+
	  						"    <SUB>출고전대차 신차해지시요금정산</SUB>"+
			  				"    <CONT>출고전대차 신차해지시요금정산 견적서 미표기 : "+rent_l_cd+"</CONT>"+
	 						"    <URL></URL>";
				xml_data3 += "    <TARGET>"+tae_target_bean.getId()+"</TARGET>";
				xml_data3 += "    <MSGICON>10</MSGICON>"+
	  						"    <MSGSAVE>1</MSGSAVE>"+
	  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
	  						"  </ALERTMSG>"+
	  						"</COOLMSG>";
				
				CdAlertBean msg3 = new CdAlertBean();
				msg3.setFlddata(xml_data3);
				msg3.setFldtype("1");
				
				//flag12 = cm_db.insertCoolMsg(msg3);									
			}
			
			if(!taecha.getRent_inv().equals("") && !taecha.getRent_inv().equals("0")){
				ContFeeBean fee_add = a_db.getContFeeNewAdd(rent_mng_id, rent_l_cd, "t");
				if(!AddUtil.replace(taecha.getCar_rent_et(),"-","").equals(fee_add.getRent_end_dt()) || !AddUtil.replace(taecha.getCar_rent_st(),"-","").equals(fee_add.getRent_start_dt())){
					fee_add.setRent_start_dt	(taecha.getCar_rent_st());
					fee_add.setRent_end_dt		(taecha.getCar_rent_et());
					flag2 = a_db.updateContFeeAdd(fee_add);
				}
			}
			
			int tae_rent_inv_s = request.getParameter("tae_rent_inv_s")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_inv_s"));
			int tae_rent_inv_v = request.getParameter("tae_rent_inv_v")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_inv_v"));
			
			int tae_rent_fee_s = request.getParameter("tae_rent_fee_s")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_fee_s"));
			int tae_rent_fee_v = request.getParameter("tae_rent_fee_v")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_fee_v"));
			
			
			if(tae_rent_inv_s>0){
				//추가연장대여정보 정상요금 수정
				boolean flag30 = a_db.updateContFeeAddInvAmt(rent_mng_id, rent_l_cd, "t", tae_rent_inv_s, tae_rent_inv_v, tae_rent_fee_s, tae_rent_fee_v);
			}else{
				ContFeeBean fee_add = a_db.getContFeeNewAdd(rent_mng_id, rent_l_cd, "t");
				if( tae_rent_fee_s>0 && AddUtil.parseInt(base.getRent_dt()) > 20100910 ){
					if(AddUtil.parseDigit(taecha.getRent_fee()) > fee_add.getFee_s_amt()+fee_add.getFee_v_amt() || AddUtil.parseDigit(taecha.getRent_fee()) < fee_add.getFee_s_amt()+fee_add.getFee_v_amt() ){
						boolean flag30 = a_db.updateContFeeAddFeeAmt(rent_mng_id, rent_l_cd, "t", tae_rent_fee_s, tae_rent_fee_v);
					}
				}
			}
			
			if(!tae_car_mng_id.equals("") && !taecha.getRent_s_cd().equals("")){
				RentContBean rc_bean = rs_db.getRentContCase(taecha.getRent_s_cd(), tae_car_mng_id);
				if(!rc_bean.getSub_l_cd().equals("")){
					rc_bean.setSub_l_cd		(rent_l_cd);
					int rs_count = 1;
					rs_count = rs_db.updateRentCont(rc_bean);
				}
			}
			
		}else{
			if(!taecha.getRent_mng_id().equals("")){
				//=====[taecha] delete =====
				//flag2 = a_db.deleteTaecha(taecha);
			}
		}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('대여정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag2){	%>	alert('출고전대차 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("15") || idx.equals("99")){
	
	//영업소사원-------------------------------------------------------------------------------------------
	
	
	String emp_id[] 	= request.getParameterValues("emp_id");
	String car_off_nm[] = request.getParameterValues("car_off_nm");
	
	if(!emp_id[0].equals("")){
	
		float o_comm_r_rt = emp1.getComm_r_rt();
		
		emp1.setEmp_id		(emp_id[0]);
		emp1.setComm_r_rt	(request.getParameter("v_comm_r_rt")	==null? 0:AddUtil.parseFloat(request.getParameter("v_comm_r_rt")));
		emp1.setCh_remark	(request.getParameter("ch_remark")	==null?"":request.getParameter("ch_remark"));
		emp1.setCh_sac_id	(request.getParameter("ch_sac_id")	==null?"":request.getParameter("ch_sac_id"));
		emp1.setEmp_bank	(request.getParameter("emp_bank")	==null?"":request.getParameter("emp_bank"));
		emp1.setEmp_acc_no	(request.getParameter("emp_acc_no")	==null?"":request.getParameter("emp_acc_no"));
		emp1.setEmp_acc_nm	(request.getParameter("emp_acc_nm")	==null?"":request.getParameter("emp_acc_nm"));
		emp1.setCommi		(request.getParameter("commi")		==null? 0:AddUtil.parseDigit(request.getParameter("commi")));
		emp1.setCommi_car_amt(request.getParameter("commi_car_amt")==null? 0:AddUtil.parseDigit(request.getParameter("commi_car_amt")));
		emp1.setCommi_car_st(request.getParameter("commi_car_st")==null?"1":request.getParameter("commi_car_st"));
		emp1.setAgnt_st		("1");
		emp1.setCommi_st	("1");
		emp1.setBank_cd		(request.getParameter("emp_bank_cd")	==null?"":request.getParameter("emp_bank_cd"));
		
		if(!emp1.getBank_cd().equals("")){
			emp1.setEmp_bank		(c_db.getNameById(emp1.getBank_cd(), "BANK"));
		}
		
		float n_comm_r_rt = emp1.getComm_r_rt();
		
		if(emp1.getRent_mng_id().equals("")){
			emp1.setRent_mng_id	(rent_mng_id);
			emp1.setRent_l_cd	(rent_l_cd);
			//=====[commi] insert=====
			flag1 = a_db.insertCommiNew(emp1);
		}else{
			//=====[commi] update=====
			flag1 = a_db.updateCommiNew(emp1);
		}
		
		//영업사원별담당자 업그레이드하기----------------------------------------------------------------
		CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
		//담당자변경이력
		CarOffEdhBean[] cohList  = cod.getCar_off_edh(emp_id[0]); 
		if(cohList.length >0){
			coh_bean = cohList[cohList.length-1];
			String up_emp_id = "";
			
			if(!coh_bean.getDamdang_id().equals(base.getBus_id())){
				coe_bean = cod.getCarOffEmpBean(emp_id[0]);
				//담당자 이력관리
				coh_bean.setEmp_id		(emp_id[0]);
				coh_bean.setDamdang_id	(base.getBus_id());
				coh_bean.setCng_dt		(base.getRent_dt());
				coh_bean.setCng_rsn		("1");
				coh_bean.setReg_id		(user_id);
				coh_bean.setReg_dt		(base.getRent_dt());
				up_emp_id = cod.updateCarOffEmp(coe_bean, coh_bean);
			}
		}
		
		//영업수당 수정시 영업팀장에게 메시지 발송		
		if(o_comm_r_rt > n_comm_r_rt || o_comm_r_rt < n_comm_r_rt){
		
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 		= "장기계약 계약영업수당 변동";
			String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ] 장기계약의 미결현황에서 계약영업수당이 변동하였습니다. 확인바랍니다.";
			String url 		= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
			String target_id = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
			
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("엑셀견적관리자");
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
	  					"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  					"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
	  					"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			
			flag3 = cm_db.insertCoolMsg(msg);
		}	
		
	}else{
		//영업 영업사원 있다가 취소한 경우 삭제
		if(emp1.getSup_dt().equals("") && !emp1.getEmp_id().equals("") && emp_id[0].equals("")){
			flag1 = a_db.deleteCommi(rent_mng_id, rent_l_cd, "1");
		}
	}
	
	if(!car_gu.equals("0")){
		if(!emp_id[1].equals("")){
			
			emp2.setEmp_id		(emp_id[1]);
			emp2.setAgnt_st		("2");
			emp2.setCommi_st	("1");
			if(emp2.getRent_mng_id().equals("")){
				emp2.setRent_mng_id	(rent_mng_id);
				emp2.setRent_l_cd	(rent_l_cd);
				//=====[commi] insert=====
				flag2 = a_db.insertCommiNew(emp2);
			}else{
				//=====[commi] update=====
				flag2 = a_db.updateCommiNew(emp2);
			}
		}else{
			//출고 영업사원 있다가 취소한 경우 삭제
			if(!emp2.getEmp_id().equals("") && emp_id[1].equals("")){
				flag2 = a_db.deleteCommi(rent_mng_id, rent_l_cd, "2");
			}
		}
	}
	
	//계약기본정보-----------------------------------------------------------------------------------------------
	
	//계약기타정보-----------------------------------------------------------------------------------------------		2017. 12. 06
	cont_etc.setDlv_con_commi_yn(request.getParameter("dlv_con_commi_yn")	==null?"":request.getParameter("dlv_con_commi_yn")); //출고보전수당 지급여부
	cont_etc.setDir_pur_commi_yn(request.getParameter("dir_pur_commi_yn")	==null?"":request.getParameter("dir_pur_commi_yn")); //특판출고 실적이관가능여부
	if(!cont_etc.getRent_mng_id().equals("")){
		flag3 = a_db.updateContEtcModify(cont_etc);
	}
	
	//출고정보-------------------------------------------------------------------------------------------
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	pur.setUdt_st		(request.getParameter("udt_st")			==null?"":request.getParameter("udt_st"));
	pur.setCons_amt1	(request.getParameter("cons_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt1")));
	pur.setCon_amt		(request.getParameter("con_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("con_amt")));
	pur.setCon_bank		(request.getParameter("con_bank")		==null?"":request.getParameter("con_bank"));
	pur.setCon_acc_no	(request.getParameter("con_acc_no")		==null?"":request.getParameter("con_acc_no"));
	pur.setCon_acc_nm	(request.getParameter("con_acc_nm")		==null?"":request.getParameter("con_acc_nm"));
	pur.setTrf_amt5		(request.getParameter("trf_amt5")		==null? 0:AddUtil.parseDigit(request.getParameter("trf_amt5")));
	
	if(pur.getTrf_amt5() >0 && pur.getTrf_st5().equals("")) pur.setTrf_st5("1");
	
	if(car_gu.equals("1")){
		
		String o_one_self  	= pur.getOne_self();
		
		String dlv_est_dt 	= request.getParameter("dlv_est_dt")	==null?"":request.getParameter("dlv_est_dt");
		String dlv_est_h 	= request.getParameter("dlv_est_h")	==null?"":request.getParameter("dlv_est_h");
		pur.setOne_self		(request.getParameter("one_self")	==null?"":request.getParameter("one_self"));
		pur.setDlv_brch		(car_off_nm[1]);
		pur.setDir_pur_yn	(request.getParameter("dir_pur_yn")	==null?"":request.getParameter("dir_pur_yn"));
		pur.setPur_req_dt	(request.getParameter("pur_req_dt")	==null?"":request.getParameter("pur_req_dt"));
		pur.setPur_bus_st	(request.getParameter("pur_bus_st")	==null?"":request.getParameter("pur_bus_st"));
		pur.setPur_req_yn	(request.getParameter("pur_req_yn")	==null?"":request.getParameter("pur_req_yn"));

		
		//=====[CAR_PUR] update=====
		flag4 = a_db.updateContPur(pur);
		
		String n_one_self  	= pur.getOne_self();
		
		//자체출고 수정시 영업팀장에게 메시지 발송
		if(!o_one_self.equals(n_one_self)){
		
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 		= "장기계약 자체출고여부 변동";
			String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ] 장기계약의 미결현황에서 자체출고여부가 변동하였습니다. 확인바랍니다.";
			String url 		= "/agent/lc_rent/lc_b_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
			String target_id = nm_db.getWorkAuthUser("계약변경관리");  //20131205 중고차가분석자->계약변경관리
			
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("엑셀견적관리자");
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
	  					"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  					"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
	  					"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			
			flag3 = cm_db.insertCoolMsg(msg);
		}
	}
	
	if(car_gu.equals("2")){
		
		pur.setRpt_no		(request.getParameter("rpt_no")			==null?"":request.getParameter("rpt_no"));
		pur.setCar_num		(request.getParameter("car_num")		==null?"":request.getParameter("car_num"));
		pur.setTrf_amt1		(request.getParameter("trf_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt1")));
		pur.setDlv_brch		(car_off_nm[1]);
		
		//=====[CAR_PUR] update=====
		flag4 = a_db.updateContPur(pur);
	}	
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('영업담당 영업사원 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('출고담당 영업사원 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag3){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag4){	%>	alert('출고정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
</script>
<%	}%>



<%
	if(idx.equals("16") || idx.equals("99")){
	
		t_zip_size = t_zip.length;
	
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
		fee_etc.setBus_cau	(request.getParameter("bus_cau")==null?"":request.getParameter("bus_cau"));
		
		if(fee_etc.getBus_cau().equals("")){
			fee_etc.setBus_yn	("N");
		}else{
			fee_etc.setBus_yn	("Y");	
		}
		
		//=====[fee_etc] update=====
		flag6 = a_db.updateFeeEtcBus(fee_etc);
		
	%>
<script language='javascript'>
<%		if(!flag6){	%>	alert('대여기타 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("sanction_req")){
	
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		String sanction = "결재요청";
		
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		//=====[cont] update=====
		flag2 = a_db.updateContSanction(rent_mng_id, rent_l_cd, "sanction", user_id, sanction);
		
		
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		
		String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		String sub 		= "장기계약 결재 요청";
		String cont 		= "["+firm_nm+"] 장기계약의 결재를 요청합니다.";
		String target_id 	= nm_db.getWorkAuthUser("본사영업부팀장");
		String url 		= "/agent/lc_rent/lc_b_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
		
		
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		
		if(!cs_bean.getUser_id().equals("")){
			if(cs_bean.getTitle().equals("오전반휴")){
				//등록시간이 오전(12시전)이라면 대체자
				if(AddUtil.getTimeAM().equals("오전")){
					target_id = nm_db.getWorkAuthUser("본사영업팀장");	
				}								
			}else if(cs_bean.getTitle().equals("오후반휴")){
				//등록시간이 오후(12시이후)라면 대체자
				if(AddUtil.getTimeAM().equals("오후")){				
					target_id = nm_db.getWorkAuthUser("본사영업팀장");	
				}
			}else{//연차
				target_id = nm_db.getWorkAuthUser("본사영업팀장");
			}
		}				
		
		
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
 					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag3 = cm_db.insertCoolMsg(msg);
		%>
<script language='javascript'>
<%		if(!flag2){	%>	alert('계약결재요청 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>
<%	}%>

<%
	if(idx.equals("sanction_req_delete")){//계약삭제요청하기
	
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		String sanction_req_delete_cont = request.getParameter("sanction_req_delete_cont")==null?""        :request.getParameter("sanction_req_delete_cont");
		
		String sanction = "계약삭제요청";
		
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		
		String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		String sub 		= "장기계약 삭제요청";
		String cont 	= "["+firm_nm+" "+rent_l_cd+"] 장기계약의 삭제를 요청합니다.  &lt;br&gt; &lt;br&gt;  요청사유 : "+sanction_req_delete_cont;
		String url 		= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|now_stat="+now_stat;
		String target_id = nm_db.getWorkAuthUser("월마감전산담당자");
		String m_url = "/fms2/lc_rent/lc_b_frame.jsp";
				
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		if(!cs_bean.getUser_id().equals(""))	target_id = cs_bean.getWork_id();
		
		//사용자 정보 조회
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>"; 							
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";		
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag3 = cm_db.insertCoolMsg(msg);

		%>
<script language='javascript'>
<%		if(!flag3){	%>	alert('계약삭제요청 에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>
<%	}%>

<%
	
	if(idx.equals("reset_car")){
		
		//차량기본정보-----------------------------------------------------------------------------------------------
		
		car.setCar_cs_amt	(request.getParameter("car_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_cs_amt")));
		car.setCar_cv_amt	(request.getParameter("car_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_cv_amt")));
		car.setCar_fs_amt	(request.getParameter("car_fs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_fs_amt")));
		car.setCar_fv_amt	(request.getParameter("car_fv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("car_fv_amt")));
		car.setOpt_cs_amt	(request.getParameter("opt_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("opt_cs_amt")));
		car.setOpt_cv_amt	(request.getParameter("opt_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("opt_cv_amt")));
		car.setOpt_amt_m	(request.getParameter("opt_amt_m")	==null? 0:AddUtil.parseDigit(request.getParameter("opt_amt_m")));
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
		car.setOpt		(request.getParameter("opt")		==null?"":request.getParameter("opt"));
		car.setOpt_code		(request.getParameter("opt_seq")	==null?"":request.getParameter("opt_seq"));
		car.setColo		(request.getParameter("col")		==null?"":request.getParameter("col"));
		car.setIn_col		(request.getParameter("in_col")		==null?"":request.getParameter("in_col"));		
		car.setGarnish_col		(request.getParameter("garnish_col")		==null?"":request.getParameter("garnish_col"));		
		car.setS_dc1_re_etc	(request.getParameter("s_dc1_re_etc")	==null?"":request.getParameter("s_dc1_re_etc"));
		car.setS_dc2_re_etc	(request.getParameter("s_dc2_re_etc")	==null?"":request.getParameter("s_dc2_re_etc"));
		car.setS_dc3_re_etc	(request.getParameter("s_dc3_re_etc")	==null?"":request.getParameter("s_dc3_re_etc"));
		car.setS_dc1_per	(request.getParameter("s_dc1_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc1_per")));
		car.setS_dc2_per	(request.getParameter("s_dc2_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc2_per")));
		car.setS_dc3_per	(request.getParameter("s_dc3_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc3_per")));
		car.setJg_opt_st	(request.getParameter("jg_opt_st")==null?"":request.getParameter("jg_opt_st"));
		car.setJg_col_st	(request.getParameter("jg_col_st")==null?"":request.getParameter("jg_col_st"));
		car.setJg_tuix_st	(request.getParameter("jg_tuix_st")==null?"":request.getParameter("jg_tuix_st"));
		car.setJg_tuix_opt_st	(request.getParameter("jg_tuix_opt_st")==null?"":request.getParameter("jg_tuix_opt_st"));		
		
		//=====[car_etc] update=====
		flag1 = a_db.updateContCarNew(car);
		
		
		//결재취소
		if(from_page.equals("/agent/lc_rent/lc_cng_car_frame.jsp")){
			//=====[cont] update=====
			flag2 = a_db.updateContSanction(rent_mng_id, rent_l_cd, "sanction_cancel", ck_acar_id, "");
		}
		
		
		String lkas_yn_org = request.getParameter("lkas_yn_org");
		String ldws_yn_org = request.getParameter("ldws_yn_org");
		String aeb_yn_org = request.getParameter("aeb_yn_org");
		String fcw_yn_org	= request.getParameter("fcw_yn_org");
		String hook_yn_org	= request.getParameter("hook_yn_org");
		String legal_yn_org	= request.getParameter("legal_yn_org");
		
		String lkas_yn_modi = "";
		String ldws_yn_modi = "";
		String aeb_yn_modi = "";
		String fcw_yn_modi = "";
		String hook_yn_modi = "";
		String legal_yn_modi = "";
		
		String lkas_yn 				= request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn");
		String lkas_yn_opt_st	= request.getParameter("lkas_yn_opt_st")==null?"":request.getParameter("lkas_yn_opt_st");
		if(lkas_yn.equals("Y")||lkas_yn_opt_st.equals("Y")){
			cont_etc.setLkas_yn("Y");
			lkas_yn_modi = "Y";
		}
		String ldws_yn 				= request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn");
		String ldws_yn_opt_st	= request.getParameter("ldws_yn_opt_st")==null?"":request.getParameter("ldws_yn_opt_st");
		if(ldws_yn.equals("Y")||ldws_yn_opt_st.equals("Y")){
			cont_etc.setLdws_yn("Y");
			ldws_yn_modi = "Y";
		}
		String aeb_yn 				= request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn");
		String aeb_yn_opt_st	= request.getParameter("aeb_yn_opt_st")==null?"":request.getParameter("aeb_yn_opt_st");
		if(aeb_yn.equals("Y")||aeb_yn_opt_st.equals("Y")){
			cont_etc.setAeb_yn("Y");
			aeb_yn_modi = "Y";
		}
		String fcw_yn 				= request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn");
		String fcw_yn_opt_st	= request.getParameter("fcw_yn_opt_st")==null?"":request.getParameter("fcw_yn_opt_st");
		if(fcw_yn.equals("Y")||fcw_yn_opt_st.equals("Y")){
			cont_etc.setFcw_yn("Y");
			fcw_yn_modi = "Y";
		}
		String hook_yn 				= request.getParameter("hook_yn")==null?"":request.getParameter("hook_yn");
		String hook_yn_opt_st		= request.getParameter("hook_yn_opt_st")==null?"":request.getParameter("hook_yn_opt_st");
		if(hook_yn.equals("Y")||hook_yn_opt_st.equals("Y")){
			cont_etc.setHook_yn("Y");
			hook_yn_modi = "Y";
		}
		String legal_yn 				= request.getParameter("legal_yn")==null?"":request.getParameter("legal_yn");
		if(legal_yn.equals("Y")){
			cont_etc.setLegal_yn("Y");
			legal_yn_modi = "Y";
		}
		
		
		
		/*
		
		String chumdan_subject = "첨단장치 및 견인고리, 법률비용지원금 변경알림";
		String chumdan_message = "[첨단장치 및 견인고리, 법률비용지원금 변경알림] ";
		String lkas_message = "";
		String ldws_message = "";
		String aeb_message = "";
		String fcw_message = "";
		String hook_message = "";
		String legal_message = "";
		
		if(lkas_yn_org.length()==0 || lkas_yn_org.equals("N")){
			if(lkas_yn_modi != null && lkas_yn_modi.equals("Y")){
				lkas_message = "차선이탈 제어형을 사용함으로 변경 ";
			}
		}
		if(lkas_yn_org != null && lkas_yn_modi != null){
			if(lkas_yn_org.equals("Y")){
				if(!lkas_yn_modi.equals("Y")){
					lkas_message = "차선이탈 제어형을 사용안함으로 변경 ";
				}
			}	
		}
		
		if(ldws_yn_org.length()==0 || ldws_yn_org.equals("N")){
			if(ldws_yn_modi != null && ldws_yn_modi.equals("Y")){
				ldws_message = "차선이탈 경고형을 사용함으로 변경 ";
			}
		}
		if(ldws_yn_org != null && ldws_yn_modi != null){
			if(ldws_yn_org.equals("Y")){
				if(!ldws_yn_modi.equals("Y")){
					ldws_message = "차선이탈 경고형을 사용안함으로 변경 ";
				}
			}	
		}

		if(aeb_yn_org.length()==0 || aeb_yn_org.equals("N")){
			if(aeb_yn_modi != null && aeb_yn_modi.equals("Y")){
				aeb_message = "긴급제동 제어형을 사용함으로 변경 ";
			}
		}
		if(aeb_yn_org != null && aeb_yn_modi != null){
			if(aeb_yn_org.equals("Y")){
				if(!aeb_yn_modi.equals("Y")){
					aeb_message = "긴급제동 제어형을 사용안함으로 변경 ";
				}
			}	
		}
		
		if(fcw_yn_org.length()==0 || fcw_yn_org.equals("N")){
			if(fcw_yn_modi != null && fcw_yn_modi.equals("Y")){
				fcw_message = "긴급제동 경고형을 사용함으로 변경 ";
			}
		}
		if(fcw_yn_org != null && fcw_yn_modi != null){
			if(fcw_yn_org.equals("Y")){
				if(!fcw_yn_modi.equals("Y")){
					fcw_message = "긴급제동 경고형을 사용안함으로 변경 ";
				}
			}	
		}

		if(hook_yn_org.length()==0 || hook_yn_org.equals("N")){
			if(hook_yn_modi != null && hook_yn_modi.equals("Y")){
				hook_message = "견인고리를 사용함으로 변경 ";
			}
		}
		if(hook_yn_org != null && hook_yn_modi != null){
			if(hook_yn_org.equals("Y")){
				if(!hook_yn_modi.equals("Y")){
					hook_message = "견인고리를 사용안함으로 변경 ";
				}
			}	
		}

		if(legal_yn_org.length()==0 || legal_yn_org.equals("N")){
			if(legal_yn_modi != null && legal_yn_modi.equals("Y")){
				legal_message = "법률비용지원금(고급형)을 가입으로 변경 ";
			}
		}
		if(legal_yn_org != null && legal_yn_modi != null){
			if(legal_yn_org.equals("Y")){
				if(!legal_yn_modi.equals("Y")){
					legal_message = "법률비용지원금(고급형)를 미가입으로 변경 ";
				}
			}	
		}
		
		// 20210219 보험담당자들 요청으로 안보냄 (첨단안전장치는 차 출고할때 설치하고 변경될 일이 없음)
		
		String chumdan_target_id = "000048";		// 총무팀 최치권 사원 (000277)
			
		if(lkas_message.length() > 10 || ldws_message.length() > 10 || aeb_message.length() > 10 || fcw_message.length() > 10 || hook_message.length() > 10 || legal_message.length() > 10){
			String send_name = c_db.getNameByUserId(user_id, "name");	// 보내는 사람 성명
			chumdan_message += send_name;
			chumdan_message += "님이";
			
			Vector vct = new Vector();
			vct = a_db.getCheckCarNo(rent_l_cd);
			
			// 계약번호 rent_l_cd로 조회하여 차대번호와 차량번호 모두 없는 경우 최치권 사원에게 첨단안전장치 변경 사항 전달
			// 차대번호나 차량번호가 있는 경우 고영은 사원에게 첨단안전장치 변경 사항 전달
			if(vct.size() > 0){
				chumdan_target_id = "000130";		// 총무팀 보험담당자 고영은 사원 (000130)
				Hashtable ht = (Hashtable)vct.elementAt(0);
				String bohum_car_no = ht.get("CAR_NO").toString();
				String bohum_car_num = ht.get("CAR_NUM").toString();
				
				if(bohum_car_no.length() < 4){
					chumdan_message += " 차대번호 ";
					chumdan_message += bohum_car_num;
				}else{
					chumdan_message += " 차량번호 ";
					chumdan_message += bohum_car_no;
				}
			}else{
				chumdan_message += " 계약번호 ";
				chumdan_message += rent_l_cd;
			}
			
			chumdan_message += " 계약의 ";
		}
		
		if(lkas_message.length() > 10){chumdan_message += lkas_message;}
		if(ldws_message.length() > 10){chumdan_message += ldws_message;}
		if(aeb_message.length() > 10){chumdan_message += aeb_message;}
		if(fcw_message.length() > 10){chumdan_message += fcw_message;}
		if(hook_message.length() > 10){chumdan_message += hook_message;}
		if(legal_message.length() > 10){chumdan_message += legal_message;}
		
		if(lkas_message.length() > 10 || ldws_message.length() > 10 || aeb_message.length() > 10 || fcw_message.length() > 10 || hook_message.length() > 10 || legal_message.length() > 10){
			chumdan_message += "하였습니다.";
						
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(chumdan_target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
					
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+chumdan_subject+"</SUB>"+
					"    <CONT>"+chumdan_message+"</CONT>"+
					"    <URL></URL>";
	xml_data2 += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
					"    <MSGICON>10</MSGICON>"+
					"    <MSGSAVE>1</MSGSAVE>"+
					"    <LEAVEDMSG>1</LEAVEDMSG>"+
					"    <FLDTYPE>1</FLDTYPE>"+
					"  </ALERTMSG>"+
					"</COOLMSG>";
			
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
			
			flag14 = cm_db.insertCoolMsg(msg2);
		}
		
		*/
		
		flag13 = a_db.updateContEtc(cont_etc);
		// 첨단안전장치 ### end ###
		
		
		%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>
</script>
<%	}%>

<%
	if(idx.equals("com_emp_sac")){
	
		//미가입사유 others
		base.setOthers		(request.getParameter("others")			==null?"":request.getParameter("others"));
		//=====[cont] update=====
		flag1 = a_db.updateContBaseNew(base);
		

		//=====[cont_etc] update=====
		flag2 = ec_db.updateContEtcComEmpSac(rent_mng_id, rent_l_cd, user_id);		
	
	}
%>	

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>      
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>      
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>  
  <input type='hidden' name='rent_st'	 		value=''>   
  <input type='hidden' name="now_stat"			value="<%=now_stat%>">              
</form>
<script language='javascript'>

	var fm = document.form1;
	
	<%if(idx.equals("sanction_req")){%>
	fm.action = '/agent/lc_rent/lc_b_frame.jsp';		
	<%}else{%>
	fm.action = '/agent/lc_rent/lc_b_u.jsp';	
	<%}%>
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>