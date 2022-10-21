<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_mst.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	// 계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	// 차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	// 자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
			
	// amazoncar
	Hashtable br = new Hashtable();		
	br = c_db.getBranch("S1");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <title>FMS</title>
    <!-- <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link> -->
  <!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script> -->
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script> -->
<style>
.mid{
	font-size:11px;
	padding-left:30px;
	letter-spacing: 1px;
}
.mid2{
	font-size:11px;
	padding-left:60px;
	letter-spacing: 1px;
}
.mid3{
	font-size:12px;
	padding-left:30px;
	letter-spacing: 1.5px;
}
table{
	table-layout: fixed;
	border-collapse:collapse;
}
.cus_td{
	border-top:1px solid #000;
	border-bottom:1px solid #000;
	background-color:#CCC;
}
.cus_left_td{
	border-top:1px solid #000;
	border-right:1px solid #000;
	border-bottom:1px solid #000;
}
.top_bot_line{
    border-top: 1px solid #000;
    border-bottom: 1px solid #000;
}
.bottom_txt{
	font-size:11px;
	padding-left:5px;
	letter-spacing: 0.5px;
}
.bottom_txt2{
	font-size:11px;
	padding-left:20px;
	letter-spacing: 0.5px;
}
.font_txt09 {
	font-size:9px;
}
.font_txt10 {
	font-size:10px;
}
.font_txt11 {
	font-size:11px;
}
.font_txt12 {
	font-size:12px;
}
.font_txt13 {
	font-size:13px;
}
</style>
<style type="text/css" media="print">
    @page {
        size:  auto;
        margin: 4mm 0mm 0mm 0mm;
    }
    html {
        /* background-color: #FFF; */
        margin: 0px;
    }
    body {
    	-webkit-print-color-adjust: exact; 
    	-ms-print-color-adjust: exact; 
    	color-adjust: exact;
    	/* transform: scale(.9); */    	
        /* margin으로 프린트 여백 조정 */
        /* IE */
        margin: 0mm 0mm 0mm 0mm;
        
        /* CHROME */
        -webkit-margin-before: 8mm; /*상단*/
		-webkit-margin-end: 0mm; /*우측*/
		-webkit-margin-after: 0mm; /*하단*/
		-webkit-margin-start: 0mm; /*좌측*/
    }
</style>
<script language="JavaScript" type="text/JavaScript">
	function ieprint() {
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 10.0; //좌측여백   
		factory.printing.rightMargin 	= 10.0; //우측여백
		factory.printing.topMargin 	= 5.0; //상단여백    
		factory.printing.bottomMargin 	= 5.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}
	
	function onprint() {
		var userAgent=navigator.userAgent.toLowerCase();
		
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			ieprint();
		}
	}
