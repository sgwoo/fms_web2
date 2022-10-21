<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.ars_card.* "%>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String ars_code 	= request.getParameter("ars_code")==null?"":request.getParameter("ars_code");
		
	ArsCardBean ars = ar_db.getArsCard(ars_code);
	
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
        url : "https://api.innopay.co.kr/api/cancelApi",
        async : true,
        data : tableToJSON(document.getElementById('payTable')),
        contentType: "application/json; charset=utf-8",
        dataType : "json",
        success : function(data){
			$("#first").hide();
			$("#second").show();

            console.log(data);
            $('[name="pgTid_result"]').val(data.pgTid);
            $('[name="resultCode_result"]').val(data.resultCode);
            $('[name="resultMsg_result"]').val(data.resultMsg);
            $('[name="pgApprovalAmt_result"]').val(data.pgApprovalAmt);
            $('[name="pgAppDate_result"]').val(data.pgAppDate);
            $('[name="pgAppTime_result"]').val(data.pgAppTime); 
        },
        error : function(data){
        	console.log(data);   
        	alert("��ſ���");
        }
    });
}
function back(){
	$("#first").show();
	$("#second").hide();
}
</script>
<body>
<div class="wrap">
	<h2>< �̳����� SMS ���� ��� ��û ></h2>
	<div class="first" id="first">
		<h2>SMS ���� ��� ��û</h2>
		<form id="frm" name="frm">
			<table id="payTable">
				<tr>
					<td>���� ���̵�</td>
					<td>
						<input name="mid" value="pgamazoncm" readonly style="background-color: rgb(235, 235, 228);"> <!-- �ʼ�: ���� ���̵�(���Ǵϼ���Ʈ �߱�) -->
					</td>
				</tr>
				<tr>
					<td>�ŷ� ���̵�</td>
					<td>
						<input name="tid" value="" readonly style="background-color: rgb(235, 235, 228);"> <!-- �ʼ�: �ŷ�������ȣ -->
					</td>
				</tr>
				<tr>
					<td>���񽺱���</td>
					<td>
						<input name="svcCd" value="01" readonly style="background-color: rgb(235, 235, 228);"> <!-- �ʼ�: 01 ���� -->
					</td>
				</tr>
				<tr>
					<td>��ұݾ�</td>
					<td>
						<input name="cancelAmt" value="<%=AddUtil.parseDecimal(ars.getGood_mny())%>"> <!-- �ʼ�: ��ұݾ�(����) -->
					</td>
				</tr>
				<tr>
					<td>��һ���</td>
					<td>
						<input name="cancelMsg" value=""> <!-- �ʼ�: ��һ��� -->
					</td>
				</tr>
				<input type="hidden" name="cancelPwd" value="123456">
				<!-- 
				<tr>
					<td>��Һ�й�ȣ</td>
					<td>
						<input name="cancelPwd" value="123456" readonly style="background-color: rgb(235, 235, 228);"> --><!-- �ʼ�: ��Һ�й�ȣ -->
					<!--</td>
				</tr>
				 -->
			</table>
		</form>
		<button onclick="javascript:send();" style="cursor:pointer">��ҿ�û</button>
	</div>

	<div class="second" id="second">
		<h2>SMS ���� ��� ��û ���</h2>
		<table id="">
			<tr>
				<td>�ŷ�������ȣ</td>
				<td>
					<input name="pgTid_result" value="" disabled> <!-- pgTid -->
				</td>
			</tr>
			<tr>
				<td>����ڵ� (2001:����, �̿� ����)</td>
				<td>
					<input name="resultCode_result" value="" disabled> <!-- resultCode -->
				</td>
			</tr>
			<tr>
				<td>����޽���</td>
				<td>
					<input name="resultMsg_result" value="" disabled> <!-- resultMsg -->
				</td>
			</tr>
			<tr>
				<td>��ұݾ�</td>
				<td>
					<input name="pgApprovalAmt_result" value="" disabled> <!-- pgApprovalAmt -->
				</td>
			</tr>
			<tr>
				<td>�����</td>
				<td>
					<input name="pgAppDate_result" value="" disabled> <!-- pgAppDate -->
				</td>
			</tr>
			<tr>
				<td>��ҽð�</td>
				<td>
					<input name="pgAppTime_result" value="" disabled> <!-- pgAppTime -->
				</td>
			</tr>
		</table>
		<button onclick="javascript:back();" style="cursor:pointer">�ڷΰ���</button>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function () {
	$("#second").hide();
});	
</script>
</body>
</html>
