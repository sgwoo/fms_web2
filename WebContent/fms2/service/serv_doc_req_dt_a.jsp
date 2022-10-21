<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.cus_reg.*, acar.user_mng.*"%>

<%@ include file="/acar/cookies.jsp" %> 

<html><head><title>FMS</title>
</head>
<body>
<%
//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
		
	String req_code = request.getParameter("req_code")==null?"":request.getParameter("req_code");
	String jung_dt = request.getParameter("jung_dt")==null?"":request.getParameter("jung_dt");  //service의 set_dt
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
		
	int flag = 0;	
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
			
	//정산일 변경 
	if(!cr_db.updateServiceJungDt(req_code, user_id, jung_dt))	flag += 1; //선수금정산
		
%>
<form name='form1' action='' target='d_content' method="POST">

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//  실패%>

	alert('등록 오류발생!');

<%	}else{ 			// 성공.. %>
	
    alert('처리되었습니다');
	parent.window.close();
	parent.opener.location.reload();
<%	
	} %>
</script>
</body>
</html>
