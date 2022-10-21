<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_sui.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="olsBean" class="acar.offls_sui.Offls_suiBean" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="sscBean" class="acar.offls_sui.Scd_sui_contBean" scope="page"/>
<jsp:useBean id="ssjBean" class="acar.offls_sui.Scd_sui_janBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	
	Scd_sui_contBean[] sscbs = olsD.getScd_sui_cont(car_mng_id);
	Scd_sui_janBean[] ssjbs = olsD.getScd_sui_jan(car_mng_id);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function cont_sugum(iuc)
{
	var fm = document.form1;
	if(iuc=="i"){
		if(!confirm('입금 하시겠습니까?')){ return; }
	}else if(iuc=="u"){
		if(!confirm('수정 하시겠습니까?')){ return; }
	}else if(iuc=="c"){
		if(!confirm('취소 하시겠습니까?')){ return; }
	}
	fm.gubun.value = iuc;
	fm.action = "/acar/off_ls_sui/off_ls_sui_reg_cont_sugum.jsp";
	fm.target = "i_no";
	fm.submit();
}
function jan_sugum(iuc)
{
	var fm = document.form1;
	if(iuc=="i"){
		if(!confirm('입금 하시겠습니까?')){ return; }
	}else if(iuc=="u"){
		if(!confirm('수정 하시겠습니까?')){ return; }
	}else if(iuc=="c"){
		if(!confirm('취소 하시겠습니까?')){ return; }
	}
	fm.gubun.value = iuc;
	fm.action = "/acar/off_ls_sui/off_ls_sui_reg_jan_sugum.jsp";
	fm.target = "i_no";
	fm.submit();
}
-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" action="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>매각대금 입금현황</span></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;<span class=style3><font color=red>1. 계약금</font></span></td>
    </tr>
    <tR>
        <td class=line2></td>
    </tr>
    <tr>
	<%if(sscbs.length > 0){%>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td width='15%'  class='title'> 회차 </td>
                <td width='17%' class='title'> 계약금</td>
                <td width='17%' class='title'> 약정일 </td>
                <td width='17%' class='title'> 입금일 </td>
                <td width='17%' class='title'> 입금액 </td>
                <td width='17%' class='title'>&nbsp; </td>
              </tr>
     	  	<%for(int i=0; i<sscbs.length; i++){%>
              <tr> 
                <td align='center'> 
                  <input type='text' name='c_tm' value='<%=sscbs[i].getTm()%>' size='2' class='whitenum' readonly>
                  회</td>
                <td align='right'> 
                  <input type='text' name='c_cont_amt' value='<%=Util.parseDecimal(sscbs[i].getCont_amt())%>' class='num'  size='10' onBlur='javascript:this.value=parseDecimal(this.value)'>
                  원&nbsp;</td>
                <td align='center'> 
                  <input type='text' name='c_est_dt' value='<%=AddUtil.ChangeDate2(sscbs[i].getEst_dt())%>' size='11' class='text' maxlength='11' onBlur='javascript:this.value=ChangeDate(this.value);'>
                </td>
                <td align='center'> 
                  <input type='text' name='c_pay_dt' value='<%=AddUtil.ChangeDate2(sscbs[i].getPay_dt())%>' size='11' class='text' maxlength='11' onBlur='javascript:this.value=ChangeDate(this.value);'>
                </td>
                <td align='right'>
                  <input type='text' name='c_pay_amt' value='<%=Util.parseDecimal(sscbs[i].getPay_amt())%>' size='10' class='num' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value)'>
                  원&nbsp;</td>
                <td align='center'> <%if(i==sscbs.length-1){%><a href="javascript:cont_sugum('i')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_ig.gif border=0 align=absmiddle></a>&nbsp;
        			<a href="javascript:cont_sugum('u')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>&nbsp;
        			<a href="javascript:cont_sugum('c')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_cancel.gif border=0 align=absmiddle></a><%}%></td>
              </tr>
    		<%}%>
            </table>
      </td>
	  <%}else{%>
	  <td>&nbsp;&nbsp;없음.</td>
	  <%}%>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;<span class=style3><font color=red>2. 잔금</font></span></td>
    </tr>
    <tR>
        <td class=line2></td>
    </tr>
    <tr> 
	<%if(ssjbs.length > 0){%>
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='15%' class='title'> 회차 </td>
            <td width='17%' class='title'> 잔금</td>
            <td width='17%' class='title'> 약정일 </td>
            <td width='17%' class='title'> 입금일 </td>
            <td width='17%' class='title'> 입금액 </td>
            <td width='17%' class='title'>&nbsp; </td>
          </tr>
		<%for(int i=0; i<ssjbs.length; i++){%> 
          <tr> 
            <td align='center'> 
              <input type='text' name='j_tm' value='<%=ssjbs[i].getTm()%>' size='2' class='whitenum' readonly>
              회</td>
            <td align='right'> 
              <input type='text' name='j_jan_amt' value='<%=Util.parseDecimal(ssjbs[i].getJan_amt())%>' class='num'  size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
              원&nbsp;</td>
            <td align='center'> 
              <input type='text' name='j_est_dt' value='<%=AddUtil.ChangeDate2(ssjbs[i].getEst_dt())%>' size='11' class='text' maxlength='11' onBlur='javascript:this.value=ChangeDate(this.value)'>
            </td>
            <td align='center'> 
              <input type='text' name='j_pay_dt' value='<%=AddUtil.ChangeDate2(ssjbs[i].getPay_dt())%>' size='11' class='text' maxlength='11' onBlur='javascript:this.value=ChangeDate(this.value);'>
            </td>
            <td align='right'> 
              <input type='text' name='j_pay_amt' value='<%=Util.parseDecimal(ssjbs[i].getPay_amt())%>' size='10' class='num' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value)'>
              원&nbsp;</td>
           <td align='center'><%if(i==ssjbs.length-1){%><a href="javascript:jan_sugum('i')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_ig.gif border=0 align=absmiddle></a>&nbsp;
        			<a href="javascript:jan_sugum('u')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>&nbsp;
        			<a href="javascript:jan_sugum('c')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_cancel.gif border=0 align=absmiddle></a><%}%></td>
          </tr>
		<%}%>
        </table>
      </td>
	  <%}else{%>
	  <td>&nbsp;&nbsp;없음.</td>
	  <%}%>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
