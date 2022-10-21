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
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
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
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:18px; color:#7f7f7f; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; font:13px; margin:5px 5px;}
.contents_box1 th {color:#282828; width:115px; height:26px; text-align:left; font-weight:bold;}
.contents_box1 td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:18px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_office.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
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
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//영업사원
	CarOffEmpBean coe_bean1 = new CarOffEmpBean();
	CarOffEmpBean coe_bean2 = new CarOffEmpBean();
	
	String damdang_id = "";
	
	if(!emp1.getEmp_id().equals("")){
		coe_bean1 = cod.getCarOffEmpBean(emp1.getEmp_id());
		damdang_id = cod.getCarOffEmpDamdangId(emp1.getEmp_id());
	}
	if(!emp2.getEmp_id().equals("")) coe_bean2 = cod.getCarOffEmpBean(emp2.getEmp_id());
	

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

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%if(car_no.equals("미등록")){%><%//=rent_l_cd%><%=car_nm%><%}else{%><%=car_no%><%}%>
			</div>
			<div id="gnb_home">
				<a href="javascript:view_sitemap()" onMouseOver="window.status=''; return true" title='+메뉴'><img src=/smart/images/button_pmenu.gif align=absmiddle /></a>
				<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">	
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">영업담당자</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>근무처</th>
							<td><%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>&nbsp;<%=emp1.getCar_off_nm()%></td>
						</tr>
				    	<tr>
				    		<th>성명</th>
				    		<td><%=emp1.getEmp_nm()%></td>
				    	</tr>
				    	<tr>
				    		<th>직위</th>
				    		<td><%= coe_bean1.getEmp_pos() %></td>
				    	</tr>
				    	<tr>
				    		<th>휴대폰</th>
				    		<td><a href="tel:<%=coe_bean1.getEmp_m_tel()%>"><font color=#fd5f00><%= coe_bean1.getEmp_m_tel() %></font></a></td>
				    	</tr>
				    	<tr>
				    		<th>대표전화</th>
				    		<td><a href="tel:<%=coe_bean1.getEmp_m_tel()%>"><font color=#fd5f00><%= coe_bean1.getEmp_h_tel() %></font></a></td>
				    	</tr>
				    	<tr>
				    		<th>팩스</th>
				    		<td><%= coe_bean1.getCar_off_fax() %></td>
				    	</tr>
				    	<tr>
				    		<th>메일</th>
				    		<td><a href="mailto:<%= coe_bean1.getEmp_email() %>"><%= coe_bean1.getEmp_email() %></a></td>
				    	</tr>
				    	<tr>
				    		<th>관리담당</th>
				    		<td><%=c_db.getNameById(damdang_id,"USER")%></td>
				    	</tr>
						
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">출고담당자</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th  width=100px>근무처</th>
							<td><%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%>&nbsp;<%=emp2.getCar_off_nm()%></td>
						</tr>
				    	<tr>
				    		<th>성명</th>
				    		<td><%=emp2.getEmp_nm()%></td>
				    	</tr>
				    	<tr>
				    		<th>직위</th>
				    		<td><%= coe_bean2.getEmp_pos() %></td>
				    	</tr>
				    	<tr>
				    		<th>휴대폰</th>
				    		<td><a href="tel:<%=coe_bean2.getEmp_m_tel()%>"><font color=#fd5f00><%= coe_bean2.getEmp_m_tel() %></font></a></td>
				    	</tr>
				    	<tr>
				    		<th>대표전화</th>
				    		<td><a href="tel:<%=coe_bean2.getEmp_h_tel()%>"><font color=#fd5f00><%= coe_bean2.getEmp_h_tel() %></font></a></td>
				    	</tr>
				    	<tr>
				    		<th>팩스</th>
				    		<td><%= coe_bean2.getCar_off_fax() %></td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
	</div>  
    <div id="footer"></div>  
</div>
</form>
</body>
</html>