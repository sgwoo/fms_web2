<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<script type="text/javascript" src="/include/modalLoading.js" ></script>
		
<%
	
	String m_st 	= request.getParameter("m_st")==null?"13":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")==null?"01":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")==null?"01":request.getParameter("m_cd");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
		
	
%>
<html>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<HEAD>
<TITLE>FMS (109)</TITLE>
<script language=JavaScript>


</script>
</HEAD>
<FRAMESET ROWS="123,*" border=0>
	<FRAME NAME="top_menu"      SRC="emp_top.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=0 marginheight=0 scrolling="no" noresize>
	<FRAMESET cols="185, *" border=0>
		<FRAME name="d_menu"    SRC="emp_menu.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=0 marginheight=0 scrolling="auto" noresize>  
		<FRAME onload="hideBlindLayer();" name="d_content" SRC="amazoncar_main.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=10 marginheight=10 scrolling="auto" noresize>		 	
	</frameset>
</FRAMESET>	
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>