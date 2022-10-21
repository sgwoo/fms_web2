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
		
		fm.action = 'user_cont_stat.jsp';		
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
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<%@ include file="/smart/cookies.jsp" %>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>

<%	
	//디폴트 : 당월	
	if(gubun1.equals("")) gubun1 = "4";
	
	//큰그룹
	String gubun_cd[] 	= new String[3];
	gubun_cd[0] 	= "2";
	gubun_cd[1] 	= "1";
	gubun_cd[2] 	= "3";
	//큰그룹
	String gubun_nm[] 	= new String[3];
	gubun_nm[0] 	= "영업팀";
	gubun_nm[1] 	= "고객지원팀";
	gubun_nm[2] 	= "에이전트";		
	
	int count = 1;
	
	//작은그룹 소계
	int cnt1[] 	= new int[25];
	//큰그룹 소계
	int cnt2[] 	= new int[25];
	//총합계
	int cnt3[] 	= new int[25];	

%> 


<body>
<form name='form1' method='post' action='user_cont_stat.jsp' id="sortdata1">
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
            <div id="gnb_login">사원별계약현황 </span></div>
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
				<option value="4" <%if(gubun1.equals("4"))%>selected<%%>>당월</option>
				<option value="5" <%if(gubun1.equals("5"))%>selected<%%>>전월</option>
				<option value="6" <%if(gubun1.equals("6"))%>selected<%%>>전전월</option>
				<option value="8" <%if(gubun1.equals("8"))%>selected<%%>>당해</option>
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
					<th width='15%'>부서</th>					
					<th width='10%'>연번</th>
					<th width='15%'>성명</th>
					<th width='10%'>입사년도</th>
					<th width='10%'>신차</th>
					<th width='10%'>재리스</th>
					<th width='10%'>연장</th>
					<th width='10%'>합계</th>					
					<th width='10%' class="n">월렌트</th>					
				</tr>
								
				
				<%	
					st_dt = AddUtil.replace(st_dt,"-","");
					end_dt = AddUtil.replace(end_dt,"-","");
				
					Vector vt = sb_db.getStatRentUserDept("smart", gubun1, st_dt, end_dt);
					int vt_size = vt.size();
				%>
				
                <%for (int g = 0 ; g < 3 ; g++){
                		count = 1;
                		for (int k = 0 ; k < 24 ; k++){ cnt2[k] = 0; }		               	
           	    %> 	            
           	    
           	    
           	    
                <%		
   								for (int k = 0 ; k < 24 ; k++){ cnt1[k] = 0; }	
           	    				for (int j = 0 ; j < vt_size ; j++){
    								Hashtable ht = (Hashtable)vt.elementAt(j);    					
    								if(gubun_cd[g].equals(String.valueOf(ht.get("LOAN_ST")))){    						
           	    %>


               <tr> 
                    <th style="text-align:center;"><%= String.valueOf(ht.get("BR_NM"))%></td>
                    <th style="text-align:center;"><%=count++%></td>
                    <th style="text-align:center;"><%= String.valueOf(ht.get("USER_NM"))%></font></a></td>
                    <th style="text-align:center;"><%= AddUtil.parseDate(String.valueOf(ht.get("ENTER_DT")),1)%></font></a></td>
                    <%					for (int k = 0 ; k < 24 ; k++){
                    						cnt1[k] = cnt1[k] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+k)));
                    						cnt2[k] = cnt2[k] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+k)));
                    						cnt3[k] = cnt3[k] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+k)));
                    						
                    						if(k==4 || k==5 || k==6 ||k==7 || k==23){
                    %>
	                <th><%= String.valueOf(ht.get("CNT"+k))%></td>
	                <%						}%>
	                <%					}%>
                </tr>
                <%					}
	            				}	                		
                %> 
                
           	    

                <tr> 
                    <td class=c colspan='4'><%=gubun_nm[g]%> 소계</td>
                    <%		for (int k = 0 ; k < 24 ; k++){
                    			if(k==4 || k==5 || k==6 ||k==7 || k==23){
                    %>
	                <td  class="c"><%=cnt2[k]%></td>
	                <%			}%>
	                <%		}%>
                </tr>           
                
                
                
                
                <%	}%>
                
                <tr> 
                    <td class=c colspan='4'>총합계</td>
                    <%		for (int k = 0 ; k < 24 ; k++){
                    			if(k==4 || k==5 || k==6 ||k==7 || k==23){
                    %>
	                <td  class="c"><%=cnt3[k]%></td>
	                <%			}%>
	                <%		}%>
                </tr>            			

				
					
			</table>
		</div>
    </div> 
    <div id="footer"></div>      	
</div>
</form>
</body>
</html>