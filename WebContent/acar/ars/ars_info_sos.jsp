<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.util.*, java.util.List" %>
<%@ page import="java.net.URLEncoder, java.net.URLDecoder" %>
<%@ page import="acar.ars.*, acar.common.*, acar.util.*, acar.cont.*, acar.user_mng.*, acar.client.*, acar.cont.*, acar.insur.*, acar.car_register.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="ars_db" scope="page" class="acar.ars.ArsApiDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<%
	String search_type = request.getParameter("search_type") == null ? "" : request.getParameter("search_type");
	String number = request.getParameter("number") == null ? "" : request.getParameter("number");
	String gubun = request.getParameter("gubun") == null ? "" : request.getParameter("gubun");
	
	String type = request.getParameter("type") == null ? "" : request.getParameter("type");
	
	String client_id = request.getParameter("client_id") == null ? "" : request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm") == null ? "" : request.getParameter("firm_nm");
	String car_no = request.getParameter("car_no") == null ? "" : request.getParameter("car_no");
	
	String user_id = request.getParameter("user_id") == null ? "" : request.getParameter("user_id");
	String user_nm = request.getParameter("user_nm") == null ? "" : request.getParameter("user_nm");
	String user_m_tel = request.getParameter("user_m_tel") == null ? "" : request.getParameter("user_m_tel");
	
	String send_type = request.getParameter("send_type") == null ? "" : request.getParameter("send_type");
	
	String rent_mng_id = request.getParameter("rent_mng_id") == null ? "" : request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd") == null ? "" : request.getParameter("rent_l_cd");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if (user_id.equals("")) {
		user_bean = umd.getUsersBean(base.getBus_id2());
	} else {
		user_bean = umd.getUsersBean(user_id);
	}
	
	//보험정보
	String ins_st = "";
	String ins_com_nm = "";
	
	if (!base.getCar_mng_id().equals("")) {		
		ins_st 	= ai_db.getInsSt(base.getCar_mng_id());
		ins_com_nm = ai_db.getInsComNm(base.getCar_mng_id());
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>긴급출동서비스 안내</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<style>
body { 
	-webkit-text-size-adjust : auto; /* 기존과 똑같이 작동하도록 한다 */
	background-color: #FFFFFF !important; 
}
.container {
    margin-right: auto;
    margin-left: auto;
}
.swiper-container {
    width: 100%;
    height: 100%;
}   
.swiper-slide {
	width:100%;
    text-align: center;
    font-size: 16px;
    background: #fff;    
    /* Center slide text vertically */
    display: -webkit-box;
    display: -ms-flexbox;
    display: -webkit-flex;
    display: flex;
    -webkit-box-pack: center;
    -ms-flex-pack: center;
    -webkit-justify-content: center;
    justify-content: center;
    -webkit-box-align: center;
    -ms-flex-align: center;
    -webkit-align-items: center;
    align-items: center;
}
.swip_title {
	border: 1px solid #000;
    border-radius: 8px;
    padding-top: 15px;
    padding-bottom: 10px;
}
.padding_LR_0 {
	padding-left: 0px;
	padding-right: 0px;
}
.padding_top_20 {
	padding-top: 20px;
}
.padding_b_3 {
	padding-bottom: 3px;
}
.margin-top-5 {
	margin-top: 5px;
}
.active {
	vertical-align: middle !important;
	font-weight: bold;
}
.active-th {
	vertical-align: middle !important;
	height: 60px !important;
	font-weight: bold;
}
.mid {
	vertical-align: middle !important;
}
.carousel-control {
    width: 5%;
}
.carousel-control:focus, .carousel-control:hover {
    color: #fff;
    text-decoration: none;
    outline: 0;
    filter: alpha(opacity=90);
    opacity: 0.9;
}
.carousel-control.left {
    background-image: none;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#80000000', endColorstr='#00000000', GradientType=1);
}
.carousel-control.right {
    right: 0;
    left: auto;
    background-image: none;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#00000000', endColorstr='#80000000', GradientType=1);
}
.table>tbody>tr.active>td, .table>tbody>tr.active>th, .table>tbody>tr>td.active, .table>tbody>tr>th.active, .table>tfoot>tr.active>td, .table>tfoot>tr.active>th, .table>tfoot>tr>td.active, .table>tfoot>tr>th.active, .table>thead>tr.active>td, .table>thead>tr.active>th, .table>thead>tr>td.active, .table>thead>tr>th.active {
    background-color: #00378a;
    color: #FFF;
}
.table-bordered {
    border: 1px solid #b3bfd4;
}
.table-bordered>tbody>tr>td, .table-bordered>tbody>tr>th, .table-bordered>tfoot>tr>td, .table-bordered>tfoot>tr>th, .table-bordered>thead>tr>td, .table-bordered>thead>tr>th {
    border: 1px solid #b3bfd4;
}
a{
	color: #333333;
}
.glyp-color {
	color: #b3bfd4;
}
.glyp-color-yellow {
	color: #eed5ab;
}
.logo-img-div {
	padding: 10px;
}
.logo-img-size {
	width: 140px;
	height: 25px;
}
.title-back-img-1 {
	background-image: url("../images/main_1.png");
	background-repeat: no-repeat;
	background-size: cover; 
	width: 100%;
	height: 100%;
	min-height: 110px;
	max-height: 110px;
}
.title-back-img-2 {
	background-image: url("../images/main_2.png");
	background-repeat: no-repeat;
	width: 100%;
	height: 100%;
	min-height: 110px;
	max-height: 110px;
}
.title-back-img-3 {
	background-image: url("../images/main_3.png");
	background-repeat: no-repeat;
	width: 100%;
	height: 100%;
	min-height: 110px;
	max-height: 110px;
}
.title-img-div-position {
	position: relative;
}
.title-text {
	color: #FFF;
	font-size: 20px;
	font-weight: bold;
	text-align: center;
	padding-top: 40px;
}
.title-mid {
	padding: 15px 0px 10px 18px;
	font-size: 18px;
	font-weight: bold;
}
.title-mid-second {
	padding: 30px 0px 10px 18px;
	font-size: 18px;
	font-weight: bold;
}
.main-content-div {
	padding: 10px 0px 50px 0px;
}
.content-padding-left {
	padding: 10px 0px 10px 5px;
	height: 60px;
}
.content-padding-right {
	padding: 20px 5px 10px 0px; 
	height: 60px;
}
.content2-padding {
    padding: 10px 10px 10px 20px;
    height: 40px;
}
.content2-sub-padding {
    padding: 15px 10px 15px 20px;
    color: #333;
    font-size: 12px;
}
.com-border {
	border: 1px solid #b3bfd4;
}
.no-top-border {
	border-top-color: #FFF;
}
.sub-text {
	padding: 10px 0px 0px 0px;
	font-size: 12px;
}
.bg-color-sky {
	background-color: #ECF4FF;
}
.detail {
	display: none;
}
</style>
<script type="text/javascript">
$(document).ready( function() {
	$('div.detail-link').click(function(){		
		$(this).next().toggle();
		
		var toggle_status = $(this).next().is(":visible");
		
		if (toggle_status == true) {
			$(this).find(".up").css("display", "");
			$(this).find(".down").css("display", "none");
		} else {
			$(this).find(".up").css("display", "none");
			$(this).find(".down").css("display", "");
		}
	})
});
</script>
</head>
<body>
	<div class="container">
		<div class="logo-img-div text-center">
			<img class="logo-img-size" src="https://www.amazoncar.co.kr/home/mobile/images/logo_1.png">
		</div>
		<div id="myCarousel" class="carousel slide" data-ride="carousel" data-interval="false">
			<!-- Indicators -->
			<ol class="carousel-indicators" style="display: none;">
				<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
				<li data-target="#myCarousel" data-slide-to="1"></li>
				<li data-target="#myCarousel" data-slide-to="2"></li>
				<li data-target="#myCarousel" data-slide-to="3"></li>
			</ol>

			<!-- Wrapper for slides -->
			<div class="carousel-inner">
			
				<!-- 사고처리 연락처 안내 -->
				<div class="item active">
					<div class="title-back-img-1">
						<div class="title-text">긴급출동서비스 이용안내</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">           			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				긴급출동서비스제공 업체 현황
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					마스타자동차관리
           						<br>
           						<a href="tel:1588-6688">1588-6688</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:1588-6688"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border no-top-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					SK네트웍스
           						<br>
           						<a href="tel:1670-5494">1670-5494</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:1670-5494"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<%if (!user_bean.getBr_nm().equals("")) {%>
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid-second">
            				아마존카 담당자
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					<%=user_bean.getBr_nm()%> <%=user_bean.getUser_nm()%>
           						<br>
           						(직통) <a href="tel:<%=user_bean.getHot_tel()%>"><%=user_bean.getHot_tel()%></a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:<%=user_bean.getHot_tel()%>"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border no-top-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					<%=user_bean.getBr_nm()%> <%=user_bean.getUser_nm()%>
           						<br>
           						(HP) <a href="tel:<%=user_bean.getUser_m_tel()%>"><%=user_bean.getUser_m_tel()%></a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:<%=user_bean.getUser_m_tel()%>"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			<%}%>    		
	            	</div>
				</div>
				

				<div class="item">
					<div class="title-back-img-1">
						<div class="title-text">긴급출동서비스 이용안내</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				긴급출동서비스 상세내용
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					<!-- 긴급견인서비스 -->
            					견인서비스
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- 대상차량의 사고 또는 고장으로 인하여 자력운행이 불가능한 경우에 10km 내에서 "고객"이 지정하는 곳으로 견인하는 서비스를 말한다. 단, 10km 초과하는 경우에는 "고객"이 1KM당 2,000원의 추가비용을부담한다. -->
	            				자동차가 고장, 사고 등으로 자력운행이 불가능하게 된 때, 고객님이 지정한 곳까지 견인하는 서비스입니다. 단, 견인 거리가 10km를 초과하게 되면 추가비용이 발생할 수 있습니다. 추가비용은 고객님께서 부담하셔야 합니다. (2020년 현재, 1km당 2,000원)
            				</div>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					<!-- 비상급유서비스 -->
            					급유서비스
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- 대상차량의 연료 소진으로 인하여 운행이 불가능한 경우에 연료(휘발유/ 경유 3리터 이내, LPG차량 및 전기자동차는 긴급견인서비스 제공)를 보충하는 서비스를 말한다. -->
	            				연료가 부족해서 더는 운행이 불가능하게 된 경우, 긴급하게 연료를 보충하는 서비스입니다. (휘발유/경유는 3 리터 이내, LPG 및 전기자동차는 견인서비스)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					배터리충전서비스
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- 대상차량의 배터리 방전으로 인하여 운행이 불가능한 경우에 배터리를 충전하는 서비스를 말한다. 단, 배터리충전은 12V 사용 차량에 한하며, 배터리 교환 시에는 “아마존카” 또는 "고객"이 실비를 부담한다. -->
	            				배터리가 방전돼 더는 운행이 불가능하게 된 자동차 배터리에 충전하는 서비스입니다. 단, 12V 배터리를 사용하는 자동차만 충전서비스가 가능하며, 배터리를 교환할 경우 실비는 고객님께서 부담하셔야 합니다. 단, 계약상품에 따라서는 “당사” 가 부담합니다.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					타이어서비스
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- 가.	타이어교체서비스대상차량의 타이어 펑크로 운행이 불가능한 경우에 대상차량의 예비타이어가 있는 경우에 한하여 고장 난 타이어를 예비타이어로 교체하는 서비스를 말한다.<br>
								나.	타이어수리서비스대상차량이 지면에 닿은 타이어 트레드 부분의 펑크로 인하여 운행이 불가능할 경우 펑크를 수리하는 서비스를 말하며, 타이어수리 시 펑크 1개당 10,000원의 수리비용을 "고객"이 부담한다.다만, 아래 각 목의 경우로 타이어수리서비스의 제공에 제한이 생길 경우에는 긴급출동 서비스 항목 중 긴급견인서비스를 제공할 수 있다.
								<br><br>
								1.	타이어가 찢어진 경우<br>
								2.	타이어펑크의 크기, 모양 및 위치에 따라 타이어수리서비스가 불가능한 경우<br>
								3.	야간 및 눈, 비 등 기상상황 등의 현장사정에 의해 수리서비스가 어려운 경우<br> -->
								1. 타이어 교체서비스 : 타이어에 구멍(펑크)이 나서 더는 운행이 불가능하게 된 경우, 예비타이어로 교체하는 서비스입니다.<br>
								2. 수선 서비스 : 예비타이어가 없거나 타이어 트레드(tread) 부위(지면에 맞닿는 부분)에 구멍이 났을 때 현장에서 수선하는 서비스(단, 수선 부위 1곳당 10,000원(2020년 현재)은 고객님께서 부담하셔야 합니다.)<br>
								3. 견인서비스 : 타이어가 찢어졌거나, 수선이 불가하게끔 타이어에 구멍이 났거나, 기상 상황 및 현장 사정으로 수선 서비스가 어렵게 된 경우에는 견인서비스로 대체.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					잠금장치해제서비스
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- 대상차량의 열쇠를 차내에 두거나 분실 등으로 차문을 열 수 없는 경우에 잠금 장치를 해제하는 서비스를 말한다.단, 트렁크 잠금 장치 해제 및 외제차량이나 일반적 방법으로 해제가 되지 않는 특수 잠금 장치 차량은 제외한다. -->
	            				자동차 문을 열 수 없게 된 경우에 출동해 잠금장치를 해제하는 서비스입니다. 단, 일반적인 방법으로는 해제가 불가한 특수잠금장치(스마트키, 이모빌라이저), 사이드에어백이 장착되어 있는 자동차는 서비스를 제공하지 않습니다. 아울러 일부 외산 자동차 또한 서비스 대상 자동차가 아닐 수도 있습니다. 이때는 서비스 자체가 불가(트렁크잠금장치해제포함)할 수도 있습니다.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					긴급구난서비스
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- 대상차량이 도로를 이탈하거나 장애물로 인하여 운행이 불가능하여 구난이 필요한 경우에 긴급 구난하는 서비스를 말한다.(단,별도의 구난장비 없이 본조①항의 서비스 제공을 위한 자동차로 구난이 가능한 경우에 한하며,[특수한 구난]을 한 경우에는 별도의 구난비용이 고객에게 청구한다.또한 차량의 적재물로 인하여 서비스의 제공에 제한이 생길 경우에는 이 서비스를 제공하지 않는다.)
	            				<br><br>
	            				※ 특수한 구난<br>
								1. 2.5t을 초과하는 구난형 특수 자동차로 구난한 경우<br>
								2. 2대 이상의 구난형 특수 자동차가 구난한 경우<br>
								3. 구난작업을 시작하여 견인고리 연결할 때까지 소요시간이 30분을 초과하는 경우<br>
								4. 외제차량 또는 2,500cc 이상의 국산차량을 구난하는 경우<br>
								5. 기타 별도의 구난장비(세이프티로더 등)를 사용하여 구난하는 경우 -->
								자동차가 도로를 이탈했거나 장애물 등으로 운행이 불가해 구난이 필요한 경우에 제공하는 서비스입니다. 단, 아래와 같이 특수한 구난이 필요한 경우, 추가비용이 발생할 수 있으며 그 비용은 고객님께서 부담하셔야 합니다.
								<br><br>
								※ 특수한 구난<br>
								1. 2.5t을 초과하는 특수자동차로 구난한 경우<br>
								2. 2대 이상의 특수자동차가 함께 구난한 경우<br>
								3. 구난작업을 시작하고 견인용 고리에 연결할 때까지의 소요시간이 30분을 초과하여 작업한 경우<br>
								4. 수입 자동차 또는 2,500cc 이상의 국내산 차량을 구난한 경우<br>
								5. 세이프티로더(견인 고리가 아닌 별도 제작된 적재함에 싣고 이동하는 구난용 자동차) 등의 별도 구난용 장비를 사용하게 된 경우
            				</div>
            			</div>
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					기타출동서비스
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- 본조①~⑥항의 서비스 외 차량의 고장 또는 이상으로 정상적인 운행이 어려운 경우 안전과 정상적인 운행이 가능하도록 조치하는 서비스를 말한다. -->
	            				자동차가 고장 또는 이상 증상으로 더는 정상적인 운행이 어려운 경우, 안전한 운행이 가능하도록 조치하고 도움을 주는 서비스입니다.
            				</div>
            			</div>
            			
	            	</div>
	            	
				</div>
				
			</div>

			<!-- Left and right controls -->
			<a class="left carousel-control" href="#myCarousel" data-slide="prev">
				<span class="glyphicon glyphicon-chevron-left" style="left: 0px; color: #000; text-align: right;"></span> <span class="sr-only">Previous</span>
			</a> 
			<a class="right carousel-control" href="#myCarousel" data-slide="next"> 
				<span class="glyphicon glyphicon-chevron-right" style="right: 0px; color: #000; text-align: left;"></span> <span class="sr-only">Next</span>
			</a>
		</div>
	</div>
	
</body>
</html>
