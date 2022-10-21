<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
<style type="text/css">

/* body ���� �Ӽ� */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '�������'; }
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0; text-align:center;}

/* ���̾ƿ� ū�ڽ� �Ӽ� */
#wrap {float:left; margin:0 auto; width:100%; background-color:#301a37;}
#header {float:left; width:100%; height:43px; margin-bottom:30px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#CCC; margin-top:20px;}

/* �޴������ܵ� */
#gnb_menu a{text-decoration:none; color:#fff; display:block; padding-bottom:10px;}
#gnb_menu ul{float:left; margin:0 0 70px 10px;}
#gnb_menu ul li{width:100px; float:left; font-size:0.80em; font-weight:bold; height:130px;}

/* �ΰ� */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}
</style>
</head>
<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
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
        	
			<div id="gnb_login">�űԵ��</a></div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">
        <div id="gnb_menu">
            <ul>
            	<li><a href="client_vst_reg.jsp<%=hidden_value%>"><img src="/smart/images/nreg_menu01.gif" alt="menu1" /><br />�ŷ�ó�湮���</a></li>
            	<li><a href="car_dist_reg.jsp<%=hidden_value%>"><img src="/smart/images/nreg_menu02.gif" alt="menu2" /><br />����Ÿ����</a></li>
            	<!--<li><a href="rent_start_reg.jsp<%=hidden_value%>"><img src="/smart/images/nreg_menu03.gif" alt="menu1" /><br />�뿩���õ��</a></li>-->
            	<!--<li><a href="car_deli_reg.jsp<%=hidden_value%>"><img src="/smart/images/nreg_menu04.gif" alt="menu2" /><br />�������������</a></li>
            	<li><a href="car_ret_reg.jsp<%=hidden_value%>"><img src="/smart/images/nreg_menu05.gif" alt="menu2" /><br />�������������</a></li>-->
            </ul>
        </div>
    </div>
    <div id="footer"></div>
</div>
</form>

</body>
</html>