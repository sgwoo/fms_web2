<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.car_register.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String dt	= request.getParameter("dt")==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String gubun1	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	String sa_no 	= request.getParameter("sa_no")==null?"":request.getParameter("sa_no");
	String c_yy 	= request.getParameter("c_yy")==null?"":request.getParameter("c_yy");
	String form		= request.getParameter("form")==null?"":request.getParameter("form");
	
	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String valus	= request.getParameter("valus")==null?"2":request.getParameter("valus");
	
	int count = 0;
	
	if(cmd.equals("del")){
		count = ac_db.updateEnd_dt_cancel(c_yy, sa_no);
	}else{
		count = ac_db.updateEnd_dt(c_yy, sa_no);
	}

%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<script language="JavaScript">
<!--
	function go_parent(<%=form%>){
		var fm = document.form1;
		fm.action = "<%=form%>";
		fm.target = '_parent';
		fm.submit();
	}

//-->
</script>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type="hidden" name="form" value="<%=form%>">
<input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
<input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
<input type='hidden' name='valus' 	value='<%=valus%>'>
<input type='hidden' name='dt' value='<%=dt%>'> 
<input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'> 
<input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'> 
</form>
<body>
<script language="JavaScript">
<!--
<%if(count >= 1){%>
	alert("완료처리 되었습니다.");
	var fm = document.form1;
		fm.action = "<%=form%>";
		fm.target = '_parent';
		fm.submit();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%}%>
//-->
</script>
</body>
</html>
