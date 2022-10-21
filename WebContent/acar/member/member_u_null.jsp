<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, cust.member.*"%>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String chk_st = request.getParameter("chk_st")==null?"":request.getParameter("chk_st");
	
	String pwd = request.getParameter("pwd")==null?"":request.getParameter("pwd");
	String email = request.getParameter("email")==null?"":request.getParameter("email");
	int count = 0;
	
	//회원정보 수정
	MemberBean bean = m_db.getMemberCase(client_id, r_site, member_id);
	bean.setPwd(pwd);
	bean.setEmail(email);
	count = m_db.updateMember(bean);
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(count == 1){%>			
		alert("회원정보가 수정 되었습니다.");
		parent.opener.location.href = "member_c.jsp?member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&auth_rw=<%=auth_rw%>";
		parent.self.close();
		parent.window.close();				
<%	}else{%>
	alert("수정 오류!!");
<%	}%>
//-->
</script>
</body>
</html>
