<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.SimpleDateFormat"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String reg_code = request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String file_seq = request.getParameter("file_seq")==null?"":request.getParameter("file_seq");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
	boolean result = false;
	result = ic_db.deleteInsExcelCom2(reg_code, seq);
	
%>

<html>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<script>
	var result = '<%=result%>';
	var gubun2 = '<%=gubun2%>';
	var gubun3 = '<%=gubun3%>';
	var st_dt = '<%=st_dt%>';
	var end_dt = '<%=end_dt%>';
	
	if(result){
		alert("삭제가 완료 되었습니다.");
		location.href= "ins_com_filereq_sc_in.jsp?gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt;   
	}else{
		alert("삭제가 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		location.href= "ins_com_filereq_sc_in.jsp?gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt;   
	}
	
</script>


<body>

</body>

