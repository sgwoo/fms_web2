<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="coev_bean" class="acar.car_office.CarOffEmpVisBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	String emp_id = "";	
	String vis_nm = "";
	String vis_dt = "";
	int seq_no = 0;
	String sub = "";
	String vis_cont = "";
					
    String cmd = "";
	int count = 0;
	String auth_rw = "";
	
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	
	if(request.getParameter("emp_id")!=null) emp_id = request.getParameter("emp_id");
	if(request.getParameter("vis_nm")!=null) vis_nm = request.getParameter("vis_nm");
	if(request.getParameter("vis_dt")!=null) vis_dt = request.getParameter("vis_dt");
	if(request.getParameter("seq_no")!=null) seq_no = Util.parseInt(request.getParameter("seq_no"));
	if(request.getParameter("sub")!=null) sub = request.getParameter("sub");
	if(request.getParameter("vis_cont")!=null) vis_cont = request.getParameter("vis_cont");
	
	if(cmd.equals("i")||cmd.equals("u"))
	{
				
		coev_bean.setEmp_id(emp_id);
		coev_bean.setVis_nm(vis_nm);
		coev_bean.setVis_dt(vis_dt);
		coev_bean.setSeq_no(seq_no);
		coev_bean.setSub(sub);
		coev_bean.setVis_cont(vis_cont);
		
		if(cmd.equals("i"))
		{
			count = umd.insertCarOffEmpVis(coev_bean);
		}else if(cmd.equals("u")){
			count = umd.updateCarOffEmpVis(coev_bean);
		}
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>
<script language="JavaScript">
<!--
<%if(cmd.equals("u")){%>
	alert("정상적으로 수정되었습니다.");
	parent.location.href = "car_office_p_s.jsp?emp_id=<%= emp_id %>";
<%}else{
		if(count==1)
		{
%>
alert("정상적으로 등록되었습니다.");
	parent.location.href = "car_office_p_s.jsp?emp_id=<%= emp_id %>";
<%		}
	}
%>
//-->
</script>
</body>
</html>