<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<html><head><title>FMS</title>
</head>
<body>
<%
	
	String today 	= AddUtil.getDate(4);
	String save_dt 	= today;
		
	int flag3 = 0;
	
	int count = 0;


    	//�������������Ȳ
    	String  d_flag3 =  ad_db.call_sp_stat_car_mng_magam();
	if (!d_flag3.equals("0")) flag3 = 1;
    	System.out.println("�������������Ȳ =" + d_flag3);


%>
<form name='form1'  method="POST">

<input type='hidden' name='mode' value=''>
</form>
<script language='javascript'>
	var fm = document.form1;

<%	if(flag3 != 0){%>
	alert('�������������Ȳ���� �߻�!');
<%	} else   {%>
    alert('ó���Ǿ����ϴ�');

<%	} %>
	
</script>
</body>
</html>