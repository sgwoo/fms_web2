<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID	
		
	// cms ó���� ����Ÿ���� Ȯ�� �� ���� 		
	int cnt = 0;
	String jbit = "";
	String  flag = "0"; 
	
	cnt =  ai_db.getCntMemberCmsBit();
	if (cnt < 1 ) {	
		     flag =  ai_db.call_sp_member_user_cms_reg();	
	} else {	
		flag = "2";
	}	
		
	System.out.println("cms ������Ÿ ����ó��:" +flag);
	
%>


<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>

</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag.equals("1")){%>
		alert('�����߻�!');
<%	}else if(flag.equals("2")){%>
		alert('cms������Ÿ�� �����Ҽ� �����ϴ�.!');
<%	}else{%>
		alert('ó���Ǿ����ϴ�');
		fm.action='/fms2/cms/master_cms_reg.jsp';
   		fm.target='d_content';		
    	fm.submit();

<%	}%>

</script>
</body>
</html>

