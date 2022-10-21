<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.arrear.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.arrear.ArrearDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	boolean flag = true;
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
		
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
		
	ArrearBean arrear = new ArrearBean();
	
	arrear.setRent_mng_id(m_id);
	arrear.setRent_l_cd(l_cd);
	arrear.setUser_id(user_id);

	arrear.setReg_dt(request.getParameter("reg_dt"));
	arrear.setCredit_method(request.getParameter("credit_method"));
	arrear.setCredit_desc(request.getParameter("credit_desc"));
	arrear.setArr_type("1");
	
	flag = ad_db.insertArrear(arrear);
	
%>
<form name='form1' method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
</form>

<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
		location='about:blank';
<%	}else{%>
		alert('등록되었습니다');
		parent.window.close();
		parent.opener.location.reload();
		
<%	}%>
</script>
</body>
</html>
