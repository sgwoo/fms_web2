<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, acar.car_service.*"%> 
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");

	String 	cust_req_dt =  request.getParameter("cust_req_dt")==null?"":request.getParameter("cust_req_dt"); //û������	
	String 	fee_r_yn =  request.getParameter("fee_r_yn")==null?"":request.getParameter("fee_r_yn"); //�뿩�� ����Ͽ� �����û
	String 	cust_plan_dt =  request.getParameter("cust_plan_dt")==null?"":request.getParameter("cust_plan_dt"); //�Աݿ�����
		
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();
	
	String cal_plan_dt = "";
			
	// �⺻ + 3�� -- 20211122
	if ( cust_plan_dt.equals("") ) {
		cal_plan_dt = a_csd.getCustPlanDt(cust_req_dt, 4);			
		System.out.println("[������Ȯ��]��å�ݿ�������="+ l_cd+ ":" + cal_plan_dt);	
	} 		
	
	
	if (fee_r_yn.equals("Y") && cust_plan_dt.equals("") ) {  //�뿩�� ����Ͽ� ����	
		cal_plan_dt = a_csd.getCustPlanDt(cust_req_dt, c_id, m_id, l_cd, accid_id);
		System.out.println("[������Ȯ��] ��å�ݴ뿩�ᳯ¥��û="+ l_cd+ ":" + cal_plan_dt);
	}	
	
	if ( !cust_req_dt.equals("") && cal_plan_dt.equals("") ) {
		cal_plan_dt = cust_req_dt;  //û���Ϸ� 
	}
	
	if ( !cust_req_dt.equals("") && !cust_plan_dt.equals("") ) {
		cal_plan_dt = cust_plan_dt;  //�Աݿ�����
	}
	
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

		alert( "�Աݿ�������  <%=AddUtil.ChangeDate2(cal_plan_dt)%> �Դϴ�.");		
-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
</body>
</html>
