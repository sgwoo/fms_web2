<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 3; //검색 라인수
	int height = cnt*sh_line_height+45;

%>
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"0001":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_id 		= request.getParameter("car_id")	==null?"":request.getParameter("car_id");
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String t_wd2 		= request.getParameter("t_wd2")		==null?"":request.getParameter("t_wd2");
	String t_wd3 		= request.getParameter("t_wd3")		==null?"":request.getParameter("t_wd3");
	String t_wd4 		= request.getParameter("t_wd4")		==null?"":request.getParameter("t_wd4");
	String t_wd5 		= request.getParameter("t_wd5")		==null?"":request.getParameter("t_wd5");
	String gubun1 		= request.getParameter("gubun1")	==null?"A":request.getParameter("gubun1");
	String s_car_id 	= request.getParameter("s_car_id")	==null?"":request.getParameter("s_car_id");	
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"3":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"0":request.getParameter("asc");
		
	car_id = s_car_id;
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&car_comp_id="+car_comp_id+"&code="+code+"&car_id="+car_id+"&view_dt="+view_dt+"&t_wd="+t_wd+"&t_wd2="+t_wd2+"&t_wd3="+t_wd3+"&t_wd4="+t_wd4+"&t_wd5="+t_wd5+
			"&gubun1="+gubun1+"&s_car_id="+s_car_id+"&sort_gubun="+sort_gubun+"&asc="+asc+
			"&sh_height="+height+"";	
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./car_mst_sh.jsp<%=valus%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<%if(code.equals("")){%>
	<FRAME SRC="about:blank" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<%}else{%>
	<FRAME SRC="./car_mst_sc.jsp<%=valus%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">	
	<%}%>
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
