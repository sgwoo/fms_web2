<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 6; //검색 라인수
	int height = cnt*sh_line_height;
%>
<HTML>
<HEAD>
<title>FMS</title>
<script language='javascript'>
</script>
</HEAD>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	//검색구분
 	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String s_dept = request.getParameter("s_dept")==null?"":request.getParameter("s_dept");
	String s_user = request.getParameter("s_user")==null?"":request.getParameter("s_user");
	String s_mng_way = request.getParameter("s_mng_way")==null?"":request.getParameter("s_mng_way");
	String s_mng_st = request.getParameter("s_mng_st")==null?"":request.getParameter("s_mng_st");	
	String gubun2 	= request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

%>
<frameset rows="<%=height%>, *" border=0>
  <frame src="./stat_maker_car_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_brch=<%=s_brch%>&s_dept=<%=s_dept%>&s_user=<%=s_user%>&s_mng_way=<%=s_mng_way%>&s_mng_st=<%=s_mng_st%>&sh_height=<%=height%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame src="./stat_maker_car_sc2.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_brch=<%=s_brch%>&s_dept=<%=s_dept%>&s_user=<%=s_user%>&s_mng_way=<%=s_mng_way%>&s_mng_st=<%=s_mng_st%>&sh_height=<%=height%>" name="c_foot" marginwidth=10 marginheight=0 scrolling='auto'>
</frameset>
</HTML>
