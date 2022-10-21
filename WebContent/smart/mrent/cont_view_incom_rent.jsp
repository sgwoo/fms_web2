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
#wrap {float:left; margin:0 auto; width:100%; background-color:#ffffff;}
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

/* 리스트 */
.search_list {width:100%; text-align:center; border-bottom:2px solid #b0baec; border-collapse:collapse;}
.search_list caption {display:none;}
.search_list th {padding:7px 0 4px 0; background-color:#e2e7ff; border-top:2px solid #b0baec; border-left:1px solid #b0baec; border-right:1px solid #b0baec; border-bottom:1px solid #b0baec; font-size:14px; font-family:NanumGothic, '나눔고딕'; font-weight:bold; color:#666666;}
.search_list td {padding:6px 0 4px 0; border:1px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}

/* UI Object */

.srch{width:100%;padding:5px 0}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}
/* //UI Object */


/* UI Object */
.lst_type{width:auto;padding:20px;border:1px solid #c2c2c2;list-style:none; background-color:#ffffff; font-family:'나눔고딕',Dotum;font-size:15px;}
.lst_type li{margin-bottom:5px;font-family:'나눔고딕',Dotum;font-size:15px;font-weight:normal;line-height:14px;vertical-align:top}
.lst_type li a{color:#1478CD;text-decoration:none;font-family:'나눔고딕',Dotum;font-size:20px;font-weight:normal;line-height:30px;display:inline;} /*링크*/
.lst_type li em{color:#f84e12}
.lst_type li a:hover{text-decoration:underline}
/* //UI Object */

</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
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
	
	if(gubun3.equals("")) gubun3 = "0";
	
	
	Vector vt = s_db.getScdRentMngList_New(gubun3, gubun4, "2", car_mng_id, "");//(String gubun3, String gubun4, String s_kd, String t_wd)
	int vt_size = vt.size();
%> 

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		fm.action = 'cont_view_incom_rent.jsp';
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}

	function view_before()
	{
		var fm = document.form1;		
		fm.action = "cont_view_incom.jsp";		
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
<form name='form1' method='post' action='cont_view_incom_rent.jsp'>
	<input type='hidden' name="s_width" value="<%=s_width%>">   
  	<input type='hidden' name="s_height" value="<%=s_height%>">     
  	<input type='hidden' name="sh_height" value="<%=sh_height%>">   
  	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  	<input type='hidden' name='br_id' value='<%=br_id%>'>
  	<input type='hidden' name='user_id' value='<%=user_id%>'>    
  	<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
  	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
  	<input type='hidden' name='t_wd1' value='<%=t_wd1%>'>
  	<input type='hidden' name='t_wd2' value='<%=t_wd2%>'>
  	<input type='hidden' name='s_br' value='<%=s_br%>'>
  	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
  	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
  	<!--<input type='hidden' name='gubun3' value='<%=gubun3%>'>-->
  	<input type='hidden' name='gubun4' value='<%=gubun4%>'>
  	<input type='hidden' name='gubun5' value='<%=gubun5%>'>
  	<input type='hidden' name='gubun6' value='<%=gubun6%>'>  
  	<input type='hidden' name='chk1' value='<%=chk1%>'>
  	<input type='hidden' name='chk2' value='<%=chk2%>'>
  	<input type='hidden' name='chk3' value='<%=chk3%>'>
  	<input type='hidden' name='chk4' value='<%=chk4%>'>
  	<input type='hidden' name='chk5' value='<%=chk5%>'>  
  	<input type='hidden' name='chk6' value='<%=chk6%>'>  
  	<input type='hidden' name='chk7' value='<%=chk7%>'>      
  	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
  	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
  	<input type='hidden' name='sort' value='<%=sort%>'>
  	<input type='hidden' name='asc' value='<%=asc%>'>
	  
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>		
	
	
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
    	<div id="search">
<!--ui object -->
		<fieldset class="srch">
			<legend>검색영역</legend>
			단기요금
			<select name="gubun3" >			
                <option value="0" <%if(gubun3.equals("0")){%>selected<%}%>>전체</option>			
                <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>수금</option>
                <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>미수금</option>
        	</select>
			<input alt=검색 src="/smart/images/btn_srch.gif" type="image"> 
		</fieldset> 
<!--//ui object -->
		</div>
		<br>
	
		 <%for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
			<ul class="lst_type">
				<li>
					<span><h3>(<%=i+1%>) <%=ht.get("RENT_ST")%> <%=Util.parseDecimal(String.valueOf(ht.get("RENT_AMT")))%>원 <%if(String.valueOf(ht.get("PAY_DT")).equals("")){%><em>미수금</em><%}%></h3></span>
					
					
					<br>
					
					| 상호 : <%=ht.get("FIRM_NM")%> <%=ht.get("CUST_NM")%>
					<br>
					| 계약일자 : <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>
					<br>					
					| 입금예정일 : <%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%>					
					
					<%if(!String.valueOf(ht.get("PAY_DT")).equals("")){%>
					<br>
					| 수금일자 : <%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_DT")))%>
					<%}%>

				</li>
			</ul>
          <%}%>
		  <%if(vt_size==0){%>
			<ul class="lst_type">
				<li><span>데이타가 없습니다.</span>
				</li>
			</ul>		  
		  <%}%>		  
	</div>     
</div>
</form>
</body>
</html>