<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, acar.car_office.* "%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	boolean flag1 = true;
	
	String car_off_id 	= "";
		
	CarOffPreBean bean = new CarOffPreBean();
	
    String car_off_nm = request.getParameter("car_off_nm")==null?"":request.getParameter("car_off_nm");
        
    bean.setReq_dt		(request.getParameter("req_dt")		==null?"":request.getParameter("req_dt"));
    bean.setCom_con_no	(request.getParameter("com_con_no")		==null?"":request.getParameter("com_con_no"));
	bean.setCar_nm		(request.getParameter("car_nm")		==null?"":request.getParameter("car_nm"));	
	bean.setOpt			(request.getParameter("opt")		==null?"":request.getParameter("opt"));	
	bean.setColo		(request.getParameter("colo")		==null?"":request.getParameter("colo"));	
	bean.setIn_col		(request.getParameter("in_col")		==null?"":request.getParameter("in_col"));	
	bean.setEco_yn		(request.getParameter("eco_yn")		==null?"":request.getParameter("eco_yn"));	
	bean.setCar_amt		(request.getParameter("car_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_amt")));
	bean.setCon_amt		(request.getParameter("con_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("con_amt")));
	bean.setDlv_est_dt	(request.getParameter("dlv_est_dt")	==null?"":request.getParameter("dlv_est_dt"));	
	bean.setCon_pay_dt	(request.getParameter("con_pay_dt")	==null?"":request.getParameter("con_pay_dt"));	
	bean.setEtc			(request.getParameter("etc")		==null?"":request.getParameter("etc"));	
	bean.setGarnish_col	(request.getParameter("garnish_col")==null?"":request.getParameter("garnish_col"));
	bean.setAgent_view_yn(request.getParameter("agent_view_yn")==null?"N":request.getParameter("agent_view_yn"));
	bean.setBus_self_yn	(request.getParameter("bus_self_yn")==null?"N":request.getParameter("bus_self_yn"));
	bean.setQ_reg_dt	(request.getParameter("q_reg_dt")==null?"N":request.getParameter("q_reg_dt"));
	
	bean.setCon_bank	(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
	bean.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
	bean.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
	bean.setCon_est_dt	(request.getParameter("con_est_dt")	==null?"":request.getParameter("con_est_dt"));
	bean.setTrf_st0		(request.getParameter("trf_st0")	==null?"":request.getParameter("trf_st0"));
	bean.setAcc_st0		(request.getParameter("acc_st0")	==null?"":request.getParameter("acc_st0"));
		
	if(car_off_nm.equals("강서")) 				car_off_nm = "강서구청영업소";
	else if(car_off_nm.equals("강서구청")) 		car_off_nm = "강서구청영업소";
	else if(car_off_nm.equals("강서구청대리점")) 	car_off_nm = "강서구청영업소";
	else if(car_off_nm.equals("법인")) 			car_off_nm = "B2B사업운영팀";
	else if(car_off_nm.equals("법인판매")) 		car_off_nm = "B2B사업운영팀";
	else if(car_off_nm.equals("숭실대")) 			car_off_nm = "숭실대대리점";
	else if(car_off_nm.equals("숭실대판매점")) 		car_off_nm = "숭실대대리점";
	else if(car_off_nm.equals("을지로")) 			car_off_nm = "을지로대리점";
	else if(car_off_nm.equals("증산")) 			car_off_nm = "증산대리점";
	else if(car_off_nm.equals("학익")) 			car_off_nm = "학익대리점";
	
	if(car_off_nm.equals("B2B사업운영팀")) 		car_off_id = "03900";
	else if(car_off_nm.equals("강서구청영업소")) 	car_off_id = "02176";
	else if(car_off_nm.equals("분당서현전시장")) 	car_off_id = "04741";
	else if(car_off_nm.equals("숭실대대리점")) 		car_off_id = "00998";
	else if(car_off_nm.equals("영등포중앙대리점")) 	car_off_id = "04128";
	else if(car_off_nm.equals("을지로대리점")) 		car_off_id = "04500";
	else if(car_off_nm.equals("증산대리점")) 		car_off_id = "03548";
	else if(car_off_nm.equals("총신대")) 			car_off_id = "00588";
	else if(car_off_nm.equals("학익대리점")) 		car_off_id = "03579";
	else if(car_off_nm.equals("효성강남대로본사")) 	car_off_id = "03923";
		
	bean.setCar_off_nm		(car_off_nm);
	bean.setCar_off_id		(car_off_id);
	bean.setReg_id			(ck_acar_id);		
	bean.setUse_yn			("Y");	
		
	//insert
	flag1 = cop_db.insertCarOffPre(bean);	
	

		


%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('사전계약관리 처리 에러입니다.\n\n확인하십시오');		<%}%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'> 
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>   
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='from_page'	   value='<%=from_page%>'>   
   
</form>
<script language='javascript'>
	<%if(flag1){%>
	alert('처리되었습니다.');
	<%}%>
	
	parent.self.close();
		
	
</script>
</body>
</html>