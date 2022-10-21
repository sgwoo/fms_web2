<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>

<%
	//세금계산서 메일
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String gubun 		= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String reg_code 	= request.getParameter("item_reg_code")==null?"":request.getParameter("item_reg_code");
	String tax_no 		= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String reg_dt 		= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	
	if(gubun.length() >1 && reg_code.equals("") && tax_no.equals("")){
		if(gubun.length() == 28){//ex:1=201109210710013860==008812
			String t_gubun = gubun;
			gubun 		= t_gubun.substring(0,1);
			reg_code 	= t_gubun.substring(1,20);
			client_id	= t_gubun.substring(22,28);
		}
		if(gubun.length() == 30){//ex:1=201109210710013860=01=008812
			String t_gubun = gubun;
			gubun 		= t_gubun.substring(0,1);
			reg_code 	= t_gubun.substring(1,20);
			site_id 	= t_gubun.substring(21,23);
			client_id	= t_gubun.substring(24,30);
		}
	}
	
	if(!reg_code.equals("") && tax_no.equals("")){
		gubun = "1";
	}
	if(reg_code.equals("") && !tax_no.equals("")){
		gubun = "2";
	}
	
	Hashtable ht = IssueDb.getTaxMailCase(gubun, reg_code, tax_no, client_id, site_id);	
	
	if(String.valueOf(ht.get("CLIENT_ID")).equals("null") || String.valueOf(ht.get("CLIENT_ID")).equals("")){
		ht = IssueDb.getTaxMailCase2(gubun, reg_code, tax_no, client_id, site_id);
	}
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(client_id, site_id);
	
	if(String.valueOf(ht.get("CLIENT_ID")).equals("null") || String.valueOf(ht.get("CLIENT_ID")).equals("")){
		ht.put("NAME", 		client.getFirm_nm());
		ht.put("CLIENT_ID", client_id);
		ht.put("SEQ", 		site_id);
		ht.put("REG_DT",	AddUtil.getDate());
		ht.put("TAX_CNT",	"1");
		ht.put("TAX_YEAR",	AddUtil.getDate(1));
		ht.put("TAX_MON",	AddUtil.getDate(2));		
	}
	
	//out.println(ht.get("USER_NM"));
	//out.println(ht.get("USER_H_TEL"));

	if(String.valueOf(ht.get("USER_NM")).equals("null") || String.valueOf(ht.get("USER_NM")).equals("")){	
		String tax_user_id = nm_db.getWorkAuthUser("세금계산서담당자");
		UsersBean tax_user_bean = umd.getUsersBean(tax_user_id);
		
		ht.put("USER_NM",	tax_user_bean.getUser_nm());
		ht.put("USER_H_TEL",	tax_user_bean.getHot_tel());
	}
	
	//out.println(ht.get("USER_NM"));
	//out.println(ht.get("USER_H_TEL"));
	
	
	//차량이 1건일 때만 (통합발행은 담당자가 서로 상이하므로 담당자 노출 안함)
	
	String mng_nm = "";
	String mng_hp = "";
	
	String l_cd = "";
	l_cd = c_db.getTaxRent_l_cd(tax_no);
	
	if ( !l_cd.equals("") ) {
	     
	     Hashtable ht1 = c_db.getDamdang(l_cd);
	     
	     mng_nm = String.valueOf(ht1.get("USER_NM"));
		 mng_hp = String.valueOf(ht1.get("HOT_TEL"));
	
	}
		
%>

