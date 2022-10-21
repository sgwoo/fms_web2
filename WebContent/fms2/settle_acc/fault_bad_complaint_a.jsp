<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.inside_bank.*, acar.accid.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String accid_id 	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");

	boolean result = false;
	AccidDatabase as_db = AccidDatabase.getInstance();
	
/* 	System.out.println(car_mng_id);
	System.out.println(accid_id); */
	
	//result = as_db.deleteAccidSuit(car_mng_id, accid_id);
	
	
	result = d_db.deleteDocSettleAccidSuit(car_mng_id, accid_id);
	
	
	

%>

<script>
	var result = '<%=result%>';
	var gubun1 = '<%=gubun1%>';

	if(result){
		alert("삭제가 완료 되었습니다.");
		location.href= "fault_bad_complaint_sc_in.jsp?gubun1="+gubun1;   


	}else{
		alert("삭제가 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		location.href= "fault_bad_complaint_sc_in.jsp?gubun1="+gubun1;   
	}
</script>

</body>
</html>