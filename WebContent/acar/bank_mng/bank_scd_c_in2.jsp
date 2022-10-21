<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.bank_mng.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="bl_db" scope="page" class="acar.bank_mng.BankLendDatabase"/>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq = request.getParameter("rtn_seq")==null?"1":request.getParameter("rtn_seq");

	BankLendBean bl = abl_db.getBankLendScd(lend_id, rtn_seq);
	Vector scds = abl_db.getBankScds(lend_id, rtn_seq);
	int scd_size = scds.size();
	
	
%>

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
	
	//중도해지
	function view_cls_list(cls_rtn_dt){	
		var fm = document.form1;
		var auth_rw = '1';
		var lend_id = fm.lend_id.value;
		var rtn_seq = fm.rtn_seq.value;
		var url = "";
		url = "../cls_bank/cls_c.jsp?auth_rw="+auth_rw+"&lend_id="+lend_id+"&rtn_seq="+rtn_seq+"&cls_rtn_dt="+cls_rtn_dt;
		window.open(url, "CLS_BANK", "left=100, top=180, width=940, height=550, status=yes, scrollbars=yes");
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' method='post'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>
<input type='hidden' name='scd_size' value='<%=scd_size%>'>
<input type='hidden' name='cont_amt' value='<%//=bl.getCont_amt()%>'>
<input type='hidden' name='fst_pay_amt' value=''>
<input type='hidden' name='fst_pay_dt' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
		 	<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%	if(scd_size > 0){
		for(int i = 0 ; i < scd_size ; i++){
			BankScdBean scd = (BankScdBean)scds.elementAt(i);
%>
				<tr>
					<td width=5% align='center'><input type='text' name='alt_tm' value='<%=scd.getAlt_tm()%>' size='2' class='white' readonly></td>
					<td width=10% align='center'><input type='text' name='alt_est_dt' size='11' value='<%=scd.getAlt_est_dt()%>' class='white' readonly></td>
					<td width=15% align='right'><input type='text' name='alt_prn_amt' size='10' value='<%=AddUtil.parseDecimal(scd.getAlt_prn_amt())%>' class='whitenum' readonly>원&nbsp;</td>
					<td width=15% align='right'><input type='text' name='alt_int_amt' size='10' value='<%=AddUtil.parseDecimal(scd.getAlt_int_amt())%>' maxlength='10' class='whitenum' readonly>원&nbsp;</td>
					<td width=15% align='right'><input type='text' name='alt_amt' size='10' maxlength='11' value='<%=AddUtil.parseDecimal(scd.getAlt_prn_amt()+scd.getAlt_int_amt())%>' class='whitenum' readonly>원&nbsp;</td>
					<td width=18% align='right'><input type='text' name='alt_rest' size='10' value='<%=AddUtil.parseDecimal(scd.getAlt_rest())%>' class='whitenum' readonly>원&nbsp;</td>
					<td width=10% align='center'><input type='text' name='pay_yn' size='2' <%if(scd.getPay_yn().equals("0")){%>value='N'<%}else{%>value='Y'<%}%> class='white' readonly>
					<%if(!scd.getCls_rtn_dt().equals("")){%><a href="javascript:view_cls_list('<%=scd.getCls_rtn_dt()%>');" title='중도상환 보기'>(중도상환)</a><%}%>
					</td>
					<%if(scd.getPay_yn().equals("1")){%>	
					<td width=10% align='center'><%=scd.getPay_dt()%></td>
					<%}else{%>				
					<td width=12% align='center'>-</td>
					<%}%>
				</tr>
<%		}
	}else{
%>				<tr>
					<td align='center'>은행대출관리 화면에서 할부횟수(상환개월)를 먼저 입력한 후 스케줄을 작성하십시오</td>
				</tr>
<%	}%>
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
