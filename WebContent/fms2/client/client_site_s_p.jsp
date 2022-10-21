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
	String h_con = request.getParameter("h_con")==null?"":request.getParameter("h_con");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function select(site_id, from_page , site_nm ){		

		var fm = document.form1;
		
		if (from_page == '' ){
			fm.site_id.value = site_id;
			fm.action='./client_site_i_p.jsp';
			fm.target='CLIENT_SITE';
			fm.submit();
		}else{
			window.opener.form1.site_id.value = site_id;
			window.opener.form1.site_nm.value = site_nm;
			window.self.close();
		}	
	}
	
	function search(){
		var fm = document.form1;
		fm.h_con.value = fm.s_con.options[fm.s_con.selectedIndex].value;
		fm.h_wd.value =  fm.t_wd.value;
		fm.action='./client_site_s_p.jsp';
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

<body leftmargin="15" onLoad="javascript:document.form1.t_wd.focus();">
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name='h_con' value=''>
<input type='hidden' name='h_wd' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>
<input type='hidden' name='site_id' value=''>
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리 > <span class=style5>지점/현장 검색</span></span> : 지점/현장 검색</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td colspan=2>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;
						<select name='s_con'>
							<option value='1' <%if(h_con.equals("1")){%> selected <%}%>> 지점/현장명 	</option>
						</select>
						<input type='text' name='t_wd' size='15' class='text' value='<%=h_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                	<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>					
              	  <td align='right'>
		          <%	if(auth_rw.equals("2") || auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
				   <a href='/acar/mng_client2/client_site_i_p.jsp?client_id=<%=client_id%>&from_page=<%=from_page%>' target='CLIENT_SITE'><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>			   <%}%> 
              	  &nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>

	<tr>
		<td colspan=2>
			<iframe src="./client_site_s_in.jsp?client_id=<%=client_id%>&h_con=<%=h_con%>&h_wd=<%=h_wd%>&from_page=<%=from_page%>" name="inner" width="100%" height="350" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
		</td>
	</tr>
	<tr>
		<td colspan=2>
			&nbsp;<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>						
		</td>
	</tr>	
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>