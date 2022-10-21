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
	
	user_bean = umd.getUsersBean(user_id);
	
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
<title>ARS 통합 서비스 안내문</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<!-- <meta name="viewport" content="width=device-width, initial-scale=1"> -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<style>
/* body { -webkit-text-size-adjust : none; } /* 폰트의 사이즈를 늘어나지 않도록 한다 */ */
/* body { -webkit-text-size-adjust : 120%; } /* 폰트를 기존 사이즈와 동일하게 한다 */ */
body { 
	-webkit-text-size-adjust : auto; /* 기존과 똑같이 작동하도록 한다 */
	background-color: #FFFFFF !important; 
}
.container {
    padding-right: 30px !important;
    padding-left: 30px !important;
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
    background-color: #0d6eff;
    color: #FFF;
}
</style>
</head>
<body>
	<div class="container">
		<div class="text-center" style="padding: 10px;">
			<img src="https://www.amazoncar.co.kr/home/mobile/images/logo_1.png" style="width: 140px; height: 25px;">
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
					<div style="position: relative;">
						<img src="https://www.amazoncar.co.kr/home/mobile/images/title_1.png" style="width: 100%; height: 100%; min-height: 130px; max-height: 130px;">
	            	</div>
	            	<div style="position: relative; top: -80px;">
						<div style="color: #FFF; font-size: 20px; font-weight: bold; text-align: center;">사고처리 연락처 안내</div>
	            	</div>
	            	
	            	<div style="margin: 0px 0px 0px 0px;">
	            		<div>
	            			<div class="text-center" style="border: 1px solid #50af31; padding: 10px; font-size:20px; font-weight: bold; color: #50af31; margin-bottom: 20px;">
	            				자동차 보험회사
	            			</div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 20%;">
									<col style="width: 40%;">
									<col style="width: 40%;">
								</colgroup>
	            				<tr>
	            					<th class="active text-center text-center">구분</th>
	            					<th class="active text-center text-center">보험회사</th>
	            					<th class="active text-center text-center">연락처</th>
	            				</tr>
	            				<tr>	            					
	            					<td class="mid text-center">렌터카</td>
	            					<td class="mid text-center">렌터카공제조합</td>
	            					<td class="mid text-center">1661-7977</td>
	            				</tr>
	            				<tr>	            					
	            					<td class="mid text-center">리스</td>
	            					<td class="mid text-center">삼성화재</td>
	            					<td class="mid text-center">1588-5114 (1588-0100)</td>
	            				</tr>
	            			</table>
	            			<div class="text-left">
	            				※ 차량번호에 "허", "하", "호" 문자가 있다면 렌터카입니다.
	            				<br>
	            				※ 그 외의 경우는 리스 차량이며, 이 자동차는 <span style="font-weight: bold; color: red;"><%=ins_com_nm%></span>에 보험 가입되어 있습니다.
	            			</div>
	            		</div>
	            		
	            		<div>
	            			<div class="text-center" style="border: 1px solid #50af31; padding: 10px; font-size:20px; font-weight: bold; color: #FFFFFF; margin: 20px 0px; background-color: #50af31;">
	            				긴급출동 서비스
	            			</div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: 50%;">
								</colgroup>
	            				<tr>
	            					<th class="active text-center text-center">상호</th>
	            					<th class="active text-center text-center">연락처</th>
	            					<th class="active text-center text-center">비고</th>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">마스타자동차관리</td>
	            					<td class="mid text-center">1588-6688</td>
	            					<td class="mid text-center" rowspan="3">
	            						긴급출동 서비스는 렌터카와 리스를
	            						<br>
	            						구분하지 않습니다.
	            					</td>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">SK 네트웍스</td>
	            					<td class="mid text-center">1670-5494</td>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">렌터카공제조합</td>
	            					<td class="mid text-center">1661-7977</td>
	            				</tr>
	            			</table>
	            		</div>
	            		
	            		<div style="height: 280px;">
	            			<div class="text-center" style="border: 1px solid #50af31; padding: 10px; font-size:20px; font-weight: bold; color: #50af31; margin-bottom: 20px;">
	            				기타 연락처
	            			</div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: 50%;">
								</colgroup>
	            				<tr>
	            					<th class="active text-center text-center">구분</th>
	            					<th class="active text-center text-center">연락처</th>
	            					<th class="active text-center text-center">비고</th>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">경찰청</td>
	            					<td class="mid text-center">112</td>
	            					<td class="mid text-center"></td>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">119안전신고센터</td>
	            					<td class="mid text-center">119</td>
	            					<td class="mid text-center"></td>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">아마존카</td>
	            					<td class="mid text-center">02-392-4242</td>
	            					<td class="mid text-center"><%=user_bean.getUser_m_tel()%>(<%=user_bean.getUser_nm()%>)</td>
	            				</tr>
	            			</table>
	            		</div>
	            	</div>
				</div>

				<div class="item">
					<div style="position: relative;">
						<img src="https://www.amazoncar.co.kr/home/mobile/images/title_1.png" style="width: 100%; height: 100%; min-height: 130px; max-height: 130px;">
	            	</div>
	            	<div style="position: relative; top: -85px;">
						<div style="color: #FFF; font-size: 20px; font-weight: bold; text-align: center;">교통사고처리(현장) 안내</div>
	            	</div>
	            	
	            	<div style="margin: 0px 0px 0px 0px;">
	            		<div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 25%; vertical-align: middle;">
									<col style="width: 75%;">
								</colgroup>
	            				<tr>
	            					<th class="active active-th text-center text-center">삼각대설치</th>
	            					<td class="mid">	            						
	            						<div style="padding: 20px 0px 20px 20px;">
	            							사고 차량으로부터 주간(100M), 야간(200M) 후방에 설치합니다.
	            							<br>
	            							(삼각대는 트렁크에 비치되어 있습니다.)
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">대피</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							신속하게 가드레일 밖으로 대피합니다.
	            							<br>
	            							(고속도로/자동차 전용도로)
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">부상자 확인</th>
	            					<td class="mid">	            						
	            						<div style="padding: 20px 0px 20px 20px;">
	            							부상자가 있을 경우 신속히 신고합니다.(119)
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">증거확보</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							사고 현장 사진 촬영 및 블랙박스 영상 확보, 목격자 확인합니다.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">사고접수</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							보험사에 사고 접수 및 사고 접수번호를 받습니다.
	            							<br>
	            							(보험사 및 접수번호)	
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">경찰청 사고접수</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							필요한 경우 (12대 중과실 등에 해당하는 경우)
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">연락처 교환</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							상대방과 명함 등 연락처를 교환합니다.
	            						</div>
	            					</td>
	            				</tr>
	            			</table>
	            		</div>
	            	</div>
				</div>

				<div class="item">
					<div style="position: relative;">
						<img src="https://www.amazoncar.co.kr/home/mobile/images/title_4.png" style="width: 100%; height: 100%; min-height: 130px; max-height: 130px;">
	            	</div>
	            	<div style="position: relative; top: -80px;">
						<div style="color: #FFF; font-size: 20px; font-weight: bold; text-align: center;">자차손해 사고처리 안내</div>
	            	</div>
	            	
	            	<div style="margin: 0px 0px 0px 0px;">
	            		<div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 25%; vertical-align: middle;">
									<col style="width: 75%;">
								</colgroup>
	            				<tr>
	            					<th class="active active-th text-center text-center">사고사실 통보</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							고객님 담당자(이름 : <%=user_bean.getUser_nm()%>, 전화번호 : <%=user_bean.getUser_m_tel()%>)에게 통보합니다.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">사고처리<br>절차협의</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							자차사고 처리 협의, 기타 문의 및 협조 요청하시면 성실하고
	            							<br>
	            							최선을 다해 협조해 드립니다.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">대차서비스</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							자차 수리 기간에 동급의 자동차로 대차해드립니다.
	            							<br>
	            							고객님 담당자에 요청하시길 바랍니다.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">자차수리</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							당사의 모든 자동차 자기차량 손해담보는 보험회사가 아닌
	            							<br>
	            							당사가 보험 기능을 수행합니다.
	            							<br><br>
	            							사고 수리와 관련된 업무는 모두 고객님 담당자가 처리합니다.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">주의사항</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							고객님께서 임의로 정비업체에 맡겨 수리하거나 요청한 경우,
	            							<br>
	            							수리비에 대한 보상이 이루어지지 않으므로,
	            							<br>
	            							사전에 담당자와 협의하여 처리해주시길 바랍니다.
	            						</div>
	            					</td>
	            				</tr>
	            			</table>
	            		</div>
	            	</div>
				</div>
				
				<div class="item">
					<div style="position: relative;">
						<img src="https://www.amazoncar.co.kr/home/mobile/images/title_3.png" style="width: 100%; height: 100%; min-height: 130px; max-height: 130px;">
	            	</div>
	            	<div style="position: relative; top: -80px;">
						<div style="color: #FFF; font-size: 20px; font-weight: bold; text-align: center;">사고처리(경찰청) 순서 안내</div>
	            	</div>
	            	
	            	<div style="margin: 0px 0px 0px 0px;">
	            		<div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 25%; vertical-align: middle;">
									<col style="width: 75%;">
								</colgroup>
	            				<tr>
	            					<th class="active active-th text-center text-center">사고접수</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							접수 사실을 SMS 문자로 가해자 · 피해자에게 통지합니다.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">현장조사</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							본인, 변호인(보호자), 목격자 등 입회 및 유리한 증거를 제출합니다.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">진술청취</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							피해자, 참고인(목격자) 등이 사고 당시 보고 느낀 대로
	            							<br>
	            							<span style="font-weight: bold;">진술서</span>를 작성하고 피해자는 진단서, 견적서를 체출합니다.
	            							<br>
	            							※ 미제출 시 피해가 없는 사고로 종결될 수 있습니다.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">가해자 조사</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							사망, 중상해, 뺑소니 등은 교통사고처리특례법(제3조 2항)에서 정한
	            							<br>
	            							12대 중과실에 해당하고, 보험 미가입(미합의) 사고의 경우 
	            							<br>
	            							형사입건(불구속 수사가 원칙이나, 인명피해가 크거나 뺑소니 사고로
	            							<br>
	            							도주 · 증거인멸 우려가 있는 경우 구속될 수 있음)
	            							<br>
	            							단, 원인 행위는 범칙금 및 벌점 부과됩니다.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">사건송치</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							사건송치 : 조사 완료 후 조사 결과를 검창청에 송치한 후,
	            							<br>
	            							3일 이내에 조사 결과를 서면 통보하고 있습니다.
	            						</div>
	            					</td>
	            				</tr>
	            			</table>
	            			<div class="text-left">
	            				※ 더 궁금하신 사항은 경찰청 콜센터 182로 문의 바랍니다.
	            			</div>
	            		</div>
	            	</div>
				</div>
				
			</div>

			<!-- Left and right controls -->
			<a class="left carousel-control" href="#myCarousel" data-slide="prev" style="left: -100;">
				<span class="glyphicon glyphicon-chevron-left" style="left: 0px; color: #000; text-align: right;"></span> <span class="sr-only">Previous</span>
			</a> 
			<a class="right carousel-control" href="#myCarousel" data-slide="next" style="right: -100;"> 
				<span class="glyphicon glyphicon-chevron-right" style="right: 0px; color: #000; text-align: left;"></span> <span class="sr-only">Next</span>
			</a>
		</div>
	</div>
	
</body>
</html>
