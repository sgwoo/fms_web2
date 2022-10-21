<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	String zip[] 	= request.getParameterValues("t_zip");
	String addr[] = request.getParameterValues("t_addr");
	
	boolean flag = false;
	
	ClientAssestBean c_assest = al_db.getClientAssest(client_id, seq);
	
	c_assest.setClient_id(client_id);
	c_assest.setA_seq(seq);
	
	//newFMS 자산
	c_assest.setC_ass1_type	(request.getParameter("c_ass1_type")==null?"":request.getParameter("c_ass1_type"));
	c_assest.setC_ass1_addr	(addr[0]);
	c_assest.setC_ass1_zip	(zip[0]);
	c_assest.setC_ass2_type	(request.getParameter("c_ass2_type")==null?"":request.getParameter("c_ass2_type"));
	c_assest.setC_ass2_addr	(addr[1]);
	c_assest.setC_ass2_addr	(zip[1]);
	c_assest.setR_ass1_type	(request.getParameter("r_ass1_type")==null?"":request.getParameter("r_ass1_type"));
	c_assest.setR_ass1_addr	(addr[2]);
	c_assest.setR_ass1_zip	(zip[2]);
	c_assest.setR_ass2_type	(request.getParameter("r_ass2_type")==null?"":request.getParameter("r_ass2_type"));
	c_assest.setR_ass2_addr	(addr[3]);
	c_assest.setR_ass2_addr	(zip[3]);
	
	if(seq.equals("")){
		flag = al_db.insertClientAssest(c_assest);
	}else{
	   	flag = al_db.updateClientAssest(c_assest);
	}
%>
<form name='form1' action='./client_assest_s_p.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>

</form>
	<script language='javascript'>
<%	if(flag){%>
				alert('정상적으로 처리되었습니다');
				var fm = document.form1;
				fm.target = "CLIENT_SITE";
				fm.submit();
			
<%	}else{ //에러%>
				alert('처리되지 않았습니다');
<%	}%>
</script>
</body>
</html>
