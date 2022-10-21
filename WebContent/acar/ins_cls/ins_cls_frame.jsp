<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	auth_rw = rs_db.getAuthRw(user_id, "09", "19");	
%> 
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="80, *" border=0>
	<FRAME SRC="./ins_cls_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&c_id=<%=c_id%>&ins_st=<%=ins_st%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>
	<%if(c_id.equals("")){%>
 	<FRAME SRC="./ins_cls_help.jsp" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10" marginheight="10">
	<%}else{%>
 	<FRAME SRC="./ins_cls_sc.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&c_id=<%=c_id%>&ins_st=<%=ins_st%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10" marginheight="10">	
	<%}%>	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
