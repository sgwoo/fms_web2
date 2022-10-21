<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*, acar.cont.* "%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	String var1 = request.getParameter("var1")==null?"":request.getParameter("var1");
	String var2 = request.getParameter("var2")==null?"":request.getParameter("var2");	
	String var3 = request.getParameter("var3")==null?"":request.getParameter("var3");
	String var4 = request.getParameter("var4")==null?"":request.getParameter("var4");	
	String var5 = request.getParameter("var5")==null?"":request.getParameter("var5");
	String var6 = request.getParameter("var6")==null?"":request.getParameter("var6");
	
	String mail_yn = "";
	
	if(rent_l_cd.equals("") && !var2.equals("")){
		mail_yn = "Y";
		rent_l_cd = var2;		
		rent_mng_id = var4;
		rent_st = var6;		
	}	
	
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<style>
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    background-color: #ddd;
    font-family: "맑은 고딕", Malgun Gothic, "굴림", gulim,"돋움", dotum, arial, helvetica, sans-serif;
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    min-height: 297mm;
    padding: 10mm; /* set contents area */
    margin: 10mm auto;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 20px;
   /*  border: 1px #888 solid ; */
    height: 273mm;
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
        height: 297mm;
        background: #fff;
    }
    .paper {
        margin: 0;
        border: initial;
        border-radius: initial;
        width: initial;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
   
}
	/* #contents {font-size:9pt}; */
 table {
     border: 2px solid #444444;
    border-collapse: collapse; 
  }
  th, td {
    border: 1px solid #444444;
    font-weight:bold;
    font-size:9pt;
  }
.title{text-align:center;background-color: aliceblue;}  
.contents {font-size:10pt;}
.contents tr{ height:30px;}
#wrap{ font-family: 'Malgun Gothic'; vertical-align: middle; font-weight:bold;}
	
