<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String print_yn 	= request.getParameter("print_yn")==null?"":request.getParameter("print_yn");
	
	String paper_size 	= request.getParameter("paper_size")==null?"":request.getParameter("paper_size");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	CarOfficeDatabase cod 	= CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);

	// 최초 계약일 조회
	String temp_first_rent_dt = a_db.getFirstRentDt(rent_mng_id);
	int first_rent_dt = Integer.parseInt(temp_first_rent_dt);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
		
	//신차대여정보
	ContFeeBean f_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//해당대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
		
	//이행보증보험
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	int gin_size 	= a_db.getGinCnt(rent_mng_id, rent_l_cd);
	if(gin_size==0) gin_size = 1;
	ContGiInsBean ext_gin = new ContGiInsBean();
	/* for(int f=1; f<=gin_size ; f++){
		ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));	
	} */	
	//연장회차에 맞는 보증보험을 조회하기 위해 수정(20190828)
	ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, rent_st);
	
	//전계약매입옵션
	int fee_opt_amt = 0;
	if(rent_st.equals("2")){
		fee_opt_amt = f_fee.getOpt_s_amt()+f_fee.getOpt_v_amt();
	}else if(AddUtil.parseInt(rent_st) >2){
		ContFeeBean a_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(AddUtil.parseInt(rent_st)-1));	
		fee_opt_amt = a_fee.getOpt_s_amt()+a_fee.getOpt_v_amt();
	}
	
	//차량기본정보
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");

	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	int rtn_run_amt = fee_etc.getRtn_run_amt();	// 환급 대여료
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	
	//담당자
	UsersBean bus_user_bean 	= umd.getUsersBean(fee.getExt_agnt());
		
	
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
	
	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<title>무제 문서</title>
<script language="JavaScript">
<!--	
	//출력하기
	function go_print(){
		var fm = document.form1;
		fm.print_yn.value = 'Y';
		fm.action='newcar_doc.jsp';		
		fm.target='_self';		
		fm.submit();
	}
	
	//메일수신하기
	function go_mail(){			
		var SUBWIN="mail_input.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=rent_st%>&print_yn=<%=print_yn%>&content_st=newcar_doc";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=450, scrollbars=no, status=yes");
	}	
		
//-->
</script>
</head>
<style>
<!--
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
	vertical-align:middle;}
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

.style8 {
	font-size:1.4em;
	font-weight:bold;}
.style9{
	letter-spacing: -1px;
}	
.endline{page-break-before:always}
	
checkbox{padding:0px;}

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

