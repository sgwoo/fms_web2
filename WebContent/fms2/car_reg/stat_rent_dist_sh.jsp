<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "07", "07", "03");
		
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String sh_height 	= request.getParameter("sh_height")==null?"":request.getParameter("sh_height");
	

%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.action = 'stat_rent_dist_sc.jsp';
		fm.target = 'c_foot';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
//-->
</script>
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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin=15>
<form name='form1' action='' target='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>

<div class="navigation">
	<span class=style1>현황 및 통계 > 차량관리 ></span><span class=style5>초과운행차량현황</span>
</div>
<div class="search-area">
	<label><i class="fa fa-check-circle"></i> 담당자 </label>
	<input type='text' name='gubun1' size='10' class='text' value='<%=gubun1%>' style='IME-MODE: active'>
	&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> 관리구분 </label>
	<select id="gubun2" name="gubun2" class="select" style="width:100px;">
		<option value='' <%if(gubun2.equals("")){%>selected<%}%>>전체</option>
		<option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>일반식</option>
		<option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>기본식</option>
	</select>
	&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> 검색조건 </label>
	<select id="s_kd" name="s_kd" class="select" style="width:100px;">
		<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호</option>
		<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>차량번호</option>
	</select>
	&nbsp;
	<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	&nbsp;&nbsp;
	<input type="button" class="button" value="검색" onclick="search()"/>
</div>
</form>
</body>
</html>
