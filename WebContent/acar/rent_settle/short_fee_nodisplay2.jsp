<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.short_fee_mng.*, acar.user_mng.*, acar.res_search.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	//정산금 자동계산
	
	int tot_hour 	= request.getParameter("tot_hour")==null?0:Util.parseDigit(request.getParameter("tot_hour"));	
	int tot_days 	= request.getParameter("tot_days")==null?0:Util.parseDigit(request.getParameter("tot_days"));
	int tot_months 	= request.getParameter("tot_months")==null?0:Util.parseDigit(request.getParameter("tot_months"));
	
	int day_s_amt 	= request.getParameter("day_s_amt")==null?0:Util.parseDigit(request.getParameter("day_s_amt"));
		
	int tot_fee_s_amt = 0;
	int tot_amt_m = 0;
	int tot_amt_d = 0;
	int tot_amt_h = 0;
	
	if(tot_hour >0 && tot_hour < 13){
		tot_hour = 12;
	}else if(tot_hour >12){
		tot_hour = 0;
		tot_days = tot_days+1;
	}	
				
	if(tot_months != 0)		tot_amt_m = day_s_amt * 30 * tot_months;
	if(tot_days != 0)		tot_amt_d = (new Double(day_s_amt)).intValue() * tot_days;
	//if(tot_hour != 0) 		tot_amt_h = (new Double(day_s_amt/24)).intValue() * tot_hour;
	if(tot_hour != 0) 		tot_amt_h = (new Double(day_s_amt/2)).intValue();
	
	
	tot_fee_s_amt = tot_amt_m + tot_amt_d + tot_amt_h;
		
%>
<script language='javascript'>
	var fm = parent.form1;
	
	
	fm.fee_s_amt.value = parseDecimal(hun_th_rnd('<%=tot_fee_s_amt%>'));
	parent.set_amt(fm.fee_s_amt);
		
	
</script>
</body>
</html>

