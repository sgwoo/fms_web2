<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		fm.target = "c_foot";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int year =AddUtil.getDate2(1);
%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="holiday_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 코드관리 > <span class=style5>공휴일 관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td> 
            <table border="0" cellspacing="1" cellpadding="0" width="300">
                <tr> 
                    <td width="200">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gg.gif align=absmiddle>&nbsp;
                        <select name="s_year">
                            <option value="" <%if(s_year == 0){%>selected<%}%>>전체</option>
                            <%for(int i=2010; i<=year+10; i++){%>
                            <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                            <%}%>
                        </select>
                </td>
                    <td><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
                </tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>