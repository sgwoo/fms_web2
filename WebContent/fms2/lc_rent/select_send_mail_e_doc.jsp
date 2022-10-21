<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.net.*, acar.util.*, tax.*, acar.estimate_mng.*, acar.user_mng.*,acar.im_email.*, acar.alink.*, acar.common.*" %>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ page import="acar.kakao.*" %>
<%@ include file="/acar/cookies.jsp" %>

<% 
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String type = request.getParameter("type")==null?"":request.getParameter("type");
	String view_amt = request.getParameter("view_amt")==null?"":request.getParameter("view_amt");
	String pay_way = request.getParameter("pay_way")==null?"":request.getParameter("pay_way");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String ch_cd = request.getParameter("ch_cd")==null?"":request.getParameter("ch_cd");
	String user_type = request.getParameter("user_type")==null?"":request.getParameter("user_type");
	
	
	String view_good = request.getParameter("view_good")==null?"":request.getParameter("view_good");
	String view_tel = request.getParameter("view_tel")==null?"":request.getParameter("view_tel");
	String view_addr = request.getParameter("view_addr")==null?"":request.getParameter("view_addr");	
	
	String est_nm 		= request.getParameter("est_nm")==null?"고객":request.getParameter("est_nm");	
	String mail_addr 	= request.getParameter("mail_addr")==null?"":request.getParameter("mail_addr");
	
	String replyto_st 	= request.getParameter("replyto_st")==null?"1":request.getParameter("replyto_st");
	String replyto 		= request.getParameter("replyto")==null?"":request.getParameter("replyto");
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");
	
	String send_st 		= request.getParameter("send_st")==null?"1":request.getParameter("send_st");
	String m_tel 		= request.getParameter("m_tel")==null?"":request.getParameter("m_tel");
	String doc_name 	= request.getParameter("doc_name")==null?"":request.getParameter("doc_name");
	String doc_url = request.getParameter("doc_url")==null?"":request.getParameter("doc_url");
	String doc_type = request.getParameter("doc_type")==null?"":request.getParameter("doc_type");
	String sign_type = request.getParameter("sign_type")==null?"":request.getParameter("sign_type");
	String client_st = request.getParameter("client_st")==null?"":request.getParameter("client_st");
	
	
		
	int count = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	
	String user_email = "";
	user_email = "sales@amazoncar.co.kr";
	
	if(replyto_st.equals("1")){
			replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
	}else if(replyto_st.equals("2")){
		if(!user_id.equals("")){
			replyto = "\"아마존카 "+user_bean.getUser_nm()+"\"<"+user_bean.getUser_email()+">";
		}else{
			replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
		}
	}else if(replyto_st.equals("3")){
		if(!replyto.equals("")){
			if(!user_id.equals("")){
				replyto = "\"아마존카 "+user_bean.getUser_nm()+"\"<"+replyto+">";
			}else{
				replyto = "\"아마존카\"<"+replyto+">";
			}
		}else{
			replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
		}
	}
	
	String doc_code  = "CT"+Long.toString(System.currentTimeMillis());
	
	String t_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+doc_code;
	String st_url = ShortenUrlGoogle.getShortenUrl(t_url);
	
	doc_url = "https://edoc.amazoncar.co.kr"+doc_url+"?doc_code="+doc_code;
	
	if(type.equals("2")){
		doc_url = doc_url+"&view_amt="+view_amt;
	}
	if(type.equals("4")){
		doc_url = doc_url+"&pay_way="+pay_way;
	}
	
	//doc_url = ShortenUrlGoogle.getShortenUrl(doc_url);	
	
	//전자문서처리
	String receiver = mail_addr.trim();
	String send_type = "mail";
	if(send_st.equals("2")){
		send_type = "talk";
		receiver = m_tel.trim();
	}
	//확인서는 추가작업없음
	if(doc_type.equals("3")){
		sign_type = "0";		
	}
	//유효기간 30일
	String term_dt = AddUtil.getDate(4);
	//for(int j = 0 ; j < 7 ; j++){
		term_dt = af_db.getValidDt(c_db.addDay(term_dt, 30));
	//}		
	
	boolean flag = true;
		
	//전자문서 전송데이터 처리		
	flag = ln_db.insertALinkEdoc(doc_code, doc_type, sign_type, send_type, doc_name, doc_url, est_nm, receiver, ck_acar_id, term_dt, client_id, rent_mng_id, rent_l_cd, "", ch_cd, rent_st, "1", client_st, "Y", "", doc_code);		
	
	
	DmailBean d_bean = new DmailBean();
	d_bean.setSubject			("[아마존카] "+est_nm+" 님 아마존카 전자문서입니다.");
	d_bean.setSql				("SSV:"+mail_addr.trim());
	d_bean.setReject_slist_idx	(0);
	d_bean.setBlock_group_idx	(0);
	d_bean.setMailfrom			(replyto);
	d_bean.setMailto			("\""+est_nm+"\"<"+mail_addr.trim()+">");
	d_bean.setReplyto			("\"아마존카\"<no-reply@amazoncar.co.kr>");
	d_bean.setErrosto			("\"아마존카\"<return@amazoncar.co.kr>");
	d_bean.setHtml				(1);
	d_bean.setEncoding			(0);
	d_bean.setCharset			("euc-kr");
	d_bean.setDuration_set		(1);
	d_bean.setClick_set			(0);
	d_bean.setSite_set			(0);
	d_bean.setAtc_set			(0);
	d_bean.setGubun				("docs");
	d_bean.setRname				("mail");
	d_bean.setMtype       		(0);
	d_bean.setU_idx       		(1);//admin계정
	d_bean.setG_idx				(1);//admin계정
	d_bean.setMsgflag     		(0);	
	d_bean.setContent			("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code);

	
	if(flag){
		if(send_st.equals("1")){
			//메일
			flag = ImEmailDb.insertDEmail(d_bean, "4", "", "+7");
		}else{
			//알림톡
			//m_tel
			String msg = est_nm +  " 님  아마존카입니다. 전자문서를 발송합니다. \n\n" + st_url + " " ;				
			AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
			at_db.sendMessage(1009, "0", msg, m_tel, user_bean.getUser_m_tel(), null, rent_l_cd, ck_acar_id);
		}
	}	

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--
<%if(flag){%>
	alert("정상적으로 발송 되었습니다.");
	parent.window.close();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	parent.window.close();				
<%}%>
//-->
</script>

</body>
</html>



