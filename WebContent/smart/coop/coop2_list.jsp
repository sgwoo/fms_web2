<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
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
#wrap {float:left; margin:0 auto; width:100%; background-color:#ffffff;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

/* 검색창 */
#search fieldset {padding:10px 0px; border:0px;}
#search .userform {width:100%; overflow:hidden; position:relative;}
#search .userform .name {float:left; position:absolute; width:100px; margin:5px 20px 0 20px;}
#search .userform .userinput {padding-right:60px; height:50px; margin:0 20px 0 85px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:25px;}

.srch{width:100%;padding:10px 0;}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}


/* 리스트 */
.search_list {width:100%; text-align:center; border-bottom:2px solid #b0baec; border-collapse:collapse;}
.search_list caption {display:none;}
.search_list th {padding:7px 0 4px 0; background-color:#e2e7ff; border-top:2px solid #b0baec; border-left:1px solid #b0baec; border-right:1px solid #b0baec; border-bottom:1px solid #b0baec; font-size:14px; font-family:NanumGothic, '나눔고딕'; font-weight:bold; color:#666666;}
.search_list td {padding:6px 0 4px 0; border:1px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}

#contentsWrap { padding:0; font-size:22px;} /* padding _ top bottom */
#topListWrap { position: relative; height: 100%; }
.List li {padding:15px 21px;border-bottom:1px #eaeaea solid;}
.List li a {width:100%;padding:7px 0 6px;font-size:15px;color:#000;line-height:20px;font-weight:bold;display:block;}
.List li a em {color:#888;font-size:15px;}
</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cooperation.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	String s_year 	= request.getParameter("s_year")==null?AddUtil.getDate(1):request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?AddUtil.getDate(2):request.getParameter("s_mon");
	if(gubun2.equals("")){
		gubun2 = "2";
	}
	Vector vt = cp_db.CooperationCList(s_year, s_mon, "", s_kd, t_wd, gubun1, gubun2, gubun3, gubun4);
	int vt_size = vt.size();
	
	int cnt = 3; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_year="+s_year+"&s_mon="+s_mon+"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
				   	"&sh_height="+height+"";
%>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	function view_content(seq, in_dt, in_id)
	{
		window.open("coop_view.jsp<%=valus%>&seq="+seq+"&in_dt="+in_dt+"&in_id="+in_id, "COOPERATION", "left=100, top=100, width=700, height=650, scrollbars=yes");
	}
	
//-->
</script>

</head>

<body onload="">

<table width=100% border=0 cellspacing=0 cellpadding=0>

<form name="form1" method="post"   action='coop2_list.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  
<div id="wrap">
	<div id="header">
        <div id="gnb_box">
        	
            <div id="gnb_login">고객업무협조</div>
            <div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
	<div id="contents">    
    	<div id="search">
			<fieldset class="srch">
				<legend>검색영역</legend>
				<select name='s_year'>
          			<%for(int i=2009; i<=AddUtil.getDate2(1); i++){%>
          			<option value="<%=i%>" <%if(i == AddUtil.parseInt(s_year)){%> selected <%}%>><%=i%>년도</option>
          			<%}%>				  
    		    </select>
    			<select name='s_mon'>
          			<option value="" <%if(s_mon.equals("")){%> selected <%}%>>전체</option>        		  
	          		<% for(int i=1; i<=12; i++){%>        
          			<option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(s_mon)){%> selected <%}%>><%=AddUtil.addZero2(i)%>월</option>
          			<%}%>			
    		    </select>
				<!--
				<select name="gubun1"> 
	            	<option value=""  		<% if(gubun1.equals("")) out.print("selected"); %>>전체</option>
	                <option value="c_mon"  <% if(gubun1.equals("c_mon")) out.print("selected"); %>>당월</option>
	                <option value="c_year"  <% if(gubun1.equals("c_year")) out.print("selected"); %>>당해</option>					
					<option value="title"	<% if(gubun1.equals("title")) out.print("selected"); %>>제목</option>
					<option value="content" <% if(gubun1.equals("content")) out.print("selected"); %>>내용</option>
					<option value="user_nm" <% if(gubun1.equals("user_nm")) out.print("selected"); %>>작성자</option>					  																		
				</select> 
				<input accesskey="s" class="keyword" title=검색어 type="text" name="t_wd" value="<%=t_wd%>"> 
				-->
				&nbsp;
				<select name='gubun2'>
					<option value="2" <%if(gubun2.equals("2"))%>selected<%%>>미처리</option>
					<option value="1" <%if(gubun2.equals("1"))%>selected<%%>>처리</option>
                </select>
				<input alt=검색 src="/smart/images/btn_srch.gif" type="image"> 
			</fieldset> 
		</div>  
		<tbody>            
			<% 	if(vt.size()>0){
				for(int i=0; i< vt.size(); i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);	%>
            <ul class="List">
				<li>
					<span>
						<font color="#7f7f7f"><%= AddUtil.ChangeDate2((String)ht.get("IN_DT")) %></font>&nbsp;<font color="#aeaeae"> | </font>&nbsp;<%=ht.get("USER_NM")%>
					</span>
					<br />
		    		<span>
		    			<font color="#990000"><b><%=ht.get("TITLE")%></b></font>
					</span>
					<br />
					<div style="height:5px;"></div>
					<span>
		    			<%=ht.get("CONTENT")%>
					</span>
					<br />
					<div style="height:5px;"></div>
		    		<span>
						<%if(ht.get("OUT_ID").equals("")){%>직접지정<%}else{%><%=ht.get("OUT_NM")%><%}%>&nbsp;<font color="#aeaeae"> | </font>&nbsp;<%=ht.get("SUB_NM")%>&nbsp; <font color="#aeaeae">|</font> &nbsp;<font color='#3b44bb' size='2'><b><%if(ht.get("OUT_DT").equals("")){%></b></font><font color=#fd5f00><b>미처리</b></font><font color='#3b44bb' size='2'><b><%}else{%><%=ht.get("OUT_DT")%><%}%></b></font>
					</span>
		    	</li>													    		
    		</ul>	    			
             	
            <%		}
				}else{%>
                <span>데이타가 없습니다.</span><br> 		
            <% } %> 
            <span>&nbsp;</span>          
        </tbody>               
	 </div>   
</div>	    
</form>
</body>
</html>