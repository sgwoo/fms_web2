<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.client.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector c_sites = al_db.getClientSites(client_id);
	int c_site_size = c_sites.size();
%>
<form name='form1' method='post' action='/acar/mng_client2/client_mm_i_a.jsp'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=500>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=500>
<%	if(c_site_size > 0){
		for(int i = 0; i < c_site_size ; i++){
						ClientSiteBean site = (ClientSiteBean)c_sites.elementAt(i);%>
				<tr>
					<td align='center' width='80'><%=site.getReg_dt()%></td>
					<td align='center' width='80'><%=c_db.getNameById(site.getReg_id(), "USER")%></td>
					<td width='340'>
						<table border="0" cellspacing="1" cellpadding="0" width=340>
							<tr>
								<td width='5'></td>
								<td><%=Util.htmlBR(site.getR_site())%></td>
							</tr>
						</table>
				</tr>
<%		}
	}else{%>
				<tr>
					<td colspan='3' align='center'>등록된 데이타가 없습니다</td>
				</tr>
<%	}%>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
