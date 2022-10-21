<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*"%>
<%
	String type = request.getParameter("type")==null? "":request.getParameter("type");
	String firm_nm = request.getParameter("firm_nm")==null? "":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null? "":request.getParameter("client_nm");
	String rent_l_cd = request.getParameter("rent_l_cd")==null? "":request.getParameter("rent_l_cd");
	String car_no = request.getParameter("car_no")==null? "":request.getParameter("car_no");
	String car_nm = request.getParameter("car_nm")==null? "":request.getParameter("car_nm");					// 차명
	String current_date = AddUtil.getDate3();
	String ssn = request.getParameter("ssn")==null? "":request.getParameter("ssn");									// 법인등록번호 또는 생년월일
	String enp_no = request.getParameter("enp_no")==null? "":request.getParameter("enp_no");					// 사업자등록번호
	String address = request.getParameter("address")==null? "":request.getParameter("address");					// 사업장 주소 2018.01.10
	String rent_dt = request.getParameter("rent_dt")==null? "":request.getParameter("rent_dt");					// 계약일자
	String car_color = request.getParameter("car_color")==null? "":request.getParameter("car_color");			// 차량색상
	String rent_start_dt = request.getParameter("rent_start_dt")==null? "":request.getParameter("rent_start_dt");// 이용기간 시작일
	String rent_end_dt = request.getParameter("rent_end_dt")==null? "":request.getParameter("rent_end_dt");// 이용기간 종료일
	String driving_age = request.getParameter("driving_age")==null? "":request.getParameter("driving_age");// 보험가입운전자 연령
	String view_amt 		= request.getParameter("view_amt")		==null? "":request.getParameter("view_amt");// 대여료/보증금표시여부 20191105
	int fee_amt 				= request.getParameter("fee_amt")			==null?0:Util.parseInt(request.getParameter("fee_amt"));// 대여료 20191105
	int grt_amt 				= request.getParameter("grt_amt")			==null?0:Util.parseInt(request.getParameter("grt_amt"));// 보증금 20191105
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <title>FMS</title>
    <!-- <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link> -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style>
	*{
		font-family: serif;
	}
</style>
</head>
<body topmargin=0 leftmargin=0 onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">

</object>
<input type="hidden" id="type" value="<%=type%>">

<div id="print_template_a"><!-- 자기차량손해확인서 		START-->
	<table style="border-collapse:collapse;width:100%;">
		<tr>
			<td style="height:50px;"></td>
		</tr>
		<tr>
			<td colspan="4" style="text-align:center;height:50px;">
				<span style="padding-top:10px;padding-right:30px;padding-bottom:10px;padding-left:30px;border-width:1px;border-style:solid;border-color:black;font-size:28px;
					font-weight:bold;">자기차량손해확인서</span>
			</td>
		</tr>
		<tr>
			<td style="height:30px;"></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;">계약자</td>
			<td style="border:1px solid black;width:30%;text-align:center;"><%=firm_nm%><br><%=client_nm%></td>
			<td style="border:1px solid black;width:20%;text-align:center;">계약번호</td>
			<td style="border:1px solid black;width:30%;text-align:center;"><%=rent_l_cd%></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;">차량번호</td>
			<td style="border:1px solid black;width:30%;text-align:center;"><%=car_no%></td>
			<td style="border:1px solid black;width:20%;text-align:center;">차 명</td>
			<td style="border:1px solid black;width:30%;text-align:center;"><%=car_nm%></td>
		</tr>
		<tr>
			<td style="height:20px;"></td>
		</tr>
		<tr>
			<td colspan="4">
				<span style="margin-left:25px;font-size:17px;font-weight:bold;">○ 자기차량손해 부위 및 기타 손해(망실 등) 내용(계약서 및 인도인수증 참조)</span><br>
				<span style="margin-left:50px;font-size:14px;">(상기 대여자동차 대여기간에 발생한 자기차량손해 수리비용을 면책금(자차보험)만으로 갈음하고</span><br>
				<span style="margin-left:50px;font-size:14px;">고객에게는 더 이상의 비용부담을 주지 않기 위함입니다.)</span>
			</td>
		</tr>
		<tr>
			<td style="height:10px;"></td>
		</tr>
		<tr>
			<td colspan="4"><input style="border:1px solid black;width:100%;height:260px;" readonly></td>
		</tr>
		<tr>
			<td style="height:20px;"></td>
		</tr>
		<tr>
			<td colspan="4"><span style="margin-left:25px;font-size:17px;font-weight:bold;">○ 면책금액 및 입금 안내</span></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:15px;">면 책 금 액</td>
			<td colspan="3" style="border:1px solid black;">
				<span style="margin-left:100px;font-weight:bold;font-size:15px;">일 금</span><span style="margin-left:200px;font-weight:bold;font-size:15px;">원 정</span>
			</td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:15px;">납 입 약 정 일 자</td>
			<td colspan="3">&nbsp;<span style="font-size:15px;">계좌입금(20&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp;&nbsp;월&nbsp;&nbsp;&nbsp;일), 신용카드(자동이체, 현장결재)</span></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:15px;">입 금 안 내</td>
			<td colspan="3">
				&nbsp;<span style="font-size:15px;">입금계좌 : 신 한 은 행 140-004-023871 ㈜아마존카</span><br>
				&nbsp;<span style="font-size:15px;">신용카드 : 대여차량 반납시 현장 결재 또는 신용카드자동이체</span>
			</td>
		</tr>
		<tr>
			<td style="height:20px;"></td>
		</tr>
		<tr>
			<td colspan="4">
				<span style="margin-left:25px;font-size:18px;">○ 상기 내용을 정히 고지 받았으며 고지 받은 자기차량손해 면책금을 약정</span><br>
				<span style="margin-left:50px;font-size:18px;">기일 안에 납부할 것을 약속합니다.</span>
			</td>
		</tr>
		<tr>
			<td style="height:20px;"></td>
		</tr>
		<tr>
			<td colspan="4" style="text-align:center;">
				<span style="font-size:18px;"><%=current_date%></span>
			</td>
		</tr>
		<tr>
			<td style="height:50px;"></td>
		</tr>
		<tr>
			<td colspan="2"><span style="margin-left:45px;font-size:20px;font-weight:bold;">계약자</span></td>
			<td colspan="2"><span style="margin-left:80px;font-size:14px;">(서명날인)</span></td>
		</tr>
		<tr>
			<td style="height:20px;"></td>
		</tr>
		<tr>
			<td colspan="2"><span style="margin-left:45px;font-size:20px;font-weight:bold;">계약자의 대리인</span></td>
			<td colspan="2"><span style="margin-left:80px;font-size:14px;">(서명날인)</span></td>
		</tr>
	</table>
