<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.serv_off.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
%>
<html>
<head>
<title>신규등록및선택</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function select(off_id){		
		var fm = document.form1;
		fm.action='./cus0401_d_sc_serv_off_i_a.jsp?h_page_gubun=EXT&off_id='+off_id;	//h_page_gubun=EXT:기존고객 세팅
		fm.submit();
	}
	
	function search(){
		var fm = document.form1;
		fm.h_wd.value =  fm.t_wd.value;
		fm.action='./cus0401_d_sc_serv_off.jsp';
		fm.target='CLIENT';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
//-->
</script>
</head>
<body onLoad="javascript:document.form1.t_wd.focus();">
<center>
<form name='form1' action='' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='h_wd' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>정비업체등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="3" width=100%>
				<tr>					
                    <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jbucm.gif align=absmiddle>&nbsp;
                        <input type='text' name='t_wd' size='15' class='text' value='' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                	    <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>					
              	    <td align='right'> <a href='cus0401_d_sc_serv_off_reg.jsp' target='CLIENT'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a> 
              	    </td>
				</tr>
			</table>
		</td>
		<td width=17></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'> 
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='7%'>연번</td>
                    <td class='title' width='13%'>정비급수</td>
                    <td class='title' width='27%'>업체명</td>
                    <td class='title' width='12%'>대표자</td>
                    <td class='title' width='41%'>주소</td>
                </tr>
            </table>
        </td>
		<td width=17></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="./cus0401_d_sc_serv_off_in.jsp?h_wd=<%=h_wd%>" name="inner" width="100%" height="350" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
		</td>
	</tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>