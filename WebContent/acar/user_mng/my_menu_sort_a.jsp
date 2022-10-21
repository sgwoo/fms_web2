<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String m_st = request.getParameter("m_st")==null?"":request.getParameter("m_st");
	String m_st2 = request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_cd = request.getParameter("m_cd")==null?"":request.getParameter("m_cd");
	String cmd = request.getParameter("cmd")==null?"u":request.getParameter("cmd");
	int size = request.getParameter("size")==null?1:AddUtil.parseInt(request.getParameter("size"));
	
	int count = 0;
	
	String seq[] = request.getParameterValues("seq");
	String sort[] = request.getParameterValues("sort");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	for(int i=0; i<size; i++){
		count = nm_db.updateMyMenu(user_id, AddUtil.parseInt(seq[i]), AddUtil.parseInt(sort[i]));
	}
%>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body bgcolor="#FFFFFF" text="#000000">
<script language='javascript'>
<%	if(count == 0){	%>
		alert('에러입니다.');
		location='about:blank';
<%	}else{%>
		alert("수정되었습니다");
		parent.window.close();
		parent.opener.location.reload();
<%	}	%>
</script>
</body>
</html>
