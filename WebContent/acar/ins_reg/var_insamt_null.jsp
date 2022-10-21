<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String var_cd = request.getParameter("var_cd")==null?"":request.getParameter("var_cd");
	String var_sik = request.getParameter("var_sik")==null?"":request.getParameter("var_sik");
	var_sik = AddUtil.parseDigit3(var_sik);
	
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstiSikVarBean bean = e_db.getEstiSikVarCaseDly(a_a, seq, var_cd);
	bean.setVar_sik(var_sik);
	count = e_db.updateEstiSikVar(bean);
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='ins_reg_frame.jsp' method="POST" target='d_content'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==1){%>
			alert("정상적으로 수정되었습니다.");
			parent.location.reload();
			//fm.submit();
<%	}else{%>
			alert("오류발생!");
<%	}%>
//-->
</script>
</body>
</html>
