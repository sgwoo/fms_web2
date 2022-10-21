<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//공지사항 결재	 등록 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int bbs_id 		= request.getParameter("bbs_id")==null?0:Util.parseInt(request.getParameter("bbs_id"));
	String acar_id 	= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String comst	= request.getParameter("comst")==null?"":request.getParameter("comst");


	int count = 0;
	
	
	OffAncDatabase oad = OffAncDatabase.getInstance();

	a_bean.setBbs_id(bbs_id);
	a_bean.setComst(comst);

	count = oad.updateBbsComst(a_bean);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">  
	<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
	<input type="hidden" name="comst" value="<%=comst%>">

	
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==1){%>
	alert("정상적으로 등록되었습니다.");
	fm.action='./anc_se_c.jsp';
	fm.target='AncDisp';
	fm.submit();
//	parent.window.close();
<%	}else{%>
	alert("등록 오류입니다.");
<%	}%>
//-->
</script>
</body>
</html>
