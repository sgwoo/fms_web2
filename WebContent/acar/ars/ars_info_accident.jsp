<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.util.*, java.util.List" %>
<%@ page import="java.net.URLEncoder, java.net.URLDecoder" %>
<%@ page import="acar.ars.*, acar.common.*, acar.util.*, acar.cont.*, acar.user_mng.*, acar.client.*, acar.cont.*, acar.insur.*, acar.car_register.*" %>
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
<title>사고처리서비스 안내</title>
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
</style>
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
						<div class="title-text">사고처리 연락처 안내</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">           			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				보험회사 연락처
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					렌터카공제조합
           						<br>
           						<a href="tel:1661-7977">1661-7977</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:1661-7977"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border no-top-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					삼성화재(동부화재)
           						<br>
           						<a href="tel:1588-5114">1588-5114</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:1588-5114"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<%if(!base.getCar_st().equals("")){%>
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left sub-text" style="font-size: 14px;">            				
            				※ 고객님 자동차는 <span style="font-weight: bold; color: red;"><%if(base.getCar_st().equals("1")){%>렌트<%}else if(base.getCar_st().equals("2")){%>예비<%}else if(base.getCar_st().equals("3")){%>리스<%}else if(base.getCar_st().equals("4")){%>월렌트<%}else if(base.getCar_st().equals("5")){%>업무대여<%}%> 차량</span> 입니다.
            				<br>
            				<span style="font-weight: bold; color: red;"><%=ins_com_nm%></span>에 보험 가입되어 있습니다.
            			</div>
            			<%}%>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid-second">
            				긴급출동 서비스
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
            					SK 네트웍스
           						<br>
           						<a href="tel:1670-5494">1670-5494</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:1670-5494"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left sub-text">
            				※ 긴급출동 서비스는 렌터카와 리스상품을 구분하지 않습니다.
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid-second">
            				기타 연락처
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					경찰청
           						<br>
           						<a href="tel:112">112</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:112"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border no-top-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					119(안전신고센터)
           						<br>
           						<a href="tel:119">119</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:119"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
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
						<div class="title-text">교통사고처리(현장) 안내</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				교통사고처리 방법
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					삼각대설치
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				사고 차량으로부터 주간(100M), 야간(200M)<br>후방에 설치합니다.
       							<br>
       							(삼각대는 트렁크에 비치되어 있습니다.)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					대피
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				신속하게 가드레일 밖으로 대피합니다.
       							<br>
       							(고속도로/자동차 전용도로)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					부상자 확인
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				부상자가 있을 경우 신속히 신고합니다.(119)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					증거확보
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				사고 현장 사진 촬영 및 블랙박스 영상 확보,
	            				<br>
	            				목격자를 확인합니다.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					사고접수
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				보험사에 사고 접수 및 사고 접수번호를 받습니다.
       							<br>
       							(보험사 및 접수번호)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					경찰청 사고접수
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				필요한 경우 (12대 중과실 등에 해당하는 경우)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					연락처 교환
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				상대방과 명함 등 연락처를 교환합니다.
            				</div>
            			</div>            			
	            	</div>
	            	
				</div>				

				<div class="item">
					<div class="title-back-img-1">
						<div class="title-text">자차손해 사고처리 안내</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				자차손해 사고처리 방법
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					사고사실 통보
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				<%if (!user_bean.getUser_nm().equals("")) {%>
	            				고객님 담당자
	            				<br>
	            				이름 : <%=user_bean.getUser_nm()%>, 전화번호 : <a href="tel:<%=user_bean.getUser_m_tel()%>"><%=user_bean.getUser_m_tel()%></a> 에게
	            				<br>
	            				통보합니다.
	            				<%} else {%>
	            				고객님 담당자 에게 통보합니다.
	            				<%}%>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					사고처리 절차협의
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				자차사고 처리 협의, 기타 문의 및 협조 요청하시면
       							성실하고 최선을 다해 협조해 드립니다.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					대차서비스
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				자차 수리 기간에 동급의 자동차로 대차 해 드립니다. 고객님 담당자에 요청하시길 바랍니다.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					자차수리
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				당사의 모든 자동차 자기차량 손해담보는 보험회사가 아닌 당사가 보험 기능을 수행합니다. 아울러 사고 수리와 관련된 업무는 고객님 담당자가 전담하여 처리합니다.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					주의사항
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color" style="color: red;">
	            				고객님께서 임의로 정비업체에 맡겨 수리하거나 요청한 경우, 수리비에 대한 보상이 이루어지지 않으므로, 사전에 담당자와 협의하여 처리해주시길 바랍니다.
            				</div>
            			</div>        			
	            	</div>
	            	
				</div>
				

				<div class="item">
					<div class="title-back-img-1">
						<div class="title-text">사고처리(경찰청) 순서 안내</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				사고처리 안내
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					사고접수
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				접수 사실을 SMS 문자로
	            				<br>
	            				가해자 · 피해자에게 통지합니다.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					현장조사
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				본인, 변호인(보호자), 목격자 등
	            				<br>
	            				입회 및 유리한 증거를 제출합니다.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					진술청취
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				피해자, 참고인(목격자) 등이 사고 당시 보고 느낀 대로
       							<span style="font-weight: bold;">진술서</span>를 작성하고 피해자는 진단서, 견적서를 체출합니다.
       							<br>
       							※ 미제출 시 피해가 없는 사고로 종결될 수 있습니다.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					가해자 조사
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				사망, 중상해, 뺑소니 등은 교통사고처리특례법(제3조 2항)
	            				에서 정한 12대 중과실에 해당하고,
       							보험 미가입(미합의) 사고의 경우 형사입건
       							(불구속 수사가 원칙이나, 인명피해가 크거나 뺑소니 사고로
       							도주 · 증거인멸 우려가 있는 경우 구속될 수 있음)
       							<br>
       							단, 원인 행위는 범칙금 및 벌점 부과됩니다.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					사건송치
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				사건송치 : 조사 완료 후 조사 결과를
      							<br>
      							검창청에 송치한 후, 3일 이내에 조사 결과를
      							<br>
      							서면 통보하고 있습니다.
            				</div>
            			</div>        	
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left sub-text">
            				※ 더 궁금하신 사항은 경찰청 콜센터 <a href="tel:182">182</a>로 문의바랍니다.
            			</div>		
	            	</div>
	            	
				</div>
				
				
				
				<div class="item">
					<div class="title-back-img-1">
						<div class="title-text">12대 중과실(교통사고처리특례법)</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				12대 중과실 안내
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				1. 도로교통법 제5조에 따른 신호기가 표시하는 신호 또는 교통정리를 하는 경찰공무원등의 신호를 위반하거나 통행금지 또는 일시정지를 내용으로 하는 안전표지가 표시하는 지시를 위반하여 운전한 경우
								<br><br>
								2. 도로교통법 제13조제3항을 위반하여 중앙선을 침범하거나 같은 법 제62조를 위반하여 횡단, 유턴 또는 후진한 경우
								<br><br>
								3. 도로교통법 제17조제1항 또는 제2항에 따른 제한속도를 시속 20킬로미터 초과하여 운전한 경우
								<br><br>
								4. 도로교통법 제21조제1항, 제22조, 제23조에 따른 앞지르기의 방법·금지시기·금지장소 또는 끼어들기의 금지를 위반하거나 같은 법 제60조제2항에 따른 고속도로에서의 앞지르기 방법을 위반하여 운전한 경우
								<br><br>
								5. 도로교통법 제24조에 따른 철길건널목 통과방법을 위반하여 운전한 경우
								<br><br>
								6. 도로교통법 제27조제1항에 따른 횡단보도에서의 보행자 보호의무를 위반하여 운전한 경우
								<br><br>
								7. 도로교통법 제43조, 「건설기계관리법」 제26조 또는 도로교통법 제96조를 위반하여 운전면허 또는 건설기계조종사면허를 받지 아니하거나 국제운전면허증을 소지하지 아니하고 운전한 경우. 이 경우 운전면허 또는 건설기계조종사면허의 효력이 정지 중이거나 운전의 금지 중인 때에는 운전면허 또는 건설기계조종사면허를 받지 아니하거나 국제운전면허증을 소지하지 아니한 것으로 본다.
								<br><br>
								8. 도로교통법 제44조제1항을 위반하여 술에 취한 상태에서 운전을 하거나 같은 법 제45조를 위반하여 약물의 영향으로 정상적으로 운전하지 못할 우려가 있는 상태에서 운전한 경우
								<br><br>
								9. 도로교통법 제13조제1항을 위반하여 보도(步道)가 설치된 도로의 보도를 침범하거나 같은 법 제13조제2항에 따른 보도 횡단방법을 위반하여 운전한 경우
								<br><br>
								10. 도로교통법 제39조제3항에 따른 승객의 추락 방지의무를 위반하여 운전한 경우
								<br><br>
								11. 도로교통법 제12조제3항에 따른 어린이 보호구역에서 같은 조 제1항에 따른 조치를 준수하고 어린이의 안전에 유의하면서 운전하여야 할 의무를 위반하여 어린이의 신체를 상해(傷害)에 이르게 한 경우
								<br><br>
								12. 도로교통법 제39조제4항을 위반하여 자동차의 화물이 떨어지지 아니하도록 필요한 조치를 하지 아니하고 운전한 경우
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
