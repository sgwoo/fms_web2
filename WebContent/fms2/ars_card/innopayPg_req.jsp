<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.ars_card.*, acar.user_mng.* "%>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String ars_code 	= request.getParameter("ars_code")==null?"":request.getParameter("ars_code");
	String svcPrdtCd 	= request.getParameter("svcPrdtCd")==null?"":request.getParameter("svcPrdtCd");
		
	ArsCardBean ars = ar_db.getArsCard(ars_code);
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUserNmBean(ars.getBus_nm());
	
	boolean flag1 = ar_db.updateArsStep(ars_code, "2");
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<style>
	div.wrap {
		padding : 30px;
		width : 1400px;
		float : left;
		width: 100%;
		text-align: center;
	}
	div.first {
		padding : 30px;
		width : 350px;
		display: inline-block;
	}
	div.second {
		padding : 60px 30px 30px 30px;
		width : 615.922px;
		display: inline-block;
	}	
	h2 {
		width : 100%;
		font-size : 16px;
		margin-top : 0px;
		padding-bottom : 6px;
		float : left;
		color : #444;
		line-height : 26px;
		display : block;
	}
	
	td {
		padding : 0 0px 5px 0;
		text-align : left;
		font-weight : bold;
		width : 167px;
	}
	
	div.first input {
		border : 1px solid #aaa;
		border-radius : 0;
		padding-left : 10px;
		width : 100%;
		font-size : 13px;
		vertical-align : baseline;
		height : 30px;
	}

	div.first select {
		padding-top : 1px;
		padding-bottom : 1px;
		height : 34px;
	}
	
	div.second input {
		border : 1px solid #aaa;
		border-radius : 0;
		padding-left : 10px;
		width : 250%;
		font-size : 13px;
		vertical-align : baseline;
		height : 30px;
	}
	
	button {
		width : 350px;
		border-radius : 4px;
		padding : 0;
		margin : 20px 0;
		height : 40px;
		background-color : #1e5dd2;
		border : none;
		color : #fff;
		font-weight : bold;
	}
</style>
<script type="text/javascript">

function today(){   
    var date = new Date();

    var year  = date.getFullYear();
    var month = date.getMonth() + 1;
    var day   = date.getDate();

    if (("" + month).length == 1) { month = "0" + month; }
    if (("" + day).length   == 1) { day   = "0" + day;   }
       
	return year + month + day + "001";
}

function tableToJSON(table) {
	var obj = {};
	var row, rows = table.rows;
	for (var i=0, iLen=rows.length; i<iLen; i++) {
	  row = rows[i];
	  obj[document.getElementsByTagName("input")[i].getAttribute('name')] = document.getElementsByTagName("input")[i].value;
	}
	console.log(obj);
	return JSON.stringify(obj);
}

