<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/off/cookies.jsp" %>
<%@ include file="/off/access_log.jsp" %>
<%
	int cnt = 4; //�˻� ���μ�
	int height = cnt*sh_line_height-5;


	//�ڵ������� �˻�������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID	

	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
			
	String	to_dt 	= AddUtil.getDate(1)+""+AddUtil.getDate(2)+""+AddUtil.getDate(3);		
	String  st_dt = "";
	String  end_dt = "";
	
	st_dt = ad_db.getWortPreDay(to_dt, 7);	
	end_dt = ad_db.getWortPreDay(to_dt, 1);		
	
	String gubun1 = request.getParameter("gubun1")==null?"4":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"4":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./car_list_sh.jsp?gubun1=<%=gubun1%>&t_wd=<%=t_wd%>&gubun3=<%=gubun3%>&gubun2=<%=gubun2%>&gubun4=<%=gubun4%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./car_list_sc.jsp?gubun1=<%=gubun1%>&t_wd=<%=t_wd%>&gubun3=<%=gubun3%>&gubun2=<%=gubun2%>&gubun4=<%=gubun4%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&sh_height=<%=height%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
