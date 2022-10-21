<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	/*여기부터 수정문안*/
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");

	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String g_fm = "1";
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body>

<form name='form1' action='survey_ve_sc.jsp' target='c_foot' method='post'>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
    	<td>
    	    <table width="100%" border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7 rowspan=2><img src="/acar/images/center/menu_bar_1.gif" width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/menu_bar_dot.gif" width=4 height=5 align=absmiddle>&nbsp;<span class=style1>콜센터 > <span class=style5>콜항목관리</span></span></td>
                    <td width=7 rowspan=2><img src="/acar/images/center/menu_bar_2.gif" width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td>
            <table border=0 cellspacing=1 width=100%>
                <tr> 
					<td width="300">&nbsp;&nbsp;&nbsp;
						<input type="radio" name="gubun1" value="1" <%if(gubun1.equals("1"))%>checked<%%>>계약 
						<input type="radio" name="gubun1" value="2" <%if(gubun1.equals("2"))%>checked<%%>>순회정비
						<input type="radio" name="gubun1" value="3" <%if(gubun1.equals("3"))%>checked<%%>>사고처리
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
