<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.bank_mng.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="bl_db" scope="page" class="acar.bank_mng.BankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function cal_total()
	{
		var fm = document.form1;
		var tm = fm.alt_prn_amt.length;
		var prn = 0;
		var int = 0;
		var amt = 0;
		for(var i = 0 ; i < tm ; i ++)
		{	
			prn += toInt(parseDigit(fm.alt_prn_amt[i].value));
			int += toInt(parseDigit(fm.alt_int_amt[i].value));
			amt += toInt(parseDigit(fm.alt_amt[i].value));
		}
		parent.form1.tot_alt_prn.value = parseDecimal(prn);
		parent.form1.tot_alt_int.value = parseDecimal(int);
		parent.form1.tot_alt_amt.value = parseDecimal(amt);
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	BankLendBean bl = bl_db.getBankLend(lend_id);
	
	Vector scds = bl_db.getBankScds(lend_id);
	int scd_size = scds.size();
%>
<form name='form1' method='post'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='scd_size' value='<%=scd_size%>'>
<input type='hidden' name='cont_amt' value='<%=bl.getCont_amt()%>'>
<input type='hidden' name='fst_pay_amt' value=''>
<input type='hidden' name='fst_pay_dt' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td class='line'>
		 	<table border="0" cellspacing="1" cellpadding="0" width=800>
<%
	if(scd_size > 0)
	{
		for(int i = 0 ; i < scd_size ; i++)
		{
			BankScdBean scd = (BankScdBean)scds.elementAt(i);
%>
				<tr>
					<td width='40' align='center'><input type='text' name='alt_tm' value='<%=scd.getAlt_tm()%>' size='2' class='white' readonly></td>
					<td width='90' align='center'><input type='text' name='alt_est_dt' size='11' value='<%=scd.getAlt_est_dt()%>' class='white' readonly></td>
					<td width='120' align='right'><input type='text' name='alt_prn_amt' size='10' value='<%=Util.parseDecimal(scd.getAlt_prn_amt())%>' class='whitenum' readonly>원&nbsp;</td>
					<td width='120' align='right'><input type='text' name='alt_int_amt' size='10' value='<%=Util.parseDecimal(scd.getAlt_int_amt())%>' maxlength='10' class='whitenum' readonly>원&nbsp;</td>
					<td width='120' align='right'><input type='text' name='alt_amt' size='10' maxlength='11' value='<%=Util.parseDecimal(scd.getAlt_prn_amt()+scd.getAlt_int_amt())%>' class='whitenum' readonly>원&nbsp;</td>
					<td width='150' align='right'>
              <input type='text' name='alt_rest' size='11' value='<%=Util.parseDecimal(scd.getAlt_rest())%>' class='whitenum' readonly>
              원&nbsp;</td>
					<td width='60' align='center'><input type='text' name='pay_yn' size='2' <%if(scd.getPay_yn().equals("0")){%>value='N'<%}else{%>value='Y'<%}%> class='white' readonly>
					<%if(!scd.getCls_rtn_dt().equals("")){%>(중도상환)<%}%></td>
<%
			if(scd.getPay_yn().equals("1"))
			{
%>					<td width='100' align='center'><%=scd.getPay_dt()%></td>
<%			}else{
%>					<td width='100' align='center'>-</td>
<%			}
%>
				</tr>
<%		}
	}
	else
	{
%>				<tr>
					<td align='center'>은행대출관리 화면에서 할부횟수(상환개월)를 먼저 입력한 후 스케줄을 작성하십시오</td>
				</tr>
<%
	}
%>
			</table>
		</td>
	</tr>
</table>
</form>
<script language='javascript'>
<!--
cal_total();
-->
</script>
<iframe src="about:blank" name="i_in_no" width="200" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>
</body>
</html>
