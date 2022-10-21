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
<title>자동차정비 안내</title>
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
.content-padding-left2 {
	padding: 10px 0px 10px 5px;
	height: 80px;
}
.content-padding-right2 {
	padding: 30px 5px 10px 0px; 
	height: 80px;
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
						<div class="title-text">자동차정비 안내</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">           			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				수도권
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-10 col-xs-10 col-md-10 col-lg-10 content-padding-left2">
            					㈜오토크린
           						<br>
           						서울시 구로구 구일로 170
           						<br>
           						<a href="tel:02-3663-2131">02-3663-2131</a>
            				</div>
            				<div class="col-sm-2 col-xs-2 col-md-2 col-lg-2 content-padding-right2 text-right">
	            				<a href="tel:02-3663-2131"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border no-top-border">
            				<div class="col-sm-10 col-xs-10 col-md-10 col-lg-10 content-padding-left2">
            					아마존모터스
            					<br>
            					서울시 강서구 남부순환로 224-40
           						<br>
           						<a href="tel:02-2661-8283">02-2661-8283</a>
            				</div>
            				<div class="col-sm-2 col-xs-2 col-md-2 col-lg-2 content-padding-right2 text-right">
	            				<a href="tel:02-2661-8283"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border no-top-border">
            				<div class="col-sm-10 col-xs-10 col-md-10 col-lg-10 content-padding-left2">
            					㈜신엠제이모터스
            					<br>
            					서울시 영등포구 선유로 112
           						<br>
           						<a href="tel:02-2636-2686">02-2636-2686</a>
            				</div>
            				<div class="col-sm-2 col-xs-2 col-md-2 col-lg-2 content-padding-right2 text-right">
	            				<a href="tel:02-2636-2686"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid-second">
            				대전
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-10 col-xs-10 col-md-10 col-lg-10 content-padding-left2">
            					현대카독크
           						<br>
           						대전시 대덕구 벚꽃길 100
           						<br>
           						<a href="tel:042-932-0607">042-932-0607</a>
            				</div>
            				<div class="col-sm-2 col-xs-2 col-md-2 col-lg-2 content-padding-right2 text-right">
	            				<a href="tel:042-932-0607"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid-second">
            				대구
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-10 col-xs-10 col-md-10 col-lg-10 content-padding-left2">
            					성서현대정비센터
           						<br>
           						대구시 달서구 달서대로109길 58
           						<br>
           						<a href="tel:053-593-3211">053-593-3211</a>
            				</div>
            				<div class="col-sm-2 col-xs-2 col-md-2 col-lg-2 content-padding-right2 text-right">
	            				<a href="tel:053-593-3211"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid-second">
            				부산
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-10 col-xs-10 col-md-10 col-lg-10 content-padding-left2">
            					부경자동차정비
           						<br>
           						부산시 연제구 거제천로 270번길 5
           						<br>
           						<a href="tel:051-868-7668">051-868-7668</a>
            				</div>
            				<div class="col-sm-2 col-xs-2 col-md-2 col-lg-2 content-padding-right2 text-right">
	            				<a href="tel:051-868-7668"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border no-top-border">
            				<div class="col-sm-10 col-xs-10 col-md-10 col-lg-10 content-padding-left2">
            					삼일정비
           						<br>
           						부산시 금정구 금사동 108-12번지
           						<br>
           						<a href="tel:051-521-3157">051-521-3157</a>
            				</div>
            				<div class="col-sm-2 col-xs-2 col-md-2 col-lg-2 content-padding-right2 text-right">
	            				<a href="tel:051-521-3157"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid-second">
            				광주
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-10 col-xs-10 col-md-10 col-lg-10 content-padding-left2">
            					상무1급자동차공업사
           						<br>
           						광주시 서구 상무누리로 131-1
           						<br>
           						<a href="tel:062-371-3444">062-371-3444</a>
            				</div>
            				<div class="col-sm-2 col-xs-2 col-md-2 col-lg-2 content-padding-right2 text-right">
	            				<a href="tel:062-371-3444"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
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
						<div class="title-text">자동차정비 안내</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				사고 및 고장관련 정비안내
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					사고 관련 자차정비
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				자동차 사고에 따른 자차 파손 부위는
	            				<br>
								당사가 지정한 정비업체에서 전담하여 수리합니다.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					고장(경정비) 수리
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				정비포함 장기대여상품 및 월렌트상품은 소모품 교환 및 경정비 서비스를 무상 제공합니다. 
	            				<br>
	            				단, 아래 지정정비업체가 정비를 전담하고 있습니다.
								<br>
								만일 고객님이 임의로 선택한 정비업체를 이용하신 경우
								정비비는 고객님이 부담하게 될 수 있습니다.
								<br>
								지정정비업체 이용이 불편하실 경우
								고객님 자동차 관리담당자와 협의하여 주십시오.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid-second">
            				지정정비 업체명
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					스피드메이트(SK네트웍스)
           						<br>
           						<a href="tel:1600-1600">1600-1600</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:1600-1600"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
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
