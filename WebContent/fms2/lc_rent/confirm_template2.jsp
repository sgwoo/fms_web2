<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*, acar.common.*, acar.cont.*, acar.client.*, acar.car_register.*, acar.cls.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>

<%
	String current_date 	= AddUtil.getDate3();
	
	String var2 = request.getParameter("var2")==null?"":request.getParameter("var2");	
	String var4 = request.getParameter("var4")==null?"":request.getParameter("var4");	
	String var5 = request.getParameter("var5")==null?"":request.getParameter("var5");
	
	String view_amt 		= request.getParameter("view_amt")		==null? "":request.getParameter("view_amt");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();	
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
		
	String rent_l_cd = var2;	
	String client_id = var5;
	String rent_mng_id = var4;
			
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
		
	CarRegBean cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
			
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);	
		
	String ssn = client.getSsn1();
	ssn += "-";
	if(client.getClient_st().equals("1")){
		ssn += client.getSsn2();
	}else {
		if(client.getSsn2().length() > 1){
			ssn += client.getSsn2().substring(0,1);
			ssn += "******";
		}else{
			ssn += "*******";
		}
	}
		
	String enp_no = client.getEnp_no1();
	enp_no += "-";
	enp_no += client.getEnp_no2();
	enp_no += "-";
	enp_no += client.getEnp_no3();
	if(enp_no.length()==2){
		enp_no = "";
	}
		
	String address = "";
	if(!client.getO_addr().equals("")){
		address += "(";
	}
	address += client.getO_zip();
	if(!client.getO_addr().equals("")){
		address += ") ";
	}
	address += client.getO_addr();
			
	// 차량색상
	String car_color = "";
	car_color += car.getColo();
	if(!car.getIn_col().equals("")){
		car_color += "   ";
		car_color += "(내장색상(시트): ";
		car_color += car.getIn_col();
		car_color += ")";
	}
	if(!car.getGarnish_col().equals("")){
		car_color += "   ";
		car_color += "(가니쉬: ";
		car_color += car.getGarnish_col();
		car_color += ")";
	}
	
	// 계약일자는 대여요금의 계약일자
	String rent_dt = base.getRent_dt();
	
	Vector vt = af_db.getRentDtConMon(rent_mng_id, rent_l_cd, 0);
	if(vt.size() < 1){
		vt = af_db.getRentDtConMon(rent_mng_id, rent_l_cd, 1);
	}
	
	String rent_end_dt = "";
		
	for(int i=0; i<vt.size(); i++){
		Hashtable ht = (Hashtable)vt.elementAt(i); 
		rent_end_dt = String.valueOf(ht.get("RENT_END_DT"));
	}
		
	// 이용기간 시작일은 대여요금의 대여개시일
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(1));
	String rent_start_dt = fees.getRent_start_dt();
		
	// 계약승계의 경우 이용기간 시작일은 계약승계날짜로 변경		2018.01.11
	String rent_suc_dt = af_db.getRentSucDt(rent_mng_id, rent_l_cd);
	if(rent_suc_dt.length() > 1){
		rent_start_dt = rent_suc_dt;
	}
		
	// 계약 연장이 있는 경우 마지막 연장계약의 대여만료일로 이용기간 종료일이 변경된다.
	ContFeeBean fees2 = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	int fee_amt = fees2.getFee_s_amt()+fees2.getFee_v_amt();
	int grt_amt = fees2.getGrt_amt_s();				
	rent_end_dt = fees2.getRent_end_dt();
	
	// 임의 연장이 있는 경우 마지막 사용일로 이용기간 종료일이 변경된다.	2018.01.11
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	String im_rent_end_dt = "";
	if(im_vt_size > 0){
		Hashtable im_ht = (Hashtable)im_vt.elementAt(im_vt_size - 1);
		im_rent_end_dt = String.valueOf(im_ht.get("RENT_END_DT"));
		if(Integer.parseInt(im_rent_end_dt) > Integer.parseInt(rent_end_dt)){	// 임의 연장 기간 종료일이 계약 연장 종료일보다 큰 경우만 변경시킨다.
			rent_end_dt = im_rent_end_dt;
		}
	}
		
	//계약해지는 해지일자가 만료일자
		
	//해지정보
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	if(!cls.getCls_dt().equals("")){
		rent_end_dt = cls.getCls_dt();
	}
			
	// 보험가입운전자 연령
	String driving_age = base.getDriving_age();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
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
<body topmargin=0 leftmargin=0 >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="https://www.amazoncar.co.kr/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
    <div class="paper">
    <div class="content">
    
	<div id="wrap" style="width:100%;">


