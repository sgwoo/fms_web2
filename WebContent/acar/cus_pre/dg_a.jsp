<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.car_register.*"%>
<jsp:useBean id="cr_Bean" scope="page" class="acar.car_register.CarRegBean"/>  

<%@ include file="/acar/cookies.jsp" %>
<%

	//중복되는 변수
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String cmd	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	//insertPs
	String dg_dt = request.getParameter("dg_dt")==null?"":request.getParameter("dg_dt");
	String dg_no = request.getParameter("dg_no")==null?"":request.getParameter("dg_no");
	String dg_yn = request.getParameter("dg_yn")==null?"":request.getParameter("dg_yn");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	int count = 0;
	
	AddCarRegDatabase cr_db = AddCarRegDatabase.getInstance();	

if(cmd.equals("i")){
	
	cr_Bean.setDg_id(user_id);
	cr_Bean.setDg_dt(dg_dt);
	cr_Bean.setDg_no(dg_no);
	cr_Bean.setDg_yn(dg_yn);
	cr_Bean.setCar_mng_id(car_mng_id);
	
	count = cr_db.Updatedg_no(cr_Bean);

//	System.out.println("[AddCarRegDatabase:Updatedg_no]="+count);
	
}
%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15" >

<form name='form1' method='post'>
<input type="hidden" name="user_id" 	value="<%=user_id%>">
<input type="hidden" name="cmd" 	value="<%=cmd%>">
</form>
<script language='javascript'>
<!--
	var fm = document.form1;

<%if(cmd.equals("i")){
		if(count == 1){
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='/acar/car_register/register_s_frame.jsp';
		fm.submit();
//		parent.window.close();
		window.close();		
		

		

<%}
}else{
%>
	alert("에러입니다.");

<%
}
%>
//-->

</script>
</body>
</html>
