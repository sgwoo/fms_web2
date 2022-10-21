<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.user_mng.*, card.*"%>

<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	
	String mode= request.getParameter("mode")==null?"":request.getParameter("mode");	
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");	
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");	
	String o_year = request.getParameter("o_year")==null?"":request.getParameter("o_year");	//유류대정산 년도 
	String o_mon = request.getParameter("o_mon")==null?"":request.getParameter("o_mon");	//유류대정산 월 
	
	System.out.println("St_year=" + st_year + ":St_mon="+ st_mon + ":mode=" + mode);
	
	// 선택 캠페인 포상금액 정산 - gong_amt  
	String  flag =  JsDb.call_sp_car_oil_cmp_jungsan(o_year, o_mon, st_year, st_mon, mode);
		
	System.out.println("캠페인 포상금액 유류대 반영="+flag);	
	
%>

<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>

</form>
<script language='javascript'>
<%	if(flag.equals("1")){%>
		alert('오류발생!');

<%	}else{%>
		alert('처리되었습니다');

<%	}%>
</script>
</body>
</html>
