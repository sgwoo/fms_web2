<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*, acar.cont.*, acar.estimate_mng.*, acar.user_mng.*, acar.cont.*, acar.insur.*"%>
<jsp:useBean id="rs_db" class="acar.res_search.ResSearchDatabase" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");	
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");		
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
	String ins_st 		= request.getParameter("ins_st")	==null?"":request.getParameter("ins_st");
	String ins_st2 		= request.getParameter("ins_st2")	==null?"":request.getParameter("ins_st2");
	
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	InsDatabase 	ai_db 	= InsDatabase.getInstance();
	
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "05", "01");
	
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String disabled = "disabled";
	String white 	= "white";
	String readonly = "readonly";
	if(mode.equals("u")){
		disabled 	= "";
		white 		= "";
		readonly 	= "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트
	int user_size = users.size();	
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003"); 
	int bank_size = banks.length;
	

	//보험사 리스트
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
	//단기관리자-연대보증인
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(s_cd, "4");
	//단기대여정보
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	//선수금정보
	ScdRentBean sr_bean0 = rs_db.getScdRentCase(s_cd, "6");
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	//입금스케줄
	Vector conts = rs_db.getScdRentList(s_cd, "fee");
	int cont_size = conts.size();	
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//신용카드결제
	Vector cards = rs_db.getRentContCardList(s_cd);
	int card_size = cards.size();
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	
	if(rf_bean.getFee_s_amt()>0 && rf_bean.getInv_s_amt()==0){
		rf_bean.setInv_s_amt(rf_bean.getFee_s_amt());
		rf_bean.setInv_v_amt(rf_bean.getFee_v_amt());
	}
	
	//보험정보
	if(ins_st.equals("")) ins_st = ai_db.getInsSt(c_id);
// 	System.out.println("c_id > " + c_id);
// 	System.out.println("ins_st > " + ins_st);
	InsurBean ins = ai_db.getIns(c_id, ins_st);
// 	System.out.println("ins.getAge_scp() > " + ins.getAge_scp());
	String ins_com_nm = ai_db.getInsComNm(c_id);
	// 예약차량 보험 정보
	String rsrv_c_id = String.valueOf(rc_bean.getSub_c_id());
	if(ins_st2.equals("")) ins_st2 = ai_db.getInsSt(rsrv_c_id);
// 	System.out.println("rsrv_c_id > " + rsrv_c_id);
// 	System.out.println("ins_st2 > " + ins_st2);
	InsurBean ins2 = ai_db.getIns(rsrv_c_id, ins_st2);
// 	System.out.println("ins2.getAge_scp() > " + ins2.getAge_scp());
	String ins_com_nm2 = ai_db.getInsComNm(rsrv_c_id);
	
// 	System.out.println(rsrv_c_id);

	String age_scp_1 = ins.getAge_scp();
	String age_scp_2 = ins2.getAge_scp();
	
// 	System.out.println("age_scp_1 > " + age_scp_1);
// 	System.out.println("age_scp_2 > " + age_scp_2);
	
	
	
	//공휴일 정보
		Vector hdays = c_db.getHolidayList();
		int hdaysSize = hdays.size();
		String[] hdaysArray = new String[hdaysSize];
		for (int i = 0 ; i < hdaysSize ; i++){
			Hashtable hday = (Hashtable)hdays.elementAt(i);
//	 		System.out.println(hday.get("HDAY"));
			hdaysArray[i] = (String)hday.get("HDAY");
		}
%>

<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="./jquery-ui-1.12.1/datepicker-ko.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--

	var popObj = null;
var hdaysArray = "<%=Arrays.toString(hdaysArray)%>".replaceAll("[","").replaceAll("]","").split(",");

	//팝업윈도우 열기
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;		
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}		
		popObj.location = theURL;
		popObj.focus();	
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();		
	}			


	//단기대여---------------------------------------------------------------------------------------------------------
	
	//고객 조회
	function cust_select(){
		var fm = document.form1;
		if(fm.mode.value != 'u') return;		
			fm.c_cust_st.value 	= "";
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
			if(fm.rent_st.value == '1'){
				fm.mgr_nm2.value = "";
				fm.m_tel2.value = "";
				fm.m_etc2.value = "";
				fm.mgr_nm1.value = "";
				fm.m_ssn1.value = "";
				fm.m_lic_no1.value = "";
				fm.m_tel1.value = "";
				fm.m_zip1.value = "";
				fm.m_addr1.value = "";				
			}
			if(fm.rent_st.value == '2'){
				fm.serv_id.value = "";
				fm.off_nm.value = "";
				fm.car_no.value = "";
				fm.car_nm.value = "";
			}
			window.open("/acar/res_search/client_s_p.jsp?auth_rw="+fm.auth_rw.value+"&br_id="+fm.br_id.value+"&user_id="+fm.user_id.value+"&rent_st="+fm.rent_st.value+"&from_page=/acar/rent_mng/res_rent_u.jsp", "CLIENT_SEARCH", "left=50, top=50, width=1020, height=700, status=yes, scrollbars=yes");	
	}	
	
	//연대보증인 디스플레이
	function gua_display(){
		var fm = document.form1;
		if(fm.gua_st.options[fm.gua_st.selectedIndex].value == '1'){
			tr_gua2.style.display	= '';			
			tr_gua3.style.display	= 'none';						
			fm.gua_cau.value = '';
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
		if(fm.mode.value != 'u') return;
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
			fm.m_tel1.value 	= fm.c_tel.value;
			fm.m_zip1.value 	= fm.c_zip.value;
			fm.m_addr1.value 	= fm.c_addr.value;			
		}else{
			fm.mgr_nm1.value 	= '';
			fm.m_ssn1.value 	= '';
			fm.m_lic_no1.value 	= '';
			fm.m_tel1.value 	= '';
			fm.m_zip1.value 	= '';
			fm.m_addr1.value 	= '';					
		}
	}
		
	//대여일수 구하기
	function getRentTime() {
	
				
		var fm = document.form1;	
		if(fm.mode.value != 'u') return;		
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
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
				fm.action = "/acar/res_search/get_dt_nodisplay.jsp";
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
				
				<%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>				
				getFee_sam();								
				<%}%>
				
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
					
		return;
	
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;	
		if(obj==fm.rent_start_dt_h){
			fm.rent_end_dt_h[fm.rent_start_dt_h.selectedIndex].selected = true;
			fm.deli_plan_dt_h[fm.rent_start_dt_h.selectedIndex].selected = true;		
		}else if(obj==fm.rent_start_dt_s){
			fm.rent_end_dt_s[fm.rent_start_dt_s.selectedIndex].selected = true;
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
		if(fm.mode.value != 'u') return;		
		fm.action = '/acar/res_search/short_fee_nodisplay.jsp';		
		<%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
		fm.action = '/acar/res_search/short_fee_nodisplay2.jsp';
		<%}%>
		fm.target = 'i_no';
		fm.submit();
	}
	
	//금액 셋팅	
	function set_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;	
		if(fm.mode.value != 'u') return;	
		
		<%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
		
		if(obj==fm.fee_s_amt){
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_v_amt){
			fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_amt){
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));		
		}else if(obj==fm.cons1_s_amt){
			fm.cons1_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) * 0.1) ;
			fm.cons1_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));
		}else if(obj==fm.cons1_v_amt){
			fm.cons1_s_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_v_amt.value)) / 0.1) ;
			fm.cons1_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));
		}else if(obj==fm.cons1_amt){
			fm.cons1_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.cons1_amt.value))));
			fm.cons1_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_amt.value)) - toInt(parseDigit(fm.cons1_s_amt.value)));		
		}else if(obj==fm.cons2_s_amt){
			fm.cons2_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) * 0.1) ;
			fm.cons2_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));
		}else if(obj==fm.cons2_v_amt){
			fm.cons2_s_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_v_amt.value)) / 0.1) ;
			fm.cons2_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));
		}else if(obj==fm.cons2_amt){
			fm.cons2_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.cons2_amt.value))));
			fm.cons2_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_amt.value)) - toInt(parseDigit(fm.cons2_s_amt.value)));			
		}		
		
		<%}else{%>	
		
		if(obj==fm.fee_s_amt){
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
			if(fm.ins_yn.value == 'Y'){
				//fm.ins_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) * 0.1) ;	
			}
		}else if(obj==fm.fee_v_amt){
			fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_amt){
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));		
		}else if(obj==fm.inv_s_amt){
			fm.inv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1) ;
			fm.inv_amt.value = parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));
		}else if(obj==fm.inv_v_amt){
			fm.inv_s_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) / 0.1) ;
			fm.inv_amt.value = parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));
		}else if(obj==fm.inv_amt){
			fm.inv_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));		
		}else if(obj==fm.dc_s_amt){
			fm.dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) * 0.1) ;
			fm.dc_amt.value = parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));
		}else if(obj==fm.dc_v_amt){
			fm.dc_s_amt.value = parseDecimal(toInt(parseDigit(fm.dc_v_amt.value)) / 0.1) ;
			fm.dc_amt.value = parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));
		}else if(obj==fm.dc_amt){
			fm.dc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.dc_amt.value))));
			fm.dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.dc_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)));		
