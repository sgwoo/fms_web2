<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String second_plate_yn 	= request.getParameter("second_plate_yn")==null?"":request.getParameter("second_plate_yn");
	String return_dt 	= request.getParameter("return_dt")==null?"":request.getParameter("return_dt");
	String etc 	= request.getParameter("etc")==null?"":request.getParameter("etc");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	boolean flag = true;	
	
	if (second_plate_yn.equals("R") || second_plate_yn.equals("N")) {
		flag = a_db.updateCarSecondPlateMng(second_plate_yn, return_dt, etc, rent_mng_id, rent_l_cd);
	}
%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">
	<input type="hidden" name="s_kd" value="<%=s_kd%>">
	<input type="hidden" name="t_wd" value="<%=t_wd%>">
	<input type="hidden" name="gubun1" value="<%=gubun1%>">
	<input type="hidden" name="gubun2" value="<%=gubun2%>">
	<input type="hidden" name="gubun3" value="<%=gubun3%>">
	<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
	<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
</form>
<script language='javascript'>
<%if (!flag) {%>
alert("보조번호판 상태 수정 에러입니다.\n\n확인하십시오.");
location="about:blank";
<%} else {%>
alert("보조번호판 상태가 정상적으로 수정되었습니다.");
parent.window.close();
parent.opener.location.reload();
<%}%>
</script>
</body>
</html>