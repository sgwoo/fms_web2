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
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	CarOfficeDatabase cod 	= CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
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
	//ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, rent_st);
	int gin_size 	= a_db.getGinCnt(rent_mng_id, rent_l_cd);
	if(gin_size==0) gin_size = 1;
	ContGiInsBean ext_gin = new ContGiInsBean();
	//for(int f=1; f<=gin_size ; f++){
		ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, rent_st);	
	//}				
	
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
	
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	
	//담당자
	UsersBean bus_user_bean 	= umd.getUsersBean(base.getBus_id());
	
	if(!rent_st.equals("1"))	bus_user_bean 	= umd.getUsersBean(fee.getExt_agnt());
	
	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<title>무제 문서</title>
<script language="JavaScript">
<!--	

//-->
</script>
</head>
<style>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	font-family: dotum,'돋움',gulim,'굴림',Helvetica,Apple-Gothic,sans-serif;
	font-size:0.8em;
	text-align:center;
	}
.style1 {
	font-size:2.0em;
	font-weight:bold;
}
.style2 {
	font-size:1.1em;
	font-weight:bold;}
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
		
checkbox{padding:0px;}

table {text-align:left; border-collapse:collapse; vertical-align:middle;}
.doc table {border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em;}
.doc table td {border:1px solid #000000; height:13px;}
.doc table td.title {font-weight:bold; background-color:#e8e8e8;}
.doc1 table {border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em;}
.doc1 table td {border:1px solid #000000; height:13px; padding:3px;}
.doc1 table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:13px; padding:3px; }
p {padding:1px 0 0 0;}
.doc1 table td.pd{padding:3px;}
.doc table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:13px; padding:3px; }
.doc1 table th.ht{height:60px;}

.doc_a table {border:1px solid #000000; font-size:0.85em; width:100%;}
.doc_a table td.nor {padding:5px 10px 2px 10px;}
.doc_a table td.con {padding:0 10px 0 25px; line-height:10px;}
.cnum table {width:44%; border:1px solid #000000; font-size:0.85em;}
.cnum table td{border:1px solid #000000; height:12px; padding:3px;}
.cnum table th{background-color:#e8e8e8;}

table.doc_s {width:200px; padding:0px;}
table.doc_s td{padding:0px; height:15px;}
table.doc_s th{padding:0px;}
.left {text-align:left;}
.center {text-align:center;}
.right {text-align:right;}
.fs {font-size:0.9em; font-weight:normal;}
.fss {font-size:0.85em;}
.lineh {line-height:12px;}
.name {padding-top:8px; padding-bottom:5px; line-height:18px;}
.ht{height:60px;}
.point{background-color:#e1e1e1; padding-top:3px; font-weight:bold;}
.agree{padding:4px 0 4px 0; }

table.zero { border:0px; font-size:1.15em;}

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

-->
</style>

<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<body  onLoad="javascript:onprint();">
<div id="Layer1" style="position:absolute; left:230px; top:1703px; width:54px; height:41px; z-index:1"><img src="http://fms1.amazoncar.co.kr/acar/images/stamp.png" width="75" height="75"></div>
<div id="Layer3" style="position:absolute; left:633px; top:1718px; width:54px; height:41px; z-index:1"><img src="http://fms1.amazoncar.co.kr/acar/images/rect.png"></div>
<div id="Layer4" style="position:absolute; left:478px; top:2020px; width:54px; height:41px; z-index:1"><img src="http://fms1.amazoncar.co.kr/acar/images/rect.png"></div>
<div id="Layer5" style="position:absolute; left:633px; top:1777px; width:54px; height:41px; z-index:1"><img src="http://fms1.amazoncar.co.kr/acar/images/tri.png"></div>
<div id="Layer6" style="position:absolute; left:630px; top:2018px; width:54px; height:41px; z-index:1"><img src="http://fms1.amazoncar.co.kr/acar/images/tri.png"></div>
<div align="center">
<form action="" name="form1" method="POST" >
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="rent_st" value="<%=rent_st%>">
<input type="hidden" name="print_yn" value="<%=print_yn%>">
<input type="hidden" name="content_st" value="newcar_doc">

<table width="680">
	<tr>
		<td colspan="2"><div align="center"><span class=style1>자 동 차  대 여 이 용  계 약 서</span></div></td>
	</tr>
	<tr>
		<td width=48%>&nbsp;<img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png></td>
		<td width=52% class="cnum right">
			<table>
				<tr>
					<th width=45% class="center">차량번호</th>
					<td class="center"><%=cr_bean.getCar_no()%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height=3></td>
	</tr>
  	<tr>
 		<td colspan="2" class="doc">
			<table>
		      	<tr>
			 		<th width="13%">계약번호</th>
			   		<td width="19%">&nbsp;<%=rent_l_cd%></td>
			    	<th width="13%">영업소</th>
			     	<td width="19%">&nbsp;<%=c_db.getNameById(bus_user_bean.getBr_id(),"BRCH")%></td>
			     	<th width="13%">영업담당자</th>
			   		<td width="23%">&nbsp;<%=bus_user_bean.getUser_nm()%>&nbsp;<%=bus_user_bean.getUser_m_tel()%></td>
		   		</tr>
				<tr>
			    	<td class="center title" style="height:24px;">대여상품 구분</td>
			    	<td colspan="4"><input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("1") && fee.getRent_way().equals("1"))%>checked<%%>>장기렌트 일반식 
			    	    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("1") && !fee.getRent_way().equals("1"))%>checked<%%>>장기렌트 기본식 
			    	    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("3") && fee.getRent_way().equals("1"))%>checked<%%>>리스plus 일반식  
			    	    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("3") && !fee.getRent_way().equals("1"))%>checked<%%>>리스plus 기본식</td>
			     	<td><input type="checkbox" name="checkbox" value="checkbox" <%if(rent_st.equals("1") && base.getCar_gu().equals("1"))%>checked<%%>>신차 
			     	    <input type="checkbox" name="checkbox" value="checkbox" <%if(rent_st.equals("1") && base.getCar_gu().equals("0"))%>checked<%%>>재리스
			     	    <input type="checkbox" name="checkbox" value="checkbox" <%if(!rent_st.equals("1"))%>checked<%%>>연장</td>
				</tr>
    		</table>
		</td>
	</tr>
	<tr>
   		<td height=3></td>
	</tr>
	<tr>
    	<td colspan="2"><span class=style2>1. 고객사항</span></td>
	</tr>
	<tr>
    	<td colspan="2" class="doc">
      		<table>
		        <tr>
		        	<th width="14%">고객구분</th>
		        	<td colspan="6"><input type="checkbox" name="checkbox" value="checkbox" <%if(client.getClient_st().equals("1"))%>checked<%%>>법인 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	    <input type="checkbox" name="checkbox" value="checkbox" <%if(!client.getClient_st().equals("1")&&!client.getClient_st().equals("2"))%>checked<%%>>개인사업자 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	    <input type="checkbox" name="checkbox" value="checkbox" <%if(client.getClient_st().equals("2"))%>checked<%%>>개인</td>
		        </tr>
		        
		        <tr>
		        	<th>상 호</th>
		        	<td colspan="2">&nbsp;<%=client.getFirm_nm()%></td>
		        	<th>사업자번호</th>
		        	<td colspan="3">&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%><%}%></td>
		        </tr>
		        <tr>
		        	<th>성명(대표자)</th>
		        	<td width="24%">&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getClient_nm()%><%}%></td>
		        	<th width="17%">생년월일/법인번호</th>
		        	<td width="16%">&nbsp;<%if(client.getClient_st().equals("1")){%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}else{%><%if(AddUtil.parseInt(AddUtil.getDate(4)) > 20140806){%><%=client.getSsn1()%><%}else{%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}%><%}%></td>
		        	<th width="4%" rowspan="2">사<br>무<br>실</th>
		        	<th width="10%" class="center">전화번호</th>
		        	<td width="15%">&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
		        </tr>
		        <tr>
		        	<th>주 소(본점)</th>
		        	<td colspan="3">&nbsp;<%=client.getO_addr()%></td>
		        	<th class="center">팩스번호</th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
		        </tr>
		        <tr>
		        	<th>우편물수령주소</th>
		        	<td colspan="3">&nbsp;<%= base.getP_addr()%>&nbsp;<%=base.getTax_agnt()%></td>
		        	<th rowspan="2">대<br>표<br>자</th>
		        	<th class="center">휴대폰번호</th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
		        </tr>
		        <tr>
		        	<th>사용본거지주소</th>
		        	<td colspan="3">&nbsp;<%=site.getAddr()%>&nbsp;<%=site.getR_site()%></td>
		        	<th class="center">자택전화</th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
		        </tr>
	    	</table>	
			<table>
		        <tr>
		        	<th width="12%">구 분</th>
		        	<th width="10%">근무부서</th>
		        	<th width="14%">성 명</th>
		        	<th width="9%">직 위</th>
		        	<th width="17%">전화번호</th>
		        	<th width="13%">휴대폰번호</th>
		        	<th width="26%">E-MAIL</th>
		        </tr>
		        <%
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);        		
        				
        				if(mgr.getMgr_st().equals("차량이용자") || mgr.getMgr_st().equals("차량관리자") || mgr.getMgr_st().equals("회계관리자")){
        		%>
		        <tr>
		        	<th class="center"><%=mgr.getMgr_st()%></th>
		        	<td class="center"><%=mgr.getMgr_dept()%></td>
		        	<td class="center"><%=mgr.getMgr_nm()%></td>
		        	<td class="center"><%=mgr.getMgr_title()%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(mgr.getMgr_tel())%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(mgr.getMgr_m_tel())%></td>
		        	<td class="center"><%=mgr.getMgr_email()%></td>
		        </tr>
		        <%		}
		        	}%>
  			</table>
		</td>
	</tr>
	<tr>
	  	<td height=3></td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>2. 대여이용 기본사항</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc">
			<table class="center">
				<tr>
					<th rowspan="2" width="5%">대<br>여<br>차<br>량</th>
					<th width=20%>차종</th>
					<th width=47%>선택사양</th>
					<th width="8%">색상</th>
					<th width="15%">차량가격<br><span class="fs">-제조사 소비자가격-</span></th>
					<th width=5%">대수</th>
				</tr>
				<tr>
					<td>&nbsp;<%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
					<td>&nbsp;<%=car.getOpt()%></td>
					<td style="height:50px;">&nbsp;<%=car.getColo()%> 
						<%if(!car.getIn_col().equals("")){%>
						&nbsp;&nbsp;&nbsp;
					  	(내장:<%=car.getIn_col()%>)  
						<%}%>
						<%if(!car.getGarnish_col().equals("")){%>
						&nbsp;&nbsp;&nbsp;
					  	(가니쉬:<%=car.getGarnish_col()%>)  
						<%}%>
					</td>
					<td>&nbsp;<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>원					    
					    <%if(!base.getCar_gu().equals("1") || !rent_st.equals("1")){ //연장,재리스%>
					    <br>
					    <%		if(fee_opt_amt>0){%>
					    &nbsp;(<%=AddUtil.parseDecimal(fee_opt_amt)%>원)
					    <%		}else{%>
					    &nbsp;(<%=AddUtil.parseDecimal(fee_etc.getSh_amt())%>원)
					    <%		}%>
					    <%}else{%>
					    <%	if(car.getTax_dc_s_amt() > 0){%>
					    	<br>&nbsp;(개소세 감면후)
					    <%	}%>
					    <%}%>
					</td>
					<td>1대</td>
				</tr>
				<tr>
					<th>이용<br>기간</th>
					<td colspan="5"><input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("12"))%>checked<%%>>12개월 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("24"))%>checked<%%>>24개월 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("36"))%>checked<%%>>36개월 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("48"))%>checked<%%>>48개월 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("12")||fee.getCon_mon().equals("24")||fee.getCon_mon().equals("36")||fee.getCon_mon().equals("48")){%><%}else{%>checked<%}%>>기타( <%if(fee.getCon_mon().equals("12")||fee.getCon_mon().equals("24")||fee.getCon_mon().equals("36")||fee.getCon_mon().equals("48")){%>&nbsp;&nbsp;&nbsp;<%}else{%><%=fee.getCon_mon()%><%}%>)개월<br>
					    <%if(fee.getRent_start_dt().equals("")){%>
					    20 &nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;월 &nbsp;&nbsp;일부터 ~ 20 &nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;월 &nbsp;&nbsp;일까지
					    <%}else{%>
					    <%=AddUtil.getDate3(fee.getRent_start_dt())%>부터 ~ <%=AddUtil.getDate3(fee.getRent_end_dt())%>까지
					    <%}%>
					</td>
				</tr>
			</table>
			<table class="center">
				<tr>
					<th rowspan="6" width="5%">보험사항</th>
					<th width="20%">운전자범위</th>
					<th width="13%">운전자연령</th>
					<th colspan="3">보험가입금액 (보상한도)</th>
				</tr>
				<tr>
					<td rowspan="4" class="left"><input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> checked <%}%>>계약자의 임직원<br>&nbsp;<span class="fs">(법인 임직원 한정운전 특약 가입)</span><br>
					<input type="checkbox" name="checkbox" value="checkbox" <%if(!cont_etc.getCom_emp_yn().equals("Y")){%> checked <%}%>>계약자<br> &nbsp;&nbsp;&nbsp;&nbsp; 계약자의 임직원/가족<br> &nbsp;&nbsp;&nbsp;&nbsp; 계약자 임직원의 가족</td>
					<td rowspan="4" class="left">
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("0")){%> checked <%}%>>만26세 이상<br>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("3")){%> checked <%}%>>만24세 이상<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(리스만 가능)<br>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("1")){%> checked <%}%>>만21세 이상</td>
					<td width="11%">대 인 배 상</td>
					<td width="25%">무한(대인배상 Ⅰ,Ⅱ)</td>
					<td rowspan="5" width="26%">* 자기차량손해 면책금(사고 건당)<br> 
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_ja()==300000){%> checked <%}%>> 30만원 / 
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_ja() > 300000 || base.getCar_ja() < 300000){%> checked <%}%>> 기타(<%if(base.getCar_ja() > 300000 || base.getCar_ja() < 300000){%><%=base.getCar_ja()/10000%><%}else{%>&nbsp;<%}%>)만원<br>
					<span class="fs">(별도의 당사 차량손해면책제도에 의거 보상-좌측의 종합보험 가입 보험사 약관에 준함)</span></td>
				</tr>
				<tr>
					<td>대 물 배 상</td>
					<td><!--<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("1")){%> checked <%}%>>5천만원-->
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("2")){%> checked <%}%>>1억원
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("4")){%> checked <%}%>>2억원
						<input type="checkbox" name="checkbox" value="checkbox" <%if(!base.getGcp_kd().equals("2")&&!base.getGcp_kd().equals("4")){%> checked <%}%>>기타
						(<%if(base.getGcp_kd().equals("1")){%>5천만<%}else if(base.getGcp_kd().equals("8")){%>3억<%}else if(base.getGcp_kd().equals("3")){%>5억<%}%>)원
						</td>
				</tr>
				<tr>
					<td>자기신체사고</td>
					<td><!--<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getBacdt_kd().equals("1")){%> checked <%}%>>5천만원-->
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getBacdt_kd().equals("2")){%> checked <%}%>>1억원</td>
				</tr>		
				<tr> 
					<td>무보험차상해</td>
					<td>
						 <input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> checked <%}%>>가입(피보험자 1인당 최고 2억원)
						 <input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCanoisr_yn().equals("N")){%> checked <%}%>>미가입
					</td>
				</tr>	
				<tr>
					<td colspan="4" class="left">* 여기서 가족이란 부모, 배우자, 배우자의 부모, 자녀, 며느리, 사위를 말합니다.(형제·자매는 포함되지 않습니다)</td>
				</tr>
			<table class="center">
				<tr>
					<td width="15%" rowspan="2">차량관리 서비스<br>제공범위<br>(체크된 □칸의 서비스가 제공됩니다)</td>
					<td class="left lineh"><input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getAc_dae_yn().equals("Y")){%>checked<%}%>>사고대차 서비스<span class="fs"> (피해사고시 제외)</span>  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getMain_yn().equals("Y")){%>checked<%}%>>일체의 정비서비스 (각종 내구성부품/소모품 점검, 교환, 수리)
					<br><input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getPro_yn().equals("Y")){%>checked<%}%>>교통사고 발생시 사고처리 업무 대행 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*제조사 차량 취급설명서 기준<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(보험사 관련 업무 등)  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getMa_dae_yn().equals("Y")){%>checked<%}%>>정비대차서비스 (4시간이상 정비공장 입고시)</td>
				</tr>
				<tr>
					<td class="left">&nbsp;* 수입차는 국산차로 대차서비스하며 승합차종이나 화물차종은 승용 및 RV로 대차서비스합니다.<br>
					&nbsp;* 사고발생시 임차인의 임의적인 사고수리는 인정되지 않습니다.<br>&nbsp;&nbsp; - 사고로 인한 차량수리가 필요한 경우에는 (주)아마존카의 확인 및 선조치 사항이 있어야 (주)아마존카에서<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 수리비가 지불됩니다.</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr>
	  	<td height=3></td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>3. 대 여 요 금</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc">
			<table class="right">
				<tr>
					<th width=10%>구분</th>
					<th width=15%>보증금</th>
					<th width=15%>선납금</th>
					<th width=15%>개시대여료</th>
					<th width=15%>월대여료</th>
					<th width=15%>월대여료<br>납입할 횟수</th>
					<th width=15%>월대여료<br>납입할 날짜</th>
				</tr>
				<tr>
					<th>공급가</th>
					<td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_s_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_s_amt())%>원</td>
					<td rowspan="3" class="center"><%=fee.getFee_pay_tm()%>&nbsp;회</td>
					<td rowspan="3" class="center">매월 
					    <%if(fee.getFee_est_day().equals("99")){%> &nbsp;말일 
					    <%}else if(fee.getFee_est_day().equals("98")){%> &nbsp;대여개시일 
					    <%}else{%>
					    &nbsp;&nbsp;<%=fee.getFee_est_day()%>&nbsp;일
					    <%}%>					
					</td>
				</tr>
				<tr>
					<th>부가세</th>
					<td class="center">-</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_v_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_v_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_v_amt())%>원</td>
				</tr>
				<tr>
					<th>합 계</th>
					<td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>원</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3" class="center">초기 납입금 합계: &nbsp;&nbsp;<%=AddUtil.parseDecimal(fee.getGrt_amt_s()+fee.getPp_s_amt()+fee.getPp_v_amt()+fee.getIfee_s_amt()+fee.getIfee_v_amt())%>원</td>
					<td colspan="3" class="right">※ 마지막 회차 결제일은 계약 만료일입니다.&nbsp;<%//=fee.getFee_cdt()%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="fss"><p>&nbsp;&nbsp;&nbsp;* 1. 보증금은 계약기간 만료후 고객님께 환불해 드립니다.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. 선납금은 이용기간동안 매월 일정 금액씩 공제되며, 계약 만료후 환불되는 돈이 아닙니다.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3. 개시대여료는 마지막( )개월치 대여료를 선납하는 것입니다.<br>
			<%//if(base.getCar_gu().equals("1") && fee.getRent_st().equals("1")){%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4. 초기 납입금 (보증금, 선납금, 개시대여료)은 신차출고 2일전까지는 (주)아마존카로 입금되어야 합니다.
			<%//}%>
			</p>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
			<table class="center">
				<tr>
					<th rowspan="3" width=5%>납입<br>방법</th>
					<th rowspan="2" width=10%>자동이체<br>신청</th>
					<td colspan="4" class="left pd"><span class="style2">※ 별지 CMS 출금이체 신청서 작성</span></td>
				</tr>
				<tr>
					<td>자동이체 대상</td>
					<td colspan="3" class="left pd">월대여료, 연체이자, 해지정산금, 면책금, 과태료</td>
				</tr>
				<tr>
					<th>통장 입금<br>(은행선택)</th>
					<td colspan="4" class="left pd">신한 140-004-023871 &nbsp;&nbsp;&nbsp;KEB하나 188-910025-57904 &nbsp;&nbsp; 기업 221-181337-01-012 &nbsp;&nbsp;신한 140-003-993274 (부산)<br>
						국민 385-01-0026-124&nbsp;&nbsp;우리 103-293206-13-001&nbsp;&nbsp; 농협 367-17-014214&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신한 140-004-023856 (대전)</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height=5></td>
	</tr>
	<tr>
		<td colspan="2" class="right fss">( 계약번호 : <%=rent_l_cd%>, Page 1/2, <%=AddUtil.ChangeDate2(fee.getRent_dt())%> )</td>
	</tr>
	<tr>
		<td height=5 class="a4"></td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>4. 보 증 보 험</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1 right">
			<table>	
				<tr>
					<th width=14%><input type="checkbox" name="checkbox" value="checkbox" <%if(ext_gin.getGi_fee() >0 ){%> checked <%}%>>가&nbsp;&nbsp;&nbsp;&nbsp; 입<br>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(ext_gin.getGi_fee() == 0){%> checked <%}%>>가입면제</th>
					<td class="pd">임차인은 계약기간 동안 임대인을 피보험자로 하는 이행(지급)보증보험증권(
						<%if(ext_gin.getGi_st().equals("1")){%>
						<%=AddUtil.parseDecimal(AddUtil.ten_thous(ext_gin.getGi_amt()))%>만원, <%=fee.getCon_mon()%>개월
						<%}else{%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  만원, &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;개월
					  <%}%>
						 )을 예치한다.<br>
						이 때, 차량대여요금의 연체, 중도해지 위약금, 면책금 등과 같이 본 계약에서 발생할 수 있는 모든 채권에 대해서<br>
						임대인은 임차인이 예치한 이행(지급)보증보험증권으로 권리를 행사할 수 있다.</td>
				</tr>	
			</table>
			<!-- 보증보험료 삭제(2019년 11월 13일) 다시 살릴 수 있음. -->
			<%-- <table class="doc_s right" style="margin:0px; padding:0px;">
				<tr>
					<th width=45%>보증보험료</th>
					<td><%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>원</td>
				</tr>
			</table> --%>
		</td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>5. 특 약 사 항</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
			<table>
				<tr>
					<th width=10%>구분</th>
					<th colspan="4">내 용</th>
				</tr>
				<tr>
					<th>대여료<br>연체시</th>
					<td colspan="4" class="pd">(1) 대여료 연체시 <span class="style2 point">년리 24%의 연체이자</span>가 부과된다.<br>
									(2) 30일 이상 대여료 연체시 임대인은 계약을 해지 할 수 있으며, 이 때 임차인은 차량을 즉시 반납하여야 한다. 임대인의<br>
			   &nbsp;&nbsp;&nbsp;&nbsp; 차량 반납 요구에도 불구하고 임차인이 차량을 반납하지 않을 경우에는 임대인은 임의로 차량을 회수할 수 있다.<br>
									(3) 임차인은 보증금 등 초기납입금을 이유로 본 계약에 따라 임대인에게 지급하여야 할 대여료의 지급을 거절할 수 없다.<br>
									(4) 연체로 인한 계약해지시 임차인은 아래 중도해지 조항의 위약금을 지불하여야 한다.
					</td>
				</tr>
				<tr>
					<th>중도해지시</th>
					<td colspan="4" class="pd">(1) 계약의 중도해지시에는 <span class="style2 point">잔여기간 대여료의 (&nbsp;<%=fee.getCls_r_per()%>&nbsp;)%의 위약금</span>을 배상하여야 한다.<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * 기본위약금율은 <b>30%</b>이며, 차종에 따라 위약금율이 다르게 적용됩니다.<br>
						&nbsp;&nbsp;&nbsp; ★ 잔여기간 대여료 = (대여료 총액÷계약이용기간) X 잔여이용기간<br>
						&nbsp;&nbsp;&nbsp; ★ 대여료 총액 = 선납금 + 개시대여료 + (월대여료 X 총계약기간동안 월대여료 납입할 횟수)<br>
									(2) 위약금의 정산 : 보증금 및 개시대여료, 잔여 선납금으로 정산하고, 부족할 경우에는 현금으로 지불하여야 한다.<br>
						&nbsp;&nbsp;&nbsp; ★ 중도 해지 후 <b>7</b>일이내에 임차인이 위약금을 완제하지 않을 경우에는 임대인은 위의 4. 보증보험으로 정산할 수 있다.<br>
									(3) 보증금, 개시대여료, 잔여선납금으로 변제하는 순서 : ①범칙금, 과태료 ②가압류비용, 소송비용 등 법적구제비용<br>
						&nbsp;&nbsp;&nbsp;&nbsp; ③차량회수(자구행위)를 위하여 임대인이 부담한 실비용 ④면책금 ⑤연체이자 ⑥중도해지위약금 ⑦연체대여료
					</td>
				</tr>
				<tr>
					<th>계약승계시</th>
					<td colspan="4" class="pd">계약을 승계받을 고객은 임차인이 찾아야 하며, 계약승계를 승인할 지 여부는 (주)아마존카가 종합적으로 판단하여 결정한다. 계약승계수수료는 제조사 가격표상 신차 소비자가격의 0.8%로 한다. (중고차매매상에게 또는 계약만료 3개월이내 계약승계 불가)</td>
				</tr>
				<tr>
					<th>한달미만<br>대여요금</th>
					<td colspan="4" class="pd">대여요금은 월단위로 산정하며, 1개월 미만 이용기간에 대한 대여요금은 "이용일수 X (월대여료÷30)"으로 한다.</td>
				</tr>
				<tr>
					<th rowspan="2">계약기간<br>만료시의<br>중고차<br>매입옵션</th>
					<td colspan="4" class="pd">계약기간 만료시 임차인은 위 대여이용 차량을 아래의 매입옵션가격에 매입할 수 있는 [중고차 매입 선택권(중고차 매입옵션)]을 가진다. 단, 일반인이 구입할 수 없는 LPG 차량의 경우에는 법률의 규정에 따라 국가유공자나 장애인등 일정한 자격이 있는 자 또는 
					법률에서 규정하고 있는 일정 요건을 갖춘 차량만 매입이 가능합니다.</td>
				</tr>
				<tr>
					<th width=10%>매입옵션<br>가격</th>
					<td width=27% class="center"><%if(fee.getOpt_s_amt() > 0){%><%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>원 (부가세 포함)<%}else{%>매입옵션없음<%}%></td>
					<th width=14%>매입옵션<br>행사권자 범위</th>
					<td width=35% class="pd">★법인고객:법인 또는 그 법인의 종업원<br>
						★개인고객:본인 또는 본인의 부모/자녀/배우자</td>
				</tr>
				<tr>
					<th>차량의반납</th>
					<td colspan="4" class="pd">임차인은 계약 종료시에 정상적인 마모를 제외하고 최초 인도 받은 상태로 차량을 반납하여야 한다.</td>
				</tr>
				<tr>
					<th class="ht">기 타</th>
					<td colspan="4">&nbsp;<%=fee_etc.getCon_etc()%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="fss" height=20>※ 본 계약서에 기재되지 않은 사항은 "자동차 대여 표준약관"에 의합니다. (2011.9.23 공정거래위원회 개정, 아마존카 홈페이지 참조)</td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
		<%if(cont_etc.getClient_share_st().equals("1")){%>
		<%-- <%if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%> --%>
     	        <!-- 공동임차인일 경우 --> 	
     	 	<table class="center">
				<tr>
					<td height=18 colspan=4 class="center"><span class=style2>계 약 일 &nbsp;&nbsp;: &nbsp;<%=AddUtil.getDate3(fee.getRent_dt())%></span></td>
				</tr>
		        <tr>
		          	<td width="39%" class="name left" rowspan="4">&nbsp;&nbsp;<span class=style2>대여제공자(임대인)</span><br>&nbsp;&nbsp;서울시 영등포구 의사당대로 8,<br>&nbsp;&nbsp;802호 (여의도동, 태흥빌딩)<br><br>
		      			&nbsp;&nbsp;<span class=style6>(주)아마존카 대표이사 &nbsp;&nbsp;&nbsp;조 &nbsp;&nbsp;&nbsp;성 &nbsp;&nbsp;&nbsp;희 &nbsp;&nbsp;(인)</span></td>
		          	<td colspan="3" class="name left">&nbsp;&nbsp;<span class=style2>대여이용자 (임차인)</span><br>
		      			&nbsp;&nbsp;본 계약의 내용을 확인하여 계약을 체결하고 계약서 1통을 정히 수령함.<br>
		      			&nbsp;&nbsp;위 대여이용자</span><br><br>
		      			<%if(AddUtil.lengthb(client.getFirm_nm()+" "+client.getClient_nm()) < 30){%>
		      			    &nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp; 
		      			    <%=client.getFirm_nm()%>
		      			    <%if(!client.getClient_st().equals("2")){%>대표이사 <%=client.getClient_nm()%><%}%>&nbsp;&nbsp; (인)</div>
		      			<%}else{%>
		      			    &nbsp;&nbsp;&nbsp;<div class="style5 style6">
		      			    <%=client.getFirm_nm()%>
		      			    <%if(!client.getClient_st().equals("2")){%>대표이사 <%=client.getClient_nm()%><%}%>&nbsp; (인)</div>
		      			<%}%>
		      		</td>
		        </tr>
		        <tr>
		        	<td height="16" rowspan="3" class="fs">&nbsp;본 연대보증인(공동임차인)은 임차인이 (주)아마존카와 체결한 위 &quot;자동차 대여이용 계약&quot; 에 대하여 그 내용을 숙지하고 임차인과 연대하여(공동으로)  동 계약상 일체의 채권·채무를 이행할 것을 확약합니다.</td>
		          	<td width="13%" rowspan="3"><input type="checkbox" name="checkbox" value="checkbox"><span class=style6>연대보증인</span><br>
		          								<input type="checkbox" name="checkbox" value="checkbox"><span class=style6>공동임차인</span></td>
		          	<td width="9%" class="pd">주 소</td>
		          	<td width="39%">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_addr()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="20" class="pd">생년월일</td>
		          	<td class="pd">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_ssn1()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="20" class="pd">성명</td>
		          	<td class="right pd"><!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getClient_nm()%><%}%>-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		        </tr>
     	 	</table>		
		<%}else{%>
		<!-- 연대보증인일 경우 -->
			<table class="center">
				<tr>
					<td height=18 colspan=4 class="center"><span class=style2>계 약 일 &nbsp;&nbsp;: &nbsp;<%=AddUtil.getDate3(fee.getRent_dt())%></span></td>
				</tr>
		        <tr>
		          	<td width="39%" class="name left">&nbsp;&nbsp;<span class=style2>대여제공자(임대인)</span><br>&nbsp;&nbsp;서울시 영등포구 의사당대로 8,<br>&nbsp;&nbsp;802호 (여의도동, 까뮤이앤씨빌딩)<br><br>
		      			&nbsp;&nbsp;<span class=style6>(주)아마존카 대표이사 &nbsp;&nbsp;&nbsp;조 &nbsp;&nbsp;&nbsp;성 &nbsp;&nbsp;&nbsp;희 &nbsp;&nbsp;(인)</span></td>
		          	<td colspan="3" class="name left">&nbsp;&nbsp;<span class=style2>대여이용자 (임차인)</span><br>
		      			&nbsp;&nbsp;본 계약의 내용을 확인하여 계약을 체결하고 계약서 1통을 정히 수령함.<br>
		      			&nbsp;&nbsp;위 대여이용자</span><br><br>
		      			<%if(AddUtil.lengthb(client.getFirm_nm()+" "+client.getClient_nm()) < 30){%>
		      			    &nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp; 
		      			    <%=client.getFirm_nm()%>
		      			    <%if(!client.getClient_st().equals("2")){%>대표이사 <%=client.getClient_nm()%><%}%>&nbsp;&nbsp; (인)</div>
		      			<%}else{%>
		      			    &nbsp;&nbsp;&nbsp;<div class="style5 style6">
		      			    <%=client.getFirm_nm()%>
		      			    <%if(!client.getClient_st().equals("2")){%>대표이사 <%=client.getClient_nm()%><%}%>&nbsp; (인)</div>
		      			<%}%>
		      		</td>
		        </tr>
		        <tr>
		          	<td height="16" rowspan="3" class="fs">&nbsp;본 연대보증인(공동임차인)은 임차인이 (주)아마존카와 체결한 위 &quot;자동차 대여이용 계약&quot; 에 대하여 그 내용을 숙지하고 임차인과 연대하여(공동으로)  동 계약상 일체의 채권·채무를 이행할 것을 확약합니다.</td>
		          	<td width="13%" rowspan="3"><input type="checkbox" name="checkbox" value="checkbox"><span class=style6>연대보증인</span><br>
		          								<input type="checkbox" name="checkbox" value="checkbox"><span class=style6>공동임차인</span></td>
		          	<td width="9%" class="pd">주 소</td>
		          	<td width="39%">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_addr()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="20" class="pd">생년월일</td>
		          	<td class="pd">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_ssn1()%>-<%=client.getRepre_ssn2()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="20" class="pd">성명</td>
		          	<td class="right pd"><!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getClient_nm()%><%}%>-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		        </tr>
     	 	</table>		
		<%}%>
		</td>
	</tr>
	<tr>
		<td height=5></td>
	</tr>
	<tr>
		<td colspan="2" class="doc_a">
			<table>
				<tr>
					<td class="nor"><span class=style2>■ 개인정보 수집·이용 동의서, 신용정보의 제공·활용 및 조회 동의서 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style5>(주)아마존카 귀중</span></span></td>
				</tr>
				<tr>
					<td class="con fs">(1) 개인정보보호법 제15조의 규정에 따라 아래와 같이 본인의 개인정보를 수집·이용하는데 동의합니다.<br>
						&nbsp;&nbsp;&nbsp;&nbsp; ①수집·이용목적 : 자동차 대여이용 계약의 체결 및 이행, 요금정산(대여료결제, 세금계산서 발송, 대여료추심등) ②수집항목 : 성명, 주소,<br>
						&nbsp;&nbsp;&nbsp;&nbsp;  생년월일, 운전면허번호, 연락처, 이메일, 자동이체 계좌번호, 직업, 소득 및 재산정도 ③보유 및 이용기간 : 원칙적으로 개인정보 수집·이용<br>
						&nbsp;&nbsp;&nbsp;&nbsp;  목적이 달성된 후에는 지체없이 파기합니다. 다만, 상법등 관계법령에 의하여 보존할 필요가 있는 경우에는 일정기간 보존 후 파기합니다.<br>
						&nbsp;&nbsp;&nbsp;&nbsp;  ④개인정보(고유식별정보포함) 수집·이용 동의를 거부할 권리가 있으나, 동의거부시 자동차 대여이용 계약에 따른 의무이행 및 관련 서비스<br>
						&nbsp;&nbsp;&nbsp;&nbsp;   제공이 불가하여 부득이 계약 체결이 거절될 수 있습니다.
						 <div class="agree style2">&nbsp;&nbsp;&nbsp;&nbsp;<span class="style7">· 고유식별정보(주민등록번호, 운전면허번호, 외국인등록번호) 수집·이용 동의여부:</span> &nbsp;<input type="checkbox" name="checkbox" value="checkbox" checked> 동의함&nbsp; <input type="checkbox" name="checkbox" value="checkbox"> 동의안함</div>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  * 개인정보보호법 제24조의 규정에 따라 고유식별정보 수집·이용시 별도 동의가 필요하며, 주민등록번호는 부가가치세법에 의거 세금<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  계산서 발행 목적으로 임차인이 개인인 경우에만 수집·이용 합니다.<br>
						(2) 이 계약과 관련하여 귀사가 본인으로부터 취득한 다음의 신용정보는 신용정보의 이용 및 보호에 관한 법률 제32조 제1항의 규정에 따라<br>
						&nbsp;&nbsp;&nbsp;&nbsp; 타인에게 제공·활용시 본인의 동의를 얻어야 하는 정보입니다. 이에 본인은 귀사가 다음의 신용정보를 신용정보 집중기관, 신용정보업자,<br>
						&nbsp;&nbsp;&nbsp;&nbsp; 신용정보 제공·이용자 등에게 제공하여 본인의 신용을 판단하기 위한 자료로서 활용하거나 공공기관에서 정책자료로 활용, 기타 법령에서<br>
						&nbsp;&nbsp;&nbsp;&nbsp; 정한 목적 등으로 이용하는데 동의합니다.<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * 제공·활용할 신용정보의 내용 : 식별정보, 연락처정보, 속성정보, 자동차대여이용정보, 대여금불입정보 등<br>
						(3) 신용정보의 이용 및 보호에 관한 법률 제32조 제2항의 규정에 따라 귀사가 계약의 체결 및 유지여부 판단을 위하여 신용도 판단정보, 개설<br>
						&nbsp;&nbsp;&nbsp;&nbsp; 정보 및 신용등급 등 본인의 신용정보를 거래기간 동안 신용조회회사로부터 조회하는데 동의합니다. 이 동의는 본 계약의 갱신이나 추가<br>
						&nbsp;&nbsp;&nbsp;&nbsp; 계약의 체결여부를 판단하기 위한 경우에도 유효합니다.
					</td>
				</tr>
				<tr>
					<td class="nor">
						<table class="zero">
							<tr>
								<td><span class=style6><%=AddUtil.getDate3(fee.getRent_dt())%></td>
								<td>
								<div class="style2 style5">대여이용자
								<span class=style4><%if(client.getClient_st().equals("2")){%> &nbsp;&nbsp;&nbsp;&nbsp;<%=client.getClient_nm()%>					
								<%}else{%> &nbsp;&nbsp;&nbsp;&nbsp;<%=client.getFirm_nm()%>&nbsp;<%=client.getClient_nm()%>
								<%}%>
								</span>
								<%if(AddUtil.lengthb(client.getFirm_nm()+" "+client.getClient_nm()) < 30){%>
								&nbsp;&nbsp;&nbsp;인 &nbsp;&nbsp;&nbsp;&nbsp;
								    <%if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%>
								    연대보증인 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								    &nbsp;&nbsp;&nbsp;인
								    <%}%>
								<%}else{%>
								인 &nbsp;&nbsp;
								    <%if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%>
								    <%}else{%>연대보증인
								     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								    인
								    <%}%>																
								<%}%>
								</span></span></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height=10></td>
	</tr>
	<tr>	        
		<td colspan="2" class="right fss">( 계약번호 : <%=rent_l_cd%>, Page 2/2, <%=AddUtil.ChangeDate2(fee.getRent_dt())%> )</td>
	</tr>	
</table>
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
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 10.0; //좌측여백   
factory.printing.topMargin = 10.0; //상단여백    
factory.printing.rightMargin = 10.0; //우측여백
factory.printing.bottomMargin = 8.0; //하단여백
<%if(print_yn.equals("Y")){ //인쇄화면에서 보인다 %>
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
<%}%>
alert('인쇄미리보기에서 2장, 도장위치가 맞는지 확인! 안맞는다면 익스플로러 창에서 도구 > 호환성보기설정에 amazoncar.co.kr 추가설정 후 프린트!');
}
</script>
