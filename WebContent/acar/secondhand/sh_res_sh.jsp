<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String sh_height = request.getParameter("sh_height")==null?"0":request.getParameter("sh_height");//상단길이
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		if( (fm.gubun1.value == '' || fm.gubun1.value == '3') && fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); return;}
		fm.action = 'sh_res_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
//-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  
  <div class="navigation" style="margin-bottom:0px !important">
	<span class="style1">영업관리 > 견적관리 > </span><span class="style5">차량예약관리</span>
  </div>
  <div class="search-area">
  	<label><i class="fa fa-check-circle"></i>&nbsp;검색조건</label>
  	<select name='s_kd' class="select">
         <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>고객명 </option>
         <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>연락처 </option>
         <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
         <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>차종 </option>
         <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>메모 </option>
         <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>담당자 </option>
         <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>등록일 </option>
         <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>예약시작일 </option>
         <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>예약만료일 </option>
     </select>
     <input type='text' class="input" name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
     &nbsp;&nbsp;&nbsp;
     <label><i class="fa fa-check-circle"></i>&nbsp;구분</label>
     <select name='gubun3' class="select">
         <option value=''  <%if(gubun3.equals("")){ %>selected<%}%>>전체 </option>
         <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>재리스</option>
         <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>월렌트</option>
     </select>
     &nbsp;&nbsp;&nbsp;
     <label><i class="fa fa-check-circle"></i>&nbsp;상태</label>
     <select name='gubun1' class="select">
        <option value=''  <%if(gubun1.equals("")){ %>selected<%}%>>전체 </option>
        <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>진행+대기</option>
        <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>진행 </option>
        <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>대기</option>
        <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>종료</option>                            
    </select>
    <select name='gubun2'  class="select">
        <option value=''  <%if(gubun2.equals("")){ %>selected<%}%>>전체 </option>
        <option value='0' <%if(gubun2.equals("0")){%>selected<%}%>>상담중</option>
        <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>계약확정</option>
        <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>계약연동</option>
    </select>    
    &nbsp;&nbsp;&nbsp;
    <label><i class="fa fa-check-circle"></i>&nbsp;담당자</label> 
     <select name='gubun4'  class="select">
        <option value=''  <%if(gubun4.equals("")){ %>selected<%}%>>전체 </option>
        <option value='0' <%if(gubun4.equals("0")){%>selected<%}%>>미배치</option>
        <option value='1' <%if(gubun4.equals("1")){%>selected<%}%>>배치완료</option>
    </select>
    <input type="button" class="button" value="검색" onclick="search()">
  </div> 
</form>
</body>
</html>

