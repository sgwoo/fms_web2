<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.ca.*"%>
<jsp:useBean id="CaNoDb" class="acar.ca.CaNoDatabase" scope="page"/>
<jsp:useBean id="CaNoBn" class="acar.beans.CaNoBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차 등록번호 관리(CA_NO)
	CaNoBn.setCar_no_id		(request.getParameter("car_no_id"));
	CaNoBn.setCar_no		(request.getParameter("car_no"));
	CaNoBn.setInit_reg_dt	(Util.ChangeString(request.getParameter("init_reg_dt")));
	CaNoBn.setReg_ext		(request.getParameter("reg_ext"));
	CaNoBn.setBr_id			(request.getParameter("br_id"));
	//CaNoBn.setExp_dt		(request.getParameter("exp_dt"));		//말소일
	//CaNoBn.setExp_cau		(request.getParameter("exp_cau"));		//말소사유
	CaNoBn.setReg_id		(user_id); 

	//해당 Bean 등록.
	int result = CaNoDb.insertCaNo(CaNoBn);  

%>

<html>
<head>
<title></title>
</head>

<body>
<script language='javascript'>
<%	if(result > 0){	%>
		alert('차량번호가 등록 되었습니다.');
		parent.location.href = "./s_carno.jsp";
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
</body>
</html>
