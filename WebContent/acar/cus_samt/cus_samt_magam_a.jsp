<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.cus_samt.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.cus_samt.CusSamt_Database"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_seq = request.getParameter("s_seq")==null?"":request.getParameter("s_seq");

	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");
	
	int j_g_amt = request.getParameter("j_g_amt")==null?0: AddUtil.parseInt(request.getParameter("j_g_amt"));
	int j_b_amt = request.getParameter("j_b_amt")==null?0: AddUtil.parseInt(request.getParameter("j_b_amt"));
	int j_g_dc_amt = request.getParameter("j_g_dc_amt")==null?0: AddUtil.parseInt(request.getParameter("j_g_dc_amt"));
	int j_dc_amt = request.getParameter("j_dc_amt")==null?0: AddUtil.parseInt(request.getParameter("j_dc_amt"));
	int j_ext_amt = request.getParameter("j_ext_amt")==null?0: AddUtil.parseInt(request.getParameter("j_ext_amt"));
		
	boolean flag1 = true;
		
	flag1 = cs_db.updateMJ_Jungsan(acct, s_yy, s_mm, s_seq, j_g_amt, j_b_amt, j_g_dc_amt,  j_ext_amt, j_dc_amt,  user_id);
	
	
	
%>
<script language='javascript'>
<%	if(flag1){%>
		alert('정상적으로 처리되었습니다');
	//	parent.window.close();
	//	parent.opener.location.reload();
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
