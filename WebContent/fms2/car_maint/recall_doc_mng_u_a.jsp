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
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String yn = request.getParameter("yn")==null?"":request.getParameter("yn");
	
		
%>

<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	int count = 0;
	boolean flag = true;
		

	//이의신청공문 테이블
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineDocBn.setDoc_dt		(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));
	FineDocBn.setPrint_dt		(request.getParameter("print_dt")==null?"":request.getParameter("print_dt"));
	FineDocBn.setF_reason		(request.getParameter("f_reason")==null?"":request.getParameter("f_reason"));
	FineDocBn.setF_result		(request.getParameter("f_result")==null?"":request.getParameter("f_result"));	
	FineDocBn.setReg_id		(request.getParameter("reg_id")==null?"":request.getParameter("reg_id"));
	FineDocBn.setPrint_id		(request.getParameter("print_id")==null?"":request.getParameter("print_id"));
	FineDocBn.setH_mng_id		(request.getParameter("h_mng_id")==null?"":request.getParameter("h_mng_id"));
	FineDocBn.setB_mng_id		(request.getParameter("b_mng_id")==null?"":request.getParameter("b_mng_id"));
	FineDocBn.setGov_id		(gov_id);	
	
	FineDocBn.setMng_pos		(request.getParameter("code")==null?"":request.getParameter("code"));
	FineDocBn.setMng_nm		(request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm"));
	FineDocBn.setGov_st		(request.getParameter("gov_st")==null?"":request.getParameter("gov_st"));   //대상구분
	FineDocBn.setS_dt		(request.getParameter("s_dt")==null?"":request.getParameter("s_dt"));   //개시일(제조일자)
	FineDocBn.setE_dt		(request.getParameter("e_dt")==null?"":request.getParameter("e_dt"));   //종료일(제조일자)
	FineDocBn.setIp_dt		(request.getParameter("ip_dt")==null?"":request.getParameter("ip_dt"));   //시행기간
	FineDocBn.setEnd_dt		(request.getParameter("end_dt")==null?"":request.getParameter("end_dt"));   //시행기간
		
	FineDocBn.setMng_dept	(request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept"));
	FineDocBn.setTitle	(request.getParameter("title")==null?"":request.getParameter("title"));
	FineDocBn.setRemarks	(request.getParameter("remarks")==null?"":request.getParameter("remarks"));
						
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
<%if(cmd.equals("y")||cmd.equals("d")){%>
	alert("정상적으로 처리되었습니다.");

	parent.window.close();
<%}else{%>
<%		if(flag==true){%>
			alert("정상적으로 처리되었습니다.");
			parent.opener.location.reload();
			parent.window.close();	
<%		}else{%>
			alert("에러발생!");
<%		}%>
<%}%>
</script>
</body>
</html>

