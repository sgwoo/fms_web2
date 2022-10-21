<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ include file="/acar/cookies.jsp" %>
<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height-10;

%>
<%
	String auth_rw = "";
	String off_id = "";
	String cpt_cd = "";
	String mon_amt = "";
	String save_dt = "";
	String gubun1 = "";
		
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("off_id") != null)	off_id = request.getParameter("off_id");
	if(request.getParameter("cpt_cd") != null)	cpt_cd = request.getParameter("cpt_cd");
	if(request.getParameter("mon_amt") != null)	mon_amt = request.getParameter("mon_amt");
	if(request.getParameter("save_dt") != null)	save_dt = request.getParameter("save_dt");
	if(request.getParameter("gubun1") != null)	gubun1 = request.getParameter("gubun1");
	
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./servemp_ds_sh.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>&cpt_cd=<%=cpt_cd%>&sh_height=<%=height%>&mon_amt=<%=mon_amt%>&save_dt=<%=save_dt%>&gubun1=<%=gubun1%>" name="dsc_head" frameborder=0  marginwidth="10" topmargin=0 scrolling="no" noresize>
	<FRAME SRC="./servemp_ds_sc.jsp?auth_rw=<%=auth_rw%>&off_id=<%=off_id%>&cpt_cd=<%=cpt_cd%>&sh_height=<%=height%>&mon_amt=<%=mon_amt%>&save_dt=<%=save_dt%>&gubun1=<%=gubun1%>" name="dsc_body" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>