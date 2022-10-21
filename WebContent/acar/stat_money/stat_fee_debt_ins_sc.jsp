<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	
	int cnt = 3; //검색 라인수
	int sh_height = cnt*sh_line_height;
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
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
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//조회
	function Search(){
		var fm = document.form1;
		if(fm.gubun.value == ''){ alert('구분을 선택하십시오'); return;}
		if(fm.gubun.value == '1'){
			if(fm.s_yy.value == ''){ alert('년도를 선택하십시오'); fm.s_yy.focus(); return;}
			if(fm.s_mm.value == ''){ alert('월을 선택하십시오');  fm.s_mm.focus(); return;}
		}else if(fm.gubun.value == '2'){
			if(fm.s_yy.value == ''){ alert('년도를 선택하십시오'); fm.s_yy.focus(); return;}
		}else if(fm.gubun.value == '3'){
			if(fm.st_dt.value == ''){ 	alert('기간 시작일을 입력하십시오'); fm.st_dt.focus(); return;}
			if(fm.end_dt.value == ''){ 	alert('기간 종료일을 입력하십시오'); fm.end_dt.focus(); return;}
		}
		fm.target='i_view';
		fm.action = "stat_fee_debt_ins_sc_in_view.jsp";
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}
	function set_gubun(){
		var fm = document.form1;
		if(fm.gubun.value == '1'){
			fm.st_dt.value = '';
			fm.end_dt.value = '';
			if(fm.s_yy.value == '') fm.s_yy.value = '<%=AddUtil.getDate(1)%>';
			if(fm.s_mm.value == '') fm.s_mm.value = '<%=AddUtil.getDate(2)%>';
		}else if(fm.gubun.value == '2'){
			fm.s_mm.value = '';
			fm.st_dt.value = '';
			fm.end_dt.value = '';
			if(fm.s_yy.value == '') fm.s_yy.value = '<%=AddUtil.getDate(1)%>';
		}else if(fm.gubun.value == '3'){
			fm.s_yy.value = '';
			fm.s_mm.value = '';
		}
	}
	
function autoResize(i)
{
    var iframeHeight=
    (i).contentWindow.document.body.scrollHeight;
    (i).height=iframeHeight+20;
}	
//-->
</script>
</head>
<body>

<form action="stat_fee_debt_ins_sc_in_view.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>


<div class="navigation">
	<span class=style1>경영정보 > 재무회계 > </span><span class=style5>입출금현황</span>
</div>
<div class="search-area">
	<label><i class="fa fa-check-circle"></i> 구분 </label>
	<select id="gubun" name="gubun" class="select" style="width:90px;" onchange="javascript:set_gubun();">
		<option value="1" <%if(gubun.equals("1")){%>selected<%}%>>일일</option>
		<option value="2" <%if(gubun.equals("2")){%>selected<%}%>>월별</option>
		<option value="3" <%if(gubun.equals("3")){%>selected<%}%>>기간별</option>
	</select>	
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> 년월 </label>
	<select id="s_yy" name="s_yy" class="select" style="width:90px;">
		<option value="" <%if(s_yy.equals("")){%>selected<%}%>>선택</option>
		<%for(int i=2008; i<=AddUtil.getDate2(1); i++){%>
		<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
		<%}%>
	</select>
	<select id="s_mm" name="s_mm" class="select" style="width:60px;">
		<option value="" <%if(s_mm.equals("")){%>selected<%}%>>선택</option>
		<%for(int i=1; i<=12; i++){%>
	  <option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=i%>월</option>
	  <%}%>
	</select>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> 기간 </label>
	<input type="text" name="st_dt" size="10" value="" class="text" onBlur='javscript:this.value = ChangeDate4(this.value);'>
	~
	<input type="text" name="end_dt" size="10" value="" class="text" onBlur='javscript:this.value = ChangeDate4(this.value);'>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" class="button" value="검색" onclick="Search()"/>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr> 
		<td><iframe src="./stat_fee_debt_ins_sc_in_view.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun=<%=gubun%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>" name="i_view" onload="autoResize(this)" width="100%" height="100%" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
	</tr>
</table>
</form>
</body>
</html>
