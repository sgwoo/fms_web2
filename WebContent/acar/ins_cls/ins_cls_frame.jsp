<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	auth_rw = rs_db.getAuthRw(user_id, "09", "19");	
%> 
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="80, *" border=0>
	<FRAME SRC="./ins_cls_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&c_id=<%=c_id%>&ins_st=<%=ins_st%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>
	<%if(c_id.equals("")){%>
 	<FRAME SRC="./ins_cls_help.jsp" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10" marginheight="10">
	<%}else{%>
 	<FRAME SRC="./ins_cls_sc.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&c_id=<%=c_id%>&ins_st=<%=ins_st%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10" marginheight="10">	
	<%}%>	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
