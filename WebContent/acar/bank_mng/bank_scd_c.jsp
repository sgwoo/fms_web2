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
		
      <td> <font color="navy">�繫���� -> </font><font color="navy">���������� </font>-> 
        <font color="red">�Һα� ��ȯ ������</font> </td>
	</tr>
	<tr>
		<td align='right'>
<%
if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))	{
%>		
			<a href='javascript:go_modify()' onMouseOver="window.status=''; return true">����ȭ��</a>
<%	}
%>			&nbsp;&nbsp;<a href='javascript:go_list()' onMouseOver="window.status=''; return true">����Ʈ��</a>
		</td>
	</tr>
	<tr>
	<td class='line'>
		 <table border="0" cellspacing="1" cellpadding="1" width=800>
		 	<tr>
		 		<td width='70' class='title'>�������</td>
		 		<td width='90'><%=c_db.getNameById(bl.getCont_bn(), "BANK")%></td>
		 		<td width='70' class='title'>�����ȣ</td>
		 		<td width='90'><%=bl.getLend_no()%></td>
		 		<td width='70' class='title'> �����	</td>
				<td width='90'><%=bl.getCont_dt()%></td>
				<td width='70' class='title'> �Һ�Ƚ�� </td>
		 		<td width='90'><%=bl.getCont_term()%>ȸ </td>
		 		<td width='70' class='title'> ������ </td>
		 		<td width='90'><%if(bl.getRtn_way().equals("1")){%>�ڵ���ü
		 			<%}else if(bl.getRtn_way().equals("2")){%>����
		 			<%}else if(bl.getRtn_way().equals("3")){%>��Ÿ <%}%></td>
		 	</tr>
		 	<tr>
		 		<td class='title'> ����ݾ� </td>
		 		<td><%=AddUtil.parseDecimalLong(bl.getCont_amt())%>��</td>
				<td class='title'> ���� </td>
		 		<td><%=bl.getLend_int()%> </td>
		 		<td class='title'> ����ȯ�ݾ� </td>
		 		<td><%=Util.parseDecimal(bl.getAlt_amt())%>��</td>
				<td class='title'> �Һμ����� </td>
		 		<td><%=Util.parseDecimal(bl.getCharge_amt())%>��</td>
				
            <td class='title'> �������� 
            <td><%=bl.getRtn_est_dt()%>��</td>	
			</tr>
			<tr>
				
            <td class='title'> ������ 
            <td><%=Util.parseDecimal(bl.getNtrl_fee())%>��</td>
				
            <td class='title'> ������ 
            <td><%=Util.parseDecimal(bl.getStp_fee())%>��</td>
				<td class='title'>1ȸ��������</td>
				<td>&nbsp;<%=bl.getFst_pay_dt()%></td>
				<td colspan='2' class='title'>1ȸ����ȯ�ݾ� </td>
				<td colspan='2'>&nbsp;<%=Util.parseDecimal(bl.getFst_pay_amt())%>��&nbsp;</td>
			</tr>
		</table>
	</td>
	</tr>
</table>
<br/>
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td><<�Һαݽ�����>></td>
	</tr>
	<tr>	
		<td class='line' width='800'>
			<table border='0' cellspacing='1' cellpadding='1' width='800'>
				<tr>
					<td width='40' class='title'>ȸ��</td>
					<td width='90' class='title'>������</td>
					<td width='120' class='title'>�Һο���</td>
					<td width='120' class='title'>����</td>
					<td width='120' class='title'>�Һα�</td>
					<td width='150' class='title'>�Һα��ܾ�</td>
					<td width='60' class='title'>���翩��	</td>
					<td width='100' class='title'>������</td>							
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
					<td width='40' class='title'>�հ� </td>
					<td width='90'>&nbsp;</td>
					<td width='120' align='right'>
              <input type='text' name='tot_alt_prn' size='11' value='' class='whitenum' readonly>
              ��&nbsp;</td>
					<td width='120' align='right'><input type='text' name='tot_alt_int' size='10' value='' class='whitenum' readonly>��&nbsp;</td>
					<td width='120' align='right'>
              <input type='text' name='tot_alt_amt' size='11' value='' class='whitenum' readonly>
              ��&nbsp;</td>
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
