<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID	
		
	// cms 처리전 데이타여부 확인 후 삭제 		
	int cnt = 0;
	String jbit = "";
	String  flag = "0"; 
	
	 flag =  ai_db.call_sp_member_user_cms11_reg();	
		
	System.out.println("cms 은행데이타 처리:" +flag);
	
%>

<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>

</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag.equals("1")){%>
		alert('오류발생!');
<%	}else if(flag.equals("2")){%>
		alert('cms은행데이타를 처리할수 없습니다.!');
<%	}else{%>
		alert('처리되었습니다');
		fm.action='/fms2/cms/file11_cms_reg.jsp';
   		fm.target='d_content';		
    		fm.submit();

<%	}%>

</script>
</body>
</html>

