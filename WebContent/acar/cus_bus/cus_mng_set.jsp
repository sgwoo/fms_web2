<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "MNG_EMP"); //고객지원팀 리스트
	int user_size = users.size();	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='javascript'>
<!--
function set(rmg,rld){
	var fm = document.form1;
	fm.action = "cus_mng_set_reg.jsp";
	fm.target = "i_no";
	fm.submit();
}	
-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="rent_mng_id" value="<%= rent_mng_id %>">
<input type="hidden" name="rent_l_cd" value="<%= rent_l_cd %>">
<input type="hidden" name="mode" value="<%= mode %>">
<table width="200" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td><select name='mng_id'>
        <option value="">=선택=</option>
        <%if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
						  Hashtable user = (Hashtable)users.elementAt(i);%>
        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
        <%	}
					}%>
      </select>
      <a href="javascript:set()"><img src="/images/reg.gif" width="50" height="18" align="absbottom" border="0"></a>&nbsp;<a href="javascript:window.close();"><img src="/images/close.gif" width="50" height="18" align="absbottom" border="0"></a></td>
  </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
