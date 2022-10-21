<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String mail_code	 	= request.getParameter("mail_code")==null?"1":request.getParameter("mail_code");
	String doc_code	 	= request.getParameter("doc_code")==null?"":request.getParameter("doc_code");
	
	String sign_type 	= request.getParameter("sign_type")==null?"":request.getParameter("sign_type");
	
	Hashtable ht = ln_db.getLcRentLinkM(rent_l_cd, rent_st);
	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<title>
<%if(String.valueOf(ht.get("DOC_TYPE")).equals("1")){ %>
	장기 계약서
<%} else if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){ %>
	승계 계약서
<%} else if(String.valueOf(ht.get("DOC_TYPE")).equals("3")){ %>
	연장 계약서
<%} %>
</title>
</head>
<style>
body {
	margin-left: 0px;
	margin-top: 0px;
	font-family: dotum,'돋움',gulim,'굴림',Helvetica,Apple-Gothic,sans-serif;
	font-size:0.75em;
	text-align:center;
}
.style1 {
	font-size:2.0em;
	font-weight:bold;
}
.style2 {
	font-size:1.1em;
	font-weight:bold;
	vertical-align:middle;
}
.style3{
	font-size:0.8em;
}
.style4{
	font-size:0.9em;
}
.style5{
	text-decoration:underline;
	text-align:right;
	padding-right:20px;
}
.style6{
	font-size:1.1em;
}
.style7{
	text-decoration:underline;
}
.style8 {
	font-size:1.4em;
	font-weight:bold;
}
.style9{
	letter-spacing: -1px;
}	
.endline{
	page-break-before:always
}
checkbox{
	padding:0px;
}

table {text-align:left; border-collapse:collapse; vertical-align:middle;}
.doc table {border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em;}
.doc table td {border:1px solid #000000; height:14px;}
.doc table td.title {font-weight:bold; background-color:#e8e8e8;}
.doc1 table {border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em;}
.doc1 table td {border:1px solid #000000; height:13px; padding:2px; line-height:1.22em;}
.doc1 table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:13px; padding:2px; }
p {padding:1px 0 1px 0;}
.doc1 table td.pd{padding:1px;}
.doc table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:13px; padding:2px; }
.doc1 table th.ht{height:50px;}

.doc_a table {border:1px solid #000000; font-size:0.85em; width:100%;}
.doc_a table td.nor {padding:5px 10px 2px 10px;}
.doc_a table td.con {padding:0 10px 0 25px; line-height:10px;}
.cnum table {width:157px; border:1px solid #000000; font-size:0.85em;}
.cnum table td{border:1px solid #000000; height:12px; padding:3px;}
.cnum table th{background-color:#e8e8e8;}

table.doc_s {width:200px; padding:0px;}
table.doc_s td{padding:0px; height:13px;}
table.doc_s th{padding:0px;}
.left {text-align:left;}
.center {text-align:center;}
.right {text-align:right;}
.fs {font-size:0.9em; font-weight:normal;}
.fss {font-size:0.85em;}
.lineh {line-height:12px;}
.name {padding-top:8px; padding-bottom:5px; line-height:14px;}
.ht{height:45px;}
.point{background-color:#e1e1e1; padding-top:3px; font-weight:bold;}
.agree{padding-bottom:5px;}
table.zero { border:0px; font-size:1.15em;}

.a4 { page: a4sheet; page-break-after: always }

</style>
<style type="text/css" media="print">
    @page {
        size:  auto;
        margin: 0mm;
    }
    html {
        background-color: #FFFFFF; 
        margin: 0px;
    }    
    body {
        /* margin으로 프린트 여백 조정 */
        /* IE */
        margin: 5mm 10mm 5mm 10mm;
        
        /* CHROME */
        -webkit-margin-before: 0px; /*상단*/
		-webkit-margin-end: 0px; /*우측*/
		-webkit-margin-after: 5mm; /*하단*/
		-webkit-margin-start: 0px; /*좌측*/
    }
    .divide_page {
    	height: 20px;
    }
</style>

<body>

<div align="center">
	<form action="" name="form1" method="POST" >
		<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
		<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
		<input type="hidden" name="rent_st" value="<%=rent_st%>">
		
		<!-- 계약서 -->
		<div class="a4">
			<table width="680" style="margin-top: 30px;">
				<%@ include file="newcar_doc_1.jsp" %>
			</table>
		</div>
		<div class="a4">
			<table width="680">
				<%@ include file="newcar_doc_2.jsp" %>
			</table>
		</div>	
		
		<!-- 약관 -->
		<table width="680">
			<tr>
				<td>
					<div class="a4" style="padding-top: 20px;">
					<%if(String.valueOf(ht.get("CAR_ST")).contains("리스")){ // 리스%>
						<img alt="lease_serv_term_A4_1" src="http://fms1.amazoncar.co.kr/fms2/images/lease_serv_term_A4_1.jpg" width="500%" style="max-width: 672px;">
					<%}else{ 	//렌트%>
						<img alt="rent_serv_term_A4_1" src="http://fms1.amazoncar.co.kr/fms2/images/rent_serv_term_A4_1.jpg" width="500%" style="max-width: 680px;">
					<%} %>
					</div>
				</td>
			</tr>	
			<tr>
				<td>
					<div class="a4" style="padding-top: 50px;">
					<%if(String.valueOf(ht.get("CAR_ST")).contains("리스")){ // 리스%>
						<img alt="lease_serv_term_A4_2" src="http://fms1.amazoncar.co.kr/fms2/images/lease_serv_term_A4_2.jpg" width="500%" style="max-width: 672px;">
					<%}else{ 	//렌트%>
						<img alt="rent_serv_term_A4_2" src="http://fms1.amazoncar.co.kr/fms2/images/rent_serv_term_A4_2.jpg" width="500%" style="max-width: 680px;">
					<%} %>			
					</div>
				</td>
			</tr>
		</table>
		
		<!-- 개인정보 동의서 -->
		<div class="a4">
			<table width="680" style="margin-top: 30px;">
				<%@ include file="personal_info_form.jsp" %>
			</table>
		</div>
		
		<!-- CMS 출금이체 신청서 -->
		<%if(sign_type.equals("2") && !String.valueOf(ht.get("CLIENT_ST")).equals("법인")){ // 자필서명인 경우. 법인은 제외.%>
		<div class="a4">
			<table width="680" style="margin-top: 30px;">
				<%@ include file="cms_form.jsp" %>
			</table>
		</div>
		<%} %>
	</form>
</div>
</body>
</html>
