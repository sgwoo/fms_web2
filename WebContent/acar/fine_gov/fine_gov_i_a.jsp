<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
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
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
		
%>

<%
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	String gov_nm = request.getParameter("gov_nm")==null?"":request.getParameter("gov_nm");
	
	int count = 0;
	boolean flag = true;
	
	//기관명 중복체크하기
	if(gov_id.equals("")){
		count = FineDocDb.getFineGovNmChk(gov_nm);
	}
	
	if(count == 0){
		FineGovBn = FineDocDb.getFineGov(gov_id);
		
		FineGovBn.setGov_nm		(gov_nm);
		FineGovBn.setMng_dept	(request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept"));
		FineGovBn.setTel		(request.getParameter("tel")==null?"":request.getParameter("tel"));
		FineGovBn.setFax		(request.getParameter("fax")==null?"":request.getParameter("fax"));
		FineGovBn.setZip		(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
		FineGovBn.setAddr		(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
		FineGovBn.setGov_st		(request.getParameter("gov_st")==null?"":request.getParameter("gov_st"));
		FineGovBn.setMng_nm		(request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm"));
		FineGovBn.setMng_pos	(request.getParameter("mng_pos")==null?"":request.getParameter("mng_pos"));
		FineGovBn.setVen_code	(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
		FineGovBn.setVen_name	(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
		FineGovBn.setUse_yn		(request.getParameter("use_yn")==null?"":request.getParameter("use_yn"));
		FineGovBn.setGov_nm2	(request.getParameter("gov_nm2")==null?"":request.getParameter("gov_nm2"));
		FineGovBn.setGov_dept_code	(request.getParameter("gov_dept_code")==null?"":request.getParameter("gov_dept_code"));
		
		if(gov_id.equals("")){//등록
			flag = FineDocDb.insertFineGov(FineGovBn);
		}else{//수정
			flag = FineDocDb.updateFineGov(FineGovBn);
		}
	}
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
<%	if(count == 0){%>
<%		if(flag==true){%>
			alert("정상적으로 처리되었습니다.");
			<%if(from_page.equals("/fms2/pay_mng/off_list.jsp")){%>
				parent.opener.location.reload();
				parent.window.close();
			<%}else{%>
				<%if(gov_id.equals("")){//등록%>
				parent.opener.document.form1.submit();
				<%}else{//수정%>		
				parent.opener.location.reload();
				<%}%>				
				parent.window.close();
			<%}%>
<%		}else{%>
			alert("에러발생!");
<%		}%>
<%	}else{%>
			alert("중복된 데이타입니다. 확인하십시오.");
			parent.document.form1.gov_nm.focus();
<%	}%>
</script>
</body>
</html>

