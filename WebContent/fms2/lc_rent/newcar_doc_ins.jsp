<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.insur.*,acar.user_mng.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>

<%
	InsDatabase c_db = InsDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();


	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String id1 = request.getParameter("id1")==null?"":request.getParameter("id1");
	String id2 = request.getParameter("id2")==null?"":request.getParameter("id2");
	
	if(client_id.equals("") && !id1.equals("")) 	client_id = id1;
	if(user_id.equals("") && !id2.equals("")) 	user_id = id2;

	
	Vector client_vt = c_db.getIjwList(client_id, rent_l_cd);		
	int client_vt_size = client_vt.size();	
	
	
	//발신자 사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);		
	
	String car_no ="";
	String car_nm ="";
	
	for(int k=0;k<client_vt_size;k++){
		Hashtable ht = (Hashtable)client_vt.elementAt(k);
		if(k==0) {
			car_no = (String)ht.get("CAR_NO");
			car_nm = (String)ht.get("CAR_NM");
		} else {
			car_no += ", " + (String)ht.get("CAR_NO");
			car_nm += ", " + (String)ht.get("CAR_NM");
		}
	}
	

	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<title>임직원 전용 자동차 보험 가입 요청서</title>
<script language="JavaScript">
<!--	

//-->
</script>
</head>
<style>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	font-family: dotum,'돋움',gulim,'굴림',Helvetica,Apple-Gothic,sans-serif;
	font-size:0.8em; 
	text-align:center;
	}
.style1 {
	font-size:2.0em;
	font-weight:bold;
}
.style2 {
	font-size:1.1em;
	font-weight:bold;}
.style3{
	font-size:0.8em;}
.style4{
	font-size:0.9em;}
.style5{
	text-decoration:underline;
	text-align:right;
	padding-right:20px;
	}
.style6{
	font-size:1.1em;}

.style7{
	text-decoration:underline;
	}
		
checkbox{padding:0px;}

