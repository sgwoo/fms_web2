<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 3; //�˻� ���μ�
	int height = cnt*sh_line_height+20;
%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "04", "01");
%>

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./car_office_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&s_kd=<%= s_kd %>&t_wd=<%= t_wd %>&sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./car_office_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&s_kd=<%= s_kd %>&t_wd=<%= t_wd %>&sh_height=<%=height%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
