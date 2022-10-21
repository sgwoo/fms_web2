<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String st_nm = request.getParameter("st_nm")==null?"":request.getParameter("st_nm");
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>

<script language="JavaScript">
<!--
function SearchRentCond()
{
	var theForm = document.RentCondSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchRentCond();
}
function ChangeDT(arg)
{
	var theForm = document.RentCondSearchForm;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}

	//디스플레이 타입
	function cng_input(){
		var fm = document.RentCondSearchForm;
		if(fm.gubun1.options[fm.gubun1.selectedIndex].value == '3' ||fm.gubun1.options[fm.gubun1.selectedIndex].value == '2'){
			td_nm.style.display 	= '';
		}else{
			td_nm.style.display 	= 'none';
		}
	}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>

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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body onload="javascript:document.form1.st_nm.focus();" leftmargin="15">

<form name='RentCondSearchForm' action='call_cond_rm_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<div class="navigation">
	<span class=style1>콜센터 ></span><span class=style5>월렌트 콜등록 현황</span>
</div>
<div class="search-area">
	<label><i class="fa fa-check-circle"></i> 기간 </label>
	<input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>><label>전월</label> 
	<input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>><label>당월 </label> 
	<input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>><label>당해 </label> 
	<input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>><label>조회기간</label>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> 구분 </label>
		<select name="gubun1" class="select" style="width:150px;" onChange="javascript:cng_input()" >          
		<option value="1" <%if(gubun1.equals("1"))%>selected<%%>>해지일</option>		
		<option value="3" <%if(gubun1.equals("2"))%>selected<%%>>상호</option>
		<option value="3" <%if(gubun1.equals("3"))%>selected<%%>>콜등록일</option>
		</select>
		&nbsp;
		<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
		~ 
		<input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<span id='td_nm' style='display:none'> 
		<input type='text' size='20' name='st_nm' class='text' value=''>
	</span>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" class="button" value="검색" onclick="SearchRentCond()"/>                    

<input type='hidden' name='sh_height' value='<%=sh_height%>'> 	    
</div>
</form>


</body>
</html>