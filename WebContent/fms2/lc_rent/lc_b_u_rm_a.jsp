<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_mst.*, acar.car_office.*, acar.res_search.*, acar.client.*,  cust.member.*, acar.ext.*, acar.car_sche.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.estimate_mng.*, acar.short_fee_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<jsp:useBean id="oh_db" scope="session" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<jsp:useBean id="ad_db" 	scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
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
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")	==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd");
	String idx 		= request.getParameter("idx")		==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")	==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")	==null?"":request.getParameter("car_st");
	
	String fee_size 	= request.getParameter("fee_size")	==null?"":request.getParameter("fee_size");
	String zip_cnt 		= request.getParameter("zip_cnt")	==null?"":request.getParameter("zip_cnt");
	String now_stat	 	= request.getParameter("now_stat")	==null?"":request.getParameter("now_stat");
	
	String t_zip[] 		= request.getParameterValues("t_zip");
	String t_addr[] 	= request.getParameterValues("t_addr");
	
	int t_zip_size = 0;
	
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
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
%>


<%
	if(idx.equals("0") || idx.equals("99")){
	
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		//최초영업자,영업담당자,계약일자,계약구분,영업구분,용도구분
		base.setBus_id			(request.getParameter("bus_id")		==null?"":request.getParameter("bus_id"));
		base.setBus_id2			(request.getParameter("bus_id2")	==null?"":request.getParameter("bus_id2"));		
		//=====[cont] update=====
		flag1 = a_db.updateContBaseNew(base);
		
		
		//계약기타정보-----------------------------------------------------------------------------------------------
				
		//관리지점,영업대리인
		cont_etc.setCar_deli_dt		(request.getParameter("car_deli_dt")	==null?"":request.getParameter("car_deli_dt"));
		cont_etc.setEst_area		(request.getParameter("est_area")	==null?"":request.getParameter("est_area"));
		
		
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag2 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag2 = a_db.updateContEtc(cont_etc);
		}
		
		%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag3){	%>	alert('대여정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("suc_commi")){
	
		//계약기타정보-----------------------------------------------------------------------------------------------
		
		cont_etc.setRent_suc_commi	(request.getParameter("rent_suc_commi")==null? 0:AddUtil.parseDigit(request.getParameter("rent_suc_commi")));
		cont_etc.setRent_suc_dt		(request.getParameter("rent_suc_dt")==null?"":request.getParameter("rent_suc_dt"));
		cont_etc.setRent_suc_grt_yn	(request.getParameter("rent_suc_grt_yn")==null?"":request.getParameter("rent_suc_grt_yn"));		
		cont_etc.setRent_suc_commi_pay_st(request.getParameter("rent_suc_commi_pay_st")	==null?"":request.getParameter("rent_suc_commi_pay_st"));
		if(cont_etc.getRent_suc_commi()>0 && cont_etc.getRent_suc_commi_pay_st().equals("")){
			cont_etc.setRent_suc_commi_pay_st("2");
		}
		
		cont_etc.setGrt_suc_o_amt	(request.getParameter("suc_grt_suc_o_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_grt_suc_o_amt")));
		cont_etc.setGrt_suc_r_amt	(request.getParameter("suc_grt_suc_r_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_grt_suc_r_amt")));
		
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag2 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag2 = a_db.updateContEtc(cont_etc);
		}
		
		
		if(cont_etc.getRent_suc_commi()>0){
			
			int suc_commi_s_amt = request.getParameter("suc_commi_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_commi_s_amt"));
			int suc_commi_v_amt = request.getParameter("suc_commi_v_amt")==null? 0:AddUtil.parseDigit(request.getParameter("suc_commi_v_amt"));
			
			
			//승계수수료
			ExtScdBean suc = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//기존 등록 여부 조회
			
			//원계약자 승계수수료 부담
			if(cont_etc.getRent_suc_commi_pay_st().equals("1")){
				suc = ae_db.getAGrtScd(rent_mng_id, cont_etc.getRent_suc_l_cd(), "1", "5", "1");//기존 등록 여부 조회
				
			}
			

			if(suc == null || suc.getRent_l_cd().equals("")){
				
			}else{				
			
				//승계수수료 동일하고 공급가 금액 미세조정시
				if(suc.getExt_s_amt()+suc.getExt_v_amt() > suc_commi_s_amt+suc_commi_v_amt || suc.getExt_s_amt()+suc.getExt_v_amt() < suc_commi_s_amt+suc_commi_v_amt){
					if(cont_etc.getRent_suc_commi() == suc.getExt_s_amt()+suc.getExt_v_amt()){
						suc.setExt_s_amt	(suc_commi_s_amt);
						suc.setExt_v_amt	(suc_commi_v_amt);
						//=====[scd_pre] update=====
						flag6 = ae_db.i_updateGrt(suc);
					}else{
						if(!suc.getExt_pay_dt().equals("")){
							if(suc_commi_s_amt>0){
								suc.setExt_s_amt	(suc_commi_s_amt);
								suc.setExt_v_amt	(suc_commi_v_amt);
							}else{
								suc.setExt_s_amt	(AddUtil.parseInt(String.valueOf(AddUtil.parseFloat(String.valueOf(cont_etc.getRent_suc_commi()))/1.1)));
								suc.setExt_v_amt	(cont_etc.getRent_suc_commi()-suc.getExt_s_amt());
							}
							//=====[scd_pre] update=====
							flag6 = ae_db.updateGrt(suc);
						}else{
							if(suc.getExt_pay_dt().equals("") && suc.getExt_v_amt()>0){
								if(suc_commi_s_amt>0){
									suc.setExt_s_amt	(suc_commi_s_amt);
									suc.setExt_v_amt	(suc_commi_v_amt);
								}else{
									suc.setExt_s_amt	(AddUtil.parseInt(String.valueOf(AddUtil.parseFloat(String.valueOf(cont_etc.getRent_suc_commi()))/1.1)));
									suc.setExt_v_amt	(cont_etc.getRent_suc_commi()-suc.getExt_s_amt());
								}
								//=====[scd_pre] update=====
								flag6 = ae_db.updateGrt(suc);
							}else if(suc.getExt_pay_dt().equals("") && suc.getExt_v_amt()==0 && suc_commi_v_amt > 0){
									suc.setExt_s_amt	(suc_commi_s_amt);
									suc.setExt_v_amt	(suc_commi_v_amt);
									//=====[scd_pre] update=====
									flag6 = ae_db.i_updateGrt(suc); //잔액체크없이 수정
							}else if(suc.getExt_pay_dt().equals("") && suc.getExt_v_amt()==0 && suc_commi_v_amt == 0){
									suc.setExt_s_amt	(suc_commi_s_amt);
									suc.setExt_v_amt	(suc_commi_v_amt);
									//=====[scd_pre] update=====
									flag6 = ae_db.i_updateGrt(suc); //잔액체크없이 수정
							}else{
								if(suc.getExt_s_amt()+suc.getExt_v_amt()==0){
									suc.setExt_s_amt	(suc_commi_s_amt);
									suc.setExt_v_amt	(suc_commi_v_amt);
									//=====[scd_pre] update=====
									flag6 = ae_db.i_updateGrt(suc); //잔액체크없이 수정
								}
							}
						}
					}
				}else{
					if(suc.getExt_pay_dt().equals("")){
						if(suc.getExt_s_amt() > suc_commi_s_amt || suc.getExt_s_amt() < suc_commi_s_amt || suc.getExt_v_amt() > suc_commi_v_amt || suc.getExt_v_amt() < suc_commi_v_amt){
							suc.setExt_s_amt	(suc_commi_s_amt);
							suc.setExt_v_amt	(suc_commi_v_amt);
							//=====[scd_pre] update=====
							flag6 = ae_db.i_updateGrt(suc); //잔액체크없이 수정					
						}
					}
				}
			}
		}
		if(cont_etc.getRent_suc_commi()==0){
			//승계수수료
			ExtScdBean suc = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//기존 등록 여부 조회
			//원계약자 승계수수료 부담
			if(cont_etc.getRent_suc_commi_pay_st().equals("1")){
				suc = ae_db.getAGrtScd(rent_mng_id, cont_etc.getRent_suc_l_cd(), "1", "5", "1");//기존 등록 여부 조회				
			}
			if(suc == null || suc.getRent_l_cd().equals("")){
				
			}else{	
				if(suc.getExt_pay_dt().equals("")){
					suc.setExt_s_amt	(0);
					suc.setExt_v_amt	(0);
					//=====[scd_pre] update=====
					flag6 = ae_db.i_updateGrt(suc); //잔액체크없이 수정			
				}
			}
		}
		%>
