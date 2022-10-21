<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_mst.*, acar.client.*, acar.car_register.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "01", "07", "15");
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//자동차등록정보
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	//보조번호판 발급정보
	CarSecondPlateBean second_plate = a_db.getCarSecondPlate(rent_mng_id, rent_l_cd);	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
<script>
    $.datepicker.setDefaults({
        dateFormat: "yy-mm-dd",
        prevText: "이전 달",
        nextText: "다음 달",
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        dayNames: ["일", "월", "화", "수", "목", "금", "토"],
        dayNamesShort: ["일", "월", "화", "수", "목", "금", "토"],
        dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
        showMonthAfterYear: true,
        changeMonth: true,
        changeYear: true,
        yearSuffix: "년"
    });

    $(function() {
        $("#return_dt").datepicker();
    });
</script>
<script language='javascript'>
<!--
function update(){		
	var fm = document.form1;
	
	if ($("#second_plate_yn").val() == "") {
		alert("보조번호판 상태를 변경 하실 경우 회수 또는 미회수로 선택해주세요.");
		return;
	}
	
	if ($("#second_plate_yn").val() == "R") {
		if ($("#return_dt").val() == "") {
			alert("회수 일자를 입력해 주세요.");
			return;
		} else {
			$("#etc").val("");
		}
	}
	
	if ($("#second_plate_yn").val() == "N") {
		if ($("#etc").val() == "") {
			alert("미회수 사유를 입력해 주세요.");
			return;
		} else {
			$("#return_dt").val("");
		}
	}
	
	if (confirm("수정 하시겠습니까?")) {
		fm.action = "second_plate_update_pop_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
}
//-->

function second_plate_change(str) {
	if (str == "R") {
		$("#return").css("display", "");
		$("#no-return").css("display", "none");
	} else if (str == "N") {
		$("#return").css("display", "none");
		$("#no-return").css("display", "");
	} else {
		$("#return").css("display", "none");
		$("#no-return").css("display", "none");
	}
	$("#return_dt").val("");
	$("#etc").val("");
}
</script>
<style>
.ui-datepicker-calendar th {
	background-color: #FFFFFF !important;
}
.ui-datepicker select.ui-datepicker-month, .ui-datepicker select.ui-datepicker-year {
    width: 35% !important;
}
</style>
</head>

<body>
<center>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">  
<input type="hidden" name="gubun2" value="<%=gubun2%>"> 
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="firm_nm" value="<%=client.getFirm_nm()%>">
<table border="0" cellspacing="0" cellpadding="0" width=670>
    <tr>
    	<td>
    	    <table width="100%" border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src="/acar/images/center/menu_bar_1.gif" width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;<img src="/acar/images/center/menu_bar_dot.gif" width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>보조번호판관리</span></span></td>
                    <td width=7><img src="/acar/images/center/menu_bar_2.gif" width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class="h"></td>
    </tr>
    <tr>
        <td>
        	<img src="/acar/images/center/icon_arrow.gif" align="absmiddle"> <span class="style2">계약정보</span>
        </td>
    </tr>
    <tr>
        <td class="line2"></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                    <td class="title" width="20%">계약번호</td>
                    <td width="30%">&nbsp;
                    	<%=rent_l_cd%>
                    </td>
                    <td class="title" width="20%">대여기간</td>
                    <td width="30%">&nbsp;
                    	<%=AddUtil.ChangeDate2(base.getRent_start_dt())%> ~ <%=AddUtil.ChangeDate2(base.getRent_end_dt())%>
                    </td>
                </tr>
                <tr> 
                    <td class="title">상호</td>
                    <td colspan="3">&nbsp;
                    	<%=client.getFirm_nm()%><%if(!client.getClient_st().equals("2")){%>&nbsp;<%=client.getClient_nm()%><%}%>
                    </td>
                </tr>                     
                <tr> 
                    <td class="title">고객구분</td>
                    <td>&nbsp;
                    	<%if (client.getClient_st().equals("1")) {%>
                    	법인
                    	<%} else if (client.getClient_st().equals("2")) {%>
                    	개인
                    	<%} else if (client.getClient_st().equals("3")) {%>
                    	개인사업자(일반과세)
                    	<%} else if (client.getClient_st().equals("4")) {%>
                    	개인사업자(간이과세)
                    	<%} else if (client.getClient_st().equals("5")) {%>
                    	개인사업자(면세사업자)
                    	<%} else if (client.getClient_st().equals("6")) {%>
                    	경매장
                    	<%}%>
        			</td>
                    <td class="title">사업자번호</td>
                    <td>&nbsp;
                    	<%if(!client.getClient_st().equals("2")){%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%><%}%>
                    </td>
                </tr>                
            </table>
    	</td>
    </tr>
    <%if(!site.getR_site().equals("")){%>
    <tr>
        <td class="h"></td>
    </tr>            
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">        
                <tr> 
                    <td class="title" width="20%">
                    	<%if (site.getSite_st().equals("1")) {%>
                    	지점
                    	<%} else if (site.getSite_st().equals("2")) {%>
                    	현장
                    	<%}%>
					</td>
                    <td width="30%">&nbsp;
                    	<%=site.getR_site()%>
                    </td>
                    <td class="title" width="20%">사업자번호</td>
                    <td width="30%">&nbsp;
                    	<%=AddUtil.ChangeEnp(site.getEnp_no())%>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%}%>
    <tr>
        <td class="h"></td>
    </tr>    
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>
                    <td class="title" width="20%">차량번호</td>
                    <td width="30%">&nbsp;
                    	<%=cr_bean.getCar_no()%>
                    </td>
                    <td class="title" width="20%">차대번호</td>
                    <td width="30%">&nbsp;
                    	<%=cr_bean.getCar_num()%>
                    </td>
                </tr>
                <tr>
                    <td class="title">차명</td>
                    <td colspan="3">&nbsp;
                    	<%=cr_bean.getCar_nm()%> <%=cm_bean.getCar_name()%>
                    </td>
                </tr>
                <tr>
                    <td class="title">옵션</td>
                    <td colspan="3">&nbsp;
                    	<%=car.getOpt()%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="h"></td>
    </tr>
    <tr>
        <td>
        	<img src="/acar/images/center/icon_arrow.gif" align="absmiddle"> <span class="style2">보조번호판 요청정보</span>
        </td>
    </tr>
    <tr>
        <td class="line2"></td>
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>
                    <td class="title" width="20%">위임장</td>
                    <td width="30%">&nbsp;
                    	<%if (second_plate.getWarrant().equals("Y")) {%>필수<%}%>
                    </td>
                    <td class="title" width="20%">차량등록증</td>
                    <td width="30%">&nbsp;
                    	<%if (second_plate.getCar_regist().equals("1")) {%>
                    	사본
                    	<%} else if (second_plate.getCar_regist().equals("2")) {%>
                    	원본(회수필수)
                    	<%}%>
                    </td>
                </tr>
                <tr>
                    <td class="title" width="20%">사업자등록증</td>
                    <td width="30%">&nbsp;
                    	<%if (second_plate.getBus_regist().equals("Y")) {%>필요<%} else {%>불필요<%}%>
                    </td>
                    <td class="title" width="20%">법인등기부등본</td>
                    <td width="30%">&nbsp;
                    	<%if (second_plate.getCorp_regist().equals("Y")) {%>필요<%} else {%>불필요<%}%>
                    </td>
                </tr>
                <tr>
                    <td class="title" width="20%">법인임감증명서</td>
                    <td width="80%" colspan="3">&nbsp;
                    	<%if (second_plate.getCorp_cert().equals("Y")) {%>필요<%} else {%>불필요<%}%>
                    </td>
                </tr>
                <tr>
                    <td class="title" width="20%">고객정보</td>
                    <td width="80%" colspan="3">&nbsp;
                    	우편물 수령자 : <%=second_plate.getClient_nm()%><br>
                    	&nbsp;
                    	수령자 연락처 : <%=second_plate.getClient_number()%><br>
                    	&nbsp;
                    	우편물 수령지 : <%=second_plate.getClient_zip()%>&nbsp;<%=second_plate.getClient_addr()%>&nbsp;<%=second_plate.getClient_detail_addr()%>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td class="h"></td>
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>
                    <td class="title" width="20%">보조번호판</td>
                    <td colspan="3" width="80%">&nbsp;
                    	<select class="custom-select" id="second_plate_yn" name="second_plate_yn" onchange="second_plate_change(this.value)"><!-- onclick="second_plate_change(this.value)" -->                    		
                    		<option value="" <%if (second_plate.getSecond_plate_yn().equals("Y")) {%>selected<%}%>>선택</option>
                    		<option value="R" <%if (second_plate.getSecond_plate_yn().equals("R")) {%>selected<%}%>>회수</option>
                    		<option value="N" <%if (second_plate.getSecond_plate_yn().equals("N")) {%>selected<%}%>>미회수</option>
                    	</select>
                    </td>
                </tr>
                <tr id="return" <%if (!(second_plate.getSecond_plate_yn().equals("R"))) {%>style="display: none;"<%}%>>
                    <td class="title" width="20%">회수일자</td>
                    <td colspan="3" width="80%">&nbsp;
                    	<input type="text" class="text custom-input" id="return_dt" name="return_dt" value="<%=AddUtil.ChangeDate2(second_plate.getReturn_dt())%>" readonly>
                    </td>
                </tr>
                <tr id="no-return" <%if (!(second_plate.getSecond_plate_yn().equals("N"))) {%>style="display: none;"<%}%>>
                    <td class="title" width="20%">미회수사유</td>
                    <td colspan="3" width="80%">&nbsp;
                    	<textarea rows="3" cols="80" id="etc" name="etc"><%=second_plate.getEtc()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td class="h"></td>
    </tr>
    <tr>
    	<td align="right">
    		<a href="javascript:update()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
    		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    	</td>
    </tr>
</table>
</form>
<script language="JavaScript">
<!--		
//-->
</script>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
