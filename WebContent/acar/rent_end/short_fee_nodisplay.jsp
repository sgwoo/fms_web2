<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.short_fee_mng.*"%>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String section = request.getParameter("section")==null?"":request.getParameter("section");
	String ins_yn = request.getParameter("ins_yn")==null?"":request.getParameter("ins_yn");
	int rent_hour = request.getParameter("add_hour")==null?0:Util.parseDigit(request.getParameter("add_hour"));
	int rent_days = request.getParameter("add_days")==null?0:Util.parseDigit(request.getParameter("add_days"));
	int rent_months = request.getParameter("add_months")==null?0:Util.parseDigit(request.getParameter("add_months"));
	int fee_amt = 0;
	int ins_amt = 0;
	
	if(rent_months > 0){		//개월레벨(amt01m~amt11m)
			fee_amt = sfm_db.getShortFeeAmt(section, "amt_"+AddUtil.addZero2(rent_months)+"m", "2");
	}else{
		if(rent_days > 0){ 		//일자레벨(amt01d~amt30d)
			fee_amt = sfm_db.getShortFeeAmt(section, "amt_"+AddUtil.addZero2(rent_days)+"d", "2");
		}else if(rent_hour > 0){ 					//시간레벨(amt_12h)
			fee_amt = sfm_db.getShortFeeAmt(section, "amt_12h", "2");
		}
	}
%>
<script language='javascript'>
	var fm = parent.form1;
	fm.add_fee_s_amt.value = '<%=fee_amt%>';
	parent.set_amt(fm.add_fee_s_amt);
	<%if(ins_yn.equals("Y") && rent_months == 0){%>
		fm.add_ins_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) * 0.1) ;	
		parent.set_amt(fm.add_ins_s_amt);	
	<%}%>		
</script>
</body>
</html>
