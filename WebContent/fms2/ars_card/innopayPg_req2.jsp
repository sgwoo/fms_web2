<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.ars_card.*, acar.user_mng.* "%>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String ars_code 	= request.getParameter("ars_code")==null?"":request.getParameter("ars_code");
		
	ArsCardBean ars = ar_db.getArsCard(ars_code);
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUserNmBean(ars.getBus_nm());
	
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
        	alert("��ſ���");
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
	<h2>SMS ���� ��û ���� ������</h2>
	<div class="first" id="first">
		<h2>SMS ���� ��û</h2>
		<form id="frm" name="frm">
			<table id="payTable">
				<tr>
					<td></td>
					<td>
						<select name="" onchange="change(this.value)">
							<option value="04" selected="selected">��ī��</option>
							<option value="03">�Ϲݵ��</option>							
						</select>
					</td>
				</tr>

				<tr>
					<td>���� ���̵�</td>
					<td>
						<input name="mid" value="pgamazoncm" readonly style="background-color: rgb(235, 235, 228);"> <!-- �ʼ�: ���� ���̵�(���Ǵϼ���Ʈ �߱�) -->
					</td>
				</tr>
				<tr>
					<td>������������</td>
					<td>
						<input name="payExpDate" value="<%=AddUtil.getDate(4) %>235959" readonly> <!-- ����: SMS������������ (���Է½� ���� 23��59��59��) ���� : (2017-11-21 23:59:59 or 20171121235959) -->
						<br><span class=style1 style="font-size: 10px;">(���� ������)</span>
					</td>
				</tr>
				<tr>
					<td>ȸ�� ���̵�</td>
					<td>
						<input name="userId" value="acar_<%=user_bean.getId()%>"> <!-- ����: ������ ȸ�� ID -->
						<br><span class=style1 style="font-size: 10px;">(�Ƹ���ī ����� ���̵�)</span>
					</td>
				</tr>
				<tr>
					<td>������ �ֹ���ȣ</td>
					<td>
						<input name="moid" value="acar<%=ars_code%>" readonly> <!-- �ʼ�: ������ �ֹ���ȣ -->
					</td>
				</tr>
				<tr>
					<td>��ǰ��</td>
					<td>
						<input name="goodsName" value="<%=ars.getGood_name()%>"> <!-- �ʼ�: ��ǰ�� (�ѱ۱��� 20�� ����) -->
						<br><span class=style1 style="font-size: 10px;">(�ѱ۱��� 20�� ����)</span>
					</td>
				</tr>
				<tr>
					<td>������û�ݾ�</td>
					<td>
						<input name="amt" value="0" readonly> <!-- �ʼ�: ������û�ݾ� (����, ��ǥ(,) ����) -->
					</td>
				</tr>
				<tr>
					<td>�鼼�ݾ�</td>
					<td>
						<input name="dutyFreeAmt" value="<%=AddUtil.parseDecimal(ars.getGood_mny())%>" readonly> <!-- �ʼ�: �鼼�ݾ� (����, ��ǥ(,) ����) -->
					</td>
				</tr>
				<tr>
					<td>�����ڸ�</td>
					<td>
						<input name="buyerName" value="<%=ars.getBuyr_name()%>"> <!-- �ʼ�: ������ �̸� -->
					</td>
				</tr>
				<tr>
					<td>������ ����ó</td>
					<td>
						<input name="buyerTel" value="<%=ars.getBuyr_tel2()%>"> <!-- �ʼ�: ������ �޴�����ȣ (����, ����ǥ(-) ����) -->
					</td>
				</tr>
				<tr>
					<td>������ �̸���</td>
					<td>
						<input name="buyerEmail" value="<%=ars.getBuyr_mail()%>"> <!-- ����: ������ �̸��� �ּ� (���� ������ �߼�) -->
					</td>
				</tr>
				<tr>
					<td>���񽺱���</td>
					<td>
						<input type="text" name="svcPrdtCd" value="04" readonly style="background-color: rgb(235, 235, 228);">
					</td>
				</tr>
				<tr>
					<td colspan='2'>�� �Ϲݵ��(03):ī���ȣ,��ȿ�Ⱓ �����Է�<br>�� ��ī��(04):ī��� ����Ͼ� ����</td>
				</tr>
			</table>
		</form>
		<button onclick="javascript:send();" style="cursor:pointer">������û</button>
	</div>

	<div class="second" id="second">
		<h2>SMS ������û ���</h2>
		<table id="">
			<tr>
				<td>���� ���̵�</td>
				<td>
					<input name="mid_result" value="" disabled> <!-- mid -->
				</td>
			</tr>
			<tr>
				<td>������ �ֹ���ȣ</td>
				<td>
					<input name="moid_result" value="" disabled> <!-- moid -->
				</td>
			</tr>
			<tr>
				<td>��ǰ��</td>
				<td>
					<input name="goodsName_result" value="" disabled> <!-- goodsName -->
				</td>
			</tr>
			<tr>
				<td>������û�ݾ�</td>
				<td>
					<input name="amt_result" value="" disabled> <!-- amt -->
				</td>
			</tr>
			<tr>
				<td>�鼼�ݾ�</td>
				<td>
					<input name="dutyFreeAmt_result" value="" disabled> <!-- dutyFreeAmt -->
				</td>
			</tr>
			<tr>
				<td>������ �̸�</td>
				<td>
					<input name="buyerName_result" value="" disabled> <!-- buyerName -->
				</td>
			</tr>
			<tr>
				<td>������ �޴�����ȣ</td>
				<td>
					<input name="buyerTel_result" value="" disabled> <!-- buyerTel -->
				</td>
			</tr>
			<tr>
				<td>������ �̸��� �ּ�</td>
				<td>
					<input name="buyerEmail_result" value="" disabled> <!-- buyerEmail -->
				</td>
			</tr>
			<tr>
				<td>SMS������������</td>
				<td>
					<input name="payExpDate_result" value="" disabled> <!-- payExpDate -->
				</td>
			</tr>
			<tr>
				<td>������ ȸ�� ID</td>
				<td>
					<input name="userId_result" value="" disabled> <!-- userId -->
				</td>
			</tr>
			<tr>
				<td>����ڵ�</td>
				<td>
					<input name="resultCode_result" value="" disabled> <!-- resultCode ("0000" �� ����) -->
				</td>
			</tr>
			<tr>
				<td>����޽���</td>
				<td>
					<input name="resultMsg_result" value="" disabled> <!-- resultMsg -->
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

