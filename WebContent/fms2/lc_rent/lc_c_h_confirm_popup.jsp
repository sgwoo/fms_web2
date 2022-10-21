<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.cls.*, acar.client.*, acar.car_mst.*, acar.car_register.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
	InsDatabase ai_db 		= InsDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);				
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
		
	//차명
	String car_nm = c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG");
	
	// 법인등록번호 또는 생년월일
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
	
	// 사업자등록번호
	String enp_no = client.getEnp_no1();
	enp_no += "-";
	enp_no += client.getEnp_no2();
	enp_no += "-";
	enp_no += client.getEnp_no3();
	if(enp_no.length()==2){
		enp_no = "";
	}
	
	// 사업장 주소 2018.01.10
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
	
	String rent_dt = "";			// 계약일자
	String rent_start_dt = "";	// 이용기간 시작일
	String rent_end_dt = "";	// 이용기간 종료일
	
	// 계약일자는 대여요금의 계약일자
	rent_dt = base.getRent_dt();
	
	Vector vt = af_db.getRentDtConMon(rent_mng_id, rent_l_cd, 0);
	if(vt.size() < 1){
		vt = af_db.getRentDtConMon(rent_mng_id, rent_l_cd, 1);
	}
	
	for(int i=0; i<vt.size(); i++){
		Hashtable ht = (Hashtable)vt.elementAt(i); 
		rent_end_dt = String.valueOf(ht.get("RENT_END_DT"));
	}
	
	// 이용기간 시작일은 대여요금의 대여개시일
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(1));
	rent_start_dt = fees.getRent_start_dt();
	
	// 계약승계의 경우 이용기간 시작일은 계약승계날짜로 변경		2018.01.11
	String rent_suc_dt = af_db.getRentSucDt(rent_mng_id, rent_l_cd);
	if(rent_suc_dt.length() > 1){
		rent_start_dt = rent_suc_dt;
	}
	
	// 계약 연장이 있는 경우 마지막 연장계약의 대여만료일로 이용기간 종료일이 변경된다.
	ContFeeBean fees2 = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
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
	String driving_age = "";
	driving_age = base.getDriving_age();
 	Vector inss2 = ai_db.getInsHisList1(base.getCar_mng_id());
	
	
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <title>FMS</title>
    <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
    <style type="text/css">
        .table-style-1 {
            font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
            font-size: 9pt;
            color: #515150;
            font-weight: bold;
        }
        .table-back-1 {
            background-color: #B0BAEC
        }
        .table-body-1 {
            text-align: center;
            height: 26px;
        }
        .table-body-2 {
            text-align: center;
            padding-left: 10px;
            font-size: 10pt;
        }
        .font-1 {
            font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
            font-size: 9pt;
            font-weight: bold;
        }
        .font-2 {
            font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
            font-size: 9pt;
        }
    </style>

</head>

<body leftmargin="15">

<%-- 헤더 --%>
<div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan=10>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr>
                        <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>확인서 > <span class=style5>확인서출력목록</span></span></td>
                        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr><td class=h></td></tr>
    </table>
</div>

