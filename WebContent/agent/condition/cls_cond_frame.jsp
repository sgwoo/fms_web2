<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ include file="/agent/cookies.jsp" %>
<%@ include file="/agent/access_log.jsp" %>
<%
	int cnt = 2; //�˻� ���μ�
	int height = cnt*sh_line_height+15;
%>
<%

%> 

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./cls_cond_sh.jsp?sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./cls_cond_sc.jsp?sh_height=<%=height%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
