<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<title>Mobile_FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
<link rel=stylesheet type="text/css" href="/smart/include/css_main.css">
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
		<div id="gnb_login">현황</a></div>
		<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">
        <div id="gnb_menu">
            <ul>
            	<li><a href="rent_cont_stat.jsp<%=hidden_value%>"><img src="/smart/images/nreg_menu06.gif" alt="menu2" /><br />영업소별계약현황</a></li> 
            	<li><a href="user_cont_stat.jsp<%=hidden_value%>"><img src="/smart/images/nreg_menu06.gif" alt="menu2" /><br />사원별계약현황</a></li>
            	<li><a href="asset_sale_list.jsp<%=hidden_value%>"><img src="/smart/images/nreg_menu01.gif" alt="menu1" /><br />자산매각현황</a></li>
          		<li><a href="stat_asset_list.jsp<%=hidden_value%>"><img src="/smart/images/nreg_menu01.gif" alt="menu1" /><br />자산매각현황 II</a></li>  
				<li><a href="car_auction_list.jsp<%=hidden_value%>"><img src="/smart/images/nreg_menu07.gif" alt="menu2" /><br />경매현황</a></li>            	            	            	            	
            </ul>
        </div>
    </div>
    <div id="footer"></div>
</div>
</form>

</body>
</html>