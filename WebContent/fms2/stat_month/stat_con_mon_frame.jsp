<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 2; //�˻� ���μ�
	int height = cnt*sh_line_height+25;

%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
%> 

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./stat_con_mon_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./stat_con_mon_sc_d.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10" style="padding-left: 15px;">
</FRAMESET>
<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
