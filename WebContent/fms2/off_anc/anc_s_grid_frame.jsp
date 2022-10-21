<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = cnt*sh_line_height-20;
%>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String gubun1 = request.getParameter("gubun1")==null?"title":request.getParameter("gubun1");
	String gubun_1 = request.getParameter("gubun_1")==null?"":request.getParameter("gubun_1");
	String gubun2 = request.getParameter("gubun2")==null?"c_year":request.getParameter("gubun2");
	String gubun_2 = request.getParameter("gubun_2")==null?"":request.getParameter("gubun_2");
	
	
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "13", "01", "01");
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
									"&gubun1="+gubun1+"&gubun_1="+gubun_1+"&gubun2="+gubun2+"&gubun_2="+gubun_2+
				   				"&sh_height="+height+"";
%>
<!DOCTYPE html>
<html>
<HEAD>
<meta http-equiv="X-UA-Compatible" content="IE=edge;" />
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./anc_s_grid_sh.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./anc_s_grid_sc.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>" name="c_foot" frameborder=0 scrolling="yes" topmargin=0 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
