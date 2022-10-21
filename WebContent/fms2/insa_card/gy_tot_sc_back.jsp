<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*, acar.insa_card.*, acar.car_sche.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	
	//당해연도
	int a08_y1 = 0; 	//외근 영업팀 충원
	int a08_yk1 = 0; 	//외근 영업기획팀 충원
	int a08_g1 = 0;		//외근 고객관리팀 충원
	int a08_c1 = 0;		//외근 총무팀 충원
	int a08_b1 = 0;		//외근 부산지점 충원
	int a08_d1 = 0;		//외근 대전지점 충원
	int a08_s1 = 0;		//외근 강남지점 충원
	int a08_j1 = 0;		//외근 광주지점 충원
	int a08_k1 = 0;		//외근 대구지점 충원
	int a08_i1 = 0;		//외근 인천지점 충원
	int a08_w1 = 0;		//외근 수원지점 충원
	int a08_gs1 = 0;	//외근 강서지점 충원
	int a08_gr1 = 0;	//외근 구로지점 충원
	int a08_u1 = 0;		//외근 울산지점 충원
	int a08_jr1 = 0;	//외근 광화문지점 충원
	int a08_sp1 = 0;	//외근 송파지점 충원
	int a08_it1 = 0;
	
	int a08_tot1 = 0;	//외근 충원 소계
	
	int a08_y2 = 0; 	//외근 영업팀 퇴사
	int a08_yk2 = 0; 	//외근 영업기획팀 퇴사
	int a08_g2 = 0;		//외근 고객관리팀 퇴사
	int a08_c2 = 0;		//외근 총무팀 퇴사
	int a08_b2 = 0;		//외근 부산지점 퇴사
	int a08_d2 = 0;		//외근 대전지점 퇴사
	int a08_s2 = 0;		//외근 강남지점 퇴사
	int a08_j2 = 0;		//외근 광주지점 퇴사
	int a08_k2 = 0;		//외근 대구지점 퇴사
	int a08_i2 = 0;		//외근 인천지점 퇴사
	int a08_w2 = 0;		//외근 수원지점 퇴사
	int a08_gs2 = 0;		//외근 강서지점 퇴사
	int a08_gr2 = 0;		//외근 구로지점 퇴사
	int a08_u2 = 0;		//외근 울산지점 퇴사
	int a08_jr2 = 0;
	int a08_sp2 = 0;
	int a08_it2 = 0;
	
	int a08_tot2 = 0;	//외근 퇴사 소계
	
	int a08_y3 = 0;    	//내근 영업팀 충원
	int a08_yk3 = 0;    	//내근 영업기획팀 충원
	int a08_g3 = 0;		//내근 고객관리팀 충원
	int a08_c3 = 0;		//내근 총무팀 충원
	int a08_b3 = 0;		//내근 부산지점 충원
	int a08_d3 = 0;		//내근 대전지점 충원
	int a08_s3 = 0;		//내근 강남지점 충원
	int a08_j3 = 0;		//내근 광주지점 충원
	int a08_k3 = 0;		//내근 대구지점 충원
	int a08_i3 = 0;		//내근 인천지점 충원
	int a08_w3 = 0;		//내근 수원지점 충원
	int a08_gs3 = 0;		//내근 강서지점 충원
	int a08_gr3 = 0;		//내근 구로지점 충원
	int a08_u3 = 0;		//내근 울산지점 충원
	int a08_jr3 = 0;
	int a08_sp3 = 0;
	int a08_it3 = 0;
	
	int a08_tot3 = 0;	//내근 충원 소계
	
	int a08_y4 = 0; 	//내근 영업팀 퇴사
	int a08_yk4 = 0; 	//내근 영업기획팀 퇴사
	int a08_g4 = 0;		//내근 고객관리팀 퇴사
	int a08_c4 = 0;		//내근 총무팀 퇴사
	int a08_b4 = 0;		//내근 부산지점 퇴사
	int a08_d4 = 0;		//내근 대전지점 퇴사
	int a08_s4 = 0;		//내근 강남지점 퇴사
	int a08_j4 = 0;		//내근 광주지점 퇴사
	int a08_k4 = 0;		//내근 대구지점 퇴사
	int a08_i4 = 0;		//내근 인천지점 퇴사
	int a08_w4 = 0;		//내근 수원지점 퇴사
	int a08_gs4 = 0;		//내근 강서지점 퇴사
	int a08_gr4 = 0;		//내근 구로지점 퇴사
	int a08_u4 = 0;		//내근 울산지점 퇴사
	int a08_jr4 = 0;
	int a08_sp4 = 0;
	int a08_it4 = 0;
	
	int a08_tot4 = 0;	//내근 퇴사 소계
	
	int tot_a0813 = 0;		//충원 합계
	int tot_a0824 = 0;		//퇴사 합계
	
	//당해-1
	int a07_y1 = 0;    	//외근 영업팀 충원
	int a07_yk1 = 0;    	//외근 영업기획팀 충원
	int a07_g1 = 0;		//외근 고객관리팀 충원
	int a07_c1 = 0;		//외근 총무팀 충원
	int a07_b1 = 0;		//외근 부산지점 충원
	int a07_d1 = 0;		//외근 대전지점 충원
	int a07_s1 = 0;		//외근 강남지점 충원
	int a07_j1 = 0;		//외근 광주지점 충원
	int a07_k1 = 0;		//외근 대구지점 충원
	int a07_i1 = 0;		//외근 인천지점 충원
	int a07_w1 = 0;		//외근 수원지점 충원
	int a07_gs1 = 0;		//외근 수원지점 충원
	int a07_gr1 = 0;		//외근 수원지점 충원
	int a07_u1 = 0;		//외근 수원지점 충원
	int a07_jr1 = 0;
	int a07_sp1 = 0;
	int a07_it1 = 0;
	
	int a07_tot1 = 0;	//외근 충원 소계
	
	int a07_y2 = 0; 	//외근 영업팀 퇴사
	int a07_yk2 = 0; 	//외근 영업기획팀 퇴사
	int a07_g2 = 0;		//외근 고객관리팀 퇴사
	int a07_c2 = 0;		//외근 총무팀 퇴사
	int a07_b2 = 0;		//외근 부산지점 퇴사
	int a07_d2 = 0;		//외근 대전지점 퇴사
	int a07_s2 = 0;		//외근 강남지점 퇴사
	int a07_j2 = 0;		//외근 광주지점 퇴사
	int a07_k2 = 0;		//외근 대구지점 퇴사
	int a07_i2 = 0;		//외근 인천지점 퇴사
	int a07_w2 = 0;		//외근 수원지점 퇴사
	int a07_gs2 = 0;		//외근 수원지점 퇴사
	int a07_gr2 = 0;		//외근 수원지점 퇴사
	int a07_u2 = 0;		//외근 수원지점 퇴사
	int a07_jr2 = 0;
	int a07_sp2 = 0;
	int a07_it2 = 0;
	
	int a07_tot2 = 0;	//외근 퇴사 소계
	
	int a07_y3 = 0;    //내근 영업팀 충원
	int a07_yk3 = 0;    //내근 영업기획팀 충원
	int a07_g3 = 0;		//내근 고객관리팀 충원
	int a07_c3 = 0;		//내근 총무팀 충원
	int a07_b3 = 0;		//내근 부산지점 충원
	int a07_d3 = 0;		//내근 대전지점 충원
	int a07_s3 = 0;		//내근 강남지점 충원
	int a07_j3 = 0;		//내근 광주지점 충원
	int a07_k3 = 0;		//내근 대구지점 충원
	int a07_i3 = 0;		//내근 인천지점 충원
	int a07_w3 = 0;		//내근 수원지점 충원
	int a07_gs3 = 0;		//내근 수원지점 충원
	int a07_gr3 = 0;		//내근 수원지점 충원
	int a07_u3 = 0;		//내근 수원지점 충원
	int a07_jr3 = 0;
	int a07_sp3 = 0;
	int a07_it3 = 0;
	
	int a07_tot3 = 0;	//내근 충원 소계
	
	int a07_y4 = 0; 	//내근 영업팀 퇴사
	int a07_yk4 = 0; 	//내근 영업기획팀 퇴사
	int a07_g4 = 0;		//내근 고객관리팀 퇴사
	int a07_c4 = 0;		//내근 총무팀 퇴사
	int a07_b4 = 0;		//내근 부산지점 퇴사
	int a07_d4 = 0;		//내근 대전지점 퇴사
	int a07_s4 = 0;		//내근 강남지점 퇴사
	int a07_j4 = 0;		//내근 광주지점 퇴사
	int a07_k4 = 0;		//내근 대구지점 퇴사
	int a07_i4 = 0;		//내근 인천지점 퇴사
	int a07_w4 = 0;		//내근 수원지점 퇴사
	int a07_gs4 = 0;		//내근 수원지점 퇴사
	int a07_gr4 = 0;		//내근 수원지점 퇴사
	int a07_u4 = 0;		//내근 수원지점 퇴사
	int a07_jr4 = 0;
	int a07_sp4 = 0;
	int a07_it4 = 0;
	
	int a07_tot4 = 0;	//내근 퇴사 소계
	
	int tot_a0713 = 0;		//충원 합계
	int tot_a0724 = 0;		//퇴사 합계
	
	int a06_y1 = 0;    //외근 영업팀 충원
	int a06_yk1 = 0;    //외근 영업기획팀 충원
	int a06_g1 = 0;		//외근 고객관리팀 충원
	int a06_c1 = 0;		//외근 총무팀 충원
	int a06_b1 = 0;		//외근 부산지점 충원
	int a06_d1 = 0;		//외근 대전지점 충원
	int a06_s1 = 0;		//외근 강남지점 충원
	int a06_j1 = 0;		//외근 광주지점 충원
	int a06_k1 = 0;		//외근 대구지점 충원
	int a06_i1 = 0;		//외근 인천지점 충원
	int a06_w1 = 0;		//외근 수원지점 충원
	int a06_gs1 = 0;		//외근 수원지점 충원
	int a06_gr1 = 0;		//외근 수원지점 충원
	int a06_u1 = 0;		//외근 수원지점 충원
	int a06_jr1 = 0;
	int a06_sp1 = 0;
	int a06_it1 = 0;
	
	int a06_tot1 = 0;	//외근 충원 소계
	
	int a06_y2 = 0; 	//외근 영업팀 퇴사
	int a06_yk2 = 0; 	//외근 영업기획팀 퇴사
	int a06_g2 = 0;		//외근 고객관리팀 퇴사
	int a06_c2 = 0;		//외근 총무팀 퇴사
	int a06_b2 = 0;		//외근 부산지점 퇴사
	int a06_d2 = 0;		//외근 대전지점 퇴사
	int a06_s2 = 0;		//외근 강남지점 퇴사
	int a06_j2 = 0;		//외근 광주지점 퇴사
	int a06_k2 = 0;		//외근 대구지점 퇴사
	int a06_i2 = 0;		//외근 인천지점 퇴사
	int a06_w2 = 0;		//외근 수원지점 퇴사
	int a06_gs2 = 0;		//외근 수원지점 퇴사
	int a06_gr2 = 0;		//외근 수원지점 퇴사
	int a06_u2 = 0;		//외근 수원지점 퇴사
	int a06_jr2 = 0;
	int a06_sp2 = 0;
	int a06_it2 = 0;
	
	int a06_tot2 = 0;	//외근 퇴사 소계
	
	int a06_y3 = 0;    //내근 영업팀 충원
	int a06_yk3 = 0;    //내근 영업기획팀 충원
	int a06_g3 = 0;		//내근 고객관리팀 충원
	int a06_c3 = 0;		//내근 총무팀 충원
	int a06_b3 = 0;		//내근 부산지점 충원
	int a06_d3 = 0;		//내근 대전지점 충원
	int a06_s3 = 0;		//내근 강남지점 충원
	int a06_j3 = 0;		//내근 광주지점 충원
	int a06_k3 = 0;		//내근 대구지점 충원
	int a06_i3 = 0;		//내근 인천지점 충원
	int a06_w3 = 0;		//내근 수원지점 충원
	int a06_gs3 = 0;		//내근 수원지점 충원
	int a06_gr3 = 0;		//내근 수원지점 충원
	int a06_u3 = 0;		//내근 수원지점 충원
	int a06_jr3 = 0;
	int a06_sp3 = 0;
	int a06_it3 = 0;
	
	int a06_tot3 = 0;	//내근 충원 소계
	
	int a06_y4 = 0; 	//내근 영업팀 퇴사
	int a06_yk4 = 0; 	//내근 영업기획팀 퇴사
	int a06_g4 = 0;		//내근 고객관리팀 퇴사
	int a06_c4 = 0;		//내근 총무팀 퇴사
	int a06_b4 = 0;		//내근 부산지점 퇴사
	int a06_d4 = 0;		//내근 대전지점 퇴사
	int a06_s4 = 0;		//내근 강남지점 퇴사
	int a06_j4 = 0;		//내근 광주지점 퇴사
	int a06_k4 = 0;		//내근 대구지점 퇴사
	int a06_i4 = 0;		//내근 인천지점 퇴사
	int a06_w4 = 0;		//내근 수원지점 퇴사
	int a06_gs4 = 0;		//내근 수원지점 퇴사
	int a06_gr4 = 0;		//내근 수원지점 퇴사
	int a06_u4 = 0;		//내근 수원지점 퇴사
	int a06_jr4 = 0;
	int a06_sp4 = 0;
	int a06_it4 = 0;
	
	int a06_tot4 = 0;	//내근 퇴사 소계
	
	int tot_a0613 = 0;		//충원 합계
	int tot_a0624 = 0;		//퇴사 합계

