<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.im_email.*, tax.*, acar.complain.*"%>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//���ϰ��� ���� �߼� ó�� ������
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String email = request.getParameter("email")==null?"":request.getParameter("email");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	String answer = request.getParameter("answer")==null?"":request.getParameter("answer");
	String contents = request.getParameter("contents")==null?"":request.getParameter("contents");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
		
	int flag = 0;
	int result = 0;
	
	//�亯 ����
	ComplainDatabase oad = ComplainDatabase.getInstance();
	
	result = oad.updateAnswer(seq, answer, user_id);
	
	if(result != 1) flag += 1;
	
	//[5�ܰ�] �������Ϸ� �߼� : d-mail ����

	if(!email.equals("") && !answer.equals("��ȭ�� ����� �����߽��ϴ�.")){
		//	1. d-mail ���-------------------------------
		
		DmailBean d_bean = new DmailBean();
		
		d_bean.setSubject(name+"����, �̿뿡 ������ ��� �˼��մϴ�.");							
		
		d_bean.setSql				("SSV:"+email.trim());
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom			("\"�Ƹ���ī\"<ads@amazoncar.co.kr>");
		d_bean.setMailto			("\""+name+"\"<"+email.trim()+">");
		d_bean.setReplyto			("\"�Ƹ���ī\"<ads@amazoncar.co.kr>");
		d_bean.setErrosto			("\"�Ƹ���ī\"<ads@amazoncar.co.kr>");
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
		d_bean.setU_idx       		(1);//admin����
		d_bean.setG_idx				(1);//admin����
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
<%	if(flag > 0){//�����߻�%>
		alert("�̸��� �߼� ������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
			<%if (answer.equals("��ȭ�� ����� �����߽��ϴ�.")){%>
				alert("��ȭ����� �Ϸ��߽��ϴ�.")
			<%} else {%>
				alert("�̸��ϸ� �߼��Ͽ����ϴ�.");
			<%}%>
		parent.window.close();
<%	}%>
//-->
</script>
</form>
</body>
</html>
