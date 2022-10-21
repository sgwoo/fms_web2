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
	
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String height 	= request.getParameter("height")==null?"":request.getParameter("height");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	
	//당해년도
	int a08m_yk1 = 0; 	//남 외근 영업기획팀 충원
	int a08m_y1 = 0; 	//남 외근 영업팀 충원
	int a08m_g1 = 0;		//남 외근 고객관리팀 충원
	int a08m_c1 = 0;		//남 외근 총무팀 충원
	int a08m_b1 = 0;		//남 외근 부산지점 충원
	int a08m_d1 = 0;		//남 외근 대전지점 충원
	int a08m_s1 = 0;		//남 외근 강남지점 충원
	int a08m_j1 = 0;		//남 외근 광주지점 충원
	int a08m_k1 = 0;		//남 외근 대구지점 충원
	int a08m_i1 = 0;		//남 외근 인천지점 충원
	int a08m_w1 = 0;		//남 외근 수원지점 충원
	int a08m_gs1 = 0;	//남 외근 강서지점 충원
	int a08m_gr1 = 0;	//남 외근 구로지점 충원
	int a08m_u1 = 0;		//남 외근 울산지점 충원
	int a08m_jr1 = 0;		//남 외근 광화문지점 충원
	int a08m_sp1 = 0;	//남 외근 송파지점 충원
	int a08m_it1 = 0;		//남 외근 IT팀 충원
	
	int a08m_tot1 = 0;	//남 외근 충원 소계
	
	int a08f_yk1 = 0; 		//여 외근 영업기획팀 충원
	int a08f_y1 = 0; 		//여 외근 영업팀 충원
	int a08f_g1 = 0;		//여 외근 고객관리팀 충원
	int a08f_c1 = 0;		//여 외근 총무팀 충원
	int a08f_b1 = 0;		//여 외근 부산지점 충원
	int a08f_d1 = 0;		//여 외근 대전지점 충원
	int a08f_s1 = 0;		//여 외근 강남지점 충원
	int a08f_j1 = 0;		//여 외근 광주지점 충원
	int a08f_k1 = 0;		//여 외근 대구지점 충원
	int a08f_i1 = 0;		//여 외근 인천지점 충원
	int a08f_w1 = 0;		//여 외근 수원지점 충원
	int a08f_gs1 = 0;		//여 외근 강서지점 충원
	int a08f_gr1 = 0;		//여 외근 구로지점 충원
	int a08f_u1 = 0;		//여 외근 울산지점 충원
	int a08f_jr1 = 0;		//여 외근 광화문지점 충원
	int a08f_sp1 = 0;		//여 외근 송파지점 충원
	int a08f_it1 = 0;		//여 외근 IT팀 충원
	
	int a08f_tot1 = 0;	//여 외근 충원 소계
	
	int a08m_yk2 = 0; 	//남 외근 영업기획팀 퇴사
	int a08m_y2 = 0; 	//남 외근 영업팀 퇴사
	int a08m_g2 = 0;		//남 외근 고객관리팀 퇴사
	int a08m_c2 = 0;		//남 외근 총무팀 퇴사
	int a08m_b2 = 0;		//남 외근 부산지점 퇴사
	int a08m_d2 = 0;		//남 외근 대전지점 퇴사
	int a08m_s2 = 0;		//남 외근 강남지점 퇴사
	int a08m_j2 = 0;		//남 외근 광주지점 퇴사
	int a08m_k2 = 0;		//남 외근 대구지점 퇴사
	int a08m_i2 = 0;		//남 외근 인천지점 퇴사
	int a08m_w2 = 0;		//남 외근 수원지점 퇴사
	int a08m_gs2 = 0;	//남 외근 강서지점 퇴사
	int a08m_gr2 = 0;	//남 외근 구로지점 퇴사
	int a08m_u2 = 0;		//남 외근 울산지점 퇴사
	int a08m_jr2 = 0;		//남 외근 광화문지점 퇴사
	int a08m_sp2 = 0;	//남 외근 송파지점 퇴사
	int a08m_it2 = 0;		//남 외근 IT팀 퇴사
	
	int a08m_tot2 = 0;	//남 외근 퇴사 소계
	
	int a08f_yk2 = 0; 		//남 외근 영업기획팀 퇴사
	int a08f_y2 = 0; 		//남 외근 영업팀 퇴사
	int a08f_g2 = 0;		//남 외근 고객관리팀 퇴사
	int a08f_c2 = 0;		//남 외근 총무팀 퇴사
	int a08f_b2 = 0;		//남 외근 부산지점 퇴사
	int a08f_d2 = 0;		//남 외근 대전지점 퇴사
	int a08f_s2 = 0;		//남 외근 강남지점 퇴사
	int a08f_j2 = 0;		//남 외근 광주지점 퇴사
	int a08f_k2 = 0;		//남 외근 대구지점 퇴사
	int a08f_i2 = 0;		//남 외근 인천지점 퇴사
	int a08f_w2 = 0;		//남 외근 수원지점 퇴사
	int a08f_gs2 = 0;		//남 외근 강서지점 퇴사
	int a08f_gr2 = 0;		//남 외근 구로지점 퇴사
	int a08f_u2 = 0;		//남 외근 울산지점 퇴사
	int a08f_jr2 = 0;		//남 외근 광화문지점 퇴사
	int a08f_sp2 = 0;		//남 외근 송파지점 퇴사
	int a08f_it2 = 0;		//남 외근 IT팀 퇴사
	
	int a08f_tot2 = 0;	//남 외근 퇴사 소계
	
	int a08m_yk3 = 0;    	//남 내근 영업기획팀 충원
	int a08m_y3 = 0;    	//남 내근 영업팀 충원
	int a08m_g3 = 0;		//남 내근 고객관리팀 충원
	int a08m_c3 = 0;		//남 내근 총무팀 충원
	int a08m_b3 = 0;		//남 내근 부산지점 충원
	int a08m_d3 = 0;		//남 내근 대전지점 충원
	int a08m_s3 = 0;		//남 내근 강남지점 충원
	int a08m_j3 = 0;		//남 내근 광주지점 충원
	int a08m_k3 = 0;		//남 내근 대구지점 충원
	int a08m_i3 = 0;		//남 내근 인천지점 충원
	int a08m_w3 = 0;		//남 내근 수원지점 충원
	int a08m_gs3 = 0;	//남 내근 강서지점 충원
	int a08m_gr3 = 0;	//남 내근 구로지점 충원
	int a08m_u3 = 0;		//남 내근 울산지점 충원
	int a08m_jr3 = 0;		//남 내근 광화문지점 충원
	int a08m_sp3 = 0;	//남 내근 송파지점 충원
	int a08m_it3 = 0;		//남 내근 IT팀 충원
	
	int a08m_tot3 = 0;	//남 내근 충원 소계
	
	int a08f_yk3 = 0;    	//여 내근 영업기획팀 충원
	int a08f_y3 = 0;    	//여 내근 영업팀 충원
	int a08f_g3 = 0;		//여 내근 고객관리팀 충원
	int a08f_c3 = 0;		//여 내근 총무팀 충원
	int a08f_b3 = 0;		//여 내근 부산지점 충원
	int a08f_d3 = 0;		//여 내근 대전지점 충원
	int a08f_s3 = 0;		//여 내근 강남지점 충원
	int a08f_j3 = 0;		//여 내근 광주지점 충원
	int a08f_k3 = 0;		//여 내근 대구지점 충원
	int a08f_i3 = 0;		//여 내근 인천지점 충원
	int a08f_w3 = 0;		//여 내근 수원지점 충원
	int a08f_gs3 = 0;		//여 내근 강서지점 충원
	int a08f_gr3 = 0;		//여 내근 구로지점 충원
	int a08f_u3 = 0;		//여 내근 울산지점 충원
	int a08f_jr3 = 0;		//여 내근 광화문지점 충원
	int a08f_sp3 = 0;		//여 내근 송파지점 충원
	int a08f_it3 = 0;		//여 내근 IT팀 충원
	
	int a08f_tot3 = 0;	//여 내근 충원 소계
	
	int a08m_yk4 = 0; 	//남 내근 영업기획팀 퇴사
	int a08m_y4 = 0; 	//남 내근 영업팀 퇴사
	int a08m_g4 = 0;		//남 내근 고객관리팀 퇴사
	int a08m_c4 = 0;		//남 내근 총무팀 퇴사
	int a08m_b4 = 0;		//남 내근 부산지점 퇴사
	int a08m_d4 = 0;		//남 내근 대전지점 퇴사
	int a08m_s4 = 0;		//남 내근 강남지점 퇴사
	int a08m_j4 = 0;		//남 내근 광주지점 퇴사
	int a08m_k4 = 0;		//남 내근 대구지점 퇴사
	int a08m_i4 = 0;		//남 내근 인천지점 퇴사
	int a08m_w4 = 0;		//남 내근 수원지점 퇴사
	int a08m_gs4 = 0;	//남 내근 강서지점 퇴사
	int a08m_gr4 = 0;	//남 내근 구로지점 퇴사
	int a08m_u4 = 0;		//남 내근 울산지점 퇴사
	int a08m_jr4 = 0;		//남 내근 광화문지점 퇴사
	int a08m_sp4 = 0;	//남 내근 송파지점 퇴사
	int a08m_it4 = 0;		//남 IT팀 퇴사
	
	int a08m_tot4 = 0;	//남 내근 퇴사 소계
	
	int a08f_yk4 = 0; 		//여 내근 영업기획팀 퇴사
	int a08f_y4 = 0; 		//여 내근 영업팀 퇴사
	int a08f_g4 = 0;		//여 내근 고객관리팀 퇴사
	int a08f_c4 = 0;		//여 내근 총무팀 퇴사
	int a08f_b4 = 0;		//여 내근 부산지점 퇴사
	int a08f_d4 = 0;		//여 내근 대전지점 퇴사
	int a08f_s4 = 0;		//여 내근 강남지점 퇴사
	int a08f_j4 = 0;		//여 내근 광주지점 퇴사
	int a08f_k4 = 0;		//여 내근 대구지점 퇴사
	int a08f_i4 = 0;		//여 내근 인천지점 퇴사
	int a08f_w4 = 0;		//여 내근 수원지점 퇴사
	int a08f_gs4 = 0;		//여 내근 강서지점 퇴사
	int a08f_gr4 = 0;		//여 내근 구로지점 퇴사
	int a08f_u4 = 0;		//여 내근 울산지점 퇴사
	int a08f_jr4 = 0;		//여 내근 광화문지점 퇴사
	int a08f_sp4 = 0;		//여 송파지점 퇴사
	int a08f_it4 = 0;		//여 IT팀 퇴사 
	
	int a08f_tot4 = 0;	//여 내근 퇴사 소계
	
	int totm_a0813 = 0;		//남 충원 합계
	int totf_a0813 = 0;		//여 충원 합계
	
	int totm_a0824 = 0;		//남 퇴사 합계
	int totf_a0824 = 0;		//여 퇴사 합계
	
	int a08_tot1 = 0;		//외근 충원 소계
	int a08_tot3 = 0;		//관리/사무직 충원 소계
	int a08_it3 = 0;		//기술직 충원 소계
	
	int a08_tot2 = 0;		//외근 퇴사 소계
	int a08_tot4 = 0;		//관리/사무직 퇴사 소계
	int a08_it4 = 0;		//기술직 퇴사 소계
	
	int tot_a0813 = 0;	//충원 합계
	int tot_a0824 = 0	;	//퇴사 합계
	
	//당해-1
	int a07m_yk1 = 0; 	//남 외근 영업기획팀 충원
	int a07m_y1 = 0; 	//남 외근 영업팀 충원
	int a07m_g1 = 0;		//남 외근 고객관리팀 충원
	int a07m_c1 = 0;		//남 외근 총무팀 충원
	int a07m_b1 = 0;		//남 외근 부산지점 충원
	int a07m_d1 = 0;		//남 외근 대전지점 충원
	int a07m_s1 = 0;		//남 외근 강남지점 충원
	int a07m_j1 = 0;		//남 외근 광주지점 충원
	int a07m_k1 = 0;		//남 외근 대구지점 충원
	int a07m_i1 = 0;		//남 외근 인천지점 충원
	int a07m_w1 = 0;		//남 외근 수원지점 충원
	int a07m_gs1 = 0;	//남 외근 강서지점 충원
	int a07m_gr1 = 0;	//남 외근 구로지점 충원
	int a07m_u1 = 0;		//남 외근 울산지점 충원
	int a07m_jr1 = 0;		//남 외근 광화문지점 충원
	int a07m_sp1 = 0;	//남 외근 송파지점 충원
	int a07m_it1 = 0;		//남 외근 IT팀 충원
	
	int a07m_tot1 = 0;	//남 외근 충원 소계
	
	int a07f_yk1 = 0; 		//여 외근 영업기획팀 충원
	int a07f_y1 = 0; 		//여 외근 영업팀 충원
	int a07f_g1 = 0;		//여 외근 고객관리팀 충원
	int a07f_c1 = 0;		//여 외근 총무팀 충원
	int a07f_b1 = 0;		//여 외근 부산지점 충원
	int a07f_d1 = 0;		//여 외근 대전지점 충원
	int a07f_s1 = 0;		//여 외근 강남지점 충원
	int a07f_j1 = 0;		//여 외근 광주지점 충원
	int a07f_k1 = 0;		//여 외근 대구지점 충원
	int a07f_i1 = 0;		//여 외근 인천지점 충원
	int a07f_w1 = 0;		//여 외근 수원지점 충원
	int a07f_gs1 = 0;		//여 외근 강서지점 충원
	int a07f_gr1 = 0;		//여 외근 구로지점 충원
	int a07f_u1 = 0;		//여 외근 울산지점 충원
	int a07f_jr1 = 0;		//여 외근 광화문지점 충원
	int a07f_sp1 = 0;		//여 외근 송파지점 충원
	int a07f_it1 = 0;		//여 외근 IT팀 충원
	
	int a07f_tot1 = 0;	//여 외근 충원 소계
	
	int a07m_yk2 = 0; 	//남 외근 영업기획팀 퇴사
	int a07m_y2 = 0; 	//남 외근 영업팀 퇴사
	int a07m_g2 = 0;		//남 외근 고객관리팀 퇴사
	int a07m_c2 = 0;		//남 외근 총무팀 퇴사
	int a07m_b2 = 0;		//남 외근 부산지점 퇴사
	int a07m_d2 = 0;		//남 외근 대전지점 퇴사
	int a07m_s2 = 0;		//남 외근 강남지점 퇴사
	int a07m_j2 = 0;		//남 외근 광주지점 퇴사
	int a07m_k2 = 0;		//남 외근 대구지점 퇴사
	int a07m_i2 = 0;		//남 외근 인천지점 퇴사
	int a07m_w2 = 0;		//남 외근 수원지점 퇴사
	int a07m_gs2 = 0;	//남 외근 강서지점 퇴사
	int a07m_gr2 = 0;	//남 외근 구로지점 퇴사
	int a07m_u2 = 0;		//남 외근 울산지점 퇴사
	int a07m_jr2 = 0;		//남 외근 광화문지점 퇴사
	int a07m_sp2 = 0;	//남 외근 송파지점 퇴사
	int a07m_it2 = 0;		//남 외근 IT팀 퇴사
	
	int a07m_tot2 = 0;	//남 외근 퇴사 소계
	
	int a07f_yk2 = 0; 		//남 외근 영업기획팀 퇴사
	int a07f_y2 = 0; 		//남 외근 영업팀 퇴사
	int a07f_g2 = 0;		//남 외근 고객관리팀 퇴사
	int a07f_c2 = 0;		//남 외근 총무팀 퇴사
	int a07f_b2 = 0;		//남 외근 부산지점 퇴사
	int a07f_d2 = 0;		//남 외근 대전지점 퇴사
	int a07f_s2 = 0;		//남 외근 강남지점 퇴사
	int a07f_j2 = 0;		//남 외근 광주지점 퇴사
	int a07f_k2 = 0;		//남 외근 대구지점 퇴사
	int a07f_i2 = 0;		//남 외근 인천지점 퇴사
	int a07f_w2 = 0;		//남 외근 수원지점 퇴사
	int a07f_gs2 = 0;		//남 외근 강서지점 퇴사
	int a07f_gr2 = 0;		//남 외근 구로지점 퇴사
	int a07f_u2 = 0;		//남 외근 울산지점 퇴사
	int a07f_jr2 = 0;		//남 외근 광화문지점 퇴사
	int a07f_sp2 = 0;		//남 외근 송파지점 퇴사
	int a07f_it2 = 0;		//남 외근 IT팀 퇴사
	
	int a07f_tot2 = 0;	//남 외근 퇴사 소계
	
	int a07m_yk3 = 0;    	//남 내근 영업기획팀 충원
	int a07m_y3 = 0;    	//남 내근 영업팀 충원
	int a07m_g3 = 0;		//남 내근 고객관리팀 충원
	int a07m_c3 = 0;		//남 내근 총무팀 충원
	int a07m_b3 = 0;		//남 내근 부산지점 충원
	int a07m_d3 = 0;		//남 내근 대전지점 충원
	int a07m_s3 = 0;		//남 내근 강남지점 충원
	int a07m_j3 = 0;		//남 내근 광주지점 충원
	int a07m_k3 = 0;		//남 내근 대구지점 충원
	int a07m_i3 = 0;		//남 내근 인천지점 충원
	int a07m_w3 = 0;		//남 내근 수원지점 충원
	int a07m_gs3 = 0;	//남 내근 강서지점 충원
	int a07m_gr3 = 0;	//남 내근 구로지점 충원
	int a07m_u3 = 0;		//남 내근 울산지점 충원
	int a07m_jr3 = 0;		//남 내근 광화문지점 충원
	int a07m_sp3 = 0;	//남 내근 송파지점 충원
	int a07m_it3 = 0;		//남 내근 IT팀 충원
	
	int a07m_tot3 = 0;	//남 내근 충원 소계
	
	int a07f_yk3 = 0;    	//여 내근 영업기획팀 충원
	int a07f_y3 = 0;    	//여 내근 영업팀 충원
	int a07f_g3 = 0;		//여 내근 고객관리팀 충원
	int a07f_c3 = 0;		//여 내근 총무팀 충원
	int a07f_b3 = 0;		//여 내근 부산지점 충원
	int a07f_d3 = 0;		//여 내근 대전지점 충원
	int a07f_s3 = 0;		//여 내근 강남지점 충원
	int a07f_j3 = 0;		//여 내근 광주지점 충원
	int a07f_k3 = 0;		//여 내근 대구지점 충원
	int a07f_i3 = 0;		//여 내근 인천지점 충원
	int a07f_w3 = 0;		//여 내근 수원지점 충원
	int a07f_gs3 = 0;		//여 내근 강서지점 충원
	int a07f_gr3 = 0;		//여 내근 구로지점 충원
	int a07f_u3 = 0;		//여 내근 울산지점 충원
	int a07f_jr3 = 0;		//여 내근 광화문지점 충원
	int a07f_sp3 = 0;		//여 내근 송파지점 충원
	int a07f_it3 = 0;		//여 내근 IT팀 충원
	
	int a07f_tot3 = 0;	//여 내근 충원 소계
	
	int a07m_yk4 = 0; 	//남 내근 영업기획팀 퇴사
	int a07m_y4 = 0; 	//남 내근 영업팀 퇴사
	int a07m_g4 = 0;		//남 내근 고객관리팀 퇴사
	int a07m_c4 = 0;		//남 내근 총무팀 퇴사
	int a07m_b4 = 0;		//남 내근 부산지점 퇴사
	int a07m_d4 = 0;		//남 내근 대전지점 퇴사
	int a07m_s4 = 0;		//남 내근 강남지점 퇴사
	int a07m_j4 = 0;		//남 내근 광주지점 퇴사
	int a07m_k4 = 0;		//남 내근 대구지점 퇴사
	int a07m_i4 = 0;		//남 내근 인천지점 퇴사
	int a07m_w4 = 0;		//남 내근 수원지점 퇴사
	int a07m_gs4 = 0;	//남 내근 강서지점 퇴사
	int a07m_gr4 = 0;	//남 내근 구로지점 퇴사
	int a07m_u4 = 0;		//남 내근 울산지점 퇴사
	int a07m_jr4 = 0;		//남 내근 광화문지점 퇴사
	int a07m_sp4 = 0;	//남 내근 송파지점 퇴사
	int a07m_it4 = 0;		//남 IT팀 퇴사
	
	int a07m_tot4 = 0;	//남 내근 퇴사 소계
	
	int a07f_yk4 = 0; 		//여 내근 영업기획팀 퇴사
	int a07f_y4 = 0; 		//여 내근 영업팀 퇴사
	int a07f_g4 = 0;		//여 내근 고객관리팀 퇴사
	int a07f_c4 = 0;		//여 내근 총무팀 퇴사
	int a07f_b4 = 0;		//여 내근 부산지점 퇴사
	int a07f_d4 = 0;		//여 내근 대전지점 퇴사
	int a07f_s4 = 0;		//여 내근 강남지점 퇴사
	int a07f_j4 = 0;		//여 내근 광주지점 퇴사
	int a07f_k4 = 0;		//여 내근 대구지점 퇴사
	int a07f_i4 = 0;		//여 내근 인천지점 퇴사
	int a07f_w4 = 0;		//여 내근 수원지점 퇴사
	int a07f_gs4 = 0;		//여 내근 강서지점 퇴사
	int a07f_gr4 = 0;		//여 내근 구로지점 퇴사
	int a07f_u4 = 0;		//여 내근 울산지점 퇴사
	int a07f_jr4 = 0;		//여 내근 광화문지점 퇴사
	int a07f_sp4 = 0;		//여 송파지점 퇴사
	int a07f_it4 = 0;		//여 IT팀 퇴사 
	
	int a07f_tot4 = 0;	//여 내근 퇴사 소계
	
	int totm_a0713 = 0;		//남 충원 합계
	int totf_a0713 = 0;		//여 충원 합계
	
	int totm_a0724 = 0;		//남 퇴사 합계
	int totf_a0724 = 0;		//남 퇴사 합계
	
	int a07_tot1 = 0;		//외근 충원 소계
	int a07_tot3 = 0;		//관리/사무직 충원 소계
	int a07_it3 = 0;		//기술직 충원 소계
	
	int a07_tot2 = 0;		//외근 퇴사 소계
	int a07_tot4 = 0;		//관리/사무직 퇴사 소계
	int a07_it4 = 0;		//기술직 퇴사 소계
	
	int tot_a0713 = 0;	//충원 합계
	int tot_a0724 = 0	;	//퇴사 합계
	
	//당해-2
	int a06m_yk1 = 0; 	//남 외근 영업기획팀 충원
	int a06m_y1 = 0; 	//남 외근 영업팀 충원
	int a06m_g1 = 0;		//남 외근 고객관리팀 충원
	int a06m_c1 = 0;		//남 외근 총무팀 충원
	int a06m_b1 = 0;		//남 외근 부산지점 충원
	int a06m_d1 = 0;		//남 외근 대전지점 충원
	int a06m_s1 = 0;		//남 외근 강남지점 충원
	int a06m_j1 = 0;		//남 외근 광주지점 충원
	int a06m_k1 = 0;		//남 외근 대구지점 충원
	int a06m_i1 = 0;		//남 외근 인천지점 충원
	int a06m_w1 = 0;		//남 외근 수원지점 충원
	int a06m_gs1 = 0;	//남 외근 강서지점 충원
	int a06m_gr1 = 0;	//남 외근 구로지점 충원
	int a06m_u1 = 0;		//남 외근 울산지점 충원
	int a06m_jr1 = 0;		//남 외근 광화문지점 충원
	int a06m_sp1 = 0;	//남 외근 송파지점 충원
	int a06m_it1 = 0;		//남 외근 IT팀 충원
	
	int a06m_tot1 = 0;	//남 외근 충원 소계
	
	int a06f_yk1 = 0; 		//여 외근 영업기획팀 충원
	int a06f_y1 = 0; 		//여 외근 영업팀 충원
	int a06f_g1 = 0;		//여 외근 고객관리팀 충원
	int a06f_c1 = 0;		//여 외근 총무팀 충원
	int a06f_b1 = 0;		//여 외근 부산지점 충원
	int a06f_d1 = 0;		//여 외근 대전지점 충원
	int a06f_s1 = 0;		//여 외근 강남지점 충원
	int a06f_j1 = 0;		//여 외근 광주지점 충원
	int a06f_k1 = 0;		//여 외근 대구지점 충원
	int a06f_i1 = 0;		//여 외근 인천지점 충원
	int a06f_w1 = 0;		//여 외근 수원지점 충원
	int a06f_gs1 = 0;		//여 외근 강서지점 충원
	int a06f_gr1 = 0;		//여 외근 구로지점 충원
	int a06f_u1 = 0;		//여 외근 울산지점 충원
	int a06f_jr1 = 0;		//여 외근 광화문지점 충원
	int a06f_sp1 = 0;		//여 외근 송파지점 충원
	int a06f_it1 = 0;		//여 외근 IT팀 충원
	
	int a06f_tot1 = 0;	//여 외근 충원 소계
	
	int a06m_yk2 = 0; 	//남 외근 영업기획팀 퇴사
	int a06m_y2 = 0; 	//남 외근 영업팀 퇴사
	int a06m_g2 = 0;		//남 외근 고객관리팀 퇴사
	int a06m_c2 = 0;		//남 외근 총무팀 퇴사
	int a06m_b2 = 0;		//남 외근 부산지점 퇴사
	int a06m_d2 = 0;		//남 외근 대전지점 퇴사
	int a06m_s2 = 0;		//남 외근 강남지점 퇴사
	int a06m_j2 = 0;		//남 외근 광주지점 퇴사
	int a06m_k2 = 0;		//남 외근 대구지점 퇴사
	int a06m_i2 = 0;		//남 외근 인천지점 퇴사
	int a06m_w2 = 0;		//남 외근 수원지점 퇴사
	int a06m_gs2 = 0;	//남 외근 강서지점 퇴사
	int a06m_gr2 = 0;	//남 외근 구로지점 퇴사
	int a06m_u2 = 0;		//남 외근 울산지점 퇴사
	int a06m_jr2 = 0;		//남 외근 광화문지점 퇴사
	int a06m_sp2 = 0;	//남 외근 송파지점 퇴사
	int a06m_it2 = 0;		//남 외근 IT팀 퇴사
	
	int a06m_tot2 = 0;	//남 외근 퇴사 소계
	
	int a06f_yk2 = 0; 		//남 외근 영업기획팀 퇴사
	int a06f_y2 = 0; 		//남 외근 영업팀 퇴사
	int a06f_g2 = 0;		//남 외근 고객관리팀 퇴사
	int a06f_c2 = 0;		//남 외근 총무팀 퇴사
	int a06f_b2 = 0;		//남 외근 부산지점 퇴사
	int a06f_d2 = 0;		//남 외근 대전지점 퇴사
	int a06f_s2 = 0;		//남 외근 강남지점 퇴사
	int a06f_j2 = 0;		//남 외근 광주지점 퇴사
	int a06f_k2 = 0;		//남 외근 대구지점 퇴사
	int a06f_i2 = 0;		//남 외근 인천지점 퇴사
	int a06f_w2 = 0;		//남 외근 수원지점 퇴사
	int a06f_gs2 = 0;		//남 외근 강서지점 퇴사
	int a06f_gr2 = 0;		//남 외근 구로지점 퇴사
	int a06f_u2 = 0;		//남 외근 울산지점 퇴사
	int a06f_jr2 = 0;		//남 외근 광화문지점 퇴사
	int a06f_sp2 = 0;		//남 외근 송파지점 퇴사
	int a06f_it2 = 0;		//남 외근 IT팀 퇴사
	
	int a06f_tot2 = 0;	//남 외근 퇴사 소계
	
	int a06m_yk3 = 0;    	//남 내근 영업기획팀 충원
	int a06m_y3 = 0;    	//남 내근 영업팀 충원
	int a06m_g3 = 0;		//남 내근 고객관리팀 충원
	int a06m_c3 = 0;		//남 내근 총무팀 충원
	int a06m_b3 = 0;		//남 내근 부산지점 충원
	int a06m_d3 = 0;		//남 내근 대전지점 충원
	int a06m_s3 = 0;		//남 내근 강남지점 충원
	int a06m_j3 = 0;		//남 내근 광주지점 충원
	int a06m_k3 = 0;		//남 내근 대구지점 충원
	int a06m_i3 = 0;		//남 내근 인천지점 충원
	int a06m_w3 = 0;		//남 내근 수원지점 충원
	int a06m_gs3 = 0;	//남 내근 강서지점 충원
	int a06m_gr3 = 0;	//남 내근 구로지점 충원
	int a06m_u3 = 0;		//남 내근 울산지점 충원
	int a06m_jr3 = 0;		//남 내근 광화문지점 충원
	int a06m_sp3 = 0;	//남 내근 송파지점 충원
	int a06m_it3 = 0;		//남 내근 IT팀 충원
	
	int a06m_tot3 = 0;	//남 내근 충원 소계
	
	int a06f_yk3 = 0;    	//여 내근 영업기획팀 충원
	int a06f_y3 = 0;    	//여 내근 영업팀 충원
	int a06f_g3 = 0;		//여 내근 고객관리팀 충원
	int a06f_c3 = 0;		//여 내근 총무팀 충원
	int a06f_b3 = 0;		//여 내근 부산지점 충원
	int a06f_d3 = 0;		//여 내근 대전지점 충원
	int a06f_s3 = 0;		//여 내근 강남지점 충원
	int a06f_j3 = 0;		//여 내근 광주지점 충원
	int a06f_k3 = 0;		//여 내근 대구지점 충원
	int a06f_i3 = 0;		//여 내근 인천지점 충원
	int a06f_w3 = 0;		//여 내근 수원지점 충원
	int a06f_gs3 = 0;		//여 내근 강서지점 충원
	int a06f_gr3 = 0;		//여 내근 구로지점 충원
	int a06f_u3 = 0;		//여 내근 울산지점 충원
	int a06f_jr3 = 0;		//여 내근 광화문지점 충원
	int a06f_sp3 = 0;		//여 내근 송파지점 충원
	int a06f_it3 = 0;		//여 내근 IT팀 충원
	
	int a06f_tot3 = 0;	//여 내근 충원 소계
	
	int a06m_yk4 = 0; 	//남 내근 영업기획팀 퇴사
	int a06m_y4 = 0; 	//남 내근 영업팀 퇴사
	int a06m_g4 = 0;		//남 내근 고객관리팀 퇴사
	int a06m_c4 = 0;		//남 내근 총무팀 퇴사
	int a06m_b4 = 0;		//남 내근 부산지점 퇴사
	int a06m_d4 = 0;		//남 내근 대전지점 퇴사
	int a06m_s4 = 0;		//남 내근 강남지점 퇴사
	int a06m_j4 = 0;		//남 내근 광주지점 퇴사
	int a06m_k4 = 0;		//남 내근 대구지점 퇴사
	int a06m_i4 = 0;		//남 내근 인천지점 퇴사
	int a06m_w4 = 0;		//남 내근 수원지점 퇴사
	int a06m_gs4 = 0;	//남 내근 강서지점 퇴사
	int a06m_gr4 = 0;	//남 내근 구로지점 퇴사
	int a06m_u4 = 0;		//남 내근 울산지점 퇴사
	int a06m_jr4 = 0;		//남 내근 광화문지점 퇴사
	int a06m_sp4 = 0;	//남 내근 송파지점 퇴사
	int a06m_it4 = 0;		//남 IT팀 퇴사
	
	int a06m_tot4 = 0;	//남 내근 퇴사 소계
	
	int a06f_yk4 = 0; 		//여 내근 영업기획팀 퇴사
	int a06f_y4 = 0; 		//여 내근 영업팀 퇴사
	int a06f_g4 = 0;		//여 내근 고객관리팀 퇴사
	int a06f_c4 = 0;		//여 내근 총무팀 퇴사
	int a06f_b4 = 0;		//여 내근 부산지점 퇴사
	int a06f_d4 = 0;		//여 내근 대전지점 퇴사
	int a06f_s4 = 0;		//여 내근 강남지점 퇴사
	int a06f_j4 = 0;		//여 내근 광주지점 퇴사
	int a06f_k4 = 0;		//여 내근 대구지점 퇴사
	int a06f_i4 = 0;		//여 내근 인천지점 퇴사
	int a06f_w4 = 0;		//여 내근 수원지점 퇴사
	int a06f_gs4 = 0;		//여 내근 강서지점 퇴사
	int a06f_gr4 = 0;		//여 내근 구로지점 퇴사
	int a06f_u4 = 0;		//여 내근 울산지점 퇴사
	int a06f_jr4 = 0;		//여 내근 광화문지점 퇴사
	int a06f_sp4 = 0;		//여 송파지점 퇴사
	int a06f_it4 = 0;		//여 IT팀 퇴사 
	
	int a06f_tot4 = 0;	//여 내근 퇴사 소계
	
	int totm_a0613 = 0;		//남 충원 합계
	int totf_a0613 = 0;		//여 충원 합계
	
	int totm_a0624 = 0;		//남 퇴사 합계
	int totf_a0624 = 0;		//남 퇴사 합계
	
	int a06_tot1 = 0;		//외근 충원 소계
	int a06_tot3 = 0;		//관리/사무직 충원 소계
	int a06_it3 = 0;		//기술직 충원 소계
	
	int a06_tot2 = 0;		//외근 퇴사 소계
	int a06_tot4 = 0;		//관리/사무직 퇴사 소계
	int a06_it4 = 0;		//기술직 퇴사 소계
	
	int tot_a0613 = 0;	//충원 합계
	int tot_a0624 = 0	;	//퇴사 합계

	//당해-3
	int a05m_yk1 = 0; 	//남 외근 영업기획팀 충원
	int a05m_y1 = 0; 	//남 외근 영업팀 충원
	int a05m_g1 = 0;		//남 외근 고객관리팀 충원
	int a05m_c1 = 0;		//남 외근 총무팀 충원
	int a05m_b1 = 0;		//남 외근 부산지점 충원
	int a05m_d1 = 0;		//남 외근 대전지점 충원
	int a05m_s1 = 0;		//남 외근 강남지점 충원
	int a05m_j1 = 0;		//남 외근 광주지점 충원
	int a05m_k1 = 0;		//남 외근 대구지점 충원
	int a05m_i1 = 0;		//남 외근 인천지점 충원
	int a05m_w1 = 0;		//남 외근 수원지점 충원
	int a05m_gs1 = 0;	//남 외근 강서지점 충원
	int a05m_gr1 = 0;	//남 외근 구로지점 충원
	int a05m_u1 = 0;		//남 외근 울산지점 충원
	int a05m_jr1 = 0;		//남 외근 광화문지점 충원
	int a05m_sp1 = 0;	//남 외근 송파지점 충원
	int a05m_it1 = 0;		//남 외근 IT팀 충원
	
	int a05m_tot1 = 0;	//남 외근 충원 소계
	
	int a05f_yk1 = 0; 		//여 외근 영업기획팀 충원
	int a05f_y1 = 0; 		//여 외근 영업팀 충원
	int a05f_g1 = 0;		//여 외근 고객관리팀 충원
	int a05f_c1 = 0;		//여 외근 총무팀 충원
	int a05f_b1 = 0;		//여 외근 부산지점 충원
	int a05f_d1 = 0;		//여 외근 대전지점 충원
	int a05f_s1 = 0;		//여 외근 강남지점 충원
	int a05f_j1 = 0;		//여 외근 광주지점 충원
	int a05f_k1 = 0;		//여 외근 대구지점 충원
	int a05f_i1 = 0;		//여 외근 인천지점 충원
	int a05f_w1 = 0;		//여 외근 수원지점 충원
	int a05f_gs1 = 0;		//여 외근 강서지점 충원
	int a05f_gr1 = 0;		//여 외근 구로지점 충원
	int a05f_u1 = 0;		//여 외근 울산지점 충원
	int a05f_jr1 = 0;		//여 외근 광화문지점 충원
	int a05f_sp1 = 0;		//여 외근 송파지점 충원
	int a05f_it1 = 0;		//여 외근 IT팀 충원
	
	int a05f_tot1 = 0;	//여 외근 충원 소계
	
	int a05m_yk2 = 0; 	//남 외근 영업기획팀 퇴사
	int a05m_y2 = 0; 	//남 외근 영업팀 퇴사
	int a05m_g2 = 0;		//남 외근 고객관리팀 퇴사
	int a05m_c2 = 0;		//남 외근 총무팀 퇴사
	int a05m_b2 = 0;		//남 외근 부산지점 퇴사
	int a05m_d2 = 0;		//남 외근 대전지점 퇴사
	int a05m_s2 = 0;		//남 외근 강남지점 퇴사
	int a05m_j2 = 0;		//남 외근 광주지점 퇴사
	int a05m_k2 = 0;		//남 외근 대구지점 퇴사
	int a05m_i2 = 0;		//남 외근 인천지점 퇴사
	int a05m_w2 = 0;		//남 외근 수원지점 퇴사
	int a05m_gs2 = 0;	//남 외근 강서지점 퇴사
	int a05m_gr2 = 0;	//남 외근 구로지점 퇴사
	int a05m_u2 = 0;		//남 외근 울산지점 퇴사
	int a05m_jr2 = 0;		//남 외근 광화문지점 퇴사
	int a05m_sp2 = 0;	//남 외근 송파지점 퇴사
	int a05m_it2 = 0;		//남 외근 IT팀 퇴사
	
	int a05m_tot2 = 0;	//남 외근 퇴사 소계
	
	int a05f_yk2 = 0; 		//남 외근 영업기획팀 퇴사
	int a05f_y2 = 0; 		//남 외근 영업팀 퇴사
	int a05f_g2 = 0;		//남 외근 고객관리팀 퇴사
	int a05f_c2 = 0;		//남 외근 총무팀 퇴사
	int a05f_b2 = 0;		//남 외근 부산지점 퇴사
	int a05f_d2 = 0;		//남 외근 대전지점 퇴사
	int a05f_s2 = 0;		//남 외근 강남지점 퇴사
	int a05f_j2 = 0;		//남 외근 광주지점 퇴사
	int a05f_k2 = 0;		//남 외근 대구지점 퇴사
	int a05f_i2 = 0;		//남 외근 인천지점 퇴사
	int a05f_w2 = 0;		//남 외근 수원지점 퇴사
	int a05f_gs2 = 0;		//남 외근 강서지점 퇴사
	int a05f_gr2 = 0;		//남 외근 구로지점 퇴사
	int a05f_u2 = 0;		//남 외근 울산지점 퇴사
	int a05f_jr2 = 0;		//남 외근 광화문지점 퇴사
	int a05f_sp2 = 0;		//남 외근 송파지점 퇴사
	int a05f_it2 = 0;		//남 외근 IT팀 퇴사
	
	int a05f_tot2 = 0;	//남 외근 퇴사 소계
	
	int a05m_yk3 = 0;    	//남 내근 영업기획팀 충원
	int a05m_y3 = 0;    	//남 내근 영업팀 충원
	int a05m_g3 = 0;		//남 내근 고객관리팀 충원
	int a05m_c3 = 0;		//남 내근 총무팀 충원
	int a05m_b3 = 0;		//남 내근 부산지점 충원
	int a05m_d3 = 0;		//남 내근 대전지점 충원
	int a05m_s3 = 0;		//남 내근 강남지점 충원
	int a05m_j3 = 0;		//남 내근 광주지점 충원
	int a05m_k3 = 0;		//남 내근 대구지점 충원
	int a05m_i3 = 0;		//남 내근 인천지점 충원
	int a05m_w3 = 0;		//남 내근 수원지점 충원
	int a05m_gs3 = 0;	//남 내근 강서지점 충원
	int a05m_gr3 = 0;	//남 내근 구로지점 충원
	int a05m_u3 = 0;		//남 내근 울산지점 충원
	int a05m_jr3 = 0;		//남 내근 광화문지점 충원
	int a05m_sp3 = 0;	//남 내근 송파지점 충원
	int a05m_it3 = 0;		//남 내근 IT팀 충원
	
	int a05m_tot3 = 0;	//남 내근 충원 소계
	
	int a05f_yk3 = 0;    	//여 내근 영업기획팀 충원
	int a05f_y3 = 0;    	//여 내근 영업팀 충원
	int a05f_g3 = 0;		//여 내근 고객관리팀 충원
	int a05f_c3 = 0;		//여 내근 총무팀 충원
	int a05f_b3 = 0;		//여 내근 부산지점 충원
	int a05f_d3 = 0;		//여 내근 대전지점 충원
	int a05f_s3 = 0;		//여 내근 강남지점 충원
	int a05f_j3 = 0;		//여 내근 광주지점 충원
	int a05f_k3 = 0;		//여 내근 대구지점 충원
	int a05f_i3 = 0;		//여 내근 인천지점 충원
	int a05f_w3 = 0;		//여 내근 수원지점 충원
	int a05f_gs3 = 0;		//여 내근 강서지점 충원
	int a05f_gr3 = 0;		//여 내근 구로지점 충원
	int a05f_u3 = 0;		//여 내근 울산지점 충원
	int a05f_jr3 = 0;		//여 내근 광화문지점 충원
	int a05f_sp3 = 0;		//여 내근 송파지점 충원
	int a05f_it3 = 0;		//여 내근 IT팀 충원
	
	int a05f_tot3 = 0;	//여 내근 충원 소계
	
	int a05m_yk4 = 0; 	//남 내근 영업기획팀 퇴사
	int a05m_y4 = 0; 	//남 내근 영업팀 퇴사
	int a05m_g4 = 0;		//남 내근 고객관리팀 퇴사
	int a05m_c4 = 0;		//남 내근 총무팀 퇴사
	int a05m_b4 = 0;		//남 내근 부산지점 퇴사
	int a05m_d4 = 0;		//남 내근 대전지점 퇴사
	int a05m_s4 = 0;		//남 내근 강남지점 퇴사
	int a05m_j4 = 0;		//남 내근 광주지점 퇴사
	int a05m_k4 = 0;		//남 내근 대구지점 퇴사
	int a05m_i4 = 0;		//남 내근 인천지점 퇴사
	int a05m_w4 = 0;		//남 내근 수원지점 퇴사
	int a05m_gs4 = 0;	//남 내근 강서지점 퇴사
	int a05m_gr4 = 0;	//남 내근 구로지점 퇴사
	int a05m_u4 = 0;		//남 내근 울산지점 퇴사
	int a05m_jr4 = 0;		//남 내근 광화문지점 퇴사
	int a05m_sp4 = 0;	//남 내근 송파지점 퇴사
	int a05m_it4 = 0;		//남 IT팀 퇴사
	
	int a05m_tot4 = 0;	//남 내근 퇴사 소계
	
	int a05f_yk4 = 0; 		//여 내근 영업기획팀 퇴사
	int a05f_y4 = 0; 		//여 내근 영업팀 퇴사
	int a05f_g4 = 0;		//여 내근 고객관리팀 퇴사
	int a05f_c4 = 0;		//여 내근 총무팀 퇴사
	int a05f_b4 = 0;		//여 내근 부산지점 퇴사
	int a05f_d4 = 0;		//여 내근 대전지점 퇴사
	int a05f_s4 = 0;		//여 내근 강남지점 퇴사
	int a05f_j4 = 0;		//여 내근 광주지점 퇴사
	int a05f_k4 = 0;		//여 내근 대구지점 퇴사
	int a05f_i4 = 0;		//여 내근 인천지점 퇴사
	int a05f_w4 = 0;		//여 내근 수원지점 퇴사
	int a05f_gs4 = 0;		//여 내근 강서지점 퇴사
	int a05f_gr4 = 0;		//여 내근 구로지점 퇴사
	int a05f_u4 = 0;		//여 내근 울산지점 퇴사
	int a05f_jr4 = 0;		//여 내근 광화문지점 퇴사
	int a05f_sp4 = 0;		//여 송파지점 퇴사
	int a05f_it4 = 0;		//여 IT팀 퇴사 
	
	int a05f_tot4 = 0;	//여 내근 퇴사 소계
	
	int totm_a0513 = 0;		//남 충원 합계
	int totf_a0513 = 0;		//여 충원 합계
	
	int totm_a0524 = 0;		//남 퇴사 합계
	int totf_a0524 = 0;		//남 퇴사 합계
	
	int a05_tot1 = 0;		//외근 충원 소계
	int a05_tot3 = 0;		//관리/사무직 충원 소계
	int a05_it3 = 0;		//기술직 충원 소계
	
	int a05_tot2 = 0;		//외근 퇴사 소계
	int a05_tot4 = 0;		//관리/사무직 퇴사 소계
	int a05_it4 = 0;		//기술직 퇴사 소계
	
	int tot_a0513 = 0;	//충원 합계
	int tot_a0524 = 0	;	//퇴사 합계
		
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
	int thisyear3s = Util.parseInt((nyear-3)+"0101");
	
	int thisyeare = Util.parseInt(nyear+"1231");
	int thisyear1e = Util.parseInt((nyear-1)+"1231");
	int thisyear2e = Util.parseInt((nyear-2)+"1231");
	int thisyear3e = Util.parseInt((nyear-3)+"1231");
	
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

	Vector vt05i = ic_db.gylist2005In(user_id, thisyear3s, thisyear3e);
	int vt05i_size = vt05i.size();

	Vector vt05o = ic_db.gylist2005Out(user_id, thisyear3s, thisyear3e);
	int vt05o_size = vt05o.size();
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

