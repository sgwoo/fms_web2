<%@ page language="java" import="java.util.*, acar.util.*" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height+10;
%>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String gubun1 = request.getParameter("gubun1")==null?"0":request.getParameter("gubun1");
%>
<frameset rows="<%=height%>, *" border=1>
  <frame src="/acar/bank_mng/bank_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&sh_height=<%=height%>&bank_id=<%=bank_id%>&gubun1=<%=gubun1%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
  <frame src="/acar/bank_mng/bank_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&sh_height=<%=height%>&bank_id=<%=bank_id%>&gubun1=<%=gubun1%>" name="c_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>