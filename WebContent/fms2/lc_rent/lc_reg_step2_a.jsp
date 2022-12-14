<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*, acar.car_mst.*, cust.member.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
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
	
	String rent_mng_id 		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String old_rent_mng_id 		= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 		= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	String t_zip[] 			= request.getParameterValues("t_zip");
	String t_addr[] 		= request.getParameterValues("t_addr");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag12 = true;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();

	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));


	//1. 계약기본정보-----------------------------------------------------------------------------------------------
	
	//cont
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String tax_agnt 	= request.getParameter("tax_agnt")==null?"":request.getParameter("tax_agnt");
	String t_addr_sub 	= request.getParameter("t_addr_sub")==null?"":request.getParameter("t_addr_sub");
	
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_st 	= request.getParameter("client_st")==null?"":request.getParameter("client_st");
	
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	// ContBase insert 
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	base.setClient_id	(client_id);
	base.setR_site		(site_id);
	base.setP_zip		(t_zip[0]);
	base.setP_addr		(t_addr[0]+" "+t_addr_sub);
	base.setTax_agnt	(tax_agnt);
	base.setReg_step	("2");
	base.setBus_id2		("000026");
	base.setLic_no		(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));	
	base.setMgr_lic_no	(request.getParameter("mgr_lic_no")==null?"":request.getParameter("mgr_lic_no"));	
	base.setMgr_lic_emp	(request.getParameter("mgr_lic_emp")==null?"":request.getParameter("mgr_lic_emp"));	
	base.setMgr_lic_rel	(request.getParameter("mgr_lic_rel")==null?"":request.getParameter("mgr_lic_rel"));
	
	base.setTest_lic_emp	(request.getParameter("test_lic_emp")==null?"":request.getParameter("test_lic_emp"));	
	base.setTest_lic_rel	(request.getParameter("test_lic_rel")==null?"":request.getParameter("test_lic_rel"));
	base.setTest_lic_result	(request.getParameter("test_lic_result")==null?"":request.getParameter("test_lic_result"));
	
	base.setTest_lic_emp2	(request.getParameter("test_lic_emp2")==null?"":request.getParameter("test_lic_emp2"));	
	base.setTest_lic_rel2	(request.getParameter("test_lic_rel2")==null?"":request.getParameter("test_lic_rel2"));
	base.setTest_lic_result2(request.getParameter("test_lic_result2")==null?"":request.getParameter("test_lic_result2"));
	
	//=====[cont] insert=====
	flag1 = a_db.updateContBaseNew(base);
	
	
	// ContEtc insert 
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//cont_etc
	String client_guar_st	= request.getParameter("client_guar_st")==null?"":request.getParameter("client_guar_st");	
	String guar_con 			= request.getParameter("guar_con")==null?"":request.getParameter("guar_con");
	String guar_sac_id		= request.getParameter("guar_sac_id")==null?"":request.getParameter("guar_sac_id");
	String guar_st 				= request.getParameter("guar_st")==null?"":request.getParameter("guar_st");
	String client_share_st= request.getParameter("client_share_st")==null?"":request.getParameter("client_share_st");
	String car_use_addr 	= request.getParameter("car_use_addr")==null?"":request.getParameter("car_use_addr");	//차량이용지 주소 추가 (2018.03.09)
	
	cont_etc.setClient_guar_st(client_guar_st);
	cont_etc.setGuar_st				(guar_st);
	cont_etc.setGuar_con			(guar_con);
	cont_etc.setGuar_sac_id		(guar_sac_id);	
	cont_etc.setClient_share_st(client_share_st);
	cont_etc.setCar_use_addr	(car_use_addr);		//차량이용지 주소 추가 (2018.03.09)
	cont_etc.setMng_type			(request.getParameter("mng_type")==null?"":request.getParameter("mng_type"));	
	
	//=====[cont_etc] insert=====
	flag3 = a_db.updateContEtc(cont_etc);	
	
	
	//계약 영업담당자 배정처리
	String  d_flag3 =  ad_db.call_sp_rent_busid2_auto_reg(rent_mng_id, rent_l_cd);
	
	//if(base.getBus_st().equals("7")){
		//에이전트 계약처리
		//String  d_flag4 =  ad_db.call_sp_agent_users();
	//}	
	
	
	// ContBase insert 
	base = a_db.getCont(rent_mng_id, rent_l_cd);

	//월렌트
	if(base.getCar_st().equals("4")){	

		//월렌트 - 우량기업 고정후 바로 4단계로
		base.setSpr_kd		("1");
		base.setReg_step	("3");

	//업무대여
	}else if(base.getCar_st().equals("5")){
		
		//사용자
		UsersBean emp_bean 	= new UsersBean();
		if(!firm_nm.equals("") && !firm_nm.equals("(주)아마존카")){
			emp_bean = umd.getUserNmBean(firm_nm);
			base.setBus_id	(emp_bean.getUser_id());
			base.setBus_id2	(emp_bean.getUser_id());
			base.setMng_id	(emp_bean.getUser_id());
		}else{
			base.setBus_id	(user_id);
			base.setBus_id2	(user_id);
			base.setMng_id	(user_id);			
		}

	}
	
	//=====[cont] insert=====
	flag1 = a_db.updateContBaseNew(base);			


	//2. 관계자관련테이블 생성 [car_mgr,car_pur,car_etc,fee,allot] insert-------------------------------------------------
	
	//car_mgr
	String mgr_st[] 			= request.getParameterValues("mgr_st");
	String mgr_com[] 			= request.getParameterValues("mgr_com");
	String mgr_dept[] 			= request.getParameterValues("mgr_dept");
	String mgr_nm[] 			= request.getParameterValues("mgr_nm");
	String mgr_title[] 			= request.getParameterValues("mgr_title");
	String mgr_tel[] 			= request.getParameterValues("mgr_tel");
	String mgr_m_tel[] 			= request.getParameterValues("mgr_m_tel");
	String mgr_email[] 			= request.getParameterValues("mgr_email");
	
	String mgr_ssn[] 			= request.getParameterValues("mgr_ssn");
	String mgr_addr[] 			= request.getParameterValues("mgr_addr");
	String mgr_lic_no[] 			= request.getParameterValues("mgr_lic_no");
	String mgr_etc[] 			= request.getParameterValues("mgr_etc");
	
	
	int mgr_size = mgr_st.length;
	
	for(int i = 0 ; i < mgr_size ; i++){
		
		CarMgrBean mgr = new CarMgrBean();
		
		mgr.setRent_mng_id	(rent_mng_id);
		mgr.setRent_l_cd	(rent_l_cd);
		mgr.setMgr_id		(String.valueOf(i));
		mgr.setMgr_st		(mgr_st[i]);
		mgr.setMgr_nm		(mgr_nm[i]);
		
		if(base.getCar_st().equals("4")){
			mgr.setSsn		(mgr_ssn[i]);
			mgr.setMgr_addr		(mgr_addr[i]);
			mgr.setLic_no		(mgr_lic_no[i]);		
			mgr.setEtc		(mgr_etc[i]);
		
		}else{
			mgr.setMgr_dept		(mgr_dept[i]);
			mgr.setMgr_title	(mgr_title[i]);
			mgr.setMgr_email	(mgr_email[i].trim());		
			mgr.setCom_nm		(mgr_com[i]);
			
			if(i == 0){
				mgr.setMgr_zip		(t_zip[1]);
				mgr.setMgr_addr		(t_addr[1]);
			}
			
		}
		mgr.setMgr_tel		(mgr_tel[i]);
		mgr.setMgr_m_tel	(mgr_m_tel[i]);
		mgr.setUse_yn		("Y");
		mgr.setEmail_yn		("Y");
		
		if(mgr.getMgr_st().equals("추가운전자")){
			if(mgr.getMgr_nm().equals("")){
				mgr.setMgr_nm	(request.getParameter("mgr_lic_emp5")	==null?"":request.getParameter("mgr_lic_emp5"));
			}
			mgr.setLic_no		(request.getParameter("mgr_lic_no5")	==null?"":request.getParameter("mgr_lic_no5"));
			mgr.setEtc			(request.getParameter("mgr_lic_rel5")	==null?"":request.getParameter("mgr_lic_rel5"));
			mgr.setLic_result	(request.getParameter("mgr_lic_result5")	==null?"":request.getParameter("mgr_lic_result5"));
		}
		
		
		//=====[CAR_MGR] update=====
		flag2 = a_db.updateCarMgrNew(mgr);
		
	}
	
	
	//월렌트정보
	if(base.getCar_st().equals("4")){
			
		//fee_rm
		ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
		fee_rm.setCar_use	(request.getParameter("rm_car_use")==null?"":request.getParameter("rm_car_use"));
		if(fee_rm.getRent_mng_id().equals("")){
			fee_rm.setRent_mng_id		(rent_mng_id);
			fee_rm.setRent_l_cd		(rent_l_cd);
			fee_rm.setRent_st		("1");
			//=====[fee_rm] insert=====
			flag2 = a_db.insertFeeRm(fee_rm);
		}else{
			//=====[fee_rm] update=====
			flag2 = a_db.updateFeeRm(fee_rm);
		}
	}else{
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
	}



	
	
	//cont_gur
	String gur_nm[] 	= request.getParameterValues("gur_nm");
	String gur_ssn[] 	= request.getParameterValues("gur_ssn");
	String gur_tel[] 	= request.getParameterValues("gur_tel");
	String gur_rel[] 	= request.getParameterValues("gur_rel");
	
	int gur_size = gur_nm.length;
	
	for(int i = 0 ; i < gur_size ; i++){
	
		if(!gur_nm[i].equals("") && guar_st.equals("1")){
			ContGurBean gur = a_db.getContGur(rent_mng_id, rent_l_cd, String.valueOf(i));
			gur.setGur_nm		(gur_nm[i]);
			gur.setGur_ssn		(gur_ssn[i]);
			gur.setGur_zip		(t_zip[i+2]);
			gur.setGur_addr		(t_addr[i+2]);
			gur.setGur_tel		(gur_tel[i]);
			gur.setGur_rel		(gur_rel[i]);
			
			if(gur.getRent_l_cd().equals("")){
			   gur.setRent_mng_id	(rent_mng_id);
			   gur.setRent_l_cd	(rent_l_cd);
			   gur.setGur_id		(String.valueOf(i));
			   //=====[CONT_GUR] update=====
			   flag4 = a_db.insertContGur(gur);
				
			}else{
				//=====[CONT_GUR] update=====
				flag4 = a_db.updateContGur(gur);
			}
		}
	}


	//4. 고객FMS임시아이디 지정-----------------------------------------------------------------------------------------------
	/* 20210607 별도처리
	site_id = "";	
	MemberBean m_bean = m_db.getMemberCase(client_id, "", "");
	int count2 = 0;
	if(m_bean.getMember_id().equals("")){
		//회원정보 등록
		MemberBean no_m_bean = m_db.getNoMemberCase(client_id, "", "");
		
		int idcnt = m_db.checkMemberIdPwd("amazoncar", no_m_bean.getPwd());
		
		if(idcnt==0){
			count2 = m_db.insertMember(client_id, "", "amazoncar", no_m_bean.getPwd(), "");
		}else{
			count2 = m_db.updateMemberUseYN(client_id); //기존 use_yn='N'를'Y'로 처리 
		//	count2 = m_db.insertMember(client_id, site_id, "amazoncar", no_m_bean.getPwd()+String.valueOf(idcnt+1), "");
		}
	}
	*/


	//고객별 최종스캔 동기화
	//String  d_flag1 =  ad_db.call_sp_lc_rent_scanfile_syn(rent_mng_id, rent_l_cd, user_id);
	

%>




<form name='form1' action='' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type='hidden' name="old_rent_mng_id" 		value="<%=old_rent_mng_id%>">
  <input type='hidden' name="old_rent_l_cd" 		value="<%=old_rent_l_cd%>">
</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(!flag1 || !flag2 || !flag3 || !flag4){	%>
		alert('에러가 발생하였습니다. \n\n확인하십시오');
<%	}else{	%>
		alert("등록되었습니다");
		<%	if(base.getCar_st().equals("4")){%>
		fm.action = 'lc_reg_step4_rm.jsp';
		<%	}else if(base.getCar_st().equals("5")){%>
		fm.action = 'lc_reg_step4.jsp';
		<%	}else{%>
		fm.action = 'lc_reg_step3.jsp';
		<%	}%>
		fm.target = 'd_content';
		fm.submit();
<%	}	%>
</script>
</body>
</html>
