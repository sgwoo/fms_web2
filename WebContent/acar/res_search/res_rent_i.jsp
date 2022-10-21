<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.insur.*, acar.estimate_mng.*, acar.secondhand.*, acar.offls_pre.*, acar.user_mng.*,acar.cont.*, acar.car_mst.*,acar.client.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="shDb" scope="page" class="acar.secondhand.SecondhandDatabase"/>
<jsp:useBean id="oh_db" scope="session" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase 	c_db 	= CommonDataBase.getInstance();
	LoginBean 	login 	= LoginBean.getInstance();
	InsDatabase 	ai_db 	= InsDatabase.getInstance();
	EstiDatabase edb		= EstiDatabase.getInstance();
	EstiDatabase 	e_db 	= EstiDatabase.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();


	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String gubun1 		= request.getParameter("gubun1")	==null?"1":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"1":request.getParameter("gubun2");
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");		
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")		==null?"2":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"asc":request.getParameter("asc");
	
	
	//로그인ID&영업소ID&권한	
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "01", "01");
	
	
	String c_id 		= request.getParameter("c_id")		==null?"":request.getParameter("c_id");
	String rent_st 		= request.getParameter("rent_st")	==null?"":request.getParameter("rent_st");
	String rent_start_dt 	= request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt 	= request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt");
	String use_st 		= request.getParameter("use_st")	==null?"":request.getParameter("use_st");	
	String ins_st 		= request.getParameter("ins_st")	==null?"":request.getParameter("ins_st");
	String rent_mon		= request.getParameter("rent_mon")	==null?"":request.getParameter("rent_mon");
	
	
	//영업소 리스트 조회
	Vector branches = c_db.getBranchList(); 
	int brch_size = branches.size();
	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();	
	
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003"); 
	int bank_size = banks.length;

	
	//보험사 리스트
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	
	//예약현황
	Vector conts = rs_db.getResCarList(c_id);
	int cont_size = conts.size();
	
	
	int use_cnt = 0;
	int rent_cnt = 0;
	
	if(cont_size > 0){
  		for(int i = 0 ; i < cont_size ; i++){
    			Hashtable reservs = (Hashtable)conts.elementAt(i);
    			if(String.valueOf(reservs.get("USE_ST")).equals("예약") || String.valueOf(reservs.get("USE_ST")).equals("배차")){
				use_cnt ++;
				if(String.valueOf(reservs.get("USE_ST")).equals("예약") && String.valueOf(reservs.get("RENT_ST")).equals("장기대기")){
					rent_cnt ++;
				}
			}
		}
	}
	
	
	//최근 홈페이지 적용대여료
	Hashtable hp = oh_db.getSecondhandCase_20090901("", "", c_id);	
	

	//보험정보
	if(ins_st.equals("")) ins_st = ai_db.getInsSt(c_id);
	InsurBean ins = ai_db.getIns(c_id, ins_st);
	String ins_com_nm = ai_db.getInsComNm(c_id);
	
	
	//견적정보
	String est_id = "";
	EstimateBean e_bean = new EstimateBean();
			
	
	
	
	//차량정보
	Hashtable sb_ht = shDb.getShBase(c_id);
	
	String tot_dist 		= String.valueOf(sb_ht.get("TOT_DIST"));
	String today_dist 		= String.valueOf(sb_ht.get("TODAY_DIST"));
	String serv_dt	 		= String.valueOf(sb_ht.get("SERV_DT"));
	
	
	
	
	
	//탁송구간
	CodeBean[] codes2 = c_db.getCodeAll_0022("0022");
	int c_size2 = codes2.length;
	
	
	//차량정보
	Off_ls_pre_apprsl ap_bean = rs_db.getCarBinImg2(c_id);	
	
						
	String rent_months	= "";
	String rent_days	= "";
	
	int fee_amt = 0;	
	int fee_amt_m = 0;
	int fee_amt_d = 0;
	int fee_amt_h = 0;
	
	
	
	
	
	UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);	
	
	
	String rent_mng_id = String.valueOf(reserv.get("RENT_MNG_ID"));
	String rent_l_cd = String.valueOf(reserv.get("RENT_L_CD"));
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	
	//차종코드 
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//공휴일 정보
	Vector hdays = c_db.getHolidayList();
	int hdaysSize = hdays.size();
	String[] hdaysArray = new String[hdaysSize];
	for (int i = 0 ; i < hdaysSize ; i++){
		Hashtable hday = (Hashtable)hdays.elementAt(i);
// 		System.out.println(hday.get("HDAY"));
		hdaysArray[i] = (String)hday.get("HDAY");
	}
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="./jquery-ui-1.12.1/datepicker-ko.js"></script>
<!-- <link rel="stylesheet" type="text/css" media="screen" href="resources/jqgrid/jquery-ui-1.12.1/jquery-ui.css" /> -->
<!-- <script src="http://code.jquery.com/jquery-1.10.2.js"></script> -->
<!-- <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script> -->
<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script> -->
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	
	var hdaysArray = "<%=Arrays.toString(hdaysArray)%>".replaceAll("[","").replaceAll("]","").split(",");
	//단기대여---------------------------------------------------------------------------------------------------------
	
	//고객 조회
	function cust_select(){
		var fm = document.form1;
			fm.c_cust_nm.value 	= "";
			fm.c_firm_nm.value 	= "";
			fm.c_ssn.value 		= "";
			fm.c_enp_no.value 	= "";
			fm.c_zip.value 		= "";
			fm.c_addr.value		= "";			
			fm.c_lic_no.value	= "";
			fm.c_lic_st.value 	= "";
			fm.c_tel.value	 	= "";
			fm.c_m_tel.value 	= "";
			if(fm.rent_st.value == '2'){
				fm.serv_id.value = "";
				fm.off_nm.value = "";
				fm.car_no.value = "";
				fm.car_nm.value = "";
			}
			window.open("client_s_p.jsp?auth_rw="+fm.auth_rw.value+"&br_id="+fm.br_id.value+"&user_id="+fm.user_id.value+"&rent_st="+fm.rent_st.value+"&cust_st="+fm.cust_st.value+"&rent_st=<%=rent_st%>", "CLIENT_SEARCH", "left=50, top=50, width=1020, height=700, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//관리담당자 조회
	function mngid_select(){
		var fm = document.form1;
		if(fm.c_cust_id.value == ''){
			alert('고객을 먼저 선택하십시오.');
			return;
		}
		if(fm.mng_id.value != ''){
			if(!confirm('거래처의 기존 담당자가 있습니다. 다른 직원을 조회하시겠습니까?')){	return;	}
		}
		window.open("search_mngid.jsp?c_id=<%=c_id%>&s_brch_id="+fm.s_brch_id.value, "MNGID_SEARCH", "left=50, top=0, width=420, height=700, resizable=yes, scrollbars=yes, status=yes");		
	}

	//고객관련자 조회
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.c_cust_id.value == ''){
			alert('고객을 먼저 선택하십시오.');
			return;
		}		
		//초기화
		if(idx == 4){
			fm.c_lic_no.value 	= '';
			fm.c_lic_st.value 	= '';
			fm.c_tel.value 	= '';
			fm.c_m_tel.value 	= '';			
		}
		if(idx == 2){
			fm.mgr_nm2.value 	= '';
			fm.m_tel2.value 	= '';	
			fm.m_etc2.value 	= '';			
		}
		if(idx == 1){
			fm.m_lic_no1.value 	= '';
			fm.m_lic_st1.value 	= '';
			fm.mgr_nm1.value 	= '';
			fm.m_ssn1.value 	= '';
			fm.m_tel1.value 	= '';			
			fm.m_zip1.value 	= '';	
			fm.m_addr1.value 	= '';	
			fm.m_etc1.value 	= '';			
		}
		window.open("search_mgr.jsp?client_id="+fm.c_cust_id.value+"&idx="+idx, "SEARCH_MGR", "left=50, top=0, width=820, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//고객자동이체정보 조회
	function search_cms(){
		var fm = document.form1;
		if(fm.c_cust_id.value == ''){
			alert('고객을 먼저 선택하십시오.');
			return;
		}		
		window.open("search_cms.jsp?client_id="+fm.c_cust_id.value, "SEARCH_CMS", "left=50, top=0, width=820, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	
	//네비게이션
	function search_navi(){
		var fm = document.form1;
		if(fm.c_cust_id.value == ''){
			alert('고객을 먼저 선택하십시오.');
			return;
		}		
		window.open("search_navi.jsp?client_id="+fm.c_cust_id.value, "SEARCH_CMS", "left=50, top=0, width=820, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	
	//연대보증인 디스플레이
	function gua_display(){
		var fm = document.form1;
		if(fm.gua_st.options[fm.gua_st.selectedIndex].value == '1'){
			tr_gua2.style.display	= '';			
			tr_gua3.style.display	= 'none';						
		}else if(fm.gua_st.options[fm.gua_st.selectedIndex].value == '2'){
			tr_gua2.style.display	= 'none';
			tr_gua3.style.display	= '';
		}else{
			tr_gua2.style.display	= 'none';
			tr_gua3.style.display	= 'none';			
		}
	}

	//결제수단:카드번호 디스플레이
	function paid_display(){
		var fm = document.form1;
		if(fm.paid_st.options[fm.paid_st.selectedIndex].value == '2'){
			td_paid.style.display	= '';						
			if(fm.paid_way.options[fm.paid_way.selectedIndex].value == '1'){
				fm.paid_st1[1].selected = true;
				fm.paid_st2[1].selected = true;				
			}
		}else{
			td_paid.style.display	= 'none';
			if(fm.paid_way.options[fm.paid_way.selectedIndex].value == '1'){
				fm.paid_st1[2].selected = true;
				fm.paid_st2[2].selected = true;				
			}			
		}	
	}
	
	//결제방법:선납금 디스플레이
	function paid_way_display(){
		var fm = document.form1;
		if(fm.paid_way.options[fm.paid_way.selectedIndex].value == '1'){
			tr_pre.style.display	= '';						
			tr_pre1.style.display	= '';									
		}else{
			tr_pre.style.display	= 'none';						
			tr_pre1.style.display	= 'none';								
		}	
	}	

	//실운전자 세팅
	function mgr1_set(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];
			if(ck.name == 'cust_sam_chk'){
				if(ck.checked == true){
					cnt++;
				}
			}
		}
		if(cnt == '1'){//동일
			fm.mgr_nm1.value 	= fm.c_cust_nm.value;
			fm.m_ssn1.value 	= fm.c_ssn.value;
			fm.m_lic_no1.value 	= fm.c_lic_no.value;
			fm.m_lic_st1.value 	= fm.c_lic_st.value;
			fm.m_tel1.value 	= fm.c_tel.value;
			fm.m_zip1.value 	= fm.c_zip.value;
			fm.m_addr1.value 	= fm.c_addr.value;			
		}else{
			fm.mgr_nm1.value 	= '';
			fm.m_ssn1.value 	= '';
			fm.m_lic_no1.value 	= '';
			fm.m_lic_st1.value 	= '';
			fm.m_tel1.value 	= '';
			fm.m_zip1.value 	= '';
			fm.m_addr1.value 	= '';					
		}
	}
	
	//대여일수 구하기
	function getRentTime() {
					
		var fm = document.form1;
				
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  		// 1시간
		lm = 60*1000;  	 	 	// 1분
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;
		
		if(fm.rent_start_dt.value != '' && fm.rent_end_dt.value != ''){
		
			//월렌트 장기대여방식(20120614)
			if(fm.rent_st.value == '12'){
			
				fm.target = "i_no";				
				fm.action = "get_dt_nodisplay.jsp";
				fm.submit();			
				
			}else{	
		
				d1 = replaceString('-','',fm.rent_start_dt.value)+fm.rent_start_dt_h.value+fm.rent_start_dt_s.value;
				d2 = replaceString('-','',fm.rent_end_dt.value)+fm.rent_end_dt_h.value+fm.rent_end_dt_s.value;		
	
				t1 = getDateFromString(d1).getTime();
				t2 = getDateFromString(d2).getTime();
						
				t3 = t2 - t1;
			
				fm.rent_months.value 	= parseInt(t3/m);
				fm.rent_days.value 	= parseInt((t3%m)/l);
				fm.rent_hour.value 	= parseInt(((t3%m)%l)/lh);			
				
			}
			fm.deli_plan_dt.value = fm.rent_start_dt.value;
			fm.ret_plan_dt.value = fm.rent_end_dt.value;			
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}

	//시분 세팅	
	function setDtHS(obj){
					
		var fm = document.form1;	
		if(obj==fm.rent_start_dt_h){
			fm.deli_plan_dt_h[fm.rent_start_dt_h.selectedIndex].selected = true;		
		}else if(obj==fm.rent_start_dt_s){
			fm.deli_plan_dt_s[fm.rent_start_dt_s.selectedIndex].selected = true;				
		}else if(obj==fm.rent_end_dt_h){
			fm.ret_plan_dt_h[fm.rent_end_dt_h.selectedIndex].selected = true;
		}else if(obj==fm.rent_end_dt_s){
			fm.ret_plan_dt_s[fm.rent_end_dt_s.selectedIndex].selected = true;
		}
	}
		
	//정상대여료 자동계산
	function getFee_sam(){
		var fm = document.form1;
		fm.action = 'short_fee_nodisplay.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
	
	//1회차납입일 기준으로 입금예정일 셋팅
	function set_est_dt(){	
		var fm = document.form1;		
		fm.target = "i_no";				
		fm.action = "get_scddt_nodisplay.jsp";
		fm.submit();								
	}
	
	//탁송구간선택시 배차료 셋팅
	function cons_yn_display(){
		var fm = document.form1;	
		if(fm.cmp_app.value != ''){
			fm.action = 'cmp_app_nodisplay.jsp';
			fm.target = 'i_no';
			fm.submit();			
		}
	}
	
	//네비게이션이용액 셋팅
	function navi_yn_display(){
		var fm = document.form1;
		fm.serial_no.value = "";		
		if(fm.navi_yn.value == 'Y'){
			fm.navi_amt.value = 27500;						
		}else{
			fm.navi_amt.value = 0;
			fm.serial_no.value = "";			
		}	
		set_amt(fm.navi_amt);		
	}
	
	//금액 셋팅	
	function set_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;	
		if(obj==fm.fee_s_amt){
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			fm.fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_v_amt){
			fm.fee_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			fm.fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_amt){
			fm.fee_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));		
		}else if(obj==fm.inv_s_amt){
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1) ;
			fm.inv_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
		}else if(obj==fm.inv_v_amt){
			fm.inv_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) / 0.1) ;
			fm.inv_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));
		}else if(obj==fm.inv_amt){
			fm.inv_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));		
		}else if(obj==fm.dc_s_amt){
			fm.dc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) * 0.1) ;
			fm.dc_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));
		}else if(obj==fm.dc_v_amt){
			fm.dc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_v_amt.value)) / 0.1) ;
			fm.dc_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));
		}else if(obj==fm.dc_amt){
			fm.dc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.dc_amt.value))));
			fm.dc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)));		
		}else if(obj==fm.navi_s_amt){
			fm.navi_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) * 0.1) ;
			fm.navi_amt.value 	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value)));
		}else if(obj==fm.navi_v_amt){
			fm.navi_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.navi_v_amt.value)) / 0.1) ;
			fm.navi_amt.value 	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value)));
		}else if(obj==fm.navi_amt){
			fm.navi_s_amt.value	= parseDecimal(sup_amt(toInt(parseDigit(fm.navi_amt.value))));
			fm.navi_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.navi_amt.value)) - toInt(parseDigit(fm.navi_s_amt.value)));		
		}else if(obj==fm.etc_s_amt){
			fm.etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) * 0.1) ;
			fm.etc_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));
		}else if(obj==fm.etc_v_amt){
			fm.etc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_v_amt.value)) / 0.1) ;
			fm.etc_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));
		}else if(obj==fm.etc_amt){
			fm.etc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.etc_amt.value))));
			fm.etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_amt.value)) - toInt(parseDigit(fm.etc_s_amt.value)));		
		}else if(obj==fm.cons1_s_amt){
			fm.cons1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) * 0.1) ;
			fm.cons1_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));
		}else if(obj==fm.cons1_v_amt){
			fm.cons1_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons1_v_amt.value)) / 0.1) ;
			fm.cons1_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));
		}else if(obj==fm.cons1_amt){
			fm.cons1_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.cons1_amt.value))));
			fm.cons1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons1_amt.value)) - toInt(parseDigit(fm.cons1_s_amt.value)));		
		}else if(obj==fm.cons2_s_amt){
			fm.cons2_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) * 0.1) ;
			fm.cons2_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));
		}else if(obj==fm.cons2_v_amt){
			fm.cons2_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons2_v_amt.value)) / 0.1) ;
			fm.cons2_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));
		}else if(obj==fm.cons2_amt){
			fm.cons2_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.cons2_amt.value))));
			fm.cons2_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons2_amt.value)) - toInt(parseDigit(fm.cons2_s_amt.value)));		
		}
		

		
		
		
		//총결재금액											
		fm.rent_tot_s_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons2_s_amt.value)) );
		fm.rent_tot_v_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_v_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)) );
		fm.rent_tot_amt.value 	= parseDecimal(	toInt(parseDigit(fm.fee_amt.value))   + toInt(parseDigit(fm.cons1_amt.value))   + toInt(parseDigit(fm.cons2_amt.value))   );
				
		
	}			

	//금액 셋팅	
	function pay_set_amt(){
	
		var fm = document.form1;
		
		
		
		fm.total_pay_amt.value = 0;
				
		fm.rest_amt1.value 	= parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value))) ;
		fm.rest_amt2.value 	= parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value)) - toInt(parseDigit(fm.pay_amt2.value))) ;
		
		fm.rent_s_amt0.value 	= fm.pay_amt0.value;
		fm.rent_v_amt0.value 	= 0;
		
		//총금액과 스케줄총금액이 맞다면 강제셋팅할것 없다
		var total_pay_amt = 0;

		<%for(int i=1; i<7; i++){%>
		total_pay_amt  	= total_pay_amt + toInt(parseDigit(fm.pay_amt<%=i%>.value));	
		<%}%>

		
		<%for(int i=1; i<7; i++){%>
		
		if(toInt(parseDigit(fm.rent_tot_amt.value)) == total_pay_amt){
			
		}else{
			if(<%=i%> > 2 && fm.pay_dt<%=i%>.value != '')	fm.pay_amt<%=i%>.value		= fm.t_fee_amt.value
		}
		fm.rent_s_amt<%=i%>.value 	= parseDecimal( sup_amt(toInt(parseDigit(fm.pay_amt<%=i%>.value))));
		fm.rent_v_amt<%=i%>.value 	= parseDecimal( toInt(parseDigit(fm.pay_amt<%=i%>.value)) - toInt(parseDigit(fm.rent_s_amt<%=i%>.value)));
		fm.total_pay_amt.value  	= parseDecimal( toInt(parseDigit(fm.total_pay_amt.value))+toInt(parseDigit(fm.pay_amt<%=i%>.value)) );	
		<%}%>
					
		<%for(int i=3; i<7; i++){%>				
		fm.rest_amt<%=i%>.value 	= parseDecimal( toInt(parseDigit(fm.rest_amt<%=i-1%>.value)) - toInt(parseDigit(fm.pay_amt<%=i%>.value)) ) ;
		<%}%>
		
		
	}	
	

	
	//최초결제방식 셋팅
	function f_paid_way_display(){
		var fm = document.form1;
		
		if(fm.f_paid_way.value == '1'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.dc_amt.value)) + toInt(parseDigit(fm.ins_amt.value)) + toInt(parseDigit(fm.navi_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.cons1_amt.value)) );
		}else if(fm.f_paid_way.value == '2'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.m2_dc_amt.value)) - toInt(parseDigit(fm.m3_dc_amt.value)) + toInt(parseDigit(fm.cons1_amt.value)) );
		}
		
		//반차료 최초포함여부
		if(fm.f_paid_way2.value == '1'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.f_rent_tot_amt.value)) + toInt(parseDigit(fm.cons2_amt.value)));
		}
		
		pay_set_amt();				
	
	}		
	

	// 정비대차 ------------------------------------------------------------------------------------------------
	
	//정비 조회
	function serv_select(){
		var fm = document.form1;
			fm.serv_id.value 	= "";
			fm.off_nm.value 	= "";
			if(fm.c_cust_id.value == '' && fm.rent_st.value == '2'){ alert('고객을 선택하십시오.');  return;}
			window.open("sub_select_2_s.jsp?c_id="+fm.sub_c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&go_url=/acar/res_search/res_rent_i.jsp", "SERV_SEARCH", "left=50, top=50, width=800, height=600, status=yes, scrollbars=yes");
	}	

	
	// 사고대차 ------------------------------------------------------------------------------------------------
	
	//사고 조회
	function accid_select(){
		var fm = document.form1;
			fm.accid_id.value 	= "";
			fm.off_nm.value 	= "";
			if(fm.rent_st.value == '3'){
				fm.our_num.value	= "";
				fm.ins_nm.value		= "";
				fm.ins_mng_nm.value	= "";			
				if(fm.c_cust_id.value == '' && fm.rent_st.value == '3'){ alert('고객을 선택하십시오.');  return;}				
			}else{
				fm.accid_dt.value = "";
				fm.accid_mng_nm.value = "";
				fm.accid_cont.value = "";
			}
			window.open("sub_select_3_a.jsp?auth_rw="+fm.auth_rw.value+"&c_id="+fm.sub_c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&user_id="+fm.user_id.value+"&go_url=/acar/res_search/res_rent_i.jsp", "ACCID_SEARCH", "left=50, top=50, width=830, height=600, status=yes, scrollbars=yes");
	}	


	// 대여 및 업무지원 ------------------------------------------------------------------------------------------------
	
	//직원 조회
	function user_select(){
		var fm = document.form1;
		fm.c_brch_nm.value 	= "";
		fm.c_dept_nm.value 	= "";
		fm.c_lic_no.value	= "";
		fm.c_lic_st.value 	= "";
		fm.c_tel.value	 	= "";
		fm.c_m_tel.value 	= "";
		fm.target='i_no';
		fm.action = 'sub_select_4_u.jsp?user_id='+fm.c_cust_nm.options[fm.c_cust_nm.selectedIndex].value;
		fm.submit();
	}	

	
	// 차량점검 ------------------------------------------------------------------------------------------------
	
	//정기점검 조회
	function maint_select(){
		var fm = document.form1;
			fm.seq_no.value 	= "";
			fm.che_kd.value 	= "";
			fm.che_no.value		= "";
			fm.che_comp.value	= "";
			window.open("sub_select_5_m.jsp?c_id="+fm.c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value, "ACCID_SEARCH", "left=50, top=50, width=800, height=300, status=yes, scrollbars=yes");
	}	

	
	// 기타 ------------------------------------------------------------------------------------------------
	

	//차량예약현황 조회
	function car_reserve(){
		var fm = document.form1;
		var SUBWIN="car_reserve.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserve", "left=50, top=50, width=820, height=500, scrollbars=yes");
	}

	//동급차량예약현황 조회
	function car_reserve2(){
		var fm = document.form1;
		var SUBWIN="car_reserve_dk.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserveDK", "left=50, top=50, width=820, height=500, scrollbars=yes");
	}

	//정비업체 조회
	function SearchServOff(){
		var fm = document.form1;
		var serv_off_nm = "";
		var keyValue = event.keyCode;
		if (keyValue =='13'){
			serv_off_nm = fm.cust_nm.value;
			var SUBWIN="./service_office_open.jsp?off_nm=" +serv_off_nm;	
			window.open(SUBWIN, "ServOff", "left=100, top=100, width=230, height=250, scrollbars=yes");
		}
	}
		
	//저장하기
	function save(){
		var fm = document.form1;
		var rent_st = $("#rent_st").val();
		var ins_change_flag = $("#ins_change_flag").is(":checked");
		var ins_change_flag_input = "";
		
		// 21세만 해당
		if(ins_change_flag) {
			ins_change_flag_input = "N"; // 보유차 보험 변경 X
		} else {
			ins_change_flag_input = "Y"; // 보유차 보험 변경 O
		}
		
		$("#ins_change_flag_input").val(ins_change_flag_input);
		
// 		alert($("#ins_change_flag_input").val());
		
		if(rent_st == "3" || rent_st == "2" || rent_st == "10"){
			if(fm.c_cust_id.value == '') { 
				alert('고객 원계약 정보를 선택하세요.');
				return;
			} 
			var age1 = 0; // 대여 차량 보험 연령
			var age2 = 0; // 계약 차량 보험 연령
			var rent_start_dt = $("#rent_start_dt").val().replaceAll("-",""); // 약정 기간 시작일
			var rent_end_dt = $("#rent_end_dt").val().replaceAll("-",""); // 약정 기간 종료일
			var ins_change_std_dt = $("#ins_change_std_dt").val().replaceAll("-",""); // 보험 변경 기준일

			if($("#age_scp_1").val() == "1") {
				age1 = 21;
			} else if($("#age_scp_1").val() == "2") {
				age1 = 26;
			} else if($("#age_scp_1").val() == "4") {
				age1 = 24;
			}
			
			if($("#age_scp_2").val() == "1") {
				age2 = 21;
			} else if($("#age_scp_2").val() == "2") {
				age2 = 26;
			} else if($("#age_scp_2").val() == "4") {
				age2 = 24;
			}
			
			if((rent_st == "3" && (age1 > age2)) || (rent_st == "10" && (age1 > age2)) || age2 == 21 ) {
				if(!$("#ins_change_std_dt").val()) {
					alert("보험변경 기준일을 입력하세요.");
					return;
				}
				var today = new Date();
				var year = today.getFullYear();
				year = year.toString();
				var month = ('0' + (today.getMonth() + 1)).slice(-2);
				month = month.toString();
				var date = ('0' + today.getDate()).slice(-2);
				date = date.toString();
				var day = today.getDay();
				var week = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');
				var todayLabel = week[day];
				var hours = today.getHours();
				var today_yyyymmdd = year+month+date;
				
				if(parseInt(rent_start_dt) >= parseInt(rent_end_dt)) {
					alert("약정 기간 시작일과 종료일을 확인하세요.");
					return;
				} 
				// 21세 보험 변경일 경우에만 보험변경 날짜 체크 진행
				if(ins_change_flag_input == "Y") {
					// 오후 5시 이전인 경우
					if(hours < 17) {
						if(parseInt(ins_change_std_dt) >= parseInt(rent_start_dt)) {
							alert("보험 변경 기준일은 약정 기간의 시작일 보다 빨라야합니다.\n확인 후 다시 저장하세요.");
							return;
						} else if(parseInt(ins_change_std_dt) < parseInt(today_yyyymmdd)) {
							alert("보험 변경 기준일은 오늘보다 빠를 수 없습니다.\n확인 후 다시 저장하세요.");
							return;
						}
					} 
					// 오후 5시 이후인 경우
					else {
						if(parseInt(ins_change_std_dt) == parseInt(today_yyyymmdd)) {
							alert("오후 17시 이후는 보험 업무 마감으로 보험 변경 기준일을 당일로 지정할 수 없습니다.\n당일 날짜로 등록이 필요한 경우 보험 담당자에게 문의하세요.");
							return;
						} else if(parseInt(ins_change_std_dt) >= parseInt(rent_start_dt)) {
							alert("보험 변경 기준일은 약정 기간의 시작일 보다 빨라야합니다.\n확인 후 다시 저장하세요.");
							return;
						} else if(parseInt(ins_change_std_dt) < parseInt(today_yyyymmdd)) {
							alert("보험 변경 기준일은 오늘보다 빠를 수 없습니다.\n확인 후 다시 저장하세요.");
							return;
						}   
					}
				}
			}
		}
		
		if(toInt(fm.rent_cnt.value) > 0){
			if(!confirm('재리스 계약확정되어 장기대기로 예약되어 있는 차량입니다.\n\n등록하시겠습니까?')){	return;	}
		}else{
			if(toInt(fm.use_cnt.value) > 0){
				if(!confirm('현재 예약 혹은 배차중인 차량입니다.\n\n등록하시겠습니까?')){	return;	}
			}
		}
				
		if(fm.c_id.value == '')		{ alert('차량선택이 잘못되었습니다\n\n목록에서 선택하십시오'); 		return; }
		if(fm.rent_st.value == '')	{ alert('계약구분이 잘못되었습니다\n\n전페이지에서 선택하십시오'); 	return; }		
		
		
		if(fm.rent_st.value == '1' || fm.rent_st.value == '9' || fm.rent_st.value == '12'){		
		
			if(fm.c_cust_id.value == '')		{ alert('고객을 선택하십시오'); return; }
			if(fm.c_cust_id.value == '000228')	{ alert('아마존카로는 입력할 수 없습니다. 고객을 선택하십시오'); return; }			
			if(fm.rent_end_dt.value == '')		{ alert('대여종료일을 입력하십시오'); return; }			
			
			if(fm.rent_st.value == '1' || fm.rent_st.value == '9'){	
				if(toInt(fm.rent_months.value) == 0 && toInt(fm.rent_days.value) == 0 && toInt(fm.rent_hour.value) == 0){ 
					alert('약정기간을 확인하십시오.'); return;
				}
				if(fm.rent_st.value != '12' && toInt(fm.rent_months.value) == 1 && (toInt(fm.rent_days.value) > 0 || toInt(fm.rent_hour.value) > 0)){ 
					alert('1개월 이상은 장기계약으로 입력해주십시오.'); return;
				}
			}
			if(fm.fee_s_amt.value == '0' || fm.fee_s_amt.value == ''){ alert('정상대여료를 입력하십시오.'); return; }			
			
		
		}else if(fm.rent_st.value == '2'){
			if(fm.c_cust_id.value == ''){ alert('고객을 선택하십시오'); return; }
			if(fm.age_scp.value != fm.d_car_ins_age_cd.value){ 
				if(!confirm('정비차량과 대차차량의 보험연령이 다릅니다. 등록하시겠습니까?')){	return;	}
			}	
		
		}else if(fm.rent_st.value == '3'){
			if(fm.c_cust_id.value == ''){ alert('고객을 선택하십시오'); return; }
			if(fm.age_scp.value != fm.d_car_ins_age_cd.value){ 
				if(!confirm('사고차량과 대차차량의 보험연령이 다릅니다. 등록하시겠습니까?')){	return;	}
			}	

		}else if(fm.rent_st.value == '4' || fm.rent_st.value == '5'){
			if(fm.c_cust_nm.value == ''){ alert('사용자를 선택하십시오'); return; }

		}else if(fm.rent_st.value == '10'){//지연대차
			if(fm.c_cust_id.value == '')		{ alert('고객을 선택하십시오'); return; }
			if(fm.c_cust_id.value == '000228')	{ alert('아마존카로는 입력할 수 없습니다. 고객을 선택하십시오'); return; }
			if(fm.age_scp.value != fm.d_car_ins_age_cd.value){ 
				if(!confirm('정비차량과 대차차량의 보험연령이 다릅니다. 등록하시겠습니까?')){	return;	}
			}	
		}
		
		if(fm.rent_dt.value == '')	{ alert('계약일자를 입력하십시오'); 		fm.rent_dt.focus(); 		return; }
		if(fm.s_brch_id.value == '')	{ alert('영업소를 입력하십시오'); 		fm.brch_id.focus(); 		return; }
		if(fm.bus_id.value == '')	{ alert('담당자를 입력하십시오'); 		fm.bus_id.focus(); 		return; }
		if(fm.rent_start_dt.value == ''){ alert('이용기간 시작일시를 입력하십시오'); 	fm.rent_start_dt.focus(); 	return; }
		if(fm.deli_plan_dt.value == '')	{ alert('배차예정일시를 입력하십시오'); 	fm.deli_plan_dt.focus(); 	return; }
		
		
		if(!max_length(fm.deli_loc.value,40)){	alert('배차위치 길이는 '+get_length(fm.deli_loc.value)+'자(공백포함) 입니다.\n\n사유는 한글20자/영문40자까지 입력이 가능합니다.'); return; } 
		if(!max_length(fm.ret_loc.value,40)) {	alert('반차위치 길이는 '+get_length(fm.ret_loc.value)+'자(공백포함) 입니다.\n\n사유는 한글20자/영문40자까지 입력이 가능합니다.'); return; } 		
		
		//운전면허번호 자리수체크 및 formating 로직 추가(2018.02.07)
		<%if(rent_st.equals("1") || rent_st.equals("9")){%>
			if(fm.c_lic_no.value!=""){
				var chk_lic_no_res = CheckLic_no(fm.c_lic_no.value);
				if(chk_lic_no_res=='N'){	return false;	}
			}
			if(fm.m_lic_no1.value!=""){
				var chk_lic_no_res2 = CheckLic_no(fm.m_lic_no1.value);
				if(chk_lic_no_res2=='N'){	return false;	}
			}
		<%}else if(rent_st.equals("4") || rent_st.equals("5")){%>
			if(fm.c_lic_no.value!=""){
				var chk_lic_no_res = CheckLic_no(fm.c_lic_no.value);
				if(chk_lic_no_res=='N'){	return false;	}
			}
		<%}%>
					
		if(!confirm('등록하시겠습니까?')){	return;	}
		
		if(fm.rent_start_dt.value != '')
			fm.h_rent_start_dt.value = fm.rent_start_dt.value+fm.rent_start_dt_h.value+fm.rent_start_dt_s.value;
		if(fm.rent_end_dt.value != '')
			fm.h_rent_end_dt.value = fm.rent_end_dt.value+fm.rent_end_dt_h.value+fm.rent_end_dt_s.value;
		if(fm.deli_plan_dt.value != '')
			fm.h_deli_plan_dt.value = fm.deli_plan_dt.value+fm.deli_plan_dt_h.value+fm.deli_plan_dt_s.value;
		if(fm.ret_plan_dt.value != '')
			fm.h_ret_plan_dt.value = fm.ret_plan_dt.value+fm.ret_plan_dt_h.value+fm.ret_plan_dt_s.value;
		if(fm.deli_dt.value != ''){
			if(fm.deli_dt_h.value == ''){ alert('배차 시간을 선택하십시오'); return; }
			if(fm.deli_dt_s.value == ''){ alert('배차 분을 선택하십시오'); return; }			
			if(fm.deli_loc.value == ''){ alert('배차위치를 입력하십시오'); return; }						
			if(fm.deli_mng_id.value == ''){ alert('배차담당자를 선택하십시오'); return; }
			fm.h_deli_dt.value = fm.deli_dt.value+fm.deli_dt_h.value+fm.deli_dt_s.value;			
		}
			
		fm.action = 'res_rent_i_a.jsp';
//		fm.target = 'd_content';
		fm.target='i_no';
		fm.submit();
	}
	
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "res_se_frame_s.jsp";
		fm.submit();
	}	
	
	function view_ins()
	{
		window.open("../ins_mng/ins_u_frame.jsp?c_id=<%=c_id%>&ins_st=<%=ins_st%>&cmd=view", "VIEW_INS", "left=20, top=20, width=850, height=650, scrollbars=yes");
	}		
	
	function EstiPrintRm(a_a,rent_way,a_b,amt){ 		
		var fm = document.form1;  		
		var SUBWIN="/acar/secondhand_hp/estimate_rm.jsp?est_id=<%=est_id%>&from_page=secondhand_hp&car_mng_id=<%= c_id %>&today_dist=<%=hp.get("REAL_KM")%>&o_1=<%=hp.get("APPLY_SH_PR")%>&rent_dt=<%=hp.get("UPLOAD_DT")%>&est_code=<%=hp.get("REG_CODE")%>&a_a="+a_a+""+rent_way+"&a_b="+a_b+"&amt="+amt;  	
		if(<%=hp.get("UPLOAD_DT")%> > 20120830){
			SUBWIN="/acar/secondhand_hp/estimate_rm_new.jsp?est_id=<%=est_id%>&from_page=secondhand_hp&car_mng_id=<%= c_id %>&today_dist=<%=hp.get("REAL_KM")%>&o_1=<%=hp.get("APPLY_SH_PR")%>&rent_dt=<%=hp.get("UPLOAD_DT")%>&est_code=<%=hp.get("REG_CODE")%>&a_a="+a_a+""+rent_way+"&a_b="+a_b+"&amt="+amt;  	
		}
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 		
	}
	
	//차종내역 보기
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=c_id%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=reserv.get("RENT_MNG_ID")%>&rent_l_cd=<%=reserv.get("RENT_L_CD")%>&car_mng_id=<%=c_id%>&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}		
	
	//차종내역 보기
	function view_car_nm(){
		window.open("/acar/car_mst/car_mst_u.jsp?car_id=<%=reserv.get("CAR_ID")%>&car_seq=<%=reserv.get("CAR_SEQ")%>", "VIEW_CAR_NM", "left=20, top=20, width=875, height=650, scrollbars=yes");		
	}
	
	//월렌트일때 개월선택시 자동셋팅 20120424
	function rent_end_set_display(){
		var fm = document.form1;		
		fm.target = "i_no";
		fm.action = "get_dt_nodisplay.jsp";
		fm.submit();			
	}
	
	
	function youFunction(){
		alert();
	}
	
	 $(function() {
         $("#ins_change_std_dt").datepicker({
             dateFormat: 'yy-mm-dd'
             ,showOtherMonths: true
             ,showMonthAfterYear:true
             ,changeYear: true
             ,changeMonth: true                 
             ,showOn: "both"
             ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" 
             ,buttonImageOnly: true
             ,buttonText: "선택"           
             ,yearSuffix: "년" 
             ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12']
             ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
             ,dayNamesMin: ['일','월','화','수','목','금','토'] 
             ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] 
             ,minDate: "-0D" //(-1D:하루, -1M:한 달, -1Y:일 년)
	         ,beforeShowDay: function(date){
	             show = true;
	             if(date.getDay() == 0 || date.getDay() == 6){show = false;} // 주말 제외
	             for (var i = 0; i < hdaysArray.length; i++) {
	                 if (new Date(hdaysArray[i]).toString() == date.toString()) {show = false;} // 공휴일 제외
	                 
	             }
	             var display = [show,'',(show)?'':'주말 및 공휴일 선택 불가'];
	             return display;
	         }
         });                    
         
         $('#ins_change_std_dt').datepicker('setDate', 'today'); // 최초 날짜 세팅 시 오늘 날짜 설정
         $(".ui-datepicker-trigger").css("margin-left","3px"); // 캘린더 이미지 위치 조정
         $(".ui-datepicker-trigger").css("margin-bottom","-3px"); // 캘린더 이미지 위치 조정
         
	 });
	 
	 $(document).ready(function(){
		    $("#ins_change_flag").change(function(){
		        if($("#ins_change_flag").is(":checked")){
		            alert("보험연령 21세 고객, 대차 차량 21세로 연령 변경 없음을 체크 하셨습니다.\n실제 연령 변경 신청이 안 되며 대차 차량은 이후 사고 발생 시 자동차 보상처리가 면책 처리되며 모든 담당자 또는 고객은 서로 간의 고지의 유무에 따라 과실자가 정해지며 책임있는 사유로 그 손해를 배상할 책임을 집니다.");
		        }
		    });
		});
