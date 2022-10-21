<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.ip_mng.*" %>
<%
	IpMngDatabase imd = IpMngDatabase.getInstance();
	
	String user_id = "";
	String ip = "";
	String h_user_id = "";
	String h_ip = "";
	String ip_auth = "";
    String auth_rw = "";
    String cmd = "";
	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("user_id") != null)	user_id = request.getParameter("user_id");
	if(request.getParameter("ip") != null)	ip = request.getParameter("ip");
	if(request.getParameter("h_user_id") != null)	h_user_id = request.getParameter("h_user_id");
	if(request.getParameter("h_ip") != null)	h_ip = request.getParameter("h_ip");
	if(request.getParameter("ip_auth") != null)	ip_auth = request.getParameter("ip_auth");
	if(request.getParameter("cmd") != null)	cmd = request.getParameter("cmd");
		if(cmd.equals("i"))
		{
			count = imd.insertIp(user_id, ip);
		}else if(cmd.equals("u")){
			count = imd.updateIp(user_id, ip, h_user_id, h_ip);
		}else if(cmd.equals("d")){
			count = imd.deleteIp(h_user_id, h_ip);
		}
		
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language="JavaScript">
<!--
function NullAction()
{

<%
	if(cmd.equals("u"))
	{
		if(count==1)
		{
%>

alert("정상적으로 수정되었습니다.");
parent.parent.c_body.location ='./ip_s_sc.jsp';
parent.parent.c_foot.location ='./ip_u.jsp';
<%
		}
	}else if(cmd.equals("i")){
		if(count==1)
		{
%>

alert("정상적으로 등록되었습니다.");
parent.parent.c_body.location ='./ip_s_sc.jsp';
parent.parent.c_foot.location ='./ip_u.jsp';
//window.location="about:blank";
<%
		}
	}else if(cmd.equals("d")){
		if(count==1)
		{
%>

alert("정상적으로 삭제되었습니다.");
parent.parent.c_body.location ='./ip_s_sc.jsp';
parent.parent.c_foot.location ='./ip_u.jsp';

//window.location="about:blank";
<%
		}
	}
%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">

</body>
</html>
