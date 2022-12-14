<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.im_email.*, acar.cont.*, acar.client.*, acar.user_mng.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          	scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<% 
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String mail_addr 	= request.getParameter("mail_addr")==null?"":request.getParameter("mail_addr");
	String replyto_st 	= request.getParameter("replyto_st")==null?"1":request.getParameter("replyto_st");
	String replyto 		= request.getParameter("replyto")==null?"":request.getParameter("replyto");	

	
	boolean flag = true;
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
		
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	
	
	//수신메일	
	String user_email = "";
	
	//user_email = "sales@amazoncar.co.kr";

	user_email = user_bean.getUser_email();
	
	
	//회사메일
	if(replyto_st.equals("1")){
		replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
	//사용자등록메일
	}else if(replyto_st.equals("2")){
		replyto = "\"아마존카 "+user_bean.getUser_nm()+"\"<"+user_bean.getUser_email()+">";
	//직접입력
	}else if(replyto_st.equals("3")){
		if(!replyto.equals("")){
			replyto = "\"아마존카\"<"+replyto+">";
		}else{
			replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
		}
	}	
	
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
		
	DmailBean d_bean = new DmailBean();
	d_bean.setSubject			("[아마존카] "+client.getFirm_nm()+" 님 업무 전용 자동차 보험 가입 요청서 입니다.");
	d_bean.setSql				("SSV:"+mail_addr);
	//d_bean.setSql				("SSV:yoonwon0611@hanmail.net");
	d_bean.setReject_slist_idx	(0);
	d_bean.setBlock_group_idx	(0);
	d_bean.setMailfrom			("\"아마존카\"<"+user_email.trim()+">");
	d_bean.setMailto			("\""+client.getFirm_nm()+"\"<"+mail_addr.trim()+">");
	//d_bean.setMailto			("\"아마존카\"<yoonwon0611@hanmail.net>");
	d_bean.setReplyto			("\"아마존카\"<no-reply@amazoncar.co.kr>");
	d_bean.setErrosto			("\"아마존카\"<return@amazoncar.co.kr>");	
	d_bean.setHtml				(1);
	d_bean.setEncoding			(0);
	d_bean.setCharset			("euc-kr");
	d_bean.setDuration_set		(1);
	d_bean.setClick_set			(0);
	d_bean.setSite_set			(0);
	d_bean.setAtc_set			(0);
	d_bean.setGubun				(reg_code+"_insur");
	d_bean.setRname				("mail");
	d_bean.setMtype       		(0);
	d_bean.setU_idx       		(1);//admin계정
	d_bean.setG_idx				(1);//admin계정
	d_bean.setMsgflag     		(0);	
	d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/ins/ins_task_docs.jsp?client_id="+base.getClient_id()+"&car_mng_id="+car_mng_id);
	d_bean.setEncoding			(3); //파일첨부
	d_bean.setAtc_set			(1);
	
	String reg_code2  = Long.toString(System.currentTimeMillis());
	d_bean.setGubun2		(reg_code2);	
		
	flag = ImEmailDb.insertDEmail(d_bean, "4", "", "+7");						

	
	String add_fileinfo 	= "업무용승용차 손비처리 기준 안내.pdf";
	String add_content 	= "https://fms3.amazoncar.co.kr/doc/amazoncar_comemp_doc3.pdf";
										
	flag = ImEmailDb.insertDEmailEnc4(d_bean.getGubun(), d_bean.getGubun2(), add_fileinfo, add_content);
	

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
	alert("메일이 정상적으로 발송 되었습니다.");
	parent.window.close();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	parent.window.close();				
<%}%>
//-->
</script>

</body>
</html>



