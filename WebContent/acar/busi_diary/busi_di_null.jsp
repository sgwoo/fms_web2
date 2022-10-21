<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String sel = request.getParameter("sel")==null?"":request.getParameter("sel");
	String s_brch_id = request.getParameter("s_brch_id")==null?"":request.getParameter("s_brch_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList(s_dept_id, s_brch_id, "EMP");//사원 리스트
	int user_size = users.size();	
	int count = 0;
	int indexV = 0;
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	te = parent.<%=sel%>;

<%	if(user_size > 0){%>

	te.length = <%= user_size+1 %>;
	te.options[0].value = '';
	te.options[0].text = '선택';

<%		for(int i = 0 ; i < user_size ; i++){
			Hashtable user = (Hashtable)users.elementAt(i);%>
			
				te.options[<%=i+1%>].value = '<%=user.get("USER_ID")%>';
				te.options[<%=i+1%>].text = '<%=user.get("USER_NM")%>';
				
<%		}
	}else{	%>
	
	te.length = 1;
	te.options[0].value = '';
	te.options[0].text = '선택';

<%	}	%>

//-->
</script>
</head>
<body>
</body>
</html>
