<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="at_db" scope="page" class="acar.attend.AttendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID	
	String adate = request.getParameter("adate")==null?"":request.getParameter("adate");	
	
	
	// cms ó���� ����Ÿ���� Ȯ�� 
	
	int cnt = 0;
	String jbit = "";
	String  flag = "0"; 
	//������ check
	int h_cnt =  at_db.getHolidayCnt(adate); //�������� �ƴϸ� ����
	
	if  ( h_cnt  < 1) {
	
		cnt =  ai_db.getCntFile21CmsBit(adate);
		if (cnt < 1 ) {
			flag =  ai_db.call_sp_file21_cms_reg(adate);	
		} else {
			flag = "2";
		}	
	} else {	
		flag = "3"; //�����ϻ���
	}
	
	System.out.println("cms ���ⵥ��Ÿ ����=" + adate + ":" +flag);
	
%>

<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>

</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag.equals("0")){%>
		alert('ó���Ǿ����ϴ�');
		fm.action='/fms2/cms/file21_cms_reg.jsp';
   		fm.target='d_content';		
    		fm.submit();		
<%	}else if(flag.equals("2")){%>
		alert('����Ƿڵ� ����Ÿ�� �ٽ� �����Ҽ� �����ϴ�.!');
<%	}else if(flag.equals("3")){%>
		alert('������ ����Ƿڵ���Ÿ��  �����Ҽ� �����ϴ�.!');		
<%	}else{%>
	alert('�����߻�!');
<%	}%>

</script>
</body>
</html>
