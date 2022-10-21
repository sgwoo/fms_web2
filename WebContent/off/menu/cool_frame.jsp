<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_st 	= request.getParameter("m_st")==null?"13":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")==null?"01":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")==null?"01":request.getParameter("m_cd");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String url 	= request.getParameter("url")==null?"":request.getParameter("url");
	
	String s_width2 = request.getParameter("s_width2")==null?"":request.getParameter("s_width2");
	String s_height2= request.getParameter("s_height2")==null?"":request.getParameter("s_height2");
	
	LoginBean login 	= LoginBean.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	
	//���������
	UsersBean user_bean = umd.getUsersBean(ck_acar_id);
	
	
	if(nm_db.getWorkAuthUser("�ܺ�_Ź�۾�ü",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "07";
		m_cd 	= "02";
		//20120117 ���¾�ü�� ������ ���ƾ�ü-���¾�ü����-�Ƹ���ī������ȸ�� �⺻ �������� �ȴ�.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}else if(nm_db.getWorkAuthUser("�ܺ�_��ǰ��ü",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "08";
		m_cd 	= "02";
		//20120117 ���¾�ü�� ������ ���ƾ�ü-���¾�ü����-�Ƹ���ī������ȸ�� �⺻ �������� �ȴ�.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}else if(nm_db.getWorkAuthUser("�ܺ�_�����ü",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "06";
		m_cd 	= "01";
		//20120117 ���¾�ü�� ������ ���ƾ�ü-���¾�ü����-�Ƹ���ī������ȸ�� �⺻ �������� �ȴ�.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}else if(nm_db.getWorkAuthUser("�ܺ�_���·�",ck_acar_id)){
		m_st 	= "03";
		m_st2 	= "06";
		m_cd 	= "01";
		//20120117 ���¾�ü�� ������ ���ƾ�ü-���¾�ü����-�Ƹ���ī������ȸ�� �⺻ �������� �ȴ�.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}else if(nm_db.getWorkAuthUser("�ܺ�_����⵿",ck_acar_id)){
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";
		//20120117 ���¾�ü�� ������ ���ƾ�ü-���¾�ü����-�Ƹ���ī������ȸ�� �⺻ �������� �ȴ�.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}else if(nm_db.getWorkAuthUser("�ܺ�_�ݼ�Ÿ",ck_acar_id)){
		m_st 	= "16";
		m_st2 	= "01";
		m_cd 	= "01";
		//20120117 ���¾�ü�� ������ ���ƾ�ü-���¾�ü����-�Ƹ���ī������ȸ�� �⺻ �������� �ȴ�.
		m_st 	= "17";
		m_st2 	= "09";
		m_cd 	= "03";		
	}
		
	
	if(s_width.equals("") && !s_width2.equals("")){
		login.setDisplayCookie(s_width2, s_height2, response);//���÷��� ������ ��Ű����
	}
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, url);
	
	if(m_st.equals("") && !url.equals("")){
		int len = url.indexOf("?");
		String s_url = url;
		if(len != -1){
			s_url = url.substring(0,len);
		}
		MaMenuBean bean = nm_db.getMenuCase(s_url);
		m_st 	= bean.getM_st();
		m_st2 	= bean.getM_st2();
		m_cd 	= bean.getM_cd();
	}
	
	url = AddUtil.replace(url, "|", "&");
	
	if(url.equals("")) url = "amazoncar_main.jsp";
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<script language=JavaScript>
</script>
</HEAD>
<FRAMESET ROWS="123,*" border=0>
	<%if(user_bean.getDept_id().equals("8888")){//�ܺξ�ü%>
	<FRAME NAME="top_menu"      SRC="subcont_top.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=0 marginheight=0 scrolling="no" noresize>
	<FRAMESET cols="185, *" border=0>
		<FRAME name="d_menu"    SRC="subcont_menu.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=0 marginheight=0 scrolling="auto" noresize>  
		<%if(url.equals("amazoncar_main.jsp")){%>
		<!--<FRAME name="d_content" SRC="about:blank" frameborder=0 marginwidth=10 marginheight=10 scrolling="auto" noresize>-->
		<FRAME name="d_content" SRC="/fms2/master_car/amazoncar_list_frame.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=10 marginheight=10 scrolling="auto" noresize>
		<%}else{%>
		<FRAME name="d_content" SRC="<%=url%>" frameborder=0 marginwidth=10 marginheight=10 scrolling="auto" noresize>
		<%}%>
	</frameset>	
	<%}else{//�Ƹ���ī����%>	
	<FRAME NAME="top_menu"      SRC="emp_top.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=0 marginheight=0 scrolling="no" noresize>
	<FRAMESET cols="185, *" border=0>
		<FRAME name="d_menu"    SRC="emp_menu.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>" frameborder=0 marginwidth=0 marginheight=0 scrolling="auto" noresize>  
		<FRAME name="d_content" SRC="<%=url%>" frameborder=0 marginwidth=10 marginheight=10 scrolling="auto" noresize>
	</frameset>
	<%}%>
</FRAMESET>	
<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>