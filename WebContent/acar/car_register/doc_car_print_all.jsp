<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.master_car.*, acar.car_register.*" %>	
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	
	//String ch_cd 	= request.getParameter("ch_cd")==null?"":request.getParameter("ch_cd");
	
	//ch_cd=AddUtil.substring(ch_cd, ch_cd.length() -1);
	
	String vid[] = request.getParameterValues("ch_cd");
	
	String c_id = "";
	
	int vt_size = vid.length;

	for(int i=0;i < vt_size;i++){

	c_id = vid[i];
	
	c_id = c_id.substring(0,6);
	
	//정비정보
	Hashtable  h_bean = mc_db.getCarReqMaintInfo(c_id);
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title> 자동차 검사 신청서</title>
<style>
@page a4sheet { size: 21.0cm 29.7cm }
.a4 { page: a4sheet; page-break-after: always; margin:0; }
</style>
<STYLE>
<!--
* {line-height:120%; font-size:10pt; font-family:돋움;}

.f1{font-size:20pt; font-weight:bold; line-height:150%;}
.f2{font-size:13pt; line-height:180%; font-weight:bold;}
.f3{font-size:8.5pt;}
.f4{font-size:11pt;}

.t1 table{border-top:1px solid #000000; border-bottom:1px solid #000000;}
.t1 table td{border-right:1px solid #000000;}
.t1 table td.n1{border-right:0px;}
.t1 table td.n1 table{border:0px;}
.t1 table td.n1 table td{border-right:0px;}

.t2 table{border-top:2px solid #000000; border-bottom:1px solid #000000;}
.t2 table td{border-left:1px solid #000000; border-bottom:1px solid #000000;}
.t2 table td.n1{border-left:0px;}

.t3 table {border:0px;}
.t3 table td {border:0px;}
.t3 table td.n1 {border-right:0px;}

.t4 {border:0px;}

@media print {
	html, body {
		width: 210mm;
		height: 297mm;  
		margin:0;
		padding:0;      
	}
-->
</STYLE>	
<script>

window.onbeforeprint = function(){
	//setCookie();
};

function setCookie(cName, cValue, cMinutes){

 	var expire = new Date();
    expire.setDate(expire.getMinutes() + cMinutes);
    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr';
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
    
}

// 쿠키 가져오기
function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}

setCookie('tmp_waste', 'delete', 1);

</script>

<!-- <SCRIPT>
	function Installed(){
		try{	return (new ActiveXObject('IEPageSetupX.IEPageSetup'));	}
		catch (e){	return false;	}
	}

	function PrintTest(){
		if (!Installed()){
			alert("컨트롤이 설치되지 않았습니다. 정상적으로 인쇄되지 않을 수 있습니다.")
			return false;
		}else{
			alert("정상적으로 설치되었습니다.");
			alert("기본프린트 : "+IEPageSetupX.GetDefaultPrinter());
		}	
	}
</SCRIPT> -->
<!-- <SCRIPT language="JavaScript" for="IEPageSetupX" event="OnError(ErrCode, ErrMsg)">
	alert('에러 코드: ' + ErrCode + "\n에러 메시지: " + ErrMsg);
</SCRIPT> -->
</head>
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="./IEPageSetupX.cab#version=1,4,0,3" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
	<div style="position:absolute;top:276;left:320;width:300;height:68;border:solid 1 #99B3A0;background:#D8D7C4;overflow:hidden;z-index:1;visibility:visible;"><FONT style='font-family: "굴림", "Verdana"; font-size: 9pt; font-style: normal;'>
	<BR>  인쇄 여백제어 컨트롤이 설치되지 않았습니다.   <BR>  <a href="https://www.amazoncar.co.kr/home/IEPageSetupX.exe"><font color=red>이곳</font></a>을 클릭하여 수동으로 설치하시기 바랍니다.  </FONT>	</div>
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()">
<div class="a4">
<table width="750" border="0" cellspacing="2" cellpadding="0" >
	<tr>
		<td>	
			<table width="700" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height=10 class="f3">[별지 제47호서식] <개정 2017. 2. 14.></td>
				</tr>
				<tr>
					<td align=center><span class=f1>자동차 검사 신청서</span></td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
			        <td class="t1">
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
				            <tr bgcolor="#eeeeee">
				                <td width=34% height=45 valign=top>&nbsp;접수번호</td>
					           	<td width=33% valign=top>&nbsp;접수일</td>
					           	<td width=33% valign=top class=n1>&nbsp;처리기간 즉시</td>
					     	</tr>	
					     </table>
					 </td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
					<td class="t2">
						<table width=700 border=0 cellspacing=0 cellpadding=0>		            
				            <tr>
								<td width="100" align=center rowspan=4 class="n1"><span class="f4">신청인</span></td>
								<td width="200" height=30>&nbsp;&nbsp;성명(명칭)</td>
								<td width="400" class="n1">&nbsp;&nbsp;(주) 아마존카</td>
							</tr>
							<tr>
								<td height=30>&nbsp;&nbsp;생년월일또는 사업자 등록번호</td>
								<td class="n1">&nbsp;&nbsp;115611-******* (128-81-47957)</td>
				            </tr>
							<tr>
								<td height=30>&nbsp;&nbsp;주 소</td>
								<td class="n1">&nbsp;&nbsp;<%=h_bean.get("BR_ADDR")%></td>
							</tr>
							<tr>
								<td height=30>&nbsp;&nbsp;전화번호</td>
							    <td class="n1">&nbsp;&nbsp;02-392-4242</td>
						    </tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
					<td class="t2">
						<table width=700 border=0 cellspacing=0 cellpadding=0>		            
				            <tr>
								<td width="100" align=center rowspan=4 class="n1"><span class="f4">자동차</span></td>
								<td width="200" height=30>&nbsp;&nbsp;차명</td>
								<td width="400" class="n1">&nbsp;&nbsp;<%=h_bean.get("CAR_NM")%></td>
							</tr>
							<tr>
								<td height=30>&nbsp;&nbsp;형식</td>
								<td class="n1">&nbsp;&nbsp;<%=h_bean.get("CAR_FORM")%></td>
				            </tr>
							<tr>
								<td height=30>&nbsp;&nbsp;등록번호</td>
								<td class="n1">&nbsp;&nbsp;<%=h_bean.get("CAR_NO")%></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
					<td class="t2">
						<table width=700 border=0 cellspacing=0 cellpadding=0>		            
				            <tr>
								<td width="100" align=center class="n1"><span class="f4">검사구분</span></td>
								<td width="250" height=50>&nbsp;&nbsp;[ &nbsp; ] 튜닝검사&nbsp;&nbsp;[ ■ ] 임시검사</td>
								<td width="350" class=n1>&nbsp;&nbsp;[ &nbsp; ] 수리검사<br><div class="f3">&nbsp;&nbsp;(전손 처리 사유: [ ]침수  [ ]사고  [ ]도난ㆍ분실 [ ] 기타)</div></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
					<td>「자동차관리법」 제43조제1항, 같은 법 시행규칙 제78조, 제79조 및 제79조의2에 따라 위와 같이 신청합니다.</td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
				<!--	<td align=right><%=AddUtil.getDate(1)%>&nbsp;&nbsp;년 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(2)%>&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(3)%>&nbsp;&nbsp;일 &nbsp;&nbsp;&nbsp;</td> -->
					<td align=right>&nbsp;&nbsp;년 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일 &nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
					<td align=center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신청인 &nbsp;&nbsp;&nbsp;(주)아마존카</td>
				</tr>
					<td align=right><span class="f3">(서명 또는 인)</span> &nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
					<td><span class=f2>&nbsp;자동차검사대행자</span> 귀하</td>
				</tr>
				<tr>
					<td height=3 bgcolor="#000000"></td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
			        <td class="t2">
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
				            <tr>
								<td colspan="2" class="n1" width=100>
									<p style="text-align: center;" class="n1" class="f3">첨부서류<br></p>
								</td>
								<td width=100>
									<p style="text-align: center;" class="f3">수수료<br></p>
								</td>
							</tr>
							<tr>
								<td class="n1"  width=100>
									<p style="text-align: center;"  class="f3">튜닝검사<br></p>
								</td>
								<td>
									<p class="f3"><br>&nbsp;1. 자동차등록증</p>
									<p class="f3">&nbsp;2. 튜닝승인서</p>
									<p class="f3">&nbsp;3. 튜닝 전ㆍ후 주요제원대비표</p>
									<p class="f3">&nbsp;4. 튜닝 전ㆍ후의 자동차외관도(외관의 변경이 있는 경우에만 제출합니다)</p>
									<p class="f3">&nbsp;5. 튜닝하려는 구조ㆍ장치의 설계도</p>
									<p class="f3"></p>
								</td>
								<td rowspan="3" scope="">
									<p class="f3"><br>&nbsp;검사대행자가 정한 금액</p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="바탕글" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
								</td>
							</tr>
							<tr>
								<td class="n1" width=100>
									<p style="text-align: center;" class="f3">임시검사<br></p>
								</td>
								<td >
									<p class="f3"><br>&nbsp;1. 자동차등록증</p>
									<p class="f3">&nbsp;2. 자동차점검ㆍ정비ㆍ검사 또는 원상복구명령서</p>
									<p class="f3"></p>
								</td>
							</tr>
							<tr>
								<td class="n1" width=100>
									<p style="text-align: center;" class="f3">수리검사<br></p>
								</td>
								<td >
									<p class="f3"><br>&nbsp;1. 자동차등록증</p>
									<p class="f3">&nbsp;2. 자동차정비업자가 발급한 별지 제89호의2서식의 점검ㆍ정비명세서(전손 처리된 이후의  <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;수리에 관한 점검ㆍ정비명세서를 말합니다)</p>
									<p class="f3">&nbsp;3. 자동차관리법 시행규칙」 제79조의2제3호에 따른 사진</p>
									<p class="f3">&nbsp;4. 자동차검사대행자가 제출을 요구하는 다음 각 목의 서류</p>
									<p class="f3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;가. 보험회사가 발급한 전손 처리에 관한 확인서(사고일자, 사고원인 및 고장 또는 파손이<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;된 구조나 장치의 명칭이 기재된 것을 말합니다)</p>
									<p class="f3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;나. 휠얼라인먼트 측정 결과</p>
									<p class="f3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;다. 손상된 구조 또는 장치에 대한 수리 전 사진</p>
									<p class="f3"></p>
								</td>
							</tr>
					     </table>
					 </td>
				</tr>
				<tr>
					<td colspan="3" align="right" class="f3"><br>210㎜×297㎜[일반용지 60g/㎡]</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<div id="Layer1" style="position:absolute; margin-top: -590px; margin-left: 600px; z-index:1;"><img src="/acar/images/square_stamp_S.png" width="100" height="100"></div>
</div>

<!-- 자동차등록증 추가(20191004) -->
<jsp:include page="doc_car_print_car_reg.jsp" flush="true">
	<jsp:param name="c_id" value="<%=c_id%>"/>
</jsp:include>


</body>
<%}%>
</html>
<script>

//onprint();

function onprint(){
// 	var vid_size = '1';
// 									//~IE10									  //IE8~IE11		
// 	if( navigator.userAgent.indexOf("MSIE") > 0 || navigator.userAgent.indexOf("Trident") > 0){
// 		IEPageSetupX.header='';				//폐이지상단 인쇄
// 		IEPageSetupX.footer='';				//폐이지하단 인쇄
// 		//IEPageSetupX.Orientation = 1;		//1-세로인쇄, 2-가로인쇄
// 		IEPageSetupX.leftMargin=10.0;		//좌측여백
// 		IEPageSetupX.rightMargin=10.0;		//우측여백
// 		IEPageSetupX.topMargin=0;		//상단여백
// 		IEPageSetupX.bottomMargin=0;		//하단여백
// 		IEPageSetupX.PaperSize = 'A4';		//인쇄용지설정
// 		IEPageSetupX.PrintBackground = 1;	//배경색 및 이미지 인쇄 여부 설정
// 		if(vid_size == 1)			IEPageSetupX.Print();
// 		else 						IEPageSetupX.Print(true);	//인쇄 대화상자표시여부(true-표시 , 공백/false- 표시안함(바로 인쇄))
// 		//IEPageSetupX.Print(true);			//인쇄 대화상자표시여부(true-표시 , 공백/false- 표시안함(바로 인쇄))
		
// 		//IEPageSetupX.Print();			//인쇄 대화상자표시여부(true-표시 , 공백/false- 표시안함(바로 인쇄))
	
// 		/* factory.printing.header 	= ""; //폐이지상단 인쇄
// 		factory.printing.footer 	= ""; //폐이지하단 인쇄
// 		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
// 		factory.printing.leftMargin 	= 10.0; //좌측여백   
// 		factory.printing.rightMargin 	= 10.0; //우측여백
// 		factory.printing.topMargin 		= 10.0; //상단여백    
// 		factory.printing.bottomMargin 	= 10.0; //하단여백 */
// 	}else{	
// 		window.print();
// 	}

	var userAgent = navigator.userAgent.toLowerCase();
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
			IE_Print();
		}
}

function IE_Print(){
	factory1.printing.header='';
	factory1.printing.footer='';
	factory1.printing.leftMargin=10;
	factory1.printing.rightMargin=10;
	factory1.printing.topMargin=20;
	factory1.printing.bottomMargin=20;
	factory1.printing.Print(true, window);
}

// function onprint_box(){
// 	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
// }

</script>
