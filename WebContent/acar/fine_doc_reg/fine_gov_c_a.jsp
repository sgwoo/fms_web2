<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" scope="page" class="acar.forfeit_mng.FineGovBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
		
%>

<%
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");	
	
	int count = 0;
	boolean flag = true;
	
	//이의신청골문발송대장 수신처 상세
	FineGovBn = FineDocDb.getFineGov(gov_id);
	
	FineGovBn.setGov_id    (request.getParameter("gov_id")==null?"":request.getParameter("gov_id"));
	FineGovBn.setGov_nm2   (request.getParameter("gov_nm2")==null?"":request.getParameter("gov_nm2"));
	FineGovBn.setGov_dept_code(request.getParameter("gov_dept_code")==null?"":request.getParameter("gov_dept_code"));
	
	flag = FineDocDb.updateFineGovNm2(FineGovBn);
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
<%		if(flag==true){%>
			alert("정상적으로 처리되었습니다.");
			parent.opener.location.reload();
			parent.window.close();
<%		}else{%>
			alert("에러발생!");
<%		}%>
</script>
</body>
</html>

