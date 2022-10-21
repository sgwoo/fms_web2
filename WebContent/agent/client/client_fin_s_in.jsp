<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%			Vector c_sites = al_db.getClientFinList(client_id);
			int c_site_size = c_sites.size();
			if(c_site_size > 0){
				for(int i = 0 ; i < c_site_size ; i++){
					ClientFinBean fin = (ClientFinBean)c_sites.elementAt(i);%>
				<tr>
					<td width='10%' align='center'><a href="javascript:parent.select('<%= fin.getF_seq()%>')" onMouseOver="window.status=''; return true"><%= fin.getF_seq()%></a>
					</td>
					<td width='45%' align='center'><%=fin.getC_kisu()%>&nbsp;기&nbsp;&nbsp;(<%=fin.getC_ba_year_s()%>~<%=fin.getC_ba_year()%>)</td>
					<td width='45%' align='center'><%=fin.getF_kisu()%>&nbsp;기&nbsp;&nbsp;(<%=fin.getF_ba_year_s()%>~<%=fin.getF_ba_year()%>)</td>					
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
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
		<td align=right>
			<a href="javascript:parent.self.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>						
		</td>
	</tr>	
</table>
</form>
</center>
</body>
</html>
