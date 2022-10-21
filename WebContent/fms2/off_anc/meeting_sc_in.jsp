<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<jsp:useBean id="b_bean" class="acar.off_anc.BulBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	int count = 0;
	
	
	String acar_id = ck_acar_id;
	
	OffBulDatabase oad = OffBulDatabase.getInstance();

	BulBean a_r [] = oad.getBulAll(gubun, gubun_nm, acar_id, "M");
%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<%if(a_r.length > 0){
					for(int i=0; i<a_r.length; i++){
						b_bean = a_r[i];
						String r_ch = b_bean.getRead_chk();
						String u_ch = b_bean.getUse_chk();
				%>
				<tr>
					<td <%if(u_ch.equals("N"))%>class='is2'<%%> width=5% align="center"><%=i+1%></td>				
					<td <%if(u_ch.equals("N"))%>class='is2'<%%> width=49%>&nbsp;<a href="javascript:parent.AncDisp('<%=b_bean.getB_id()%>')" onMouseOver="window.status=''; return true"><%if(r_ch.equals("1")){%><font color="#666666"><%=b_bean.getTitle()%></font><%}else{%><%=b_bean.getTitle()%><%}%></a></td>
					<td <%if(u_ch.equals("N"))%>class='is2'<%%> width=10% align="center"><%=b_bean.getUser_nm()%></td>
					<td <%if(u_ch.equals("N"))%>class='is2'<%%> width=12% align="center"><%=b_bean.getDept_nm()%></td>
					<td <%if(u_ch.equals("N"))%>class='is2'<%%> width=12% align="center"><%=b_bean.getReg_dt()%></td>
					<td <%if(u_ch.equals("N"))%>class='is2'<%%> width=12% align="center"><%=b_bean.getExp_dt()%></td>
				</tr>
				<%}	}else{%>
				<tr>
                	<td colspan=10 align=center height=25>등록된 데이타가 없습니다.</td>
            	</tr>
				<%	}%>
			</table>
		</td>
	</tr>
</table>
</body>
</html>