//부서별현황 2008
	int a08_y13 = 0;
	int a08_yk13 = 0;
	int a08_g13 = 0;
	int a08_c13 = 0;
	int a08_it13 = 0;
	int a08_ygc13 = 0;
	
	int a08_b13 = 0;
	int a08_d13 = 0;
	int a08_s13 = 0;
	int a08_j13 = 0;
	int a08_k13 = 0;
	int a08_i13 = 0;
	int a08_w13 = 0;
	int a08_gs13 = 0;
	int a08_gr13 = 0;
	int a08_u13 = 0;
	int a08_jr13 = 0;
	int a08_sp13 = 0;
	int a08_bd13 = 0;
	
	int a08_tot13 = 0;
	
	int a08_y24 = 0;
	int a08_yk24 = 0;
	int a08_g24 = 0;
	int a08_c24 = 0;
	int a08_it24 = 0;
	int a08_ygc24 = 0;
	
	int a08_b24 = 0;
	int a08_d24 = 0;
	int a08_s24 = 0;
	int a08_j24 = 0;
	int a08_k24 = 0;
	int a08_i24 = 0;
	int a08_w24 = 0;
	int a08_gs24 = 0;
	int a08_gr24 = 0;
	int a08_u24 = 0;
	int a08_jr24 = 0;
	int a08_sp24 = 0;
	int a08_bd24 = 0;
	
	int a08_tot24 = 0;

