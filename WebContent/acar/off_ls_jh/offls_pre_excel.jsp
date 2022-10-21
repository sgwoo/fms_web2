<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="olyD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] pre = request.getParameterValues("pr");
	String c_id = "";
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%' height="43">
				<tr> 
					<td class='title' width="5%">연번</td>
					<td class='title' width="20%">차량번호</td>
					<td class='title' width="30%">차량명</td>
					<td class='title' width="15%">최초등록일</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='line' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			<%
			for(int i=0; i<pre.length; i++){
				pre[i] = pre[i].substring(0,6);
				c_id = pre[i];
				
			Hashtable ht = olyD.getSearch_list(c_id);
			%>
			<tr>
				<td width="5%" align="center"><%=i+1%></td>
				<td width="20%" align="center"><%=ht.get("CAR_NO")%></td>
				<td width="30%" align="center"><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
				<td width="15%" align="center"><%=AddUtil.ChangeDate2((String)ht.get("INIT_REG_DT"))%></td>
			</tr>
			<%}%>
			</table>
		</td>
	</tr>
</table>


</body>

</html>

