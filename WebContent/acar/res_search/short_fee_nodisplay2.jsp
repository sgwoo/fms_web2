<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.short_fee_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	int rent_hour 	= request.getParameter("rent_hour")==null?0:Util.parseDigit(request.getParameter("rent_hour"));
	int rent_days 	= request.getParameter("rent_days")==null?0:Util.parseDigit(request.getParameter("rent_days"));
	int rent_months = request.getParameter("rent_months")==null?0:Util.parseDigit(request.getParameter("rent_months"));

	int day_s_amt 	= request.getParameter("day_s_amt")==null?0:Util.parseDigit(request.getParameter("day_s_amt"));
	
	int fee_amt = 0;
	int fee_amt_m = 0;
	int fee_amt_d = 0;
	int fee_amt_h = 0;
	
	if(rent_hour >0 && rent_hour < 13){
		rent_hour = 12;
	}else if(rent_hour >12){
		rent_hour = 0;
		rent_days = rent_days+1;
	}

				
	if(rent_months != 0)		fee_amt_m = day_s_amt * 30 * rent_months;
	if(rent_days != 0)		fee_amt_d = (new Double(day_s_amt)).intValue() * rent_days;
	if(rent_hour != 0) 		fee_amt_h = (new Double(day_s_amt/24)).intValue() * rent_hour;
				
	fee_amt = fee_amt_m + fee_amt_d + fee_amt_h;
%>
<script language='javascript'>
	var fm = parent.form1;
	
	fm.fee_s_amt.value = parseDecimal(hun_th_rnd('<%=fee_amt%>'));
	parent.set_amt(fm.fee_s_amt);
			
</script>
</body>
</html>
