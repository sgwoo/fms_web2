<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.im_email.*, tax.*, acar.complain.*"%>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//메일관리 메일 발송 처리 페이지
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String email = request.getParameter("email")==null?"":request.getParameter("email");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	String answer = request.getParameter("answer")==null?"":request.getParameter("answer");
	String contents = request.getParameter("contents")==null?"":request.getParameter("contents");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
		
	int flag = 0;
	int result = 0;
	
	//답변 저장
	ComplainDatabase oad = ComplainDatabase.getInstance();
	
	result = oad.updateAnswer(seq, answer, user_id);
	
	if(result != 1) flag += 1;
	
	//[5단계] 인포메일러 발송 : d-mail 생성

	if(!email.equals("") && !answer.equals("전화로 상담을 진행했습니다.")){
		//	1. d-mail 등록-------------------------------
		
		DmailBean d_bean = new DmailBean();
		
		d_bean.setSubject(name+"고객님, 이용에 불편을 드려 죄송합니다.");							
		
		d_bean.setSql				("SSV:"+email.trim());
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom			("\"아마존카\"<ads@amazoncar.co.kr>");
		d_bean.setMailto			("\""+name+"\"<"+email.trim()+">");
		d_bean.setReplyto			("\"아마존카\"<ads@amazoncar.co.kr>");
		d_bean.setErrosto			("\"아마존카\"<ads@amazoncar.co.kr>");
		d_bean.setHtml				(1);
		d_bean.setEncoding			(0);
		d_bean.setCharset			("euc-kr");
		d_bean.setDuration_set		(1);
		d_bean.setClick_set			(0);
		d_bean.setSite_set			(0);
		d_bean.setAtc_set			(0);
		d_bean.setGubun				(seq+"complain"); 
		d_bean.setRname				("mail");
		d_bean.setMtype       		(0);
		d_bean.setU_idx       		(1);//admin계정
		d_bean.setG_idx				(1);//admin계정
		d_bean.setMsgflag     		(0);
		d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/etc/complain_answer.jsp?seq="+seq); 
		
		if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
	}
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){	  
		//parent.window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type='hidden' name="s_width" value="<%=s_width%>">   
    <input type='hidden' name="s_height" value="<%=s_height%>">  
    <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  
<a href="javascript:go_step()"></a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("이메일 발송 에러가 발생하였습니다.");
<%	}else{//정상%>
			<%if (answer.equals("전화로 상담을 진행했습니다.")){%>
				alert("전화상담을 완료했습니다.")
			<%} else {%>
				alert("이메일를 발송하였습니다.");
			<%}%>
		parent.window.close();
<%	}%>
//-->
</script>
</form>
</body>
</html>
