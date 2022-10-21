<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");	
	String vst_dt = request.getParameter("vst_dt")==null?"":AddUtil.ChangeString(request.getParameter("vst_dt"));
	String visiter = request.getParameter("visiter")==null?"":request.getParameter("visiter");
	String vst_pur = request.getParameter("vst_pur")==null?"":request.getParameter("vst_pur");
	String vst_title = request.getParameter("vst_title")==null?"":request.getParameter("vst_title");
	String vst_cont = request.getParameter("vst_cont")==null?"":request.getParameter("vst_cont");
	String vst_est_dt = request.getParameter("vst_est_dt")==null?"":AddUtil.ChangeString(request.getParameter("vst_est_dt"));
	String vst_est_cont = request.getParameter("vst_est_cont")==null?"":request.getParameter("vst_est_cont");
	String update_id = request.getParameter("update_id")==null?"":request.getParameter("update_id");
	String update_dt = request.getParameter("update_dt")==null?"":AddUtil.ChangeString(request.getParameter("update_dt"));
	String sangdamja = request.getParameter("sangdamja")==null?"":request.getParameter("sangdamja");
	String page_nm = request.getParameter("page_nm")==null?"":request.getParameter("page_nm");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	Cycle_vstBean cvBn = new Cycle_vstBean();
	cvBn.setClient_id(client_id);
	cvBn.setSeq(seq);
	cvBn.setVst_dt(vst_dt);
	cvBn.setVisiter(visiter);
	cvBn.setVst_pur(vst_pur);
	cvBn.setVst_title(vst_title);
	cvBn.setVst_cont(vst_cont);
	cvBn.setVst_est_dt(vst_est_dt);
	cvBn.setVst_est_cont(vst_est_cont);
	cvBn.setUpdate_id(update_id);
	cvBn.setUpdate_dt(update_dt);
	cvBn.setSangdamja(sangdamja);
	
	
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.updateCycle_vst(cvBn);

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
		alert("<% if(vst_pur.equals("")){ %>등록<% }else{ %>수정<% } %>되지 않았습니다");
		parent.location.href="vst_reg.jsp?client_id=<%=client_id%>&seq=<%= seq %>";
		
<%	}else{		%>		
		alert("<% if(vst_pur.equals("")){ %>등록<% }else{ %>수정<% } %>되었습니다");
		<% if(page_nm.equals("cus_pre_sc_gs")){ %>
			parent.opener.location.href = "../cus_pre/cus_pre_sc_gs.jsp?user_id=<%= user_id %>";
		<% }else{ %>
			parent.opener.location.reload();
		<% } %>
		parent.window.close();
		//parent.location.href="vst_reg.jsp?client_id=<%=client_id%>&seq=<%= seq %>";
<%	}			%>
</script>
</body>
</html>