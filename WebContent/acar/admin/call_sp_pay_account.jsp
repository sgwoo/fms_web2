<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String doc_type	= request.getParameter("doc_type")==null?"N":request.getParameter("doc_type");
	String doc_dt	= request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt");
	String pay_code	= request.getParameter("pay_code")==null?"":request.getParameter("pay_code");
	String sender_nm = request.getParameter("sender_nm")==null?"":request.getParameter("sender_nm");
	String kr_nm = request.getParameter("kr_nm")==null?"":request.getParameter("kr_nm");
	
	
	
	
	int flag4 = 0;
	
	//회계처리 프로시저 호출----------------------------------------------------------------------------
	String  d_flag1 =  ad_db.call_sp_pay_account(sender_nm, pay_code, doc_type, AddUtil.replace(doc_dt,"-",""));
	
	if (!d_flag1.equals("0")) flag4 = 1;
	
	System.out.println("[[회계처리 프로시저 등록]] pay_code='"+pay_code+"', sender_nm='"+sender_nm+"', kr_nm='"+kr_nm+"', doc_type='"+doc_type+"', doc_dt='"+doc_dt+"', d_flag1='"+d_flag1+"', act_dt='"+AddUtil.getDate()+"'");
	//--------------------------------------------------------------------------------------------------
	
%>
<html><head><title>FMS</title>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'http://fms1.amazoncar.co.kr/fms2/pay_mng/pay_c_frame.jsp';			
		fm.target = 'd_content';
		fm.submit();
	}
	
//-->
</script>
</head>
<body>
<form name='form1' action='' target='d_content' method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='pay_code' 	value='<%=pay_code%>'>      
  <input type='hidden' name='doc_type' 	value='<%=doc_type%>'>        
  <input type='hidden' name='doc_dt' 	value='<%=doc_dt%>'>          
  <input type='hidden' name='sender_nm' value='<%=sender_nm%>'>      
</form>
<script language='javascript'>
<!--
<%	if(flag4 > 0){//에러발생%>
		alert("출금원장 회계처리중 에러가 발생하였습니다.");
<%	}else{//정상%>		
		alert("정상발급!!");
		opener.location.reload();
		self.window.close();
//		go_step();
<%	}%>
//-->	
</script>
</body>
</html>