<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	int cnt = 4; //��Ȳ ��� ������ �Ѽ�
	 
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-245;//��Ȳ ���μ���ŭ ���� ���������� ������
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='reg_gu' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td>---------------------------------------------------
	  </td>
	</tr>    
</table>
</form>
</body>
</html>
