<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.bank_mng.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="bl_db" scope="page" class="acar.bank_mng.BankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_modify()
	{
		location='/acar/bank_mng/bank_scd_u.jsp?lend_id='+document.form1.lend_id.value;
	}
	function go_list()
	{
		location='/acar/bank_mng/bank_frame_s.jsp?auth_rw='+document.form1.auth_rw.value;
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	BankLendBean bl = bl_db.getBankLend(lend_id);
	CommonDataBase c_db = CommonDataBase.getInstance();
	int cont_term = bl.getCont_term().equals("")?0:Integer.parseInt(bl.getCont_term());
%>
<body>
<form name='form1' method="POST">
<input type='hidden' name='cont_term' value='<%=cont_term%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		
      <td> <font color="navy">재무관리 -> </font><font color="navy">은행대출관리 </font>-> 
        <font color="red">할부금 상환 스케줄</font> </td>
	</tr>
	<tr>
		<td align='right'>
<%
if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))	{
%>		
			<a href='javascript:go_modify()' onMouseOver="window.status=''; return true">수정화면</a>
<%	}
%>			&nbsp;&nbsp;<a href='javascript:go_list()' onMouseOver="window.status=''; return true">리스트로</a>
		</td>
	</tr>
	<tr>
	<td class='line'>
		 <table border="0" cellspacing="1" cellpadding="1" width=800>
		 	<tr>
		 		<td width='70' class='title'>금융사명</td>
		 		<td width='90'><%=c_db.getNameById(bl.getCont_bn(), "BANK")%></td>
		 		<td width='70' class='title'>대출번호</td>
		 		<td width='90'><%=bl.getLend_no()%></td>
		 		<td width='70' class='title'> 계약일	</td>
				<td width='90'><%=bl.getCont_dt()%></td>
				<td width='70' class='title'> 할부횟수 </td>
		 		<td width='90'><%=bl.getCont_term()%>회 </td>
		 		<td width='70' class='title'> 결재방법 </td>
		 		<td width='90'><%if(bl.getRtn_way().equals("1")){%>자동이체
		 			<%}else if(bl.getRtn_way().equals("2")){%>지로
		 			<%}else if(bl.getRtn_way().equals("3")){%>기타 <%}%></td>
		 	</tr>
		 	<tr>
		 		<td class='title'> 대출금액 </td>
		 		<td><%=AddUtil.parseDecimalLong(bl.getCont_amt())%>원</td>
				<td class='title'> 이율 </td>
		 		<td><%=bl.getLend_int()%> </td>
		 		<td class='title'> 월상환금액 </td>
		 		<td><%=Util.parseDecimal(bl.getAlt_amt())%>원</td>
				<td class='title'> 할부수수료 </td>
		 		<td><%=Util.parseDecimal(bl.getCharge_amt())%>원</td>
				
            <td class='title'> 약정일자 
            <td><%=bl.getRtn_est_dt()%>일</td>	
			</tr>
			<tr>
				
            <td class='title'> 공증료 
            <td><%=Util.parseDecimal(bl.getNtrl_fee())%>원</td>
				
            <td class='title'> 인지대 
            <td><%=Util.parseDecimal(bl.getStp_fee())%>원</td>
				<td class='title'>1회차결재일</td>
				<td>&nbsp;<%=bl.getFst_pay_dt()%></td>
				<td colspan='2' class='title'>1회차상환금액 </td>
				<td colspan='2'>&nbsp;<%=Util.parseDecimal(bl.getFst_pay_amt())%>원&nbsp;</td>
			</tr>
		</table>
	</td>
	</tr>
</table>
<br/>
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td><<할부금스케줄>></td>
	</tr>
	<tr>	
		<td class='line' width='800'>
			<table border='0' cellspacing='1' cellpadding='1' width='800'>
				<tr>
					<td width='40' class='title'>회차</td>
					<td width='90' class='title'>약정일</td>
					<td width='120' class='title'>할부원금</td>
					<td width='120' class='title'>이자</td>
					<td width='120' class='title'>할부금</td>
					<td width='150' class='title'>할부금잔액</td>
					<td width='60' class='title'>결재여부	</td>
					<td width='100' class='title'>결재일</td>							
				</tr>
			</table>
		</td>
		<td width='20'></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="/acar/bank_mng/bank_scd_c_in.jsp?lend_id=<%=lend_id%>" name="i_in" width="820" height="350" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>							
		</td>
	</tr>
	<tr>
		<td class='line' width='800'>
			<table border="0" cellspacing="1" cellpadding="0" width=800>
				<tr>
					<td width='40' class='title'>합계 </td>
					<td width='90'>&nbsp;</td>
					<td width='120' align='right'>
              <input type='text' name='tot_alt_prn' size='11' value='' class='whitenum' readonly>
              원&nbsp;</td>
					<td width='120' align='right'><input type='text' name='tot_alt_int' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width='120' align='right'>
              <input type='text' name='tot_alt_amt' size='11' value='' class='whitenum' readonly>
              원&nbsp;</td>
					<td width='310' colspan='3'></td>
				</tr>
			</table>
		</td>
		<td width='20'></td>
	</tr>					
</table>
</form>
</body>
</html>
