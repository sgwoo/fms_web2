<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="clre_db" scope="page" class="acar.cl.ClRegDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String s_con = request.getParameter("s_con")==null?"":request.getParameter("s_con");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
%>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='javascript'>
<!--
//-->
</script>
</head>

<body>
<%	if(!s_con.equals("")){%>
<table border="0" cellspacing="0" cellpadding="0" width=600>
	<tr>
		<td class='line' colspan='2'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
        <%	Vector clients = clre_db.getClientList(s_con, t_wd);
			int client_size = clients.size();
			if(client_size > 0){
				for(int i = 0 ; i < client_size ; i++){
					Hashtable client = (Hashtable)clients.elementAt(i);	%>
        <tr> 
          <td width='30' align='center'><%= i+1 %></td>
          <td width='70' align='center'><%=client.get("CLIENT_ST_NM")%></td>
          <td width='180' align='center'><a href="javascript:parent.select('<%= client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><span title='<%=client.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("FIRM_NM")), 15)%></span></a></td>
          <td width='120' align='center'><span title='<%=client.get("CLIENT_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("CLIENT_NM")), 8)%></span></td>
          <td width='100' align='center'>&nbsp;</td>
          <td width='100' align='center'><%=client.get("M_TEL")%></td>
        </tr>
        <%				}
			}else{	%>
        <tr> 
          <td align='center' colspan="6">등록된 데이타가 없습니다</td>
        </tr>
        <%			}		%>
      </table>
		</td>
	</tr>
</table>
<%	}%>
</body>
</html>