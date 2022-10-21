<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<HTML>
<HEAD>
<TITLE>  </TITLE>
</HEAD>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String prop_id = request.getParameter("prop_id")==null?"":request.getParameter("prop_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String re_seq = request.getParameter("re_seq")==null?"":request.getParameter("re_seq");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");

%>
<frameset rows="250,*" border=0>
        <frame src="c_eval_sh.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_id=<%=prop_id%>&seq=<%=seq%>&re_seq=<%=re_seq%>&user_id=<%=user_id%>" name="p_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="c_eval_sc.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_id=<%=prop_id%>&seq=<%=seq%>&re_seq=<%=re_seq%>&user_id=<%=user_id%>" name="p_foot" marginwidth=10 marginheight=10 scrolling="no">
</frameset>

</HTML>