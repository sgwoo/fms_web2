<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String list_order = request.getParameter("list_order")==null?"":request.getParameter("list_order");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"00010":request.getParameter("gubun2");
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	String mail_yn = request.getParameter("mail_yn")==null?"":request.getParameter("mail_yn");
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "35", "01", "");
	
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getServ_empAll();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function enter(){
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}

function search(){
	var fm = document.form1;
	fm.search_gubun.value = "search_all";
	fm.action = "serv_emp_bank_sc.jsp";
	fm.target = "c_foot";
	fm.submit();
}

function emp_search(){
	var fm = document.form1;
	fm.search_gubun.value = "search_emp";
	fm.action = "serv_emp_bank_ddj_sc.jsp";
	fm.target = "c_foot";
	fm.submit();
}

function serv_off_reg(){
	var SUBWIN="serv_off_i.jsp?auth_rw=<%= auth_rw %>&gubun1=<%=gubun1%>&cmd=i";
	window.open(SUBWIN, "ServOffReg", "left=100, top=120, width=850, height=400, scrollbars=no");
}

//리스트 엑셀 전환
function pop_excel(kd){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_fin_man_excel.jsp?gubun1="+kd;
	fm.submit();
}	

	

function excel_reg(){
	var SUBWIN="excel.jsp?auth_rw=<%= auth_rw %>";
	window.open(SUBWIN, "excel_reg", "left=100, top=120, width=850, height=400, scrollbars=no");
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
select {
    width: 40%;
    padding: 4px 8px;
    border: 1px solid ;
    border-radius: 4px;
    background-color: #ffff;
	font-size: 1em;
}
</style>
</head>

<body>
<form name='form1' method='post' action='' target='c_foot'>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='gubun1' value='<%=gubun1%>'> 
<input type='hidden' name='search_gubun' value='search_all'> 
<div class="navigation">
	<span class=style1>업체정보관리 ></span><span class=style5>업체명함관리</span>
</div>
<div class="search-area">
	<label><i class="fa fa-check-circle"></i> 구분 </label>
		<input type="radio" name="gubun2" value="00010" <%if(gubun2.equals("00010")){%>checked<%}%>><label>금융권 전체</label>
		<input type="radio" name="gubun2" value="00011" <%if(gubun2.equals("00011")){%>checked<%}%>><label>은행</label>
		<input type="radio" name="gubun2" value="00012" <%if(gubun2.equals("00012")){%>checked<%}%>><label>저축은행</label>
		<input type="radio" name="gubun2" value="00013" <%if(gubun2.equals("00013")){%>checked<%}%>><label>캐피탈</label>
		<input type="radio" name="gubun2" value="00014" <%if(gubun2.equals("00014")){%>checked<%}%>><label>카드사</label> 
		<input type="radio" name="gubun2" value="00015" <%if(gubun2.equals("00015")){%>checked<%}%>><label>증권사</label>
	&nbsp;&nbsp;	
	<label><i class="fa fa-check-circle"></i> 검색조건 </label>
	<select name='s_kd' class="select" style="width:150px;">
		<option value="1" <% if(s_kd.equals("1")){ %>selected<% } %>>상호</option>
		<option value="2" <% if(s_kd.equals("2")){ %>selected<% } %>>사무실전화</option>
		<option value="4" <% if(s_kd.equals("4")){ %>selected<% } %>>휴대전화(담당자별 검색)</option><!-- 20190109 -->
		<option value="3" <% if(s_kd.equals("3")){ %>selected<% } %>>담당자(담당자별 검색)</option>
	</select>
	<input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'> 
	<select name='mail_yn' class="select" style="width:120px;">
		<option value="Y" <% if(mail_yn.equals("Y")){ %>selected<% } %>>메일일괄대상</option>
		<option value="N" <% if(mail_yn.equals("N")){ %>selected<% } %>>메일일괄비대상</option>
	</select>
	&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> 정렬조건 </label>
	<select name='list_order' class="select" style="width:150px;">
		<option value="1" <% if(list_order.equals("1")){ %>selected<% } %>>상호</option>
		<option value="2" <% if(list_order.equals("2")){ %>selected<% } %>>대출거래잔액</option>
	</select>
	<input type="button" class="button" value="검색" onclick="search()"/> 
	<input type="button" class="button" value="담당자별" onclick="emp_search()"/> 

<% if(!auth_rw.equals("1")){ %>
<input type="button" class="button" value="일반등록" onclick="serv_off_reg()"/> 
<input type="button" class="button" value="엑셀등록" onclick="excel_reg()"/> 
<%if(gubun1.equals("0001")){%>
<input type="button" class="button" value="엑셀저장(전체)" onclick="pop_excel('<%=gubun1%>' )"/> 

	<% } %>
<% } %>&nbsp;&nbsp;&nbsp;&nbsp; 

</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
