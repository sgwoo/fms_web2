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
#wrap {float:left; margin:0 auto; width:100%; background-color:#1a3737;}
#header {float:left; width:100%; height:43px; margin-bottom:30px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#CCC; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu a{text-decoration:none; color:#fff; display:block; padding-bottom:10px;}
#gnb_menu ul{float:left; margin:0 0 190px 5px;}
#gnb_menu ul li{width:100px; float:left; font-size:0.80em; font-weight:bold; height:130px;}

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
//-->
</script>

<body>
<form name="form1" method="post" action="">
<div id="wrap">
    <div id="header">
        <div id="gnb_box">
        	
			<div id="gnb_login">협조전</a></div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">
        <div id="gnb_menu">
            <ul>
            	<li><a href="coop1_list.jsp"><img src="/smart/images/coop_menu01.gif" alt="menu1" /><br />업무협조</a></li>
            	<li><a href="coop2_list.jsp"><img src="/smart/images/coop_menu02.gif" alt="menu2" /><br />고객업무협조</a></li>            	
                <li><a href="coop3_list.jsp"><img src="/smart/images/coop_menu03.gif" alt="menu3" /><br />주차장방문협조</a></li>
            </ul>
        </div>
    </div>
    <div id="footer"></div>
</div>
</form>

</body>
</html>