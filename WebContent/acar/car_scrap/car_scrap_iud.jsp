<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_scrap.*"%>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"서울":request.getParameter("gubun");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String car_ext = request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String reg_dt = request.getParameter("reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("reg_dt"));	
	String cnt = "";
				
	int result = 0;
		
	if(cmd.equals("i"))	{
		if(sc_db.getScrapCheck(car_no)==0){
			result = sc_db.car_scrap_i(car_no, car_nm, reg_dt, car_ext);
		}else{
			cnt = "1";
		}
	}
	else if(cmd.equals("u"))	result = sc_db.car_scrap_u(seq, car_no, car_nm, reg_dt, car_ext);
	else if(cmd.equals("d"))	result = sc_db.car_scrap_d(seq);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<form action="scrap_s_frame_m.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="seq" value="">
</form>
<script language="JavaScript">
<!--
<%if(result >= 1){
	if(cmd.equals("i")){%>
		alert("등록되었습니다.");
	<%}else if(cmd.equals("u")){%>
		alert("수정되었습니다.");
	<%}else if(cmd.equals("d")){%>
		alert("삭제되었습니다.");
	<%} %>
	document.form1.target = 'd_content';
	document.form1.submit();
//	parent.location.href = "scrap_sc_m.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&gubun=<%=gubun%>";
<%}else{
	if(cnt.equals("1")){%>
		alert("이미 등록된 차량번호 입니다.");
	<%}else{%>		
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.close();
	<%}%>	
<%}%>
//-->
</script>
</body>
</html>