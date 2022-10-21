<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	Vector conts = l_db.getOLContList(client_id);
	int cont_size = conts.size();
	int valid_cont_cnt = 0;
%>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
	if(cont_size > 0)
	{
		for(int i = 0 ; i < cont_size ; i++)
		{
			Hashtable cont = (Hashtable)conts.elementAt(i);
%>
				<tr>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='3%'><%=i+1%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='10%'><%=cont.get("CAR_NO")%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='15%'><%=cont.get("CAR_NM")%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='10%'><%=cont.get("CONT_DT")%></td>					
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='10%'><%=cont.get("MM_PR")%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='10%'><%=cont.get("MIGR_DT")%></td>		
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='32%'><%=cont.get("FIRM_NM")%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='10%'><%=cont.get("USER_NM")%></td>
				</tr>
<%			
				valid_cont_cnt += 1;
		}
%>
<%
	}else{
%>				<tr>
					<td>&nbsp;등록된 계약이 없습니다</td>
				</tr>
<%	}
%>
			</table>
		</td>
	</tr>
</table>
<script language='javascript'>
<!--
	parent.form1.valid_o_cont_cnt.value = '<%=valid_cont_cnt%>';
//-->
</script>
</body>
</html>
