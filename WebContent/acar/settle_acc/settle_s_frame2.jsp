<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<jsp:useBean id="cnd" scope="page" class="acar.common.ConditionBean"/>
<%@ include file="/acar/cookies.jsp" %>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String today = request.getParameter("today")==null?AddUtil.getDate():request.getParameter("today");
	String mode = request.getParameter("mode")	==null?"":request.getParameter("mode");
	
	cnd.setAuth_rw(request.getParameter("auth_rw")==null?cnd.getAuth_rw():request.getParameter("auth_rw"));
	cnd.setUser_id(request.getParameter("user_id")==null?cnd.getUser_id():request.getParameter("user_id"));
	cnd.setBr_id(request.getParameter("br_id")==null?cnd.getBr_id():request.getParameter("br_id"));
	cnd.setGubun1(request.getParameter("gubun1")==null?"7":request.getParameter("gubun1"));
	cnd.setGubun2(request.getParameter("gubun2")==null?"2":request.getParameter("gubun2"));
	cnd.setGubun3(request.getParameter("gubun3")==null?"3":request.getParameter("gubun3"));
	cnd.setGubun4(request.getParameter("gubun4")==null?"0":request.getParameter("gubun4"));
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
	
	//임원이거나 총무팀직원은 전체검색 / 사원이고 총무팀가 아닌 직원은 영업소담당자로 조회
	CommonDataBase c_db = CommonDataBase.getInstance();
	String id_chk = c_db.getUserBusYn(cnd.getUser_id());
	if(!id_chk.equals("") && cnd.getS_kd().equals("") && cnd.getT_wd().equals("")){
		cnd.setS_kd("8");
		cnd.setT_wd(cnd.getUser_id());
	}	
	
	if(mode.equals("")){
%>
<frameset rows="80,*" border=1>
        <frame src="/acar/settle_acc/settle_sh.jsp?auth_rw=<%=cnd.getAuth_rw()%>&user_id=<%=cnd.getUser_id()%>&br_id=<%=cnd.getBr_id()%>&gubun1=<%=cnd.getGubun1()%>&gubun2=<%=cnd.getGubun2()%>&gubun3=<%=cnd.getGubun3()%>&gubun4=<%=cnd.getGubun4()%>&st_dt=<%=cnd.getSt_dt()%>&end_dt=<%=cnd.getEnd_dt()%>&s_kd=<%=cnd.getS_kd()%>&t_wd=<%=cnd.getT_wd()%>&sort_gubun=<%=cnd.getSort_gubun()%>&asc=<%=cnd.getAsc()%>&today=<%=today%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="/acar/settle_acc/settle_sc.jsp?auth_rw=<%=cnd.getAuth_rw()%>&user_id=<%=cnd.getUser_id()%>&br_id=<%=cnd.getBr_id()%>&gubun1=<%=cnd.getGubun1()%>&gubun2=<%=cnd.getGubun2()%>&gubun3=<%=cnd.getGubun3()%>&gubun4=<%=cnd.getGubun4()%>&st_dt=<%=cnd.getSt_dt()%>&end_dt=<%=cnd.getEnd_dt()%>&s_kd=<%=cnd.getS_kd()%>&t_wd=<%=cnd.getT_wd()%>&sort_gubun=<%=cnd.getSort_gubun()%>&asc=<%=cnd.getAsc()%>&today=<%=today%>" name="c_body" marginwidth=10 marginheight=10 scrolling="no">
</frameset>
<%	}else{
		String m_id = request.getParameter("m_id")	==null?"":request.getParameter("m_id");
		String l_cd = request.getParameter("l_cd")	==null?"":request.getParameter("l_cd");
		String c_id = request.getParameter("c_id")	==null?"":request.getParameter("c_id");
%>
<frameset rows="*,0" border=1>
        <frame src="/acar/settle_acc/settle_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&auth=<%=auth%>&auth_rw=<%=cnd.getAuth_rw()%>&user_id=<%=cnd.getUser_id()%>&br_id=<%=cnd.getBr_id()%>&gubun1=<%=cnd.getGubun1()%>&gubun2=<%=cnd.getGubun2()%>&gubun3=<%=cnd.getGubun3()%>&gubun4=<%=cnd.getGubun4()%>&st_dt=<%=cnd.getSt_dt()%>&end_dt=<%=cnd.getEnd_dt()%>&s_kd=<%=cnd.getS_kd()%>&t_wd=<%=cnd.getT_wd()%>&sort_gubun=<%=cnd.getSort_gubun()%>&asc=<%=cnd.getAsc()%>&today=<%=today%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="about:blank" name="c_body" marginwidth=10 marginheight=10 scrolling="no">
</frameset>
<% 	}	%>
</HTML>
