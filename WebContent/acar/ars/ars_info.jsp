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
	
	user_bean = umd.getUsersBean(user_id);
	
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
<title>ARS ���� ���� �ȳ���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<!-- <meta name="viewport" content="width=device-width, initial-scale=1"> -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<style>
/* body { -webkit-text-size-adjust : none; } /* ��Ʈ�� ����� �þ�� �ʵ��� �Ѵ� */ */
/* body { -webkit-text-size-adjust : 120%; } /* ��Ʈ�� ���� ������� �����ϰ� �Ѵ� */ */
body { 
	-webkit-text-size-adjust : auto; /* ������ �Ȱ��� �۵��ϵ��� �Ѵ� */
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
			
				<!-- ���ó�� ����ó �ȳ� -->
				<div class="item active">
					<div style="position: relative;">
						<img src="https://www.amazoncar.co.kr/home/mobile/images/title_1.png" style="width: 100%; height: 100%; min-height: 130px; max-height: 130px;">
	            	</div>
	            	<div style="position: relative; top: -80px;">
						<div style="color: #FFF; font-size: 20px; font-weight: bold; text-align: center;">���ó�� ����ó �ȳ�</div>
	            	</div>
	            	
	            	<div style="margin: 0px 0px 0px 0px;">
	            		<div>
	            			<div class="text-center" style="border: 1px solid #50af31; padding: 10px; font-size:20px; font-weight: bold; color: #50af31; margin-bottom: 20px;">
	            				�ڵ��� ����ȸ��
	            			</div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 20%;">
									<col style="width: 40%;">
									<col style="width: 40%;">
								</colgroup>
	            				<tr>
	            					<th class="active text-center text-center">����</th>
	            					<th class="active text-center text-center">����ȸ��</th>
	            					<th class="active text-center text-center">����ó</th>
	            				</tr>
	            				<tr>	            					
	            					<td class="mid text-center">����ī</td>
	            					<td class="mid text-center">����ī��������</td>
	            					<td class="mid text-center">1661-7977</td>
	            				</tr>
	            				<tr>	            					
	            					<td class="mid text-center">����</td>
	            					<td class="mid text-center">�Ｚȭ��</td>
	            					<td class="mid text-center">1588-5114 (1588-0100)</td>
	            				</tr>
	            			</table>
	            			<div class="text-left">
	            				�� ������ȣ�� "��", "��", "ȣ" ���ڰ� �ִٸ� ����ī�Դϴ�.
	            				<br>
	            				�� �� ���� ���� ���� �����̸�, �� �ڵ����� <span style="font-weight: bold; color: red;"><%=ins_com_nm%></span>�� ���� ���ԵǾ� �ֽ��ϴ�.
	            			</div>
	            		</div>
	            		
	            		<div>
	            			<div class="text-center" style="border: 1px solid #50af31; padding: 10px; font-size:20px; font-weight: bold; color: #FFFFFF; margin: 20px 0px; background-color: #50af31;">
	            				����⵿ ����
	            			</div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: 50%;">
								</colgroup>
	            				<tr>
	            					<th class="active text-center text-center">��ȣ</th>
	            					<th class="active text-center text-center">����ó</th>
	            					<th class="active text-center text-center">���</th>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">����Ÿ�ڵ�������</td>
	            					<td class="mid text-center">1588-6688</td>
	            					<td class="mid text-center" rowspan="3">
	            						����⵿ ���񽺴� ����ī�� ������
	            						<br>
	            						�������� �ʽ��ϴ�.
	            					</td>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">SK ��Ʈ����</td>
	            					<td class="mid text-center">1670-5494</td>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">����ī��������</td>
	            					<td class="mid text-center">1661-7977</td>
	            				</tr>
	            			</table>
	            		</div>
	            		
	            		<div style="height: 280px;">
	            			<div class="text-center" style="border: 1px solid #50af31; padding: 10px; font-size:20px; font-weight: bold; color: #50af31; margin-bottom: 20px;">
	            				��Ÿ ����ó
	            			</div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: 50%;">
								</colgroup>
	            				<tr>
	            					<th class="active text-center text-center">����</th>
	            					<th class="active text-center text-center">����ó</th>
	            					<th class="active text-center text-center">���</th>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">����û</td>
	            					<td class="mid text-center">112</td>
	            					<td class="mid text-center"></td>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">119�����Ű���</td>
	            					<td class="mid text-center">119</td>
	            					<td class="mid text-center"></td>
	            				</tr>
	            				<tr>
	            					<td class="mid text-center">�Ƹ���ī</td>
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
						<div style="color: #FFF; font-size: 20px; font-weight: bold; text-align: center;">������ó��(����) �ȳ�</div>
	            	</div>
	            	
	            	<div style="margin: 0px 0px 0px 0px;">
	            		<div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 25%; vertical-align: middle;">
									<col style="width: 75%;">
								</colgroup>
	            				<tr>
	            					<th class="active active-th text-center text-center">�ﰢ�뼳ġ</th>
	            					<td class="mid">	            						
	            						<div style="padding: 20px 0px 20px 20px;">
	            							��� �������κ��� �ְ�(100M), �߰�(200M) �Ĺ濡 ��ġ�մϴ�.
	            							<br>
	            							(�ﰢ��� Ʈ��ũ�� ��ġ�Ǿ� �ֽ��ϴ�.)
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">����</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							�ż��ϰ� ���巹�� ������ �����մϴ�.
	            							<br>
	            							(��ӵ���/�ڵ��� ���뵵��)
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">�λ��� Ȯ��</th>
	            					<td class="mid">	            						
	            						<div style="padding: 20px 0px 20px 20px;">
	            							�λ��ڰ� ���� ��� �ż��� �Ű��մϴ�.(119)
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">����Ȯ��</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							��� ���� ���� �Կ� �� ���ڽ� ���� Ȯ��, ����� Ȯ���մϴ�.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">�������</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							����翡 ��� ���� �� ��� ������ȣ�� �޽��ϴ�.
	            							<br>
	            							(����� �� ������ȣ)	
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">����û �������</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							�ʿ��� ��� (12�� �߰��� � �ش��ϴ� ���)
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">����ó ��ȯ</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							����� ���� �� ����ó�� ��ȯ�մϴ�.
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
						<div style="color: #FFF; font-size: 20px; font-weight: bold; text-align: center;">�������� ���ó�� �ȳ�</div>
	            	</div>
	            	
	            	<div style="margin: 0px 0px 0px 0px;">
	            		<div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 25%; vertical-align: middle;">
									<col style="width: 75%;">
								</colgroup>
	            				<tr>
	            					<th class="active active-th text-center text-center">����� �뺸</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							���� �����(�̸� : <%=user_bean.getUser_nm()%>, ��ȭ��ȣ : <%=user_bean.getUser_m_tel()%>)���� �뺸�մϴ�.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">���ó��<br>��������</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							������� ó�� ����, ��Ÿ ���� �� ���� ��û�Ͻø� �����ϰ�
	            							<br>
	            							�ּ��� ���� ������ �帳�ϴ�.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">��������</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							���� ���� �Ⱓ�� ������ �ڵ����� �����ص帳�ϴ�.
	            							<br>
	            							���� ����ڿ� ��û�Ͻñ� �ٶ��ϴ�.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">��������</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							����� ��� �ڵ��� �ڱ����� ���ش㺸�� ����ȸ�簡 �ƴ�
	            							<br>
	            							��簡 ���� ����� �����մϴ�.
	            							<br><br>
	            							��� ������ ���õ� ������ ��� ���� ����ڰ� ó���մϴ�.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">���ǻ���</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							���Բ��� ���Ƿ� �����ü�� �ð� �����ϰų� ��û�� ���,
	            							<br>
	            							������ ���� ������ �̷������ �����Ƿ�,
	            							<br>
	            							������ ����ڿ� �����Ͽ� ó�����ֽñ� �ٶ��ϴ�.
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
						<div style="color: #FFF; font-size: 20px; font-weight: bold; text-align: center;">���ó��(����û) ���� �ȳ�</div>
	            	</div>
	            	
	            	<div style="margin: 0px 0px 0px 0px;">
	            		<div>
	            			<table class="table table-bordered">
	            				<colgroup>
									<col style="width: 25%; vertical-align: middle;">
									<col style="width: 75%;">
								</colgroup>
	            				<tr>
	            					<th class="active active-th text-center text-center">�������</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							���� ����� SMS ���ڷ� ������ �� �����ڿ��� �����մϴ�.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">��������</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							����, ��ȣ��(��ȣ��), ����� �� ��ȸ �� ������ ���Ÿ� �����մϴ�.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">����û��</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							������, ������(�����) ���� ��� ��� ���� ���� ���
	            							<br>
	            							<span style="font-weight: bold;">������</span>�� �ۼ��ϰ� �����ڴ� ���ܼ�, �������� ü���մϴ�.
	            							<br>
	            							�� ������ �� ���ذ� ���� ���� ����� �� �ֽ��ϴ�.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">������ ����</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							���, �߻���, ���Ҵ� ���� ������ó��Ư�ʹ�(��3�� 2��)���� ����
	            							<br>
	            							12�� �߰��ǿ� �ش��ϰ�, ���� �̰���(������) ����� ��� 
	            							<br>
	            							�����԰�(�ұ��� ���簡 ��Ģ�̳�, �θ����ذ� ũ�ų� ���Ҵ� ����
	            							<br>
	            							���� �� �����θ� ����� �ִ� ��� ���ӵ� �� ����)
	            							<br>
	            							��, ���� ������ ��Ģ�� �� ���� �ΰ��˴ϴ�.
	            						</div>
	            					</td>
	            				</tr>
	            				<tr>
	            					<th class="active active-th text-center">��Ǽ�ġ</th>
	            					<td class="mid">
	            						<div style="padding: 20px 0px 20px 20px;">
	            							��Ǽ�ġ : ���� �Ϸ� �� ���� ����� ��âû�� ��ġ�� ��,
	            							<br>
	            							3�� �̳��� ���� ����� ���� �뺸�ϰ� �ֽ��ϴ�.
	            						</div>
	            					</td>
	            				</tr>
	            			</table>
	            			<div class="text-left">
	            				�� �� �ñ��Ͻ� ������ ����û �ݼ��� 182�� ���� �ٶ��ϴ�.
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
