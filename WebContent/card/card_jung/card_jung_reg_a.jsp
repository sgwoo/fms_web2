<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");	
			
	String  flag =  CardDb.call_sp_card_jungsan(s_year, AddUtil.addZero(s_month) );
	
	System.out.println("�����Ļ�������="+flag);
	
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

