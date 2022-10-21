<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.* " %>
<%@ page import="acar.secondhand.*, acar.estimate_mng.*, acar.res_search.*, acar.car_register.*" %>
<%@ page import="acar.accid.*, acar.car_service.*"%>
<jsp:useBean id="shDb" 	class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="shBn" 		class="acar.secondhand.SecondhandBean" 		scope="page"/>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 	scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<jsp:useBean id="oh_db" 	class="acar.off_ls_hpg.OfflshpgDatabase" 	scope="session"/>
<jsp:useBean id="e_bean" 	class="acar.estimate_mng.EstimateBean" 		scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	EstiDatabase e_db 		= EstiDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
	LoginBean login 		= LoginBean.getInstance();

	String auth_rw 			= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 				= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 			= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String res_yn 				= request.getParameter("res_yn")==null?"":request.getParameter("res_yn");
	String res_mon_yn		= request.getParameter("res_mon_yn")==null?"":request.getParameter("res_mon_yn");

	String est_st 				= request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String fee_opt_amt 		= request.getParameter("fee_opt_amt")==null?"":request.getParameter("fee_opt_amt");
	String fee_rent_st 		= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");

	String est_id 				= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String spe_seq 			= request.getParameter("spe_seq")==null?"":request.getParameter("spe_seq");
	String est_table 			= request.getParameter("est_table")==null?"":request.getParameter("est_table");
	String from_page 		= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");

	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	String car_mng_id 		= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id 		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 			= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String br_to_st 			= request.getParameter("br_to_st")==null?"":request.getParameter("br_to_st");
	
	//차량등록정보
	if (!car_mng_id.equals("")) {
		cr_bean = crd.getCarRegBean(car_mng_id);
	}

	//월렌트관리에서 재리스견적을 위해
	if (from_page.equals("/fms2/lc_rent/lc_rm_frame.jsp")) {
		rent_mng_id = "";
		rent_l_cd = "";
		est_st = "1";
	}

	//사고
	Vector vt = oh_db.getServCarHisList(car_mng_id);
	int vt_size = vt.size();

	//예약상태
	ShResBean srBn = shDb.getShRes(car_mng_id);

	Vector sr = shDb.getShResList(car_mng_id);
	int sr_size = sr.size();

	Vector srh = shDb.getShResHList(car_mng_id);
	int srh_size = srh.size();

	//대차관리 배차상태
	Hashtable reserv = rs_db.getResCarCase(car_mng_id, "2");
	String use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
	
	//대차관리 예약현황
	Vector conts = rs_db.getResCarList(car_mng_id);
	int cont_size = conts.size();
	
	int cont_size2 = 0;
	for (int i = 0; i < cont_size; i++) {
		Hashtable reservs2 = (Hashtable)conts.elementAt(i);
		if (String.valueOf(reservs2.get("USE_ST")).equals("예약")) {
			cont_size2++;
		}
	}
		
	if (use_st.equals("null") && cont_size2 == 1) {
		reserv = rs_db.getResCarCase(car_mng_id, "1");
		use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
		cont_size = 0;
	}

	//최근 홈페이지 적용대여료 약정주행거리 10000 - 기본
	Hashtable hp = oh_db.getSecondhandCase_20090901("", "", car_mng_id);	
	
	//최근 홈페이지 적용대여료 약정주행거리 20000
	Hashtable hp_2d = oh_db.getSecondhandCaseDist("", "", car_mng_id, "20000");	

	//최근 홈페이지 적용대여료 약정주행거리 30000
	Hashtable hp_3d = oh_db.getSecondhandCaseDist("", "", car_mng_id, "30000");

	//최근 홈페이지 적용대여료 약정주행거리 40000
	Hashtable hp_4d = oh_db.getSecondhandCaseDist("", "", car_mng_id, "40000");

	//최근 홈페이지 적용대여료 - 월대여료
	Hashtable hp2 = oh_db.getSecondhandCaseRm("", "", car_mng_id);

	//자산양수차량
	Hashtable ht_ac = shDb.getCarAcInfo(car_mng_id);

	//차량정보	
	Hashtable ht = shDb.getShBase(car_mng_id);

	String car_comp_id			= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_cd					= String.valueOf(ht.get("CAR_CD"));
	String car_id					= String.valueOf(ht.get("CAR_ID"));
	String car_seq					= String.valueOf(ht.get("CAR_SEQ"));
	String s_st 						= String.valueOf(ht.get("S_ST"));
	String jg_code 				= String.valueOf(ht.get("JG_CODE"));
	String car_no 					= String.valueOf(ht.get("CAR_NO"));
	String car_name				= String.valueOf(ht.get("CAR_NAME"));
	String init_reg_dt 			= String.valueOf(ht.get("INIT_REG_DT"));
	String car_y_form			= String.valueOf(ht.get("CAR_Y_FORM"));
	String secondhand_dt 		= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 				= String.valueOf(ht.get("PARK"));
	String dlv_dt 					= String.valueOf(ht.get("DLV_DT"));
	String before_one_year		= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 				= String.valueOf(ht.get("TOT_DIST"));
	String today_dist 			= String.valueOf(ht.get("TODAY_DIST"));
	today_dist 						= String.valueOf(ht.get("TOT_DIST")); //20170629 최종주행거리 기준으로 견적한다.
	String serv_dt	 				= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 				= String.valueOf(ht.get("LPG_YN"));
	String opt		 				= String.valueOf(ht.get("OPT"));
	String colo		 				= String.valueOf(ht.get("COL"));
	String add_opt	 			= String.valueOf(ht.get("ADD_OPT"));
	int car_amt 					= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 					= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 						= AddUtil.parseInt((String)ht.get("COL_AMT"));
	int accid_serv_amt1			= AddUtil.parseInt((String)ht.get("ACCID_SERV_AMT1"));
	int accid_serv_amt2			= AddUtil.parseInt((String)ht.get("ACCID_SERV_AMT2"));
	int add_opt_amt				= AddUtil.parseInt((String)ht.get("ADD_OPT_AMT"));
	String jg_opt_st	 			= String.valueOf(ht.get("JG_OPT_ST"));
	String jg_col_st	 			= String.valueOf(ht.get("JG_COL_ST"));
	String jg_tuix_st	 			= String.valueOf(ht.get("JG_TUIX_ST"));
	String jg_tuix_opt_st		= String.valueOf(ht.get("JG_TUIX_OPT_ST"));
	String lkas_yn	 				= String.valueOf(ht.get("LKAS_YN"));
	String ldws_yn		 		= String.valueOf(ht.get("LDWS_YN"));
	String aeb_yn	 				= String.valueOf(ht.get("AEB_YN"));
	String fcw_yn	 				= String.valueOf(ht.get("FCW_YN"));
	String hook_yn		 		= String.valueOf(ht.get("HOOK_YN"));
	String legal_yn		 		= String.valueOf(ht.get("LEGAL_YN"));	
	String max_use_mon	 	= String.valueOf(hp.get("MAX_USE_MON"));
	
	//신차 개소세 감면액 추가(2017.10.13)
	int tax_dc_amt	 			= AddUtil.parseInt((String)ht.get("TAX_DC_AMT"));
	
	//중고차잔가변수
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(jg_code, "");
	
	//친환경차 유무 체크 위한 변수
	String jg_g_7 = String.valueOf(ej_bean.getJg_g_7());

	//차량등록 경과기간(차령)
	Hashtable carOld = c_db.getOld(init_reg_dt);
	//재리스등록 경과기간
	Hashtable carOld2 = c_db.getOld(secondhand_dt);
	//주행거리등록 경과기간
	Hashtable carOld3 = c_db.getOld(serv_dt);
	//차량등록 경과기간2(차령만료일2개월전까지)
	Hashtable carOld4 = new Hashtable();
	if (cr_bean.getCar_end_yn().equals("Y")) {
		carOld4 = c_db.getOld(init_reg_dt, cr_bean.getCar_end_dt(), "-60");
		if (!ej_bean.getJg_b().equals("2")) {
			carOld4 = c_db.getOld(init_reg_dt, cr_bean.getCar_end_dt(), "-30"); //20150120 차량만료일까지	-> 20150217 LPG는 2개월전까지, 비LPG는 1개월전까지
		}
	}

	//재리스가격결정권한
	String readonly = "";
	if(!nm_db.getWorkAuthUser("재리스가격결정",user_id)) readonly = "readonly";

	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();

	if (jg_code.equals("")) {
		ej_bean.setJg_a(s_st);
	}

	int mon[] = new int[18];
	mon[0] = 36;
	mon[1] = 24;
	mon[2] = 12;
	mon[3] = 6;

	//스폐셜견적에서 연결
	if (est_table.equals("esti_spe")) {
		e_bean = e_db.getEstimateSpeCarCase(est_id, spe_seq);
	}

	//주차장 정보
	CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;
	
	String rb_max = "0";
	String rs_max = "0";
	String lb_max = "0";
	String ls_max = "0";
	
	String amt1 = "0";
	String amt2 = "0";
	String amt3 = "0";
	String amt4 = "0";
	String amt_id1 = "";
	String amt_id2 = "";
	String amt_id3 = "";
	String amt_id4 = "";
	
	String to_amt1 = "0";
	String to_amt2 = "0";
	String to_amt3 = "0";
	String to_amt4 = "0";
	
	Hashtable estiCommVarSh = oh_db.getEstiCommVarSh();
	
	/* 0.서울 1.대전 2.대구 3.광주 4.부산 */
	/*
	1.영남주차장 2.정일현대 4.대전지점 5.신엠제이 6.기타 7.부산부경 8.웰메이드 9.대전현대 10.오토크린 
	11.대전금호 12.광주지점 13.대구지점 14.서광모터스 16.동화엠파크 18.본동자동차 19.타이어휠타운 20.성서현대
	21.아마존모터스
	*/
	
	String br_from = "";
	String br_to = "";
	//현위치
	if (park.equals("1") || park.equals("2") || park.equals("5") || park.equals("10") || park.equals("14") || park.equals("16") || park.equals("18") || park.equals("19") || park.equals("21")) {
		br_from = "0";		//서울
	} else if (park.equals("4") || park.equals("9") || park.equals("11")) {
		br_from = "1";		//대전
	} else if (park.equals("13") || park.equals("20")) {
		br_from = "2";		//대구
	} else if (park.equals("12")) {
		br_from = "3";		//광주
	} else if (park.equals("3") || park.equals("7") || park.equals("8")) {
		br_from = "4";		//부산
	}
	
	//고객주소지
	if (park.equals("6")) {
		br_from = "0";		//서울
		br_to = "0";
	} else {
		if (!br_to_st.equals("")) {
			if (br_to_st.equals("0") || br_to_st.equals("5")) {
				br_to = "0";
			} else {
				br_to = br_to_st;
			}
		} else {
			br_to = br_from;
		}
	}
	
	int br_cons = AddUtil.parseInt((String)estiCommVarSh.get("BR_CONS_" + br_from + br_to));	
	
	for (int i = 0; i < 4; i++) {
		if (i == 0) {
			to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB36")), AddUtil.parseInt((String)hp.get("RB36_AG")), br_cons);
			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS36")), AddUtil.parseInt((String)hp.get("RS36_AG")), br_cons);
			to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB36")), AddUtil.parseInt((String)hp.get("LB36_AG")), br_cons);
			to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS36")), AddUtil.parseInt((String)hp.get("LS36_AG")), br_cons);
			//amt_id1 = String.valueOf(hp.get("RB36_ID"));	amt_id2 = String.valueOf(hp.get("RS36_ID"));  amt_id3 = String.valueOf(hp.get("LB36_ID"));  amt_id4 = String.valueOf(hp.get("LS36_ID"));
		} else if (i == 1) {
			to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB24")), AddUtil.parseInt((String)hp.get("RB24_AG")), br_cons);
			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS24")), AddUtil.parseInt((String)hp.get("RS24_AG")), br_cons);
			to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB24")), AddUtil.parseInt((String)hp.get("LB24_AG")), br_cons);
			to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS24")), AddUtil.parseInt((String)hp.get("LS24_AG")), br_cons);
			//amt_id1 = String.valueOf(hp.get("RB24_ID"));	amt_id2 = String.valueOf(hp.get("RS24_ID"));  amt_id3 = String.valueOf(hp.get("LB24_ID"));  amt_id4 = String.valueOf(hp.get("LS24_ID"));			
		} else if (i == 2) {
			to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB12")), AddUtil.parseInt((String)hp.get("RB12_AG")), br_cons);
			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS12")), AddUtil.parseInt((String)hp.get("RS12_AG")), br_cons);
			to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB12")), AddUtil.parseInt((String)hp.get("LB12_AG")), br_cons);
			to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS12")), AddUtil.parseInt((String)hp.get("LS12_AG")), br_cons);
			//amt_id1 = String.valueOf(hp.get("RB12_ID"));	amt_id2 = String.valueOf(hp.get("RS12_ID"));  amt_id3 = String.valueOf(hp.get("LB12_ID"));  amt_id4 = String.valueOf(hp.get("LS12_ID"));
		} else if (i == 3) {
			to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB6")), AddUtil.parseInt((String)hp.get("RB6_AG")), br_cons);
			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS6")), AddUtil.parseInt((String)hp.get("RS6_AG")), br_cons);			
			to_amt3 = "0";
			to_amt4 = "0";
			//amt_id1 = String.valueOf(hp.get("RB6_ID"));		amt_id2 = String.valueOf(hp.get("RS6_ID"));  	amt_id3 = "";  	amt_id4 = "";
		}
	}
	
	/* System.out.println("###############");
	System.out.println("br_to_st = " + br_to_st);
	System.out.println("----------------------------");
	System.out.println("br_from = " + br_from);
	System.out.println("br_to = " + br_to);
	System.out.println("br_cons = " + br_cons);
	System.out.println("###############"); */
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<style type="text/css">
 .col_0{	background-color: #FFFFFF;	}
 .col_1{	background-color: #FFB2D9;	}
 .col_2{	background-color: #FAED7D;	}
 .col_3{	background-color: #86E57F;	}
 .col_4{	background-color: #B2CCFF;	}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//배차현황 세부내역 조회
	function view_rentcont(use_st, rent_s_cd){
		var SUBWIN="/acar/res_stat/res_rent_u.jsp?mode=view&c_id=<%=car_mng_id%>&s_cd="+rent_s_cd;
		if(use_st == '배차'){
			SUBWIN="/acar/rent_mng/res_rent_u.jsp?mode=view&c_id=<%=car_mng_id%>&s_cd="+rent_s_cd;
		}
		window.open(SUBWIN, "view_rentcont", "left=5, top=50, width=1000, height=650, scrollbars=yes, status=yes");
	}

	//예약이력
	function view_sh_res_h(){
		var SUBWIN="reserveCarHistory.jsp?car_mng_id=<%=car_mng_id%>";
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}

	//견적상담후 예약해두기
	function reserveCar(){
		var fm = document.form1;
		var SUBWIN="reserveCar.jsp?from_page=<%=from_page%>&car_mng_id=<%=car_mng_id%>&user_id=<%=user_id%>&situation=<%=srBn.getSituation()%>&damdang_id=<%=srBn.getDamdang_id()%>&reg_dt=<%=srBn.getReg_dt()%>&ret_dt="+fm.ret_dt.value;
		window.open(SUBWIN, "reserveCar", "left=250, top=250, width=520, height=600, scrollbars=no, status=yes");
	}

	//예약메모수정하기
	function reserveCarM(seq, situation, memo, cust_nm, cust_tel, damdang_id){
		var fm = document.form1;
		var SUBWIN="reserveCarM.jsp?from_page=<%=from_page%>&user_id=<%=user_id%>&car_mng_id=<%=car_mng_id%>&seq="+seq+"&situation="+situation+"&memo="+memo+"&cust_nm="+cust_nm+"&cust_tel="+cust_tel+"&damdang_id="+damdang_id;
		window.open(SUBWIN, "reserveCar", "left=250, top=250, width=520, height=500, scrollbars=no, status=yes");
	}

	//예약취소하기
	function cancelCar(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("예약을 취소 하시겠습니까?"))	return;
		fm.action = "cancelCar.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//예약연장하기
	function reReserveCar(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("예약을 연장 하시겠습니까?"))	return;
		fm.action = "reReserveCar.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//예약 대차기간 보전하기
	function reReserveCar2(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("예약기간을 대차종료일예정일+3일로 보전 하시겠습니까?"))	return;
		fm.action = "reReserveCar2.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//계약확정으로 전환하기
	function reserveCar2Cng(car_mng_id, seq, situation, damdang_id, shres_reg_dt, shres_cust_nm, shres_cust_tel){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		fm.shres_cust_nm.value = shres_cust_nm;
		fm.shres_cust_tel.value = shres_cust_tel;
		if(!confirm("상담중에서 계약확정으로 전환 하시겠습니까?"))	return;
		fm.action = "reserveCar2cng.jsp";
		fm.target = "i_no";
		fm.submit();
	}

	//자동차등록정보 보기
	function view_car() {
		window.open("/acar/car_register/car_view.jsp?car_mng_id=<%=car_mng_id%>&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}

	//차종내역 보기
	function view_car_nm(car_id, car_seq) {
		window.open("/acar/car_mst/car_mst_u.jsp?car_id="+car_id+"&car_seq="+car_seq, "VIEW_CAR_NM", "left=100, top=100, width=875, height=675, scrollbars=yes");
	}

	//중고차가격 계산하기-숨어서
	function getSecondhandCarAmt_h() {
		var fm = document.form1;
		fm.mode.value = 'account';
		fm.action = "getSecondhandBaseSet.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//중고차가격 계산하기
	function getSecondhandCarAmt(){
		var fm = document.form1;
		window.open("getSecondhandBaseSet.jsp?car_mng_id=<%=car_mng_id%>&est_st=<%=est_st%>&fee_opt_amt=<%=fee_opt_amt%>&rent_st=1&mode=view", "VIEW_SH_CAR_AMT", "left=100, top=100, width=900, height=800, scrollbars=yes");
	}

	//견적
	function EstiMate(st, value, nm, a_a, rent_way, a_b, target,agree_dist){
		var fm = document.form1;

		<%if(jg_code.equals("")){%>
		alert('차종코드가 없습니다.\n\n견적이 안됩니다.');
		return;
		<%}%>
		
		if(st != '1' && a_a == '1' && a_b < 12){
			alert('리스는 최소개월수 12개월입니다.');
			return;
		}
		
		if((st == '2' || st == '3') && rent_way == '2' && a_a == '2' && Number(a_b) < 12){
			alert('※ 재렌트 대여기간 12개월 미만은 일반식(정비포함) 상품만 가능합니다.\n 기본식(정비미포함) 상품은 12개월 이상부터 가능합니다.');
			return;
		}  
		
		if (fm.br_to_st.value == "") {
			alert("고객주소지(차량인도지역)를 선택 해주세요.");
			return;
		} else {			
			if (fm.br_to_st.value == "" || fm.br_to_st.value == "5") {
				fm.br_to.value = "0";
			} else {
				fm.br_to.value = fm.br_to_st.value;
			}
		}
		
		<%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
		//개인사업자일때 선택으로 되어있으면 가입 또는 미가입으로 선택하도록 수정
		var doc_type_value = $('select[name="doc_type"] option:selected').val();
		if (doc_type_value == "2") {
    	    if (fm.com_emp_yn.value == "") {
    	    	alert("임직원 한정운전특약 가입 여부를 선택해주세요.\n\n성실신고확인대상자, 전문직업종 개인사업자는 2021년1월1일 이후부터 업무전용자동차보험에 가입하여야 합니다. 단, 사업자별 1대는 업무전용자동차보험 가입대상에서 제외, 1대를 제외한 나머지 차량 업무전용자동차보험 미가입 시 비용의 50%만 인정됩니다.\n\n자세한 내용은 홈페이지 하단 [손비처리 기준]을 참고해주세요.");
    			return;
    	  	}
        }
		<%}%>

		if(fm.apply_secondhand_price.value == '' || fm.apply_secondhand_price.value == '0'){
			alert('재리스기준차가가 계산되지 않았습니다.\n\n전산팀 정현미차장에게 문의하십시오.');
			return;
		}

		if(value == '리스불가' || value == '렌트불가'){ alert(value); return; }
		
		//수입차 출고전대차
		<%if(AddUtil.parseInt(car_comp_id) > 5){%>
			if(st == '1'){
				if(!confirm("수입차량을 출고전 대차 차량으로 제공하려는 경우 영업팀장님 사전승인을 맡아야 합니다.\n\n사전승인을 맡으셨습니까?"))	return;
			}
		<%}%>

		fm.esti_nm.value 	= nm;
		fm.a_a.value 		= a_a+""+rent_way;
		fm.a_b.value 		= a_b;
		fm.st.value 		= st;
		fm.agree_dist.value 		= agree_dist;

		fm.pp_st.value 	= '2';
		fm.rg_8.value 	= '25'; //20->30(20081216)->25(20090117)


		if(st == 'all'){
			fm.pp_st.value 	= '2';
			fm.rg_8.value 	= '25'; //20->30(20081216)->25(20090117)
		}else{
			//주행거리 입력기간 체크
			if('<%=serv_dt%>' != ''){
				var serv_mon = <%= carOld3.get("YEAR") %>*12+<%= carOld3.get("MONTH") %>;
				if(serv_mon >6){
					if(!confirm("주행거리 최종 입력일로부터 "+serv_mon+"개월이 경과하였습니다.\n\n현재 예상주행거리로 견적을 할경우 부정확한 결과가 예상됩니다.\n\n견적하시겠습니까?"))	return;
				}
				if(st == '2' || st == '3' || st == '4'){
					var serv_days = (<%= carOld3.get("YEAR") %>*365)+(<%= carOld3.get("MONTH") %>*30)+<%= carOld3.get("DAY") %>;
					if(serv_days >7){
						if(!confirm("주행거리확인일자로부터 7일이상("+serv_days+"일) 경과하였습니다. \n\n현재 주행거리로 견적을 할경우 부정확한 결과가 예상됩니다. \n\n실 주행거리를 확인후 재리스 견적내기 내에 있는 부정기 등록에 실주행거리를 등록하고 견적하세요.\n\n실주행거리 등록전 이라도 견적하시겠습니까?"))	return;
					}
				}
				
			}
		}

		fm.target = target;
		fm.action = 'esti_mng_i_20090901.jsp';
		fm.submit();
	}

	//월렌트 견적
	function EstiMateRm(st, value, nm, a_a, rent_way, a_b, days, target){
		var fm = document.form1;

		<%if(jg_code.equals("")){%>
		alert('차종코드가 없습니다.\n\n견적이 안됩니다.');
		return;
		<%}%>		

		if(value == '리스불가' || value == '렌트불가'){ alert(value); return; }

		fm.esti_nm.value 	= nm;
		fm.a_a.value 		  = a_a+""+rent_way;
		fm.a_b.value 		  = a_b;
		fm.st.value 		  = st;
		fm.months.value		= a_b;
		fm.days.value 		= days;

		//할인율
		var amt_per = 0;
		if(toInt(fm.months.value)==1){
			amt_per 	= (4 / 100) * toInt(fm.days.value) / 30;
		}
		if(toInt(fm.months.value)==2){
			amt_per 	= (4 / 100) + ((2 / 100)*toInt(fm.days.value) / 30);
		}
		if(toInt(fm.months.value) > 2){
			amt_per 	= 6 / 100;
		}
		amt_per 			= parseDecimal(amt_per * 1000) / 1000;
		fm.per_rm.value	= amt_per;

		//적용월대여료
		fm.tot_rm.value 	= <%=hp2.get("RM1")%> * (1-amt_per);
		fm.tot_rm.value 	= hun_th_rnd(toInt(fm.tot_rm.value));
		
		//산출대여료
		fm.tot_rm1.value 	= ( toInt(fm.tot_rm.value)*toInt(fm.months.value) ) + ( toInt(fm.tot_rm.value) / 30 * toInt(fm.days.value) );
		fm.tot_rm1.value 	= hun_th_rnd(toInt(fm.tot_rm1.value));

		//주행거리 입력기간 체크
		<%if(!serv_dt.equals("")){%>
			var serv_mon = <%= carOld3.get("YEAR") %>*12+<%= carOld3.get("MONTH") %>;
			if(serv_mon >6){
				if(!confirm("주행거리 최종 입력일로부터 "+serv_mon+"개월이 경과하였습니다.\n\n현재 예상주행거리로 견적을 할경우 부정확한 결과가 예상됩니다.\n\n견적하시겠습니까?"))	return;
			}
		<%}%>

		fm.target = target;
		fm.action = 'esti_mng_i_20120614_rm_a.jsp';
		fm.submit();
	}

	//전체견적
	function show_all(){
		var fm = document.form1;

		<%if(jg_code.equals("")){%>
		alert('차종코드가 없습니다.\n\n견적이 안됩니다.');
		return;
		<%}%>
		
		/* if (fm.br_to_st.value == "") {
			alert("고객주소지(차량인도지역)를 선택 해주세요.");
			return;
		} else {			
			if (fm.br_to_st.value == "" || fm.br_to_st.value == "5") {
				fm.br_to.value = "0";
			}
		} */
		if (fm.br_to_st.value == "") {
			fm.br_to.value = fm.br_from.value;
		} else if (fm.br_to_st.value == "5") {
			fm.br_to.value = "0";
		}
		
		fm.target = 'i_no';
		fm.action = "sp_esti_reg_sh.jsp";
		fm.submit();
	}

	//전체견적보기
	function estimates_view(reg_code, car_mng_id) {
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?est_code="+reg_code+"&car_mng_id="+car_mng_id+"&esti_table=estimate_sh";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}

	//전체견적보기
	function estimates_view_rm(reg_code, car_mng_id) {
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901_rm.jsp?est_code="+reg_code+"&car_mng_id="+car_mng_id+"&esti_table=estimate_sh";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}

	//견적서인쇄
	function EstiPrint(a_a, rent_way, a_b, amt, est_id) {
		var check = confirm_serv_mon('2');
		
 		if (check == true) {
			var fm = document.form1;			
			if (fm.br_to_st.value == "") {
				alert("고객주소지(차량인도지역)를 선택 해주세요.");
				return;
			} else {			
				if (fm.br_to_st.value == "" || fm.br_to_st.value == "5") {
					fm.br_to.value = "0";
				}
			}
			var br_to = fm.br_to.value;
			var br_from = fm.br_from.value;
			var SUBWIN="/acar/secondhand_hp/estimate.jsp?from_page=secondhand_hp&car_mng_id=<%= car_mng_id %>&today_dist=<%=hp.get("REAL_KM")%>&o_1=<%=hp.get("APPLY_SH_PR")%>&rent_dt=<%=hp.get("UPLOAD_DT")%>&est_code=<%=hp.get("REG_CODE")%>&a_a="+a_a+""+rent_way+"&a_b="+a_b+"&amt="+amt+"&est_id="+est_id+"&br_from="+br_from+"&br_to="+br_to;
			window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes");
 		}	
	}

	function EstiPrintRm(a_a, rent_way, a_b, amt, est_id) {
		var fm = document.form1;
		var SUBWIN="/acar/secondhand_hp/estimate_rm_new.jsp?from_page=secondhand_hp&car_mng_id=<%= car_mng_id %>&today_dist=<%=hp2.get("REAL_KM")%>&o_1=<%=hp2.get("APPLY_SH_PR")%>&rent_dt=<%=hp2.get("UPLOAD_DT")%>&est_code=<%=hp2.get("REG_CODE")%>&a_a="+a_a+""+rent_way+"&a_b="+a_b+"&amt="+amt+"&est_id="+est_id;
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes");
	}

	//차종내역 보기
	function view_car_service(car_id) {
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=car_mng_id%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");
	}

	//동일차량견적이력
	function EstiHistory() {
		var fm = document.form1;
		window.open("about:blank", "ESTI_HISTORY", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");
		fm.target = 'ESTI_HISTORY';
		fm.action = '/acar/rent_mng/rm_esti_history.jsp';
		fm.submit();
	}

	//견적 기존고객찾기
	function search_cust() {
		var fm = document.form1;
		var SUBWIN="/acar/estimate_mng/search_cust_list.jsp?from_page=/acar/secondhand/secondhand_price_20090901.jsp&t_wd="+fm.cust_nm.value;
		window.open(SUBWIN, "SubCust", "left=10, top=10, width=1250, height=800, scrollbars=yes, status=yes");
	}

	//특별할인
	function reg_spe_dc() {
		var fm = document.form1;
		var SUBWIN="reg_spe_dc.jsp?user_id=<%=user_id%>&car_mng_id=<%=car_mng_id%>";
		window.open(SUBWIN, "RegSpeDc", "left=250, top=250, width=420, height=200, scrollbars=no, status=no");
	}

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
	//법인임직원전용보험 가입여부
	function SetComEmpYn() {
		var fm = document.form1;
		
		<%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
		
		var doc_type_value = $('select[name="doc_type"] option:selected').val();
		var com_emp_yn_html = "";
		
		if (doc_type_value == "1") {
			com_emp_yn_html = "<option value='N'>미가입</option>"+
										"<option value='Y' selected>가입</option>";
					
			$("#com_emp_yn").html(com_emp_yn_html);
			
		} else if (doc_type_value == "2") {
			com_emp_yn_html = "<option value='' selected>선택</option>"+
										"<option value='N'>미가입</option>"+
										"<option value='Y'>가입</option>";
										
			$("#com_emp_yn").html(com_emp_yn_html);
		} else {
			com_emp_yn_html = "<option value='N' selected>미가입</option>"+
										"<option value='Y'>가입</option>";
						
			$("#com_emp_yn").html(com_emp_yn_html);
		}
		
		if (fm.doc_type.value == "1") {
			fm.com_emp_yn.value = "Y";
		} else if (fm.doc_type.value == "2") {
			fm.com_emp_yn.value = "";
		} else {
			fm.com_emp_yn.value = "N";
		}
		<%}%>
	}

	//기본사양보여주기
	function opt() {  
		var fm = document.form1;
		var SUBWIN="/acar/main_car_hp/opt.jsp?car_id=<%=car_id%>&car_seq=<%=car_seq%>&from_page=<%=from_page%>";	
		window.open(SUBWIN, "OPT", "left=10, top=10, width=798, height=550, scrollbars=yes, status=yes, resizable=no");
	}
	
	//견적 4건 한장으로 보기(20180725)
	function go_esti_more() {
		var check = confirm_serv_mon('2');
		
 		if (check == true) {
	        var fm = document.form1 ;
	        
			if (fm.br_to_st.value == "") {
				alert("고객주소지(차량인도지역)를 선택 해주세요.");
				return;
			} else {			
				if (fm.br_to_st.value == "" || fm.br_to_st.value == "5") {
					fm.br_to.value = "0";
				}
			}
			window.open("", "esti_4_sh", "left=10, top=10, width=800, height=900, scrollbars=yes, status=yes, resizable=yes");
			
	        fm.target = "esti_4_sh" ;
	        fm.action = "/acar/secondhand_hp/estimate_comp_fms_sh.jsp";
	        fm.submit() ;
		}
	}
	
	//체크박스 체크시 배경색 바꾸기/견적 파라미터 세팅(20180725)
	function change_td_col(num,val){
		var chk_cnt = $("input[name='go_esti_4']:checked").length;
		
		if($("#cb"+num).is(":checked")==true){	//체크인 경우
			
			//이전 체크해제한 내역이 있는지 체크 
			if($("#cb_chk_off1").val()=="Y"){	//체크해제한 내역이 첫번째 선택값 이었으면
				chk_cnt=1;						//다시 체크해도 첫번째 선택으로 취급
				$("#cb_chk_off1").val("");		//체크해제 내역은 삭제처리
			}else if($("#cb_chk_off2").val()=="Y"){	//두번째
				chk_cnt=2;
				$("#cb_chk_off2").val("");
			}else if($("#cb_chk_off3").val()=="Y"){	//세번째
				chk_cnt=3;
				$("#cb_chk_off3").val("");
			}else if($("#cb_chk_off4").val()=="Y"){	//네번째
				chk_cnt=4;
				$("#cb_chk_off4").val("");
			}
		
			//이전 체크해제한 내역이 없으면 바로 여기서 시작(순서대로 색, 파라미터 세팅)		
			if(chk_cnt==1){
				$("#cb"+num).parents("td").addClass('col_1');
				$("#param1").val(val);
			}else if(chk_cnt==2){
				$("#cb"+num).parents("td").addClass('col_2');
				$("#param2").val(val);
			}else if(chk_cnt==3){
				$("#cb"+num).parents("td").addClass('col_3');
				$("#param3").val(val);
			}else if(chk_cnt==4){
				$("#cb"+num).parents("td").addClass('col_4');
				$("#param4").val(val);
			}else{
				alert("견적 선택은 총 4건 까지만 가능합니다.");
				$("#cb"+num).prop("checked",false);
				return false;
			}
			
		}else{	//체크해제인 경우
			
			for(var i=1;i<=4;i++) {
				if($("#param"+i).val()==val){	//지금 체크해제하려는값과 넘길 파라미터값을 비교
					$("#param"+i).val("");		//넘길 파라미터에서 삭제				
					if($("#cb"+num).parents("td").hasClass('col_'+i)){	
						$("#cb_chk_off"+i).val("Y");	//몇번째로 선택한 값을 체크해제했는지 저장
						$("#cb"+num).parents("td").removeClass('col_'+i);	//색 제거
					}
				}
			}
		}
	}
	
	//체크박스 체크 초기화(20180725)
	function reset_checkBox() {
		for(var i=1;i<=4;i++){
			$("#param"+i).val("");
			$("#cb_chk_off"+i).val("");
			$(".cb").parents("td").removeClass('col_'+i);
		}
		$("input[name='go_esti_4']:checked").each(function(){
			$(this).prop("checked",false);
		});
	}
	
	//주행거리확인일자 경과시 확인
	function confirm_serv_mon(st){
		var result = true;
		if(st == 'all'){
			fm.pp_st.value 	= '2';
			fm.rg_8.value 	= '25'; //20->30(20081216)->25(20090117)
		}else{
			//주행거리 입력기간 체크
			if('<%=serv_dt%>' != ''){
				var serv_mon = <%= carOld3.get("YEAR") %>*12+<%= carOld3.get("MONTH") %>;
				if(serv_mon >6){
					if(!confirm("주행거리 최종 입력일로부터 "+serv_mon+"개월이 경과하였습니다.\n\n현재 예상주행거리로 견적을 할경우 부정확한 결과가 예상됩니다.\n\n견적하시겠습니까?"))	result = false;
				}
				if(st == '2' || st == '3' || st == '4'){
					var serv_days = (<%= carOld3.get("YEAR") %>*365)+(<%= carOld3.get("MONTH") %>*30)+<%= carOld3.get("DAY") %>;
					if(serv_days >7){
						if(!confirm("주행거리확인일자로부터 7일이상("+serv_days+"일) 경과하였습니다. \n\n현재 주행거리로 견적을 할경우 부정확한 결과가 예상됩니다. \n\n실 주행거리를 확인후 재리스 견적내기 내에 있는 부정기 등록에 실주행거리를 등록하고 견적하세요.\n\n실주행거리 등록전 이라도 견적하시겠습니까?"))	result = false;
					}
				}
			}
		}
		return result;
	}
	
	//고객주소지선택에 따른 실제값 변경 및 금액변경
	function changeBrTo(str) {
		
		var fm = document.form1;
		
		if (str == "" || str == "5") {
			fm.br_to.value = fm.br_from.value;
		} else {
			fm.br_to.value = str;
		}
		
		var url = "auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>";		
			url = url + "&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&jg_code=<%=jg_code%>";		
			url = url + "&est_st=<%=est_st%>&fee_opt_amt=<%=fee_opt_amt%>&fee_rent_st=<%=fee_rent_st%>&est_id=<%=est_id%>&spe_seq=<%=spe_seq%>&est_table=<%=est_table%>&list_from_page=<%=list_from_page%>&br_to_st="+str;
			
		//fm.target = 'detail_body';
        //fm.action = "./secondhand_price_20090901.jsp";
        //fm.submit() ;
		parent.detail_body.location.href = "secondhand_price_20090901.jsp?"+url;
	}
	
	//불량고객 
	function view_badcust()
	{
		var fm = document.form1;
	    if (fm.cust_nm.value == '') {
	    	alert('상호 또는 성명을 입력하십시오');
	    	fm.cust.focus();
	    	return;
	    }	
		window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_atype_i.jsp&est_nm='+fm.cust_nm.value+'&est_tel='+fm.cust_tel.value+'&est_mail='+fm.cust_email.value+'&est_fax='+fm.cust_fax.value, "BADCUST", "left=10, top=10, width=1400, height=900, resizable=yes, scrollbars=yes, status=yes");
		return;
	}	    	
	
	
//-->
</script>
</head>

<body>
<form name="form1" action="" method="POST" >
<input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
<input type="hidden" name="br_id" 		value="<%=br_id%>">
<input type="hidden" name="user_id" 		value="<%=user_id%>">
<input type="hidden" name="car_mng_id" 		value="<%=car_mng_id%>">
<input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type="hidden" name="a_e" 		value="<%=s_st%>">
<input type="hidden" name="car_no" 		value="<%=car_no%>">
<input type="hidden" name="init_reg_dt" 	value="<%=init_reg_dt%>">
<input type="hidden" name="before_one_year" 	value="<%=before_one_year%>">
<input type="hidden" name="real_km" 		value="<%=today_dist%>">
<input type="hidden" name="today_dist" 		value="<%=today_dist%>">
<input type="hidden" name="lpg_yn"	 	value="<%=lpg_yn%>">
<input type='hidden' name="est_st"		value="<%=est_st%>">
<input type='hidden' name="fee_opt_amt"		value="<%=fee_opt_amt%>">
<input type='hidden' name="fee_rent_st"		value="<%=fee_rent_st%>">
<input type='hidden' name="jg_code"		value="<%=jg_code%>">
<input type="hidden" name="reg_code"		value="<%=hp.get("REG_CODE")%>" id="reg_code">
<input type="hidden" name="upload_dt"		value="<%=hp.get("UPLOAD_DT")%>">
<input type="hidden" name="mode" 		value="">
<input type="hidden" name="st"	 		value="">
<input type="hidden" name="car_old_exp" 	value="">
<input type="hidden" name="apply_sh_pr" 	value="">
<input type="hidden" name="seq" 		value="">
<input type="hidden" name="compute" 		value="N">
<input type="hidden" name="detail" 		value="N">
<input type="hidden" name="car_name" value="<%=car_name%>" id="car_name">
<!--변동변수-->
<input type="hidden" name="esti_nm"		value="">
<input type="hidden" name="a_a"			value="">
<input type="hidden" name="a_b"			value="">
<input type="hidden" name="pp_st"		value="">
<input type="hidden" name="rg_8"		value="">
<!--고정변수-->
<input type="hidden" name="rent_st"		value="1"><!--보유차재리스-->
<input type="hidden" name="spr_yn" 		value="1">
<input type="hidden" name="lpg_yn" 		value="0">
<input type="hidden" name="lpg_kit" 		value="">
<input type="hidden" name="a_h" 		value="1">
<input type="hidden" name="ins_dj" 		value="2">
<input type="hidden" name="ins_age" 		value="1">
<input type="hidden" name="ins_good" 		value="0">
<input type="hidden" name="gi_yn" 		value="0">
<input type="hidden" name="car_ja" 		value="300000">
<!--<input type="hidden" name="from_page" 		value="secondhand">-->
<input type="hidden" name="rent_dt" 		value="<%=AddUtil.getDate()%>">

<input type="hidden" name="situation" 		value="<%//=srBn.getSituation()%>">
<input type="hidden" name="damdang_id" 		value="<%//=srBn.getDamdang_id()%>">
<input type="hidden" name="shres_reg_dt" 	value="<%//=srBn.getReg_dt()%>">
<input type="hidden" name="shres_seq" 		value="">
<input type="hidden" name="shres_cust_nm" 		value="">
<input type="hidden" name="shres_cust_tel" 		value="">

<input type="hidden" name="est_id" 		value="<%=est_id%>">
<input type='hidden' name="spe_seq"		value="<%=spe_seq%>">
<input type='hidden' name="est_table"		value="<%=est_table%>">
<input type='hidden' name="from_page"		value="<%=from_page%>">
<input type='hidden' name="list_from_page" 	value="<%=list_from_page%>">
<input type='hidden' name="jg_w" 		value="<%=ej_bean.getJg_w()%>">
<!--월렌트-->
<input type="hidden" name="tot_rm"		value="">
<input type="hidden" name="tot_rm1"		value="">
<input type="hidden" name="per_rm"		value="">

<input type="hidden" name="agree_dist"	value="">

<input type="hidden" name="br_from"		value="<%=br_from%>">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
<%if(est_st.equals("")){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>예약상태</span>
            <%if(srh_size>0){%>
            &nbsp;&nbsp;<a href="javascript:view_sh_res_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a>&nbsp;(<%=srh_size%>건)
            <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="5%">순위</td>
                    <td class="title" width="10%">담당자</td>
                    <td class="title" width="10%">진행상황</td>
                    <td class="title" width="15%">예약기간</td>
                    <td class="title" width="35%">메모</td>
                    <td class="title" width="10%">등록일자</td>
                    <td class="title" width="15%">처리</td>
                </tr>
                <%	int sh_res_reg_chk = 0;
                    for(int i = 0 ; i < sr_size ; i++){
                        Hashtable sr_ht = (Hashtable)sr.elementAt(i);

                        //20160119 계약확정이후에도 예약할수 있다.
                        //if(String.valueOf(sr_ht.get("SITUATION")).equals("2")) sh_res_reg_chk = 1;
                %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>
                    <td align="center">
                    	<%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))				out.print("상담중");
                    			else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("계약확정");
                   				else if(String.valueOf(sr_ht.get("SITUATION")).equals("3"))		out.print("계약연동");
                    	%>
                    </td>
                    <td align="center">
                    	<%if(!String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>
                    	<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %>
                    	<%}%>
                    </td>
                    <td>&nbsp;
                    	<!--메모수정-->
                    	<%if(!String.valueOf(sr_ht.get("SITUATION")).equals("3") && !auth_rw.equals("1")){%><a href="javascript:reserveCarM('<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("MEMO")%>', '<%=sr_ht.get("CUST_NM")%>', '<%=sr_ht.get("CUST_TEL")%>', '<%=sr_ht.get("DAMDANG_ID")%>');" title='메모수정하기'><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>&nbsp;<%}%>
                    	<%=sr_ht.get("CUST_NM")%>&nbsp;<%=sr_ht.get("CUST_TEL")%>&nbsp;<%=sr_ht.get("MEMO")%>
                    </td>
                    <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %></td>
                    <td align="center">
                    	<%if(!String.valueOf(sr_ht.get("SITUATION")).equals("3") && !auth_rw.equals("1")){%>
                    	<%	if(user_id.equals(String.valueOf(sr_ht.get("DAMDANG_ID"))) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
                    	<%		if(i==0 && sh_res_reg_chk==0 && String.valueOf(sr_ht.get("SITUATION")).equals("0")){%>
                    	<!--상담을 계약확정을 전환-->
                    	<a href="javascript:reserveCar2Cng('<%=car_mng_id%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>', '<%=sr_ht.get("CUST_NM")%>', '<%=sr_ht.get("CUST_TEL")%>');" title='차량예약 계약확정하기'><img src=/acar/images/center/button_in_dec.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<%		}%>
                    	<!--1회연장-->
                    	<%		if((i==0 && String.valueOf(sr_ht.get("SITUATION")).equals("2") && AddUtil.parseInt(String.valueOf(sr_ht.get("ADD_CNT"))) == 0) || (i==0 && String.valueOf(sr_ht.get("SITUATION")).equals("0") && AddUtil.parseInt(String.valueOf(sr_ht.get("ADD_CNT_S"))) == 0)){%>
                    	<a href="javascript:reReserveCar('<%=car_mng_id%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='차량예약 연장하기'><img src=/acar/images/center/button_in_yj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<%		}%>
                    	<!--예약취소-->
                    	<a href="javascript:cancelCar('<%=car_mng_id%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='차량예약 취소하기'><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<!--배차 기간 보전-->
                    	<%		if(i==0 && nm_db.getWorkAuthUser("전산팀",user_id) && !use_st.equals("null") && !String.valueOf(reserv.get("RENT_ST")).equals("대기") && AddUtil.parseInt(String.valueOf(sr_ht.get("RES_END_DT"))) < AddUtil.parseInt(String.valueOf(reserv.get("RET_DT2"))) ){%>
                    	<a href="javascript:reReserveCar2('<%=car_mng_id%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=reserv.get("RET_DT2")%>');" title='차량예약 배차기간 보전하기'>보전</a>&nbsp;&nbsp;
                    	<%		}%>
                    	<%	}%>
                    	<%}%>
                    </td>
                </tr>
				        <%}%>
				        <%if(sr_size==0){%>
                <tr>
                    <td align="center" colspan="7">등록된 데이타가 없습니다.</td>
                </tr>
				        <%}%>
            </table>
	    </td>
    </tr>
	  <%if(sh_res_reg_chk == 0 && sr_size < 3){%>
    <tr>
        <td align="right">
            <a href="javascript:reserveCar();" title='차량예약하기'><img src=/acar/images/center/button_cryy.gif align=absmiddle border=0></a>
        </td>
    </tr>
	  <%}%>
    <tr>
        <td>* 계약확정인 경우에 2회까지 예약기간을 연장할수 있습니다. 예약 마지막날이 오늘을 포함하여 3일이 연장됩니다. 계약확정 예약기간은 대차일자를 포함합니다.</td>
    </tr>
    <tr>
        <td>* 1순위 예약이 자동취소 혹은 직접취소처리될 경우 다음순위에게 예약배정됩니다.</td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차현황</span></td>
    </tr>
    <!-- 배차 --->
	<%if(!use_st.equals("null")){%>
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">계약구분</td>
                    <% if (String.valueOf(reserv.get("RENT_ST")).equals("차량정비")) { %>
	                    <td width="34%">&nbsp;<a href="javascript:view_rentcont('<%=reserv.get("USE_ST")%>','<%=reserv.get("RENT_S_CD")%>');"><%=reserv.get("RENT_ST")%></a></td>
	                    <td class="title" width="16%">현위치</td>
						<td width="34%">&nbsp;			
							<%for(int i = 0 ; i < good_size ; i++){
								CodeBean good = goods[i];
								if(park.equals(good.getNm_cd()))%><%=good.getNm()%>
							<%}%>
						</td>
					<% } else { %>
						<td width="84%" colspan='3'>&nbsp;<a href="javascript:view_rentcont('<%=reserv.get("USE_ST")%>','<%=reserv.get("RENT_S_CD")%>');"><%=reserv.get("RENT_ST")%></a></td>	                    
					<% } %>
    		    </tr>
    		    <tr>
                    <td class="title" width="16%">대여기간</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_DT")))%>~<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT")))%>
					&nbsp;&nbsp;&nbsp;
					[등록] <%=AddUtil.ChangeDate2(String.valueOf(reserv.get("REG_DT")))%> <%=c_db.getNameById(String.valueOf(reserv.get("REG_ID")),"USER")%>
					</td>
					<td class="title" width="16%">사용자</td>
                    <td width="34%">&nbsp;<%=reserv.get("FIRM_NM")%>&nbsp;<%=reserv.get("CUST_NM")%></td>					
                </tr>
            </table>
	    </td>
    </tr>
    
    <%	if(String.valueOf(reserv.get("RENT_ST")).equals("업무대여")){%>
	<input type="hidden" name="ret_dt" 		value="">
	<%	}else{%>
	<input type="hidden" name="ret_dt" 		value="<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT2")))%>">
	<%	}%>
	
    <%}else{%>
    
    <%	if(cont_size2 > 0){%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title rowspan='2' width="4%">연번</td>
                    <td class=title rowspan='2' width="7%">구분</td>
                    <td class=title rowspan='2' width="4%">상태</td>
                    <td class=title colspan='2'>자동차</td>										
                    <td class=title rowspan='2' width="18%">대여기간</td>
                    <td class=title rowspan='2' width="24%">상호/성명</td>					
                    <td class=title rowspan='2' width="7%">담당자</td>					
                    <td class=title rowspan='2' width="10%">등록일자</td>
                </tr>
				<tr>
                    <td class=title width="10%">보유차</td>														
                    <td class=title width="10%">사유발생</td>																			
				</tr>			
                <%	int cont_idx = 0;
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs2 = (Hashtable)conts.elementAt(i);
    					if(String.valueOf(reservs2.get("USE_ST")).equals("예약")){
    						cont_idx++;	
    					%>
                <tr> 
                    <td align="center"><%=cont_idx%></td>
                    <td align="center"><%=reservs2.get("RENT_ST")%></td>
                    <td align="center"><%=reservs2.get("USE_ST")%></td>
                    <td align="center"><%=reservs2.get("CAR_NO")%></td>
                    <td align="center"><%=reservs2.get("D_CAR_NO")%></td>															
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs2.get("RENT_START_DT")))%>시<br> ~ <%=AddUtil.ChangeDate3(String.valueOf(reservs2.get("RENT_END_DT")))%>시</td>
                    <td align="center"><%=reservs2.get("FIRM_NM")%> <%=reservs2.get("CUST_NM")%></td>
                    <td align="center"><%=reservs2.get("BUS_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate3_2(String.valueOf(reservs2.get("REG_DT")))%></td>										
                </tr>
              	<%		}%>
              <%	}%>
            </table>
        </td>
    </tr>   
    <input type="hidden" name="ret_dt" 		value="">
    <%	}else{%>
	<input type="hidden" name="ret_dt" 		value="">
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">계약구분</td>
                    <td width="34%">&nbsp;대기</td>
                    <td class="title" width="16%">현위치</td>
                    <td width="34%">&nbsp;
						<%for(int i = 0 ; i < good_size ; i++){
							CodeBean good = goods[i];							
							if(park.equals(good.getNm_cd()))%><%= good.getNm()%>
						<%}%>
        			</td>
                </tr>
            </table>
	    </td>
    </tr>    
    <%	} %> 
    <!-- 예약 --->
	<%}%>
	<tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>재리스등록현황</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">재리스등록일자</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate2(secondhand_dt)%></td>
                    <td class="title" width="16%">경과기간</td>
                    <td width="34%">&nbsp;<%= carOld2.get("MONTH") %>개월<%= carOld2.get("DAY") %>일
        			</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>
	<%if(!cr_bean.getOff_ls().equals("0")){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매각정보</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">오프리스구분</td>
                    <td >&nbsp;
                        <%if(cr_bean.getOff_ls().equals("1")){%>[매각결정]<%}%>
                        <%if(cr_bean.getOff_ls().equals("2")){%>[소매]<%}%>
                        <%if(cr_bean.getOff_ls().equals("3")){%>[경매장출품]<%}%>
                        <%if(cr_bean.getOff_ls().equals("4")){%>[수의계약]<%}%>
                        <%if(cr_bean.getOff_ls().equals("5")){%>[경매장낙찰]<%}%>
                        <%if(cr_bean.getOff_ls().equals("6")){%>[매각완료]<%}%>
						<%if(cr_bean.getOff_ls().equals("3")){
								//경매정보
								Hashtable ht_apprsl 	= shDb.getCarApprsl(car_mng_id);%>
						:
							<%if(!String.valueOf(ht_apprsl.get("ACTN_DT")).equals("")){%>
							경매일자 - <%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("ACTN_DT")))%>,
							<%}else{%>
							평가일자 - <%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("APPRSL_DT")))%>,
							<%}%>
						출품경매장 - <%=ht_apprsl.get("FIRM_NM")%>
						<%}%>
					</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>
	<%}%>
