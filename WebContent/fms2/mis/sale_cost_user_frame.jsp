<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//비용캠페인변수 : cost_campaign 테이블
	Hashtable ht3 = ac_db.getCostCampaignVar2("2");
	
	String year 		= (String)ht3.get("YEAR");
	String tm 			= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");
	
	String ref_dt1 	= request.getParameter("ref_dt1")==null?AddUtil.ChangeDate2(cs_dt):request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?AddUtil.ChangeDate2(ce_dt):request.getParameter("ref_dt2");
		
	//로그인ID&영업소ID
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "09", "07", "02");
	
	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<FRAMESET rows="<%=sh_height%>, *" border=0>
 	<FRAME SRC="./sale_cost_user_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sh_height=<%=sh_height%>" name="c_head" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>	
	<FRAME SRC="./sale_cost_user_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sh_height=<%=sh_height%>" name="c_body" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