//부서별현황 2007	
	int a07_y13 = 0;
	int a07_yk13 = 0;
	int a07_g13 = 0;
	int a07_c13 = 0;
	int a07_it13 = 0;
	int a07_ygc13 = 0;
	
	int a07_b13 = 0;
	int a07_d13 = 0;
	int a07_s13 = 0;
	int a07_j13 = 0;
	int a07_k13 = 0;
	int a07_i13 = 0;
	int a07_w13 = 0;
	int a07_gs13 = 0;
	int a07_gr13 = 0;
	int a07_u13 = 0;
	int a07_jr13 = 0;
	int a07_sp13 = 0;
	int a07_bd13 = 0;
	
	int a07_tot13 = 0;
	
	int a07_y24 = 0;
	int a07_yk24 = 0;
	int a07_g24 = 0;
	int a07_c24 = 0;
	int a07_it24 = 0;
	int a07_ygc24 = 0;
	
	int a07_b24 = 0;
	int a07_d24 = 0;
	int a07_s24 = 0;
	int a07_j24 = 0;
	int a07_k24 = 0;
	int a07_i24 = 0;
	int a07_w24 = 0;
	int a07_gs24 = 0;
	int a07_gr24 = 0;
	int a07_u24 = 0;
	int a07_jr24 = 0;
	int a07_sp24 = 0;
	int a07_bd24 = 0;
	
	int a07_tot24 = 0;

//부서별현황 2006	
	int a06_y13 = 0;
	int a06_yk13 = 0;
	int a06_g13 = 0;
	int a06_c13 = 0;
	int a06_it13 = 0;
	int a06_ygc13 = 0;
	
	int a06_b13 = 0;
	int a06_d13 = 0;
	int a06_s13 = 0;
	int a06_j13 = 0;
	int a06_k13 = 0;
	int a06_i13 = 0;
	int a06_w13 = 0;
	int a06_gs13 = 0;
	int a06_gr13 = 0;
	int a06_u13 = 0;
	int a06_jr13 = 0;
	int a06_sp13 = 0;
	int a06_bd13 = 0;
	
	int a06_tot13 = 0;
	
	int a06_y24 = 0;
	int a06_yk24 = 0;
	int a06_g24 = 0;
	int a06_c24 = 0;
	int a06_it24 = 0;
	int a06_ygc24 = 0;
	
	int a06_b24 = 0;
	int a06_d24 = 0;
	int a06_s24 = 0;
	int a06_j24 = 0;
	int a06_k24 = 0;
	int a06_i24 = 0;
	int a06_w24 = 0;
	int a06_gs24 = 0;
	int a06_gr24 = 0;
	int a06_u24 = 0;
	int a06_jr24 = 0;
	int a06_sp24 = 0;
	int a06_bd24 = 0;
	
	int a06_tot24 = 0;
	
	int start_year = Util.parseInt(request.getParameter("start_year"));
	int nyear = 0;
	if(start_year==0)
	{
		nyear = calendar.getThisYear();
	}else{
		nyear = start_year;
	}
	int thisyears = Util.parseInt(nyear+"0101");
	int thisyear1s = Util.parseInt((nyear-1)+"0101");
	int thisyear2s = Util.parseInt((nyear-2)+"0101");
	
	int thisyeare = Util.parseInt(nyear+"1231");
	int thisyear1e = Util.parseInt((nyear-1)+"1231");
	int thisyear2e = Util.parseInt((nyear-2)+"1231");
	
	Vector vt08i = ic_db.gylist2008In(user_id, thisyears, thisyeare);
	int vt08i_size = vt08i.size();

	Vector vt08o = ic_db.gylist2008Out(user_id, thisyears, thisyeare);
	int vt08o_size = vt08o.size();
	
	Vector vt07i = ic_db.gylist2007In(user_id, thisyear1s, thisyear1e);
	int vt07i_size = vt07i.size();

	Vector vt07o = ic_db.gylist2007Out(user_id, thisyear1s, thisyear1e);
	int vt07o_size = vt07o.size();
	
	Vector vt06i = ic_db.gylist2006In(user_id, thisyear2s, thisyear2e);
	int vt06i_size = vt06i.size();

	Vector vt06o = ic_db.gylist2006Out(user_id, thisyear2s, thisyear2e);
	int vt06o_size = vt06o.size();
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">

<!--

//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<%if(vt08i_size > 0)	{ 			
	for(int i = 0 ; i < vt08i_size ; i++){
		Hashtable ht08i = (Hashtable)vt08i.elementAt(i);
		
		if(ht08i.get("DEPT_ID").equals("0001")	&& (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_y1++;		} 
		else if(ht08i.get("DEPT_ID").equals("0020")	&& (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_yk1++;		} 
		else if(ht08i.get("DEPT_ID").equals("0002") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_g1++;		}
		else if(ht08i.get("DEPT_ID").equals("0003") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_c1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0005") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_it1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0007") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_b1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0008") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_d1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0009") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_s1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0010") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_j1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0011") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_k1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0012") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_i1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0013") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_w1++;		}  
		
		else if(ht08i.get("DEPT_ID").equals("0014") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_gs1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0015") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_gr1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0016") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_u1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0017") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_jr1++;		}  
		else if(ht08i.get("DEPT_ID").equals("0018") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08_sp1++;		}  

		
		else if(ht08i.get("DEPT_ID").equals("0001") && ht08i.get("LOAN_ST").equals("")){		a08_y3++;		}
		else if(ht08i.get("DEPT_ID").equals("0020") && ht08i.get("LOAN_ST").equals("")){		a08_yk3++;		}
		else if(ht08i.get("DEPT_ID").equals("0002") && ht08i.get("LOAN_ST").equals("")){		a08_g3++;		}
		else if(ht08i.get("DEPT_ID").equals("0003") && ht08i.get("LOAN_ST").equals("")){		a08_c3++;		}
		else if(ht08i.get("DEPT_ID").equals("0005") && ht08i.get("LOAN_ST").equals("")){		a08_it3++;		}
		else if(ht08i.get("DEPT_ID").equals("0007") && ht08i.get("LOAN_ST").equals("")){		a08_b3++;		}
		else if(ht08i.get("DEPT_ID").equals("0008") && ht08i.get("LOAN_ST").equals("")){		a08_d3++;		}
		else if(ht08i.get("DEPT_ID").equals("0009") && ht08i.get("LOAN_ST").equals("")){		a08_s3++;		}
		else if(ht08i.get("DEPT_ID").equals("0010") && ht08i.get("LOAN_ST").equals("")){		a08_j3++;		}
		else if(ht08i.get("DEPT_ID").equals("0011") && ht08i.get("LOAN_ST").equals("")){		a08_k3++;		}
		else if(ht08i.get("DEPT_ID").equals("0012") && ht08i.get("LOAN_ST").equals("")){		a08_i3++;		}
		else if(ht08i.get("DEPT_ID").equals("0013") && ht08i.get("LOAN_ST").equals("")){		a08_w3++;		}
		
		else if(ht08i.get("DEPT_ID").equals("0014") && ht08i.get("LOAN_ST").equals("")){		a08_gs3++;		}
		else if(ht08i.get("DEPT_ID").equals("0015") && ht08i.get("LOAN_ST").equals("")){		a08_gr3++;		}
		else if(ht08i.get("DEPT_ID").equals("0016") && ht08i.get("LOAN_ST").equals("")){		a08_u3++;		}
		else if(ht08i.get("DEPT_ID").equals("0017") && ht08i.get("LOAN_ST").equals("")){		a08_jr3++;		}
		else if(ht08i.get("DEPT_ID").equals("0018") && ht08i.get("LOAN_ST").equals("")){		a08_sp3++;		}
		
		
		
		
		a08_tot1 = a08_yk1 + a08_y1 + a08_g1 + a08_c1 + a08_b1 + a08_d1 + a08_s1 + a08_j1 + a08_k1 + a08_i1 + a08_w1 + a08_gs1 + a08_gr1 + a08_u1 + a08_jr1 + a08_sp1 + a08_it1;
		
		a08_tot3 = a08_yk3 + a08_y3 + a08_g3 + a08_c3 + a08_b3 + a08_d3 + a08_s3 + a08_j3 + a08_k3 + a08_i3 + a08_w3 + a08_gs3 + a08_gr3 + a08_u3 + a08_jr3 + a08_sp3 + a08_it3;
		
		tot_a0813 = a08_tot1 + a08_tot3;
		}
	}
	
