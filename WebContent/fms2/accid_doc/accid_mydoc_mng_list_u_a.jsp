<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String doc_id 		= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq_no 		= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	
	boolean flag = true;
%>

<%
	//과태료리스트
	FineDocListBn = FineDocDb.getAccidMyDocList(doc_id, car_mng_id, seq_no);
	
	FineDocListBn.setPaid_no		(request.getParameter("paid_no")==null?"":request.getParameter("paid_no"));
	FineDocListBn.setFirm_nm		(request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm"));
	FineDocListBn.setSsn			(request.getParameter("ssn")==null?"":request.getParameter("ssn"));
	FineDocListBn.setEnp_no			(request.getParameter("enp_no")==null?"":request.getParameter("enp_no"));
	FineDocListBn.setCar_no			(request.getParameter("car_no")==null?"":request.getParameter("car_no"));
	FineDocListBn.setRent_start_dt	(request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt"));
	FineDocListBn.setRent_end_dt	(request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt"));
	FineDocListBn.setVar3			(request.getParameter("car_nm")==null?"":request.getParameter("car_nm"));
	FineDocListBn.setVar2			(request.getParameter("use_day")==null?"":request.getParameter("use_day"));
	FineDocListBn.setAmt1			(request.getParameter("amt1")==null?0:AddUtil.parseDigit(request.getParameter("amt1")));  //청구액
	
	flag = FineDocDb.updateAccidMyDocListCase(FineDocListBn);
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
<%		if(flag){%>
			alert("정상적으로 처리되었습니다.");
			parent.opener.location.reload();			
<%		}else{%>
			alert("에러발생!");
<%		}%>
</script>
</body>
</html>



