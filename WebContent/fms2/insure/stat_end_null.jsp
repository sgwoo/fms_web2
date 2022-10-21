<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>

<html><head><title>FMS</title>
</head>
<body>
<%
	
	String s_dt = "20150210";
   	String s_use = request.getParameter("s_use")==null?"2":request.getParameter("s_use");
		
	int flag3 = 0;
	
	int count = 0;
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
    	//차량관리비용현황
    	String  d_flag3 =  ai_db.call_sp_jip_insur_car_use(s_dt, s_use);
	if (!d_flag3.equals("0")) flag3 = 1;
    	System.out.println("보험갱신현황 =" + d_flag3);


%>
<form name='form1'  method="POST">

<input type='hidden' name='mode' value=''>
</form>
<script language='javascript'>
	var fm = document.form1;

<%	if(flag3 != 0){%>
	alert('보험갱신현황오류 발생!');
<%	} else   {%>
    alert('처리되었습니다');
<%	} %>
	
</script>
</body>
</html>