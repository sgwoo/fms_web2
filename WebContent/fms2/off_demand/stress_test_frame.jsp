<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int sh_height = sh_line_height*4;
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=sh_height%>, *" border=0>
 	<FRAME SRC="./stress_test_sh.jsp" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>
 	<FRAME SRC="/acar/menu/about_blank.jsp" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="yes"> 		
</FRAMESET>
<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>