<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

%>
<html>
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>

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
select {
    width: 40%;
    padding: 4px 8px;
    border: 1px solid ;
    border-radius: 4px;
    background-color: #ffff;
	font-size: 1em;
}
</style>
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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<script>
$(function() {
	$("#gubun2").chained("#gubun1");
});
</script>
</head>
<body>
<form name='form1' action='survey_list_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<div class="navigation">
	<span class=style1>콜센터 ></span><span class=style5>콜 항목 관리</span>
</div>
<div class="search-area">
	<label><i class="fa fa-check-circle"></i> 구분 </label>
	<select id="gubun1" name="gubun1"  class="select" style="width:150px;">
		<option value = ""  <%if(gubun1.equals("")){out.print("selected");}%>> 선택 </option>
		<option value = "계약" <%if("계약".equals(gubun1)){out.print("selected");}%>>계약</option>
		<option value = "순회정비" <%if("순회정비".equals(gubun1)){out.print("selected");}%>>순회정비</option>
		<option value = "사고처리" <%if("사고처리".equals(gubun1)){out.print("selected");}%>>사고처리</option>
	</select>
	<label><i class="fa fa-check-circle"></i> 계약타입 </label>
	<select id="gubun2" name="gubun2" class="select" style="width:150px;">
		<option value = ""  <%if(gubun2.equals("")){out.print("selected");}%>> 선택 </option>
		<option class="계약" value = "신규"  <%if(gubun2.equals("신규")){out.print("selected");}%>> 신규 </option>
		<option class="계약" value = "대차"  <%if(gubun2.equals("대차")){out.print("selected");}%>> 대차 </option>
		<option class="계약" value = "증차"  <%if(gubun2.equals("증차")){out.print("selected");}%>> 증차 </option>
		<option class="계약" value = "재리스"  <%if(gubun2.equals("재리스")){out.print("selected");}%>> 재리스 </option>
		<option class="계약" value = "월렌트"  <%if(gubun2.equals("월렌트")){out.print("selected");}%>> 월렌트 </option>
		<option class="순회정비" value = "순회정비"  <%if(gubun2.equals("순회정비")){out.print("selected");}%>> 순회정비 </option>
		<option class="사고처리" value = "사고처리"  <%if(gubun2.equals("사고처리")){out.print("selected");}%>> 사고처리 </option>
	</select>
	<label><i class="fa fa-check-circle"></i> 사용여부 </label>
	<select id="gubun3" name="gubun3" class="select" style="width:150px;">
		<option value="" <%if(gubun3.equals("")){%>selected<%}%>> 사용여부 </option>
		<option value="Y" <%if(gubun3.equals("Y")){%>selected<%}%>> 사용 </option>
		<option value="N" <%if(gubun3.equals("N")){%>selected<%}%>> 미사용 </option>
	</select>
	<input type="button" class="button" value="검색" onclick="search()"/>
</div>

</form>
</body>
</html>
