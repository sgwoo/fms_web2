<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, tax.*, acar.cont.*, acar.alink.*, acar.coolmsg.*, acar.estimate_mng.*, acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.im_email.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      	scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<% 
	String user_id 	= request.getParameter("user_id")		== null ? "" : request.getParameter("user_id");
	String doc_code 	= request.getParameter("doc_code")	== null ? "" : request.getParameter("doc_code");
	String type		 	= request.getParameter("type")			== null ? "" : request.getParameter("type");
	
	String s_kd 		= request.getParameter("s_kd")		==	null ? "" : request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==	null ? "" : request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")		==	null ? "" : request.getParameter("gubun1");
	String gubun4 	= request.getParameter("gubun4")		==	null ? "" : request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")		==	null ? "" : request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		== 	null ? "" : request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")		==	null ? "" : request.getParameter("end_dt");
	
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	// 전자문서 단 건 조회
	Hashtable ht = ln_db.getEDocMng(doc_code);
	String doc_type 			= String.valueOf(ht.get("DOC_TYPE"));		// 문서 구분
	String doc_name			= String.valueOf(ht.get("DOC_NAME"));		// 문서명
	String firm_nm 			= String.valueOf(ht.get("FIRM_NM"));			// 상호명
	String sign_st				= String.valueOf(ht.get("SIGN_ST"));			// 서명자 정보(고객/공동임차인/승계원계약자)
	String rent_l_cd			= String.valueOf(ht.get("RENT_L_CD"));		// 계약번호
	String link_code			= String.valueOf(ht.get("LINK_CODE"));		
	String sign_client_st	= String.valueOf(ht.get("SIGN_CLIENT_ST"));		
	String send_type 		= String.valueOf(ht.get("SEND_TYPE"));		// 발송 구분
	
	String sender_contact 	= "";		// 발신자
	String receiver_contact	= String.valueOf(ht.get("RECEIVER"));		// 수신자
	
	Hashtable link_ht = null;
	if(doc_type.equals("1")){
		if(doc_name.equals("월렌트계약서")){
			link_ht = ln_db.getRmRentLinkM(link_code);
		} else {
			link_ht = ln_db.getLcRentLinkM(link_code);
		}
	}
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	
	if( type.equals("discard") ){	/***** 문서 폐기 *****/
		
		
		// 전자문서관리 테이블 미사용 처리
		flag1 = ln_db.discardEDoc(link_code);
	
		String link_doc_code = "";
		String link_table = "";
		
		if(doc_type.equals("1")){		// 계약서
			if(doc_name.equals("월렌트계약서")){
				link_doc_code = doc_code.replace("RM", "");
				link_table = "RM_RENT_LINK_M";
			} else {
				link_doc_code = doc_code.replace("LC", "");
				link_table = "LC_RENT_LINK_M";
			}
		}
		
		// 전자문서 데이터 미사용 처리
		if(flag1){
			flag1 = ln_db.updateAlinkDocyn(link_doc_code, link_table, "D");
		}
		
	} else if( type.equals("resend") ){	/***** 재발송 *****/
		
		// CMS 자동이체 신청서 추가 발송 유무 체크
		boolean checkSendCms = false;
		if( sign_st.equals("1") && (doc_name.equals("장기계약서") || doc_name.equals("계약승계계약서")) ) checkSendCms = true;	// 장기계약서, 계약승계계약서의 경우 CMS 자동이체신청서 추가 발송. 
		if( doc_name.equals("월렌트계약서")) {
			String cms_type = String.valueOf(link_ht.get("CMS_TYPE"));
			cms_type = "cms";
			if(sign_st.equals("1") && sign_client_st.equals("1") && "cms".equals(cms_type)){	// 월렌트계약서 법인이면서 cms_type이 cms인 경우 CMS 자동이체신청서 추가 발송.
				checkSendCms = true;
			}
		}
		
		if(send_type.equals("mail")){	// 발송 구분 메일
			
			// 메일 발송 시 발신자는 메일 계정.
			sender_contact = "no-reply@amazoncar.co.kr";
			
			String content_st = "";
			DmailBean d_bean = new DmailBean();
			
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			(sender_contact);
			d_bean.setReplyto			("\"아마존카\"<no-reply@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<return@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set	(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setRname			("mail");
			d_bean.setMtype     	  	(0);
			d_bean.setU_idx      		(1);	// admin계정
			d_bean.setG_idx				(1);	// admin계정
			d_bean.setMsgflag     		(0);
			d_bean.setV_mailfrom		(sender_contact);
			
			if(doc_name.equals("월렌트계약서")){	// 월렌트
				content_st = "rmcar_doc";
			} else {		// 신규/증차/대차, 계약승계, 연장
				content_st = "newcar_doc";
			}
			
			d_bean.setSubject			("[아마존카] "+ firm_nm +" 님의 자동차대여이용 "+doc_name+"입니다.");
			d_bean.setSql					("SSV:" + receiver_contact);
			d_bean.setMailto				("\"" + firm_nm + "\"<" + receiver_contact + ">");
			d_bean.setV_mailto			(receiver_contact);
			d_bean.setGubun2			(doc_code + "" + content_st);
			d_bean.setContent			("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code);
			d_bean.setV_content		("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code);
			
			flag1 = ImEmailDb.insertDEmail(d_bean, "5", "", "+7");
			
			if(flag1){
				//  CMS 신청서 추가 발송.
				if( checkSendCms ){
					// 해당 계약서에 대한 CMS 신청서 발송 건 조회
					Hashtable cms_ht = ln_db.getCmsEDocMng(rent_l_cd);
					String doc_code_cms = String.valueOf(cms_ht.get("DOC_CODE"));
					
					DmailBean d_bean_cms = new DmailBean();
					
					d_bean_cms.setSubject				("[아마존카] " + firm_nm + " 고객님 아마존카 자동이체신청서입니다.");
					d_bean_cms.setSql						("SSV:"+ receiver_contact);
					d_bean_cms.setReject_slist_idx		(0);
					d_bean_cms.setBlock_group_idx	(0);
					d_bean_cms.setMailfrom				(sender_contact);
					d_bean_cms.setMailto					("\""+ firm_nm +"\"<"+ receiver_contact +">");
					d_bean_cms.setReplyto				("\"아마존카\"<no-reply@amazoncar.co.kr>");
					d_bean_cms.setErrosto				("\"아마존카\"<return@amazoncar.co.kr>");
					d_bean_cms.setHtml					(1);
					d_bean_cms.setEncoding				(0);
					d_bean_cms.setCharset				("euc-kr");
					d_bean_cms.setDuration_set			(1);
					d_bean_cms.setClick_set				(0);
					d_bean_cms.setSite_set				(0);
					d_bean_cms.setAtc_set				(0);
					d_bean_cms.setGubun					("docs");
					d_bean_cms.setRname					("mail");
					d_bean_cms.setMtype       			(0);
					d_bean_cms.setU_idx       			(1);	// admin계정
					d_bean_cms.setG_idx					(1);	// admin계정
					d_bean_cms.setMsgflag     			(0);	
					d_bean_cms.setContent				("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code_cms);

					flag2 = ImEmailDb.insertDEmail(d_bean_cms, "4", "", "+7");
				}
			}
			
		} else if(send_type.equals("talk")){
			
			// 알림톡 발송 시 발신자는 전화번호.
			sender_contact = "02-392-4243";
			
			// 친구톡 메시지 내용
			String talk_msg = firm_nm + " 고객님 아마존카입니다. 전자문서를 발송합니다. \n\n";
			
			String index_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+doc_code;	 // 전자 문서 인덱스 페이지 url
			String short_index_url = ShortenUrlGoogle.getShortenUrl(index_url);		// 전자 문서 인덱스 페이지 url bitly화
			
			talk_msg += short_index_url + " ";
			
			// 친구톡 발송
			flag1 = at_db.sendMessage(1009, "0", talk_msg, receiver_contact, sender_contact, null, rent_l_cd, user_id);
			
			if(flag1){
				// CMS 신청서 추가 발송.
				if( checkSendCms ){
					
					// 해당 계약서에 대한 CMS 신청서 발송 건 조회
					Hashtable cms_ht = ln_db.getCmsEDocMng(rent_l_cd);
					String doc_code_cms = String.valueOf(cms_ht.get("DOC_CODE"));
					
					String talk_msg_cms = firm_nm + " 고객님 아마존카입니다. 전자문서를 발송합니다. \n\n";
					
					String index_url_cms = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+doc_code_cms;
					String short_index_url_cms = ShortenUrlGoogle.getShortenUrl(index_url_cms);
					
					talk_msg_cms += short_index_url_cms + " ";
					
					flag2 = at_db.sendMessage(1009, "0", talk_msg_cms, receiver_contact, sender_contact, null, rent_l_cd, user_id);
				}
			}
			
		}
		
	} else if( type.equals("completed") ){	/***** 완료 문서 발송 *****/
		
		if(send_type.equals("mail")){			// 발송 구분: 메일
		
			// 메일 발송 시 발신자는 메일 계정.
			sender_contact = "no-reply@amazoncar.co.kr";
			
			String content_st = "";
			DmailBean d_bean = new DmailBean();
			
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			(sender_contact);
			d_bean.setReplyto			("\"아마존카\"<no-reply@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<return@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set	(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setRname			("mail");
			d_bean.setMtype     	  	(0);
			d_bean.setU_idx      		(1);	// admin계정
			d_bean.setG_idx				(1);	// admin계정
			d_bean.setMsgflag     		(0);
			d_bean.setV_mailfrom		(sender_contact);
			
			if(doc_name.equals("월렌트계약서")){	// 월렌트
				content_st = "rmcar_doc";
			} else {		// 신규/증차/대차, 계약승계, 연장
				content_st = "newcar_doc";
			}
			
			d_bean.setSubject			("[아마존카] "+ firm_nm +" 님의 자동차대여이용 "+doc_name+"입니다.");
			d_bean.setSql					("SSV:" + receiver_contact);
			d_bean.setMailto				("\"" + firm_nm + "\"<" + receiver_contact + ">");
			d_bean.setV_mailto			(receiver_contact);
			d_bean.setGubun2			(doc_code + "" + content_st);
			d_bean.setContent			("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code);
			d_bean.setV_content		("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code);
			
			flag1 = ImEmailDb.insertDEmail(d_bean, "5", "", "+7");
			
		} else if( send_type.equals("talk") || send_type.equals("park") ){	//	발송 구분: 알림톡 또는 현장
			
			// 알림톡 발송 시 발신자는 전화번호.
			sender_contact = "02-392-4243";
			
			// 친구톡 메시지 내용
			String talk_msg = firm_nm + " 고객님 아마존카입니다. 서명하신 "+doc_name+"를 발송합니다. \n\n";
			
			String index_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+doc_code;	 // 전자 문서 인덱스 페이지 url
			String short_index_url = ShortenUrlGoogle.getShortenUrl(index_url);		// 전자 문서 인덱스 페이지 url bitly화
			
			talk_msg += short_index_url + " ";
			
			// 친구톡 발송
			flag1 = at_db.sendMessage(1009, "0", talk_msg, receiver_contact, sender_contact, null, rent_l_cd, user_id);
			
		}
		
	}
	
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
</head>
<body>
<form name='form1' method='post' target="">
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name="s_kd" 		value="<%=s_kd%>">
  <input type='hidden' name="t_wd" 	value="<%=t_wd%>">
  <input type='hidden' name="gubun1" 	value="<%=gubun1%>">
  <input type='hidden' name="gubun4" 	value="<%=gubun4%>">
  <input type='hidden' name="gubun5"	value="<%=gubun5%>">
  <input type='hidden' name="st_dt"		value="<%=st_dt%>">
  <input type='hidden' name="end_dt"	value="<%=end_dt%>">
</form>
<script language="JavaScript">
<%if(type.equals("discard")){%>
	<%if(!flag1){%>
		alert("폐기 실패");
	<%} else {%>
		alert("폐기되었습니다.");
	<%}%>
		var fm = document.form1;
		fm.action = document.referrer;
		fm.submit();
<%} else if(type.equals("resend")){%>
	<%if(!flag1 || !flag2){%>
		alert("발송 실패");
	<%} else {%>
		alert("정상적으로 발송되었습니다.");
	<%}%>
		var fm = document.form1;
		fm.action = document.referrer;
		fm.submit();
<%} else if(type.equals("completed")){%>
	<%if(!flag1){%>
		alert("발송 실패");
	<%} else {%>
		alert("정상적으로 발송되었습니다.");
	<%}%>
	var fm = document.form1;
	fm.action = document.referrer;
	fm.submit();
<%}%>
</script>
</body>
</html>