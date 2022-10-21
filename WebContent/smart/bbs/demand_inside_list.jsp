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
#search fieldset {padding:0px 0 10px 0px; border:0px;}
#search .userform {width:100%; overflow:hidden; position:relative;}
#search .userform .title {float:left; padding:0 0 0 20px; height:35px;}
#search .userform .name { margin:0 20px 0 55px;}
#search .userform .userinput {padding-right:60px; height:35px; margin:0 20px 0 75px; vertical-align:top;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:20px; padding-top:38px;}

/* 리스트 */
.search_list {width:100%; text-align:center; border-bottom:2px solid #b0baec; border-collapse:collapse;}
.search_list caption {display:none;}
.search_list th {padding:7px 0 4px 0; background-color:#e2e7ff; border-top:2px solid #b0baec; border-left:1px solid #b0baec; border-right:1px solid #b0baec; border-bottom:1px solid #b0baec; font-size:14px; font-family:NanumGothic, '나눔고딕'; font-weight:bold; color:#666666;}
.search_list td {padding:6px 0 4px 0; border:1px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}


#contentsWrap { padding:0; font-size:22px;} /* padding _ top bottom */
#topListWrap { position: relative; height: 100%; }
.List li {padding:15px 21px;border-bottom:1px #eaeaea solid;}
.List li a {width:100%;padding:7px 0 6px;font-size:16px;color:#000;line-height:20px;font-weight:bold;display:block;}
.List li a em {color:#888;font-size:16px;}
</style>

</head>
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.inside_bank.*"%>
<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String s_wd = request.getParameter("s_wd")==null?"":request.getParameter("s_wd");
	
	Vector clients = new Vector();
	int client_size = 0;
	
	if (!s_wd.equals("")) {	
		clients = ib_db.getIbAcctAllTrDdList(dt, "", "", s_wd, asc);
	}
	
	client_size = clients.size();
%>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.s_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.s_wd.focus(); return; }	
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
//-->
</script>

</head>

<body>

<table width=100% border=0 cellspacing=0 cellpadding=0>

<form name="form1" method="post"   action='demand_inside_list.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  
	<input type='hidden' name='s_kd' 		value='1'>

<div id="wrap">
	<div id="header">
        <div id="gnb_box">
        	
            <div id="gnb_login">은행입금조회</div>
            <div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
	
	<div id="contents">    
    	<div id="search">
	        <fieldset>
	        	<div class="userform">
		        	<div class="title">입금일</div>		
					<div class="userinput"><select name="dt">
								    <option value="1" <% if(dt.equals("1")) out.print("selected"); %>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;당일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
								    <option value="2" <% if(dt.equals("2")) out.print("selected"); %>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;당월&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>							 
								    <option value="4" <% if(dt.equals("4")) out.print("selected"); %>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;전일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
								    <option value="5" <% if(dt.equals("5")) out.print("selected"); %>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;전월&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
		                    		</select>
					</div>										        
					<div class="title">검색어</div>	  
					<div class="userinput"><input type="text" name="s_wd" value="<%=s_wd%>" size="13" class="text" onKeyDown="javasript:enter()" style='IME-MODE: active' />
					</div>
					<div class="submit"><a onClick='javascript:window.search();' style='cursor:hand'><img src="/smart/images/btn_srch.gif" alt="검색" value="검색"></a></div>
					</div>
				</div>	
			</fieldset>
		</div>	  
        <tbody>
         <%	if( client_size > 0){
				for (int i = 0 ; i < client_size ; i++){
					Hashtable ht = (Hashtable)clients.elementAt(i);%>                
                 <ul class="List">
	               	  <li>
	               	 	 <span><font color='#3b44bb'>		                
							 <b><%=ht.get("NAEYONG")%></b>&nbsp;</span></font><br>	
						<div style="height:5px;"></div>		 							 
					 	<span><b><%=ht.get("BANK_NAME")%><%=ht.get("ACCT_NB")%></b>&nbsp;/&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TR_DATE")))%></span><br> 						
						<span><b>￦&nbsp;<font color="#990000"><%=Util.parseDecimal(String.valueOf(ht.get("IP_AMT")))%></font> 원</b></span><br> 		    		
		    		 </li>													    		
    			</ul>	    			             	
                <% if(i == ( client_size  - 1)) break;
				}//for
			}else{ %>
                            <span><%	if (!s_wd.equals("")) {%>데이타가 없습니다.<%}%></span><br> 		
                            
        <%	} %> 
        </tbody>                  
	 </div>   
</div>	    
</form>
</body>
</html>