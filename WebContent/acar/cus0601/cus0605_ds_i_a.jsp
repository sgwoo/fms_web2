<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, acar.cus_reg.*, acar.car_service.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));	
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	String wash_pay 	= request.getParameter("wash_pay")==null?"":request.getParameter("wash_pay");
	String apply_dt 	= request.getParameter("apply_dt")==null?"":request.getParameter("apply_dt");
	String cont_etc 	= request.getParameter("cont_etc")==null?"":request.getParameter("cont_etc");
	String est_st 	= request.getParameter("est_st")==null?"":request.getParameter("est_st");
	
	
	int count = 0;
	ParkIODatabase piod = ParkIODatabase.getInstance();
	
	if (seq == 0) { // 등록
		count = piod.insertOffWashCont(off_id, wash_pay, apply_dt, cont_etc, est_st, gubun);
	}
	

%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15" >

<form name='form1' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="s_kd" 	value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
</form>
<script language='javascript'>
<!--
var fm = document.form1;
<%	if(count==1){ %>
		<% 	if (seq==0) { %>
		alert("정상적으로 등록되었습니다.");
		<% 	} else { %>
		alert("정상적으로 수정되었습니다.");
		<% 	} %>
		parent.window.close();
		parent.opener.location.reload();
	
		
<%}else{%>
		alert('에러가 발생하였습니다. 관리자에게 문의해 주세요.');
		parent.window.document.getElementById("loader").style.visibility="hidden";
<%}%>
//-->

</script>
</body>
</html>
