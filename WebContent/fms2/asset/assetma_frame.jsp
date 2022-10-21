<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	int cnt = 20; //검색 라인수
	int height = cnt*sh_line_height;

%>
<%
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 	= request.getParameter("st")==null?"1":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String asset_code = request.getParameter("asset_code")==null?"":request.getParameter("asset_code");
	
		
	String chk1 = request.getParameter("chk1")==null?"2":request.getParameter("chk1");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
		
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");

	String asset_g 	= request.getParameter("asset_g")==null?"1":request.getParameter("asset_g");

%> 
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="400, *, 10" border=0>
	<FRAME SRC="./asset_master_u.jsp?chk1=<%=chk1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&asset_code=<%=asset_code%>&cmd=<%=cmd%>&st=<%=st%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&asset_g=<%=asset_g%>&sh_height=<%=height%>" name="c_body"  frameborder=0 marginwidth=0 marginheight=10 scrolling="no" noresize>
	<FRAME SRC="./asset_move_s_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&asset_code=<%=asset_code%>&st=<%=st%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&asset_g=<%=asset_g%>&sh_height=400" name="c_foot" scrolling="auto" topmargin=0 marginwidth="10" marginheight="10">
	<FRAME SRC="about:blank" name="nodisplay" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">

</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
