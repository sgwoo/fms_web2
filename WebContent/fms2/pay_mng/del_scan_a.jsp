<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.cus_reg.*, acar.car_service.*, acar.bill_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>


<%
	PayMngDatabase 	   pm_db 	= PayMngDatabase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이


	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;

	String reqseq 	= request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	String file_st 	= request.getParameter("file_st")==null?"":request.getParameter("file_st");


	//출금원장
	PayMngBean bean 	= pm_db.getPay(reqseq);
	
	if(file_st.equals("1"))		bean.setFilename1	("");//첨부파일명1
	if(file_st.equals("2"))		bean.setFilename2	("");//첨부파일명2
	if(file_st.equals("3"))		bean.setFilename3	("");//첨부파일명3
	if(file_st.equals("4"))		bean.setFilename4	("");//첨부파일명4
	if(file_st.equals("5"))		bean.setFilename5	("");//첨부파일명5
	
	if(!pm_db.updatePayBFD(bean, file_st)) flag1 += 1;
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		
		opener.document.location.reload();
		
		window.close();
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' target='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
  <input type='hidden' name='from_page' value='<%=from_page%>'>       
  <input type='hidden' name='reqseq'    value='<%=reqseq%>'>    
</form>
<script language='javascript'>
<!--
<%	if(flag1>0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("등록하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
