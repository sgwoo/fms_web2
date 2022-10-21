<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.user_mng.*,java.time.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>

<%

	UserMngDatabase umd = UserMngDatabase.getInstance();

// 	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
// 	String s_kd 	= request.getParameter("s_kd")==null?	"":request.getParameter("s_kd");
// 	String t_wd 	= request.getParameter("t_wd")==null?	"":request.getParameter("t_wd");
// 	String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");
// 	String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");
// 	String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");
// 	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
// 	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
// 	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
// 	int count =0;
	
// 	Vector vt = ln_db.getAlinkDeliReceiptList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);	
// 	int vt_size = vt.size();
	String cons_no = request.getParameter("cons_no")==null?	"":request.getParameter("cons_no");
	String seq = request.getParameter("seq")==null?	"":request.getParameter("seq");
	
	Hashtable ht_cons = cs_db.getConsignment_Links(cons_no, AddUtil.parseInt(seq));
	
// 	System.out.println(ht_cons.toString());
	
// 	System.out.println(">>>>>>>>>>>>>>>>>>>>>");
	
	String rent_l_cd = String.valueOf(ht_cons.get("RENT_L_CD")); // 계약번호
	String dept_nm = String.valueOf(ht_cons.get("DEPT_NM")); // 지점명
	String cons_cau = String.valueOf(ht_cons.get("CONS_CAU")); // 구분
	String car_no = String.valueOf(ht_cons.get("CAR_NO")); // 차량번호
	String car_nm = String.valueOf(ht_cons.get("CAR_NM")); // 차명
	String acar_mng = String.valueOf(ht_cons.get("ACAR_MNG")); // 아마존카 담당자
	String acar_tel = String.valueOf(ht_cons.get("ACAR_TEL")); // 아마존카 담당자 연락처
	String off_nm = String.valueOf(ht_cons.get("OFF_NM")); // 탁송업체명
	String firm_nm = String.valueOf(ht_cons.get("FIRM_NM")); // 이용자 상호
	String firm_ssn = String.valueOf(ht_cons.get("FIRM_SSN")); // 이용자 사업자번호(생년월일)
	String firm_addr = String.valueOf(ht_cons.get("FIRM_ADDR")); // 이용자 주소
	String firm_tel = String.valueOf(ht_cons.get("FIRM_TEL")); // 이용자 전화
	String firm_m_tel = String.valueOf(ht_cons.get("FIRM_M_TEL")); // 이용자 H.P
	
	String cons_no_seq = cons_no.concat(seq);
	
	Hashtable ht_cons2 = cs_db.getConsignment_Links2(cons_no_seq);
	
	String off_drv = String.valueOf(ht_cons2.get("OFF_DRV"));
	String off_drv_tel = String.valueOf(ht_cons2.get("OFF_DRV_TEL"));
	
	String b_trf_yn = String.valueOf(ht_cons2.get("B_TRF_YN")); // 여부
	String client_st = String.valueOf(ht_cons2.get("CLIENT_ST")); // 고객 유형
	String ins_com_nm = String.valueOf(ht_cons2.get("INS_COM_NM")); // 채무자명
	String firm_zip = String.valueOf(ht_cons2.get("FIRM_ZIP")); // 우편번호
	String ins_req_amt = String.valueOf(ht_cons2.get("INS_REQ_AMT")); // 금액
	String ins_req_amt_han = String.valueOf(ht_cons2.get("INS_REQ_AMT_HAN")); // 금액 한글
	String accid_dt = String.valueOf(ht_cons2.get("ACCID_DT")); // 사고일자
	String ins_use_st = String.valueOf(ht_cons2.get("INS_USE_ST")); // 시작일
	String ins_use_et = String.valueOf(ht_cons2.get("INS_USE_ET")); // 종료일
	String ac_car_no = String.valueOf(ht_cons2.get("AC_CAR_NO")); // 사고차량번호
	String ac_car_nm = String.valueOf(ht_cons2.get("AC_CAR_NM")); // 사고차량명
	String client_nm = String.valueOf(ht_cons2.get("CLIENT_NM")); // 고객명
	
	
