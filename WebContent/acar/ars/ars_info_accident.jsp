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
<title>���ó������ �ȳ�</title>
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
			
				<!-- ���ó�� ����ó �ȳ� -->
				<div class="item active">
					<div class="title-back-img-1">
						<div class="title-text">���ó�� ����ó �ȳ�</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">           			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				����ȸ�� ����ó
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					����ī��������
           						<br>
           						<a href="tel:1661-7977">1661-7977</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:1661-7977"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border no-top-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					�Ｚȭ��(����ȭ��)
           						<br>
           						<a href="tel:1588-5114">1588-5114</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:1588-5114"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<%if(!base.getCar_st().equals("")){%>
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left sub-text" style="font-size: 14px;">            				
            				�� ���� �ڵ����� <span style="font-weight: bold; color: red;"><%if(base.getCar_st().equals("1")){%>��Ʈ<%}else if(base.getCar_st().equals("2")){%>����<%}else if(base.getCar_st().equals("3")){%>����<%}else if(base.getCar_st().equals("4")){%>����Ʈ<%}else if(base.getCar_st().equals("5")){%>�����뿩<%}%> ����</span> �Դϴ�.
            				<br>
            				<span style="font-weight: bold; color: red;"><%=ins_com_nm%></span>�� ���� ���ԵǾ� �ֽ��ϴ�.
            			</div>
            			<%}%>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid-second">
            				����⵿ ����
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
            					SK ��Ʈ����
           						<br>
           						<a href="tel:1670-5494">1670-5494</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:1670-5494"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left sub-text">
            				�� ����⵿ ���񽺴� ����ī�� ������ǰ�� �������� �ʽ��ϴ�.
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid-second">
            				��Ÿ ����ó
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					����û
           						<br>
           						<a href="tel:112">112</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:112"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border no-top-border">
            				<div class="col-sm-8 col-xs-8 col-md-8 col-lg-8 content-padding-left">
            					119(�����Ű���)
           						<br>
           						<a href="tel:119">119</a>
            				</div>
            				<div class="col-sm-4 col-xs-4 col-md-4 col-lg-4 content-padding-right text-right">
	            				<a href="tel:119"><span class="glyphicon glyphicon-earphone glyp-color" aria-hidden="true"></span></a>
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
						<div class="title-text">������ó��(����) �ȳ�</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				������ó�� ���
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					�ﰢ�뼳ġ
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				��� �������κ��� �ְ�(100M), �߰�(200M)<br>�Ĺ濡 ��ġ�մϴ�.
       							<br>
       							(�ﰢ��� Ʈ��ũ�� ��ġ�Ǿ� �ֽ��ϴ�.)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					����
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				�ż��ϰ� ���巹�� ������ �����մϴ�.
       							<br>
       							(��ӵ���/�ڵ��� ���뵵��)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					�λ��� Ȯ��
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				�λ��ڰ� ���� ��� �ż��� �Ű��մϴ�.(119)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					����Ȯ��
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				��� ���� ���� �Կ� �� ���ڽ� ���� Ȯ��,
	            				<br>
	            				����ڸ� Ȯ���մϴ�.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					�������
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				����翡 ��� ���� �� ��� ������ȣ�� �޽��ϴ�.
       							<br>
       							(����� �� ������ȣ)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					����û �������
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				�ʿ��� ��� (12�� �߰��� � �ش��ϴ� ���)
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					����ó ��ȯ
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				����� ���� �� ����ó�� ��ȯ�մϴ�.
            				</div>
            			</div>            			
	            	</div>
	            	
				</div>				

				<div class="item">
					<div class="title-back-img-1">
						<div class="title-text">�������� ���ó�� �ȳ�</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				�������� ���ó�� ���
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					����� �뺸
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				<%if (!user_bean.getUser_nm().equals("")) {%>
	            				���� �����
	            				<br>
	            				�̸� : <%=user_bean.getUser_nm()%>, ��ȭ��ȣ : <a href="tel:<%=user_bean.getUser_m_tel()%>"><%=user_bean.getUser_m_tel()%></a> ����
	            				<br>
	            				�뺸�մϴ�.
	            				<%} else {%>
	            				���� ����� ���� �뺸�մϴ�.
	            				<%}%>
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					���ó�� ��������
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				������� ó�� ����, ��Ÿ ���� �� ���� ��û�Ͻø�
       							�����ϰ� �ּ��� ���� ������ �帳�ϴ�.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					��������
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				���� ���� �Ⱓ�� ������ �ڵ����� ���� �� �帳�ϴ�. ���� ����ڿ� ��û�Ͻñ� �ٶ��ϴ�.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					��������
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				����� ��� �ڵ��� �ڱ����� ���ش㺸�� ����ȸ�簡 �ƴ� ��簡 ���� ����� �����մϴ�. �ƿ﷯ ��� ������ ���õ� ������ ���� ����ڰ� �����Ͽ� ó���մϴ�.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					���ǻ���
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color" style="color: red;">
	            				���Բ��� ���Ƿ� �����ü�� �ð� �����ϰų� ��û�� ���, ������ ���� ������ �̷������ �����Ƿ�, ������ ����ڿ� �����Ͽ� ó�����ֽñ� �ٶ��ϴ�.
            				</div>
            			</div>        			
	            	</div>
	            	
				</div>
				

				<div class="item">
					<div class="title-back-img-1">
						<div class="title-text">���ó��(����û) ���� �ȳ�</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				���ó�� �ȳ�
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					�������
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				���� ����� SMS ���ڷ�
	            				<br>
	            				������ �� �����ڿ��� �����մϴ�.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					��������
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				����, ��ȣ��(��ȣ��), ����� ��
	            				<br>
	            				��ȸ �� ������ ���Ÿ� �����մϴ�.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					����û��
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				������, ������(�����) ���� ��� ��� ���� ���� ���
       							<span style="font-weight: bold;">������</span>�� �ۼ��ϰ� �����ڴ� ���ܼ�, �������� ü���մϴ�.
       							<br>
       							�� ������ �� ���ذ� ���� ���� ����� �� �ֽ��ϴ�.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					������ ����
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				���, �߻���, ���Ҵ� ���� ������ó��Ư�ʹ�(��3�� 2��)
	            				���� ���� 12�� �߰��ǿ� �ش��ϰ�,
       							���� �̰���(������) ����� ��� �����԰�
       							(�ұ��� ���簡 ��Ģ�̳�, �θ����ذ� ũ�ų� ���Ҵ� ����
       							���� �� �����θ� ����� �ִ� ��� ���ӵ� �� ����)
       							<br>
       							��, ���� ������ ��Ģ�� �� ���� �ΰ��˴ϴ�.
            				</div>
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center padding_b_3">
            				<span class="glyphicon glyphicon-chevron-down glyp-color-yellow" aria-hidden="true"></span>
            			</div>            			
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-padding bg-color-sky">
            					��Ǽ�ġ
            				</div>
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				��Ǽ�ġ : ���� �Ϸ� �� ���� �����
      							<br>
      							��âû�� ��ġ�� ��, 3�� �̳��� ���� �����
      							<br>
      							���� �뺸�ϰ� �ֽ��ϴ�.
            				</div>
            			</div>        	
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left sub-text">
            				�� �� �ñ��Ͻ� ������ ����û �ݼ��� <a href="tel:182">182</a>�� ���ǹٶ��ϴ�.
            			</div>		
	            	</div>
	            	
				</div>
				
				
				
				<div class="item">
					<div class="title-back-img-1">
						<div class="title-text">12�� �߰���(������ó��Ư�ʹ�)</div>
	            	</div>
	            	
	            	<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 main-content-div">
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-left title-mid">
            				12�� �߰��� �ȳ�
            			</div>
            			
            			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 com-border padding_LR_0">
            				<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 content2-sub-padding glyp-color">
	            				1. ���α���� ��5���� ���� ��ȣ�Ⱑ ǥ���ϴ� ��ȣ �Ǵ� ���������� �ϴ� �������������� ��ȣ�� �����ϰų� ������� �Ǵ� �Ͻ������� �������� �ϴ� ����ǥ���� ǥ���ϴ� ���ø� �����Ͽ� ������ ���
								<br><br>
								2. ���α���� ��13����3���� �����Ͽ� �߾Ӽ��� ħ���ϰų� ���� �� ��62���� �����Ͽ� Ⱦ��, ���� �Ǵ� ������ ���
								<br><br>
								3. ���α���� ��17����1�� �Ǵ� ��2�׿� ���� ���Ѽӵ��� �ü� 20ų�ι��� �ʰ��Ͽ� ������ ���
								<br><br>
								4. ���α���� ��21����1��, ��22��, ��23���� ���� ���������� ����������ñ⡤������� �Ǵ� �������� ������ �����ϰų� ���� �� ��60����2�׿� ���� ��ӵ��ο����� �������� ����� �����Ͽ� ������ ���
								<br><br>
								5. ���α���� ��24���� ���� ö��ǳθ� �������� �����Ͽ� ������ ���
								<br><br>
								6. ���α���� ��27����1�׿� ���� Ⱦ�ܺ��������� ������ ��ȣ�ǹ��� �����Ͽ� ������ ���
								<br><br>
								7. ���α���� ��43��, ���Ǽ����������� ��26�� �Ǵ� ���α���� ��96���� �����Ͽ� �������� �Ǵ� �Ǽ������������㸦 ���� �ƴ��ϰų� ���������������� �������� �ƴ��ϰ� ������ ���. �� ��� �������� �Ǵ� �Ǽ��������������� ȿ���� ���� ���̰ų� ������ ���� ���� ������ �������� �Ǵ� �Ǽ������������㸦 ���� �ƴ��ϰų� ���������������� �������� �ƴ��� ������ ����.
								<br><br>
								8. ���α���� ��44����1���� �����Ͽ� ���� ���� ���¿��� ������ �ϰų� ���� �� ��45���� �����Ͽ� �๰�� �������� ���������� �������� ���� ����� �ִ� ���¿��� ������ ���
								<br><br>
								9. ���α���� ��13����1���� �����Ͽ� ����(��Գ)�� ��ġ�� ������ ������ ħ���ϰų� ���� �� ��13����2�׿� ���� ���� Ⱦ�ܹ���� �����Ͽ� ������ ���
								<br><br>
								10. ���α���� ��39����3�׿� ���� �°��� �߶� �����ǹ��� �����Ͽ� ������ ���
								<br><br>
								11. ���α���� ��12����3�׿� ���� ��� ��ȣ�������� ���� �� ��1�׿� ���� ��ġ�� �ؼ��ϰ� ����� ������ �����ϸ鼭 �����Ͽ��� �� �ǹ��� �����Ͽ� ����� ��ü�� ����(߿��)�� �̸��� �� ���
								<br><br>
								12. ���α���� ��39����4���� �����Ͽ� �ڵ����� ȭ���� �������� �ƴ��ϵ��� �ʿ��� ��ġ�� ���� �ƴ��ϰ� ������ ���
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
