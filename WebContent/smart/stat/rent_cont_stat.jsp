<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">

<head>

<title>Mobile_FMS_Search_Cont</title>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 
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
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu a{text-decoration:none; color:#fff;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

/* 검색창 */
#search fieldset {padding:0px 0px; border:0px;}
#search .userform {width:100%; overflow:hidden; position:relative;}
#search .userform .name {float:left; position:absolute; width:100px; margin:5px 20px 0 20px; color:#ffe4a9;}
#search .userform .userinput {padding-right:60px; height:50px; margin:0 20px 0 85px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:25px;}


/* UI Object */

.srch{width:100%;padding:5px 0}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}
/* //UI Object */


#dj_list table{margin:auto;width:90%; text-align:center; border-bottom:2px solid #c18d44; border-top:1px solid #c18d44; font:11px Tahoma;}
#dj_list table th{padding:7px 0 4px 0;  border-top:1px solid #c18d44; border-left:1px solid #c18d44; border-right:1px solid #c18d44; font:13px NanumGothic; font-weight:bold; color:#e4ddd4; height:30px;}
#dj_list table td{padding:6px 0 4px 0; border-top:1px solid #c18d44;  font:13px NanumGothic; color:#e4ddd4; font-weight:bold; height:30px ; background-color:#322719;}
#dj_list table a{color:#e4ddd4; padding:8px 8px;}
#dj_list table th.n{border-right:0px;}

li.ment{font-size:0.8em; color:#545454;}
</style>

<link rel=stylesheet type="text/css" href="/smart/include/css_stat.css">
<link rel=stylesheet type="text/css" href="/smart/include/css_calendar.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='JavaScript' src='/smart/include/calendar.js'></script>
<script language='javascript'>
<!--
	//검색
	function search()
	{
		var fm = document.form1;
		
		if(fm.gubun1.value == '' && fm.st_dt.value == '' && fm.end_dt.value == ''){
			alert('기간일 경우 날짜를 입력하십시오.');
			return;
		}
		
		fm.action = 'rent_cont_stat.jsp';		
		fm.submit();
	}
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}

	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "stat_main.jsp";		
		fm.submit();
	}
	
	//디스플레이 타입(검색)-세부조회 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun1.options[fm.gubun1.selectedIndex].value != '4'){ //기간
			fm.st_dt.value	 = '';
			fm.end_dt.value ='';
		}
	}

//-->
</script>
</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/smart/cookies.jsp" %>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<%	
	//디폴트 : 당일	
	if(gubun1.equals("")) gubun1 = "1";
	
	int cnt[]	 = new int[14];		
%> 


