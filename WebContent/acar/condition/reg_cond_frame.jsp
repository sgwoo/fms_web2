<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 2; //�˻� ���μ�
	int height = cnt*sh_line_height+20;

%>
<%
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");

%> 

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
 <FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./reg_cond_sh.jsp?sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./reg_cond_sc.jsp?auth_rw=<%=auth_rw%>&sh_height=<%=height%>" name="c_foot" frameborder=0  topmargin=0 marginwidth="10" scrolling="auto">
</FRAMESET> 

<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
