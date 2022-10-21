<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.fee.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	function cal_sv_amt()
	{
		var fm = document.form1;
		if(parseDigit(fm.t_fee_amt.value).length > 8)
		{	alert('월대여료를 확인하십시오');	return;	}
		fm.t_fee_amt.value = parseDecimal(fm.t_fee_amt.value);
		fm.t_fee_s_amt.value = parseDecimal(sup_amt(parseDigit(fm.t_fee_amt.value)));
		fm.t_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_amt.value)) - toInt(parseDigit(fm.t_fee_s_amt.value)));
	}
	
	function save()
	{
		var fm = document.form1;
		if(parseDigit(fm.t_fee_amt.value).length > 8)
		{	alert('월대여료를 확인하십시오');	return;	}
		fm.target='i_no';
		fm.submit();
	}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String prv_mon_yn = request.getParameter("prv_mon_yn")==null?"":request.getParameter("prv_mon_yn");//출고전대차기간포함여부
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String fee_tm = request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String fee_amt = request.getParameter("fee_amt")==null?"":request.getParameter("fee_amt");
	String fee_est_dt = request.getParameter("fee_est_dt")==null?"":request.getParameter("fee_est_dt");
	String page_gubun = request.getParameter("page_gubun")==null?"":request.getParameter("page_gubun");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<form name='form1' action='/fms2/con_fee/ext_scd_i_a.jsp' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='h_ext_gubun' value='EXT'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='prv_mon_yn' value='<%=prv_mon_yn%>'>
<input type='hidden' name='page_gubun' value='<%=page_gubun%>'>

<table border="0" cellspacing="0" cellpadding="0" width=380>
	<tr>
		<td>
			<<회차연장>>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=380>
				<tr>
					<td class='line'>
						 <table border="0" cellspacing="1" cellpadding="0" width=380>
							<tr>
								<td width='50' class='title'>회차</td>
								<td width='50'><input type='text' name='h_fee_tm' size='2' value='<%=fee_tm%>' class='white' readonly></td>
								<td width='60' class='title'>공급가</td>
								<td width='80'><input type='text' name='t_fee_s_amt' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
								<td width='60' class='title'>부가세</td>
								<td width='80'><input type='text' name='t_fee_v_amt' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
				</tr>
				<tr>
					<td class='line'>
						 <table border="0" cellspacing="1" cellpadding="0" width=380>
							<tr>
								<td width='100' class='title'>입금예정일</td>
								<td width='100' align='left'>&nbsp;<input type='text' name='t_fee_est_dt' size='11' maxlength='10' value='<%=c_db.getSysDate().substring(0, 8)+fee_est_dt%>' class='text'></td>
								<td width='80' class='title'>월대여료</td>
								<td width='100'>&nbsp;<input type='text' name='t_fee_amt' size='10' value='<%=Util.parseDecimal(fee_amt)%>' class='num' maxlength='10' onBlur='javascript:cal_sv_amt()'>원&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'><a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/add.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
			&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
	</tr>
</table>
</form>
<script language='javascript'>
<!--
	cal_sv_amt();
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>