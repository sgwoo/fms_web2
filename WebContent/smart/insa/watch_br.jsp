<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
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
#wrap {float:left; margin:0 auto; width:100%; background-color:#ffffff;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}


/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%;  height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}

.News_tit .date {padding-top:14px;font-size:18px;color:#888;}
.News_tit {padding:19px 21px 14px; border-bottom:1px #ddd solid; position:relative;}
.News_content {padding:10px 5px 15px;font-size:18px;color:#111;line-height:1px #ddd solid;}
.News_tit h3 {font-size:19px;color:#000;line-height:22px;}
.News_tit tt {font-size:13px;}
</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_sche.*"%>
<%@ page import="acar.watch.*, acar.user_mng.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %> 


<%
	String myid = user_id;
	
	
	
	String watch_type 	= request.getParameter("watch_type")==null?"":request.getParameter("watch_type");
	String s_br_nm 		= request.getParameter("s_br_nm")==null?"":request.getParameter("s_br_nm");
	
	int start_year 	= request.getParameter("start_year")==null?0:AddUtil.parseInt(request.getParameter("start_year"));
	int start_month = request.getParameter("start_month")==null?0:AddUtil.parseInt(request.getParameter("start_month"));
	int start_day 	= request.getParameter("start_day")==null?0:AddUtil.parseInt(request.getParameter("start_day"));
	
	int nyear 	= 0;
	int nmonth 	= 0;
	int nday 	= 0;
	int cnt 	= 1;
	
	if(start_year==0){
		nyear 	= calendar.getThisYear();
		nmonth 	= calendar.getThisMonth();
		nday 	= calendar.getThisDay();
	}else{
		nyear 	= start_year;
		nmonth 	= start_month;
		nday 	= start_day;
	}
	
	String thisyear 	= Integer.toString(nyear);
	String thismonth 	= Integer.toString(nmonth);
	String thisday 		= Integer.toString(nday);
	
	if(thismonth.length() == 1)		thismonth 	= "0"+thismonth;
	if(thisday.length() == 1)		thisday 	= "0"+thisday;
	
	int day_of_week = 0;
	int last_day 	= calendar.getMonthLastDay(nyear,nmonth);
	
	String tr_color = "";
	String whatday 	= "";
	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarSchDatabase schedule = CarSchDatabase.getInstance();
	WatchDatabase wc_db = WatchDatabase.getInstance();
	
	//견적내기
	Vector vt = wc_db.WatchScheAll(thisyear, thismonth, watch_type);
	int vt_size = vt.size();
%>

<script language='javascript'>
<!--
function go_before(year, mon)
{
	var cur_mon = mon - 1;
	var cur_year = year;

	if(cur_mon < 1)
	{
		cur_mon = 12;
		cur_year = year - 1 ;
	}

	if(cur_mon < 10)
		cur_mon = "0"+cur_mon;

	document.form1.start_year.value = cur_year;
	document.form1.start_month.value = cur_mon;
	document.form1.submit();
}

function go_next(year, mon)
{
	var cur_mon = mon + 1;
	var cur_year = year;

	if(cur_mon > 12)
	{
		cur_mon = 1;
		cur_year = year + 1 ;
	}

	if(cur_mon < 10)
		cur_mon = "0"+cur_mon;

	document.form1.start_year.value = cur_year;
	document.form1.start_month.value = cur_mon;
	document.form1.submit();
}


function search(){
	fm = document.form1;
	fm.submit();
}

//-->
</script>


<body>
<form name='form1' method='post' action='watch_br.jsp'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='start_year' value='<%=thisyear%>'>
<input type='hidden' name='start_month' value='<%=thismonth%>'>
<input type='hidden' name='watch_type' value='<%=watch_type%>'>
<input type='hidden' name='s_br_nm' value='<%=s_br_nm%>'>
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login"><%=s_br_nm%> 당직표
			</div> 
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>           
        </div>
    </div>    
	<div id="contents">
		<center>
			<!--이전날-->
			<a href='javascript:go_before(<%=nyear%>,<%=nmonth%>);' class=hh><img src=/acar/images/center/button_b_month.gif align=absmiddle /></a>&nbsp;
			<!--현재날짜/요일-->
				<b class=sub><%=thisyear%>년&nbsp;<%=thismonth%>월</b>&nbsp;
			<!--다음날-->	
			<a href='javascript:go_next(<%=nyear%>,<%=nmonth%>);' class=hh><img src=/acar/images/center/button_n_month.gif align=absmiddle /></a>
		</center>
		<br />	
		<!-- content -->
		<div class="News_tit">
		<%	for(int i=0; i<  vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				day_of_week = calendar.getDayOfWeek(nyear, nmonth, AddUtil.parseInt(String.valueOf(ht.get("START_DAY"))));
				whatday = AddUtil.parseDateWeek("c", day_of_week);
				//평일 - 검정
				tr_color = "#000000";
				if(day_of_week == 1)			tr_color = "RED"; 		//일요일
				else if(day_of_week == 7)		tr_color = "BLUE"; 		//토요일
				if(AddUtil.getDate2(3) == AddUtil.parseInt(String.valueOf(ht.get("START_DAY"))))	tr_color = "green"; 	//현재날짜
				%>				
			<div>					
				<font color='<%=tr_color%>'><b><%=ht.get("START_DAY")%>일 <%=whatday%></b></font> <%=ht.get("MEMBER_NM")%>
				<%if(ht.get("WATCH_TIME_ED").equals("") && ht.get("WATCH_SIGN").equals("")){%>
				<%	if(ht.get("MEMBER_NM").equals("")){%>
				[미정]
				<%	}else{%>
				[예정]
				<%	}%>				
				<%}else if(!ht.get("WATCH_TIME_ED").equals("") && ht.get("WATCH_SIGN").equals("")){%>
				<font color="red">[결재요청]</font>
				<%}else{%>				
				<font color="blue">[완료]</font>
				<%}%>
			</div>
			<hr color=#e3e0d3 height=1>
		<%	}%>		
		<%  if(vt_size==0){%>
		  데이타가 없습니다.
	    <%	}%>
	    </div>
<!-- //content -->
	</div>
</div>
</form>
</body>
</html>
