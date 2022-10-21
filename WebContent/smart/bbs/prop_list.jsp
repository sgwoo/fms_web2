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
#search fieldset {padding:0 0 15px 0; border:0px;}
#search .userform {width:100%; overflow:hidden; position:relative;}
#search .userform .name {float:left; position:absolute; width:100px; margin:5px 20px 0 20px;}
#search .userform .userinput {padding-right:60px; height:50px; margin:0 20px 0 85px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:25px;}

.srch{width:100%;padding:5px 0}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}

/* 리스트 */
.search_list {width:100%; text-align:center; border-bottom:2px solid #b0baec; border-collapse:collapse;}
.search_list caption {display:none;}
.search_list th {padding:7px 0 4px 0; background-color:#e2e7ff; border-top:2px solid #b0baec; border-left:1px solid #b0baec; border-right:1px solid #b0baec; border-bottom:1px solid #b0baec; font-size:14px; font-family:NanumGothic, '나눔고딕'; font-weight:bold; color:#666666;}
.search_list td {padding:6px 0 4px 0; border:1px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}

#contentsWrap { padding:0; font-size:22px; } /* padding _ top bottom */
#topListWrap { position: relative; height: 100%; }
.List li {padding:0 21px;border-bottom:1px #eaeaea solid;  font-size:14px;}
.List li a {width:100%;padding:13px 0 6px 0;font-size:17px; color:#000;font-weight:bold; line-height:20px;font-weight:bold;display:block; text-decoration:none;}
.List li a em {color:#888;font-size:16px;}
</style>

</head>
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*"%>
<%@ include file="/smart/cookies.jsp" %> 

<%
	String gubun = request.getParameter("gubun")==null?"c_mon":request.getParameter("gubun");
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
	Vector vt = p_db.getOffPropList(gubun, t_wd, gubun1, gubun2, "1", ck_acar_id);
	int vt_size = vt.size();
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
		
 	//내용 보기
	function view_bbs(prop_id){
		var fm = document.form1;
		fm.prop_id.value = prop_id;
		fm.action = 'prop_info.jsp';
		fm.submit();
	}				
//-->
</script>

</head>

<body onload="document.form1.t_wd.focus()">

<table width=100% border=0 cellspacing=0 cellpadding=0>

<form name="form1" method="post"   action='prop_list.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  
	<input type='hidden' name='prop_id'		value=''>
<div id="wrap">
	<div id="header">
        <div id="gnb_box">        	
        
            <div id="gnb_login">제안함</div>
            <div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
	<div id="contents">    
    	<div id="search">
			<fieldset class="srch">
				<legend>검색영역</legend>
				<select name="gubun"> 
	            	<option value=""  		<% if(gubun.equals("")) out.print("selected"); %>>전체</option>
	                <option value="c_mon"  <% if(gubun.equals("c_mon")) out.print("selected"); %>>당월</option>
					<option value="b_mon"  <% if(gubun.equals("b_mon")) out.print("selected"); %>>전월</option>
	                <option value="c_year"  <% if(gubun.equals("c_year")) out.print("selected"); %>>당해</option>					
					<option value="title"	<% if(gubun.equals("title")) out.print("selected"); %>>제목</option>
					<option value="content" <% if(gubun.equals("content")) out.print("selected"); %>>내용</option>
					<option value="user_nm" <% if(gubun.equals("user_nm")) out.print("selected"); %>>작성자</option>					  																		
				</select> 
				<input accesskey="s" class="keyword" title=검색어 type="text" name="t_wd" value="<%=t_wd%>"> 
				<input alt=검색 src="/smart/images/btn_srch.gif" type="image"> 
			</fieldset> 
		</div>  	     
       	<tbody>          		
			<%	if(vt_size > 0)	{
				for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>	
                
                 <ul class="List">
	               	  <li><a href="prop_info.jsp?prop_id=<%=ht.get("PROP_ID")%>" title='제안내역'>
	               	 	 <span>	               	 	 
						  <font color="#990000">[<%=ht.get("STEP")%>]</font>							
	               	 	  <%if(String.valueOf(ht.get("USE_YN")).equals("Y")|| String.valueOf(ht.get("USE_YN")).equals("M")){ %><img src=/smart/images/mservice_icon.gif align=absmiddle><% } %> 
							 <%=ht.get("TITLE")%>&nbsp;</span></a>				 							 
					 <span><font color='#3b44bb'><b>
					 <% if (  ht.get("OPEN_YN").equals("Y")) { %><%=ht.get("USER_NM")%>
					<% } else {  %>
					비공개 
					<% } %>
					 </b>&nbsp;|&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></font></span><br> 
		    		 <div style="height:7px;"></div>
		    		 <span>
		    			<%=Util.subData(String.valueOf(ht.get("CONTENT1")),30)%>&nbsp;</span><br> 		    		
		    		 <div style="height:10px;"></div>
		    		 </li>													    		
    			</ul>	    			
             	
                <% if(i == (vt_size  - 1)) break;
							  	}//for
							}else{ %>
                            <span>데이타가 없습니다.</span><br> 		
                            
                <% } %> 
               <div style="height:10px;"></div>
       	</tbody>                      
	 </div>    
</div>	    
</form>
</body>
</html>