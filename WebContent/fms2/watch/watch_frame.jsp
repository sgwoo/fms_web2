<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%> 
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 3; //�˻� ���μ�
	int height = cnt*sh_line_height+15;
%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	String chk1 = request.getParameter("chk1")==null?"m":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="watch_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&chk1=<%=chk1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>&sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no">
	<%if(br_id.equals("S1")||br_id.equals("S3")||br_id.equals("S4")||br_id.equals("S5")||br_id.equals("S6")){//����%>
			<FRAME SRC="watch_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&chk1=<%=chk1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>&sh_height=<%=height%>" name="c_foot" frameborder=0 marginheight="10" marginwidth="10" scrolling="auto" noresize>
	<%}else if(br_id.equals("B1")||br_id.equals("U1")||br_id.equals("G1")||br_id.equals("D1")||br_id.equals("J1")){//����%>
			<FRAME SRC="watch_jj.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&chk1=<%=chk1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>&sh_height=<%=height%>" name="c_foot" frameborder=0 marginheight="10" marginwidth="10" scrolling="auto" noresize>
	<%}else if(br_id.equals("S2")||br_id.equals("I1")||br_id.equals("K3")){%>
			<FRAME SRC="watch_s2.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&chk1=<%=chk1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>&sh_height=<%=height%>" name="c_foot" frameborder=0 marginheight="10" marginwidth="10" scrolling="auto" noresize>
	<%}else{%>
			<FRAME SRC="watch_s2.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&chk1=<%=chk1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>&sh_height=<%=height%>" name="c_foot" frameborder=0 marginheight="10" marginwidth="10" scrolling="auto" noresize>
	<%}%>
</FRAMESET>

<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
