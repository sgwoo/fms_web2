<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.coolmsg.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.tint.*, acar.doc_settle.*, acar.car_sche.*, acar.consignment.*, acar.client.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" scope="page" class="acar.car_mst.CarMstBean"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

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
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
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
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//영업소
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean sender_bean 	= umd.getUsersBean(base.getBus_id());
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	String o_reg_est_dt = car.getReg_est_dt();
	
	
	//자동차기본정보
	cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차종변수
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//특판계출관리
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);	
	
%>


<%
	//1. 신차대여정보 fee-----------------------------------------------------------------------------------------
	
	String pp_st		= request.getParameter("pp_st")==null?"":request.getParameter("pp_st");
	String rent_est_dt 	= request.getParameter("rent_est_dt")==null?"":request.getParameter("rent_est_dt");
	String rent_est_h 	= request.getParameter("rent_est_h")==null?"":request.getParameter("rent_est_h");
	
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	if(pp_st.equals("미결")){
		fee.setPp_est_dt	(request.getParameter("pp_est_dt")==null?"":request.getParameter("pp_est_dt"));
		fee.setPp_etc		(request.getParameter("pp_etc")==null?"":request.getParameter("pp_etc"));
	}
	fee.setRent_est_dt		(rent_est_dt+rent_est_h);
	fee.setGrt_suc_yn		(request.getParameter("grt_suc_yn")==null?"":request.getParameter("grt_suc_yn"));
	//=====[fee] update=====
	flag1 = a_db.updateContFeeNew(fee);
	
	
	//2. 보증보험정보 gua_ins--------------------------------------------------------------------------------------
	
	String gi_st		 	= request.getParameter("gi_st")==null?"":request.getParameter("gi_st");
	
	if(gi_st.equals("미결")){
		ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
		gins.setGi_est_dt	(request.getParameter("gi_est_dt")==null?"":request.getParameter("gi_est_dt"));
		gins.setGi_etc		(request.getParameter("gi_etc")==null?"":request.getParameter("gi_etc"));
		//=====[gua_ins] update=====
		flag2 = a_db.updateGiInsNew(gins);
	}
	
	
	//3. 연대보증인정보 cont_gur--------------------------------------------------------------------------------------
	
	String guar_end_st		 = request.getParameter("guar_end_st")==null?"":request.getParameter("guar_end_st");
	
	if(!guar_end_st.equals("")){
		//cont_etc
		ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		//관리지점,영업대리인
		cont_etc.setGuar_end_st	(request.getParameter("guar_end_st")==null?"":request.getParameter("guar_end_st"));
		cont_etc.setGuar_est_dt	(request.getParameter("guar_est_dt")==null?"":request.getParameter("guar_est_dt"));
		cont_etc.setGuar_etc	(request.getParameter("guar_etc")==null?"":request.getParameter("guar_etc"));
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag3 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag3 = a_db.updateContEtc(cont_etc);
		}
	}
	
	
	//4. 출고정보 car_pur--------------------------------------------------------------------------------------
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	String o_udt_st = pur.getUdt_st();
	
	String dlv_est_dt 	= request.getParameter("dlv_est_dt")==null?"":request.getParameter("dlv_est_dt");
	String dlv_est_h 	= request.getParameter("dlv_est_h")==null?"":request.getParameter("dlv_est_h");
	
	pur.setDlv_brch		(request.getParameter("dlv_brch")	==null?"":request.getParameter("dlv_brch"));
	pur.setRpt_no		(request.getParameter("rpt_no")		==null?"":request.getParameter("rpt_no"));
	pur.setDlv_est_dt	(dlv_est_dt+dlv_est_h);
	pur.setCon_amt		(request.getParameter("con_amt").equals("")		?0:AddUtil.parseDigit(request.getParameter("con_amt")));
	pur.setTrf_amt5		(request.getParameter("trf_amt5").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt5")));
	pur.setTrf_amt1		(request.getParameter("jan_amt").equals("")		?0:AddUtil.parseDigit(request.getParameter("jan_amt")));
	pur.setPur_est_dt	(request.getParameter("pur_est_dt")	==null?"":request.getParameter("pur_est_dt"));
	//신규칼럼
	pur.setDlv_ext		(request.getParameter("dlv_ext")	==null?"":request.getParameter("dlv_ext"));
	pur.setUdt_st		(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));
	pur.setUdt_est_dt	(request.getParameter("udt_est_dt")	==null?"":request.getParameter("udt_est_dt"));
	pur.setCons_st		(request.getParameter("cons_st")	==null?"":request.getParameter("cons_st"));
	pur.setOff_id		(request.getParameter("off_id")		==null?"":request.getParameter("off_id"));
	pur.setOff_nm		(request.getParameter("off_nm")		==null?"":request.getParameter("off_nm"));
	pur.setCons_amt1	(request.getParameter("cons_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt1")));
	pur.setCons_amt2	(request.getParameter("cons_amt2").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt2")));
	pur.setJan_amt		(request.getParameter("jan_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("jan_amt")));
	pur.setCon_est_dt	(request.getParameter("con_est_dt")	==null?"":request.getParameter("con_est_dt"));
	pur.setRent_ext		(request.getParameter("rent_ext")	==null?"":request.getParameter("rent_ext"));
	pur.setCar_num		(request.getParameter("car_num")	==null?"":request.getParameter("car_num"));
	pur.setCon_amt_cont	(request.getParameter("con_amt_cont")	==null?"":request.getParameter("con_amt_cont"));
	pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
	pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
	pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
	pur.setCom_tint		(request.getParameter("com_tint")	==null?"":request.getParameter("com_tint"));
	pur.setCom_film_st	(request.getParameter("com_film_st")	==null?"":request.getParameter("com_film_st"));
	pur.setCon_pay_dt	(request.getParameter("con_pay_dt")	==null?"":request.getParameter("con_pay_dt"));
	pur.setTrf_st0		(request.getParameter("trf_st0")	==null?"":request.getParameter("trf_st0"));
	pur.setAcc_st0		(request.getParameter("acc_st0")	==null?"":request.getParameter("acc_st0"));
	
	//=====[CAR_PUR] update=====
	flag4 = a_db.updateContPur(pur);
	

	
	String n_udt_st = pur.getUdt_st();
	
	String o_udt_st_nm = c_db.getNameByIdCode("0035", "", o_udt_st);
	String n_udt_st_nm = c_db.getNameByIdCode("0035", "", n_udt_st);
	
	//차량인수지 변경시 계약변경관리에게 메시지 발송
	if(!o_udt_st.equals("") && !o_udt_st.equals(n_udt_st)){
		if(base.getUse_yn().equals("Y")){
			
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String sub2 		= "장기계약 차량인수지 변동";
			String cont2 	= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" ]  &lt;br&gt; &lt;br&gt;  장기계약의 차량인수지가 ("+o_udt_st_nm+" -> "+n_udt_st_nm+") 변동하였습니다. &lt;br&gt; &lt;br&gt;  확인바랍니다.";
			String target_id2 = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
			
			
			CarScheBean cs_bean7 = csd.getCarScheTodayBean(target_id2);
			if(!cs_bean7.getUser_id().equals("")){
				if(cs_bean7.getTitle().equals("오전반휴")){
					//등록시간이 오전(12시전)이라면 대체자, 아니면 본인
					target_id2 = nm_db.getWorkAuthUser("엑셀견적관리자");
				}else if(cs_bean7.getTitle().equals("오후반휴")){
					//등록시간이 오후(12시이후)라면 대체자, 아니면 본인
					target_id2 = nm_db.getWorkAuthUser("엑셀견적관리자");
				}else{//연차
					target_id2 = nm_db.getWorkAuthUser("엑셀견적관리자");
				}
			}
			
			//사용자 정보 조회
			UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub2+"</SUB>"+
		  				"    <CONT>"+cont2+"</CONT>"+
 						"    <URL></URL>";
			xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			xml_data2 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
			
			flag5 = cm_db.insertCoolMsg(msg2);
			System.out.println("쿨메신저("+rent_l_cd+" "+request.getParameter("firm_nm")+" [차량대금기안등록] 계약 차량인수지 변동)-----------------------"+target_bean2.getUser_nm());
		}
	}	
	
	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장관리"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산지점장"));
	UsersBean udt_mng_bean_b2	= umd.getUsersBean(nm_db.getWorkAuthUser("부산주차장관리"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("대전지점장"));
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("대구지점장"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("광주지점장"));
		
	String udt_mng_id 	= "";
 	String udt_mng_nm 	= "";
  String udt_mng_tel 	= "";
  String udt_firm 	= "";    	
 	String udt_addr 	= "";  
 	if(pur.getUdt_st().equals("1")){
  	udt_mng_id 	= udt_mng_bean_s.getUser_id();
		udt_mng_nm 	= udt_mng_bean_s.getDept_nm()+" "+udt_mng_bean_s.getUser_nm()+" "+udt_mng_bean_s.getUser_pos();  		
  	udt_mng_tel 	= udt_mng_bean_s.getHot_tel();
		udt_firm 	= "영등포 영남주차장"; 
  	udt_addr 	= "서울시 영등포구 영등포로 34길 9";   
	}else if(pur.getUdt_st().equals("2")){
	  	udt_mng_id 	= udt_mng_bean_b2.getUser_id();
  		udt_mng_nm 	= udt_mng_bean_b2.getDept_nm()+" "+udt_mng_bean_b2.getUser_nm()+" "+udt_mng_bean_b2.getUser_pos(); 
	  	udt_mng_tel 	= udt_mng_bean_b2.getHot_tel();
	  	udt_firm 	= "조양골프연습장 주차장"; 
  		udt_addr 	= "부산광역시 연제구 연산4동 585-1";
  		//20210204 이사
  		if(AddUtil.getDate2(4) >= 20210205){
  			udt_firm 	= "스마일TS"; 
  			udt_addr 	= "부산시 연제구 안연로7번나길 10(연산동 363-13번지)";
  		}
	}else if(pur.getUdt_st().equals("3")){
	  udt_mng_id 	= udt_mng_bean_d.getUser_id();
  	udt_mng_nm 	= udt_mng_bean_d.getDept_nm()+" "+udt_mng_bean_d.getUser_nm()+" "+udt_mng_bean_d.getUser_pos(); 
	  udt_mng_tel 	= udt_mng_bean_d.getHot_tel();
	  udt_firm 	= "미성테크"; 
  	udt_addr 	= "대전광역시 유성구 온천북로59번길 10(봉명동 690-3)";     	
  }else if(pur.getUdt_st().equals("5")){
	  udt_mng_id 	= udt_mng_bean_g.getUser_id();
  	udt_mng_nm 	= udt_mng_bean_g.getDept_nm()+" "+udt_mng_bean_g.getUser_nm()+" "+udt_mng_bean_g.getUser_pos(); 
	  udt_mng_tel 	= udt_mng_bean_g.getHot_tel();
	  udt_firm 	= "대구지점"; 
  	udt_addr 	= "대구광역시 달서구 호산동 708-5 유일빌딩 303호";     	
  }else if(pur.getUdt_st().equals("6")){
	  udt_mng_id 	= udt_mng_bean_j.getUser_id();
  	udt_mng_nm 	= udt_mng_bean_j.getDept_nm()+" "+udt_mng_bean_j.getUser_nm()+" "+udt_mng_bean_j.getUser_pos(); 
	  udt_mng_tel 	= udt_mng_bean_j.getHot_tel();
	  udt_firm 	= "용용이자동차용품점"; 
  	udt_addr 	= "광주광역시 광산구 상무대로 233 (송정동 1360)";     	
  }else if(pur.getUdt_st().equals("4")){
	  udt_mng_id 	= client.getClient_id();
  	udt_mng_nm 	= client.getCon_agnt_dept()+" "+client.getCon_agnt_nm()+" "+client.getCon_agnt_title();
	  udt_mng_tel 	= client.getO_tel();
	  udt_firm 	= client.getFirm_nm(); 
  	udt_addr 	= client.getO_addr();     	
  }
  
	if(!o_udt_st.equals(n_udt_st) && !o_udt_st_nm.equals(n_udt_st_nm)){
	
		CarPurDocListBean cpd_bean = cod.getCarPurCom(rent_mng_id, rent_l_cd, pur.getRpt_no());
		
		if(!cpd_bean.getCom_con_no().equals("")){ // && !cpd_bean.getUdt_st().equals(n_udt_st)
		  String o_udt_firm = cpd_bean.getUdt_firm(); 
			cpd_bean.setUdt_st			(n_udt_st);	
			cpd_bean.setUdt_firm		(udt_firm);	
			cpd_bean.setUdt_addr		(udt_addr);		
			cpd_bean.setUdt_mng_id		(udt_mng_id);	
			cpd_bean.setUdt_mng_nm		(udt_mng_nm);	
			cpd_bean.setUdt_mng_tel		(udt_mng_tel);	
			flag1 = cod.updateCarPurCom(cpd_bean);
			
			int cng_next_seq = cod.getCarPurComCngNextSeq(rent_mng_id, rent_l_cd, cpd_bean.getCom_con_no());

			CarPurDocListBean cng_bean = new CarPurDocListBean();
			cng_bean.setRent_mng_id	(rent_mng_id);
			cng_bean.setRent_l_cd		(rent_l_cd);
			cng_bean.setCom_con_no		(cpd_bean.getCom_con_no());
			cng_bean.setSeq				(cng_next_seq);
			cng_bean.setCng_st			("1");	
			cng_bean.setCng_cont		("배달지");	
			cng_bean.setBigo			(o_udt_st_nm+"->"+n_udt_st_nm);	
			cng_bean.setReg_id			(user_id);
			flag1 = cod.insertCarPurComCng(cng_bean);
		}
	}    
	
	//자체-배달탁송
	if(pur.getCons_st().equals("2")){
		//기존 배달탁송 등록이 있는지 확인
		ConsignmentBean cons = cs_db.getConsignmentPur(rent_mng_id, rent_l_cd);
		if(cons.getUdt_mng_nm().equals("")){
			cons.setUdt_mng_id		(udt_mng_id);
			cons.setUdt_mng_nm		(udt_mng_nm);
			cons.setUdt_mng_tel		(udt_mng_tel);
			cons.setUdt_firm		(udt_firm);
			cons.setUdt_addr		(udt_addr);			
		}
			
		//신규입력이면
		if(cons.getRent_l_cd().equals("")){
	
			//탁송의뢰등록	
			String cons_no	 	= "";		
	
			cons.setRent_mng_id		(rent_mng_id);
			cons.setRent_l_cd		(rent_l_cd);
			cons.setReq_id			(base.getBus_id());
			cons.setReg_id			(user_id);
		
			//=====[consignment] insert=====
			cons_no = cs_db.insertConsignmentPur(cons);		
			
			
			//법인판매팀 03900 이 아니면 확정 메시지 발송 (탁송업체)
			if(!emp2.getCar_off_id().equals("03900")){
				
				//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			
				String sub2 	= "영업소-배달탁송확정";
				String cont2 	= "["+pur.getRpt_no()+"] 영업소출고 배달탁송 확정합니다.";
				String url2 	= "/fms2/cons_pur/consp_mng_frame.jsp";
			
			
				//사용자 정보 조회
				UsersBean target_bean3 	=  new UsersBean();
			
				String target_id3 = "";
			
				if(pur.getOff_id().equals("007751")){
					target_id3 = "000187";					
				}
				if(pur.getOff_id().equals("009026")){
					target_id3 = "000222";					
				}
				if(pur.getOff_id().equals("009771")){
					target_id3 = "000240";					
				}
				if(pur.getOff_id().equals("011372")){
					target_id3 = "000308";
				}
			
				if(!target_id3.equals("")){
				
					target_bean3 	= umd.getUsersBean(target_id3);
			
					String xml_data2 = "";
					xml_data2 =  "<COOLMSG>"+
  						"<ALERTMSG>"+
	  					"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+sub2+"</SUB>"+
  						"    <CONT>"+cont2+"</CONT>"+
	 					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url2+"</URL>";
		
					xml_data2 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
			
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
		
					flag2 = cm_db.insertCoolMsg(msg2);	
					System.out.println("쿨메신저(차량대금기안전-배달탁송확정)("+rent_l_cd+" "+request.getParameter("firm_nm")+" -----------------------"+target_bean3.getUser_nm());				
								
				}
			
				cons.setCons_no			(cons_no);
				cons.setSettle_id		(ck_acar_id);	
				boolean cons_flag = cs_db.updateConsignmentPurSettle(cons);				
			}			
			
		}else{
		
			//=====[CONS_PUR] update=====
			flag4 = cs_db.updateConsignmentPur(cons);
			
			//법인판매팀 03900 이 아니면 확정 메시지 발송 (탁송업체)
			if(!emp2.getCar_off_id().equals("03900") && cons.getSettle_id().equals("")){
		
				//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			
				String sub2 	= "영업소-배달탁송확정";
				String cont2 	= "["+pur.getRpt_no()+"] 영업소출고 배달탁송 확정합니다.";
				String url2 	= "/fms2/cons_pur/consp_mng_frame.jsp";
				
			
				//사용자 정보 조회
				UsersBean target_bean3 	=  new UsersBean();
				
				String target_id3 = "";
			
				if(pur.getOff_id().equals("007751")){
					target_id3 = "000187";
				}
				if(pur.getOff_id().equals("009026")){
					target_id3 = "000222";
				}
				if(pur.getOff_id().equals("009771")){
					target_id3 = "000240";
				}
				if(pur.getOff_id().equals("011372")){
					target_id3 = "000308";
				}
			
				if(!target_id3.equals("")){
			
					target_bean3 	= umd.getUsersBean(target_id3);
			
					String xml_data2 = "";
					xml_data2 =  "<COOLMSG>"+
  						"<ALERTMSG>"+
	  					"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub2+"</SUB>"+
						"    <CONT>"+cont2+"</CONT>"+
	 					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url2+"</URL>";
		
					xml_data2 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
			
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
		
					flag2 = cm_db.insertCoolMsg(msg2);	
					System.out.println("쿨메신저(차량대금기안전-배달탁송확정)("+rent_l_cd+" "+request.getParameter("firm_nm")+" -----------------------"+target_bean3.getUser_nm());				
								
				}
			
				cons.setSettle_id		(ck_acar_id);	
				
				boolean cons_flag = cs_db.updateConsignmentPurSettle(cons);
					
			}				

			if(!o_udt_st.equals(n_udt_st)){
		
				ConsignmentBean cng_bean = new ConsignmentBean();
		
				int next_seq = cs_db.getConsPurCngNextSeq(cons.getCons_no());
		
				cng_bean.setCons_no		(cons.getCons_no());
				cng_bean.setSeq			(next_seq);			
				cng_bean.setCng_st		("1");			
				cng_bean.setReg_id		(user_id);
			
				//=====[CONS_PUR_CNT] insert=====				
				flag1 = cs_db.insertConsignmentPurCng(cng_bean);			
			}					
			
		}
	}	
	
		
	//5. 차량기본정보 car_etc-----------------------------------------------------------------------------------------------
	
	
	int o_car_amt = car.getCar_fs_amt()+car.getCar_fv_amt()+car.getDc_cs_amt()+car.getDc_cv_amt();
	
	String reg_est_dt 	= request.getParameter("reg_est_dt")==null?"":request.getParameter("reg_est_dt");
	String reg_est_h 	= request.getParameter("reg_est_h")==null?"":request.getParameter("reg_est_h");
	
	car.setReg_est_dt	(reg_est_dt+reg_est_h);
	car.setSd_cs_amt	(request.getParameter("sd_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cs_amt")));
	car.setSd_cv_amt	(request.getParameter("sd_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cv_amt")));
	car.setDc_cs_amt	(request.getParameter("dc_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("dc_cs_amt")));
	car.setDc_cv_amt	(request.getParameter("dc_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("dc_cv_amt")));
	car.setS_dc1_amt	(request.getParameter("s_dc1_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc1_amt")));
	car.setS_dc2_amt	(request.getParameter("s_dc2_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc2_amt")));
	car.setS_dc3_amt	(request.getParameter("s_dc3_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc3_amt")));
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
	car.setCar_ext		(request.getParameter("car_ext")	==null?"":request.getParameter("car_ext"));
	
	String n_reg_est_dt = reg_est_dt+reg_est_h;
	
	//=====[car_etc] update=====
	flag5 = a_db.updateContCarNew(car);
	
	
	
	
	int n_car_amt = car.getCar_fs_amt()+car.getCar_fv_amt()+car.getDc_cs_amt()+car.getDc_cv_amt();
	
	if(!emp2.getCar_off_id().equals("03900") && (o_car_amt < n_car_amt || o_car_amt > n_car_amt)){
		//금액변동이 있었음->영업팀장에게 메시지 전달
		
			
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String sub2 		= "장기계약 차가변동";
			String cont2 	= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" ] 장기계약의 차량금액이 변동하였습니다. 확인바랍니다.";
			String target_id2 = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
			
			
			CarScheBean cs_bean7 = csd.getCarScheTodayBean(target_id2);
			if(!cs_bean7.getUser_id().equals("")){
				target_id2 = nm_db.getWorkAuthUser("엑셀견적관리자");

			}
			
			//사용자 정보 조회
			UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub2+"</SUB>"+
		  				"    <CONT>"+cont2+"</CONT>"+
 						"    <URL></URL>";
			xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			xml_data2 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
			
			if((o_car_amt-n_car_amt) > 10000 || (o_car_amt-n_car_amt) < -10000){							
				flag5 = cm_db.insertCoolMsg(msg2);			
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
	
	
	//9. 계약기타정보 cont_etc-----------------------------------------------------------------------------------------------
		
		//cont_etc
		ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		//관리지점,영업대리인
		cont_etc.setGrt_suc_m_id	(request.getParameter("grt_suc_m_id")	==null?"":request.getParameter("grt_suc_m_id"));
		cont_etc.setGrt_suc_l_cd	(request.getParameter("grt_suc_l_cd")	==null?"":request.getParameter("grt_suc_l_cd"));
		cont_etc.setGrt_suc_c_no	(request.getParameter("grt_suc_c_no")	==null?"":request.getParameter("grt_suc_c_no"));
		cont_etc.setGrt_suc_o_amt	(request.getParameter("grt_suc_o_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_o_amt")));
		cont_etc.setGrt_suc_r_amt	(request.getParameter("grt_suc_r_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_r_amt")));
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag9 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag9 = a_db.updateContEtc(cont_etc);
		}
	
	

	
	//6. 문서처리전 등록-------------------------------------------------------------------------------------------
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String sub 		= "차량대금 지출 품의";
	String cont 	= "["+firm_nm+"] 차량대금 지출을 요청합니다.";
	
	DocSettleBean doc = new DocSettleBean();
	doc.setDoc_st("4");
	doc.setDoc_id(rent_l_cd);
	doc.setSub(sub);
	doc.setCont(cont);
	doc.setEtc("");
	doc.setUser_nm1("기안자");
	doc.setUser_nm2("지점장");
	doc.setUser_nm3("출고관리자");
	doc.setUser_nm4("회계관리자");
	doc.setUser_nm5("총무과장");
	doc.setUser_id1(base.getBus_id());
	doc.setDoc_bit("1");
	
	System.out.println("쿨메신저(차량대금기안)-----------------------"+br_id);
	
	String user_id2 = "";
	String user_id3 = nm_db.getWorkAuthUser("출고관리자");
	String user_id4 = "XXXXXX";
	String user_id5 = nm_db.getWorkAuthUser("본사총무팀장");
	
	//20130708 총무팀장 결재 변경
	user_id5 = nm_db.getWorkAuthUser("대출관리자");
	
	//20180928 지점장 결재 생략
	user_id2 = "XXXXXX";
	
	CarScheBean cs_bean3 = csd.getCarScheTodayBean(user_id3);
	CarScheBean cs_bean5 = csd.getCarScheTodayBean(user_id5);
	
	doc.setUser_id2(user_id2);
	doc.setUser_id3(user_id3);
	doc.setUser_id4(user_id4);
	doc.setUser_id5(user_id5);
		
	//=====[doc_settle] insert=====
	//20180822 등록후 기안
	doc.setDoc_step("0");
	doc.setDoc_bit("0");	
	
	//중복체크
	DocSettleBean doc_chk = d_db.getDocSettleCommi("4", rent_l_cd);
	
	if(doc_chk.getDoc_no().equals("")){
		flag6 = d_db.insertDocSettle2(doc);
	}	
	
	
	//7. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
	String url 		= "/agent/car_pur/pur_doc_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
	
	//사용자 정보 조회 - 본사는 김태우씨, 지점은 지점장 걸친 후 김태우씨
	String target_id = doc.getUser_id3();
	
	CarScheBean cs_bean6 = csd.getCarScheTodayBean(target_id);
	if(!cs_bean6.getUser_id().equals("")){
		if(cs_bean6.getWork_id().equals("")){
			target_id = nm_db.getWorkAuthUser("출고관리자");	//출고관리자
		}else{
			target_id = cs_bean6.getWork_id(); 					//업무대체자
		}
	}
	
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"    <BACKIMG>4</BACKIMG>"+
  				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
  				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	
	//받는사람
	xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	
	//보낸사람
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
	
	//flag7 = cm_db.insertCoolMsg(msg);	
	//System.out.println("쿨메신저(차량대금기안)"+firm_nm+"-----------------------"+target_bean.getUser_nm());
	
	
	//에이전트 계약시 영업담당자에게도 안내
	if(base.getBus_st().equals("7")){

		sub 	= "에이전트계약 차량대금 지출 품의";
		cont 	= "에이전트계약 ["+firm_nm+" "+rent_l_cd+"] 차량대금 지출을 요청하니 업무에 참고하시기 바랍니다.";
		
		UsersBean target_bean2 	= umd.getUsersBean(base.getBus_id2());
	
		String xml_data2 = "";
		xml_data2 =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"    <BACKIMG>4</BACKIMG>"+
  				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
  				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	
		//받는사람
		xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
	
		//보낸사람
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
	
		flag7 = cm_db.insertCoolMsg(msg2);	
		System.out.println("쿨메신저(에이전트계약 차량대금기안)"+firm_nm+"-----------------------"+target_bean.getUser_nm());
	}
	
	//신차 전기차는 전기차관련담당자(함윤원)에게 메시지 발송
	if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("3")){
			
					UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("증차담당"));	
					
					String xml_data2 = "";
					xml_data2 =  "<COOLMSG>"+
		  						"<ALERTMSG>"+
  								"    <BACKIMG>4</BACKIMG>"+
  								"    <MSGTYPE>104</MSGTYPE>"+
	  							"    <SUB>전기차 차량대금기안등록</SUB>"+
			  					"    <CONT>전기차 차량대금지급요청 문서가 등록되었습니다.  &lt;br&gt; &lt;br&gt; "+cm_bean.getCar_comp_nm()+"  &lt;br&gt; &lt;br&gt; "+cm_bean.getCar_nm()+" "+cm_bean.getCar_name()+"  &lt;br&gt; &lt;br&gt; "+rent_l_cd+" </CONT>"+
 								"    <URL></URL>";
					xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
					xml_data2 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  								"    <MSGICON>10</MSGICON>"+
  								"    <MSGSAVE>1</MSGSAVE>"+
	  							"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  					"    <FLDTYPE>1</FLDTYPE>"+
  								"  </ALERTMSG>"+
  								
	  							"</COOLMSG>";
			
					CdAlertBean msg2 = new CdAlertBean();
					msg2.setFlddata(xml_data2);
					msg2.setFldtype("1");
			
					flag7 = cm_db.insertCoolMsg(msg2);
	}
	//신차 수소차는 전기차관련담당자(함윤원)에게 메시지 발송
	if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("4")){
			
					UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("증차담당"));	
					
					String xml_data2 = "";
					xml_data2 =  "<COOLMSG>"+
		  						"<ALERTMSG>"+
  								"    <BACKIMG>4</BACKIMG>"+
  								"    <MSGTYPE>104</MSGTYPE>"+
	  							"    <SUB>수소차 차량대금기안등록</SUB>"+
			  					"    <CONT>수소차 차량대금지급요청 문서가 등록되었습니다. &lt;br&gt; &lt;br&gt;  "+cm_bean.getCar_comp_nm()+" &lt;br&gt; &lt;br&gt;  "+cm_bean.getCar_nm()+" "+cm_bean.getCar_name()+" &lt;br&gt; &lt;br&gt;  "+rent_l_cd+" </CONT>"+
 								"    <URL></URL>";
					xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
					xml_data2 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  								"    <MSGICON>10</MSGICON>"+
  								"    <MSGSAVE>1</MSGSAVE>"+
	  							"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  					"    <FLDTYPE>1</FLDTYPE>"+
  								"  </ALERTMSG>"+
  								
	  							"</COOLMSG>";
			
					CdAlertBean msg2 = new CdAlertBean();
					msg2.setFlddata(xml_data2);
					msg2.setFldtype("1");
			
					flag7 = cm_db.insertCoolMsg(msg2);
	}	
	
	//대전,대구 인수지는 차량등록예정일이 넣을때 보험담당자에게 메시지를 보낸다.
	if((pur.getUdt_st().equals("3")||pur.getUdt_st().equals("5")) && !AddUtil.replace(n_reg_est_dt,"-","").equals(AddUtil.replace(o_reg_est_dt,"-",""))){
		//메시지발송 프로시저 호출
		String  d_flag2 =  ec_db.call_sp_message_send("msg", "대전,대구인수지 차량등록예정일 보험담당자 통보", rent_mng_id, rent_l_cd, ck_acar_id);
	}	
		
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('선수금 미결사유 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag2){	%>	alert('보증금 미결사유 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag3){	%>	alert('연대보증 미결사유 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag4){	%>	alert('출고정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
<%		if(!flag5){	%>	alert('차량정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
<%		if(!flag6){	%>	alert('문서품의서 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag7){	%>	alert('쿨메신저 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>     
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>   
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>
	var fm = document.form1;	
	alert('차량대금지급요청이 등록되었습니다. 등록내용 확인후 기안자 결재하십시오.');
	fm.action = 'pur_doc_u.jsp';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>