<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"1":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String s_est_y = request.getParameter("s_est_y")==null?"":request.getParameter("s_est_y");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String f_list = request.getParameter("f_list")==null?"pay":request.getParameter("f_list");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	if(s_est_y.equals("")) s_est_y = AddUtil.getDate(1);
	
	if(mode.equals("")){
%>
<frameset rows="80,*" border=1>
        <frame src="/acar/con_tax/stat_tax_sh.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=seq_no%>&f_list=<%=f_list%>&s_brch=<%=s_brch%>&s_est_y=<%=s_est_y%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="/acar/con_tax/stat_tax_sc.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=seq_no%>&f_list=<%=f_list%>&s_brch=<%=s_brch%>&s_est_y=<%=s_est_y%>" name="c_body" marginwidth=10 marginheight=10 scrolling="no">
</frameset>
<%	}else{%>
<frameset rows="*,0" border=1>
        <frame src="/acar/con_tax/stat_tax_c.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=seq_no%>&f_list=<%=f_list%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="about:blank" name="c_body" marginwidth=10 marginheight=10 scrolling="no">
</frameset>
<% 	}	%>
</HTML>
