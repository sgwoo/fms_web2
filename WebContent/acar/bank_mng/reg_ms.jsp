<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.common.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String vid[] = request.getParameterValues("ch3_cd");
	String rent_l_cd = "";
	String rent_mng_id ="";
	String doc_id ="";
	String vid_num="";
	
	int vt_size = vid.length;
		
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>

<STYLE>
<!--
body {text-align:center;}
table { border-collapse:collapse; }
table td{ border:1px solid #000000;}

-->
</STYLE>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>
<script language='javascript'>
<!--
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=12;
		IEPageSetupX.rightMargin=12;
		IEPageSetupX.topMargin=20;
		IEPageSetupX.bottomMargin=20;	
		print();
	
	}
	
function onprint(){
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

function IE_Print() {
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 12.0; //좌측여백   
factory.printing.topMargin = 12.0; //상단여백    
factory.printing.rightMargin = 20.0; //우측여백
factory.printing.bottomMargin = 10.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
//-->
</script>

</head>
<body leftmargin="10" topmargin="1" onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<%
int count = 0;
for(int i=0;i < vt_size;i++){								
	vid_num = vid[i];								
	rent_l_cd = vid_num.substring(0,13);
	rent_mng_id = vid_num.substring(13,19);
	doc_id = vid_num.substring(19);								
	Hashtable ht = FineDocDb.getReg_msprint(doc_id, rent_l_cd, rent_mng_id);
	count ++;
%>
<form action="" name="form1" method="POST" >
<input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 		value='<%=user_id%>'>
<input type='hidden' name='br_id' 		value='<%=br_id%>'>  
<%
} 
%>

<!-- 저당권 말소 등록 신청서 -->  
<div class="a4">
<table>
	<tr>
		<td colspan="5" height="20" valign="middle" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
			<span STYLE='font-size:11.0pt;font-family:"돋움";line-height:130%;'>[별지 제4호 서식] &lt;개정 2010.1.11&gt;</span>
		</td>
	</tr>
	<tr>
		<td style="border:none;">
			<table cellspacing="0" cellpadding="0"  width="650" style="border:1px solid #000000;">				
				<tr>
					<td rowspan="2" colspan="4" height="69" align="center" valign="middle" style='border:1px solid #000000; padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<span STYLE='font-size:16.0pt;font-family:"돋움";font-weight:"bold";line-height:160%;'>저당권 말소등록 신청서</span>
					</td>
					<td width="110" height="25" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<span STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>처리기간</span>
					</td>
				</tr>
				<tr>
					<td height="44" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<span STYLE='font-size:11.0pt;font-family:"돋움";line-height:100%;'>즉시(항공기<br>의 경우 7일)</span>
					</td>
				</tr>
				<TR>
					<TD colspan="2" height="49" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>■ 자동차&nbsp;&nbsp;&nbsp;&nbsp; □ 건설기계</SPAN><br>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>□ 항공기&nbsp;&nbsp;&nbsp;&nbsp; □ 소형선박</SPAN>
					</TD>
					<TD width="110" height="49" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>등록번호<br>(등록기호)</SPAN>
					</TD>
					<TD  height="49" width="205" valign="middle" style='border-left:solid #000000 1px;border-right:none;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<%
						for(int i=0;i < 1;i++){								
							vid_num = vid[i];								
							rent_l_cd = vid_num.substring(0,13);
							rent_mng_id = vid_num.substring(13,19);
							doc_id = vid_num.substring(19);								
							Hashtable ht = FineDocDb.getReg_msprint(doc_id, rent_l_cd, rent_mng_id);
						%>
						<SPAN STYLE='font-size:15.0pt;font-family:"돋움";line-height:160%;'><%=ht.get("CAR_NO")%> 외 <%=count-1%>대</SPAN>						
					</TD>						
					<TD  height="49"  valign="middle" style='border-left:none;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:2.8pt 5.7pt 2.8pt 5.7pt'>&nbsp;
					</TD>
				</TR>
				<TR>
					<TD rowspan="2" width="85" height="60" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>저당권자</SPAN>
					</TD>
					<TD width="140"  valign="middle" align="center" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";'>주소</SPAN>
					</TD>
					<TD colspan="3" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:140%;'>
							<% if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("현대저축은행")){%>
								<!--	135-864	-->서울특별시 강남구 선릉로 652 (삼성동 9-1,현대저축은행)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("산업은행")){%>
								<!--	135-894	-->서울특별시 강남구 신사동 611 중산빌딩 1층 산업은행 압구정지점
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("신한은행")){%>
								<!--	150-748	-->서울특별시 영등포구 국회대로70길 18 (여의도동, 한양빌딩 1층)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("NH저축은행")){%>
								<!--	121-807	-->서울특별시 마포구 노고산동 106-5 아이비타워 4층
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("한국시티은행")){%>
								<!--	137-881	-->서울특별시 서초구 서초대로 324 (서초동 1675-1,서원빌딩)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("대신저축은행")){%>
								<!--	138-908	-->서울특별시 송파구 올림픽로 119 잠실파인애플상가 3층 제3A 11호
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("부산은행")){%>
								<!--	137-070	-->서울특별시 서초구 서초동 1357-35  
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("국민은행")){%>
								<!--	110-752	-->서울특별시 종로구 청계천로 41 영풍빌딩 2층
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("하나저축은행")){%>
								<!--	110-855	-->서울특별시 종로구  종로 293 
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("OK저축은행")){%>
								<!--	100-743	-->서울특별시 중구 세종대로 39 대한서울상공회의소 10층
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("흥국상호저축은행")){%>
								<!--	611-839	-->부산광역시 연제구 중앙대로 1076 (연산동 703-1)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("한국씨티은행")){%>
								<!--	150-034	-->서울특별시 영등포구 영등포동4가 147-1, 홍익빌딩1층
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("하나은행")){%>
								<!--	135-884	-->서울특별시 강남구 수서동 713 (현대벤처빌 1층)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("pepper저축은행")||c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("페퍼저축은행")){%>
								<!--	463-824	-->경기도 성남시 분당구  분당로 55, 13F(서현동)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("대구은행")){%>
								<!--	100-070	-->서울특별시 중구 을지로2가 6번지 내외빌딩 2층
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("우리은행")){%>
								<!--	150-882	-->서울특별시 영등포구 여의도동 30-3
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("전북은행")){%>
								<!--	137-070	-->서울특별시 서초구 서초동 1337-20 대륭서초타워 2층 
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("기업은행")){%>
								<!--	150-740	-->서울특별시 영등포구 여의도동 은행로 30 중소기업중앙회빌딩 1층
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("외환은행")){%>
								<!--	150-879	-->서울특별시 영등포구 여의도동 26-5 대오빌딩 3층
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("HK저축은행")){%>
								<!--	135-010	-->서울특별시 강남구 논현동 199-2 2층
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("세람저축은행")){%>
								<!--	467-808	-->경기도 이천시  중리천로 50 
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("SBI4저축은행")){%>
								<!--	135-090	-->서울특별시 강남구 삼성동 143-30 SBI타워 5층 
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("한국시티은행")){%>
								<!--	150-034	-->서울특별시 영등포구 영등포동 4가 147-1 홍익빌딩 1층
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("SC제일은행")){%>
								<!--	150-716	-->서울특별시 영등포구  국제금융로 56 대우증권빌딩 (여의도동)
								<%}else if(c_db.getNameById((String)ht.get("GOV_ID"), "BANK").equals("광주은행")){%>
								<!--	150-890	-->서울특별시 영등포구  의사당대로1길 34 인영빌딩 3층
								<%}%>
							<%-- <%}%> --%>
						</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="30" valign="middle" align="center" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";letter-spacing:-1.2pt;line-height:160%;'>성명 또는 명칭</SPAN>
					</TD>
					<TD colspan="3" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'><%=c_db.getNameById((String)ht.get("GOV_ID"), "BANK")%></SPAN>
					</TD>
				</TR>
				<TR>
					<TD colspan="2"  height="44"  valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";letter-spacing:0.5pt;line-height:160%;'>&nbsp; □ 채권액 &nbsp;&nbsp;□ 채권최고액</SPAN><br>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp; □ 담보가격</SPAN>
					</TD>
					<TD colspan="3" height="44" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:15.0pt;font-family:"굴림";line-height:160%;'><%-- <%=Util.parseDecimal(ht.get("AMT6"))%> --%>별지 첨부 확인</SPAN>
					</TD>
				</TR>
				<TR>
					<TD rowspan="2" height="55" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";letter-spacing:-2.0pt;line-height:160%;'>채무자</SPAN>
					</TD>
					<TD height="30" valign="middle" align="center"  style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>주소</SPAN>
					</TD>
					<TD colspan="3" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>서울시 영등포구 의사당대로 8, 802호</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="30" valign="middle" align="center" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";letter-spacing:-1.2pt;line-height:160%;'>성명 또는 명칭</SPAN>
					</TD>
					<TD colspan="3" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>(주)아마존카</SPAN>
					</TD>
				</TR>
				<TR>
					<TD rowspan="2" height="61" align="center" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>저당권<br>설정자</SPAN>
					</TD>
					<TD height="30" valign="middle" align="center" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>주소</SPAN>
					</TD>
					<TD colspan="4" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>서울시 영등포구 의사당대로 8, 802호</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="31" valign="middle" align="center" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";letter-spacing:-1.1pt;line-height:160%;'>성명 또는 명칭</SPAN>
					</TD>
					<TD colspan="3" height="31" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>(주)아마존카</SPAN>
					</TD>
				</TR>
				<TR>
					<TD colspan="2" height="30" valign="middle"align="center"  style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>대위 원인</SPAN>
					</TD>
					<TD colspan="3" height="30" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
				<TR>
					<TD colspan="5" height="188" valign="middle" style='border:1px solid #000000;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;&nbsp;「자동차 등 특정동산 저당법」 제5조 및 같은 법 시행령 제6조에 따라 위와 같이 <br>&nbsp;&nbsp;&nbsp; 저당권 말소등록을 신청합니다. </SPAN><br>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%; text-align:right;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 월&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 일 
						</SPAN><br><br>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신청인:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN>
						<SPAN STYLE='font-family:"돋움";'>(서명 또는 인)</SPAN><br><br>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;귀하</SPAN>
					</TD>
				</TR>
				<TR>
					<TD rowspan="2" colspan="4" height="140" valign="middle" style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:11.0pt;font-family:"돋움";font-weight:"bold";line-height:160%;'>※ 구비서류</SPAN><br>
						<SPAN STYLE='font-size:11.0pt;line-height:160%;'>1. 말소등록의 원인을 증명하는 서류 및 저당권자의 인감증명서(자동차저당권<br>&nbsp;&nbsp;&nbsp; 의 경우 저당권자가 법인이고 제출된 사용인감계를 등록관청이 대조ㆍ확인 <br>&nbsp;&nbsp;&nbsp; 할수 있을때는 제외합니다)</SPAN><br>
						<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>2. 제3자의 승낙서나 그에 대항할 수 있는 판결문 등본(저당권의 말소등록에 <br>&nbsp;&nbsp;&nbsp; 이해관계를 가진 제3자가 있는 경우에만 제출합니다)</SPAN>
					</TD>
					<TD height="27" valign="middle" align="center" style='border-left:solid #000000 1px;border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>수수료</SPAN>
					</TD>
				</TR>
				<TR>
					<TD  height="112" valign="middle" align="center" style='border-left:solid #000000 1px;border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:130%;'>시행령<br>제10조<br>참조</SPAN>
					</TD>
				</TR>
				<TR>
					<TD colspan="5" height="119" valign="middle" style='border-left:solid #000000 1px;border-right:solid #000000 1px;border-top:none;border-bottom:solid #000000 1px;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
						<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>3.「민사소송법」에 따른 공시최고절차를 거쳐 제권판결을 받은 경우에는 그 등본 또는<br>&nbsp;&nbsp;&nbsp; 「공탁법」에 따른 공탁을 한 경우는 공탁서, 채권증서 및 채무이행에 관한 약정서(저당권<br>
						&nbsp;&nbsp;&nbsp; 자의 주소가 분명하지 않아 저당권설정자가 단독으로 저당권말소등록을 신청할 경우에만<br>&nbsp;&nbsp;&nbsp; 제출합니다)</SPAN><br>
						<SPAN STYLE='font-size:11.0pt;font-family:"돋움";letter-spacing:0.6pt;line-height:160%;'>4. 대위원인을 증명하는 서류(채권자가 채무자를 대위하여 등록신청하는 경우에만<br>&nbsp;&nbsp;&nbsp; 제출합니다)</SPAN>
					</TD>
				</TR>			
			</TABLE>
		</td>
	</tr>
	<TR>
		<TD colspan="5" height="29" align="right" valign="middle" style='border:none;padding:1.0pt 5.7pt 1.0pt 5.7pt'>
			<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>210mm×297mm[일반용지 60g/㎡(재활용품)]</SPAN>
		</TD>
	</TR>
</table>
</div>
<%}%>

