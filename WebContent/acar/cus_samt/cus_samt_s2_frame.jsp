<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //�˻� ���μ�
	int height = cnt*sh_line_height;

%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"21":request.getParameter("gubun1");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	String s_sys = Util.getDate();
	String s_year = s_sys.substring(0,4);
	String s_mon = s_sys.substring(5,7);
	String s_day = "";
	
	String acct = request.getParameter("acct")==null?"012005":request.getParameter("acct");
		
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
		
	String hidden_value = "";
	
%>

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border="0">
	<FRAME SRC="./cus_samt_s2_sh.jsp?first=Y&acct=<%=acct%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&sh_height=<%=height%>" name="c_body" frameborder="0" marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./cus_samt_s2_sc.jsp?first=Y&acct=<%=acct%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&sh_height=<%=height%>" name="c_foot" frameborder="0" marginwidth="10" marginheight="10" topmargin="0" scrolling="auto">
</FRAMESET>
<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
