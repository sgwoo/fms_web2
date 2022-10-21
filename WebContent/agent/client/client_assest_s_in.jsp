<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='javascript'>
<!--
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='./client_s_p.jsp' method='post'>
<input type='hidden' name='mode' value=''>

<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");

%>
<table border="0" cellspacing="0" cellpadding="0" width=600>
	<tr>
		<td class='line' colspan='2'>
			<table border="0" cellspacing="1" cellpadding="0" width=600>
<%			Vector c_sites = al_db.getClientAssestList(client_id);
			int c_site_size = c_sites.size();
			if(c_site_size > 0){
				for(int i = 0 ; i < c_site_size ; i++){
					ClientAssestBean assest = (ClientAssestBean)c_sites.elementAt(i);%>
				<tr>
					<td width='50' align='center'><a href="javascript:parent.select('<%= assest.getA_seq()%>')" onMouseOver="window.status=''; return true"><%= assest.getA_seq()%></a>
					</td>
					<td width='200' align='center'>(<%=assest.getC_ass1_type()%>)&nbsp;<%=AddUtil.subData(assest.getC_ass1_addr(), 16)%></td>
					<td width='200' align='center'>(<%=assest.getR_ass1_type()%>)&nbsp;<%=AddUtil.subData(assest.getR_ass1_addr(), 16)%></td>					
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