<!-- 해지증서  -->
<div class="a4">
<table width="650">
	<tr>
		<td valign="middle" align="center" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt'>
			<span STYLE='font-size:26.0pt;font-family:"돋움";font-weight:"bold";line-height:180%;'>해 &nbsp;&nbsp;지 &nbsp;&nbsp;증 &nbsp;&nbsp;서</span>
		</td>
	</tr>
	<tr>
		<td height=1 bgcolor="#000000;"></td>
	</tr>
	<tr>
		<td style='border:none; padding:2.8pt 5.7pt 2.8pt 5.7pt;'> <br><br><br>
			<span style='font-size:13.0pt;font-family:"돋움";line-height:250%;'> 
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				일자 자동차 근저당권 설정계약에 기하여 &nbsp;&nbsp;&nbsp;&nbsp; 
			<%
			for(int i=0;i < 1;i++){								
				vid_num = vid[i];								
				rent_l_cd = vid_num.substring(0,13);
				rent_mng_id = vid_num.substring(13,19);
				doc_id = vid_num.substring(19);								
				Hashtable ht = FineDocDb.getReg_msprint(doc_id, rent_l_cd, rent_mng_id);
			%>
			<br>&nbsp;<b><%=c_db.getNameById((String)ht.get("GOV_ID"), "BANK")%></b> 
			<%}%>
			&nbsp; 은(는) 아래 기재된 내용 처럼 등록된 차량에 대하여 <br>근저당권을 설정하고 등록을 필하였던 바 금번 채권변제로 인하여 이를 해지한다.</span>
			  <!-- 임의 추가 문구 -->   
			<!-- <div STYLE='font-size:13.0pt;font-family:"돋움";line-height:250%;'>(상기 사항은 하단 목록중 첫호에 해당. 이 외 건의 기재사항은 별지 첨부 확인 )</div> -->    
			<br><br><br>
		</td>
	</tr>	
	<tr>
		<td style="border:none;">
			<TABLE cellspacing="0" cellpadding="0"  width="650">
			<colgroup>
				<col width="5%">
				<col width="20%">
				<col width="11%">
				<col width="25%">
				<col width="18%">
				<col width="10%">
				<col width="11%">
			</colgroup>
			<tr>
				<td align="center" colspan="7"><SPAN STYLE='font-size:13.0pt;font-family:"돋움";line-height:250%;'><b>근저당권 설정 해지 차량 목록</b></SPAN></td>
			</tr>
			<TR bgcolor="#CCCCCC" >
				<TD height="39" align="center" valign="middle" >
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>No.</SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>차 량</SPAN>
				</TD>
				<TD height="39" align="center" valign="middle" >
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>차량번호</SPAN>
				</TD>				
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>을부번호</SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>채권가액</SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>차대번호</SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:10.0pt;font-family:"돋움";line-height:160%;'>사용본거지</SPAN>
				</TD>
			</TR>
			<% 
				for(int i=0;i < vt_size; i++){						
					vid_num = vid[i];								
					rent_l_cd = vid_num.substring(0,13);
					rent_mng_id = vid_num.substring(13,19);
					doc_id = vid_num.substring(19);								
					Hashtable ht = FineDocDb.getReg_msprint(doc_id, rent_l_cd, rent_mng_id);
					String carFullNum = (String)ht.get("CAR_NUM");
					String carNum = "";					
					if(carFullNum != null && carFullNum != ""){
						carNum = carFullNum.substring(11);
					} 
					
			%>
			<TR>
				<TD height="39" align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'><%=i+1%></SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'><%=ht.get("CAR_NM")%></SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'><%=ht.get("CAR_NO")%></SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
				</TD>
				<TD valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'>
						<div align="left" style="float: left;">&nbsp;\</div> 
						<div align="right"><%=Util.parseDecimal(ht.get("AMT6"))%>&nbsp;</div>						
					</SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'><%=carNum%><%-- <%=ht.get("CAR_NUM")%> --%></SPAN>
				</TD>
				<TD align="center" valign="middle">
					<SPAN STYLE='font-size:11.0pt;font-family:"돋움";line-height:160%;'></SPAN>
				</TD>
			</TR>
			<%}%>
		  </TABLE>
		</td>
	</tr>
	<TR>
		<TD colspan="5" height="29" align="center" style='border:none;'><br><br><br>
			<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>201 &nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일<br><br><br>
			근저당권자 : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)</SPAN>
		</TD>
	</TR>