<%//당해년
	String jumin = "";
	String gender = "";
			
	
	if(vt08i_size > 0)	{ 			
		for(int i = 0 ; i < vt08i_size ; i++){
			Hashtable ht08i = (Hashtable)vt08i.elementAt(i);
			
			//성별구분
			jumin = String.valueOf(ht08i.get("USER_SSN"));
	
			gender = jumin.substring(6, 7);	
			
			if(ht08i.get("DEPT_ID").equals("0001")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_y1++;		}//당해년 남 외근 충원
			else if(ht08i.get("DEPT_ID").equals("0020")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_yk1++;		}
			else if(ht08i.get("DEPT_ID").equals("0002")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_g1++;		}
			else if(ht08i.get("DEPT_ID").equals("0003")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_c1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0005")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_it1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0007")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_b1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0008")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_d1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0009")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_s1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0010")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_j1++;			}  
			else if(ht08i.get("DEPT_ID").equals("0011")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_k1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0012")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_i1++;			}  
			else if(ht08i.get("DEPT_ID").equals("0013")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_w1++;		}  		
			else if(ht08i.get("DEPT_ID").equals("0014")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_gs1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0015")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_gr1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0016")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_u1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0017")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_jr1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0018")	&& gender.equals("1") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08m_sp1++;		}  
			
	
			else if(ht08i.get("DEPT_ID").equals("0001")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_y1++;		}//당해년 여 외근 충원
			else if(ht08i.get("DEPT_ID").equals("0020")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_yk1++;		}
			else if(ht08i.get("DEPT_ID").equals("0002")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_g1++;		}
			else if(ht08i.get("DEPT_ID").equals("0003")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_c1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0005")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_it1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0007")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_b1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0008")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_d1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0009")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_s1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0010")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_j1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0011")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_k1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0012")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_i1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0013")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_w1++;	}  		
			else if(ht08i.get("DEPT_ID").equals("0014")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_gs1++;	}  
			else if(ht08i.get("DEPT_ID").equals("0015")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_gr1++;	}  
			else if(ht08i.get("DEPT_ID").equals("0016")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_u1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0017")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_jr1++;		}  
			else if(ht08i.get("DEPT_ID").equals("0018")	&& gender.equals("2") && (ht08i.get("LOAN_ST").equals("2")||ht08i.get("LOAN_ST").equals("1"))){		a08f_sp1++;	}  
	
			
			else if(ht08i.get("DEPT_ID").equals("0001")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_y3++;		}//당해년 남 내근 충원
			else if(ht08i.get("DEPT_ID").equals("0020")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_yk3++;		}
			else if(ht08i.get("DEPT_ID").equals("0002")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_g3++;		}
			else if(ht08i.get("DEPT_ID").equals("0003")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_c3++;		}
			else if(ht08i.get("DEPT_ID").equals("0007")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_b3++;		}
			else if(ht08i.get("DEPT_ID").equals("0008")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_d3++;		}
			else if(ht08i.get("DEPT_ID").equals("0009")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_s3++;		}
			else if(ht08i.get("DEPT_ID").equals("0010")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_j3++;			}
			else if(ht08i.get("DEPT_ID").equals("0011")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_k3++;		}
			else if(ht08i.get("DEPT_ID").equals("0012")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_i3++;			}
			else if(ht08i.get("DEPT_ID").equals("0013")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_w3++;		}
			else if(ht08i.get("DEPT_ID").equals("0014")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_gs3++;		}
			else if(ht08i.get("DEPT_ID").equals("0015")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_gr3++;		}
			else if(ht08i.get("DEPT_ID").equals("0016")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_u3++;		}
			else if(ht08i.get("DEPT_ID").equals("0017")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_jr3++;		}
			else if(ht08i.get("DEPT_ID").equals("0018")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_sp3++;		}
	
			else if(ht08i.get("DEPT_ID").equals("0001")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_y3++;		}//당해년 여 내근 충원
			else if(ht08i.get("DEPT_ID").equals("0020")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_yk3++;		}
			else if(ht08i.get("DEPT_ID").equals("0002")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_g3++;		}
			else if(ht08i.get("DEPT_ID").equals("0003")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_c3++;		}
			else if(ht08i.get("DEPT_ID").equals("0007")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_b3++;		}
			else if(ht08i.get("DEPT_ID").equals("0008")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_d3++;		}
			else if(ht08i.get("DEPT_ID").equals("0009")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_s3++;		}
			else if(ht08i.get("DEPT_ID").equals("0010")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_j3++;		}
			else if(ht08i.get("DEPT_ID").equals("0011")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_k3++;		}
			else if(ht08i.get("DEPT_ID").equals("0012")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_i3++;		}
			else if(ht08i.get("DEPT_ID").equals("0013")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_w3++;	}
			else if(ht08i.get("DEPT_ID").equals("0014")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_gs3++;	}
			else if(ht08i.get("DEPT_ID").equals("0015")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_gr3++;	}
			else if(ht08i.get("DEPT_ID").equals("0016")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_u3++;		}
			else if(ht08i.get("DEPT_ID").equals("0017")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_jr3++;		}
			else if(ht08i.get("DEPT_ID").equals("0018")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_sp3++;	}
			
			else if(ht08i.get("DEPT_ID").equals("0005")	&& gender.equals("1") && ht08i.get("LOAN_ST").equals("")){		a08m_it3++;	}
			else if(ht08i.get("DEPT_ID").equals("0005")	&& gender.equals("2") && ht08i.get("LOAN_ST").equals("")){		a08f_it3++;	}
					
			a08m_tot1 = a08m_yk1 + a08m_y1 + a08m_g1 + a08m_c1 + a08m_b1 + a08m_d1 + a08m_s1 + a08m_j1 + a08m_k1 + a08m_i1 + a08m_w1 + a08m_gs1 + a08m_gr1 + a08m_u1 + a08m_jr1 + a08m_sp1 + a08m_it1;
			a08f_tot1 = a08f_yk1 + a08f_y1 + a08f_g1 + a08f_c1 + a08f_b1 + a08f_d1 + a08f_s1 + a08f_j1 + a08f_k1 + a08f_i1 + a08f_w1 + a08f_gs1 + a08f_gr1 + a08f_u1 + a08f_jr1 + a08f_sp1 + a08f_it1;
			
			a08m_tot3 = a08m_yk3 + a08m_y3 + a08m_g3 + a08m_c3 + a08m_b3 + a08m_d3 + a08m_s3 + a08m_j3 + a08m_k3 + a08m_i3 + a08m_w3 + a08m_gs3 + a08m_gr3 + a08m_u3 + a08m_jr3 + a08m_sp3;
			a08f_tot3 = a08f_yk3 + a08f_y3 + a08f_g3 + a08f_c3 + a08f_b3 + a08f_d3 + a08f_s3 + a08f_j3 + a08f_k3 + a08f_i3 + a08f_w3 + a08f_gs3 + a08f_gr3 + a08f_u3 + a08f_jr3 + a08f_sp3;
			
			
			totm_a0813 = a08m_tot1 + a08m_tot3 + a08m_it3;
			totf_a0813 = a08f_tot1 + a08f_tot3 + a08f_it3;
			
			a08_tot1 = a08m_tot1 + a08f_tot1;	//외근 충원 소계
			a08_tot3 = a08m_tot3 + a08f_tot3;	//관리/사무직 충원 소계
			a08_it3 = a08m_it3 + a08f_it3;			//기술직 충원 소계
			
			tot_a0813 = totm_a0813 + totf_a0813;		//충원 합계
		}
	}
