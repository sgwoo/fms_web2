<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕'; }
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0; text-align:center;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#371a1a;}
#header {float:left; width:100%; height:43px; margin-bottom:20px;}
#contents {float:left; width:100%; height:100%;}
#footer {float:left; width:100%; height:50px; background:#CCC; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu a{text-decoration:none; color:#fff; display:block; padding-bottom:10px;}
#gnb_menu ul{float:left; margin:0 0 30px 10px;}
#gnb_menu ul li{width:75px; float:left; font-size:0.80em; font-weight:bold; height:130px;}

/* 로고 */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}
</style>
</head>
<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/smart/cookies.jsp" %> 

<%
	
%>

<script language='javascript'>
<!--
	function view_info(sostel_st, dept_id, dept_nm)
	{
		var fm = document.form1;
		
		fm.sostel_st.value = sostel_st;
		fm.dept_id.value = dept_id;
		fm.dept_nm.value = dept_nm;	
		fm.target = "_self";			
		fm.action = "sostel_list.jsp";
		fm.submit();
	}
	
		 
	 function view_info2(sostel_st, dept_id, dept_nm) {//2012-09-26 수정 
        var fm = document.form1;
        window.open('blank', "detail", 'width=1024,height=800,status=no,scrollbars=yes,resizable=yes');
        fm.method = "post";
        fm.action = 'sostel_list.jsp?sostel_st='+sostel_st+'&dept_id='+dept_id+'&dept_nm='+dept_nm;
        fm.target = "detail";
        fm.submit();    
    }
//-->
</script>

<body>
<form name="form1" method="post" action="sostel_list.jsp">
<%@ include file="/smart/include/search_hidden.jsp" %>
<!--	<input type='hidden' name='sostel_st'	value=''>
<!--	<input type='hidden' name='dept_id'		value=''>  
	<input type='hidden' name='dept_nm'		value=''>	-->	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">
        	
			<div id="gnb_login">연락망</a></div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">
        <div id="gnb_menu">
            <ul>
            	<li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0000&dept_nm=임원"><img src="/smart/images/st_menu01.gif" alt="menu1" /><br />임원</a></li>
            	<li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0020&dept_nm=영업기획"><img src="/smart/images/st_menu02.gif" alt="menu2" /><br />영업기획</a></li>         	
            	<li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0001&dept_nm=영업"><img src="/smart/images/st_menu02.gif" alt="menu2" /><br />영업</a></li>    
                <li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0002&dept_nm=고객지원"><img src="/smart/images/st_menu03.gif" alt="menu3" /><br />고객지원</a></li>
                <li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0003&dept_nm=총무"><img src="/smart/images/st_menu04.gif" alt="menu4" /><br />총무</a></li> 
                <li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0005&dept_nm=IT"><img src="/smart/images/st_menu22.gif" alt="menu22" /><br />IT</a></li> 
                
				<li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0009&dept_nm=강남지점"><img src="/smart/images/st_menu_gn.gif" alt="menu5" /><br />강남지점</a></li>            	
                <li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0012&dept_nm=인천지점"><img src="/smart/images/st_menu_ic.gif" alt="menu6" /><br />인천지점</a></li> 
                <li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0013&dept_nm=수원지점"><img src="/smart/images/st_menu_sw.gif" alt="menu7" /><br />수원지점</a></li> 
                <li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0014&dept_nm=강서지점"><img src="/smart/images/st_menu_gs.gif" alt="menu8" /><br />강서지점</a></li>            	
				<li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0015&dept_nm=부천지점"><img src="/smart/images/st_menu_gr.gif" alt="menu9" /><br />부천지점</a></li>            	
				<li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0017&dept_nm=광화문지점"><img src="/smart/images/st_menu_jr.gif" alt="menu20" /><br />광화문지점</a></li>
				<li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0018&dept_nm=송파지점"><img src="/smart/images/st_menu_sp.gif" alt="menu21" /><br />송파지점</a></li>
				<li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0016&dept_nm=울산지점"><img src="/smart/images/st_menu_us.gif" alt="menu10" /><br />울산지점</a></li>            	
                
                <li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0007&dept_nm=부산지점"><img src="/smart/images/st_menu_ps.gif" alt="menu11" /><br />부산지점</a></li> 
                <li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0008&dept_nm=대전지점"><img src="/smart/images/st_menu_dj.gif" alt="menu12" /><br />대전지점</a></li>
				<li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0010&dept_nm=광주지점"><img src="/smart/images/st_menu_kj.gif" alt="menu13" /><br />광주지점</a></li>
				<li><a href="sostel_list.jsp?sostel_st=1&ddept_id=0011&dept_nm=대구지점"><img src="/smart/images/st_menu_dg.gif" alt="menu14" /><br />대구지점</a></li>            	
				
                <li><a href="sostel_list.jsp?sostel_st=2&ddept_id=8888&dept_nm=자동차구매"><img src="/smart/images/st_menu07.gif" alt="menu15" /><br />CAR구매</a></li>
                <li><a href="sostel_list.jsp?sostel_st=2&ddept_id=8888&dept_nm=협력업체"><img src="/smart/images/st_menu08.gif" alt="menu16" /><br />협력업체</a></li>
                <li><a href="sostel_list.jsp?sostel_st=2&ddept_id=8888&dept_nm=보험사"><img src="/smart/images/st_menu09.gif" alt="menu17" /><br />보험사</a></li>
				<li><a href="sostel_list.jsp?sostel_st=2&ddept_id=8888&dept_nm=긴급출동"><img src="/smart/images/st_menu09.gif" alt="menu18" /><br />긴급출동</a></li>
                <li><a href="sostel_list.jsp?sostel_st=2&ddept_id=8888&dept_nm=기타"><img src="/smart/images/st_menu010.gif" alt="menu19" /><br />기타</a></li>
            </ul>
        </div>
    </div>
    <div id="footer"></div>
</div>
</form>

</body>
</html>