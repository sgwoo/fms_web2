<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 5; //검색 라인수
	int height = cnt*sh_line_height+30;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String t_wd1 	= request.getParameter("t_wd1")==null?"":request.getParameter("t_wd1");
	String t_wd2 	= request.getParameter("t_wd2")==null?"":request.getParameter("t_wd2");
	String t_wd3 	= request.getParameter("t_wd3")==null?"":request.getParameter("t_wd3");
	String t_wd4 	= request.getParameter("t_wd4")==null?"":request.getParameter("t_wd4");
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&t_wd3="+t_wd3+"&t_wd4="+t_wd4+
					"&m_id="+m_id+"&l_cd="+l_cd+
				   	"&sh_height="+height+"";	
%>
<frameset rows="<%=height%>,*" border=1>
    <frame src="/fms2/con_fee/fee_scd_account_allpay_sh.jsp<%=valus%>" name="p_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
    <frame src="/fms2/con_fee/fee_scd_account_allpay_sc.jsp<%=valus%>" name="p_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>
