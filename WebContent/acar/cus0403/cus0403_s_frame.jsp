<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<jsp:useBean id="cnd" scope="session" class="acar.common.ConditionBean"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = cnt*sh_line_height;

%>
<%
	cnd.setGubun1(request.getParameter("gubun1")==null?"23":request.getParameter("gubun1"));
	cnd.setGubun2(request.getParameter("gubun2")==null?cnd.getGubun2():request.getParameter("gubun2"));
	cnd.setGubun3(request.getParameter("gubun3")==null?cnd.getGubun3():request.getParameter("gubun3"));
	cnd.setGubun4(request.getParameter("gubun4")==null?cnd.getGubun4():request.getParameter("gubun4"));
	cnd.setSt_dt(request.getParameter("st_dt")==null?cnd.getSt_dt():request.getParameter("st_dt"));
	cnd.setEnd_dt(request.getParameter("end_dt")==null?cnd.getEnd_dt():request.getParameter("end_dt"));
	cnd.setS_kd(request.getParameter("s_kd")==null?cnd.getS_kd():request.getParameter("s_kd"));
	cnd.setT_wd(request.getParameter("t_wd")==null?cnd.getT_wd():request.getParameter("t_wd"));
	cnd.setS_bus(request.getParameter("s_bus")==null?cnd.getS_bus():request.getParameter("s_bus"));
	cnd.setS_brch(request.getParameter("s_brch")==null?cnd.getS_brch():request.getParameter("s_brch"));
	cnd.setSort_gubun(request.getParameter("sort_gubun")==null?cnd.getSort_gubun():request.getParameter("sort_gubun"));
	cnd.setAsc(request.getParameter("asc")==null?cnd.getAsc():request.getParameter("asc"));
	cnd.setIdx(request.getParameter("idx")==null?cnd.getIdx():request.getParameter("idx"));
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="<%=height%>, *" border=0>
	<FRAME SRC="./cus0403_s_sh.jsp?sh_height=<%=height%>" name="c_head" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./cus0403_s_sc.jsp?sh_height=<%=height%>" name="c_body" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10">
</FRAMESET>

<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>