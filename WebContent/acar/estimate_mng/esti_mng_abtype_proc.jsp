<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"1":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt 		= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 		= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	
	String esti_type	= request.getParameter("esti_type")	==null?"":request.getParameter("esti_type");
	String set_code		= request.getParameter("set_code")	==null?"":request.getParameter("set_code");
	String est_id		= request.getParameter("est_id")	==null?"":request.getParameter("est_id");
	String reg_id		= request.getParameter("reg_id")	==null?user_id:request.getParameter("reg_id");
	
	
	String jg_b_dt		= "";
	String em_a_j		= "";
	String ea_a_j		= "";
	
	
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	out.println("#### set_code="+set_code+"-------------------------------<br>");
	
	
	String reg_code[]  	= request.getParameterValues("reg_code");
	int est_size 		= reg_code.length;
	int count 			= 0;
	
	
	
	
	
	if(est_size>0){
		
		EstimateBean a_bean = e_db.getEstimateCase(est_id);
		
		//변수기준일자
		jg_b_dt = e_db.getVar_b_dt("jg", a_bean.getRent_dt());
		em_a_j 	= e_db.getVar_b_dt("em", a_bean.getRent_dt());
		ea_a_j 	= e_db.getVar_b_dt("ea", a_bean.getRent_dt());
		
		out.println("#### jg_b_dt="+jg_b_dt+"-------------------------------<br>");
		out.println("#### em_a_j="+em_a_j+"---------------------------------<br>");
		out.println("#### ea_a_j="+ea_a_j+"---------------------------------<br>");
		
		for(int j=0; j < est_size; j++){
			
			//[1단계]신차 잔가율 계산
			String  d_flag1 =  e_db.call_sp_esti_janga(reg_code[j], jg_b_dt, em_a_j, ea_a_j, "");
			//--------------------------------------------------------------------------------------------------
			
			
			//[2단계]월대여료 계산
			String  d_flag2 =  e_db.call_sp_esti_feeamt(reg_code[j], jg_b_dt, em_a_j, ea_a_j, "");
			//--------------------------------------------------------------------------------------------------
			
			
			//[3단계]중도해지위약율 계산하기
			String  d_flag3 =  e_db.call_sp_esti_clsper(reg_code[j], jg_b_dt, em_a_j, ea_a_j, "");
			//--------------------------------------------------------------------------------------------------
			
			
			//[4단계]초과운행부담금 계산하기
			//String  d_flag3 =  e_db.call_sp_esti_runamt(reg_code[j], jg_b_dt, em_a_j, ea_a_j, "");
			//--------------------------------------------------------------------------------------------------

		}
	}
	
		
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >     
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="acar_id" value="<%=user_id%>">
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">
  <input type="hidden" name="gubun4" value="<%=gubun4%>">
  <input type="hidden" name="gubun5" value="<%=gubun5%>">
  <input type="hidden" name="gubun6" value="<%=gubun6%>">  
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">
  <input type="hidden" name="t_wd" value="<%=t_wd%>">
  
  <input type="hidden" name="set_code" value='<%=set_code%>'>          
  <input type="hidden" name="est_id" value='<%=est_id%>'>   
  <input type="hidden" name="jg_b_dt" value="<%=jg_b_dt%>">
  <input type="hidden" name="em_a_j" value="<%=em_a_j%>">
  <input type="hidden" name="ea_a_j" value="<%=ea_a_j%>">   
  <input type='hidden' name="from_page"		value="/acar/estimate_mng/esti_mng_atype_proc.jsp">          
</form>
<script>
<!--
		document.form1.gubun1.value = '1';
		document.form1.gubun2.value = '';
		document.form1.gubun3.value = '';
		document.form1.gubun4.value = '2';
		document.form1.s_dt.value = '';
		document.form1.e_dt.value = '';		
		document.form1.target = 'd_content';						

		<%//if(esti_type.equals("a")){%>
		document.form1.action = "esti_mng_atype_u.jsp";		
		<%//}else if(esti_type.equals("b")){%>
		//document.form1.action = "esti_mng_btype_u.jsp";
		<%//}%>
		
		document.form1.submit();
//-->
</script>
</body>
</html>
