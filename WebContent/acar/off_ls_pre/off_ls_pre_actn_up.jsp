<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_pre.*"%>
<jsp:useBean id="olyD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String actn_id = request.getParameter("id")==null?"":request.getParameter("id");
	String doc_chk = request.getParameter("doc_chk")==null?"":request.getParameter("doc_chk");
	String[] seq = request.getParameterValues("pr");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	String doc_seq = "";
	
	if(seq != null){
		for(int i=0; i<seq.length; i++){
			if( i == (seq.length -1))	doc_seq += seq[i];
			else						doc_seq += seq[i]+"/";
		}
	}
//System.out.println(doc_seq);
	int result = olyD.upDocChk(car_mng_id, doc_chk, doc_seq);

%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result >= 1){
	if(gubun.equals("i")){%>
		alert("등록되었습니다.");
	<%}else if(gubun.equals("u")){%>
		alert("수정되었습니다.");
	<%}%>
	parent.in_doc.location.href = "off_ls_pre_actn_in_doc.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&id=<%=actn_id%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	location.href = "off_ls_pre_actn_in_doc.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&id=<%=actn_id%>";
	window.close();				
<%}%>
//-->
</script>
</body>
</html>
