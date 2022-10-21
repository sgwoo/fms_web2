<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String s_rtn 	= request.getParameter("s_rtn")==null?"":request.getParameter("s_rtn");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String cont_bn = request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String lend_int = request.getParameter("lend_int")==null?"":request.getParameter("lend_int");
	String max_cltr_rat = request.getParameter("max_cltr_rat")==null?"":request.getParameter("max_cltr_rat");
	String rtn_st = request.getParameter("rtn_st")==null?"":request.getParameter("rtn_st");
	String lend_amt_lim = request.getParameter("lend_amt_lim")==null?"":request.getParameter("lend_amt_lim");
	String rtn_size = request.getParameter("rtn_size")==null?"":request.getParameter("rtn_size");
%>
<frameset rows="70,*" border=1>
	<frame src="bank_mapping_sh.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_rtn=<%=s_rtn%>&gubun=<%=gubun%>&lend_id=<%=lend_id%>&cont_bn=<%=cont_bn%>&lend_int=<%=lend_int%>&max_cltr_rat=<%=max_cltr_rat%>&rtn_st=<%=rtn_st%>&lend_amt_lim=<%=lend_amt_lim%>&rtn_size=<%=rtn_size%>" name="p_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
	<%if(gubun.equals("reg") && t_wd.equals("")){%>
	<frame src="about:blank" name="p_foot" marginwidth=10 marginheight=10 scrolling="auto">
	<%}else{%>
	<frame src="bank_mapping_sc.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_rtn=<%=s_rtn%>&gubun=<%=gubun%>&lend_id=<%=lend_id%>&cont_bn=<%=cont_bn%>&lend_int=<%=lend_int%>&max_cltr_rat=<%=max_cltr_rat%>&rtn_st=<%=rtn_st%>&lend_amt_lim=<%=lend_amt_lim%>&rtn_size=<%=rtn_size%>" name="p_foot" marginwidth=10 marginheight=10 scrolling="auto">	
	<%}%>
</frameset>
</HTML>
