<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
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
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
		
%>

<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	
	int count = 0;
	boolean flag = true;
	
	//공문 테이블
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineDocBn.setDoc_dt		(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));
	FineDocBn.setGov_id		(request.getParameter("gov_id")==null?"":request.getParameter("gov_id"));
	FineDocBn.setMng_dept	(request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept"));
	FineDocBn.setUpd_id		(user_id);
	FineDocBn.setGov_st		(request.getParameter("gov_st")==null?"":request.getParameter("gov_st"));
	FineDocBn.setMng_nm		(request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm"));
	FineDocBn.setMng_pos	(request.getParameter("mng_pos")==null?"":request.getParameter("mng_pos"));
	FineDocBn.setH_mng_id	(request.getParameter("h_mng_id")==null?"":request.getParameter("h_mng_id"));
	FineDocBn.setB_mng_id	(request.getParameter("b_mng_id")==null?"":request.getParameter("b_mng_id"));
	FineDocBn.setApp_doc1	(request.getParameter("app_doc1")==null?"N":request.getParameter("app_doc1"));
	FineDocBn.setApp_doc2	(request.getParameter("app_doc2")==null?"N":request.getParameter("app_doc2"));
	FineDocBn.setApp_doc3	(request.getParameter("app_doc3")==null?"N":request.getParameter("app_doc3"));
	FineDocBn.setApp_doc4	(request.getParameter("app_doc4")==null?"N":request.getParameter("app_doc4"));
	FineDocBn.setPost_num	(request.getParameter("post_num")==null?"":request.getParameter("post_num"));
	FineDocBn.setH_mng_id	(request.getParameter("h_mng_id")==null?"":request.getParameter("h_mng_id"));
	FineDocBn.setB_mng_id	(request.getParameter("b_mng_id")==null?"":request.getParameter("b_mng_id"));
	
	String app_doc4 	= request.getParameter("app_doc4")==null?"N":request.getParameter("app_doc4");//첨부문서
	String app_doc5 	= request.getParameter("app_doc5")==null?"N":request.getParameter("app_doc5");//첨부문서
	String app_doc6 	= request.getParameter("app_doc6")==null?"N":request.getParameter("app_doc6");//첨부문서
	String app_doc7 	= request.getParameter("app_doc7")==null?"N":request.getParameter("app_doc7");//첨부문서
	String app_doc8 	= request.getParameter("app_doc8")==null?"N":request.getParameter("app_doc8");//첨부문서
	String app_doc9 	= request.getParameter("app_doc9")==null?"N":request.getParameter("app_doc9");//첨부문서
	String app_doc10 	= request.getParameter("app_doc10")==null?"N":request.getParameter("app_doc10");//첨부문서
	String app_doc11 	= request.getParameter("app_doc11")==null?"N":request.getParameter("app_doc11");//첨부문서
	
	String app_docs = "^Y^Y^Y^"+app_doc4+"^"+app_doc5+"^"+app_doc6+"^"+app_doc7+"^"+app_doc8+"^"+app_doc9+"^"+app_doc10+"^"+app_doc11;
	FineDocBn.setApp_docs	(app_docs);//대여청구 첨부문서
	
	flag = FineDocDb.updateFineDoc(FineDocBn);
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

