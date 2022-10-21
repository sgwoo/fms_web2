<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	
	
	
	String gubun = "";
	String gu_nm = "";
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") !=null) 	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun") != null)	gubun = request.getParameter("gubun");
	if(request.getParameter("gu_nm") != null)	gu_nm = request.getParameter("gu_nm");
	
	
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");	
		
	
	String user_id = login.getCookieValue(request, "acar_id");
	String user_nm = login.getAcarName(user_id);
	String user_m_tel = login.getUser_m_tel(request, "acar_id");
	
	
	String valus = 	"?auth_rw="+auth_rw+"&gubun="+gubun+"&gu_nm="+gu_nm+
			"&sort_gubun="+sort_gubun+"&sort="+sort+"&user_id="+user_id+"&user_nm="+user_nm+"&user_m_tel="+user_m_tel+
		   	"";
	
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
	function open_sms(){
		var SUBWIN="./sms_gate.jsp<%=valus%>";	
		window.open(SUBWIN, "pop", "left=80, top=40, width=850, height=750, scrollbars=yes, status=yes");
	}
//-->
</script>
</head>

<body leftmargin="15" onload="open_sms()">

</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
