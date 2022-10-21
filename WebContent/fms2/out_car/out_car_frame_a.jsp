<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	int cnt = 3; //검색 라인수
	int height = cnt*sh_line_height+10;

%>
<HTML>
<HEAD>
<TITLE>FMS고현황</TITLE>
</HEAD>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String idx_gubun 	= "A";
%>
<frameset rows="<%=height%>, *" border=1>
        <frame src="/fms2/out_car/out_car_sh_a.jsp?auth_rw=<%=auth_rw%>&sh_height=<%=height%>&user_id=<%=user_id%>&idx_gubun=<%=idx_gubun%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="/fms2/out_car/out_car_sc.jsp?auth_rw=<%=auth_rw%>&sh_height=<%=height%>&user_id=<%=user_id%>&idx_gubun=<%=idx_gubun%>" name="c_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>
