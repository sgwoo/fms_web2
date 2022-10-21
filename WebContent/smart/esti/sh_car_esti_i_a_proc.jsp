<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/smart/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")	==null?"":request.getParameter("car_no");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	String cmd 			= request.getParameter("cmd")		==null?"":request.getParameter("cmd");
	String e_page 		= request.getParameter("e_page")	==null?"":request.getParameter("e_page");
	String est_from 	= request.getParameter("est_from")	==null?"":request.getParameter("est_from");
	String esti_stat	= request.getParameter("esti_stat")	==null?"":request.getParameter("esti_stat");
	String l_cd 		= request.getParameter("l_cd")		==null?"":request.getParameter("l_cd");
	String m_id 		= request.getParameter("m_id")		==null?"":request.getParameter("m_id");
	String fee_rent_st 	= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	String insur_per	= request.getParameter("insur_per")	==null?"":request.getParameter("insur_per");
	String one_self		= request.getParameter("one_self")	==null?"":request.getParameter("one_self");
	String reg_dt		= request.getParameter("reg_dt")	==null?"":request.getParameter("reg_dt");
	String action_st 	= request.getParameter("action_st")	==null?"":request.getParameter("action_st");
	String reg_code		= request.getParameter("reg_code")	==null?"":request.getParameter("reg_code");
	String est_code		= request.getParameter("est_code")	==null?"":request.getParameter("est_code");
	String esti_table	= request.getParameter("esti_table")==null?"":request.getParameter("esti_table");
	String opt_chk		= request.getParameter("opt_chk")	==null?"":request.getParameter("opt_chk");
	String est_id		= request.getParameter("est_id")	==null?"":request.getParameter("est_id");
	String jg_b_dt		= "";
	String em_a_j		= "";
	String ea_a_j		= "";
	
	if(esti_table.equals("")) 	esti_table 	= "estimate_hp";
	if(!est_code.equals("")) 	reg_code 	= est_code;
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	System.out.println("#### reg_code="+reg_code+"-------------------------------<br>");
	
	
	int count 			= 0;
	
	
	
	//변수기준일자
	jg_b_dt = e_db.getVar_b_dt("jg", AddUtil.getDate());
	em_a_j 	= e_db.getVar_b_dt("em", AddUtil.getDate());
	ea_a_j 	= e_db.getVar_b_dt("ea", AddUtil.getDate());
	
	System.out.println("#### jg_b_dt="+jg_b_dt+"-------------------------------<br>");
	System.out.println("#### em_a_j="+em_a_j+"---------------------------------<br>");
	System.out.println("#### ea_a_j="+ea_a_j+"---------------------------------<br>");
	
	//[1단계]신차 잔가율 계산
	String  d_flag1 =  e_db.call_sp_esti_reg_sh_case(reg_code, jg_b_dt, em_a_j, ea_a_j);
	//--------------------------------------------------------------------------------------------------
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	function go_esti(){
		var fm = document.form1;
		fm.from_page.value = '/acar/estimate_mng/esti_mng_u.jsp';
		fm.action = "acar/secondhand_hp/estimate_fms.jsp";
		fm.target = '_blank';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >   
<%@ include file="/include/search_hidden.jsp" %>  
  <input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
  <input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
  <input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
  <input type='hidden' name='car_no' 		value='<%=car_no%>'>
  <input type='hidden' name='from_page'	value='<%=from_page%>'>
  <input type="hidden" name="cmd" value="<%=cmd%>">  
  <input type="hidden" name="e_page" value="<%=e_page%>">
  <input type="hidden" name="est_from" value="<%=est_from%>">  
  <input type="hidden" name="l_cd" value='<%=l_cd%>'>		    
  <input type="hidden" name="m_id" value='<%=m_id%>'>
  <input type="hidden" name="fee_rent_st" value='<%=fee_rent_st%>'>    
  <input type="hidden" name="one_self" value="<%=one_self%>">   
  <input type="hidden" name="reg_dt" value='<%=reg_dt%>'>    
  <input type="hidden" name="est_code" value='<%=reg_code%>'>          
  <input type="hidden" name="est_id" value='<%=est_id%>'>   
  <input type="hidden" name="jg_b_dt" value="<%=jg_b_dt%>">
  <input type="hidden" name="em_a_j" value="<%=em_a_j%>">
  <input type="hidden" name="ea_a_j" value="<%=ea_a_j%>">   
  <input type="hidden" name="mobile_yn" value="Y">             
  <input type="hidden" name="acar_id" value="<%=ck_acar_id%>">               
  <input type="hidden" name="opt_chk" value="<%=opt_chk%>">                 
</form>
<script>
<!--	

		document.form1.target = '_parent';						
		document.form1.action = "sh_car_esti_u.jsp";
		document.form1.submit();

		go_esti();
				
//-->
</script>
</body>
</html>
