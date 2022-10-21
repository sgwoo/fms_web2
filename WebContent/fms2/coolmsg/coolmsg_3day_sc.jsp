<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 
<%@ include file="/acar/access_log.jsp" %>

<%
	Vector vt = cm_db.getBkAlertList();
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
	<table border="0" cellspacing="0" cellpadding="0" width='100%'>
		<tr>
			<td>
				<table width=100% border=0 cellpadding=0 cellspacing=0 >
					<tr>
						<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
						<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>FMS운영관리 > Admin > <span class=style5>3일이내메시지확인</span></span></td>
						<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
					</tr>
				</table>
			</td>
		</tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr><td class=line2></td></tr>
		<tr>
			<td class=line>
				<table border="0" cellspacing="1" cellpadding="1" width=100%>
					<tr>
						<td width='5%' class='title'>연번</td>
						<td width='15%' class='title'>등록일시</td>
						<td width='80%' class='title'>메시지</td>						
					</tr>
					<%	for(int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
					<tr>
						<td align='center'><%=i+1%></td>
						<td align='center'><%=ht.get("FLDWRITEDATE")%></td>
						<td><%=ht.get("FLDDATA")%></td>						
					</tr>
					<%
							}
					%>
				</table>
			</td>	
		</tr>
	</table>
</body>
</html>
