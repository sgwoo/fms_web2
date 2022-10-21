<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String start_dt = request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	//검색
	function Search()
	{
		var fm = document.form1;		
		fm.target = "c_foot";		
		fm.action = 'rm_stat2_sc.jsp';	
		fm.submit();
	}
	
	function save()
	{
		var fm = document.form1;		
		fm.target = '_blank';		
		fm.action = 'rm_stat2_sc.jsp';								
		fm.submit();
	}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body leftmargin=15>
<form name="form1" method="POST">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 월렌트관리 > <span class=style5>신규영업현황</span></span></td>
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
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<!--기간-->
                    	<img src=/acar/images/center/arrow_gggs.gif align=absmiddle>&nbsp;
	    		<select name='gubun4'>
                    	  <option value="2" <%if(gubun4.equals("2"))%>selected<%%>>당일</option>
		    	  <option value="4" <%if(gubun4.equals("4"))%>selected<%%>>전일</option>
                    	  <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>당월</option>
		    	  <option value="5" <%if(gubun4.equals("5"))%>selected<%%>>전월</option>
                    	  <option value="3" <%if(gubun4.equals("3"))%>selected<%%>>기간</option>					
            		</select>	
            		&nbsp;	
            		<input type='text' name='start_dt' size='11' class='text' value='<%=start_dt%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
            		~ 
            		<input type='text' name='end_dt' size='11' class='text' value='<%=end_dt%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>     			              		
            		&nbsp;&nbsp;
            		<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
		    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>