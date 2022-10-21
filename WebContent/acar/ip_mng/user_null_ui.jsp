<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>

<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String user_id = "";
    String id = "";
    String dept_nm = "";
    String user_m_tel = "";
    String user_pos = "";
    
	if(request.getParameter("user_id") != null) user_id = request.getParameter("user_id");
	
	u_bean = umd.getUsersBean(user_id);
	id = u_bean.getId();
	dept_nm = u_bean.getDept_nm();
	user_pos = u_bean.getUser_pos();
	user_m_tel = u_bean.getUser_m_tel();
	
		
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language="JavaScript">
<!--
function NullAction()
{
	var theForm = parent.parent.c_foot.IpUpForm;
	theForm.id.value = '<%=id%>';
	theForm.dept_nm.value = '<%=dept_nm%>';
	theForm.user_m_tel.value = '<%=user_m_tel%>';
	theForm.user_pos.value = '<%=user_pos%>';

}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">

</body>
</html>
