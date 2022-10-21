<%@ page language="java" import="java.util.*" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String tm_st = request.getParameter("tm_st")==null?"":request.getParameter("tm_st");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
%>
<frameset rows="250,*" border=0>
        <frame src="/acar/con_ins_m/ins_memo_sh.jsp?auth_rw=<%=auth_rw%>&tm_st=<%=tm_st%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=serv_id%>&mng_id=<%=mng_id%>" name="p_head" marginwidth=10 marginheight=10 scrolling="auto" noresize>
		<frame src="/acar/con_ins_m/ins_memo_sc.jsp?auth_rw=<%=auth_rw%>&tm_st=<%=tm_st%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=serv_id%>&mng_id=<%=mng_id%>" name="p_foot" marginwidth=10 marginheight=10 scrolling="auto" noresize>
</frameset>
</HTML>