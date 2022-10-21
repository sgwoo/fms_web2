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
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; height:100%; width:100%; margin:5px 0;}
#footer {float:left; width:100%; height:40px; background:#221a11; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left;  text-align:middle; width:100%; height:47px; margin-bottom:10px; background:url(/smart/images/sl_mbg.gif);}
#gnb_menu a{text-decoration:none; color:#fff; line-height:32px; display:block; background-color:#322719;}
#menu_mn {float:left; height:42px; font-size:0.95em; font-weight:bold; text-align:left;}
#menu_tt {float:left; padding:8px 0 0 5px; height:42px; font-size:0.95em; color:#fff; font-weight:bold;}
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
	function view_info(st)
	{
		var fm = document.form1;
		
		if(st == '1'){
			fm.action = "rlscar_view1.jsp";		
		}else if(st == '2'){
			fm.action = "rlscar_view2.jsp";		
		}else if(st == '3'){
			fm.action = "rlscar_view3.jsp";		
		}else if(st == '4'){
			fm.action = "rlscar_view4.jsp";		
		}else if(st == '5'){
			fm.action = "rlscar_view5.jsp";		
		}else if(st == '6'){
			fm.action = "rlscar_view6.jsp";		
		}else if(st == '7'){
			fm.action = "rlscar_view7.jsp";		
		}
		
		fm.submit();
	}
	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "rlscar_list.jsp";		
		fm.submit();
	}	

	 function view_info2(st) {//2012-09-26 수정 
        var fm = document.form1;
        window.open('blank', "detail2", 'width=1024,height=800,status=no,scrollbars=yes,resizable=yes');
        fm.method = "post";
        
		fm.action = "rlscar_view"+[st]+".jsp";		
		//alert(fm.action);
		
        fm.target = "detail2";
        fm.submit();    
    }
//-->
</script>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_ls_hpg.*"%>
<jsp:useBean id="oh_db" scope="page" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	//차량정보
	Hashtable secondhand = oh_db.getSecondhandCase_20090901(rent_mng_id, rent_l_cd, car_mng_id);
%>


<body>
<form name='form1' method='post' action='rlscar_main.jsp'>
<%@ include file="/smart/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='from_page'	value='<%=from_page%>'>
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">재리스차량</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>            
        </div>
    </div>
    <div id="contents" style="margin:0 auto;">
    	<div id="List" >
        	<ul>
		    	<li class='list1'><img src="https://fms3.amazoncar.co.kr/images/carImg/<% if(String.valueOf(secondhand.get("IMGFILE1")).equals("")) out.print("../../images/no_photo"); else out.print(secondhand.get("IMGFILE1")); %>.gif" width=275 height=203 border=0 align=absmiddle></li>	
				<li class='list3'><font color="#ffffff"><%= secondhand.get("CAR_JNM") %><%= secondhand.get("CAR_NM") %> /</font> <font color="#f8920d"><%=car_no%></font></li>
							
        	</ul>
        </div>	
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info2('1')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_m1.gif" alt="menu1" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info2('1')" onMouseOver="window.status=''; return true">자동차등록/기본사항</a></div>
            <div id="menu_mrg"><a href="javascript:view_info2('1')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info2('5')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_m5.gif" alt="menu2" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info2('5')" onMouseOver="window.status=''; return true">기본사양/선택사양</a></div>
            <div id="menu_mrg"><a href="javascript:view_info2('5')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info2('7')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_m7.gif" alt="menu3" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info2('7')" onMouseOver="window.status=''; return true">운행정보</a></div>
            <div id="menu_mrg"><a href="javascript:view_info2('7')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info2('6')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_m6.gif" alt="menu4" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info2('6')" onMouseOver="window.status=''; return true">견적대여료</a></div>
            <div id="menu_mrg"><a href="javascript:view_info2('6')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info2('2')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_m2.gif" alt="menu5" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info2('2')" onMouseOver="window.status=''; return true">자동차대여이력</a></div>
            <div id="menu_mrg"><a href="javascript:view_info2('2')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info2('3')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_m3.gif" alt="menu6" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info2('3')" onMouseOver="window.status=''; return true">사고이력</a></div>
            <div id="menu_mrg"><a href="javascript:view_info2('3')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info2('4')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_m4.gif" alt="menu7" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info2('4')" onMouseOver="window.status=''; return true">정비이력</a></div>
            <div id="menu_mrg"><a href="javascript:view_info2('4')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
    </div>
	<div id="footer"></div>
</div>
</form>
</body>
</html>