%> 
<%if(vt08o_size > 0)	{ 			
	for(int i = 0 ; i < vt08o_size ; i++){
		Hashtable ht08o = (Hashtable)vt08o.elementAt(i);
		
		if(ht08o.get("DEPT_OUT").equals("0001")	&& (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_y2++;		} 
		else if(ht08o.get("DEPT_OUT").equals("0020")	&& (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_yk2++;		} 
		else if(ht08o.get("DEPT_OUT").equals("0002") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_g2++;		}
		else if(ht08o.get("DEPT_OUT").equals("0003") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_c2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0005") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_it2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0007") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_b2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0008") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_d2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0009") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_s2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0010") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_j2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0011") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_k2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0012") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_i2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0013") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_w2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0014") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_gs2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0015") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_gr2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0016") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_u2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0017") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_jr2++;		}  
		else if(ht08o.get("DEPT_OUT").equals("0018") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08_sp2++;		}  
		
		else if(ht08o.get("DEPT_OUT").equals("0001") && ht08o.get("LOAN_ST").equals("")){		a08_y4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0020") && ht08o.get("LOAN_ST").equals("")){		a08_yk4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0002") && ht08o.get("LOAN_ST").equals("")){		a08_g4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0003") && ht08o.get("LOAN_ST").equals("")){		a08_c4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0005") && ht08o.get("LOAN_ST").equals("")){		a08_it4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0007") && ht08o.get("LOAN_ST").equals("")){		a08_b4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0008") && ht08o.get("LOAN_ST").equals("")){		a08_d4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0009") && ht08o.get("LOAN_ST").equals("")){		a08_s4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0010") && ht08o.get("LOAN_ST").equals("")){		a08_j4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0011") && ht08o.get("LOAN_ST").equals("")){		a08_k4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0012") && ht08o.get("LOAN_ST").equals("")){		a08_i4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0013") && ht08o.get("LOAN_ST").equals("")){		a08_w4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0014") && ht08o.get("LOAN_ST").equals("")){		a08_gs4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0015") && ht08o.get("LOAN_ST").equals("")){		a08_gr4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0016") && ht08o.get("LOAN_ST").equals("")){		a08_u4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0017") && ht08o.get("LOAN_ST").equals("")){		a08_jr4++;		}
		else if(ht08o.get("DEPT_OUT").equals("0018") && ht08o.get("LOAN_ST").equals("")){		a08_sp4++;		}
		
		
		a08_tot2 = a08_y2 + a08_yk2 + a08_g2 + a08_c2 + a08_b2 + a08_d2 + a08_s2 + a08_j2 + a08_k2 + a08_i2 + a08_w2 + a08_gs2 + a08_gr2 + a08_u2 + a08_jr2 + a08_sp2+a08_it2;
		
		a08_tot4 = a08_y4 + a08_yk4 + a08_g4 + a08_c4 + a08_b4 + a08_d4 + a08_s4 + a08_j4 + a08_k4 + a08_i4 + a08_w4 + a08_gs4 + a08_gr4 + a08_u4 + a08_jr4 + a08_sp4+a08_it4;
		
		tot_a0824 = a08_tot2 + a08_tot4;
		}
	}
	
%>	
<%if(vt07i_size > 0)	{ 			
	for(int i = 0 ; i < vt07i_size ; i++){
		Hashtable ht07i = (Hashtable)vt07i.elementAt(i);
		
		if(ht07i.get("DEPT_ID").equals("0001")	&& (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_y1++;		} 
		else if(ht07i.get("DEPT_ID").equals("0020")	&& (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_yk1++;		} 
		else if(ht07i.get("DEPT_ID").equals("0002") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_g1++;		}
		else if(ht07i.get("DEPT_ID").equals("0003") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_c1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0005") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_it1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0007") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_b1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0007") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_d1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0009") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_s1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0010") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_j1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0011") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_k1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0012") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_i1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0013") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_w1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0014") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_gs1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0015") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_gr1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0016") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_u1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0017") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_jr1++;		}  
		else if(ht07i.get("DEPT_ID").equals("0018") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07_sp1++;		}  
		
		else if(ht07i.get("DEPT_ID").equals("0001") && ht07i.get("LOAN_ST").equals("")){		a07_y3++;		}
		else if(ht07i.get("DEPT_ID").equals("0020") && ht07i.get("LOAN_ST").equals("")){		a07_yk3++;		}
		else if(ht07i.get("DEPT_ID").equals("0002") && ht07i.get("LOAN_ST").equals("")){		a07_g3++;		}
		else if(ht07i.get("DEPT_ID").equals("0003") && ht07i.get("LOAN_ST").equals("")){		a07_c3++;		}
		else if(ht07i.get("DEPT_ID").equals("0005") && ht07i.get("LOAN_ST").equals("")){		a07_it3++;		}
		else if(ht07i.get("DEPT_ID").equals("0007") && ht07i.get("LOAN_ST").equals("")){		a07_b3++;		}
		else if(ht07i.get("DEPT_ID").equals("0007") && ht07i.get("LOAN_ST").equals("")){		a07_d3++;		}
		else if(ht07i.get("DEPT_ID").equals("0009") && ht07i.get("LOAN_ST").equals("")){		a07_s3++;		}
		else if(ht07i.get("DEPT_ID").equals("0010") && ht07i.get("LOAN_ST").equals("")){		a07_j3++;		}
		else if(ht07i.get("DEPT_ID").equals("0011") && ht07i.get("LOAN_ST").equals("")){		a07_k3++;		}
		else if(ht07i.get("DEPT_ID").equals("0012") && ht07i.get("LOAN_ST").equals("")){		a07_i3++;		}
		else if(ht07i.get("DEPT_ID").equals("0013") && ht07i.get("LOAN_ST").equals("")){		a07_w3++;		}
		else if(ht07i.get("DEPT_ID").equals("0014") && ht07i.get("LOAN_ST").equals("")){		a07_gs3++;		}
		else if(ht07i.get("DEPT_ID").equals("0015") && ht07i.get("LOAN_ST").equals("")){		a07_gr3++;		}
		else if(ht07i.get("DEPT_ID").equals("0016") && ht07i.get("LOAN_ST").equals("")){		a07_u3++;		}
		else if(ht07i.get("DEPT_ID").equals("0017") && ht07i.get("LOAN_ST").equals("")){		a07_jr3++;		}
		else if(ht07i.get("DEPT_ID").equals("0018") && ht07i.get("LOAN_ST").equals("")){		a07_sp3++;		}
		
		a07_tot1 = a07_y1 + a07_yk1 + a07_g1 + a07_c1 + a07_b1 + a07_d1 + a07_s1 + a07_j1 + a07_k1 + a07_i1 + a07_w1 + a07_gs1 + a07_gr1 + a07_u1 + a07_jr1 + a07_sp1+a07_it1;
		
		a07_tot3 = a07_y3 + a07_yk3 + a07_g3 + a07_c3 + a07_b3 + a07_d3 + a07_s3 + a07_j3 + a07_k3 + a07_i3 + a07_w3 + a07_gs3 + a07_gr3 + a07_u3 + a07_jr3 + a07_sp3+a07_it3;
		
		tot_a0713 = a07_tot1 + a07_tot3;
		}
	}
	
