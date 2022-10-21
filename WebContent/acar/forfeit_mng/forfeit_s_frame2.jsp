<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*" %>
<jsp:useBean id="cnd" scope="page" class="acar.common.ConditionBean"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	cnd.setAuth_rw(request.getParameter("auth_rw")==null?cnd.getAuth_rw():request.getParameter("auth_rw"));
	cnd.setUser_id(request.getParameter("user_id")==null?cnd.getUser_id():request.getParameter("user_id"));
	cnd.setBr_id(request.getParameter("br_id")==null?cnd.getBr_id():request.getParameter("br_id"));
	cnd.setGubun1(request.getParameter("gubun1")==null?"10":request.getParameter("gubun1"));
	cnd.setGubun2(request.getParameter("gubun2")==null?"6":request.getParameter("gubun2"));
	cnd.setGubun3(request.getParameter("gubun3")==null?"3":request.getParameter("gubun3"));
	cnd.setGubun4(request.getParameter("gubun4")==null?"5":request.getParameter("gubun4"));
	cnd.setSt_dt(request.getParameter("st_dt")==null?cnd.getSt_dt():request.getParameter("st_dt"));
	cnd.setEnd_dt(request.getParameter("end_dt")==null?cnd.getEnd_dt():request.getParameter("end_dt"));
	cnd.setS_kd(request.getParameter("s_kd")==null?cnd.getS_kd():request.getParameter("s_kd"));
	cnd.setT_wd(request.getParameter("t_wd")==null?cnd.getT_wd():request.getParameter("t_wd"));
	cnd.setS_bus(request.getParameter("s_bus")==null?cnd.getS_bus():request.getParameter("s_bus"));
	cnd.setS_brch(request.getParameter("s_brch")==null?cnd.getS_brch():request.getParameter("s_brch"));
	cnd.setSort_gubun(request.getParameter("sort_gubun")==null?cnd.getSort_gubun():request.getParameter("sort_gubun"));
	cnd.setAsc(request.getParameter("asc")==null?cnd.getAsc():request.getParameter("asc"));
	cnd.setIdx(request.getParameter("idx")==null?cnd.getIdx():request.getParameter("idx"));

	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(cnd.getUser_id().equals("")) 	cnd.setUser_id(login.getCookieValue(request, "acar_id"));
	if(cnd.getBr_id().equals(""))		cnd.setBr_id(login.getCookieValue(request, "acar_br"));
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="90, *" border=0>
	<FRAME SRC="./forfeit_sh.jsp?auth_rw=<%=cnd.getAuth_rw()%>&user_id=<%=cnd.getUser_id()%>&br_id=<%=cnd.getBr_id()%>&gubun1=<%=cnd.getGubun1()%>&gubun2=<%=cnd.getGubun2()%>&gubun3=<%=cnd.getGubun3()%>&gubun4=<%=cnd.getGubun4()%>&st_dt=<%=cnd.getSt_dt()%>&end_dt=<%=cnd.getEnd_dt()%>&s_kd=<%=cnd.getS_kd()%>&t_wd=<%=cnd.getT_wd()%>&sort_gubun=<%=cnd.getSort_gubun()%>&asc=<%=cnd.getAsc()%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./forfeit_sc.jsp?auth_rw=<%=cnd.getAuth_rw()%>&user_id=<%=cnd.getUser_id()%>&br_id=<%=cnd.getBr_id()%>&gubun1=<%=cnd.getGubun1()%>&gubun2=<%=cnd.getGubun2()%>&gubun3=<%=cnd.getGubun3()%>&gubun4=<%=cnd.getGubun4()%>&st_dt=<%=cnd.getSt_dt()%>&end_dt=<%=cnd.getEnd_dt()%>&s_kd=<%=cnd.getS_kd()%>&t_wd=<%=cnd.getT_wd()%>&sort_gubun=<%=cnd.getSort_gubun()%>&asc=<%=cnd.getAsc()%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>