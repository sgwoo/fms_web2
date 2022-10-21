<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<jsp:useBean id="bc_bean" class="acar.off_anc.BbsCommentBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//공지사항 댓글 등록 페이지
		
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int bbs_id 		= request.getParameter("bbs_id")==null?0:Util.parseInt(request.getParameter("bbs_id"));
	String acar_id 	= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String comment 	= request.getParameter("comment")==null?"":request.getParameter("comment");
	String user_id	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String bbs_st	= request.getParameter("bbs_st")==null?"":request.getParameter("bbs_st");
	String com_st	= request.getParameter("com_st")==null?"":request.getParameter("com_st");
	
	int count = 0;
	
		
	OffAncDatabase oad = OffAncDatabase.getInstance();

	bc_bean.setBbs_id(bbs_id);
	bc_bean.setReg_id(acar_id);
	bc_bean.setContent(comment);
	bc_bean.setCom_st(com_st);
	//System.out.println("acar_id: "+acar_id);
	count = oad.insertBbsComment(bc_bean);
%>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">  
	<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
	<input type="hidden" name="com_st" value="<%=com_st%>">
	<input type="hidden" name="acar_id" value="<%=acar_id%>">
	<input type="hidden" name="com" value="">
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==1){%>
	alert("정상적으로 등록되었습니다.");
	<%if(bbs_st.equals("5")){%>
	fm.action='./anc_c2.jsp';
	<%}else{%>
	fm.action='./anc_se_c.jsp';
	<%}%>
	fm.target='AncDisp';
//	fm.target='d_content';
	fm.submit();					
<%	}else{%>
	alert("등록 오류입니다.");
<%	}%>
//-->
</script>
</body>
</html>