%> 
<%
	if(vt08o_size > 0)	{ 			
		for(int i = 0 ; i < vt08o_size ; i++){
			Hashtable ht08o = (Hashtable)vt08o.elementAt(i);
	
			//성별구분
			jumin = String.valueOf(ht08o.get("USER_SSN"));
			gender = jumin.substring(6, 7);	
	
			if(ht08o.get("DEPT_OUT").equals("0001") && gender.equals("1") || ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1")){	a08m_y2++;	}//당해년 남 외근 퇴사
			else if(ht08o.get("DEPT_OUT").equals("0020") && gender.equals("1") || ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1")){	a08m_yk2++;	}
			else if(ht08o.get("DEPT_OUT").equals("0002") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_g2++;	}
			else if(ht08o.get("DEPT_OUT").equals("0003") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_c2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0005") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_it2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0007") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_b2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0008") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_d2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0009") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_s2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0010") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_j2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0011") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_k2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0012") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_i2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0013") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_w2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0014") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_gs2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0015") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_gr2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0016") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_u2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0017") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_jr2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0018") && gender.equals("1") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){	a08m_sp2++;	}
			
				
			else if(ht08o.get("DEPT_OUT").equals("0001") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_y2++;		}//당해년 여 외근 퇴사
			else if(ht08o.get("DEPT_OUT").equals("0020") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_yk2++;		}
			else if(ht08o.get("DEPT_OUT").equals("0002") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_g2++;		}
			else if(ht08o.get("DEPT_OUT").equals("0003") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_c2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0005") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_it2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0007") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_b2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0008") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_d2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0009") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_s2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0010") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_j2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0011") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_k2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0012") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_i2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0013") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_w2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0014") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_gs2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0015") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_gr2++;	}  
			else if(ht08o.get("DEPT_OUT").equals("0016") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_u2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0017") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_jr2++;		}  
			else if(ht08o.get("DEPT_OUT").equals("0018") && gender.equals("2") && (ht08o.get("LOAN_ST").equals("2")||ht08o.get("LOAN_ST").equals("1"))){		a08f_sp2++;	}
		
			else if(ht08o.get("DEPT_OUT").equals("0001") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_y4++;	}//당해년 남 내근 퇴사
			else if(ht08o.get("DEPT_OUT").equals("0020") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_yk4++;	}//당해년 남 내근 퇴사
			else if(ht08o.get("DEPT_OUT").equals("0002") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_g4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0003") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_c4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0007") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_b4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0008") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_d4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0009") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_s4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0010") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_j4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0011") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_k4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0012") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_i4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0013") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_w4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0014") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_gs4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0015") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_gr4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0016") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_u4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0017") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_jr4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0018") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_sp4++;	}	
			
			else if(ht08o.get("DEPT_OUT").equals("0001") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_y4++;		}//당해년 여 내근 퇴사
			else if(ht08o.get("DEPT_OUT").equals("0020") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_yk4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0002") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_g4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0003") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_c4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0007") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_b4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0008") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_d4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0009") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_s4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0010") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_j4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0011") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_k4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0012") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_i4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0013") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_w4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0014") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_gs4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0015") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_gr4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0016") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_u4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0017") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_jr4++;		}
			else if(ht08o.get("DEPT_OUT").equals("0018") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_sp4++;	}				
			
			else if(ht08o.get("DEPT_OUT").equals("0005") && gender.equals("1") && ht08o.get("LOAN_ST").equals("")){		a08m_it4++;	}
			else if(ht08o.get("DEPT_OUT").equals("0005") && gender.equals("2") && ht08o.get("LOAN_ST").equals("")){		a08f_it4++;		}
			
			//당해년 외근 퇴사
			a08m_tot2 = a08m_yk2 + a08m_y2 + a08m_g2 + a08m_c2 + a08m_b2 + a08m_d2 + a08m_s2 + a08m_j2 + a08m_k2 + a08m_i2 + a08m_w2 + a08m_gs2 + a08m_gr2 + a08m_u2 + a08m_jr2 + a08m_sp2+a08m_it2;
			a08f_tot2 = a08f_yk2 + a08f_y2 + a08f_g2 + a08f_c2 + a08f_b2 + a08f_d2 + a08f_s2 + a08f_j2 + a08f_k2 + a08f_i2 + a08f_w2 + a08f_gs2 + a08f_gr2 + a08f_u2 + a08f_jr2 + a08f_sp2+a08f_it2;
			
			//당해년 관리/사무직 퇴사
			a08m_tot4 = a08m_yk4 + a08m_y4 + a08m_g4 + a08m_c4 + a08m_b4 + a08m_d4 + a08m_s4 + a08m_j4 + a08m_k4 + a08m_i4 + a08m_w4 + a08m_gs4 + a08m_gr4 + a08m_u4 + a08m_jr4 + a08m_sp4;
			a08f_tot4 = a08f_yk4 + a08f_y4 + a08f_g4 + a08f_c4 + a08f_b4 + a08f_d4 + a08f_s4 + a08f_j4 + a08f_k4 + a08f_i4 + a08f_w4 + a08f_gs4 + a08f_gr4 + a08f_u4 + a08f_jr4 + a08f_sp4;
					
			totm_a0824 = a08m_tot2 + a08m_tot4 +  a08m_it4;
			totf_a0824 = a08f_tot2 + a08f_tot4 + a08f_it4;
			
			a08_tot2 = a08m_tot2 + a08f_tot2;		//외근 퇴직 소계
			a08_tot4 = a08m_tot4 + a08f_tot4;		//관리/사무직 퇴직 소계
			a08_it4 = a08m_it4 + a08f_it4;		//기술직 퇴직 소계
			
			tot_a0824 = totm_a0824 + totf_a0824;		//퇴직 합계
			

		}
	}
	