function send(){
	
    var resultcode = null;
    $.ajax({
        type : "POST",
        url : "https://api.innopay.co.kr/api/smsPayApi",
        async : true,
        data : tableToJSON(document.getElementById('payTable')),
        contentType: "application/json; charset=utf-8",
        dataType : "json",
        success : function(data){
			$("#first").hide();
			$("#second").show();

            console.log(data);
            alert("성공");
            
            $('[name="mid_result"]').val(data.mid);
            $('[name="moid_result"]').val(data.moid);
            $('[name="goodsName_result"]').val(data.goodsName);
            $('[name="amt_result"]').val(data.amt);
            $('[name="dutyFreeAmt_result"]').val(data.dutyFreeAmt);
            $('[name="buyerName_result"]').val(data.buyerName);
            $('[name="buyerTel_result"]').val(data.buyerTel);
            $('[name="buyerEmail_result"]').val(data.buyerEmail);
            $('[name="payExpDate_result"]').val(data.payExpDate);  
			$('[name="userId_result"]').val(data.userId);  
			$('[name="resultCode_result"]').val(data.resultCode);  
			$('[name="resultMsg_result"]').val(data.resultMsg);  
        },
        error : function(data){
        	console.log(data);   
        	alert("통신에러");
        }
    });
}
function back(){
	$("#first").show();
	$("#second").hide();
}
function change(val){
	if (val == "03") {
		$("input[name=svcPrdtCd]").val("03");
	} else if (val == "04") {
		$("input[name=svcPrdtCd]").val("04");
	}
}
</script>
<body>
<div class="wrap">
	<h2>SMS 결제 요청 샘플 페이지</h2>
	<div class="first" id="first">
		<h2>SMS 결제 요청</h2>
		<form id="frm" name="frm">
			<table id="payTable">
			    <tr>
					<td></td>
					<td>
						<select name="" onchange="change(this.value)">
							<option value="04" selected="selected">앱카드</option>
							<option value="03">일반등록</option>							
						</select>
					</td>
				</tr>
				<tr>
					<td>상점 아이디</td>
					<td>
						<input name="mid" value="pgamazoncm" readonly style="background-color: rgb(235, 235, 228);"> <!-- 필수: 상점 아이디(인피니소프트 발급) -->
					</td>
				</tr>
				<tr>
					<td>결제마감기한</td>
					<td>
						<input name="payExpDate" value="<%=AddUtil.getDate(4) %>235959" readonly> <!-- 선택: SMS결제마감기한 (미입력시 익일 23시59분59초) 예제 : (2017-11-21 23:59:59 or 20171121235959) -->
						<br><span class=style1 style="font-size: 10px;">(당일 자정전)</span>
					</td>
				</tr>
				<tr>
					<td>회원 아이디</td>
					<td>
						<input name="userId" value="acar_<%=user_bean.getId()%>"> <!-- 선택: 결제자 회원 ID -->
						<br><span class=style1 style="font-size: 10px;">(아마존카 담당자 아이디)</span>
					</td>
				</tr>
				<tr>
					<td>가맹점 주문번호</td>
					<td>
						<input name="moid" value="acar<%=ars_code%>" readonly> <!-- 필수: 가맹점 주문번호 -->
					</td>
				</tr>
				<tr>
					<td>상품명</td>
					<td>
						<input name="goodsName" value="<%=ars.getGood_name()%>"> <!-- 필수: 상품명 (한글기준 20자 이하) -->
						<br><span class=style1 style="font-size: 10px;">(한글기준 20자 이하)</span>
					</td>
				</tr>
				<tr>
					<td>결제요청금액</td>
					<td>
						<input name="amt" value="0" readonly> <!-- 필수: 결제요청금액 (숫자, 쉼표(,) 가능) -->
					</td>
				</tr>
				<tr>
					<td>면세금액</td>
					<td>
						<input name="dutyFreeAmt" value="<%=AddUtil.parseDecimal(ars.getGood_mny())%>" readonly> <!-- 필수: 면세금액 (숫자, 쉼표(,) 가능) -->
					</td>
				</tr>
				<tr>
					<td>결제자명</td>
					<td>
						<input name="buyerName" value="<%=ars.getBuyr_name()%>"> <!-- 필수: 결제자 이름 -->
					</td>
				</tr>
				<tr>
					<td>결제자 연락처</td>
					<td>
						<input name="buyerTel" value="<%=ars.getBuyr_tel2()%>"> <!-- 필수: 결제자 휴대폰번호 (숫자, 붙임표(-) 가능) -->
					</td>
				</tr>
				<tr>
					<td>결제자 이메일</td>
					<td>
						<input name="buyerEmail" value="<%=ars.getBuyr_mail()%>"> <!-- 선택: 결제자 이메일 주소 (결제 영수증 발송) -->
					</td>
				</tr>
				<tr>
					<td>서비스구분</td>
					<td>
						<input type="text" name="svcPrdtCd" value="<%=svcPrdtCd%>" readonly style="background-color: rgb(235, 235, 228);">
					</td>
				</tr>
				<tr>
					<td colspan='2'>※ 일반등록(03):카드번호,유효기간 직접입력<br>※ 앱카드(04):카드사 모바일앱 연동</td>
				</tr>
			</table>
		</form>
		<button onclick="javascript:send();" style="cursor:pointer">결제요청</button>
	</div>
	
	<div class="second" id="second">
		<h2>SMS 결제요청 결과</h2>
		<table id="">
			<tr>
				<td>상점 아이디</td>
				<td>
					<input name="mid_result" value="" disabled> <!-- mid -->
				</td>
			</tr>
			<tr>
				<td>가맹점 주문번호</td>
				<td>
					<input name="moid_result" value="" disabled> <!-- moid -->
				</td>
			</tr>
			<tr>
				<td>상품명</td>
				<td>
					<input name="goodsName_result" value="" disabled> <!-- goodsName -->
				</td>
			</tr>
			<tr>
				<td>결제요청금액</td>
				<td>
					<input name="amt_result" value="" disabled> <!-- amt -->
				</td>
			</tr>
			<tr>
				<td>면세금액</td>
				<td>
					<input name="dutyFreeAmt_result" value="" disabled> <!-- dutyFreeAmt -->
				</td>
			</tr>
			<tr>
				<td>결제자 이름</td>
				<td>
					<input name="buyerName_result" value="" disabled> <!-- buyerName -->
				</td>
			</tr>
			<tr>
				<td>결제자 휴대폰번호</td>
				<td>
					<input name="buyerTel_result" value="" disabled> <!-- buyerTel -->
				</td>
			</tr>
			<tr>
				<td>결제자 이메일 주소</td>
				<td>
					<input name="buyerEmail_result" value="" disabled> <!-- buyerEmail -->
				</td>
			</tr>
			<tr>
				<td>SMS결제마감기한</td>
				<td>
					<input name="payExpDate_result" value="" disabled> <!-- payExpDate -->
				</td>
			</tr>
			<tr>
				<td>결제자 회원 ID</td>
				<td>
					<input name="userId_result" value="" disabled> <!-- userId -->
				</td>
			</tr>
			<tr>
				<td>결과코드</td>
				<td>
					<input name="resultCode_result" value="" disabled> <!-- resultCode ("0000" 외 실패) -->
				</td>
			</tr>
			<tr>
				<td>결과메시지</td>
				<td>
					<input name="resultMsg_result" value="" disabled> <!-- resultMsg -->
				</td>
			</tr>
		</table>
		<button onclick="javascript:back();" style="cursor:pointer">뒤로가기</button>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function () {
	$("#second").hide();
	send();
});	
</script>
</body>
</html>

