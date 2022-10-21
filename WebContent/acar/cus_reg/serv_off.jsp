<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
	
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function select(off_id){		
		var fm = document.form1;		
		fm.action='serv_off_sel.jsp?h_page_gubun=EXT&off_id='+off_id;	//h_page_gubun=EXT:기존고객 세팅
		fm.submit();
	}
	
	function search(){
		var fm = document.form1;
		fm.h_wd.value =  fm.t_wd.value;
		fm.action='serv_off.jsp';
		fm.target='popwin_serv_off';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
function openServOffReg(){
	var SUBWIN="serv_off_reg.jsp"; 
	window.open(SUBWIN, 'popwin_serv_off','scrollbars=yes,status=yes,resizable=yes,width=550,height=420,left=100,top=120');
}
//-->
</script>
</head>

<body leftmargin="15" onLoad="javascript:document.form1.t_wd.focus();">
<center>
<form name='form1' action='' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='h_wd' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 자동차정비등록 > <span class=style5>정비업체검색</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h colspan=2></td>
    </tr>
	<tr>
		<td colspan=2>
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>					
                    <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jbucm.gif align=absmiddle>
                    <input type='text' name='t_wd' size='25' class='text' value='' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                    &nbsp;<a href='javascript:search()'><img src=../images/center/button_search.gif align=absmiddle border=0></a></td>					
                  	  <td align='right'>&nbsp;<a href='javascript:openServOffReg()'><img src=../images/center/button_reg.gif align=absmiddle border=0></a> 
                  	  </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line' align=center> 
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=5%>연번</td>
                    <td class='title' width=20%>&nbsp;업체명&nbsp;</td>
    			    <td class='title' width=15%>&nbsp;사업자번호&nbsp;</td>
                    <td class='title' width=10%>&nbsp;&nbsp;&nbsp;급수&nbsp;&nbsp;&nbsp;</td>
                    <td class='title' width=15%>&nbsp;&nbsp;지정업체&nbsp;&nbsp;</td>
                    <td class='title' width=10%>&nbsp;&nbsp;대표자&nbsp;&nbsp;</td>
                    <td class='title' width=25%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
		<td width='17'></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="serv_off_in.jsp?h_wd=<%=h_wd%>" name="inner" width="100%" height="350" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
		</td>
	</tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>