</div><!-- 자기차량손해확인서 		END-->

<div id="print_template_b"><!-- 자동차 대여이용 계약사실 확인서		START-->
	<table style="border-collapse:collapse;width:100%;">
		<tr><td style="height:50px;"></td></tr>
		<tr>
			<td colspan="4" style="text-align:center;font-size:20px;">〈 자동차 대여이용 계약사실 확인서 〉</td>
		</tr>
		<tr><td style="height:30px;"></td></tr>
		<tr>
			<td colspan="4" style="font-weight:bold;">＊ 고객 사항</td>
		</tr>
		<tr><td style="height:10px;"></td></tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><span>상</span><span style="margin-left:60px;">호</span></td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=firm_nm%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">법인등록번호<br>또는 생년월일</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=ssn%></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">성명 (대표자)</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=client_nm%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">사업자번호</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=enp_no%></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><span>주</span><span style="margin-left:60px;">소</span></td>
			<td colspan="3" style="font-size:14px;">&nbsp;<%=address%></td>
		</tr>
		<tr>
			<td colspan="4" style="height:50px;"></td>
		</tr>
		<tr>
			<td colspan="4" style="font-weight:bold;">＊ 계약 사실에 대한 확인</td>
		</tr>
		<tr><td style="height:10px;"></td></tr>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">계약일자</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.ChangeDate2(rent_dt)%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">대여차량명</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=car_nm%></td>
		</tr>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">이용기간</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.ChangeDate2(rent_start_dt)%> ~ <%=AddUtil.ChangeDate2(rent_end_dt)%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">차량번호</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=car_no%></td>
		</tr>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">보험가입운전자<br>연령</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%if(driving_age.equals("0")){%>26세이상<%}
																																			else if(driving_age.equals("3")){%>24세이상<%}
																																			else if(driving_age.equals("1")){%>21세이상<%}
																																			else if(driving_age.equals("5")){%>30세이상<%}
																																			else if(driving_age.equals("6")){%>35세이상<%}
																																			else if(driving_age.equals("7")){%>43세이상<%}
																																			else if(driving_age.equals("8")){%>48세이상<%}
																																			else if(driving_age.equals("2")){%>모든운전자<%}%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">차량색상</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=car_color%></td>
		</tr>
		<%if(view_amt.equals("Y")){%>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">보증금</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.parseDecimal(grt_amt)%> 원</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">대여료</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.parseDecimal(fee_amt)%> 원</td>
		</tr>
		<%} %>
		<tr><td style="height:70px;"></td></tr>
		<tr>
			<td colspan="4" style="font-size:14px;">위의 고객은 주식회사 아마존카 자동차대여이용계약 고객임을 확인합니다.</td>
		</tr>
		<tr><td style="height:70px;"></td></tr>
		<tr>
			<td colspan="4" style="text-align:center;"><span style="font-size:14px;"><%=current_date%></span></td>
		</tr>
		<tr><td style="height:40px;"></td></tr>
		<tr>
			<td colspan="4" style="text-align:center;"><img src="/acar/main_car_hp/images/ceo_no_stamp.gif"
				><img src="/acar/main_car_hp/images/ceo_stamp.jpg" height="63" width="63"></td>
		</tr>
	</table>
</div><!-- 자동차 대여이용 계약사실 확인서		END-->
</body>
<script>
	$(document).ready(function(){
		var type = $("#type").val();
		console.log(type);
		if(type == "1"){
			$("#print_template_b").remove();
		}else if(type == "2"){
			$("#print_template_a").remove();
		}
	});
	
	function onprint(){	// 2018.02.13 추가
		factory.printing.header = ""; //폐이지상단 인쇄
		factory.printing.footer = ""; //폐이지하단 인쇄
		factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin = 5.0; //좌측여백   
		factory.printing.rightMargin = 5.0; //우측여백
		factory.printing.topMargin = 0.0; //상단여백    
		factory.printing.bottomMargin = 0.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}
</script>
</html>