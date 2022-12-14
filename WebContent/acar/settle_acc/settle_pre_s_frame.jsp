<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 5; //검색 라인수
	int height = cnt*sh_line_height-25;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"8":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String today = request.getParameter("today")==null?AddUtil.getDate():request.getParameter("today");
	String mode = request.getParameter("mode")	==null?"":request.getParameter("mode");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "07", "03");
	
	//임원이거나 총무팀직원은 전체검색 / 사원이고 총무팀가 아닌 직원은 영업소담당자로 조회
	CommonDataBase c_db = CommonDataBase.getInstance();
	String id_chk = c_db.getUserBusYn(user_id);
	if(!id_chk.equals("") && s_kd.equals("") && t_wd.equals("")){
		s_kd="8";
		t_wd=user_id;
	}	
	
	if(mode.equals("")){
%>
<frameset rows="<%=height%>,*" border=1>
        <frame src="/acar/settle_acc/settle_pre_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&today=<%=today%>&sh_height=<%=height%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="/acar/settle_acc/settle_pre_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&today=<%=today%>&sh_height=<%=height%>" name="c_body" marginwidth=10 marginheight=10 scrolling="no">
</frameset>
<%	}else{
		String m_id = request.getParameter("m_id")	==null?"":request.getParameter("m_id");
		String l_cd = request.getParameter("l_cd")	==null?"":request.getParameter("l_cd");
		String c_id = request.getParameter("c_id")	==null?"":request.getParameter("c_id");
%>
<frameset rows="*,0" border=1>
        <frame src="/acar/settle_acc/settle_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&today=<%=today%>&sh_height=<%=height%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="about:blank" name="c_body" marginwidth=10 marginheight=10 scrolling="no">
</frameset>
<% 	}	%>
</HTML>
