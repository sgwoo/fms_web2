<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, cust.member.*"%>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	
	MemberBean bean = m_db.getMemberCase(client_id, r_site, member_id);
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save(){
		var fm = document.form1;
		if(fm.pwd.value == ''){ 	alert('비밀번호를 입력하십시오'); 	fm.pwd.focus(); 	return;}		
		if(fm.email.value == ''){ 	alert('이메일을 입력하십시오'); 	fm.email.focus(); 	return;}				
		if(fm.pwd.value.length < 5){ 	alert('비밀번호는 5자 이상입니다.');fm.pwd.focus(); 	return;}				
		if(!confirm('수정하시겠습니까?')){ return; }
		fm.cmd.value= "u";
		fm.target="i_no";
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') save();
	}	
	
	function LoadMain(){
		opener.location.href = "member_c.jsp";
		self.close();
		window.close();
	}	
//-->
</script>
</head>
<body  onLoad="document.form1.id.focus()">
<center>
<form action="./member_u_null.jsp" name="form1" method="POST" >
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="member_id" value="<%=member_id%>">
<input type='hidden' name="client_id" value="<%=client_id%>">
<input type='hidden' name="r_site" value="<%=r_site%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="chk_st" value="">
    <table border=0 cellspacing=0 cellpadding=0 width=400>
      <tr> 
        <td ><font color="navy">&lt;회원정보 수정&gt;</font></td>
      </tr>
      <tr> 
        <td ><font color="#666666"> </font></td>
      </tr>
      <tr> 
        <td class=line> 
          <table border="0" cellspacing="1" width=400>
            <tr> 
              <td class=title width="80">ID</td>
              <td width="320"><%=bean.getMember_id()%></td>
            </tr>
            <tr> 
              <td class=title>비밀번호</td>
              <td> 
                <input type="password" name="pwd" value="<%=bean.getPwd()%>" size="17" class=text>
                <font color="#666666">(6자 이상 입력하십시오)</font></td>
            </tr>
            <tr> 
              <td class=title>이메일</td>
              <td> 
                <input type="text" name="email" value="<%=bean.getEmail()%>" size="45" class=text style='IME-MODE: inactive'>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr> 
        <td> 
          <table border="0" cellspacing="3" width=400>
            <tr> 
              <td align="right"> <a href='javascript:save();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>