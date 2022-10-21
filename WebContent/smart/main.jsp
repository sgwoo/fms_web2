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
#wrap {float:left; margin:0 auto; width:100%; background-color:#282828;}
#header {float:left; width:100%; height:43px; margin-bottom:35px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; text-align:center; width:100%; height:50px; background:#CCC; margin-top:35px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; margin-left:15px;  text-decoration:none;}
#gnb_menu a{text-decoration:none; color:#fff; display:block;}
#gnb_menu li{float:left; display:inline; height:90px; font-size:0.85em; font-weight:bold; margin:10px 7px 0 0; text-align:center;}

/* 로고 */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_login {float:left; height:34px; padding:11px 0 0 24px; color:#fff; font-weight:bold;}
#gnb_logout {float:left; padding:7px 0 0 12px; valign:middle;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

/* bottom */
#pc { text-align:center;  padding:10px 0 0 0; font-size:14px; font-weight:bold; font-family:NanumGothic;}
#pc a{ text-decoration:none; color:#000;}
</style>
</head>
<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="org.apache.commons.codec.binary.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ include file="cookies.jsp" %> 
<%
	String acar_id = ck_acar_id;
	//로그아웃 처리를 위한------------------
	String login_time 	= Util.getLoginTime();		//로그인시간
	String ip 			= request.getRemoteAddr(); 	//로그인IP
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//사용자정보
	user_bean = umd.getUsersBean(acar_id);
	
	String pass="";
	pass = Base64.encodeBase64String(StringUtils.getBytesUtf8(user_bean.getUser_psd()));
	
	
%>
<script language='javascript'>
<!--
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
	
	//로그아웃
	function Logout(){
		var fm = document.form1;	
		
		if(!confirm("로그아웃 하시겠습니까?")){ 
			return; 
		}
		
		location.href = 'del.jsp?login_time=<%=login_time%>&ip=<%=ip%>';
	}

//-->
</script>

<body>
<form name="form1" method="post" action="">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name="login_time" value="<%=login_time%>">
<input type='hidden' name="ip" value="<%=ip%>">
<div id="wrap">
    <div id="header">
        <div id="gnb_box">
			<div id="gnb_login"><%=user_bean.getUser_nm()%></div>
			<div id="gnb_logout"> <a href="javascript:Logout();"><img src=/smart/images/btn_logout.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">
        <div id="gnb_menu">
            <ul>
            	<li><a href="/smart/fms/fms_search.jsp"><img src="images/menu_3.gif" alt="FMS" /><br />FMS</a><li>
				<%//if(nm_db.getWorkAuthUser("전산팀",acar_id)){%>
				<li><a href="/smart/mrent/mrent_search.jsp"><img src="images/menu_13.gif" alt="월렌트" /><br />월렌트</a><li>
				<%//}%>
            	<!-- <li><a href="/smart/esti/esti_main.jsp"><img src="images/menu_2.gif" alt="견적" /><br />견적</a><li> -->            	
                <li><a href="/smart/bbs/bbs_main.jsp"><img src="images/menu_5.gif" alt="기타업무" /><br />기타업무</a><li>
                
                <li><a href="/smart/rlscar/rlscar_search.jsp"><img src="images/menu_4.gif" alt="재리스" /><br />재리스</a><li>                                
                <li><a href="/smart/sostel/sostel_main.jsp"><img src="images/menu_1.gif" alt="연락망" /><br />연락망</a><li> 
                <li><a href="/smart/coop/coop_main.jsp"><img src="images/menu_8.gif" alt="협조전" /><br />협조전</a><li>
                
                <li>
			<%if(nm_db.getWorkAuthUser("임원",acar_id)){%>
				<a href="/smart/cus_sch/schedule_dept_main.jsp">
			<%}else{%>
				<a href="/smart/cus_sch/schedule_main.jsp">					
			<%}%>					
				<img src="images/menu_9.gif" alt="일정표" /><br />일정표</a>
		<li>	
		
		<li><a href="/smart/insa/insa_main.jsp"><img src="images/menu_10.gif" alt="인사관리" /><br />인사관리</a><li>	
		<li><a href="/smart/settle/settle_main.jsp"><img src="images/menu_11.gif" alt="채권관리" /><br />채권관리</a><li>			
		
		<%if(nm_db.getWorkAuthUser("임원",acar_id) || nm_db.getWorkAuthUser("전산팀",acar_id)){%>
		<li><a href="/smart/stat/stat_main.jsp"><img src="images/menu_3.gif" alt="현황" /><br />현황</a><li>			
		<%}%>
		
                <li><a href="/smart/nreg/nreg_main.jsp"><img src="images/menu_6.gif" alt="신규등록" /><br />신규등록</a><li>
                
                <li>
			<%if(nm_db.getWorkAuthUser("임원",acar_id) || nm_db.getWorkAuthUser("전산팀",acar_id)){%>
				<a href="/smart/pur_com/pur_com_stat.jsp">
			<%}else{%>
				<%if(user_bean.getLoan_st().equals("")){%>
					<a href="/smart/pur_com/pur_com_list.jsp">					
				<%}else{%>	
					<a href="/smart/pur_com/pur_com_list.jsp?s_kd=4&t_wd=<%=user_bean.getUser_nm()%>&gubun3=2">					
				<%}%>
			<%}%>					
				<img src="images/menu_12.gif" alt="특판계출" /><br />특판계출</a>
		<li>
		                
            </ul>
        </div>
    </div>
    <div id="footer">
    	<div id="pc">
		&nbsp;<a href="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?direct=Y&id=<%=user_bean.getId()%>&pass=<%=pass%>&url=" target=_blank>PC버전</a> &nbsp;<font color="#a8a8a8">|</font>&nbsp; <a href="http://www.amazoncar.co.kr/" target=_blank>아마존카홈페이지</a>
		</div>
	</div>
</div>
</form>

</body>
</html>