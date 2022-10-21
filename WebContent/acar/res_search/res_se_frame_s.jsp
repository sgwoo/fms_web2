<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 5; //검색 라인수
	int height = cnt*sh_line_height-8;
%>

<HTML>
<HEAD>
<title>FMS</title>
<script language='javascript'>
</script>
</HEAD>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"11":request.getParameter("gubun2");
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String s_cc 		= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")		==null?"1":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"a.dpm":request.getParameter("sort_gubun");
	String asc 			= request.getParameter("asc")		==null?"desc":request.getParameter("asc");
	
	String first="Y";		
	//조회구분-예약조회 고정		
	gubun1 = "1";
	
	if(!sort_gubun.equals("")){
		if(!sort_gubun.equals("i.use_st") && !sort_gubun.equals("a.car_no") && !sort_gubun.equals("a.car_nm") && !sort_gubun.equals("a.init_reg_dt") && !sort_gubun.equals("a.dpm")){
			sort_gubun = "a.dpm";
		}
	}
%>
<frameset rows="<%=height%>, *" border=1>
  <frame src="./res_se_sh.jsp?first=Y&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&sh_height=<%=height%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
 <%if(first.equals("Y")){%>
  <FRAME SRC="/acar/menu/about_blank.jsp" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="no" noresize>  
  <%}else{%>
 <frame src="./res_se_sc.jsp?first=Y&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&sh_height=<%=height%>" name="c_foot" marginwidth=10 marginheight=10 scrolling='no' noresize>
 <%}%>
 </frameset>
</HTML>