<%-- 확인서 출력 --%>
<div>
    <br>
    <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">확인서 출력</div>
    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="600" style="margin-top: 8px">
        <tr><td class=line2 colspan=2></td></tr>
        <tr>
            <td class="title" width=7%>연번</td>
            <td class="title" width=70%>확인서</td>
            <td class="title" width=23%>선택</td>
            <!-- <td colspan="3" class="title" width=50%>최근출력이력</td> -->
        </tr>
        <!-- <tr>
            <td class="title" width=15%>일시</td>
            <td class="title" width=25%>출력자</td>
            <td class="title" width=10%>이력보기</td>
        </tr> -->
        
        <tr class="table-body-1">
        	<td>1</td>
        	<td>자기차량손해확인서</td>
        	<td><button class="button" name="print1" id="print1" onclick="confirmTemplate('1')">출력</button>&nbsp;
        	    <button class="button" name="mail1" id="mail1" onclick="confirmEmail('1')">발송</button></td>
        	<!-- <td>-</td>
        	<td>-</td>
        	<td>-</td> -->
        </tr>
        
        <tr class="table-body-1">
        	<td>2</td>
        	<td>
        		자동차 대여이용 계약사실 확인서 &nbsp;
        		<!-- 대여료/보증금 표시여부 설정(20191105) -->
        		(대여료/보증금<input type="radio" name="view_amt" value="N" checked>미표시<input type="radio" name="view_amt" value="Y">표시)
        	</td>
        	<td><button class="button" name="print2" id="print2" onclick="confirmTemplate('2')">출력</button>&nbsp;
        	    <button class="button" name="mail2" id="mail2" onclick="confirmEmail('2')">발송</button></td>
        	<!-- <td>-</td>
        	<td>-</td>
        	<td>-</td> -->
        </tr>
        
        <tr class="table-body-1">
        	<td>3</td>
        	<td>자동차보험 관련 특약 약정서</td>
        	<td><button class="button" name="print2" id="print3" onclick="javascript:reqdoc('<%=fees.getRent_l_cd()%>','<%=fees.getRent_mng_id()%>','<%=fees.getRent_st()%>')">출력</button>&nbsp;
        	    <button class="button" name="mail3" id="mail3" onclick="confirmEmail('3')">발송</button></td>
        	<!-- <td>-</td>
        	<td>-</td>
        	<td>-</td> -->
        </tr>
        <!-- 자동차 장기대여 대여료의 결제수단 안내 (20191023)-->
        <tr class="table-body-1">
        	<td>4</td>
        	<td align="center">
        		자동차 장기대여 대여료의 결제수단 안내 &nbsp;
        		(<input type="radio" name="pay_way" value="ARS" checked>ARS&nbsp;&nbsp;
        		<input type="radio" name="pay_way" value="visit">방문)
        	</td>
        	<td><button class="button" name="print2" id="print4" onclick="javascript:noticePayWay('<%=base.getClient_id()%>','<%=base.getCar_mng_id()%>','<%=fees.getFee_s_amt()+fees.getFee_v_amt()%>','<%=base.getBus_id2()%>')">출력</button>&nbsp;
        	    <button class="button" name="mail4" id="mail4" onclick="confirmEmail('4')">발송</button></td>
        	<!-- <td>-</td>
        	<td>-</td>
        	<td>-</td> -->
        </tr>        
		<%
		if(client.getClient_st().equals("1") && inss2.size() > 0){
			Hashtable ins2 = (Hashtable)inss2.elementAt(0); 
		%>
         <tr class="table-body-1">
        	<td>5</td>
        	<td>임직원 전용 가입사실 확인서</td>
        	<td><button class="button" name="print2" id="print5" onclick="javascript:comEmpYnTemplate('<%=base.getCar_mng_id()%>','<%=ins2.get("INS_ST")%>','<%=base.getClient_id()%>', '<%=rent_l_cd%>')">출력</button>&nbsp;
        	    <button class="button" name="mail5" id="mail5" onclick="confirmEmail('5')">발송</button></td>
        	<!-- <td>-</td>
        	<td>-</td>
        	<td>-</td> -->
        </tr>
		<%
		}
		%>
		
        <tr class="table-body-1">
        	<td>6</td>
        	<td>
        		경찰서 제출용 계약사실 확인서 &nbsp;        		
        		<br>상품구분 : <input type="radio" name="view_good" value="N">미표시<input type="radio" name="view_good" value="Y" checked>표시
        		<br>연 락 처 :  <input type="radio" name="view_tel" value="N">미표시<input type="radio" name="view_tel" value="Y" checked>표시
        		<br>주 &nbsp;&nbsp;&nbsp;소 :    <input type="radio" name="view_addr" value="N">미표시<input type="radio" name="view_addr" value="Y" checked>표시
        	</td>
        	<td><button class="button" name="print6" id="print6" onclick="policeConfirm('<%=base.getClient_id()%>','<%=base.getCar_mng_id()%>','<%=fees.getFee_s_amt()+fees.getFee_v_amt()%>','<%=base.getBus_id2()%>')">출력</button>&nbsp;
        	    </td>        	
        </tr>		
        
        <%	String content_code = "LC_SCAN";
			String content_seq  = base.getRent_mng_id()+""+rent_l_cd+""+fee_size+"17";

			Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
			int attach_vt_size = attach_vt.size();
			
			if(attach_vt_size > 0){
		%>
        <tr class="table-body-1">
        	<td>7</td>
        	<td>
        		<%if(fee_size ==1){%>신규
			    <%}else{%><%=fee_size-1%>차연장
			    <%}%> 
        		대여개시후 계약서JPG (스캔파일)</td>
        	<td><button class="button" name="print7" id="print7" onclick="javascript:rentDocJpg()">출력</button>&nbsp;
        	    <button class="button" name="mail7" id="mail7" onclick="confirmEmail('7')">발송</button></td>     	
        </tr>		        
        <%	}%>
        		
    </table>