<script language='javascript'>
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
		base.setP_zip			(t_zip[0]);
		base.setP_addr			(t_addr[0]);
		base.setTax_agnt		(request.getParameter("tax_agnt")	==null?"":request.getParameter("tax_agnt"));
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
		
		String mgr_ssn[] 			= request.getParameterValues("mgr_ssn");
		String mgr_addr[] 			= request.getParameterValues("mgr_addr");
		String mgr_lic_no[] 			= request.getParameterValues("mgr_lic_no");
		String mgr_etc[] 			= request.getParameterValues("mgr_etc");		
		
		int mgr_size = mgr_st.length;
		
		for(int i = 0 ; i < mgr_size ; i++){
			
			CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, mgr_st[i]);
			//근무처,부서,성명,직위,전화번호,휴대폰,이메일
			mgr.setMgr_nm		(mgr_nm[i]);						
			mgr.setSsn		(mgr_ssn[i]);
			mgr.setMgr_addr		(mgr_addr[i]);
			mgr.setLic_no		(mgr_lic_no[i]);		
			mgr.setEtc		(mgr_etc[i]);			
			mgr.setMgr_tel		(mgr_tel[i]);
			mgr.setMgr_m_tel	(mgr_m_tel[i]);
										
			if(mgr.getRent_mng_id().equals("")){
				mgr.setRent_mng_id	(rent_mng_id);
				mgr.setRent_l_cd	(base.getRent_l_cd());
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
		
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] insert=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag1 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag1 = a_db.updateContEtc(cont_etc);
		}
		
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
	if(idx.equals("8") || idx.equals("99")){
	
	//차량기본정보-----------------------------------------------------------------------------------------------
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	car.setRemark		(request.getParameter("remark")			==null?"":request.getParameter("remark"));
	
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("9") || idx.equals("99")){
	
	/*
	
	//차량기본정보-----------------------------------------------------------------------------------------------
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);


	car.setSh_car_amt	(request.getParameter("sh_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
	car.setSh_year		(request.getParameter("sh_year")	==null?"":request.getParameter("sh_year"));
	car.setSh_month		(request.getParameter("sh_month")	==null?"":request.getParameter("sh_month"));
	car.setSh_day		(request.getParameter("sh_day")		==null?"":request.getParameter("sh_day"));
	car.setSh_day_bas_dt	(request.getParameter("sh_day_bas_dt")	==null?"":request.getParameter("sh_day_bas_dt"));
	car.setSh_amt		(request.getParameter("sh_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
	car.setSh_ja		(request.getParameter("sh_ja")		==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
	car.setSh_km		(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
	car.setSh_km_bas_dt	(request.getParameter("sh_km_bas_dt")	==null?"":request.getParameter("sh_km_bas_dt"));
		
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, fee_size);
	fee_etc.setSh_car_amt		(request.getParameter("sh_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
	fee_etc.setSh_year		(request.getParameter("sh_year")	==null?"":request.getParameter("sh_year"));
	fee_etc.setSh_month		(request.getParameter("sh_month")	==null?"":request.getParameter("sh_month"));
	fee_etc.setSh_day		(request.getParameter("sh_day")		==null?"":request.getParameter("sh_day"));
	fee_etc.setSh_day_bas_dt	(request.getParameter("sh_day_bas_dt")	==null?"":request.getParameter("sh_day_bas_dt"));
	fee_etc.setSh_amt		(request.getParameter("sh_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
	fee_etc.setSh_ja		(request.getParameter("sh_ja")		==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
	fee_etc.setSh_km		(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
	fee_etc.setSh_tot_km		(request.getParameter("sh_tot_km")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_tot_km")));
	fee_etc.setSh_km_bas_dt		(request.getParameter("sh_km_bas_dt")	==null?"":request.getParameter("sh_km_bas_dt"));
	fee_etc.setSh_init_reg_dt	(request.getParameter("sh_init_reg_dt")	==null?"":request.getParameter("sh_init_reg_dt"));
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
		

	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	*/
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		

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
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
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
	cont_etc.setInsurant	(request.getParameter("insurant")	==null?"":request.getParameter("insurant"));
	cont_etc.setCom_emp_yn	(request.getParameter("com_emp_yn")	==null?"":request.getParameter("com_emp_yn"));

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

	//System.out.println(rent_l_cd);
	//System.out.println(ins_chk1);
	//System.out.println(ins_chk2);
	//System.out.println(ins_chk3);

	if(!ins_chk1.equals("") || !ins_chk2.equals("") || !ins_chk3.equals("")  || !ins_chk4.equals("") ){
		
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 		= "보험 현재 가입과 약정이 틀림";
			String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ] "+ins_chk1+" "+ins_chk2+" "+ins_chk3+" "+ins_chk4+" 확인바랍니다.";
			String url 		= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;
			String target_id = nm_db.getWorkAuthUser("부산보험담당");
			String m_url = "/fms2/lc_rent/lc_b_frame.jsp";
			CarSchDatabase csd = CarSchDatabase.getInstance();
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals("")){
				target_id = nm_db.getWorkAuthUser("본사보험담당");
				//보험담당자 모두 휴가일때
				cs_bean = csd.getCarScheTodayBean(target_id);
				if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
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
			
			//flag12 = cm_db.insertCoolMsg(msg);
		
	}
	
	
	//fee_rm
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");	
	
	fee_rm.setMy_accid_yn	(request.getParameter("my_accid_yn")==null?"":request.getParameter("my_accid_yn"));
	
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
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("16") || idx.equals("99")){
	

	//fee_rm
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");	
	
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
	
	fee_rm.setDeli_loc	(request.getParameter("deli_loc")==null?"":request.getParameter("deli_loc"));
	fee_rm.setRet_loc	(request.getParameter("ret_loc")==null?"":request.getParameter("ret_loc"));
			
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
	%>
<script language='javascript'>
<%		if(!flag2){	%>	alert('월렌트계약정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>



<%
	if(idx.equals("12") || idx.equals("99")){
	

	
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, fee_size);
	
	int old_fee_s_amt = fee.getFee_s_amt();
	int old_inv_s_amt = fee.getInv_s_amt();
		

		
	fee.setExt_agnt			(request.getParameter("ext_agnt")		==null? "":request.getParameter("ext_agnt"));
	fee.setRent_dt			(request.getParameter("ext_rent_dt")		==null? "":request.getParameter("ext_rent_dt"));

	fee.setCon_mon			(request.getParameter("con_mon")		==null?"":request.getParameter("con_mon"));
		
	if(!fee_size.equals("1") && nm_db.getWorkAuthUser("전산팀",ck_acar_id)){
		fee.setRent_start_dt	(request.getParameter("rent_start_dt")		==null?"":request.getParameter("rent_start_dt"));
		fee.setRent_end_dt	(request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt"));
	}
	
	fee.setGur_per			(request.getParameter("gur_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_per")));
	fee.setGur_p_per		(request.getParameter("gur_p_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
	fee.setCls_per			(request.getParameter("cls_per")		==null?"":request.getParameter("cls_per"));
	fee.setCls_r_per		(request.getParameter("cls_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("cls_r_per")));
	fee.setDc_ra			(request.getParameter("dc_ra")			==null? 0:AddUtil.parseFloat(request.getParameter("dc_ra")));
	fee.setGrt_amt_s		(request.getParameter("grt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("grt_s_amt")));
	fee.setFee_s_amt		(request.getParameter("fee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_s_amt")));
	fee.setFee_v_amt		(request.getParameter("fee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_v_amt")));
	fee.setInv_s_amt		(request.getParameter("inv_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_s_amt")));
	fee.setInv_v_amt		(request.getParameter("inv_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_v_amt")));
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
	fee.setGrt_suc_yn		(request.getParameter("grt_suc_yn")		==null?"":request.getParameter("grt_suc_yn"));

			
	//=====[fee] update=====
	flag1 = a_db.updateContFeeNew(fee);
		
	int new_fee_s_amt = fee.getFee_s_amt();
	int new_inv_s_amt = fee.getInv_s_amt();
		
	int fee_oldnew_amt = (old_fee_s_amt-new_fee_s_amt);//+(old_inv_s_amt-new_inv_s_amt)
	//대여료 계약요금 변경시 문자 보내기
	if(fee.getRent_st().equals("1") && (fee_oldnew_amt>0 || fee_oldnew_amt<0) && cont_etc.getRent_suc_dt().equals("")){		
		
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
		String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		String sub 		= "장기계약 대여료 계약요금 변동";
		String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ] 장기계약의 대여료 계약요금이 변동하였습니다. 확인바랍니다.";
		String url 		= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;
		String target_id = nm_db.getWorkAuthUser("세금계산서담당자");
		String m_url = "/fms2/lc_rent/lc_b_frame.jsp";
		CarSchDatabase csd = CarSchDatabase.getInstance();
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
			
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
		
		
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, fee_size);
		
	fee_etc.setCms_not_cau		(request.getParameter("cms_not_cau")		==null?"":request.getParameter("cms_not_cau"));
	fee_etc.setAgree_dist		(request.getParameter("agree_dist")		==null? 0:AddUtil.parseDigit(request.getParameter("agree_dist")));
	fee_etc.setOver_run_amt		(request.getParameter("over_run_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("over_run_amt")));
	fee_etc.setCon_day		(request.getParameter("con_day")		==null?"":request.getParameter("con_day"));		
	fee_etc.setBus_agnt_id		(request.getParameter("ext_bus_agnt_id")==null?"":request.getParameter("ext_bus_agnt_id"));
		
		
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
		
						
	if(fee_etc.getRent_st().equals("1")){
		base.setRent_start_dt(request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt"));
	}
	base.setRent_end_dt	(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
		
	//=====[cont] update=====
	flag5 = a_db.updateContBaseNew(base);
		
		
	if(fee_etc.getCng_chk_st().equals("계약승계") && !fee_etc.getCng_chk_id().equals("") && fee_etc.getCng_chk_dt().equals("")){//
		
	}else{
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
						
	}
	
	
	//fee_rm
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, fee_size);
		
	fee_rm.setDc_s_amt	(request.getParameter("dc_s_amt")==null?0:Util.parseDigit(request.getParameter("dc_s_amt")));
	fee_rm.setDc_v_amt	(request.getParameter("dc_v_amt")==null?0:Util.parseDigit(request.getParameter("dc_v_amt")));
	fee_rm.setNavi_s_amt	(request.getParameter("navi_s_amt")==null?0:Util.parseDigit(request.getParameter("navi_s_amt")));
	fee_rm.setNavi_v_amt	(request.getParameter("navi_v_amt")==null?0:Util.parseDigit(request.getParameter("navi_v_amt")));
	fee_rm.setEtc_s_amt	(request.getParameter("etc_s_amt")==null?0:Util.parseDigit(request.getParameter("etc_s_amt")));
	fee_rm.setEtc_v_amt	(request.getParameter("etc_v_amt")==null?0:Util.parseDigit(request.getParameter("etc_v_amt")));
	fee_rm.setT_fee_s_amt	(request.getParameter("t_fee_s_amt")==null?0:Util.parseDigit(request.getParameter("t_fee_s_amt")));
	fee_rm.setT_fee_v_amt	(request.getParameter("t_fee_v_amt")==null?0:Util.parseDigit(request.getParameter("t_fee_v_amt")));
	fee_rm.setCons1_s_amt	(request.getParameter("cons1_s_amt")==null?0:Util.parseDigit(request.getParameter("cons1_s_amt")));
	fee_rm.setCons1_v_amt	(request.getParameter("cons1_v_amt")==null?0:Util.parseDigit(request.getParameter("cons1_v_amt")));
	fee_rm.setCons2_s_amt	(request.getParameter("cons2_s_amt")==null?0:Util.parseDigit(request.getParameter("cons2_s_amt")));
	fee_rm.setCons2_v_amt	(request.getParameter("cons2_v_amt")==null?0:Util.parseDigit(request.getParameter("cons2_v_amt")));
	fee_rm.setF_rent_tot_amt(request.getParameter("f_rent_tot_amt")==null?0:Util.parseDigit(request.getParameter("f_rent_tot_amt")));
	fee_rm.setF_paid_way	(request.getParameter("f_paid_way")==null?"":request.getParameter("f_paid_way"));
	fee_rm.setF_paid_way2	(request.getParameter("f_paid_way2")==null?"":request.getParameter("f_paid_way2"));
	fee_rm.setReg_id	(user_id);
	fee_rm.setUpdate_id	(user_id);
	fee_rm.setNavi_yn	(request.getParameter("navi_yn")==null?"":request.getParameter("navi_yn"));
	fee_rm.setCons1_yn	(request.getParameter("cons1_yn")==null?"":request.getParameter("cons1_yn"));
	fee_rm.setCons2_yn	(request.getParameter("cons2_yn")==null?"":request.getParameter("cons2_yn"));
	fee_rm.setAmt_per	(request.getParameter("amt_per")==null?"":request.getParameter("amt_per"));
	fee_rm.setEtc_cont	(request.getParameter("etc_cont")==null?"":request.getParameter("etc_cont"));
	fee_rm.setF_con_amt	(request.getParameter("f_con_amt")==null?0:Util.parseDigit(request.getParameter("f_con_amt")));		
		
	if(!fee_rm.getCons1_yn().equals("Y") && fee_rm.getCons1_s_amt()>0)	fee_rm.setCons1_yn("Y");
	if(!fee_rm.getCons1_yn().equals("N") && fee_rm.getCons1_s_amt()==0)	fee_rm.setCons1_yn("N");
	if(!fee_rm.getCons2_yn().equals("Y") && fee_rm.getCons2_s_amt()>0)	fee_rm.setCons2_yn("Y");
	if(!fee_rm.getCons2_yn().equals("Y") && fee_rm.getCons2_s_amt()==0)	fee_rm.setCons2_yn("N");
		
		
	if(fee_rm.getRent_mng_id().equals("")){
	
		//최근 홈페이지 적용대여료
		Hashtable hp = oh_db.getSecondhandCaseRm("", "", base.getCar_mng_id());	
		 
		//견적정보
		String est_id = shDb.getSearchEstIdShRm(base.getCar_mng_id(), "21", "1", "", String.valueOf(hp.get("REAL_KM")), String.valueOf(hp.get("UPLOAD_DT")), String.valueOf(hp.get("RM1")), String.valueOf(hp.get("REG_CODE")));
				
		//견적정보
		EstimateBean e_bean = e_db.getEstimateShCase(est_id);
			
		//차종정보
		cm_bean = cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());

		//차종별변수
		String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());				
		EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);

		//단기요금표
		ShortFeeMngBean sf_bean = sfm_db.getShortFeeMngCase(ej_bean.getJg_r(), "2", e_bean.getRent_dt());
						
		fee_rm.setCars		(ej_bean.getJg_v());
		fee_rm.setAmt_01d	(sf_bean.getAmt_01d());
		fee_rm.setAmt_03d	(sf_bean.getAmt_03d());
		fee_rm.setAmt_05d	(sf_bean.getAmt_05d());
		fee_rm.setAmt_07d	(sf_bean.getAmt_07d());
		
		
		fee_rm.setRent_mng_id		(rent_mng_id);
		fee_rm.setRent_l_cd		(rent_l_cd);
		fee_rm.setRent_st		("1");
		//=====[fee_etc] insert=====
		flag6 = a_db.insertFeeRm(fee_rm);
	}else{
	
		if(!fee_rm.getEst_id().equals("") && fee_rm.getCars().equals("")){
		
			//견적정보
			EstimateBean e_bean = e_db.getEstimateShCase(fee_rm.getEst_id());
			
			//차종정보
			cm_bean = cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());

			//차종별변수
			String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());				
			EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);

			//단기요금표
			ShortFeeMngBean sf_bean = sfm_db.getShortFeeMngCase(ej_bean.getJg_r(), "2", e_bean.getRent_dt());
						
			fee_rm.setCars		(ej_bean.getJg_v());
			fee_rm.setAmt_01d	(sf_bean.getAmt_01d());
			fee_rm.setAmt_03d	(sf_bean.getAmt_03d());
			fee_rm.setAmt_05d	(sf_bean.getAmt_05d());
			fee_rm.setAmt_07d	(sf_bean.getAmt_07d());		
		
		}
		
		
		//=====[fee_etc] update=====
		flag6 = a_db.updateFeeRm(fee_rm);
	}	
	
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
		cms.setCms_start_dt	(request.getParameter("cms_start_dt")	==null?"":request.getParameter("cms_start_dt"));
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
	
	cont_etc.setRec_st		(request.getParameter("rec_st")		==null?"":request.getParameter("rec_st"));
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
		client.setPrint_car_st	(print_car_st);
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
	if(idx.equals("sanction")){
	
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		String sanction = request.getParameter("sanction")==null?""        :request.getParameter("sanction");
		
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		base.setUse_yn		("Y");
		//=====[cont] update=====
		flag1 = a_db.updateContBaseNew(base);
		
		//=====[cont] update=====
		flag2 = a_db.updateContSanction(rent_mng_id, rent_l_cd, "sanction_id", user_id, sanction);
		
		
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		
		String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		String sub 		= "장기계약 결재";
		String cont 		= "["+firm_nm+" "+rent_l_cd+"] 장기계약이 결재되었습니다.";
		String target_id = base.getSanction_req();
		String target_id2 = nm_db.getWorkAuthUser("연장/승계담당자");
		
		//계약승계 혹은 차종변경일때 원계약 해지내용
		Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
		
		if(target_id.equals("")){
			//대여료갯수조회(연장여부)
			int i_fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
			//마지막대여정보
			ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i_fee_size));
			if(String.valueOf(begin.get("CLS_ST")).equals("계약승계") || String.valueOf(begin.get("CLS_ST")).equals("차종변경") || !fee_size.equals("1")){
				//target_id = base.getBus_id2();
				target_id = max_fee.getExt_agnt();
			}else{
				if(i_fee_size == 1){
					target_id = base.getBus_id();
				}else{
					target_id = max_fee.getExt_agnt();
				}
			}
		}
		
		//사용자 정보 조회
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		UsersBean target_bean2 	= umd.getUsersBean(target_id2);
		
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
 					"    <URL></URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		if(String.valueOf(begin.get("CLS_ST")).equals("계약승계") || String.valueOf(begin.get("CLS_ST")).equals("차종변경") || !fee_size.equals("1")){
			xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
		}
				
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
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약결재 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
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
		String target_id 	= nm_db.getWorkAuthUser("본사총무팀장");
		String url 		= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;
		String m_url ="/fms2/lc_rent/lc_b_frame.jsp";
		CarSchDatabase csd = CarSchDatabase.getInstance();
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		//if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("본사영업팀장");
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
<%		if(!flag2){	%>	alert('계약결재요청 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>
<%	}%>


<%
	if(idx.equals("sanction_req_cancel")){//결재요청 취소하기
	
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		String sanction_req_cancel_cont = request.getParameter("sanction_req_cancel_cont")==null?""        :request.getParameter("sanction_req_cancel_cont");
		
		String sanction = "결재요청취소";
		
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		
		//=====[cont] update=====
		flag2 = a_db.updateContSanctionCancel(rent_mng_id, rent_l_cd, "sanction_req_cancel", user_id, sanction);
		
		
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		
		String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		String sub 		= "장기계약 결재요청취소";
		String cont 		= "["+firm_nm+" "+rent_l_cd+"] 장기계약의 결재요청이 취소되었습니다.  &lt;br&gt; &lt;br&gt;  취소사유 : "+sanction_req_cancel_cont;
		String url 		= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;
		String target_id = base.getBus_id();
		String m_url ="/fms2/lc_rent/lc_b_frame.jsp";
		if(now_stat.equals("계약승계") || now_stat.equals("차종변경")){
			//target_id = base.getBus_id2();
			ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, fee_size);
			target_id = fee.getExt_agnt();
		}
		
		if(now_stat.equals("연장")){
			ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, fee_size);
			target_id = fee.getExt_agnt();
		}
		
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
<%		if(!flag2){	%>	alert('계약결재요청취소 에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>
<%	}%>

<%
	if(idx.equals("sanction_cancel")){//결재 취소하기
	
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		String sanction = "결재취소";
		
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		//=====[cont] update=====
		flag2 = a_db.updateContSanctionCancel(rent_mng_id, rent_l_cd, "sanction_cancel", user_id, sanction);
		%>
<script language='javascript'>
<%		if(!flag2){	%>	alert('계약결재취소 에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>
<%	}%>

<%
	if(idx.equals("delete")){
	
		String del_chk = "Y";
		
		if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){
		 
			//전자계약 전송건은 삭제하지 못함			
			int alink_count2 = ln_db.getALinkCnt("rm_rent_link",   rent_l_cd);
			int alink_count3 = ln_db.getALinkCnt("rm_rent_link_m", rent_l_cd);
			if(alink_count2+alink_count3 > 0){
				del_chk = "N";
			}
			
		
			if(del_chk.equals("Y")){
				flag1 = a_db.deleteCont(rent_mng_id, rent_l_cd);
			}
		
			//보유차 살리기
			flag2 = a_db.rebirthUseCar(base.getCar_mng_id());
			
			//등록차량 상태값 초기화
			flag9 = a_db.updateCarStatCng(base.getCar_mng_id());
		
		}
		
		%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약 삭제 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>




<%
	if(idx.equals("make_suc_schedule")){
	
		
		String suc_tax_req 		= request.getParameter("suc_tax_req")==null?"N":request.getParameter("suc_tax_req");
		String suc_commi_est_dt	= request.getParameter("suc_commi_est_dt")==null?"":request.getParameter("suc_commi_est_dt");
		int    suc_commi_s_amt	= request.getParameter("suc_commi_s_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("suc_commi_s_amt"));
		int    suc_commi_v_amt	= request.getParameter("suc_commi_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("suc_commi_v_amt"));
		
		
		ExtScdBean suc = new ExtScdBean();
		suc.setRent_mng_id	(rent_mng_id);
		suc.setRent_l_cd	(rent_l_cd);
		suc.setRent_st		("1");
		suc.setRent_seq		("1");
		suc.setExt_id		("0");
		suc.setExt_st		("5");
		suc.setExt_tm		("1");
		suc.setExt_s_amt	(suc_commi_s_amt);
		suc.setExt_v_amt	(suc_commi_v_amt);
		suc.setExt_est_dt	(suc_commi_est_dt);
		if(suc_tax_req.equals("N")){
			suc.setExt_s_amt	(suc_commi_s_amt+suc_commi_v_amt);
			suc.setExt_v_amt	(0);
		}
		
		//원계약자 승계수수료 부담
		if(cont_etc.getRent_suc_commi_pay_st().equals("1")){
			suc.setRent_l_cd	(cont_etc.getRent_suc_l_cd());
		}
		suc.setUpdate_id	(user_id);
		
		flag1 = ae_db.insertGrt(suc);
		%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('승계수수료 스케줄 생성 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(idx.equals("scan_sys")){

		if(!base.getClient_id().equals("000228")){
			//고객별 최종스캔 동기화
			String  d_flag1 =  ad_db.call_sp_lc_rent_scanfile_syn(rent_mng_id, rent_l_cd, user_id);					
		}
	
	}
%>	

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
	
	fm.action = 'lc_rm_frame.jsp';	
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>