%> 
<%if(vt07o_size > 0)	{ 			
	for(int i = 0 ; i < vt07o_size ; i++){
		Hashtable ht07o = (Hashtable)vt07o.elementAt(i);
		
		if(ht07o.get("DEPT_OUT").equals("0001")	&& (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_y2++;		} 
		else if(ht07o.get("DEPT_OUT").equals("0020")	&& (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_yk2++;		} 
		else if(ht07o.get("DEPT_OUT").equals("0002") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_g2++;		}
		else if(ht07o.get("DEPT_OUT").equals("0003") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_c2++;		}  
		else if(ht07o.get("DEPT_OUT").equals("0005") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_it2++;		}  
		else if(ht07o.get("DEPT_OUT").equals("0007") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_b2++;		}  
		else if(ht07o.get("DEPT_OUT").equals("0008") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_d2++;		}  
		else if(ht07o.get("DEPT_OUT").equals("0009") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_s2++;		}  
		else if(ht07o.get("DEPT_OUT").equals("0010") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_j2++;		}  
		else if(ht07o.get("DEPT_OUT").equals("0011") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_k2++;		}  
		else if(ht07o.get("DEPT_OUT").equals("0012") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_i2++;		}  
		else if(ht07o.get("DEPT_OUT").equals("0013") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_w2++;		} 
		else if(ht07o.get("DEPT_OUT").equals("0014") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_gs2++;		} 
		else if(ht07o.get("DEPT_OUT").equals("0015") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_gr2++;		} 
		else if(ht07o.get("DEPT_OUT").equals("0016") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_u2++;		} 
		else if(ht07o.get("DEPT_OUT").equals("0017") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_jr2++;		} 
		else if(ht07o.get("DEPT_OUT").equals("0018") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07_sp2++;		} 
		
		else if(ht07o.get("DEPT_OUT").equals("0001") && ht07o.get("LOAN_ST").equals("")){		a07_y4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0020") && ht07o.get("LOAN_ST").equals("")){		a07_yk4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0002") && ht07o.get("LOAN_ST").equals("")){		a07_g4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0003") && ht07o.get("LOAN_ST").equals("")){		a07_c4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0005") && ht07o.get("LOAN_ST").equals("")){		a07_it4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0007") && ht07o.get("LOAN_ST").equals("")){		a07_b4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0008") && ht07o.get("LOAN_ST").equals("")){		a07_d4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0009") && ht07o.get("LOAN_ST").equals("")){		a07_s4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0010") && ht07o.get("LOAN_ST").equals("")){		a07_j4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0011") && ht07o.get("LOAN_ST").equals("")){		a07_k4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0012") && ht07o.get("LOAN_ST").equals("")){		a07_i4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0013") && ht07o.get("LOAN_ST").equals("")){		a07_w4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0014") && ht07o.get("LOAN_ST").equals("")){		a07_gs4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0015") && ht07o.get("LOAN_ST").equals("")){		a07_gr4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0016") && ht07o.get("LOAN_ST").equals("")){		a07_u4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0017") && ht07o.get("LOAN_ST").equals("")){		a07_jr4++;		}
		else if(ht07o.get("DEPT_OUT").equals("0018") && ht07o.get("LOAN_ST").equals("")){		a07_sp4++;		}
		
		a07_tot2 = a07_y2 + a07_yk2 + a07_g2 + a07_c2 + a07_b2 + a07_d2 + a07_s2 + a07_j2 + a07_k2 + a07_i2 + a07_w2 + a07_gs2 + a07_gr2 + a07_u2 + a07_jr2 + a07_sp2+a07_it2;
		
		a07_tot4 = a07_y4 + a07_yk4 + a07_g4 + a07_c4 + a07_b4 + a07_d4 + a07_s4 + a07_j4 + a07_k4 + a07_i4 + a07_w4 + a07_gs4 + a07_gr4 + a07_u4 + a07_jr4 + a07_sp4+a07_it4;
		tot_a0724 = a07_tot2 + a07_tot4;
		}
	}
	
%>	
<%if(vt06i_size > 0)	{ 			
	for(int i = 0 ; i < vt06i_size ; i++){
		Hashtable ht06i = (Hashtable)vt06i.elementAt(i);
		
		if(ht06i.get("DEPT_ID").equals("0001")	&& (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_y1++;		} 
		else if(ht06i.get("DEPT_ID").equals("0020")	&& (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_yk1++;		} 
		else if(ht06i.get("DEPT_ID").equals("0002") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_g1++;		}
		else if(ht06i.get("DEPT_ID").equals("0003") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_c1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0005") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_it1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0007") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_b1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0008") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_d1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0009") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_s1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0010") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_j1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0011") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_k1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0012") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_i1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0013") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_w1++;		}  
		
		else if(ht06i.get("DEPT_ID").equals("0014") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_gs1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0015") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_gr1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0016") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_u1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0017") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_jr1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0018") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06_sp1++;		}  
		
		else if(ht06i.get("DEPT_ID").equals("0001") && ht06i.get("LOAN_ST").equals("")){		a06_y3++;		}
		else if(ht06i.get("DEPT_ID").equals("0020") && ht06i.get("LOAN_ST").equals("")){		a06_yk3++;		}
		else if(ht06i.get("DEPT_ID").equals("0002") && ht06i.get("LOAN_ST").equals("")){		a06_g3++;		}
		else if(ht06i.get("DEPT_ID").equals("0003") && ht06i.get("LOAN_ST").equals("")){		a06_c3++;		}
		else if(ht06i.get("DEPT_ID").equals("0005") && ht06i.get("LOAN_ST").equals("")){		a06_it3++;		}
		else if(ht06i.get("DEPT_ID").equals("0007") && ht06i.get("LOAN_ST").equals("")){		a06_b3++;		}
		else if(ht06i.get("DEPT_ID").equals("0008") && ht06i.get("LOAN_ST").equals("")){		a06_d3++;		}
		else if(ht06i.get("DEPT_ID").equals("0009") && ht06i.get("LOAN_ST").equals("")){		a06_s3++;		}
		else if(ht06i.get("DEPT_ID").equals("0010") && ht06i.get("LOAN_ST").equals("")){		a06_j3++;		}
		else if(ht06i.get("DEPT_ID").equals("0011") && ht06i.get("LOAN_ST").equals("")){		a06_k3++;		}
		else if(ht06i.get("DEPT_ID").equals("0012") && ht06i.get("LOAN_ST").equals("")){		a06_i3++;		}
		else if(ht06i.get("DEPT_ID").equals("0013") && ht06i.get("LOAN_ST").equals("")){		a06_w3++;		}
		else if(ht06i.get("DEPT_ID").equals("0014") && ht06i.get("LOAN_ST").equals("")){		a06_gs3++;		}
		else if(ht06i.get("DEPT_ID").equals("0015") && ht06i.get("LOAN_ST").equals("")){		a06_gr3++;		}
		else if(ht06i.get("DEPT_ID").equals("0016") && ht06i.get("LOAN_ST").equals("")){		a06_u3++;		}
		else if(ht06i.get("DEPT_ID").equals("0017") && ht06i.get("LOAN_ST").equals("")){		a06_jr3++;		}
		else if(ht06i.get("DEPT_ID").equals("0018") && ht06i.get("LOAN_ST").equals("")){		a06_sp3++;		}
		
		a06_tot1 = a06_y1 + a06_yk1 + a06_g1 + a06_c1 + a06_b1 + a06_d1 + a06_s1 + a06_j1 + a06_k1 + a06_i1 + a06_w1 + a06_gs1 + a06_gr1 + a06_u1 + a06_jr1 + a06_sp1+a06_it1;
		
		a06_tot3 = a06_y3 + a06_yk3 + a06_g3 + a06_c3 + a06_b3 + a06_d3 + a06_s3 + a06_j3 + a06_k3 + a06_i3 + a06_w3 + a06_gs3 + a06_gr3 + a06_u3 + a06_jr1 + a06_sp1+a06_it3;
		
		tot_a0613 = a06_tot1 + a06_tot3;
		}
	}
	
