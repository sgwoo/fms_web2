<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*,acar.cont.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"    class="acar.cont.AddContDatabase" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "02", "01");
	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String acq_std = request.getParameter("acq_std")==null?"":request.getParameter("acq_std");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
//	System.out.println(acq_std);
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
function CarAcqUp()
{
	var theForm = document.CarAcqForm;
	
	if (theForm.acq_amt_card.checked == true ) {
	 	theForm.acq_amt_card.value = "Y";
	}
	
	if (theForm.acq_amt_card.checked == false ) {
	 	theForm.acq_amt_card.value = "N";
	}
	
	//제주등록은 카드결제없음.
	if(theForm.acq_is_o.value.indexOf("제주") != -1){
		theForm.acq_amt_card.value = "N";
	} 
		
	//금액이 있다면 납부일자 check
	
	if(theForm.acq_acq.value == '' || theForm.acq_acq.value == '0'){
	} else {	
		if(theForm.acq_ex_dt.value==""){		alert("납부일자를 확인하세요"); 			theForm.acq_ex_dt.focus(); return; }
	}
		
	if(!confirm('수정하시겠습니까?'))
	{
		return;
	}
	
	theForm.cmd.value = "u";
	theForm.target = "nodisplay"
	theForm.submit();
}

function init()
{
	var theForm1 = parent.c_body.CarRegForm;
	var theForm2 = document.CarAcqForm;
	theForm2.acq_std.value = parseDecimal(theForm1.acq_std.value);
	theForm2.acq_acq.value = parseDecimal(theForm1.acq_amt.value);		// 취득세로 정정 (org -> acq_acq.value)
	//console.log("###");
	//console.log("acq_amt : " + theForm1.acq_amt.value);
	theForm2.acq_f_dt.value = ChangeDate2(theForm1.acq_f_dt.value);
	theForm2.acq_ex_dt.value = ChangeDate2(theForm1.acq_ex_dt.value);
	theForm2.acq_re.value = theForm1.acq_re.value;
	theForm2.acq_is_p.value = theForm1.acq_is_p.value;
	theForm2.acq_is_o.value = theForm1.acq_is_o.value;
	theForm2.car_mng_id.value = theForm1.car_mng_id.value;
	theForm2.rent_mng_id.value = theForm1.rent_mng_id.value;
	theForm2.rent_l_cd.value = theForm1.rent_l_cd.value;
	theForm2.acq_amt_card.value = theForm1.acq_amt_card.value;
	
	if (theForm2.acq_amt_card.value == "Y" ) {
	 	theForm2.acq_amt_card.checked = true;
	}
	theForm2.acq_std.value = parseDecimal(toInt(parseDigit(theForm2.car_fs_amt.value)) + toInt(parseDigit(theForm2.sd_cs_amt.value)) - toInt(parseDigit(theForm2.dc_cs_amt.value)) );
	<%if(br_id.equals("S1")){%>
	<%	if(!cmd.equals("ud")){%>
			if(theForm2.acq_acq.value == '' || theForm2.acq_acq.value == '0'){
				//theForm2.acq_amt_card.checked = true; //20210622 취득세 현금결제
			}
	<%	}%>
	<%}%>
	//신규인것 취득세 납부일자 setting 
	<%	if(!cmd.equals("ud")){%>
			if(theForm2.acq_ex_dt.value == ''){
				theForm2.acq_ex_dt.value = theForm2.reg_pay_dt.value;
			}
	<%	}%>
	

}
function ChangeFDT()
{
	var theForm = document.CarAcqForm;
	theForm.acq_f_dt.value = ChangeDate2(theForm.acq_f_dt.value);

}
/* 취득세 계산 */
function SetAcq()
{
	var theForm = document.CarAcqForm;
//	theForm.acq_acq.value = Math.floor(parseInt(theForm.acq_std.value, 10)*0.02);
	theForm.acq_acq.value = parseDecimal(Math.floor(toInt(parseDigit(theForm.acq_std.value))*0.02))
	theForm.acq_acq.focus();
}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:init()">

<form action="./register_acq_ui.jsp" name="CarAcqForm" method="POST" >

<input type="hidden" name="car_fs_amt" value="<%=car.getCar_fs_amt()%>">
<input type="hidden" name="sd_cs_amt" value="<%=car.getSd_cs_amt()%>">
<input type="hidden" name="dc_cs_amt" value="<%=car.getDc_cs_amt()%>">
<%	if(cmd.equals("ud")){%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>취득세</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td width=10% class=title>과세표준</td>
                    <td width=23% align="center"><input type="text" name="acq_std" value="<%=AddUtil.parseDecimal(acq_std)%>" size="12" class=whitenum readonly>원</td>
                    <td width=10% class=title>취득세</td>
                    <td width=23% align="center"><input type="text" name="acq_acq" value="" size="12" class=whitenum readonly>원</td>
                    <td width=10% class=title>납기일자</td>
                    <td width=24% align="center"><input type="text" name="acq_f_dt" value="" size="12" class=white readonly></td>
                </tr>
                <tr>
                    <td class=title>문의처</td>
                    <td>&nbsp;<input type="text" name="acq_re" value="" size="12" class=white readonly></td>
                    <td class=title>고지서발급자</td>
                    <td>&nbsp;<input type="text" name="acq_is_p" value="" size="12" class=white readonly></td>
                    <td class=title>발급처</td>
                    <td>&nbsp;<input type="text" name="acq_is_o" value="" size="12" class=white readonly></td>
                </tr>
                <tr>
                    <td class=title>납부일자</td>
                    <td >&nbsp;<input type="text" name="acq_ex_dt" value="" size="25" class=white readonly></td>
                    <td class=title>취득세결재</td>                    
                    <td colspan="3">&nbsp;<input type="checkbox" name="acq_amt_card" value="Y" >
					    카드결재
        	   	    </td>
                </tr>				
            </table>
        </td>
    </tr>

</table>
<%	}else{%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>취득세</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td width=10% class=title>과세표준</td>
                    <td width=23% >&nbsp;<input type="text" name="acq_std" value="<%=AddUtil.parseDecimal(acq_std)%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); SetAcq()'> 원</td>
                    <td width=10% class=title>취득세</td>
                    <td width=23% >&nbsp;<input type="text" name="acq_acq" value="" size="12" class=num onBlur="javascript:this.value=parseDecimal(this.value);"> 원</td>
                    <td width=10% class=title>납기일자</td>
                    <td width=24%>&nbsp;<input type="text" name="acq_f_dt" value="" size="25" class=text onBlur="javascript:ChangeFDT()"></td>
                </tr>
                <tr>
                    <td class=title>문의처</td>
                    <td>&nbsp;<input type="text" name="acq_re" value="" size="25" class=text></td>
                    <td class=title>고지서발급자</td>
                    <td>&nbsp;<input type="text" name="acq_is_p" value="" size="25" class=text></td>
                    <td class=title>발급처</td>
                    <td>&nbsp;<input type="text" name="acq_is_o" value="" size="25" class=text></td>
                </tr>
                <tr>
                    <td class=title>납부일자</td>
                    <td>&nbsp;<input type="text" name="acq_ex_dt" value="" size="25" class=text></td>
                    <td class=title>취득세결재</td>                    
                    <td colspan="3">&nbsp;<input type="checkbox" name="acq_amt_card" value="Y"   >
					    카드결재
        	   	    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td align="right"><a href="javascript:CarAcqUp()"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
<%	}%>
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
</form>
</body>
</html>