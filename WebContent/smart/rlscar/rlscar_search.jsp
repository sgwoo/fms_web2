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
#wrap {overflow:hidden;width:100%; background-color:#1a2237;}

#header {float:left; width:100%; height:43px;}
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0.0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}


#contents {width:100%; margin:0 auto;}
#footer {height:50px; background:#CCC; clear:both; margin:0 auto;}

/* 메뉴아이콘들 */
#gnb_menu a{text-decoration:none; color:#fff; display:block; padding-bottom:10px;}
#gnb_menu ul{float:left; margin:30px 0 40px 0;}
#gnb_menu ul li{width:100px; float:left;font-size:0.80em; font-weight:bold;}

/* 로고 */


</style>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/smart/cookies.jsp" %>

<%
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function view_search(gubun1){
		var fm = document.form1;	
		fm.gubun1.value = gubun1;
		fm.action = 'rlscar_list.jsp';
		fm.submit();
	}
//-->
</script>


</head>
<body>
<form name="form1" method="post" action="rlscar_list.jsp">
<%@ include file="/include/search_hidden.jsp" %>

<div id="wrap">
    <div id="header">
        <div id="gnb_box">
			<div id="gnb_login">재리스FMS 검색 </div>
			<div id="gnb_home"><a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">
    	<div id="gnb_menu">
            <ul> 
            	<li><a href="rlscar_list.jsp?gubun1="><img src="/smart/images/fms_menu02.gif" alt="menu1" /><br />전체</a></li>
            	<li><a href="rlscar_list.jsp?gubun1=8"><img src="/smart/images/fms_menu02.gif" alt="menu2" /><br />소형승용(LPG)</a></li>            	
                <li><a href="rlscar_list.jsp?gubun1=5"><img src="/smart/images/fms_menu02.gif" alt="menu3" /><br />중형승용(LPG)</a></li>
                <li><a href="rlscar_list.jsp?gubun1=4"><img src="/smart/images/fms_menu02.gif" alt="menu4" /><br />대형승용(LPG)</a></li> 
				<li><a href="rlscar_list.jsp?gubun1=3"><img src="/smart/images/fms_menu02.gif" alt="menu5" /><br />소형승용(가솔린,디젤)</a></li> 
            	<li><a href="rlscar_list.jsp?gubun1=2"><img src="/smart/images/fms_menu02.gif" alt="menu1" /><br />중형승용(가솔린,디젤)</a></li>
            	<li><a href="rlscar_list.jsp?gubun1=1"><img src="/smart/images/fms_menu02.gif" alt="menu2" /><br />대형승용(가솔린)</a></li>            	
                <li><a href="rlscar_list.jsp?gubun1=6"><img src="/smart/images/fms_menu02.gif" alt="menu3" /><br />RV및기타</a></li>
                <li><a href="rlscar_list.jsp?gubun1=7"><img src="/smart/images/fms_menu02.gif" alt="menu4" /><br />수입차</a></li> 		
            </ul>
        </div>
    </div>
    <div id="footer"></div>
</div>

</form>
</body>
</html>