table {text-align:left; border-collapse:collapse; vertical-align:middle;}
.doc table {border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em;}
.doc table td {border:1px solid #000000; height:13px;}
.doc table td.title {font-weight:bold; background-color:#e8e8e8;}
.doc1 table {border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em;}
.doc1 table td {border:1px solid #000000; height:13px; padding:3px;}
.doc1 table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:13px; padding:3px; }
p {padding:1px 0 0 0;}
.doc1 table td.pd{padding:3px;}
.doc table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:13px; padding:3px; }
.doc1 table th.ht{height:60px;}

.doc_a table {border:1px solid #000000; font-size:0.85em; width:100%;padding:20px 0;}
.doc_a table td.nor {padding:10px 10px 2px 10px;}
.doc_a table td.con {padding:0 10px 0 25px; line-height:10px;}
.cnum table {width:44%; border:1px solid #000000; font-size:0.85em;}
.cnum table td{border:1px solid #000000; height:12px; padding:3px;}
.cnum table th{background-color:#e8e8e8;}

table.doc_s {width:200px; padding:0px;}
table.doc_s td{padding:0px; height:15px;}
table.doc_s th{padding:0px;}
.left {text-align:left;}
.center {text-align:center;}
.right {text-align:right;}
.fs {font-size:0.9em; font-weight:normal;}
.fss {font-size:0.85em;}
.lineh {line-height:12px;}
.name {padding-top:8px; padding-bottom:5px; line-height:18px;}
.ht{height:60px;}
.point{background-color:#e1e1e1; padding-top:3px; font-weight:bold;}
.agree{padding:4px 0 4px 0; }

table.zero { border:0px; font-size:1.15em;}

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

-->
</style>

<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<body>
<div align="center">
<form action="" name="form1" method="POST" >
<!--
<script>var pfHeaderImgUrl = '';var pfHeaderTagline = '';var pfdisableClickToDel = 0;var pfHideImages = 0;var pfImageDisplayStyle = 'right';var pfDisablePDF = 0;var pfDisableEmail = 0;var pfDisablePrint = 1;var pfCustomCSS = '';var pfBtVersion='1';(function(){var js, pf;pf = document.createElement('script');pf.type = 'text/javascript';if('https:' == document.location.protocol){js='https://pf-cdn.printfriendly.com/ssl/main.js'}else{js='http://cdn.printfriendly.com/printfriendly.js'}pf.src=js;document.getElementsByTagName('head')[0].appendChild(pf)})();</script><a href="http://www.printfriendly.com" style="color:#6D9F00;text-decoration:none;" class="printfriendly" onclick="window.print();return false;" title="Printer Friendly and PDF"><img style="border:none;-webkit-box-shadow:none;box-shadow:none;" src="http://cdn.printfriendly.com/button-print-blu20.png" alt="Print Friendly and PDF"/></a>
-->
<table width="560" style="font-size:15px;">
	<tr>
   		<td height="60"></td>
	</tr>
	<tr>
		<td colspan="2"><div align="center"><span class=style1 style="text-decoration: underline; text-underline-position:under;">업무전용자동차보험 가입/미가입 신청서</span></div></td>
	</tr>
	<tr>
		<td height="10px"></td>
	</tr>
	<tr>
		<td colspan="2"><div align="center"><span class=style1 style="font-size: 1.5em;">(법인사업자 고객용)</span></div></td>
	</tr>
	<tr>
   		<td height=34></td>
	</tr>
	<tr>
		<td width=48% style="font-size:16px;">○ 신청인/대상자동차</td>
	</tr>
</table>
<table width="560" style="font-size:15px;">
	<% if(client_vt_size > 0) { %>
		<%
			for(int k=0;k<1;k++){
			 			Hashtable ht = (Hashtable)client_vt.elementAt(k);
	 	%>
		<tr>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center; ">계약자<br>(상호/성명)</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;"><%=ht.get("FIRM_NM")%></td>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center;">사업자등록<br>번호</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;"><%=AddUtil.ChangeEnp(String.valueOf(ht.get("ENP_NO")))%></td>
		</tr>
		<tr>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center; ">차량번호</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;" ><%=car_no%></td>
			<td  style="border:1px solid #000000; height:60px; width: 16%; text-align:center;">차종</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 34%;"><%=car_nm%></td>
		</tr>
		<% }%>
	<% } else { %>
		<tr>
			<td  style="border:1px solid #000000; height:60px; width: 15%; text-align:center;">계약자<br>(상호/성명)</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 35%;"></td>
			<td  style="border:1px solid #000000; height:60px; width: 15%; text-align:center;">사업자등록<br>번호</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 35%;"></td>
		</tr>
		<tr>
			<td  style="border:1px solid #000000; height:60px; width: 15%; text-align:center; ">차량번호</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 35%;"></td>
			<td  style="border:1px solid #000000; height:60px; width: 15%; text-align:center;">차종</td>
			<td  style="border:1px solid #000000; height:60px; text-align:center; width: 35%;"></td>
		</tr>
	<% } %>
	
	<tr>
		<td height=37></td>
	</tr>
	<tr>
		<td colspan="4" style="font-size:16px;">○ 업무전용자동차보험 주요내용</td>
	</tr>
	<tr>
		<td  style="border:1px solid #000000; width: 15%; text-align:center; ">가입대상<br>차량 및<br>운전자범위</td>
		<td  colspan="3" style="border:1px solid #000000; text-align:left; line-height: 190%;">
		<span>◆  법인세법 제27조의2 및 법인세법시행령 제50조의2 제4항에 의거<br>
			    업무용승용차는 업무전용자동차보험에 가입하여야 업무용승용차<br>
			    관련비용의 손비처리가 가능합니다.<br>
			     ◆ 가입대상차량 (법인세법 제27조의2) : 업무용승용차<br>
	 		  &nbsp;- 개별소비세법 제1조 제2항 제3호에 따른 승용자동차<br>
			<span>&nbsp;(경차, 9인승 이상 차량, 화물차는 제외 → 세법 개정전과 동일한 방법으로 손비처리 가능)</span><br>
			◆ 업무전용자동차 보험 가입시 운전자 범위<br> 
	  		&nbsp;&nbsp;① 임차 법인 소속의 임원 또는 직원<br>
	  		&nbsp;&nbsp;② 계약에 따라 해당 법인의 업무를 위하여 운전하는 사람<br>
	  		&nbsp;&nbsp;③ 해당 법인의 운전자 채용을 위한 면접에 응시한 지원자</span>
					
 		</td>
	</tr>
	<tr>
		<td  style="border:1px solid #000000; width: 15%; text-align:center; ">미가입</td>
		<td colspan="3" style="border:1px solid #000000; text-align:left; line-height: 190%;">
			◆ 업무전용자동차보험에 가입하지 아니한 경우 <br>
 			&nbsp;- 미가입기간 동안 전액 손금불인정<br>
			◆ 미가입시 운전자 범위 : 임직원 및 임직원의 직계가족<br>
 			&nbsp;<span style="font-size:13px">- 그외 운전자는 반드시 당사(아마존카)와 사전협의한 경우에만 운전가능</span><br>
			
		</td>
	</tr>
	<tr>
		<td  style="border:1px solid #000000; width: 15%; text-align:center;"><span style="font-size: 13px;">일부기간만<br>가입한<br>경우<br>업무사용금액<br>계산</span></span></td>
		<td colspan="3" style="border:1px solid #000000; text-align:left; line-height: 190%;">
			◆ 해당 사업연도 전체기간(임차한 승용차의 경우 해당 사업연도 중에 임차한기간을 말한다) 중 일부기간만 업무전용자동차보험에 가입한 경우 법인세법
  			 제27조의2 제2항에 따른 업무사용금액은 다음의 계산식에 따라 산정한 금액으로 한다.<br>
 			= 업무용승용차 관련비용 × 업무사용비율 × (해당 사업연도에 실제로 업무전용자동차보험에 가입한 일수 ÷ 해당 사업연도에 업무전용자동차보험에 의무적으로 가입하여야 할 일수)<br>
			<span style="font-size:13px;">※ 법인세법(제27조의2), 법인세법시행령(제50조의2)등을 참고하시길 바랍니다.</span> 
		</td>
	</tr>
	<tr>
		<td  style="border:1px solid #000000; width: 15%; text-align:center; ">주의사항</td>
		<td colspan="3" style="border:1px solid #000000; text-align:left; line-height: 190%;">
			◆ 자동차보험보상범위<br>
			&nbsp;- 업무전용자동차보험에 가입한 당해 자동차는 당사(아마존카)와 약정한 계약서
			  등의 내용과 상관없이 계약자(임차인)의 가족 등(상기 업무전용자동차보험 가입시
			  운전자 범위 외의 자)이 운전해서 발생한 사고에 대해서는 자동차손해보험보상이 
			  불가합니다. (자기차량손해 사고수리비도 계약자가 전액 부담)
		</td>
	</tr>
</table>
<table width="560" style="font-size:15px;">
	<tr>
   		<td colspan="5" height="30"></td>
	</tr>
	<tr>
		<td colspan="5"></td>
	</tr>
	<tr>
		<td width=48% colspan="5" style="font-size:16px;">○ 업무전용자동차보험 선택(가입 또는 미가입 &#10003;)</td>
	</tr>
	<tr>
		<td rowspan="3" style="border:1px solid #000000; width: 15%; text-align:center; height:50px ">□<br>가입</td>
		<td style="border:1px solid #000000; width: 14%; text-align:center; height:50px ">계약자<br>상호</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px "></td>
		<td style="border:1px solid #000000; width: 15%; text-align:center; height:50px ">서명&날인</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px "></td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:40px;">업무전용자동차보험 개시일 &nbsp;【 20&nbsp;&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp;&nbsp;월&nbsp;&nbsp;&nbsp;일 】</td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:50px; line-height: 190%; ">상기 계약자 본인은 상기 자동차보험을 업무전용자동차보험으로 가입 신청합니다.</td>
	</tr>
	<tr>
		<td rowspan="3" style="border:1px solid #000000; width: 15%; text-align:center; height:50px; ">□<br>미가입</td>
		<td style="border:1px solid #000000; width: 14%; text-align:center; height:50px; ">계약자<br>상호</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px; "></td>
		<td style="border:1px solid #000000; width: 15%; text-align:center; height:50px; ">서명&날인</td>
		<td style="border:1px solid #000000; width: 28%; text-align:center; height:50px; "></td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:50px; line-height: 190%; font-size:14px; ">&nbsp; 개시일  【 20&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp;월&nbsp;&nbsp;일 】 부터 종료일 【 20&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp;월&nbsp;&nbsp;일 】 까지</td>
	</tr>
	<tr>
		<td colspan="5" style="border:1px solid #000000; width: 14%; text-align:left; height:50px; line-height: 190%; ">상기 계약자 본인은 상기 기간에 업무전용자동차보험 미가입을 신청합니다.</td>
	</tr>
</table>
<div style="width:560px; margin-top:60px">
	<span style="text-align: center; font-size: 17px;">20 &nbsp;&nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;일</span>
</div>
<div style="width:376px; margin-top:70px; text-align: right; display:inline-block; ">
	<span style="font-size: 17px;">계약자(신청인)</span>
</div>
<div style="width:214px; margin-top:70px; text-align: right; display:inline-block; margin-right: 30px; ">
	<span style="font-size: 17px;">(인)</span>
</div>
<div style="width:560px; margin-top:130px; text-align: left;">
	<span style=" font-size: 20px;"><b>주식회사 아마존카 귀중</b></span>
</div>

<div style="width:560px; margin-top:30px; text-align: left;">
	<span style=" font-size: 12px;">법인사업자 업무전용자동차보험 가입신청서(2021.11.23)</span>
</div>
	
</form>
</div>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>	

<script>
/* function onprint(){

//factory.printing.header = ""; //폐이지상단 인쇄
//factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 10.0; //좌측여백   
factory.printing.topMargin = 10.0; //상단여백    
factory.printing.rightMargin = 10.0; //우측여백
factory.printing.bottomMargin = 8.0; //하단여백

factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
//alert('인쇄미리보기에서 2장, 도장위치가 맞는지 확인! 안맞는다면 익스플로러 창에서 도구 > 호환성보기설정에 amazoncar.co.kr 추가설정 후 프린트!');
} */
</script>
