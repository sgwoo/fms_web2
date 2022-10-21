<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//보조번호판 발급정보
	CarSecondPlateBean second_plate = a_db.getCarSecondPlate(rent_mng_id, rent_l_cd);
	
	//대여료갯수조회(연장여부)
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//특이사항 조회
	if (!from_page.equals("99") ) { 
		from_page = "/fms2/lc_rent/lc_c_c_etc.jsp";
	}
	
	String valus = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src="//code.jquery.com/jquery.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function openDaumPostcode() {
	new daum.Postcode({
		oncomplete: function(data) {
			document.getElementById("client_zip").value = data.zonecode;
			document.getElementById("client_addr").value = data.roadAddress;
		}
	}).open();
}
</script>
<style type="text/css">
<!--
.style1 {color: #666666}
.custom-div {padding: 3px 10px;}
.custom-span {display: inline-block;}
.custom-span-1 {display: inline-block; width: 120px;}
.custom-span-2 {display: inline-block; width: 120px;}
.custom-select {width: 110px;}
.custom-input {height: 20px;}
.custom-input-1 {height: 22px; margin-top: 0px;}
.custom-input-2 {height: 22px; margin-top: 5px;}
.center {text-align: center;}
-->
</style>

<script language="JavaScript">
<!--
//수정
function update() {
	var fm = document.form1;
	
	var num_regex = /^[0-9]+$/g;
	
	if (fm.second_plate_yn.value == "Y") {
		if (fm.warrant.value == "") {
			alert("보조번호판 발급 요청시 위임장은 필수로 선택해주세요.");
			return;
		}
		if (fm.car_regist.value == "") {
			alert("보조번호판 발급 요청시 차량등록증은 사본 또는 원본(회수필수)으로 선택해주세요.");
			return;
		}
		if (fm.client_nm.value == "") {
			alert("보조번호판 발급 요청시 우편물 수령자를 입력하세요.");
			return;
		}
		if (fm.client_number.value == "") {
			alert("보조번호판 발급 요청시 수령자 연락처를 입력하세요.");
			return;
		}
		if (!num_regex.test(fm.client_number.value)) {
        	alert("수령자 연락처는 기호없이 숫자로만 입력해주세요.");
        	return;
        }
		if (fm.client_addr.value == "") {
			alert("보조번호판 발급 요청시 우편물 수령지를 입력하세요.");
			return;
		}
	}
	
	if (confirm("수정하시겠습니까?")) {
		fm.action = "cng_etc_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
}
//-->
</script> 
</head>
<body leftmargin="15">
<form action='lc_b_u_a.jsp' name="form1" method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
<input type='hidden' name='andor'	value='<%=andor%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>  
<input type='hidden' name='gubun3' value='<%=gubun3%>'>    
<input type='hidden' name='gubun4' value='<%=gubun4%>'>  
<input type='hidden' name='gubun5' value='<%=gubun5%>'>    
<input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
<input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
<input type='hidden' name="rent_mng_id"	value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
<input type='hidden' name="from_page" 	value="<%=from_page%>">
<input type='hidden' name="car_no" 	value="<%=cr_bean.getCar_no()%>">
<input type='hidden' name="car_nm" 	value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>">
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약서수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>상호</td>
                    <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>차명<%}else{%>차량번호<%}%></td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>
        			</td>
                </tr>
    		</table>
	    </td>
	</tr>  	  
	<tr>
	    <td align="right">&nbsp;</td>
	<tr>
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>특이사항</span></td>
    </tr>
	<!--
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">고객</td>
                    <td>&nbsp;<textarea rows='4' cols='110' name='remark'><%=client.getEtc()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr> 				
    <tr>
        <td class=h></td>
    </tr>   	
	-->
    
    
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%">보조번호판발급</td>
                    <td>
                    	<div class="custom-div">
                    		<select class="custom-select" id="second_plate_yn" name="second_plate_yn">
                    			<%if (second_plate.getSecond_plate_yn().equals("")) {%>
                    			<option value="">선택</option>
                    			<option value="Y">요청</option>
                    			<%} else {%>
                    			<%if (nm_db.getWorkAuthUser("전산팀", user_id) || user_id.equals("000096") || user_id.equals("000153")) {%>
                    			<option value="" <%if (second_plate.getSecond_plate_yn().equals("")) {%>selected<%}%>>선택</option>
                    			<%}%>
                    			<option value="Y" <%if (second_plate.getSecond_plate_yn().equals("Y")) {%>selected<%}%>>요청</option>
                    			<%}%>
                    		</select>
                    		<span class="custom-span" style="padding-left: 10px; color: red;">※ 보조번호판 발급 요청시 아래 필요한 서류를 선택 및 입력해주세요.</span>
                    	</div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td class="title" width="13%">위임장</td>
					<td colspan="3">&nbsp;
	 					<select class="custom-select" id="warrant" name="warrant">
		          			<option value="" <%if (second_plate.getWarrant().equals("")) {%>selected<%}%>>선택</option>
		          			<option value="Y" <%if (second_plate.getWarrant().equals("Y")) {%>selected<%}%>>필수</option>
         				</select>
         			</td>
				</tr>
				<tr>
					<td class="title" width="13%">사업자등록증</td>
					<td>&nbsp;
						<select class="custom-select" id="bus_regist" name="bus_regist">
		          			<option value="" <%if (second_plate.getBus_regist().equals("")) {%>selected<%}%>>선택</option>
		          			<option value="Y" <%if (second_plate.getBus_regist().equals("Y")) {%>selected<%}%>>필요</option>
		          		</select>
					</td>
					<td class="title" width="13%">차량등록증</td>
					<td>&nbsp;
						<select class="custom-select" id="car_regist" name="car_regist">
		          			<option value="" <%if (second_plate.getCar_regist().equals("")) {%>selected<%}%>>선택</option>
		          			<option value="1" <%if (second_plate.getCar_regist().equals("1")) {%>selected<%}%>>사본</option>
		          			<option value="2" <%if (second_plate.getCar_regist().equals("2")) {%>selected<%}%>>원본(회수필수)</option>
		          		</select>
         			</td>
				</tr>
				<tr>
					<td class="title" width="13%">법인등기부등본</td>
					<td>&nbsp;
						<select class="custom-select" id="corp_regist" name="corp_regist">
		          			<option value="" <%if (second_plate.getCorp_regist().equals("")) {%>selected<%}%>>선택</option>
		          			<option value="Y" <%if (second_plate.getCorp_regist().equals("Y")) {%>selected<%}%>>필요</option>
		          		</select>
	         		</td>
					<td class="title" width="13%">법인임감증명서</td>
					<td>&nbsp;
						<select class="custom-select" id="corp_cert" name="corp_cert">
		          			<option value="" <%if (second_plate.getCorp_cert().equals("")) {%>selected<%}%>>선택</option>
		          			<option value="Y" <%if (second_plate.getCorp_cert().equals("Y")) {%>selected<%}%>>필요</option>
		          		</select>
					</td>
				</tr>
				<tr>
					<td  class="title" width="13%">우편물 수령자</td>
					<td>&nbsp;
						<input type="text" class="text custom-input" id="client_nm" name="client_nm" value="<%=second_plate.getClient_nm()%>">
         			</td>
					<td class="title" width="13%">수령자 연락처</td>
					<td>&nbsp;
						<input type="text" class="text custom-input" id="client_number" name="client_number" value="<%=second_plate.getClient_number()%>">
					</td>
				</tr>
				<tr>
					<td class="title" width="13%">우편물 수령지</td>
					<td colspan="3">&nbsp;
						<div style="display: inline-block;">
							<input type="text" class="text custom-input-1" name="client_zip" id="client_zip" size="7" maxlength='7' value="<%=second_plate.getClient_zip()%>" placeholder="우편번호" readonly style="width: 7em;">
							&nbsp;<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
							<input type="text" class="text custom-input-2" name="client_addr" id="client_addr" value="<%=second_plate.getClient_addr()%>" size="75" placeholder="주소" readonly style="width: 38em;"><br>
							<input type="text" class="text custom-input-2" name="client_detail_addr" id="client_detail_addr" value="<%=second_plate.getClient_detail_addr()%>" size="75" placeholder="상세주소" style="width: 20em;">
		          		</div>
         			</td>
				</tr>
			</table>
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>
    
    
     
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%">신용평가</td>
                    <td>&nbsp;<textarea rows='4' cols='110' name='dec_etc'><%=cont_etc.getDec_etc()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr> 				
    <tr>
        <td class=h></td>
    </tr>   	
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%">대여차량</td>
                    <td>&nbsp;<textarea rows='4' cols='110' name='remark'><%=car.getRemark()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr> 				
    <tr>
        <td class=h></td>
    </tr>   	
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%">보험사항</td>
                    <td>&nbsp;<textarea rows='4' cols='110' name='others'><%=base.getOthers()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr> 				
    <tr>
        <td class=h></td>
    </tr>  
  	<%		for(int i=1; i<=fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i));
				ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(i));%>		 	
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>												
                <tr>
                    <td class=title width="13%"><%if(i >1){%><%=i-1%>차 연장 <%}%>대여요금<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td>&nbsp;<textarea rows='4' cols='110' name='fee_cdt<%=i%>'><%=fees.getFee_cdt()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr> 				
    <tr>
        <td class=h></td>
    </tr>   	
	<%	if(nm_db.getWorkAuthUser("영업효율",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
	<tr>
    <tr>
        <td class=line2></td>
    </tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%"><%if(i >1){%><%=i-1%>차 연장 <%}%>영업효율</td>
                    <td>&nbsp;<textarea rows='4' cols='110' name='bc_etc<%=i%>'><%=fee_etcs.getBc_etc()%></textarea></td>
                </tr>							
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>   	
	<%	}else{%>		
	<input type='hidden' name="bc_etc<%=i%>" 		value="<%=fee_etcs.getBc_etc()%>">
	<%	}%>
	
	<%if(fee_etcs.getRent_st().equals("1")){%>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%">견적사후관리<br>(계약체결 사유 입력)</td>
                    <td>&nbsp;<textarea rows='4' cols='110' name='bus_cau'><%=fee_etcs.getBus_cau()%></textarea></td>
                </tr>							
            </table>
        </td>
    </tr> 	
    <tr>
        <td class=h></td>
    </tr>   
	<%}%>			
	    
	<%}%>			
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td class=title width="13%">해지 비고</td>
                    <td>&nbsp;<textarea rows='4' cols='110' name='cls_etc'><%=cont_etc.getCls_etc()%></textarea></td>
                </tr>							
            </table>
        </td>
    </tr> 	
    <tr>
        <td class=h></td>
    </tr>   	
    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>	
    <tr>
	    <td align='center'> 
	    <% if (!from_page.equals("99") ) {%> 
	  	<a href='javascript:update();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
	  	<% } %> 
	  	&nbsp;
	  	<a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 
	  	</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
