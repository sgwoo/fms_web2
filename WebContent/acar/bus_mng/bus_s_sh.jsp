<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="bus_s_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	
		
	
%>
<form action="./bus_s_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > <span class=style5>사원별차량배정에 따른 대여료 채권현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_jr.gif"  align="absmiddle" border="0">&nbsp;
        <select name="sort">
          <option value="1" <%if(sort.equals("1")){%> selected <%}%>>성명</option>
          <option value="2" <%if(sort.equals("2")){%> selected <%}%>>입사일자</option>
          <option value="3" <%if(sort.equals("3")){%> selected <%}%>>총대수</option>
          <option value="4" <%if(sort.equals("4")){%> selected <%}%>>총받을어음</option>
          <option value="5" <%if(sort.equals("5")){%> selected <%}%>>일반식대수</option>
          <option value="6" <%if(sort.equals("6")){%> selected <%}%>>일반식받을어음</option>
          <option value="7" <%if(sort.equals("7")){%> selected <%}%>>기본식대수</option>
          <option value="8" <%if(sort.equals("8")){%> selected <%}%>>기본식받을어음</option>		            
          <option value="10" <%if(sort.equals("10")){%> selected <%}%>>연체율</option>		  
        </select>
        <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%>><!-- onClick='javascript:Search()'-->
        오름차순 
        <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>>
        내림차순&nbsp;&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
    </tr>	
</table>
</form>
</body>
</html>