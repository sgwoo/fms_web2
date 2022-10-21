<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
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
	String cmd = request.getParameter("cmd")==null?"m":request.getParameter("cmd");
	if(cmd.equals(""))	cmd = "m";
	
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUsersBean(user_id);
	
	if(dept_id.equals("")){
		dept_id = user_bean.getDept_id();
		
		if(dept_id.equals("0003")) dept_id = "0002";
	}
%>

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border="0">
	<FRAME SRC="./cus_pre_a_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&dept_id=<%=dept_id%>&year=<%=AddUtil.getDate(1)%>&sh_height=<%=height%>" name="c_head" frameborder="0" marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./cus_pre_tg_md.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&dept_id=<%=dept_id%>&cmd=<%=cmd%>&sh_height=<%=height%>" name="c_body" frameborder="0" marginwidth="10" marginheight="10" topmargin="0" scrolling="auto">
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
