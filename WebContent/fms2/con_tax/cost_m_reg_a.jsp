<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");	
				
	String  flag =  t_db.call_sp_car_cost(st_year);
	
	System.out.println("������¿��� ������ ="+flag);
	
%>

<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='st_year' value='<%=st_year%>'>

</form>
<script language='javascript'>
<%	if(flag.equals("1")){%>
		alert('�����߻�!');

<%	}else{%>
		alert('ó���Ǿ����ϴ�');

<%	}%>
</script>
</body>
</html>

