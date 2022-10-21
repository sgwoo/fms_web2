<%@ page language="java" import="java.util.*" contentType="text/html;charset=euc-kr" %>
<HTML>
<HEAD>
<TITLE>  </TITLE>
</HEAD>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String fee_tm = request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 = request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
%>
<%
%>
<frameset rows="*" border=1>
        <frame src="memo_sh.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&fee_tm=<%=fee_tm%>&tm_st1=<%=tm_st1%>&bus_id2=<%=bus_id2%>" name="p_head" marginwidth=10 marginheight=10 scrolling="auto" noresize>
</frameset>
</HTML>