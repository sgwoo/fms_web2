<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
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

	var window_name;
	
	if(<%=user_id%> == '000050'){
		today = new Date();
		window_name = today.getTime();
	}

	var SUBWIN = '';
	<% if ( cool.equals("Y")   ) {%>
		SUBWIN="/acar/menu/cool_frame.jsp";
	<% } else {%>
		SUBWIN="/acar/menu/emp_frame.jsp";
	<% } %>
	
	newwin=window.open("","EMP"+window_name,"scrollbars=yes, status=yes");
	if (document.all){
		newwin.moveTo(0,0);
		newwin.resizeTo(screen.width,screen.height-50);
	}
	newwin.location=SUBWIN;

	top.window.close();

<%	}%>

</script>
</body>
</html>