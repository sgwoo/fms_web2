<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="j_db" scope="page" class="card.JungSanDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
     
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String sort		= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String make		= request.getParameter("make")==null?"":request.getParameter("make");
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");		
	String dept_nm = "";

	int vt_size2 = 0;
	
	//procedure 호출
	if ( make.equals("Y")) {
    	j_db.call_sp_oil_jungsanNew(dt, ref_dt1, ref_dt2, ck_acar_id);
	}
	     
%>	 	


<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' method="POST">
<input type='hidden' name='mode' value=''>
</form>
<script language="JavaScript">
	var fm = document.form1;
	 alert('처리되었습니다');
</script>
</body>
</html>

