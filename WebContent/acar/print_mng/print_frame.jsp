<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	int cnt = 3; //검색 라인수
	int height = cnt*sh_line_height-10;
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"1":request.getParameter("s_gubun1");
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");
	String s_gubun4 = request.getParameter("s_gubun4")==null?"":request.getParameter("s_gubun4");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String rent_cnt = "";
	
	if(!br_id.equals("S1"))	s_gubun3 = user_id;
	
	//임원이거나 총무팀직원은 전체검색 / 사원이고 총무팀가 아닌 직원은 영업소담당자로 조회
	CommonDataBase c_db = CommonDataBase.getInstance();
	String id_chk = c_db.getUserBusYn(user_id);
	if(!id_chk.equals("") && s_gubun3.equals("")){
		s_gubun3=user_id;
	}
%>
<frameset rows="<%=height%>, *" border=0>
	<frame name="c_body"    src="./print_sh.jsp?br_id=<%=br_id%>&user_id=<%=user_id%>&member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&auth_rw=<%=auth_rw%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&s_gubun1=<%=s_gubun1%>&s_gubun2=<%=s_gubun2%>&s_gubun3=<%=s_gubun3%>&s_gubun4=<%=s_gubun4%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&rent_cnt=<%=rent_cnt%>&idx=<%=idx%>&sh_height=<%=height%>" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<frame name="c_foot"    src="./print_sc.jsp?br_id=<%=br_id%>&user_id=<%=user_id%>&member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&auth_rw=<%=auth_rw%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&s_gubun1=<%=s_gubun1%>&s_gubun2=<%=s_gubun2%>&s_gubun3=<%=s_gubun3%>&s_gubun4=<%=s_gubun4%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&rent_cnt=<%=rent_cnt%>&idx=<%=idx%>&sh_height=<%=height%>" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</frameset>
</HTML>