</script>
</head>
<body onLoad="javascript:onprint();" style="width: 820px;">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<table style="margin-left: 20px; margin-right: 20px;">
	<tr><td colspan="7" style="height:0.5cm;"></td></tr>
	<tr>
		<td colspan="7" class="font_txt11">■ 자동차등록규칙 [별지 제15호서식] <font color="blue">&#60;개정 2017. 10. 26.&#62;</font></td>
	</tr>
	<tr><td colspan="7" style="height:0.3cm;"></td></tr>
	<tr>
		<td colspan="7" style="text-align:center; font-weight:bold;"><font size="5">자동차양도증명서(양도인 · 양수인 직접 거래용)</font></td>
	</tr>
	<tr><td colspan="7" style="height:0.4cm;"></td></tr>
	<tr>
		<td class=" font_txt12" colspan="7" style="width:778px; height:30px; text-align:left; vertical-align:top;">			
			<div style="overflow: hidden;">
				<div class="cus_td font_txt12" style="width: 388px; height:30px; float: left; padding-top: 1px;">
					&nbsp;접수번호
				</div>
				<div class="cus_td font_txt12" style="width: 388px; height:30px; float: left; padding-top: 1px; border-left:1px solid black;">
					&nbsp;접수일자
				</div>
			</div>
		</td>
		<!-- <td class=" font_txt12" colspan="5" style="height:30px;text-align:left;vertical-align:top;">
			
		</td> -->
	</tr>
	<tr>
		<td colspan="7" style="height:0.05cm;"></td>
	</tr>
	<tr>
		<td colspan="7" style="width:778px;">
			<div class="top_bot_line" style="overflow: hidden; height: 75px;">
				<div class="font_txt13" style="float: left; width: 100px; height: 75px; text-align: center; padding-top: 16px; border-right: 1px solid #000;">갑<br>(양도인)</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; vertical-align: middle; line-height: 25px;">&nbsp;성명(명칭)&nbsp;&nbsp;(주)아마존카</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;주민(법인)등록번호&nbsp;&nbsp;115611-0019610</div>
				<div class="font_txt12" style="float: left; width: 676px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;전화번호&nbsp;&nbsp;<%=br.get("TEL")%></div>
				<div class="font_txt12" style="float: left; width: 676px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;주소&nbsp;&nbsp;<%=br.get("BR_ADDR")%></div>
			</div>
			<div class="top_bot_line" style="overflow: hidden; height: 75px; margin-top: 2px;">
				<div class="font_txt13" style="float: left; width: 100px; height: 75px; text-align: center; padding-top: 16px; border-right: 1px solid #000;">을<br>(양수인)</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; line-height: 25px;">&nbsp;성명(명칭)</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;주민(법인)등록번호</div>
				<div class="font_txt12" style="float: left; width: 676px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;전화번호</div>
				<div class="font_txt12" style="float: left; width: 676px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;주소</div>
			</div>
			<div class="top_bot_line" style="overflow: hidden; height: 100px; margin-top: 2px;">
				<div class="font_txt13" style="float: left; width: 100px; height: 100px; text-align: center; padding-top: 42px; border-right: 1px solid #000;">거래내용</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; vertical-align: middle; line-height: 25px;">&nbsp;자동차등록번호&nbsp;&nbsp;<%=cr_bean.getCar_no()%></div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;차종 및 차명&nbsp;&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;차대번호&nbsp;&nbsp;<%=cr_bean.getCar_num()%></div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;매매일</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;매매금액</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;잔금지급일</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; line-height: 25px;">&nbsp;자동차인도일</div>
				<div class="font_txt12" style="float: left; width: 338px; height: 25px; border-top: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; line-height: 25px;">&nbsp;주행거리<div style="float: right; line-height: 20px; margin-right: 30px;">&nbsp;km</div></div>
			</div>
		</td>
	</tr>
	
	<tr><td colspan="7" height="10"></td></tr>
	<tr>
		<td colspan="7">
			<span class="mid">제1조(당사자표시) 양도인을 "갑"이라 하고, 양수인을 "을"이라 한다.</span><br>
			<span class="mid">제2조(동시이행 등) "갑"은 잔금 수령과 상환으로 자동차와 소유권이전등록에 필요한 서류를 "을"에게 인도한다.</span><br>
			<span class="mid">제3조(공과금부담) 이 자동차에 대한 제세공과금은 자동차 인도일을 기준으로 하여, 그 기준일까지의 분은 "갑"이 부담하고, 기</span><br>
			<span class="mid2">준일 다음 날부터의 분은 "을"이 부담한다. 다만, 관계 법령에 제세공과금의 납부에 관하여 특별한 규정이 있는 경우에는</span><br>
			<span class="mid2">그에 따른다.</span><br>
			<span class="mid">제4조(사고책임) "을"은 이 자동차를 인수한 때부터 발생하는 모든 사고에 대하여 자기를 위하여 운행하는 자로서의 책임을 진다.</span><br>
			<span class="mid">제5조(법률상의 하자책임) 자동차인도일 이전에 발생한 행정처분 또는 이전등록 요건의 불비, 그 밖에 행정상의 하자에 대해서는</span><br>
			<span class="mid2">"갑"이 그 책임을 진다.</span><br>
			<span class="mid" style="letter-spacing: 0px;">제6조(등록 지체 책임) "을"이 매매목적물을 인수한 후 정해진 기간에 이전등록을 하지 않을 때에는 이에 대한 모든 책임을 "을"이 진다.</span><br>
			<span class="mid">제7조(할부승계특약) "갑"이 자동차를 할부로 구입하여 할부금을 다 내지 않은 상태에서 "을"에게 양도하는 경우에는 나머지 할</span><br>
			<span class="mid2">부금을 "을"이 승계하여 부담할 것인지의 여부를 특약사항란에 적어야 한다.</span><br>
			<span class="mid">제8조(양도증명서) 이 양도증명서는 2통을 작성하여 "갑"과 "을"이 각각 1통씩 지니고 "을"은 이 증명서를 소유권과 이전등록 신</span><br>
			<span class="mid2">청을 할 때(잔금지급일부터 15일 이내)에 등록관청에 제출해야 한다.</span>
		</td>
	</tr>
	<tr>
		<td colspan="7" height="10"></td>
	</tr>
	
	<tr>
		<td colspan="5" class="mid" style="vertical-align: top;">특약사항:</td>
		<td colspan="2">
			<table style="width: 150px;" align="right">
				<tr>
					<td class="font_txt11" style="height:30px; border:1px solid black; text-align:center;">수입인지</td>
				</tr>
				<tr>
					<td class="font_txt11" style="height:80px; border:1px solid black; text-align:center;">「인지세법」에 따름<br>(뒷면 여백에 붙임)</td>
				</tr>
			</table>			
		</td>
	</tr>
	
	<tr>
		<td colspan="7" height="10"></td>
	</tr>
	<tr>
		<td colspan="7">
			<span class="mid3" style="word-spacing: 2px; letter-spacing: 2px;">본인은 자동차매매사업자의 중개를 통하지 않고 양수인과 직접 거래로 소유자동차를 양도하고, 그 사실을</span><br>
			<span class="mid3">증명하기 위하여 「자동차등록규칙」 제33조제2항제1호에 따라 이 양도증명서를 작성하여 발급합니다.</span>
		</td>
	</tr>
	<tr>
		<td colspan="7" class="mid3" style="text-align:right;">
			<span style="padding-right:20px">
				년&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				월&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일
			</span>
		</td>
	</tr>
	<tr><td colspan="7"></td></tr>
	<tr>
		<td colspan="7" class="font_txt12">
			<span style="padding-left:30px;padding-right:30px;">양도인</span>(주)아마존카
			<span style="padding-left:230px;">양수인</span>
		</td>
	</tr>
	<tr>
		<td colspan="5" style="border-bottom:1px solid;">
			<span style="font-size:11px;vertical-align:top;padding-left:310px; color: #737272">(서명 또는 인)</span>
		</td>
		<td colspan="2" style="border-bottom:1px solid; text-align: right;">
			<span style="font-size:11px;vertical-align:top; color: #737272; padding-right: 10px;">(서명 또는 인)</span>
		</td>
	</tr>
	<tr><td colspan="7" height="7" style="border-top: 3px solid #000; border-bottom: 3px solid #000;"></td></tr>
	<tr>
		<td class="cus_td" colspan="7" style="text-align:center;">유의사항</td>
	</tr>
	<tr>
		<td colspan="7" height="10"></td>
	</tr>
	<tr>
		<td colspan="7">
			<span class="bottom_txt">1. 양도인 주의사항: 이 양도증명서를 작성할 때 양수인의 인적사항을 적지 않으면 양수인의 무단전매 등으로 예측할 수 없는 손해를 볼 수</span><br>
			<span class="bottom_txt2">있으니 반드시 양수인의 인적사항을 적으시기 바랍니다.</span><br>
			<span class="bottom_txt">2. 양수인 주의사항: 이 양도증명서를 작성할 때 이 차량에 대하여 부과된 자동차세 및 제세공과금 납부와 압류 · 저당권 등의 등록 여부를</span><br>
			<span class="bottom_txt2">확인하여 뜻하지 않은 손해를 입지 않도록 하시기 바랍니다.</span><br>
			<span class="bottom_txt">3. 공통사항: 이 당사자거래용 양도증명서를 직접거래 당사자가 아닌 자(자동차매매업자 포함)가 사용할 때에는 자동차관리법령에 따라 처벌</span><br>
			<span class="bottom_txt2">을 받게 됩니다.</span><br>
			<span class="bottom_txt">4. 정당한 사유 없이 주행거리를 변경한 자는 「자동차관리법」 제71조제2항 및 제79조제5호에 따라 징역 또는 벌금에 처해집니다.</span><br>
			<span class="bottom_txt">5. 자동차정비, 검사, 주행거리 이력, 자동차세 납부여부와 압류내역 등 자동차토탈이력정보는 국토교통부에서 제공하는 스마트폰용 어플("</span><br>
			<span class="bottom_txt2">마이카정보") 또는 자동차민원대국민포털(www.ecar.go.kr)에서 조회가 가능하므로 확인 바랍니다. </span><br>
			<span class="bottom_txt">6. 양도인이 서명한 경우에는 본인서명사실확인서 또는 전자본인서명확인서 발급증을, 양도인이 납인한 경우에는 인감증명서를 첨부하여야 합</span><br>
			<span class="bottom_txt2">니다.</span>
		</td>
	</tr>
</table>
</body>

</html>