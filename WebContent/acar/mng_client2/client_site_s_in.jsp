<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

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
<input type='hidden' name='h_con' value=''>
<input type='hidden' name='h_wd' value=''>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String h_con = request.getParameter("h_con")==null?"":request.getParameter("h_con");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='5%'>구분</td>
					<td class='title' width='25%'>상호</td>
					<td class='title' width='15%'>대표자</td>
					<td class='title' width='25%'>주소</td>
					<td class='title' width='15%'>이메일</td>
					<td class='title' width='15%'>비고</td>
				</tr>			
<%			Vector c_sites = al_db.getClientSiteList(client_id, h_wd);
			int c_site_size = c_sites.size();
			if(c_site_size > 0){
				for(int i = 0 ; i < c_site_size ; i++){
					ClientSiteBean site = (ClientSiteBean)c_sites.elementAt(i);%>
                <tr>
					<td width='5%' align='center'>
					<%if(site.getSite_st().equals("1")){%>지점
					<%}else{%>현장<%}%>
					</td>
					<td width='25%' align='center'><a href="javascript:parent.select('<%= site.getSeq()%>')" onMouseOver="window.status=''; return true"><%=site.getR_site()%>(<%= site.getSeq()%>)</a><br><%=site.getEnp_no()%></td>
					<td width='15%' align='center'><a href="javascript:parent.select('<%= site.getSeq()%>')" onMouseOver="window.status=''; return true"><%=site.getSite_jang()%></a></td>
					<td width='25%' align='center'><%=site.getAddr()%></td>					
					<td width='15%' align='center'><%=site.getAgnt_nm()%><br><%=site.getAgnt_email()%></td>					
					<td width='15%' align='center'><%=site.getBigo_value()%></td>					
				</tr>
<%				}
			}else{	%>		
				<tr>
					<td align='center' colspan='6'>등록된 데이타가 없습니다</td>
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
