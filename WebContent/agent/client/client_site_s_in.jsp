<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String h_con = request.getParameter("h_con")==null?"":request.getParameter("h_con");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='javascript'>
<!--
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='./client_s_p.jsp' method='post'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='h_con' value=''>
<input type='hidden' name='h_wd' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%			Vector c_sites = al_db.getClientSiteList(client_id, h_wd);
			int c_site_size = c_sites.size();
			if(c_site_size > 0){
				for(int i = 0 ; i < c_site_size ; i++){
					ClientSiteBean site = (ClientSiteBean)c_sites.elementAt(i);%>
				<tr>
					<td width='17%' align='center'>
					<%if(site.getSite_st().equals("1")){%>지점
					<%}else{%>현장<%}%>
					</td>
					<td width='30%' align='center'><a href="javascript:parent.select('<%= site.getSeq()%>','<%= from_page%>', '<%= site.getR_site()%>')" onMouseOver="window.status=''; return true"><span title='<%=site.getR_site()%>'><%=AddUtil.subData(site.getR_site(), 15)%></span></a></td>
					<td width='20%' align='center'><a href="javascript:parent.select('<%= site.getSeq()%>','<%= from_page%>', '<%= site.getR_site()%>')" onMouseOver="window.status=''; return true"><%=site.getSite_jang()%></a></td>
					<td width='33%' align='center'><span title='<%=site.getAddr()%>'><%=AddUtil.subData(site.getAddr(), 16)%></span></td>					
				</tr>
<%				}
			}else{	%>		
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
<%			}		%>			
			</table>
		</td>
	</tr>
</table>
</form>
</center>
</body>
</html>
