<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	//����ں� ���̵� �ߺ� üũ
	
	String h_id 	= request.getParameter("h_id")==null?"":request.getParameter("h_id");		//���� ���̵�
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");	//���ο� ���̵�
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");//update, inpsert ����
	String id = "";
	int count = 0;
	
	if(cmd.equals("") && h_id.equals("")) 	cmd = "i";
	if(cmd.equals("") && !h_id.equals("")) 	cmd = "ud";
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//���� �Է� ���� ���̵� �̹� ��ϵ� ���̵����� Ȯ��
	id = umd.checkUserID(user_id);
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<%	if(cmd.equals("i")){
		if(!id.equals("")){%>
		alert("<%=user_id%>�� ��ϵ� ���̵��Դϴ�.");
		parent.form1.id.value = "";
		parent.form1.id.focus();
<%		}else{%>
		alert("<%=user_id%>�� ��� ������ ���̵��Դϴ�.");	
<%		}
	}else if(cmd.equals("ud")){
		if(!id.equals("") && !h_id.equals(id)){%>
		alert("<%=user_id%>�� ��ϵ� ���̵��Դϴ�.");
		parent.form1.id.value = '<%=h_id%>';
		parent.form1.id.focus();
<%		}else{%>
		alert("<%=user_id%>�� ��� ������ ���̵��Դϴ�.");	
<%		}
	}%>
</script>

<br><%=cmd%>
<br><%=id%>
<br><%=h_id%>
</body>
</html>