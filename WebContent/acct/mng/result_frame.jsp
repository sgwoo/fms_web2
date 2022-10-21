<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ include file="/acct/cookies.jsp" %>


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");


	String gubun1 	= request.getParameter("gubun1") ==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2") ==null?"":request.getParameter("gubun2");
	
%> 

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="100, *" border=0>
	<FRAME SRC="result_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="result_sc.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10"></FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
