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
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if (user_id.equals("")) {
		user_bean = umd.getUsersBean(base.getBus_id2());
	} else {
		user_bean = umd.getUsersBean(user_id);
	}
	
	//��������
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
<title>����⵿���� �ȳ�</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<style>
body { 
	-webkit-text-size-adjust : auto; /* ������ �Ȱ��� �۵��ϵ��� �Ѵ� */
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
			
				<!-- ���ó�� ����ó �ȳ� -->
				<div class="item active">
					<div class="title-back-img-1">
						<div class="title-text">����⵿���� �̿�ȳ�</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">           			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				����⵿�������� ��ü ��Ȳ
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					����Ÿ�ڵ�������
           						<br>
           						<a href="tel:1588-6688">1588-6688</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:1588-6688"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border no-top-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					SK��Ʈ����
           						<br>
           						<a href="tel:1670-5494">1670-5494</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:1670-5494"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<%if (!user_bean.getBr_nm().equals("")) {%>
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid-second">
            				�Ƹ���ī �����
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					<%=user_bean.getBr_nm()%> <%=user_bean.getUser_nm()%>
           						<br>
           						(����) <a href="tel:<%=user_bean.getHot_tel()%>"><%=user_bean.getHot_tel()%></a>
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
						<div class="title-text">����⵿���� �̿�ȳ�</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				����⵿���� �󼼳���
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					<!-- ��ް��μ��� -->
            					���μ���
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- ��������� ��� �Ǵ� �������� ���Ͽ� �ڷ¿����� �Ұ����� ��쿡 10km ������ "��"�� �����ϴ� ������ �����ϴ� ���񽺸� ���Ѵ�. ��, 10km �ʰ��ϴ� ��쿡�� "��"�� 1KM�� 2,000���� �߰�������δ��Ѵ�. -->
	            				�ڵ����� ����, ��� ������ �ڷ¿����� �Ұ����ϰ� �� ��, ������ ������ ������ �����ϴ� �����Դϴ�. ��, ���� �Ÿ��� 10km�� �ʰ��ϰ� �Ǹ� �߰������ �߻��� �� �ֽ��ϴ�. �߰������ ���Բ��� �δ��ϼž� �մϴ�. (2020�� ����, 1km�� 2,000��)
            				</div>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					<!-- ���������� -->
            					��������
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- ��������� ���� �������� ���Ͽ� ������ �Ұ����� ��쿡 ����(�ֹ���/ ���� 3���� �̳�, LPG���� �� �����ڵ����� ��ް��μ��� ����)�� �����ϴ� ���񽺸� ���Ѵ�. -->
	            				���ᰡ �����ؼ� ���� ������ �Ұ����ϰ� �� ���, ����ϰ� ���Ḧ �����ϴ� �����Դϴ�. (�ֹ���/������ 3 ���� �̳�, LPG �� �����ڵ����� ���μ���)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					���͸���������
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- ��������� ���͸� �������� ���Ͽ� ������ �Ұ����� ��쿡 ���͸��� �����ϴ� ���񽺸� ���Ѵ�. ��, ���͸������� 12V ��� ������ ���ϸ�, ���͸� ��ȯ �ÿ��� ���Ƹ���ī�� �Ǵ� "��"�� �Ǻ� �δ��Ѵ�. -->
	            				���͸��� ������ ���� ������ �Ұ����ϰ� �� �ڵ��� ���͸��� �����ϴ� �����Դϴ�. ��, 12V ���͸��� ����ϴ� �ڵ����� �������񽺰� �����ϸ�, ���͸��� ��ȯ�� ��� �Ǻ�� ���Բ��� �δ��ϼž� �մϴ�. ��, ����ǰ�� ���󼭴� ����硱 �� �δ��մϴ�.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					Ÿ�̾��
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- ��.	Ÿ�̾ü���񽺴�������� Ÿ�̾� ��ũ�� ������ �Ұ����� ��쿡 ��������� ����Ÿ�̾ �ִ� ��쿡 ���Ͽ� ���� �� Ÿ�̾ ����Ÿ�̾�� ��ü�ϴ� ���񽺸� ���Ѵ�.<br>
								��.	Ÿ�̾�������񽺴�������� ���鿡 ���� Ÿ�̾� Ʈ���� �κ��� ��ũ�� ���Ͽ� ������ �Ұ����� ��� ��ũ�� �����ϴ� ���񽺸� ���ϸ�, Ÿ�̾���� �� ��ũ 1���� 10,000���� ��������� "��"�� �δ��Ѵ�.�ٸ�, �Ʒ� �� ���� ���� Ÿ�̾���������� ������ ������ ���� ��쿡�� ����⵿ ���� �׸� �� ��ް��μ��񽺸� ������ �� �ִ�.
								<br><br>
								1.	Ÿ�̾ ������ ���<br>
								2.	Ÿ�̾���ũ�� ũ��, ��� �� ��ġ�� ���� Ÿ�̾�������񽺰� �Ұ����� ���<br>
								3.	�߰� �� ��, �� �� ����Ȳ ���� ��������� ���� �������񽺰� ����� ���<br> -->
								1. Ÿ�̾� ��ü���� : Ÿ�̾ ����(��ũ)�� ���� ���� ������ �Ұ����ϰ� �� ���, ����Ÿ�̾�� ��ü�ϴ� �����Դϴ�.<br>
								2. ���� ���� : ����Ÿ�̾ ���ų� Ÿ�̾� Ʈ����(tread) ����(���鿡 �´�� �κ�)�� ������ ���� �� ���忡�� �����ϴ� ����(��, ���� ���� 1���� 10,000��(2020�� ����)�� ���Բ��� �δ��ϼž� �մϴ�.)<br>
								3. ���μ��� : Ÿ�̾ �������ų�, ������ �Ұ��ϰԲ� Ÿ�̾ ������ ���ų�, ��� ��Ȳ �� ���� �������� ���� ���񽺰� ��ư� �� ��쿡�� ���μ��񽺷� ��ü.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					�����ġ��������
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- ��������� ���踦 ������ �ΰų� �н� ������ ������ �� �� ���� ��쿡 ��� ��ġ�� �����ϴ� ���񽺸� ���Ѵ�.��, Ʈ��ũ ��� ��ġ ���� �� ���������̳� �Ϲ��� ������� ������ ���� �ʴ� Ư�� ��� ��ġ ������ �����Ѵ�. -->
	            				�ڵ��� ���� �� �� ���� �� ��쿡 �⵿�� �����ġ�� �����ϴ� �����Դϴ�. ��, �Ϲ����� ������δ� ������ �Ұ��� Ư�������ġ(����ƮŰ, �̸��������), ���̵忡����� �����Ǿ� �ִ� �ڵ����� ���񽺸� �������� �ʽ��ϴ�. �ƿ﷯ �Ϻ� �ܻ� �ڵ��� ���� ���� ��� �ڵ����� �ƴ� ���� �ֽ��ϴ�. �̶��� ���� ��ü�� �Ұ�(Ʈ��ũ�����ġ��������)�� ���� �ֽ��ϴ�.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					��ޱ�������
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- ��������� ���θ� ��Ż�ϰų� ��ֹ��� ���Ͽ� ������ �Ұ����Ͽ� ������ �ʿ��� ��쿡 ��� �����ϴ� ���񽺸� ���Ѵ�.(��,������ ������� ���� ���������� ���� ������ ���� �ڵ����� ������ ������ ��쿡 ���ϸ�,[Ư���� ����]�� �� ��쿡�� ������ ��������� ������ û���Ѵ�.���� ������ ���繰�� ���Ͽ� ������ ������ ������ ���� ��쿡�� �� ���񽺸� �������� �ʴ´�.)
	            				<br><br>
	            				�� Ư���� ����<br>
								1. 2.5t�� �ʰ��ϴ� ������ Ư�� �ڵ����� ������ ���<br>
								2. 2�� �̻��� ������ Ư�� �ڵ����� ������ ���<br>
								3. �����۾��� �����Ͽ� ���ΰ� ������ ������ �ҿ�ð��� 30���� �ʰ��ϴ� ���<br>
								4. �������� �Ǵ� 2,500cc �̻��� ���������� �����ϴ� ���<br>
								5. ��Ÿ ������ �������(������Ƽ�δ� ��)�� ����Ͽ� �����ϴ� ��� -->
								�ڵ����� ���θ� ��Ż�߰ų� ��ֹ� ������ ������ �Ұ��� ������ �ʿ��� ��쿡 �����ϴ� �����Դϴ�. ��, �Ʒ��� ���� Ư���� ������ �ʿ��� ���, �߰������ �߻��� �� ������ �� ����� ���Բ��� �δ��ϼž� �մϴ�.
								<br><br>
								�� Ư���� ����<br>
								1. 2.5t�� �ʰ��ϴ� Ư���ڵ����� ������ ���<br>
								2. 2�� �̻��� Ư���ڵ����� �Բ� ������ ���<br>
								3. �����۾��� �����ϰ� ���ο� ���� ������ �������� �ҿ�ð��� 30���� �ʰ��Ͽ� �۾��� ���<br>
								4. ���� �ڵ��� �Ǵ� 2,500cc �̻��� ������ ������ ������ ���<br>
								5. ������Ƽ�δ�(���� ���� �ƴ� ���� ���۵� �����Կ� �ư� �̵��ϴ� ������ �ڵ���) ���� ���� ������ ��� ����ϰ� �� ���
            				</div>
            			</div>
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0 margin-top-5">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky detail-link">
            					��Ÿ�⵿����
            					<span class="glyphicon glyphicon-chevron-down glyp-color down" aria-hidden="true" style="float: right; padding-right: 10px;"></span>
            					<span class="glyphicon glyphicon-chevron-up glyp-color up" aria-hidden="true" style="display: none; float: right; padding-right: 10px;"></span>
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color detail">
	            				<!-- ������~������ ���� �� ������ ���� �Ǵ� �̻����� �������� ������ ����� ��� ������ �������� ������ �����ϵ��� ��ġ�ϴ� ���񽺸� ���Ѵ�. -->
	            				�ڵ����� ���� �Ǵ� �̻� �������� ���� �������� ������ ����� ���, ������ ������ �����ϵ��� ��ġ�ϰ� ������ �ִ� �����Դϴ�.
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
