<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.client.*, acar.car_register.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String rent_mng_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String rent_l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String est_id 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	String print_yn 	= request.getParameter("print_yn")==null?"":request.getParameter("print_yn");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기본정보
	CarRegBean cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
		
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	EstimateBean e_bean = e_db.getEstimateCase(est_id);
	
	String current_date   = AddUtil.getDate3();
	
	UsersBean user_bean 	= umd.getUsersBean(e_bean.getReg_id());

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <title>FMS</title>
    <!-- <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link> -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style>
	*{
		font-family: serif;
	}
</style>
<style>
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    font-family: "맑은 고딕", Malgun Gothic, "굴림", gulim,"돋움", dotum, arial, helvetica, sans-serif;
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
	/* #contents {font-size:9pt}; */

.title{text-align:center;background-color: aliceblue;}  
.contents {font-size:10pt;}
.contents tr{ height:30px;}
#wrap{ font-family: 'Malgun Gothic'; vertical-align: middle; font-weight:bold;}
	
</style>
</head>
<body>
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
    <div class="paper">
    <div class="content">    
	<div id="wrap" style="width:100%;">

<div id="print_template_b">
	<table style="border-collapse:collapse;width:100%;">
		<tr>
	  	    <td colspan='4'><img src="/acar/images/logo_1.png" style="margin-left: 30px;"></td>
		</tr>	
		<tr><td style="height:50px;"></td></tr>
		<tr>
			<td colspan="4" style="text-align:center;height:50px;">
				<span style="padding-top:20px;padding-right:30px;padding-bottom:20px;padding-left:30px;border-width:1px;border-style:solid;border-color:black;font-size:28px;
					font-weight:bold;">계약사항 변경요청서</span>
			</td>
		</tr>	
		<tr><td style="height:20px;"></td></tr>
		<tr>
			<td colspan="4" style="text-align:center;font-size:20px;">(약정운행거리 변경)</td>
		</tr>
		<tr><td colspan="4" style="height:30px;"></td></tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;">약정운행거리 변경일</td>
			<td colspan="3" style="border:1px solid black;font-size:14px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.ChangeDate2(e_bean.getCng_dt()) %></td>
		</tr>		
		<tr><td colspan="4" style="height:30px;"></td></tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:24%;text-align:center;font-size:14px;font-weight:bold;">상 호</td>
			<td style="border:1px solid black;width:38%;text-align:center;font-size:14px;"><%=client.getFirm_nm()%></td>
			<td style="border:1px solid black;width:19%;text-align:center;font-size:14px;font-weight:bold;">차량번호</td>
			<td style="border:1px solid black;width:19%;text-align:center;font-size:14px;"><%=cr_bean.getCar_no()%></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;">차 명</td>
			<td colspan="3" style="border:1px solid black;text-align:center;font-size:14px;"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
		</tr>
		<tr><td style="height:20px;"></td></tr>
		<tr>
			<td colspan="4" style="font-size:16px;font-weight:bold;">※ 계약사항 변경내용</td>
		</tr>		

		<tr><td style="height:5px;"></td></tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;">변경사항</td>
			<td style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;">변경 전</td>
			<td colspan="2" style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;">변경 후</td>			
		</tr>
		<tr style="border:1px solid black;height:60px;">
			<td style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;">약정운행거리</td>
			<td style="border:1px solid black;text-align:center;font-size:14px;"><%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>km/1년<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%><br><span style="font-size:12px;">미운행 1km당 <%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%>원(부가세별도) 환급<br>초과운행 1km당 <%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>원(부가세별도) 납입</span><%} %></td>
			<td colspan="2" style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;"><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km/1년<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%><br><span style="font-size:12px;">미운행 1km당 <%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>원(부가세별도) 환급<br>초과운행 1km당 <%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>원(부가세별도) 납입</span><%} %></td>	
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;">월대여료</td>
			<td style="border:1px solid black;text-align:center;font-size:14px;"><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>원(vat포함)</td>
			<td colspan="2" style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;"><%=AddUtil.parseDecimal(e_bean.getCtr_s_amt()+e_bean.getCtr_v_amt())%>원(vat포함)</td>	
		</tr>	
		<%if(fee.getOpt_s_amt() > 0){ %>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;">매입옵션가격</td>
			<td style="border:1px solid black;text-align:center;font-size:14px;"><%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>원(vat포함)</td>
			<td colspan="2" style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;"><%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>원(vat포함)</td>	
		</tr>	
		<%} %>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;">중도해지위약금율</td>
			<td style="border:1px solid black;text-align:center;font-size:14px;"><%=fee.getCls_r_per()%>%</td>
			<td colspan="2" style="border:1px solid black;text-align:center;font-size:14px;font-weight:bold;"><%=e_bean.getCls_per()%>%</td>	
		</tr>						
		<tr>
			<td colspan="4" style="height:30px;"></td>
		</tr>
		<tr>
			<td colspan="4">
				<span style="margin-left:20px;font-size:16px;font-weight:bold;">상기와 같이 계약사항의 변경을 요청합니다.</span>
			</td>
		</tr>
		<tr>
			<td colspan="4" style="height:30px;"></td>
		</tr>
		<tr>
			<td colspan="4" style="text-align:center;font-size:20px;"><%=current_date%></td>
		</tr>		
		<tr>
			<td style="height:30px;"></td>
		</tr>
		<tr>
			<td colspan="4" style="text-align:center;font-size:20px;">
				<span style="font-size:20pt;font-weight:bold;">계약자</span>
              	<span style="margin-left:335px;"></span>
              	<span style="font-size:18px;margin-left:15px;font-weight:bold;">(인)
			</td>
		</tr>	
		<tr>
			<td style="height:50px;"></td>
		</tr>	
		<tr>
			<td colspan="4">
				<span style="font-size:14px;"><%if(client.getClient_st().equals("1")){ %>※ 본 문서 계약자란에 명판과 직인을 날인하고 아래 팩스번호로 회신해 주십시오.<%}else{%>※ 본 문서 계약자란에 자필서명후 아래 팩스번호로 회신해 주십시오.<%}%></span>
			</td>
		</tr>					
		<tr>
			<td colspan="4">
				<span style="font-size:14px;">담당자 팩스번호 : <%=user_bean.getUser_nm()%> (FAX <%=user_bean.getI_fax()%>)</span>
			</td>
		</tr>					
		<tr>
			<td colspan="4">
				<span style="font-size:14px;">담당자 연락처 : <%=user_bean.getUser_nm()%> (TEL <%=user_bean.getUser_m_tel()%>)</span>
			</td>
		</tr>					
		<tr>
			<td style="height:40px;"></td>
		</tr>	
		<tr>
			<td colspan="4" style="text-align:right;font-size:20px;">주식회사 아마존카 귀중</td>
		</tr>
	</table>
</div>
</div>
</body>
<script language="JavaScript" type="text/JavaScript">
function onprint(){
	window.print();
}
</script>
</html>


