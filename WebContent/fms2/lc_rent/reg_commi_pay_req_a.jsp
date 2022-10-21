<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String emp_id	 	= request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	
	boolean flag1 = true;
%>


<%
	
	//영업소사원-------------------------------------------------------------------------------------------
	
	//commi
	CommiBean emp1 		= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	emp1.setEmp_id			(emp_id);
//	emp1.setComm_rt		 	(request.getParameter("comm_rt")		==null? 0:AddUtil.parseFloat(request.getParameter("comm_rt")));
	emp1.setComm_r_rt	 	(request.getParameter("comm_r_rt")		==null? 0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
	emp1.setCh_remark	 	(request.getParameter("ch_remark")		==null?"":request.getParameter("ch_remark"));
	emp1.setCh_sac_id	 	(request.getParameter("ch_sac_id")		==null?"":request.getParameter("ch_sac_id"));
	emp1.setEmp_bank	 	(request.getParameter("emp_bank")		==null?"":request.getParameter("emp_bank"));
	emp1.setEmp_acc_no		(request.getParameter("emp_acc_no")		==null?"":request.getParameter("emp_acc_no"));
	emp1.setEmp_acc_nm	 	(request.getParameter("emp_acc_nm")		==null?"":request.getParameter("emp_acc_nm"));
	emp1.setCommi			(request.getParameter("commi")			==null? 0:AddUtil.parseDigit(request.getParameter("commi")));
	emp1.setCommi_car_amt	(request.getParameter("commi_car_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("commi_car_amt")));
	emp1.setReq_dt		 	(request.getParameter("req_dt")			==null?"":request.getParameter("req_dt"));
	emp1.setReq_cont	 	(request.getParameter("req_cont")		==null?"":request.getParameter("req_cont"));
	if(!emp1.getReq_dt().equals(""))		emp1.setReq_id(user_id);
	emp1.setAgnt_st			("1");
	emp1.setCommi_st		("1");
	
	//=====[commi] update=====
	flag1 = a_db.updateCommiNew(emp1);
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('영업담당 영업사원 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>


<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>

	var fm = document.form1;
	
	fm.action = '<%=from_page%>';	
	fm.target = 'c_foot';
	fm.submit();
	
//	parent.window.close();
	window.close();

</script>
</body>
</html>