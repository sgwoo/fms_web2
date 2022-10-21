<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	
	
	String our_fault_per = request.getParameter("our_fault_per")==null?"":request.getParameter("our_fault_per");
	String p_ip_dt = request.getParameter("p_ip_dt")==null?"":request.getParameter("p_ip_dt");
	String p_ip_amt 	=  request.getParameter("p_ip_amt")==null?"":request.getParameter("p_ip_amt");  //입금액
	String p_desc = request.getParameter("p_desc")==null?"":request.getParameter("p_desc");
	
	String p_doc_desc = "사전결재후 과실확정 비율: 당사 ->" + our_fault_per + " %" + " 입금일: " + p_ip_dt + "  입금액: " + p_ip_amt + " 특이사항: " + p_desc; 
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	int count = 1;
	
	count = as_db.updatePredocDesc(c_id, accid_id,p_doc_desc, p_ip_dt, AddUtil.parseDigit(p_ip_amt) );
%>
<script language='javascript'>
<%	if(count == 1){%>
		alert('정상적으로 처리되었습니다');
		parent.window.close();
		parent.opener.location.reload();
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
