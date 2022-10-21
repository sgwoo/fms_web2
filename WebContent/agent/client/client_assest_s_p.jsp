<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	String br_id = login.getCookieValue(request, "acar_br");
	String auth_rw = rs_db.getAuthRw(user_id, "22", "01", "01");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='javascript'>
<!--
	function select(seq){		
		var fm = document.form1;
		fm.seq.value = seq;
		if (seq == "") 
			fm.action='./client_assest_i_p.jsp';
		else
			fm.action='./client_assest_u_p.jsp';
		fm.target='CLIENT_SITE';
		fm.submit();
	}
	
	function search(){
		var fm = document.form1;

		fm.action='./client_assest_s_p.jsp';
		fm.target='CLIENT_SITE';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
//-->
</script>
</head>

<body leftmargin="15" >
<center>
<form name='form1' action='' method='post'>

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>
<input type='hidden' name='seq' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=620>
	<tr>
		<td colspan='2'>
			<font color="navy">영업지원  -> </font><font color="navy"> 고객 관리 -> <font color="red">거래서 자산 </font>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=600>
				<tr>
				  <td align='left'>&nbsp;</td>					
              	  <td align='right'>
		          <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
				  <!-- <a href="javascript:select('')" target='CLIENT_SITE'><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>-->
				   <%}%> 
              	  </td>
				</tr>
			</table>
		</td>
		<td width='20'></td>
	</tr>
	<tr>
		<td class='line' width='600'>
			<table border="0" cellspacing="1" cellpadding="0" width=600>
				<tr>
					<td class='title' width='50'>연번</td>
					<td class='title' width='200'>법인 물건지1</td>
					<td class='title' width='200'>대표이사 물건지1</td>
					
				</tr>
			</table>
		</td>
		<td width='20'></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="./client_assest_s_in.jsp?client_id=<%=client_id%>" name="inner" width="620" height="350" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
		</td>
	</tr>
	<tr>
		<td colspan='2'>
			&nbsp;<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a>						
		</td>
	</tr>	
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>