<body>
<form name='form1' method='post' action='rent_cont_stat.jsp' id="sortdata1">
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  

	<input type='hidden' name='mode' 	value=''>
	<input type='hidden' name='rent_way' 	value=''>
	<input type='hidden' name='s_br' 	value=''>  


	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">영업소별계약현황 </span></div>
            <div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>				
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">
    	<div id="search">
                <!--ui object -->
		<fieldset class="srch">
			<legend>검색영역</legend>
			<select name='gubun1' onChange="javascript:cng_input1()">
          		    	<option value="1" <%if(gubun1.equals("1"))%>selected<%%>>당일</option>
				<option value="2" <%if(gubun1.equals("2"))%>selected<%%>>전일</option>
				<option value="3" <%if(gubun1.equals("3"))%>selected<%%>>전전일</option>
				<option value="7" <%if(gubun1.equals("7"))%>selected<%%>>3일전</option>
				<option value="4" <%if(gubun1.equals("4"))%>selected<%%>>당월</option>
				<option value="5" <%if(gubun1.equals("5"))%>selected<%%>>전월</option>
				<option value="6" <%if(gubun1.equals("6"))%>selected<%%>>전전월</option>
				<option value="9" <%if(gubun1.equals("9"))%>selected<%%>>기간</option>
			</select>
			<input class="keyword" title=검색어 type="text" size="8" name="st_dt" value="<%=st_dt%>" onfocus="showCalendarControl(this);"> ~ 
			<input class="keyword" type="text" size="8" name="end_dt" value="<%=end_dt%>" onfocus="showCalendarControl(this);">  
			<input alt=검색 src="/smart/images/btn_srch.gif" type="image"> 
		</fieldset> 
                <!--//ui object -->
		</div>
		<div id="dj_list">	
			<table border="0" cellspacing="0" cellpadding="0" width="100%" style="border:1px solid #c18d44;">
				<tr>
					<th width='25%'>구분</th>					
					<th width='15%'>신차</th>
					<th width='15%'>재리스</th>
					<th width='15%'>연장</th>
					<th width='15%'>합계</th>					
					<th width='15%' class="n">월렌트</th>					
				</tr>
								
				
				<%	Vector vt = ec_db.getStatDeptListM("", "", gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
					int vt_size = vt.size();
				%>
					
					
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);						
						cnt[9]  += AddUtil.parseInt((String)ht.get("CNT1_0"));
						cnt[10] += AddUtil.parseInt((String)ht.get("CNT1_1"));
						cnt[11] += AddUtil.parseInt((String)ht.get("CNT1_2"));						
						cnt[12] += AddUtil.parseInt((String)ht.get("CNT1_3"));
						cnt[13] += AddUtil.parseInt((String)ht.get("CNT1_4"));																	
				%>								

				<tr>
					<th style="text-align:center;"><%=ht.get("BR_NM")%></th>					
					<th>          <a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&gubun2=&gubun3=<%=ht.get("BRCH_ID")%>&gubun4="><%=ht.get("CNT1_0")%></a></td>
					<th>          <a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&gubun2=&gubun3=<%=ht.get("BRCH_ID")%>&gubun4="><%=ht.get("CNT1_1")%></a></td>
					<th>          <a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&gubun2=&gubun3=<%=ht.get("BRCH_ID")%>&gubun4="><%=ht.get("CNT1_2")%></a></td>
					<th>          <a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=&gubun2=&gubun3=<%=ht.get("BRCH_ID")%>&gubun4="><%=ht.get("CNT1_4")%></a></td>
					<th class="b"><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=4&gubun2=&gubun3=<%=ht.get("BRCH_ID")%>&gubun4="><%=ht.get("CNT1_3")%></a></td>
				</tr>

				<%	}%>									
				
				<!--합계-->							
                		<tr> 
                    			<th class="c" style="text-align:center;">합계</th>  
                    			<th class='c'><font color="#d3f010"><%=cnt[9]%></font></td>
                    			<th class='c'><font color="#d3f010"><%=cnt[10]%></font></td>
                    			<th class='c'><font color="#d3f010"><%=cnt[11]%></font></td>
                    			<th class='c'><font color="#d3f010"><%=cnt[13]%></font></td>
                    			<th class='c'><font color="#d3f010"><%=cnt[12]%></font></td>
                		</tr>					
					
			</table>
		</div>
		<div class=ment>※ 출고전해지/개시전해지/계약승계/차종변경은 제외, 중고차는 재리스에 포함</div>
		
		<!-- 관리구분별현황/대여기간별현황-->
   		<div class="text01"><img src="/smart/images/arrow.png"> <b>관리구분별현황</b></div>
		<div class="text01"><a href="rent_cont_stat_1.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&gubun2=1&gubun3=&gubun4=" class="btn_type01">신차</a> &nbsp;&nbsp;
		                    <a href="rent_cont_stat_1.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&gubun2=1&gubun3=&gubun4=" class="btn_type01">재리스</a> &nbsp;&nbsp;
		                    <a href="rent_cont_stat_1.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&gubun2=1&gubun3=&gubun4=" class="btn_type01">연장</a><br><br></div>
		<div class="text01"><img src="/smart/images/arrow.png"> <b>대여기간별현황</b></div>
		<div class="text01"><a href="rent_cont_stat_2.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&gubun2=2&gubun3=&gubun4=" class="btn_type01">신차</a> &nbsp;&nbsp;
		                    <a href="rent_cont_stat_2.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&gubun2=2&gubun3=&gubun4=" class="btn_type01">재리스</a> &nbsp;&nbsp;
		                    <a href="rent_cont_stat_2.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&gubun2=2&gubun3=&gubun4=" class="btn_type01">연장</a></div>
    </div> 
    <div id="footer"></div>      	
</div>
</form>
</body>
</html>