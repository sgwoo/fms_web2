<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no"); //차량번호 또는 차대번호
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm"); //차종
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id"); //차량관리번호
	String init_reg_dt	= request.getParameter("init_reg_dt")==null?"":request.getParameter("init_reg_dt"); //최초등록일
	String dpm	= request.getParameter("dpm")==null?"":request.getParameter("dpm"); //배기량
	String fuel_kd	= request.getParameter("fuel_kd")==null?"":request.getParameter("fuel_kd"); //연료
	String colo	= request.getParameter("colo")==null?"":request.getParameter("colo"); // 색상
	int car_km = request.getParameter("car_km")==null?0:Util.parseInt(request.getParameter("car_km"));
	String io_gubun	= request.getParameter("io_gubun")==null?"":request.getParameter("io_gubun");
	String st	= request.getParameter("st")==null?"":request.getParameter("st");
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id");

%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="320, *" border=0>
	<FRAME SRC="./parking_check_sh.jsp?park_id=<%=park_id%>&auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&io_gubun=<%=io_gubun%>&st=<%=st%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./parking_check_sc.jsp?park_id=<%=park_id%>&auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&io_gubun=<%=io_gubun%>&st=<%=st%>" name="c_foot" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10" noresize>
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
