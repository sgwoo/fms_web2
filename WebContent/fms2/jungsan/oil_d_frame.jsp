<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "08", "02", "22");
			
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
				
	sh_height = sh_line_height*3;
	int cnt = 2; //현황 출력 총수
			
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="<%=sh_height%>, *" border=0>
 	<FRAME SRC="./oil_d_sh.jsp?dt=9&user_id=<%=user_id%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&height=<%=height%>&s_width=<%=s_width%>&s_height=<%=s_height%>" name="cd_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>	
	<FRAME SRC="./oil_d_sc.jsp?dt=9&user_id=<%=user_id%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&height=<%=height%>&s_width=<%=s_width%>&s_height=<%=s_height%>" name="cd_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="no" noresize>	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
