<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "11", "02");
			
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
				
	sh_height = sh_line_height*3;
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="<%=sh_height%>, *" border=0>
 	<FRAME SRC="./card_oil_sh.jsp?user_id=<%=user_id%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&sh_height=<%=sh_height%>" name="cd_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>	
	<FRAME SRC="./card_oil_sc.jsp?user_id=<%=user_id%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&sh_height=<%=sh_height%>" name="cd_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
