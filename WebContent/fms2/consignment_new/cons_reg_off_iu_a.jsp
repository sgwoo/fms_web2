<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.consignment.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String mm_seq 		= request.getParameter("mm_seq")==null?"":request.getParameter("mm_seq");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
%>


<%
	ConsignmentBean cons_mm 		= cs_db.getConsignmentMM(mm_seq);
	
	if(cons_mm.getMm_seq().equals("")){
		cons_mm.setReg_id		(user_id);
		cons_mm.setMm_req_nm		(request.getParameter("req_nm")==null?"":request.getParameter("req_nm"));
		cons_mm.setMm_car_no1		(request.getParameter("car_no1")==null?"":request.getParameter("car_no1"));
		cons_mm.setMm_car_no2		(request.getParameter("car_no2")==null?"":request.getParameter("car_no2"));
		cons_mm.setMm_content		(request.getParameter("content")==null?"":request.getParameter("content"));
		cons_mm.setMm_cons_dt		(request.getParameter("cons_dt")==null?"":request.getParameter("cons_dt"));
		
		mm_seq = cs_db.insertConsignmentMM(cons_mm);
		
		if(mm_seq.equals("")) result = 1;
		
	}else{
		cons_mm.setMm_req_nm		(request.getParameter("req_nm")==null?"":request.getParameter("req_nm"));
		cons_mm.setMm_car_no1		(request.getParameter("car_no1")==null?"":request.getParameter("car_no1"));
		cons_mm.setMm_car_no2		(request.getParameter("car_no2")==null?"":request.getParameter("car_no2"));
		cons_mm.setMm_content		(request.getParameter("content")==null?"":request.getParameter("content"));
		cons_mm.setMm_cons_dt		(request.getParameter("cons_dt")==null?"":request.getParameter("cons_dt"));
		
		flag1 = cs_db.updateConsignmentMM(cons_mm);
		
	}
	%>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='mm_seq' 	value='<%=mm_seq%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>    
  <input type='hidden' name='mode' 		value='<%=mode%>'>      
</form>
<script language='javascript'>
	var flag = 0;	
<%		if(result>0){	%>	alert('등록 에러입니다.\n\n확인하십시오');		flag = 1;<%		}	%>
<%		if(!flag1){		%>	alert('수정 에러입니다.\n\n확인하십시오');		flag = 1;<%		}	%>

	if(flag == 0){
		alert('처리되었습니다.');
		var fm = document.form1;	
		fm.action = 'cons_reg_off_frame.jsp';		
		fm.target = 'd_content';
		fm.submit();		
		
		parent.window.close();
	}
</script>
</body>
</html>
