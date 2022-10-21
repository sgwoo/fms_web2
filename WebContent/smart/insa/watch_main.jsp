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

#carrow {float:left; margin:0 0 5px 20px;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}

#List {height:120px; margin:0 0 0 20px;}
#List li {border-bottom:0px #eaeaea solid; font-weight:bold;}
#List .list1{float:left; margin-right:10px;}
#List .list2{float:left;}
#List .list3{float:left; margin-top:10px; margin-bottom:10px;}

.dj_list {width:90%; text-align:center; border-bottom:2px solid #c18d44; border-top:1px solid #c18d44; font:11px Tahoma;}
.dj_list th {padding:7px 0 4px 0;  border-top:1px solid #c18d44; border-right:1px solid #c18d44; font:12px NanumGothic; font-weight:bold; color:#f09310; height:24px;}
.dj_list td {padding:6px 0 4px 0; border-top:1px solid #c18d44;  font:12px NanumGothic; color:#e4ddd4; font-weight:bold; height:24px;}


</style>

<script language='javascript'>
<!--
	function view_info(watch_type, s_br_nm)
	{
		var fm = document.form1;		
		fm.watch_type.value = watch_type;
		fm.s_br_nm.value = s_br_nm;				
		fm.action = "watch_br.jsp";		
		if(watch_type == '0') fm.action = "watch_stat.jsp";
		fm.submit();
	}
//-->
</script>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.watch.*"%>
<%@ include file="/smart/cookies.jsp" %> 

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	
	//당직현황
	Vector vt = wc_db.WatchScheStat();
	int vt_size = vt.size();
%>


<body>
<form name='form1' method='post' action=''>
<%@ include file="/smart/include/search_hidden.jsp" %>
	<input type='hidden' name='watch_type'	value='1'>	
	<input type='hidden' name='s_br_nm'		value=''>	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">당직표</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>            
        </div>
    </div>
    <div id="contents" style="margin:0 auto;">
    	<div class="dj_list" style="margin:0 auto;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
    			<tr>
    				<th width=15%><font color="#c28835">구분</font></th>
    				<td><font color="#c28835">어제</font></td>
    				<td><font color="#d3f010">오늘</font></td>
    				<td><font color="#c28835">내일</font></td>
    				<td><font color="#c28835">모레</font></td>
    			</tr>
				<%	for(int i=0; i<  vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
    			<tr>
    				<th><font color="#c28835"><%if(ht.get("BR_ST").equals("본사")){%>본사-수도권<%}else if(ht.get("BR_ST").equals("부산지점")){ %>부산-대구지점<%}else if(ht.get("BR_ST").equals("대전지점")){ %>대전-광주지점<%}%></font></th>
    				<td><%=ht.get("USER_NM1")%></td>
    				<td><a href="tel:<%=ht.get("USER_M_TEL")%>"><font color="#d3f010"><%=ht.get("USER_NM2")%></font></a></td>
    				<td><%=ht.get("USER_NM3")%></td>
    				<td><%=ht.get("USER_NM4")%></td>
    			</tr>
				<%	}%>
    		</table>
    	</div>   
    	<div style="height:25px;"></div> 			
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('1','본사')" onMouseOver="window.status=''; return true"><img src="/smart/images/sch_sub_m6.gif" alt="menu1" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info('1','본사')" onMouseOver="window.status=''; return true">본사-수도권 당직표</a></div>
            <div id="menu_mrg"><a href="javascript:view_info('1','본사')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('3','부산지점')" onMouseOver="window.status=''; return true"><img src="/smart/images/sch_sub_m2.gif" alt="menu2" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info('3','부산지점')" onMouseOver="window.status=''; return true">부산-대구지점 당직표</a></div>
            <div id="menu_mrg"><a href="javascript:view_info('3','부산지점')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
        <div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('4','대전지점')" onMouseOver="window.status=''; return true"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info('4','대전지점')" onMouseOver="window.status=''; return true">대전-광주지점 당직표</a></div>
            <div id="menu_mrg"><a href="javascript:view_info('4','대전지점')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
		<!--
		<div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('5','강남지점')" onMouseOver="window.status=''; return true"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info('5','강남지점')" onMouseOver="window.status=''; return true">강남지점 당직표</a></div>
            <div id="menu_mrg"><a href="javascript:view_info('5','강남지점')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
		<div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('6','광주지점')" onMouseOver="window.status=''; return true"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info('6','광주지점')" onMouseOver="window.status=''; return true">광주지점 당직표</a></div>
            <div id="menu_mrg"><a href="javascript:view_info('6','광주지점')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
		<div id="gnb_menu">
			<div id="menu_mn"> <a href="javascript:view_info('7','대구지점')" onMouseOver="window.status=''; return true"><img src="/smart/images/sch_sub_m3.gif" alt="menu3" /></a></div>
            <div id="menu_tt"> <a href="javascript:view_info('7','대구지점')" onMouseOver="window.status=''; return true">대구지점 당직표</a></div>
            <div id="menu_mrg"><a href="javascript:view_info('7','대구지점')" onMouseOver="window.status=''; return true"><img src="/smart/images/sl_mrg.gif" alt="mrg" /></a></div>
        </div>
		-->
    </div>
	<div id="footer"></div>
</div>
</form>
</body>
</html>