<%}%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span>
           <!-- &nbsp;<span class="b"><a href="javascript:MM_openBrWindow('/acar/rent_prepare/car_rmst.jsp?c_id=<%=car_mng_id%>&car_no=<%=car_no%>&auth_rw=<%=auth_rw%>','CarRmSt','scrollbars=no,status=yes,resizable=yes,width=420,height=530,left=50, top=50')" title='차량상태 확인'>
           [차량상태]</a></span>
            --> 
           <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("재리스특별할인",user_id)){%>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:reg_spe_dc();">[
                     특별할인
            <%if(cr_bean.getSpe_dc_st().equals("Y")){%>
            &nbsp; 지정: <%=cr_bean.getSpe_dc_cau()%>, <%=cr_bean.getSpe_dc_per()%>%
            <%}%>
            ]</a>
            <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">최초등록일</td>
                    <td width="34%">&nbsp;<a href="javascript:view_car();"><%=AddUtil.ChangeDate2(init_reg_dt)%></a>&nbsp;(<%=car_y_form%>년형)</td>
                    <td class="title" width="16%">출고일자</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate2(dlv_dt)%>
					 (연료:
					    <%=c_db.getNameByIdCode("0039", "", cr_bean.getFuel_kd())%>					    
					 )</td>
                </tr>
                <tr>
                    <td class="title" width="16%">차령</td>
                    <td width="34%">&nbsp;<%= carOld.get("YEAR") %>년<%= carOld.get("MONTH") %>개월<%= carOld.get("DAY") %>일(기준일자:<%=AddUtil.getDate()%>)
					<%if(cr_bean.getCar_use().equals("1")){
							int car_end_d_day = c_db.getCar_D_day("car_end_dt", car_mng_id);
					%>
					<br>&nbsp;<b>차령만료일 : <%=cr_bean.getCar_end_dt()%> <%if(car_end_d_day <= 30){ %><font color=red>(D-day <%=car_end_d_day%>일)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_end_d_day%>일<%}} %></b>
					<%}%>
					</td>
                    <td class="title" width="16%">주행거리</td>
                    <td width="34%">&nbsp;최종입력:<%=AddUtil.parseDecimal(tot_dist)%>km, <%=AddUtil.ChangeDate2(serv_dt)%>
   	    			  &nbsp;&nbsp;
					  <span class="b"><a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="정비내역보기"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a></span>
					  &nbsp;&nbsp;
					  <a href="javascript:MM_openBrWindow('/acar/cus_reg/serv_reg.jsp?car_mng_id=<%= car_mng_id %>&cmd=b&from_page=/acar/secondhand/secondhand_price_20090901.jsp','popwin_serv_reg','scrollbars=yes,status=yes,resizable=yes,width=850,height=600,top=50,left=50')"><img src=/acar/images/center/button_reg_bjg.gif align=absmiddle border=0></a>&nbsp;
					  
					  
					</td>
                </tr>
    		    <tr>
        		    <td class='title'> 검사유효기간 </td>
        		    <%	
        		    	int car_maint_d_day = c_db.getCar_D_day("car_maint_dt", car_mng_id);
					%>
        		    <td>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%> <%if(car_maint_d_day <= 30){ %><font color=red>(D-day <%=car_maint_d_day%>일)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_maint_d_day%>일<%}} %></b></b></td>
                	<td class='title'>점검유효기간</td>
        		    <td>&nbsp;<b><%=cr_bean.getTest_st_dt()%>~<%=cr_bean.getTest_end_dt()%></b></td>
    		    </tr>
    		    <tr>
        		    <td class='title'> 사고수리비 </td>
        		    <td>&nbsp;1위 <%= AddUtil.parseDecimal(accid_serv_amt1) %>원, 2위 <%= AddUtil.parseDecimal(accid_serv_amt2) %>원 
        		    	<%if(!String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("") && !String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("null")){%>
        		    	(<b>자산양수차량</b>)
        		    	<%}%> 
        		    </td>
                	<td class='title'>색상및사양 잔가반영</td>
        		    <td>&nbsp;색상 : <%=jg_col_st%>, 잔가 : <%=jg_opt_st%>
        		    	<!-- &nbsp;&nbsp;&nbsp;&nbsp;TUIX/TUON 트림여부 : <%=jg_tuix_st%>, 옵션여부 : <%=jg_tuix_opt_st%> -->
        		    </td>
    		    </tr>
    		    <tr>
        		    <td class='title'> 첨단안전사양 </td>
        		    <td colspan='3'>&nbsp;<%if(lkas_yn.equals("Y")){%>차선이탈제어형 <%=lkas_yn%><%}%> <%if(ldws_yn.equals("Y")){%>차선이탈경고형 <%=ldws_yn%><%}%> <%if(aeb_yn.equals("Y")){%>긴급제동제어형 <%=aeb_yn%><%}%> <%if(fcw_yn.equals("Y")){%>긴급제동경고형 <%=fcw_yn%><%}%></td>
    		    </tr>    		    
            </table>
	    </td>
    </tr>
    <%if(!cr_bean.getDist_cng().equals("")){%>
    <tr>
		<td><font color=green><b>* <%=cr_bean.getDist_cng()%></b></font></td>
    </tr>
    <%}else{%>
    <tr></tr><tr></tr>
    <%}%>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">제조사</td>
                    <td width="68%">&nbsp;<%= c_db.getNameById(car_comp_id, "CAR_COM") %></td>
                    <td class="title" width="16%">금액</td>
                </tr>
                <tr>
                    <td class="title">차명</td>
                    <td>&nbsp;<a href="javascript:opt();" onMouseOver="window.status=''; return true"><%=car_name%></a>&nbsp;(<%=jg_code%>)</td>
                    <td align="center"><input type="text" name="car_amt" value="<%= AddUtil.parseDecimal(car_amt) %>" size="15" class="whitenum">원</td>
                </tr>
                <tr>
                    <td class="title">옵션</td>
                    <td>&nbsp;<a href="javascript:opt();" onMouseOver="window.status=''; return true"><%=opt%></a>
                    <%if(add_opt_amt>0){ %>(추가장착:<%=add_opt %> <%= AddUtil.parseDecimal(add_opt_amt) %>원)<%}%>
                    </td>
                    <td align="center"><input type="text" name="car_amt" value="<%= AddUtil.parseDecimal(opt_amt) %>" size="15" class="whitenum">원</td>
                </tr>
                <tr>
                    <td class="title">색상</td>
                    <td>&nbsp;<%=colo%></td>
                    <td align="center"><input type="text" name="car_amt" value="<%= AddUtil.parseDecimal(clr_amt) %>" size="15" class="whitenum">원</td>
                </tr>
                <!-- 신차 개소세 감면 추가(2017.10.13) -->
				<%
				if(jg_g_7.equals("1") || jg_g_7.equals("2") || jg_g_7.equals("3") || jg_g_7.equals("4")){
				%>                
                <tr>
                    <td class="title">신차 개소세 감면</td>
                    <td>&nbsp;</td>
                    <td align="center"><input type="text" name="car_amt" value="- <%= AddUtil.parseDecimal(tax_dc_amt) %>" size="15" class="whitenum">원</td>
                </tr>
				<%
				}
				%>
                
                <tr>
                    <td class="title">감가상각</td>
                    <td align="right"></td>
                    <td align="center">- <input type="text" name="depreciation" value="0" size="15" class="defaultnum">원</td>
                </tr>
                <tr>
                    <td class="title" colspan="2">재리스기준가격</td>
                    <td align="center"><input type="text" name="apply_secondhand_price" value="<%=AddUtil.parseDecimal(String.valueOf(hp.get("APPLY_SH_PR")))%>" size="15" class="defaultnum">원</td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>

    <tr></tr><tr></tr>
    <tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span>
             &nbsp;&nbsp;<a href="javascript:search_cust()" onMouseOver="window.status=''; return true" title="고객조회하기. 클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a>
             
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <font color=red>※ 불량고객 확인하기</font>
        	&nbsp;&nbsp;&nbsp;        	
        	<input type="button" class="button" id="bad_cust" value='고객확인' onclick="javascript:view_badcust();">
        	<input name="badcust_chk" type="text" class="text"  readonly value="" size="1">   
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">상호 또는 성명</td>
                    <td width="34%">&nbsp;<input type="text" name="cust_nm" value="<%=e_bean.getEst_nm()%>" size="40" class=default style='IME-MODE: active'></td>
                    <td class="title" width="16%">호칭 또는 담당자이름+호칭</td>
                    <td width="34%">&nbsp;<input type="text" name="mgr_nm" value="<%=e_bean.getMgr_nm()%>" size="40" class=default style='IME-MODE: active'></td>
                </tr>
                <tr>
                    <td class="title">사업자등록번호</td>
                    <td>&nbsp;<input type="text" name="cust_ssn" value="<%=e_bean.getEst_ssn()%>" size="40" class=default ></td>
                    <td class="title">이메일주소</td>
                    <td>&nbsp;<input type="text" name="cust_email" value="<%=e_bean.getEst_email()%>" size="40" class=default  style='IME-MODE: inactive'></td>
                </tr>
                <tr>
                    <td class="title" width="16%">전화번호</td>
                    <td width="34%">&nbsp;<input type="text" name="cust_tel" value="<%=e_bean.getEst_tel()%>" size="15" class=default ></td>
                    <td class="title" width="16%">FAX</td>
                    <td width="34%">&nbsp;<input type="text" name="cust_fax" value="<%=e_bean.getEst_fax()%>" size="15" class=default></td>
                </tr>
                <tr>
                    <td class="title">고객구분</td>
                    <td>&nbsp;<select name="doc_type" class=default <%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>onChange="javascript:SetComEmpYn()"<%}%>>
                            <option value=""  <%if(e_bean.getDoc_type().equals("")){%>selected<%}%>>선택</option>
                            <option value="1" <%if(e_bean.getDoc_type().equals("1")){%>selected<%}%>>법인고객</option>
                            <option value="2" <%if(e_bean.getDoc_type().equals("2")){%>selected<%}%>>개인사업자</option>
                            <option value="3" <%if(e_bean.getDoc_type().equals("3")){%>selected<%}%>>개인</option>
                          </select>
                          &nbsp;(고객구분에 따라 견적서에 필요서류를 표기합니다.) 
                    </td>
                    <td class="title" width="16%">담당자</td>
                    <td>
        			  &nbsp;<select name='damdang_id2' class=default>
                        <option value="">미지정</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);
        					%>
          			    <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
        			</td>
                </tr>                
                <%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
                <tr>
                    <td class="title">법인임직원전용보험</td>
                    <td colspan='3'>&nbsp;<select name="com_emp_yn" id="com_emp_yn" class=default>
                    	<%if(e_bean.getDoc_type().equals("2")){%>                    	
                            <option value="">선택</option>
                    	<%}%>
                            <option value="N">미가입</option>
                            <option value="Y">가입</option>
                          </select>                          
                    </td>
                </tr>
                <%}else{%>
                <input type="hidden" name="com_emp_yn"		value="N">
                <%}%>
            </table>
	    </td>
    </tr>
    <%if(nm_db.getWorkAuthUser("전산팀",user_id)||cr_bean.getSecondhand().equals("1") || from_page.equals("off_lease_sc.jsp")){%>
    <tr>
        <td>&nbsp;<font color="#999999">♣ 고객정보를 입력하고 기본이나 조정견적을 클릭하면, <!--영업지원-&gt;견적진행관리에 등록할 수 있습니다.-->견적서에 반영됩니다.</font></td>
    </tr>
    <tr>
        <td align="right">
		<%if(est_st.equals("")){%>

	    		<a href="javascript:EstiMate('1', '', '', '<%if(cr_bean.getCar_use().equals("1")){%>2<%}else{%>1<%}%>', '1', '1', '_blank','');" title='출고지연대차 견적하기'><img src=/acar/images/center/button_cgjdc.gif align=absmiddle border=0></a>&nbsp;&nbsp;


			<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("재리스특별할인",user_id)){%> 
			<a href="javascript:show_all();" title='전체견적하기'><img src=/acar/images/center/button_est_all.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			<%}%>

			<font color=red>[홈페이지 적용일자 : <%=hp.get("UPLOAD_DT")%>]</font>

		<%}else{ %>

			<%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
			<a href="javascript:EstiMate('1', '', '', '<%if(cr_bean.getCar_use().equals("1")){%>2<%}else{%>1<%}%>', '1', '1', '_blank','');" title='출고지연대차 견적하기'><img src=/acar/images/center/button_cgjdc.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			<%}%>

		<%}%>
		</td>
    </tr>
    <%}%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
        	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객주소지</span>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
   	    		<td class="title" width="16%">고객주소지(차량인도지역)</td>
    	    	<td width="34%">
    	    		&nbsp;
                   	<select name="br_to_st" class="default" style="width: 100px;" onchange="changeBrTo(this.value);">
	                    <option value="" selected>선택</option>
	                    <option value="0" <%if (br_to_st.equals("0")) {%>selected<%}%>>수도권</option>
	                    <option value="1" <%if (br_to_st.equals("1")) {%>selected<%}%>>대전/세종/충남/충북</option>
	                    <option value="2" <%if (br_to_st.equals("2")) {%>selected<%}%>>대구/경북</option>
	                    <option value="3" <%if (br_to_st.equals("3")) {%>selected<%}%>>광주/전남/전북</option>
	                    <option value="4" <%if (br_to_st.equals("4")) {%>selected<%}%>>부산/울산/경남</option>
	                    <option value="5" <%if (br_to_st.equals("5")) {%>selected<%}%>>강원</option>
					</select>
					<input type="hidden" name="br_to" value="<%=br_to%>">
    	    	</td>
   	    		<td class="title" width="16%">현위치</td>
    	    	<td width="34%">
    	    		&nbsp;
    	    		<%if (br_from.equals("0")) {%>서울<%} else if (br_from.equals("1")) {%>대전<%} else if (br_from.equals("2")) {%>대구<%} else if (br_from.equals("3")) {%>광주<%} else if (br_from.equals("4")) {%>부산<%}%>
    	    	</td>
    	    </table>
		</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%
    if (!from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp") && (cr_bean.getSecondhand().equals("1") || from_page.equals("off_lease_sc.jsp") || from_page.equals("/fms2/lc_rent/lc_s_frame.jsp") || from_page.equals("/fms2/lc_rent/lc_rm_frame.jsp") || nm_db.getWorkAuthUser("전산팀", user_id))) {
   		
    	rb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RBMAX")), AddUtil.parseInt((String)hp.get("RBMAX_AG")), br_cons);
   		rs_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RSMAX")), AddUtil.parseInt((String)hp.get("RSMAX_AG")), br_cons);
   		lb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LBMAX")), AddUtil.parseInt((String)hp.get("LBMAX_AG")), br_cons);
   		ls_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LSMAX")), AddUtil.parseInt((String)hp.get("LSMAX_AG")), br_cons);
    %>
    <!--10000-->
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여기간별 월대여료
                    	<%if(!String.valueOf(hp_3d.get("REG_CODE")).equals("") && !String.valueOf(hp_3d.get("REG_CODE")).equals("null")){%>
                    	  (연간 약정운행거리 : <%=hp.get("AGREE_DIST")%>km)&nbsp;&nbsp;
                    	<%}%>
                    	</span>                    	
			                <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
			                  (<%=car_mng_id%>-<%=hp.get("REG_CODE")%>)
			                  ||<a href="javascript:estimates_view('<%=hp.get("REG_CODE")%>','<%=car_mng_id%>');" title='견적결과'>[견적결과]</a>
			                <%}%>
	                  </td>
                    <td align=right>
                    	견적서에 표기되는 순서 &nbsp;: &nbsp;
                    	<span style="color: #FFB2D9;size:20px;">■</span>&nbsp;-&nbsp;
                    	<span style="color: #FAED7D;size:20px;">■</span>&nbsp;-&nbsp;
                    	<span style="color: #86E57F;size:20px;">■</span>&nbsp;-&nbsp;
                    	<span style="color: #B2CCFF;size:20px;">■</span>&nbsp;&nbsp;
                    	<input type="hidden" name="param1" id="param1" value="">
                    	<input type="hidden" name="param2" id="param2" value="">
                    	<input type="hidden" name="param3" id="param3" value="">
                    	<input type="hidden" name="param4" id="param4" value="">
                    	<input type="button" class="button" value="견적서 한장으로 보기" onclick="javascript:go_esti_more();">
                    	<input type="button" class="button" value="선택 초기화" onclick="javascript:reset_checkBox();">
                    </td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td rowspan="2" width="8%" class="title">대여기간</td>
                    <td colspan="2" class="title">장기렌트</td>
                    <td colspan="2" class="title">리스플러스(오토리스)</td>
                </tr>
                <tr>
                    <td width="23%" class="title">기본식</td>
                    <td width="23%" class="title">일반식</td>
                    <td width="23%" class="title">기본식</td>
                    <td width="23%" class="title">일반식</td>
                </tr>
                <!--최대개월--> 
                <tr>
                    <td class="title">최대 <%=String.valueOf(hp.get("MAX_USE_MON"))%>개월</td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("RBMAX"))) > 0) {%>
       		            <%-- <a href="javascript:EstiPrint('2', '2', '<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '<%=String.valueOf(hp.get("RBMAX"))%>', '<%=hp.get("RBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RBMAX")))%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(rb_max)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                   		<input type="checkbox" class="cb" name="go_esti_4" id="cb1" value="22//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=String.valueOf(hp.get("RBMAX"))%>//<%=hp.get("RBMAX_ID")%>" onclick="javascript:change_td_col('1',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("RSMAX"))) > 0) {%>
       		            <%-- <a href="javascript:EstiPrint('2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RSMAX"))%>','<%=hp.get("RSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RSMAX")))%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(rs_max)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb2" value="21//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=String.valueOf(hp.get("RSMAX"))%>//<%=hp.get("RSMAX_ID")%>" onclick="javascript:change_td_col('2',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("LBMAX"))) > 0) {%>
       		            <%-- <a href="javascript:EstiPrint('1', '2', '<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '<%=String.valueOf(hp.get("LBMAX"))%>', '<%=hp.get("LBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LBMAX")))%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(lb_max)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb3" value="12//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=String.valueOf(hp.get("LBMAX"))%>//<%=hp.get("LBMAX_ID")%>" onclick="javascript:change_td_col('3',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("LSMAX"))) > 0) {%>
       		            <%-- <a href="javascript:EstiPrint('1', '1', '<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("LSMAX"))%>','<%=hp.get("LSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LSMAX")))%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(ls_max)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb4" value="11//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=String.valueOf(hp.get("LSMAX"))%>//<%=hp.get("LSMAX_ID")%>" onclick="javascript:change_td_col('4',this.value);">
                        <%} else {%>-<%}%>
    		    	</td>
                </tr>
                <!--최대개월부터 12개월이내 선택견적-->
                <tr>
                    <td class="title">선택
                        <select name="s_a_b">
                        <%for (int i = AddUtil.parseInt(String.valueOf(hp.get("MAX_USE_MON")))-1; i > 6; i--) {
                        	if (i == 36) continue;
                        	if (i == 24) continue;
                        	if (i == 12) continue;
                        	if (i == 6) continue;
                        %>
                        	<option value="<%=i%>"><%=i%></option>
                        <%}%>
                        </select>개월
                    </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("RB36")))+AddUtil.parseInt(String.valueOf(hp.get("RB24")))+AddUtil.parseInt(String.valueOf(hp.get("RB12")))+AddUtil.parseInt(String.valueOf(hp.get("RB6"))) > 0) {%>
                        <input type="text" name="rbsel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
					</td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("RS36")))+AddUtil.parseInt(String.valueOf(hp.get("RS24")))+AddUtil.parseInt(String.valueOf(hp.get("RS12")))+AddUtil.parseInt(String.valueOf(hp.get("RS6"))) > 0) {%>
                        <input type="text" name="rssel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("LB36")))+AddUtil.parseInt(String.valueOf(hp.get("LB24")))+AddUtil.parseInt(String.valueOf(hp.get("LB12"))) > 0) {%>
                        <input type="text" name="lbsel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("LS36")))+AddUtil.parseInt(String.valueOf(hp.get("LS24")))+AddUtil.parseInt(String.valueOf(hp.get("LS12"))) > 0) {%>
                        <input type="text" name="lssel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%
    		  	for (int i = 0; i < 4; i++) {
  	  				if (i == 0) {
    					amt1 	= String.valueOf(hp.get("RB36"));			amt2 		= String.valueOf(hp.get("RS36"));  		amt3 		= String.valueOf(hp.get("LB36"));  		amt4 		= String.valueOf(hp.get("LS36"));
    					amt_id1 = String.valueOf(hp.get("RB36_ID"));	amt_id2 = String.valueOf(hp.get("RS36_ID"));  amt_id3 = String.valueOf(hp.get("LB36_ID"));  amt_id4 = String.valueOf(hp.get("LS36_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB36")), AddUtil.parseInt((String)hp.get("RB36_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS36")), AddUtil.parseInt((String)hp.get("RS36_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB36")), AddUtil.parseInt((String)hp.get("LB36_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS36")), AddUtil.parseInt((String)hp.get("LS36_AG")), br_cons);
    				} else if (i == 1) {
    					amt1 	= String.valueOf(hp.get("RB24"));			amt2 		= String.valueOf(hp.get("RS24"));  		amt3 		= String.valueOf(hp.get("LB24"));  		amt4 		= String.valueOf(hp.get("LS24"));
    					amt_id1 = String.valueOf(hp.get("RB24_ID"));	amt_id2 = String.valueOf(hp.get("RS24_ID"));  amt_id3 = String.valueOf(hp.get("LB24_ID"));  amt_id4 = String.valueOf(hp.get("LS24_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB24")), AddUtil.parseInt((String)hp.get("RB24_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS24")), AddUtil.parseInt((String)hp.get("RS24_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB24")), AddUtil.parseInt((String)hp.get("LB24_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS24")), AddUtil.parseInt((String)hp.get("LS24_AG")), br_cons);
    				} else if (i == 2) {
    					amt1 	= String.valueOf(hp.get("RB12"));			amt2 		= String.valueOf(hp.get("RS12"));  		amt3 		= String.valueOf(hp.get("LB12"));  		amt4 		= String.valueOf(hp.get("LS12"));
    					amt_id1 = String.valueOf(hp.get("RB12_ID"));	amt_id2 = String.valueOf(hp.get("RS12_ID"));  amt_id3 = String.valueOf(hp.get("LB12_ID"));  amt_id4 = String.valueOf(hp.get("LS12_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB12")), AddUtil.parseInt((String)hp.get("RB12_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS12")), AddUtil.parseInt((String)hp.get("RS12_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB12")), AddUtil.parseInt((String)hp.get("LB12_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS12")), AddUtil.parseInt((String)hp.get("LS12_AG")), br_cons);
	    			} else if (i == 3) {
  	  					amt1 	= String.valueOf(hp.get("RB6"));			amt2 		= String.valueOf(hp.get("RS6"));  		amt3 		= "0";  amt4 		= "0";
  	  					amt_id1 = String.valueOf(hp.get("RB6_ID"));		amt_id2 = String.valueOf(hp.get("RS6_ID"));  	amt_id3 = "";  	amt_id4 = "";
  	  					
	  	  				to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB6")), AddUtil.parseInt((String)hp.get("RB6_AG")), br_cons);
		  	  			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS6")), AddUtil.parseInt((String)hp.get("RS6_AG")), br_cons);			
		  	  			to_amt3 = "0";
		  	  			to_amt4 = "0";
    				}
    			%>
                <tr>
                    <td class="title" ><%=mon[i]%>개월</td>
                    <td align="center">
                   	<%if (nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업팀장", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057")) {%>
                        <%if (AddUtil.parseInt(amt1) > 0) {%>
	        		        <%-- <a href="javascript:EstiPrint('2', '2', '<%=mon[i]%>', '<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
	                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+2)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+2)+1%>',this.value);">
                        <%} else {%>-<%}%>
                   	<%} else {%>
                        <%if (AddUtil.parseInt(amt1) > 0) {%>
	                    	<%if (mon[i] >= 12) {%>
	        		        <%-- <a href="javascript:EstiPrint('2', '2', '<%=mon[i]%>', '<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
	                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+2)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+2)+1%>',this.value);">
	                    	<%} else {%>-<%}%>
                        <%} else {%>-<%}%>
                   	<%}%>
        	        </td>
                    <td  align="center">
                        <%if(AddUtil.parseInt(amt2)>0){%>
        		        <%-- <a href="javascript:EstiPrint('2', '1', '<%=mon[i]%>', '<%=to_amt2%>', '<%=amt_id2%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="rs<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt2)>0){%><%=AddUtil.parseDecimal(to_amt2)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>', '2', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>', '2', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>', '2', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+2)+2%>" value="21//<%=mon[i]%>//<%=to_amt2%>//<%=amt_id2%>" onclick="javascript:change_td_col('<%=4*(i+2)+2%>',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
   	          		<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt3)>0){%>
        		        <%-- <a href="javascript:EstiPrint('1', '2', '<%=mon[i]%>', '<%=to_amt3%>', '<%=amt_id3%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt3)>0){%><%=AddUtil.parseDecimal(to_amt3)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>', '1', '2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>', '1', '2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>', '1', '2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+2)+3%>" value="12//<%=mon[i]%>//<%=to_amt3%>//<%=amt_id3%>" onclick="javascript:change_td_col('<%=4*(i+2)+3%>',this.value);">
                        <%} else {%>-<%}%>
                    <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
        		    <%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt4)>0){%>
        		        <%-- <a href="javascript:EstiPrint('1', '1', '<%=mon[i]%>', '<%=to_amt4%>', '<%=amt_id4%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="ls<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt4)>0){%><%=AddUtil.parseDecimal(to_amt4)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>', '1', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>', '1', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>', '1', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+2)+4%>" value="11//<%=mon[i]%>//<%=to_amt4%>//<%=amt_id4%>" onclick="javascript:change_td_col('<%=4*(i+2)+4%>',this.value);">
                        <%} else {%>-<%}%>
        		    <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%}%>
    		</table>
	    </td>
    </tr>    
    
    <!--20000-->
    <%	
    if (!String.valueOf(hp_2d.get("REG_CODE")).equals("") && !String.valueOf(hp_2d.get("REG_CODE")).equals("null")) {
		hp = hp_2d;
		
		rb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RBMAX")), AddUtil.parseInt((String)hp.get("RBMAX_AG")), br_cons);
   		rs_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RSMAX")), AddUtil.parseInt((String)hp.get("RSMAX_AG")), br_cons);
   		lb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LBMAX")), AddUtil.parseInt((String)hp.get("LBMAX_AG")), br_cons);
   		ls_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LSMAX")), AddUtil.parseInt((String)hp.get("LSMAX_AG")), br_cons);
    %>
    <tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여기간별 월대여료
                    	  (연간 약정운행거리 : <%=hp.get("AGREE_DIST")%>km)&nbsp;&nbsp;
                    	</span>
			                <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
			                  (<%=car_mng_id%>-<%=hp.get("REG_CODE")%>)
			                  ||<a href="javascript:estimates_view('<%=hp.get("REG_CODE")%>','<%=car_mng_id%>');" title='견적결과'>[견적결과]</a>
			                <%}%>
	                  </td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td rowspan="2" width="8%" class="title">대여기간</td>
                    <td colspan="2" class="title">장기렌트</td>
                    <td colspan="2" class="title">리스플러스(오토리스)</td>
                </tr>
                <tr>
                    <td width="23%" class="title">기본식</td>
                    <td width="23%" class="title">일반식</td>
                    <td width="23%" class="title">기본식</td>
                    <td width="23%" class="title">일반식</td>
                </tr>

                <!--최대개월--> 
                <tr>
                    <td class="title">최대 <%=String.valueOf(hp.get("MAX_USE_MON"))%>개월</td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RBMAX"))%>','<%=hp.get("RBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RBMAX")))%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(rb_max)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb25" value="22//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rb_max%>//<%=hp.get("RBMAX_ID")%>" onclick="javascript:change_td_col('25',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=rs_max%>','<%=hp.get("RSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(rs_max)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb26" value="21//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rs_max%>//<%=hp.get("RSMAX_ID")%>" onclick="javascript:change_td_col('26',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=lb_max%>','<%=hp.get("LBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(lb_max)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb27" value="12//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=lb_max%>//<%=hp.get("LBMAX_ID")%>" onclick="javascript:change_td_col('27',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=ls_max%>','<%=hp.get("LSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(ls_max)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb28" value="11//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=ls_max%>//<%=hp.get("LSMAX_ID")%>" onclick="javascript:change_td_col('28',this.value);">
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
                <!--최대개월부터 12개월이내 선택견적-->
                <tr>
                    <td class="title">선택
                        <select name="s_a_b">
                        <%for(int i = AddUtil.parseInt(String.valueOf(hp.get("MAX_USE_MON")))-1 ; i > 6 ; i--){
                        	if(i == 36) continue;
                        	if(i == 24) continue;
                        	if(i == 12) continue;
                        	if(i == 6) continue;

                        %>
                        <option value="<%=i%>"><%=i%></option>
                        <%}%>
                        </select>개월
                    </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RB36")))+AddUtil.parseInt(String.valueOf(hp.get("RB24")))+AddUtil.parseInt(String.valueOf(hp.get("RB12")))+AddUtil.parseInt(String.valueOf(hp.get("RB6")))>0){%>
                        <input type="text" name="rbsel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RS36")))+AddUtil.parseInt(String.valueOf(hp.get("RS24")))+AddUtil.parseInt(String.valueOf(hp.get("RS12")))+AddUtil.parseInt(String.valueOf(hp.get("RS6")))>0){%>
                        <input type="text" name="rssel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LB36")))+AddUtil.parseInt(String.valueOf(hp.get("LB24")))+AddUtil.parseInt(String.valueOf(hp.get("LB12")))>0){%>
                        <input type="text" name="lbsel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LS36")))+AddUtil.parseInt(String.valueOf(hp.get("LS24")))+AddUtil.parseInt(String.valueOf(hp.get("LS12")))>0){%>
                        <input type="text" name="lssel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%
    		  	for (int i = 0; i < 4; i++) {
  	  				if (i == 0) {
    					amt1		= String.valueOf(hp.get("RB36"));			amt2 		= String.valueOf(hp.get("RS36"));  		amt3 		= String.valueOf(hp.get("LB36"));  		amt4 		= String.valueOf(hp.get("LS36"));
    					amt_id1 = String.valueOf(hp.get("RB36_ID"));	amt_id2 = String.valueOf(hp.get("RS36_ID"));  amt_id3 = String.valueOf(hp.get("LB36_ID"));  amt_id4 = String.valueOf(hp.get("LS36_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB36")), AddUtil.parseInt((String)hp.get("RB36_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS36")), AddUtil.parseInt((String)hp.get("RS36_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB36")), AddUtil.parseInt((String)hp.get("LB36_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS36")), AddUtil.parseInt((String)hp.get("LS36_AG")), br_cons);
    				} else if (i == 1) {
    					amt1		= String.valueOf(hp.get("RB24"));			amt2 		= String.valueOf(hp.get("RS24"));  		amt3 		= String.valueOf(hp.get("LB24"));  		amt4 		= String.valueOf(hp.get("LS24"));
    					amt_id1 = String.valueOf(hp.get("RB24_ID"));	amt_id2 = String.valueOf(hp.get("RS24_ID"));  amt_id3 = String.valueOf(hp.get("LB24_ID"));  amt_id4 = String.valueOf(hp.get("LS24_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB24")), AddUtil.parseInt((String)hp.get("RB24_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS24")), AddUtil.parseInt((String)hp.get("RS24_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB24")), AddUtil.parseInt((String)hp.get("LB24_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS24")), AddUtil.parseInt((String)hp.get("LS24_AG")), br_cons);
    				} else if (i == 2) {
    					amt1		= String.valueOf(hp.get("RB12"));			amt2 		= String.valueOf(hp.get("RS12"));  		amt3 		= String.valueOf(hp.get("LB12"));  		amt4 		= String.valueOf(hp.get("LS12"));
    					amt_id1 = String.valueOf(hp.get("RB12_ID"));	amt_id2 = String.valueOf(hp.get("RS12_ID"));  amt_id3 = String.valueOf(hp.get("LB12_ID"));  amt_id4 = String.valueOf(hp.get("LS12_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB12")), AddUtil.parseInt((String)hp.get("RB12_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS12")), AddUtil.parseInt((String)hp.get("RS12_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB12")), AddUtil.parseInt((String)hp.get("LB12_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS12")), AddUtil.parseInt((String)hp.get("LS12_AG")), br_cons);
	    			} else if (i == 3) {
  	  					amt1		= String.valueOf(hp.get("RB6"));			amt2 		= String.valueOf(hp.get("RS6"));  		amt3 		= "0";  amt4 		= "0";
  	  					amt_id1 = String.valueOf(hp.get("RB6_ID"));		amt_id2 = String.valueOf(hp.get("RS6_ID"));  	amt_id3 = "";  	amt_id4 = "";
  	  					
	  	  				to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB6")), AddUtil.parseInt((String)hp.get("RB6_AG")), br_cons);
		  	  			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS6")), AddUtil.parseInt((String)hp.get("RS6_AG")), br_cons);			
		  	  			to_amt3 = "0";
		  	  			to_amt4 = "0";
    				}
    			%>
                <tr>
                    <td class="title" ><%=mon[i]%>개월</td>
                    <td align="center">
                    <%if (nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업팀장", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057")) {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
	                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+7)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+7)+1%>',this.value);">
                        <%} else {%>-<%}%>
					<%} else {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
							<%if (mon[i] >= 12) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
	                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+7)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+7)+1%>',this.value);">
	                        <%} else {%>-<%}%>
						<%} else {%>-<%}%>
					<%}%>
        	        </td>
                    <td  align="center">
                        <%if(AddUtil.parseInt(amt2)>0){%>
        		        <%-- <a href="javascript:EstiPrint('2','1','<%=mon[i]%>','<%=to_amt2%>', '<%=amt_id2%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="rs<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt2)>0){%><%=AddUtil.parseDecimal(to_amt2)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+7)+2%>" value="21//<%=mon[i]%>//<%=to_amt2%>//<%=amt_id2%>" onclick="javascript:change_td_col('<%=4*(i+7)+2%>',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
   	          		<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt3)>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','2','<%=mon[i]%>','<%=to_amt3%>', '<%=amt_id3%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt3)>0){%><%=AddUtil.parseDecimal(to_amt3)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+7)+3%>" value="12//<%=mon[i]%>//<%=to_amt3%>//<%=amt_id3%>" onclick="javascript:change_td_col('<%=4*(i+7)+3%>',this.value);">
                        <%} else {%>-<%}%>
                    <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
	            	<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt4)>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=mon[i]%>','<%=to_amt4%>', '<%=amt_id4%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="ls<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt4)>0){%><%=AddUtil.parseDecimal(to_amt4)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+7)+4%>" value="11//<%=mon[i]%>//<%=to_amt4%>//<%=amt_id4%>" onclick="javascript:change_td_col('<%=4*(i+7)+4%>',this.value);">
                        <%} else {%>-<%}%>
   		            <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%}%>
    		</table>
	    </td>
    </tr>
    <%	}%>
    
    <!--30000-->
    <%	
    if (!String.valueOf(hp_3d.get("REG_CODE")).equals("") && !String.valueOf(hp_3d.get("REG_CODE")).equals("null")) {
    	hp = hp_3d;
    	
    	rb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RBMAX")), AddUtil.parseInt((String)hp.get("RBMAX_AG")), br_cons);
   		rs_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RSMAX")), AddUtil.parseInt((String)hp.get("RSMAX_AG")), br_cons);
   		lb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LBMAX")), AddUtil.parseInt((String)hp.get("LBMAX_AG")), br_cons);
   		ls_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LSMAX")), AddUtil.parseInt((String)hp.get("LSMAX_AG")), br_cons);
    %>
    <tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여기간별 월대여료
                    	  (연간 약정운행거리 : <%=hp.get("AGREE_DIST")%>km)&nbsp;&nbsp;
                    	</span>
			                <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
			                  (<%=car_mng_id%>-<%=hp.get("REG_CODE")%>)
			                  ||<a href="javascript:estimates_view('<%=hp.get("REG_CODE")%>','<%=car_mng_id%>');" title='견적결과'>[견적결과]</a>
			                <%}%>
	                </td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td rowspan="2" width="8%" class="title">대여기간</td>
                    <td colspan="2" class="title">장기렌트</td>
                    <td colspan="2" class="title">리스플러스(오토리스)</td>
                </tr>
                <tr>
                    <td width="23%" class="title">기본식</td>
                    <td width="23%" class="title">일반식</td>
                    <td width="23%" class="title">기본식</td>
                    <td width="23%" class="title">일반식</td>
                </tr>

                <!--최대개월--> 
                <tr>
                    <td class="title">최대 <%=String.valueOf(hp.get("MAX_USE_MON"))%>개월</td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RBMAX"))%>','<%=hp.get("RBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RBMAX")))%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(rb_max)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb49" value="22//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rb_max%>//<%=hp.get("RBMAX_ID")%>" onclick="javascript:change_td_col('49',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RSMAX"))%>','<%=hp.get("RSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RSMAX")))%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(rs_max)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb50" value="21//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rs_max%>//<%=hp.get("RSMAX_ID")%>" onclick="javascript:change_td_col('50',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("LBMAX"))%>','<%=hp.get("LBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LBMAX")))%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(lb_max)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb51" value="12//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=lb_max%>//<%=hp.get("LBMAX_ID")%>" onclick="javascript:change_td_col('51',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("LSMAX"))%>','<%=hp.get("LSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LSMAX")))%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(ls_max)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb52" value="11//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=ls_max%>//<%=hp.get("LSMAX_ID")%>" onclick="javascript:change_td_col('52',this.value);">
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
                <!--최대개월부터 12개월이내 선택견적-->
                <tr>
                    <td class="title">선택
                        <select name="s_a_b">
                        <%for(int i = AddUtil.parseInt(String.valueOf(hp.get("MAX_USE_MON")))-1 ; i > 6 ; i--){
                        	if(i == 36) continue;
                        	if(i == 24) continue;
                        	if(i == 12) continue;
                        	if(i == 6) continue;

                        %>
                        <option value="<%=i%>"><%=i%></option>
                        <%}%>
                        </select>개월
                    </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RB36")))+AddUtil.parseInt(String.valueOf(hp.get("RB24")))+AddUtil.parseInt(String.valueOf(hp.get("RB12")))+AddUtil.parseInt(String.valueOf(hp.get("RB6")))>0){%>
                        <input type="text" name="rbsel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RS36")))+AddUtil.parseInt(String.valueOf(hp.get("RS24")))+AddUtil.parseInt(String.valueOf(hp.get("RS12")))+AddUtil.parseInt(String.valueOf(hp.get("SB6")))>0){%>
                        <input type="text" name="rssel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LB36")))+AddUtil.parseInt(String.valueOf(hp.get("LB24")))+AddUtil.parseInt(String.valueOf(hp.get("LB12")))>0){%>
                        <input type="text" name="lbsel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LS36")))+AddUtil.parseInt(String.valueOf(hp.get("LS24")))+AddUtil.parseInt(String.valueOf(hp.get("LS12")))>0){%>
                        <input type="text" name="lssel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%
    		  	for (int i = 0; i < 4; i++) {
  	  				if (i == 0) {
    					amt1 	= String.valueOf(hp.get("RB36"));			amt2 		= String.valueOf(hp.get("RS36"));  		amt3 		= String.valueOf(hp.get("LB36"));  		amt4 		= String.valueOf(hp.get("LS36"));
    					amt_id1 = String.valueOf(hp.get("RB36_ID"));	amt_id2 = String.valueOf(hp.get("RS36_ID"));  amt_id3 = String.valueOf(hp.get("LB36_ID"));  amt_id4 = String.valueOf(hp.get("LS36_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB36")), AddUtil.parseInt((String)hp.get("RB36_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS36")), AddUtil.parseInt((String)hp.get("RS36_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB36")), AddUtil.parseInt((String)hp.get("LB36_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS36")), AddUtil.parseInt((String)hp.get("LS36_AG")), br_cons);
    				} else if (i == 1) {
    					amt1 	= String.valueOf(hp.get("RB24"));			amt2 		= String.valueOf(hp.get("RS24"));  		amt3 		= String.valueOf(hp.get("LB24"));  		amt4 		= String.valueOf(hp.get("LS24"));
    					amt_id1 = String.valueOf(hp.get("RB24_ID"));	amt_id2 = String.valueOf(hp.get("RS24_ID"));  amt_id3 = String.valueOf(hp.get("LB24_ID"));  amt_id4 = String.valueOf(hp.get("LS24_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB24")), AddUtil.parseInt((String)hp.get("RB24_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS24")), AddUtil.parseInt((String)hp.get("RS24_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB24")), AddUtil.parseInt((String)hp.get("LB24_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS24")), AddUtil.parseInt((String)hp.get("LS24_AG")), br_cons);
    				} else if (i == 2) {
    					amt1 	= String.valueOf(hp.get("RB12"));			amt2 		= String.valueOf(hp.get("RS12"));  		amt3 		= String.valueOf(hp.get("LB12"));  		amt4 		= String.valueOf(hp.get("LS12"));
    					amt_id1 = String.valueOf(hp.get("RB12_ID"));	amt_id2 = String.valueOf(hp.get("RS12_ID"));  amt_id3 = String.valueOf(hp.get("LB12_ID"));  amt_id4 = String.valueOf(hp.get("LS12_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB12")), AddUtil.parseInt((String)hp.get("RB12_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS12")), AddUtil.parseInt((String)hp.get("RS12_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB12")), AddUtil.parseInt((String)hp.get("LB12_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS12")), AddUtil.parseInt((String)hp.get("LS12_AG")), br_cons);
	    			} else if (i == 3) {
  	  					amt1 	= String.valueOf(hp.get("RB6"));			amt2 		= String.valueOf(hp.get("RS6"));  		amt3 		= "0";  amt4 		= "0";
  	  					amt_id1 = String.valueOf(hp.get("RB6_ID"));		amt_id2 = String.valueOf(hp.get("RS6_ID"));  	amt_id3 = "";  	amt_id4 = "";
  	  					
	  	  				to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB6")), AddUtil.parseInt((String)hp.get("RB6_AG")), br_cons);
		  	  			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS6")), AddUtil.parseInt((String)hp.get("RS6_AG")), br_cons);			
		  	  			to_amt3 = "0";
		  	  			to_amt4 = "0";
    				}
    			%>
                <tr>
                    <td class="title" ><%=mon[i]%>개월</td>
                    <td align="center">
					<%if (nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업팀장", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057")) {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
	                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+14)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+14)+1%>',this.value);">
                        <%} else {%>-<%}%>
					<%} else {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
							<%if (mon[i] >= 12) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
	                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+14)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+14)+1%>',this.value);">
                       		<%} else {%>-<%}%>
						<%} else {%>-<%}%>
					<%}%>
        	        </td>
                    <td  align="center">
                        <%if(AddUtil.parseInt(amt2)>0){%>
        		        <%-- <a href="javascript:EstiPrint('2','1','<%=mon[i]%>','<%=to_amt2%>', '<%=amt_id2%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="rs<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt2)>0){%><%=AddUtil.parseDecimal(to_amt2)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+14)+2%>" value="21//<%=mon[i]%>//<%=to_amt2%>//<%=amt_id2%>" onclick="javascript:change_td_col('<%=4*(i+14)+2%>',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
  	          		<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt3)>0){%>
      		            <%-- <a href="javascript:EstiPrint('1','2','<%=mon[i]%>','<%=to_amt3%>', '<%=amt_id3%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt3)>0){%><%=AddUtil.parseDecimal(to_amt3)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+14)+3%>" value="12//<%=mon[i]%>//<%=to_amt3%>//<%=amt_id3%>" onclick="javascript:change_td_col('<%=4*(i+14)+3%>',this.value);">
                        <%} else {%>-<%}%>
                    <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
  		            <%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt4)>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=mon[i]%>','<%=to_amt4%>', '<%=amt_id4%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="ls<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt4)>0){%><%=AddUtil.parseDecimal(to_amt4)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+14)+4%>" value="11//<%=mon[i]%>//<%=to_amt4%>//<%=amt_id4%>" onclick="javascript:change_td_col('<%=4*(i+14)+4%>',this.value);">
                        <%} else {%>-<%}%>
   		            <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%}%>
    		</table>
	    </td>
    </tr>
    <%	}%>    
    
    <!--40000-->
    <%	
    if (!String.valueOf(hp_4d.get("REG_CODE")).equals("") && !String.valueOf(hp_4d.get("REG_CODE")).equals("null")) {
    	hp = hp_4d;
    	
    	rb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RBMAX")), AddUtil.parseInt((String)hp.get("RBMAX_AG")), br_cons);
   		rs_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RSMAX")), AddUtil.parseInt((String)hp.get("RSMAX_AG")), br_cons);
   		lb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LBMAX")), AddUtil.parseInt((String)hp.get("LBMAX_AG")), br_cons);
   		ls_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LSMAX")), AddUtil.parseInt((String)hp.get("LSMAX_AG")), br_cons);
    %>
    <tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여기간별 월대여료
                    	  (연간 약정운행거리 : <%=hp.get("AGREE_DIST")%>km)&nbsp;&nbsp;
                    	</span>
			                <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
			                  (<%=car_mng_id%>-<%=hp.get("REG_CODE")%>)
			                  ||<a href="javascript:estimates_view('<%=hp.get("REG_CODE")%>','<%=car_mng_id%>');" title='견적결과'>[견적결과]</a>
			                <%}%>
					</td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td rowspan="2" width="8%" class="title">대여기간</td>
                    <td colspan="2" class="title">장기렌트</td>
                    <td colspan="2" class="title">리스플러스(오토리스)</td>
                </tr>
                <tr>
                    <td width="23%" class="title">기본식</td>
                    <td width="23%" class="title">일반식</td>
                    <td width="23%" class="title">기본식</td>
                    <td width="23%" class="title">일반식</td>
                </tr>

                <!--최대개월--> 
                <tr>
                    <td class="title">최대 <%=String.valueOf(hp.get("MAX_USE_MON"))%>개월</td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RBMAX"))%>','<%=hp.get("RBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RBMAX")))%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(rb_max)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb73" value="22//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rb_max%>//<%=hp.get("RBMAX_ID")%>" onclick="javascript:change_td_col('73',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RSMAX"))%>','<%=hp.get("RSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RSMAX")))%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(rs_max)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb74" value="21//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rs_max%>//<%=hp.get("RSMAX_ID")%>" onclick="javascript:change_td_col('74',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("LBMAX"))%>','<%=hp.get("LBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LBMAX")))%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(lb_max)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb75" value="12//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=lb_max%>//<%=hp.get("LBMAX_ID")%>" onclick="javascript:change_td_col('75',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("LSMAX"))%>','<%=hp.get("LSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LSMAX")))%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp; --%>
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(ls_max)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb76" value="11//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=ls_max%>//<%=hp.get("LSMAX_ID")%>" onclick="javascript:change_td_col('76',this.value);">
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
                <!--최대개월부터 12개월이내 선택견적-->
                <tr>
                    <td class="title">선택
                        <select name="s_a_b">
                        <%for(int i = AddUtil.parseInt(String.valueOf(hp.get("MAX_USE_MON")))-1 ; i > 6 ; i--){
                        	if(i == 36) continue;
                        	if(i == 24) continue;
                        	if(i == 12) continue;
                        	if(i == 6) continue;

                        %>
                        <option value="<%=i%>"><%=i%></option>
                        <%}%>
                        </select>개월
                    </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RB36")))+AddUtil.parseInt(String.valueOf(hp.get("RB24")))+AddUtil.parseInt(String.valueOf(hp.get("RB12")))+AddUtil.parseInt(String.valueOf(hp.get("RB6")))>0){%>
                        <input type="text" name="rbsel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RS36")))+AddUtil.parseInt(String.valueOf(hp.get("RS24")))+AddUtil.parseInt(String.valueOf(hp.get("RS12")))+AddUtil.parseInt(String.valueOf(hp.get("RS6")))>0){%>
                        <input type="text" name="rssel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LB36")))+AddUtil.parseInt(String.valueOf(hp.get("LB24")))+AddUtil.parseInt(String.valueOf(hp.get("LB12")))>0){%>
                        <input type="text" name="lbsel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LS36")))+AddUtil.parseInt(String.valueOf(hp.get("LS24")))+AddUtil.parseInt(String.valueOf(hp.get("LS12")))>0){%>
                        <input type="text" name="lssel" class=num size="6" value="선택견적" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%
    		  	for (int i = 0; i < 4; i++) {
  	  				if (i==0) {
    					amt1 	= String.valueOf(hp.get("RB36"));			amt2 		= String.valueOf(hp.get("RS36"));  		amt3 		= String.valueOf(hp.get("LB36"));  		amt4 		= String.valueOf(hp.get("LS36"));
    					amt_id1 = String.valueOf(hp.get("RB36_ID"));	amt_id2 = String.valueOf(hp.get("RS36_ID"));  amt_id3 = String.valueOf(hp.get("LB36_ID"));  amt_id4 = String.valueOf(hp.get("LS36_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB36")), AddUtil.parseInt((String)hp.get("RB36_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS36")), AddUtil.parseInt((String)hp.get("RS36_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB36")), AddUtil.parseInt((String)hp.get("LB36_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS36")), AddUtil.parseInt((String)hp.get("LS36_AG")), br_cons);
    				} else if (i == 1) {
    					amt1 	= String.valueOf(hp.get("RB24"));			amt2 		= String.valueOf(hp.get("RS24"));  		amt3 		= String.valueOf(hp.get("LB24"));  		amt4 		= String.valueOf(hp.get("LS24"));
    					amt_id1 = String.valueOf(hp.get("RB24_ID"));	amt_id2 = String.valueOf(hp.get("RS24_ID"));  amt_id3 = String.valueOf(hp.get("LB24_ID"));  amt_id4 = String.valueOf(hp.get("LS24_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB24")), AddUtil.parseInt((String)hp.get("RB24_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS24")), AddUtil.parseInt((String)hp.get("RS24_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB24")), AddUtil.parseInt((String)hp.get("LB24_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS24")), AddUtil.parseInt((String)hp.get("LS24_AG")), br_cons);
    				} else if (i == 2) {
    					amt1 	= String.valueOf(hp.get("RB12"));			amt2 		= String.valueOf(hp.get("RS12"));  		amt3 		= String.valueOf(hp.get("LB12"));  		amt4 		= String.valueOf(hp.get("LS12"));
    					amt_id1 = String.valueOf(hp.get("RB12_ID"));	amt_id2 = String.valueOf(hp.get("RS12_ID"));  amt_id3 = String.valueOf(hp.get("LB12_ID"));  amt_id4 = String.valueOf(hp.get("LS12_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB12")), AddUtil.parseInt((String)hp.get("RB12_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS12")), AddUtil.parseInt((String)hp.get("RS12_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB12")), AddUtil.parseInt((String)hp.get("LB12_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS12")), AddUtil.parseInt((String)hp.get("LS12_AG")), br_cons);
	    			} else if (i == 3) {
  	  					amt1 	= String.valueOf(hp.get("RB6"));			amt2 		= String.valueOf(hp.get("RS6"));  		amt3 		= "0";  amt4 		= "0";
  	  					amt_id1 = String.valueOf(hp.get("RB6_ID"));		amt_id2 = String.valueOf(hp.get("RS6_ID"));  	amt_id3 = "";  	amt_id4 = "";
  	  					
	  	  				to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB6")), AddUtil.parseInt((String)hp.get("RB6_AG")), br_cons);
		  	  			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS6")), AddUtil.parseInt((String)hp.get("RS6_AG")), br_cons);			
		  	  			to_amt3 = "0";
		  	  			to_amt4 = "0";
    				}
    			%>
                <tr>
                    <td class="title" ><%=mon[i]%>개월</td>
                    <td align="center">
					<%if (nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업팀장", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057")) {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
	                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+20)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+20)+1%>',this.value);">
                        <%} else {%>-<%}%>
					<%} else {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
							<%if (mon[i] >= 12) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
	                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+20)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+20)+1%>',this.value);">
							<%} else {%>-<%}%>
						<%} else {%>-<%}%>
					<%}%>
        	        </td>
                    <td  align="center">
                        <%if(AddUtil.parseInt(amt2)>0){%>
        		        <%-- <a href="javascript:EstiPrint('2','1','<%=mon[i]%>','<%=to_amt2%>', '<%=amt_id2%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="rs<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt2)>0){%><%=AddUtil.parseDecimal(to_amt2)%><%}else{%>렌트불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+20)+2%>" value="21//<%=mon[i]%>//<%=to_amt2%>//<%=amt_id2%>" onclick="javascript:change_td_col('<%=4*(i+20)+2%>',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
   	          		<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt3)>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','2','<%=mon[i]%>','<%=to_amt3%>', '<%=amt_id3%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt3)>0){%><%=AddUtil.parseDecimal(to_amt3)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+20)+3%>" value="12//<%=mon[i]%>//<%=to_amt3%>//<%=amt_id3%>" onclick="javascript:change_td_col('<%=4*(i+20)+3%>',this.value);">
                        <%} else {%>-<%}%>
                    <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
	            	<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt4)>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=mon[i]%>','<%=to_amt4%>', '<%=amt_id4%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="ls<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt4)>0){%><%=AddUtil.parseDecimal(to_amt4)%><%}else{%>리스불가<%}%>" <%=readonly%>>원&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="기본견적"></a>
                        <a href="javascript:EstiMate('3', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정견적"></a>
                        <a href="javascript:EstiMate('4', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="무사고기준"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+20)+4%>" value="11//<%=mon[i]%>//<%=to_amt4%>//<%=amt_id4%>" onclick="javascript:change_td_col('<%=4*(i+20)+4%>',this.value);">
                        <%} else {%>-<%}%>
   		            <%} else {%>-<%}%>
					</td>
                </tr>
    		  <%}%>
    		</table>
	    </td>
    </tr>
    <%	}%>
    
    <%}%>
    
    <%if (cr_bean.getCar_use().equals("1")) {%>
    <tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td>
                    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금</span>
			            <%if(nm_db.getWorkAuthUser("전산팀", user_id)){%>
			            (<%=car_mng_id%>-<%=hp.get("REG_CODE")%>)
			            ||<a href="javascript:estimates_view_rm('<%=hp.get("REG_CODE")%>','<%=car_mng_id%>');" title='견적결과'>[월렌트 견적결과]</a>
			            <%}%>
					</td>
                    <td align=right></td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="line">
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr>
					<td class="title" width="8%">월렌트</td>
					<td>&nbsp;
						<%if(AddUtil.parseInt(String.valueOf(hp2.get("RM1")))>0){%><a href="javascript:EstiPrintRm('2','1','1','<%=hp2.get("RM1")%>','<%=hp2.get("RM1_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;<%}%>
    		    	    <input type="text" name="rm1" class=num size="10" value="<%=AddUtil.parseDecimal(String.valueOf(hp2.get("RM1")))%>" <%=readonly%>>원&nbsp;
    		    		&nbsp;|&nbsp;
    		    		<a href="javascript:EstiMateRm('2', document.form1.rm1.value, 'rm1', '2', '1', '1', '0', '_blank')"><img src=/acar/main_car_hp/images/btn_1month.gif border="0" alt="1개월견적"></a>
					    <input type="hidden" name="months" value="1">
                        <input type="hidden" name="days" value="0">
                        <a href="javascript:EstiHistory();"><img src=/acar/images/center/button_in_gjir.gif align="absmiddle" border="0" alt="견적이력"></a>
    		        </td>
				</tr>
			</table>
		</td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
    <%//	}%>    
    <%}%>    
</table>
<input type="hidden" id="cb_chk_off1" value="">
<input type="hidden" id="cb_chk_off2" value="">
<input type="hidden" id="cb_chk_off3" value="">
<input type="hidden" id="cb_chk_off4" value="">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

<script language="JavaScript" type="text/JavaScript">
	<%if(jg_code.equals("")){%>
		alert('차종코드가 없습니다.\n\n정상견적이 안됩니다.\n\n확인하십시오.');
	<%}%>

	var fm = document.form1;
	fm.car_old_exp.value = (<%= carOld.get("YEAR") %>*12)+<%= carOld.get("MONTH") %>;

	fm.depreciation.value 	= parseDecimal(<%=car_amt+opt_amt+clr_amt-tax_dc_amt%> - toInt(parseDigit(fm.apply_secondhand_price.value)));
</script>
</body>
</html>
