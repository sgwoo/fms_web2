<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, acar.car_service.*"%> 
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");

	String 	cust_req_dt =  request.getParameter("cust_req_dt")==null?"":request.getParameter("cust_req_dt"); //청구일자	
	String 	fee_r_yn =  request.getParameter("fee_r_yn")==null?"":request.getParameter("fee_r_yn"); //대여료 출금일에 맞춤요청
	String 	cust_plan_dt =  request.getParameter("cust_plan_dt")==null?"":request.getParameter("cust_plan_dt"); //입금예정일
		
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();
	
	String cal_plan_dt = "";
			
	// 기본 + 3일 -- 20211122
	if ( cust_plan_dt.equals("") ) {
		cal_plan_dt = a_csd.getCustPlanDt(cust_req_dt, 4);			
		System.out.println("[예정일확인]면책금예정일자="+ l_cd+ ":" + cal_plan_dt);	
	} 		
	
	
	if (fee_r_yn.equals("Y") && cust_plan_dt.equals("") ) {  //대여료 출금일에 맞춤	
		cal_plan_dt = a_csd.getCustPlanDt(cust_req_dt, c_id, m_id, l_cd, accid_id);
		System.out.println("[예정일확인] 면책금대여료날짜요청="+ l_cd+ ":" + cal_plan_dt);
	}	
	
	if ( !cust_req_dt.equals("") && cal_plan_dt.equals("") ) {
		cal_plan_dt = cust_req_dt;  //청구일로 
	}
	
	if ( !cust_req_dt.equals("") && !cust_plan_dt.equals("") ) {
		cal_plan_dt = cust_plan_dt;  //입금예정일
	}
	
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

		alert( "입금예정일은  <%=AddUtil.ChangeDate2(cal_plan_dt)%> 입니다.");		
-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
</body>
</html>