</div>

<form name="printForm" method="post">
	<input type="hidden" name="use_yn" id="use_yn" value="<%=base.getUse_yn()%>"><!-- 구분(진행, 해지...) -->
	<input type="hidden" name="firm_nm" value="<%=client.getFirm_nm()%>">	<!-- 회사명 -->
	<input type="hidden" name="client_nm" value="<%=client.getClient_nm()%>"><!-- 고객명 -->
	<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">					<!-- 계약번호 -->
	<input type="hidden" name="rent_mng_id" value="<%=base.getRent_mng_id()%>">					<!-- 계약번호 -->
	<input type="hidden" name="client_id" value="<%=base.getClient_id()%>">					<!-- 계약번호 -->
	<input type="hidden" name="rent_st" value="<%=rent_st%>">					<!-- 계약번호 -->
	<input type="hidden" name="car_no" value="<%=cr_bean.getCar_no()%>">	<!-- 차량번호 -->
	<input type="hidden" name="car_nm" value="<%=car_nm%>">						<!-- 차명 -->
	<input type="hidden" name="ssn" value="<%=ssn%>">									<!-- 법인등록번호 또는 생년월일 -->
	<input type="hidden" name="enp_no" value="<%=enp_no%>">						<!-- 사업자등록번호 -->
	<input type="hidden" name="address" value="<%=address%>">						<!-- 주소 -->
	<input type="hidden" name="rent_dt" value="<%=rent_dt%>">						<!-- 계약일자 -->
	<input type="hidden" name="car_color" value="<%=car_color%>">					<!-- 차량색상 -->
	<input type="hidden" name="rent_start_dt" value="<%=rent_start_dt%>">		<!-- 이용기간 시작일 -->
	<input type="hidden" name="rent_end_dt" value="<%=rent_end_dt%>">			<!-- 이용기간 종료일 -->
	<input type="hidden" name="driving_age" value="<%=driving_age%>">			<!-- 보험가입운전자 연령 -->
	<input type="hidden" name="fee_amt" value="<%=fees2.getFee_s_amt()+fees2.getFee_v_amt()%>"><!-- 신규/n차연장 대여료-->
	<input type="hidden" name="grt_amt" value="<%=fees2.getGrt_amt_s()%>">	<!-- 신규/n차연장 보증금 -->
	<input type="hidden" name="view_amt" value="">	
	<input type="hidden" name="pay_way" value="">
	<input type="hidden" name="view_good" value="">
	<input type="hidden" name="view_tel" value="">
	<input type="hidden" name="view_addr" value="">
	<input type="hidden" name="user_id" value="<%=ck_acar_id%>">
</form>

