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
#contents {float:left; width:100%; height:100%}
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

<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	int bbs_id = request.getParameter("bbs_id")==null?0:Util.parseInt(request.getParameter("bbs_id"));
	int count = 0;
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	
	//공지사항 한건 조회
	a_bean = oad.getAncBean(bbs_id);
	//읽기체크
//	count = oad.readChkAnc(bbs_id, acar_id);
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
	<input type="hidden" name="bbs_id" value="<%=bbs_id%>">	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">				
			    <%if(a_bean.getBbs_st().equals("1")){%>일반공지
				<%}else if(a_bean.getBbs_st().equals("2")){%>최근뉴스
				<%}else if(a_bean.getBbs_st().equals("3")){%>판매조건
				<%}else if(a_bean.getBbs_st().equals("4")){%>업무협조
				<%}else if(a_bean.getBbs_st().equals("5")){%>경조사
				<%}else if(a_bean.getBbs_st().equals("6")){%>규정및인사
				<%}else if(a_bean.getBbs_st().equals("7")){%>업그레이드
				<%}%></div> 
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>           
        </div>
    </div>    
	<div id="contents">
	 <tbody>
			<div class="News_tit">
			<h3>
				<%if(a_bean.getRead_yn().equals("Y")){%><img src="/smart/images/n_icon.gif" border=0 align=absmiddle>&nbsp;<%}%><%=a_bean.getTitle()%></h3>
			<div class=date><font color='#3b44bb'><%=a_bean.getUser_nm()%></font>&nbsp;/&nbsp;<%=a_bean.getDept_nm()%>&nbsp;/&nbsp;<%=a_bean.getReg_dt()%> ~ <%=a_bean.getExp_dt()%></div>	
			<div class="News_content" ><%=HtmlUtil.htmlBR(a_bean.getContent())%></div>			
		  </div>			
	</tbody>
	</div>
</div>
</form>		
</body>
</html>