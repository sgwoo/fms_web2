<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.partner.*"%>


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String yn		= request.getParameter("yn")==null?"":request.getParameter("yn");
	
	String form		= request.getParameter("form")==null?"":request.getParameter("form");
	String valus	= request.getParameter("valus")==null?"2":request.getParameter("valus");
	
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	String mon_amt = request.getParameter("mon_amt")==null?"":request.getParameter("mon_amt");	
	String save_dt  = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	
	int count = 0;
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	if(yn.equals("Y")){
		count = se_dt.update_email_yn(off_id, seq, "N");
	}else{
		count = se_dt.update_email_yn(off_id, seq, "Y");
	}

%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<script language="JavaScript">
<!--
function go_parent_list(){
		var fm = document.form1;
		fm.action = "./servemp_d_frame.jsp";
		fm.target='d_content';
		fm.submit();
	}

//-->
</script>
<body>
<form name='form1' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="form" value="<%=form%>">
<input type="hidden" name="off_id" value="<%=off_id%>">
<input type="hidden" name="cpt_cd" value="<%=cpt_cd%>">
<input type="hidden" name="mon_amt" value="<%=mon_amt%>">
<input type="hidden" name="save_dt" value="<%=save_dt%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
</form>

<script language="JavaScript">
<!--
var fm = document.form1;
<%if(count >= 1){%>
	alert("완료처리 되었습니다.");
		//parent.parent.opener.document.location.reload();
		
		go_parent_list();
	
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%}%>
//-->
</script>

</body>
</html>
