<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 3; //�˻� ���μ�
	int height = cnt*sh_line_height+10;
%>
<%
	//�ڵ������� �˻�������
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "02", "01");
	
	String st 			= request.getParameter("st")==null?"3":request.getParameter("st");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"00000000":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"99999999":request.getParameter("ref_dt2");
	String gubun 		= request.getParameter("gubun")==null?"firm_nm":request.getParameter("gubun");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"firm_nm":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./register_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun3=<%=gubun3%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>&sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./register_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun3=<%=gubun3%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>&sh_height=<%=height%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
