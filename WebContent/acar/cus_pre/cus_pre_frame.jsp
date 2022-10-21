<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = cnt*sh_line_height;

%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
%>

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border="0">
	<FRAME SRC="./cus_pre_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&sh_height=<%=height%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="c_head" frameborder="0" marginwidth="10" marginheight="10" scrolling="no" noresize>
	<%if(cmd.equals("pre")){%>
	<FRAME SRC="./cus_pre_sc.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&sh_height=<%=height%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="c_body" frameborder="0" marginwidth="10" marginheight="10" topmargin="0" scrolling="auto">
	<%}else{%>
	<FRAME SRC="./cus_pre_sc_gs.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&sh_height=<%=height%>" name="c_body" frameborder="0" marginwidth="10" marginheight="10" topmargin="0" scrolling="auto">
	<%}%>
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
