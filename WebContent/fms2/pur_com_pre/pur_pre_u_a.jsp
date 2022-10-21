<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, acar.car_office.*, acar.user_mng.*, acar.estimate_mng.*, acar.coolmsg.*, acar.cont.*, acar.car_mst.*, acar.client.*, acar.common.*"%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
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
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String opt1 		= request.getParameter("opt1")		==null?"":request.getParameter("opt1");
	String opt2 		= request.getParameter("opt2")		==null?"":request.getParameter("opt2");
	String opt3 		= request.getParameter("opt3")		==null?"":request.getParameter("opt3");
	String opt4 		= request.getParameter("opt4")		==null?"":request.getParameter("opt4");
	String opt5 		= request.getParameter("opt5")		==null?"":request.getParameter("opt5");
	String opt6 		= request.getParameter("opt6")		==null?"":request.getParameter("opt6");
	String opt7 		= request.getParameter("opt7")		==null?"":request.getParameter("opt7");
	String e_opt1 		= request.getParameter("e_opt1")	==null?"":request.getParameter("e_opt1");
	String e_opt2 		= request.getParameter("e_opt2")	==null?"":request.getParameter("e_opt2");
	String e_opt3 		= request.getParameter("e_opt3")	==null?"":request.getParameter("e_opt3");
	String e_opt4 		= request.getParameter("e_opt4")	==null?"":request.getParameter("e_opt4");
	String e_opt5 		= request.getParameter("e_opt5")	==null?"":request.getParameter("e_opt5");
	String e_opt6 		= request.getParameter("e_opt6")	==null?"":request.getParameter("e_opt6");
	String e_opt7 		= request.getParameter("e_opt7")	==null?"":request.getParameter("e_opt7");
	String ready_car	= request.getParameter("ready_car")	==null?"":request.getParameter("ready_car");
	String eco_yn 	= request.getParameter("eco_yn")	==null?"":request.getParameter("eco_yn");

	
	String seq 			= request.getParameter("seq")		==null?"":request.getParameter("seq");
	String r_seq 		= request.getParameter("r_seq")		==null?"":request.getParameter("r_seq");
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");
	String cng_item 	= request.getParameter("cng_item")	==null?"":request.getParameter("cng_item");


	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag4 = true;
	
	int result = 0;
	
	String msg_yn = "N"; 
	String target2_yn = "N"; 
	String sub 	= "";
	String cont 	= "";
	String jg_g_7 = "";
	
	String cont_udt_auto_cng_yn = "";
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	CarOffPreBean bean = cop_db.getCarOffPreSeq(seq);
	
	if(!r_seq.equals("")){
		bean = cop_db.getCarOffPreSeq(seq, r_seq);
	}
	
	//int temp_idx = bean.getReq_dt().indexOf(".");
    //String req_dt = bean.getReq_dt().substring(0, temp_idx);
    
    bean.setReq_dt(bean.getReq_dt());
	
	//계출번호 변경
	if(cng_item.equals("com_con_no")){
	
		String o_com_con_no = request.getParameter("o_com_con_no")==null?"":request.getParameter("o_com_con_no");
		String n_com_con_no = request.getParameter("n_com_con_no")==null?"":request.getParameter("n_com_con_no");
		
		String etc = bean.getEtc();
		
		if(!etc.equals("")) etc = etc+" ";
		
		etc = etc +"구계출번호="+o_com_con_no;
		
		bean.setCom_con_no	(n_com_con_no);
		bean.setEtc	(etc);
		
		//update
		flag1 = cop_db.updateCarOffPre(bean);
		
	}else if(cng_item.equals("req")){
		
		String o_req_dt = request.getParameter("o_req_dt")==null?"":request.getParameter("o_req_dt");
		String n_req_dt = request.getParameter("n_req_dt")==null?"":request.getParameter("n_req_dt");
		
		//int idx_num = n_req_dt.indexOf(".");
		//n_req_dt = n_req_dt.substring(0, idx_num);
		
		bean.setReq_dt(n_req_dt);
		
		//update
		flag1 = cop_db.updateCarOffPre(bean);
			
	//차량정보 변경
	}else if(cng_item.equals("car")){
		
		bean.setCar_nm		(request.getParameter("car_nm")		==null?"":request.getParameter("car_nm"));	
		bean.setOpt			(request.getParameter("opt")		==null?"":request.getParameter("opt"));	
		bean.setColo		(request.getParameter("colo")		==null?"":request.getParameter("colo"));	
		bean.setIn_col		(request.getParameter("in_col")		==null?"":request.getParameter("in_col"));	
		bean.setEco_yn		(request.getParameter("eco_yn")		==null?"":request.getParameter("eco_yn"));	
		bean.setCar_amt		(request.getParameter("car_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_amt")));
		bean.setCon_amt		(request.getParameter("con_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("con_amt")));
		bean.setDlv_est_dt	(request.getParameter("dlv_est_dt")	==null?"":request.getParameter("dlv_est_dt"));	
		bean.setCon_pay_dt	(request.getParameter("con_pay_dt")	==null?"":request.getParameter("con_pay_dt"));	
		bean.setEtc			(request.getParameter("etc")		==null?"":request.getParameter("etc"));	
		bean.setGarnish_col	(request.getParameter("garnish_col")==null?"":request.getParameter("garnish_col"));
		bean.setAgent_view_yn(request.getParameter("agent_view_yn")==null?"N":request.getParameter("agent_view_yn"));
		bean.setBus_self_yn	(request.getParameter("bus_self_yn")==null?"N":request.getParameter("bus_self_yn"));
		
		bean.setCon_bank	(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
		bean.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
		bean.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
		bean.setCon_est_dt	(request.getParameter("con_est_dt")	==null?"":request.getParameter("con_est_dt"));
		bean.setTrf_st0		(request.getParameter("trf_st0")	==null?"":request.getParameter("trf_st0"));
		bean.setAcc_st0		(request.getParameter("acc_st0")	==null?"":request.getParameter("acc_st0"));
		
		//update
		flag1 = cop_db.updateCarOffPre(bean);

		
		String o_q_reg_dt = request.getParameter("o_q_reg_dt")==null?"":request.getParameter("o_q_reg_dt");
		String q_reg_dt = request.getParameter("q_reg_dt")==null?"N":request.getParameter("q_reg_dt");
		
		bean.setQ_reg_dt	(q_reg_dt);
		
		//변경일때 Q코드등록일
		if(o_q_reg_dt.equals("") && q_reg_dt.equals("Y")){
			flag1 = cop_db.updateCarOffPreQ(bean);
		}
		if(!o_q_reg_dt.equals("") && q_reg_dt.equals("N")){
			flag1 = cop_db.updateCarOffPreQ(bean);
		}
		
		
	//예약자 수정
	}else if(cng_item.equals("res_u")){
		
		bean.setBus_nm		(request.getParameter("bus_nm")		==null?"":request.getParameter("bus_nm"));	
		bean.setFirm_nm		(request.getParameter("firm_nm")	==null?"":request.getParameter("firm_nm"));	
		bean.setAddr		(request.getParameter("addr")		==null?"":request.getParameter("addr"));	
		bean.setCust_tel	(request.getParameter("cust_tel")	==null?"":request.getParameter("cust_tel"));	
		bean.setMemo		(request.getParameter("memo")		==null?"":request.getParameter("memo"));	
		bean.setBus_tel		(request.getParameter("bus_tel")	==null?"":request.getParameter("bus_tel"));
		
		//update
		flag1 = cop_db.updateCarOffPreRes(bean);
		
	//예약자 등록
	}else if(cng_item.equals("res_i")){
		//기존 : 여러명 예약가능(reg_dt에 따라 순위존재), 변경: 한 차량에 한명만 예약가능하게 수정. (20190121) --> 2순위까지 허용 20211015 --> 3순위까지 허용 20220901
		int res_cnt = 0;
		int max_r_seq = 0;
		Vector vt = cop_db.getCarOffPreSeqResList(seq);
		if(vt.size() > 0){
			for(int i=0; i<vt.size();i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String cls_dt = String.valueOf(ht.get("CLS_DT"));
				if(cls_dt.equals("")){
					msg_yn = "RESERVE";
					res_cnt++;
				}
				max_r_seq = AddUtil.parseInt(String.valueOf(ht.get("R_SEQ")));
			}
		}
		if(res_cnt < 3){ // && msg_yn.equals("N")
			String res_msg_yn 	= request.getParameter("res_msg_yn")	==null?"":request.getParameter("res_msg_yn");
			String res_msg_yn2 	= request.getParameter("res_msg_yn2")	==null?"":request.getParameter("res_msg_yn2");
			
			msg_yn = res_msg_yn;
			target2_yn = res_msg_yn2;
			
			bean.setBus_nm	(request.getParameter("bus_nm")		==null?"":request.getParameter("bus_nm"));	
			bean.setFirm_nm	(request.getParameter("firm_nm")	==null?"":request.getParameter("firm_nm"));	
			bean.setAddr	(request.getParameter("addr")		==null?"":request.getParameter("addr"));	
			bean.setCust_tel(request.getParameter("cust_tel")	==null?"":request.getParameter("cust_tel"));	
			bean.setMemo	(request.getParameter("memo")		==null?"":request.getParameter("memo"));	
			bean.setReg_id	(ck_acar_id);
			bean.setBus_tel	(request.getParameter("bus_tel")	==null?"":request.getParameter("bus_tel"));
			
			//q코드
			if(!bean.getQ_reg_dt().equals("")){
				bean.setCust_q	("Q");
			}
			
			//insert
			flag1 = cop_db.insertCarOffPreRes(bean);
			
			//1순위 예약인 경우 유효기간 셋팅 프로시저를 실행한다.
			if(res_cnt == 0){
				String d_flag1 = cop_db.call_sp_com_pre_res_dire("i", bean.getSeq(), (max_r_seq+1));
			}	
			
		}
		
		
	//예약자 취소
	}else if(cng_item.equals("res_c")){
		
		
		
		//update
		flag1 = cop_db.updateCarOffPreResCls(bean.getSeq(), AddUtil.parseInt(r_seq));
		
		//사전계약예약 기간 셋팅 프로시저 실행
		String d_flag1 = cop_db.call_sp_com_pre_res_dire("c"+""+user_id, bean.getSeq(), AddUtil.parseInt(r_seq));
		
		
		//취소시 전기차담당자에게 메시지 발송
		msg_yn = "Y";
		target2_yn = "Y";

	//심사완료
	}else if(cng_item.equals("res_conf")){
			
		//update
		flag1 = cop_db.updateCarOffPreResConfirm(bean.getSeq(), AddUtil.parseInt(r_seq));
		
		//취소시 전기차담당자에게 메시지 발송
		msg_yn = "Y";
		

	//사전계약 취소
	}else if(cng_item.equals("cls")){
		
		//update
		flag1 = cop_db.updateCarOffPreCls(bean.getSeq());
		
	//계약연동
	}else if(cng_item.equals("cont")){
		
		String cont_car_yn = request.getParameter("cont_car_yn")==null?"":request.getParameter("cont_car_yn");
		
		bean.setRent_l_cd	(request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd"));	
		
		//계약등록 확인
		Hashtable cont_ht = a_db.getContCase(bean.getRent_l_cd());

		//20190221 컨버전 미처리 : 잘못 입력분 찾을수 없음.
		//if(cont_car_yn.equals("Y")){
			//차량기본정보
			//ContCarBean car 	= a_db.getContCarNew(String.valueOf(cont_ht.get("RENT_MNG_ID")), bean.getRent_l_cd());
			//자동차기본정보
			//CarMstBean cm_bean = cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
			//컨버전
			//bean.setCar_nm			(cm_bean.getCar_nm());	
			//bean.setOpt					(cm_bean.getCar_name()+" "+car.getOpt());	
			//bean.setColo				(car.getColo());	
			//bean.setIn_col			(car.getIn_col());	
			//bean.setCar_amt			(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt());
		//}
		
		//update
		bean.setPre_out_yn("");
		flag1 = cop_db.updateCarOffPre(bean);		
		
		//출고정보
		ContPurBean pur = a_db.getContPur(String.valueOf(cont_ht.get("RENT_MNG_ID")), bean.getRent_l_cd());
		
		//계약금 연동
		if(bean.getCon_amt() >0 && pur.getPur_pay_dt().equals("")){
			if(pur.getCon_amt() == 0){
				pur.setCon_amt		(bean.getCon_amt());
				pur.setCon_pay_dt	(bean.getCon_pay_dt());
				pur.setCon_bank		(bean.getCon_bank());
				pur.setCon_acc_no	(bean.getCon_acc_no());
				pur.setCon_acc_nm	(bean.getCon_acc_nm());
				pur.setTrf_st0		(bean.getTrf_st0());
				pur.setAcc_st0		(bean.getAcc_st0());
				pur.setCon_est_dt	(bean.getCon_est_dt());
			}			
			if(pur.getRpt_no().equals("")){ 
				pur.setRpt_no	(bean.getCom_con_no());
			}	
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
		}
		
		//자체출고점검메시지
		String d_flag2 = cop_db.call_sp_com_pre_sys_cont(bean.getCom_con_no());
		
		//자체출고점검메시지 -> 20220907 call_sp_com_pre_sys_cont 처리와 중복 미사용
		//String d_flag1 = cop_db.call_sp_com_pre_pur_auto(bean.getCom_con_no());
		
		//자체출고관리 여부
		CarPurDocListBean cpd_bean = cod.getCarPurCom(bean.getCom_con_no());
		
		//배달지 변경시 처리 
		if(bean.getCar_off_nm().equals("B2B사업운영팀") || cpd_bean.getCar_off_id().equals("03900")){
			//B2B사업운영팀 : 사전계약관리 화면 하단에 붉은색으로 표시	
		}else{
			//B2B사업운영팀 외(숭실,을지로, 학익, 증산, 총신대) : 배달지(인수지)가 자동변경
			if(!pur.getUdt_st().equals("") && !cpd_bean.getUdt_st().equals("") && !pur.getUdt_st().equals(cpd_bean.getUdt_st())){
				UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장관리"));
				UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산지점장"));
				UsersBean udt_mng_bean_b2	= umd.getUsersBean(nm_db.getWorkAuthUser("부산주차장관리"));
				UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("대전지점장"));
				UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("대구지점장"));
				UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("광주지점장"));
				//고객정보
				ClientBean client = al_db.getNewClient(String.valueOf(cont_ht.get("CLIENT_ID")));
					
				String udt_mng_id 	= "";
			    String udt_mng_nm 	= "";
			  	String udt_mng_tel 	= "";
			  	String udt_firm 	= "";    	
				String udt_addr 	= "";  
				String o_udt_st_nm = c_db.getNameByIdCode("0035", "", cpd_bean.getUdt_st());
				String n_udt_st_nm = c_db.getNameByIdCode("0035", "", pur.getUdt_st());
			 	if(pur.getUdt_st().equals("1")){
				  	udt_mng_id 	= udt_mng_bean_s.getUser_id();
					udt_mng_nm 	= udt_mng_bean_s.getDept_nm()+" "+udt_mng_bean_s.getUser_nm()+" "+udt_mng_bean_s.getUser_pos();  		
			 		udt_mng_tel = udt_mng_bean_s.getHot_tel();
				  	udt_firm 	= "영등포 영남주차장"; 
			 		udt_addr 	= "서울시 영등포구 영등포로 34길 9";   
			  	}else if(pur.getUdt_st().equals("2")){
			  		udt_mng_id 	= udt_mng_bean_b2.getUser_id();
			 		udt_mng_nm 	= udt_mng_bean_b2.getDept_nm()+" "+udt_mng_bean_b2.getUser_nm()+" "+udt_mng_bean_b2.getUser_pos(); 
			  		udt_mng_tel = udt_mng_bean_b2.getHot_tel();
			  		udt_firm 	= "스마일TS"; 
			  		udt_addr 	= "부산시 연제구 안연로7번나길 10(연산동 363-13번지)";			  		  	
			  	}else if(pur.getUdt_st().equals("3")){
			  		udt_mng_id 	= udt_mng_bean_d.getUser_id();
			 		udt_mng_nm 	= udt_mng_bean_d.getDept_nm()+" "+udt_mng_bean_d.getUser_nm()+" "+udt_mng_bean_d.getUser_pos(); 
			  		udt_mng_tel = udt_mng_bean_d.getHot_tel();
			  		udt_firm 	= "미성테크"; 
			 		udt_addr 	= "대전광역시 유성구 온천북로59번길 10(봉명동 690-3)";     	
			  	}else if(pur.getUdt_st().equals("5")){
			  		udt_mng_id 	= udt_mng_bean_g.getUser_id();
			 		udt_mng_nm 	= udt_mng_bean_g.getDept_nm()+" "+udt_mng_bean_g.getUser_nm()+" "+udt_mng_bean_g.getUser_pos(); 
			  		udt_mng_tel = udt_mng_bean_g.getHot_tel();
			  		udt_firm 	= "대구 썬팅집"; 
			 		udt_addr 	= "대구광역시 달서구 신당동 321-86";  
			  	}else if(pur.getUdt_st().equals("6")){
			  		udt_mng_id 	= udt_mng_bean_j.getUser_id();
			 		udt_mng_nm 	= udt_mng_bean_j.getDept_nm()+" "+udt_mng_bean_j.getUser_nm()+" "+udt_mng_bean_j.getUser_pos(); 
			  		udt_mng_tel = udt_mng_bean_j.getHot_tel();
			  		udt_firm 	= "용용이자동차용품점"; 
			 		udt_addr 	= "광주광역시 광산구 상무대로 233 (송정동 1360)";     	
			  	}else if(pur.getUdt_st().equals("4")){
			  		udt_mng_id 	= client.getClient_id();
			 		udt_mng_nm 	= client.getCon_agnt_dept()+" "+client.getCon_agnt_nm()+" "+client.getCon_agnt_title();
			  		udt_mng_tel = client.getO_tel();
			  		udt_firm 	= client.getFirm_nm(); 
			 		udt_addr 	= client.getO_addr();     	
			 	}
			 	
			 	String o_udt_firm = cpd_bean.getUdt_firm(); 
				cpd_bean.setUdt_st			(pur.getUdt_st());	
				cpd_bean.setUdt_firm		(udt_firm);	
				cpd_bean.setUdt_addr		(udt_addr);		
				cpd_bean.setUdt_mng_id		(udt_mng_id);	
				cpd_bean.setUdt_mng_nm		(udt_mng_nm);	
				cpd_bean.setUdt_mng_tel		(udt_mng_tel);	
				flag1 = cod.updateCarPurCom(cpd_bean);
				int cng_next_seq = cod.getCarPurComCngNextSeq(cpd_bean.getRent_mng_id(), cpd_bean.getRent_l_cd(), cpd_bean.getCom_con_no());
				CarPurDocListBean cng_bean = new CarPurDocListBean();
				cng_bean.setRent_mng_id		(cpd_bean.getRent_mng_id());
				cng_bean.setRent_l_cd		(cpd_bean.getRent_l_cd());
				cng_bean.setCom_con_no		(cpd_bean.getCom_con_no());
				cng_bean.setSeq				(cng_next_seq);
				cng_bean.setCng_st			("1");	
				cng_bean.setCng_cont		("배달지");	
				cng_bean.setBigo			(o_udt_st_nm+"->"+n_udt_st_nm+" (사전계약 자동변경)");	
				cng_bean.setReg_id			(user_id);
				flag1 = cod.insertCarPurComCng(cng_bean);
				
				cont_udt_auto_cng_yn = "Y";
				
			}
		}	
		
		
		
	//계약연동 취소
	}else if(cng_item.equals("no_cont")){
		
		
		//계약등록 확인
		Hashtable cont_ht = a_db.getContCase(bean.getRent_l_cd());
		
		//출고정보
		ContPurBean pur = a_db.getContPur(String.valueOf(cont_ht.get("RENT_MNG_ID")), bean.getRent_l_cd());

		//계약금연동 취소
		if(bean.getCon_amt() >0 && bean.getCon_amt() == pur.getCon_amt() && pur.getPur_pay_dt().equals("")){
			pur.setCon_amt		(0);
			pur.setCon_pay_dt	("");
			pur.setCon_bank		("");
			pur.setCon_acc_no	("");
			pur.setCon_acc_nm	("");
			pur.setTrf_st0		("");
			pur.setAcc_st0		("");
			pur.setCon_est_dt	("");
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
		}
		
		
		bean.setRent_l_cd			("");	
		
		//update
		flag1 = cop_db.updateCarOffPre(bean);				
								
	}else if(cng_item.equals("pre_out")){
		
		bean.setPre_out_yn	(request.getParameter("pre_out_yn")	==null?"":request.getParameter("pre_out_yn"));
		//update
		flag1 = cop_db.updatePreOutYn(bean);
	
	//사전계약 취소
	}else if(cng_item.equals("cls_restore")){
		
		//update
		flag1 = cop_db.updateCarOffPreClsRestore(bean.getSeq());
	
	}
	
	//메시지 발송
	if(msg_yn.equals("Y") || target2_yn.equals("Y")){
	

			sub = "사전계약 예약안내";
			cont = "사전계약 예약이 등록되었습니다.  &lt;br&gt; &lt;br&gt;  차명 : "+bean.getCar_nm()+",  &lt;br&gt; &lt;br&gt; 계출번호 : "+bean.getCom_con_no()+",  &lt;br&gt; &lt;br&gt; 예약자 : "+bean.getBus_nm()+",  &lt;br&gt; &lt;br&gt; 고객명 : "+bean.getFirm_nm();
			
			//사용자
			UsersBean target_bean 	= new UsersBean();
			if(!bean.getBus_nm().equals("")){
				target_bean = umd.getUserNmBusBean(bean.getBus_nm());
			}
			
	
			//쿨메신저 메세지 전송------------------------------------------------------------------------------------------
				
			String url 	 = "/fms2/pur_com_pre/pur_pre_c.jsp?seq="+seq;
			String m_url = "/fms2/pur_com_pre/pur_pre_frame.jsp";
			String xml_data = "";
			
			String xml_data_target = "";
 			if(cng_item.equals("res_c")){ 				
				sub = "사전계약 예약취소";
				cont = "사전계약 예약이 취소되었습니다.  &lt;br&gt; &lt;br&gt; 차명 : "+bean.getCar_nm()+",  &lt;br&gt; &lt;br&gt; 계출번호 : "+bean.getCom_con_no()+",  &lt;br&gt; &lt;br&gt; 예약자 : "+bean.getBus_nm()+",  &lt;br&gt; &lt;br&gt; 고객명 : "+bean.getFirm_nm();
 			}else if(cng_item.equals("res_conf")){	
				sub = "사전계약 심사완료";
				cont = "에이전트 사전계약 예약이 심사완료되었습니다.  &lt;br&gt; &lt;br&gt; 차명 : "+bean.getCar_nm()+",  &lt;br&gt; &lt;br&gt; 계출번호 : "+bean.getCom_con_no()+",  &lt;br&gt; &lt;br&gt; 예약자 : "+bean.getBus_nm()+",  &lt;br&gt; &lt;br&gt; 고객명 : "+bean.getFirm_nm();
				UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("에이전트관리"));
				xml_data_target = "    <TARGET>"+target_bean3.getId()+"</TARGET>";
 			}else{
				xml_data_target = "    <TARGET>"+target_bean.getId()+"</TARGET>";
			}
						
			xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";	 
 			
			//신차 전기차는 전기차관련담당자(함윤원)에게 메시지 발송
			if(target2_yn.equals("Y")){
				UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("전기차담당"));
				
				if(!target_bean3.getUser_id().equals(ck_acar_id)){
					xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";					
				}
			}
			
			if(msg_yn.equals("Y")){
				xml_data += xml_data_target;
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
		
			if(!bean.getRent_l_cd().equals("") && !cng_item.equals("res_conf")){
			
				//계약등록 확인
				Hashtable cont_ht = a_db.getContCase(bean.getRent_l_cd());
				
				//계약기본정보
				ContBaseBean base = a_db.getCont(String.valueOf(cont_ht.get("RENT_MNG_ID")), bean.getRent_l_cd());
				
				//에이전트 실의뢰자한테 요청
				if(target_bean.getDept_id().equals("1000") && !base.getAgent_emp_id().equals("")){
							
					UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
					String sendphone 	= sender_bean.getUser_m_tel();
					String sendname 	= "(주)아마존카 "+sender_bean.getUser_nm();
					String msg_cont		= AddUtil.replace(cont,"&lt;br&gt; &lt;br&gt;","\n\n");
					CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
					String destname 	= a_coe_bean.getEmp_nm();
					String destphone = a_coe_bean.getEmp_m_tel();
			
					IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", msg_cont);
				}	
			}
		
	}

