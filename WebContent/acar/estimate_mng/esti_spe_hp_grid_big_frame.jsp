<%@ page language="java" import="java.util.*, acar.util.*" contentType="text/html;charset=euc-kr" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 150; //검색 라인수
	int height = cnt*sh_line_height+15;
%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");
	
	// 목록보기 클릭시 전단계 검색조건 유지를 위해 추가
	String period_gubun = request.getParameter("period_gubun")==null?"":request.getParameter("period_gubun");	
	String branch = request.getParameter("branch")==null?"":request.getParameter("branch");		//영업지점 검색추가
	String bus_user_id = request.getParameter("bus_user_id")==null?"":request.getParameter("bus_user_id");		//통화작성자 검색추가
		
	//로그인ID&영업소ID
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "05", "01");	
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<%-- <FRAME SRC="./esti_spe_hp_grid_big_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&esti_m=<%= esti_m %>&esti_m_dt=<%= esti_m_dt %>&esti_m_s_dt=<%= esti_m_s_dt %>&esti_m_e_dt=<%= esti_m_e_dt %>&sh_height=<%=height%>&period_gubun=<%=period_gubun%>&branch=<%=branch%>&bus_user_id=<%=bus_user_id%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize> --%>
	<FRAME SRC="./esti_spe_hp_grid_big_sc.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&esti_m=<%= esti_m %>&esti_m_dt=<%= esti_m_dt %>&esti_m_s_dt=<%= esti_m_s_dt %>&esti_m_e_dt=<%= esti_m_e_dt %>&sh_height=<%=height%>&period_gubun=<%=period_gubun%>&branch=<%=branch%>&bus_user_id=<%=bus_user_id%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10" noresize>
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
