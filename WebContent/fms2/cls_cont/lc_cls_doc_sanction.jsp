<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.credit.*, acar.insur.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*,acar.offls_sui.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="sui_db" scope="page" class="acar.offls_sui.Offls_suiDatabase"/>

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
	
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st"); //업무대여 
	
	String from_page 	= "";
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String reg_id 	= request.getParameter("reg_id")==null?ck_acar_id:request.getParameter("reg_id");	
	String cool 	= request.getParameter("cool")==null?"":request.getParameter("cool");	 //월렌트인경우 메세지 보내기 체크
	int   fdft_amt2 =   request.getParameter("fdft_amt2")==null?0:AddUtil.parseDigit(request.getParameter("fdft_amt2"));	 //월렌트인경우 메세지 보내기 체크 
	String rt	= request.getParameter("rt")==null?"":request.getParameter("rt");	 //real time
			
	String rt_s = "";
	if (rt.equals("Y")) {
		rt_s = " [즉시] ";
	}
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	int result = 0;
	
	int flag =0;
	
	String doc_step  = "";
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();

				
		//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st_r();
		
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {  //월렌트해지인 경우
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	} else {
		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}

	
	int cnt = 0;
	cnt = ac_db.countDocSettleCls(rent_l_cd);
	
	//계약기본정보
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	//수입차여부 
	ContCarBean car	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	String car_origin 	= car.getCar_origin();
	
	
	//문서 결재여부
	String sub = "";
	String cont = "";
	//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------
	//
	if (doc_bit.equals("1")) {  //문서처리전 등록
	
	//	System.out.println(" doc_sanction doc_bit = " + doc_bit + ": doc_no = :" + doc_no + ": rent_l_cd = " + rent_l_cd);
	
		//doc_settle에 저장	
		//2. 문서처리전 등록-------------------------------------------------------------------------------------------
		
		if ( cls_st.equals("8")) {
			sub 		= "매입옵션의뢰";
			cont 	= "[계약번호:"+rent_l_cd+"] 매입옵션 의뢰 합니다.";
		} else if ( cls_st.equals("7")) {
			sub 		= "출고전해지(신차)의뢰";
			cont 	= "[계약번호:"+rent_l_cd+"] 출고전해지(신차) 의뢰 합니다.";
		} else if ( cls_st.equals("10")) {
			sub 		= "개시전해지(재리스)의뢰";
			cont 	= "[계약번호:"+rent_l_cd+"] 개시전해지(재리스) 의뢰 합니다.";	
		} else if ( cls_st.equals("14")) {
			sub 		= "월렌트해지 회계처리의뢰";
			cont 	= "[계약번호:"+rent_l_cd+"] 월렌트 회계처리 의뢰 합니다.";	
		
		} else {
			sub 		= "계약해지정산의뢰";
			cont 	= "[계약번호:"+rent_l_cd+"] 해지정산 의뢰 합니다.";		
		}	
		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st("11");//해지정산의뢰 (중도해지, 계약만료, 매입옵션, 출고전해지(신차))
		doc.setDoc_id(rent_l_cd);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc("");
		doc.setUser_nm1("기안자");
		doc.setUser_nm2("고객지원팀장");
		doc.setUser_nm3("회계담당자"); //채권업무도 같이 처리 -  월렌트인경우는 결재없이 회계처리함.
		doc.setUser_nm4("채권담당자");  //사용 - 20091201
		doc.setUser_nm5("총무팀장");
		
		doc.setUser_id1(reg_id);
		
		String user_id2 = "";
		String user_id3 = "";
		String user_id4 = "";
		String user_id5 = "";
			
		doc.setDoc_bit("1");//수신1단계
		doc.setDoc_step("1");//기안		
	
		user_id2 = "000026";//팀장:000026, 팀장 000006   부산:000053 대전:000052 , 대구: 000054    광주:000020
		user_id3 = nm_db.getWorkAuthUser("해지관리자"); 	
		
		// 월렌트인 경우 
		 if ( cls_st.equals("14") ) {   //월렌트인경우	
			user_id3 =  nm_db.getWorkAuthUser("세금계산서담당자"); 			
		 }
		
		user_id4 = nm_db.getWorkAuthUser("채권관리자"); 
		user_id5 =  "000004";   // nm_db.getWorkAuthUser("본사총무팀장");  // 총무팀장:000004 영업팀장:000005
	//	user_id5 =  "000048";   // nm_db.getWorkAuthUser("본사총무팀장");  // 총무팀장:000004 영업팀장:000005
				
		//출고전해지(신차), 개시전해지(재리스)		
		if ( cls_st.equals("7") ) {
			doc.setUser_nm2("영업팀장");
			user_id2 = "000028"; 	
		} else if (  cls_st.equals("10") ) {
				doc.setUser_nm2("고객지원팀장");
				user_id2 = "000026"; 					
		} else {  //부산,대구는 본사에서  		
			if(br_id.equals("B1") || br_id.equals("U1")){
				doc.setUser_nm2("지점장");
				user_id2 = "000053"; //000053(제인학)
			} else if(br_id.equals("G1")){
				doc.setUser_nm2("지점장");
				user_id2 = "000054"; //000054(윤영탁)
			} else if(br_id.equals("J1")){
				doc.setUser_nm2("지점장");
				user_id2 = "000219"; //000118(이수재)		000219(류선)
			}else if(br_id.equals("D1")){
				doc.setUser_nm2("지점장"); 
				user_id2 = "000052"; //000052(박영규)
			}	
		}	
			    	  	
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);  		
		CarScheBean cs_bean3 = csd.getCarScheTodayBean(user_id3);
		CarScheBean cs_bean4 = csd.getCarScheTodayBean(user_id4);
		CarScheBean cs_bean5 = csd.getCarScheTodayBean(user_id5);
			
		//지점장연차 -> 고객지원팀장, 고객팀장, 영업팀장연차 -> 회계관리자로 		
		if ( cls_st.equals("1") || cls_st.equals("2") || cls_st.equals("8") ) {
			if(!cs_bean2.getWork_id().equals("") ) {
			   if ( user_id2.equals("000052")  || user_id2.equals("000053") || user_id2.equals("000054") || user_id2.equals("000020") ) {
					user_id2 = "000026";
				} else {
					user_id2 = "XXXXXX"; //생략
				}	
			}		
		}
		
				
		if ( cls_st.equals("7") || cls_st.equals("10") ) {
			if(!cs_bean2.getWork_id().equals("")) user_id2 = "XXXXXX"; //생략
		}

	
		if(!cs_bean3.getWork_id().equals("")) user_id3 =  cs_bean3.getWork_id();    // cs_bean3.getWork_id();
		if(!cs_bean4.getWork_id().equals("")) user_id4 =  cs_bean4.getWork_id(); //채권관리자
	//	if(!cs_bean5.getWork_id().equals("")) user_id5 =  cs_bean5.getWork_id(); //총무팀장
		if(!cs_bean5.getWork_id().equals("")) user_id5 = "000048"; //총무팀장	
		 
		 if ( cls_st.equals("14")  )    {   //월렌트 인경우			 			 	
			user_id2 = "XXXXXX"; 	 //생략		
			user_id4 = "XXXXXX"; 	 //생략
			user_id5 = "XXXXXX"; 	 //생략	
		}	
		 	
		 if ( car_st.equals("5")  )    {   // 업무대여 인경우			 			 	
			user_id2 = "000026"; 			
			user_id4 = "XXXXXX"; 	 //생략
			user_id5 = "XXXXXX"; 	 //생략	
		}	
		 	
		//출고전해지(신차), 개시전해지(재리스)	 
		if ( cls_st.equals("7")  ||  cls_st.equals("10") ) {
		  user_id5 = "XXXXXX"; 	 //생략	
		  if (!user_id2.equals("XXXXXX") ){ //생략건이 아니면 
			  if ( fdft_amt2   == 0 ) {  //정산금이 없다면  총무팀장으로 
			    	user_id3 = "XXXXXX"; 	 //생략	
			    //	user_id5 = "XXXXXX"; 	 //생략	
			  }	 
		  }		  
		}  	
	
		
		// 수입차 또는 받을어음이 있다면 총무팀장 
		if ( cls_st.equals("1")  ||  cls_st.equals("2") ) {
			
			 if ( !car_origin.equals("2") ) { 
			   if ( fdft_amt2  <= 0 ) {  //받을채권이 있고 수입차가  아니면   총무팀장으로 
				    	user_id5 = "XXXXXX"; 	 //생략
			   }	 				  
			 }  
		}  	
		
		doc.setUser_id2(user_id2);//팀장/지점장
		doc.setUser_id3(user_id3);//회계관리자
		doc.setUser_id4(user_id4);//채권관리자
		doc.setUser_id5(user_id5);//총무팀장
					 				
		//=====[doc_settle] insert=====
		if (cnt < 1 ) {
			flag1 = d_db.insertDocSettle(doc);
		}		
	
		//3. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
			
		UsersBean sender_bean 	= umd.getUsersBean(reg_id);
		
			//사용자 정보 조회
		String target_id = "";
			   
		target_id = doc.getUser_id2();
		
		if (target_id.equals("XXXXXX")) {
		   			target_id = doc.getUser_id3();
		}	
		
			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
		String url 		= "/fms2/cls_cont/lc_cls_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
		
		 if ( cls_st.equals("14")) {
			 url 		= "/fms2/cls_cont/lc_cls_rm_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
		}
			
	//	System.out.println("from_page 1=" + from_page);	
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
					"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
					"    <CONT>"+cont+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+from_page+"</URL>";
		
		
		//받는사람
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		if ( cls_st.equals("8")) {
			xml_data += "    <TARGET>2013002</TARGET>";  //매입옵션인 경우 추가 - 조현준
		}
		
