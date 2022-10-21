<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.ext.*, acar.user_mng.*, acar.car_office.*, acar.coolmsg.*, acar.car_sche.*, acar.client.*, acar.car_mst.*, acar.estimate_mng.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String cng_item 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String cng_size 	= request.getParameter("cng_size")==null?"":request.getParameter("cng_size");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	int result = 0;
	
	String msg_yn = "N"; 
	String target2_yn = "N";	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
			
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	cm_bean = cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
	//차종변수
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");	
	
	String sub 	= "";
	String cont 	= "";	
	
	UsersBean target_bean 	= umd.getUsersBean(base.getBus_id());
	UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("출고관리자"));
	UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("전기차담당"));	
	
	//배정관리		
	CarPurDocListBean cpd_bean = cod.getCarPurCom(rent_mng_id, rent_l_cd, com_con_no);	
	
	//변경계약
	Vector vt2 = cod.getCarPurComCngsNew(rent_mng_id, rent_l_cd, com_con_no);
	int vt_size2 = vt2.size();
	
	String old_dlv_est_dt 	= cpd_bean.getDlv_est_dt();
	String old_dlv_con_dt 	= cpd_bean.getDlv_con_dt();

%>


<%

	//배달탁송사
	if(cng_item.equals("cons_off")){
	
		String o_cons_off_nm 	= cpd_bean.getCons_off_nm();
		
		cpd_bean.setCons_off_nm	(request.getParameter("cons_off_nm")	==null?"":request.getParameter("cons_off_nm"));	
		cpd_bean.setCons_off_tel(request.getParameter("cons_off_tel")	==null?"":request.getParameter("cons_off_tel"));	
		
		String n_cons_off_nm 	= cpd_bean.getCons_off_nm();
		
		flag1 = cod.updateCarPurComConsOff(cpd_bean);
		
		if(o_cons_off_nm.equals("") || !o_cons_off_nm.equals(n_cons_off_nm)){
				sub 	= "배달탁송사 알림";
				cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 배달탁송사는 "+cpd_bean.getCons_off_nm()+" ("+cpd_bean.getCons_off_tel()+") 입니다.";
				msg_yn = "Y";
		}
		
	}	
	
	//출고수정
	if(cng_item.equals("dlv")){				
		
		cpd_bean.setDlv_ext		(request.getParameter("dlv_ext")	==null?"":request.getParameter("dlv_ext"));			
		cpd_bean.setUdt_st		(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));	
		cpd_bean.setUdt_firm		(request.getParameter("udt_firm")	==null?"":request.getParameter("udt_firm"));	
		cpd_bean.setUdt_addr		(request.getParameter("udt_addr")	==null?"":request.getParameter("udt_addr"));		
		cpd_bean.setUdt_mng_id		(request.getParameter("udt_mng_id")	==null?"":request.getParameter("udt_mng_id"));	
		cpd_bean.setUdt_mng_nm		(request.getParameter("udt_mng_nm")	==null?"":request.getParameter("udt_mng_nm"));	
		cpd_bean.setUdt_mng_tel		(request.getParameter("udt_mng_tel")	==null?"":request.getParameter("udt_mng_tel"));	
		cpd_bean.setCons_amt		(request.getParameter("cons_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt")));
		cpd_bean.setReg_id		(user_id);
		
		if(cpd_bean.getDlv_ext().equals("") || cpd_bean.getDlv_ext().equals("other")){
			cpd_bean.setDlv_ext	(request.getParameter("dlv_ext_sub")	==null?"":request.getParameter("dlv_ext_sub"));			
		}
		
		if(cpd_bean.getDlv_st().equals("1")){
			cpd_bean.setDlv_est_dt		(request.getParameter("dlv_est_dt")	==null?"":AddUtil.replace(request.getParameter("dlv_est_dt")," ",""));	
			
			if(!AddUtil.replace(cpd_bean.getDlv_est_dt(),"-","").equals(old_dlv_est_dt)){
				sub 	= "계출관리 자동차납품 출고배정예정";
				cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 출고배정예정 ("+cpd_bean.getDlv_est_dt()+")";			
				
				if(!old_dlv_est_dt.equals("")){
					sub 	= "계출관리 자동차납품 출고배정예정 변경";
					cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 출고배정예정 변경  ("+old_dlv_est_dt+" -> "+cpd_bean.getDlv_est_dt()+")";							
				}
				
				msg_yn = "Y";
			}
		}else{
			cpd_bean.setDlv_con_dt		(request.getParameter("dlv_con_dt")	==null?"":AddUtil.replace(request.getParameter("dlv_con_dt")," ",""));	
			
			if(!AddUtil.replace(cpd_bean.getDlv_con_dt(),"-","").equals(old_dlv_con_dt)){
				sub 	= "계출관리 자동차납품 출고배정";
				cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 출고배정 ("+cpd_bean.getDlv_con_dt()+")";			
				
				if(!old_dlv_con_dt.equals("")){
					sub 	= "계출관리 자동차납품 출고배정 변경";
					cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 출고배정 변경  ("+old_dlv_con_dt+" -> "+cpd_bean.getDlv_con_dt()+")";								
				}
				
				msg_yn = "Y";
			}
		}
		
		flag1 = cod.updateCarPurCom(cpd_bean);
		
	}
	
	//재고여부
	if(cng_item.equals("stock")){
	
		String o_order_car = cpd_bean.getOrder_car();
		
		cpd_bean.setStock_yn		(request.getParameter("stock_yn")	==null?"":request.getParameter("stock_yn"));	
		cpd_bean.setBigo				(request.getParameter("bigo")		==null?"":request.getParameter("bigo"));	
		cpd_bean.setStock_st		(request.getParameter("stock_st")	==null?"":request.getParameter("stock_st"));	
		cpd_bean.setOrder_car		(request.getParameter("order_car")	==null?"N":request.getParameter("order_car"));	
		
		flag1 = cod.updateCarPurCom(cpd_bean);
		
		msg_yn = "";
		
		if((o_order_car.equals("") || o_order_car.equals("N")) && cpd_bean.getOrder_car().equals("Y")){
			
			cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 주문차입니다. 다시 한 번 확인요청 바랍니다. 확정시 협력업체관리-자체출고관리-예정현황 세부페이지에서 [고객확인처리]를 클릭하십시오.";
			
			//계약담당자에게 문자발송
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			String sendphone 	= sender_bean.getUser_m_tel();
			String sendname 	= "(주)아마존카 "+sender_bean.getUser_nm();
			String destphone 	= target_bean.getUser_m_tel();
			String destname 	= target_bean.getUser_nm();
			String msg_cont		= cont;
		
			//에이전트 실의뢰자한테 요청
			if(target_bean.getDept_id().equals("1000") && !base.getAgent_emp_id().equals("")){
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
				destname 	= a_coe_bean.getEmp_nm();
				destphone = a_coe_bean.getEmp_m_tel();
			}
				
			//20211217 신차취소현황상태이면 메시지 발송하지 않는다.
			if(cpd_bean.getUse_yn().equals("N") && cpd_bean.getSuc_yn().equals("D")){
			}else{				
				at_db.sendMessage(1009, "0", msg_cont, destphone, "02-392-4243", null,  base.getRent_l_cd(), ck_acar_id );
			}	
		}		
	}	
	
	
	//원계약 금액수정
	if(cng_item.equals("amt")){
	
		if(cng_size.equals("0") && nm_db.getWorkAuthUser("전산팀",user_id)){
			cpd_bean.setCar_nm		(request.getParameter("car_nm")		==null?"":request.getParameter("car_nm"));	
			cpd_bean.setOpt			(request.getParameter("opt")		==null?"":request.getParameter("opt"));	
			cpd_bean.setColo		(request.getParameter("colo")		==null?"":request.getParameter("colo"));	
			cpd_bean.setPurc_gu		(request.getParameter("purc_gu")	==null?"":request.getParameter("purc_gu"));	
			cpd_bean.setAuto		(request.getParameter("auto")		==null?"":request.getParameter("auto"));					
		}
	
		cpd_bean.setCar_c_amt		(request.getParameter("car_c_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_c_amt")));	
		cpd_bean.setCar_f_amt		(request.getParameter("car_f_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_f_amt")));
		cpd_bean.setDc_amt		(request.getParameter("dc_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
		cpd_bean.setAdd_dc_amt		(request.getParameter("add_dc_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("add_dc_amt")));
		cpd_bean.setCar_d_amt		(request.getParameter("car_d_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_d_amt")));
		cpd_bean.setCar_g_amt		(request.getParameter("car_g_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_g_amt")));
		cpd_bean.setReg_id		(user_id);
		
		flag1 = cod.updateCarPurCom(cpd_bean);

		msg_yn = "";
		
	}
	
	//변경계약
	if(cng_item.equals("cng")){
	
		CarPurDocListBean cng_bean = new CarPurDocListBean();
		
		int next_seq = cod.getCarPurComCngNextSeq(rent_mng_id, rent_l_cd, com_con_no);
		
		if(!cpd_bean.getUse_yn().equals("N")){
		
			cng_bean.setRent_mng_id		(rent_mng_id);
			cng_bean.setRent_l_cd		(rent_l_cd);
			cng_bean.setCom_con_no		(com_con_no);
			cng_bean.setSeq			(next_seq);
			cng_bean.setCng_st		("1");	
			cng_bean.setCng_cont		(request.getParameter("cng_cont")	==null?"":request.getParameter("cng_cont"));	
			cng_bean.setCar_nm		(request.getParameter("car_nm")		==null?"":request.getParameter("car_nm"));	
			cng_bean.setOpt			(request.getParameter("opt")		==null?"":request.getParameter("opt"));	
			cng_bean.setColo		(request.getParameter("colo")		==null?"":request.getParameter("colo"));	
			cng_bean.setPurc_gu		(request.getParameter("purc_gu")	==null?"":request.getParameter("purc_gu"));	
			cng_bean.setAuto		(request.getParameter("auto")		==null?"":request.getParameter("auto"));		
			cng_bean.setCar_c_amt		(request.getParameter("car_c_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_c_amt")));	
			cng_bean.setCar_f_amt		(request.getParameter("car_f_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_f_amt")));
			cng_bean.setDc_amt		(request.getParameter("dc_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
			cng_bean.setAdd_dc_amt		(request.getParameter("add_dc_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("add_dc_amt")));
			cng_bean.setCar_d_amt		(request.getParameter("car_d_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_d_amt")));
			cng_bean.setCar_g_amt		(request.getParameter("car_g_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_g_amt")));		
			cng_bean.setReg_id		(user_id);
									
			flag1 = cod.insertCarPurComCng(cng_bean);		
	
			//변경상태
			cpd_bean.setUse_yn		("C");
			cpd_bean.setDlv_st		("1");
			cpd_bean.setReg_id		(user_id);
			flag2 = cod.updateCarPurCom(cpd_bean);
		}
	}
	
	//변경계약-반영처리
	if(cng_item.equals("cng_act") || cng_item.equals("cls_act") || cng_item.equals("re_act") || cng_item.equals("end_act") || cng_item.equals("cng_cont")){
	
		//변경관리		
		CarPurDocListBean cng_bean = cod.getCarPurComCng(rent_mng_id, rent_l_cd, com_con_no, seq);
		
		cng_bean.setCng_id		(user_id);
		
		flag1 = cod.updateCarPurComCngAct(cng_bean);	
		
		if(cng_item.equals("re_act")){
			cpd_bean.setDlv_st		(request.getParameter("dlv_st")		==null?"":request.getParameter("dlv_st"));	
			cpd_bean.setDlv_est_dt		(request.getParameter("dlv_est_dt")	==null?"":request.getParameter("dlv_est_dt"));	
			cpd_bean.setReg_id		(user_id);
			flag1 = cod.updateCarPurCom(cpd_bean);			
		}
		
		msg_yn = "Y";
		target2_yn = "Y"; 
		
		if(cng_item.equals("cng_act")){
			sub 	= "계출관리 자동차납품 계약변경 반영";
			cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 계출관리 자동차납품 계약변경이 반영되었습니다.";
		}else if(cng_item.equals("cls_act")){
			sub 	= "계출관리 자동차납품 계약해지 반영";
			cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 계출관리 자동차납품 계약해지가 반영되었습니다.";
		}else if(cng_item.equals("re_act")){
			sub 	= "계출관리 자동차납품 재배정요청 반영";
			cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 계출관리 자동차납품 재배정요청이 반영되었습니다.";
		}else if(cng_item.equals("end_act")){
			sub 	= "계출관리 자동차납품 배정후 변경요청 반영";
			cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 계출관리 자동차납품 배정후 변경요청이 반영되었습니다.";
		}else if(cng_item.equals("cng_cont")){
			sub 	= "계출관리 자동차납품 고객변경 반영";
			cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 계출관리 자동차납품 고객변경이 반영되었습니다.";
		}
		
	}
	
	//변경계약 금액수정
	if(cng_item.equals("cng_amt")){
	
		//변경관리		
		CarPurDocListBean cng_bean = cod.getCarPurComCng(rent_mng_id, rent_l_cd, com_con_no, seq);
		
		cng_bean.setCar_c_amt		(request.getParameter("car_c_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_c_amt")));	
		cng_bean.setCar_f_amt		(request.getParameter("car_f_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_f_amt")));
		cng_bean.setDc_amt		(request.getParameter("dc_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
		cng_bean.setAdd_dc_amt		(request.getParameter("add_dc_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("add_dc_amt")));
		cng_bean.setCar_d_amt		(request.getParameter("car_d_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_d_amt")));
		cng_bean.setCar_g_amt		(request.getParameter("car_g_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_g_amt")));
		
		flag1 = cod.updateCarPurComCng(cng_bean);
		
		msg_yn = "";
	}	
	
	//변경 취소
	if(cng_item.equals("cng_cancel")){
	
		//변경관리		
		CarPurDocListBean cng_bean = cod.getCarPurComCng(rent_mng_id, rent_l_cd, com_con_no, seq);
		
		flag1 = cod.deleteCarPurComCng(cng_bean);
		
		msg_yn = "";
	}		
	
	//계약해지
	if(cng_item.equals("cls1") || cng_item.equals("cls2")){
	
		CarPurDocListBean cng_bean = new CarPurDocListBean();
		
		int next_seq = cod.getCarPurComCngNextSeq(rent_mng_id, rent_l_cd, com_con_no);
		
		cng_bean.setRent_mng_id	(rent_mng_id);
		cng_bean.setRent_l_cd		(rent_l_cd);
		cng_bean.setCom_con_no	(com_con_no);
		cng_bean.setSeq					(next_seq);
		cng_bean.setCng_st			("2");	
		cng_bean.setCng_cont		(request.getParameter("cng_cont")	==null?"":request.getParameter("cng_cont"));	
		cng_bean.setBigo				(request.getParameter("bigo")		==null?"":request.getParameter("bigo"));	
		cng_bean.setReg_id			(user_id);
									
		flag1 = cod.insertCarPurComCng(cng_bean);		

		if(cng_bean.getCng_cont().equals("신차취소현황으로 보내기")){
			cpd_bean.setSuc_yn	("D");	
			cpd_bean.setCng_yn	("Y");
		}
		
		//변경상태
		cpd_bean.setUse_yn		("N");	
		cpd_bean.setReg_id		(user_id);				
		flag2 = cod.updateCarPurCom(cpd_bean);
		
		//car_pur - 출고요청으로 다시 넘어가게
		ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		pur.setPur_com_firm("");
		//=====[CAR_PUR] update=====
		flag4 = a_db.updateContPur(pur);
		
		String cont_use_yn = request.getParameter("cont_use_yn")==null?"":request.getParameter("cont_use_yn");
		
		//아마존카단계일때 처리
		if(cont_use_yn.equals("N") && base.getClient_id().equals("000228") && !base.getCar_st().equals("2")){
			base.setUse_yn("N");
			//=====[cont] update=====
			flag3 = a_db.updateContBaseNew(base);
			
			//선수금스케줄 있다면 미청구처리
			
			//보증금
			ExtScdBean grt = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "0", "1");//기존 등록 여부 조회
			int grt_gbn = 1;	//기존
			if(grt == null || grt.getRent_l_cd().equals("")){
				grt_gbn = 0;	//신규
			}
			if(grt_gbn == 1 && grt.getExt_pay_dt().equals("")){
				grt.setBill_yn		("N");
				grt.setUpdate_id	(user_id);
				//=====[scd_pre] update=====
				flag6 = ae_db.updateGrt(grt);
			}
									
			//선납금
			ExtScdBean pp = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "1", "1");//기존 등록 여부 조회
			int pp_gbn = 1;		//기존
			if(pp == null || pp.getRent_l_cd().equals("")){
				pp_gbn = 0;	//신규
			}
			if(pp_gbn == 1 && pp.getExt_pay_dt().equals("")){
				pp.setBill_yn		("N");
				pp.setUpdate_id		(user_id);
				//=====[scd_pre] update=====
				flag6 = ae_db.updateGrt(pp);
			}
						
			//개시대여료
			ExtScdBean ifee = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "2", "1");//기존 등록 여부 조회
			int ifee_gbn = 1;	//기존
			if(ifee == null || ifee.getRent_l_cd().equals("")){
				ifee_gbn = 0;	//신규
			}
			if(ifee_gbn == 1 && ifee.getExt_pay_dt().equals("")){
				ifee.setBill_yn		("N");
				ifee.setUpdate_id	(user_id);
				//=====[scd_pre] update=====
				flag6 = ae_db.updateGrt(ifee);
			}
		}
		
		//알림톡 보내기
		if(cng_bean.getCng_cont().equals("신차취소현황으로 보내기")){
			
			// 변경계약건이 있을경우
			if (vt_size2 > 0) {
				for (int z = 0 ; z < vt_size2 ; z++) {
			 		Hashtable ht2 = (Hashtable)vt2.elementAt(z);
					
					cpd_bean.setCom_con_no(String.valueOf(ht2.get("COM_CON_NO")));
					cpd_bean.setCar_nm(String.valueOf(ht2.get("CAR_NM")));
					cpd_bean.setOpt(String.valueOf(ht2.get("OPT")));
					cpd_bean.setColo(String.valueOf(ht2.get("COLO")));
					cpd_bean.setCar_c_amt(AddUtil.parseInt(String.valueOf(ht2.get("CAR_C_AMT"))));
				}
			}
			
			//알림톡
			String at_value0 = cpd_bean.getCom_con_no();
			String at_value1 = cpd_bean.getCar_nm();
			String at_value2 = cpd_bean.getOpt();
			String at_value3 = cpd_bean.getColo();
			String at_value4 = AddUtil.parseDecimal(cpd_bean.getCar_c_amt())+"원";
			String at_value5 = AddUtil.ChangeDate2(base.getReg_dt());
			String at_value6 = AddUtil.ChangeDate2(cpd_bean.getDlv_est_dt());
			String at_destphone = "";
			
			if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("3")){
				at_value4 = at_value4 + "(친환경차 개소세 감면후)";
			}
			if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("4")){
				at_value4 = at_value4 + "(친환경차 개소세 감면후)";
			}
			
			if(cpd_bean.getDlv_st().equals("2")){
				at_value6 = AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt());
			}
			
			//List<String> fieldList2 = Arrays.asList(at_value1, at_value2, at_value3, at_value4, at_value5, at_value6);
			List<String> fieldList2 = Arrays.asList(at_value0, at_value1, at_value2, at_value3, at_value4, at_value5, at_value6);
			
			String at_msg = "납기단축가능(계약취소) 차량 안내해 드립니다.\n\n 차명: " + at_value1 + "\n 사양: " + at_value2 + "\n 색상: " + at_value3 + "\n 차량가격: " + at_value4 + "\n 계약등록일: " + at_value5 + "\n 배정(예정일): " + at_value6 + "\n\n협력업체관리 > 자체출고관리 > 신차취소현황 에서 확인 가능합니다.";
			
			//담당자 리스트
			Vector users = c_db.getUserList("", "", "loan_st", "Y");
			int user_size = users.size();
			for(int i = 0 ; i < user_size ; i++){
				Hashtable user = (Hashtable)users.elementAt(i);
				at_destphone = String.valueOf(user.get("USER_M_TEL"));
				at_db.sendMessageReserve("acar0219", fieldList2, at_destphone, "02-392-4242", null , rent_l_cd,  com_con_no);
				//at_db.sendMessageReserve("acar0146", fieldList2, at_destphone, "02-392-4242", null , rent_l_cd,  com_con_no);
				//at_db.sendMessage(1009, "0", at_msg, at_destphone, "02-392-4243", null,  rent_l_cd, ck_acar_id );
			}
			//신차 전기차는 전기차관련담당자(함윤원)에게 메시지 발송
			if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("3")){
				at_destphone = target_bean3.getUser_m_tel();
				at_db.sendMessageReserve("acar0219", fieldList2, at_destphone, "02-392-4242", null , rent_l_cd,  com_con_no);
				//at_db.sendMessageReserve("acar0146", fieldList2, at_destphone, "02-392-4242", null , rent_l_cd,  com_con_no);
				//at_db.sendMessage(1009, "0", at_msg, at_destphone, "02-392-4243", null,  rent_l_cd, ck_acar_id );
			}
			//신차 수소차는 전기차관련담당자(함윤원)에게 메시지 발송
			if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("4")){
				at_destphone = target_bean3.getUser_m_tel();
				at_db.sendMessageReserve("acar0219", fieldList2, at_destphone, "02-392-4242", null , rent_l_cd,  com_con_no);
				//at_db.sendMessageReserve("acar0146", fieldList2, at_destphone, "02-392-4242", null , rent_l_cd,  com_con_no);
				//at_db.sendMessage(1009, "0", at_msg, at_destphone, "02-392-4243", null,  rent_l_cd, ck_acar_id );
			}
		}
	}
	
	//계약해지
	if(cng_item.equals("cls5")){
	
		//변경계약
		Vector vt = cod.getCarPurComCngs(rent_mng_id, rent_l_cd, com_con_no);
		int vt_size = vt.size();		
		
		for(int i = 0 ; i < vt_size ; i++){
	    	Hashtable ht = (Hashtable)vt.elementAt(i);
	    	if(String.valueOf(ht.get("CNG_ST")).equals("2")){
	    		if(String.valueOf(ht.get("CNG_DT")).equals("")){
	    			//신차취소현황으로가기 해지등록분 반영처리
						CarPurDocListBean cng_bean2 = cod.getCarPurComCng(rent_mng_id, rent_l_cd, com_con_no, String.valueOf(ht.get("SEQ")));					
						cng_bean2.setCng_cont		("납품취소");	
						cng_bean2.setBigo				("고객요청");	
						cng_bean2.setReg_id			(user_id);
						flag1 = cod.updateCarPurComCngSucN(cng_bean2);	
	    		}
	    	}
    	}		
	
		cpd_bean.setSuc_yn	("N");	
		flag2 = cod.updateCarPurCom(cpd_bean);
		
	}	
		
	//재배정요청
	if(cng_item.equals("re")){
	
		CarPurDocListBean cng_bean = new CarPurDocListBean();
		
		int next_seq = cod.getCarPurComCngNextSeq(rent_mng_id, rent_l_cd, com_con_no);
		
		cng_bean.setRent_mng_id		(rent_mng_id);
		cng_bean.setRent_l_cd		(rent_l_cd);
		cng_bean.setCom_con_no		(com_con_no);
		cng_bean.setSeq			(next_seq);
		cng_bean.setCng_st		("3");	
		cng_bean.setCng_cont		(request.getParameter("cng_cont")	==null?"":request.getParameter("cng_cont"));	
		cng_bean.setBigo		(request.getParameter("bigo")		==null?"":request.getParameter("bigo"));	
		cng_bean.setReq_dt		(request.getParameter("pur_req_dt")	==null?"":request.getParameter("pur_req_dt"));
		cng_bean.setReg_id		(user_id);
	
		flag1 = cod.insertCarPurComCng(cng_bean);		
	
		//변경상태
		cpd_bean.setUse_yn		("C");
		cpd_bean.setDlv_st		("1");	
		cpd_bean.setReg_id		(user_id);	
		flag2 = cod.updateCarPurCom(cpd_bean);
		
		if(!cng_bean.getReq_dt().equals("")){
			//car_pur
			ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
			pur.setPur_req_dt	(request.getParameter("pur_req_dt")	==null?"":request.getParameter("pur_req_dt"));
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
		}
	}		
		
	//출고배정
	if(cng_item.equals("con")){
	
		cpd_bean.setDlv_st		("2");	
		cpd_bean.setDlv_con_dt		(request.getParameter("dlv_con_dt")	==null?"":request.getParameter("dlv_con_dt"));	
		cpd_bean.setDlv_ext		(request.getParameter("dlv_ext")	==null?"":request.getParameter("dlv_ext"));			
		cpd_bean.setUdt_st		(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));	
		cpd_bean.setUdt_firm		(request.getParameter("udt_firm")	==null?"":request.getParameter("udt_firm"));	
		cpd_bean.setUdt_addr		(request.getParameter("udt_addr")	==null?"":request.getParameter("udt_addr"));		
		cpd_bean.setUdt_mng_id		(request.getParameter("udt_mng_id")	==null?"":request.getParameter("udt_mng_id"));	
		cpd_bean.setUdt_mng_nm		(request.getParameter("udt_mng_nm")	==null?"":request.getParameter("udt_mng_nm"));	
		cpd_bean.setUdt_mng_tel		(request.getParameter("udt_mng_tel")	==null?"":request.getParameter("udt_mng_tel"));	
		cpd_bean.setCons_amt		(request.getParameter("cons_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt")));
		cpd_bean.setReg_id		(user_id);
		
		if(cpd_bean.getDlv_ext().equals("") || cpd_bean.getDlv_ext().equals("other")){
			cpd_bean.setDlv_ext	(request.getParameter("dlv_ext_sub")	==null?"":request.getParameter("dlv_ext_sub"));			
		}
		
		flag1 = cod.updateCarPurCom(cpd_bean);
		
		msg_yn = "Y";
		
		sub 	= "계출관리 자동차납품 출고배정";
		cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 출고배정 ("+cpd_bean.getDlv_con_dt()+")";

		//계약담당자에게 문자발송
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		String sendphone 	= sender_bean.getUser_m_tel();
		String sendname 	= "(주)아마존카 "+sender_bean.getUser_nm();
		String destphone 	= target_bean.getUser_m_tel();
		String destname 	= target_bean.getUser_nm();
		String msg_cont		= cont;
		
		//에이전트 실의뢰자한테 요청
		if(target_bean.getDept_id().equals("1000") && !base.getAgent_emp_id().equals("")){
			CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
			destname 	= a_coe_bean.getEmp_nm();
			destphone = a_coe_bean.getEmp_m_tel();
		}
		
		//20211217 신차취소현황상태이면 메시지 발송하지 않는다.
		if(cpd_bean.getUse_yn().equals("N") && cpd_bean.getSuc_yn().equals("D")){
			
		}else{	
			at_db.sendMessage(1009, "0", msg_cont, destphone, "02-392-4243", null,  base.getRent_l_cd(), ck_acar_id );
		}	
		
	}	
	
	//배정후 변경사항
	if(cng_item.equals("cng2")){
	
		if(!cpd_bean.getUse_yn().equals("N")){
			//배정관리		
			CarPurDocListBean o_cpd_bean = cod.getCarPurCom(rent_mng_id, rent_l_cd, com_con_no);
		
			CarPurDocListBean cng_bean = cpd_bean;
			
			cpd_bean.setDlv_dt		(request.getParameter("dlv_dt")		==null?"":request.getParameter("dlv_dt"));	
			cpd_bean.setUdt_st		(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));	
			cpd_bean.setUdt_firm		(request.getParameter("udt_firm")	==null?"":request.getParameter("udt_firm"));	
			cpd_bean.setUdt_addr		(request.getParameter("udt_addr")	==null?"":request.getParameter("udt_addr"));		
			cpd_bean.setUdt_mng_id		(request.getParameter("udt_mng_id")	==null?"":request.getParameter("udt_mng_id"));	
			cpd_bean.setUdt_mng_nm		(request.getParameter("udt_mng_nm")	==null?"":request.getParameter("udt_mng_nm"));	
			cpd_bean.setUdt_mng_tel		(request.getParameter("udt_mng_tel")	==null?"":request.getParameter("udt_mng_tel"));	
			cpd_bean.setCons_amt		(request.getParameter("cons_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt")));
		
			String cng_cau = "";

			if(!AddUtil.replace(o_cpd_bean.getDlv_con_dt(),"-","").equals(AddUtil.replace(cpd_bean.getDlv_dt(),"-",""))){  
				cng_cau = cng_cau + " 출고일자 변경 ("+o_cpd_bean.getDlv_con_dt()+"->"+cpd_bean.getDlv_dt()+")  \n\n "; 
			}
			if(!AddUtil.replace(o_cpd_bean.getUdt_st()," ","").equals(AddUtil.replace(cpd_bean.getUdt_st()," ",""))){  
				cng_cau = cng_cau + " 배달지-구분 변경 ("+c_db.getNameByIdCode("0035", "", o_cpd_bean.getUdt_st())+"->"+c_db.getNameByIdCode("0035", "", cpd_bean.getUdt_st())+")  \n\n "; 
			}			
			if(!AddUtil.replace(o_cpd_bean.getUdt_firm()," ","").equals(AddUtil.replace(cpd_bean.getUdt_firm()," ",""))){  
				cng_cau = cng_cau + " 배달지-지점/상호 변경 ("+o_cpd_bean.getUdt_firm()+"->"+cpd_bean.getUdt_firm()+")  \n\n "; 
			}
			/*
			if(!AddUtil.replace(o_cpd_bean.getUdt_addr()," ","").equals(AddUtil.replace(cpd_bean.getUdt_addr()," ",""))){  
				cng_cau = cng_cau + " 배달지-주소 변경 ("+o_cpd_bean.getUdt_addr()+"->"+cpd_bean.getUdt_addr()+")  \n\n "; 
			}
			if(!AddUtil.replace(o_cpd_bean.getUdt_mng_nm()," ","").equals(AddUtil.replace(cpd_bean.getUdt_mng_nm()," ",""))){  
				cng_cau = cng_cau + " 배달지-담당자 변경 ("+o_cpd_bean.getUdt_mng_nm()+"->"+cpd_bean.getUdt_mng_nm()+")  \n\n "; 
			}
			if(!AddUtil.replace(o_cpd_bean.getUdt_mng_tel()," ","").equals(AddUtil.replace(cpd_bean.getUdt_mng_tel()," ",""))){  
				cng_cau = cng_cau + " 배달지-연락처 변경 ("+o_cpd_bean.getUdt_mng_tel()+"->"+cpd_bean.getUdt_mng_tel()+")  \n\n "; 
			}
			*/
			if(o_cpd_bean.getCons_amt() > cpd_bean.getCons_amt() || o_cpd_bean.getCons_amt() < cpd_bean.getCons_amt()){  
				cng_cau = cng_cau + " 배달탁송료 ("+o_cpd_bean.getCons_amt()+"->"+cpd_bean.getCons_amt()+")  \n\n "; 
			}
		
			int next_seq = cod.getCarPurComCngNextSeq(rent_mng_id, rent_l_cd, com_con_no);
		
			cng_bean.setSeq			(next_seq);
			cng_bean.setCng_st		("4");	
			cng_bean.setCng_cont		("배정후변경");	
			cng_bean.setBigo		(cng_cau);	
			cng_bean.setReg_id		(user_id);
									
			flag1 = cod.insertCarPurComCng(cng_bean);		
	
			//변경상태
			cpd_bean.setUse_yn		("C");							
			cpd_bean.setReg_id		(user_id);
			flag2 = cod.updateCarPurCom(cpd_bean);
		
			//바로 변경반영
			//cng_bean.setCng_id		(user_id);		
			//flag1 = cod.updateCarPurComCngAct(cng_bean);
		}	
		
	}
	
	//배정취소
	if(cng_item.equals("cls3")){
	
		CarPurDocListBean cng_bean = new CarPurDocListBean();
		
		int next_seq = cod.getCarPurComCngNextSeq(rent_mng_id, rent_l_cd, com_con_no);
		
		cng_bean.setRent_mng_id		(rent_mng_id);
		cng_bean.setRent_l_cd		(rent_l_cd);
		cng_bean.setCom_con_no		(com_con_no);
		cng_bean.setSeq			(next_seq);
		cng_bean.setCng_st		("4");	
		cng_bean.setCng_cont		(request.getParameter("cng_cont")	==null?"":request.getParameter("cng_cont"));	
		cng_bean.setBigo		(request.getParameter("bigo")		==null?"":request.getParameter("bigo"));	
		cng_bean.setReg_id		(user_id);
									
		flag1 = cod.insertCarPurComCng(cng_bean);		
	
		//변경상태
		cpd_bean.setUse_yn		("C");					
		cpd_bean.setDlv_st		("1");					
		cpd_bean.setDlv_con_dt		("");		
		cpd_bean.setReg_id		(user_id);
		flag2 = cod.updateCarPurCom(cpd_bean);
		
		//바로 변경반영
		//cng_bean.setCng_id		(user_id);		
		//flag1 = cod.updateCarPurComCngAct(cng_bean);			
		
		String cont_use_yn = request.getParameter("cont_use_yn")==null?"":request.getParameter("cont_use_yn");
		
		//아마존카단계일때 처리
		if(cont_use_yn.equals("N") && base.getClient_id().equals("000228") && !base.getCar_st().equals("2")){
			base.setUse_yn("N");
			//=====[cont] update=====
			flag3 = a_db.updateContBaseNew(base);
		}
	}	
	
	//출고
	if(cng_item.equals("settle")){
		
		cpd_bean.setDlv_dt		(request.getParameter("dlv_dt")		==null?"":request.getParameter("dlv_dt"));			
		cpd_bean.setSettle_id		(user_id);	
		
		flag1 = cod.updateCarPurComDlv(cpd_bean);

	}	
	
	//출고일자수정
	if(cng_item.equals("dlv_dt")){
		
		cpd_bean.setDlv_dt		(request.getParameter("dlv_dt")		==null?"":request.getParameter("dlv_dt"));					

		flag1 = cod.updateCarPurCom(cpd_bean);
				
	}	
		
	//계약번호 변경
	if(cng_item.equals("com_con_no")){
	
		String o_com_con_no = request.getParameter("o_com_con_no")==null?"":request.getParameter("o_com_con_no");
		String n_com_con_no = request.getParameter("n_com_con_no")==null?"":request.getParameter("n_com_con_no");
		
		//변경계약이 있는지 확인
		Vector vt = cod.getCarPurComCngs(rent_mng_id, rent_l_cd, o_com_con_no);
		int vt_size = vt.size();
		
		if(!o_com_con_no.equals(n_com_con_no)){
		
			flag1 = cod.updateCarPurComConNoCase1(rent_l_cd, o_com_con_no, n_com_con_no);
			
			if(flag1)	com_con_no = n_com_con_no;
			
			if(vt_size>0){
				flag1 = cod.updateCarPurComConNoCase2(rent_l_cd, o_com_con_no, n_com_con_no);
			}
		}
	
	}
	
	//주문차처리
	if(cng_item.equals("order_req")){
	
		cpd_bean.setOrder_req_id	(user_id);
	
		flag1 = cod.updateCarPurComOrderReq(cpd_bean);
		
		msg_yn = "";
		
		sub 	= "계출관리 자동차납품 주문차 고객확인";
		cont 	= "[ "+rent_l_cd+" "+cpd_bean.getCom_con_no()+" "+request.getParameter("firm_nm")+" "+cm_bean.getCar_nm()+" ] 계출관리 자동차납품 주문차 고객확인이 완료되었습니다. 진행하여 주십시오.";
		
	}	
	
	//주문차처리
	if(cng_item.equals("order_chk")){
	
		cpd_bean.setOrder_chk_id	(user_id);
	
		flag1 = cod.updateCarPurComOrderChk(cpd_bean);
		
		msg_yn = "";
		
	}		
	
	//해지취소후 부활
	if(cng_item.equals("revival")){
	
		CarPurDocListBean cng_bean = cod.getCarPurComCng(rent_mng_id, rent_l_cd, com_con_no, seq);
		
		flag1 = cod.deleteCarPurComCng(cng_bean);		
	
		//변경상태
		cpd_bean.setUse_yn		("C");
		cpd_bean.setSuc_yn		("");
		flag2 = cod.updateCarPurCom(cpd_bean);
		
		msg_yn = "";
		
	}			
	
	
	

	if(msg_yn.equals("Y")){
			
		//쿨메신저 메세지 전송------------------------------------------------------------------------------------------
				
		String url 	= "/fms2/pur_com/lc_rent_c.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|com_con_no="+com_con_no;
		String m_url = "/fms2/pur_com/lc_rent_frame.jsp";
						
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";	 
 						
		//20211217 신차취소현황상태이면 메시지 발송하지 않는다. - 전기차담당자한테만 발송
		if(cpd_bean.getUse_yn().equals("N") && cpd_bean.getSuc_yn().equals("D")){
			xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
		}else if(cpd_bean.getUse_yn().equals("N") && cpd_bean.getSuc_yn().equals("N")){
			xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
		}else{
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			
			if(target2_yn.equals("Y")){
				xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			}
			
			//신차 전기차는 전기차관련담당자(함윤원)에게 메시지 발송
			if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("3")){
				xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
			}
			//신차 수소차는 전기차관련담당자(함윤원)에게 메시지 발송
			if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("4")){
				xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
			}			
		}
		
		
		xml_data += "    <SENDER></SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		System.out.println("쿨메신저(계출관리)"+cont+"-----------------------"+target_bean.getUser_nm());
			
		flag2 = cm_db.insertCoolMsg(msg);
		
		if(!cng_item.equals("con")){
			//계약담당자에게 문자발송
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			String sendphone 	= sender_bean.getUser_m_tel();
			String sendname 	= "(주)아마존카 "+sender_bean.getUser_nm();
			String destphone 	= target_bean.getUser_m_tel();
			String destname 	= target_bean.getUser_nm();
			String msg_cont		= cont;
				
			//에이전트 실의뢰자한테 요청
			if(target_bean.getDept_id().equals("1000") && !base.getAgent_emp_id().equals("")){
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
				destname 	= a_coe_bean.getEmp_nm();
				destphone = a_coe_bean.getEmp_m_tel();
			}
				
			if(cpd_bean.getUse_yn().equals("N") && cpd_bean.getSuc_yn().equals("D")){
			}else if(cpd_bean.getUse_yn().equals("N") && cpd_bean.getSuc_yn().equals("N")){				
			}else{
				at_db.sendMessage(1009, "0", msg_cont, destphone, "02-392-4243", null,  base.getRent_l_cd(), ck_acar_id );
			}	
		}
	}

%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계출관리 처리 에러입니다.\n\n확인하십시오');		<%}%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'> 
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='from_page'	   value='<%=from_page%>'>   
  <input type='hidden' name='rent_mng_id'  value='<%=rent_mng_id%>'>  
  <input type='hidden' name='rent_l_cd'	   value='<%=rent_l_cd%>'> 
  <input type='hidden' name="com_con_no"   value="<%=com_con_no%>">  
</form>
<script language='javascript'>
	<%if(flag1){%>
			alert('처리되었습니다.');
	<%}%>
	<%if(cng_item.equals("cng_act") || cng_item.equals("cls_act") || cng_item.equals("re_act")){%>
	<%}else{%>
			parent.self.close();
	<%}%>	
	var fm = document.form1;	
	fm.action = 'lc_rent_c.jsp';
	fm.target = 'd_content';
	fm.submit();	
</script>
</body>
</html>