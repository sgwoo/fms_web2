<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.net.*, java.text.*, acar.util.*, acar.common.*, acar.off_ls_hpg.*, acar.estimate_mng.*"%>
<jsp:useBean id="oh_db" scope="session" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<jsp:useBean id="off_bn" class="acar.offls_yb.Offls_ybBean" scope="page"/>
<jsp:useBean id="es_bn" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<%@ page import="java.util.Date" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<c:set var="tomorrow" value="<%=new Date(new Date().getTime() + 60*60*24*1000)%>"/>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String carManagedId	 	= request.getParameter("carManagedId")==null?"":request.getParameter("carManagedId");
	String rentLocationCode	= request.getParameter("rentLocationCode")==null?"":request.getParameter("rentLocationCode");
	String rentManagedId 	= request.getParameter("rentManagedId")==null?"":request.getParameter("rentManagedId");
	String estId 			= request.getParameter("estId")==null?"":request.getParameter("estId");
	int rank 				= request.getParameter("rank")==null?0:AddUtil.parseInt(request.getParameter("rank"));
	String res_st_dt 		= request.getParameter("res_st_dt")==null?"":request.getParameter("res_st_dt");
	String res_end_dt		= request.getParameter("res_end_dt")==null?"":request.getParameter("res_end_dt");
	String br_nm 			= request.getParameter("br_nm")==null?"":request.getParameter("br_nm");
	String br_tel 			= URLDecoder.decode(request.getParameter("br_tel")==null?"":request.getParameter("br_tel"), "EUC-KR");
	
	Hashtable secondhand = oh_db.getSecondhandCase_20090901(rentManagedId, rentLocationCode, carManagedId);
	es_bn = e_db.getEstiSpeCase(estId);
	String gubun = String.valueOf(es_bn.getEst_st());
	String telNum = String.valueOf(es_bn.getEst_tel());
	//사업자인지 개인인지 확인
	if(gubun.contains("1")){
	    gubun = "법인사업자";	
	}else if(gubun.contains("2")){
	    gubun = "개인사업자";
	}else if(gubun.contains("3")){
	    gubun = "개인";
	}
	
	StringBuffer telNumPrint = new StringBuffer(telNum);
	//전화번호 처리
	if(telNum.length() > 8){
	    telNumPrint.replace(3,7,"****");
	}
	
	int tot_rm2 = AddUtil.parseInt((String)secondhand.get("RM1"));
	
	
	
	
	SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy.MM.dd HH:mm:ss", Locale.KOREA );
	Date currentTime = new Date ();
	String mTime = mSimpleDateFormat.format ( currentTime );
	System.out.println ( mTime );
	
	//추가
	SimpleDateFormat dtFormat = new SimpleDateFormat ( "yyyyMMdd" );
	Date reserveEnd = dtFormat.parse ( res_end_dt );
	
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>아마존카 차량예약 확인 메일</title>
<style type="text/css">
<!--
.style1 {color: #373737}
.style2 {color: #63676a}
.style3 {color: #ff8004}
.style4 {color: #c09b33; font-weight: bold;}
.style5 {color: #c39235}
.style6 {color: #8b8063;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>

<script language="JavaScript">
<!--
//New 로그인
	function getLogin2(member_id, pwd){	
		var w = 450;
		var h = 250;
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		var SUBWIN="https://fms.amazoncar.co.kr/service/index.jsp?name="+member_id+"&passwd="+pwd;	
//		window.open(SUBWIN, "InfoUp", "left="+winl+", top="+wint+", width="+w+", height="+h+", scrollbars=yes");
		window.open(SUBWIN, "InfoUp1", "left=5, top=5, width=1240, height=760, scrollbars=yes, status=yes, menubar=yes, toolbar=yes, resizable=yes");		
		
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
//-->
</script>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top_no_title.png></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>

    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=20 style="padding:20px;line-height:25px;text-align:center;">
                    	<!-- <h2>아래와 같이 <span style="color:#9CB445;">월렌트 차량 예약</span>이 <span style="color:#9CB445;">완료</span>되었습니다</h2> -->
                    	<h2><span style="color:#9CB445;">월렌트 차량 예약</span> 관련 안내</h2>
                    </td>
                </tr>
                <tr>
                	<td style="line-height:18px;border-top:1px solid #ddd;border-bottom:1px solid #ddd;padding:15px;">
   	            		<%-- * <span class="primary" style="font-weight:bold;">대기 <%=rank%>순위</span>로 예약되셨습니다.<br/>
						* 예약 기한은 <span class="primary-orange"><fmt:formatDate value="<%=reserveEnd%>" pattern="yyyy년 MM월 dd일 " /> 16시</span>까지 입니다.<br/>
						* 자세한 차량예약 정보는 <a href="https://www.amazoncar.co.kr">www.amazoncar.co.kr</a>에 로그인 > 마이페이지 > 견적/상담/예약 이력 에서 확인 가능하며 , 상담을 통해 예약이 확정되고 계약이 진행됩니다. --%>
						* 아래의 월렌트 차량이 예약되었습니다.<br/>
						* 아마존카 직원과 유선 상담을 통해 나머지 계약과정이 진행됩니다.<br>
						<div style="margin-left:15px;">(빠른 시간내에 아마존카 직원이 연락드리도록 하겠습니다.)</div>
						<div style="margin-left:15px;">※해당 지점(<%=br_nm%>:<%=br_tel%>)으로 직접 전화주시면 더 빠른 진행이 가능합니다.</div>
						<div style="margin-left:25px;">[상담 가능시간: 평일 오전 9:00 ~ 오후 5:00]</div>
						* 예약 기한은 <span class="primary-orange"><fmt:formatDate value="<%=reserveEnd%>" pattern="yyyy년 MM월 dd일 " /> 16시</span>까지 입니다.<br/>
						* 예약취소는 마이페이지 > 견적/상담/예약 이력 메뉴에서 하실 수 있습니다. 
					</td>
                </tr>
                <tr>
                	<td>
                		<table style="border-collapse:collapse;width:100%;margin:20px 0px;">
                			<caption style="text-align:left;"><h3>■ 차량 정보</h3></caption>
                			<colgroup>
                				<col width="15%"/>
                				<col width="35%"/>
                				<col width="15%"/>
                				<col width="35%"/>
                			</colgroup>
                			<tr>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">제조사</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;"><%=c_db.getNameById(String.valueOf(secondhand.get("CAR_COMP_ID")),"CAR_COM")%></td>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">차명</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;"><%=secondhand.get("CAR_JNM")%>&nbsp;<%=secondhand.get("CAR_NM")%></td>
                			</tr>
                			<tr>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">차량번호</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;"><%=secondhand.get("CAR_NO")%></td>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">신차등록일</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;"><%=secondhand.get("INIT_REG_DT")%></td>
                			</tr>
                			<tr>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">배기량</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;"><%=secondhand.get("DPM")%>cc</td>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">연료</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;"><%=secondhand.get("FUEL_KD")%></td>
                			</tr>
                			<tr>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">색상</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;"><%=secondhand.get("COLO")%></td>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">주행거리</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;"><%=Util.parseDecimal(String.valueOf(secondhand.get("REAL_KM")))%>km</td>
                			</tr>
                			<tr>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">월 대여료</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;font-weight:bold;color:#22b500;"><%= AddUtil.parseDecimal(tot_rm2*1.1) %>원(부가세 포함)</td>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;"></th>
                				<td style="border:1px solid #d6d6d6;padding:5px;font-weight:bold;color:#22b500;"></td>
                			</tr>
                		</table>
                		<table  style="border-collapse:collapse;width:100%;margin:20px 0px;">
                			<caption style="text-align:left;"><h3>■ 고객 정보</h3></caption>
                			<colgroup>
                				<col width="10%"/>
                				<col width="20%"/>
                				<col width="10%"/>
                				<col width="20%"/>
                				<col width="10%"/>
                				<col width="20%"/>
                			</colgroup>
                			<tr>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">구분</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;"><%=gubun%></td>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">성명</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;"><%=es_bn.getEst_nm()%></td>
                				<th style="border:1px solid #d6d6d6;padding:5px;background-color:#eee;">연락처</th>
                				<td style="border:1px solid #d6d6d6;padding:5px;"><%=telNumPrint%></td>
                			</tr>
                		</table>
                	</td>
                </tr>          
            </table>
        </td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=85><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>