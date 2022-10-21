<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"S1":request.getParameter("br_id");//로그인-영업소
	String go_url = "/fms2/credit/fine_ocr_reg_sc.jsp";
	String paid_no = request.getParameter("paid_no")==null?"":request.getParameter("paid_no");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	String file_name 	= request.getParameter("file_name")==null?"":request.getParameter("file_name");
	String save_folder 	= request.getParameter("save_folder")==null?"":request.getParameter("save_folder");
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "07", "04");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="50, *" border=0>
	<FRAME SRC="./fine_ocr_reg_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&go_url=<%=go_url%>" name="c_body" frameborder=0  marginwidth="10"  scrolling="no" noresize style="height: 33px !important;">
	<FRAME SRC="./fine_ocr_reg_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&go_url=<%=go_url%>&paid_no=<%=paid_no%>&car_no=<%=car_no%>&gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&seq=<%=seq%>&file_name=<%=file_name%>&save_folder=<%=save_folder%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
	<FRAME SRC="about:blank" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>