%>	
<%//딩해년-1
	if(vt07i_size > 0)	{ 			
		for(int i = 0 ; i < vt07i_size ; i++){
			Hashtable ht07i = (Hashtable)vt07i.elementAt(i);
			
			//성별구분
			jumin = String.valueOf(ht07i.get("USER_SSN"));
	
			gender = jumin.substring(6, 7);	
			
			if(ht07i.get("DEPT_ID").equals("0001")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_y1++;		}//당해년-1 남 외근 충원
			else if(ht07i.get("DEPT_ID").equals("0020")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_yk1++;		}
			else if(ht07i.get("DEPT_ID").equals("0002")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_g1++;		}
			else if(ht07i.get("DEPT_ID").equals("0003")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_c1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0005")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_it1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0007")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_b1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0008")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_d1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0009")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_s1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0010")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_j1++;			}  
			else if(ht07i.get("DEPT_ID").equals("0011")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_k1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0012")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_i1++;			}  
			else if(ht07i.get("DEPT_ID").equals("0013")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_w1++;		}  		
			else if(ht07i.get("DEPT_ID").equals("0014")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_gs1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0015")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_gr1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0016")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_u1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0017")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_jr1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0018")	&& gender.equals("1") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07m_sp1++;		}  
			
	
			else if(ht07i.get("DEPT_ID").equals("0001")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_y1++;		}//당해년-1 여 외근 충원
			else if(ht07i.get("DEPT_ID").equals("0020")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_yk1++;		}
			else if(ht07i.get("DEPT_ID").equals("0002")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_g1++;		}
			else if(ht07i.get("DEPT_ID").equals("0003")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_c1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0005")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_it1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0007")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_b1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0007")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_d1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0009")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_s1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0010")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_j1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0011")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_k1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0012")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_i1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0013")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_w1++;	}  		
			else if(ht07i.get("DEPT_ID").equals("0014")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_gs1++;	}  
			else if(ht07i.get("DEPT_ID").equals("0015")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_gr1++;	}  
			else if(ht07i.get("DEPT_ID").equals("0016")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_u1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0017")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_jr1++;		}  
			else if(ht07i.get("DEPT_ID").equals("0018")	&& gender.equals("2") && (ht07i.get("LOAN_ST").equals("2")||ht07i.get("LOAN_ST").equals("1"))){		a07f_sp1++;	}  
	
			
			else if(ht07i.get("DEPT_ID").equals("0001")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_y3++;		}//당해년 남 내근 충원
			else if(ht07i.get("DEPT_ID").equals("0020")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_yk3++;		}
			else if(ht07i.get("DEPT_ID").equals("0002")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_g3++;		}
			else if(ht07i.get("DEPT_ID").equals("0003")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_c3++;		}
			else if(ht07i.get("DEPT_ID").equals("0007")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_b3++;		}
			else if(ht07i.get("DEPT_ID").equals("0008")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_d3++;		}
			else if(ht07i.get("DEPT_ID").equals("0009")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_s3++;		}
			else if(ht07i.get("DEPT_ID").equals("0010")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_j3++;			}
			else if(ht07i.get("DEPT_ID").equals("0011")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_k3++;		}
			else if(ht07i.get("DEPT_ID").equals("0012")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_i3++;			}
			else if(ht07i.get("DEPT_ID").equals("0013")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_w3++;		}
			else if(ht07i.get("DEPT_ID").equals("0014")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_gs3++;		}
			else if(ht07i.get("DEPT_ID").equals("0015")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_gr3++;		}
			else if(ht07i.get("DEPT_ID").equals("0016")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_u3++;		}
			else if(ht07i.get("DEPT_ID").equals("0017")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_jr3++;		}
			else if(ht07i.get("DEPT_ID").equals("0018")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_sp3++;		}
	
			else if(ht07i.get("DEPT_ID").equals("0001")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_y3++;		}//당해년 여 내근 충원
			else if(ht07i.get("DEPT_ID").equals("0020")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_yk3++;		}
			else if(ht07i.get("DEPT_ID").equals("0002")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_g3++;		}
			else if(ht07i.get("DEPT_ID").equals("0003")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_c3++;		}
			else if(ht07i.get("DEPT_ID").equals("0007")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_b3++;		}
			else if(ht07i.get("DEPT_ID").equals("0008")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_d3++;		}
			else if(ht07i.get("DEPT_ID").equals("0009")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_s3++;		}
			else if(ht07i.get("DEPT_ID").equals("0010")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_j3++;		}
			else if(ht07i.get("DEPT_ID").equals("0011")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_k3++;		}
			else if(ht07i.get("DEPT_ID").equals("0012")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_i3++;		}
			else if(ht07i.get("DEPT_ID").equals("0013")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_w3++;	}
			else if(ht07i.get("DEPT_ID").equals("0014")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_gs3++;	}
			else if(ht07i.get("DEPT_ID").equals("0015")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_gr3++;	}
			else if(ht07i.get("DEPT_ID").equals("0016")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_u3++;		}
			else if(ht07i.get("DEPT_ID").equals("0017")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_jr3++;		}
			else if(ht07i.get("DEPT_ID").equals("0018")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_sp3++;	}
			
			else if(ht07i.get("DEPT_ID").equals("0005")	&& gender.equals("1") && ht07i.get("LOAN_ST").equals("")){		a07m_it3++;	}
			else if(ht07i.get("DEPT_ID").equals("0005")	&& gender.equals("2") && ht07i.get("LOAN_ST").equals("")){		a07f_it3++;		}
					
			a07m_tot1 = a07m_yk1 + a07m_y1 + a07m_g1 + a07m_c1 + a07m_b1 + a07m_d1 + a07m_s1 + a07m_j1 + a07m_k1 + a07m_i1 + a07m_w1 + a07m_gs1 + a07m_gr1 + a07m_u1 + a07m_jr1 + a07m_sp1 + a07m_it1;
			a07f_tot1 = a07f_yk1 + a07f_y1 + a07f_g1 + a07f_c1 + a07f_b1 + a07f_d1 + a07f_s1 + a07f_j1 + a07f_k1 + a07f_i1 + a07f_w1 + a07f_gs1 + a07f_gr1 + a07f_u1 + a07f_jr1 + a07f_sp1 + a07f_it1;
			
			a07m_tot3 = a07m_yk3 + a07m_y3 + a07m_g3 + a07m_c3 + a07m_b3 + a07m_d3 + a07m_s3 + a07m_j3 + a07m_k3 + a07m_i3 + a07m_w3 + a07m_gs3 + a07m_gr3 + a07m_u3 + a07m_jr3 + a07m_sp3;
			a07f_tot3 = a07f_yk3 + a07f_y3 + a07f_g3 + a07f_c3 + a07f_b3 + a07f_d3 + a07f_s3 + a07f_j3 + a07f_k3 + a07f_i3 + a07f_w3 + a07f_gs3 + a07f_gr3 + a07f_u3 + a07f_jr3 + a07f_sp3;
			
			
			totm_a0713 = a07m_tot1 + a07m_tot3 + a07m_it3;
			totf_a0713 = a07f_tot1 + a07f_tot3 + a07f_it3;
			
			a07_tot1 = a07m_tot1 + a07f_tot1;	//외근 충원 소계
			a07_tot3 = a07m_tot3 + a07f_tot3;	//관리/사무직 충원 소계
			a07_it3 = a07m_it3 + a07f_it3;			//기술직 충원 소계
			
			tot_a0713 = totm_a0713 + totf_a0713;		//충원 합계
		}
	}
	