</body>
<script>
	// 구분이 해지인 경우 자동차 대여이용 계약사실 확인서 비활성화		2018.01.11  ->  기간 명시되므로 해지 조건 넣지 않는다. 20200306
	/*
	$(document).ready(function(){
		if($("#use_yn").val()=="N"){
			$("#print2").hide();
		}
	});
	*/
	
	function confirmEmail(type){
		var url = "about:blank";
		window.open(url, 'CONFIRM_TEMPLATE', "left=50, top=50, width=500, height=700, scrollbars=yes");
		
		var view_amt = $("input[name='view_amt']:checked").val();
		var pay_way = $("input[name='pay_way']:checked").val();
		var view_good = $("input[name='view_good']:checked").val();
		var view_tel = $("input[name='view_tel']:checked").val();
		var view_addr = $("input[name='view_addr']:checked").val();
		
		var frmData = document.printForm;
		
		if(type == 7 && frmData.rent_st.value==''){
			frmData.rent_st.value = <%=fee_size%>;
		}
		
		frmData.target = "CONFIRM_TEMPLATE";
		frmData.action = "select_mail_input_rent_docs.jsp?type="+type+"&view_amt="+view_amt+'&pay_way='+pay_way+'&view_good='+view_good+'&view_tel='+view_tel+'&view_addr='+view_addr;
		frmData.submit();
	}	

	function confirmTemplate(type){
		var view_amt = $("input[name='view_amt']:checked").val();

		var url = "./lc_c_h_confirm_template.jsp?type="+type+"&view_amt="+view_amt;
		window.open(url, 'CONFIRM_TEMPLATE', "left=50, top=50, width=900, height=700, scrollbars=yes");
					
		var frmData = document.printForm;
		frmData.target = "CONFIRM_TEMPLATE";
		frmData.action = "./lc_c_h_confirm_template.jsp?type="+type+"&view_amt="+view_amt;
		frmData.submit();
	}
	
	//특약요청서 열기
	function reqdoc(rent_l_cd, rent_mng_id, rent_st){
		var url = 'lc_b_s_reqdoc.jsp?rent_l_cd='+rent_l_cd+'&rent_mng_id='+rent_mng_id+'&rent_st='+rent_st;
		window.open(url, "popupView", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");
	}
	//임직원 전용 가입 사실 확인서 열기
	function comEmpYnTemplate(car_mng_id,ins_st ,client_id, rent_l_cd){
		var url = '/acar/ins_mng/ins_u_sh_emp_print.jsp?car_mng_id='+car_mng_id+'&ins_st='+ins_st+'&client_id='+client_id+'&rent_l_cd='+rent_l_cd;
		window.open(url, "popupView", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");
	}
	//자동차 장기대여 대여료의 결제수단 안내(20191023)
	function noticePayWay(client_id, car_mng_id, fee_amt, bus_id2){
		var pay_way = $("input[name='pay_way']:checked").val();
		
		var url = './lc_c_h_confirm_template2.jsp?client_id='+client_id+'&car_mng_id='+car_mng_id+'&fee_amt='+fee_amt+'&bus_id2='+bus_id2+'&pay_way='+pay_way;
		window.open(url, "popupView", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");
	}
	//경찰서제출용 계약사실확인서(20201019)
	function policeConfirm(client_id, car_mng_id, fee_amt, bus_id2){
		var view_good = $("input[name='view_good']:checked").val();
		var view_tel = $("input[name='view_tel']:checked").val();
		var view_addr = $("input[name='view_addr']:checked").val();

		var url = "./lc_c_h_confirm_template3.jsp?user_id=<%=ck_acar_id%>&rent_mng_id=<%=base.getRent_mng_id()%>&rent_l_cd=<%=rent_l_cd%>&client_id="+client_id+"&car_mng_id="+car_mng_id+"&fee_amt="+fee_amt+"&bus_id2="+bus_id2+"&view_good="+view_good+"&view_tel="+view_tel+"&view_addr="+view_addr;
		window.open(url, 'CONFIRM_TEMPLATE', "left=50, top=50, width=900, height=700, scrollbars=yes");
					
		var frmData = document.printForm;
		frmData.target = "CONFIRM_TEMPLATE";
		frmData.action = "./lc_c_h_confirm_template3.jsp?user_id=<%=ck_acar_id%>&rent_mng_id=<%=base.getRent_mng_id()%>&rent_l_cd=<%=rent_l_cd%>&client_id="+client_id+"&car_mng_id="+car_mng_id+"&fee_amt="+fee_amt+"&bus_id2="+bus_id2+"&view_good="+view_good+"&view_tel="+view_tel+"&view_addr="+view_addr;
		frmData.submit();
	}
	//대여개시후 계약서JPG
	function rentDocJpg(){
		var url = './lc_c_h_confirm_template4.jsp?rent_mng_id=<%=base.getRent_mng_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=fee_size%>';
		window.open(url, "popupView", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");
	}	
</script>
</html>