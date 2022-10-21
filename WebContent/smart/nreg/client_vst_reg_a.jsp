<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.cus0402.*"%>
<%@ include file="/smart/cookies.jsp" %> 

<%
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String cmd 			= request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	
	String seq 			= request.getParameter("seq")==null?"":request.getParameter("seq");
	String vst_dt 		= request.getParameter("vst_dt")==null?"":request.getParameter("vst_dt");
	String vst_pur 		= request.getParameter("vst_pur")==null?"":request.getParameter("vst_pur");
	String vst_title 	= request.getParameter("vst_title")==null?"":request.getParameter("vst_title");
	String sangdamja 	= request.getParameter("sangdamja")==null?"":request.getParameter("sangdamja");
	String vst_cont 	= request.getParameter("vst_cont")==null?"":request.getParameter("vst_cont");
	String vst_pur_nm 	= request.getParameter("vst_pur_nm")==null?"":request.getParameter("vst_pur_nm");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	
	Cus0402_Database c42_db = Cus0402_Database.getInstance();
	
	int result = 0;
	
	Cycle_vstBean cvBn = new Cycle_vstBean();
	cvBn.setClient_id	(client_id);
	cvBn.setVst_dt		(vst_dt);
	cvBn.setVisiter		(user_id);
	cvBn.setVst_pur		(vst_pur);
	cvBn.setVst_title	(vst_title);
	cvBn.setVst_cont	(vst_cont);
	cvBn.setUpdate_id	(user_id);
	cvBn.setSangdamja	(sangdamja);
	
	if(!vst_pur.equals("6") && vst_title.equals("")) 	cvBn.setVst_title	(vst_pur_nm);
	if(!vst_pur.equals("6") && !vst_title.equals("")) 	cvBn.setVst_title	(vst_pur_nm+"-"+vst_title);
	if(vst_pur.equals("6") && !vst_title.equals("")) 	cvBn.setVst_title	(vst_title);
	
	if(cmd.equals("i")){
		seq = c42_db.insertCycle_vst(cvBn);
	}else if(cmd.equals("u")){
		cvBn = c42_db.getCycle_vstList(client_id, seq);
		cvBn.setVst_dt		(vst_dt);
		cvBn.setVst_title	(vst_title);
		cvBn.setVst_cont	(vst_cont);
		cvBn.setUpdate_id	(user_id);
		cvBn.setSangdamja	(sangdamja);
		result = c42_db.updateCycle_vst(cvBn);
	}else if(cmd.equals("d")){
		result = c42_db.deleteCycle_vst(client_id, seq);
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>
<form action="client_vst_view.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='seq' 		value='<%=seq%>'>	
</form>
<script>
<%	if(cmd.equals("i") && !seq.equals("")){%>		
		document.form1.action = "client_vst_view.jsp";
		document.form1.target = '_parent';		
		document.form1.submit();		
<%	}else if(cmd.equals("u") && result==1){%>		
		document.form1.action = "client_vst_view.jsp";
		document.form1.target = '_parent';		
		document.form1.submit();		
<%	}else if(cmd.equals("d") && result==1){%>		
		document.form1.action = "nreg_main.jsp";
		document.form1.target = '_parent';		
		document.form1.submit();		
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>