</table>
</div>

<!-- 위임장 -->
<div class="a4">
<table width="650">
	<TR>
		<TD valign="middle" align="center" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt' colspan="3">
			<SPAN STYLE='font-size:28.0pt;font-family:"돋움";font-weight:"bold";line-height:180%;'>위 &nbsp;&nbsp;임 &nbsp;&nbsp;장</SPAN>
		</TD>
	</TR>
	<tr>
		<td height=1 bgcolor="#000000;" colspan="3"></td>
	</tr>
	<tr>
		<td height=60 style='border:none;'></td>
	</tr>
	<tr>
		<td width="80" align="center" rowspan="3" valign="top" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt;'><SPAN STYLE='font-size:13.0pt;font-family:"돋움";line-height:160%;'>수임자<br>(대리인)</span></td>
		<td width="120" align="right" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:230%;'>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 소 :</span></td>
		<td width="440" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:230%;'>&nbsp;</span></td>
	</tr>
	<tr>
		<td width="120" style='border:none;' align="right"><SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:230%;'>성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 명 :</span></td>
		<td width="440" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:230%;'>&nbsp;</span></td>
	</tr>
	<tr>
		<td width="120" style='border:none;' align="right"><SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:230%;'>주민등록번호 :</span></td>
		<td width="440" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:230%;'>&nbsp;</span></td>
	</tr>
	<tr>
		<td colspan="3" style='border:none; padding:2.8pt 5.7pt 2.8pt 5.7pt;'> <br><br><SPAN STYLE='font-size:14.0pt;font-family:"돋움";line-height:240%;'>상기인에게 아래 목록에 기재된 자동차의 근저당권 말소 등록신청에 관하여 
		일체의 행위를 위임합니다.</span></td>
	</tr>
	<TR>
		<TD  colspan="3" height="29" align="center" style='border:none;'><br><br>
			<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:140%;'>201&nbsp;&nbsp;&nbsp;&nbsp; 년 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일</SPAN><br><br><br><br>
		</TD>
	</TR>
	<tr>
		<td width="100" align="center" rowspan="2" valign="top" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt;'><SPAN STYLE='font-size:13.0pt;font-family:"돋움";line-height:160%;'>채권자 겸<br>근저당권자</span></td>
		<td width="120" align="right" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:230%;'>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 소 : </span></td>
		<td width="420"  style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:230%;'>&nbsp;</span></td>
	</tr>
	<tr>
		<td width="120" style='border:none;' align="right"><SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:230%;'>성&nbsp;&nbsp;&nbsp;명(상호) :</span></td>
		<td width="420" style='border:none;'><SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:230%;'>&nbsp;</span></td>
	</tr>
	<tr>
		<td style="border:none;" colspan="3"><br><br><br><br>
			<TABLE cellspacing="0" cellpadding="0"  width="650">
				<TR bgcolor="#CCCCCC" >
					<TD height="39" align="center" valign="middle" >
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>자동차등록번호</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>자동차명</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>형식</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>차대번호</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>원동기번호</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>사용본거지</SPAN>
					</TD>
				</TR>
				<TR>						
					<TD height="39" align="center" valign="middle" colspan="6">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>별지 첨부 확인</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="39" align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'> </SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="39" align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'> </SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="39" align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'> </SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="39" align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'> </SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
				<TR>
					<TD height="39" align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'> </SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'></SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
					<TD align="center" valign="middle">
						<SPAN STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>&nbsp;</SPAN>
					</TD>
				</TR>
		  </TABLE>
		</td>
	</tr>
