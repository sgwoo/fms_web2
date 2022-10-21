<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,java.awt.print.*,com.qoppa.pdf.*,com.qoppa.pdfPrint.*,acar.client.*"%>
<%@ page import="acar.cooperation.*, java.io.*, org.apache.pdfbox.pdmodel.PDDocument,acar.user_mng.*, acar.accid.*"%>
<%@ page import="org.apache.pdfbox.multipdf.PDFMergerUtility,org.apache.pdfbox.pdmodel.*, acar.util.*"%>
<%@ page import="org.apache.pdfbox.pdmodel.PDPage, org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject, org.apache.pdfbox.pdmodel.PDPageContentStream"%>
<%@ page import="java.awt.*,java.nio.*, javax.imageio.*,com.sun.pdfview.*,java.awt.image.*, java.nio.channels.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="al_db" scope="page" 	class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String ch_cd[] 	= request.getParameterValues("ch_cd");
	//content_code 받아오기
	String content_code = request.getParameter(Webconst.Common.contentCodeName);
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	
	String rent_l_cd = request.getParameter("rent_l_cd");
	String rent_mng_id = request.getParameter("rent_mng_id");
	String rent_st = request.getParameter("rent_st");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(String.valueOf(cont.get("CLIENT_ID")));
	
	ServletContext context = getServletContext();
	String fileName ="";
	String saveFolder ="";
	String realFolder ="";
	String filePath = "";
	String fileType = "";
	Vector vt = new Vector();
	
	int count = 0;
	
	int img_width 	= 680;
	int img_height 	= 1009;

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src='/include/common.js'></script>
<script>
window.onload = function(){
    window.document.body.scroll = "auto";
}

</script>
<style>
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    background-color: #ddd;
    font-family: "돋움", dotum, arial, helvetica, sans-serif;
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

</style>
<style>

.title{text-align:center;font-size:11pt;}  
.content1 {font-size:10pt;}
.content1 tr{ height:30px;}
  
.content2 {font-size:10pt;}
.content2 tr{ height:31px;}
  
.content3 {font-size:10pt;}
.content3 tr{ height:25px;}

.checklist{border-bottom:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;font-size:9pt;}
.checkpoint{font-size:11px;text-align:right;}

.notice{font-size:9pt;}
.noticeList{margin-left:10px;margin-top:10px;}
.noticeListFirst{margin-bottom:4px;}
.noticeListMiddle{margin-left:18px;margin-bottom:4px;}
.noticeListLast{margin-left:18px;}
</style>
<script>


