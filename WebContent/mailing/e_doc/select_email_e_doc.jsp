<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.alink.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>

<%
	String doc_code = request.getParameter("doc_code")==null?"":request.getParameter("doc_code");
		
	//전자문서 정보 doc_code 
	Hashtable ht = ln_db.getALink("e_doc_mng", doc_code);
	String sign_type = ht.get("SIGN_TYPE")+"";
	String doc_type = ht.get("DOC_TYPE")+"";
%>

<html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title>아마존카 전자문서</title>
<style type="text/css">
<!--
.style1 {
	color: #747474;
	font-weight: bold;
	font-family:nanumgothic;
}
.style2 {color: #747474}
.style3 {
	color: #ff00ff;
	font-weight: bold;
}
.style4 {color: #626262}
.style5 {color: #376100}
.style6 {
	color: #FFFFFF;
	font-weight: bold;
}
.style8 {color: #696969}
.style9 {
	color: #f75802;
}
-->
</style>


</head>
<body topmargin=0 leftmargin=0>

<div style="width: 700px; margin: 0 auto;">
	<div style="padding: 5px 10px; text-align: left;">
		<a href="https://www.amazoncar.co.kr" target="_blank">
			<img src="https://www.amazoncar.co.kr/resources/images/logo_1.png" style="width: 150px;"/>
		</a>
	</div>
	<div style="text-align: center; width: 700px; background-color: #9bb345; border: 1px solid #d2e38d; border-radius: 10px;">
		<div style="text-align: center; width: 700px; background-color: #FFFFFF; border-radius: 10px; margin: 8px 0px;">
			<!-- title_start -->
			<div style="padding: 20px 20px;">
				<span style="font-size:20px;">아마존카 전자문서 발송 안내문</span>
			</div>
			<div style="margin: 30px 20px; font-family: nanumgothic; font-size:13px; border: 3px solid #e0e0e0;">
				<div style="padding: 10px 0px 10px 50px; text-align: left; line-height: 22px;">
					<span style="font-weight: bold;"><%=ht.get("FIRM_NM")%></span>&nbsp;님<br>
					<%if(sign_type.equals("1") || sign_type.equals("2")){ %>
					<span style="color: #FF00FF; font-weight: bold;"><%=ht.get("DOC_NAME") %></span> 서명요청이 왔습니다. 문서를 확인하고 서명해주세요.<br>
					<%}else{ %>
					<span style="color: #FF00FF; font-weight: bold;"><%=ht.get("DOC_NAME") %></span> 문서가 발송되었습니다. 문서를 확인하고 저장해주세요.<br>
					<%} %>	
					(저장 및 확인 가능기간 : 발송일로부터 30일, 별도 저장 요망)<br>
					<%if(doc_type.equals("1")){ %>										
					<%	if(sign_type.equals("1")){ %>
					* 장기대여계약서 인증서 서명인 경우 자동이체신청서는 별도로 메일발송됩니다. 신청서 작성후 회신하여 주십시오.<br>
					<%	} %>
					* 담당자 연락처는 계약서를 참고하십시오.
					<%} %>			
				</div>
			</div>
			<!-- title_end -->	
			<!-- content_start -->			
			<div style="padding: 10px 20px;">				
				<a href="https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code=<%=doc_code%>" target='_blank' style="padding: 5px 15px; background: #efefef; text-decoration: none; border-radius: 5px; color: #000000; border: 1px solid #000; font-size: 15px;">
					문서 확인하기
				</a>
			</div>
			
			<div style="padding: 25px 0px 10px 0px;">
				<div style="margin: 0px 15px; padding: 2px; font-family: nanumgothic; font-size: 11px; ">
					유효기간 (<%=ht.get("REG_DT") %>~<%=ht.get("TERM_DT") %>)
				</div>
			</div>
			
			<div style="margin: 0px 20px 5px 20px; font-family: nanumgothic; font-size: 14px; line-height: 22px; text-align: left; font-weight: bold; border-bottom: 1px solid #9cb445;">
				* 고객인증
			</div>
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 12px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px 10px 10px 30px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px; text-align: left;">				
					1. 비밀번호는 법인/개인사업자-사업자등록번호, 개인-생년월일를 입력하셔야 합니다.<br>
					2. 입력하신 비밀번호가 일치하지 않을 경우에는 <span style="color: #f75802;">IT팀 02-392-4243</span> 또는 <span style="color: #f75802;">메일(<a href=mailto:dev@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">dev@amazoncar.co.kr</span></a>)</span>로<br>
					&nbsp;&nbsp;&nbsp;연락주시기 바랍니다.
				</div>
			</div>
			
			<div style="margin: 0px 20px 5px 20px; font-family: nanumgothic; font-size: 14px; line-height: 22px; text-align: left; font-weight: bold; border-bottom: 1px solid #9cb445;">
				* 수신시 주의사항
			</div>
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 12px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px 10px 10px 30px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px; text-align: left;">
					1. 고객님께서 수신할 문서가 아니시면 <span style="color: #f75802;">메일(<a href=mailto:dev@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">dev@amazoncar.co.kr</span></a>)</span>로 연락주시기 바랍니다.<br>
					2. 이 메일과 링크를 공유하지 마십시오. 승인하지 않은 제3자가 내용을 확인할 수 있습니다.<br>
					3. 메일계정을 유지하여 주십시오. 서명 진행과 관련된 내용이 메일로 전송됩니다. 메일 삭제, 수신 거부 등 사용자의 귀책사유로 메일이 전송되지 않는 문제가 발생할 수 있습니다.<br>
					4. 입력한 서명은 법적효력이 인정됩니다. 당사자 간 동의가 있어야만 입력할 수 있는 아마존카 서명은 전자서명법 제3조3항에 의해 법적 효력이 인정됩니다. 서명 당시의 시간, 아이피 주소 등 서명 진행과 관련된 모든 부분이 기록되며, 서명이 완료된 문서는 이메일로 전송됩니다. 이를 통해 본인/위조/변조 여부를 확인할 수 있습니다.  
				</div>
			</div>	
			
			<div style="padding: 25px 0px 10px 0px;">
				<div style="margin: 0px 15px; padding: 20px; font-family: nanumgothic; font-size: 11px; border-top: 1px dotted; border-bottom: 1px dotted;">
					본 메일은 발신전용 메일이므로 궁금한 사항은 <a href="mailto:dev@amazoncar.co.kr"><span style="font-size: 11px; color: #af2f98; font-family: nanumgothic;">수신메일(dev@amazoncar.co.kr)</span></a>로 보내주시기 바랍니다.</span>
				</div>
			</div>
			<!-- content_end -->
			<!-- footer_start -->
			<div style="margin: 10px 15px 0px 15px; padding-bottom: 20px; font-family: nanumgothic; font-size: 11px; line-height: 20px;">
				<div>
					<table border=0 cellspacing=0 cellpadding=0 style="width: 100%; font-family: nanumgothic; font-size: 11px;">
						<tr>
							<td rowspan="5" style="width: 150px;">
								<img src="https://www.amazoncar.co.kr/resources/images/logo_1.png" style="width: 150px; padding-right: 10px;"/>
							</td>
							<td style="width: 55px; text-align: center;">본사</td>
							<td style="width: 90px; color: red;">02-757-0802</td>
							<td style="width: 55px; text-align: center;">광화문</td>
							<td style="width: 90px; color: red;">02-2038-8661</td>
							<td style="width: 55px; text-align: center;">강남</td>
							<td style="width: 90px; color: red;">02-537-5877</td>
							<td style="width: 55px; text-align: center;">송파</td>
							<td style="width: 90px; color: red;">02-2038-2492</td>
						</tr>
						<tr>
							<td style="width: 55px; text-align: center;">인천</td>
							<td style="width: 90px; color: red;">032-554-8820</td>
							<td style="width: 55px; text-align: center;">수원</td>
							<td style="width: 90px; color: red;">031-546-8858</td>
							<td style="width: 55px; text-align: center;">대전</td>
							<td style="width: 90px; color: red;">042-824-1770</td>
							<td style="width: 55px; text-align: center;">대구</td>
							<td style="width: 90px; color: red;">053-582-2998</td>
						</tr>
						<tr>
							<td style="width: 55px; text-align: center;">부산</td>
							<td style="width: 90px; color: red;">051-851-0606</td>
							<td style="width: 55px; text-align: center;">광주</td>
							<td colspan="5" style="color: red;">062-385-0133</td>
						</tr>
						<tr>
							<td colspan="8" style="height: 8px;"></td>
						</tr>
						<tr>
							<td style="width: 55px; text-align: center;">고객지원</td>
							<td style="width: 90px; color: red;">02-392-4242</td>
							<td style="width: 55px; text-align: center;">총무</td>
							<td colspan="5" style="color: red;">02-392-4243</td>
						</tr>
					</table>
				</div>
				<div style="padding: 20px 0px 0px 0px; text-align: center;">
					<span style="font-family: nanumgothic;">
						서울 영등포구 의사당대로 8 802 (여의도동, 태흥빌딩) | 법인명 : 주식회사 아마존카 | 대표이사 : 조성희
					</span><br>
					<span style="color: #a1a1a2;">Copyright(c) 2004 by amazoncar. All right reserved webmaster@amazoncar.co.kr</span>
				</div>
			</div>
			<!-- footer_end -->
		</div>
	</div>
</div>

</body>
</html>
