<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String from_page 	= request.getParameter("from_page")==null? "":request.getParameter("from_page");

	UserMngDatabase umd = UserMngDatabase.getInstance();
	String user_id = "";
	String user_psd = "";
	
	String cmd = "";
	int count = 0;
	
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd"); //update, inpsert 구분
	if(request.getParameter("user_id") !=null) user_id = request.getParameter("user_id");
	if(request.getParameter("user_psd_a") !=null) user_psd = request.getParameter("user_psd_a");
	String cool 	= request.getParameter("cool")==null?	"":request.getParameter("cool");

	count = umd.updatePass(user_id,user_psd);
	
	//프로시저 호출
	int flag4 = 0;
	String  d_flag1 =  cm_db.call_sp_sync_db_all();
	System.out.println(d_flag1);
	if (!d_flag1.equals("0")) flag4 = 1;
	System.out.println("비밀번호 변경시 메신저 동기화 프로시저 호출 등록"+ user_id);
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>

<script>
<%	if(count==1){%>

	alert("정상적으로 변경되었습니다.");
	
	var SUBWIN = '';
	
	<%if(from_page.equals("info_u.jsp")){%>

		parent.window.close();

	<%}else{%>
	
		<% if ( cool.equals("Y")   ) {%>
			SUBWIN="/fms2/menu/cool_frame.jsp";
		<% } else {%>
			SUBWIN="/fms2/menu/emp_frame.jsp";
		<% } %>
	
		top.window.opener.location.href = SUBWIN;	
		top.window.close();
	
	<% } %>	

<%	}%>

</script>
</body>
</html>