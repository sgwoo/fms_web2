<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 3; //�˻� ���μ�
	int height = cnt*sh_line_height+15;
%>
<%
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3"); //����/�μ�
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4"); //��Ʈ/����� 
	String gubun5 = request.getParameter("gubun5")==null?"1":request.getParameter("gubun5"); //�Ϲݽ�/�⺻��
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page"); //	
	
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1"); //�Ⱓ
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2"); //

	String bm = request.getParameter("bm")==null?"1":request.getParameter("bm");//Ÿ��
	
%> 

<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./stat_cls_sh.jsp?bm=<%=bm%>&from_page=<%=from_page%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&auth_rw=<%=auth_rw%>&sh_height=<%=height%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./stat_cls_sc.jsp?bm=<%=bm%>&from_page=<%=from_page%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&auth_rw=<%=auth_rw%>&sh_height=<%=height%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
