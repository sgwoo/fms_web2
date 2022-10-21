<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.* "%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	out.println("선택견적"+"<br><br>");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String base_dt = request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String vid1[] 		= request.getParameterValues("ch_l_cd");
	
	String est_tel		= "";
	int vid_size 		= 0;
	int flag 		= 0;
	
	
	vid_size = vid1.length;
	
	out.println("선택건수="+vid_size+"<br><br>");
	
	for(int i=0;i < vid_size;i++){
	
		est_tel = vid1[i];
		
		String set_code  = Long.toString(System.currentTimeMillis())+""+est_tel;
		
		out.println("실행코드="+set_code+"<br>");

		
	
		String  d_flag1 =  e_db.call_sp_esti_reg_hp(est_tel, set_code, 20000);
		
		String  d_flag2 =  e_db.call_sp_esti_reg_hp(est_tel, set_code, 30000);
		
		String  d_flag3 =  e_db.call_sp_esti_reg_hp(est_tel, set_code, 40000);
					
		String  d_flag4 =  e_db.call_sp_esti_reg_hp(est_tel, set_code, 10000);
		
		String  d_flag5 =  e_db.call_sp_esti_reg_hp(est_tel, set_code, 15000);
		
		String  d_flag6 =  e_db.call_sp_esti_reg_hp(est_tel, set_code, 25000);
			
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">  
  <input type="hidden" name="base_dt" value="<%=base_dt%>">  
  <input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">      
  <input type="hidden" name="t_wd" value="<%=t_wd%>">      
</form>
<script language='javascript'>
<!--
	alert('견적완료');
		
	var fm = document.form1;
	fm.target = 'd_content';						
	fm.action = 'main_car_frame.jsp';
	fm.submit();	
//-->
</script>
</body>
</html>
