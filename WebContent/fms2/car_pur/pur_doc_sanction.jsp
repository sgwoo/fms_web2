<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.consignment.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
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
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	int result = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	UsersBean user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//특판계출관리
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);	
	
	
	String o_udt_st = pur.getUdt_st();
	
	pur.setUdt_st			(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));

	if(doc_bit.equals("4")){
		//0. 출고정보 car_pur--------------------------------------------------------------------------------------
		pur.setTrf_amt1		(request.getParameter("trf_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt1")));
		pur.setTrf_amt2		(request.getParameter("trf_amt2").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt2")));
		pur.setTrf_amt3		(request.getParameter("trf_amt3").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt3")));
		pur.setTrf_amt4		(request.getParameter("trf_amt4").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt4")));
		pur.setTrf_st1		(request.getParameter("trf_st1")	==null?"":request.getParameter("trf_st1"));
		pur.setTrf_st2		(request.getParameter("trf_st2")	==null?"":request.getParameter("trf_st2"));
		pur.setTrf_st3		(request.getParameter("trf_st3")	==null?"":request.getParameter("trf_st3"));
		pur.setTrf_st4		(request.getParameter("trf_st4")	==null?"":request.getParameter("trf_st4"));
		pur.setCard_kind1	(request.getParameter("card_kind1")	==null?"":request.getParameter("card_kind1"));
		pur.setCard_kind2	(request.getParameter("card_kind2")	==null?"":request.getParameter("card_kind2"));
		pur.setCard_kind3	(request.getParameter("card_kind3")	==null?"":request.getParameter("card_kind3"));
		pur.setCard_kind4	(request.getParameter("card_kind4")	==null?"":request.getParameter("card_kind4"));
		pur.setCardno1		(request.getParameter("cardno1")	==null?"":request.getParameter("cardno1"));
		pur.setCardno2		(request.getParameter("cardno2")	==null?"":request.getParameter("cardno2"));
		pur.setCardno3		(request.getParameter("cardno3")	==null?"":request.getParameter("cardno3"));
		pur.setCardno4		(request.getParameter("cardno4")	==null?"":request.getParameter("cardno4"));
		pur.setTrf_cont1	(request.getParameter("trf_cont1")	==null?"":request.getParameter("trf_cont1"));
		pur.setTrf_cont2	(request.getParameter("trf_cont2")	==null?"":request.getParameter("trf_cont2"));
		pur.setTrf_cont3	(request.getParameter("trf_cont3")	==null?"":request.getParameter("trf_cont3"));
		pur.setTrf_cont4	(request.getParameter("trf_cont4")	==null?"":request.getParameter("trf_cont4"));
		pur.setPur_est_dt	(request.getParameter("pur_est_dt")	==null?"":request.getParameter("pur_est_dt"));
		pur.setAcc_st1		(request.getParameter("acc_st1")	==null?"":request.getParameter("acc_st1"));
		pur.setAcc_st2		(request.getParameter("acc_st2")	==null?"":request.getParameter("acc_st2"));
		pur.setAcc_st3		(request.getParameter("acc_st3")	==null?"":request.getParameter("acc_st3"));
		pur.setAcc_st4		(request.getParameter("acc_st4")	==null?"":request.getParameter("acc_st4"));
		pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
		pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
		pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
		pur.setAcq_cng_yn	(request.getParameter("acq_cng_yn")	==null?"":request.getParameter("acq_cng_yn"));
		pur.setCpt_cd		(request.getParameter("cpt_cd")		==null?"":request.getParameter("cpt_cd"));
		pur.setCom_tint		(request.getParameter("com_tint")	==null?"":request.getParameter("com_tint"));
		pur.setCom_film_st	(request.getParameter("com_film_st")==null?"":request.getParameter("com_film_st"));
		pur.setTrf_st0		(request.getParameter("trf_st0")	==null?"":request.getParameter("trf_st0"));
	}
	//=====[CAR_PUR] update=====
	flag3 = a_db.updateContPur(pur);
	
	//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------
	
	//=====[doc_settle] update=====
	
	String doc_step = "2";
	
		
	if(doc_bit.equals("1")){
		 doc_step = "1";
		 doc.setDoc_bit("2");
	} 
		
	//총무팀장 결재이면 문서 결재 완료
	if(doc_bit.equals("5")) doc_step = "3";
	
	
	flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
	
	
	
	//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String sub 		= "차량대금 결재 요청";
	String cont 	= "["+firm_nm+"] 차량대금 지출을 요청합니다.";
	String url 		= "/fms2/car_pur/pur_doc_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
	String target_id = "";
	String m_url = "/fms2/car_pur/pur_doc_frame.jsp";
	
	//다음결재자 target_id
	
	if(doc_bit.equals("1"))	target_id = doc.getUser_id3();				//출고관리자
	if(doc_bit.equals("2"))	target_id = doc.getUser_id3();				//출고관리자
	if(doc_bit.equals("3"))	target_id = doc.getUser_id5();				//회계관리
	if(doc_bit.equals("4"))	target_id = doc.getUser_id5();				//총무팀장
	if(doc_bit.equals("5"))	target_id = nm_db.getWorkAuthUser("출고관리자");	//차량대금지급처리
	
	//본사는 회계관리 생략하고 총무팀장으로 넘어간다. (출고관리와 회계관리가 같으므로) 20131001 회계관리자 모두 생략
	if(doc_bit.equals("3")){// && user_bean.getBr_nm().equals("본사")
		doc_bit 	= "4";
		target_id 	= doc.getUser_id5();
	}
	
	
	CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
	if(!cs_bean.getUser_id().equals("")){
		if(!cs_bean.getWork_id().equals("")){
		 	target_id = cs_bean.getWork_id();
			//문서결재자도 변경
			//=====[doc_settle] update=====
			if(doc_bit.equals("3"))	flag4 = d_db.updateDocSettleUserCng(doc_no, "4", target_id);//회계관리
			if(doc_bit.equals("4"))	flag4 = d_db.updateDocSettleUserCng(doc_no, "5", target_id);//총무팀장
		}else{
			if(doc_bit.equals("4") && target_id.equals(nm_db.getWorkAuthUser("본사총무팀장"))) 		target_id = nm_db.getWorkAuthUser("본사영업팀장"); 			//총무팀장 : 총무팀장 휴가시 본사영업팀장 결재
 			if(doc_bit.equals("5") && target_id.equals(nm_db.getWorkAuthUser("출고관리자")))		target_id = nm_db.getWorkAuthUser("계약서류점검담당자");	//차량대금지급처리 : 출고관리자 휴가시 계약서류점검담당자 처리
		}
	}
	
	
	if(doc_bit.equals("5")){
		sub 	= "차량대금 결재 완결";
		cont 	= "차량대금 지출을 결재 완결하니 출금 집행하세요";
		url 	= "/fms2/car_pur/pur_pay_frame.jsp";
		m_url = "/fms2/car_pur/pur_pay_frame.jsp";
	}
	
	//사용자 정보 조회
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
	
	flag2 = cm_db.insertCoolMsg(msg);
	
	System.out.println("쿨메신저(차량대금결재)"+firm_nm+", doc_bit="+doc_bit+"-----------------------"+target_bean.getUser_nm());


	String n_udt_st = pur.getUdt_st();
	
	String o_udt_st_nm = c_db.getNameByIdCode("0035", "", o_udt_st);
	String n_udt_st_nm = c_db.getNameByIdCode("0035", "", n_udt_st);
		
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
  	udt_firm 	= "대구 썬팅집"; 
 		udt_addr 	= "대구광역시 달서구 신당동 321-86";  
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
 	
	//배정관리		
	CarPurDocListBean cpd_bean = cod.getCarPurCom(rent_mng_id, rent_l_cd, pur.getRpt_no());
			
	System.out.println("특판계출관리 여부 car_pur_com.rent_l_cd="+cpd_bean.getRent_l_cd()+"-----------------------");
		
	if(!cpd_bean.getRent_l_cd().equals("")){
		
		if(!o_udt_st.equals(n_udt_st) && !o_udt_st_nm.equals(n_udt_st_nm)){
			if(!cpd_bean.getCom_con_no().equals("")){ // && !cpd_bean.getUdt_st().equals(n_udt_st)
			  String o_udt_firm = cpd_bean.getUdt_firm(); 
				cpd_bean.setUdt_st			(n_udt_st);	
				cpd_bean.setUdt_firm		(udt_firm);	
				cpd_bean.setUdt_addr		(udt_addr);		
				cpd_bean.setUdt_mng_id	(udt_mng_id);	
				cpd_bean.setUdt_mng_nm	(udt_mng_nm);	
				cpd_bean.setUdt_mng_tel	(udt_mng_tel);	
				flag1 = cod.updateCarPurCom(cpd_bean);
				int cng_next_seq = cod.getCarPurComCngNextSeq(rent_mng_id, rent_l_cd, cpd_bean.getCom_con_no());
				CarPurDocListBean cng_bean = new CarPurDocListBean();
				cng_bean.setRent_mng_id	(rent_mng_id);
				cng_bean.setRent_l_cd		(rent_l_cd);
				cng_bean.setCom_con_no	(cpd_bean.getCom_con_no());
				cng_bean.setSeq					(cng_next_seq);
				cng_bean.setCng_st			("1");	
				cng_bean.setCng_cont		("배달지");	
				cng_bean.setBigo				(o_udt_st_nm+"->"+n_udt_st_nm);	
				cng_bean.setReg_id			(user_id);
				flag1 = cod.insertCarPurComCng(cng_bean);
			}
		}   	
	}	
 	
	//특판처리
	if(doc_bit.equals("5")){
	
		String com_con_no 	= "";
		String dlv_est_dt 	= request.getParameter("dlv_est_dt")==null?"":request.getParameter("dlv_est_dt");
		
		if(dlv_est_dt.equals("")) dlv_est_dt 	= request.getParameter("udt_est_dt")==null?"":request.getParameter("udt_est_dt");
		
		//기존 배달탁송 등록이 있는지 확인
		ConsignmentBean cons = cs_db.getConsignmentPur(rent_mng_id, rent_l_cd);
		
		//자체-배달탁송
		if(pur.getCons_st().equals("2") && !pur.getOff_id().equals("")){
 			if(!cons.getUdt_firm().equals(udt_firm)){
				cons.setUdt_mng_id		(udt_mng_id);
				cons.setUdt_mng_nm		(udt_mng_nm);
				cons.setUdt_mng_tel		(udt_mng_tel);
				cons.setUdt_firm			(udt_firm);
				cons.setUdt_addr			(udt_addr);
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
				cons.setCons_no(cons_no);
			}else{
				//=====[CONS_PUR] update=====
				flag4 = cs_db.updateConsignmentPur(cons);
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
			if(cons.getSettle_dt().equals("")){
				cons.setSettle_id		(user_id);	
				boolean cons_flag = cs_db.updateConsignmentPurSettle(cons);
			}
			//사용자 정보 조회
			UsersBean target_bean3 	=  new UsersBean();
			String target_id3 = "";
			if(pur.getOff_id().equals("007751")){				target_id3 = "000187";			}
			if(pur.getOff_id().equals("009026")){				target_id3 = "000222";			}
			if(pur.getOff_id().equals("009771")){				target_id3 = "000240";			}
			if(pur.getOff_id().equals("011372")){				target_id3 = "000308";			}
			if(!target_id3.equals("") && pur.getDlv_brch().equals("B2B사업운영팀")){
				target_bean3 	= umd.getUsersBean(target_id3);
				sub 	= "차량대금결재-배달탁송확정";
				cont 	= "["+pur.getRpt_no()+"] 차량대금 지출을 결재 완결되어 배달탁송 확정합니다.";
				url 	= "/fms2/cons_pur/consp_mng_frame.jsp";
				String xml_data2 = "";
				xml_data2 =  "<COOLMSG>"+
  					"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
  					"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
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
				System.out.println("쿨메신저(차량대금결재-배달탁송확정)"+firm_nm+", doc_bit="+doc_bit+"-----------------------"+target_bean3.getUser_nm());						
			}
		}	
		

		if(!cpd_bean.getRent_l_cd().equals("")){	
			cpd_bean.setDlv_dt			(dlv_est_dt);	
			cpd_bean.setSettle_id		(user_id);	
			boolean pur_flag = cod.updateCarPurComDlv(cpd_bean);
	
			System.out.println("확정처리 updateCarPurComDlv()-----------------------dlv_est_dt = "+dlv_est_dt);
								
			UsersBean target_bean2 	= umd.getUsersBean(String.valueOf(pur_com.get("CAR_OFF_USER_ID")));
							
			if(!target_bean2.getUser_id().equals("")){
				UsersBean sender_bean2 	= umd.getUsersBean(doc.getUser_id3());
				String sendphone 	= sender_bean2.getUser_m_tel();
				String sendname 	= "(주)아마존카 "+sender_bean2.getUser_nm();
				String destphone 	= target_bean2.getUser_m_tel();
				String destname 	= target_bean2.getUser_nm();
				String msg_cont		= "차량대금 지급요청("+pur.getRpt_no()+") 완료, 확정현황 확인후 출고바랍니다.-아마존카-";
				IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", msg_cont);
			}		
		}		
				
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'> 
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>      
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='flag1'	 		    value='<%=flag1%>'>     
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	fm.action = 'pur_doc_u.jsp';
	fm.target = 'd_content';
	<%if(doc_bit.equals("3") || doc_bit.equals("5")){%>
	//fm.action = 'pur_doc_c.jsp';
	fm.action = 'pur_doc_frame.jsp';
	<%}%>
	fm.submit();
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>