%> 



<%if(vt07o_size > 0)	{ 			
		for(int i = 0 ; i < vt07o_size ; i++){
			Hashtable ht07o = (Hashtable)vt07o.elementAt(i);
			
			//성별구분
			jumin = String.valueOf(ht07o.get("USER_SSN"));
			gender = jumin.substring(6, 7);	
	
			if(ht07o.get("DEPT_OUT").equals("0001") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_y2++;	}//당해년 남 외근 퇴사
			else if(ht07o.get("DEPT_OUT").equals("0020") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_yk2++;	}
			else if(ht07o.get("DEPT_OUT").equals("0002") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_g2++;	}
			else if(ht07o.get("DEPT_OUT").equals("0003") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_c2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0005") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_it2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0007") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_b2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0008") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_d2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0009") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_s2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0010") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_j2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0011") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_k2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0012") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_i2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0013") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_w2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0014") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_gs2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0015") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_gr2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0016") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_u2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0017") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_jr2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0018") && gender.equals("1") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){	a07m_sp2++;	}
			
				
			else if(ht07o.get("DEPT_OUT").equals("0001") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_y2++;		}//당해년 여 외근 퇴사
			else if(ht07o.get("DEPT_OUT").equals("0020") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_yk2++;		}
			else if(ht07o.get("DEPT_OUT").equals("0002") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_g2++;		}
			else if(ht07o.get("DEPT_OUT").equals("0003") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_c2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0005") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_it2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0007") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_b2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0008") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_d2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0009") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_s2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0010") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_j2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0011") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_k2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0012") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_i2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0013") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_w2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0014") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_gs2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0015") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_gr2++;	}  
			else if(ht07o.get("DEPT_OUT").equals("0016") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_u2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0017") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_jr2++;		}  
			else if(ht07o.get("DEPT_OUT").equals("0018") && gender.equals("2") && (ht07o.get("LOAN_ST").equals("2")||ht07o.get("LOAN_ST").equals("1"))){		a07f_sp2++;	}
		
			else if(ht07o.get("DEPT_OUT").equals("0001") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_y4++;	}//당해년 남 내근 퇴사
			else if(ht07o.get("DEPT_OUT").equals("0020") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_yk4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0002") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_g4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0003") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_c4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0005") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_it4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0007") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_b4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0008") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_d4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0009") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_s4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0010") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_j4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0011") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_k4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0012") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_i4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0013") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_w4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0014") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_gs4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0015") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_gr4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0016") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_u4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0017") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_jr4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0018") && gender.equals("1") || ht07o.get("LOAN_ST").equals("")){		a07m_sp4++;	}	
			
			else if(ht07o.get("DEPT_OUT").equals("0001") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_y4++;		}//당해년 여 내근 퇴사
			else if(ht07o.get("DEPT_OUT").equals("0020") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_yk4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0002") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_g4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0003") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_c4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0005") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_it4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0007") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_b4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0008") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_d4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0009") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_s4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0010") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_j4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0011") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_k4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0012") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_i4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0013") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_w4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0014") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_gs4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0015") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_gr4++;	}
			else if(ht07o.get("DEPT_OUT").equals("0016") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_u4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0017") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_jr4++;		}
			else if(ht07o.get("DEPT_OUT").equals("0018") && gender.equals("2") || ht07o.get("LOAN_ST").equals("")){		a07f_sp4++;	}				
			
			//당해년 외근 퇴사
			a07m_tot2 =  a07m_yk2 + a07m_y2 + a07m_g2 + a07m_c2 + a07m_b2 + a07m_d2 + a07m_s2 + a07m_j2 + a07m_k2 + a07m_i2 + a07m_w2 + a07m_gs2 + a07m_gr2 + a07m_u2 + a07m_jr2 + a07m_sp2+a07m_it2;
			a07f_tot2 = a07f_yk2 + a07f_y2 + a07f_g2 + a07f_c2 + a07f_b2 + a07f_d2 + a07f_s2 + a07f_j2 + a07f_k2 + a07f_i2 + a07f_w2 + a07f_gs2 + a07f_gr2 + a07f_u2 + a07f_jr2 + a07f_sp2+a07f_it2;
			
			//당해년 관리/사무직 퇴사
			a07m_tot4 = a07m_yk4 + a07m_y4 + a07m_g4 + a07m_c4 + a07m_b4 + a07m_d4 + a07m_s4 + a07m_j4 + a07m_k4 + a07m_i4 + a07m_w4 + a07m_gs4 + a07m_gr4 + a07m_u4 + a07m_jr4 + a07m_sp4;
			a07f_tot4 = a07f_yk4 + a07f_y4 + a07f_g4 + a07f_c4 + a07f_b4 + a07f_d4 + a07f_s4 + a07f_j4 + a07f_k4 + a07f_i4 + a07f_w4 + a07f_gs4 + a07f_gr4 + a07f_u4 + a07f_jr4 + a07f_sp4;
					
			totm_a0724 = a07m_tot2 + a07m_tot4 +  a07m_it4;
			totf_a0724 = a07f_tot2 + a07f_tot4 + a07f_it4;
			
			a07_tot2 = a07m_tot2 + a07f_tot2;		//외근 퇴직 소계
			a07_tot4 = a07m_tot4 + a07f_tot4;		//관리/사무직 퇴직 소계
			a07_it4 = a07m_it4 + a07f_it4;		//기술직 퇴직 소계
			
			tot_a0724 = totm_a0724 + totf_a0724;		//퇴직 합계
		}
	}
	
