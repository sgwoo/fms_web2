<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");
	String flag = request.getParameter("flag")==null?"n":request.getParameter("flag");	//경매상태등록 여부 판단후 FootWin()실행 결정.	
	
	String actn_id = request.getParameter("actn_id")==null?"":request.getParameter("actn_id");
		
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="255,700, 200, 5" border=0>
	<FRAME SRC="./off_ls_jh_actn_mng_list.jsp?actn_id=<%=actn_id%>&auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>" name="c_head"  frameborder=0 marginwidth=10 marginheight=10 scrolling="no" noresize>
	<FRAME SRC="./off_ls_jh_actn_mng.jsp?actn_id=<%=actn_id%>&auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&seq=<%=seq%>&flag=<%=flag%>" name="c_body"  frameborder=0 marginwidth=10 marginheight=10 scrolling="no" noresize>
	<FRAME SRC="" name="st_foot" scrolling="auto" topmargin=0 marginwidth="10" marginheight="10">
	<FRAME SRC="about:blank" name="nodisplay" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">

</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
