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
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%;}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}


/* 둥근테이블 시작 */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}
        
#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}




/* 내용테이블 */
.contents_box {width:100%; table-layout:fixed; font-size:14px;}
.contents_box th {color:#282828; width:90px; height:28px; text-align:left; font-weight:bold; font-size:14px;}
.contents_box td {line-height:16px; height:20px; color:#7f7f7f; font-weight:bold;}
.contents_box em{color:#fd5f00; font-weight:bold;}



/* 제목테이블 */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
#cbtn { text-align:center; margin:15px 0 0 0;}


</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //계약건수
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
	
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	String from_page 		= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	//세금계산서정보
	Vector vt = new Vector();
	
	if(from_page.equals("fms_menu.jsp")) 		vt = a_db.getTAXContList("1", client_id, "");	//String s_kd, String t_wd, String gubun1
	else if(from_page.equals("cont_menu.jsp")) 	vt = a_db.getTAXContList("3", rent_l_cd, "");	//String s_kd, String t_wd, String gubun1
	
	int vt_size = vt.size();
%>

<style type=text/css>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #828282;
         font-size: 11px;}
.style2 {color: #ff00ff;
         font-size: 11px;} 
.style3 {color: #727272}
.style4 {color: #ef620c}
.style5 {color: #334ec5;
        font-weight: bold;} 
-->

</style>


<script language='javascript'>
<!--
	function view_info()
	{
		var fm = document.form1;		
		fm.action = "tax_list.jsp";
		fm.submit();
	}
	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "<%=from_page%>";		
		fm.submit();
	}	
	
	function view_sitemap()
	{
		var fm = document.form1;	
		fm.action = "sitemap.jsp";		
		fm.submit();
	}								
//-->
</script>

</head>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>		
	<input type='hidden' name='from_page' 	value='<%=from_page%>'>		

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%if(from_page.equals("fms_menu.jsp")){%>
				<%=AddUtil.subData(firm_nm, 6)%>
				<%}else{%>
				<%=car_no%>
				<%}%>
			</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+메뉴'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">	
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">세금계산서정보</div>			
			<%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">					
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					    <!--
						<tr>
							<th width="90px">차량번호</th>
							<td><%//=ht.get("CAR_NO")%></td>
						</tr>
						-->
						<tr>
							<th>구분</th>
							<td><%=ht.get("TAX_TYPE_NM")%></td>
						</tr>
						<tr>
							<th>청구서수령방법</th>
							<td><%=ht.get("REC_ST")%></td>
						</tr>
						<tr>
							<th>전자세금계산서</th>
							<td><%=ht.get("ELE_TAX_ST")%></td>
						</tr>
						<tr>
							<th>공급받는자</th>
							<td><%=ht.get("RECCONAME")%> <%=ht.get("RECCOREGNO")%></td>
						</tr>
						<tr>
							<th>담당자</th>
							<td><%=ht.get("AGNT_NM")%> <%=ht.get("AGNT_EMAIL")%></td>
						</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<%}%>
		<%if(vt_size==0){%>
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">		
				데이타가 없습니다.
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>		
		<%}%>
	</div>	
	<div id="cbtn"><a href="javascript:view_info()" onMouseOver="window.status=''; return true" title=''><img src="/smart/images/btn_bill_list.gif" /></a></div>			
		
    <div id="footer"></div>  
</div>
</form>
</body>
</html>
