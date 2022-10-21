<%@ page language="java" import="java.util.*, acar.util.*, acar.user_mng.*" contentType="text/html;charset=euc-kr" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 3; //검색 라인수
	int height = cnt*sh_line_height+10;
%>
<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String s_dt 	= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 	= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String esti_m 	= request.getParameter("esti_m")	==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")	==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");
	
	//로그인ID&영업소ID
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "05", "09");	
	
	if(gubun1.equals("") && gubun2.equals("") && gubun3.equals("") && gubun4.equals("") && gubun5.equals("") && gubun6.equals("") && t_wd.equals("")){
		gubun1 	= "7";
		gubun4 	= "2";
		s_kd 	= "3";
		
		UserMngDatabase umd = UserMngDatabase.getInstance();
		user_bean 	= umd.getUsersBean(user_id);
		
		if(!user_bean.getLoan_st().equals("")){			
			gubun5 = user_bean.getUser_nm();
		}			
	}	
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./esti_cu_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&esti_m=<%= esti_m %>&esti_m_dt=<%= esti_m_dt %>&esti_m_s_dt=<%= esti_m_s_dt %>&esti_m_e_dt=<%= esti_m_e_dt %>&sh_height=<%=height%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./esti_cu_sc.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&esti_m=<%= esti_m %>&esti_m_dt=<%= esti_m_dt %>&esti_m_s_dt=<%= esti_m_s_dt %>&esti_m_e_dt=<%= esti_m_e_dt %>&sh_height=<%=height%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
