<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 10; //검색 라인수
	int height = cnt*sh_line_height+10;
%>

<HTML>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<frameset rows="90%, *" border=1>
		<frame src="survey_tot_list_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&sh_height=<%=height%>" name="c_body" marginwidth=10 marginheight=10 scrolling='auto' >
		<!--<frame src="survey_tot_sc.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&sh_height=<%=height%>" name="c_foot" marginwidth=10 marginheight=10 scrolling="auto">-->
</frameset>
</HTML>