//		}else if(obj==fm.ins_s_amt || obj==fm.ins_v_amt){
//			fm.ins_amt.value = parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)));
		}else if(obj==fm.navi_s_amt){
			fm.navi_v_amt.value = parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) * 0.1) ;
			fm.navi_amt.value = parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value)));
		}else if(obj==fm.navi_v_amt){
			fm.navi_s_amt.value = parseDecimal(toInt(parseDigit(fm.navi_v_amt.value)) / 0.1) ;
			fm.navi_amt.value = parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value)));
		}else if(obj==fm.navi_amt){
			fm.navi_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.navi_amt.value))));
			fm.navi_v_amt.value = parseDecimal(toInt(parseDigit(fm.navi_amt.value)) - toInt(parseDigit(fm.navi_s_amt.value)));		
		}else if(obj==fm.etc_s_amt){
			fm.etc_v_amt.value = parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) * 0.1) ;
			fm.etc_amt.value = parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));
		}else if(obj==fm.etc_v_amt){
			fm.etc_s_amt.value = parseDecimal(toInt(parseDigit(fm.etc_v_amt.value)) / 0.1) ;
			fm.etc_amt.value = parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));
		}else if(obj==fm.etc_amt){
			fm.etc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.etc_amt.value))));
			fm.etc_v_amt.value = parseDecimal(toInt(parseDigit(fm.etc_amt.value)) - toInt(parseDigit(fm.etc_s_amt.value)));		
		}else if(obj==fm.cons1_s_amt){
			fm.cons1_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) * 0.1) ;
			fm.cons1_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));
		}else if(obj==fm.cons1_v_amt){
			fm.cons1_s_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_v_amt.value)) / 0.1) ;
			fm.cons1_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));
		}else if(obj==fm.cons1_amt){
			fm.cons1_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.cons1_amt.value))));
			fm.cons1_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_amt.value)) - toInt(parseDigit(fm.cons1_s_amt.value)));		
		}else if(obj==fm.cons2_s_amt){
			fm.cons2_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) * 0.1) ;
			fm.cons2_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));
		}else if(obj==fm.cons2_v_amt){
			fm.cons2_s_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_v_amt.value)) / 0.1) ;
			fm.cons2_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));
		}else if(obj==fm.cons2_amt){
			fm.cons2_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.cons2_amt.value))));
			fm.cons2_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_amt.value)) - toInt(parseDigit(fm.cons2_s_amt.value)));			
		}		
		
		<%}%>
		
		//총결재금액											
		fm.rent_tot_s_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons2_s_amt.value)) );
		fm.rent_tot_v_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_v_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)) );
		fm.rent_tot_amt.value 	= parseDecimal(	toInt(parseDigit(fm.fee_amt.value))   + toInt(parseDigit(fm.cons1_amt.value))   + toInt(parseDigit(fm.cons2_amt.value))   );
		
	}			

	//금액 셋팅	
	function pay_set_amt(){
		var fm = document.form1;	
		if(fm.mode.value != 'u') return;
				
		fm.rest_amt1.value 	= parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.rent_amt1.value))) ;
		fm.rest_amt2.value 	= parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.rent_amt1.value)) - toInt(parseDigit(fm.rent_amt2.value))) ;
		
		fm.rent_s_amt0.value 	= fm.rent_amt0.value;
		fm.rent_v_amt0.value 	= 0;
		
		fm.rent_s_amt1.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.rent_amt1.value))));
		fm.rent_v_amt1.value 	= parseDecimal(toInt(parseDigit(fm.rent_amt1.value)) - toInt(parseDigit(fm.rent_s_amt1.value)));
		
		fm.rent_s_amt2.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.rent_amt2.value))));
		fm.rent_v_amt2.value 	= parseDecimal(toInt(parseDigit(fm.rent_amt2.value)) - toInt(parseDigit(fm.rent_s_amt2.value)));
		
		fm.scd_total_amt.value  = parseDecimal(toInt(parseDigit(fm.rent_amt1.value)) + toInt(parseDigit(fm.rent_amt2.value)));
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
		if(fm.mode.value != 'u') return;		
			fm.serv_id.value 	= "";
			fm.off_nm.value 	= "";
			if(fm.c_cust_id.value == '' && fm.rent_st.value == '2'){ alert('고객을 선택하십시오.');  return;}
			window.open("/acar/res_search/sub_select_2_s.jsp?c_id="+fm.sub_c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value, "SERV_SEARCH", "left=50, top=50, width=800, height=600, status=yes");
	}	

	
	// 사고대차 ------------------------------------------------------------------------------------------------
	
	//사고 조회
	function accid_select(){
		var fm = document.form1;
		if(fm.mode.value != 'u') return;		
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
			window.open("/acar/res_search/sub_select_3_a.jsp?c_id="+fm.sub_c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&user_id="+fm.user_id.value, "ACCID_SEARCH", "left=50, top=50, width=800, height=300, status=yes");
	}	


	// 대여 및 업무지원 ------------------------------------------------------------------------------------------------
	
	//직원 조회
	function user_select(){
		var fm = document.form1;
		if(fm.mode.value != 'u') return;		
		fm.c_brch_nm.value 	= "";
		fm.c_dept_nm.value 	= "";
		fm.c_lic_no.value	= "";
		fm.c_lic_st.value 	= "";
		fm.c_tel.value	 	= "";
		fm.c_m_tel.value 	= "";
		fm.target='i_no';
		fm.action = '/acar/res_search/sub_select_4_u.jsp?user_id='+fm.c_cust_nm.options[fm.c_cust_nm.selectedIndex].value;
		fm.submit();
	}	

	
	// 차량점검 ------------------------------------------------------------------------------------------------
	
	//정기점검 조회
	function maint_select(){
		var fm = document.form1;
		if(fm.mode.value != 'u') return;		
			fm.seq_no.value 	= "";
			fm.che_kd.value 	= "";
			fm.che_no.value		= "";
			fm.che_comp.value	= "";
			window.open("/acar/res_search/sub_select_5_m.jsp?c_id="+fm.c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value, "ACCID_SEARCH", "left=50, top=50, width=800, height=300, status=yes");
	}	

	
	// 기타 ------------------------------------------------------------------------------------------------
	
	//차량위치 조회
	function car_map(){
/*		var fm = document.form1;
		var SUBWIN="car_map.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarMap", "left=50, top=50, width=730, height=530, scrollbars=yes");
*/		
	}

	//우편번호 조회
	function search_zip(str){
		var fm = document.form1;
		if(fm.mode.value != 'u') return;	
		window.open("/acar/res_search/zip_s.jsp?str="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}	

	//차량예약현황 조회
	function car_reserve(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserve", "left=50, top=50, width=820, height=400, scrollbars=yes");
	}

	//동급차량예약현황 조회
	function car_reserve2(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve_dk.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserveDK", "left=50, top=50, width=820, height=400, scrollbars=yes");
	}

	//정비업체 조회
	function SearchServOff(){
		var fm = document.form1;
		if(fm.mode.value != 'u') return;		
		var serv_off_nm = "";
		var keyValue = event.keyCode;
		if (keyValue =='13'){
			serv_off_nm = fm.cust_nm.value;
			var SUBWIN="/acar/res_search/service_office_open.jsp?off_nm=" +serv_off_nm;	
			window.open(SUBWIN, "ServOff", "left=100, top=100, width=230, height=250, scrollbars=yes");
		}
	}
	
	//금액 셋팅	
/*	function set_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;	
		if(obj==fm.rent_s_amt){
			if(fm.rent_days.value != '' && fm.rent_days.value.indexOf("일") != -1){
				var rent_day = fm.rent_days.value;
				var days = rent_day.substring(0,rent_day.indexOf("일"));
//				fm.one_w_amt.value = parseDecimal(toInt(parseDigit(fm.rent_s_amt.value)) / toInt(days) );
			}else{
//				fm.one_w_amt.value = fm.rent_s_amt.value;
			}
			fm.paid_cnt.focus();
		}else if(obj==fm.sale_rat){
			fm.sale_r_amt.value = parseDecimal(toInt(parseDigit(fm.rent_s_amt.value)) * toInt(fm.sale_rat.value)/100 );		
		}else if(obj==fm.res_g_amt){
			fm.rent_amt.value = parseDecimal(toInt(parseDigit(fm.rent_s_amt.value)) - toInt(parseDigit(fm.sale_r_amt.value)) - toInt(parseDigit(fm.res_g_amt.value)) );		
		}else if(obj==fm.rec_amt1){
			fm.jan_amt1.value = parseDecimal(toInt(parseDigit(fm.rent_s_amt.value)) - toInt(parseDigit(fm.sale_r_amt.value)) - toInt(parseDigit(fm.rec_amt1.value)) );				
		}else if(obj==fm.rec_amt2){
			fm.jan_amt2.value = parseDecimal(toInt(parseDigit(fm.jan_amt1.value)) - toInt(parseDigit(fm.rec_amt2.value)) );				
		}else if(obj==fm.rec_dt1){
//			fm.rec_amt1.value = fm.res_g_amt.value;
//			fm.jan_amt1.value = parseDecimal(toInt(parseDigit(fm.rent_s_amt.value)) - toInt(parseDigit(fm.sale_r_amt.value)) - toInt(parseDigit(fm.rec_amt1.value)) );				
		}
	}
*/

	//취소하기
	function all_reset(){
		var fm = document.form1;	
		fm.reset();
	}
	
	//저장하기
	function save(){
		var fm = document.form1;
		
// 		var rent_st = $("#rent_st").val();
		var rent_st = '<%=rent_st%>';
		
		var ins_change_flag = $("#ins_change_flag").is(":checked");
		var ins_change_flag_input = "";
		
		// 21세만 해당
		if(ins_change_flag) {
			ins_change_flag_input = "N"; // 보유차 보험 변경 X
		} else {
			ins_change_flag_input = "Y"; // 보유차 보험 변경 O
		}
		
		$("#ins_change_flag_input").val(ins_change_flag_input);
		
		if(rent_st == "3" || rent_st == "2" || rent_st == "10"){
			if(fm.c_cust_id.value == '') { 
				alert('고객 원계약 정보를 선택하세요.');
				return;
			}
			var age_scp_1 = '<%=age_scp_1%>';
			var age_scp_2 = '<%=age_scp_2%>';
			var reg_ins_change_std_dt = '<%=rc_bean.getIns_change_std_dt()%>';
// 			alert(ins_change_std_dt);
			
			var age1 = 0; // 대여 차량 보험 연령
			var age2 = 0; // 계약 차량 보험 연령
			var rent_start_dt = $("#rent_start_dt").val().replaceAll("-",""); // 약정 기간 시작일
			var rent_end_dt = $("#rent_end_dt").val().replaceAll("-",""); // 약정 기간 종료일
			var ins_change_std_dt = $("#ins_change_std_dt").val().replaceAll("-",""); // 보험 변경 기준일

			if(age_scp_1 == "1") {
				age1 = 21;
			} else if(age_scp_1 == "2") {
				age1 = 26;
			} else if(age_scp_1 == "4") {
				age1 = 24;
			}
			
			if(age_scp_2 == "1") {
				age2 = 21;
			} else if(age_scp_2 == "2") {
				age2 = 26;
			} else if(age_scp_2 == "4") {
				age2 = 24;
			}
			
			if((rent_st == "3" && (age1 > age2)) || (rent_st == "10" && (age1 > age2)) || (rent_st == "2" && (age1 > age2)) ) {
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
				if(ins_change_flag_input == "Y") {
					// 오후 5시 이전인 경우
					if(hours < 17) {
						if(parseInt(ins_change_std_dt) >= parseInt(rent_start_dt)) {
							alert("보험 변경 기준일은 약정 기간의 시작일 보다 빨라야합니다.\n확인 후 다시 저장하세요.");
							return;
						}
						else if(parseInt(ins_change_std_dt) < parseInt(reg_ins_change_std_dt)) {
							alert("보험 변경 기준일은 예약 등록 시 최초 등록한 일자보다 빠를 수 없습니다.\n확인 후 다시 저장하세요.");
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
						} else if(parseInt(ins_change_std_dt) < parseInt(reg_ins_change_std_dt)) {
							alert("보험 변경 기준일은 예약 등록 시 최초 등록한 일자보다 빠를 수 없습니다.\n확인 후 다시 저장하세요.");
							return;
						}  
					}
				}
			}
		}
		
		if(fm.mode.value != 'u'){
			fm.mode.value = 'u';
			fm.action = 'res_rent_u.jsp';
			fm.target = 'd_content';
			fm.submit();
		}else{
			
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
			
			if(fm.c_id.value == ''){ alert('차량선택이 잘못되었습니다\n\n목록에서 선택하십시오'); return; }
			if(fm.rent_st.value == ''){ alert('계약구분이 잘못되었습니다\n\n전페이지에서 선택하십시오'); return; }		
			if(fm.rent_st.value == '1' || fm.rent_st.value == '9' || fm.rent_st.value == '12'){
				if(fm.gua_st.value == ''){ alert('보증 여부를 선택하십시오'); fm.gua_st.focus(); return; }
				if(fm.c_cust_id.value == ''){ alert('고객을 선택하십시오'); return; }
				if(fm.tax_yn.value == ''){ alert('세금계산서 발행 여부를 선택하십시오'); fm.tax_yn.focus(); return; }
				if(fm.ins_yn.value == ''){ alert('선택보험 가입 여부를 선택하십시오'); fm.ins_yn.focus(); return; }
				//if(fm.driver_yn.value == ''){ alert('운전기사 포함 여부를 선택하십시오'); fm.driver_yn.focus(); return; }
				if(fm.paid_way.value == ''){ alert('결제방법을 선택하십시오'); fm.paid_way.focus(); return; }
				if(fm.paid_st.value == ''){ alert('결제수단을 선택하십시오'); fm.paid_st.focus(); return; }
				if(fm.fee_s_amt.value == ''){ alert('정상대여료를 확인하십시오'); fm.fee_s_amt.focus(); return; }
				if(fm.rent_tot_amt.value == ''){ alert('총결제금액을 확인하십시오'); fm.rent_tot_amt.focus(); return; }
				
			}else if(fm.rent_st.value == '2'){
				if(fm.c_cust_id.value == ''){ alert('고객을 선택하십시오'); return; }
			}else if(fm.rent_st.value == '3'){
				if(fm.c_cust_id.value == ''){ alert('고객을 선택하십시오'); return; }
			}else if(fm.rent_st.value == '4' || fm.rent_st.value == '5'){
				if(fm.c_cust_nm.value == ''){ alert('사용자를 선택하십시오'); return; }
			}else if(fm.rent_st.value == '10'){
				if(fm.c_cust_id.value == ''){ alert('고객을 선택하십시오'); return; }
			}
			if(fm.rent_dt.value == ''){ alert('계약일자를 입력하십시오'); fm.rent_dt.focus(); return; }
			if(fm.s_brch_id.value == ''){ alert('영업소를 입력하십시오'); fm.brch_id.focus(); return; }
			if(fm.bus_id.value == ''){ alert('담당자를 입력하십시오'); fm.bus_id.focus(); return; }
			if(fm.rent_start_dt.value == ''){ alert('이용기간 시작일시를 입력하십시오'); fm.rent_start_dt.focus(); return; }
			if(fm.deli_plan_dt.value == ''){ alert('배차예정일시를 입력하십시오'); fm.deli_plan_dt.focus(); return; }
				
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

			if(!confirm('수정하시겠습니까?')){	return;	}
						
			fm.action = 'res_rent_u_a.jsp';
//			fm.target = 'd_content';
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		fm.action = 'res_st_frame_s.jsp';
		if('<%=list_from_page%>' != '') fm.action = '<%=list_from_page%>';
		fm.target = 'd_content';
		fm.submit();				
	}	
	
	
	
	//탁송의뢰등록
	function tint_reg_link(){
		var fm = document.form1;
		var auth_rw 	= fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;						
		var car_mng_id 	= fm.c_id.value;
		var sub_l_cd 	= fm.sub_l_cd.value;
		var sub_c_id 	= fm.sub_c_id.value;
		var rent_st 	= fm.rent_st.value;		
		location = "/fms2/consignment_new/cons_reg_step1.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&car_mng_id="+car_mng_id+"&sub_l_cd="+sub_l_cd+"&sub_c_id="+sub_c_id+"&rent_st="+rent_st;		
	}
	
	//예약시스템 계약서
	function view_scan_res(c_id, s_cd){
		window.open("/acar/rent_mng/res_rent_u_print.jsp?c_id="+c_id+"&s_cd="+s_cd+"&mode=fine_doc", "VIEW_SCAN_RES", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}
	
	

	//스캔등록
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=c_id%>&rent_l_cd=<%=s_cd%>&from_page=/acar/res_stat/res_rent_u.jsp&file_st="+file_st, "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}
	

	//삭제하기
	function remove(seq, st_nm){
		fm = document.form1;
		fm.remove_seq.value = seq;
		if(!confirm(st_nm+" 파일을 삭제하시겠습니까?"))		return;		
		fm.target = "i_no";
		fm.action='reg_scan.jsp';
		fm.submit();
	}	
	
	//스캔관리 보기
	function view_scan(){
		window.open("scan_view.jsp?c_id=<%=c_id%>&s_cd=<%=s_cd%>&from_page=/acar/res_stat/res_rent_u.jsp", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}
	
	//월렌트일때 개월선택시 자동셋팅 20120424
	function rent_end_set_display(){
		var fm = document.form1;		
		fm.target = "i_no";
		fm.action = "/acar/res_search/get_dt_nodisplay.jsp";
		fm.submit();			
	}	
	
	//월렌트 관리담당자 배정
	function mng_id_reg(brch_id){
		var fm = document.form1;
		window.open("about:blank", "MNGID_REG", "left=100, top=10, width=700, height=600, resizable=yes, scrollbars=yes, status=yes");			
		fm.mngid_reg_brch_id.value = brch_id;
		fm.target = 'MNGID_REG';
		fm.action = '/acar/rent_mng/mng_id_reg.jsp';
		fm.submit();							
	}
	
	//카드결제연동번호발송
	function ax_hub_orderno_send(rent_st, tm){
		var fm = document.form1;
		fm.scd_rent_st.value = rent_st;
		fm.scd_tm.value = tm;
		window.open("about:blank", "AX_HUB_ORDER_SEND", "left=100, top=10, width=700, height=500, resizable=yes, scrollbars=yes, status=yes");			
		fm.target = 'AX_HUB_ORDER_SEND';
		fm.action = '/acar/rent_mng/ax_hub_order_send.jsp';
		fm.submit();			
	}
	
	//동일차량견적이력
	function EstiHistory(){
		var fm = document.form1;
		window.open("about:blank", "ESTI_HISTORY", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");			
		fm.target = 'ESTI_HISTORY';
		fm.action = '/acar/rent_mng/rm_esti_history.jsp';
		fm.submit();				
	}	
	
	function RentMemo(s_cd, c_id, user_id){
		var SUBWIN="/acar/con_rent/res_memo_i.jsp?s_cd="+s_cd+"&c_id="+c_id+"&user_id="+user_id;	
		window.open(SUBWIN, "RentMemoDisp", "left=100, top=100, width=580, height=700, scrollbars=yes");
	}	
	
	
	//네비게이션이용액 셋팅
	function navi_yn_display(){
		var fm = document.form1;
	//	alert("aaa");
		
	//	fm.serial_no.value = "";		
		if(fm.navi_yn.value == 'Y'){
			fm.navi_amt.value = 27500;						
		}else{
			fm.navi_amt.value = 0;
			fm.serial_no.value = "";			
		}	
		set_amt(fm.navi_amt);		
	}
	
	//네비게이션
	function search_navi(){
		var fm = document.form1;
		if(fm.c_cust_id.value == ''){
			alert('고객을 먼저 선택하십시오.');
			return;
		}		
		window.open("/acar/res_search/search_navi.jsp?client_id="+fm.c_cust_id.value, "SEARCH_CMS", "left=50, top=0, width=820, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}					
	
	//스케줄관리
	function move_fee_scd(){
		var fm = document.form1;
		fm.action = '/acar/con_rent/res_fee_c.jsp';
		fm.target = 'd_content';
		fm.submit();						
	}
	
	//고객 보기
	function view_client()
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id=<%=rc_bean.getCust_id()%>", "CLIENT", "left=10, top=10, width=900, height=700, scrollbars=yes, status=yes, resizable=yes");
	}			
	
	//월렌트견적 1개월이상일때 견적서 보기
	function go_esti_print(){  
		var fm = document.form2;
		fm.action = "/acar/secondhand_hp/estimate_rm_new.jsp";
		fm.target = "_blank";
		fm.submit();
	}				
	
// 	$(function() {
//         $("#ins_change_std_dt").datepicker({
//             dateFormat: 'yy-mm-dd'
//             ,showOtherMonths: true
//             ,showMonthAfterYear:true
//             ,changeYear: true
//             ,changeMonth: true                 
//             ,showOn: "both"
//             ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" 
//             ,buttonImageOnly: true
//             ,buttonText: "선택"           
//             ,yearSuffix: "년" 
//             ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12']
//             ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
//             ,dayNamesMin: ['일','월','화','수','목','금','토'] 
//             ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] 
// //             ,minDate: "-0D" //(-1D:하루, -1M:한 달, -1Y:일 년)
// 	         ,beforeShowDay: function(date){
// 	             show = true;
// 	             if(date.getDay() == 0 || date.getDay() == 6){show = false;} // 주말 제외
// 	             for (var i = 0; i < hdaysArray.length; i++) {
// 	                 if (new Date(hdaysArray[i]).toString() == date.toString()) {show = false;} // 공휴일 제외
	                 
// 	             }
// 	             var display = [show,'',(show)?'':'주말 및 공휴일 선택 불가'];
// 	             return display;
// 	         }
//         });                    
        
// //         $('#ins_change_std_dt').datepicker('setDate', 'today'); // 최초 날짜 세팅 시 오늘 날짜 설정
//         $(".ui-datepicker-trigger").css("margin-left","3px"); // 캘린더 이미지 위치 조정
//         $(".ui-datepicker-trigger").css("margin-bottom","-3px"); // 캘린더 이미지 위치 조정
        
// 	 });
	
	$(document).ready(function(){
		if($("#ins_change_flag").val() == "N") {
			$("input:checkbox[id='ins_change_flag']").prop("checked", true);
		}
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
<form action="" name="form2" method="POST" >
  <input type="hidden" name="car_mng_id" 	value="<%=c_id%>">  
  <input type="hidden" name="est_id" 		value="<%=e_bean.getEst_id()%>">  
  <input type="hidden" name="a_a"		value="<%=e_bean.getA_a()%>">
  <input type="hidden" name="a_b"		value="<%=e_bean.getA_b()%>">
  <input type="hidden" name="o_1"		value="<%=e_bean.getO_1()%>">  
  <input type="hidden" name="rent_dt"		value="<%=e_bean.getRent_dt()%>">
  <input type="hidden" name="amt"		value="<%=e_bean.getFee_s_amt()%>">      
  <input type="hidden" name="est_code"		value="<%=e_bean.getReg_code()%>">
  <input type="hidden" name="from_page"		value="">  
  <input type="hidden" name="tot_rm"		value="<%=rf_bean.getInv_s_amt()%>">  
  <input type="hidden" name="tot_rm1"		value="<%=rf_bean.getFee_s_amt()%>">  
  <input type="hidden" name="months"		value="<%=rc_bean.getRent_months()%>">  
  <input type="hidden" name="days"		value="<%=rc_bean.getRent_days()%>">  
  <input type="hidden" name="per"		value="<%=rf_bean.getAmt_per()%>">  
  <input type="hidden" name="navi_yn"		value="<%=rf_bean.getNavi_yn()%>">   
</form>
<form action="res_rent_u_a.jsp" name="form1" method="post" >
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun1' value='<%=gubun1%>'>  
 <input type='hidden' name='gubun2' value='<%=gubun2%>'>   
 <input type='hidden' name='gubun3' value='<%=gubun3%>'>  
 <input type='hidden' name='gubun4' value='<%=gubun4%>'>   
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
 <input type='hidden' name='list_from_page' value='<%=list_from_page%>'>
 <input type='hidden' name='mode' value='<%=mode%>'> 
 <input type='hidden' name='mngid_reg_brch_id' value=''> 
 
 <input type='hidden' name='c_id' value='<%=c_id%>'>
<%--  <input type='hidden' name='rent_st' id="rent_st" value='<%=rent_st%>'> --%>
 <input type='hidden' name='use_st' value='<%=use_st%>'>
 <input type='hidden' name='c_cust_id' value='<%=rc_bean.getCust_id()%>'>
 <input type='hidden' name='site_id' value='<%=rc_bean.getSite_id()%>'>
 <input type='hidden' name='sub_c_id' value='<%=rc_bean.getSub_c_id()%>'>
 <input type='hidden' name='h_rent_start_dt' value=''>
 <input type='hidden' name='h_rent_end_dt' value=''>
 <input type='hidden' name='h_deli_plan_dt' value=''>
 <input type='hidden' name='h_ret_plan_dt' value=''>
 <input type='hidden' name='h_deli_dt' value=''> 
 <input type='hidden' name='c_car_no' value='<%=rc_bean2.getCar_no()%>'>
 <input type='hidden' name='section' value='<%=reserv.get("SECTION")%>'>
 <input type='hidden' name='sub_l_cd' value='<%=rc_bean.getSub_l_cd()%>'>
 <input type='hidden' name='from_page' value='/acar/res_stat/res_rent_u.jsp'>
 <input type='hidden' name='remove_seq' value=''> 
 <input type='hidden' name='rent_mng_id' value='<%=c_id%>'>
 <input type='hidden' name='rent_l_cd' value='<%=s_cd%>'>
 <input type='hidden' name='amt_per' value='<%=rf_bean.getAmt_per()%>'>   
 <input type='hidden' name='scd_rent_st' value=''>   
 <input type='hidden' name='scd_tm' value=''>   
 <input type='hidden' name='day_s_amt' value='<%=rf_bean.getInv_s_amt()%>'>
 
      
 


<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 배반차관리 > 예약수정 > <span class=style5>예약등록 ( 
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
    <tr><td class=h></td></tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td width="20%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보 (<%=c_id%>)</span></td>
        <td align="right"> 		
        	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>        		
        	<%	if(mode.equals("")){%>
        	<a href='javascript:save();'><img src="/acar/images/center/button_modify_s.gif"  align="absmiddle" border="0"></a>&nbsp; 
        	<%	}%>
        	<%}%>
		&nbsp;
		<%if(!mode.equals("view")){%>
		<a href='javascript:go_to_list();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>
		<%}%>
	</td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>차량번호</td>
                    <td>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class=title>차명</td>
                    <td colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                    <td class=title>차대번호</td>
                    <td colspan="3">&nbsp;<%=reserv.get("CAR_NUM")%></td>
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
                    <td colspan="3">&nbsp;<%=reserv.get("OPT")%></td>
                    <td class=title>현재예상주행거리</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(reserv.get("TODAY_DIST")))%>km</td>
                    <td class=title>최종점검일</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("SERV_DT")))%></td>
                </tr>
				<tr> 
                    <td class=title width=10%>검사유효기간</td>
                    <td width=23% colspan="3">&nbsp; 
                      <input type="text" name="maint_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>" size="10" class=whitetext>
                      ~ 
                      <input type="text" name="maint_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%>" size="10" class=whitetext>
                      &nbsp; </td>
                    <td class=title>차령만료일</td>
                    <td>&nbsp; 
                      <input type="text" name="car_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("CAR_END_DT")))%>" size="10" class=whitetext>
                    </td>
                    <td class=title>점검유효기간</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="test_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_ST_DT")))%>" size="10" class=whitetext>
                      ~&nbsp; 
                      <input type="text" name="test_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_END_DT")))%>" size="10" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("11")){%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right">
            <%if(!mode.equals("fine_doc")){%>
                    
	        <img src=/acar/images/center/arrow.gif> <%=reserv.get("CAR_NO")%>
		<a href="javascript:car_reserve();"><img src="/acar/images/center/button_list_dy.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
		<a href="javascript:car_reserve2();"><img src="/acar/images/center/button_list_dg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;		
	    	
	    <%if(!mode.equals("view")){%>		
		<a href="javascript:view_scan_res('<%=c_id%>','<%=s_cd%>')" onMouseOver="window.status=''; return true" title='과태료첨부문서'><img src=/acar/images/center/button_file_gtr.gif border=0 align=absmiddle></a>        
		<a href="javascript:move_fee_scd()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_sch.gif align=absmiddle border="0"></a>&nbsp;&nbsp;		
	    <%}%>	
		<a href="javascript:RentMemo('<%=s_cd%>','<%=c_id%>','<%=ck_acar_id%>');" class="btn" title='통화내역보기'><img src=/acar/images/center/button_th.gif align=absmiddle border=0></a>&nbsp;
	    <%}%>		    		
        </td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <%if(rent_st.equals("1")||rent_st.equals("9")){%>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>
        			<%if(mode.equals("u")){%>
        			구분 <a href="javascript:cust_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
        			<%}else{%>
        			구분
        			<%}%>
        			</td>
                    <td> 
                      &nbsp;<input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
                      <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="20" class=whitetext>
                    </td>
                    <td class=title>성명</td>
                    <td> 
                      &nbsp;<input type="text" name="c_cust_nm" value="<%=rc_bean2.getCust_nm()%>" size="25" class=whitetext>
                    </td>
                    <td class=title>생년월일</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="c_ssn" value="<%=rc_bean2.getSsn()%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>상호</td>
                    <td colspan=3> 
                      &nbsp;<input type="text" name="c_firm_nm" value="<%=rc_bean2.getFirm_nm()%>" size="60" class=whitetext>
                      &nbsp;<span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
                    </td>
                    <td class=title>사업자등록번호</td>
                    <td colspan=3> 
                      &nbsp;<input type="text" name="c_enp_no" value="<%=rc_bean2.getEnp_no()%>" size="15" class=whitetext>
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
					<input type="text" name='c_zip' id="c_zip" size="7" value="<%=rc_bean2.getZip()%>" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='c_addr' id="c_addr"  value="<%=rc_bean2.getAddr()%>" size="50">

                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>운전면허번호</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="c_lic_no" value="<%=rm_bean4.getLic_no()%>" size="16" class=<%=white%>text onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                    </td>
                    <td class=title width=10%>면허종류</td>
                    <td width=16%> 
                      &nbsp;<select name='c_lic_st' <%=disabled%>>
                        <option value=''>선택</option>
                        <option value='1' <%if(rm_bean4.getLic_st().equals("1"))%>selected<%%>>2종보통</option>
                        <option value='2' <%if(rm_bean4.getLic_st().equals("2"))%>selected<%%>>1종보통</option>
                        <option value='3' <%if(rm_bean4.getLic_st().equals("3"))%>selected<%%>>1종대형</option>
                      </select>                        
                    </td>
                    <td class=title width=10%>전화번호</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="c_tel" value="<%=rm_bean4.getTel()%>" class=<%=white%>text size="15">
                    </td>
                    <td class=title width=10%>휴대폰</td>
                    <td width=14%> 
                      &nbsp;<input type="text" name="c_m_tel" value="<%=rm_bean4.getEtc()%>" size="15" class=<%=white%>text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>비상연락처</td>
                    <td  colspan='7'> 
                      <input type="hidden" name="mgr_st2" value="2">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 성명:&nbsp;
                      <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=<%=white%>text size="10">
                       &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 연락처:&nbsp; 
                      <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=<%=white%>text>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 관계:&nbsp; 
                      <input type="text" name="m_etc2" value="<%=rm_bean2.getEtc()%>" size="58" class=<%=white%>text>
                    </td>
                </tr>
                
                <tr> 
                    <td class=title rowspan="4">실운전자<br>(용역기사 등)</td>
                    <td  colspan='7'> 
                      &nbsp;<input type="checkbox" name="cust_sam_chk" value="N" onclick="javascript:mgr1_set();">
                      위의 고객과 동일
                    </td>
                </tr>		  
                <tr> 
                    <td colspan='7'>                       
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 성명:&nbsp;
                      <input type="hidden" name="mgr_st1" value="1">
                      <input type="text" name="mgr_nm1" value="<%=rm_bean1.getMgr_nm()%>" class=<%=white%>text size="10">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 생년월일:&nbsp;
                      <input type="text" name="m_ssn1" value="<%=rm_bean1.getSsn()%>" size="15" maxlength='8' class=<%=white%>text>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 운전면허번호:&nbsp;
                      <input type="text" name="m_lic_no1" value="<%=rm_bean1.getLic_no()%>" size="16" class=<%=white%>text onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                      &nbsp; <img src=/acar/images/center/arrow.gif> 면허종류:&nbsp; 
                      <select name='m_lic_st1' <%=disabled%>>
                        <option value=''>선택</option>
                        <option value='1' <%if(rm_bean1.getLic_st().equals("1"))%>selected<%%>>2종보통</option>
                        <option value='2' <%if(rm_bean1.getLic_st().equals("2"))%>selected<%%>>1종보통</option>
                        <option value='3' <%if(rm_bean1.getLic_st().equals("3"))%>selected<%%>>1종대형</option>
                      </select> 
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 전화번호:&nbsp; 
                      <input type="text" name="m_tel1" value="<%=rm_bean1.getTel()%>" size="15" class=<%=white%>text>
                    </td>
                </tr>                
                
				<script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('m_zip1').value = data.zonecode;
								document.getElementById('m_addr1').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>
                <tr> 
                    <td  colspan='7'>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 주소:&nbsp
					<input type="text" name='m_zip1' id="m_zip1" size="7" value="<%=rm_bean1.getZip()%>" maxlength='7'>
					<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='m_addr1' id="m_addr1"  value="<%=rm_bean1.getAddr()%>" size="100">

                    </td>
                </tr>
               <tr> 
                    <td  colspan='7'>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 기타:&nbsp;                       
                      <input type="text" name="m_etc1" value="<%=rm_bean1.getEtc()%>" size="113" class=<%=white%>text>
                    </td>
                </tr>   
                             
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("10") || rent_st.equals("11")){%>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>
        			<%if(mode.equals("u")){%>
        			구분 <a href="javascript:cust_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
        			<%}else{%>
        			구분
        			<%}%>
        			</td>
                    <td width=21%> 
                      &nbsp;<input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
                      <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%>성명</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="c_cust_nm" value="<%=rc_bean2.getCust_nm()%>" size="30" class=whitetext>
                    </td>
                    <td class=title width=10%>생년월일</td>
                    <td width=29%> 
                     &nbsp;<input type="text" name="c_ssn" value="<%=rc_bean2.getSsn()%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>상호</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="c_firm_nm" value="<%=rc_bean2.getFirm_nm()%>" size="80" class=whitetext>
                    </td>
                    <td class=title>사업자등록번호</td>
                    <td> 
                      &nbsp;<input type="text" name="c_enp_no" value="<%=rc_bean2.getEnp_no()%>" size="15" class=whitetext>
                    </td>
                </tr>
    		    <%if(!rent_st.equals("11")){%>
                <tr> 
                    <td class=title>비상연락처</td>
                    <td  colspan='5'> 
                      <input type="hidden" name="mgr_st2" value="2">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 성명:&nbsp; 
                      <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=<%=white%>text size="10">
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 연락처:&nbsp; 
                      <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=<%=white%>text>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 관계:&nbsp;
                      <input type="text" name="m_etc2" value="<%=rm_bean2.getEtc()%>" size="58" class=<%=white%>text>
                    </td>
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
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>구분</td>
                    <td width=15%> 
                      &nbsp;<input type='hidden' name='cust_st' value='4'>
                      <input type="text" name="c_cust_st" value="직원" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%>성명</td>
                    <td width=16%> 
                      &nbsp;<select name='c_cust_nm' onChange='javascript:user_select()' <%=disabled%>>
                        <option value="">==선택==</option>			  
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean2.getCust_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                    <td class=title width=10%>영업소명</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="c_brch_nm" value="<%=rc_bean2.getBrch_nm()%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>부서명</td>
                    <td width=14%> 
                      &nbsp;<input type="text" name="c_dept_nm" value="<%=rc_bean2.getDept_nm()%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>운전면허번호</td>
                    <td> 
                      &nbsp;<input type="text" name="c_lic_no" value="<%=rc_bean2.getLic_no()%>" size="16" class=whitetext onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                    </td>
                    <td class=title>면허종류</td>
                    <td> 
                      &nbsp;<input type="text" name="c_lic_st" value="<%=rc_bean2.getLic_st()%>" size="15" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title>전화번호</td>
                    <td> 
                      &nbsp;<input type="text" name="c_tel" value="<%=rc_bean2.getTel()%>" class=whitetext size="15">
                    </td>
                    <td class=title>휴대폰</td>
                    <td> 
                      &nbsp;<input type="text" name="c_m_tel" value="<%=rc_bean2.getM_tel()%>" size="15" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}else{%>
    <input type='hidden' name='c_cust_st' value='5'>	
    <input type='hidden' name='c_cust_nm' value=''>
    <input type='hidden' name='c_firm_nm' value=''>	
    <input type='hidden' name='c_ssn' value=''>
    <input type='hidden' name='c_enp_no' value=''>
    <input type='hidden' name='c_lic_no' value=''>				
    <input type='hidden' name='c_lic_st' value=''>    
    <input type='hidden' name='c_zip' value=''>				
    <input type='hidden' name='c_addr' value=''>	
	<%}%>
	<tr><td class=h></td></tr>	
    <tr id=tr_gua style="display:<%if(rent_st.equals("1")){%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연대보증인</span></td>
    </tr>
    <tr id=tr_gua1 style="display:<%if(rent_st.equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan="2" style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>보증여부</td>
                    <td> 
                      &nbsp;<select name="gua_st" onchange="javascript:gua_display()" <%=disabled%>>
                        <option value="">==선택==</option>
                        <option value="1" <%if(rf_bean.getGua_st().equals("1")){%>selected<%}%>>입보</option>
                        <option value="2" <%if(rf_bean.getGua_st().equals("2")){%>selected<%}%>>면제</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_gua2 style="display:<%if(rent_st.equals("1") && rf_bean.getGua_st().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>성명</td>
                    <td width=15%> 
                      &nbsp;<input type="hidden" name="mgr_st3" value="3">
                      <input type="text" name="mgr_nm3" value="<%=rm_bean3.getMgr_nm()%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title width=10%>생년월일</td>
                    <td width=16%> 
                      &nbsp;<input type="text" name="m_ssn3" value="<%=rm_bean3.getSsn()%>" size="14" maxlength='8' class=<%=white%>text onBlur='javscript:this.value = ChangeSsn(this.value);'>
                    </td>
                    <td class=title width=10%>전화번호</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="m_tel3" value="<%=rm_bean3.getTel()%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title width=10%>계약자와의 관계</td>
                    <td width=14%> 
                      &nbsp;<input type="text" name="m_etc3" value="<%=rm_bean3.getEtc()%>" size="9" class=<%=white%>text>
                    </td>
                </tr>
				<script>
					function openDaumPostcode2() {
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
					<input type="text" name='m_zip3' id="m_zip3" size="7"  value="<%=rm_bean3.getZip()%>" maxlength='7'>
					<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='m_addr3' id="m_addr3"  value="<%=rm_bean3.getAddr()%>" size="50">

                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_gua3 style="display:<%if(rent_st.equals("1") && rf_bean.getGua_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>면제사유</td>
                    <td> 
                        &nbsp;<input type="text" name="gua_cau" value="<%=rf_bean.getGua_cau()%>" size="109" class=<%=white%>text>
                    </td>
              </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%if(rent_st.equals("2")){
		//정비대차정보
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());
		//계약정보
		Hashtable cont_view = a_db.getContViewCase("", rc_bean.getSub_l_cd());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비대차</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>
        			<%if(mode.equals("u")){%>
        			정비공장명 <a href="javascript:serv_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
        			<%}else{%>
        			정비공장명
        			<%}%>
        			</td>
                    <td width="21%"> 
                        &nbsp;<input type="hidden" name="serv_id" value="<%=rc_bean.getServ_id()%>">
                        <input type="text" name="off_nm" value="<%=serv.get("OFF_NM")%>" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%>정비차량번호</td>
                    <td width="20%"> 
                        &nbsp;<input type="text" name="car_no" value="<%=serv.get("CAR_NO")%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>차종</td>
                    <td width="29%"> 
                        &nbsp;<input type="text" name="car_nm" value="<%=serv.get("CAR_NM")%>" size="20" class=whitetext>
                    </td>
                </tr>
                <tr>
                    <td class=title>보험연령</td>
                    <td>
                      &nbsp;<input type="text" name="d_car_ins_age" size="20" class=whitetext>
                        <input type="hidden" name="d_car_ins_age_cd" value=""></td>
                    <td class=title width="10%">대여방식</td>
                    <td colspan='3'> 
                      &nbsp;<input type="text" name="rent_way_nm" value="<%=cont_view.get("RENT_WAY")%>" size="15" class=whitetext>
                      (<%=cont_view.get("RENT_START_DT")%>~)
                    </td>
                </tr>                  
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
	<%}else if(rent_st.equals("3")){
		//대차정보
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고대차</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding=0" width=100%>
                <tr> 
                    <td class=title width=10%>
        			<%if(mode.equals("u")){%>
        			정비공장명 <a href="javascript:accid_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
        			<%}else{%>
        			정비공장명
        			<%}%>			
        			 </td>
                    <td width=21%> 
                        &nbsp;<input type="hidden" name="accid_id" value="<%=rc_bean.getAccid_id()%>">
                        <input type="text" name="off_nm" value="<%=accid.get("OFF_NM")%>" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%>피해차량번호</td>
                    <td width=20%> 
                        &nbsp;<input type="text" name="car_no" value="<%=accid.get("CAR_NO")%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>차종</td>
                    <td width=29%>
                        &nbsp;<input type="text" name="car_nm" value="<%=accid.get("CAR_NM")%>" size="20" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title> 접수번호</td>
                    <td> 
                        &nbsp;<input type="text" name="our_num" value="<%=accid.get("P_NUM")%>" size="25" class=whitetext>
                    </td>
                    <td class=title>가해자보험사</td>
                    <td> 
                        &nbsp;<input type="text" name="ins_nm" value="<%=accid.get("G_INS")%>" size="15" class=whitetext>
                    </td>
                    <td class=title>담당자</td>
                    <td>
                        &nbsp;<input type="text" name="ins_mng_nm" value="<%=accid.get("G_INS_NM")%>" size="20" class=whitetext>
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
    <tr><td class=h></td></tr>
	<%}else if(rent_st.equals("9")){
		//보험대차정보
		RentInsBean ri_bean = rs_db.getRentInsCase(rc_bean.getSub_c_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험대차</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title> 접수번호</td>
                    <td> 
                      &nbsp;<input type="text" name="ins_num" value="<%=ri_bean.getIns_num()%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title>보험사</td>
                    <td colspan="5"> 
                      &nbsp;<select name='ins_com_id' <%=disabled%>>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ri_bean.getIns_com_id().equals(ic.getIns_com_id()))%>selected<%%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%> 담당자</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="ins_nm" value="<%=ri_bean.getIns_nm()%>" size="14" class=<%=white%>text maxlength="10" >
                    </td>
                    <td class=title width=10%>연락처Ⅰ</td>
                    <td width=16%> 
                      &nbsp;<input type="text" name="ins_tel" value="<%=ri_bean.getIns_tel()%>" size="13" class=<%=white%>text maxlength="15" >
                    </td>
                    <td class=title width=10%>연락처Ⅱ</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="ins_tel2" value="<%=ri_bean.getIns_tel2()%>" size="13" class=<%=white%>text maxlength="15" >
                    </td>
                    <td class=title width=10%>팩스</td>
                    <td width=14%> 
                      &nbsp;<input type="text" name="ins_fax" value="<%=ri_bean.getIns_fax()%>" size="13" class=<%=white%>text maxlength="15" >
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
	<%}else if(rent_st.equals("6")){
		//차량정비정보
		Hashtable serv = rs_db.getInfoServ(c_id, rc_bean.getServ_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정비</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>
        			<%if(mode.equals("u")){%>
        			<a href="javascript:serv_select()"><font color="#FFFF00">정비공장명</font></a>
        			<%}else{%>
        			정비공장명
        			<%}%>			
        			</td>
                    <td width=41%> 
                      &nbsp;<input type="hidden" name="serv_id" value="<%=rc_bean.getServ_id()%>">
                      <input type="text" name="off_nm" value="<%=serv.get("OFF_NM")%>" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%> 정비일자</td>
                    <td width=39%>
                      &nbsp;<input type="text" name="serv_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%>" size="12" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>		
	<%}else if(rent_st.equals("7")){
		//차량점검정보
		Hashtable maint = rs_db.getInfoMaint(c_id, rc_bean.getMaint_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정검</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan="2"></td>
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
    <tr><td class=h></td></tr>
	<%}else if(rent_st.equals("8")){
		//사고수리정보
		Hashtable accid = rs_db.getInfoAccid(c_id, rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고수리</span></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>		
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>
        			<%if(mode.equals("u")){%>
        			<a href="javascript:accid_select()"><font color="#FFFF00">정비공장명</font></a>
        			<%}else{%>
        			정비공장명
        			<%}%>			
        			</td>
                    <td width=21%> 
                      &nbsp;<input type="hidden" name="accid_id" value="<%=rc_bean.getAccid_id()%>">
                      <input type="text" name="off_nm" value="<%=accid.get("OFF_NM")%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title width=10%>사고일자</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="accid_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title width=10%>담당자</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="accid_mng_nm" value="<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%>" size="20" class=<%=white%>text>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%> 사고내용</td>
                    <td colspan="5"> 
                      &nbsp;<input type="text" name="accid_cont" value="<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%>" size="100" class=<%=white%>text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>		
	<%}%>
	<tr><td class=h></td></tr>					
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약정보</span></td>
	    <td align="right"><font color="#999999">
        	<%if(!rc_bean.getReg_id().equals("")){%>
        		<img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(rc_bean.getReg_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> : 
        		<%=AddUtil.ChangeDate2(rc_bean.getReg_dt())%>
        	<%}%>	  
        	<%if(!rc_bean.getUpdate_id().equals("")){%>
        		&nbsp;&nbsp;<img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> <%=c_db.getNameById(rc_bean.getUpdate_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> 
        		<%=AddUtil.ChangeDate2(rc_bean.getUpdate_dt())%>
        	<%}%>
        	</font>
        	<%if(!mode.equals("view")){%>
			&nbsp;&nbsp;&nbsp;<a href="javascript:tint_reg_link();"><img src="/acar/images/center/button_reg_p_ts.gif" align="absmiddle" border="0"></a>&nbsp;
		<%}%>
		</td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>계약구분</td>
                    <td colspan="9"> 
                     &nbsp;<select name="rent_st" <%=disabled%>>
                        <option value="1"  <%if(rent_st.equals("1"))%> selected<%%>>단기대여</option>
                        <option value="2"  <%if(rent_st.equals("2"))%> selected<%%>>정비대차</option>
                        <option value="3"  <%if(rent_st.equals("3"))%> selected<%%>>사고대차</option>
                        <option value="9"  <%if(rent_st.equals("9"))%> selected<%%>>보험대차</option>
                        <option value="10" <%if(rent_st.equals("10"))%>selected<%%>>지연대차</option>
                        <option value="4"  <%if(rent_st.equals("4"))%> selected<%%>>업무대여</option>
        <!--            <option value="5"  <%if(rent_st.equals("5"))%> selected<%%>>업무지원</option>-->
                        <option value="6"  <%if(rent_st.equals("6"))%> selected<%%>>차량정비</option>
        <!--            <option value="7"  <%if(rent_st.equals("7"))%> selected<%%>>차량점검</option>-->
                        <option value="8"  <%if(rent_st.equals("8"))%> selected<%%>>사고수리</option>
                        <option value="11" <%if(rent_st.equals("11"))%>selected<%%>>장기대기</option>				
                        		
                      </select>
                      <%if(rent_st.equals("10")){%>(<%=rc_bean.getSub_l_cd()%>)<%}%>
        
                    </td>
                </tr>		  		
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="s_cd" value="<%=rc_bean.getRent_s_cd()%>" size="10" class=whitetext readonly>
                    </td>
                    <td class=title width=10%>계약일자</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="rent_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%>" size="12" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>영업소</td>
                    <td width=10%> 
                      &nbsp;<select name='s_brch_id' <%=disabled%>>
                        <option value=''>전체</option>
                        <%if(brch_size > 0){
        					for (int i = 0 ; i < brch_size ; i++){
        						Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%= branch.get("BR_ID") %>' <%if(rc_bean.getBrch_id().equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width=10% class=title>담당자</td>
                    <td width=10%> 
                      &nbsp;<select name='bus_id' <%=disabled%>>
                        <option value="">미지정</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width=10% class=title>관리담당자</td>
                    <td width=10%><input type='hidden' name='mng_id' value='<%=rc_bean.getMng_id()%>'> 
                      &nbsp;
                      <%=c_db.getNameById(rc_bean.getMng_id(),"USER")%>                      
                      <%
                      		String sl_mng_dept_jang = nm_db.getWorkAuthUser("본사관리팀장");
                      		String sl_rm_mng_user 	= nm_db.getWorkAuthUser("본사월렌트담당");
                      %>                            
                      
                      
                    </td>                            
                </tr>
                <tr> 
                    <td class=title>이용기간</td>
                    <td colspan="9"> 
                      &nbsp;<input type="text" name="rent_start_dt" id="rent_start_dt"value="<%=AddUtil.ChangeDate2(rc_bean.getRent_start_dt_d())%>" size="12" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'>
                      <select name="rent_start_dt_h" onChange="getRentTime(); setDtHS(this);" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_start_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="rent_start_dt_s" onChange="getRentTime(); setDtHS(this);" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_start_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                      ~ 
                      <input type="text" name="rent_end_dt" id="rent_end_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRent_end_dt_d())%>" size="12" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'>
                      <select name="rent_end_dt_h" onChange="getRentTime(); setDtHS(this);" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_end_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="rent_end_dt_s" onChange="getRentTime(); setDtHS(this);" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_end_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select> 
                      ( 
                      <input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="4" class=<%=white%>text>
                      시간 
                      <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="4" class=<%=white%>text>
                      일
                      <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="4" class=<%=white%>text>
                      개월 )
                      <%//}%>
                       </td>
                </tr>
                <tr> 
                    <td class=title>보험 변경 기준일</td>
                    <td colspan="7"> 
                      &nbsp;<input type="text" name="ins_change_std_dt" id="ins_change_std_dt" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();' value="<%=AddUtil.ChangeDate2(rc_bean.getIns_change_std_dt())%>" readonly style="background: gray;">
					  <input type="checkbox" id="ins_change_flag" name="ins_change_flag" style="margin-left:90px;" value="<%=rc_bean.getIns_change_flag()%>"><span>보험 변경 없음</span>&nbsp;&nbsp;<span style="color: red;font-weight: bold;">* 계약한 차량이 21세이지만 실제 운전자가 21세가 아닐경우 체크 </span> 
					  <input type="hidden" id="ins_change_flag_input" name="ins_change_flag_input" value="<%=rc_bean.getIns_change_flag()%>"/>
                </tr>
                <tr> 
                    <td class=title>기타 특이사항</td>
                    <td colspan="9"> 
                      &nbsp;<textarea name="etc" cols="110" rows="3" class=default <%=readonly%>><%=rc_bean.getEtc()%></textarea>
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
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>배차예정일시</td>
                    <td width=41%> 
                      &nbsp;<input type="text" name="deli_plan_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%>" size="12" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="deli_plan_dt_h" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="deli_plan_dt_s" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title width=10%>배차위치</td>
                    <td width=39%> 
                      &nbsp;<input type="text" name="deli_loc" value="<%=rc_bean.getDeli_loc()%>" size="60" class=<%=white%>text>
                    </td>
                </tr>
    		    <%if(!rent_st.equals("11")){%>
                <tr> 
                    <td class=title>배차일시</td>
                    <td> 
                      &nbsp;<input type="text" name="deli_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="deli_dt_h" disabled>
                        <option value="">선택</option>			  
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="deli_dt_s" disabled>
                        <option value="">선택</option>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>배차담당자</td>
                    <td>
                      &nbsp;<select name='deli_mng_id' <%=disabled%>>
                        <option value="">미지정</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean.getDeli_mng_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>		
    		    <%}else{%>
    		  <input type='hidden' name="deli_dt">
    		  <input type='hidden' name="deli_dt_h">
    		  <input type='hidden' name="deli_dt_s">
    		  <input type='hidden' name="deli_mng_id">
    		  <%}%>		  
                <tr> 
                    <td class=title>반차예정일시</td>
                    <td> 
                      &nbsp;<input type="text" name="ret_plan_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%>" size="12" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="ret_plan_dt_h" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="ret_plan_dt_s" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>반차위치</td>
                    <td> 
                      &nbsp;<input type="text" name="ret_loc" value="<%=rc_bean.getRet_loc()%>" size="60" class=<%=white%>text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%if(rent_st.equals("1") || rent_st.equals("9")){%>
    <tr id=tr_fee style="display:''"> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금</span>
          <%if(rent_st.equals("1") || rent_st.equals("9")){%>&nbsp;&nbsp;<font color="red">※ 정상대여료는 대여기간 동안의 <b>총대여요금</b>입니다.</font><%}%>
        </td>
    </tr>
    <tr id=tr_fee style="display:''"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>                     
                <tr> 
                    <td class=title width=10%>세금계산서</td>
                    <td width=15%> 
                      &nbsp;<select name="tax_yn" <%=disabled%>>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getTax_yn().equals("Y")){%>selected<%}%>>발행</option>
                        <option value="N" <%if(rf_bean.getTax_yn().equals("N")){%>selected<%}%>>미발행</option>
                      </select>
                    </td>
                    <td class=title width=10%>선택보험</td>
                    <td width=26%> 
                      &nbsp;<select name="ins_yn" <%=disabled%>>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getIns_yn().equals("Y")){%>selected<%}%>>가입</option>
                        <option value="N" <%if(rf_bean.getIns_yn().equals("N")){%>selected<%}%>>미가입</option>
                      </select>
                      (면책금 : <input type='text' size='12' maxlength='7' name='car_ja' class='num' value='<%=AddUtil.parseDecimal(rf_bean.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			원)</td>
                    <td class=title width=10%>휴차보상료</td>
                    <td> 
                      &nbsp;<select name="my_accid_yn" <%=disabled%>>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getMy_accid_yn().equals("Y")){%>selected<%}%>>고객부담</option>
                        <option value="N" <%if(rf_bean.getMy_accid_yn().equals("N")){%>selected<%}%>>면제</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>결제방법</td>
                    <td> 
                       &nbsp;<select name="paid_way" <%=disabled%> onchange="javascript:paid_way_display();"><!---->
                            <option value="">==선택==</option>			  
                            <option value="1" <%if(rf_bean.getPaid_way().equals("1")){%>selected<%}%>>선불</option>
                            <option value="2" <%if(rf_bean.getPaid_way().equals("2")){%>selected<%}%>>후불</option>
                        </select>
                    </td>
                    <td class=title>결제수단</td>
                    <td colspan="3">
        			    <table border="0" width="100%">
                            <tr>
            				    <td>
                	                &nbsp;<select name="paid_st" <%=disabled%>><!-- onchange="javascript:paid_display();"-->
                    	              <option value="">==선택==</option>			  
                        	      <option value="1" <%if(rf_bean.getPaid_st().equals("1")){%>selected<%}%>>현금</option>
                            	      <option value="2" <%if(rf_bean.getPaid_st().equals("2")){%>selected<%}%>>신용카드</option>
                            	      <option value="3" <%if(rf_bean.getPaid_st().equals("3")){%>selected<%}%>>자동이체</option>
                            	      <option value="4" <%if(rf_bean.getPaid_st().equals("4")){%>selected<%}%>>무통장입금</option>
                	                </select>				  </td>				
            				    <td id=td_paid style="display:<%if(rf_bean.getPaid_st().equals("2")){%>''<%}else{%>none<%}%>">(카드NO. : 
            		                <input type="text" name="card_no" value="<%=rf_bean.getCard_no()%>" size="30" class=<%=white%>text>
            	                    )
            				    </td>				   
                                <td align="right">
                                		<%if(!mode.equals("view")){%>
            					    <a href="javascript:getFee_sam();"><img src=/acar/images/center/button_in_jdgs.gif align=absmiddle border=0></a>
            					<%}%>    
                                </td>
            				</tr>
        			    </table>
                    </td>
                    
                </tr>
                <tr> 
                    <td class=title>주유량</td>
                    <td> 
                      &nbsp;<select name="oil_st" <%=disabled%>>
                        <option value="">==선택==</option>			  
                        <option value="1" <%if(rf_bean.getOil_st().equals("1")){%>selected<%}%>>1칸</option>
                        <option value="2" <%if(rf_bean.getOil_st().equals("2")){%>selected<%}%>>2칸</option>
                        <option value="3" <%if(rf_bean.getOil_st().equals("3")){%>selected<%}%>>3칸</option>
                        <option value="f" <%if(rf_bean.getOil_st().equals("f")){%>selected<%}%>>full</option>
                      </select>
                    </td>                        
                    <td class=title>네비게이션</td>
                    <td colspan='3'> 
                      &nbsp;<select name="navi_yn" >
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getNavi_yn().equals("Y")){%>selected<%}%>>있음</option>
                        <option value="N" <%if(rf_bean.getNavi_yn().equals("N")){%>selected<%}%>>없음</option>
                        </select>
                       <% if (  user_id.equals("000063") ) { %> 
                         <a href='javascript:search_navi()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
                        <% } %> 
                         &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> S / N:&nbsp; 
                      <input type='text' name='serial_no'  value="<%=rf_bean.getSerial_no()%>"  size='30' class='text'  readonly >        
                    </td>
                   
                </tr>          
                <tr> 
                    <td class=title>배차주행거리</td>
                    <td> 
                      &nbsp;<input type="text" name="dist_km" value="<%=AddUtil.parseDecimal(rf_bean.getDist_km())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      km
                    </td>                        
                    <td class=title>탁송요청</td>
                    <td> 
                      &nbsp;<select name="cons_yn" <%=disabled%>>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getCons_yn().equals("Y")){%>selected<%}%>>있음</option>
                        <option value="N" <%if(rf_bean.getCons_yn().equals("N")){%>selected<%}%>>없음</option>
                      </select>
                    </td>   
                     <td class=title width=10%>GPS</td>
                    <td> 
                      &nbsp;<select name="gps_yn" <%=disabled%>>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getGps_yn().equals("Y")){%>selected<%}%>>있음</option>
                        <option value="N" <%if(rf_bean.getGps_yn().equals("N")){%>selected<%}%>>없음</option>
                      </select>
                    </td>         
                </tr>   
                     
               <tr> 
                   <td class=title width=10%>특이사항</td>
                    <td colspan='5'> 
                      &nbsp;<textarea name="fee_etc" cols="110" rows="3" class=default <%=readonly%>><%=rf_bean.getFee_etc()%></textarea>                 
                    </td>                                           
                </tr>       
                <tr> 
                    <td class=title>자동이체</td>
                    <td  colspan='5'> 
                      &nbsp;<img src=/acar/images/center/arrow.gif> 은행:&nbsp; 
                      <select name='cms_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        				for(int i = 0 ; i < bank_size ; i++){
        					CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(rf_bean.getCms_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        			}%>
                      </select>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 계좌번호:&nbsp; 
                      <input type='text' name='cms_acc_no' value='<%=rf_bean.getCms_acc_no()%>' size='20' class='text'>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 예금주:&nbsp; 
                      <input type='text' name='cms_dep_nm' value='<%=rf_bean.getCms_dep_nm()%>' size='20' class='text'>
                    </td>
                </tr>   
                
            </table>
        </td>
    </tr>	
    <tr id=tr_fee1 style="display:''"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title rowspan="2" >구분</td>
                    <td class=title colspan="6">월대여료</td>
                    <td class=title width="11%">대여료총액</td>
                    <td class=title rowspan="2" width="8%">배차료</td>
                    <td class=title rowspan="2" width="8%">반차료</td>
                    <td class=title rowspan="2" width="11%">총결재금액</td>                    
                </tr>
                <tr>
                  <td width="10%" class=title>정상대여료</td>
                  <td width="8%" class=title>D/C</td>
                  <td width="8%" class=title>네비게이션</td>
                  <td width="8%" class=title>기타</td>                  
                  <td width="8%" class=title>선택보험료</td>                  
                  <td width="10%" class=title>합계</td>                  
                  <td class=title>
                  	<input type="text" name="v_rent_months" value="<%=rc_bean.getRent_months()%>" size="1" class=whitenum>
                      	개월
                      	<input type="text" name="v_rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=whitenum>
                      	일
                  </td>           
                </tr>                
                <tr> 
                    <td class=title width="10%">공급가</td>
                    <td align="center"> 
                      <input type="text" name="inv_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="dc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="navi_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>부가세</td>
                    <td align="center"> 
                      <input type="text" name="inv_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="dc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_v_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="navi_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="etc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>합계</td>
                    <td align="center"> 
                      <input type="text" name="inv_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getInv_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt()+rf_bean.getDc_v_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="navi_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="etc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="ins_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                      <input type='hidden' name="m2_dc_amt" value="<%=rf_bean.getM2_dc_amt()%>">
                      <input type='hidden' name="m3_dc_amt" value="<%=rf_bean.getM3_dc_amt()%>">
                <tr> 
                    <td class=title>최초결제금액</td>
                    <td align="center"> 
                      &nbsp;<input type="text" name="f_rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getF_rent_tot_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td class=title>최초결제방식</td>
                    <td colspan="8">&nbsp; 
                      <select name="f_paid_way" onchange="javascript:f_paid_way_display();" <%=disabled%>>
                        <option value="">==선택==</option>			  
                        <option value="1" <%if(rf_bean.getF_paid_way().equals("1")){%>selected<%}%>>1개월치</option>
                        <option value="2" <%if(rf_bean.getF_paid_way().equals("2")){%>selected<%}%>>총액</option>
                      </select>
                      &nbsp; 반차료
                      <select name="f_paid_way2" onchange="javascript:f_paid_way_display();" <%=disabled%>>
                        <option value="">==선택==</option>			  
                        <option value="1" <%if(rf_bean.getF_paid_way2().equals("1")){%>selected<%}%>>포함</option>
                        <option value="2" <%if(rf_bean.getF_paid_way2().equals("2")){%>selected<%}%>>미포함</option>
                      </select>
                      </td>  
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기본식 정비대차 요금</span>
        </td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>                           
                <tr> 
                    <td class=title width=10%>결제수단</td>
                    <td width=41%> 
                      &nbsp;<select name="paid_st" <%=disabled%>>
                    	              <option value="">==선택==</option>			  
                        	      <option value="1" <%if(rf_bean.getPaid_st().equals("1")){%>selected<%}%>>현금</option>
                            	      <!--<option value="2" <%if(rf_bean.getPaid_st().equals("2")){%>selected<%}%>>신용카드</option>-->
                            	      <option value="3" <%if(rf_bean.getPaid_st().equals("3")){%>selected<%}%>>자동이체</option>
                            	      <option value="4" <%if(rf_bean.getPaid_st().equals("4")){%>selected<%}%>>무통장입금</option>
                	                </select>
                    </td>                        
                    <td class=title width=10%>탁송요청</td>
                    <td> 
                      &nbsp;<select name="cons_yn" <%=disabled%>>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getCons_yn().equals("Y")){%>selected<%}%>>있음</option>
                        <option value="N" <%if(rf_bean.getCons_yn().equals("N")){%>selected<%}%>>없음</option>
                      </select>
                    </td>   
                </tr>   
                     
               <tr> 
                   <td class=title width=10%>특이사항</td>
                    <td colspan='3'> 
                      &nbsp;<textarea name="fee_etc" cols="110" rows="3" class=default <%=readonly%>><%=rf_bean.getFee_etc()%></textarea>                 
                    </td>                                           
                </tr>       
            </table>
        </td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>청구기준</td>
                    <td colspan='4'>&nbsp;1일 <%=AddUtil.parseDecimal(rf_bean.getInv_s_amt())%>원 (공급가)
                      </td>                      
                </tr>       	
                <tr> 
                    <td class=title>구분</td>                    
                    <td width="11%" class=title>대여료총액</td>
                    <td width="8%" class=title>배차료</td>
                    <td width="8%" class=title>반차료</td>
                    <td width="11%" class=title>총결재금액</td>
                </tr>            
                <tr> 
                    <td class=title width="10%">공급가</td>
                    <td align="center"> 
                      <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>부가세</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>합계</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr> 
                <!--
                <%if(white.equals("") && cont_size == 0){%>
                <tr> 
                    <td class=title>스케줄생성여부</td>
                    <td colspan='4'>&nbsp;<input type="checkbox" name="scd_reg_yn" value="Y"> ( 체크하면 반차예정일자, 총결재금액 합계로 스케줄을 생성합니다.) 
                      </td>                      
                </tr>            
                <%}%>                           
                -->
            </table>
        </td>
    </tr>    
    <tr> 
        <td colspan='2'>※ 이용 일자 계산 방법 : 24시간 이내 반납 - 1일치 요금 적용, 24시간 이상 이용시 - 12시간 단위로 대여요금 산정</td>
    </tr>         
    <%}%>
    <tr><td class=h></td></tr>	
    <tr id=tr_pre style="display:<%if(rf_bean.getPaid_way().equals("1") && sr_bean0.getRent_s_amt()+sr_bean1.getRent_s_amt()+sr_bean2.getRent_s_amt() >0 ){%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선수금/보증금 </span></td>
    </tr>
    <tr id=tr_pre1 style="display:<%if(rf_bean.getPaid_way().equals("1") && sr_bean0.getRent_s_amt()+sr_bean1.getRent_s_amt()+sr_bean2.getRent_s_amt() >0){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=5 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>입금구분</td>
                    <td class=title width=15%>납부구분</td>
                    <td class=title width=10%>입금예정일</td>
                    <td class=title width=10%>입금일자</td>
                    <td class=title width=15%>청구금액</td>
                    <td class=title width=15%>입금금액</td>
                    <td class=title width=10%>청구잔액</td>
                    <td class=title width=15%>-</td>
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st0" value="6">
                      <input type="hidden" name="tm0" value="<%=sr_bean0.getTm()%>">
        	      <input type="hidden" name="rent_s_amt0" value="<%=AddUtil.parseDecimal(sr_bean0.getRent_s_amt())%>">
        	      <input type="hidden" name="rent_v_amt0" value="<%=AddUtil.parseDecimal(sr_bean0.getRent_v_amt())%>">
        	      <input type="hidden" name="rest_amt0" value="<%=AddUtil.parseDecimal(sr_bean0.getRest_amt())%>">			  
                      보증금</td>
                    <td align="center"> 
                      <select name="paid_st0" <%=disabled%>>
                        <option value="">==선택==</option>			  			  
                        <option value="1" <%if(sr_bean0.getPaid_st().equals("1")){%>selected<%}%>>현금</option>
                        <option value="2" <%if(sr_bean0.getPaid_st().equals("2")){%>selected<%}%>>신용카드</option>
                        <option value="3" <%if(sr_bean0.getPaid_st().equals("3")){%>selected<%}%>>자동이체</option>
                        <option value="4" <%if(sr_bean0.getPaid_st().equals("4")){%>selected<%}%>>무통장입금</option>			
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="est_dt0" value="<%=AddUtil.ChangeDate2(sr_bean0.getEst_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitetext name="pay_dt0" value="<%=AddUtil.ChangeDate2(sr_bean0.getPay_dt())%>"  readonly onBlur='javscript:this.value=ChangeDate(this.value);'>
                      <%if(sr_bean0.getPay_dt().equals("")) sr_bean0.setPay_amt(0);%>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rent_amt0" value="<%=AddUtil.parseDecimal(sr_bean0.getRent_s_amt()+sr_bean0.getRent_v_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="pay_amt0" value="<%=AddUtil.parseDecimal(sr_bean0.getPay_amt())%>" readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center" colspan="2">계약종료후 환불할 보증금</td>  
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st1" value="1">
                      <input type="hidden" name="tm1" value="<%=sr_bean1.getTm()%>">
        			  <input type="hidden" name="rent_s_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getRent_s_amt())%>">
        			  <input type="hidden" name="rent_v_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getRent_v_amt())%>">			  
                      예약금</td>
                    <td align="center"> 
                      <select name="paid_st1" <%=disabled%>>
                        <option value="">==선택==</option>			  			  
                        <option value="1" <%if(sr_bean1.getPaid_st().equals("1")){%>selected<%}%>>현금</option>
                        <option value="2" <%if(sr_bean1.getPaid_st().equals("2")){%>selected<%}%>>신용카드</option>
                        <option value="3" <%if(sr_bean1.getPaid_st().equals("3")){%>selected<%}%>>자동이체</option>
                        <option value="4" <%if(sr_bean1.getPaid_st().equals("4")){%>selected<%}%>>무통장입금</option>			
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="est_dt1" value="<%=AddUtil.ChangeDate2(sr_bean1.getEst_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitetext name="pay_dt1" value="<%=AddUtil.ChangeDate2(sr_bean1.getPay_dt())%>"  readonly onBlur='javscript:this.value=ChangeDate(this.value);'>
                      <%if(sr_bean1.getPay_dt().equals("")) sr_bean1.setPay_amt(0);%>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rent_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getRent_s_amt()+sr_bean1.getRent_v_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="pay_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getPay_amt())%>" readonly onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rest_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getRest_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">-</td>  
                </tr>                
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st2" value="2">
                      <input type="hidden" name="tm2" value="<%=sr_bean2.getTm()%>">
        			  <input type="hidden" name="rent_s_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getRent_s_amt())%>">
        			  <input type="hidden" name="rent_v_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getRent_v_amt())%>">
                      선수대여료</td>
                    <td align="center"> 
                      <select name="paid_st2" <%=disabled%>>
                        <option value="">==선택==</option>			  			  
                        <option value="1" <%if(sr_bean2.getPaid_st().equals("1")){%>selected<%}%>>현금</option>
                        <option value="2" <%if(sr_bean2.getPaid_st().equals("2")){%>selected<%}%>>신용카드</option>                        
                        <option value="3" <%if(sr_bean2.getPaid_st().equals("3")){%>selected<%}%>>자동이체</option>	
                        <option value="4" <%if(sr_bean2.getPaid_st().equals("4")){%>selected<%}%>>무통장입금</option>						
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="est_dt2" value="<%=AddUtil.ChangeDate2(sr_bean2.getEst_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>                    
                    <td align="center"> 
                      <input type='text' size='12' class=whitetext name="pay_dt2" value="<%=AddUtil.ChangeDate2(sr_bean2.getPay_dt())%>" readonly onBlur='javscript:this.value=ChangeDate(this.value);'>
                      <%if(sr_bean2.getPay_dt().equals("")) sr_bean2.setPay_amt(0);%>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rent_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getRent_s_amt()+sr_bean2.getRent_v_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      원</td>                    
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="pay_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getPay_amt())%>" readonly onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rest_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getRest_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">                      
                      
                    </td>    
                </tr>
                <%if(cont_size == 0){%>
                <tr> 
                    <td class=title colspan='4'>합계</td>
                    <td align="center">
                      <input type="text" name="scd_total_amt" value="<%=Util.parseDecimal(sr_bean1.getRent_s_amt()+sr_bean1.getRent_v_amt()+sr_bean2.getRent_s_amt()+sr_bean2.getRent_v_amt())%>" size="12" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">
                      <input type="text" name="scd_pay_total_amt" value="<%=Util.parseDecimal(sr_bean1.getPay_amt()+sr_bean2.getPay_amt())%>" size="12" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                </tr>                         
                <%}%>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_pay_nm style="display:<%if(cont_size > 0){%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선수금외 스케줄</span></td>
    </tr>
    <tr id=tr_pay1 style="display:<%if(cont_size > 0){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
                    <td class=line2 colspan=5 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>입금구분</td>
                    <td class=title width=15%>납부구분</td>
                    <td class=title width=10%>입금예정일</td>
                    <td class=title width=10%>입금일자</td>
                    <td class=title width=15%>청구금액</td>
                    <td class=title width=15%>입금금액</td>
                    <td class=title width=10%>-</td>
                    <td class=title width=15%>-</td>
                </tr>
    		  <%
    		  	int scd_total_amt 	= sr_bean1.getRent_s_amt()+sr_bean1.getRent_v_amt()+sr_bean2.getRent_s_amt()+sr_bean2.getRent_v_amt();
    		  	int scd_pay_total_amt 	= sr_bean1.getPay_amt()+sr_bean2.getPay_amt();
    			if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable sr = (Hashtable)conts.elementAt(i);
    					scd_total_amt 		= scd_total_amt 	+ AddUtil.parseInt(String.valueOf(sr.get("RENT_AMT")));
    					scd_pay_total_amt 	= scd_pay_total_amt 	+ AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  %>		  
                <tr> 
                    <td class=title> 
                      <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>
                      예약보증금 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>
                      선수대여료 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>
                      대여료 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("5")){%>
                      연장대여료 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>
                      정산금 
                      <%}%>                     
                    </td>
                    <td align="center">
        			<%if(String.valueOf(sr.get("PAID_ST")).equals("1")){%>
        			현금
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("2")){%>
        			카드
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("3")){%>
        			자동이체
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("4")){%>
        			무통장입금
        			<%}%>				
        			</td>
        	    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("EST_DT")))%></td>		
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%></td>
                    <td align="center"><input type="text" name="incom_rent_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("RENT_AMT")))%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>  
                    <td align="center"><input type="text" name="incom_pay_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>  
                    <td align="center">
                        -
                    </td>                     
                    <td align="center">
                        -
                    </td>                     
                </tr>
    		  <%		
    		  		}
    		  	}%> 
    		<%if(cont_size > 0){%>  	
                <tr> 
                    <td class=title colspan='4'>스케줄 합계(선수금/보증금 포함)</td>
                    <td align="center"><input type="text" name="scd_total_amt" value="<%=Util.parseDecimal(scd_total_amt)%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center"><input type="text" name="scd_pay_total_amt" value="<%=Util.parseDecimal(scd_pay_total_amt)%>" size="12" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>                      
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                </tr>                		  				  
                <%}%>
            </table>
        </td>
    </tr>  
	<tr>
	  <td colspan="2">* 입금처리된 스케줄은 수정할 수 없습니다. 총무팀 입금담당자에게 문의하세요.</td>
	</tr>     
    <%	if(card_size > 0){%>
    <tr>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>온라인 신용카드결제</span></td>
    </tr>    
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>
                 <tr>
                  <td width="10%" class=title>연번</td>
                  <td width="15%" class=title>인증번호</td>
                  <td width="15%" class=title>휴대폰번호</td>		  
                  <td width="10%" class=title>금액</td>
                  <td width="10%" class=title>카드종류</td>
                  <td width="15%" class=title>회원성명</td>
                  <td width="15%" class=title>관계</td>
                  <td width="10%" class=title>상태</td>		  
                </tr>    
    <%		for(int i = 0 ; i < card_size ; i++){
    			Hashtable card = (Hashtable)cards.elementAt(i);%>	
                <tr>
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%=card.get("AM_AX_CODE")%></td>
                  <td align="center"><%=card.get("AM_M_TEL")%></td>		  
                  <td align="right"><%=Util.parseDecimal(String.valueOf(card.get("AM_GOOD_AMT")))%>원</td>
                  <td align="center"><%=card.get("CARD_NAME")%></td>
                  <td align="center"><%=card.get("AM_CARD_SIGN")%></td>		  
                  <td align="center"><%=card.get("AM_CARD_REL")%></td>		  
                  <td align="center"><%if(String.valueOf(card.get("TNO")).equals("")){%>대기<%}else{%>결재<%}%></td>		  
                </tr>      			
    <%		}%>
                                
            </table>
        </td>
    </tr>        
    <%	}%>          

    <%if(!mode.equals("view")){%>     
    <tr><td class=h></td></tr>
    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>        
    <tr> 
        <td width="20%"></td>
        <td align="right"> 
        
        <a href='javascript:save();'><img src="/acar/images/center/<%if(mode.equals("u")){%>button_modify<%}else{%>button_modify_s<%}%>.gif"  align="absmiddle" border="0"></a>&nbsp; 
    </tr>        
    <%}%>
        
  

    <tr>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기본스캔파일</span>
          <%if(rc_bean.getCust_st().equals("1")){%>
          &nbsp;<a href ="javascript:view_scan()"><img src=/acar/images/center/button_see_ss.gif align=absmiddle border=0></a>
          <%}%>
        </td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=5 style='height:1'></td>
                </tr>
                <tr>
                    <td width="10%" class=title>연번</td>
                    <td width="25%" class=title>구분</td>                    
                    <td width="25%" class=title>스캔파일</td>
                    <td width="25%" class=title>등록일자</td>
                    <td width="15%" class=title>삭제</td>		  
                </tr>
                
		<% 	
                   	int scan_num = 0;
                   	
                   	
                   	String file_st = "";
                   
                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
			String content_code = "SC_SCAN";
			String content_seq  = c_id+""+s_cd; 
			
			Vector attach_vt = new Vector();
			int attach_vt_size = 0;                   
                %>                
                   
                   
                <!-- 기본식 유상 정비대차 견적서 -->   
                <%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
                                                
                <% 	scan_num++; 
                	file_st = "28";                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">기본식유상정비대차견적서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">기본식유상정비대차견적서</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <%}%>
                                
                                
                <%if(rent_st.equals("1") || rent_st.equals("9")){//단기대여,보험대차,월렌트%>
                
                <%	scan_num++;%>
                   
                <!-- 자동차대여이용계약서 -->
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">자동차대여이용계약서</td>
                    <td align="center">
                            (구) <a href='res_rent_p.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp; 		      
                    </td>
                    <td align="center">웹페이지</td>		  
                    <td align="center"></td>		  
                </tr>  
                                
                <!-- 계약서(앞)-jpg파일 -->
                <% 	scan_num++; 
                	file_st = "17";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">계약서(앞)-jpg파일</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">계약서(앞)-jpg파일</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                
                <!-- 계약서(뒤)-jpg파일 -->
                <% 	scan_num++; 
                	file_st = "18";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">계약서(뒤)-jpg파일</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">계약서(뒤)-jpg파일</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                
                                
                <!-- 사업자등록증jpg -->
                <%	if(!rc_bean2.getEnp_no().equals("")){ //법인,개인사업자%>
                <% 		scan_num++; 
                		file_st = "2";                                      	
                
                		content_seq  = c_id+""+s_cd+""+file_st;
                
                		attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                		attach_vt_size = attach_vt.size();
                	
                		if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">사업자등록증jpg</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%			}
                		}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">사업자등록증jpg</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%		}%>
                <%	}%>

                <%	if(rc_bean2.getCust_st().equals("법인")){%>
                
                <!-- 법인등기부등본 -->    
                <% 		scan_num++; 
                		file_st = "3";                                      	
                
                		content_seq  = c_id+""+s_cd+""+file_st;
                
                		attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                		attach_vt_size = attach_vt.size();
                	
                		if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인등기부등본</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%			}
                		}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인등기부등본</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%		}%>
                
                <!-- 법인인감증명서 -->    
                <% 		scan_num++; 
                		file_st = "6";                                      	
                
                		content_seq  = c_id+""+s_cd+""+file_st;
                
                		attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                		attach_vt_size = attach_vt.size();
                	
                		if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인인감증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%			}
                		}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인인감증명서</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%		}%>                
                                            
                <%	}%>   
                

                <!-- 신분증jpg -->
                <% 	scan_num++; 
                	file_st = "4";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">신분증jpg</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">신분증jpg</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
          
                <!-- 주운전자운전면허증 -->
                <% 	scan_num++; 
                	file_st = "24";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">주운전자운전면허증</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">주운전자운전면허증</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>       
                
                <!-- 추가운전자운전면허증 -->
                <% 	scan_num++; 
                	file_st = "27";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">추가운전자운전면허증</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">추가운전자운전면허증</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                      
                
                <!-- 통장사본 -->
                <% 	scan_num++; 
                	file_st = "9";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">통장사본</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">통장사본</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                          
                
                <%}%>    
                

                <!-- 배차차량인도증 -->
                <% 	scan_num++; 
                	file_st = "25";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">배차차량인도증</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">배차차량인도증</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>         
                
                <!-- 반차차량인수증 -->
                <% 	scan_num++; 
                	file_st = "26";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">반차차량인수증</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">반차차량인수증</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                                         
                
                
                <!-- 기타 -->
                <% 	scan_num++; 
                	file_st = "5";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">기타</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">기타</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                   
                

                <!-- 추가 -->
                <% 	scan_num++; 
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">추가</td>
                    <td align="center"><a href="javascript:scan_reg('')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
            </table>
        </td>
    </tr>    
    <%}else{%>
    <tr><td class=h></td></tr>
    <tr> 
        <td width="20%"></td>
        <td align="right"> 
        		<a href='javascript:window.close();'><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a>&nbsp;         
    </tr>        
    <%}%>    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
