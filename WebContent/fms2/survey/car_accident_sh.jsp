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
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String g_fm = "1";
	
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
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '2'){
			td_nm.style.display 	= '';
		}else{
			td_nm.style.display 	= 'none';
		}
	}
	
		//수정하기
	function nocall()
	{
	
		var fm = parent.c_foot.inner.form1;
		var len = fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];
			if(ck.name == 'ch_all'){
				if(ck.checked == true){
					cnt++;
					idnum = ck.value;
				}
			}
		}
		
		if(cnt == 0){ alert("비대상을 선택하세요 !"); return; }
		if(!confirm('Call 비대상으로 지정하시겠습니까?')){	return;	}
		fm.action = "call_reg_cont_u_a.jsp";
		fm.target = "i_no";
//		fm.target='nodisplay';
		fm.submit();
				
				
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
<body>
<form action="./car_accident_sc.jsp" name="RentCondSearchForm" method="POST" target="c_foot">
<div class="navigation">
	<span class=style1>콜센터 ></span><span class=style5>사고현황</span>
</div>
<div class="search-area">

	<input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>><label>당월 </label> 
	<input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>><label>당해 </label> 
	<input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>><label>조회기간 </label> 
	
	<label><i class="fa fa-check-circle"></i> 구분 </label>
	<select name="gubun2" class="select" style="width:150px;" onChange="javascript:cng_input()">          
	<option value="1" <%if(gubun2.equals("1"))%>selected<%%>>사고일</option>
	<option value="2" <%if(gubun2.equals("2"))%>selected<%%>>상호</option>
	</select>
	&nbsp;
	<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
	~ 
	<input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()">
	&nbsp;&nbsp;&nbsp;&nbsp;
	<span id='td_nm' style='display:none'> 
	<input type='text' size='20' name='st_nm' class='text' value=''>
	</span>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" class="button" value="검색" onclick="SearchRentCond()"/>      


	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 	    
	
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

</body>
</html>