%>	
<%if(vt06i_size > 0)	{ 			
	for(int i = 0 ; i < vt06i_size ; i++){
		Hashtable ht06i = (Hashtable)vt06i.elementAt(i);
		
		//성별구분
		jumin = String.valueOf(ht06i.get("USER_SSN"));

		gender = jumin.substring(6, 7);	
		
		if(ht06i.get("DEPT_ID").equals("0001")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_y1++;		}//당해년-1 남 외근 충원
		else if(ht06i.get("DEPT_ID").equals("0020")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_yk1++;		}
		else if(ht06i.get("DEPT_ID").equals("0002")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_g1++;		}
		else if(ht06i.get("DEPT_ID").equals("0003")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_c1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0005")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_it1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0007")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_b1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0008")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_d1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0009")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_s1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0010")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_j1++;			}  
		else if(ht06i.get("DEPT_ID").equals("0011")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_k1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0012")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_i1++;			}  
		else if(ht06i.get("DEPT_ID").equals("0013")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_w1++;		}  		
		else if(ht06i.get("DEPT_ID").equals("0014")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_gs1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0015")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_gr1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0016")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_u1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0017")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_jr1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0018")	&& gender.equals("1") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06m_sp1++;		}  
		

		else if(ht06i.get("DEPT_ID").equals("0001")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_y1++;		}//당해년-1 여 외근 충원
		else if(ht06i.get("DEPT_ID").equals("0020")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_yk1++;		}
		else if(ht06i.get("DEPT_ID").equals("0002")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_g1++;		}
		else if(ht06i.get("DEPT_ID").equals("0003")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_c1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0005")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_it1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0007")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_b1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0007")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_d1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0009")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_s1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0010")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_j1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0011")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_k1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0012")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_i1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0013")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_w1++;	}  		
		else if(ht06i.get("DEPT_ID").equals("0014")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_gs1++;	}  
		else if(ht06i.get("DEPT_ID").equals("0015")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_gr1++;	}  
		else if(ht06i.get("DEPT_ID").equals("0016")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_u1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0017")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_jr1++;		}  
		else if(ht06i.get("DEPT_ID").equals("0018")	&& gender.equals("2") && (ht06i.get("LOAN_ST").equals("2")||ht06i.get("LOAN_ST").equals("1"))){		a06f_sp1++;	}  

		
		else if(ht06i.get("DEPT_ID").equals("0001")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_y3++;		}//당해년 남 내근 충원
		else if(ht06i.get("DEPT_ID").equals("0020")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_yk3++;		}
		else if(ht06i.get("DEPT_ID").equals("0002")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_g3++;		}
		else if(ht06i.get("DEPT_ID").equals("0003")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_c3++;		}
		else if(ht06i.get("DEPT_ID").equals("0007")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_b3++;		}
		else if(ht06i.get("DEPT_ID").equals("0008")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_d3++;		}
		else if(ht06i.get("DEPT_ID").equals("0009")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_s3++;		}
		else if(ht06i.get("DEPT_ID").equals("0010")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_j3++;			}
		else if(ht06i.get("DEPT_ID").equals("0011")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_k3++;		}
		else if(ht06i.get("DEPT_ID").equals("0012")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_i3++;			}
		else if(ht06i.get("DEPT_ID").equals("0013")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_w3++;		}
		else if(ht06i.get("DEPT_ID").equals("0014")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_gs3++;		}
		else if(ht06i.get("DEPT_ID").equals("0015")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_gr3++;		}
		else if(ht06i.get("DEPT_ID").equals("0016")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_u3++;		}
		else if(ht06i.get("DEPT_ID").equals("0017")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_jr3++;		}
		else if(ht06i.get("DEPT_ID").equals("0018")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_sp3++;		}

		else if(ht06i.get("DEPT_ID").equals("0001")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_y3++;		}//당해년 여 내근 충원
		else if(ht06i.get("DEPT_ID").equals("0020")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_yk3++;		}
		else if(ht06i.get("DEPT_ID").equals("0002")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_g3++;		}
		else if(ht06i.get("DEPT_ID").equals("0003")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_c3++;		}
		else if(ht06i.get("DEPT_ID").equals("0007")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_b3++;		}
		else if(ht06i.get("DEPT_ID").equals("0008")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_d3++;		}
		else if(ht06i.get("DEPT_ID").equals("0009")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_s3++;		}
		else if(ht06i.get("DEPT_ID").equals("0010")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_j3++;		}
		else if(ht06i.get("DEPT_ID").equals("0011")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_k3++;		}
		else if(ht06i.get("DEPT_ID").equals("0012")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_i3++;		}
		else if(ht06i.get("DEPT_ID").equals("0013")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_w3++;	}
		else if(ht06i.get("DEPT_ID").equals("0014")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_gs3++;	}
		else if(ht06i.get("DEPT_ID").equals("0015")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_gr3++;	}
		else if(ht06i.get("DEPT_ID").equals("0016")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_u3++;		}
		else if(ht06i.get("DEPT_ID").equals("0017")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_jr3++;		}
		else if(ht06i.get("DEPT_ID").equals("0018")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_sp3++;	}
		
		else if(ht06i.get("DEPT_ID").equals("0005")	&& gender.equals("1") && ht06i.get("LOAN_ST").equals("")){		a06m_it3++;	}
		else if(ht06i.get("DEPT_ID").equals("0005")	&& gender.equals("2") && ht06i.get("LOAN_ST").equals("")){		a06f_it3++;		}
				
		a06m_tot1 = a06m_yk1 + a06m_y1 + a06m_g1 + a06m_c1 + a06m_b1 + a06m_d1 + a06m_s1 + a06m_j1 + a06m_k1 + a06m_i1 + a06m_w1 + a06m_gs1 + a06m_gr1 + a06m_u1 + a06m_jr1 + a06m_sp1 + a06m_it1;
		a06f_tot1 = a06f_yk1 +  a06f_y1 + a06f_g1 + a06f_c1 + a06f_b1 + a06f_d1 + a06f_s1 + a06f_j1 + a06f_k1 + a06f_i1 + a06f_w1 + a06f_gs1 + a06f_gr1 + a06f_u1 + a06f_jr1 + a06f_sp1 + a06f_it1;
		
		a06m_tot3 = a06m_yk3 + a06m_y3 + a06m_g3 + a06m_c3 + a06m_b3 + a06m_d3 + a06m_s3 + a06m_j3 + a06m_k3 + a06m_i3 + a06m_w3 + a06m_gs3 + a06m_gr3 + a06m_u3 + a06m_jr3 + a06m_sp3;
		a06f_tot3 = a06f_yk3 + a06f_y3 + a06f_g3 + a06f_c3 + a06f_b3 + a06f_d3 + a06f_s3 + a06f_j3 + a06f_k3 + a06f_i3 + a06f_w3 + a06f_gs3 + a06f_gr3 + a06f_u3 + a06f_jr3 + a06f_sp3;
		
		
		totm_a0613 = a06m_tot1 + a06m_tot3 + a06m_it3;
		totf_a0613 = a06f_tot1 + a06f_tot3 + a06f_it3;
		
		a06_tot1 = a06m_tot1 + a06f_tot1;	//외근 충원 소계
		a06_tot3 = a06m_tot3 + a06f_tot3;	//관리/사무직 충원 소계
		a06_it3 = a06m_it3 + a06f_it3;			//기술직 충원 소계
		
		tot_a0613 = totm_a0613 + totf_a0613;		//충원 합계
		}
	}
	
