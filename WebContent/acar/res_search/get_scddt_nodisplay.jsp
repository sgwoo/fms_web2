<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*, acar.fee.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//예약시스템 예약등록시 1회차납입일 기준으로 스케줄 입금예정일 셋팅 페이지
	
	String from_page  		= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	String deli_plan_dt 		= request.getParameter("deli_plan_dt")==null?"":request.getParameter("deli_plan_dt");
	String deli_dt 			= request.getParameter("deli_dt")==null?"":request.getParameter("deli_dt");
	int rent_months 		= request.getParameter("rent_months")==null?0:AddUtil.parseInt(request.getParameter("rent_months"));	
	
	if(!deli_dt.equals("")){
		deli_plan_dt = deli_dt;
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>	
<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>

				parent.document.form1.pay_dt2.value		= '<%=AddUtil.ChangeDate2(deli_plan_dt)%>';
				
		
		if(<%=rent_months%> > 1 ){
		
			<%for(int i=3; i<rent_months+2; i++){%>				
				parent.document.form1.pay_dt<%=i%>.value 	= '<%=c_db.addMonth(deli_plan_dt, (i-2))%>';				
			<%}%>
			
		}		
					
</script>
</body>
</html>
