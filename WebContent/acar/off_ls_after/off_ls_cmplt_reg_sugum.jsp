<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.user_mng.*"%>
<%@ page import="acar.offls_sui.*,  acar.asset.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="olsBean" class="acar.offls_sui.Offls_suiBean" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="sscBean" class="acar.offls_sui.Scd_sui_contBean" scope="page"/>
<jsp:useBean id="ssjBean" class="acar.offls_sui.Scd_sui_janBean" scope="page"/>
<jsp:useBean id="se_bean" class="acar.offls_actn.Offls_sui_etcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	
	Scd_sui_contBean[] sscbs = olsD.getScd_sui_cont(car_mng_id);
	Scd_sui_janBean[] ssjbs = olsD.getScd_sui_jan(car_mng_id);
	
	int auc_chk = olsD.getAuctionChk(car_mng_id);
	
	AssetDatabase as_db = AssetDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	se_bean = as_db.getInfoComm(car_mng_id);
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

	//스캔등록
function scan_reg(){
		window.open("/acar/off_ls_cmplt/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=ck_acar_id%>&car_mng_id=<%=car_mng_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}
	//스캔삭제
function scan_del(){
		var theForm = document.form1;
		if(!confirm('삭제하시겠습니까?')){		return;	}
		theForm.target = "i_no"
		theForm.action = "/acar/off_ls_cmplt/del_scan_a.jsp";
		theForm.submit();
}
		//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/sui/"+theURL;
		window.open(theURL,winName,features);
}

function update_sui_etc(iuc)
{
	var fm = document.form1;
	
	if(!confirm('수정 하시겠습니까?')){ return; }

	fm.action = "/acar/off_ls_sui/off_ls_sui_etc_reg_a.jsp";
	fm.target = "i_no";
	fm.submit();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" action="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
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
                      <input type='text' name='c_cont_amt' value='<%=Util.parseDecimal(sscbs[i].getCont_amt())%>' class='num'  size='12' >
                      원&nbsp;</td>
                    <td align='center'> 
                      <input type='text' name='c_est_dt' value='<%=AddUtil.ChangeDate2(sscbs[i].getEst_dt())%>' size='11' class='text' maxlength='11' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align='center'> 
                      <input type='text' name='c_pay_dt' value='<%=AddUtil.ChangeDate2(sscbs[i].getPay_dt())%>' size='11' class='text' maxlength='11' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align='right'> 
                      <input type='text' name='c_pay_amt' value='<%=Util.parseDecimal(sscbs[i].getPay_amt())%>' size='10' class='num' maxlength='10' value='' onBlur='javascript:this.value=parseDecimal(this.value)'>
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
        <td class="line" width="100%"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='15%'  class='title'> 회차 </td>
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
                      <input type='text' name='j_jan_amt' value='<%=Util.parseDecimal(ssjbs[i].getJan_amt())%>' class='num'  size='10' >
                      원&nbsp;</td>
                    <td align='center'> 
                      <input type='text' name='j_est_dt' value='<%=AddUtil.ChangeDate2(ssjbs[i].getEst_dt())%>' size='11' class='text' maxlength='11' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align='center'> 
                      <input type='text' name='j_pay_dt' value='<%=AddUtil.ChangeDate2(ssjbs[i].getPay_dt())%>' size='11' class='text' maxlength='11' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align='right'> 
                      <input type='text' name='j_pay_amt' value='<%=Util.parseDecimal(ssjbs[i].getPay_amt())%>' size='10' class='num' maxlength='10' value='' onBlur='javascript:this.value=parseDecimal(this.value)'>
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
    <tr>
        <td></td>
    </tr>
    
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>매각 수수료</span></td>
    </tr>
    <tR>
        <td class=line2></td>
    </tr>
    
  	<%if(auc_chk > 0){%>  
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=32%> 세금계산서발행일</td>
                    <td colspan="4" width=68%>&nbsp; <input type='text' name='comm_date' value="<%=AddUtil.ChangeDate2(se_bean.getComm_date())%>" size='11' class='text' maxlength='11' onBlur='javascript:this.value=ChangeDate(this.value);'>
        			</td>
                </tr>
                <tr> 
                    <td class='title'  width=32%> 위탁출품자낙출수수료</td>
                    <td class='title' width=17%>공급가</td>
                    <td width=17% align='left'>&nbsp; <input type='text' name='comm1_sup' value="<%=Util.parseDecimal(se_bean.getComm1_sup())%>"  size='13' class='num' maxlength='13' onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v1_amt();'>
                    </td>
                    <td class='title' width=17%>세액</td>
                    <td width=17%>&nbsp; <input type='text' size='13' name='comm1_vat' value="<%=Util.parseDecimal(se_bean.getComm1_vat())%>"  class='num' maxlength='13' onBlur='javascript:this.value=parseDecimal(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'> 재출품수수료</td>
                    <td class='title'>공급가</td>
                    <td align='left'>&nbsp; <input type='text' name='comm2_sup' value="<%=Util.parseDecimal(se_bean.getComm2_sup())%>" size='13' class='num' maxlength='13' onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v2_amt();'>
                    </td>
                    <td class='title'>세액</td>
                    <td>&nbsp; <input type='text' size='13' name='comm2_vat' value="<%=Util.parseDecimal(se_bean.getComm2_vat())%>"   class='num' maxlength='13' onBlur='javascript:this.value=parseDecimal(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'> 위탁출품자반입탁송대금입금</td>
                    <td class='title'>공급가</td>
                    <td align='left'>&nbsp; <input type='text' name='comm3_sup' value="<%=Util.parseDecimal(se_bean.getComm3_sup())%>" size='13' class='num' maxlength='13' onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v3_amt();'>
                    </td>
                    <td class='title'>세액</td>
                    <td>&nbsp; <input type='text' size='13' name='comm3_vat' value="<%=Util.parseDecimal(se_bean.getComm3_vat())%>"  class='num' maxlength='13' onBlur='javascript:this.value=parseDecimal(this.value)'>
                    </td>
                </tr>
                <tr>                 
                 	 <td class="title">증빙스캔</td>
                     <td colspan=4>&nbsp; <%if(se_bean.getCommfile().equals("")){%><a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a><%}else{%><a href="javascript:MM_openBrWindow('<%= se_bean.getCommfile() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%= se_bean.getCommfile() %></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:scan_del()"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a><%}%></td>
                  	      
			   </tr>
            </table>
        </td>  
    </tr>	
    <tr>
        <td align='right'>
		<% if ( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("매입옵션관리자",ck_acar_id)  || nm_db.getWorkAuthUser("세금계산서담당자",ck_acar_id)  || nm_db.getWorkAuthUser("해지관리자",ck_acar_id)   ) { %>    
        <a href="javascript:update_sui_etc('u')"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
		<% } %>      
        </td>
    </tr>	
<% } %>   	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
