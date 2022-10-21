<%@ page language="java" import="java.util.*" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun1		= request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 		= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc 			= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String mode 		= request.getParameter("mode")	==null?"":request.getParameter("mode");
	
	if(mode.equals("")){
%>
<frameset rows="80,*" border=1>
        <frame src="/fms2/con_fee/fee_sh.jsp?auth_rw=<%=auth_rw%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="/fms2/con_fee/fee_sc.jsp?auth_rw=<%=auth_rw%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="c_body" marginwidth=10 marginheight=10 scrolling="no">
</frameset>
<%	}else{
		String m_id = request.getParameter("m_id")	==null?"":request.getParameter("m_id");
		String l_cd = request.getParameter("l_cd")	==null?"":request.getParameter("l_cd");
		String c_id = request.getParameter("c_id")	==null?"":request.getParameter("c_id");
		String link = "";
		if(auth_rw.equals("F")) link="mgr";
		else if(auth_rw.equals("R/W")) link="adm";
		else link="read";
%>
<frameset rows="*,0" border=1>
        <frame src="/fms2/con_fee/fee_c_<%=link%>.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="about:blank" name="c_body" marginwidth=10 marginheight=10 scrolling="no">
</frameset>
<% 	}	%>
</HTML>
