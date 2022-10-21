<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS Client_Info</title>
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
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40Px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}


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
.contents_box td {line-height:16px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}




</style>
<script language='javascript'>
<!--	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "rlscar_list.jsp";		
		fm.submit();
	}			
//-->
</script>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.* "%>
<%@ page import="acar.off_ls_hpg.*, acar.car_register.* "%>
<jsp:useBean id="oh_db" scope="page" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	//차량정보
	Hashtable secondhand = oh_db.getSecondhandCase_20090901(rent_mng_id, rent_l_cd, car_mng_id);
	
	//자동차등록정보
	cr_bean = crd.getCarRegBean(car_mng_id);
%>

<body>

<form name='form1' method='post' action=''>
<%@ include file="/smart/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='from_page'	value='<%=from_page%>'>
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login"><%=car_no%> 차량정보</div>
			<div id="gnb_home">
			<a href="rlscar_list.jsp" onMouseOver="window.status=''; return true" title='리스트 가기'><img src=/smart/images/button_list.gif align=absmiddle /></a>
			<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
            
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">등록사항</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="80" valign=top>차명</th>
							<td valign=top><b><font color='#3b44bb'><%=secondhand.get("CAR_JNM")%>&nbsp;<%=secondhand.get("CAR_NM")%></font></b>&nbsp;</td>
						</tr>
						<tr>
				    		<th>제조사</th>
				    		<td><%=c_db.getNameById(String.valueOf(secondhand.get("CAR_COMP_ID")),"CAR_COM")%></td>
				    	</tr>
				    	<tr>
				    		<th>차종</th>
				    		<td><%=secondhand.get("CAR_KD")%></td>
				    	</tr>
				    	<tr>
				    		<th>연식</th>
				    		<td><%=cr_bean.getCar_y_form()%></td>
				    	</tr>
				    	<tr>
				    		<th>최초등록일</th>
				    		<td><%=cr_bean.getInit_reg_dt()%></td>
				    	</tr>
				    	<tr>
				    		<th>배기량</th>
				    		<td><%=cr_bean.getDpm()%>cc</td>
				    	</tr>
				    	<tr>
				    		<th>승차정원</th>
				    		<td><%=cr_bean.getTaking_p()%>명</td>
				    	</tr>
				    	<tr>
				    		<th>최대적재량</th>
				    		<td><%=cr_bean.getMax_kg()%>kg</td>
				    	</tr>
				    	<tr>
				    		<th>연료</th>
				    		<td><%=secondhand.get("FUEL_KD")%></td>
				    	</tr>
				    	<tr>
				    		<th>색상</th>
				    		<td><%=secondhand.get("COLO")%></td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">관리사항</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width="90">주행거리</th>
				    		<td><%=Util.parseDecimal(String.valueOf(secondhand.get("REAL_KM")))%>km</td>
				    	</tr>
				    	<tr>
				    		<th>차령만료일</th>
				    		<td><%=cr_bean.getCar_end_dt()%></td>
				    	</tr>
				    	<tr>
				    		<th>검사유효기간</th>
				    		<td><font color=#fd5f00><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%></font></td>
				    	</tr>
				    	<tr>
				    		<th>점검유효기간</th>
				    		<td><%=cr_bean.getTest_st_dt()%>~<%=cr_bean.getTest_end_dt()%></td>
				    	</tr>
				    	<tr>
				    		<th>타이어규격</th>
				    		<td><%=cr_bean.getTire()%></td>
				    	</tr>
				    	<tr>
				    		<th>특기사항</th>
				    		<td><%if(String.valueOf(secondhand.get("LPG_YN")).equals("장착")){%>LPG키트 <%= secondhand.get("LPG_YN") %><%}%></td>
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
