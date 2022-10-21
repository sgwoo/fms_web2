<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.ip_mng.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="i_bean" class="acar.ip_mng.IPBean" scope="page"/>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%
	IpMngDatabase imd = IpMngDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String user_id = "";
    String user_nm = "";
    String iu = "";
    String ip = "";
    String id = "";
    String ip_auth = "";
    String loginout = "";
    String login_dt = "";
    String logout_dt = "";
    String dept_id = "";
    String dept_nm = "";
    String user_m_tel = "";
    String user_pos = "";
    String auth_rw = "";
    String cmd = "";
	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	if(request.getParameter("user_id") != null) user_id = request.getParameter("user_id");
	if(request.getParameter("ip") != null) ip = request.getParameter("ip");
	
	UsersBean u_r [] = umd.getUserAll("", "", "");
	
	if(!ip.equals(""))
	{
	i_bean = imd.getIPBean(user_id, ip);
	id = i_bean.getId();
	user_nm = i_bean.getUser_nm();
	dept_nm = i_bean.getDept_nm();
	user_pos = i_bean.getUser_pos();
	user_m_tel = i_bean.getUser_m_tel();
	ip = i_bean.getIp();
	ip_auth = i_bean.getIp_auth();
	}
	
		
%>
<html>
<head><title>[<%=ip%>]</title>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function IpAddUpDel(arg)
{
	var theForm = document.IpUpForm;
	theForm.cmd.value = arg;
	theForm.target="i_no";
	theForm.submit();
}
function UserSearch()
{
	var theForm = document.UserSearchForm;
	var theForm1 = document.IpUpForm;
	
	theForm.user_id.value = theForm1.user_id.value;
	theForm.target = "i_no";
	theForm.submit();
}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body onLoad="javascript:self.focus()">
<table border="0" cellspacing="0" cellpadding="0" width=800>
	
	<form action="./ip_null_ui.jsp" name="IpUpForm" method="post">
	<tr>
	<td class='line' colspan=3>
		<input type="hidden" name="cmd" value="<%=cmd%>">
		<input type="hidden" name="h_user_id" value="<%=user_id%>">
		<input type="hidden" name="h_ip" value="<%=ip%>">
		 <table border="0" cellspacing="1" cellpadding="0" width=800>
			<tr>
				<td class="title">IP주소</td>
				<td align="left" colspan=7><input type="text" name="ip" value="<%=ip%>" size="15"></td>
			</tr>
			<tr>
				<td class="title" width="100">ID</td>
				<td align="center" width="100"><input type="text" name="id" value="<%=id%>" class=white></td>
				<td class="title" width="100">사용자</td>
				<td align="center" width="100">
					<select name="user_id" onChange="javascript:UserSearch()">
						<option value="">선택</option>
<%
    for(int i=0; i<u_r.length; i++){
        u_bean = u_r[i];
%>
						<option value="<%=u_bean.getUser_id()%>"><%=u_bean.getUser_nm()%></option>
<%}%>
					<script language="JavaScript">
					<!--
					document.IpUpForm.user_id.value = '<%=user_id%>';
					//-->
					</script>
				</td>
				<td class="title" width="100">부서</td>
				<td align="center" width="100"><input type="text" name="dept_nm" value="<%=dept_nm%>" class=white></td>
				<td class="title" width="100">직위</td>
				<td align="center" width="100"><input type="text" name="user_pos" value="<%=user_pos%>" class=white></td>
			
			</tr>
			<tr>
				<td class="title">휴대폰</td>
				<td align="left" colspan=7><input type="text" name="user_m_tel" value="<%=user_m_tel%>" class=white></td>
			</tr>
			
		</table>
		<input type="hidden" name="ip_auth" value="">
	</td>
	</tr>
	</form>
	<tr>
		<td align='right'>
			<a href="javascript:IpAddUpDel('i')" onMouseOver="window.status=''; return true"> 등록 </a>&nbsp;
			<a href="javascript:IpAddUpDel('u')" onMouseOver="window.status=''; return true"> 수정 </a>&nbsp;
			<a href="javascript:IpAddUpDel('d')" onMouseOver="window.status=''; return true"> 삭제 </a>&nbsp;
		</td>
	</tr>	
</table>
<form name="UserSearchForm" action="./user_null_ui.jsp" method="post">
<input type="hidden" name="user_id" value="">
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>
</iframe>
</body>
</html>