%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('사전계약관리 처리 에러입니다.\n\n확인하십시오');		<%}%>		
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
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>   
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='from_page'	   value='<%=from_page%>'>   
  <input type='hidden' name='seq'  value='<%=seq%>'>  
  <input type='hidden' name='opt1' 		value='<%=opt1%>'>
  <input type='hidden' name='opt2' 		value='<%=opt2%>'>
  <input type='hidden' name='opt3' 		value='<%=opt3%>'>
  <input type='hidden' name='opt4' 		value='<%=opt4%>'>
  <input type='hidden' name='opt5' 		value='<%=opt5%>'>
  <input type='hidden' name='opt6' 		value='<%=opt6%>'>
  <input type='hidden' name='opt7' 		value='<%=opt7%>'>
  <input type='hidden' name='e_opt1' 	value='<%=e_opt1%>'>
  <input type='hidden' name='e_opt2' 	value='<%=e_opt2%>'>
  <input type='hidden' name='e_opt3' 	value='<%=e_opt3%>'>
  <input type='hidden' name='e_opt4' 	value='<%=e_opt4%>'>
  <input type='hidden' name='e_opt5' 	value='<%=e_opt5%>'>
  <input type='hidden' name='e_opt6' 	value='<%=e_opt6%>'>
  <input type='hidden' name='e_opt7' 	value='<%=e_opt7%>'>
  <input type='hidden' name='ready_car' value='<%=ready_car%>'>
  <input type='hidden' name='eco_yn' value='<%=eco_yn%>'>
</form>
<script language='javascript'>
<%if(cng_item.equals("res_i")&& msg_yn.equals("RESERVE")){%>
	alert("이미 등록된 예약내역이 있습니다.\n\n페이지를 새로고침 해주세요.");
<%}else{%>
	<%if(flag1){%>
	<%	if(cont_udt_auto_cng_yn.equals("Y")){%>
		alert('배달지(인수지)가 자동변경되었습니다. 대리점과 꼭 통화하여 탁송 인수지 수정요청하셔야 합니다.');
	<%	}else{%>
		alert('처리되었습니다.');
	<%	}%>
	<%}%>
<%}%>
	<%if(cng_item.equals("res_c")){//바로처리%>
	<%}else{%>
	parent.self.close();
	<%}%>	
	var fm = document.form1;	
	fm.action = 'pur_pre_c.jsp';
	fm.target = 'd_content';
	fm.submit();
	
</script>
</body>
</html>