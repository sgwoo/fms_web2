<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<title>현대해상 임시운행보험료료</title>
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
<label>1&#46; 임시운행보험료</label>
<div class="div_out">
	<div class="div_in">
		<table>
			<tr>
				<th rowspan="2">구 분</th>
				<th rowspan="2">세부 차량구분</th>
				<th rowspan="2">해당차명</th>
				<th colspan="2">보험료&#40;&#39;17년 3월 1일&#126; &#41;</th>
			</tr>
			<tr>
				<th>인하전</th>
				<th>인하후</th>
			</tr>
			<tr>
				<td class="align_center" rowspan="2">승 용</td>
				<td class="align_center">승차정원6인이하</td>
				<td class="align_center">승용전차종&#44; 스포티지&#44; 쏘렌토&#40;5인&#41;</td>
				<td class="align_right">2&#44;800</td>
				<td class="align_right">2&#44;600</td>
			</tr>
			<tr>
				<td class="align_center">승차정원10인이하</td>
				<td class="align_center">쏘렌토&#40;7인&#41;&#44; 카렌스&#44; 카니발&#40;7&#44;9인&#41;</td>
				<td class="align_right">3&#44;800</td>
				<td class="align_right">3&#44;500</td>
			</tr>
			<tr>
				<td class="align_center" rowspan="3">화 물</td>
				<td class="align_center">1톤이하</td>
				<td class="align_center">봉고트럭 1톤</td>
				<td class="align_right">4&#44;100</td>
				<td class="align_right">3&#44;800</td>
			</tr>
			<tr>
				<td class="align_center">1톤초과 5톤이하</td>
				<td class="align_center">봉고트럭 1&#46;2톤</td>
				<td class="align_right">3&#44;600</td>
				<td class="align_right">3&#44;800</td>
			</tr>
			<tr>
				<td class="align_center">5톤초과</td>
				<td class="align_center">&#45;</td>
				<td class="align_right">6&#44;500</td>
				<td class="align_right">6&#44;000</td>
			</tr>
			<tr>
				<td class="align_center"rowspan="2">승 합</td>
				<td class="align_center">승차정원25인이하</td>
				<td class="align_center">카니발&#40;11인&#41;</td>
				<td class="align_right">4&#44;700</td>
				<td class="align_right">4&#44;300</td>
			</tr>
			<tr>
				<td class="align_center">승차정원26인이상</td>
				<td class="align_center">대형버스</td>
				<td class="align_right">6&#44;900</td>
				<td class="align_right">6&#44;400</td>
			</tr>
			<tr>
				<td class="align_center" rowspan="3">6종중기</td>
				<td class="align_center">덤프트럭</td>
				<td class="align_center">&#45;</td>
				<td class="align_right">9&#44;800</td>
				<td class="align_right">9&#44;000</td>
			</tr>
			<tr>
				<td class="align_center">콘크리트 믹서</td>
				<td class="align_center">&#45;</td>
				<td class="align_right">7&#44;700</td>
				<td class="align_right">7&#44;000</td>
			</tr>
			<tr>
				<td class="align_center">기디</td>
				<td class="align_center">&#45;</td>
				<td class="align_right">1&#44;800</td>
				<td class="align_right">1&#44;600</td>
			</tr>
			<tr>
				<td class="align_center">일반중기</td>
				<td class="align_center"></td>
				<td class="align_center">&#45;</td>
				<td class="align_right">2&#44;000</td>
				<td class="align_right">1&#44;800</td>
			</tr>
		</table>
	</div>
</div>
<label>※ 현대해상 문의처&#40;보상&#47;사고접수&#41; &#58; 탁송보험 &#40;02&#45;732&#45;0075&#41;&#44; 의무보험 &#40;02&#45;3700&#45;2925&#41;</label>
</body>
</html>