//-->

</script>
</head>
<body leftmargin="15">

<form action="reserve_rent_i_a.jsp" name="form1" method="post" >
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun1' value='<%=gubun1%>'>  
 <input type='hidden' name='gubun2' value='<%=gubun2%>'>   
 <input type='hidden' name='brch_id' value='<%=brch_id%>'>
 <input type='hidden' name='start_dt' value='<%=start_dt%>'> 
 <input type='hidden' name='end_dt' value='<%=end_dt%>'>
 <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  <input type='hidden' name='code' value='<%=code%>'>  
 <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
  <input type='hidden' name='s_cc' value='<%=s_cc%>'>
 <input type='hidden' name='s_year' value='<%=s_year%>'>
 <input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
 <input type='hidden' name='asc' value='<%=asc%>'>

 <input type='hidden' name='c_id' value='<%=c_id%>'>
 <input type='hidden' name='rent_st' value='<%=rent_st%>' id='rent_st'>
 <input type='hidden' name='use_st' value='<%=use_st%>'>
 <input type='hidden' name='c_cust_id' value=''>
 <input type='hidden' name='c_car_no' value='<%=reserv.get("CAR_NO")%>'>
 <input type='hidden' name='sub_c_id' value='<%if(rent_st.equals("6") || rent_st.equals("7") || rent_st.equals("8")) out.println(c_id);%>'>
 <input type='hidden' name='section' value='<%=reserv.get("SECTION")%>'>
 <input type='hidden' name='h_rent_start_dt' value=''>
 <input type='hidden' name='h_rent_end_dt' value=''>
 <input type='hidden' name='h_deli_plan_dt' value=''>
 <input type='hidden' name='h_ret_plan_dt' value=''>
 <input type='hidden' name='h_deli_dt' value=''> 
 <input type='hidden' name='sub_l_cd' value=''> 
 <input type='hidden' name='rm1' value='<%=hp.get("RM1")%>'> 
 <input type='hidden' name='est_s_amt' value='<%=hp.get("RM1")%>'> 
 <input type='hidden' name='est_v_amt' value='0'> 
 <input type='hidden' name='est_id' value='<%=est_id%>'>
 <input type='hidden' name='from_page' value='/acar/res_search/res_rent_i.jsp'>
 <input type='hidden' name='site_id' value=''>
 <input type='hidden' name='mng_id' value=''>

 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 영업지원 > 예약관리 > <span class=style5>예약등록 ( 
                    <%if(rent_st.equals("1")){%>
                단기대여 
                <%}else if(rent_st.equals("2")){%>
                정비대차 
                <%}else if(rent_st.equals("3")){%>
                사고대차 
                <%}else if(rent_st.equals("9")){%>
                보험대차 
                <%}else if(rent_st.equals("10")){%>
                지연대차 
                <%}else if(rent_st.equals("4")){%>
                업무대여 
                <%}else if(rent_st.equals("5")){%>
                업무지원 
                <%}else if(rent_st.equals("6")){%>
                차량정비 
                <%}else if(rent_st.equals("7")){%>
                차량점검 
                <%}else if(rent_st.equals("8")){%>
                사고수리 
                <%}else if(rent_st.equals("11")){%>
                장기대기
                
                <%}%>	
                    )</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td width="30%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보 (<%=c_id%>)</span></td>
        <td align="right" width="70%">
	    	
        	<a href='javascript:go_to_list();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>차량번호</td>
                    <td>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=reserv.get("CAR_NO")%></a></td>
                    <td class=title>차명</td>
                    <td align="left" colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=reserv.get("CAR_NAME")%></a> (<%=reserv.get("SECTION")%>)&nbsp;</td>
                    <td class=title>차대번호</td>
                    <td colspan=3>&nbsp;<%=reserv.get("CAR_NUM")%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>최초등록일</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                    <td class=title width=10%>출고일자</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
                    <td class=title width=11%>배기량</td>
                    <td width=10%>&nbsp;<%=reserv.get("DPM")%>cc</td>
                    <td class=title width=10%>칼라</td>
                    <td width=10%>&nbsp;<%=reserv.get("COLO")%></td>
                    <td class=title width=9%>연료</td>
                    <td width=10%>&nbsp;<%=reserv.get("FUEL_KD")%></td>
                </tr>
                <tr> 
                    <td class=title>선택사양</td>
                    <td colspan="9">&nbsp;<%=reserv.get("OPT")%></td>                                        
                </tr>
				<tr> 
                    <td class=title width=10%>검사유효기간</td>
                    <td width=23% colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%></td>
                    <td class=title>차령만료일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("CAR_END_DT")))%></td>
                    <td class=title>점검유효기간</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_END_DT")))%></td>
                </tr>                
                <!--보험정보-->
                <tr> 
                    <td class=title>보험회사</td>
                    <td >&nbsp;<a href="javascript:view_ins()"><%=ins_com_nm%></a>
        			<%if(ins.getVins_spe().equals("애니카")){%>(애니카)<%}%>
        			</td>
                  <td class=title>피보험자</td>
                  <td>&nbsp;<%if(ins.getCon_f_nm().equals("아마존카")){%><%=ins.getCon_f_nm()%><%}else{%><b><font color='#990000'><%=ins.getCon_f_nm()%></font></b><%}%></td>
                  <td class=title>보험연령</td>
                  <td>&nbsp;
                    	<%if(ins.getAge_scp().equals("1")){%>21세이상<%}%>
                        <%if(ins.getAge_scp().equals("4")){%>24세이상<%}%>
                        <%if(ins.getAge_scp().equals("2")){%>26세이상<%}%>
                        <%if(ins.getAge_scp().equals("3")){%>전연령<%}%>
                        <%if(ins.getAge_scp().equals("5")){%>30세이상<%}%>
                        <%if(ins.getAge_scp().equals("6")){%>35세이상<%}%>
                        <%if(ins.getAge_scp().equals("7")){%>43세이상<%}%>
						<%if(ins.getAge_scp().equals("8")){%>48세이상<%}%>
						<%if(ins.getAge_scp().equals("9")){%>22세이상<%}%>
						<%if(ins.getAge_scp().equals("10")){%>28세이상<%}%>
						<%if(ins.getAge_scp().equals("11")){%>35세이상~49세이하<%}%>
			<input type="hidden" name="age_scp" value="<%=ins.getAge_scp()%>" id="age_scp_1">
                  </td>   
                    <td class=title>예상주행거리</td>
                    <td colspan="3">&nbsp;&nbsp;<%=AddUtil.parseDecimal(today_dist)%>km&nbsp;(최종입력:<%=AddUtil.parseDecimal(tot_dist)%>km, <%=AddUtil.ChangeDate2(serv_dt)%>)
   	    	      &nbsp;&nbsp;
		      <span class="b"><a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="정비내역보기"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>  	
                    </td>                         			
                </tr>                
                <%if(!rent_st.equals("1") && !rent_st.equals("9")){%>
                <tr> 
                    <td class=title>일반대차</td>
                    <td colspan="9">&nbsp;월대여료 : <%=Util.parseDecimal(String.valueOf(reserv.get("FEE_S_AMT")))%>원, 1일대여료 : <%=Util.parseDecimal(String.valueOf(reserv.get("DAY_S_AMT")))%>원 (공급가)</td>
                </tr>				
                <%}%>		
    		  
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("11")){%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right">
                .<img src=/acar/images/center/arrow.gif> <%=reserv.get("CAR_NO")%> 대여리스트 <a href="javascript:car_reserve();"><img src="/acar/images/center/button_see.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;&nbsp;
		<a href="javascript:car_reserve2();"><img src="/acar/images/center/button_list_dg.gif" align="absmiddle" border="0"></a>	     
        	&nbsp;
        	<%if(!ap_bean.getImgfile1().equals("")){%>
	    	<a href="javascript:MM_openBrWindow('/acar/secondhand_hp/bigimg.jsp?c_id=<%=c_id%>','ImgAdd','scrollbars=no,status=no,resizable=yes,width=800,height=600,left=50, top=50');" class="btn"><img src=../images/center/button_see_p.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	    	<%}%>
        </td>
    </tr>
    <%if(rent_st.equals("1") || rent_st.equals("9")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>구분 </td>
                    <td> 
                      &nbsp;<select name='cust_st'>
                        <option value='1' selected>고객</option>
                        <option value='4'>직원</option>						
                      </select>
					  &nbsp;<a href="javascript:cust_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
					  <!--
					  <input type='hidden' name='cust_st' value=''>
                      <input type="text" name="c_cust_st" value="" size="15" class=whitetext>
					  -->					  
                    </td>
                    <td class=title>성명</td>
                    <td> 
                      &nbsp;<input type="text" name="c_cust_nm" value="" size="18" class=whitetext>
                    </td>
                    <td class=title>생년월일/법인번호</td>
                    <td colspan=3> 
                      &nbsp;<input type="text" name="c_ssn" value="" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>상호</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="c_firm_nm" value="" size="60" class=whitetext>
                    </td>
                    <td class=title>사업자등록번호</td>
                    <td colspan=3> 
                      &nbsp;<input type="text" name="c_enp_no" value="" size="15" class=whitetext>
                    </td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('c_zip').value = data.zonecode;
								document.getElementById('c_addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>
                <tr> 
                    <td class=title>주소</td>
                    <td colspan="7"> 
					<input type="text" name='c_zip' id="c_zip" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='c_addr' id="c_addr" size="100">
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>운전면허번호</td>
                    <td width=17%>&nbsp;
                      <a href='javascript:search_mgr(4)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
                      &nbsp;<input type="text" name="c_lic_no" value="" size="16" class=text onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                    </td>
                    <td class=title width=10%>면허종류</td>
                    <td width=14%> 
                      &nbsp;<select name='c_lic_st'>
                        <option value=''>선택</option>
                        <option value='1'>2종보통</option>
                        <option value='2'>1종보통</option>
                        <option value='3'>1종대형</option>
                      </select>                      
                    </td>
                    <td class=title width=10%>전화번호</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="c_tel" value="" class=text size="15">
                    </td>
                    <td class=title width=10%>휴대폰</td>
                    <td width=14%> 
                      &nbsp;<input type="text" name="c_m_tel" value="" size="15" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>비상연락처</td>
                    <td  colspan='7'>&nbsp; 
                      <a href='javascript:search_mgr(2)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
                      &nbsp;<img src=/acar/images/center/arrow.gif><input type="hidden" name="mgr_st2" value="2">
                      성명:&nbsp; 
                      <input type="text" name="mgr_nm2" value="" class=text size="9">
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 연락처:&nbsp; 
                      <input type="text" name="m_tel2" value="" size="13" class=text>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 관계:&nbsp; 
                      <input type="text" name="m_etc2" value="" size="62" class=text>
                    </td>
                </tr>
                
                <tr> 
                    <td class=title rowspan="4">실운전자<br>(용역기사 등)</td>
                    <td  colspan='7'>                                             
                      <input type="checkbox" name="cust_sam_chk" value="N" onclick="javascript:mgr1_set();">
                      위의 고객과 동일                      
                    </td>
                </tr>
                <tr> 
                    <td  colspan='7'>&nbsp;<img src=/acar/images/center/arrow.gif> 성명:&nbsp; 
                      <input type="hidden" name="mgr_st1" value="1">
                      <input type="text" name="mgr_nm1" value="" class=text size="10">
                      &nbsp; <img src=/acar/images/center/arrow.gif> 생년월일:&nbsp; 
                      <input type="text" name="m_ssn1" value="" size="15" class=tex tmaxlength='8' >
                      &nbsp; <img src=/acar/images/center/arrow.gif> 운전면허번호:&nbsp; 
                      <input type="text" name="m_lic_no1" value="" size="16" class=text>
                      &nbsp; <img src=/acar/images/center/arrow.gif> 면허종류:&nbsp; 
                      <select name='m_lic_st1'>
                        <option value=''>선택</option>
                        <option value='1'>2종보통</option>
                        <option value='2'>1종보통</option>
                        <option value='3'>1종대형</option>
                      </select>  
                      &nbsp; <img src=/acar/images/center/arrow.gif> 전화번호:&nbsp; 
                      <input type="text" name="m_tel1" value="" size="15" class=text>
                    </td>
                </tr>   
				<script>
					function openDaumPostcode2() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('m_zip2').value = data.zonecode;
								document.getElementById('m_addr2').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>
                <tr> 
                    <td  colspan='7'>&nbsp;<img src=/acar/images/center/arrow.gif> 주소:&nbsp; 
					<input type="text" name='m_zip1' id="m_zip2" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='m_addr1' id="m_addr2" size="100">
					
                    </td>
                </tr>
                <tr> 
                    <td  colspan='7'>&nbsp;<img src=/acar/images/center/arrow.gif> 기타:&nbsp;                       
                      <input type="text" name="m_etc1" value="" size="113" class=text>
                    </td>
                </tr>                                                             
                
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("10") || rent_st.equals("11")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>구분 </td>
                    <td width=21%> 
                      &nbsp;
					  <select name='cust_st'>
                        <option value='1'>고객</option>
                      </select>
					  &nbsp;<a href="javascript:cust_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
					  <!--
					  <input type='hidden' name='cust_st' value=''>
                      <input type="text" name="c_cust_st" value="" size="15" class=whitetext>
					  -->
                    </td>
                    <td class=title width=10%>성명</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="c_cust_nm" value="" size="30" class=whitetext>
                    </td>
                    <td class=title width=10%>생년월일/법인번호</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="c_ssn" value="" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>상호</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="c_firm_nm" value="" size="80" class=whitetext>
                    </td>
                    <td class=title>사업자등록번호</td>
                    <td> 
                      &nbsp;<input type="text" name="c_enp_no" value="" size="15" class=whitetext>
                    </td>
                </tr>
        	    <%if(!rent_st.equals("11")){%>
                <tr> 
                    <td class=title>비상연락처</td>
                    <td  colspan='5'> 
                      <input type="hidden" name="mgr_st2" value="2">
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 성명:&nbsp; 
                      <input type="text" name="mgr_nm2" value="" class=text size="10">
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 연락처:&nbsp; 
                      <input type="text" name="m_tel2" value="" size="15" class=text>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 관계:&nbsp; 
                      <input type="text" name="m_etc2" value="" size="58" class=text>
                    </td>
                </tr>
    		    <%}%>
    		    <%if(rent_st.equals("10")){%>
                <tr>
                    <td class=title>보험연령</td>
                    <td colspan='5'>
                      &nbsp;<input type="text" name="d_car_ins_age" size="20" class=whitetext>
                        <input type="hidden" name="d_car_ins_age_cd" value="" id="age_scp_2"></td>
                </tr>    		    
    		    <%}%>
            </table>
        </td>
    </tr>	
    <input type='hidden' name='c_zip' value=''>				
    <input type='hidden' name='c_addr' value=''>	
    <input type='hidden' name='c_lic_no' value=''>				
    <input type='hidden' name='c_lic_st' value=''>	
    <input type='hidden' name='c_tel' value=''>				
    <input type='hidden' name='c_m_tel' value=''>		
    <%}else if(rent_st.equals("4") || rent_st.equals("5")){%>
    <input type='hidden' name='c_firm_nm' value='(주)아마존카'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>구분</td>
                    <td width=15%> 
                      &nbsp;
					  <select name='cust_st'>
                        <option value='4'>직원</option>
                      </select>
					  <!--					  
					  <input type='hidden' name='cust_st' value='4'>
                      <input type="text" name="c_cust_st" value="직원" size="15" class=whitetext>
					  -->
                    </td>
                    <td class=title width=10%>성명</td>
                    <td width=16%> 
                      &nbsp;<select name='c_cust_nm' onChange='javascript:user_select()'>
                        <option value="">==선택==</option>			  
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                    <td class=title width=10%>영업소명</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="c_brch_nm" value="" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>부서명</td>
                    <td width=14%> 
                      &nbsp;<input type="text" name="c_dept_nm" value="" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>운전면허번호</td>
                    <td> 
                      &nbsp;<input type="text" name="c_lic_no" value="" size="16" class=whitetext onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                    </td>
                    <td class=title>면허종류</td>
                    <td> 
                      &nbsp;<input type="text" name="c_lic_st" value="" size="15" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title>전화번호</td>
                    <td> 
                      &nbsp;<input type="text" name="c_tel" value="" class=whitetext size="15">
                    </td>
                    <td class=title>휴대폰</td>
                    <td> 
                      &nbsp;<input type="text" name="c_m_tel" value="" size="15" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}else{%>
    <!--<input type='hidden' name='c_cust_st' value='5'>-->
    <input type='hidden' name='c_cust_nm' value=''>
    <input type='hidden' name='c_firm_nm' value=''>	
    <input type='hidden' name='c_ssn' value=''>
    <input type='hidden' name='c_enp_no' value=''>
    <input type='hidden' name='c_lic_no' value=''>				
    <input type='hidden' name='c_lic_st' value=''>
    <input type='hidden' name='c_zip' value=''>				
    <input type='hidden' name='c_addr' value=''>	
    
	<%}%>	
	<tr>
	    <td class=h></td>
	</tr>
    <tr id=tr_gua style="display:<%if(rent_st.equals("1") ){%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연대보증인</span></td>
    </tr>
    <tr id=tr_gua1 style="display:<%if(rent_st.equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>보증여부</td>
                    <td> 
                      &nbsp;<select name="gua_st" onchange="javascript:gua_display()">
                        <option value="">==선택==</option>
                        <option value="1">입보</option>
                        <option value="2">면제</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_gua2 style='display:none'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>성명</td>
                    <td width=15%> 
                      &nbsp;<input type="hidden" name="mgr_st3" value="3">
                      <input type="text" name="mgr_nm3" value="" size="15" class=text>
                    </td>
                    <td class=title width=10%>생년월일</td>
                    <td width=16%> 
                      &nbsp;<input type="text" name="m_ssn3" value="" size="14" maxlength='8' class=text onBlur='javscript:this.value = ChangeSsn(this.value);'>
                    </td>
                    <td class=title width=10%>전화번호</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="m_tel3" value="" size="15" class=text>
                    </td>
                    <td class=title width=10%>계약자와의 관계</td>
                    <td width=14%> 
                      &nbsp;<input type="text" name="m_etc3" value="" size="15" class=text>
                    </td>
                </tr>
				<script>
					function openDaumPostcode3() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('m_zip3').value = data.zonecode;
								document.getElementById('m_addr3').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>
                <tr> 
                    <td class=title>주소</td>
                    <td colspan=7> 
					<input type="text" name='m_zip3' id="m_zip3" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode3()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='m_addr3' id="m_addr3" size="100">
                      </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_gua3 style='display:none'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>면제사유</td>
                    <td> 
                      &nbsp;<input type="text" name="gua_cau" value="" size="109" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%if(rent_st.equals("2")){%>
	<tr>
	    <td class=h></td>
	</tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비대차</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="10%" style='height:38'>정비공장명 <a href="javascript:serv_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a></td>
                    <td width="21%"> 
                      &nbsp;<input type="hidden" name="serv_id" value="">
                      <input type="text" name="off_nm" value="" size="25" class=whitetext>
                    </td>
                    <td class=title width="10%">정비차량번호</td>
                    <td width="20%"> 
                      &nbsp;<input type="text" name="car_no" value="" size="15" class=whitetext>
                    </td>
                    <td class=title width="10%">차종</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="car_nm" size="20" class=whitetext>
                    </td>
                </tr>
                <tr>
                    <td class=title>보험연령</td>
                    <td colspan='5'>
                      &nbsp;<input type="text" name="d_car_ins_age" size="20" class=whitetext>
                        <input type="hidden" name="d_car_ins_age_cd" value=""></td>
                </tr>
            </table>
        </td>
    </tr>	
	<%}else if(rent_st.equals("3")){%>	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고대차</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10% style='height:37'>정비공장명 <a href="javascript:accid_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a></td>
                    <td width=21%> 
                      &nbsp;<input type="hidden" name="accid_id" value="">
                      <input type="text" name="off_nm" value="" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%>피해차량번호</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="car_no" value="" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>차종</td>
                    <td width=29%>
                      &nbsp;<input type="text" name="car_nm" value="" size="20" class=whitetext>
                    </td>
                </tr>
                  <tr> 
                    <td class=title width=10%>검사유효기간</td>
                    <td width=23% colspan="1">&nbsp;
                    	<input type="text" id="serv_maint_st_dt" name="serv_maint_st_dt"  size="8" class=whitetext>~&nbsp;
                    	<input type="text" id="serv_maint_end_dt" name="serv_maint_end_dt"  size="8"  class=whitetext>
                    </td>
                    <td class=title>차령만료일</td>
                    <td>&nbsp;
                    	<input type="text" id="serv_car_end_dt" name="serv_car_end_dt"  size="8" class=whitetext>
                    </td>
                    <td class=title>점검유효기간</td>
                    <td colspan="1">&nbsp;
                    	<input type="text" id="serv_test_st_dt" name="serv_test_st_dt"  size="8" class=whitetext>~&nbsp;
                    	<input type="text" id="serv_test_end_dt" name="serv_test_end_dt"  size="8" class=whitetext>
                    </td>
                </tr>       
                <tr> 
                    <td class=title> 접수번호</td>
                    <td> 
                      &nbsp;<input type="text" name="our_num" value="" size="25" class=whitetext>
                    </td>
                    <td class=title>가해자보험사</td>
                    <td> 
                      &nbsp;<input type="text" name="ins_nm" value="" size="15" class=whitetext>
                    </td>
                    <td class=title>담당자</td>
                    <td>
                      &nbsp;<input type="text" name="ins_mng_nm" value="" size="20" class=whitetext>
                    </td>
                </tr>
                <tr>
                    <td class=title>보험연령</td>
                    <td colspan='5'>
                      &nbsp;<input type="text" name="d_car_ins_age" size="20" class=whitetext  >
                        <input type="hidden" name="d_car_ins_age_cd" value="" id="age_scp_2"></td>
                </tr>                
            </table>
        </td>
    </tr>
	<%}else if(rent_st.equals("9")){%>	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험대차</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title> 접수번호</td>
                    <td> 
                      &nbsp;<input type="text" name="ins_num" value="" size="15" class=text>
                    </td>
                    <td class=title>보험사</td>
                    <td colspan="5"> 
                      &nbsp;<select name='ins_com_id'>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>"><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>담당자</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="ins_nm" size="14" class=text maxlength="10" >
                    </td>
                    <td class=title width=10%>연락처Ⅰ</td>
                    <td width=16%> 
                      &nbsp;<input type="text" name="ins_tel" size="13" class=text maxlength="15" >
                    </td>
                    <td class=title width=10%>연락처Ⅱ</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="ins_tel2" size="13" class=text maxlength="15" >
                    </td>
                    <td class=title width=10%>팩스</td>
                    <td width=14%> 
                      &nbsp;<input type="text" name="ins_fax" size="13" class=text maxlength="15" >
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}else if(rent_st.equals("6")){%>		
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정비</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10% style='height:37'>정비공장명 <a href="javascript:serv_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a></td>
                    <td width=41%> 
                      &nbsp;<input type="hidden" name="serv_id" value="">
                      <input type="text" name="off_nm" value="" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%> 정비일자</td>
                    <td width=39%>
                      &nbsp;<input type="text" name="serv_dt" value="" size="12" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>		
	<%}else if(rent_st.equals("7")){%>				
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정검</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>검사유효기간</td>
                    <td width=90%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}else if(rent_st.equals("8")){%>		
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고수리</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10% style='height:37'>정비공장명 <a href="javascript:accid_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a></td>
                    <td width=21%> 
                      &nbsp;<input type="hidden" name="accid_id" value="">
                      <input type="text" name="off_nm" value="" size="30" class=text>
                    </td>
                    <td class=title width=10%>사고일자</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="accid_dt" value="" size="15" class=text>
                    </td>
                    <td class=title width=10%>담당자</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="accid_mng_nm" value="" size="20" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title> 사고내용</td>
                    <td colspan="5"> 
                      &nbsp;<input type="text" name="accid_cont" value="" size="100" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>		
	<%}%>
	<tr><td class=h></td></tr>					
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약정보</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="rent_s_cd" value="" size="10" class=whitetext>
                    </td>
                    <td class=title width=10%>계약일자</td>
                    <td width=16%> 
                      &nbsp;<input type="text" name="rent_dt" value="<%=AddUtil.getDate()%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>영업소</td>
                    <td width=15%> 
                    
                      &nbsp;<select name='s_brch_id'>
                        <option value=''>전체</option>
                        <%if(brch_size > 0){
        					for (int i = 0 ; i < brch_size ; i++){
        						Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%= branch.get("BR_ID") %>' <%if(br_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width=10% class=title>담당자</td>
                    <td width=14%> 
                      &nbsp;<select name='bus_id'>
                        <option value="">미지정</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
                
                <script>
                function checkClient_st(client_st){
                	if(client_st =='법인' && parseInt(<%=ej_bean.getSh_code()%>)>1999999 && parseInt(<%=ej_bean.getSh_code()%>)<7000000){
	                		$('#com_emp_yn_td').show();
	                }else if(client_st =='법인' && parseInt(<%=ej_bean.getSh_code()%>)>1999 && parseInt(<%=ej_bean.getSh_code()%>)<7000){
	                		$('#com_emp_yn_td').show();
	                }else{
	                	$('#com_emp_yn_td').hide();
	                }
                }
               	
                </script>
                 
              <tr id="com_emp_yn_td" style="display:none;">
                <td class=title>임직원운전한정특약</td>
                    <td colspan="7"> 
                   		<% 
                   			String com_emp_yn = "Y";
                    		if(cont_size > 0){
						  		for(int i = 0 ; i < cont_size ; i++){
						    			Hashtable reservs = (Hashtable)conts.elementAt(i);
						    			if(String.valueOf(reservs.get("COM_EMP_YN")).equals("N")){
						    				com_emp_yn = "N";
										}
									}
								}
                  		%>
						 &nbsp;<select name='com_emp_yn' id='com_emp_yn' style="font-weight:bold;color: black;">
							<option value="Y" id="com_emp_y"<%if(com_emp_yn.equals("Y")){%> selected <%}%>>가입</option>
							<option value="N" id="com_emp_n" <%if(com_emp_yn.equals("N")){%> selected <%}%>>미가입</option>
						</select>
						 &nbsp;&nbsp;※  주의사항 :
                     	 <input type="text" name="m_etc2" value="신차계약(본 계약)의 보험 선택이 임직원운정한정특약 가입이면 가입으로, 미가입이면 미가입으로 선택" size="120" class=text  readonly="readonly" style="font-weight:bold;border:none;">
						
                    </td>  
                </tr>
                <tr> 
                    <td class=title>약정기간</td>
                    <td colspan="7"> 
                      &nbsp;<input type="text" name="rent_start_dt" id="rent_start_dt" value="<%=AddUtil.ChangeDate2(rent_start_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'>
                      <select name="rent_start_dt_h" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<=24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="rent_start_dt_s" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                      ~ 
                      <input type="text" name="rent_end_dt" id="rent_end_dt" value="<%=AddUtil.ChangeDate2(rent_end_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'>
                      <select name="rent_end_dt_h" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<=24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%//if(i == 24) out.println("selected");%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="rent_end_dt_s" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                      
                      ( 
                      <input type="text" name="rent_hour" value="0" size="4" class=text>
                      시간 
                      <input type="text" name="rent_days" value="<%=rent_days%>" size="4" class=text>
                      일
                      <input type="text" name="rent_months" value="<%=rent_months%>" size="4" class=text>
                      개월 )
                      
                    </td>         
                </tr>
                <tr> 
                    <td class=title>보험 변경 기준일</td>
                    <td colspan="7"> 
                      &nbsp;<input type="text" name="ins_change_std_dt" id="ins_change_std_dt" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();' readonly>
					  <input type="checkbox" id="ins_change_flag" name="ins_change_flag" style="margin-left:90px;"><span>보험 변경 없음</span>&nbsp;&nbsp;<span style="color: red;font-weight: bold;">* 계약한 차량이 21세이지만 실제 운전자가 21세가 아닐경우 체크</span> 
					  <input type="hidden" id="ins_change_flag_input" name="ins_change_flag_input"/> 
                </tr>
                <tr> 
                    <td class=title>관리담당자</td>
                    <td colspan="7"> 
                      &nbsp;<input type='hidden' name='mng_nm' value=''>
                      <input type="radio" name="mng_st" value="1" <%if(!user_bean.getLoan_st().equals("1")){%>checked<%}%>>
                      관리지정자 
                      <input type="radio" name="mng_st" value="2" <%if(user_bean.getLoan_st().equals("1")){%>checked<%}%>>
                      영업자본인                       
                    </td>
                </tr>		                
                <tr> 
                    <td class=title>기타 특이사항</td>
                    <td colspan="7"> 
                      &nbsp;<textarea name="etc" cols="110" rows="3" class=default></textarea>
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차/반차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>배차예정일시</td>
                    <td width=41%> 
                      &nbsp;<input type="text" name="deli_plan_dt" value="<%=AddUtil.ChangeDate2(rent_start_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="deli_plan_dt_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="deli_plan_dt_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title width=10%>배차위치</td>
                    <td width=39%> 
                     &nbsp;<input type="text" name="deli_loc" value="" size="60" class=text>
                    </td>
                </tr>
    		    <input type='hidden' name="deli_dt">
    		    <input type='hidden' name="deli_dt_h">
    		    <input type='hidden' name="deli_dt_s">
    		    <input type='hidden' name="deli_mng_id">
                <tr> 
                    <td class=title>반차예정일시</td>
                    <td> 
                      &nbsp;<input type="text" name="ret_plan_dt" value="<%=AddUtil.ChangeDate2(rent_end_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="ret_plan_dt_h">
                        <%for(int i=0; i<=24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%//if(i == 24) out.println("selected");%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="ret_plan_dt_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>반차위치</td>
                    <td> 
                      &nbsp;<input type="text" name="ret_loc" value="" size="60" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_fee style="display:<%if(rent_st.equals("1") || rent_st.equals("9")){%>''<%}else{%>none<%}%>"> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금</span>
            <%if(rent_st.equals("1") || rent_st.equals("9")){%>&nbsp;&nbsp;<font color="red">※ 정상대여료는 대여기간 동안의 <b>총대여요금</b>입니다.</font><%}%>
        </td>
    </tr>
    <tr id=tr_fee style="display:<%if(rent_st.equals("1") || rent_st.equals("9") ){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>세금계산서</td>
                    <td width=15%> 
                      &nbsp;<select name="tax_yn">
                        <option value="">==선택==</option>			  
                        <option value="Y">발행</option>
                        <option value="N">미발행</option>
                      </select>
                    </td>
                    <td class=title width=10%>선택보험</td>
                    <td width=30%> 
                      &nbsp;<select name="ins_yn">
                        <option value="">==선택==</option>			  
                        <option value="Y">가입</option>
                        <option value="N">미가입</option>
                      </select>
                      (면책금 : <input type='text' size='12' maxlength='7' name='car_ja' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			원)</td>
                    <td class=title width=10%>휴차보상료</td>
                    <td> 
                      &nbsp;<select name="my_accid_yn">
                        <option value="">==선택==</option>			  
                        <option value="Y">고객부담</option>
                        <option value="N">면제</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>결제방법</td>
                    <td> 
                      &nbsp;<select name="paid_way" onchange="javascript:paid_way_display();">
                        <option value="">==선택==</option>			  
                        <option value="1">선불</option>
                        <option value="2">후불</option>
                      </select>
                    </td>
                    <td class=title>결제수단</td>
                    <td >
        			    <table border="0" width="100%">
                            		<tr>
            				    <td>
                	                	<select name="paid_st" onchange="javascript:paid_display();">
                    	              		<option value="">==선택==</option>			  
                        	          	<option value="1">현금</option>
                            	      		<option value="2">신용카드</option>
                            	      		<option value="3">자동이체</option>
                            	      		<option value="4">무통장입금</option>
                	                	</select>				  
                	                    </td>				
            				    <td id=td_paid style='display:none'>
            				      <!--
            				      ( 카드NO. : 
            		                	<input type="text" name="card_no" value="" size="30" class=text>
            	                    	      )
            	                    	      -->
            				   </td>				   
                                	   <td align="right">
                                	   	
                                	   </td>
            				</tr>
        			    </table>
                    </td>
                    <td class=title width=10%>GPS</td>
                    <td > 
                      &nbsp;<select name="gps_yn">
                        <option value="">==선택==</option>			  
                        <option value="Y">있음</option>
                        <option value="N">>없음</option>
                      </select>
                    </td>  
                </tr>
                <tr> 
                    <td class=title>주유량</td>
                    <td> 
                      &nbsp;<select name="oil_st">
                        <option value="">==선택==</option>			  
                        <option value="1">1칸</option>
                        <option value="2">2칸</option>
                        <option value="3">3칸</option>
                        <option value="f">full</option>
                      </select>
                    </td>   
                    <td class=title>네비게이션</td>
                    <td colspan="3"> 
                      &nbsp;<select name="navi_yn" onchange="javascript:navi_yn_display();">
                        <option value="">==선택==</option>			  
                        <option value="Y">있음</option>
                        <option value="N">없음</option>
                        </select>
                        <font color=red>* 주차장에서 네비게이션 재고 반드시 확인하세요. </font>
             
                    </td>
                   
                </tr>          
                <tr> 
                   <td class=title width=10%>배차주행거리</td>
                    <td> 
                      <input type="text" name="dist_km" value="<%=AddUtil.parseDecimal(today_dist)%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      km
                    </td>                                     
                                
                    <td class=title>탁송요청</td>
                    <td colspan='3'> 
                      &nbsp;<select name="cons_yn">
                        <option value="">==선택==</option>			  
                        <option value="Y">있음</option>
                        <option value="N">없음</option>
                      </select>
                      &nbsp; 탁송구간 : 
                      <select name="cmp_app" onchange="javascript:cons_yn_display();">
        			    <option value="">선택</option>
        				<%for(int i = 0 ; i < c_size2 ; i++){
        					CodeBean code22 = codes2[i];	%>
        				<option value='<%=code22.getNm_cd()%>'><%= code22.getNm()%></option>
        				<%}%>
          			  </select>
                    </td>                
                </tr>    
               <tr> 
                   <td class=title width=10%>특이사항</td>
                    <td colspan='5'>&nbsp;
                      <textarea name="fee_etc" cols="110" rows="3" class=default></textarea>                      
                    </td>                                           
                </tr>  
                <tr> 
                    <td class=title>자동이체</td>
                    <td  colspan='5'>&nbsp; 
                      <a href='javascript:search_cms()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
                      &nbsp;<img src=/acar/images/center/arrow.gif> 은행:&nbsp; 
                      <select name='cms_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        				for(int i = 0 ; i < bank_size ; i++){
        					CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>'><%=bank.getNm()%></option>
                        <%		}
        			}%>
                      </select>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 계좌번호:&nbsp; 
                      <input type='text' name='cms_acc_no' value='' size='20' class='text'>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 예금주:&nbsp; 
                      <input type='text' name='cms_dep_nm' value='' size='20' class='text'>
                    </td>
                </tr>                 
                
            </table>
        </td>
    </tr>	
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_fee1 style="display:<%if(rent_st.equals("1") || rent_st.equals("9")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td rowspan="2" class=title>구분</td>
                    <td colspan="6" class=title>월대여료&nbsp;&nbsp;<!--단기대여/보험대차/월렌트  자동계산--><a href="javascript:getFee_sam();"><img src=/acar/images/center/button_in_jdgs.gif align=absmiddle border=0></a></td>
                    <td width="11%" class=title>대여료총액</td>
                    <td width="8%" rowspan="2" class=title>배차료</td>
                    <td width="8%" rowspan="2" class=title>반차료</td>
                    <td width="11%" rowspan="2" class=title>총결재금액</td>
                </tr>
                <tr>
                  <td width="10%" class=title>정상대여료</td>
                  <td width="8%" class=title>D/C</td>
                  <td width="8%" class=title>네비게이션</td>
                  <td width="8%" class=title>기타</td>                  
                  <td width="8%" class=title>선택보험료</td>                  
                  <td width="10%" class=title>합계</td>                  
                  <td class=title>
                  	<input type="text" name="v_rent_months" value="<%=rent_months%>" size="1" class=whitenum>
                      	개월
                      	<input type="text" name="v_rent_days" value="<%=rent_days%>" size="2" class=whitenum>
                      	일
                  </td>                  
                </tr>
                <tr>                     
                    <td class=title width="10%">공급가</td>
                    <td align="center"> 
                      <input type="text" name="inv_s_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="dc_s_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="navi_s_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="etc_s_amt" value="" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_s_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="fee_s_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">
                      <input type="text" name="cons1_s_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
  		      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>부가세</td>
                    <td align="center"> 
                      <input type="text" name="inv_v_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="dc_v_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="navi_v_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="etc_v_amt" value="" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_v_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">
                      <input type="text" name="cons1_v_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>                      
                </tr>
                <tr> 
                    <td class=title>합계</td>
                    <td align="center"> 
                      <input type="text" name="inv_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="dc_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="navi_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="etc_amt" value="" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="ins_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">
                      <input type="text" name="cons1_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>                      
                </tr>
                <input type='hidden' name="m2_dc_amt" value="">
                <input type='hidden' name="m3_dc_amt" value="">
                <!--      
                <tr> 
                    <td class=title>총결제금액</td>
                    <td align="center"> 
                      &nbsp;<input type="text" name="rent_tot_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원
                      </td>
                    <td colspan="9"> 
                      &nbsp;
                      2회차대여료 할인금액 <input type="text" name="m2_dc_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 / 
                      3회차대여료 할인금액 <input type="text" name="m3_dc_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원
                    </td>  
                </tr>
                -->
                <tr> 
                    <td class=title>최초결제금액</td>
                    <td align="center"> 
                      &nbsp;<input type="text" name="f_rent_tot_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td class=title>최초결제방식</td>
                    <td colspan="8">&nbsp; 
                      <select name="f_paid_way" onchange="javascript:f_paid_way_display();">
                        <option value="">==선택==</option>			  
                        <option value="1">1개월치</option>
                        <option value="2">총액</option>
                      </select>
                      &nbsp; 반차료
                      <select name="f_paid_way2" onchange="javascript:f_paid_way_display();">
                        <option value="">==선택==</option>
                        <option value="1">포함</option>
                        <option value="2">미포함</option>
                      </select>
                      </td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr id=tr_pre style='display:none'>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선수금/보증금 스케줄</span></td>
    </tr>
    <tr id=tr_pre1 style='display:none'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title width=20%>항목</td>
                    <td class=title width=20%>입금방식</td>
                    <td class=title width=20%>입금예정일</td>
                    <td class=title width=20%>청구금액</td>                    
                    <td class=title width=20%>잔액</td>
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st0" value="6">
        	      <input type="hidden" name="rent_s_amt0" value="0">
        	      <input type="hidden" name="rent_v_amt0" value="0">
        	      <input type="hidden" name="rest_amt0" value="0">
                      보증금</td>
                    <td align="center"> 
                      <select name="paid_st0">
                        <option value="">==선택==</option>			  			  
                        <option value="1" selected>현금</option>
                        <!--<option value="2">신용카드</option>-->
                        <!--<option value="3">자동이체</option>-->
                        <option value="4">무통장입금</option>			
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=text name="pay_dt0" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=num name="pay_amt0" value="" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      원</td>
                    <td align="center"> 
                      계약종료후 환불할 보증금
                    </td>
                </tr>                
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st1" value="1">
        	      <input type="hidden" name="rent_s_amt1" value="0">
        	      <input type="hidden" name="rent_v_amt1" value="0">
                      예약금</td>
                    <td align="center"> 
                      <select name="paid_st1">
                        <option value="">==선택==</option>			  			  
                        <option value="1">현금</option>
                        <!--<option value="2">신용카드</option>-->
                        <!--<option value="3">자동이체</option>-->
                        <option value="4">무통장입금</option>			
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=text name="pay_dt1" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=num name="pay_amt1" value="" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="rest_amt1" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st2" value="2">
        	      <input type="hidden" name="rent_s_amt2" value="0">
        	      <input type="hidden" name="rent_v_amt2" value="0">
                      선수대여료</td>
                    <td align="center"> 
                      <select name="paid_st2">
                        <option value="">==선택==</option>			  			  
                        <option value="1">현금</option>
                        <option value="2">신용카드</option>
                        <option value="3">자동이체</option>
                        <option value="4">무통장입금</option>			
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=text name="pay_dt2" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=num name="pay_amt2" value="" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="rest_amt2" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>                
                <%for(int i=3; i<7; i++){ %>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st<%=i%>" value="3">
        	      <input type="hidden" name="rent_s_amt<%=i%>" value="0">
        	      <input type="hidden" name="rent_v_amt<%=i%>" value="0">
                      대여료</td>
                    <td align="center"> 
                      <select name="paid_st<%=i%>">
                        <option value="">==선택==</option>			  			  
                        <option value="1" selected>현금</option>
                        <option value="2">신용카드</option>
                        <option value="3">자동이체</option>
                        <option value="4">무통장입금</option>			
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=text name="pay_dt<%=i%>" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=num name="pay_amt<%=i%>" value="" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="rest_amt<%=i%>" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>                               
                <%}%>
                <tr> 
                    <td class=title colspan='3'>합계</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="total_pay_amt" value="">
                      원</td>
                    <td align="center">&nbsp;</td>
                </tr>                      
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td width="30%"></td>
        <td align="right" width="70%">
        &nbsp;<a href='javascript:save();'><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a> 
    </tr>    
	<tr>
	  <td colspan="2">* 예약차량에 한해서 배차예정일시로 부터 24시간이 경과되는 시점에도 예약상태라면 자동취소되니 업무에 참고하십시오.</td>
	</tr>
	<%if(rent_cnt>0){%>
	<tr>
	  <td colspan="2"><font color='red'><b>* 재리스 계약확정되어 장기대기로 예약되어 있는 차량입니다.</b></font></td>
	</tr>
	<%}else{%>
	<%	if(use_cnt>0){%>
	<tr>
	  <td colspan="2"><font color='red'><b>* 현재 예약 혹은 배차중인 차량입니다.</b></font></td>
	</tr>
	<%	}%>
	<%}%>
	
<input type='hidden' name='use_cnt' value='<%=use_cnt%>'>
<input type='hidden' name='rent_cnt' value='<%=rent_cnt%>'>	

</table>
</form>
<script language='javascript'>
<!--	
	
	var fm = document.form1;	

	getRentTime();
	
		
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

