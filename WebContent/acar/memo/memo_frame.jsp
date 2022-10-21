<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean = umd.getUsersBean(user_id);
	String user_pos = user_bean.getUser_pos();
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="40, *" border=0>
	<FRAME SRC="memo_sh.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>" name="c_head" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
<%//	if(user_pos.equals("사원")){
//		if(cmd.equals("new")){//메모보기%>
<!--	<FRAME SRC="memo_t_c.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>-->
<%//		}else{//받은메모함%>
	<FRAME SRC="memo_t_sc.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>" name="c_body" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
<%//		}
//	}else{//보낸메모함%>
<!--	<FRAME SRC="memo_f_sc.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>" name="c_body" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">-->
<%//	}%>
	<FRAME SRC="about:blank" name="display_no" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>