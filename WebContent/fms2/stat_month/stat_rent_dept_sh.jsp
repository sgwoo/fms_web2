<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//검색
	function Search()
	{
		var fm = document.form1;
		
		if(fm.gubun1.value == '' && fm.st_dt.value == '' && fm.end_dt.value == ''){
			alert('기간일 경우 날짜를 입력하십시오.');
			return;
		}
		
		fm.target = "c_foot";		
		fm.action = 'stat_rent_dept_sc.jsp';		
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 영업현황 > <span class=style5>부서별계약현황</span></span></td>
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
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
			<select name='gubun1'>
                    	    <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>당일</option>
                    	    <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>전일</option>
                    	    <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>전전일</option>
                    	    <option value="4" <%if(gubun1.equals("4"))%>selected<%%>>당월</option>
                    	    <option value="5" <%if(gubun1.equals("5"))%>selected<%%>>전월</option>
                    	    <option value="6" <%if(gubun1.equals("6"))%>selected<%%>>전전월</option>
                    	    <option value="9" <%if(gubun1.equals("9"))%>selected<%%>>기간</option>					
                  	</select>
	        	&nbsp;				  
                    	<input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
			~
			<input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text">	  
            		&nbsp;
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