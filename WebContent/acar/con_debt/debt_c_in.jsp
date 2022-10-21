<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.debt.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id 	= request.getParameter("car_id")==null?"":request.getParameter("car_id");

	ContDebtBean debt = a_db.getContDebt(m_id, l_cd);
	
	Vector debts = d_db.getDebtScd(car_id);
	int debt_size = debts.size();
	
%>
<form name='form1' action='' target='' method="post">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
		 	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
	if(debt_size > 0)
	{
		for(int i = 0 ; i < debt_size ; i++)
		{
			DebtScdBean a_debt = (DebtScdBean)debts.elementAt(i);
			
			if(a_debt.getPay_yn().equals("1"))
			{
%>				<tr>
					<td class='is' width=8%  align='center'><input type='text' name='t_alt_tm' value='<%=a_debt.getAlt_tm()%>' size='2' class='istext' readonly></td>
					<td class='is' width=12%  align='center'><input type='text' name='t_est_dt' size='11' value='<%=a_debt.getAlt_est_dt()%>' class='istext' readonly></td>
					<td class='is' width=14% align='right'><input type='text' name='t_alt_prn' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn())%>' class='isnum' readonly>원&nbsp;</td>
					<td class='is' width=14% align='right'><input type='text' name='t_alt_int' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_int())%>' class='isnum' readonly>원&nbsp;</td>
					<td class='is' width=14% align='right'><input type='text' name='t_alt_amt' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn()+a_debt.getAlt_int())%>' class='isnum' readonly>원&nbsp;</td>
					<td class='is' width=17% align='right'><input type='text' name='t_rest_amt' size='12' value='<%=Util.parseDecimal(a_debt.getAlt_rest())%>' class='isnum' readonly>원&nbsp;</td>
					<td class='is' width=9%  align='center'><input type='text' name='t_pay_yn' size='2' value='Y' class='istext' readonly><%if(!a_debt.getCls_rtn_dt().equals("")){%>(중도상환)<%}%></td>
					<td class='is' width=12% align='center'><input type='text' name='t_pay_dt' size='11' value='<%=a_debt.getPay_dt()%>' class='istext' readonly></td>
				</tr>
<%
			}
			else
			{
%>
				<tr>
					<td align='center'><input type='text' name='t_alt_tm' value='<%=a_debt.getAlt_tm()%>' size='2' class='white' readonly></td>
					<td align='center'><input type='text' name='t_est_dt' size='11' value='<%=a_debt.getAlt_est_dt()%>' class='white' readonly></td>
					<td align='right'><input type='text' name='t_alt_prn' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn())%>' class='whitenum' readonly>원&nbsp;</td>
					<td align='right'><input type='text' name='t_alt_int' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_int())%>' class='whitenum' readonly>원&nbsp;</td>
					<td align='right'><input type='text' name='t_alt_amt' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn()+a_debt.getAlt_int())%>' class='whitenum' readonly>원&nbsp;</td>
					<td align='right'><input type='text' name='t_rest_amt' size='12' value='<%=Util.parseDecimal(a_debt.getAlt_rest())%>' class='whitenum' readonly>원&nbsp;</td>
					<td align='center'><input type='text' name='t_pay_yn' size='2' value='N' class='white' readonly></td>
					<td align='center'><input type='text' name='t_pay_dt' size='11' value='-' class='white' readonly></td>
				</tr>
<%			}
		}
	}
	else
	{
%>				<tr>
					<td>할부횟수가 세팅되지 않았습니다.</td>
				</tr>
<%
	}
%>
			</table>
		</td>
	</tr>
</table>
<script language='javascript'>
<!--
	parent.cal_total();
-->
</script>
</body>
</html>
