<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	//사용자별 아이디 중복 체크
	
	String h_id 	= request.getParameter("h_id")==null?"":request.getParameter("h_id");		//기존 아이디
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");	//새로운 아이디
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");//update, inpsert 구분
	String id = "";
	int count = 0;
	
	if(cmd.equals("") && h_id.equals("")) 	cmd = "i";
	if(cmd.equals("") && !h_id.equals("")) 	cmd = "ud";
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//새로 입력 받은 아이디가 이미 등록된 아이디인지 확인
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
		alert("<%=user_id%>는 등록된 아이디입니다.");
		parent.form1.id.value = "";
		parent.form1.id.focus();
<%		}else{%>
		alert("<%=user_id%>는 등록 가능한 아이디입니다.");	
<%		}
	}else if(cmd.equals("ud")){
		if(!id.equals("") && !h_id.equals(id)){%>
		alert("<%=user_id%>는 등록된 아이디입니다.");
		parent.form1.id.value = '<%=h_id%>';
		parent.form1.id.focus();
<%		}else{%>
		alert("<%=user_id%>는 등록 가능한 아이디입니다.");	
<%		}
	}%>
</script>

<br><%=cmd%>
<br><%=id%>
<br><%=h_id%>
</body>
</html>