<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //�˻� ���μ�
	int height = cnt*sh_line_height-20;
%>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");

	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "13", "01", "02");
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./free_time_sh.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&auth_rw=<%=auth_rw%>&sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./free_time_sc.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&auth_rw=<%=auth_rw%>&sh_height=<%=height%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=10 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
