<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ include file="/acar/cookies.jsp" %>
<%
	int cnt = 2; //�˻� ���μ�
	int height = cnt*sh_line_height-10;

%>
<%
	String auth_rw = "";
	String off_id = "";
	String user_id = "";
		
	if(request.getParameter("auth_rw") != null)		auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("off_id") != null)		off_id = request.getParameter("off_id");
	if(request.getParameter("user_id") != null)		user_id = request.getParameter("user_id");
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="*" border=0>
	<%-- <FRAME SRC="./cus0605_ds_sh.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>&sh_height=<%=height%>" name="dsc_head" frameborder=0  marginwidth="10" topmargin=0 scrolling="no" noresize> --%>
	<FRAME SRC="./cus0605_ds_sc.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>&user_id=<%=user_id%>&sh_height=<%=height%>" name="dsc_body" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>