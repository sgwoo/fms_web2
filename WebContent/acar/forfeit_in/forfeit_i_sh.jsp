<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*" %>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function CarRentSearch(arg){
		var theForm = document.ForfeitForm;
		var rent_l_cd = "";
		var firm_nm = "";
		var car_no = "";
		var keyValue = event.keyCode;
		if (keyValue =='13'){
			if(arg=="rent_l_cd"){
				rent_l_cd = theForm.rent_l_cd.value;
			}else if(arg=="firm_nm"){
				firm_nm = theForm.firm_nm.value;
			}else if(arg=="car_no"){
				car_no = theForm.car_no.value;
			}
			var SUBWIN="./car_rent_list.jsp?gubun=" + arg + "&rent_l_cd=" + rent_l_cd + "&firm_nm=" + firm_nm + "&car_no=" + car_no;	
			window.open(SUBWIN, "CarRentList", "left=100, top=100, width=600, height=300, scrollbars=yes");
		}
	}

	function ForfeitReg(){
		var theForm = document.ForfeitForm;
		if(theForm.seq_no.value!=""){	alert("수정만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "i";
		theForm.h_paid_amt.value = parseDigit(theForm.paid_amt.value);
		theForm.vio_dt.value = theForm.vio_ymd.value + "" + theForm.vio_s.value + "" +theForm.vio_m.value; 
		theForm.target = "nodisplay"
		theForm.submit();
	}

	function ForfeitUp(){
		var theForm = document.ForfeitForm;
		if(theForm.seq_no.value==""){	alert("등록만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('수정하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "u";
		theForm.h_paid_amt.value = parseDigit(theForm.paid_amt.value);
		theForm.vio_dt.value = theForm.vio_ymd.value + "" + theForm.vio_s.value + "" +theForm.vio_m.value;
		theForm.target = "nodisplay";
		theForm.submit();
	}

	function ForfeitDel(){
		var theForm = document.ForfeitForm;
		if(theForm.seq_no.value==""){	alert("등록만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('삭제하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "d";
		theForm.h_paid_amt.value = parseDigit(theForm.paid_amt.value);
		theForm.vio_dt.value = theForm.vio_ymd.value + "" + theForm.vio_s.value + "" +theForm.vio_m.value;
		theForm.target = "nodisplay";
		theForm.submit();
	}

	function PaidNoCheck(){
		var theForm1 = document.ForfeitForm;
		var theForm2 = document.PaidNoCheckForm;
		if(theForm1.cmd.value!="up"){
			theForm2.h_paid_no.value = theForm1.paid_no.value;
			theForm2.target = "nodisplay";
			theForm2.submit();
		}
	}

	function ClearM(){
		var theForm1 = document.ForfeitForm;
		theForm1.vio_ymd.value='';
		theForm1.vio_s.value='';
		theForm1.vio_m.value='';
		theForm1.tel.value='';
		theForm1.fax.value='';
		theForm1.vio_pla.value='';
		theForm1.vio_cont.value='';
		theForm1.paid_no.value='';
		theForm1.rec_dt.value='';
		theForm1.paid_end_dt.value='';
		theForm1.paid_amt.value='';
		theForm1.h_paid_amt.value='';
		theForm1.proxy_dt.value='';
		theForm1.dem_dt.value='';
		theForm1.rec_plan_dt.value='';
		theForm1.coll_dt.value='';
		theForm1.note.value='';
		theForm1.cmd.value='';
		theForm1.seq_no.value='';
		theForm1.call_nm.value='';
		theForm1.vio_dt.value='';
		theForm1.no_paid_yn.checked = false;	
		theForm1.no_paid_cau.value='';		
		theForm1.update_id.value='';		
		theForm1.update_dt.value='';		
	}

	function ChangeDT( arg ){
		var theForm = document.ForfeitForm;
		if(arg=="vio_ymd"){				theForm.vio_ymd.value = ChangeDate(theForm.vio_ymd.value);
		}else if(arg=="rec_dt"){		theForm.rec_dt.value = ChangeDate(theForm.rec_dt.value);
		}else if(arg=="paid_end_dt"){	theForm.paid_end_dt.value = ChangeDate(theForm.paid_end_dt.value);
		}else if(arg=="proxy_dt"){		theForm.proxy_dt.value = ChangeDate(theForm.proxy_dt.value);
		}else if(arg=="dem_dt"){		theForm.dem_dt.value = ChangeDate(theForm.dem_dt.value);
		}else if(arg=="coll_dt"){		theForm.coll_dt.value = ChangeDate(theForm.coll_dt.value);
		}else if(arg=="rec_plan_dt"){	theForm.rec_plan_dt.value = ChangeDate(theForm.rec_plan_dt.value);
		}
	}
	
	function CheckField(){
		var theForm = document.ForfeitForm;
		if(theForm.rent_l_cd.value==""){	alert("계약번호를 입력하십시요");	theForm.rent_l_cd.focus();	return false;	}
		if(theForm.firm_nm.value==""){		alert("상호를 입력하십시요");		theForm.firm_nm.focus();	return false;	}
		if(theForm.car_no.value==""){		alert("차량번호를 입력하십시요");	theForm.car_no.focus();		return false;	}
		if(theForm.vio_ymd.value==""){		alert("위반일자를 입력하십시요");	theForm.vio_ymd.focus();	return false;	}
		if(theForm.vio_s.value==""){		alert("위반시간을 입력하십시요");	theForm.vio_s.focus();		return false;	}
		if(theForm.vio_m.value==""){		alert("위반시간를 입력하십시요");	theForm.vio_m.focus();		return false;	}
		if(theForm.vio_pla.value==""){		alert("위반장소를 입력하십시요");	theForm.vio_pla.focus();	return false;	}
		if(theForm.vio_cont.value==""){		alert("위반내용를 입력하십시요");	theForm.vio_cont.focus();	return false;	}
		if(theForm.pol_sta.value==""){		alert("경찰서를 입력하십시요");		theForm.pol_sta.focus();	return false;	}
		if(theForm.paid_no.value==""){		alert("납부고지서번호를 입력하십시요");	theForm.paid_no.focus();return false;	}
		if(theForm.rec_dt.value==""){		alert("영수일자를 입력하십시요");	theForm.rec_dt.focus();		return false;	}
		if(theForm.paid_end_dt.value==""){	alert("납부기한 입력하십시요");		theForm.paid_end_dt.focus();return false;	}
		if(theForm.paid_amt.value==""){		alert("납부금액을 입력하십시요");	theForm.paid_amt.focus();	return false;	}
		return true;
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String st = request.getParameter("st")==null?"2":request.getParameter("st");
	String f_st = request.getParameter("f_st")==null?"1":request.getParameter("f_st");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	rl_bean = fdb.getCarRent( car_mng_id, rent_mng_id, rent_l_cd );
	
	String user_id = "";
	String user_nm = "";
	
	LoginBean login = LoginBean.getInstance();
	user_id = login.getCookieValue(request, "acar_id");
	user_nm = login.getAcarName(user_id);
%>
<table border=0 cellspacing=0 cellpadding=0 width=800>
	<tr>
    	<td ><font color="navy">계약관리 -> 과태금/범칙금 -> </font><font color="red">수정</font></td>
    </tr>
	<form action="./forfeit_null_ui.jsp" name="ForfeitForm" method="POST" >
		<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
		<input type="hidden" name="st" value="<%=st%>">
		<input type="hidden" name="f_st" value="<%=f_st%>">
		<input type="hidden" name="gubun" value="<%=gubun%>">
		<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
		<input type="hidden" name="s_year" value="<%=s_year%>">
		<input type="hidden" name="user_id" value="<%=user_id%>">		
        <input type="hidden" name="cmd" value="">
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=800>
            	<tr>
            		<td class=title>계약번호</td>
            		<td align="center"><input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>"><input type="text" name="rent_l_cd" size="18" value="<%=rent_l_cd%>" class=text onKeydown="CarRentSearch('rent_l_cd')"></td>
            		<td class=title>계약자</td>
            		<td align="center"><input type="text" name="client_nm" size="18" value="<%=rl_bean.getClient_nm()%>" class=white readonly></td>
            		<td class=title>상호</td>
            		<td align="center" colspan="3"><input type="text" name="firm_nm" size="52" value="<%=rl_bean.getFirm_nm()%>" class=text onKeydown="CarRentSearch('firm_nm')"></td>
            	</tr>
            	<tr>
            		<td width="80" class=title>차량번호</td>
            		<td width="120" align="center"><input type="hidden" name="car_mng_id" value="<%=car_mng_id%>"><input type="text" name="car_no" size="18" value="<%=rl_bean.getCar_no()%>" class=text onKeydown="CarRentSearch('car_no')"></td>
            		<td width="80" class=title>차종</td>
            		<td width="120" align="left"><input type="text" name="car_name" size="18" value="<%=rl_bean.getCar_nm()%>" class=whitetext readonly></td>
            		<td width="80" class=title>대여방식</td>
            		<td width="120" align="left"><input type="text" name="rent_way_nm" size="18" value="<%=rl_bean.getRent_way_nm()%>" class=whitetext readonly></td>
            		<td width="80" class=title>대여기간</td>
            		<td width="120" align="left"><input type="text" name="con_mon" size="2" value="<%=rl_bean.getCon_mon()%>" class=whitetext readonly> 개월</td>            						
            	</tr>
            	<tr>
            		<td class=title>연락처</td>
            		<td align="left"><input type="text" name="o_tel" size="18" value="<%=rl_bean.getO_tel()%>" class=whitetext readonly></td>
            		<td class=title>팩스</td>
            		<td align="left"><input type="text" name="o_fax" size="18" value="<%=rl_bean.getFax()%>" class=whitetext readonly></td>
            		<td class=title>대여개시일</td>
            		<td align="left" colspan="3"><input type="text" name="rent_start_dt" size="18" value="<%=rl_bean.getRent_start_dt()%>" class=whitetext readonly></td>
            	</tr>
            </table>
        </td>
    </tr>
	<tr>
        <td>
            
        <table border=0 cellspacing=1 width="800">
          <tr> 
            <td>< 위반사항 ></td>
            <td width="300" align="right">
			  최종수정자:<input type="text" name="update_id" size="6" value="" class=white readonly>
              최종수정일:<input type="text" name="update_dt" size="10" value="" class=white readonly>
            </td>
          </tr>
        </table>
        </td>
    </tr>
    <tr>
        <td class=line>
            
        <table border=0 cellspacing=1 width=800>
          <tr> 
            <td class=title>구분</td>
            <td> 
              <select name="fine_st">
                <option value="1" selected>과태료</option>
                <option value="2">범칙금</option>
              </select>
            </td>
            <td class=title>통화자(담당자)</td>
            <td colspan=7> 
              <input type="hidden" name="seq_no" value="">
              <input type="text" name="call_nm" value="" size="31" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title>위반일시</td>
            <td> 
              <input type="text" name="vio_ymd" value="" size="11" maxlength=10 class=text onBlur="javascript:ChangeDT('vio_ymd')">
              <input type="text" name="vio_s" value="" size="2" maxlength=2 class=text>
              시 
              <input type="text" name="vio_m" value="" size="2" maxlength=2 class=text>
              분 
              <input type="hidden" name="vio_dt" value="">
            </td>
            <td class=title>전화번호</td>
            <td colspan=3> 
              <input type="text" name="tel" value="" size="31" class=text>
            </td>
            <td class=title>팩스</td>
            <td colspan=3> 
              <input type="text" name="fax" value="" size="31" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title>위반장소</td>
            <td colspan=9> 
              <input type="text" name="vio_pla" value="" size="100" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title>위반내용</td>
            <td colspan=9> 
              <input type="text" name="vio_cont" value="" size="100" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title>경찰서</td>
            <td> 
              <input type="text" name="pol_sta" value="" size="24" class=text>
            </td>
            <td class=title>고지서번호</td>
            <td colspan=3> 
              <input type="text" name="paid_no" value="" size="31" class=text onBlur="javascript:PaidNoCheck()">
            </td>
            <td class=title>과실구분</td>
            <td colspan=3> 
              <select name="fault_st">
                <option value="1" selected>고객과실</option>
                <option value="2">업무상과실</option>
              </select>
              <input type="text" name="fault_nm" value="" size="10" maxlength=10 class=text onBlur="javascript:this.value=parseDecimal(this.value)">
            </td>
          </tr>
          <tr> 
            <td width="100" class=title>납부구분</td>
            <td width="155"> 
              <select name="paid_st">
                <option value="2" selected>고객납입</option>
                <option value="1">미정</option>
                <option value="3">회사대납</option>
              </select>
            </td>
            <td width="95" class=title>고지서접수일</td>
            <td width="70"> 
              <input type="text" name="rec_dt" value="" size="11" maxlength=10 class=text onBlur="javascript:ChangeDT('rec_dt')">
            </td>
            <td width="55" class=title>납부기한</td>
            <td width="70"> 
              <input type="text" name="paid_end_dt" value="" size="11" maxlength=10 class=text onBlur="javascript:ChangeDT('paid_end_dt')">
            </td>
            <td width="60" class=title>납부금액</td>
            <td width="70"> 
              <input type="hidden" name="h_paid_amt" value="">
              <input type="text" name="paid_amt" value="" size="10" maxlength=6 class=text onBlur="javascript:this.value=parseDecimal(this.value)">
            </td>
            <td width="55" class=title>대납일자</td>
            <td width="70"> 
              <input type="text" name="proxy_dt" value="" size="11" maxlength=10 class=text onBlur="javascript:ChangeDT('proxy_dt')">
            </td>
          </tr>
          <tr> 
            <td class=title>청구일자</td>
            <td> 
              <input type="text" name="dem_dt" value="" size="11" maxlength=10 class=text onBlur="javascript:ChangeDT('dem_dt')">
            </td>
            <td class=title>입금예정일</td>
            <td colspan=3> 
              <input type="text" name="rec_plan_dt" value="" size="11" maxlength=10 class=text onBlur="javascript:ChangeDT('rec_plan_dt')">
            </td>
            <td class=title>수금일자</td>
            <td colspan=3> 
              <input type="text" name="coll_dt" value="" size="11" maxlength=10 class=text onBlur="javascript:ChangeDT('coll_dt')">
            </td>
          </tr>
          <tr> 
            <td class=title>특이사항</td>
            <td colspan=9> 
              <textarea name="note" cols=110 rows=2></textarea>
            </td>
          </tr>
          <tr> 
            <td class=title>면제여부</td>
            <td> 
              <input type='checkbox' name='no_paid_yn' value="Y">
            </td>
            <td width="95" class=title>면제사유</td>
            <td colspan="7"> 
              <input type="text" name="no_paid_cau" value="" size="70" class=text>
            </td>
          </tr>
        </table>
        </td>
    </tr>
    </form>
    <tr>
        <td>
            <table border=0 cellspacing=1 width="800">
            	<tr>
            		<td align=right><a href="javascript:ForfeitReg()"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;&nbsp;<a href="javascript:ForfeitUp()"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;&nbsp;<a href="javascript:ForfeitDel()"><img src="/images/del.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;&nbsp;<a href="javascript:ClearM()">지우기</a></td>
            	</tr>
            </table>
        </td>
    </tr>
</table>
<form action="./paid_no_check.jsp" name="PaidNoCheckForm" method="post">
<input type="hidden" name="h_paid_no" value="">
</form>
</body>
</html>