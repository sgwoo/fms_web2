<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.user_mng.*, card.*"%>

<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	
	String mode= request.getParameter("mode")==null?"":request.getParameter("mode");	
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");	
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");	
	String o_year = request.getParameter("o_year")==null?"":request.getParameter("o_year");	//���������� �⵵ 
	String o_mon = request.getParameter("o_mon")==null?"":request.getParameter("o_mon");	//���������� �� 
	
	System.out.println("St_year=" + st_year + ":St_mon="+ st_mon + ":mode=" + mode);
	
	// ���� ķ���� ����ݾ� ���� - gong_amt  
	String  flag =  JsDb.call_sp_car_oil_cmp_jungsan(o_year, o_mon, st_year, st_mon, mode);
		
	System.out.println("ķ���� ����ݾ� ������ �ݿ�="+flag);	
	
%>

<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>

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
