<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String var_cd = request.getParameter("var_cd")==null?"":request.getParameter("var_cd");	
	String var_nm = request.getParameter("var_nm")==null?"":request.getParameter("var_nm");	
	String d_type = request.getParameter("d_type")==null?"":request.getParameter("d_type");	
	int size = request.getParameter("size")==null?0:AddUtil.parseInt(request.getParameter("size"));
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String var[] = request.getParameterValues("var");
	String value[] = request.getParameterValues("value");
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	for(int i=0; i<size; i++){
		count = e_db.updateEstiCarVarList(var_cd, var[i], value[i], d_type);
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="esti_car_var_list_i.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="var_cd" value="<%=var_cd%>">
  <input type="hidden" name="var_nm" value="<%=var_nm%>">
  <input type="hidden" name="d_type" value="<%=d_type%>">          
  <input type="hidden" name="cmd" value="u">
</form>
<script>
<%	if(count==1){%>
		alert("정상적으로 수정되었습니다.");
		document.form1.action='esti_car_var_list_i.jsp';
		document.form1.target='CarVar';				
		document.form1.submit();		
		
		document.form1.action='esti_var_sc_in2.jsp';
		document.form1.target='i_in';				
		document.form1.submit();				
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>
