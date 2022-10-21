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
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	Vector conts = l_db.getContList(client_id);
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
					<td align='center' width='5%'><%=i+1%></td>
					<td align='center' width='13%'><%=cont.get("RENT_L_CD")%></td>
					<td align='center' width='10%'><%=cont.get("RENT_DT")%></td>
					<td align='center' width='12%'><%=cont.get("CAR_NO")%></td>
					<td align='center' width='18%'><%=cont.get("CAR_NM")%></td>
					<td align='center' width='18%'><%=cont.get("RENT_START_DT")%>&nbsp;~&nbsp;<%=cont.get("RENT_END_DT")%></td>
					<td align='center' width='8%'><%=cont.get("RENT_WAY")%></td>
					<td align='center' width='8%'><%=cont.get("USER_NM")%></td>
					<td align='center' width='8%'><%=cont.get("IS_RUN")%></td>		
				</tr>
<%
			if((String.valueOf(cont.get("IS_RUN_NUM")).equals("0"))||(String.valueOf(cont.get("IS_RUN_NUM")).equals("1")))
				valid_cont_cnt += 1;
		}
%>
<%
	}else{
%>				<tr>
					<td colspan="9">&nbsp;등록된 계약이 없습니다</td>
				</tr>
<%	}
%>
			</table>
		</td>
	</tr>
</table>
<script language='javascript'>
<!--
	parent.form1.valid_cont_cnt.value = '<%=valid_cont_cnt%>';
-->
</script>
</body>
</html>
