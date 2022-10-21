<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, tax.*"%>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	Vector vts = ClientMngDb.getClientMngList(s_br, s_kd, t_wd);
	int vt_size = vts.size();
%>
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
<%	if(!s_kd.equals("")){%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
        <%	if(vt_size > 0){
				for(int i = 0 ; i < vt_size ; i++){
					Hashtable client = (Hashtable)vts.elementAt(i);	%>
        <tr> 
          <td width='30' align='center'><%= i+1 %></td>
          <td width='70' align='center'><%=client.get("CLIENT_ST")%></td>
          <td width='180' align='center'><a href="javascript:parent.select('<%= client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><span title='<%=client.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("FIRM_NM")), 15)%></span></a></td>
          <td width='100' align='center'><span title='<%=client.get("CLIENT_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("CLIENT_NM")), 8)%></span></td>
          <td width='120' align='center'>
			<%if(String.valueOf(client.get("ENP_NO")).equals("")){%>
			<%=AddUtil.ChangeEnpH(String.valueOf(client.get("SSN")))%></td>			
			<%}else{%>
			<%=AddUtil.ChangeEnp(String.valueOf(client.get("ENP_NO")))%></td>
			<%}%>		  
		  </td>
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