// 	System.out.println(ht_cons2.toString());
	
// 	System.out.println(Long.toString(System.currentTimeMillis()));
	
%>

<html lang='ko'>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>

</script>
</head>
<style>
body {
	margin-left: 0px;
	margin-top: 0px;
	
	font-size:0.8em; 
	text-align:center;
	font-family:nanumgothic;
	}
.style1 {
	font-size:25px;
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

.doc_a table {border:1px solid #000000; font-size:0.85em; width:100%;padding:20px 0; }
.doc_a table td.nor {padding:5px 5px 5px 5px;}
.doc_a table td.con {padding:0 10px 0 25px; line-height:10px;}

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

td{
	line-height:130%;
	letter-spacing: 1px;
	word-spacing: 1px;
	border:1px solid #000000;
	text-align: center;
	height: 10px;
}
.td-header {
	background-color:RGB(159,177,5);
	font-weight:bold;
	height: 10px;
}
</style>

<body onload="onloadData()">
<div class="a4" style="width:800px;">
<table style="margin:2% 2% 1% 2%; width: 95%;">
	<tr>
		<td style="width: 50%; text-align:center; font-size:30px; background-color:RGB(171,168,168); font-weight:bold;">자 동 차 <br><input type="checkbox" style="zoom:1.5;"/><span style="font-size:20px;">인도증 / </span><input type="checkbox" style="zoom:1.5;"/><span style="font-size:20px;">인수증</span></td>
		<td style="width: 50%; text-align:center; font-size:15px; background-color:RGB(159,177,5); color:white; font-weight:bold; ">Pick amazoncar! We'll pick you up.</td>
	</tr>
</table>

<table style="margin: 0% 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" style="width:10%">계약번호</td>
		<td style="width:20%"><%=rent_l_cd%></td>
		<td class="td-header" style="width:10%">지점명</td>
		<td style="width:20%"><%=dept_nm%></td>
		<td class="td-header" style="width:10%">구분</td>
		<td style="width:20%"><%=cons_cau%></td>
	</tr>
</table>
<table style="margin: 3px 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" style="width:10%">차량번호</td>
		<td style="width:12%"><%=car_no%></td>
		<td class="td-header" style="width:10%">차 명</td>
		<td style="width:30%"><%=car_nm%></td>
		<td class="td-header" style="width:10%">주행거리</td>
		<td style="width:20%%">출발<input type="text" style="width: 25%;"></input>km/도착<input type="text" style="width: 25%;"></input>km</td>
	</tr>
</table>

<table style="margin: 3px 2% 0% 2% ;width: 95%;">
	<tr>
		<td rowspan="15" colspan="6"><img src=/acar/images/deli_taking.jpg align=absmiddle style="width:500px; height:400px;"></td>
		<td style="" colspan="2">표시기호</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">파 손</td>
		<td style="width:15%">B</td>
	</tr>
		<td class="td-header" style="width:10%">상 처</td>
		<td style="width:15%">B</td>
	<tr>
		<td class="td-header" style="width:10%">휘 임</td>
		<td style="width:15%">B</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">이색(도장)</td>
		<td style="width:15%">B</td>
	</tr>
	<tr>
		<td style="" colspan="2">비치용품</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">등록증</td>
		<td style="width:15%"><input type="checkbox">Y <input type="checkbox">N</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">사용설명서</td>
		<td style="width:15%"><input type="checkbox">Y <input type="checkbox">N</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">리모컨</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">보조키</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">잭키</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">잭키레버</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">삼각대</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">공구</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">휠복스</td>
		<td style="width:15%"><input type="checkbox">N <input type="checkbox">1 <input type="checkbox">2</td>
	</tr>
	<tr>
		<td class="td-header" style="width:10%">연 료</td>
		<td colspan="2" style="width:25%"><input type="checkbox">Full<input type="checkbox">3/4<input type="checkbox">2/4<input type="checkbox">1/4<input type="checkbox">E</td>
		<td class="td-header" style="width:10%">귀중품 고지</td>
		<td colspan="2" style="width:20%"><input type="text" style="width:90%"></td>
		<td class="td-header" style="width:10%">기타</td>
		<td style=""></td>
	</tr>
</table>
<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" style="width:12%">안경보관함</td>
		<td class="td-header" style="width:12%">글로브박스</td>
		<td class="td-header" style="width:12%">컵홀더</td>
		<td class="td-header" style="width:12%">중앙콘솔박스</td>
		<td class="td-header" style="width:12%">맵박스</td>
		<td class="td-header" style="width:12%;font-size: 8pt;">뒷좌석콘솔박스</td>
		<td class="td-header" style="width:12%">뒷좌석맵박스</td>
		<td class="td-header" style="width:12%">트렁크</td>
	</tr>
	<tr>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
		<td><input type="checkbox"/>Y<input type="checkbox"/>N</td>
	</tr>
</table>
<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" style="width:15%">워셔액</td>
		<td class="td-header" style="width:23%">외관 청결정도</td>
		<td class="td-header" style="width:15%">타이어 공기압</td>
		<td class="td-header" style="width:23%">타이어 마모상태</td>
		<td class="td-header" style="width:23%">실내 청결정도</td>
	</tr>
	<tr>
		<td style="width:15%"><input type="checkbox"/>정상<input type="checkbox"/>보충</td>
		<td style="width:23%"><input type="checkbox"/>정상<input type="checkbox"/>보통<input type="checkbox"/>정비요</td>
		<td style="width:15%"><input type="checkbox"/>정상<input type="checkbox"/>정비요</td>
		<td style="width:23%"><input type="checkbox"/>정상<input type="checkbox"/>보통<input type="checkbox"/>교환</td>
		<td style="width:23%"><input type="checkbox"/>정상<input type="checkbox"/>보통<input type="checkbox"/>청소요</td>
	</tr>
	<tr>
		<td class="td-header" style="width:15%">기타 정비사항</td>
		<td colspan="4"></td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" rowspan="2" colspan="2" style="width:45%;">상기 기호표시 부위의 손상 상태 및 각종 용품의 이상유무를 확인하고 차량을 정히 인도함.</td>
		<td class="td-header">인도/인수 고객명</td>
		<td><input type="text" style="height:90%"></td>
	</tr>
	<tr>
		<td class="td-header">연락처</td>
		<td><input type="text" style="height:90%"></td>
	</tr>
	<tr>
		<td colspan="2"><span id="date"></span>(<input type="text" style="height:90%; width:10%;">시 <input type="text" style="height:90%; width:10%;"">분)</td>
		<td class="td-header">계약자와의 관계</td>
		<td><input type="text" style="height:90%"></td>
	</tr>
</table>
<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" style="width:10%">주의사항</td>
		<td style="width:90%; text-align:left">※ 상기 기호표시 부위 외 손상된 부위가 더 없는 지 확인하여 주십시오.<br>
											        ※ 사용 종료 후 반차 시 같은 방법으로 손상 부위 및 각종 용품의 이상유무를 확인하게 됩니다.<br>
											        ※ 손상된 부위가 추가, 확장되거나 용품 등을 분실한 경우 계약자에게 원상복귀 비용을 청구합니다.<br>
											   &nbsp;&nbsp; (단, 자기차량손해면책제도에 가입하신 경우에는 면책금 범위 내에서 청구합니다. -용품은 제외)</td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td class="td-header" colspan="5">계약자(이용자)</td>
		<td class="td-header" colspan="5">(주)아마존카</td>
	</tr>
	<tr>
		<td class="td-header" colspan="2">상호/성명</td>
		<td colspan="3"><%=firm_nm%></td>
		<td class="td-header" rowspan="2">담당자</td>
		<td class="td-header">성명</td>
		<td colspan="3"><%=acar_mng%></td>
	</tr>
	<tr>
		<td class="td-header" colspan="2">사업자번호/생년월일</td>
		<td colspan="3" style="width:30%"><%=AddUtil.ChangeEnt_no(firm_ssn)%></td>
		<td class="td-header">연락처</td>
		<td colspan="3"><%=acar_tel%></td>
	</tr>
	<tr>
		<td class="td-header" style="width:20%" colspan="2">주 소</td>
		<td colspan="3" style="width:40%;" class="firm_addr"><%=firm_addr%></td>
		<td class="td-header" rowspan="3">배달탁송</td>
		<td class="td-header">상호</td>
		<td colspan="3"><%=off_nm%></td>
	</tr>
	<tr>
		<td class="td-header" colspan="2">전 화</td>
		<td colspan="3"><%=firm_tel%></td>
		<td class="td-header">성명</td>
		<td colspan="3"><%=off_drv%></td>
	</tr>	
	<tr>
		<td class="td-header" colspan="2">운전자/H.P</td>
		<td colspan="3"><%=firm_m_tel%></td>
		<td class="td-header">연락처</td>
		<td colspan="3"><%=off_drv_tel%></td>
	</tr>	
</table>
<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="width:50%; border-left: 0px;border-top: 0px;border-bottom: 0px;;"><img src=/acar/images/logo_1.png align=right style=""></td>
		<td style="width:50%; border:0px; text-align:left; font-weight:bold; font-size:11px;">&nbsp;<span style="font-size:20px">(주)아마존카</span><br>
														   &nbsp;주 소 : 서울시 영등포구 의사당대로 8 삼환까뮤빌딩 8층<br>
														   &nbsp;TEL : 02)392-4242(고객지원팀)<br>
														   &nbsp;FAX : 02)782-0826(고객지원팀)<br>
														   &nbsp;http://www.amazoncar.co.kr
		</td>
	</tr>
</table>
<p style="page-break-before: always;">
<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td><img src=/acar/images/left-front.png align=center style="height:355px"></td>
		<td><img src=/acar/images/front.png align=center style="height:355px"></td>
		<td><img src=/acar/images/right-front.png align=center style="height:355px"></td>
	</tr>
	<tr>
		<td><img src=/acar/images/left.png align=center style="height:355px"></td>
		<td><img src=/acar/images/center.png align=center style="height:355px"></td>
		<td><img src=/acar/images/right.png align=center style="height:355px"></td>
	</tr>
	<tr>
		<td><img src=/acar/images/left-back.png align=center style="height:355px"></td>
		<td><img src=/acar/images/back.png align=center style="height:355px"></td>
		<td><img src=/acar/images/right-back.png align=center style="height:355px"></td>
	</tr>
</table>
<%if(b_trf_yn.equals("Y")){ %>
<p style="page-break-before: always;">
<table style="margin: 3% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:30px;font-weight:bold;padding:2% 0% 2% 0%;">채권 양도 통지서 및 위임장</td>
	</tr>
</table>
<table style="margin: 5% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:20%">수신처(채무자)</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:80%"><%=ins_com_nm%> 귀하</td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:20%" rowspan="2">발신자(채권자)</td>
		<td style="font-size:15px;padding:2% 0% 2% 0% 0% 2% 0%;width:10%;">성명/상호</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%"><%=firm_nm%></td>
	</tr>
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">주소</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%">(<%=firm_zip%>) <%=firm_addr%> 
																	<%if(!client_st.equals("2")){ %>
																	<%=firm_nm%> 대표 : 
																	 <%} %>
																	<%=client_nm%></td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:20%" rowspan="2">채권의 내용</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">종류</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%">아래 사고 차량 수리기간 동안의 대차료(보험금)</td>
	</tr>
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">금액</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%"><%=ins_req_amt_han%>원 (&#92;<%=AddUtil.parseDecimal(ins_req_amt)%>)</td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:20%" rowspan="2">사고차량</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">차량번호</td>
		<td style="font-size:13px;padding:2% 0% 2% 0%; width:10%"><%=ac_car_no%></td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">사고일자</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:50%"><%=AddUtil.ChangeDate2(accid_dt)%></td>
	</tr>
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">차명</td>
		<td style="font-size:13px;padding:2% 0% 2% 0%; width:10%"><%=ac_car_nm%></td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">수리기간</td>
		<td style="font-size:13px;padding:2% 0% 2% 0%; width:50%"><%=AddUtil.ChangeDate3(ins_use_st) %> ~ <%=AddUtil.ChangeDate3(ins_use_et)%></td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:20%" rowspan="2">양도할 내용</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">내역</td>
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:70%">(주)아마존카에서 받은 사고대차 차량의 대차료(보험금) 채권 전액의 청구 및 수령의 권한 및 권리</td>
	</tr>
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">금액</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:70%">일금 <%=ins_req_amt_han%> 원정 (&#92;<%=AddUtil.parseDecimal(ins_req_amt) %>)</td>
	</tr>
</table>

<table style="margin: 5% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:15px; text-align:left; border:0px; line-height:200%;">상기 채권자 본인(아래 양도인)은 아래 양수인 (주)아마존카에게 상기 대차료(보험금)채권의 청구 및 수령의 권한 및 권리를 정상적으로 확정적으로 양도 및 승낙하였음을 통지합니다.</td>
	</tr>
</table>

<table style="margin: 5% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:15px; border:0px;" id="date2"></td>
	</tr>
</table>

<table style="margin: 2% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%" rowspan="2">양도인</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">성명</td>
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:40%"><%if(!client_st.equals("2")){ %>
																	<%=firm_nm%> 대표 : 
																	 <%} %>
																	 <%=client_nm%> &nbsp;&nbsp;&nbsp;(인)</td>
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:20%"><%if(client_st.equals("2")){%>생년월일<%}else{%>사업자등록번호<%}%></td>
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:20%"><%=AddUtil.ChangeEnt_no(firm_ssn)%></td>
	</tr>
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">주소</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%;" colspan="3" >(<%=firm_zip%>) <%=firm_addr%></td>
	</tr>
</table>
<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%" rowspan="2">양수인</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">성명</td>
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:40%;">주식회사 아마존카 <span style="z-index: 2;position: absolute;">&nbsp;&nbsp;&nbsp;(인)</span><img src='/acar/images/3c7kR522I6Sqs_70.gif' style="position: absolute;margin-left: 15px;margin-top: -18px;z-index:1;"></td>
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:20%">법인등록번호</td>
		<td style="font-size:16px;padding:0% 0% 0% 0%; width:20%">115611-0019610</td>
	</tr>
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; width:10%">주소</td>
		<td style="font-size:16px;padding:2% 0% 2% 0%;" colspan="3" >(07236) 서울시 영등포구 의사당대로 8 삼환까뮤빌딩 8층</td>
	</tr>
</table>

<table style="margin: 1% 2% 0% 2% ;width: 95%;">
	<tr>
		<td style="font-size:16px;padding:2% 0% 2% 0%; text-align:left; border:0px">※ 보험사와의 과실 비용 협의를 위함이고, 고객 비용 부담은 없는 사항입니다.</td>
	</tr>
</table>
<%} %>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='javascript'>
	function onloadData() {
		
		var today = new Date();
		
		var year = today.getFullYear();
		var month = today.getMonth() + 1;
		var date = today.getDate();
		var day = today.getDay();
		
		var yyyymmdd = year + "년 " + month + "월 " + date + "일";

		$("#date").text(yyyymmdd+" ");
		$("#date2").text(yyyymmdd);
		
		
	}
	

</script>
</body>
</html>


