<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String b_dt 	= request.getParameter("b_dt")==null?"":request.getParameter("b_dt");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String bill_yn 	= request.getParameter("bill_yn")==null?"":request.getParameter("bill_yn");
	
	//건별 대여료 스케줄 통계
	Hashtable fee_stat = af_db.getFeeScdStatNew(m_id, l_cd, b_dt, mode, bill_yn);

%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search()
	{
		var fm = document.form1;
		if(fm.b_dt.value == ''){ alert('납부예정일자를 선택하십시오.'); return;}
		fm.action='fee_scd_account_redly_sc.jsp';
		fm.target = '_self';
		fm.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function print_view(){
		var fm = document.form1;
		if(toInt(fm.s_s.value) >0){ 
			window.open("about:blank", "RedlyAccountPrint", "left=150, top=20, width=700, height=700, scrollbars=yes");
			fm.action = "fee_scd_print.jsp";
			fm.target = "RedlyAccountPrint";
			fm.submit();			
		}else{
			alert('미수연체료가 없습니다.');
		}
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' target='' method="post">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='bill_yn' value='<%=bill_yn%>'>
<input type='hidden' name='s_n' value='<%=fee_stat.get("DT")%>'>
<input type='hidden' name='s_v' value='<%=fee_stat.get("DT2")%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>연체료 미래일자 계산</span></span></td>
                    <td class=bar style='text-align:right'>&nbsp;</td>
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
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width=30%>납부예정일자</td>
                    <td>&nbsp;
                        <input type='text' name='b_dt' value='<%=AddUtil.ChangeDate2(b_dt)%>' maxlength='10' size='12' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);' onKeyDown='javascript:enter()'>
                        &nbsp;&nbsp;
                        <input type="button" class="button" value="계산하기" onclick="javascript:search();">
                    </td>
                </tr>
                <tr>
                    <td class='title'>미수연체료</td>
                    <td>&nbsp;
                        <input type='text' name='s_s' size='12' class='whitenum' value='' readonly>원
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
        	<a href="javascript:print_view();" title='기본' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a>
        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        	<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
       	</td>
    </tr>
</table>
<script language='javascript'>
<!--
	var fm = document.form1;	
	fm.s_s.value = parseDecimal(toInt(parseDigit(fm.s_n.value)) - toInt(parseDigit(fm.s_v.value)));
//-->
</script>
</body>
</html>


