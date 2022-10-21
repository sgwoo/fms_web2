<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"000071":request.getParameter("gubun1");

	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int st_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int st_mon = request.getParameter("s_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_mon"));	
	int year =AddUtil.getDate2(1);
	
%>
<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
				
//-->
</script>
</head><%@ include file="/acar/getNaviCookies.jsp" %>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
select {
    width: 40%;
    padding: 4px 8px;
    border: 1px solid ;
    border-radius: 4px;
    background-color: #ffff;
	font-size: 1em;
}
</style>
<body>

<form name='form1' action='park_list_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<div class="navigation">
	<span class=style1>차량관리 >보유차관리 ></span><span class=style5></span>
</div>
<div class="search-area">
<label><i class="fa fa-check-circle"></i> 기준일 </label>
	<select name="st_year" class="select" style="width:150px;">
		<%for(int i=2016; i<=year; i++){%>
		<option value="<%=i%>" <%if(st_year == i){%>selected<%}%>><%=i%>년</option>
		<%}%>
	</select>
	<select name="st_mon" class="select" style="width:150px;">
				<%for(int i=1; i<=12; i++){%>
				<option value="<%if(i<10){%>0<%}%><%=i%>" <%if(st_mon == i){%>selected<%}%>><%=i%>월</option>
				<%}%>
			</select>
<input type="button" class="button" value="검색" onclick="search()"/> 	
</div>
</form>
</body>
</html>