</table>
</div>

<!-- 별지 -->
<div class="a4">
<table width="650">
	<TR>
		<TD valign="middle" align="center" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt' colspan="4">
			<SPAN STYLE='font-size:20.0pt;font-family:"돋움";font-weight:"bold";line-height:180%;'>&lt; 별 &nbsp;&nbsp;지 &gt;</SPAN>
			<br><br>
		</TD>
	</TR>
	<tr>
		<td valign="middle" align="center" style='border:none;padding:2.8pt 5.7pt 2.8pt 5.7pt' colspan="4">
			<span STYLE='font-size:16.0pt;font-family:"돋움";font-weight:"bold";line-height:180%;'>* 대출 실행 일자 : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		</td>	
	</tr>
	<tr bgcolor="#CCCCCC" >
		<td height="32" align="center" valign="middle" >
			<span STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>연번</span>
		</td>
		<td align="center" valign="middle">
			<span STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>차량번호</span>
		</td>
		<td align="center" valign="middle">
			<span STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>차명</span>
		</td>
		<td align="center" valign="middle">
			<span STYLE='font-size:12.0pt;font-family:"돋움";line-height:160%;'>채권가액</span>
		</td>						
	</tr>
	<% 
		int countNum = 0;
		for(int i=0;i < vt_size;i++){								
			vid_num = vid[i];								
			rent_l_cd = vid_num.substring(0,13);
			rent_mng_id = vid_num.substring(13,19);
			doc_id = vid_num.substring(19);								
			Hashtable ht = FineDocDb.getReg_msprint(doc_id, rent_l_cd, rent_mng_id);
			countNum++;
	%>
	<tr>
		<td height="32" align="center" valign="middle" >
			<span style='font-size:12.0pt;font-family:"돋움";line-height:160%;'><%=countNum%></span>
		</td>
		<td align="center" valign="middle">
			<span style='font-size:12.0pt;font-family:"돋움";line-height:160%;'><%=ht.get("CAR_NO")%></span>
		</td>
		<td align="center" valign="middle">
			<span style='font-size:12.0pt;font-family:"돋움";line-height:160%;'><%=ht.get("CAR_NM")%></span>
		</td>
		<td align="center" valign="middle">
			<span style='font-size:12.0pt;font-family:"돋움";line-height:160%;'>
				<div align="left" style="float: left;">&nbsp;\</div>
				<div align="right"><%=Util.parseDecimal(ht.get("AMT6"))%>&nbsp;</div>
			</span>
		</td>						
	</tr>
	<%}%>
</table>
</div>
</form>
</body>
</html>
