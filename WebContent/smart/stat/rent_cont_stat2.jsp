<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS_Search_Cont</title>
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
#header {float:left; width:100%; height:43px; margin-bottom:10px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px; clear:both;overflow:hidden;}

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
#search fieldset {padding:20px 0px; border:0px solid #000; font-family:'나눔고딕',Dotum;font-size:14px; color:#fff;}
#search .userform {width:100%; overflow:hidden; position:relative;}
#search .userform .name {float:left; position:absolute; width:100px; margin:5px 20px 0 20px; color:#ffe4a9;}
#search .userform .userinput {padding-right:60px; height:30px; margin:0 20px 0 85px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:25px;}

/* 리스트 */
.search_list {width:100%; text-align:center; border-bottom:2px solid #b0baec; border-collapse:collapse;}
.search_list caption {display:none;}
.search_list th {padding:7px 0 4px 0; background-color:#e2e7ff; border-top:2px solid #b0baec; border-left:1px solid #b0baec; border-right:1px solid #b0baec; border-bottom:1px solid #b0baec; font-size:14px; font-family:NanumGothic, '나눔고딕'; font-weight:bold; color:#666666;}
.search_list td {padding:6px 0 4px 0; border:1px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}

/* UI Object */

.srch{width:100%;padding:5px 0 color:#fff;}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0 color:#fff;}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}
/* //UI Object */


/* UI Object */
.lst_type{width:auto;padding:20px;border:0px solid #c2c2c2;list-style:none; background-color:#ffffff; font-family:'나눔고딕',Dotum;font-size:14px;}
.lst_type li{margin-bottom:5px;font-family:'나눔고딕',Dotum;font-size:14px;font-weight:normal;line-height:14px;vertical-align:top}
.lst_type li a{color:#1478CD;text-decoration:none;font-family:'나눔고딕',Dotum;font-size:20px;font-weight:normal;line-height:30px;display:inline;} /*링크*/
.lst_type li em{color:#f84e12}
.lst_type li a:hover{text-decoration:underline}
/* //UI Object */

#dj_list table{margin:auto;width:90%; text-align:center; border-bottom:2px solid #c18d44; border-top:1px solid #c18d44; font:11px Tahoma;}
#dj_list table th{padding:7px 0 4px 0;  border-top:1px solid #c18d44; border-right:1px solid #c18d44; font:13px NanumGothic; font-weight:bold; color:#f09310; height:30px;}
#dj_list table td{padding:6px 0 4px 0; border-top:1px solid #c18d44;  font:13px NanumGothic; color:#e4ddd4; font-weight:bold; height:30px ; background-color:#322719;}
#dj_list table a{color:#e4ddd4; padding:7px;}
#dj_list table th.n{border-right:0px;}
#dj_list table td.c{color:#d3f010; font:16px NanumGothic;}
#dj_list table td.c a{color:#d3f010; font:16px NanumGothic;}


.ment{font-size:0.7em; color:#ffffff; padding:5px 25px 30px 25px; line-height:17px;}
.stylec{color:d3f010; font:16px NanumGothic;}
</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*"%>
<%@ include file="/smart/cookies.jsp" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>


<%	
	//디폴트 : 당일	
	if(gubun1.equals("")) gubun1 = "1";
	
	//총갯수
	int size = 10;

	int cnt0[]	 = new int[size];
	int cnt1[]	 = new int[size];	
	int cnt2[]	 = new int[size];

	int t_cnt0[]	 = new int[size];
	int t_cnt1[]	 = new int[size];	
	int t_cnt2[]	 = new int[size];
	
%> 

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
	function open_rent_dept(mode, rent_way, br_id, dept_id){
		var fm = document.form1;
		fm.mode.value 		= mode;		
		fm.rent_way.value 	= rent_way;		
		fm.s_br.value 		= br_id;		
		fm.dept_id.value 	= dept_id;		
		fm.action = "rent_cont_stat_list.jsp";		
		fm.submit();
			
		//var SUBWIN="rent_cont_stat_list.jsp?mode="+mode+"&rent_way="+rent_way+"&s_br="+br_id+"&dept_id="+dept_id+"&gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>";	
		//window.open(SUBWIN, "StatRentDept"+mode+""+rent_way, "left=10, top=10, width=1000, height=800, scrollbars=yes");
	}

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
	

//-->
</script>
</head>

<body>
<form name='form1' method='post' action='rent_cont_stat.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  

	<input type='hidden' name='mode' 	value=''>
	<input type='hidden' name='rent_way' 	value=''>
	<input type='hidden' name='s_br' 	value=''>  
	<input type='hidden' name='dept_id' 	value=''>  

	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">계약현황 </span></div>
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
			<select name='gubun1'>
          		    <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>당일</option>
                    	    <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>전일</option>
                    	    <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>전전일</option>
                    	    <option value="4" <%if(gubun1.equals("4"))%>selected<%%>>당월</option>
                    	    <option value="5" <%if(gubun1.equals("5"))%>selected<%%>>전월</option>
                    	    <option value="6" <%if(gubun1.equals("6"))%>selected<%%>>전전월</option>
                    	    <option value="9" <%if(gubun1.equals("9"))%>selected<%%>>기간</option>
			</select>
        	        <input class="keyword" title=검색어 type="text" size="7" name="st_dt" value="<%=st_dt%>"> ~ <input class="keyword" type="text" size="7" name="end_dt" value="<%=end_dt%>">  
			<input alt=검색 src="/smart/images/btn_srch.gif" type="image"> 
		</fieldset> 
<!--//ui object -->
		</div>
		<div id="dj_list">	
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<th rowspan='2' colspan='2' width='20%'>구분</th>
					<th colspan='3'>본사</th>
					<th rowspan='2' width='8%'>부산지점</th>
					<th rowspan='2' width='8%'>대전지점</th>
					<th rowspan='2' width='8%'>강남지점</th>
					<th rowspan='2' width='8%'>광주지점</th>
					<th rowspan='2' width='8%'>대구지점</th>
					<th rowspan='2' width='8%'>인천지점</th>
					<th rowspan='2' width='8%' class="n">합계</th>
				</tr>
				<tr>
					<th width='8%'>영업</th>
					<th width='8%'>고객지원</th>
					<th width='8%'>소계</th>
				</tr>
								
		<!--신차-->
		<%	Vector vt = a_db.getStatDeptList("1", gubun1, st_dt, end_dt);
			int vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				for (int j = 0 ; j < size ; j++){
					if(String.valueOf(ht.get("RENT_WAY")).equals("기본식")){
						cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						t_cnt1[j] = t_cnt1[j]+ cnt1[j];
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){
						cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						t_cnt2[j] = t_cnt2[j]+ cnt2[j];
					}
				}			
		%>								
				<tr>
									<%if(i==0){%><th rowspan='3' style="text-align:center;">신차</th><%}%>
									<th style="text-align:center;"><%=ht.get("RENT_WAY")%></th>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S1&dept_id=0001"><%=ht.get("CNT0")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S1&dept_id=0002"><%=ht.get("CNT1")%></a></td>
									<td class="b"><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S1&dept_id="><%=ht.get("CNT2")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&rent_way=<%=ht.get("RENT_WAY")%>&s_br=B1&dept_id=0007"><%=ht.get("CNT3")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&rent_way=<%=ht.get("RENT_WAY")%>&s_br=D1&dept_id=0008"><%=ht.get("CNT4")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S2&dept_id=0009"><%=ht.get("CNT5")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&rent_way=<%=ht.get("RENT_WAY")%>&s_br=J1&dept_id=0010"><%=ht.get("CNT6")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&rent_way=<%=ht.get("RENT_WAY")%>&s_br=G1&dept_id=0011"><%=ht.get("CNT7")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&rent_way=<%=ht.get("RENT_WAY")%>&s_br=I1&dept_id=0012"><%=ht.get("CNT8")%></a></td>
									<td class="b"><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=1&rent_way=<%=ht.get("RENT_WAY")%>&s_br=&dept_id="><%=ht.get("CNT9")%></a></td>
				</tr>
		<%	}%>									
		
		<!--신차 결과가 2개 아닐때-->
		<%	if(vt_size<2){
				for(int i = 0 ; i < 2-vt_size ; i++){%>
                <tr> 
                    <%if(i==0 && vt_size==0){%><th rowspan='3' style="text-align:center;">신차</th><%}%>
                    <th style="text-align:center;"><%if(cnt1[5]==0 && i==0){%>기본식<%}else{%>일반식<%}%></th>
			<%	for (int j = 0 ; j < size ; j++){%>	
                    <td><%=0%></td>
			<%	}%>
                </tr>						
		<%		}
			}%>			
					

                <tr> 
                    <th class="c" style="text-align:center;">소계</th>
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] 	= cnt1[j]+cnt2[j];
				t_cnt0[j] 	= t_cnt0[j]+cnt0[j];%>
                    <td class="c" ><%=cnt0[j]%></td>
			<%}%>
                </tr>			
			
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] = 0;
				cnt1[j] = 0;
				cnt2[j] = 0;
			}%>
			
		<!--재리스-->
		<%	vt = a_db.getStatDeptList("2", gubun1, st_dt, end_dt);
			vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				for (int j = 0 ; j < size ; j++){
					if(String.valueOf(ht.get("RENT_WAY")).equals("기본식")){
						cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						t_cnt1[j] = t_cnt1[j]+ cnt1[j];
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){
						cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						t_cnt2[j] = t_cnt2[j]+ cnt2[j];
					}
				}			
		%>								
								<tr>
									<%if(i==0){%><th rowspan='3' style="text-align:center;">재리스</th><%}%>
									<th style="text-align:center;"><%=ht.get("RENT_WAY")%></th>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S1&dept_id=0001"><%=ht.get("CNT0")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S1&dept_id=0002"><%=ht.get("CNT1")%></a></td>
									<td class="b"><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S1&dept_id="><%=ht.get("CNT2")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&rent_way=<%=ht.get("RENT_WAY")%>&s_br=B1&dept_id=0007"><%=ht.get("CNT3")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&rent_way=<%=ht.get("RENT_WAY")%>&s_br=D1&dept_id=0008"><%=ht.get("CNT4")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S2&dept_id=0009"><%=ht.get("CNT5")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&rent_way=<%=ht.get("RENT_WAY")%>&s_br=J1&dept_id=0010"><%=ht.get("CNT6")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&rent_way=<%=ht.get("RENT_WAY")%>&s_br=G1&dept_id=0011"><%=ht.get("CNT7")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&rent_way=<%=ht.get("RENT_WAY")%>&s_br=I1&dept_id=0012"><%=ht.get("CNT8")%></a></td>
									<td class="b"><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=2&rent_way=<%=ht.get("RENT_WAY")%>&s_br=&dept_id="><%=ht.get("CNT9")%></a></td>
								</tr>
		<%	}%>									
		
		<!--재리스 결과가 2개 아닐때-->
		<%	if(vt_size<2){
				for(int i = 0 ; i < 2-vt_size ; i++){%>
                <tr> 
                    <%if(i==0 && vt_size==0){%><th rowspan='3' style="text-align:center;">재리스</th><%}%>
                    <th style="text-align:center;"><%if(cnt1[5]==0 && i==0){%>기본식<%}else{%>일반식<%}%></th>
			<%	for (int j = 0 ; j < size ; j++){%>	
                    <td><%=0%></td>
			<%	}%>
                </tr>						
		<%		}
			}%>			
					

                <tr> 
                    <th class="c" style="text-align:center;">소계</th>
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] 	= cnt1[j]+cnt2[j];
				t_cnt0[j] 	= t_cnt0[j]+cnt0[j];%>
                    <td class="c" ><%=cnt0[j]%></td>
			<%}%>
                </tr>			
			
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] = 0;
				cnt1[j] = 0;
				cnt2[j] = 0;
			}%>
			
		<!--연장-->
		<%	vt = a_db.getStatDeptList("3", gubun1, st_dt, end_dt);
			vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				for (int j = 0 ; j < size ; j++){
					if(String.valueOf(ht.get("RENT_WAY")).equals("기본식")){
						cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						t_cnt1[j] = t_cnt1[j]+ cnt1[j];
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){
						cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						t_cnt2[j] = t_cnt2[j]+ cnt2[j];
					}
				}			
		%>								
								<tr>
									<%if(i==0){%><th rowspan='3' style="text-align:center;">연장</th><%}%>
									<th style="text-align:center;"><%=ht.get("RENT_WAY")%></th>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S1&dept_id=0001"><%=ht.get("CNT0")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S1&dept_id=0002"><%=ht.get("CNT1")%></a></td>
									<td class="b"><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S1&dept_id="><%=ht.get("CNT2")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&rent_way=<%=ht.get("RENT_WAY")%>&s_br=B1&dept_id=0007"><%=ht.get("CNT3")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&rent_way=<%=ht.get("RENT_WAY")%>&s_br=D1&dept_id=0008"><%=ht.get("CNT4")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&rent_way=<%=ht.get("RENT_WAY")%>&s_br=S2&dept_id=0009"><%=ht.get("CNT5")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&rent_way=<%=ht.get("RENT_WAY")%>&s_br=J1&dept_id=0010"><%=ht.get("CNT6")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&rent_way=<%=ht.get("RENT_WAY")%>&s_br=G1&dept_id=0011"><%=ht.get("CNT7")%></a></td>
									<td><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&rent_way=<%=ht.get("RENT_WAY")%>&s_br=I1&dept_id=0012"><%=ht.get("CNT8")%></a></td>
									<td class="b"><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=3&rent_way=<%=ht.get("RENT_WAY")%>&s_br=&dept_id="><%=ht.get("CNT8")%></a></td>
								</tr>
		<%	}%>									
		
		<!--연장 결과가 2개 아닐때-->
		<%	if(vt_size<2){
				for(int i = 0 ; i < 2-vt_size ; i++){%>
                <tr> 
                    <%if(i==0 && vt_size==0){%><th rowspan='3' style="text-align:center;">연장</th><%}%>
                    <th style="text-align:center;"><%if(cnt1[5]==0 && i==0){%>기본식<%}else{%>일반식<%}%></th>
			<%	for (int j = 0 ; j < size ; j++){%>	
                    <td><%=0%></td>
			<%	}%>
                </tr>						
		<%		}
			}%>			
					

                <tr> 
                    <th class="c" style="text-align:center;">소계</th>
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] 	= cnt1[j]+cnt2[j];
				t_cnt0[j] 	= t_cnt0[j]+cnt0[j];%>
                    <td class="c" ><%=cnt0[j]%></td>
			<%}%>
                </tr>			
			
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] = 0;
				cnt1[j] = 0;
				cnt2[j] = 0;
			}%>						

		<!--합계-->							
                <tr> 
                    <th colspan="2" class="c" style="text-align:center;">합계</th>                    
			<%for (int j = 0 ; j < size ; j++){%>	
                    <td class='c'><font color="#d3f010"><%=t_cnt0[j]%></font></td>
			<%}%>
                </tr>			                               	
			
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] = 0;
				cnt1[j] = 0;
				cnt2[j] = 0;
			}%>		
			

			</table>
		</div>
			<br>
		<div id="dj_list">
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
					
		<!--월렌트-->		
		<%	vt = a_db.getStatDeptRmList("", gubun1, st_dt, end_dt);
			vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>							
                <tr> 
                    <%if(i==0){%><th rowspan="<%=vt_size%>" width='20%' style="text-align:center;">월렌트</th><%}%>
                    						                  
                    <td width='8%'><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=4&rent_way=<%=ht.get("RENT_ST")%>&s_br=S1&dept_id=0001"><%=ht.get("CNT0")%></a></td>
                    <td width='8%'><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=4&rent_way=<%=ht.get("RENT_ST")%>&s_br=S1&dept_id=0002"><%=ht.get("CNT1")%></td>
                    <td width='8%' class="b"><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=4&rent_way=<%=ht.get("RENT_ST")%>&s_br=S1&dept_id="><%=ht.get("CNT2")%></td>
                    <td width='8%'><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=4&rent_way=<%=ht.get("RENT_ST")%>&s_br=B1&dept_id=0007"><%=ht.get("CNT3")%></td>
                    <td width='8%'><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=4&rent_way=<%=ht.get("RENT_ST")%>&s_br=D1&dept_id=0008"><%=ht.get("CNT4")%></td>
                    <td width='8%'><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=4&rent_way=<%=ht.get("RENT_ST")%>&s_br=S2&dept_id=0009"><%=ht.get("CNT5")%></td>
                    <td width='8%'><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=4&rent_way=<%=ht.get("RENT_ST")%>&s_br=J1&dept_id=0010"><%=ht.get("CNT6")%></td>
                    <td width='8%'><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=4&rent_way=<%=ht.get("RENT_ST")%>&s_br=G1&dept_id=0011"><%=ht.get("CNT7")%></td>
                    <td width='8%'><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=4&rent_way=<%=ht.get("RENT_ST")%>&s_br=I1&dept_id=0012"><%=ht.get("CNT8")%></td>
                    <td width='8%' class="c"><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=4&rent_way=<%=ht.get("RENT_ST")%>&s_br=&dept_id="><%=ht.get("CNT9")%></td>

                </tr>		
                <%	}%>
                
		<!--월렌트 결과가 없을때-->
		<%	if(vt_size==0){%>
                <tr> 
                    <th width='20%' style="text-align:center;">월렌트</th>
			<%	for (int j = 0 ; j < size ; j++){
					t_cnt1[j] = t_cnt1[j]+ 0;
					t_cnt2[j] = t_cnt2[j]+ 0;
			%>	
                    <td <%if(j==2 || j==5){%>width='10%' class='c'<%}else{%>width='8%'<%}%>><span class="stylec"><%=0%></span></td>
			<%	}%>
                </tr>						
		<%	}%>	
							
			</table>
		</div>
		<div class=ment>※ 출고전해지/개시전해지/계약승계/차종변경은 제외, 중고차는 재리스에 포함</div>
	</div> 
	<div id="footer"></div>      
</div>
</form>
</body>
</html>