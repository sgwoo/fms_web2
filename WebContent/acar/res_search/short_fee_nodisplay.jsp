<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.short_fee_mng.*, acar.user_mng.*"%>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String section 	= request.getParameter("section")==null?"":request.getParameter("section");
	String ins_yn 	= request.getParameter("ins_yn")==null?"":request.getParameter("ins_yn");
	int rent_hour 	= request.getParameter("rent_hour")==null?0:Util.parseDigit(request.getParameter("rent_hour"));
	int rent_days 	= request.getParameter("rent_days")==null?0:Util.parseDigit(request.getParameter("rent_days"));
	int rent_months = request.getParameter("rent_months")==null?0:Util.parseDigit(request.getParameter("rent_months"));
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	int rm1 	= request.getParameter("rm1")==null?0:Util.parseDigit(request.getParameter("rm1"));
	String cust_st = request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	String cust_id = request.getParameter("cust_id")==null?"":request.getParameter("cust_id");
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean user_bean 	= new UsersBean();
	
	//직원가 적용
	if(cust_st.equals("4")){
		user_bean 	= umd.getUsersBean(cust_id);
	}
	
	
	int fee_amt = 0;
	int ins_amt = 0;
	int fee_amt_m = 0;
	int fee_amt_d = 0;
	int fee_amt_h = 0;	

	int inv_amt = 0;
	
	
	
		if(rent_months > 0){			//개월레벨(amt01m~amt11m)
				fee_amt = sfm_db.getShortFeeAmt(section, "amt_"+AddUtil.addZero2(rent_months)+"m", "2", "");
		}else{
			if(rent_days > 0){ 		//일자레벨(amt01d~amt30d)
				fee_amt = sfm_db.getShortFeeAmt(section, "amt_"+AddUtil.addZero2(rent_days)+"d", "2", "");
			}else if(rent_hour > 0){//시간레벨(amt_12h)
				fee_amt = sfm_db.getShortFeeAmt(section, "amt_12h", "2", "");
			}
		}
				
		if(rent_months != 0)		fee_amt_m = fee_amt * 30 * rent_months;
		if(rent_days != 0)		fee_amt_d = (new Double(fee_amt)).intValue() * rent_days;
		if(rent_hour != 0) 		fee_amt_h = (new Double(fee_amt/24)).intValue() * rent_hour;
				
		fee_amt = fee_amt_m + fee_amt_d + fee_amt_h;
		
		inv_amt = fee_amt*30;
	
%>
<script language='javascript'>
	var fm = parent.form1;
	
	
		<%if(rent_st.equals("1") && cust_st.equals("4") && user_bean.getLoan_st().equals("")){%>
			fm.fee_s_amt.value = parseDecimal(hun_th_rnd(<%=fee_amt%>*0.2));
		<%}else if(rent_st.equals("1") && cust_st.equals("4") && !user_bean.getLoan_st().equals("")){%>		
			fm.fee_s_amt.value = parseDecimal(hun_th_rnd(<%=fee_amt%>*0.25));	
		<%}else{%>	
			fm.fee_s_amt.value = parseDecimal('<%=fee_amt%>');	
		<%}%>	
		
		fm.inv_s_amt.value = fm.fee_s_amt.value;	

		parent.set_amt(fm.fee_s_amt);
		parent.set_amt(fm.inv_s_amt);
		
			
	
	
</script>
</body>
</html>
