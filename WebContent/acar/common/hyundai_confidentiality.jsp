<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<title>�����ػ� �ӽÿ��ຸ����</title>
<style>
body{
	padding-top:10px;
}
table, tr, th, td{
	border-style:solid;
	border-width:thin;
	border-collapse:collapse;
	font-size:17px;
	font-family:nanumgothic;
}
label{
	font-size:18px;
	font-family:nanumgothic;
	padding-left:25px;
	margin-bottom:10px;
}
table{
	width:95%;
	height:65%;
	margin-left:auto;
	margin-right:auto;
}
th{
	background-color:#FFCC33;
}
.remove_border_top{
	border-style: none;
	border-width: 0px;
	border-color: red;
}
.remove_border_bottom{
}
.div_out{
	margin-top:10px;
	margin-bottom:10px;
	text-align:center;
}
.div_in{
	vertical-align:middle;
	display:inline-block;
	width:100%;
}
.align_center{
	text-align:center;
}
.align_right{
	text-align:right;
	padding-right:10px;
}
</style>
</head>
<body>
<label>1&#46; �ӽÿ��ຸ���</label>
<div class="div_out">
	<div class="div_in">
		<table>
			<tr>
				<th rowspan="2">�� ��</th>
				<th rowspan="2">���� ��������</th>
				<th rowspan="2">�ش�����</th>
				<th colspan="2">�����&#40;&#39;17�� 3�� 1��&#126; &#41;</th>
			</tr>
			<tr>
				<th>������</th>
				<th>������</th>
			</tr>
			<tr>
				<td class="align_center" rowspan="2">�� ��</td>
				<td class="align_center">��������6������</td>
				<td class="align_center">�¿�������&#44; ����Ƽ��&#44; ���&#40;5��&#41;</td>
				<td class="align_right">2&#44;800</td>
				<td class="align_right">2&#44;600</td>
			</tr>
			<tr>
				<td class="align_center">��������10������</td>
				<td class="align_center">���&#40;7��&#41;&#44; ī����&#44; ī�Ϲ�&#40;7&#44;9��&#41;</td>
				<td class="align_right">3&#44;800</td>
				<td class="align_right">3&#44;500</td>
			</tr>
			<tr>
				<td class="align_center" rowspan="3">ȭ ��</td>
				<td class="align_center">1������</td>
				<td class="align_center">����Ʈ�� 1��</td>
				<td class="align_right">4&#44;100</td>
				<td class="align_right">3&#44;800</td>
			</tr>
			<tr>
				<td class="align_center">1���ʰ� 5������</td>
				<td class="align_center">����Ʈ�� 1&#46;2��</td>
				<td class="align_right">3&#44;600</td>
				<td class="align_right">3&#44;800</td>
			</tr>
			<tr>
				<td class="align_center">5���ʰ�</td>
				<td class="align_center">&#45;</td>
				<td class="align_right">6&#44;500</td>
				<td class="align_right">6&#44;000</td>
			</tr>
			<tr>
				<td class="align_center"rowspan="2">�� ��</td>
				<td class="align_center">��������25������</td>
				<td class="align_center">ī�Ϲ�&#40;11��&#41;</td>
				<td class="align_right">4&#44;700</td>
				<td class="align_right">4&#44;300</td>
			</tr>
			<tr>
				<td class="align_center">��������26���̻�</td>
				<td class="align_center">��������</td>
				<td class="align_right">6&#44;900</td>
				<td class="align_right">6&#44;400</td>
			</tr>
			<tr>
				<td class="align_center" rowspan="3">6���߱�</td>
				<td class="align_center">����Ʈ��</td>
				<td class="align_center">&#45;</td>
				<td class="align_right">9&#44;800</td>
				<td class="align_right">9&#44;000</td>
			</tr>
			<tr>
				<td class="align_center">��ũ��Ʈ �ͼ�</td>
				<td class="align_center">&#45;</td>
				<td class="align_right">7&#44;700</td>
				<td class="align_right">7&#44;000</td>
			</tr>
			<tr>
				<td class="align_center">���</td>
				<td class="align_center">&#45;</td>
				<td class="align_right">1&#44;800</td>
				<td class="align_right">1&#44;600</td>
			</tr>
			<tr>
				<td class="align_center">�Ϲ��߱�</td>
				<td class="align_center"></td>
				<td class="align_center">&#45;</td>
				<td class="align_right">2&#44;000</td>
				<td class="align_right">1&#44;800</td>
			</tr>
		</table>
	</div>
</div>
<label>�� �����ػ� ����ó&#40;����&#47;�������&#41; &#58; Ź�ۺ��� &#40;02&#45;732&#45;0075&#41;&#44; �ǹ����� &#40;02&#45;3700&#45;2925&#41;</label>
</body>
</html>