%> 
<%if(vt06o_size > 0)	{ 			
	for(int i = 0 ; i < vt06o_size ; i++){
		Hashtable ht06o = (Hashtable)vt06o.elementAt(i);
		
		if(ht06o.get("DEPT_OUT").equals("0001")	&& (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_y2++;		}
		else if(ht06o.get("DEPT_OUT").equals("0020")	&& (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_yk2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0002") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_g2++;		}
		else if(ht06o.get("DEPT_OUT").equals("0003") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_c2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0005") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_it2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0007") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_b2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0008") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_d2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0009") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_s2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0010") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_j2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0011") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_k2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0012") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_i2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0013") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_w2++;		} 
		else if(ht06o.get("DEPT_OUT").equals("0014") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_gs2++;		} 
		else if(ht06o.get("DEPT_OUT").equals("0015") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_gr2++;		} 
		else if(ht06o.get("DEPT_OUT").equals("0016") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_u2++;		} 
		else if(ht06o.get("DEPT_OUT").equals("0017") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_jr2++;		} 
		else if(ht06o.get("DEPT_OUT").equals("0018") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06_sp2++;		} 
		
		else if(ht06o.get("DEPT_OUT").equals("0001") && ht06o.get("LOAN_ST").equals("")){		a06_y4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0020") && ht06o.get("LOAN_ST").equals("")){		a06_yk4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0002") && ht06o.get("LOAN_ST").equals("")){		a06_g4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0003") && ht06o.get("LOAN_ST").equals("")){		a06_c4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0005") && ht06o.get("LOAN_ST").equals("")){		a06_it4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0007") && ht06o.get("LOAN_ST").equals("")){		a06_b4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0008") && ht06o.get("LOAN_ST").equals("")){		a06_d4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0009") && ht06o.get("LOAN_ST").equals("")){		a06_s4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0010") && ht06o.get("LOAN_ST").equals("")){		a06_j4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0011") && ht06o.get("LOAN_ST").equals("")){		a06_k4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0012") && ht06o.get("LOAN_ST").equals("")){		a06_i4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0013") && ht06o.get("LOAN_ST").equals("")){		a06_w4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0014") && ht06o.get("LOAN_ST").equals("")){		a06_gs4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0015") && ht06o.get("LOAN_ST").equals("")){		a06_gr4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0016") && ht06o.get("LOAN_ST").equals("")){		a06_u4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0017") && ht06o.get("LOAN_ST").equals("")){		a06_jr4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0018") && ht06o.get("LOAN_ST").equals("")){		a06_sp4++;		}
		
		a06_tot2 = a06_y2 + a06_yk2 + a06_g2 + a06_c2 + a06_b2 + a06_d2 + a06_s2 + a06_j2 + a06_k2 + a06_i2 + a06_w2 + a06_gs2 + a06_gr2 + a06_u2 + a06_jr2 + a06_sp2+a06_it2;
		
		a06_tot4 = a06_y4 + a06_yk4 + a06_g4 + a06_c4 + a06_b4 + a06_d4 + a06_s4 + a06_j4 + a06_k4 + a06_i4 + a06_w4 + a06_gs4 + a06_gr4 + a06_u4 + a06_jr4 + a06_sp4+a06_it4;
		tot_a0624 = a06_tot2 + a06_tot4;
		}
	}
	
%>	
<%
	a08_yk13 = a08_yk1 + a08_yk3;
	a08_y13 = a08_y1 + a08_y3;
	a08_g13 = a08_g1 + a08_g3;
	a08_c13 = a08_c1 + a08_c3;
	
	a08_it13 = a08_it1 + a08_it3;
	
	a08_b13 = a08_b1 + a08_b3;
	a08_d13 = a08_d1 + a08_d3;
	a08_s13 = a08_s1 + a08_s3;
	a08_j13 = a08_j1 + a08_j3;
	a08_k13 = a08_k1 + a08_k3;
	a08_i13 = a08_i1 + a08_i3;
	a08_w13 = a08_w1 + a08_w3;
	a08_gs13 = a08_gs1 + a08_gs3;
	a08_gr13 = a08_gr1 + a08_gr3;
	a08_u13 = a08_u1 + a08_u3;
	a08_jr13 = a08_jr1 + a08_jr3;
	a08_sp13 = a08_sp1 + a08_sp3;
	
	a08_ygc13 = a08_y13 + a08_yk13 + a08_g13 + a08_c13+a08_it13;
	
	a08_bd13 = a08_b13 + a08_d13 + a08_s13 + a08_j13 + a08_k13 + a08_i13 + a08_w13 + a08_gs13 + a08_gr13 + a08_u13 + a08_jr13 + a08_sp13;
	a08_tot13 = a08_ygc13 + a08_bd13;
	
	a07_yk13 = a07_yk1 + a07_yk3;
	a07_y13 = a07_y1 + a07_y3;
	a07_g13 = a07_g1 + a07_g3;
	a07_c13 = a07_c1 + a07_c3;
	
	a07_it13 = a07_it1 + a07_it3;
	
	a07_b13 = a07_b1 + a07_b3;
	a07_d13 = a07_d1 + a07_d3;
	a07_s13 = a07_s1 + a07_s3;
	a07_j13 = a07_j1 + a07_j3;
	a07_k13 = a07_k1 + a07_k3;
	a07_i13 = a07_i1 + a07_i3;
	a07_w13 = a07_w1 + a07_w3;
	a07_gs13 = a07_gs1 + a07_gs3;
	a07_gr13 = a07_gr1 + a07_gr3;
	a07_u13 = a07_u1 + a07_u3;
	a07_jr13 = a07_jr1 + a07_jr3;
	a07_sp13 = a07_sp1 + a07_sp3;
	
	a07_ygc13 = a07_y13 + a07_yk13 + a07_g13 + a07_c13+a07_it13;
	
	a07_bd13 = a07_b13 + a07_d13 + a07_s13 + a07_j13 + a07_k13 + a07_i13 + a07_w13 + a07_gs13 + a07_gr13 + a07_u13 + a07_jr13 + a07_sp13;
	a07_tot13 = a07_ygc13 + a07_bd13;
	
	a06_yk13 = a06_yk1 + a06_yk3;
	a06_y13 = a06_y1 + a06_y3;
	a06_g13 = a06_g1 + a06_g3;
	a06_c13 = a06_c1 + a06_c3;
	a06_it13 = a06_it1 + a06_it3;
	
	a06_b13 = a06_b1 + a06_b3;
	a06_d13 = a06_d1 + a06_d3;
	a06_s13 = a06_s1 + a06_s3;
	a06_j13 = a06_j1 + a06_j3;
	a06_k13 = a06_k1 + a06_k3;
	a06_i13 = a06_i1 + a06_i3;
	a06_w13 = a06_w1 + a06_w3;
	
	a06_gs13 = a06_gs1 + a06_gs3;
	a06_gr13 = a06_gr1 + a06_gr3;
	a06_u13 = a06_u1 + a06_u3;
	a06_jr13 = a06_jr1 + a06_jr3;
	a06_sp13 = a06_sp1 + a06_sp3;
	
	a06_ygc13 = a06_y13 + a06_yk13 + a06_g13 + a06_c13+a06_it13;
	
	a06_bd13 = a06_b13 + a06_d13 + a06_s13 + a06_j13 + a06_k13 + a06_i13 + a06_w13 + a06_gs13 + a06_gr13 + a06_u13 + a06_jr13 + a06_sp13;
	a06_tot13 = a06_ygc13 + a06_bd13;
	
	a08_yk24 = a08_yk2 + a08_yk4;
	a08_y24 = a08_y2 + a08_y4;
	a08_g24 = a08_g2 + a08_g4;
	a08_c24 = a08_c2 + a08_c4;
	a08_it24 = a08_it2 + a08_it4;
	
	a08_b24 = a08_b2 + a08_b4;
	a08_d24 = a08_d2 + a08_d4;
	a08_s24 = a08_s2 + a08_s4;
	a08_j24 = a08_j2 + a08_j4;
	a08_k24 = a08_k2 + a08_k4;
	a08_i24 = a08_i2 + a08_i4;
	a08_w24 = a08_w2 + a08_w4;
	a08_gs24 = a08_gs2 + a08_gs4;
	a08_gr24 = a08_gr2 + a08_gr4;
	a08_u24 = a08_u2 + a08_u4;
	a08_jr24 = a08_jr2 + a08_jr4;
	a08_sp24 = a08_sp2 + a08_sp4;
	
	a08_ygc24 = a08_y24 + a08_yk24 + a08_g24 + a08_c24+a08_it24;
	a08_bd24 = a08_b24 + a08_d24 + a08_s24 + a08_j24 + a08_k24 + a08_i24 + a08_w24 + a08_gs24 + a08_gr24 + a08_u24 + a08_jr24 + a08_sp24;
	a08_tot24 = a08_ygc24 + a08_bd24;

	a07_yk24 = a07_yk2 + a07_yk4;
	a07_y24 = a07_y2 + a07_y4;
	a07_g24 = a07_g2 + a07_g4;
	a07_c24 = a07_c2 + a07_c4;
	a07_it24 = a07_it2 + a07_it4;
	
	a07_b24 = a07_b2 + a07_b4;
	a07_d24 = a07_d2 + a07_d4;
	a07_s24 = a07_s2 + a07_s4;
	a07_j24 = a07_j2 + a07_j4;
	a07_k24 = a07_k2 + a07_k4;
	a07_i24 = a07_i2 + a07_i4;
	a07_w24 = a07_w2 + a07_w4;
	
	a07_gs24 = a07_gs2 + a07_gs4;
	a07_gr24 = a07_gr2 + a07_gr4;
	a07_u24 = a07_u2 + a07_u4;
	a07_jr24 = a07_jr2 + a07_jr4;
	a07_sp24 = a07_sp2 + a07_sp4;
	
	a07_ygc24 = a07_y24 + a07_yk24 + a07_g24 + a07_c24+a07_it24;
	a07_bd24 = a07_b24 + a07_d24 + a07_s24 + a07_j24 + a07_k24 + a07_i24 + a07_w24 + a07_gs24 + a07_gr24 + a07_u24 + a07_jr24 + a07_sp24;
	a07_tot24 = a07_ygc24 + a07_bd24;
	
	a06_yk24 = a06_yk2 + a06_yk4;
	a06_y24 = a06_y2 + a06_y4;
	a06_g24 = a06_g2 + a06_g4;
	a06_c24 = a06_c2 + a06_c4;
	a06_it24 = a06_it2 + a06_it4;
	
	a06_b24 = a06_b2 + a06_b4;
	a06_d24 = a06_d2 + a06_d4;
	
	a06_s24 = a06_s2 + a06_s4;
	a06_j24 = a06_j2 + a06_j4;
	a06_k24 = a06_k2 + a06_k4;
	a06_i24 = a06_i2 + a06_i4;
	a06_w24 = a06_w2 + a06_w4;
	
	a06_gs24 = a06_gs2 + a06_gs4;
	a06_gr24 = a06_gr2 + a06_gr4;
	a06_u24 = a06_u2 + a06_u4;
	a06_jr24 = a06_jr2 + a06_jr4;
	a06_sp24 = a06_sp2 + a06_sp4;
	
	a06_ygc24 = a06_y24 + a06_yk24 + a06_g24 + a06_c24+a06_it24;
	a06_bd24 = a06_b24 + a06_d24 + a06_s24 + a06_j24 + a06_k24 + a06_i24 + a06_w24 + a06_gs24 + a06_gr24 + a06_u24 + a06_jr24 + a06_sp24;
	a06_tot24 = a06_ygc24 + a06_bd24;		
