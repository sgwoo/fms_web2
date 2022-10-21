<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height+15;

%>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String shed_st 	= request.getParameter("shed_st")	==null?"":request.getParameter("shed_st");
	String brch 		= request.getParameter("brch")		==null?"":request.getParameter("brch");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	
	if(gubun1.equals("")){		gubun1 = "1";		}	
	
%>
<frameset rows="<%=height%>, *" border=0>
	<frame src="/acar/car_shed/cshed_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>&gubun1=<%=gubun1%>&shed_st=<%=shed_st%>&sh_height=<%=height%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
	<frame src="/acar/car_shed/cshed_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>&gubun1=<%=gubun1%>&shed_st=<%=shed_st%>&sh_height=<%=height%>" name="c_body" marginwidth=10 topmargin=0 marginheight=10 scrolling="auto">
</frameset>
</HTML>