<html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title>전자 세금계산서 메일링</title>
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
				<span style="font-size:20px;">아마존카 전자세금계산서 발행 안내문</span>
			</div>
			<div style="margin: 30px 20px; font-family: nanumgothic; font-size:13px; border: 3px solid #e0e0e0;">
				<div style="padding: 10px 0px 10px 50px; text-align: left; line-height: 22px;">
					<span style="font-weight: bold;"><%=ht.get("NAME")%></span>&nbsp;님<br>
					<span style="color: #FF00FF; font-weight: bold;"><%=ht.get("TAX_MON")%>월</span> 세금계산서가 발행되었습니다.<br>
					아래 "세금계산서 수신하기" 버튼을 누르시면 바로 확인가능합니다.
				</div>
			</div>
			<!-- title_end -->	
			<!-- content_start -->
			<div style="margin: 20px 20px;">
				<table border=0 cellspacing=0 cellpadding=0 style="width: 100%;">
					<tr>
						<th style="text-align: center; width: 40%; border-top: 2px solid #aea8b7; border-bottom: 1px solid #dfdde2; background-color: #efeef1;"><span style="font-family:nanumgothic;font-size:12px;">발급일자</span></th>
						<td style="text-align: center; width: 60%; border-top: 2px solid #aea8b7; border-bottom: 1px solid #dfdde2;">&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=ht.get("REG_DT")%></span></td>
					</tr>
					<tr>
						<th style="text-align: center; width: 40%; border-bottom: 2px solid #aea8b7; background-color: #efeef1;"><span style="font-family:nanumgothic;font-size:12px;">문서건수</span></th>
						<td style="text-align: center; width: 60%; border-bottom: 2px solid #aea8b7;">&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=ht.get("TAX_CNT")%> 건</span></td>
					</tr>
				</table>
			</div>
			<div style="padding: 10px 20px;">
				<%-- <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?client_id=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>" target="_blank" style="padding: 5px 15px; background: #efefef; text-decoration: none; border-radius: 5px; color: #000000; border: 1px solid #000; font-size: 15px;"> --%>
				<a href="https://client.amazoncar.co.kr/clientIndex?clientId=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>" target="_blank" style="padding: 5px 15px; background: #efefef; text-decoration: none; border-radius: 5px; color: #000000; border: 1px solid #000; font-size: 15px;">
					세금계산서 수신하기
				</a>
			</div>
			<!-- 
			<div style="padding: 10px 20px 40px 20px; text-align: right; font-size: 10px;">
				※ <a href="http://fms1.amazoncar.co.kr/mailing/tax_bill/index_info.jsp" target="_blank">수신방법</a>
			</div>
			 -->
			<div style="margin: 0px 20px 5px 20px; font-family: nanumgothic; font-size: 14px; line-height: 22px; text-align: left; font-weight: bold; border-bottom: 1px solid #9cb445;">
				* 비밀번호
			</div>
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 12px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px 10px 10px 30px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px; text-align: left;">
					<!-- 1. 비밀번호는 "고객 FMS" 로그인 비밀번호를 입력하셔야 합니다.<br>
					2. 처음 방문하시는 고객은 법인/개인사업자-사업자등록번호, 개인-생년월일를 입력하셔야 합니다.<br>
					3. 입력하신 비밀번호가 일치하지 않을 경우에는 <span style="color: #f75802;">IT팀 02-392-4243</span> 또는 <span style="color: #f75802;">메일(<a href=mailto:dev@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">dev@amazoncar.co.kr</span></a>)</span>로<br>					
					&nbsp;&nbsp;&nbsp;연락주시기 바랍니다.
					 -->
					  1. 비밀번호는 법인/개인사업자-사업자등록번호, 개인-생년월일를 입력하셔야 합니다.<br>
					2. 입력하신 비밀번호가 일치하지 않을 경우에는 <span style="color: #f75802;">IT팀 02-392-4243</span> 또는 <span style="color: #f75802;">메일(<a href=mailto:dev@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">dev@amazoncar.co.kr</span></a>)</span>로<br>					
					&nbsp;&nbsp;&nbsp;연락주시기 바랍니다.
				</div>
			</div>
			
			<div style="margin: 0px 20px 5px 20px; font-family: nanumgothic; font-size: 14px; line-height: 22px; text-align: left; font-weight: bold; border-bottom: 1px solid #9cb445;">
				* 수신담당자 변경방법
			</div>
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 12px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px 10px 10px 30px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px; text-align: left;">
					&quot;<span style="color: #f75802;">고객 FMS</span>&quot;에 로그인하여 담당자를 직접 변경하거나 <span style="color: #f75802;">회계담당자 <%=ht.get("USER_H_TEL")%></span> 에게 연락주시기 바랍니다.
				</div>
			</div>
			
			<div style="margin: 0px 20px 5px 20px; font-family: nanumgothic; font-size: 14px; line-height: 22px; text-align: left; font-weight: bold; border-bottom: 1px solid #9cb445;">
				* 수신시 주의사항
			</div>
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 12px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px 10px 10px 30px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px; text-align: left;">
					고객님께서 수신할 문서가 아니시면 <span style="color: #f75802;">메일(<a href=mailto:tax@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">tax@amazoncar.co.kr</span></a>)</span>로 연락주시기 바랍니다.
				</div>
			</div>			
			
			<div style="padding: 25px 0px 10px 0px;">
				<div style="margin: 0px 15px; padding: 20px; font-family: nanumgothic; font-size: 11px; border-top: 1px dotted; border-bottom: 1px dotted;">
					본 메일은 발신전용 메일이므로 궁금한 사항은 <a href="mailto:tax@amazoncar.co.kr"><span style="font-size: 11px; color: #af2f98; font-family: nanumgothic;">수신메일(tax@amazoncar.co.kr)</span></a>로 보내주시기 바랍니다.</span>
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
							<td style="width: 60px; text-align: center;">본사</td>
							<td style="width: 85px; color: red;">02-757-0802</td>
							<td style="width: 60px; text-align: center;">광화문</td>
							<td style="width: 85px; color: red;">02-2038-8661</td>
							<td style="width: 60px; text-align: center;">강남</td>
							<td style="width: 85px; color: red;">02-537-5877</td>
							<td style="width: 60px; text-align: center;">송파</td>
							<td style="width: 85px; color: red;">02-2038-2492</td>
						</tr>
						<tr>
							<td style="width: 60px; text-align: center;">인천</td>
							<td style="width: 85px; color: red;">032-554-8820</td>
							<td style="width: 60px; text-align: center;">수원</td>
							<td style="width: 85px; color: red;">031-546-8858</td>
							<td style="width: 60px; text-align: center;">대전</td>
							<td style="width: 85px; color: red;">042-824-1770</td>
							<td style="width: 60px; text-align: center;">대구</td>
							<td style="width: 85px; color: red;">053-582-2998</td>
						</tr>
						<tr>
							<td style="width: 60px; text-align: center;">부산</td>
							<td style="width: 85px; color: red;">051-851-0606</td>
							<td style="width: 60px; text-align: center;">광주</td>
							<td colspan="5" style="width: 85px; color: red;">062-385-0133</td>
						</tr>
						<tr>
							<td colspan="8" style="height: 8px;"></td>
						</tr>
						<tr>
							<td style="width: 60px; text-align: center;">고객지원</td>
							<td style="width: 85px; color: red;">02-392-4242</td>
							<td style="width: 60px; text-align: center;">총무</td>
							<td colspan="5" style="width: 85px; color: red;">02-392-4243</td>
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