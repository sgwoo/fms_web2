<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
-->
</script>
</head>

<body>
<center>
<%
	String h_con = request.getParameter("h_con")==null?"":request.getParameter("h_con");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
	if(!h_wd.equals("")){
%>

<form name='form1' action='client_s_p.jsp' method='post'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='h_con' value='<%=h_con%>'>
<input type='hidden' name='h_wd' value='<%=h_wd%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line' colspan='2'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%			Vector clients = al_db.getClientList(h_con, h_wd);
			int client_size = clients.size();
			if(client_size > 0){
				for(int i = 0 ; i < client_size ; i++){
					Hashtable client = (Hashtable)clients.elementAt(i);	%>
				<tr>
					<td width='17%' align='center'>
					<a href="javascript:parent.select('<%= client.get("CLIENT_ST")%>','<%= client.get("CLIENT_ID")%>','<%= client.get("FIRM_NM")%>','<%= client.get("ENP_NO")%>','<%= client.get("SSN")%>','<%= client.get("O_ZIP")%>','<%= client.get("O_ADDR")%>','<%= client.get("CON_AGNT_EMAIL")%>','<%= client.get("O_TEL")%>','<%= client.get("M_TEL")%>')" onMouseOver="window.status=''; return true">
					    <%=AddUtil.ChangeEnpH(String.valueOf(client.get("ENP_NO")))%>
						<%if(!String.valueOf(client.get("SSN")).equals(String.valueOf(client.get("ENP_NO")))){%>
					    <br><br>
					    <%=AddUtil.ChangeEnpH(String.valueOf(client.get("SSN")))%>
					  <%}%></a>
					</td>
					<td width='28%' align='center'><span title='<%=client.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("FIRM_NM")), 15)%></span></td>
					<td width='10%' align='center'><span title='<%=client.get("CLIENT_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("CLIENT_NM")), 8)%></span></td>
					<td width='18%' align='center'><%=client.get("M_TEL")%></td>					
					<td width='27%' align='center'>
					    <table width=100% border=0 cellspacing=0 cellpadding=3>
					        <tr>
					            <td><%=client.get("O_ADDR")%></td>
					        </tr>
					    </table>
					</td>
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
<%	}	%>
</center>
</body>
</html>