%> 
<%if(vt06o_size > 0)	{ 			
	for(int i = 0 ; i < vt06o_size ; i++){
		Hashtable ht06o = (Hashtable)vt06o.elementAt(i);
		
		//성별구분
		jumin = String.valueOf(ht06o.get("USER_SSN"));
		gender = jumin.substring(6, 7);	

		if(ht06o.get("DEPT_OUT").equals("0001") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_y2++;	}//당해년 남 외근 퇴사
		else if(ht06o.get("DEPT_OUT").equals("0020") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_yk2++;	}
		else if(ht06o.get("DEPT_OUT").equals("0002") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_g2++;	}
		else if(ht06o.get("DEPT_OUT").equals("0003") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_c2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0005") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_it2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0007") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_b2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0008") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_d2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0009") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_s2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0010") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_j2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0011") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_k2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0012") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_i2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0013") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_w2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0014") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_gs2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0015") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_gr2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0016") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_u2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0017") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_jr2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0018") && gender.equals("1") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){	a06m_sp2++;	}
		
			
		else if(ht06o.get("DEPT_OUT").equals("0001") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_y2++;		}//당해년 여 외근 퇴사
		else if(ht06o.get("DEPT_OUT").equals("0020") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_yk2++;		}
		else if(ht06o.get("DEPT_OUT").equals("0002") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_g2++;		}
		else if(ht06o.get("DEPT_OUT").equals("0003") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_c2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0005") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_it2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0007") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_b2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0008") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_d2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0009") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_s2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0010") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_j2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0011") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_k2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0012") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_i2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0013") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_w2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0014") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_gs2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0015") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_gr2++;	}  
		else if(ht06o.get("DEPT_OUT").equals("0016") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_u2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0017") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_jr2++;		}  
		else if(ht06o.get("DEPT_OUT").equals("0018") && gender.equals("2") && (ht06o.get("LOAN_ST").equals("2")||ht06o.get("LOAN_ST").equals("1"))){		a06f_sp2++;	}
	
		else if(ht06o.get("DEPT_OUT").equals("0001") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_y4++;	}//당해년 남 내근 퇴사
		else if(ht06o.get("DEPT_OUT").equals("0020") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_yk4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0002") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_g4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0003") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_c4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0005") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_it4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0007") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_b4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0008") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_d4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0009") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_s4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0010") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_j4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0011") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_k4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0012") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_i4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0013") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_w4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0014") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_gs4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0015") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_gr4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0016") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_u4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0017") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_jr4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0018") && gender.equals("1") || ht06o.get("LOAN_ST").equals("")){		a06m_sp4++;	}	
		
		else if(ht06o.get("DEPT_OUT").equals("0001") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_y4++;		}//당해년 여 내근 퇴사
		else if(ht06o.get("DEPT_OUT").equals("0020") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_yk4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0002") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_g4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0003") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_c4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0005") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_it4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0007") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_b4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0008") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_d4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0009") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_s4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0010") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_j4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0011") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_k4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0012") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_i4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0013") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_w4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0014") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_gs4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0015") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_gr4++;	}
		else if(ht06o.get("DEPT_OUT").equals("0016") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_u4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0017") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_jr4++;		}
		else if(ht06o.get("DEPT_OUT").equals("0018") && gender.equals("2") || ht06o.get("LOAN_ST").equals("")){		a06f_sp4++;	}				
		
		//당해년 외근 퇴사
		a06m_tot2 = a06m_yk2 + a06m_y2 + a06m_g2 + a06m_c2 + a06m_b2 + a06m_d2 + a06m_s2 + a06m_j2 + a06m_k2 + a06m_i2 + a06m_w2 + a06m_gs2 + a06m_gr2 + a06m_u2 + a06m_jr2 + a06m_sp2+a06m_it2;
		a06f_tot2 = a06f_yk2 + a06f_y2 + a06f_g2 + a06f_c2 + a06f_b2 + a06f_d2 + a06f_s2 + a06f_j2 + a06f_k2 + a06f_i2 + a06f_w2 + a06f_gs2 + a06f_gr2 + a06f_u2 + a06f_jr2 + a06f_sp2+a06f_it2;
		
		//당해년 관리/사무직 퇴사
		a06m_tot4 = a06m_yk4 + a06m_y4 + a06m_g4 + a06m_c4 + a06m_b4 + a06m_d4 + a06m_s4 + a06m_j4 + a06m_k4 + a06m_i4 + a06m_w4 + a06m_gs4 + a06m_gr4 + a06m_u4 + a06m_jr4 + a06m_sp4;
		a06f_tot4 = a06f_yk4 + a06f_y4 + a06f_g4 + a06f_c4 + a06f_b4 + a06f_d4 + a06f_s4 + a06f_j4 + a06f_k4 + a06f_i4 + a06f_w4 + a06f_gs4 + a06f_gr4 + a06f_u4 + a06f_jr4 + a06f_sp4;
				
		totm_a0624 = a06m_tot2 + a06m_tot4 +  a06m_it4;
		totf_a0624 = a06f_tot2 + a06f_tot4 + a06f_it4;
		
		a06_tot2 = a06m_tot2 + a06f_tot2;		//외근 퇴직 소계
		a06_tot4 = a06m_tot4 + a06f_tot4;		//관리/사무직 퇴직 소계
		a06_it4 = a06m_it4 + a06f_it4;		//기술직 퇴직 소계
		
		tot_a0624 = totm_a0624 + totf_a0624;		//퇴직 합계
	}
}
	
%> 
<%if(vt05i_size > 0)	{ 			
	for(int i = 0 ; i < vt05i_size ; i++){
		Hashtable ht05i = (Hashtable)vt05i.elementAt(i);
		
		//성별구분
		jumin = String.valueOf(ht05i.get("USER_SSN"));

		gender = jumin.substring(6, 7);	
		
		if(ht05i.get("DEPT_ID").equals("0001")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_y1++;		}//당해년-1 남 외근 충원
		else if(ht05i.get("DEPT_ID").equals("0020")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_yk1++;		}
		else if(ht05i.get("DEPT_ID").equals("0002")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_g1++;		}
		else if(ht05i.get("DEPT_ID").equals("0003")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_c1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0005")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_it1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0007")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_b1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0008")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_d1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0009")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_s1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0010")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_j1++;			}  
		else if(ht05i.get("DEPT_ID").equals("0011")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_k1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0012")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_i1++;			}  
		else if(ht05i.get("DEPT_ID").equals("0013")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_w1++;		}  		
		else if(ht05i.get("DEPT_ID").equals("0014")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_gs1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0015")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_gr1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0016")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_u1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0017")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_jr1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0018")	&& gender.equals("1") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05m_sp1++;		}  
		

		else if(ht05i.get("DEPT_ID").equals("0001")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_y1++;		}//당해년-1 여 외근 충원
		else if(ht05i.get("DEPT_ID").equals("0020")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_yk1++;		}
		else if(ht05i.get("DEPT_ID").equals("0002")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_g1++;		}
		else if(ht05i.get("DEPT_ID").equals("0003")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_c1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0005")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_it1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0007")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_b1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0007")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_d1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0009")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_s1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0010")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_j1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0011")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_k1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0012")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_i1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0013")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_w1++;	}  		
		else if(ht05i.get("DEPT_ID").equals("0014")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_gs1++;	}  
		else if(ht05i.get("DEPT_ID").equals("0015")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_gr1++;	}  
		else if(ht05i.get("DEPT_ID").equals("0016")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_u1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0017")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_jr1++;		}  
		else if(ht05i.get("DEPT_ID").equals("0018")	&& gender.equals("2") && (ht05i.get("LOAN_ST").equals("2")||ht05i.get("LOAN_ST").equals("1"))){		a05f_sp1++;	}  

		
		else if(ht05i.get("DEPT_ID").equals("0001")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_y3++;		}//당해년 남 내근 충원
		else if(ht05i.get("DEPT_ID").equals("0020")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_yk3++;		}
		else if(ht05i.get("DEPT_ID").equals("0002")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_g3++;		}
		else if(ht05i.get("DEPT_ID").equals("0003")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_c3++;		}
		else if(ht05i.get("DEPT_ID").equals("0007")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_b3++;		}
		else if(ht05i.get("DEPT_ID").equals("0008")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_d3++;		}
		else if(ht05i.get("DEPT_ID").equals("0009")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_s3++;		}
		else if(ht05i.get("DEPT_ID").equals("0010")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_j3++;			}
		else if(ht05i.get("DEPT_ID").equals("0011")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_k3++;		}
		else if(ht05i.get("DEPT_ID").equals("0012")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_i3++;			}
		else if(ht05i.get("DEPT_ID").equals("0013")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_w3++;		}
		else if(ht05i.get("DEPT_ID").equals("0014")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_gs3++;		}
		else if(ht05i.get("DEPT_ID").equals("0015")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_gr3++;		}
		else if(ht05i.get("DEPT_ID").equals("0016")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_u3++;		}
		else if(ht05i.get("DEPT_ID").equals("0017")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_jr3++;		}
		else if(ht05i.get("DEPT_ID").equals("0018")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_sp3++;		}

		else if(ht05i.get("DEPT_ID").equals("0001")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_y3++;		}//당해년 여 내근 충원
		else if(ht05i.get("DEPT_ID").equals("0020")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_yk3++;		}
		else if(ht05i.get("DEPT_ID").equals("0002")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_g3++;		}
		else if(ht05i.get("DEPT_ID").equals("0003")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_c3++;		}
		else if(ht05i.get("DEPT_ID").equals("0007")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_b3++;		}
		else if(ht05i.get("DEPT_ID").equals("0008")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_d3++;		}
		else if(ht05i.get("DEPT_ID").equals("0009")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_s3++;		}
		else if(ht05i.get("DEPT_ID").equals("0010")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_j3++;		}
		else if(ht05i.get("DEPT_ID").equals("0011")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_k3++;		}
		else if(ht05i.get("DEPT_ID").equals("0012")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_i3++;		}
		else if(ht05i.get("DEPT_ID").equals("0013")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_w3++;	}
		else if(ht05i.get("DEPT_ID").equals("0014")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_gs3++;	}
		else if(ht05i.get("DEPT_ID").equals("0015")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_gr3++;	}
		else if(ht05i.get("DEPT_ID").equals("0016")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_u3++;		}
		else if(ht05i.get("DEPT_ID").equals("0017")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_jr3++;		}
		else if(ht05i.get("DEPT_ID").equals("0018")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_sp3++;	}
		
		else if(ht05i.get("DEPT_ID").equals("0005")	&& gender.equals("1") && ht05i.get("LOAN_ST").equals("")){		a05m_it3++;	}
		else if(ht05i.get("DEPT_ID").equals("0005")	&& gender.equals("2") && ht05i.get("LOAN_ST").equals("")){		a05f_it3++;		}
				
		a05m_tot1 = a05m_yk1 + a05m_y1 + a05m_g1 + a05m_c1 + a05m_b1 + a05m_d1 + a05m_s1 + a05m_j1 + a05m_k1 + a05m_i1 + a05m_w1 + a05m_gs1 + a05m_gr1 + a05m_u1 + a05m_jr1 + a05m_sp1 + a05m_it1;
		a05f_tot1 = a05f_yk1 + a05f_y1 + a05f_g1 + a05f_c1 + a05f_b1 + a05f_d1 + a05f_s1 + a05f_j1 + a05f_k1 + a05f_i1 + a05f_w1 + a05f_gs1 + a05f_gr1 + a05f_u1 + a05f_jr1 + a05f_sp1 + a05f_it1;
		
		a05m_tot3 = a05m_yk3 + a05m_y3 + a05m_g3 + a05m_c3 + a05m_b3 + a05m_d3 + a05m_s3 + a05m_j3 + a05m_k3 + a05m_i3 + a05m_w3 + a05m_gs3 + a05m_gr3 + a05m_u3 + a05m_jr3 + a05m_sp3;
		a05f_tot3 = a05f_yk3 + a05f_y3 + a05f_g3 + a05f_c3 + a05f_b3 + a05f_d3 + a05f_s3 + a05f_j3 + a05f_k3 + a05f_i3 + a05f_w3 + a05f_gs3 + a05f_gr3 + a05f_u3 + a05f_jr3 + a05f_sp3;
		
		
		totm_a0513 = a05m_tot1 + a05m_tot3 + a05m_it3;
		totf_a0513 = a05f_tot1 + a05f_tot3 + a05f_it3;
		
		a05_tot1 = a05m_tot1 + a05f_tot1;	//외근 충원 소계
		a05_tot3 = a05m_tot3 + a05f_tot3;	//관리/사무직 충원 소계
		a05_it3 = a05m_it3 + a05f_it3;			//기술직 충원 소계
		
		tot_a0513 = totm_a0513 + totf_a0513;		//충원 합계
		}
	}
	
%> 
<%if(vt05o_size > 0)	{ 			
	for(int i = 0 ; i < vt05o_size ; i++){
		Hashtable ht05o = (Hashtable)vt05o.elementAt(i);

		//성별구분
		jumin = String.valueOf(ht05o.get("USER_SSN"));
		gender = jumin.substring(6, 7);	

		if(ht05o.get("DEPT_OUT").equals("0001") && gender.equals("1") || ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1")){	a05m_y2++;	}//당해년 남 외근 퇴사
		else if(ht05o.get("DEPT_OUT").equals("0020") && gender.equals("1") || ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1")){	a05m_yk2++;	}
		else if(ht05o.get("DEPT_OUT").equals("0002") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_g2++;	}
		else if(ht05o.get("DEPT_OUT").equals("0003") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_c2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0005") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_it2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0007") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_b2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0008") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_d2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0009") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_s2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0010") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_j2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0011") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_k2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0012") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_i2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0013") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_w2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0014") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_gs2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0015") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_gr2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0016") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_u2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0017") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_jr2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0018") && gender.equals("1") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){	a05m_sp2++;	}
		
			
		else if(ht05o.get("DEPT_OUT").equals("0001") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_y2++;		}//당해년 여 외근 퇴사
		else if(ht05o.get("DEPT_OUT").equals("0020") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_yk2++;		}
		else if(ht05o.get("DEPT_OUT").equals("0002") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_g2++;		}
		else if(ht05o.get("DEPT_OUT").equals("0003") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_c2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0005") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_it2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0007") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_b2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0008") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_d2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0009") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_s2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0010") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_j2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0011") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_k2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0012") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_i2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0013") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_w2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0014") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_gs2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0015") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_gr2++;	}  
		else if(ht05o.get("DEPT_OUT").equals("0016") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_u2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0017") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_jr2++;		}  
		else if(ht05o.get("DEPT_OUT").equals("0018") && gender.equals("2") && (ht05o.get("LOAN_ST").equals("2")||ht05o.get("LOAN_ST").equals("1"))){		a05f_sp2++;	}
	
		else if(ht05o.get("DEPT_OUT").equals("0001") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_y4++;	}//당해년 남 내근 퇴사
		else if(ht05o.get("DEPT_OUT").equals("0020") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_yk4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0002") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_g4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0003") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_c4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0007") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_b4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0008") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_d4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0009") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_s4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0010") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_j4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0011") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_k4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0012") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_i4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0013") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_w4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0014") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_gs4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0015") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_gr4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0016") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_u4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0017") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_jr4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0018") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_sp4++;	}	
		
		else if(ht05o.get("DEPT_OUT").equals("0001") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_y4++;		}//당해년 여 내근 퇴사
		else if(ht05o.get("DEPT_OUT").equals("0020") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_yk4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0002") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_g4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0003") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_c4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0007") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_b4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0008") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_d4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0009") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_s4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0010") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_j4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0011") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_k4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0012") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_i4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0013") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_w4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0014") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_gs4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0015") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_gr4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0016") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_u4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0017") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_jr4++;		}
		else if(ht05o.get("DEPT_OUT").equals("0018") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_sp4++;	}				
		
		else if(ht05o.get("DEPT_OUT").equals("0005") && gender.equals("1") && ht05o.get("LOAN_ST").equals("")){		a05m_it4++;	}
		else if(ht05o.get("DEPT_OUT").equals("0005") && gender.equals("2") && ht05o.get("LOAN_ST").equals("")){		a05f_it4++;		}
		
		//당해년 외근 퇴사
		a05m_tot2 = a05m_yk2 + a05m_y2 + a05m_g2 + a05m_c2 + a05m_b2 + a05m_d2 + a05m_s2 + a05m_j2 + a05m_k2 + a05m_i2 + a05m_w2 + a05m_gs2 + a05m_gr2 + a05m_u2 + a05m_jr2 + a05m_sp2+a05m_it2;
		a05f_tot2 = a05f_yk2 + a05f_y2 + a05f_g2 + a05f_c2 + a05f_b2 + a05f_d2 + a05f_s2 + a05f_j2 + a05f_k2 + a05f_i2 + a05f_w2 + a05f_gs2 + a05f_gr2 + a05f_u2 + a05f_jr2 + a05f_sp2+a05f_it2;
		
		//당해년 관리/사무직 퇴사
		a05m_tot4 = a05m_yk4 + a05m_y4 + a05m_g4 + a05m_c4 + a05m_b4 + a05m_d4 + a05m_s4 + a05m_j4 + a05m_k4 + a05m_i4 + a05m_w4 + a05m_gs4 + a05m_gr4 + a05m_u4 + a05m_jr4 + a05m_sp4;
		a05f_tot4 = a05f_yk4 + a05f_y4 + a05f_g4 + a05f_c4 + a05f_b4 + a05f_d4 + a05f_s4 + a05f_j4 + a05f_k4 + a05f_i4 + a05f_w4 + a05f_gs4 + a05f_gr4 + a05f_u4 + a05f_jr4 + a05f_sp4;
				
		totm_a0524 = a05m_tot2 + a05m_tot4 +  a05m_it4;
		totf_a0524 = a05f_tot2 + a05f_tot4 + a05f_it4;
		
		a05_tot2 = a05m_tot2 + a05f_tot2;		//외근 퇴직 소계
		a05_tot4 = a05m_tot4 + a05f_tot4;		//관리/사무직 퇴직 소계
		a05_it4 = a05m_it4 + a05f_it4;		//기술직 퇴직 소계
		
		tot_a0524 = totm_a0524 + totf_a0524;		//퇴직 합계
	}
}
	
