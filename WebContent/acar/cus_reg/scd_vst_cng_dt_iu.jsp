<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String vst_est_dt = request.getParameter("vst_est_dt")==null?"":AddUtil.ChangeString(request.getParameter("vst_est_dt"));
	String vst_cng_cau = request.getParameter("vst_cng_cau")==null?"":request.getParameter("vst_cng_cau");
	String h_all = request.getParameter("h_all")==null?"":request.getParameter("h_all");
	
	/* 스케줄 변경 */
	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.modifyScdVst(client_id,seq,vst_est_dt,vst_cng_cau,h_all);

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>

<script language='javascript'>
<%	if(result <= 0){%>
		alert('오류발생!');
<%	}else{%>
		alert('처리되었습니다');
		parent.opener.scd_vst.location="cus_reg_visit_in.jsp?client_id=<%=client_id%>";
		parent.close();		
<%	}%>
</script>
</body>
</html>
