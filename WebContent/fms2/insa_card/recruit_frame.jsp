<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	sh_height = sh_line_height*3;
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=sh_height%>, *" border=0>
 	<FRAME SRC="./recruit_sh.jsp<%=hidden_value%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>	
	<FRAME SRC="./recruit_comInfo_sc.jsp<%=hidden_value%>" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