%>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>직군별현황</span></td>
    </tr>
    <tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr><td class=line2 colspan=2></td></tr>
		        <TR id='tr_title'>
		        	<td class='line2' id='td_title'>
		        		<table border="0" cellspacing="1" cellpadding="0" width=100%>
		        			<tr>
					          <TD width="22%" height="17" colspan="2" rowspan="2" class='title'>구분</TD>
					          <TD width="16%" height="17" colspan="2" class='title'><%=nyear%>년 </TD>
					          <TD width="16%" height="17" colspan="2" class='title'><%=nyear-1%>년 </TD>
					          <TD width="16%" height="17" colspan="2" class='title'><%=nyear-2%>년 </TD>
				            </TR>
		        			<tr>
		        			  <TD height="8" class='title'>충원</TD>
	        			      <TD class='title'>퇴사</TD>
	        			      <TD width="8%" height="8" class='title'>충원</TD>
	        			      <TD width="8%" class='title'>퇴사</TD>
	        			      <TD width="8%" height="8" class='title'>충원</TD>
	        			      <TD width="8%" class='title'>퇴사</TD>
        			        </TR>
        			    <TR>
					          <TD rowspan="19" width="11%" height="103" class='title'>외근직</TD>
					          <TD width="11%" height="103" class='title'>영업기획팀</TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a08_yk1%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a08_yk2%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a07_yk1%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a07_yk2%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a06_yk1%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a06_yk2%></TD>
				            </TR>
					        <TR>
					        <TR>
					          <TD width="11%" height="103" class='title'>영업팀</TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a08_y1%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a08_y2%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a07_y1%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a07_y2%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a06_y1%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a06_y2%></TD>
				            </TR>
					        <TR>
					          <TD width="11%" height="17" class='title'>고객지원팀</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_g1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_g2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_g1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_g2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_g1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_g2%></TD>
				            </TR>
					        <TR>
					          <TD width="11%" height="17" class='title'>총무팀</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_c1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_c2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_c1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_c2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_c1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_c2%></TD>
				            </TR>
							 <TR>
					          <TD width="11%" height="17" class='title'>IT팀</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_it1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_it2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_it1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_it2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_it1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_it2%></TD>
				            </TR>
					        <TR>
					          <TD width="11%" height="17" class='title'>부산지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_b1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_b2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_b1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_b2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_b1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_b2%></TD>
				            </TR>
					        <TR>
					          <TD width="11%" height="17" class='title'>대전지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_d1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_d2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_d1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_d2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_d1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_d2%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>강남지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_s1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_s2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_s1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_s2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_s1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_s2%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>광주지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_j1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_j2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_j1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_j2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_j1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_j2%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>대구지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_k1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_k2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_k1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_k2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_k1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_k2%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>인천지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_i1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_i2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_i1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_i2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_i1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_i2%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>수원지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_w1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_w2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_w1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_w2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_w1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_w2%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>강서지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_gs1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_gs2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_gs1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_gs2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_gs1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_gs2%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>구로지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_gr1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_gr2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_gr1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_gr2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_gr1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_gr2%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>울산지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_u1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_u2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_u1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_u2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_u1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_u2%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>광화문지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_jr1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_jr2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_jr1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_jr2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_jr1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_jr2%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>송파지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_sp1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_sp2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_sp1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_sp2%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_sp1%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_sp2%></TD>
				            </TR>
					        <TR>
					          <TD width="11%" height="17" class='title'>소계</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a08_tot1%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a08_tot2%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a07_tot1%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a07_tot2%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a06_tot1%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a06_tot2%> 명</TD>
				            </TR>
				           <TR>
					          <TD rowspan="18" width="11%" height="103" class='title'>내근직</TD>
					          <TD width="11%" height="103" class='title'>영업기획팀</TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a08_yk3%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a08_yk4%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a07_yk3%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a07_yk4%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a06_yk3%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a06_yk4%></TD>
				          </TR>
					        <TR>
					          <TD width="11%" height="103" class='title'>영업팀</TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a08_y3%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a08_y4%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a07_y3%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a07_y4%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a06_y3%></TD>
					          <TD width="8%" height="103" valign="middle" align="center"><%=a06_y4%></TD>
				            </TR>
					        <TR>
					          <TD width="11%" height="17" class='title'>고객지원팀</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_g3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_g4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_g3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_g4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_g3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_g4%></TD>
				            </TR>
					        <TR>
					          <TD width="11%" height="17" class='title'>총무팀</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_c3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_c4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_c3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_c4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_c3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_c4%></TD>
				            </TR>
							 <TR>
					          <TD width="11%" height="17" class='title'>IT팀</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_it3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_it4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_it3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_it4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_it3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_it4%></TD>
				            </TR>
					        <TR>
					          <TD width="11%" height="17" class='title'>부산지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_b3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_b4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_b3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_b4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_b3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_b4%></TD>
				            </TR>
					        <TR>
					          <TD width="11%" height="17" class='title'>대전지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_d3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_d4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_d3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_d4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_d3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_d4%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>강남지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_s3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_s4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_s3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_s4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_s3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_s4%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>광주지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_j3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_j4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_j3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_j4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_j3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_j4%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>대구지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_k3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_k4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_k3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_k4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_k3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_k4%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>인천지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_i3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_i4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_i3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_i4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_i3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_i4%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>수원지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_w3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_w4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_w3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_w4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_w3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_w4%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>강서지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_gs3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_gs4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_gs3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_gs4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_gs3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_gs4%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>구로지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_gr3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_gr4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_gr3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_gr4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_gr3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_gr4%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>울산지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_u3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_u4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_u3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_u4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_u3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_u4%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>광화문지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_jr3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_jr4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_jr3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_jr4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_jr3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_jr4%></TD>
				            </TR>
							<TR>
					          <TD width="11%" height="17" class='title'>송파지점</TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_sp3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a08_sp4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_sp3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a07_sp4%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_sp3%></TD>
					          <TD width="8%" height="17" valign="middle" align="center"><%=a06_sp4%></TD>
				            </TR>
					        <TR>
					          <TD width="11%" height="17" class='title'>소계</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a08_tot3%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a08_tot4%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a07_tot3%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a07_tot4%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a06_tot3%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=a06_tot4%> 명</TD>
				            </TR>
					        <TR>
					          <TD colspan="2" width="22%" height="17" class='title'>합계</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=tot_a0813%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=tot_a0824%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=tot_a0713%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=tot_a0724%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=tot_a0613%> 명</TD>
					          <TD width="8%" height="17" valign="middle" class='title'><%=tot_a0624%> 명</TD>
				            </TR>
						</TABLE>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
    	<td class="h"></td>
    </tr>
    <tr>
    	<td class="h"></td>
    </tr>
    <tr>
    	<td class="h"></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>부서별현황</span></td>
    </tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr><td class=line2 colspan=2></td></tr>
		        <TR id='tr_title'>
		        	<td class='line2' id='td_title'>
		        		<table border="0" cellspacing="1" cellpadding="0" width=100%>
							<TR>
								<TD width="22%" height="17" colspan="2" rowspan="2" class='title'>구분</TD>
								<TD width="16%" height="17" colspan="2" class='title'><%=nyear%>년</TD>
								<TD width="16%" height="17" colspan="2" class='title'><%=nyear-1%>년</TD>
								<TD width="16%" height="17" colspan="2" class='title'><%=nyear-2%>년</TD>
							</TR>
							<TR>
							  <TD height="8" class='title'>충원</TD>
						      <TD class='title'>퇴사</TD>
						      <TD width="8%" height="8" class='title'>충원</TD>
						      <TD width="8%" class='title'>퇴사</TD>
						      <TD width="8%" height="8" class='title'>충원</TD>
						      <TD width="8%" class='title'>퇴사</TD>
					      </TR>
					      
					    <TR>
								<TD rowspan="6" width="11%" height="68" class='title'>본점</TD>
								<TD width="11%" height="68" class='title'>영업기획팀</TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a08_yk13%></TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a08_yk24%></TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a07_yk13%></TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a07_yk24%></TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a06_yk13%></TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a06_yk24%></TD>
							</TR>  
							<TR>
								<TD width="11%" height="68" class='title'>영업팀</TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a08_y13%></TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a08_y24%></TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a07_y13%></TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a07_y24%></TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a06_y13%></TD>
								<TD width="8%" height="68" valign="middle" align="center"><%=a06_y24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>고객지원팀</TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a08_g13%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a08_g24%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a07_g13%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a07_g24%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a06_g13%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a06_g24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>총무팀</TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a08_c13%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a08_c24%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a07_c13%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a07_c24%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a06_c13%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a06_c24%></TD>							
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>IT팀</TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a08_it13%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a08_it24%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a07_it13%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a07_it24%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a06_it13%></TD>
								<TD width="8%" height="17" valign="middle" align="center"><%=a06_it24%></TD>							
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>소계</TD>
								<TD width="8%" height="17" valign="middle" class='title'><%=a08_ygc13%> 명</TD>
								<TD width="8%" height="17" valign="middle" class='title'><%=a08_ygc24%> 명</TD>
								<TD width="8%" height="17" valign="middle" class='title'><%=a07_ygc13%> 명</TD>
								<TD width="8%" height="17" valign="middle" class='title'><%=a07_ygc24%> 명</TD>
								<TD width="8%" height="17" valign="middle" class='title'><%=a06_ygc13%> 명</TD>
								<TD width="8%" height="17" valign="middle" class='title'><%=a06_ygc24%> 명</TD>
							</TR>
							<TR>
								<TD rowspan="13" width="11%" height="51" class='title'>지점</TD>
								<TD width="11%" height="51" class='title'>부산지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_b13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_b24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_b13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_b24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_b13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_b24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>대전지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_d13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_d24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_d13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_d24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_d13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_d24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>강남지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_s13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_s24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_s13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_s24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_s13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_s24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>광주지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_j13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_j24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_j13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_j24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_j13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_j24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>대구지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_k13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_k24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_k13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_k24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_k13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_k24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>인천지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_i13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_i24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_i13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_i24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_i13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_i24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>수원지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_w13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_w24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_w13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_w24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_w13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_w24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>강서지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_gs13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_gs24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_gs13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_gs24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_gs13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_gs24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>구로지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_gr13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_gr24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_gr13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_gr24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_gr13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_gr24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>울산지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_u13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_u24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_u13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_u24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_u13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_u24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>광화문지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_jr13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_jr24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_jr13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_jr24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_jr13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_jr24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>송파지점</TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_sp13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a08_sp24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_sp13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a07_sp24%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_sp13%></TD>
								<TD width="8%" height="51" valign="middle" align="center"><%=a06_sp24%></TD>
							</TR>
							<TR>
								<TD width="11%" height="17" class='title'>소계</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a08_bd13%> 명</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a08_bd24%> 명</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a07_bd13%> 명</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a07_bd24%> 명</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a06_bd13%> 명</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a06_bd24%> 명</TD>
							</TR>
							<TR>
								<TD colspan="2" width="22%" height="17" class='title'>합계</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a08_tot13%> 명</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a08_tot24%> 명</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a07_tot13%> 명</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a07_tot24%> 명</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a06_tot13%> 명</TD>
								<TD width="8%" height="51" valign="middle" class='title'><%=a06_tot24%> 명</TD>
							</TR>
						</TABLE>
					</td>
				</tr>
			</table>
		</td>
	</tr>  
</table>
</form>
</body>
</html>