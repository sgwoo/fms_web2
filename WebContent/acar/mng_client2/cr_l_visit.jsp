<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cng_gubun = request.getParameter("cng_gubun")==null?"":request.getParameter("cng_gubun");
	
	Vector clients = al_db.getClientList(s_kd, t_wd, "0");
	int client_size = clients.size();
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language="JavaScript">
<!--
function view_client(client_id){
	var fm = document.form1;
	<%if(cng_gubun.equals("post")){%>
	fm.action = '/fms2/client/client_cont_cng.jsp?client_id='+client_id;
	fm.target = 'ClientContCng';	
	<%}else{%>
	fm.action = 'client_email.jsp?client_id='+client_id;
	fm.target = 'MailUp';
	<%}%>
	fm.submit();
	this.close();
}
//-->
</script>
</head>

<body>
<table width="300" border="0" cellspacing="1" cellpadding="0">
<form name="form1" method="post">
  <tr>
    <td class="line"><table width="100%" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td class="title" width="13%">연번</td>
          <td class="title" width="87%">상호명</td>
        </tr>
		<%for(int i = 0 ; i < client_size ; i++){
			Hashtable client = (Hashtable)clients.elementAt(i);%>
        <tr> 
          <td align="center"><%= i+1 %></td>
          <td>&nbsp;<span title='<%=client.get("FIRM_NM")%>'><a href="javascript:view_client('<%=client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(client.get("FIRM_NM")), 20)%></a></span></td>
        </tr>
		<%}%>
      </table></td>
  </tr>
</form>
</table>
</body>
</html>