</style>
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
    <div class="paper">
    <div class="content">
    
	<div id="wrap" style="width:100%;">
		<div>
			<img  style="position:relative;top:20;left:0;" src="/acar/images/logo_1.png" border="0" width="130" >
			<div style="text-align:center;margin-bottom:5px;font-size:17pt;">
				자동차 보험 관련 특약 약정서
			</div>
		</div>
		<div style="text-align:center;font-size:10pt;margin-bottom:10px;font-weight:normal;">( 고객이 피보험자인 경우에만 작성 )</div>
		<div style="text-align:right;font-size:9pt;margin-bottom:10px;">자동차 대여이용 계약서 일련번호:__________________________</div>
			<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents">
				<tr>
					<td class='title' style="border-right:2px solid #444444;border-bottom:2px solid #444444;">항<span style="margin:15px;"></span>목</td>
					<td colspan="4" class='title' style="border-bottom:2px solid #444444;">적&nbsp;용&nbsp;내&nbsp;용</td>
					<td class='title' style="border-bottom:2px solid #444444;">비<span style="margin:15px;"></span>고</td>
				</tr>
				<tr>
					<td class='title' style="border-right:2px solid #444444;">피보험자(임차인)</td>
					<td colspan="4" align='center'><input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"></td>
					<td align='center' style="font-size:9pt;">개인사업자는 대표자가 피보험자</td>
				</tr>
				 <tr>
					<td class='title' style="border-right:2px solid #444444;">보험계약자</td>
					<td colspan="4" align='center' style="font-size:12pt;">(주)아마존카</td>
					<td align='center' >
						<input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;">
					</td>
				</tr> 
				<tr>
					<td rowspan="2" class='title' style="border-right:2px solid #444444;">운전자범위</td>
					<td colspan="2" align='center'>법인고객</td>
					<td colspan="2">
						&nbsp;※ 법인 임직원 한정운전특약<br>
						<input type="checkbox" name="">가입
						<span style="margin:10px;"></span>
						<input type="checkbox" name="">미가입
					</td>
					<td rowspan="5"  style="font-size:9pt;padding-bottom:40px;padding-left:10px;">
					※&nbsp;자동차 대여이용 계약상<br>
						<span style="margin:6px;"></span>운전자범위<br>
						1. 법인 임직원 한정운전 특약<br>
						<span style="margin:6px;"></span>가입시 법인 임직원만 운전가능<br>
						2. 법인 임직원 한정운전 특약<br>
						<span style="margin:6px;"></span>미가입한 법인고객과 개인 및 <br>
						<span style="margin:6px;"></span>개인사업자 고객의 경우:<br>
						<span style="margin:6px;"></span>[계약자]<br>
						<span style="margin:6px;"></span>[계약자의 임직원/가족]<br>
						<span style="margin:6px;"></span>[계약자 임직원의 가족]<br>				
					</td>
				</tr>
				 <tr>
					<td colspan="2" align='center'>개인/<br>개인사업자<br>고객</td>
					<td colspan="2">
						<input type="checkbox" name="">기명피보험자 1인 한정<br>
						<input type="checkbox" name="">부부운전자 한정<br>
						<input type="checkbox" name="">기타(범위 기재:<span style="margin-left:170px;"></span>)
					</td>
				</tr> 
			 	<tr>
					<td class='title' style="border-right:2px solid #444444;">운전자연령</td>
					<td colspan="4" >
						<input type="checkbox" name=""> 만 26세이상
						<span style="margin:6px;"></span>
						<input type="checkbox" name=""> 만 35세이상
						<span style="margin:6px;"></span>
						<input type="checkbox" name=""> 기타 만(<span style="margin:15px;"></span>)세이상
					</td>
				</tr>
				<tr>
					<td class='title' style="border-right:2px solid #444444;">대물보험</td>
					<td colspan="4" >
						<input type="checkbox" name=""> 1억원
						<span style="margin:23px;"></span>
						<input type="checkbox" name=""> 2억원
						<span style="margin:24px;"></span>
						<input type="checkbox" name=""> 기타 (<span style="margin:15px;"></span>)원
					</td>
				</tr>
				<tr>
					<td class='title' style="border-right:2px solid #444444;">자기차량손해</td>
					<td colspan="4">
						<input type="checkbox" name=""> 물적사고할증금액 200만원  <span style="margin:19px;"></span><input type="checkbox" name=""> 기타<br>
						<span style="margin:12px;"></span>자기부담금은 손해액의 20%<br>
						<span style="margin:12px;"></span>(최소20만원~최대 50만원)
					</td>
				</tr>
				<tr>
					<td class='title' style="border-right:2px solid #444444;">년간보험료</td>
					<td align='center' colspan="4">
						<div style="float:left;width:90%;text-align: right;"><%=AddUtil.parseDecimal(fee.getIns_total_amt())%></div>
						<div style="float:left;width:10%;">원</div></td>
					<td align='center'><input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"></td>
				</tr> 
				<tr>
					<td width="100" class='title' rowspan="6" style="border-right:2px solid #444444;">적용월대여료</td>
					<td width="20" align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td width="50" align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td width="140" align='center' class='title'>보험미포함 월대여료</td>
					<td width="160" align='center'>
						<div style="float:left;width:75%;text-align: right;"><%=AddUtil.parseDecimal(fee.getInv_s_amt())%></div> 
						<div style="float:left;width:25%">원</div>
					</td>
					<td align='center'><input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"></td>
				</tr>
				 <tr>
				 	<td align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td align='center' class='title'>월보험료</td>
					<td align='center'>
						<div style="float:left;width:75%;text-align: right;"><%=AddUtil.parseDecimal(fee.getIns_s_amt())%></div>
						<div style="float:left;width:25%">원</div>
					</td>
					<td align='center' style="font-size:9pt;">년간보험료÷12</td>
				</tr>
				
				<tr>
					<td align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td colspan="2" align='center' class='title'>보험료포함 월대여료(공급가)</td>
					<td align='center' style="background-color: aliceblue;">
						<div style="float:left;width:75%;text-align: right;"><%=AddUtil.parseDecimal(fee.getFee_s_amt())%></div> 
						<div style="float:left;width:25%">원</div>
					</td>
					<td rowspan="3" align='center' style="font-size:9pt;">
						자동차 대여이용<br>계약서 기재사항과 동일
					</td>
				</tr>
				<tr>
					<td align='center' class='title' style="border-bottom-style: hidden;"></td>
					<td colspan="2" align='center' class='title'>부가세</td>
					<td align='center' style="background-color: aliceblue;">
						<div style="float:left;width:75%;text-align: right;"><%=AddUtil.parseDecimal(fee.getFee_v_amt())%></div>
						<div style="float:left;width:25%">원</div>
					
					</td>
				</tr>
				 <tr>
					<td colspan="3" align='center' class='title' >합계</td>
					<td align='center' style="background-color: aliceblue;">
						<div style="float:left;width:75%;text-align: right;"><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%></div>
						<div style="float:left;width:25%">원</div> 
					</td>
				</tr> 
				 <tr>
					<td colspan="4" style="height:70;text-align:left;" class='title' >
						<span style="padding:30px;">※1. 보험갱신시에는 보험료포함 월대여료도 조정됩니다.</span><br> 
						<span style="padding:30px;">※2. 중도해지 위약금 산출시 대여료 기준은 [보험료포함]</span><br> 
						<span style="padding:55px;text-align:left">월대여료(공급가)입니다.</span> 
					</td>
					<td align='center'>
						<input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"><br>
						<input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"><br>
						<input type="text" style="border:0px;text-align:center;width:80%;font-size:9pt;font-weight:bold;"><br>
					</td>
				</tr>
				<tr>
					<td class='title' style="height:40;border-right:2px solid #444444;" >질권 설정 및<br>청구 권한 위임</td>
					<td colspan="5" style="padding-left:10px;padding-right:10px;"><span>자기차량 손해 보험금에 대해서는 (주)아마존카를 질권자로 설정하고. (주)아마존카에 질권청구권한을 위임한다.</span></td>
				</tr>
				
			 <tr style="height:50;">
					<td class='title' style="border-right:2px solid #444444;">특이 사항</td>
					<td colspan="5" align='center'>
						<input type="text" style="border:0px;text-align:center;width:90%;font-size:9pt;font-weight:bold;"><br>
						<input type="text" style="border:0px;text-align:center;width:90%;font-size:9pt;font-weight:bold;"><br>
				  </td>
			</tr> 
		</table>
		<br>
		<div align="center" >
			<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents">
				<tr>
					<td colspan="2" align="center"><span style="font-size:13pt;font-weight: normal;">약 &nbsp;&nbsp;정&nbsp;&nbsp;일  : 20 &nbsp;&nbsp;&nbsp;&nbsp; 년&nbsp;&nbsp; &nbsp;&nbsp; 월 &nbsp;&nbsp;&nbsp;&nbsp; 일</span></td>
				</tr>
				<tr style="border-bottom-style:hidden;height:70;">
					<td width="50%" style="padding-left:10px;padding-top:10px;">
					<span style="font-size:11pt;">대여제공자(임대인)</span><br>
					<span style="font-size:9pt;"> &nbsp;&nbsp;서울시 영등포구 의사당대로 8,</span><br>
					<span style="font-size:9pt;"> &nbsp;&nbsp;802호(여의도동, 태흥빌딩)</span>
					</td>
					<td width="50%" style="padding-left:20px;padding-bottom: 10px;">
						<span style="font-size:11pt;">대여제공자(임차인)</span><br>
						<span style="font-size:9pt;"> &nbsp;&nbsp;본 특약 내용을 확인하고 약정함.</span>
					</td>
				</tr>
				<tr style="border-bottom-style: hidden;">
					<td ></td>
					<td ></td>
				</tr>
				<tr style="border-bottom-style: hidden;">
					<td style="font-size:13pt;padding-left:10px">(주)아마존카</td>
					<td ></td>
				</tr>
				<tr>
					<td style="border-bottom-style: hidden;">
						<div style="width:20%;text-align:right;font-size:10pt;margin-top: 5px;font-weight: normal;float:left">대표이사</div>
						<div style="width:70%;text-align:center;font-size:15pt;float:left">조<span style="margin-left:35px;"></span>성<span style="margin-left:35px;"></span>희
						</div>
					</td>
					<td align="center" style="border-bottom-style:hidden;font-weight: normal;">
						<span>__________________________________________________인</span>
					</td>
				</tr>
				<tr style="height: 15px;">
					<td></td>
					<td></td>
				</tr>
			</table>
			<div style="text-align:right;font-size:10pt;font-weight: normal;">
				<span>양식 개정일자 : 2018년 3월</span>
			</div>
			<div id="Layer1" style="position:absolute; left:285px; top:980px; width:109px; height:108px; z-index:1"><img src="/acar/images/stamp.png" width="80" height="81"></div>
			
		</div>
		<%
			
		%>
	</div>
	</div>
	</div>
</form>
</body>
<script>
function onprint(){
	//factory.printing.header 	= ""; //폐이지상단 인쇄
	//factory.printing.footer 	= ""; //폐이지하단 인쇄
/* 	factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin 	= 12.0; //좌측여백   
	factory.printing.rightMargin 	= 12.0; //우측여백
	factory.printing.topMargin 	= 30.0; //상단여백    
	factory.printing.bottomMargin 	= 30.0; //하단여백
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임	
 */}
<%if(!mail_yn.equals("Y")){%>
 window.print();
<%}%>
</script>
</head>
</html>