</script>
</head>
<body>
<%-- 	<%	for(int i=0; i< ch_cd.length; i++){
		
		if(ch_cd[i].equals("doc1")){
	%>		
	<%	}else{
			String url = "https://fms3.amazoncar.co.kr/fms2/attach/imgview_print.jsp?SEQ="+ch_cd[i].replaceAll(" ","");
		%>
			<div class="paper2">
		    <div class="content2">
				<iframe  src="<%=url%>" id="frame<%=i%>" class="frame" scrolling="no" frameborder="0" style="width:100%;height:100%;">
				</iframe>
			</div>
			</div>
		<%	}%>
	<%	}%> --%>
	<%
	
	for(int i=0; i< ch_cd.length; i++){
		if(ch_cd[i].equals("doc1")){
		%>
		    <div class="paper">
		    <div class="content">
		    
			<div class="wrap" style="width:100%;">
				<br>
				<div style="text-align:left;font-size:8pt;margin-bottom:10px;">&nbsp; ■ 주민등록법 시행규칙 [ 별지 제7호서식 ]<span style="color:blue;font-size:7pt;"> <개정 2014. 12. 31.></span></div>
				<div style="text-align:center;font-size:15pt;font-weight:bold;font-family:HYGothic-Extra;">주민등록표 열람 또는 등ㆍ초본 교부 신청서</div>
				<div style="text-align:left;font-size:8pt;font-weight:normal;;margin-bottom:3px;">&nbsp; ※ 뒤쪽의 유의 사항을 읽고 작성하여 주시기 바라며, [ &nbsp; ]에는 해당하는 곳에 √표를 합니다.<span style="margin-left:180px;">( 앞쪽 )</span></div>
					<table border="0" cellspacing="0" cellpadding='0' width='100%' class="content1">
						<tr>
							<td width="80" rowspan="4" class='title' style="border-right:0.5px solid rgba(0,0,0,0.35);border-top:1px solid #444444;border-bottom:1px solid #444444;">신청인<div style="margin-top:5px;">(개인)</div></td>
							<td colspan="2" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-top:1px solid #444444;">&nbsp;성명
								<div style="margin-left:300px;font-size:9px;">( 서명 또는 인 )</div>
								<div style="width:0px; height:0px;position:relative;z-index:1;top:-25;margin-left:320px;"><img src="/acar/images/stamp.png" width="39" height="38"></div> 
							</td>
							<td width="220" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-top:1px solid #444444;border-left:0.5px dotted rgba(0,0,0,0.25);">&nbsp;주민등록번호</td>
						</tr>
						<tr>
							<td colspan="3" style="border-bottom:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;주소</td>
						</tr>
						<tr>
							<td colspan="2" style="border-bottom:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;대상자와의 관계</td>
							<td style="border-bottom:0.5px dotted rgba(0,0,0,0.25);border-left:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;전화번호</td>
						</tr>
						<tr style="height:21px;">
							<td width="110" style="border-bottom:1px solid #444444;border-right:0.5px solid rgba(0,0,0,0.25);">&nbsp;수수료 면접 대상</td>
							<td colspan="2" style="border-bottom:1px solid #444444;font-size:11px;">&nbsp;[ &nbsp;&nbsp; ]국민기초생활수급자 &nbsp;&nbsp; [ &nbsp;&nbsp; ]국가보훈대상자 &nbsp;&nbsp; [ &nbsp;&nbsp; ]그 밖의 대상자(<span style="margin-left:50px;"></span>)</td>
						</tr>
					</table>
					<table border="0" cellspacing="0" cellpadding='0' width='100%' class="content2" style="margin-top:3px;">
						<tr>
							<td width="80" rowspan="4" class='title' style="border-right:0.5px solid rgba(0,0,0,0.35);border-top:1px solid #444444;border-bottom:1px solid #444444;">신청인<div style="margin-top:5px;">(법인)</div></td>
							<td colspan="2" width="" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-top:1px solid #444444;">&nbsp;기관명 (주) 아마존카</td>
							<td colspan="2" width="220" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-top:1px solid #444444;border-left:0.5px dotted rgba(0,0,0,0.25);">&nbsp;사업자등록번호
								<div style="font-size:9pt">&nbsp;128-81-47957</div></td>
						</tr>
						<tr>
							<td colspan="2" style="border-bottom:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;대표자 조성희
							<div style="margin-left:300px;font-size:9px;">( 서명 또는 인 )</div>
							<div style="width:0px; height:0px;position:relative;z-index:1;top:-25;margin-left:320px;"><img src="/acar/images/stamp.png" width="39" height="38"></div>
							</td>
							<td colspan="2" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-left:0.5px dotted rgba(0,0,0,0.25);">&nbsp;대표전화번호
								<div style="font-size:9pt">&nbsp;02-392-4243</div></td>
						</tr>
						<tr>
							<td colspan="4" style="border-bottom:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;소재지
								<div style="font-size:9pt">&nbsp;서울 영등포구 의사당대로  8, 802 ( 여의도동, 태흥빌딩 )</div>
							</td>
						</tr>
						<tr>
							<td  width="220" style="border-bottom:1px solid #444444;border-right:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;방문자 성명
							</td>
							<td width="150" style="border-bottom:1px solid #444444;border-right:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;주민등록번호
							</td>
							<td width="90" style="border-bottom:1px solid #444444;border-right:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;직위
							</td>
							<td width="130" style="border-bottom:1px solid #444444;vertical-align:top;">&nbsp;전화번호
							</td>
						</tr>
					</table>
					
					<table border="0" cellspacing="0" cellpadding='0' width='100%' class="content3" style="margin-top:3px;">
						<tr style="height:33px;">
							<td width="80" rowspan="2" class='title' style="border-right:0.5px solid rgba(0,0,0,0.35);border-top:1px solid #444444;">열람 또는<br>등ㆍ초본<br>교부 대상자</td>
							<td colspan="2" width="" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-top:1px solid #444444;">&nbsp;<%=client.getClient_nm()%> <%=cont.get("CAR_NO") %></td>
							<td  width="225" style="vertical-align:top;border-top:1px solid #444444;border-left:0.5px dotted rgba(0,0,0,0.25);border-bottom:0.5px dotted rgba(0,0,0,0.25);font-size:10pt;">&nbsp;주민등록번호
								<div style="font-size:9pt">&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2() %></div></td>
						</tr>
						<tr style="height:33px;">
							<td colspan="4" style="vertical-align:top;">&nbsp;<%if(!client.getHo_addr().equals("")){%><%=client.getHo_addr()%><%}else{%><%=client.getO_addr()%><%}%>
								<div style="margin-left:350px;text-align:right;font-size:9pt">[ 행정기관명 : <span style="margin-left:130px;"></span>]</div>
							</td>
						</tr>
						<tr>
							<td width="60" rowspan="16" class='title' style="border-right:0.5px solid rgba(0,0,0,0.25);border-top:0.5px solid rgba(0,0,0,0.25);border-bottom:1px solid #444444;">신청 내용</td>
							<td colspan="1" width="100" style="text-align:center;border-bottom:0.5px solid rgba(0,0,0,0.35);border-top:0.5px solid rgba(0,0,0,0.35);border-right:0.5px solid rgba(0,0,0,0.35);">열 &nbsp; 람</td>
							<td colspan="2" width="" style="border-bottom:0.5px solid rgba(0,0,0,0.25);border-top:0.5px solid rgba(0,0,0,0.25);font-size:9pt;">
								&nbsp;[ &nbsp; ] 등본사항	<span style="margin-left:130px;"></span>&nbsp;[ v ] 초본사항
							</td>
						</tr>
						<tr style="height:px;">
							<td colspan="4" style="vertical-align:top;font-size:8pt;border-bottom:0.5px solid rgba(0,0,0,0.35);border-top:0.5px solid rgba(0,0,0,0.35);background-color:#cabdbd;">&nbsp;
								※ 개인정보 보호를 위하여 아래의 등ㆍ초본 사항 중 필요한 사항만 선택하여 신청할 수 있습니다.<br>
								<span style="margin-left:20px;"></span>선택사항을 표시하지 않는 경우에는 "포함"으로 굵게 표시된 사항만 포함하여 교부해 드립니다.
							</td>
						</tr>
						<tr>
							<td rowspan="8" width="100" style="text-align:center;border-bottom:0.5px solid rgba(0,0,0,0.35);border-right:0.5px solid rgba(0,0,0,0.35);">등본 교부<br>[ &nbsp; ] 통</td>
							<td colspan="2" class="checklist">
								&nbsp;1. 과거의 주소변동 사항	<div class="checkpoint">[ &nbsp; ]전체 포함 &nbsp; [  &nbsp;v&nbsp; ]최근 5년 포함  &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;2. 세대 구성 사유 <div class="checkpoint">[ &nbsp; ]<b>포함</b> &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;3. 세대원의 세대주와의 관계<div class="checkpoint">[ &nbsp; ]<b>포함</b> &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;4. 세대원의 전입일 / 변동일, 변동 사유 <div class="checkpoint">[ &nbsp; ]<b>포함</b> &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;5. 교부 대상자 외 다른 세대원의 이름 <div class="checkpoint">[ &nbsp; ]<b>포함</b> &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;6. 교부 대상자 외 다른 세대원의 주민등록번호 뒷자리 <div class="checkpoint">[ &nbsp; ]<b>포함</b> &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;7. 동거인 <div class="checkpoint">[ &nbsp; ]포함 &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" style="border-bottom:0.5px solid rgba(0,0,0,0.25);">
								&nbsp;8. 외국인 배우자 / 외국인 부모 <div class="checkpoint">[ &nbsp; ]포함 &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td rowspan="6" width="100" style="text-align:center;border-bottom:1px solid #444444;border-right:0.5px solid rgba(0,0,0,0.35);">초본 교부<br>[ 1 ] 통</td>
							<td colspan="2" width="" class="checklist" >
								&nbsp;1. 개인 인적 사항 변경 내용     	<div class="checkpoint">[ &nbsp; ]포함 &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;2. 과거의 주소 변동 사항 <div class="checkpoint">[ &nbsp; ]전체 포함 &nbsp; [  &nbsp;v&nbsp; ]최근 5년 포함  &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;3. 과거의 주소 변동 사항 중 세대주의 성명과 세대주와의 관계 <div class="checkpoint">[ &nbsp; ]포함 &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;4. 병역사항 <div class="checkpoint">[ &nbsp; ]포함 &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;5. 재외국민 국내거소신고번호 <div class="checkpoint">[ &nbsp; ]포함 &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist" style="vertical-align:top;border-bottom:1px solid #444444;">
								&nbsp;6. 외국인등록번호 <div class="checkpoint">[ &nbsp; ]포함 &nbsp; [ &nbsp; ]미포함</div>
							</td>
						</tr>
					</table>
					
					<table border="0" cellspacing="0" cellpadding='0' width='100%' class="content1" style="margin-top:3px;">
						<tr>
							<td width="100" class='title' style="border-right:0.5px solid rgba(0,0,0,0.25);border-top:1px solid #444444;border-bottom:0.5px solid rgba(0,0,0,0.25);">용도 및 목적</td>
							<td colspan="2" style="vertical-align:top;border-bottom:0.5px solid rgba(0,0,0,0.25);border-top:1px solid #444444;">&nbsp;채무자 주소 조회	</td>
							<td width="220" style="vertical-align:top;border-bottom:0.5px solid rgba(0,0,0,0.25);border-top:1px solid #444444;border-left:0.5px solid rgba(0,0,0,0.25);">&nbsp;제출처</td>
						</tr>
						<tr style="height:30px;">
							<td width="80" class='title' style="border-right:0.5px solid rgba(0,0,0,0.25);border-bottom:1px solid #444444;">증명자료</td>
							<td colspan="3" style="border-bottom:1px solid #444444;"></td>
						</tr>
					</table>
					<div style="margin-top:5px;">
						<div style="font-size:11.3pt;text-align:right;margin:0px 10px;">&nbsp;「주민등록법 시행령」&nbsp;제47조와 제48조에 따라 주민등록표의 열람 또는 등ㆍ초본 교부를 신청<div style="text-align:left;">합니다.</div></div>
						<div style="font-size:8pt;text-align:right;margin-top:10px;">  &nbsp;&nbsp; 년     &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; 월   &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; 일</div>
						<div style="text-align:center;font-weight:bold;font-size:13pt;margin-top:10px;"> 시장ㆍ군수ㆍ구청장 또는 읍ㆍ면ㆍ동장 및 출장소장  <span style="font-weight:normal;font-size:9pt;">귀하</span></div>
						<div><hr style="height:3px;background-color:gray;"></div>
					</div>
			</div>
			</div>
			</div>
			
			<!-- 두번째 페이지  -->
		  	<div class="paper">
		    <div class="content">
			<div class="wrap" style="width:100%;">
				<div style="text-align:right;font-size:8pt;font-weight:normal;margin-bottom:1px;margin-top:30px;">( 뒤쪽 )</div>
				<div><hr style="height:3px;background-color:gray;margin-bottom:60px;"></div>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="notice">
					<tr>
						<td width="120" style="text-align:center;border-bottom:1px dotted rgba(0,0,0,0.35);border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.25);">
							&nbsp;첨부서류<div style="margin:5px 0px;">(확인 후 돌려</div><div>드립니다.)</div>
						</td>
						<td style="border-bottom:1px solid rgba(0,0,0,0.35);border-top:1px solid rgba(0,0,0,0.35);border-left:1px dotted rgba(0,0,0,0.25);">
							<div style="margin-top:5px">&nbsp;1. 주민등록증 등 신분증명서</div>
							<div style="margin-top:5px">&nbsp;2. 법은 방문자인 경우는 방문자의 사원증 또는 재직증명서</div>
							<div style="margin-top:5px">&nbsp;3. 수수료 면제 대상자인 경우는 필요한 증명자료</div>
							<div style="margin:5px 0px">&nbsp;4. 외국인등록증(외국인배우자의 경우)</div>
						</td>
					</tr>
				</table>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' style="margin-top:4px;">
					<tr style="height:25px;">
						<td style="text-align:center;border-top:3px solid gray;border-bottom:1px solid rgba(0,0,0,0.25);font-size:10pt;background-color:#cabdbd;">유의사항		</td>
					</tr>
					<tr style="text-align:left;border-bottom:1px solid #444444;font-size:9pt;word-spacing:3;">
						<td>
							<div class="noticeList">
								<div class="noticeListFirst">1. 본인ㆍ세대원이 본인ㆍ세대원의 주민등록표 열람 또는 등ㆍ초본 교부를 주민등록증 등 신분증명서 제시만으로</div> 
								<div class="noticeListMiddle">신청하는 경우에는 「전자이미지서명입력기」에 자필 한글 성명으로 서명하여야 열람 또는 교부받을 수 있습니</div>
								<div class="noticeListLast" class="noticeListLast">다.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">2. 신청인은 "신청내용"란의 각 항목에 대하여 "포함", "미포함"을 선택하여 신청할 수 있으며, 선택하지 않은 경</div>
								<div class="noticeListLast">우에는 <b>"포함"</b> 으로 굵게 표시된 사항만 처리됩니다.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">3. 상속 등기 대위신청을 위하여 채무자의 주민등록초본 교부를 신청하는 경우에는 과거의 주소변동사항을 포함하</div>
								<div class="noticeListLast">여 열람하게 하거나 발급할 수 있습니다.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">4. 등본 교부를 신청할 때 주민등록을 하지 못한 외국인 배우자의 경우 8. 외국인 배우자 및 부모항목은 본인이나</div>
								<div class="noticeListLast">세대원(그 위임을 받은 자 포함)만 "포함"을 선택할 수 있습니다.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">5. 초본 교부를 신청할 때  3. 과거의 주소 변동 사항 중 세대주의 성명과 세대주와의 관계 항목은 본인이나 세대원</div> 
								<div class="noticeListMiddle">(그 위임을 받은자 포함), 국가나 지방자치단체가 공무상 필요로 한 경우에만  "포함"을 선택할 수 있고, 4. 병역</div>
								<div class="noticeListMiddle">사항 항목은 본인이나 세대원(그 위임을 받은 사람 포함),「주민등록법」제29조제2항제5호에 따른 가족, 국가</div>
								<div class="noticeListLast">나 지방자치단체가 공무상 필요로 한 경우에만 "포함"을 선택할 수 있습니다.</div>
							</div>
							<div class="noticeList">
								<div>6. 담당 공무원이 수수료 면제 대상자임을 확인하기 위하여 필요한 증명자료를 요구할 경우에는 제시해야 합니다.</div>
							</div>
							<div class="noticeList">
								<div>7. 법인방문자는 사원증(또는 재직증명서)과 주민등록증 등의 신분증명서를 함께 제시해야 합니다.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">8. 본인이나 세대원이 아닌 자가 교부받는 등ㆍ초본에는 기재하신 용도 및 목적이 표시되니 반드시 "용도 및 목적"</div>
								<div class="noticeListLast">을 기재하여야 하며, 등본을 신청하는 경우에는 별도의 증명자료를 제출하여야 합니다.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">9. 「주민등록법」 제37조제5호에 따라 거짓이나 그 밖의 부정한 방법으로 다른 사람의 주민등록표를 열람하거나 </div>
								<div class="noticeListLast">등ㆍ초본을 교부받은 경우에는 3년 이하의 징역형이나 1천만 원 이하의 벌금형에 처해질 수 있습니다.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">10. 동일 신청자가 동일 증명자료에 따라 같은 목적으로 여러 사람의 주민등록표를 열람하거나 등ㆍ초본 교부를 신 </div>
								<div style="margin-left:25px;margin-bottom:4px;">청하는 경우에는 별지 제7호서식과 별지 제8호서식을 함께 사용하여 일괄 신청할 수 있으며, 이경 별지 제7</div>
								<div style="margin-left:25px;">호서식과 별지 제8호서식 사이에는 신청인의 확인(간인)이 있어야 합니다.</div>
							</div>
							<div class="noticeList">
								<div>11. 외국인 배우자는 주민등록번호 란에 외국인등록번호를 기재하시기 바랍니다.</div>
							</div>
						</td>
					</tr>
					<tr>
						<td style="border-bottom:1px solid rgba(0,0,0,0.25);">
							<br>
						</td>
					</tr>
				</table>
				
				<table border="0" cellspacing="0" cellpadding='0' width='100%' style="margin-top:15px;">
					<tr style="height:35px;">
						<td width="220" style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);border-right:1px solid rgba(0,0,0,0.25);font-size:9pt;background-color:#cabdbd;">접수 번호</td>
						<td width="220" style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);border-right:1px solid rgba(0,0,0,0.25);font-size:9pt;background-color:#cabdbd;">접수 일자</td>
						<td style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);font-size:10pt;background-color:#cabdbd;">열람ㆍ교부 일시</td>
					</tr>
				</table>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' style="margin-top:20px;">
					<tr height="50">
						<td style="text-align:center;border-top:3px dashed gray;font-weight:1000;font-size:19px;font-family:HYGothic-Extra;">주민등록표 열람 또는 등ㆍ초본 교부 신청 접수증</td>
					</tr>
				</table>
				<table border="0" cellspacing="0" cellpadding='0' width='100%'>
					<tr style="height:35px;">
						<td width="220" style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);border-right:1px solid rgba(0,0,0,0.25);font-size:9pt;background-color:#cabdbd;">접수 번호</td>
						<td width="220" style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);border-right:1px solid rgba(0,0,0,0.25);font-size:9pt;background-color:#cabdbd;">접수 일자</td>
						<td style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);font-size:10pt;background-color:#cabdbd;">신청인 성명</td>
					</tr>
				</table>
				<div style="margin-left:100px;">
				<table border="0" cellspacing="0" cellpadding='0' width='80%' style="margin-top:15px;">
					<tr style="height:60px;font-size:12pt;font-weight:1000;">
						<td style="border:0px;text-align:right;padding-right:20px;">시장ㆍ군수ㆍ구청장 또는 읍ㆍ면ㆍ동ㆍ출장소장</td>
						<td width="65" style="text-align:center;border:3px solid grey;font-size:12pt;color:grey;">직인</td>
					</tr>
				</table>
				</div>
				<div style="text-align:left;font-size:9pt;margin-top:15px;">
					* 접수증은 온라인장애 등으로 인하여 즉시 처리가 안 되는 경우에만 교부하여 드립니다.			
				</div>
			</div>
			</div>
			</div>
		<%
		}else{
		 vt = cp_db.getAcarAttachFile(ch_cd[i]);
			 for(int j=0; j< vt.size(); j++){
					Hashtable ht = (Hashtable)vt.elementAt(j);
					fileName = String.valueOf(ht.get("SAVE_FILE"));		
					saveFolder = String.valueOf(ht.get("SAVE_FOLDER"));
					realFolder = "https://fms3.amazoncar.co.kr";
					//realFolder = request.getRealPath("/");
					filePath = realFolder + saveFolder + fileName;	
					filePath = filePath.replaceAll("///", "/").replaceAll("/////", "/");
			
				if(!String.valueOf(ht.get("FILE_TYPE")).equals("application/pdf")){
			%>
				<div class="paper">
				    <div class="content">
						<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=ht.get("SEQ")%>" width=<%=img_width%> height=<%=img_height%> />
					</div>
					</div>
				<%}else{ %>
					 <%-- <embed src="<%=filePath%>"  width=<%=img_width%> height=100%/> --%>
					 <%
					    File file = new File(filePath);
				        RandomAccessFile raf = new RandomAccessFile(file, "r");
				        FileChannel channel = raf.getChannel();
				        ByteBuffer buf = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
				        PDFFile pdffile = new PDFFile(buf);

				        // draw the first page to an image
				        PDFPage pdfPage = pdffile.getPage(pdffile.getNumPages());
				        
				        //get the width and height for the doc at the default zoom 
				        Rectangle rect = new Rectangle(0,0,
				                (int)pdfPage.getBBox().getWidth(),
				                (int)pdfPage.getBBox().getHeight());
				        
				        //generate the image
				        
				        Image image = pdfPage.getImage(
				                rect.width, rect.height, //width & height
				                rect, // clip rect
				                null, // null for the ImageObserver
				                true, // fill background with white
				                true  // block until drawing is done
				                );
				        
				        int w = image.getWidth(null);
				        int h = image.getHeight(null);
				        BufferedImage bi = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
				        Graphics2D g2 = bi.createGraphics();
				        g2.drawImage(image, 0, 0, null);
				        g2.dispose();
				        try
				        {
				        	int Idx = fileName.lastIndexOf(".");
				        	fileName = fileName.substring(0, Idx )+".jpg";
		        			filePath = realFolder + saveFolder + fileName;					        
		        			filePath = filePath.replaceAll("///", "/").replaceAll("/////", "/");
				            ImageIO.write(bi, "jpg", new File(filePath));
				        }
				        catch(IOException ioe)
				        {
				            System.out.println("write: " + ioe.getMessage());
				        } 
					 
					 %>
				<%} %>
	 		<%} %>
		<%} %>
	<%} %>
</body>
</html>
