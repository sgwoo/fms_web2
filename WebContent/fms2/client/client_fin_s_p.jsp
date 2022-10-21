<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	String br_id = login.getCookieValue(request, "acar_br");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "03", "07");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");	

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function select(seq){		
		var fm = document.form1;
		fm.seq.value = seq;
		if (seq == "") 
			fm.action='./client_fin_i_p.jsp';
		else
			fm.action='./client_fin_u_p.jsp'; 
		fm.target='CLIENT_SITE';
		fm.submit();
	}
	
	function search(){
		var fm = document.form1;

		fm.action='./client_fin_s_p.jsp';
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
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리 > <span class=style5>거래처 약식재무제표</span></span> : 거래처 약식재무제표</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
				  <td align='left'>&nbsp;</td>					
              	  <td align='right'>
		          <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
				   <!--<a href="javascript:select('')" target='CLIENT_SITE'><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>-->
				   <%}%> 
              	  </td>
				</tr>
			</table>
		</td>
		<td width='17'></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='10%'>연번</td>
					<td class='title' width='45%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;당기&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class='title' width='45%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;전기&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>					
				</tr>
			</table>
		</td>
		<td width='17'></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="./client_fin_s_in.jsp?client_id=<%=client_id%>" name="inner" width="100%" height="350" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
		</td>
	</tr>	
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>