//		xml_data += "    <TARGET>2006007</TARGET>";
		
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
		
		
		//sender&target이 같은 경우는 메세지 안감.
		if ( cls_st.equals("8")) {
			flag2 = cm_db.insertCoolMsg(msg);		
		} else {   
			if(  !target_bean.getId().equals(sender_bean.getId())  ){
				
				 if ( !cls_st.equals("14") ) {
					flag2 = cm_db.insertCoolMsg(msg);
				} else {
				     	 if ( cool.equals("Y")  ||  fdft_amt2 != 0 ) {
								flag2 = cm_db.insertCoolMsg(msg);
						 }	
				}
		   }			
	  }	
	  	 
		if ( cls_st.equals("8")) {
			System.out.println("쿨메신저(매입옵션의뢰요청)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
		} else if ( cls_st.equals("7")) {
			System.out.println("쿨메신저(출고전해지(신차) 의뢰요청)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());		
		} else if ( cls_st.equals("10")) {
			System.out.println("쿨메신저(개시전해지(재리스) 의뢰요청)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());			
		} else if ( cls_st.equals("14")) {
			System.out.println("쿨메신저(월렌트 회계처리 의뢰요청)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());					
		} else {
			System.out.println("쿨메신저(해지정산의뢰요청)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
		}				
		
		   
		//계약해지의뢰수정
		flag3 = ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "1", reg_id);  //계약해지의뢰 		
		
		//팀장 결재 skip
		if ( doc.getUser_id2().equals("XXXXXX") ) {
			doc = d_db.getDocSettleCommi("11", rent_l_cd);
			doc_no = doc.getDoc_no();
			flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "2",  "2");
		}
		
				//출고전해지가 아닌 경우만 	
		if ( cls_st.equals("7") || cls_st.equals("10")  ) {
		
		} else {
		
			//고객이 피보험자인 경우 && 21세미만인 경우  20160901-해지건 보험안내 전체대상으로 적용 ;
		// 해지완료 시점이 아닌 결재요청시점에 보험담당자에게 전달 
			String ins_st = ai_db.getInsSt(base.getCar_mng_id());
			InsurBean ins  = ai_db.getIns(base.getCar_mng_id(), ins_st);
			Hashtable ins_info = ai_db.getInsClsCoolMsg(base.getCar_mng_id(),ins_st);
			
			//20170207 매각이나 매입옵션일 경우에는 명의이전일 등록 안되어 있으면  문구 바꾸기
			String msgGubun = "계약해지";
			if( cls_st.equals("6") || cls_st.equals("8") ){
				//명의이전일 찾기
				SuiBean sui = sui_db.getSui(base.getCar_mng_id());
				if(sui.getMigr_dt().equals("")){
					if( cls_st.equals("6")  ){ msgGubun = "매각" ; }
					if( cls_st.equals("8")  ){ msgGubun = "매입옵션" ; }
				}
			}
	
		//	UsersBean sender_bean 	= umd.getUsersBean(reg_id);
									
			sub 		= "계약해지 결재진행 보험 관리 요망";
			cont 	=  msgGubun+" ["+ ins_info.get("CAR_NO") + ","+ins_info.get("CAR_NM")+","+ins_info.get("FIRM_NM")+","+ins_info.get("ENP_NO")+","+ins_info.get("INS_START_DT")+","+ins_info.get("INS_EXP_DT")+","+ins_info.get("INS_CON_NO")+"]";	
			String  d_flag2 = "";
			//보험변경요청 프로시저 호출
			if ( !cls_st.equals("8")  ) {   //매입옵션이 아니면 	
				 d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, rent_l_cd, "");	 
		   }		
				
			System.out.println("쿨메신저(결재요청 보험관리)"+ String.valueOf(ins_info.get("CAR_NO"))  +"---------------------"+rent_l_cd);		
		}			
				
	} else { //결재진행중
		
	//	System.out.println(" doc_sanction doc_bit = " + doc_bit + ": doc_no = :" + doc_no +":user_id = " + user_id + ": rent_l_cd = " + rent_l_cd);
		
		DocSettleBean doc 		= d_db.getDocSettle(doc_no);
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
		
		//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		//=====[doc_settle] update=====
		
		doc_step = "2";
			
		//총무팀장 결재이면 문서 결재 완료
		if(doc_bit.equals("5"))	doc_step = "3";  
		
		 if ( doc_bit.equals("9") ) {   //고객지원팀장 skip	 (user2 결재skip)	
			flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "2",  "2");		
		}	
					
		if(!mode.equals("msg")){		
			//	System.out.println(" doc_sanction update doc_bit = " + doc_bit + ": doc_no = :" + doc_no +":user_id = " + user_id + ": rent_l_cd = " + rent_l_cd);	
				flag1 = d_db.updateDocSettleCls(doc_no, user_id, doc_bit, doc_step);			
			//	out.println("문서처리전 결재<br>");				
		}
		
		if ( cls_st.equals("14")   ) {  //월렌트는 바로 결재완료
			doc_bit = "5";  
			doc_step = "3";  
			flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit,doc_step) ; // 월렌트 결재완료
		//	flag1 = d_db.updateDocSettleDocBit(doc_no,  doc_bit);				
		}
		
		/* -영업/관리팀장 에서 해지됨 - 20200520
		if(doc_bit.equals("2")) {			
			if ( cls_st.equals("7") || cls_st.equals("10")  ) { //출고전해지, 개시전해지 
			  if ( fdft_amt2   == 0 ) {  //정산금이 없다면  총무팀장으로  - 결재 skip ( 20200519)
			       doc_bit = "3"; 	
				   flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit,doc_step) ; // 업무대여인  결재완료				   
				   //금액확정여부					
				   if(!ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "2", user_id))	flag += 1;	
			  }	
			}  	
		}
		*/		
		
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------		
		if ( cls_st.equals("8")) {		
			sub 		= rt_s + " 매입옵션 결재요청";
			cont 	= rt_s +  " [계약번호:"+rent_l_cd+"] 매입옵션 결재요청 합니다.";	
		} else if ( cls_st.equals("7")) {		
			sub 		= rt_s + " 출고전해지(신차) 결재요청";
			cont 	= rt_s + " [계약번호:"+rent_l_cd+"] 출고전해지(신차) 결재요청 합니다.";		
		} else if ( cls_st.equals("10")) {		
			sub 		= rt_s + " 개시전해지(재리스) 결재요청";
			cont 	= rt_s + " [계약번호:"+rent_l_cd+"] 개시전해지(재리스) 결재요청 합니다.";		
		} else if ( cls_st.equals("14")) {		
			sub 		= "월렌트 회계처리 결재요청";
			cont 	= "[계약번호:"+rent_l_cd+"] 월렌트회계처리 결재요청 합니다.";			
		} else {
			sub 		= rt_s + " 계약해지정산 결재요청";
			cont 	= rt_s + " [계약번호:"+rent_l_cd+"] 해지정산 결재요청 합니다.";	
		}	
		String url 		=  "";
		
		if (doc_bit.equals("2") || doc_bit.equals("3") ||  doc_bit.equals("4")  ) {
			 url = 	"/fms2/cls_cont/lc_cls_u1.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;	
		}else  { 	
			if ( cls_st.equals("8")) {
		 		 url 	= "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
		 	} else if ( cls_st.equals("14")) {
		 		 url 	= "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	 
		 	} else {
		 		 url 	= "/fms2/cls_cont/lc_cls_d_frame.jsp";
		 	}	 
		}	 
			 
		
		String target_id = "";
					
		if(doc_bit.equals("2") )	target_id = doc.getUser_id3();
				
		if ( cls_st.equals("8") || cls_st.equals("7") || cls_st.equals("10")  ) {		 //회계관리자와 채권관리자가 같다 20110530  -20120119이전
			if(doc_bit.equals("3"))	target_id = doc.getUser_id5();		
		} else {
			if(doc_bit.equals("3"))	target_id = doc.getUser_id4();
		}
		
		if(doc_bit.equals("3")) {
		  if ( car_st.equals("5")  ) {  //업무대여인 경우  결재완료
			   flag1 = d_db.updateDocSettleDocDt( doc_no, "4","2") ; // 채권	
		       doc_bit = "5";  
			   doc_step = "3";  
			   flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit, doc_step) ; // 업무대여인  결재완료
		  }	
		  
		  //출고전해지 , 개시전해지 처리 		  
		  if ( cls_st.equals("7") || cls_st.equals("10")  ) { //출고전해지, 개시전해지 
				   doc_bit = "5";  
				   doc_step = "3"; 
				   flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit,doc_step) ; // 업무대여인  결재완료				   
				   //금액확정여부					
				   if(!ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "2", user_id))	flag += 1;	
		  }	
		}
						
		if(doc_bit.equals("4"))	target_id = doc.getUser_id5(); 
		
		if(doc_bit.equals("4")) {
			  if ( cls_st.equals("1") || cls_st.equals("2")  ) {  //중도해약, 계약만료
				   if ( target_id.equals("XXXXXX")) {
				    	doc_bit = "5";  
					    doc_step = "3";  
					    flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit,doc_step) ; //  결재완료
			  	   } 
			  }		
		}
				
		if(doc_bit.equals("5"))	target_id = doc.getUser_id3();  //회계관리자에게 알림 (회계처리) 
				
		if(doc_bit.equals("5")){
					
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
	
			
			if ( cls_st.equals("8")) {		
				sub 	= "매입옵션 결재 완결";
				cont 	=  "[계약번호:"+rent_l_cd+"] 매입옵션 결재 완결하니 회계처리 진행하세요.";
			} else if ( cls_st.equals("7")) {		
				sub 	= "출고전해지(신차) 결재 완결";
				cont 	=  "[계약번호:"+rent_l_cd+"] 출고전해지(신차) 결재 완결하니 회계처리 진행하세요.";
			} else if ( cls_st.equals("10")) {		
				sub 	= "개시전해지(재리스) 결재 완결";
				cont 	=  "[계약번호:"+rent_l_cd+"] 개시전해지(재리스) 결재 완결하니 회계처리 진행하세요.";	
			} else if ( cls_st.equals("14")) {		
				sub 	= "월렌트  결재 완결";
				cont 	=  "[계약번호:"+rent_l_cd+"] 월렌트 해지 결재 완결하니 회계처리 진행하세요.";						
			} else {
				sub 	= "계약해지정산 결재 완결";
				cont 	= "[계약번호:"+rent_l_cd+"] 계약해지정산 결재 완결하니 회계처리 진행하세요.";
			}	
				
			//월렌트인경우 별도???		
			 if ( cls_st.equals("14") ) {	 			
				url = 	"/fms2/cls_cont/lc_cls_rm_u3.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
			} else {
				url = 	"/fms2/cls_cont/lc_cls_u3.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;			
			}	
		}
		
						
	//	System.out.println("from_page 2=" + from_page);	
						
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+from_page+"</URL>";
		
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	//	if ( cls_st.equals("8")  && doc_bit.equals("3") ) {	 	
	//		xml_data += "    <TARGET>2006007</TARGET>";
	//	}	 	
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
		
		if (doc_bit.equals("5")) {
			if ( cls_st.equals("8")) {	
				System.out.println("쿨메신저(매입옵션회계처리의뢰)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
			} else if ( cls_st.equals("7")) {	
				System.out.println("쿨메신저(출고전해지(신차) 회계처리의뢰)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	
			} else if ( cls_st.equals("10")) {	
				System.out.println("쿨메신저(개시전해지(재리스) 회계처리의뢰)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());		
			} else if ( cls_st.equals("14")) {	
				System.out.println("쿨메신저(월렌트 해지 회계처리의뢰)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());			
			} else {
				System.out.println("쿨메신저(해지정산회계처리의뢰)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
			}	
		} else {
			if ( cls_st.equals("8")) {	
		    	System.out.println("쿨메신저(매입옵션의뢰)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
		    } else if ( cls_st.equals("7")) {	
		    	System.out.println("쿨메신저(출고전해지(신차)의뢰)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	
		     } else if ( cls_st.equals("10")) {	
		    	System.out.println("쿨메신저(개시전해지(재리스)의뢰)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	
		      } else if ( cls_st.equals("14")) {	
		    	System.out.println("쿨메신저(월렌트해지 회계처리의뢰)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());			
		    } else {
		    	System.out.println("쿨메신저(해지정산의뢰)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
		    }	
		}
						
		
	//	System.out.println(xml_data);
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
  <input type='hidden' name='mode'	 			value='<%=mode%>'>
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	fm.action ='<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>