@page a3sheet { size: 42.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

-->
</style>

<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
</object>
<body  onLoad="javascript:onprint();">
<div align="center">
<form action="" name="form1" method="POST" >
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="rent_st" value="<%=rent_st%>">
<input type="hidden" name="print_yn" value="<%=print_yn%>">
<input type="hidden" name="content_st" value="newcar_doc">


<%if(!paper_size.equals("A3")){%>
<div class="a4">
<table width="680">
	<%@ include file="newcar_doc_sg_1.jsp" %>
</table>
</div>	
<div class="a4">
<table width="680">
	<%@ include file="newcar_doc_sg_2.jsp" %>
</table>
</div>	
<table width="680">
	<tr>
		<td>
		<div class="a4">
		<%if(first_rent_dt < 20220415){ // 최초 계약일 2022.04.14 이전이면 기존 약관%>
			<%if(base.getCar_st().equals("3")){	//리스 %>
				<img alt="lease_serv_term_A4_1" src="http://fms1.amazoncar.co.kr/fms2/images/lease_serv_term_A4_1.jpg" width="500%" style="max-width: 672px;">
			<%}else{ 	//렌트%>
				<img alt="rent_serv_term_A4_1" src="http://fms1.amazoncar.co.kr/fms2/images/rent_serv_term_A4_1.jpg" width="500%" style="max-width: 680px;">
			<%} %>
		<%}else{ // 최초계약일 2022.04.15 이후면 신규 양식%>
			<%if(base.getCar_st().equals("3")){	//리스 %>
				<img alt="lease_serv_term_A4_1" src="http://fms1.amazoncar.co.kr/fms2/images/lease_serv_term_A4_2022_1.png" width="230%" style="max-width: 680px; margin-top: 40px;">
			<%}else{ 	//렌트%>
				<img alt="rent_serv_term_A4_1" src="http://fms1.amazoncar.co.kr/fms2/images/rent_serv_term_A4_2022_1.png" width="230%" style="max-width: 680px;">
			<%} %>
		<%} %>
		</div>
		</td>
	</tr>	
	<tr>
		<td>
			<div class="a4">
			<%if(first_rent_dt < 20220415){ // 최초 계약일 2022.04.14 이전이면 기존 약관%>
				<%if(base.getCar_st().equals("3")){	//리스 %>
					<img alt="lease_serv_term_A4_2" src="http://fms1.amazoncar.co.kr/fms2/images/lease_serv_term_A4_2.jpg" width="500%" style="max-width: 672px;">
				<%}else{ 	//렌트%>
					<img alt="rent_serv_term_A4_2" src="http://fms1.amazoncar.co.kr/fms2/images/rent_serv_term_A4_2.jpg" width="500%" style="max-width: 680px;">
				<%} %>
			<%}else{ // 최초계약일 2022.04.15 이후면 신규 양식%>
				<%if(base.getCar_st().equals("3")){	//리스 %>
					<img alt="lease_serv_term_A4_2" src="http://fms1.amazoncar.co.kr/fms2/images/lease_serv_term_A4_2022_2.png" width="230%" style="max-width: 680px; margin-top: 40px;">
				<%}else{ 	//렌트%>
					<img alt="rent_serv_term_A4_2" src="http://fms1.amazoncar.co.kr/fms2/images/rent_serv_term_A4_2022_2.png" width="230%" style="max-width: 680px;">
				<%} %>
			<%} %>
			</div>
		</td>
	</tr>
</table>
<%}else{%>


<table width="1440">
	<tr>
		<td>
			<table width="680"><%@ include file="newcar_doc_sg_1.jsp" %></table>
		</td>
		<td width=80>&nbsp;</td>
		<td>
			<table width="680"><%@ include file="newcar_doc_sg_2.jsp" %></table>
		</td>
	</tr>
</table>
	<%if(first_rent_dt < 20220415){ // 최초 계약일 2022.04.14이전이면 기존 약관%>
	<table width="1440" style="margin-top: -50px;">
		<tr>
			<td valign=top>
				<table width="680"><tr><td>
				<%if(base.getCar_st().equals("3")){	//리스 %>
					<img alt="lease_serv_term_A4_1" src="http://fms1.amazoncar.co.kr/fms2/images/lease_serv_term_A4_1.jpg" width="100%">
				<%}else{ 	//렌트%>
					<img alt="rent_serv_term_A4_1" src="http://fms1.amazoncar.co.kr/fms2/images/rent_serv_term_A4_1.jpg" width="100%">
				<%} %>
				</td></tr></table>
			</td>
			<td width=80>&nbsp;</td>
			<td>
				<table width="680"><tr><td>
				<%if(base.getCar_st().equals("3")){	//리스 %>
					<img alt="lease_serv_term_A4_2" src="http://fms1.amazoncar.co.kr/fms2/images/lease_serv_term_A4_2.jpg" width="100%">
				<%}else{	//렌트 %>
					<img alt="rent_serv_term_A4_2" src="http://fms1.amazoncar.co.kr/fms2/images/rent_serv_term_A4_2.jpg" width="100%">
				<%} %>
				</td></tr></table>
			</td>
		</tr>
	</table>
	<%} else { // 최초 계약일 2022.04.15 이후면 신규 약관 노출%>
	<table width="1440" style="margin-top: -50px;">
		<tr>
			<td>
				<%if(base.getCar_st().equals("3")){	//리스 %>
					<img alt="lease_serv_term_A3" src="http://fms1.amazoncar.co.kr/fms2/images/lease_serv_term_A3_2022.png" width="100%">
				<%}else{ %>
					<img alt="rent_serv_term_A3" src="http://fms1.amazoncar.co.kr/fms2/images/rent_serv_term_A3_2022.png" width="100%">
				<%} %>
			</td>
		</tr>	
	</table>
	<%}%>
<%}%>
</form>
</div>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>	

<script>
function onprint(){

factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.leftMargin = 0.0; //좌측여백   
factory.printing.topMargin = 0.0; //상단여백    
factory.printing.rightMargin = 0.0; //우측여백
factory.printing.bottomMargin = 0.0; //하단여백

<%if(paper_size.equals("A4")){%>
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
<%}else if(paper_size.equals("A3")){%>
factory.printing.portrait = false; //true-세로인쇄, false-가로인쇄    
alert('인쇄미리보기에서 페이퍼사이즈를 A3로 변경후 인쇄하세요.');
<%}%>


}
</script>
