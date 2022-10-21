<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height+30;
%>
<%
	String auth_rw = "";
	String gubun = "";
	String gubun_nm = "";
	String st = "0";
	String dt = "1";
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();

	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun") != null)	gubun= request.getParameter("gubun");
	if(request.getParameter("gubun_nm") != null)	gubun_nm= request.getParameter("gubun_nm");
	if(request.getParameter("st") != null)	st = request.getParameter("st");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./exp_s_sh.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&st=<%=st%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./exp_s_sc.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&st=<%=st%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&sh_height=<%=height%>" name="c_foot" frameborder=0  topmargin=0 marginwidth="10" scrolling="no">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>

