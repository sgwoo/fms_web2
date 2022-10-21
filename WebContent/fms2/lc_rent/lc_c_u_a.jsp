<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*, acar.car_mst.*, acar.insur.*, acar.car_office.*, acar.res_search.*, acar.client.*,  acar.ext.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_register.*, acar.im_email.*, tax.*, acar.car_mst.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
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
	
	String car_gu 		= request.getParameter("car_gu")==null?"":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	boolean flag12 = true;
	
	int flag = 0;
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();

	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(car_gu.equals("")){
		car_gu 	= base.getCar_gu();
	}
	if(car_st.equals("")){
		car_st 	= base.getCar_st();
	}
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);	
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));	
	
	//고객관리
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//commi
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	// 매매주문서 스캔 파일 등록 여부 조회
	String content_code = "LC_SCAN";
	String content_seq  = rent_mng_id+""+rent_l_cd;
	int attach_count = 0;
	attach_count = c_db.getAcarAttachFileCount(content_code, content_seq, 15);		
	
	//출고지연대차 리스트
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
%>


<%
	if(cng_item.equals("client")){
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		
		String o_p_addr = base.getP_addr();
		String o_lic = base.getLic_no();
		String o_m_lic = base.getMgr_lic_no()+""+base.getMgr_lic_emp()+""+base.getMgr_lic_rel();
		
		//고객,지점,우편물주소,우편물수취인
		base.setR_site			(request.getParameter("site_id")	==null?"":request.getParameter("site_id"));
		base.setP_zip			(request.getParameter("t_zip")		==null?"":request.getParameter("t_zip"));
		base.setP_addr			(request.getParameter("t_addr")		==null?"":request.getParameter("t_addr"));
		base.setTax_agnt		(request.getParameter("tax_agnt")	==null?"":request.getParameter("tax_agnt"));
		base.setLic_no			(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));	
		base.setMgr_lic_no	(request.getParameter("mgr_lic_no")==null?"":request.getParameter("mgr_lic_no"));	
		base.setMgr_lic_emp	(request.getParameter("mgr_lic_emp")==null?"":request.getParameter("mgr_lic_emp"));	
		base.setMgr_lic_rel	(request.getParameter("mgr_lic_rel")==null?"":request.getParameter("mgr_lic_rel"));	
		//=====[cont] update=====
		flag1 = a_db.updateContBaseNew(base);

		//차량이용지 주소 cnrk (2018.03.09)
		cont_etc.setCar_use_addr(request.getParameter("car_use_addr")==null?"":request.getParameter("car_use_addr"));
		//=====[cont_etc] update=====
		flag1 = a_db.updateContEtc(cont_etc);
		
		String n_p_addr = base.getP_addr();
		String n_lic = base.getLic_no();
		String n_m_lic = base.getMgr_lic_no()+""+base.getMgr_lic_emp()+""+base.getMgr_lic_rel();
		
		//우편물주소 변경이력 관리
		if(!o_p_addr.equals(n_p_addr)){
			LcRentCngHBean lrc_bean = new LcRentCngHBean();
			lrc_bean.setRent_mng_id	(rent_mng_id);
			lrc_bean.setRent_l_cd		(rent_l_cd);
			lrc_bean.setCng_item		("p_addr");
			lrc_bean.setOld_value		(o_p_addr);
			lrc_bean.setNew_value		(n_p_addr);
			lrc_bean.setCng_cau			("우편물주소 변경");
			lrc_bean.setCng_id			(ck_acar_id);
			lrc_bean.setRent_st			(Integer.toString(fee_size));
			flag1 = a_db.updateLcRentCngH(lrc_bean);
		}
		//변경이력 관리
		if(!o_lic.equals(n_lic)){
			LcRentCngHBean lrc_bean = new LcRentCngHBean();
			lrc_bean.setRent_mng_id	(rent_mng_id);
			lrc_bean.setRent_l_cd		(rent_l_cd);
			lrc_bean.setCng_item		("lic_no");
			lrc_bean.setOld_value		(o_lic);
			lrc_bean.setNew_value		(n_lic);
			lrc_bean.setCng_cau			("계약자/고객 운전면허번호 변경");
			lrc_bean.setCng_id			(ck_acar_id);
			lrc_bean.setRent_st			(Integer.toString(fee_size));
			flag1 = a_db.updateLcRentCngH(lrc_bean);
			
			//고객연동
			client.setLic_no		(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));
			flag2 = al_db.updateNewClient2(client);
		}
		//변경이력 관리
		if(!o_m_lic.equals(n_m_lic)){
			LcRentCngHBean lrc_bean = new LcRentCngHBean();
			lrc_bean.setRent_mng_id	(rent_mng_id);
			lrc_bean.setRent_l_cd		(rent_l_cd);
			lrc_bean.setCng_item		("mgr_lic_no");
			lrc_bean.setOld_value		(o_m_lic);
			lrc_bean.setNew_value		(n_m_lic);
			lrc_bean.setCng_cau			("차량이용자 운전면허번호 변경");
			lrc_bean.setCng_id			(ck_acar_id);
			lrc_bean.setRent_st			(Integer.toString(fee_size));
			flag1 = a_db.updateLcRentCngH(lrc_bean);
		}
		
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
		}
		
		CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "추가운전자");
		mgr.setLic_no		(request.getParameter("mgr_lic_no5")	==null?"":request.getParameter("mgr_lic_no5"));
		mgr.setEtc			(request.getParameter("mgr_lic_rel5")	==null?"":request.getParameter("mgr_lic_rel5"));
		if(!mgr.getRent_l_cd().equals("")){
			//=====[CAR_MGR] update=====
			flag1 = a_db.updateCarMgrNew(mgr);
		}
		
		
		
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(cng_item.equals("mgr")){
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
					mgr.setMgr_zip		(request.getParameter("t_zip")		==null?"":request.getParameter("t_zip"));
					mgr.setMgr_addr		(request.getParameter("t_addr")		==null?"":request.getParameter("t_addr"));
				}
			}
			mgr.setMgr_tel		(mgr_tel[i]);
			mgr.setMgr_m_tel	(mgr_m_tel[i]);
			
			
			
			if(!mgr_st[i].equals("")){
				if(!mgr.getRent_l_cd().equals("")){
					//=====[CAR_MGR] update=====
					flag1 = a_db.updateCarMgrNew(mgr);
				}else{
					mgr.setRent_mng_id	(rent_mng_id);
					mgr.setRent_l_cd	(rent_l_cd);
					mgr.setMgr_id		(mgr_id[i]);
					mgr.setMgr_st		(mgr_st[i]);
					
					//=====[CAR_MGR] update=====
					flag1 = a_db.insertCarMgr(mgr);
				}
			}
		}%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('관계자정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(cng_item.equals("client_guar")){
		//계약기타정보-----------------------------------------------------------------------------------------------
		
		
		//연대보증여부,면제조건,결재자
		cont_etc.setClient_guar_st	(request.getParameter("client_guar_st")==null?"":request.getParameter("client_guar_st"));
		cont_etc.setGuar_con		(request.getParameter("guar_con")==null?"":request.getParameter("guar_con"));
		cont_etc.setGuar_sac_id		(request.getParameter("guar_sac_id")==null?"":request.getParameter("guar_sac_id"));
		
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] insert=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag1 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag1 = a_db.updateContEtc(cont_etc);
		}
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('대표이사보증 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(cng_item.equals("guar")){
		//계약기타정보-----------------------------------------------------------------------------------------------
		
		//연대보증여부,면제조건,결재자
		cont_etc.setGuar_st			(request.getParameter("guar_st")==null?"":request.getParameter("guar_st"));
		cont_etc.setGuar_con		(request.getParameter("guar_con")==null?"":request.getParameter("guar_con"));
		cont_etc.setGuar_sac_id		(request.getParameter("guar_sac_id")==null?"":request.getParameter("guar_sac_id"));
		
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
		String t_zip[] 		= request.getParameterValues("t_zip");
		String t_addr[] 	= request.getParameterValues("t_addr");

		int gur_size = gur_nm.length;
		
		for(int i = 0 ; i < gur_size ; i++){
		
			if(!gur_nm[i].equals("") && cont_etc.getGuar_st().equals("1")){
				ContGurBean gur = a_db.getContGur(rent_mng_id, rent_l_cd, gur_id[i]);
				//성명,주민등록번호,주소,연락처,관계
				gur.setGur_nm		(gur_nm[i]);
				gur.setGur_ssn		(gur_ssn[i]);
				gur.setGur_zip		(t_zip[i]);
				gur.setGur_addr		(t_addr[i]);
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
<%		if(!flag2){	%>	alert('관계자정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>


<%
	if(cng_item.equals("dec")){
		//약식재무제표||고객테이블-----------------------------------------------------------------------------------------------
		
		
		String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
		String client_st 	= request.getParameter("client_st")==null?"":request.getParameter("client_st");
		String fin_seq 		= request.getParameter("fin_seq")==null?"":request.getParameter("fin_seq");
		String seq 			= cont_etc.getFin_seq();
		
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
			
			client.setCom_nm	(request.getParameter("com_nm")==null?"":request.getParameter("com_nm"));
			client.setJob		(request.getParameter("job")==null?"":request.getParameter("job"));
			client.setPay_st	(request.getParameter("pay_st")==null?"":request.getParameter("pay_st"));
			client.setPay_type	(request.getParameter("pay_type")==null?"":request.getParameter("pay_type"));
			client.setWk_year	(request.getParameter("wk_year")==null?"":request.getParameter("wk_year"));
			flag3 = al_db.updateNewClient2(client);			              
		}
	
	
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
		String t_zip[] 		= request.getParameterValues("t_zip");
		String t_addr[] 	= request.getParameterValues("t_addr");
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
			eval.setAss1_type	(ass1_type[i]);
			eval.setAss2_type	(ass2_type[i]);
			eval.setAss1_addr	(t_addr[0+(2*i)]);
			eval.setAss1_zip	(t_zip [0+(2*i)]);
			eval.setAss2_addr	(t_addr[1+(2*i)]);
			eval.setAss2_zip	(t_zip [1+(2*i)]);
			eval.setEval_b_dt	(eval_b_dt[i]);
			eval.setEval_score	(eval_score[i]);
			
			if(!eval.getRent_l_cd().equals("")){
				//=====[CONT_EVAL] update=====
				flag4 = a_db.updateContEval(eval);
			}else{
				eval.setRent_mng_id	(rent_mng_id);
				eval.setRent_l_cd	(rent_l_cd);
				eval.setE_seq		(a_db.getNextEvalSeq(rent_mng_id, rent_l_cd));
				//=====[CONT_EVAL] insert=====
				flag4 = a_db.insertContEval(eval);
			}
		}
		
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
			flag5 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag5 = a_db.updateContEtc(cont_etc);
		}
		
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		base.setSpr_kd		(request.getParameter("dec_gr")==null?"":request.getParameter("dec_gr"));
		
		//=====[cont] update=====
		flag6 = a_db.updateContBase(base);
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('약식재무제표 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag3){	%>	alert('고객테이블 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag4){	%>	alert('연대보증인정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag5){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag6){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>
<%	}%>


<%
	if(cng_item.equals("car")){
	
	
	
	//차량기본정보-----------------------------------------------------------------------------------------------
	boolean chg_van_add_opt_yn = false;
	if(!car.getVan_add_opt().equals(String.valueOf(request.getParameter("van_add_opt")))){
		chg_van_add_opt_yn = true;
	}
	
// 	car.setColo		(request.getParameter("color")			==null?"":request.getParameter("color"));
	car.setSun_per		(request.getParameter("sun_per")		==null? 0:AddUtil.parseDigit(request.getParameter("sun_per")));
	car.setLpg_yn		(request.getParameter("lpg_yn")			==null?"":request.getParameter("lpg_yn"));
	car.setLpg_setter	(request.getParameter("lpg_setter")		==null?"":request.getParameter("lpg_setter"));
	car.setLpg_kit		(request.getParameter("lpg_kit")		==null?"":request.getParameter("lpg_kit"));
	car.setLpg_price	(request.getParameter("lpg_price")		==null? 0:AddUtil.parseDigit(request.getParameter("lpg_price")));
	car.setAdd_opt		(request.getParameter("add_opt")		==null?"":request.getParameter("add_opt"));
	car.setAdd_opt_amt	(request.getParameter("add_opt_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("add_opt_amt")));
	car.setRemark		(request.getParameter("remark")			==null?"":request.getParameter("remark"));
	car.setExtra_set	(request.getParameter("extra_set")		==null?"":request.getParameter("extra_set"));
	car.setExtra_amt	(request.getParameter("extra_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("extra_amt")));
// 	car.setIn_col		(request.getParameter("in_col")			==null?"":request.getParameter("in_col"));
// 	car.setGarnish_col	(request.getParameter("garnish_col")			==null?"":request.getParameter("garnish_col"));
	car.setHipass_yn	(request.getParameter("hipass_yn")		==null?"":request.getParameter("hipass_yn"));
	car.setBluelink_yn	(request.getParameter("bluelink_yn")		==null?"":request.getParameter("bluelink_yn"));
	car.setTint_b_yn	(request.getParameter("tint_b_yn")		==null?"":request.getParameter("tint_b_yn"));
	car.setTint_s_yn	(request.getParameter("tint_s_yn")		==null?"":request.getParameter("tint_s_yn"));
	car.setTint_ps_yn		(request.getParameter("tint_ps_yn")		==null?"":request.getParameter("tint_ps_yn"));	// 고급썬팅 유무	2017.12.26
	car.setTint_ps_nm		(request.getParameter("tint_ps_nm")	==null?"":request.getParameter("tint_ps_nm"));	// 고급썬팅 내용
	car.setTint_ps_amt	(request.getParameter("tint_ps_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tint_ps_amt")));	// 고급썬팅 금액
	car.setTint_n_yn		(request.getParameter("tint_n_yn")		==null?"":request.getParameter("tint_n_yn"));
	car.setTint_bn_yn		(request.getParameter("tint_bn_yn")		==null?"":request.getParameter("tint_bn_yn"));
	car.setTint_bn_nm	(request.getParameter("tint_bn_nm")		==null?"":request.getParameter("tint_bn_nm"));
	car.setTint_sn_yn		(request.getParameter("tint_sn_yn")		==null?"":request.getParameter("tint_sn_yn")); // 전면썬팅 미시공 할인
	car.setNew_license_plate		(request.getParameter("new_license_plate")		==null?"0":request.getParameter("new_license_plate"));		// 신형번호판 신청 여부 디폴트 0(구형번호판)
	car.setTint_cons_yn		(request.getParameter("tint_cons_yn")		==null?"":request.getParameter("tint_cons_yn"));
	car.setTint_cons_amt	(request.getParameter("tint_cons_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tint_cons_amt")));
	car.setTint_eb_yn		(request.getParameter("tint_eb_yn")		==null?"":request.getParameter("tint_eb_yn"));
	car.setServ_b_yn		(request.getParameter("serv_b_yn")		==null?"":request.getParameter("serv_b_yn"));
	car.setServ_sc_yn		(request.getParameter("serv_sc_yn")		==null?"":request.getParameter("serv_sc_yn"));
// 	car.setEco_e_tag		(request.getParameter("eco_e_tag")		==null?"":request.getParameter("eco_e_tag"));
	car.setVan_add_opt	(request.getParameter("van_add_opt")		==null?"":request.getParameter("van_add_opt"));
// 	if(!(request.getParameter("car_ext") == null || request.getParameter("car_ext") == "")){
// 		car.setCar_ext	(request.getParameter("car_ext"));	
// 	}// lc_c_u.jsp파일에서 car_mng_id가 없는 경우만 등록지역 수정 가능 2017.11.02
		
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	
	// 번호판 구분 변경 시 번호판관리담당자(류길선 과장님), 주차장출납(조선희 사원님) 메신저 발송
	String prev_new_license_plate = request.getParameter("prev_new_license_plate")	==	null ? "0" : request.getParameter("prev_new_license_plate");
	String new_license_plate = request.getParameter("new_license_plate")					==	null ? "0" : request.getParameter("new_license_plate");
	
	if(!prev_new_license_plate.equals(new_license_plate) && attach_count > 0){	 // 번호판 구분이 변경 및 매매주문서 스캔 파일이 등록된 경우에만 발송. 20210331
		String msg_subject 		= "번호판 구분 변경";
		String target_id1 = "000096";	// 번호판 관리 담당자(류길선 과장님)
		//String target_id2 = "000298";	// 주차장 출납(조선희 사원님)
		//주차장출납 출산휴가로 번호판관리담당자 연차시 업무대체자로
		CarSchDatabase csd = CarSchDatabase.getInstance();
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id1);
		if(!cs_bean.getUser_id().equals(""))	target_id1 = cs_bean.getWork_id();
		//사용자 정보 조회
		UsersBean target_bean1 	= umd.getUsersBean(target_id1);
		//UsersBean target_bean2 	= umd.getUsersBean(target_id2);
		UsersBean sender_bean	= umd.getUsersBean(user_id);
		
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
	
	
	//출고정보-------------------------------------------------------------------------------------------
	
	
// 	String o_udt_st = pur.getUdt_st();
	
// 	pur.setUdt_st				(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));
// 	pur.setCons_amt1		(request.getParameter("cons_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt1")));
// 	pur.setEcar_loc_st	(request.getParameter("ecar_loc_st")		==null?"":request.getParameter("ecar_loc_st"));
// 	pur.setHcar_loc_st	(request.getParameter("hcar_loc_st")		==null?"":request.getParameter("hcar_loc_st"));
	
	flag4 = a_db.updateContPur(pur);
	
// 	String n_udt_st = pur.getUdt_st();
	
	//차량인수지 변경시 차종관리자에게 메시지 발송
// 	if(!o_udt_st.equals("") && !o_udt_st.equals(n_udt_st)){
// 		if(base.getUse_yn().equals("Y") && fee_size == 1 && cont_etc.getRent_suc_dt().equals("")){
			
// 			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
// 			String sub 		= "장기계약 차량인수지 변동";
// 			String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ] 장기계약의 차량인수지가 변동하였습니다. 확인바랍니다.";
// 			String target_id = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
			
// 			CarSchDatabase csd = CarSchDatabase.getInstance();
// 			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
// 			if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("엑셀견적관리자");
			
// 			//사용자 정보 조회
// 			UsersBean target_bean 	= umd.getUsersBean(target_id);
// 			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
// 			String xml_data = "";
// 			xml_data =  "<COOLMSG>"+
// 		  				"<ALERTMSG>"+
//   						"    <BACKIMG>4</BACKIMG>"+
//   						"    <MSGTYPE>104</MSGTYPE>"+
//   						"    <SUB>"+sub+"</SUB>"+
// 		  				"    <CONT>"+cont+"</CONT>"+
//  						"    <URL></URL>";
// 			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
// 			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
//   						"    <MSGICON>10</MSGICON>"+
//   						"    <MSGSAVE>1</MSGSAVE>"+
//   						"    <LEAVEDMSG>1</LEAVEDMSG>"+
// 		  				"    <FLDTYPE>1</FLDTYPE>"+
//   						"  </ALERTMSG>"+
//   						"</COOLMSG>";
			
// 			CdAlertBean msg = new CdAlertBean();
// 			msg.setFlddata(xml_data);
// 			msg.setFldtype("1");
			
// 			flag3 = cm_db.insertCoolMsg(msg);			
			
// 		}
// 	}
	
	//화물차이고 출고후추가장착 옵션 변경이 있으면 보험담당자에게 메세지
	if(chg_van_add_opt_yn==true){
		
		String sub2 		= "출고후추가장착 변경";
		String target_id2 = "000130";	//고영은
		String target_id3 = "000048";	//최치권 //000277 2명에게 메세지 발송되게 요청
		//사용자 정보 조회
		UsersBean target_bean2 	= umd.getUsersBean(target_id2);
		UsersBean target_bean3 	= umd.getUsersBean(target_id3);
		UsersBean sender_bean	= umd.getUsersBean(user_id);
		
		String cont2 	= "[ "+rent_l_cd+" "+firm_nm+" "+cr_bean.getCar_no()+" ]  &lt;br&gt; &lt;br&gt; 장기계약의 출고후 추가장착(화물차전용)을 ";
		if(car.getVan_add_opt().equals("")){				cont2 += "없음"; 			 		}
		else if(car.getVan_add_opt().equals("1")){		cont2 += "내장탑/윙바디 등";  		}
		else if(car.getVan_add_opt().equals("2")){		cont2 += "활어수족관";  			}
		else if(car.getVan_add_opt().equals("3")){		cont2 += "기증기/크레인";  		}
		cont2 += " 으로 등록(혹은 수정)하였습니다.  &lt;br&gt; &lt;br&gt; 확인바랍니다.  &lt;br&gt; &lt;br&gt; 등록(수정)자:"+sender_bean.getUser_nm();
		
		String xml_data2 = "";
		xml_data2 =  "<COOLMSG>"+
	  						 "<ALERTMSG>"+
							 "    <BACKIMG>4</BACKIMG>"+
							 "    <MSGTYPE>104</MSGTYPE>"+
							 "    <SUB>"+sub2+"</SUB>"+
	  						 "    <CONT>"+cont2+"</CONT>"+
							 "    <URL></URL>";
		xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET><TARGET>"+target_bean3.getId()+"</TARGET>";
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
		
		//20200219 출고후 추가장착(화물차전용)을 없음은 안보내도록 보험담당자 요청
		if(car.getVan_add_opt().equals("")){
				
		}else{
			flag3 = cm_db.insertCoolMsg(msg2);			
		}	
		
	}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag4){	%>	alert('출고정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("car_amt")){
	
	//차량기본정보-----------------------------------------------------------------------------------------------
	
	
	int o_car_amt = car.getCar_fs_amt()+car.getCar_fv_amt()+car.getDc_cs_amt()+car.getDc_cv_amt();
	
	car.setPurc_gu		(request.getParameter("purc_gu")		==null?"":request.getParameter("purc_gu"));
	car.setCar_origin	(request.getParameter("car_origin")		==null?"":request.getParameter("car_origin"));
	if(!car_gu.equals("0")){
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
		car.setS_dc1_re_etc	(request.getParameter("s_dc1_re_etc")==null?"":request.getParameter("s_dc1_re_etc"));
		car.setS_dc2_re_etc	(request.getParameter("s_dc2_re_etc")==null?"":request.getParameter("s_dc2_re_etc"));
		car.setS_dc3_re_etc	(request.getParameter("s_dc3_re_etc")==null?"":request.getParameter("s_dc3_re_etc"));
		car.setS_dc1_per	(request.getParameter("s_dc1_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc1_per")));
		car.setS_dc2_per	(request.getParameter("s_dc2_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc2_per")));
		car.setS_dc3_per	(request.getParameter("s_dc3_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc3_per")));

		car.setImport_card_amt		(request.getParameter("import_card_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("import_card_amt")));
		car.setImport_cash_back		(request.getParameter("import_cash_back")	==null? 0:AddUtil.parseDigit(request.getParameter("import_cash_back")));
		car.setImport_bank_amt		(request.getParameter("import_bank_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("import_bank_amt")));
		car.setR_import_cash_back	(request.getParameter("r_import_cash_back")	==null? 0:AddUtil.parseDigit(request.getParameter("r_import_cash_back")));
		car.setR_import_bank_amt	(request.getParameter("r_import_bank_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("r_import_bank_amt")));
		car.setTax_dc_s_amt				(request.getParameter("tax_dc_s_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tax_dc_s_amt")));
		car.setTax_dc_v_amt				(request.getParameter("tax_dc_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tax_dc_v_amt")));
				
	}else if(!car_gu.equals("1")){
	
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		fee_etc.setSh_car_amt		(request.getParameter("sh_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
		fee_etc.setSh_year		(request.getParameter("sh_year")	==null?"":request.getParameter("sh_year"));
		fee_etc.setSh_month		(request.getParameter("sh_month")	==null?"":request.getParameter("sh_month"));
		fee_etc.setSh_day		(request.getParameter("sh_day")		==null?"":request.getParameter("sh_day"));
		fee_etc.setSh_day_bas_dt	(request.getParameter("sh_day_bas_dt")==null?"":request.getParameter("sh_day_bas_dt"));
		fee_etc.setSh_amt		(request.getParameter("sh_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
		fee_etc.setSh_ja		(request.getParameter("sh_ja")		==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
		fee_etc.setSh_km		(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
		fee_etc.setSh_km_bas_dt		(request.getParameter("sh_km_bas_dt")==null?"":request.getParameter("sh_km_bas_dt"));
		fee_etc.setSh_init_reg_dt	(request.getParameter("sh_init_reg_dt")==null?"":request.getParameter("sh_init_reg_dt"));
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
	
		car.setSh_car_amt	(request.getParameter("sh_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
		car.setSh_year		(request.getParameter("sh_year")	==null?"":request.getParameter("sh_year"));
		car.setSh_month		(request.getParameter("sh_month")	==null?"":request.getParameter("sh_month"));
		car.setSh_day		(request.getParameter("sh_day")		==null?"":request.getParameter("sh_day"));
		car.setSh_day_bas_dt	(request.getParameter("sh_day_bas_dt")==null?"":request.getParameter("sh_day_bas_dt"));
		car.setSh_amt		(request.getParameter("sh_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
		car.setSh_ja		(request.getParameter("sh_ja")		==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
		car.setSh_km		(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
		car.setSh_km_bas_dt	(request.getParameter("sh_km_bas_dt")==null?"":request.getParameter("sh_km_bas_dt"));
	}

	
	
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	int n_car_amt = car.getCar_fs_amt()+car.getCar_fv_amt()+car.getDc_cs_amt()+car.getDc_cv_amt();
	
	
	if(!pur.getDlv_brch().equals("B2B사업운영팀") && !pur.getDlv_brch().equals("특판팀") && !pur.getDlv_brch().equals("법인판촉팀") && !pur.getDlv_brch().equals("법인판매팀") && (o_car_amt < n_car_amt || o_car_amt > n_car_amt)){
		//금액변동이 있었음->영업팀장에게 메시지 전달
		if(base.getUse_yn().equals("Y") && fee_size == 1 && cont_etc.getRent_suc_dt().equals("")){
			
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String sub 		= "장기계약 차가변동";
			String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ] 장기계약의 차량금액이 변동하였습니다. 확인바랍니다.";
			String target_id = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
			
			CarSchDatabase csd = CarSchDatabase.getInstance();
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
 						"    <URL></URL>";
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
	
	//제조사 할인후 차량가격 표기
	if(base.getCar_gu().equals("1") && fee_size<=1){
		cont_etc.setView_car_dc	(request.getParameter("view_car_dc")	==null? 0:AddUtil.parseDigit(request.getParameter("view_car_dc")));
		flag2 = a_db.updateContEtc(cont_etc);
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("insur")){
	
	//계약기본정보-----------------------------------------------------------------------------------------------
	
	base.setDriving_age	(request.getParameter("driving_age")	==null?"":request.getParameter("driving_age"));
	base.setDriving_ext	(request.getParameter("driving_ext")	==null?"":request.getParameter("driving_ext"));
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
	
	//수정제한
	if(!cont_etc.getInsurant().equals("") && nm_db.getWorkAuthUser("전산팀",ck_acar_id)){
		cont_etc.setInsurant	(request.getParameter("insurant")	==null?"":request.getParameter("insurant"));
	}else if(cont_etc.getInsurant().equals("")){
		cont_etc.setInsurant	(request.getParameter("insurant")	==null?"":request.getParameter("insurant"));
	}
	cont_etc.setCanoisr_yn	(request.getParameter("canoisr_yn")	==null?"":request.getParameter("canoisr_yn"));
	cont_etc.setCacdt_yn	(request.getParameter("cacdt_yn")	==null?"":request.getParameter("cacdt_yn"));
	cont_etc.setEme_yn		(request.getParameter("eme_yn")		==null?"":request.getParameter("eme_yn"));
	cont_etc.setJa_reason	(request.getParameter("ja_reason")	==null?"":request.getParameter("ja_reason"));
	cont_etc.setRea_appr_id	(request.getParameter("rea_appr_id")==null?"":request.getParameter("rea_appr_id"));
	cont_etc.setAir_ds_yn	(request.getParameter("air_ds_yn")	==null?"":request.getParameter("air_ds_yn"));
	cont_etc.setAir_as_yn	(request.getParameter("air_as_yn")	==null?"":request.getParameter("air_as_yn"));
	cont_etc.setAc_dae_yn	(request.getParameter("ac_dae_yn")	==null?"":request.getParameter("ac_dae_yn"));
	cont_etc.setPro_yn		(request.getParameter("pro_yn")		==null?"":request.getParameter("pro_yn"));
	cont_etc.setCyc_yn		(request.getParameter("cyc_yn")		==null?"":request.getParameter("cyc_yn"));
	cont_etc.setMain_yn		(request.getParameter("main_yn")	==null?"":request.getParameter("main_yn"));
	cont_etc.setMa_dae_yn	(request.getParameter("ma_dae_yn")	==null?"":request.getParameter("ma_dae_yn"));
	if(cont_etc.getInsur_per().equals("2")){
		cont_etc.setIp_insur(request.getParameter("ip_insur")	==null?"":request.getParameter("ip_insur"));
		cont_etc.setIp_agent(request.getParameter("ip_agent")	==null?"":request.getParameter("ip_agent"));
		cont_etc.setIp_dam	(request.getParameter("ip_dam")		==null?"":request.getParameter("ip_dam"));
		cont_etc.setIp_tel	(request.getParameter("ip_tel")		==null?"":request.getParameter("ip_tel"));
		cont_etc.setCacdt_me_amt	(request.getParameter("cacdt_me_amt")		==null?0:AddUtil.parseDigit(request.getParameter("cacdt_me_amt")));
		cont_etc.setCacdt_memin_amt	(request.getParameter("cacdt_memin_amt")	==null?0:AddUtil.parseDigit(request.getParameter("cacdt_memin_amt")));
		cont_etc.setCacdt_mebase_amt(request.getParameter("cacdt_mebase_amt")	==null?0:AddUtil.parseDigit(request.getParameter("cacdt_mebase_amt")));
	}else if(cont_etc.getInsur_per().equals("1")){
		cont_etc.setIp_insur("");
		cont_etc.setIp_agent("");
		cont_etc.setIp_dam	("");
		cont_etc.setIp_tel	("");
	}
	cont_etc.setBlackbox_yn	(request.getParameter("blackbox_yn") ==null?"":request.getParameter("blackbox_yn"));	
	cont_etc.setLegal_yn	(request.getParameter("legal_yn") ==null?"":request.getParameter("legal_yn"));
	cont_etc.setLkas_yn	(request.getParameter("lkas_yn") ==null?"":request.getParameter("lkas_yn"));		// 첨단안전장치 차선이탈 제어형		2018.02.02
	cont_etc.setLdws_yn	(request.getParameter("ldws_yn") ==null?"":request.getParameter("ldws_yn"));	// 첨단안전장치 차선이탈 경고형
	cont_etc.setAeb_yn	(request.getParameter("aeb_yn")	==null?"":request.getParameter("aeb_yn"));		// 첨단안전장치 긴급제동 제어형
	cont_etc.setFcw_yn	(request.getParameter("fcw_yn")	==null?"":request.getParameter("fcw_yn"));		// 첨단안전장치 긴급제동 경고형
	cont_etc.setEv_yn	(request.getParameter("ev_yn")	==null?"":request.getParameter("ev_yn"));			// 전기차
	cont_etc.setHook_yn	(request.getParameter("hook_yn")	==null?"":request.getParameter("hook_yn"));			// 견인고리
	cont_etc.setLegal_yn	(request.getParameter("legal_yn")	==null?"":request.getParameter("legal_yn"));			// 법률비용지원금
	cont_etc.setOthers_device(request.getParameter("others_device")	==null?"":request.getParameter("others_device"));

	cont_etc.setTop_cng_yn	(request.getParameter("top_cng_yn")	==null?"":request.getParameter("top_cng_yn"));			// 탑차(구조변경)
	
	if( cont_etc.getBlackbox_yn().equals("") && ( car.getTint_b_yn().equals("Y") || car.getServ_b_yn().equals("Y") ) )	cont_etc.setBlackbox_yn("Y");	
	
	String o_com_emp_yn = cont_etc.getCom_emp_yn();
	
	cont_etc.setCom_emp_yn	(request.getParameter("com_emp_yn")	==null?"":request.getParameter("com_emp_yn"));
	
	String n_com_emp_yn = cont_etc.getCom_emp_yn();
	
	if(cont_etc.getRent_mng_id().equals("")){
		//=====[cont_etc] update=====
		cont_etc.setRent_mng_id	(rent_mng_id);
		cont_etc.setRent_l_cd	(rent_l_cd);
		flag3 = a_db.insertContEtc(cont_etc);
	}else{
		//=====[cont_etc] update=====
		flag3 = a_db.updateContEtc(cont_etc);
	}
	
	if(base.getCar_st().equals("4")){
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
	}else{
	
	
		//임직원전용보험가입여부 변경시 보험관리자에게 메시지 발송
		if(!o_com_emp_yn.equals("") && !o_com_emp_yn.equals(n_com_emp_yn)){
		
			//재리스등록이거나 업무대여일때.. 법인 임직원 한전운전 관련 보험담당자 메시지 발송		
			if(base.getCar_gu().equals("0") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409 && (client.getClient_st().equals("1") || base.getCar_st().equals("5"))){
	
							
			
				//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			
				String sub 		= "임직원전용보험가입여부 변경통보";
				String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ] 임직원 ";
				String target_id 	= nm_db.getWorkAuthUser("부산보험담당");
			
				cont = cont + ec_db.getContCngInsCngMsg(rent_mng_id, rent_l_cd, String.valueOf(fee_size));
				
				//보험변경요청 프로시저 호출
				String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, rent_l_cd, String.valueOf(fee_size));
									
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
 						"    <URL></URL>";
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
		}
		
	}
	
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("gi")){
	
	//차량기본정보-----------------------------------------------------------------------------------------------
	
	car.setGi_st		(request.getParameter("gi_st")			==null?"":request.getParameter("gi_st"));
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	//이행보증보험-----------------------------------------------------------------------------------------------
	
	String gi_rent_st = request.getParameter("gi_rent_st")==null?"":request.getParameter("gi_rent_st"); 
	
	//gua_ins
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, gi_rent_st);
	
	gins.setGi_st		(request.getParameter("gi_st")			==null?"":request.getParameter("gi_st"));
	
	if(!car_st.equals("2")){
		if(gins.getGi_no().equals("")){
			gins.setGi_no("0");
		}else{
			gins.setGi_no(request.getParameter("gi_no")==null?"":request.getParameter("gi_no"));
		}
		if(gins.getGi_st().equals("0")){
			gins.setGi_reason	(request.getParameter("gi_reason")==null?"":request.getParameter("gi_reason"));
			gins.setGi_sac_id	(request.getParameter("gi_sac_id")==null?"":request.getParameter("gi_sac_id"));
			gins.setGi_jijum("");
			gins.setGi_amt(0);
			gins.setGi_fee(0);
			gins.setGi_start_dt("");
			gins.setGi_end_dt("");
			gins.setGi_dt("");
		}else if(gins.getGi_st().equals("1")){
			gins.setGi_reason("");
			gins.setGi_sac_id("");
			gins.setGi_jijum	(request.getParameter("gi_jijum")==null?"":request.getParameter("gi_jijum"));
			gins.setGi_amt		(request.getParameter("gi_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_amt")));
			gins.setGi_fee		(request.getParameter("gi_fee")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_fee")));
			gins.setGi_start_dt	(request.getParameter("gi_start_dt")==null?"":request.getParameter("gi_start_dt"));
			gins.setGi_end_dt	(request.getParameter("gi_end_dt")==null?"":request.getParameter("gi_end_dt"));
		}
		
		if(gins.getRent_mng_id().equals("")){
			//=====[gua_ins] insert=====
			gins.setRent_mng_id	(rent_mng_id);
			gins.setRent_l_cd	(rent_l_cd);
			gins.setRent_st		(gi_rent_st);
			flag2 = a_db.insertGiInsNew(gins);
		}else{
			//=====[gua_ins] update=====
			flag2 = a_db.updateGiInsNew(gins);
		}
	}

	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('이행보증보험 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("pay_way")){
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	if(!car_st.equals("2")){
		
		fee.setFee_sh			(request.getParameter("fee_sh")			==null?"":request.getParameter("fee_sh"));
		fee.setFee_pay_st		(request.getParameter("fee_pay_st")		==null?"":request.getParameter("fee_pay_st"));
		fee.setFee_bank			(request.getParameter("fee_bank")		==null?"":request.getParameter("fee_bank"));
		fee.setDef_st			(request.getParameter("def_st")			==null?"":request.getParameter("def_st"));
		fee.setDef_remark		(request.getParameter("def_remark")		==null?"":request.getParameter("def_remark"));
		fee.setDef_sac_id		(request.getParameter("def_sac_id")		==null?"":request.getParameter("def_sac_id"));
		fee.setFee_cdt			(request.getParameter("fee_cdt")		==null?"":request.getParameter("fee_cdt"));
		
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);
		
		//자동이체-------------------------------------------------------------------------------------------
		
		//cms_mng
		ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
		
		if(!base.getCar_st().equals("4") && cms.getApp_dt().equals("")){
		
			cms.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
			cms.setCms_bank		(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
			cms.setCms_dep_nm	(request.getParameter("cms_dep_nm")	==null?"":request.getParameter("cms_dep_nm"));
			cms.setCms_day		(request.getParameter("cms_day")	==null?"":request.getParameter("cms_day"));
			
			cms.setCms_tel		(request.getParameter("cms_tel")==null?"":request.getParameter("cms_tel"));
			cms.setCms_m_tel	(request.getParameter("cms_m_tel")==null?"":request.getParameter("cms_m_tel"));
			cms.setCms_email	(request.getParameter("cms_email")==null?"":request.getParameter("cms_email"));
			cms.setCms_dep_ssn	(request.getParameter("cms_dep_ssn")==null?"":request.getParameter("cms_dep_ssn"));
			
			cms.setCms_dep_post	(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
			cms.setCms_dep_addr	(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
			
			cms.setBank_cd		(request.getParameter("cms_bank_cd")	==null?"":request.getParameter("cms_bank_cd"));
			
			if(!cms.getBank_cd().equals("")){
				cms.setCms_bank		(c_db.getNameById(cms.getBank_cd(), "BANK"));
			}
			
			
		
			if(!cms.getCms_acc_no().equals("")){
			
				if(cms.getSeq().equals("")){
					cms.setRent_mng_id	(rent_mng_id);
					cms.setRent_l_cd	(rent_l_cd);
					cms.setReg_st		("1");
					cms.setCms_st		("1");
					cms.setReg_id		(user_id);
					//=====[cms_mng] insert=====
					flag2 = a_db.insertContCmsMng(cms);
				}else{
					cms.setUpdate_id	(user_id);
					//=====[cms_mng] update=====
					flag2 = a_db.updateContCmsMng(cms);
				}
			}
		}
		
		//신용카드 자동출금
		ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
		
		if(fee.getFee_pay_st().equals("6") && base.getRent_l_cd().equals("G120HNGR00164")){
		
			card_cms.setCms_acc_no		(request.getParameter("c_cms_acc_no")	==null?"":request.getParameter("c_cms_acc_no"));
			card_cms.setCms_bank		(request.getParameter("c_cms_bank")	==null?"":request.getParameter("c_cms_bank"));
			
			if(!card_cms.getCms_acc_no().equals("") || !card_cms.getCms_bank().equals("")){
				card_cms.setCms_acc_no	(request.getParameter("c_cms_acc_no")	==null?"":request.getParameter("c_cms_acc_no"));
				
				card_cms.setCms_dep_nm	(request.getParameter("c_cms_dep_nm")	==null?"":request.getParameter("c_cms_dep_nm"));
				card_cms.setCms_dep_ssn	(request.getParameter("c_cms_dep_ssn")	==null?"":request.getParameter("c_cms_dep_ssn"));
				card_cms.setCms_day		(request.getParameter("fee_est_day")	==null?"":request.getParameter("fee_est_day"));
				card_cms.setCms_dep_post(request.getParameter("c_cms_zip")		==null?"":request.getParameter("c_c_cms_zip"));
				card_cms.setCms_dep_addr(request.getParameter("c_cms_addr")		==null?"":request.getParameter("c_c_cms_addr"));
				card_cms.setCms_etc		(rent_l_cd);
				card_cms.setCms_tel		(request.getParameter("c_cms_tel")	==null?"":request.getParameter("c_cms_tel"));
				card_cms.setCms_m_tel	(request.getParameter("c_cms_m_tel")	==null?"":request.getParameter("c_cms_m_tel"));
				card_cms.setCms_email	(request.getParameter("c_cms_email")	==null?"":request.getParameter("c_cms_email"));
				card_cms.setCms_start_dt(request.getParameter("c_cms_start_dt")	==null?"":request.getParameter("c_cms_start_dt"));
				
				if(card_cms.getCms_day().equals("99")){
					card_cms.setCms_day	("31");
				}		
				
				if(!card_cms.getCms_start_dt().equals("")){
					card_cms.setApp_dt(AddUtil.getDate());
					card_cms.setApp_id(user_id);
				}
				
				if(!card_cms.getCms_acc_no().equals("") || !card_cms.getCms_bank().equals("")){
					
					if(card_cms.getSeq().equals("")){
						card_cms.setRent_mng_id(rent_mng_id);
						card_cms.setRent_l_cd	(rent_l_cd);
						card_cms.setReg_st		("1");
						card_cms.setCms_st		("1");
						card_cms.setReg_id		(user_id);
						//=====[card_cms_mng] insert=====
						flag2 = a_db.insertContCardCmsMng(card_cms);
					}else{
						card_cms.setUpdate_id	(user_id);
						//=====[card_cms_mng] update=====
						flag2 = a_db.updateContCardCmsMng(card_cms);
					}
				}
			}
			
		}	
	}
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	fee_etc.setCms_not_cau	(request.getParameter("cms_not_cau")==null?"":request.getParameter("cms_not_cau"));
	if(!fee_etc.getCms_not_cau().equals("")){
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
	}
	
	if(base.getCar_st().equals("4")){
      //fee_rm
			ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");	
			fee_rm.setCms_type	(request.getParameter("cms_type")==null?"":request.getParameter("cms_type"));
			//=====[fee_rm] update=====
			flag2 = a_db.updateFeeRm(fee_rm);
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('대여정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag2){	%>	alert('자동이체 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("tax")){
	
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
		flag2 = a_db.updateContEtc(cont_etc);
	}else{
		//=====[cont_etc] update=====
		flag2 = a_db.updateContEtc(cont_etc);
	}
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	if(!car_st.equals("2")){
		
		fee.setBr_id		(request.getParameter("fee_br_id")	==null?"":request.getParameter("fee_br_id"));
		fee.setFee_st		(request.getParameter("fee_st")		==null?"":request.getParameter("fee_st"));
		fee.setRc_day		(request.getParameter("rc_day")		==null?"":request.getParameter("rc_day"));
		fee.setNext_yn		(request.getParameter("next_yn")	==null?"":request.getParameter("next_yn"));
		fee.setLeave_day	(request.getParameter("leave_day")	==null?"":request.getParameter("leave_day"));
		
		//=====[fee] update=====
		flag3 = a_db.updateContFeeNew(fee);
	}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("taecha_info")){
	
	if(!car_st.equals("2")){
		
		//대여정보-------------------------------------------------------------------------------------------
		
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		fee.setPrv_dlv_yn		(request.getParameter("prv_dlv_yn")		==null?"":request.getParameter("prv_dlv_yn"));
		fee.setPrv_mon_yn		(request.getParameter("prv_mon_yn")		==null?"":request.getParameter("prv_mon_yn"));
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);
		
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('대여정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>			
</script>
<%	}%>

<%
	if(cng_item.equals("taecha") || (cng_item.equals("taecha_info") && ta_vt_size==0)){
	
	if(!car_st.equals("2")){
		
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		
		//출고지연대차-------------------------------------------------------------------------------------------
		
		String tae_car_mng_id = request.getParameter("tae_car_mng_id")	==null?"":request.getParameter("tae_car_mng_id");
		String tae_no = request.getParameter("tae_no")	==null?"":request.getParameter("tae_no");
		
		String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
		
		if(!tae_no.equals("") && taecha_no.equals("")){
			taecha_no = tae_no;
		}
		
		if(taecha_no.equals("")){
			taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
		}
				
		//출고지연대차
		ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
		
		taecha.setCar_mng_id	(tae_car_mng_id);
		taecha.setCar_no		(request.getParameter("tae_car_no")		==null?"":request.getParameter("tae_car_no"));
		taecha.setCar_nm		(request.getParameter("tae_car_nm")		==null?"":request.getParameter("tae_car_nm"));
		taecha.setCar_id		(request.getParameter("tae_car_id")		==null?"":request.getParameter("tae_car_id"));
		taecha.setCar_seq		(request.getParameter("tae_car_seq")	==null?"":request.getParameter("tae_car_seq"));
		taecha.setCar_rent_st	(request.getParameter("tae_car_rent_st")==null?"":request.getParameter("tae_car_rent_st"));
		taecha.setCar_rent_et	(request.getParameter("tae_car_rent_et")==null?"":request.getParameter("tae_car_rent_et"));
		taecha.setRent_fee		(request.getParameter("tae_rent_fee")	==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_fee")));
		taecha.setReq_st		(request.getParameter("tae_req_st")		==null?"":request.getParameter("tae_req_st"));
		taecha.setTae_st		(request.getParameter("tae_tae_st")		==null?"":request.getParameter("tae_tae_st"));
		taecha.setTae_sac_id	(request.getParameter("tae_sac_id")		==null?"":request.getParameter("tae_sac_id"));
		taecha.setRent_s_cd		(request.getParameter("tae_s_cd")		==null?"":request.getParameter("tae_s_cd"));
		taecha.setRent_inv		(request.getParameter("tae_rent_inv")	==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_inv")));
		taecha.setEst_id		(request.getParameter("tae_est_id")		==null?"":request.getParameter("tae_est_id"));
		taecha.setF_req_yn		(request.getParameter("tae_f_req_yn")		==null?"":request.getParameter("tae_f_req_yn"));
		taecha.setRent_fee_st	(request.getParameter("tae_rent_fee_st")	==null?"":request.getParameter("tae_rent_fee_st"));
		taecha.setRent_fee_cls	(request.getParameter("tae_rent_fee_cls")	==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_fee_cls")));
		taecha.setEnd_rent_link_sac_id(request.getParameter("end_rent_link_sac_id")		==null?"":request.getParameter("end_rent_link_sac_id"));
		
		if(!tae_car_mng_id.equals("") && fee.getPrv_dlv_yn().equals("Y")){
			
			String taecha_add_yn = "N"; 
			
			if(taecha.getRent_mng_id().equals("")){
				taecha.setRent_mng_id	(rent_mng_id);
				taecha.setRent_l_cd		(rent_l_cd);
				//=====[Taecha] insert=====
				flag2 = a_db.insertTaechaNew(taecha);
				
				if(ta_vt_size > 0){
					taecha_add_yn = "Y";
				}
				
			}else{
				//=====[Taecha] update=====
				flag2 = a_db.updateTaechaNew(taecha);
			}
			
			//출고전대차 차량변경(추가등록)
			if(taecha_add_yn.equals("Y")){
				UsersBean tae_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("스케줄생성자"));
										
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>출고지연대차 차량변경</SUB>"+
		  				"    <CONT>출고지연대차 차량이 변경되었으니 대여료 확인하세요. &lt;br&gt; &lt;br&gt;  "+rent_l_cd+" "+firm_nm+"</CONT>"+
 						"    <URL></URL>";
				//xml_data3 += "    <TARGET>"+tae_target_bean.getId()+"</TARGET>";
				xml_data3 += "    <TARGET>2002013</TARGET>";
				xml_data3 += "    <SENDER></SENDER>"+ 
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
			
			//스케줄담당자에게 메시지 발송
			if(AddUtil.parseInt(taecha.getRent_fee()) >0 && taecha.getF_req_yn().equals("Y") && taecha.getF_req_dt().equals("")){
				UsersBean tae_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("스케줄생성자"));
										
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>출고전대차 선입금 계약</SUB>"+
		  				"    <CONT>출고전대차 선입금 계약  &lt;br&gt; &lt;br&gt;  "+rent_l_cd+" "+firm_nm+" 월대여료"+taecha.getRent_fee()+"원</CONT>"+
 						"    <URL></URL>";
				xml_data3 += "    <TARGET>"+tae_target_bean.getId()+"</TARGET>";
				xml_data3 += "    <SENDER></SENDER>"+ 
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
				if(rc_bean.getSub_l_cd().equals("")){
					rc_bean.setSub_l_cd		(rent_l_cd);
					int rs_count = 1;
					rs_count = rs_db.updateRentCont(rc_bean);
				}
			}
		}else{
			if(!taecha.getRent_mng_id().equals("") && fee.getPrv_dlv_yn().equals("N") && taecha.getCar_rent_st().equals("") && taecha.getCar_rent_et().equals("")){
				if(taecha.getCar_mng_id().equals("")){
					//=====[Taecha] update=====
					flag2 = a_db.deleteTaecha(taecha);
					
				}else{
					//=====[Taecha] update=====
					flag2 = a_db.updateTaechaNew(taecha);
				}	
			}
		}
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('대여정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag2){	%>	alert('출고전대차 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("emp1")){
	
	//영업소사원-------------------------------------------------------------------------------------------
	
	
	String emp_id[] 	= request.getParameterValues("emp_id");
	String car_off_nm[] = request.getParameterValues("car_off_nm");
	
	float o_comm_r_rt = emp1.getComm_r_rt();
	
	if(!emp_id[0].equals("")){
	
				
		emp1.setEmp_id		(emp_id[0]);
		if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id)){
			emp1.setComm_rt		(request.getParameter("comm_rt")	==null? 0:AddUtil.parseFloat(request.getParameter("comm_rt")));
		}
		emp1.setComm_r_rt	(request.getParameter("comm_r_rt")	==null? 0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
		emp1.setCh_remark	(request.getParameter("ch_remark")	==null?"":request.getParameter("ch_remark"));
		emp1.setCh_sac_id	(request.getParameter("ch_sac_id")	==null?"":request.getParameter("ch_sac_id"));
		emp1.setEmp_bank	(request.getParameter("emp_bank")	==null?"":request.getParameter("emp_bank"));
		emp1.setEmp_acc_no	(request.getParameter("emp_acc_no")	==null?"":request.getParameter("emp_acc_no"));
		emp1.setEmp_acc_nm	(request.getParameter("emp_acc_nm")	==null?"":request.getParameter("emp_acc_nm"));
		emp1.setCommi		(request.getParameter("commi")		==null? 0:AddUtil.parseDigit(request.getParameter("commi")));
		emp1.setCommi_car_amt	(request.getParameter("commi_car_amt")==null? 0:AddUtil.parseDigit(request.getParameter("commi_car_amt")));
		emp1.setCommi_car_st	(request.getParameter("commi_car_st")==null?"":request.getParameter("commi_car_st"));
		emp1.setAgnt_st		("1");
		emp1.setCommi_st	("1");
		emp1.setBank_cd		(request.getParameter("emp_bank_cd")	==null?"":request.getParameter("emp_bank_cd"));
		
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
	}else{
		emp1.setEmp_id		("000000");
		if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id)){
			emp1.setComm_rt		(request.getParameter("comm_rt")	==null? 0:AddUtil.parseFloat(request.getParameter("comm_rt")));
		}
		emp1.setComm_r_rt	(request.getParameter("comm_r_rt")	==null? 0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
		emp1.setCh_remark	(request.getParameter("ch_remark")	==null?"":request.getParameter("ch_remark"));
		emp1.setCh_sac_id	(request.getParameter("ch_sac_id")	==null?"":request.getParameter("ch_sac_id"));
		emp1.setEmp_bank	(request.getParameter("emp_bank")	==null?"":request.getParameter("emp_bank"));
		emp1.setEmp_acc_no	(request.getParameter("emp_acc_no")	==null?"":request.getParameter("emp_acc_no"));
		emp1.setEmp_acc_nm	(request.getParameter("emp_acc_nm")	==null?"":request.getParameter("emp_acc_nm"));
		emp1.setCommi		(request.getParameter("commi")		==null? 0:AddUtil.parseDigit(request.getParameter("commi")));
		emp1.setCommi_car_amt(request.getParameter("commi_car_amt")==null? 0:AddUtil.parseDigit(request.getParameter("commi_car_amt")));
		emp1.setCommi_car_st(request.getParameter("commi_car_st")==null?"":request.getParameter("commi_car_st"));
		//=====[commi] update=====
		flag1 = a_db.updateCommiNew(emp1);
	}
	
	float n_comm_r_rt = emp1.getComm_r_rt();
	
	//영업수당 수정시 영업팀장에게 메시지 발송		
	if(o_comm_r_rt > n_comm_r_rt || o_comm_r_rt < n_comm_r_rt){
		
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
		String sub 		= "장기계약 계약영업수당 변동";
		String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ] 장기계약의 계약관리에서 계약영업수당이 변동하였습니다. 확인바랍니다.";
		String url 		= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;
		String target_id = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
		String m_url = "/fms2/lc_rent/lc_b_frame.jsp";
		CarSchDatabase csd = CarSchDatabase.getInstance();
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
	
	
	if(car_gu.equals("1")){
		
		pur.setPur_bus_st	(request.getParameter("pur_bus_st")	==null?"":request.getParameter("pur_bus_st"));
		
		//=====[CAR_PUR] update=====
		flag4 = a_db.updateContPur(pur);
		
	}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('영업담당 영업사원 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("emp2")){
	
	//영업소사원-------------------------------------------------------------------------------------------
	
	//commi
	
	String emp_id[] 	= request.getParameterValues("emp_id");
	String car_off_nm[] = request.getParameterValues("car_off_nm");
	
	if(car_gu.equals("1")){
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
			emp2.setEmp_id		("000000");
			//=====[commi] update=====
			flag2 = a_db.updateCommiNew(emp2);
		}
	}
	
	//계약기본정보-----------------------------------------------------------------------------------------------
	
	base.setDlv_dt		(request.getParameter("dlv_dt")			==null?"":request.getParameter("dlv_dt"));
	//=====[cont] update=====
	flag3 = a_db.updateContBaseNew(base);
	
	//출고정보-------------------------------------------------------------------------------------------
	
	
	if(car_gu.equals("1")){
		
		String o_one_self  	= pur.getOne_self();
		
		String dlv_est_dt 	= request.getParameter("dlv_est_dt")==null?"":request.getParameter("dlv_est_dt");
		String dlv_est_h 	= request.getParameter("dlv_est_h")	==null?"":request.getParameter("dlv_est_h");
		pur.setOne_self		(request.getParameter("one_self")	==null?"":request.getParameter("one_self"));
		pur.setRpt_no		(request.getParameter("rpt_no")		==null?"":request.getParameter("rpt_no"));
		pur.setDlv_est_dt	(dlv_est_dt+dlv_est_h);
		pur.setDlv_est_h	(dlv_est_h);
		pur.setDlv_brch		(car_off_nm[1]);
		pur.setTmp_drv_no	(request.getParameter("tmp_drv_no")	==null?"":request.getParameter("tmp_drv_no"));
		pur.setTmp_drv_st	(request.getParameter("tmp_drv_st")	==null?"":request.getParameter("tmp_drv_st"));
		pur.setTmp_drv_et	(request.getParameter("tmp_drv_et")	==null?"":request.getParameter("tmp_drv_et"));
		pur.setCar_num		(request.getParameter("car_num")	==null?"":request.getParameter("car_num"));
		pur.setEst_car_no	(request.getParameter("est_car_no")	==null?"":request.getParameter("est_car_no"));
		//pur.setCon_amt		(request.getParameter("con_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("con_amt")));
		//pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
		//pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
		//pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
		pur.setDir_pur_yn	(request.getParameter("dir_pur_yn")	==null?"":request.getParameter("dir_pur_yn"));
		pur.setPur_req_dt	(request.getParameter("pur_req_dt")	==null?"":request.getParameter("pur_req_dt"));
		pur.setPur_req_yn	(request.getParameter("pur_req_yn")	==null?"":request.getParameter("pur_req_yn"));
		//pur.setTrf_amt5		(request.getParameter("trf_amt5")		==null? 0:AddUtil.parseDigit(request.getParameter("trf_amt5")));
		
		//if(pur.getTrf_amt5() >0 && pur.getTrf_st5().equals("")) pur.setTrf_st5("1");
		
		//=====[CAR_PUR] update=====
		flag4 = a_db.updateContPur(pur);
		
		String n_one_self  	= pur.getOne_self();
		
		//자체출고 수정시 영업팀장에게 메시지 발송
		if(!o_one_self.equals(n_one_self) && base.getUse_yn().equals("Y") && fee_size == 1 && cont_etc.getRent_suc_dt().equals("")){
		
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String sub 		= "장기계약 자체출고여부 변동";
			String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ] 장기계약의 계약관리에서 자체출고여부가 변동하였습니다. 확인바랍니다.";
			String target_id = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
			
			CarSchDatabase csd = CarSchDatabase.getInstance();
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
 						"    <URL></URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			
			if(pur.getOne_self().equals("Y") && pur.getDlv_brch().equals("오금역대리점") && emp_id[1].equals("008126")){
				
				target_id = nm_db.getWorkAuthUser("출고관리자");
				target_bean 	= umd.getUsersBean(target_id);
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
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
			
			flag4 = cm_db.insertCoolMsg(msg);
		}
	}
	
	%>
<script language='javascript'>
<%		if(!flag2){	%>	alert('출고담당 영업사원 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag3){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag4){	%>	alert('출고정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("rent_start")){
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	if(!car_st.equals("2")){
		
		fee.setRent_start_dt		(request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt"));
		fee.setRent_end_dt		(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
		fee.setFee_pay_tm		(request.getParameter("fee_pay_tm")		==null?"":request.getParameter("fee_pay_tm"));
		fee.setFee_est_day		(request.getParameter("fee_est_day")	==null?"":request.getParameter("fee_est_day"));
		fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt")==null?"":request.getParameter("fee_pay_start_dt"));
		fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt")	==null?"":request.getParameter("fee_pay_end_dt"));
		fee.setFee_fst_dt		(request.getParameter("fee_fst_dt")		==null?"":request.getParameter("fee_fst_dt"));
		fee.setFee_fst_amt		(request.getParameter("fee_fst_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("fee_fst_amt")));
		
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);
		
		
		
		base.setRent_start_dt		(request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt"));
		base.setRent_end_dt		(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
		
		//=====[cont] update=====
		flag2 = a_db.updateContBaseNew(base);
		
		
		//차량인도일
		cont_etc.setCar_deli_dt		(request.getParameter("car_deli_dt")	==null?"":request.getParameter("car_deli_dt"));
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag3 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag3 = a_db.updateContEtc(cont_etc);
		}
		
		
		//20141014 만기매칭대차의 경우 신차대여개시시 최초주행거리 입력한다.
		
		String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
		
		if(taecha_no.equals("")){
			taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
		}
				
		//출고지연대차
		ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
		if(base.getCar_gu().equals("1") && base.getRent_st().equals("3") && taecha.getCar_mng_id().equals(base.getCar_mng_id())){
			fee_etc.setSh_km		(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));		
			//=====[fee_etc] update=====
			flag4 = a_db.updateFeeEtc(fee_etc);
		}
		
		
		//고객에게 영업담당자 배정 문자 발송한다. : 20100716
				
		
		//계약 담당자 변경 관련 문자
		Hashtable sms = c_db.getDmailSms(rent_mng_id, rent_l_cd, "1");
		
		Hashtable cont_view = a_db.getContViewCase(rent_mng_id, rent_l_cd);
		
		UsersBean target_bean 	= umd.getUsersBean(base.getBus_id2());
		
		if(!rent_l_cd.equals("S214KK7R00045") && !base.getBus_id2().equals("000026") && !base.getBus_id2().equals("000005") && !base.getBus_id2().equals("000144") && !base.getBus_id2().equals("000053") && !base.getBus_id2().equals("000052")){//관리팀장,영업팀장,채권담당,부산지점장제외
		
			CarRegDatabase crd = CarRegDatabase.getInstance();
			if(!base.getCar_mng_id().equals("")){
				cr_bean = crd.getCarRegBean(base.getCar_mng_id());
			}
			
			String s_destphone = "";
			s_destphone = String.valueOf(sms.get("TEL"));
			
			String s_destname = "";
			s_destname = String.valueOf(sms.get("NM"));
			
			String ins_name = "";
			ins_name = ai_db.getInsComNm(base.getCar_mng_id() );
			
			String ins_tel ="";
			if ( ins_name.equals("삼성화재") ) {
			    ins_tel = " 1588-5114 , ";
			} else if  ( ins_name.equals("동부화재") ) {
			    ins_tel = " 1588-0100 ,";
			}
			
			String cont_sms 	= cr_bean.getCar_no() + " 대여개시일은 " + String.valueOf(cont_view.get("RENT_START_DT")) + ", 차량 담당자는 " + target_bean.getUser_nm() + ", 연락처는 "+ target_bean.getUser_m_tel() + " 입니다. (주)아마존카"; 
			
			String cont_sms1 	= "보험사는 "+ ins_name + " "  + ins_tel + " 긴급출동은 마스타자동차 1588-6688, SK네트웍스 1670-5494 입니다.  (주)아마존카 "; 
			
			
						
			if(!s_destphone.equals("")){	
			
				//201411 대여개시일 +3일에 보내는것으로 예약한다.
				String msg_type 	= "5";
				String msg_subject 	= "대여개시안내";
				String req_time 	= AddUtil.getDate(4);
				String rqdate 		= "";
				
				req_time = rs_db.addDay(req_time, 3);
				
				req_time = AddUtil.replace(af_db.getValidDt(req_time),"-","")+"100000";								
						
				IssueDb.insertsendMail_V5_req_H("02-392-4242", "(주)아마존카", s_destphone, s_destname, req_time, rqdate, msg_type, msg_subject, cont_sms, rent_l_cd, base.getClient_id(), ck_acar_id, "start");
				
				msg_subject 	= "보험및 긴급출동안내";
				
				IssueDb.insertsendMail_V5_req_H( target_bean.getUser_m_tel(), "(주)아마존카 " + target_bean.getUser_nm(), s_destphone, s_destname, req_time, rqdate, msg_type, msg_subject, cont_sms1, rent_l_cd, base.getClient_id(), ck_acar_id, "start");
			}
			
		}						
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('대여정보 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag2){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag3){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>
<%	}%>


<%
	if(cng_item.equals("fee")){
	
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	
	if(rent_st.equals("1")){
		
		
		cont_etc.setGrt_suc_m_id	(request.getParameter("grt_suc_m_id")	==null?"":request.getParameter("grt_suc_m_id"));
		cont_etc.setGrt_suc_l_cd	(request.getParameter("grt_suc_l_cd")	==null?"":request.getParameter("grt_suc_l_cd"));
		cont_etc.setGrt_suc_c_no	(request.getParameter("grt_suc_c_no")	==null?"":request.getParameter("grt_suc_c_no"));
		cont_etc.setGrt_suc_o_amt	(request.getParameter("grt_suc_o_amt")==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_o_amt")));
		cont_etc.setGrt_suc_r_amt	(request.getParameter("grt_suc_r_amt")==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_r_amt")));
		cont_etc.setCar_deli_dt			(request.getParameter("car_deli_dt")	==null?"":request.getParameter("car_deli_dt"));
		//재리스 차량인도예정일
		if(car_gu.equals("0")){
			cont_etc.setCar_deli_est_dt(request.getParameter("car_deli_est_dt")	==null?"":request.getParameter("car_deli_est_dt")); 
		}
		
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag9 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag9 = a_db.updateContEtc(cont_etc);
		}
		
	}
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	int old_value = fee.getInv_s_amt();
	int new_value = request.getParameter("inv_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("inv_s_amt"));
	
	if(!car_st.equals("2")){
		
		if(!rent_st.equals("1")){
			fee.setExt_agnt			(request.getParameter("ext_agnt")	==null? "":request.getParameter("ext_agnt"));
			fee.setRent_dt			(request.getParameter("rent_dt")	==null? "":request.getParameter("rent_dt"));
		}
		
		
		if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("스케줄생성자",ck_acar_id) || nm_db.getWorkAuthUser("스케줄변경담당자",ck_acar_id)){
			fee.setCon_mon			(request.getParameter("con_mon")		==null?"":request.getParameter("con_mon"));
			fee.setRent_start_dt		(request.getParameter("rent_start_dt")		==null?"":request.getParameter("rent_start_dt"));
			fee.setRent_end_dt		(request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt"));
		}
		
		fee.setCredit_per		(request.getParameter("credit_per")		==null? 0:AddUtil.parseFloat(request.getParameter("credit_per")));
		fee.setCredit_r_per		(request.getParameter("credit_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("credit_r_per")));
		fee.setCredit_amt		(request.getParameter("credit_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("credit_amt")));
		fee.setCredit_r_amt		(request.getParameter("credit_r_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("credit_r_amt")));
		
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
		
		fee.setJa_s_amt			(request.getParameter("ja_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_s_amt")));
		fee.setJa_v_amt			(request.getParameter("ja_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_v_amt")));
		fee.setJa_r_s_amt		(request.getParameter("ja_r_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_r_s_amt")));
		fee.setJa_r_v_amt		(request.getParameter("ja_r_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ja_r_v_amt")));
		
		fee.setOpt_s_amt		(request.getParameter("opt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("opt_s_amt")));
		fee.setOpt_v_amt		(request.getParameter("opt_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("opt_v_amt")));
		fee.setInv_s_amt		(request.getParameter("inv_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_s_amt")));
		fee.setInv_v_amt		(request.getParameter("inv_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_v_amt")));
		fee.setIns_s_amt		(request.getParameter("ins_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ins_s_amt")));
		fee.setIns_v_amt		(request.getParameter("ins_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("ins_v_amt")));
		
		fee.setIns_total_amt	(request.getParameter("ins_total_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ins_total_amt")));
		
		fee.setFee_sac_id		(request.getParameter("fee_sac_id")		==null?"":request.getParameter("fee_sac_id"));
		fee.setFee_cdt			(request.getParameter("fee_cdt")		==null?"":request.getParameter("fee_cdt"));
		fee.setFee_pay_tm		(request.getParameter("fee_pay_tm")		==null?"":request.getParameter("fee_pay_tm"));
		fee.setFee_est_day		(request.getParameter("fee_est_day")		==null?"":request.getParameter("fee_est_day"));
		fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt")	==null?"":request.getParameter("fee_pay_start_dt"));
		fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt")		==null?"":request.getParameter("fee_pay_end_dt"));
		fee.setFee_fst_dt		(request.getParameter("fee_fst_dt")		==null?"":request.getParameter("fee_fst_dt"));
		fee.setFee_fst_amt		(request.getParameter("fee_fst_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("fee_fst_amt")));
		
		fee.setGrt_suc_yn		(request.getParameter("grt_suc_yn")		==null?"":request.getParameter("grt_suc_yn"));
		fee.setIfee_suc_yn		(request.getParameter("ifee_suc_yn")		==null?"":request.getParameter("ifee_suc_yn"));

		fee.setF_opt_per			(request.getParameter("f_opt_per")		==null?"":request.getParameter("f_opt_per"));
		fee.setF_gur_p_per		(request.getParameter("f_gur_p_per")	==null?"":request.getParameter("f_gur_p_per"));
		fee.setF_pere_r_per		(request.getParameter("f_pere_r_per")	==null?"":request.getParameter("f_pere_r_per"));
		
		
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);
		
		
		String inv_cng_st = "";
		if(old_value-new_value > 0){
			inv_cng_st= "-";
		}
		if(old_value-new_value < 0){
			inv_cng_st= "+";
		}
		
		//정상대여료 변경시 이력남기기
		if(!inv_cng_st.equals("")){
			LcRentCngHBean cng = new LcRentCngHBean();
			cng.setRent_mng_id	(rent_mng_id);
			cng.setRent_l_cd	(rent_l_cd);
			cng.setCng_item		("inv_amt");
			cng.setOld_value	(Integer.toString(old_value));
			cng.setNew_value	(Integer.toString(new_value));
			cng.setCng_cau		("수정");
			cng.setCng_id		(user_id);
			cng.setRent_st		(rent_st);
			cng.setS_amt		(fee.getInv_s_amt());
			cng.setV_amt		(fee.getInv_v_amt());
			flag2 = a_db.updateLcRentCngH(cng);
		}
		
		
		
		
		
		//대여기타정보-------------------------------------------------------------------------------------------
		
			//fee_etc
			ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
			fee_etc.setBus_agnt_id		(request.getParameter("bus_agnt_id")		==null?"":request.getParameter("bus_agnt_id"));
			fee_etc.setBus_agnt_per		(request.getParameter("bus_agnt_per")		==null? 0:AddUtil.parseFloat(request.getParameter("bus_agnt_per")));
			fee_etc.setBus_agnt_r_per	(request.getParameter("bus_agnt_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("bus_agnt_r_per")));
			fee_etc.setCls_n_mon		(request.getParameter("cls_n_mon")			==null?"":request.getParameter("cls_n_mon"));
			fee_etc.setCls_n_amt		(request.getParameter("cls_n_amt")			==null? 0:AddUtil.parseDigit(request.getParameter("cls_n_amt")));
			fee_etc.setAgree_dist		(request.getParameter("agree_dist")			==null? 0:AddUtil.parseDigit(request.getParameter("agree_dist")));
			fee_etc.setOver_run_amt		(request.getParameter("over_run_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("over_run_amt")));
			fee_etc.setAgree_dist_yn	(request.getParameter("agree_dist_yn")		==null?"":request.getParameter("agree_dist_yn"));
			fee_etc.setOver_bas_km		(request.getParameter("over_bas_km")		==null? 0:AddUtil.parseDigit(request.getParameter("over_bas_km")));
			fee_etc.setCust_est_km		(request.getParameter("cust_est_km")		==null? 0:AddUtil.parseDigit(request.getParameter("cust_est_km")));
			fee_etc.setDriver_add_amt	(request.getParameter("driver_add_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("driver_add_amt")));
			fee_etc.setDriver_add_v_amt	(request.getParameter("driver_add_v_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("driver_add_v_amt")));	//운전자 추가요금 부가세(2018.03.30)
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
				fee_etc.setRent_mng_id		(rent_mng_id);
				fee_etc.setRent_l_cd		(rent_l_cd);
				fee_etc.setRent_st			(rent_st);
				//=====[fee_etc] insert=====
				flag1 = a_db.insertFeeEtc(fee_etc);
			}else{
				//=====[fee_etc] update=====
				flag1 = a_db.updateFeeEtc(fee_etc);
			}
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('대여정보 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag1){	%>	alert('정상요금 이력 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag4){	%>	alert('영업사원수당 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("cls_n")){
	
		String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
		fee_etc.setCls_n_mon		(request.getParameter("cls_n_mon")		==null?"":request.getParameter("cls_n_mon"));
		fee_etc.setCls_n_amt		(request.getParameter("cls_n_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("cls_n_amt")));
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
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('대여기타정보 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("spr")){
	
		String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
		
		//계약기타정보-----------------------------------------------------------------------------------------------
		
		//판정신용등급
		cont_etc.setDec_gr		(request.getParameter("dec_gr")==null?"":request.getParameter("dec_gr"));
		
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
<%		if(!flag1){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag2){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("com_emp_sac")){

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
  <input type="hidden" name="rent_st" 			value="">
</form>
<script language='javascript'>

	var fm = document.form1;
	
	if('<%=from_page%>' == '/fms2/lc_rent/lc_bc_frame.jsp'){
		fm.rent_st.value = '<%=request.getParameter("rent_st")==null?"1":request.getParameter("rent_st")%>';
		fm.action = '/fms2/lc_rent/lc_bc_u.jsp';	
		fm.target = 'd_content';
		fm.submit();
	}else if('<%=from_page%>' == '/fms2/car_pur/pur_doc_u.jsp'){
		fm.rent_st.value = '1';
		fm.action = '/fms2/car_pur/pur_doc_u.jsp';	
		fm.target = 'd_content';
		fm.submit();
	}else if('<%=from_page%>' == '/fms2/lc_rent/lc_c_u_start.jsp'){
		fm.rent_st.value = '1';
		fm.action = '/fms2/lc_rent/lc_c_u_start.jsp';	
		fm.target = 'd_content';
		fm.submit();
	}else if('<%=from_page%>' == '/fms2/lc_rent/lc_c_c_fee.jsp' && '<%=base.getCar_st()%>' == '4'){
		fm.action = '/fms2/lc_rent/lc_c_c_fee_rm.jsp';		
		fm.target = 'c_foot';
		fm.submit();			
	}else if('<%=from_page%>' == '/fms2/lc_rent/lc_c_c_car.jsp'){
		fm.rent_st.value = '1';
		fm.action = '/fms2/lc_rent/lc_c_c_car.jsp';	
		fm.target = 'c_foot';
		fm.submit();
	}else{
		fm.action = '<%=from_page%>';			
		fm.target = 'c_foot';
		fm.submit();
	}
	
	parent.window.close();

</script>
</body>
</html>