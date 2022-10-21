<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.ip_mng.*" %>
<jsp:useBean id="i_bean" class="acar.ip_mng.IPLogBean" scope="page"/>
<%
	IpMngDatabase imd = IpMngDatabase.getInstance();
	String user_id = "";
    String user_nm = "";
    String ip = "";
    String id = "";
    String login_dt = "";
    String logout_dt = "";
    
	
	if(request.getParameter("ip") != null) ip = request.getParameter("ip");
	
	IPLogBean i_r [] = imd.getIpLogAll(ip);
	
%>
<html>
<head><title>[<%=ip%>]</title>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body onLoad="javascript:self.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td>
			<font color="navy">MASTER -> IP 관리 -> </font><font color="red">Login 정보</font>
		</td>
	</tr>

</table>
<table border=0 cellspacing=0 cellpadding=0 width=500>

    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=500>
            	<tr>
            		<td class='title' width='50'>연번</td>
					<td class='title' width='80'>Login ID</td>
					<td class='title' width='80'>성명</td>
					<td class='title' width='145'>로그인일시</td>
					<td class='title' width='145'>로그아웃일시</td>
				</tr>
<%
    for(int i=0; i<i_r.length; i++){
        i_bean = i_r[i];
%>
            	<tr>
            		<td align="center">&nbsp;<%=i+1%>&nbsp;</td>
            		<td align="center">&nbsp;<%=i_bean.getId()%>&nbsp;</td>
            		<td align="center">&nbsp;<%=i_bean.getUser_nm()%>&nbsp;</td>
            		<td align="center">&nbsp;<%=i_bean.getLogin_dt()%>&nbsp;</td>
            		<td align="center">&nbsp;<%=i_bean.getLogout_dt()%>&nbsp;</td>
            	</tr>
<%}%>
<% if(i_r.length == 0) { %>
            <tr>
                <td colspan=10 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>