%> 
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
				<td>
					<img src=/acar/images/center/icon_arrow.gif align=absmiddle>
					<span class=style2>직군별현황 </span>
				</td>
				<td align="right">
					<span style="text-align:right">※ 년도별 12월 31일 기준으로 조회 되었습니다.</span>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<table border="0" cellspacing="0" cellpadding="0" width=100%>
						<tr>
							<td class=line2 colspan=2></td>
						</tr>
						<tr id='tr_title'>
							<td class='line2' id='td_title'>
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td colspan="2" class='title' rowspan="2">구분</td>
										<td class='title' colspan="4">신규채용현황</td>
										<td class='title' colspan="4">퇴직현황</td>
									</tr>
									<tr>
										<td width="10%" class='title'>외근직</td>
										<td width="10%" class='title'>관리/사무직</td>
										<td width="10%" class='title'>기술직</td>
										<td width="10%" class='title'>합계</td>
										<td width="10%" class='title'>외근직</td>
										<td width="10%" class='title'>관리/사무직</td>
										<td width="10%" class='title'>기술직</td>
										<td width="10%" class='title'>합계</td>
									</tr>
									<tr>
										<td class='title' width="10%" rowspan="3"><%=nyear%>년</td>
										<td class='title' width="10%">남</td>
										<td align="center"><%=a08m_tot1%> 명</td>
										<td align="center"><%=a08m_tot3%> 명</td>
										<td align="center"><%=a08m_it3%> 명</td>
										<td align="center"><%=totm_a0813%> 명</td>
										<td align="center"><%=a08m_tot2%> 명</td>
										<td align="center"><%=a08m_tot4%> 명</td>
										<td align="center"><%=a08m_it4%> 명</td>
										<td align="center"><%=totm_a0824%> 명</td>
									</tr>
									<tr>
										<td class='title'>여</td>
										<td align="center"><%=a08f_tot1%> 명</td>
										<td align="center"><%=a08f_tot3%> 명</td>
										<td align="center"><%=a08f_it3%> 명</td>
										<td align="center"><%=totf_a0813%> 명</td>
										<td align="center"><%=a08f_tot2%> 명</td>
										<td align="center"><%=a08f_tot4%> 명</td>
										<td align="center"><%=a08f_it4%> 명</td>
										<td align="center"><%=totf_a0824%> 명</td>
									</tr>
									<tr>
										<td class='title'>소계</td>
										<td class='title'><%=a08_tot1%> 명</td>
										<td class='title'><%=a08_tot3%> 명</td>
										<td class='title'><%=a08_it3%> 명</td>
										<td class='title'><%=tot_a0813%> 명</td>
										<td class='title'><%=a08_tot2%> 명</td>
										<td class='title'><%=a08_tot4%> 명</td>
										<td class='title'><%=a08_it4%> 명</td>
										<td class='title'><%=tot_a0824%> 명</td>
									</tr>
									<tr>
										<td class='title' rowspan="3"><%=nyear-1%>년</td>
										<td class='title'>남</td>
										<td align="center"><%=a07m_tot1%> 명</td>
										<td align="center"><%=a07m_tot3%> 명</td>
										<td align="center"><%=a07m_it3%> 명</td>
										<td align="center"><%=totm_a0713%> 명</td>
										<td align="center"><%=a07m_tot2%> 명</td>
										<td align="center"><%=a07m_tot4%> 명</td>
										<td align="center"><%=a07m_it4%> 명</td>
										<td align="center"><%=totm_a0724%> 명</td>
									</tr>
									<tr>
										<td class='title'>여</td>
										<td align="center"><%=a07f_tot1%> 명</td>
										<td align="center"><%=a07f_tot3%> 명</td>
										<td align="center"><%=a07f_it3%> 명</td>
										<td align="center"><%=totf_a0713%> 명</td>
										<td align="center"><%=a07f_tot2%> 명</td>
										<td align="center"><%=a07f_tot4%> 명</td>
										<td align="center"><%=a07f_it4%> 명</td>
										<td align="center"><%=totf_a0724%> 명</td>
									</tr>
									<tr>
										<td class='title'>소계</td>
										<td class='title'><%=a07_tot1%> 명</td>
										<td class='title'><%=a07_tot3%> 명</td>
										<td class='title'><%=a07_it3%> 명</td>
										<td class='title'><%=tot_a0713%> 명</td>
										<td class='title'><%=a07_tot2%> 명</td>
										<td class='title'><%=a07_tot4%> 명</td>
										<td class='title'><%=a07_it4%> 명</td>
										<td class='title'><%=tot_a0724%> 명</td>
									</tr>
									<tr>
										<td class='title' rowspan="3"><%=nyear-2%>년</td>
										<td class='title'>남</td>
										<td align="center"><%=a06m_tot1%> 명</td>
										<td align="center"><%=a06m_tot3%> 명</td>
										<td align="center"><%=a06m_it3%> 명</td>
										<td align="center"><%=totm_a0613%> 명</td>
										<td align="center"><%=a06m_tot2%> 명</td>
										<td align="center"><%=a06m_tot4%> 명</td>
										<td align="center"><%=a06m_it4%> 명</td>
										<td align="center"><%=totm_a0624%> 명</td>
									</tr>
									<tr>
										<td class='title'>여</td>
										<td align="center"><%=a06f_tot1%> 명</td>
										<td align="center"><%=a06f_tot3%> 명</td>
										<td align="center"><%=a06f_it3%> 명</td>
										<td align="center"><%=totf_a0613%> 명</td>
										<td align="center"><%=a06f_tot2%> 명</td>
										<td align="center"><%=a06f_tot4%> 명</td>
										<td align="center"><%=a06f_it4%> 명</td>
										<td align="center"><%=totf_a0624%> 명</td>
									</tr>
									<tr>
										<td class='title'>소계</td>
										<td class='title'><%=a06_tot1%> 명</td>
										<td class='title'><%=a06_tot3%> 명</td>
										<td class='title'><%=a06_it3%> 명</td>
										<td class='title'><%=tot_a0613%> 명</td>
										<td class='title'><%=a06_tot2%> 명</td>
										<td class='title'><%=a06_tot4%> 명</td>
										<td class='title'><%=a06_it4%> 명</td>
										<td class='title'><%=tot_a0624%> 명</td>
									</tr>
									<tr>
										<td class='title' rowspan="3"><%=nyear-3%>년</td>
										<td class='title'>남</td>
										<td align="center"><%=a05m_tot1%> 명</td>
										<td align="center"><%=a05m_tot3%> 명</td>
										<td align="center"><%=a05m_it3%> 명</td>
										<td align="center"><%=totm_a0513%> 명</td>
										<td align="center"><%=a05m_tot2%> 명</td>
										<td align="center"><%=a05m_tot4%> 명</td>
										<td align="center"><%=a05m_it4%> 명</td>
										<td align="center"><%=totm_a0524%> 명</td>
									</tr>
									<tr>
										<td class='title'>여</td>
										<td align="center"><%=a05f_tot1%> 명</td>
										<td align="center"><%=a05f_tot3%> 명</td>
										<td align="center"><%=a05f_it3%> 명</td>
										<td align="center"><%=totf_a0513%> 명</td>
										<td align="center"><%=a05f_tot2%> 명</td>
										<td align="center"><%=a05f_tot4%> 명</td>
										<td align="center"><%=a05f_it4%> 명</td>
										<td align="center"><%=totf_a0524%> 명</td>
									</tr>
									<tr>
										<td class='title'>소계</td>
										<td class='title'><%=a05_tot1%> 명</td>
										<td class='title'><%=a05_tot3%> 명</td>
										<td class='title'><%=a05_it3%> 명</td>
										<td class='title'><%=tot_a0513%> 명</td>
										<td class='title'><%=a05_tot2%> 명</td>
										<td class='title'><%=a05_tot4%> 명</td>
										<td class='title'><%=a05_it4%> 명</td>
										<td class='title'><%=tot_a0524%> 명</td>
									</tr>
									<tr>
										<td class='title' rowspan="3">합계</td>
										<td class='title'>남</td>
										<td align="center"><%=a08m_tot1 + a07m_tot1 + a06m_tot1 + a05m_tot1%> 명</td>
										<td align="center"><%=a08m_tot3 + a07m_tot3 + a06m_tot3 + a05m_tot3%> 명</td>
										<td align="center"><%=a08m_it3 + a07m_it3 + a06m_it3 + a05m_it3%> 명</td>
										<td align="center"><%=totm_a0813 + totm_a0713 + totm_a0613 + totm_a0513%> 명</td>
										<td align="center"><%=a08m_tot2 + a07m_tot2 + a06m_tot2+ a05m_tot2%> 명</td>
										<td align="center"><%=a08m_tot4 + a07m_tot4 + a06m_tot4 + a05m_tot4%> 명</td>
										<td align="center"><%=a08m_it4 + a07m_it4 + a06m_it4 + a05m_it4%> 명</td>
										<td align="center"><%=totm_a0824 + totm_a0724 + totm_a0624 + totm_a0524%> 명</td>
									</tr>
									<tr>
										<td class='title'>여</td>
										<td align="center"><%=a08f_tot1 + a07f_tot1 + a06f_tot1 + a05f_tot1%> 명</td>
										<td align="center"><%=a08f_tot3 + a07f_tot3 + a06f_tot3 + a05f_tot3%> 명</td>
										<td align="center"><%=a08f_it3 + a07f_it3 + a06f_it3 + a05f_it3%> 명</td>
										<td align="center"><%=totf_a0813 + totf_a0713 + totf_a0613 + totf_a0513%> 명</td>
										<td align="center"><%=a08f_tot2 + a07f_tot2 + a06f_tot2+ a05f_tot2%> 명</td>
										<td align="center"><%=a08f_tot4 + a07f_tot4 + a06f_tot4 + a05f_tot4%> 명</td>
										<td align="center"><%=a08f_it4 + a07f_it4 + a06f_it4 + a05f_it4%> 명</td>
										<td align="center"><%=totf_a0824 + totf_a0724 + totf_a0624 + totf_a0524%> 명</td>
									</tr>
									<tr>
										<td class='title'>소계</td>
										<td class='title'><%=a08_tot1 + a07_tot1 + a06_tot1 + a05_tot1%> 명</td>
										<td class='title'><%=a08_tot3 + a07_tot3 + a06_tot3 + a05_tot3%> 명</td>
										<td class='title'><%=a08_it3 + a07_it3 + a06_it3 + a05_it3%> 명</td>
										<td class='title'><%=tot_a0813 + tot_a0713 + tot_a0613 + tot_a0513%> 명</td>
										<td class='title'><%=a08_tot2 + a07_tot2 + a06_tot2 + a05_tot2%> 명</td>
										<td class='title'><%=a08_tot4 + a07_tot4 + a06_tot4 + a05_tot4%> 명</td>
										<td class='title'><%=a08_it4 + a07_it4 + a06_it4 + a05_it4%> 명</td>
										<td class='title'><%=tot_a0824 + tot_a0724 + tot_a0624 + tot_a0524%> 명</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="h" colspan="2"></td>
			</tr>
			<tr>
				<td class="h" colspan="2"></td>
			</tr>
			<tr>
				<td class="h" colspan="2"></td>
			</tr>
			<tr>
				<td colspan="2">
					<table border="0" cellspacing="0" cellpadding="0" width=100%>
						<tr>
							<td>
								<iframe src="gy2_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>" width="100%" height="230" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > </iframe>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
</form>
</body>
</html>