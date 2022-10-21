<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS Client_Info</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">


<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#322719;}
#header {float:left; width:100%; height:43px; margin-bottom:30px;}
#contents {float:left; height:100%; width:100%; margin:5px 0;}
#contents a {text-decoration:none;}
#footer {float:left; width:100%; height:40px; background:#221a11; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left;  text-align:middle; width:100%; height:47px; margin-bottom:10px; background:url(/smart/images/sl_mbg.gif);}
#gnb_menu a{text-decoration:none; color:#fff; line-height:32px; display:block; background-color:#322719;}
#menu_mn {float:left; height:42px; font-size:0.95em; font-weight:bold; text-align:left;}
#menu_tt {float:left; padding:4px 0 0 5px; line-height:42px; font-size:0.95em; color:#fff; font-weight:bold; }
#menu_mrg {float:right;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40Px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}

#List {height:120px; margin:0 0 0 20px;}
#List li {border-bottom:0px #eaeaea solid; font-weight:bold;}
#List .list1{float:left; margin-right:10px;}
#List .list2{float:left;}
#List .list3{float:left; margin-top:10px; margin-bottom:10px;}


</style>

<script language='javascript'>
<!--
	function view_info(dept_id, dept_nm)
	{
		var fm = document.form1;		
		fm.dept_id.value = dept_id;
		fm.dept_nm.value = dept_nm;		
		fm.action = "schedule_dept.jsp";				
		fm.submit();
	}
//-->
</script>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/smart/cookies.jsp" %> 

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
%>


<body>
<form name='form1' method='post' action=''>
<%@ include file="/smart/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='dept_id'		value=''>	
	<input type='hidden' name='dept_nm'		value=''>	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">부서별스케줄관리</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>            
        </div>
    </div>
    <div id="contents" style="margin:0 auto;">
        <a href="schedule_dept.jsp?dept_id=0001&dept_nm=영업팀">
     	<div id="gnb_menu">
			<div id="menu_mn"> <img src="/smart/images/sch_sub_m4.gif" alt="menu1" /></div>
            <div id="menu_tt">영업팀 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
        
        <a href="schedule_dept.jsp?dept_id=0002&dept_nm=고객지원팀">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m1.gif" alt="menu1" /></div>
            <div id="menu_tt">고객지원팀 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
       	</a>
       	
     	<a href="schedule_dept.jsp?dept_id=0003&dept_nm=총무팀">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m5.gif" alt="menu1" /></div>
            <div id="menu_tt">총무팀 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
        
        <a href="schedule_dept.jsp?dept_id=0007&dept_nm=부산지점">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m2.gif" alt="menu2" /></div>
            <div id="menu_tt">부산지점 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
        
        <a href="schedule_dept.jsp?dept_id=0008&dept_nm=대전지점">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></div>
            <div id="menu_tt">대전지점 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
		
		<a href="schedule_dept.jsp?dept_id=0009&dept_nm=강남지점">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></div>
            <div id="menu_tt">강남지점 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
		
		<a href="schedule_dept.jsp?dept_id=0010&dept_nm=광주지점">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></div>
            <div id="menu_tt">광주지점 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
		
		<a href="schedule_dept.jsp?dept_id=0011&dept_nm=대구지점">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></div>
            <div id="menu_tt">대구지점 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
		
		<a href="schedule_dept.jsp?dept_id=0014&dept_nm=강서지점">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></div>
            <div id="menu_tt">강서지점 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
		
		<a href="schedule_dept.jsp?dept_id=0015&dept_nm=구로지점">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></div>
            <div id="menu_tt">구로지점 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
		
		<a href="schedule_dept.jsp?dept_id=0016&dept_nm=울산지점">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></div>
            <div id="menu_tt">울산지점 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
		
		<a href="schedule_dept.jsp?dept_id=0017&dept_nm=광화문지점">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></div>
            <div id="menu_tt">광화문지점 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
		<a href="schedule_dept.jsp?dept_id=0018&dept_nm=송파지점">
        <div id="gnb_menu">
			<div id="menu_mn"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></div>
            <div id="menu_tt">송파지점 스케줄</div>
            <div id="menu_mrg"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></div>
        </div>
        </a>
    </div>
	<div id="footer"></div>
</div>
</form>
</body>
</html>
