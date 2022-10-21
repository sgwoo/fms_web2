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
.contents_box {width:100%; table-layout:fixed; font-size:14px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box td .firm {line-height:18px; color:#58351e; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; font-size:14px; margin:5px 5px;}
.contents_box1 th {color:#282828; width:115px; height:26px; text-align:left; font-weight:bold;}
.contents_box1 td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:18px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font-size:16px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.fee.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase" scope="page"/>
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
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	
	int    fee_opt_s_amt[]		= new int [fee_size];
	int    fee_opt_v_amt[]		= new int [fee_size];
	int    fee_ja_s_amt[]		= new int [fee_size];
	int    fee_ja_v_amt[]		= new int [fee_size];
	int    fee_ja_r_s_amt[]		= new int [fee_size];
	int    fee_ja_r_v_amt[]		= new int [fee_size];
	String  fee_opt_per[]		= new String [fee_size];
	float  fee_max_ja[]			= new float [fee_size];
	float  fee_app_ja[]			= new float [fee_size];
	int    fee_sh_amt[]			= new int [fee_size];
	
	for(int i=0; i<fee_size; i++){
		ContFeeBean fee_bean 		= a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(i+1));
		
		ContCarBean fee_etc_bean 	= a_db.getContFeeEtc(rent_mng_id, rent_l_cd, String.valueOf(i+1));
		
		fee_opt_s_amt[i]		= fee_bean.getOpt_s_amt();
		fee_opt_v_amt[i]		= fee_bean.getOpt_v_amt();
		fee_ja_s_amt[i]			= fee_bean.getJa_s_amt();
		fee_ja_v_amt[i]			= fee_bean.getJa_v_amt();
		fee_ja_r_s_amt[i]		= fee_bean.getJa_r_s_amt();
		fee_ja_r_v_amt[i]		= fee_bean.getJa_r_v_amt();
		fee_opt_per[i]			= fee_bean.getOpt_per();
		fee_max_ja[i]			= fee_bean.getMax_ja();
		fee_app_ja[i]			= fee_bean.getApp_ja();
		fee_sh_amt[i]			= fee_etc_bean.getSh_amt();
		
	}
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
    	<div id="ctitle">차량가격</div>	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>신차소비자가 </th>
							<td><%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt()-car.getDc_cs_amt()-car.getDc_cv_amt())%>원 (VAT포함)</td>
						</tr>					
						<%if(fee_size==1 && base.getCar_gu().equals("0")){%>
						<tr>
							<th>재리스기준차가</th>
							<td><%= AddUtil.parseDecimal(fee_sh_amt[fee_size-1]) %>원 (VAT포함)</td>
						</tr>												
						<%}else{%>
						<%		if(fee_size >1 && fee_opt_s_amt[fee_size-2] >0){%>
						<tr>
							<th>연장기준차가<br>(전계약매입옵션)</th>
							<td><%= AddUtil.parseDecimal(fee_opt_s_amt[fee_size-2]+fee_opt_v_amt[fee_size-2]) %>원 (VAT포함)</td>
						</tr>												
						<%		}else if(fee_size >1 && fee_opt_s_amt[fee_size-2] == 0 ){%>
						<tr>
							<th>연장기준차가</th>
							<td><%= AddUtil.parseDecimal(fee_sh_amt[fee_size-1]) %>원 (VAT포함)</td>
						</tr>						
						<%		}%>
						<%}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">잔가</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width=100px>최대잔가</th>
				    		<td><%= AddUtil.parseDecimal(fee_ja_s_amt[fee_size-1]+fee_ja_v_amt[fee_size-1]) %>원 (VAT포함)</td>
				    	</tr>
				    	<tr>
				    		<th>차가대비</th>
				    		<td><%=fee_max_ja[fee_size-1]%>%</td>
				    	</tr>
				    	<tr>
				    		<th>적용잔가</th>
				    		<td><font color=#fd5f00><%= AddUtil.parseDecimal(fee_ja_r_s_amt[fee_size-1]+fee_ja_r_v_amt[fee_size-1]) %>원 (VAT포함)</font></td>
				    	</tr>
				    	<tr>
				    		<th>차가대비</th>
				    		<td><%=fee_app_ja[fee_size-1]%>%</td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
		<div id="ctitle">매입옵션</div>	
		<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width=100px>공급가격</th>
							<td><%= AddUtil.parseDecimal(fee_opt_s_amt[fee_size-1]) %>원</td>
						</tr>
						<tr>
							<th>부가세</th>
							<td><%= AddUtil.parseDecimal(fee_opt_v_amt[fee_size-1]) %>원</td>
						</tr>
						<tr>
							<th>합계</th>
							<td><%= AddUtil.parseDecimal(fee_opt_s_amt[fee_size-1]+fee_opt_v_amt[fee_size-1]) %>원</td>
						</tr>
						<tr>
							<th>차가대비</th>
							<td><%=fee_opt_per[fee_size-1]%>%</td>
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