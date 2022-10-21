<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.accid.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String accid_st = request.getParameter("accid_st")==null?"":request.getParameter("accid_st");//사고구분
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String dlv_mon = request.getParameter("dlv_mon")==null?"":request.getParameter("dlv_mon");
	String car_amt = request.getParameter("car_amt")==null?"":request.getParameter("car_amt");
	String tot_amt = request.getParameter("tot_amt")==null?"":request.getParameter("tot_amt");
	String req_est_amt = request.getParameter("req_est_amt")==null?"":request.getParameter("req_est_amt");
	String amor_est_id = request.getParameter("amor_est_id")==null?"":request.getParameter("amor_est_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	if(accid_id.equals(""))	accid_id = as_db.getMaxAccid_id(c_id);
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	if(mode.equals("") || mode.equals("0")){
		mode = "1";
		//if(accid_st.equals("4"))	mode = "13"; ->사고종결문서처리로 여기 사용안함
	}
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");	
%> 
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<% 	if(!accid_id.equals("")){%>
<FRAMESET rows="<%if(String.valueOf(cont.get("CAR_ST")).equals("2")){%>420<%}else{%>330<%}%>, *" border=0>
	<FRAME SRC="accid_u_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&brch_id=<%=brch_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&s_st=<%=s_st%>&go_url=<%=go_url%>&idx=<%=idx%>&dlv_mon=<%=dlv_mon%>&car_amt=<%=car_amt%>&tot_amt=<%=tot_amt%>&req_est_amt=<%=req_est_amt%>&amor_est_id=<%=amor_est_id%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="accid_u_in<%=mode%>.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&brch_id=<%=brch_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&s_st=<%=s_st%>&go_url=<%=go_url%>&idx=<%=idx%>&dlv_mon=<%=dlv_mon%>&car_amt=<%=car_amt%>&tot_amt=<%=tot_amt%>&req_est_amt=<%=req_est_amt%>&amor_est_id=<%=amor_est_id%>&from_page=<%=from_page%>" name="c_foot" frameborder=0 marginwidth="10" marginheight="10" scrolling="auto" noresize>	
</FRAMESET>
<%	}else{
	if(auth_rw.equals("")){	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "01");}%>
<FRAMESET rows="80, *" border=0>
	<FRAME SRC="../accid_reg/accid_reg_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>
 	<FRAME SRC="about:blank" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10" marginheight="10">
</FRAMESET>
<%	}%>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
