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
#contents {float:left; width:100%;}
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

.News_tit .date {padding:14px 15px; font-size:14px;color:#888; border-bottom:1px #e5e5e7 solid;  border-top:1px #e5e5e7 solid; background:#e5e5e7; font-weight:bold;}
.News_tit {padding:5px 0 14px 0;position:relative;}
.News_content {padding:20px 15px;font-size:16px;color:#111;border-bottom:1px #e5e5e7 solid;}
.News_tit h3 {font-size:18px; color:#990000; line-height:20px; padding:0 15px 20px 15px;}
</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.know_how.*"%>
<%@ include file="/smart/cookies.jsp" %> 

<%
	int know_how_id = request.getParameter("know_how_id")==null?0:Util.parseInt(request.getParameter("know_how_id"));
	int count = 0;
	
	Know_how_Database kh_db = Know_how_Database.getInstance();

	Vector vt = kh_db.Know_how_View(know_how_id);
	int vt_size = vt.size();
	
	
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>

</head>
<body onLoad="javascript:self.focus()">
<form name="form1" method="post">	
<%@ include file="/smart/include/search_hidden.jsp" %>
	<input type="hidden" name="know_how_id" value="<%=know_how_id%>">	
	<%	for(int j=0; j< vt_size; j++){
		Hashtable ht = (Hashtable)vt.elementAt(j);
	%>
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">			
			    <%if(ht.get("KNOW_HOW_ST").equals("1")){%>
							지식Q&A
							<%}else if(ht.get("KNOW_HOW_ST").equals("2")){%>
							오픈지식
							<%}%></div> 
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>           
        </div>
    </div>    
	<div id="contents">
	 	
	 <tbody>
			<div class="News_tit">
			<h3><%=ht.get("TITLE")%></h3>
			<div class=date><font color='#3b44bb'><%=ht.get("USER_NM")%></font></b>&nbsp;/&nbsp;<%=ht.get("DEPT_NM")%>&nbsp;/&nbsp;<%= AddUtil.ChangeDate2((String)ht.get("REG_DT")) %></span></div>	
			<div class="News_content" ><%=HtmlUtil.htmlBR(String.valueOf(ht.get("CONTENT")))%></div>			
		  </div>			
	</tbody>
	
	</div>
</div>
<%}%>
</form>		
</body>
</html>