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
	
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");	
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");	
			
	//������� ���� ������ �縶�� �Ұ�
	int m_cnt = 0;
	m_cnt =   JsDb.getM_cnt(st_year, st_mon );
	
	String flag = "";
	
	if  (m_cnt  > 0 ) {
	    flag = "2";
	} else { 
	     flag =  JsDb.call_sp_oil_jungsan(st_year, st_mon );
	}
	
	System.out.println("������ ����="+flag);
	
%>

<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>

</form>
<script language='javascript'>
<%	if(flag.equals("1")){%>
		alert('�����߻�!');
<%	}else if ( flag.equals("2") )  { %>
		alert('������Ȱ��� �ֽ��ϴ�. �縶�� �Ұ��Դϴ�.');
<%	}else{%>
		alert('ó���Ǿ����ϴ�');

<%	}%>
</script>
</body>
</html>

