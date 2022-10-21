<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height;

%>
<%
	//자동차관리 등록/수정화면 프레임
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	// 차량관리 > 차량등록관리 > 자동차관리에서 오는 경우와 영업관리 > 계출관리 > 납품준비상황에서 오는 경우를 구분짓기 위해 추가		2017. 11. 28
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	// 납품준비상황에서 등록일자 등록 버튼으로 이동할 경우 인수지를 매개체 데이터 이동			2017. 12. 8
	String udt_st= request.getParameter("udt_st")==null?"":request.getParameter("udt_st");
	
	int body_height = 550;
	if(s_height.equals("768")) body_height = 300;
	
	
	
	
%> 
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=body_height%>, *, 10" border=0>
<%	if(cmd.equals("id"))	{%>
	<FRAME SRC="./register_main_i.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=car_mng_id%>&cmd=<%=cmd%>&st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>&sh_height=<%=height%>&from_page=<%=from_page%>&udt_st=<%=udt_st%>" name="c_body"  frameborder=0 marginwidth=0 marginheight=10 scrolling="yes" noresize>
<%	}else{
		if(cmd.equals("")) cmd = "ud";%>
	<FRAME SRC="./register_main_u.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=car_mng_id%>&cmd=<%=cmd%>&st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>&sh_height=<%=height%>&from_page=<%=from_page%>" name="c_body"  frameborder=0 marginwidth=0 marginheight=10 scrolling="yes" noresize>
<%	}%>
	<FRAME SRC="./register_his_id.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=car_mng_id%>&cmd=<%=cmd%>&st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>&sh_height=<%=height%>" name="c_foot" scrolling="auto" topmargin=0 marginwidth="10" marginheight="10">
	<FRAME SRC="about:blank" name="nodisplay" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">

</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
