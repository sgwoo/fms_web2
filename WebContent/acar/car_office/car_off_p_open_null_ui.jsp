<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	String emp_id = "";
	String car_off_id = "";
	String cust_st = "";
	String emp_nm = "";
	String emp_ssn = "";
	String emp_m_tel = "";
	String emp_pos = "";
	String emp_email = "";
	String emp_bank = "";
	String emp_acc_no = "";
	String emp_acc_nm = "";	
	String emp_post = "";
	String emp_addr = "";				
    String cmd = "";
	int count = 0;
	
	
	if(request.getParameter("cmd") != null)
	{
		cmd = request.getParameter("cmd"); //update, inpsert 구분
	}
	
	if(request.getParameter("emp_id")!=null) emp_id = request.getParameter("emp_id");
	if(request.getParameter("car_off_id")!=null) car_off_id = request.getParameter("car_off_id");
	if(request.getParameter("cust_st")!=null) cust_st = request.getParameter("cust_st");
	if(request.getParameter("emp_nm")!=null) emp_nm = request.getParameter("emp_nm");
	if(request.getParameter("emp_ssn")!=null) emp_ssn = request.getParameter("emp_ssn");
	if(request.getParameter("emp_m_tel")!=null) emp_m_tel = request.getParameter("emp_m_tel");
	if(request.getParameter("emp_pos")!=null) emp_pos = request.getParameter("emp_pos");
	if(request.getParameter("emp_email")!=null) emp_email= request.getParameter("emp_email");
	if(request.getParameter("emp_bank")!=null) emp_bank = request.getParameter("emp_bank");
	if(request.getParameter("emp_acc_no")!=null) emp_acc_no = request.getParameter("emp_acc_no");
	if(request.getParameter("emp_acc_nm")!=null) emp_acc_nm = request.getParameter("emp_acc_nm");
	if(request.getParameter("emp_post")!=null) emp_post = request.getParameter("emp_post");
	if(request.getParameter("emp_addr")!=null) emp_addr = request.getParameter("emp_addr");
		
	if(cmd.equals("i")||cmd.equals("u"))
	{
				
		coe_bean.setCar_off_id(car_off_id);
		coe_bean.setCust_st(cust_st);
		coe_bean.setEmp_nm(emp_nm);
		coe_bean.setEmp_ssn(emp_ssn);
		coe_bean.setEmp_m_tel(emp_m_tel);
		coe_bean.setEmp_pos(emp_pos);
		coe_bean.setEmp_email(emp_email.trim());
		coe_bean.setEmp_bank(emp_bank);
		coe_bean.setEmp_acc_no(emp_acc_no);
		coe_bean.setEmp_acc_nm(emp_acc_nm);
		coe_bean.setEmp_id(emp_id);
		coe_bean.setEmp_post(emp_post);
		coe_bean.setEmp_addr(emp_addr);
		
		if(cmd.equals("i"))
		{
			count = umd.insertCarOffEmp(coe_bean);
		}else if(cmd.equals("u")){
			count = umd.updateCarOffEmp(coe_bean);
			
		}
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%
	if(count==1)
	{
%>
alert("정상적으로 등록되었습니다.");
parent.opener.CarOffReload();
window.location="about:blank";
<%
	}
%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form action="./car_office_p_frame.jsp" name="form1" method="post">
<input type="hidden" name="cmd" valaue="nd">
</form>
</body>
</html>