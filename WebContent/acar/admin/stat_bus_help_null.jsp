<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.add_mark.*" %>
<jsp:useBean id="am_db" scope="page" class="acar.add_mark.AddMarkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	int count = 0;
	
	AddMarkBean bean = new AddMarkBean();
	bean.setSeq(request.getParameter("seq")==null?"":request.getParameter("seq"));
	bean.setMarks(request.getParameter("marks")==null?"":request.getParameter("marks"));
	bean.setEnd_dt(request.getParameter("end_dt")==null?"":request.getParameter("end_dt"));
	if(!am_db.updateAddMarks(bean)) count = 1;
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='stat_mng_sc_in_view.jsp' method="POST" target='i_view'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="save_dt" value="<%=save_dt%>">
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==0){%>
			alert("���������� �����Ǿ����ϴ�.");
			fm.submit();
<%	}else{%>
			alert("�����߻�!");
<%	}%>
//-->
</script>
</body>
</html>