<div id="print_template_b"><!-- 자동차 대여이용 계약사실 확인서		START-->
	<table style="border-collapse:collapse;width:100%;">
		<tr><td style="height:50px;"></td></tr>
		<tr>
			<td colspan="4" style="text-align:center;font-size:20px;">〈 자동차 대여이용 계약사실 확인서 〉</td>
		</tr>
		<tr><td style="height:30px;"></td></tr>
		<tr>
			<td colspan="4" style="font-weight:bold;">＊ 고객 사항</td>
		</tr>
		<tr><td style="height:10px;"></td></tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><span>상</span><span style="margin-left:60px;">호</span></td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=client.getFirm_nm()%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">법인등록번호<br>또는 생년월일</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=ssn%></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">성명 (대표자)</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=client.getClient_nm()%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">사업자번호</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=enp_no%></td>
		</tr>
		<tr style="border:1px solid black;height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><span>주</span><span style="margin-left:60px;">소</span></td>
			<td colspan="3" style="font-size:14px;">&nbsp;<%=address%></td>
		</tr>
		<tr>
			<td colspan="4" style="height:50px;"></td>
		</tr>
		<tr>
			<td colspan="4" style="font-weight:bold;">＊ 계약 사실에 대한 확인</td>
		</tr>
		<tr><td style="height:10px;"></td></tr>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">계약일자</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.ChangeDate2(rent_dt)%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">대여차량명</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=cr_bean.getCar_nm()%></td>
		</tr>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">이용기간</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.ChangeDate2(rent_start_dt)%> ~ <%=AddUtil.ChangeDate2(rent_end_dt)%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">차량번호</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=cr_bean.getCar_no()%></td>
		</tr>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">보험가입운전자<br>연령</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;">
			<%	if(driving_age.equals("0")){%>26세이상<%}
				else if(driving_age.equals("3")){%>24세이상<%}
				else if(driving_age.equals("1")){%>21세이상<%}
				else if(driving_age.equals("5")){%>30세이상<%}
				else if(driving_age.equals("6")){%>35세이상<%}
				else if(driving_age.equals("7")){%>43세이상<%}
				else if(driving_age.equals("8")){%>48세이상<%}
				else if(driving_age.equals("9")){%>22세이상<%}
				else if(driving_age.equals("10")){%>28세이상<%}
				else if(driving_age.equals("11")){%>35세이상~49세이하<%}
				else if(driving_age.equals("2")){%>모든운전자<%}
			%></td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">차량색상</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;"><%=car_color%></td>
		</tr>
		<%if(view_amt.equals("Y")){%>
		<tr style="height:40px;">
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">보증금</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.parseDecimal(grt_amt)%> 원</td>
			<td style="border:1px solid black;width:20%;text-align:center;font-size:14px;">대여료</td>
			<td style="border:1px solid black;width:30%;text-align:center;font-size:14px;"><%=AddUtil.parseDecimal(fee_amt)%> 원</td>
		</tr>
		<%} %>
		<tr><td style="height:70px;"></td></tr>
		<tr>
			<td colspan="4" style="font-size:14px;">위의 고객은 주식회사 아마존카 자동차대여이용계약 고객임을 확인합니다.</td>
		</tr>
		<tr><td style="height:70px;"></td></tr>
		<tr>
			<td colspan="4" style="text-align:center;"><span style="font-size:18px;"><%=current_date%></span></td>
		</tr>
		<tr><td style="height:40px;"></td></tr>
		<tr>
			<td colspan="4" style="text-align:center;">
				<img src="https://fms1.amazoncar.co.kr/acar/main_car_hp/images/ceo_no_stamp.gif">
				<img src="https://fms1.amazoncar.co.kr/acar/main_car_hp/images/ceo_stamp.jpg" height="63" width="63">
			</td>
		</tr>
	</table>
</div><!-- 자동차 대여이용 계약사실 확인서		END-->


</div>
</body>
<script>

</script>
</html>