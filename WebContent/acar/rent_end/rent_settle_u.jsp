<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.car_service.*, acar.serv_off.*, acar.cont.*, acar.estimate_mng.*, acar.user_mng.*, acar.cont.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

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

	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "01", "02");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"c":request.getParameter("mode");
	int pay_tot_amt = 0;
	String disabled = "disabled";
	String white = "white";
	String readonly = "readonly";
//	if(mode.equals("u")){
		disabled = "";
		white = "";
		readonly = "";
//	}

	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
	
	
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
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
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
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//입금처리
	Vector conts = rs_db.getScdRentList(s_cd);
	int cont_size = conts.size();
	//미수채권
	Vector conts2 = rs_db.getScdRentNoList(s_cd);
	int cont_size2 = conts2.size();
	
	//단기대여정산정보
	RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);
	//용역비용정보
	ScdDrivBean sd_bean1 = rs_db.getScdDrivCase(s_cd, "1");
	ScdDrivBean sd_bean2 = rs_db.getScdDrivCase(s_cd, "2");
	//연장계약
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
	//신용카드결제
	Vector cards = rs_db.getRentContCardList(s_cd);
	int card_size = cards.size();	
	//미수과태료
	Vector settle_fine = rs_db.getFineSettleList(s_cd);
	int settle_fine_size = settle_fine.size();	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	if(rent_st.equals("12") && !rf_bean.getEst_id().equals("")){
		e_bean = e_db.getEstimateShCase(rf_bean.getEst_id());
	}
	
	if(rf_bean.getFee_s_amt()>0 && rf_bean.getInv_s_amt()==0){
		rf_bean.setInv_s_amt(rf_bean.getFee_s_amt());
		rf_bean.setInv_v_amt(rf_bean.getFee_v_amt());
	}	
	
	int ext_pay_rent_s_amt = 0;
	int ext_pay_rent_v_amt = 0;
	if(cont_size > 0){
		for(int i = 0 ; i < cont_size ; i++){
    			Hashtable sr = (Hashtable)conts.elementAt(i);
    			if(String.valueOf(sr.get("RENT_ST")).equals("5")){
    				ext_pay_rent_s_amt = ext_pay_rent_s_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
    				ext_pay_rent_v_amt = ext_pay_rent_v_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    			}
    		}
    	}
    	
    	
    	int settle_fine_amt = 0;
	if(settle_fine_size > 0){
		for(int i = 0 ; i < settle_fine_size ; i++){
    			Hashtable ht = (Hashtable)settle_fine.elementAt(i);    			
			settle_fine_amt = settle_fine_amt + AddUtil.parseInt(String.valueOf(ht.get("PAID_AMT")));
    		}
    	}    	
    		
%>

<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	
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
			
	//대여일수 구하기
	function getRentTime() {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var rent_time = "";
		var d1;
		var d2;
		var d3;
		var d4;		
		var t1;
		var t2;
		var t3;
		var t4;
		var t5;
		var t6;

		d1 = fm.h_rent_start_dt.value+'00';
		d2 = fm.h_rent_end_dt.value+'00';		
		d3 = fm.h_deli_dt.value+'00';
		d4 = fm.h_ret_dt.value+'00';	
											
		t1 = getDateFromString(d1).getTime();
		t2 = getDateFromString(d2).getTime();
		t3 = t2 - t1;	
		t4 = getDateFromString(d3).getTime();
		t5 = getDateFromString(d4).getTime();
		t6 = t5 - t4;	

		if(t3 == t6){
			fm.add_months.value = 0;
			fm.add_days.value = 0;
			fm.add_hour.value = 0;
			fm.tot_months.value = fm.rent_months.value;
			fm.tot_days.value = fm.rent_days.value;
			fm.tot_hour.value = fm.rent_hour.value;		
		}else{//초과 or 미만
			fm.add_months.value 	= parseInt((t6-t3)/m);
			fm.add_days.value 	= parseInt(((t6-t3)%m)/l);
			fm.add_hour.value 	= parseInt((((t6-t3)%m)%l)/lh);						
			fm.tot_months.value 	= parseInt(t6/m);
			fm.tot_days.value 	= parseInt((t6%m)/l);
			fm.tot_hour.value 	= parseInt(((t6%m)%l)/lh);				
		}			
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}
	
	//정상대여료 자동계산
	function getFee_sam(){
		var fm = document.form1;
		fm.action = '/acar/rent_settle/short_fee_nodisplay.jsp';
		<%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
		fm.action = '/acar/rent_settle/short_fee_nodisplay2.jsp';
		<%}%>
		fm.target = 'i_no';
		fm.submit();
	}
	
	//금액 셋팅	
	function set_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;	
		
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
		
		//총결재금액											
		fm.rent_tot_s_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons2_s_amt.value)) );
		fm.rent_tot_v_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_v_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)) );
		fm.rent_tot_amt.value 	= parseDecimal(	toInt(parseDigit(fm.fee_amt.value))   + toInt(parseDigit(fm.cons1_amt.value))   + toInt(parseDigit(fm.cons2_amt.value))   );
			
		
		<%}else{%>	
				
		//정상
		if(obj==fm.ag_inv_s_amt){
			fm.ag_inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_inv_s_amt.value)) * 0.1) ;
			fm.ag_inv_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_inv_s_amt.value)) + toInt(parseDigit(fm.ag_inv_v_amt.value)));
		}else if(obj==fm.ag_fee_s_amt){
			fm.ag_fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) * 0.1) ;
			fm.ag_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.ag_fee_v_amt.value)));
		}else if(obj==fm.ag_navi_s_amt){
			fm.ag_navi_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_navi_s_amt.value)) * 0.1) ;
			fm.ag_navi_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_navi_s_amt.value)) + toInt(parseDigit(fm.ag_navi_v_amt.value)));
		}else if(obj==fm.ag_etc_s_amt){
			fm.ag_etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) * 0.1) ;
			fm.ag_etc_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) + toInt(parseDigit(fm.ag_etc_v_amt.value)));
		}else if(obj==fm.ag_cons1_s_amt){
			fm.ag_cons1_v_amt.value = parseDecimal(toInt(parseDigit(fm.ag_cons1_s_amt.value)) * 0.1) ;
			fm.ag_cons1_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_cons1_s_amt.value)) + toInt(parseDigit(fm.ag_cons1_v_amt.value)));
		}else if(obj==fm.ag_cons2_s_amt){
			fm.ag_cons2_v_amt.value = parseDecimal(toInt(parseDigit(fm.ag_cons2_s_amt.value)) * 0.1) ;
			fm.ag_cons2_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_cons2_s_amt.value)) + toInt(parseDigit(fm.ag_cons2_v_amt.value)));			
		//추가
		}else if(obj==fm.add_inv_s_amt){
			fm.add_inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_inv_s_amt.value)) * 0.1) ;
			fm.add_inv_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_inv_s_amt.value)) + toInt(parseDigit(fm.add_inv_v_amt.value)));
		}else if(obj==fm.add_fee_s_amt){
			fm.add_fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) * 0.1) ;
			fm.add_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_v_amt.value)));
		}else if(obj==fm.add_navi_s_amt){
			fm.add_navi_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_navi_s_amt.value)) * 0.1) ;
			fm.add_navi_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_navi_s_amt.value)) + toInt(parseDigit(fm.add_navi_v_amt.value)));
		}else if(obj==fm.add_etc_s_amt){
			fm.add_etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_etc_s_amt.value)) * 0.1) ;
			fm.add_etc_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_v_amt.value)));
		}else if(obj==fm.add_cons1_s_amt){
			fm.add_cons1_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_cons1_s_amt.value)) * 0.1) ;
			fm.add_cons1_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_cons1_s_amt.value)) + toInt(parseDigit(fm.add_cons1_v_amt.value)));
		}else if(obj==fm.add_cons2_s_amt){
			fm.add_cons2_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_cons2_s_amt.value)) * 0.1) ;
			fm.add_cons2_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_cons2_s_amt.value)) + toInt(parseDigit(fm.add_cons2_v_amt.value)));			
			
		//부대비용
		}else if(obj==fm.cls_s_amt){
			fm.cls_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cls_s_amt.value)) * 0.1) ;
			if(fm.cls_vat.checked == true){ 
				fm.cls_v_amt.value 	= '0' ;
			}
			fm.cls_amt.value 	= parseDecimal(toInt(parseDigit(fm.cls_s_amt.value)) + toInt(parseDigit(fm.cls_v_amt.value)));
		}else if(obj==fm.ins_m_s_amt){
			fm.ins_m_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) * 0.1) ;
			if(fm.ins_m_vat.checked == true){ 
				fm.ins_m_v_amt.value 	= '0' ;
			}
			fm.ins_m_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)));
		}else if(obj==fm.ins_h_s_amt){
			fm.ins_h_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_h_s_amt.value)) * 0.1) ;
			if(fm.ins_h_vat.checked == true){ 
				fm.ins_h_v_amt.value 	= '0' ;
			}
			fm.ins_h_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)));
		}else if(obj==fm.oil_s_amt){
			fm.oil_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.oil_s_amt.value)) * 0.1) ;
			if(fm.oil_vat.checked == true){ 
				fm.oil_v_amt.value 	= '0' ;
			}
			fm.oil_amt.value 	= parseDecimal(toInt(parseDigit(fm.oil_s_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));
		}else if(obj==fm.km_s_amt){
			fm.km_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.km_s_amt.value)) * 0.1) ;
			fm.km_amt.value 	= parseDecimal(toInt(parseDigit(fm.km_s_amt.value)) + toInt(parseDigit(fm.km_v_amt.value)));
			
		//용역비용1
		}else if(obj==fm.d_pay_amt1 || obj==fm.d_pay_amt2){
			fm.d_pay_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.d_pay_amt1.value)) + toInt(parseDigit(fm.d_pay_amt2.value)));
		}

		//정상합계
		fm.ag_t_fee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_s_amt.value)) 	+ toInt(parseDigit(fm.ag_navi_s_amt.value))	+ toInt(parseDigit(fm.ag_etc_s_amt.value))	+ toInt(parseDigit(fm.ag_ins_s_amt.value))	);
		fm.ag_t_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_v_amt.value)) 	+ toInt(parseDigit(fm.ag_navi_v_amt.value))	+ toInt(parseDigit(fm.ag_etc_v_amt.value))		);
		fm.ag_t_fee_amt.value   	= parseDecimal( toInt(parseDigit(fm.ag_inv_amt.value)) 		+ toInt(parseDigit(fm.ag_navi_amt.value))	+ toInt(parseDigit(fm.ag_etc_amt.value))	+ toInt(parseDigit(fm.ag_ins_s_amt.value))	);		
		fm.ag_tot_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_s_amt.value))	);
		fm.ag_tot_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_amt.value)) 		+ toInt(parseDigit(fm.ag_cons1_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_amt.value))	);
		
						
		//추가합계
		fm.add_t_fee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.add_inv_s_amt.value)) 	+ toInt(parseDigit(fm.add_navi_s_amt.value))	+ toInt(parseDigit(fm.add_etc_s_amt.value))	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
		fm.add_t_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.add_inv_v_amt.value)) 	+ toInt(parseDigit(fm.add_navi_v_amt.value))	+ toInt(parseDigit(fm.add_etc_v_amt.value))		);
		fm.add_t_fee_amt.value   	= parseDecimal( toInt(parseDigit(fm.add_inv_amt.value)) 	+ toInt(parseDigit(fm.add_navi_amt.value))	+ toInt(parseDigit(fm.add_etc_amt.value))	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);		
		if(obj==fm.add_inv_s_amt || obj==fm.navi_s_amt || obj==fm.etc_s_amt || obj==fm.ins_s_amt){
			//추가 대여료총액, 합계
			var fee_s_amt 		= toInt(parseDigit(fm.add_t_fee_s_amt.value));			
			if(toInt(fm.add_months.value)+toInt(fm.add_days.value)>0){
				//fee_s_amt 	= parseDecimal( (fee_s_amt*toInt(fm.add_months.value)) + (fee_s_amt/30*toInt(fm.add_days.value)) );			
			}
			fm.add_fee_s_amt.value 	= fee_s_amt ;						
			fm.add_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.add_fee_s_amt.value)) * 0.1 ) ;			
			fm.add_fee_amt.value 	= parseDecimal( toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_v_amt.value)) );				
		}		
		fm.add_tot_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.add_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_s_amt.value))	);
		fm.add_tot_amt.value 		= parseDecimal( toInt(parseDigit(fm.add_fee_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_amt.value))	);

		//정산
		fm.tot_inv_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_inv_s_amt.value)) 	+ toInt(parseDigit(fm.add_inv_s_amt.value))	);
		fm.tot_fee_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_fee_s_amt.value))	);
		fm.tot_t_fee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_t_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_s_amt.value))	);
		fm.tot_navi_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_navi_s_amt.value)) 	+ toInt(parseDigit(fm.add_navi_s_amt.value))	);
		fm.tot_etc_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_etc_s_amt.value)) 	+ toInt(parseDigit(fm.add_etc_s_amt.value))	);
		fm.tot_ins_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
		fm.tot_cons1_s_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_s_amt.value))	);
		fm.tot_cons2_s_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons2_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_s_amt.value))	);
		
		fm.tot_inv_v_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_inv_v_amt.value)) 	+ toInt(parseDigit(fm.add_inv_v_amt.value))	);
		fm.tot_fee_v_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_v_amt.value)) 	+ toInt(parseDigit(fm.add_fee_v_amt.value))	);
		fm.tot_t_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_t_fee_v_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_v_amt.value))	);
		fm.tot_navi_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_navi_v_amt.value)) 	+ toInt(parseDigit(fm.add_navi_v_amt.value))	);
		fm.tot_etc_v_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_etc_v_amt.value)) 	+ toInt(parseDigit(fm.add_etc_v_amt.value))	);
		fm.tot_cons1_v_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons1_v_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_v_amt.value))	);
		fm.tot_cons2_v_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons2_v_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_v_amt.value))	);		

		fm.tot_inv_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_inv_amt.value)) 		+ toInt(parseDigit(fm.add_inv_amt.value))	);
		fm.tot_fee_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_amt.value)) 		+ toInt(parseDigit(fm.add_fee_amt.value))	);
		fm.tot_t_fee_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_t_fee_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_amt.value))	);
		fm.tot_navi_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_navi_amt.value)) 	+ toInt(parseDigit(fm.add_navi_amt.value))	);
		fm.tot_etc_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_etc_amt.value)) 		+ toInt(parseDigit(fm.add_etc_amt.value))	);
		fm.tot_ins_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
		fm.tot_cons1_amt.value		= parseDecimal( toInt(parseDigit(fm.ag_cons1_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_amt.value))	);
		fm.tot_cons2_amt.value		= parseDecimal( toInt(parseDigit(fm.ag_cons2_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_amt.value))	);		


		fm.rent_tot_s_amt.value = parseDecimal( toInt(parseDigit(fm.tot_fee_s_amt.value)) 	+ toInt(parseDigit(fm.tot_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.tot_cons2_s_amt.value))	);
		fm.rent_tot_amt2.value 	= parseDecimal( toInt(parseDigit(fm.tot_fee_amt.value)) 	+ toInt(parseDigit(fm.tot_cons1_amt.value)) 	+ toInt(parseDigit(fm.tot_cons2_amt.value))	);

		fm.etc_tot_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_s_amt.value)) 		+ toInt(parseDigit(fm.ins_m_s_amt.value)) 	+ toInt(parseDigit(fm.ins_h_s_amt.value)) 	+ toInt(parseDigit(fm.oil_s_amt.value)) 	+ toInt(parseDigit(fm.km_s_amt.value))		+ toInt(parseDigit(fm.fine_s_amt.value)));		
		fm.etc_tot_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_amt.value)) 		+ toInt(parseDigit(fm.ins_m_amt.value)) 	+ toInt(parseDigit(fm.ins_h_amt.value)) 	+ toInt(parseDigit(fm.oil_amt.value)) 		+ toInt(parseDigit(fm.km_amt.value))		+ toInt(parseDigit(fm.fine_s_amt.value)));		
						
		if(fm.rent_st.value == '1' || fm.rent_st.value == '12'){
			fm.rent_sett_amt.value = parseDecimal( toInt(parseDigit(fm.rent_tot_amt2.value)) + toInt(parseDigit(fm.etc_tot_amt.value)) - toInt(parseDigit(fm.t_dc_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
		}else{
			fm.rent_sett_amt.value = parseDecimal( toInt(parseDigit(fm.rent_tot_amt2.value)) + toInt(parseDigit(fm.etc_tot_amt.value)) - toInt(parseDigit(fm.t_dc_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)));
		}
		
		<%}%>
		
	}			

	//용역비용:결재 디스플레이
	function driv_display(){
		var fm = document.form1;
		if(fm.driv_serv_st.options[fm.driv_serv_st.selectedIndex].value == '2'){
			tr_drv2.style.display	= '';						
		}else{
			tr_drv2.style.display	= 'none';
			fm.d_paid_dt1.value = '';
			fm.d_paid_dt2.value = '';
			fm.d_pay_amt1.value = '0';
			fm.d_pay_amt2.value = '0';
			fm.d_pay_tot_amt.value = '0';			
		}	
	}	
	
	//금액 셋팅	
	function pay_set_amt(){
		var fm = document.form1;	
		if(fm.mode.value != 'u') return;		
		fm.rest_amt1.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt2.value)) - toInt(parseDigit(fm.pay_amt1.value))) ;
		fm.rest_amt2.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt2.value)) - toInt(parseDigit(fm.pay_amt1.value)) - toInt(parseDigit(fm.pay_amt2.value))) ;
	}			
	


	
	// 기타 ------------------------------------------------------------------------------------------------
	
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


	//취소하기
	function all_reset(){
		var fm = document.form1;	
		fm.reset();
	}
	
	//저장하기
	function save(upd_mode){
		var fm = document.form1;
		fm.upd_mode.value = upd_mode;		
		if(fm.ret_dt.value != ''){
			fm.h_ret_dt.value = fm.ret_dt.value+fm.ret_dt_h.value+fm.ret_dt_s.value;		
		}
		if(!confirm('수정하시겠습니까?')){	return;	}	
		fm.action = 'rent_settle_u_a.jsp';
//		fm.target = 'd_content';
		fm.target='i_no';
		fm.submit();
	}
	
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		fm.action = 'rent_en_frame_s.jsp';
		if(fm.list_from_page.value != '') fm.action = fm.list_from_page.value;
		fm.target = 'd_content';
		fm.submit();			
	}	
	
	//예약시스템 계약서
	function view_scan_res(c_id, s_cd){
		window.open("/acar/rent_mng/res_rent_u_print.jsp?c_id="+c_id+"&s_cd="+s_cd+"&mode=fine_doc", "VIEW_SCAN_RES", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}
	

	
	//스캔등록
	function scan_reg(file_st){
		window.open("/acar/res_stat/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=c_id%>&rent_l_cd=<%=s_cd%>&from_page=/acar/res_mng/res_rent_u.jsp&file_st="+file_st, "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}
	
		

	//삭제하기
	function remove(seq, st_nm){
		fm = document.form1;
		fm.remove_seq.value = seq;
		if(!confirm(st_nm+" 파일을 삭제하시겠습니까?"))		return;		
		fm.target = "i_no";
		fm.action='/acar/res_stat/reg_scan.jsp';
		fm.submit();
	}	
	
	//스캔관리 보기
	function view_scan(){
		window.open("/acar/res_stat/scan_view.jsp?c_id=<%=c_id%>&s_cd=<%=s_cd%>&from_page=/acar/res_mng/res_rent_u.jsp", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}	
	
	<%if(rent_st.equals("12") && !rf_bean.getEst_id().equals("") && !e_bean.getRent_dt().equals("")){%>
	function EstiPrintRm(a_a,rent_way,a_b,amt){ 		
		var fm = document.form1;  		
		var SUBWIN="/acar/secondhand_hp/estimate_rm_new.jsp?from_page=secondhand_hp&car_mng_id=<%= c_id %>&est_id=<%=rf_bean.getEst_id()%>&today_dist=<%=e_bean.getToday_dist()%>&o_1=<%=e_bean.getO_1()%>&rent_dt=<%=e_bean.getRent_dt()%>&est_code=<%=e_bean.getReg_code()%>&a_a=21&a_b=1&amt=<%=e_bean.getFee_s_amt()%>";  	
		if(<%=e_bean.getRent_dt()%> > 20120830){
			SUBWIN="/acar/secondhand_hp/estimate_rm_new.jsp?from_page=secondhand_hp&car_mng_id=<%= c_id %>&est_id=<%=rf_bean.getEst_id()%>&today_dist=<%=e_bean.getToday_dist()%>&o_1=<%=e_bean.getO_1()%>&rent_dt=<%=e_bean.getRent_dt()%>&est_code=<%=e_bean.getReg_code()%>&a_a=21&a_b=1&amt=<%=e_bean.getFee_s_amt()%>";  	
		}
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 		
	}
	<%}%>
	
	function RentMemo(s_cd, c_id, user_id){
		var SUBWIN="/acar/con_rent/res_memo_i.jsp?s_cd="+s_cd+"&c_id="+c_id+"&user_id="+user_id;	
		window.open(SUBWIN, "RentMemoDisp", "left=100, top=100, width=580, height=700, scrollbars=yes");
	}
	
	//미수과태료리스트
	function viewSettleFine(){
		var fm = document.form1;
		var SUBWIN="/acar/rent_settle/view_settle_fine.jsp?c_id="+fm.c_id.value+"&s_cd="+fm.s_cd.value;	
		window.open(SUBWIN, "ViewSettleFine", "left=50, top=50, width=820, height=400, scrollbars=yes");		
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
	
			
//-->
</script>
</head>
<body leftmargin="15">

<form action="rent_settle_i_a.jsp" name="form1" method="post" >
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
 
 <input type='hidden' name='c_id' value='<%=c_id%>'>
 <input type='hidden' name='s_cd' value='<%=s_cd%>'> 
 <input type='hidden' name='rent_st' value='<%=rent_st%>'>
 <input type='hidden' name='use_st' value='<%=use_st%>'>
 <input type='hidden' name='cust_id' value='<%=rc_bean.getCust_id()%>'>
 <input type='hidden' name='sub_c_id' value='<%=rc_bean.getSub_c_id()%>'>
 <input type='hidden' name='h_rent_start_dt' value='<%=rc_bean.getRent_start_dt()%>'>
 <input type='hidden' name='h_rent_end_dt' value='<%=rc_bean.getRent_end_dt()%>'>
 <input type='hidden' name='h_deli_dt' value='<%=rc_bean.getDeli_dt()%>'>
 <input type='hidden' name='h_ret_dt' value='<%=rc_bean.getRet_dt()%>'> 
 <input type='hidden' name='section' value='<%=reserv.get("SECTION")%>'> 
 <input type='hidden' name='sub_l_cd' value='<%=rc_bean.getSub_l_cd()%>'> 
 <input type='hidden' name='ins_yn' value='<%=rf_bean.getIns_yn()%>'>   
 <input type='hidden' name='upd_mode' value=''>   
 <input type='hidden' name='from_page' value='/acar/res_mng/res_rent_u.jsp'>
 <input type='hidden' name='remove_seq' value=''> 
 <input type='hidden' name='rent_mng_id' value='<%=c_id%>'>
 <input type='hidden' name='rent_l_cd' value='<%=s_cd%>'>
 <input type='hidden' name='amt_per' value='<%=rf_bean.getAmt_per()%>'>        
 <input type='hidden' name='day_s_amt' value='<%=rf_bean.getInv_s_amt()%>'>
 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 영업지원 > 사후관리 > <span class=style5><%if(rent_st.equals("1")){%>
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
                    기타 
                    <%}else if(rent_st.equals("12")){%>
                    월렌트
                    <%}%></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr><td class=h></td></tr>
    <tr><td class=h></td></tr>   
    <%if(!mode.equals("view")){%>	
    <tr> 
        <td width="20%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span></td>
        <td align="right" width="80%">
        
            <%if(!rent_st.equals("12")){%>	
    	        <img src=/acar/images/center/arrow.gif>     	    
		<%=reserv.get("CAR_NO")%>
		<a href="javascript:car_reserve();"><img src="/acar/images/center/button_list_dy.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
    		<a href="javascript:car_reserve2();"><img src="/acar/images/center/button_list_dg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;			
    	        <a href='res_rent_p.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_dggy.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp; 
		<a href="javascript:view_scan_res('<%=c_id%>','<%=s_cd%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>&nbsp;&nbsp; 
    	        <a href='rent_settle_p.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="_blank">정산서<img src="/images/print.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
                ||&nbsp;&nbsp;
            <%}%>            
            <a href='javascript:go_to_list();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>
            
            
    		&nbsp;<a href='../rent_mng/res_rent_u.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="d_content"> . </a>
    	    
    	    
        </td>
    </tr>
    <%}%>
    <tr>
        <td class=line2 colspan=2></td>
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
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right"> 
        <%if(!mode.equals("view")){%>	
            <!--<a href='javascript:save();'> <img src="/images/up_info.gif" width="50" height="18" aligh="absmiddle" border="0"> 
            </a> -->
            <a href="javascript:RentMemo('<%=s_cd%>','<%=c_id%>','<%=ck_acar_id%>');" class="btn" title='통화내역보기'><img src=/acar/images/center/button_th.gif align=absmiddle border=0></a>&nbsp;
            <a href="javascript:move_fee_scd()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_sch.gif align=absmiddle border="0"></a>&nbsp;&nbsp;		        
            &nbsp;&nbsp;
    	    <%if(rent_st.equals("12")){%>
    	    <a href='rent_settle_p_rm.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="_blank"><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>
    	    <%}%>
    	<%}%>
	</td>
    </tr>
    <%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>구분</td><!--<a href="javascript:cust_select()"></a>-->
                    <td colspan=2> 
                      &nbsp;<input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
                      <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="20" class=whitetext>
                    </td>
                    <td class=title>성명</td>
                    <td colspan="2"> 
                      &nbsp;<input type="text" name="c_cust_nm" value="<%=rc_bean2.getCust_nm()%>" size="25" class=whitetext>
                    </td>
                    <td class=title>생년월일</td>
                    <td> 
                      &nbsp;<input type="text" name="c_ssn" value="<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>상호</td>
                    <td colspan="5"> 
                      &nbsp;<input type="text" name="c_firm_nm" value="<%=rc_bean2.getFirm_nm()%>" size="80" class=whitetext>
                      &nbsp;<span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
                    </td>
                    <td class=title>사업자등록번호</td>
                    <td> 
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
					<input type="text" name='c_zip' id="c_zip" size="7" value="<%=rc_bean2.getZip()%>" maxlength='7' >
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='c_addr' id="c_addr"  value="<%=rc_bean2.getAddr()%>"  size="100">

                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>운전면허번호</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="c_lic_no" value="<%=rm_bean4.getLic_no()%>" size="16" class=whitetext onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                    </td>
                    <td class=title width=10%>면허종류</td>
                    <td width=10%> 
                      &nbsp;<select name='c_lic_st' <%=disabled%>>
                        <option value=''>선택</option>
                        <option value='1' <%if(rm_bean4.getLic_st().equals("1"))%>selected<%%>>2종보통</option>
                        <option value='2' <%if(rm_bean4.getLic_st().equals("2"))%>selected<%%>>1종보통</option>
                        <option value='3' <%if(rm_bean4.getLic_st().equals("3"))%>selected<%%>>1종대형</option>
                      </select>
                    </td>
                    <td class=title width=11%>전화번호</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="c_tel" value="<%=rm_bean4.getTel()%>" class=whitetext size="15">
                    </td>
                    <td class=title width=10%>휴대폰</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="c_m_tel" value="<%=rm_bean4.getEtc()%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>비상연락처</td>
                    <td  colspan='7'> 
                      <input type="hidden" name="mgr_st2" value="2">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 성명:&nbsp;
                      <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=whitetext size="10">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 연락처:&nbsp; 
                      <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=whitetext>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 관계:&nbsp; 
                      <input type="text" name="m_etc2" value="<%=rm_bean2.getEtc()%>" size="58" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title rowspan="3"><%if(rent_st.equals("12")){%>추가운전자<%}else{%>실운전자<br>(용역기사 등)<%}%></td>
                    <td  colspan='7'> 
                      <input type="hidden" name="mgr_st1" value="1">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 성명:&nbsp; 
                      <input type="text" name="mgr_nm1" value="<%=rm_bean1.getMgr_nm()%>" class=whitetext size="10">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 생년월일:&nbsp; 
                      <input type="text" name="m_ssn1" value="<%=AddUtil.ChangeEnpH(rm_bean1.getSsn())%>" size="15" class=whitetext>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 운전면허번호:&nbsp; 
                      <input type="text" name="m_lic_no1" value="<%=rm_bean1.getLic_no()%>" size="16" class=whitetext>
                      &nbsp; <img src=/acar/images/center/arrow.gif> 면허종류:&nbsp; 
                      <select name='m_lic_st1' <%=disabled%>>
                        <option value=''>선택</option>
                        <option value='1' <%if(rm_bean1.getLic_st().equals("1"))%>selected<%%>>2종보통</option>
                        <option value='2' <%if(rm_bean1.getLic_st().equals("2"))%>selected<%%>>1종보통</option>
                        <option value='3' <%if(rm_bean1.getLic_st().equals("3"))%>selected<%%>>1종대형</option>
                      </select> 
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 전화번호:&nbsp; 
                      <input type="text" name="m_tel1" value="<%=rm_bean1.getTel()%>" size="15" class=whitetext>
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
                    <td  colspan='7'>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 주소:&nbsp;
					<input type="text" name='m_zip1' id="m_zip1" size="7" value="<%=rm_bean1.getZip()%>" maxlength='7' >
					<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='m_addr1' id="m_addr1"  value="<%=rm_bean1.getAddr()%>"  size="100">

                    </td>
                </tr>
                <tr> 
                    <td  colspan='7'>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 기타:&nbsp;
                      &nbsp;<input type="text" name="m_etc1" value="<%=rm_bean1.getEtc()%>" size="113" class=whitetext>
                    </td>
                </tr>
                <%if(rent_st.equals("12")){%>
                <tr> 
                   <td class=title width=10%>차량사용용도</td>
                    <td colspan='7'> 
                      &nbsp;<input type="text" name="car_use" value="<%=rf_bean.getCar_use()%>" size="60" class=whitetext>
                    </td>                                           
                </tr>
                <%}%>                           
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("10")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>구분</td><!--<a href="javascript:cust_select()"></a>-->
                    <td width=20%> 
                      &nbsp;<input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
                      <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>성명</td>
                    <td width=21%> 
                      &nbsp;<input type="text" name="c_cust_nm" value="<%=rc_bean2.getCust_nm()%>" size="27" class=whitetext>
                    </td>
                    <td class=title width=10%>생년월일</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="c_ssn" value="<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%>" size="15" class=whitetext>
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
                <tr> 
                    <td class=title>비상연락처</td>
                    <td  colspan='7'> 
                      &nbsp;<input type="hidden" name="mgr_st2" value="2">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 성명:&nbsp; 
                      <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=whitetext size="10">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 연락처:&nbsp;
                      <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=whitetext>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 관계:&nbsp; 
                      <input type="text" name="m_etc2" value="<%=rm_bean2.getEtc()%>" size="58" class=whitetext>
                    </td>
                </tr>
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
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>구분</td>
                    <td width=10%> 
                        &nbsp;<input type='hidden' name='cust_st' value='4'>
                        <input type="text" name="c_cust_st" value="직원" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>성명</td>
                    <td width=10%> 
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
                    <td class=title width=11%>영업소명</td>
                    <td width=10%> 
                        &nbsp;<input type="text" name="c_brch_nm" value="<%=rc_bean2.getBrch_nm()%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>부서명</td>
                    <td> 
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
    <tr id=tr_gua style="display:<%if(rent_st.equals("1") || rent_st.equals("12")) {%>''<%}else{%>none<%}%>"'>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연대보증인</span></td>
    </tr>
    <tr id=tr_gua1 style="display:<%if(rent_st.equals("1") || rent_st.equals("12") ) {%>''<%}else{%>none<%}%>"'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>보증여부</td>
                    <td width=90%> 
                      &nbsp;<select name="gua_st" onchange="javascript:gua_display()" disabled>
                        <option value="">==선택==</option>
                        <option value="1" <%if(rf_bean.getGua_st().equals("1")){%>selected<%}%>>입보</option>
                        <option value="2" <%if(rf_bean.getGua_st().equals("2")){%>selected<%}%>>면제</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr id=tr_gua2 style="display:<%if((rent_st.equals("1") || rent_st.equals("12")) && rf_bean.getGua_st().equals("1")) {%>''<%}else{%>none<%}%>"'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>성명</td>
                    <td width=10%> 
                      &nbsp;<input type="hidden" name="mgr_st3" value="3">
                      <input type="text" name="mgr_nm3" value="<%=rm_bean3.getMgr_nm()%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>생년월일</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="m_ssn3" value="<%=AddUtil.ChangeEnpH(rm_bean3.getSsn())%>" size="14" class=whitetext onBlur='javscript:this.value = ChangeSsn(this.value);'>
                    </td>
                    <td class=title width=11%>전화번호</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="m_tel3" value="<%=rm_bean3.getTel()%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>계약자와의 관계</td>
                    <td> 
                      &nbsp;<input type="text" name="m_etc3" value="<%=rm_bean3.getEtc()%>" size="9" class=whitetext>
                    </td>
                </tr>
				<script>
					function openDaumPostcode1() {
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
					<input type="text" name='m_zip3' id="m_zip3" size="7" value="<%=rm_bean3.getZip()%>" maxlength='7' >
					<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='m_addr3' id="m_addr3"  value="<%=rm_bean3.getAddr()%>"  size="100">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_gua3 style="display:<%if((rent_st.equals("1") || rent_st.equals("12")) && rf_bean.getGua_st().equals("2")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>면제사유</td>
                    <td> 
                      &nbsp;<input type="text" name="gua_cau" value="<%=rf_bean.getGua_cau()%>" size="109" class=whitetext>
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
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>정비공장명</td>
                    <td width=20%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%>정비차량번호</td>
                    <td width=21%>&nbsp;<%=serv.get("CAR_NO")%></td>
                    <td class=title width=10%>차종</td>
                    <td width=29%>&nbsp;<%=serv.get("CAR_NM")%></td>
                </tr>
                <tr>
                    <td class=title width="10%">대여방식</td>
                    <td colspan='5'>&nbsp;<%=cont_view.get("RENT_WAY")%>&nbsp;(<%=cont_view.get("RENT_START_DT")%>~)
                    </td>
                </tr>                      
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("3")){
		//사고대차정보
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());%>
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
                    <td class=title width=10%>정비공장명</td>
                    <td width=20%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=10%>피해차량번호</td>
                    <td width=21%>&nbsp;<%=accid.get("CAR_NO")%></td>
                    <td class=title width=10%>차종</td>
                    <td width=29%>&nbsp;<%=accid.get("CAR_NM")%></td>
                </tr>
                <tr> 
                    <td class=title> 접수번호</td>
                    <td>&nbsp;<%=accid.get("P_NUM")%></td>
                    <td class=title>가해자보험사</td>
                    <td>&nbsp;<%=accid.get("G_INS")%></td>
                    <td class=title>담당자</td>
                    <td>&nbsp;<%=accid.get("G_INS_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rent_st.equals("9")){
		//보험대차정보
		RentInsBean ri_bean = rs_db.getRentInsCase(rc_bean.getRent_s_cd());%>
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
                    <td>&nbsp;<%=ri_bean.getIns_num()%></td>
                    <td class=title>보험사</td>
                    <td colspan="5"> 
                      &nbsp;<select name='ins_com_id' disabled>
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
                    <td width=10%>&nbsp;<%=ri_bean.getIns_nm()%></td>
                    <td class=title width=10%>연락처Ⅰ</td>
                    <td width=10%>&nbsp;<%=ri_bean.getIns_tel()%></td>
                    <td class=title width=11%">연락처Ⅱ</td>
                    <td width=10%>&nbsp;<%=ri_bean.getIns_tel2()%></td>
                    <td class=title width=10%>팩스</td>
                    <td>&nbsp;<%=ri_bean.getIns_fax()%></td>
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
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>정비공장명</td>
                    <td width=41%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%> 정비일자</td>
                    <td width=39%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%></td>
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
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>검사유효기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
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
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>정비공장명</td>
                    <td width=20%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=10%>사고일자</td>
                    <td width=21%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%></td>
                    <td class=title width=10%>담당자</td>
                    <td width=29%>&nbsp;<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>사고내용</td>
                    <td colspan="5">&nbsp;<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%></td>
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
        &nbsp;&nbsp;<img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(rc_bean.getReg_id(), "USER")%>&nbsp;&nbsp;<img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> :
        <%=AddUtil.ChangeDate2(rc_bean.getReg_dt())%>
        <%}%>	  
        <%if(!rc_bean.getUpdate_id().equals("")){%>
        &nbsp;&nbsp;<img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(rc_bean.getUpdate_id(), "USER")%>&nbsp;&nbsp;<img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> :
        <%=AddUtil.ChangeDate2(rc_bean.getUpdate_dt())%>
        <%}%>
        </font></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td width=10%>&nbsp;<%=rc_bean.getRent_s_cd()%></td>
                    <td class=title width=10%>계약일자</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
                    <td class=title width=11%>영업소</td>
                    <td width=10%>&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(), "BRCH")%></td>
                    <td class=title width=10%><%if(rent_st.equals("12")) {%>최초영업자<%}else{%>담당자<%}%></td>
                    <td colspan=3>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(), "USER")%></td>
                </tr>
                <tr>                     
                    <td class=title>약정기간</td>
                    <td colspan=9>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>~ 
                      <%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%></td>
                </tr>
    		  <%
    			if(ext_size > 0){
    				for(int i = 0 ; i < ext_size ; i++){
    					Hashtable ext = (Hashtable)exts.elementAt(i);%>		  
                <tr> 
                    <td class=title>연장 [<%=i+1%>]</td>
                    <td colspan="9">&nbsp; 
                        계약일자 : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_DT")))%> &nbsp;&nbsp;
                        | 대여기간 : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_END_DT")))%> &nbsp;&nbsp; 
                        (<%=ext.get("RENT_MONTHS")%>개월<%=ext.get("RENT_DAYS")%>일)                   	
                    </td>
                </tr>
    		  <%		
    		  		}
    		  	}%> 	                
                <tr> 
                    <td class=title>기타</td>
                    <td colspan=9>&nbsp;<%=rc_bean.getEtc()%></td>                    
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차/반차</span></td>
	    <td align="right">
	    <%if(!mode.equals("view")){%>	
                <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                <%	if(!rc_bean.getRet_dt_d().equals("")){%>
                <a href="javascript:save('rent_cont');"> <img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
                <%	}%>
                <%}%>
                <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
    		&nbsp;<a href='../rent_mng/res_rent_u.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="d_content"> . </a>
    	        <%}%>
            <%}%>
	    </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>배차예정일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_plan_dt())%>
                    </td>
                    <td class=title>반차예정일시</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_plan_dt())%></td>
                </tr>
                <tr> 
                    <td class=title>배차일시</td>
                    <td>
        			&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class=title>반차일시</td>
                    <td colspan="3">
                      &nbsp;<input type="text" name="ret_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime()'>
                      <select name="ret_dt_h" <%=disabled%>>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="ret_dt_s" <%=disabled%>>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>						
        			<%//=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
                </tr>
                <tr> 
                    <td class=title>배차위치</td>
                    <td>&nbsp;<%=rc_bean.getDeli_loc()%></td>
                    <td class=title>반차위치</td>
                    <td colspan="3">&nbsp;<%=rc_bean.getRet_loc()%></td>
                </tr>
                <tr> 
                    <td class=title>배차담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getDeli_mng_id(), "USER")%></td>
                    <td class=title>반차담당자</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(rc_bean.getRet_mng_id(), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>당초약정시간</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="2" class=whitenum readonly>
                      시간 
                      <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=whitenum readonly>
                      일 
                      <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="2" class=whitenum readonly>
                      개월 </td>
                    <td class=title width=10%>추가이용시간</td>
                    <td width=21%> 
                      &nbsp;<input type="text" name="add_hour" value="<%=rs_bean.getAdd_hour()%>" size="2" class=<%=white%>num >
                      시간 
                      <input type="text" name="add_days" value="<%=rs_bean.getAdd_days()%>" size="2" class=<%=white%>num >
                      일 
                      <input type="text" name="add_months" value="<%=rs_bean.getAdd_months()%>" size="2" class=<%=white%>num >
                      개월 </td>
                    <td class=title width=10%>총이용시간</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="tot_hour" value="<%=rs_bean.getTot_hour()%>" size="2" class=<%=white%>num >
                      시간 
                      <input type="text" name="tot_days" value="<%=rs_bean.getTot_days()%>" size="2" class=<%=white%>num >
                      일 
                      <input type="text" name="tot_months" value="<%=rs_bean.getTot_months()%>" size="2" class=<%=white%>num >
                      개월 </td>
                </tr>
                <tr> 
                    <td class=title>비고</td>
                    <td colspan="5"> 
                      &nbsp;<input type="text" name="etc" value="" size="110" class=<%=white%>text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>
    <tr id=tr_fee style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) {%>'' <%} else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금</span></td>
	    <td align="right">
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <!--<a href="javascript:save('rent_fee');"> <img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a> -->
        <%}%>
	    </td>	  
    </tr>
    <tr id=tr_fee style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                        
                <tr> 
                    <td class=title width=10%>세금계산서</td>
                    <td width=20%> 
                      &nbsp;<select name="tax_yn" disabled>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getTax_yn().equals("Y")){%>selected<%}%>>발행</option>
                        <option value="N" <%if(rf_bean.getTax_yn().equals("N")){%>selected<%}%>>미발행</option>
                      </select>
                    </td>
                    <td class=title width=10%>선택보험</td>
                    <td width=30%> 
                      &nbsp;<select name="ins_yn" disabled>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getIns_yn().equals("Y")){%>selected<%}%>>가입</option>
                        <option value="N" <%if(rf_bean.getIns_yn().equals("N")){%>selected<%}%>>미가입</option>
                      </select>
                      (면책금 : <input type='text' size='12' maxlength='7' name='car_ja' class='whitenum' value='<%=AddUtil.parseDecimal(rf_bean.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			원)</td>
                    </td>
                    <td class=title width=10%>휴차보상료</td>
                    <td> 
                      &nbsp;<select name="my_accid_yn" disabled>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getMy_accid_yn().equals("Y")){%>selected<%}%>>고객부담</option>
                        <option value="N" <%if(rf_bean.getMy_accid_yn().equals("N")){%>selected<%}%>>면제</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>결제방법</td>
                    <td> 
                      &nbsp;<select name="paid_way" disabled>
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
                	                &nbsp;<select name="paid_st" disabled>
                    	              <option value="">==선택==</option>			  
                        	          <option value="1" <%if(rf_bean.getPaid_st().equals("1")){%>selected<%}%>>현금</option>
                            	      <option value="2" <%if(rf_bean.getPaid_st().equals("2")){%>selected<%}%>>신용카드</option>
                	                </select>				  </td>				
            				    <td id=td_paid style='display:none'>(카드NO. : 
                		            <input type="text" name="card_no" value="<%=rf_bean.getCard_no()%>" size="30" class=<%=white%>text>
                	                 )
            				    </td>				   
                                <td align="right">&nbsp; </td>
            				</tr>
        			    </table>
                    </td>
                    <!--
                    <td class=title width=10%>운전기사</td>
                    <td width=29%> 
                      &nbsp;<select name="driver_yn" <%=disabled%>>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getDriver_yn().equals("Y")){%>selected<%}%>>포함</option>
                        <option value="N" <%if(rf_bean.getDriver_yn().equals("N")){%>selected<%}%>>미포함</option>
                      </select>
                      -->
                </tr>
                <tr> 
                    <td class=title>주유량</td>
                    <td> 
                      &nbsp;<select name="oil_st" disabled>
                        <option value="">==선택==</option>			  
                        <option value="1" <%if(rf_bean.getOil_st().equals("1")){%>selected<%}%>>1칸</option>
                        <option value="2" <%if(rf_bean.getOil_st().equals("2")){%>selected<%}%>>2칸</option>
                        <option value="3" <%if(rf_bean.getOil_st().equals("3")){%>selected<%}%>>3칸</option>
                        <option value="f" <%if(rf_bean.getOil_st().equals("f")){%>selected<%}%>>full</option>
                      </select>
                    </td>                        
                    <td class=title>내비게이션</td>
                    <td> 
                      &nbsp;<select name="navi_yn" disabled>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getNavi_yn().equals("Y")){%>selected<%}%>>있음</option>
                        <option value="N" <%if(rf_bean.getNavi_yn().equals("N")){%>selected<%}%>>없음</option>
                      </select>&nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> S / N:&nbsp;<input type='text' name='serial_no'  value="<%=rf_bean.getSerial_no()%>"  size='25' class='text'  readonly >               
                    </td>
                    <td class=title width=10%>GPS</td>
                    <td> 
                      &nbsp;<select name="gps_yn" disabled>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getGps_yn().equals("Y")){%>selected<%}%>>있음</option>
                        <option value="N" <%if(rf_bean.getGps_yn().equals("N")){%>selected<%}%>>없음</option>
                      </select>
                    </td>
                </tr>          
                <tr> 
                    <td class=title>배차주행거리</td>
                    <td> 
                      &nbsp;<input type="text" name="dist_km" value="<%=AddUtil.parseDecimal(rf_bean.getDist_km())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      km
                    </td>                        
                    <td class=title>탁송요청</td>
                    <td colspan='3'> 
                      &nbsp;<select name="cons_yn" disabled>
                        <option value="">==선택==</option>			  
                        <option value="Y" <%if(rf_bean.getCons_yn().equals("Y")){%>selected<%}%>>있음</option>
                        <option value="N" <%if(rf_bean.getCons_yn().equals("N")){%>selected<%}%>>없음</option>
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
                      <select name='cms_bank' disabled>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        				for(int i = 0 ; i < bank_size ; i++){
        					CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(rf_bean.getCms_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        			}%>
                      </select>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 계좌번호:&nbsp; 
                      <input type='text' name='cms_acc_no' value='<%=rf_bean.getCms_acc_no()%>' size='20' class='whitetext'>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 예금주:&nbsp; 
                      <input type='text' name='cms_dep_nm' value='<%=rf_bean.getCms_dep_nm()%>' size='20' class='whitetext'>
                    </td>
                </tr>    
                <%if(rent_st.equals("12")){%>
                <tr> 
                    <td class=title>월렌트요금</td>
                    <td colspan="5">&nbsp;월대여료 : <%=AddUtil.parseDecimal(e_bean.getFee_s_amt())%>원 (공급가)
                    	<input type='hidden' name='rm1' value='<%=e_bean.getFee_s_amt()%>'> 
                    	<%if(!rf_bean.getEst_id().equals("")){%>
                          <a href="javascript:EstiPrintRm('2','1','1','<%=e_bean.getFee_s_amt()%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                          &nbsp;
                          (<%=rf_bean.getEst_id()%>)
                        <%}%> 
                        &nbsp;       
                        할인율 : <input type='text' name='amt_per' value='<%=rf_bean.getAmt_per()%>' size='10' class='whitetext'>                      
                    </td>
                </tr>				
                <%}else{%>                 
                <input type='hidden' name="amt_per" value="<%=rf_bean.getAmt_per()%>">                         
                <%}%>
            </table>
        </td>
    </tr>	
    <tr></tr><tr></tr>
    <tr id=tr_fee1 style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
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
                  <td width="8%" class=title>내비게이션</td>
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
                      <input type="text" name="inv_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="dc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="navi_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>부가세</td>
                    <td align="center"> 
                      <input type="text" name="inv_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="dc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="navi_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="etc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>합계</td>
                    <td align="center"> 
                      <input type="text" name="inv_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getInv_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt()+rf_bean.getDc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="navi_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="etc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="ins_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <!--
                <tr> 
                    <td class=title colspan="2">총결제금액</td>
                    <td align="center"> 
                      &nbsp;<input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td colspan="7"> 
                      &nbsp;</td>    
                </tr>
                -->
                <tr> 
                    <td class=title>최초결제금액</td>
                    <td align="center"> 
                      &nbsp;<input type="text" name="f_rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getF_rent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td class=title>최초결제방식</td>
                    <td colspan="8">&nbsp; 
                      <select name="f_paid_way" disabled>
                        <option value="">==선택==</option>			  
                        <option value="1" <%if(rf_bean.getF_paid_way().equals("1")){%>selected<%}%>>1개월치</option>
                        <option value="2" <%if(rf_bean.getF_paid_way().equals("2")){%>selected<%}%>>총액</option>
                      </select>
                      &nbsp; 반차료
                      <select name="f_paid_way2" disabled>
                        <option value="">==선택==</option>			  
                        <option value="1" <%if(rf_bean.getF_paid_way2().equals("1")){%>selected<%}%>>포함</option>
                        <option value="2" <%if(rf_bean.getF_paid_way2().equals("2")){%>selected<%}%>>미포함</option>
                      </select>
                      </td>  
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
    <tr id=tr_pre style="display:<%if(rf_bean.getPaid_way().equals("1")) {%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선수금/보증금</span></td>
    </tr>
    <tr id=tr_pre1 style="display:<%if(rf_bean.getPaid_way().equals("1")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=20%>입금구분</td>
                    <td class=title width=20%>납부구분</td>
                    <td class=title width=20%>입금일자</td>
                    <td class=title width=20%>입금금액</td>
                    <td class=title width=20%>잔액</td>
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st1" value="1">
                      예약보증금</td>
                    <td align="center"> 
                      <select name="paid_st1" <%=disabled%>>
                        <option value="">==선택==</option>			  			  
                        <option value="1" <%if(sr_bean1.getPaid_st().equals("1")){%>selected<%}%>>현금</option>
                        <option value="2" <%if(sr_bean1.getPaid_st().equals("2")){%>selected<%}%>>카드</option>
                        <option value="3" <%if(sr_bean1.getPaid_st().equals("3")){%>selected<%}%>>자동이체</option>				
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="pay_dt1" value="<%=AddUtil.ChangeDate2(sr_bean1.getPay_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="pay_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getPay_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rest_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getRest_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st2" value="2">
                      대여료(배차)</td>
                    <td align="center"> 
                      <select name="paid_st2" <%=disabled%>>
                        <option value="">==선택==</option>			  			  
                        <option value="1" <%if(sr_bean2.getPaid_st().equals("1")){%>selected<%}%>>현금</option>
                        <option value="2" <%if(sr_bean2.getPaid_st().equals("2")){%>selected<%}%>>카드</option>
                        <option value="3" <%if(sr_bean2.getPaid_st().equals("3")){%>selected<%}%>>자동이체</option>				
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="pay_dt2" value="<%=AddUtil.ChangeDate2(sr_bean2.getPay_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="pay_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getPay_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      원</td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rest_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getRest_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>		
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여정산</span></td>
	    <td align="right">
        <%if((auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) && (br_id.equals("S1") || rc_bean.getBrch_id().equals(br_id))){%>
        <%	if(!rs_bean.getSett_dt().equals("")){%>
        <a href="javascript:save('rent_settle');"> <img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
        <%	}%>
        <%}%>
        <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
    		&nbsp;<a href='../rent_settle/rent_settle_i.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="d_content"> . </a>
    	<%}%>
	    </td>	  	
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>정산일자</td>
                    <td width=41%> 
                      &nbsp;<input type="text" name="sett_dt" value="<%=AddUtil.ChangeDate2(rs_bean.getSett_dt())%>" size="12" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>누적주행거리</td>
                    <td width=39%> 
                      &nbsp;<input type="text" name="run_km" value="<%=rs_bean.getRun_km()%>" size="10" class=<%=white%>num >
                      km </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr id=tr_sett1 style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10% rowspan="2" class=title>구분</td>
                    <td colspan="5" class=title>월대여료</td>
                    <td width=10% rowspan="2" class=title>대여료총액</td>                    
                    <td width=8% rowspan="2" class=title>배차료</td>
                    <td width=8% rowspan="2" class=title>반차료</td>
                    <td width=10% rowspan="2" class=title>합계<br>(공급가)</td>
                    <td width=10% rowspan="2" class=title>합계<br>(VAT포함)</td>
                </tr>
                <tr>
                  <td width=9% class=title>차량</td>
                  <td width=8% class=title>내비게이션</td>
                  <td width=9% class=title>기타</td>
                  <td width=9% class=title>선택보험료</td>
                  <td width=9% class=title>합계</td>
                </tr>            
                <tr> 
                    <td class=title>정상</td>
                    <td align="center">
                      <input type="text" name="ag_inv_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+ext_pay_rent_s_amt)%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='ag_inv_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_inv_amt'   value='<%=rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_navi_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='ag_navi_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>'>			 
                      <input type='hidden' name='ag_navi_amt'   value='<%=rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='ag_etc_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>'>			 
                      <input type='hidden' name='ag_etc_amt'   value='<%=rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_ins_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                    </td>
                    <td align="center">
                      <input type="text" name="ag_t_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getIns_s_amt()+ext_pay_rent_s_amt)%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='ag_t_fee_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_t_fee_amt'   value='<%=rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getIns_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>                      
                    <td align="center">
                      <input type="text" name="ag_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+ext_pay_rent_s_amt)%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='ag_fee_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_fee_amt'   value='<%=rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="ag_cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='ag_cons1_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>'>			 
                      <input type='hidden' name='ag_cons1_amt'   value='<%=rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='ag_cons2_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>'>			 
                      <input type='hidden' name='ag_cons2_amt'   value='<%=rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt()%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="ag_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt()+ext_pay_rent_s_amt)%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt)%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                    </td>
                </tr>
                <tr>
                  <td class=title>추가</td> 
                    <td align="center">
                      <input type="text" name="add_inv_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_inv_s_amt())%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='add_inv_v_amt' value='<%=rs_bean.getAdd_inv_v_amt()%>'>
                      <input type='hidden' name='add_inv_amt' value='<%=rs_bean.getAdd_inv_s_amt()+rs_bean.getAdd_inv_v_amt()%>'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_navi_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_navi_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='add_navi_v_amt' value='<%=rs_bean.getAdd_navi_v_amt()%>'>
                      <input type='hidden' name='add_navi_amt' value='<%=rs_bean.getAdd_navi_s_amt()+rs_bean.getAdd_navi_v_amt()%>'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_etc_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_etc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='add_etc_v_amt' value='<%=rs_bean.getAdd_etc_v_amt()%>'>
                      <input type='hidden' name='add_etc_amt' value='<%=rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_etc_v_amt()%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="add_ins_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_ins_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                    </td>
                    <td align="center">
                      <input type="text" name="add_t_fee_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_inv_s_amt()+rs_bean.getAdd_navi_s_amt()+rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_ins_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='add_t_fee_v_amt' value='<%=rs_bean.getAdd_inv_v_amt()+rs_bean.getAdd_navi_v_amt()+rs_bean.getAdd_etc_v_amt()%>'>
                      <input type='hidden' name='add_t_fee_amt'   value='<%=rs_bean.getAdd_inv_s_amt()+rs_bean.getAdd_navi_s_amt()+rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_ins_s_amt()+rs_bean.getAdd_inv_v_amt()+rs_bean.getAdd_navi_v_amt()+rs_bean.getAdd_etc_v_amt()%>'>
                    </td>                    
                    <td align="center">
                      <input type="text" name="add_fee_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt())%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='add_fee_v_amt' value='<%=rs_bean.getAdd_fee_v_amt()%>'>
                      <input type='hidden' name='add_fee_amt' value='<%=rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_fee_v_amt()%>'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_cons1_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_cons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='add_cons1_v_amt' value='<%=rs_bean.getAdd_cons1_v_amt()%>'>
                      <input type='hidden' name='add_cons1_amt' value='<%=rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons1_v_amt()%>'>
                    </td>                      
                    <td align="center">
                      <input type="text" name="add_cons2_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_cons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='add_cons2_v_amt' value='<%=rs_bean.getAdd_cons2_v_amt()%>'>
                      <input type='hidden' name='add_cons2_amt' value='<%=rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_cons2_v_amt()%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="add_tot_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                    </td>
                    <td align="center"> 
                      <input type="text" name="add_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_cons1_v_amt()+rs_bean.getAdd_cons2_v_amt())%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                    </td>
                </tr>                  
                <tr>
                  <td class=title>정산</td> 
                    <td align="center"> 
                      <input type='hidden' name='tot_inv_amt' value='0'>
                      <input type='hidden' name='tot_inv_v_amt' value='0'>
                      <input type="text" name="tot_inv_s_amt" value="0" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                    </td>
                    <td align="center"> 
                      <input type="text" name="tot_navi_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='tot_navi_v_amt' value='0'>
                      <input type='hidden' name='tot_navi_amt' value='0'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="tot_etc_s_amt" value="0" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='tot_etc_v_amt' value='0'>
                      <input type='hidden' name='tot_etc_amt' value='0'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="tot_ins_s_amt" value="0" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='tot_ins_v_amt' value='0'>
                      <input type='hidden' name='tot_ins_amt' value='0'>
                    </td>
                    <td align="center" > 
                      <input type="text" name="tot_t_fee_s_amt" value="0" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                      <input type='hidden' name='tot_t_fee_v_amt' value='0'>
                      <input type='hidden' name='tot_t_fee_amt' value='0'>
                    </td>                    
                    <td align="center"> 
                      <input type='hidden' name='tot_fee_amt' value='0'>
                      <input type='hidden' name='tot_fee_v_amt' value='0'>
                      <input type="text" name="tot_fee_s_amt" value="0" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                    </td>
                    <td align="center"> 
                      <input type='hidden' name='tot_cons1_amt' value='0'>
                      <input type='hidden' name='tot_cons1_v_amt' value='0'>
                      <input type="text" name="tot_cons1_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                    </td>
                    <td align="center"> 
                      <input type='hidden' name='tot_cons2_amt' value='0'>
                      <input type='hidden' name='tot_cons2_v_amt' value='0'>
                      <input type="text" name="tot_cons2_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                    </td>
                    <td align="center">                       
                      <input type='hidden' name='rent_tot_v_amt' value='0'>
                      <input type="text" name="rent_tot_s_amt" value="0" size="9" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원
                    </td>
                    <td align="center">                       
                      <input type="text" name="rent_tot_amt2" value="0" size="9" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>            
    <tr id=tr_sett3 style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                <tr> 
                    <td class=title width=10% rowspan="2">부대비용</td>
                    <td class=title width=9%>위약금</td>
                    <td class=title width=8%>면책금</td>
                    <td class=title width=9%>휴차료</td>
                    <td class=title width=9%>유류비</td>
                    <td class=title width=9%>km초과운행</td>
                    <td class=title width=10%>미수과태료</td>
                    <td class=title width=8%>-</td>
                    <td class=title width=8%>-</td>
                    <td class=title width=10%>합계<br>(공급가)</td>
                    <td class=title width=10%>합계<br>(VAT포함)</td>
                </tr>
                <tr>                  
                    <td align="center"> 
                      <input type='hidden' name='cls_amt' value='<%=rs_bean.getCls_s_amt()+rs_bean.getCls_v_amt()%>'>
                      <input type='hidden' name='cls_v_amt' value='<%=rs_bean.getCls_v_amt()%>'>
                      <input type="text" name="cls_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getCls_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      	원
                   </td>                    
                  <td align="center"><input type='hidden' name='ins_m_amt' value='<%=rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt()%>'>
                    <input type='hidden' name='ins_m_v_amt' value='<%=rs_bean.getIns_m_v_amt()%>'>
                    <input type="text" name="ins_m_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_m_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			원
		  </td>                  
                  <td align="center"><input type='hidden' name='ins_h_amt' value='<%=rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt()%>'>
                    <input type='hidden' name='ins_h_v_amt' value='<%=rs_bean.getIns_h_v_amt()%>'>
                    <input type="text" name="ins_h_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_h_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			원
		  </td>
                  <td align="center"><input type='hidden' name='oil_amt' value='<%=rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt()%>'>
                    <input type='hidden' name='oil_v_amt' value='<%=rs_bean.getOil_v_amt()%>'>
                    <input type="text" name="oil_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getOil_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			원
		  </td>
                  <td align="center"><input type='hidden' name='km_amt' value='<%=rs_bean.getKm_s_amt()+rs_bean.getKm_v_amt()%>'>
                    <input type='hidden' name='km_v_amt' value='<%=rs_bean.getKm_v_amt()%>'>
                    <input type="text" name="km_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getKm_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			원
		  </td>
                  <td align="center">
                    <input type="text" name="fine_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getFine_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			원
		  </td>
		  <td align="center">-</td>	
		  <td align="center">-</td>	
                  <td align="center"><input type="text" name="etc_tot_s_amt" value="0" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			원
		  </td>                  
                  <td align="center"><input type="text" name="etc_tot_amt" value="0" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			원
		  </td>                  
                </tr>   
                <tr>
                    <td class=title>VAT</td>
                    <td align="center"><input type="checkbox" name="cls_vat" value="N" <%if(rs_bean.getCls_s_amt()>0 && rs_bean.getCls_v_amt()==0)%>checked<%%> onClick="javascript:set_amt(document.form1.cls_s_amt);">미포함</td>
                    <td align="center"><input type="checkbox" name="ins_m_vat" value="N" <%if(rs_bean.getIns_m_s_amt()>0 && rs_bean.getIns_m_v_amt()==0)%>checked<%%> onClick="javascript:set_amt(document.form1.ins_m_s_amt);">미포함</td>
                    <td align="center"><input type="checkbox" name="ins_h_vat" value="N" <%if(rs_bean.getIns_h_s_amt()>0 && rs_bean.getIns_h_v_amt()==0)%>checked<%%>  onClick="javascript:set_amt(document.form1.ins_h_s_amt);">미포함</td>
                    <td align="center"><input type="checkbox" name="oil_vat" value="N" <%if(rs_bean.getOil_s_amt()>0 && rs_bean.getOil_v_amt()==0)%>checked<%%>  onClick="javascript:set_amt(document.form1.oil_s_amt);">미포함</td>
                    <td></td>
                    <td align="center">
                        <%if(rs_bean.getFine_s_amt()>0){%>
                        <a href="javascript:viewSettleFine();"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
                        <%}%>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>                       
                <%if(rf_bean.getT_dc_amt()>0){%>
                <tr>
                  <td class=title width=10%>1개월이상<br>계약할인</td> 
                    <td align="center" width=10%>                      
                      <input type="text" name="t_dc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getT_dc_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center" colspan='9'> 
                    </td>
                </tr>                         
                <%}else{%>     
                <input type='hidden' name='t_dc_amt' value='<%=rf_bean.getT_dc_amt()%>'>   
                <%}%>
            </table>
        </td>
    </tr>    
    <tr><td class=h></td></tr>
<%	%>	
<%	if(cont_size > 0){%>
    <tr id=tr_pay_nm style="display:''">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>입금처리</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id=tr_pay1 style="display:''"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>구분</td>
                    <td class=title width=20%> 
                      <p>결제방법</p>
                    </td>
                    <td class=title width=21%>결제일자</td>
                    <td class=title width=24%>금액</td>
                    <td class=title width=25%>비고</td>
                </tr>
              <%for(int i = 0 ; i < cont_size ; i++){
    					Hashtable sr = (Hashtable)conts.elementAt(i);%>
                <tr> 
                    <td class=title> 
                      <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>
                      예약금 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>
                      선수대여료 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>
                      대여료 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("5")){%>
                      연장대여료 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>
                      정산금 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("6")){%>
                      보증금
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
                      무통장 
                      <%}%>
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%></td>
                    <td align="center"> 
                      <input type="text" name="pay_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">-</td>
                </tr>
              <%		//if(String.valueOf(sr.get("RENT_ST")).equals("6")){	
    		  		//	pay_tot_amt = pay_tot_amt - AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  		//}else{
    		  			pay_tot_amt = pay_tot_amt + AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  		//}      		  		
    		  	}%>
                <tr> 
                    <td class=title>합계</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center"> 
                      <input type="text" name="pay_tot_amt" value="<%=Util.parseDecimal(pay_tot_amt)%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
<%	}%>	
    <tr><td class=h></td></tr>
    <tr id=tr_drv_nm style="display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")) {%>''<%}else{%>none<%}%>">	
      <td colspan="2" height="108"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>용역비용(운전기사)</span></td>
    </tr>
    <tr id=tr_drv1 style="display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class="title" width=10%>결제방법</td>
                    <td> 
                      &nbsp;<select name="driv_serv_st" onchange="javascript:driv_display();"  <%=disabled%>>
                        <option value="">선택</option>
                        <option value="1" <%if(rs_bean.getDriv_serv_st().equals("1"))%>selected<%%>>소속용역회사와 별도 정산</option>
                        <option value="2" <%if(rs_bean.getDriv_serv_st().equals("2"))%>selected<%%>>대여료 정산시 합산</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_drv2 style="display:<%if((rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) && rf_bean.getDriver_yn().equals("Y")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=20%>구분</td>
                    <td class=title width=20%>결제수단</td>
                    <td class=title width=20%>결제일자</td>
                    <td class=title width=20%>금액</td>
                    <td class=title width=20%>비고</td>
                </tr>
                <tr id=tr_scd style="display:''"> 
                    <td align="center">입금 
                      <input type="hidden" name="d_rent_st1" value="1">
                    </td>
                    <td align="center"> 
                      <select name="d_paid_st1" <%=disabled%>>
                        <option value="1" <%if(sd_bean1.getPaid_st().equals("1"))%>selected<%%>>현금</option>
                        <option value="2" <%if(sd_bean1.getPaid_st().equals("2"))%>selected<%%>>카드</option>
                        <option value="3" <%if(sd_bean1.getPaid_st().equals("3"))%>selected<%%>>자동이체</option>
                        <option value="4" <%if(sd_bean1.getPaid_st().equals("4"))%>selected<%%>>무통장</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="d_pay_dt1" value="<%=AddUtil.ChangeDate2(sd_bean1.getPay_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="d_pay_amt1" value="<%=AddUtil.parseDecimal(sd_bean1.getPay_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td align="center"> 
                      <input type="hidden" name="d_rent_st2" value="2">
                    </td>
                    <td align="center"> 
                      <select name="d_paid_st2" <%=disabled%>>
                        <option value="1" <%if(sd_bean2.getPaid_st().equals("1"))%>selected<%%>>현금</option>
                        <option value="2" <%if(sd_bean2.getPaid_st().equals("2"))%>selected<%%>>카드</option>
                        <option value="3" <%if(sd_bean2.getPaid_st().equals("3"))%>selected<%%>>자동이체</option>
                        <option value="4" <%if(sd_bean2.getPaid_st().equals("4"))%>selected<%%>>무통장</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="d_pay_dt2" value="<%=AddUtil.ChangeDate2(sd_bean2.getPay_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="d_pay_amt2" value="<%=AddUtil.parseDecimal(sd_bean2.getPay_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class="title"> 합계</td>
                    <td align="center">&nbsp; </td>
                    <td align="center">&nbsp; </td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="d_pay_tot_amt" value="<%=AddUtil.parseDecimal(sd_bean1.getPay_amt()+sd_bean2.getPay_amt())%>" readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_drv3 style="display:<%if((rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) && rf_bean.getDriver_yn().equals("Y")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class="title" width=10%>비고</td>
                    <td> 
                      &nbsp;<input type='text' size='90' class=<%=white%>text name="driv_serv_etc" value="<%=rs_bean.getDriv_serv_etc()%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_sett_nm2 style="display:<%if(rent_st.equals("1")||rent_st.equals("9") || rent_st.equals("12")) {%>''<%}else{%>none<%}%>">	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총정산금</span></td>
	    <td align="right">
	  	    &nbsp;&nbsp;<font color="#999999">
        <%if(!rs_bean.getReg_id().equals("")){%>
        &nbsp;&nbsp;<img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(rs_bean.getReg_id(), "USER")%>&nbsp;&nbsp;<img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> :
        <%=AddUtil.ChangeDate2(rs_bean.getReg_dt())%>
        <%}%>	  
        <%if(!rs_bean.getUpdate_id().equals("")){%>
        &nbsp;&nbsp;<img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(rs_bean.getUpdate_id(), "USER")%>&nbsp;&nbsp;<img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> :
        <%=AddUtil.ChangeDate2(rs_bean.getUpdate_dt())%>
        <%}%>
        </font>		
	    </td>
    </tr>

    <tr id=tr_sett2 style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>총정산금</td>
                    <td class=title_p style='text-align:left'> 
                    &nbsp;<input type='text' size='12' class=<%=white%>num name="rent_sett_amt" value="<%=AddUtil.parseDecimal(rs_bean.getRent_sett_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                    원 (정산대여료 합계 + 부대비용 합계  - 입금처리 합계, 기사포함/대여료정산시 합산일 경우 : 용역비용 합계 포함)</td>
                </tr>
            </table>
        </td>
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
                  <td align="center"><%if(String.valueOf(card.get("TNO")).equals("")){%>대기 <%}else{%>결재 <%}%></td>		  
                </tr>      			
    <%		}%>
                                
            </table>
        </td>
    </tr>        
    <%	}%>  
    
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
            </table>
        </td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>청구기준</td>
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
                      <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>부가세</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>합계</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons1_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr> 
            </table>
        </td>
    </tr>    
    <tr> 
        <td colspan='2'>※ 이용 일자 계산 방법 : 24시간 이내 반납 - 1일치 요금 적용, 24시간 이상 이용시 - 12시간 단위로 대여요금 산정</td>
    </tr>         
<%	if(cont_size > 0){%>
    <tr id=tr_pay_nm style="display:''">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>입금처리</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id=tr_pay1 style="display:''"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>구분</td>
                    <td class=title width=20%> 
                      <p>결제방법</p>
                    </td>
                    <td class=title width=21%>결제일자</td>
                    <td class=title width=24%>금액</td>
                    <td class=title width=25%>비고</td>
                </tr>
              <%for(int i = 0 ; i < cont_size ; i++){
    					Hashtable sr = (Hashtable)conts.elementAt(i);%>
                <tr> 
                    <td class=title> 
                      <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>
                      예약금 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>
                      선수대여료 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>
                      대여료 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("5")){%>
                      연장대여료 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>
                      정산금 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("6")){%>
                      보증금
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
                      무통장 
                      <%}%>
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%></td>
                    <td align="center"> 
                      <input type="text" name="pay_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">-</td>
                </tr>
              <%		//if(String.valueOf(sr.get("RENT_ST")).equals("6")){	
    		  		//	pay_tot_amt = pay_tot_amt - AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  		//}else{
    		  			pay_tot_amt = pay_tot_amt + AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  		//}      		  		
    		  	}%>
                <tr> 
                    <td class=title>합계</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center"> 
                      <input type="text" name="pay_tot_amt" value="<%=Util.parseDecimal(pay_tot_amt)%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>    
<%	}%>    

    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>정산일자</td>
                    <td width=41%> 
                      &nbsp;<input type="text" name="sett_dt" value="<%=AddUtil.ChangeDate2(rs_bean.getSett_dt())%>" size="12" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>누적주행거리</td>
                    <td width=39%> 
                      &nbsp;<input type="text" name="run_km" value="<%=rs_bean.getRun_km()%>" size="10" class=<%=white%>num >
                      km </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    
    <%}%>    

    <tr><td class=h></td></tr>	
    <tr>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기본스캔파일</span>
          <%if(!mode.equals("view")){%>	
          <%    if(rc_bean.getCust_st().equals("1")){%>
          &nbsp;<a href ="javascript:view_scan()"><img src=/acar/images/center/button_see_ss.gif align=absmiddle border=0></a>
          <%    }%>
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                                
                                
                <%if(rent_st.equals("1") || rent_st.equals("9") || rent_st.equals("12")){//단기대여,보험대차,월렌트%>
                
                <%	scan_num++;%>
                   
                <!-- 자동차대여이용계약서 -->
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">자동차대여이용계약서</td>
                    <td align="center">
                        <%if(rent_st.equals("12")){%>
                            <%if(AddUtil.parseInt(rc_bean.getRent_dt()) > 20120830){%>
                    	        (신) <a href='/acar/secondhand_hp/rm_car_doc_new.jsp?rent_s_cd=<%=s_cd%>&car_mng_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                    	    <%}else{%>
                    	        (신) <a href='/acar/secondhand_hp/rm_car_doc.jsp?rent_s_cd=<%=s_cd%>&car_mng_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                    	    <%}%>
                        <%}else{%>
                            (구) <a href='res_rent_p.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp; 		      
                        <%}%>
                    </td>
                    <td align="center">웹페이지</td>		  
                    <td align="center"></td>		  
                </tr>  
                                
                <!-- 계약서(앞)-jpg파일 -->
                <% 	scan_num++; 
                	file_st = "17";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                
                		attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                
                		attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                
                		attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
</table>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;	
	
	
	<%if(rent_st.equals("12") && ext_size > 0){
    		for(int i = 0 ; i < ext_size ; i++){
    			Hashtable ext = (Hashtable)exts.elementAt(i);
    			if(AddUtil.parseInt(String.valueOf(ext.get("PAY_AMT"))) > 0){
    	%>	
    				fm.rent_months.value 	= toInt(fm.rent_months.value)	+ <%=ext.get("RENT_MONTHS")%>;
    				fm.rent_days.value 	= toInt(fm.rent_days.value)	+ <%=ext.get("RENT_DAYS")%>;
    	<%		}
    		}
    	  }
    	%>	



	var fm = document.form1;	
	if(fm.rent_st.value == '1' || fm.rent_st.value == '9' || fm.rent_st.value == '12'){
	
		//정산		
		fm.tot_inv_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_s_amt.value)) 	+ toInt(parseDigit(fm.add_inv_s_amt.value))	);
		fm.tot_fee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_fee_s_amt.value))	);
		fm.tot_t_fee_s_amt.value= parseDecimal( toInt(parseDigit(fm.ag_t_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_s_amt.value))	);
		fm.tot_navi_s_amt.value = parseDecimal( toInt(parseDigit(fm.ag_navi_s_amt.value)) 	+ toInt(parseDigit(fm.add_navi_s_amt.value))	);
		fm.tot_etc_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_etc_s_amt.value)) 	+ toInt(parseDigit(fm.add_etc_s_amt.value))	);
		fm.tot_ins_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
		fm.tot_cons1_s_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_s_amt.value))	);
		fm.tot_cons2_s_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons2_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_s_amt.value))	);
		
		fm.tot_inv_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_v_amt.value)) 	+ toInt(parseDigit(fm.add_inv_v_amt.value))	);
		fm.tot_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_fee_v_amt.value)) 	+ toInt(parseDigit(fm.add_fee_v_amt.value))	);
		fm.tot_t_fee_v_amt.value= parseDecimal( toInt(parseDigit(fm.ag_t_fee_v_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_v_amt.value))	);
		fm.tot_navi_v_amt.value = parseDecimal( toInt(parseDigit(fm.ag_navi_v_amt.value)) 	+ toInt(parseDigit(fm.add_navi_v_amt.value))	);
		fm.tot_etc_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_etc_v_amt.value)) 	+ toInt(parseDigit(fm.add_etc_v_amt.value))	);
		fm.tot_cons1_v_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons1_v_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_v_amt.value))	);
		fm.tot_cons2_v_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons2_v_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_v_amt.value))	);		

		fm.tot_inv_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_amt.value)) 		+ toInt(parseDigit(fm.add_inv_amt.value))	);
		fm.tot_fee_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_fee_amt.value)) 		+ toInt(parseDigit(fm.add_fee_amt.value))	);
		fm.tot_t_fee_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_t_fee_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_amt.value))	);
		fm.tot_navi_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_navi_amt.value)) 	+ toInt(parseDigit(fm.add_navi_amt.value))	);
		fm.tot_etc_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_etc_amt.value)) 		+ toInt(parseDigit(fm.add_etc_amt.value))	);
		fm.tot_ins_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
		fm.tot_cons1_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons1_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_amt.value))	);
		fm.tot_cons2_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons2_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_amt.value))	);		
		
		fm.rent_tot_s_amt.value = parseDecimal( toInt(parseDigit(fm.tot_fee_s_amt.value)) 	+ toInt(parseDigit(fm.tot_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.tot_cons2_s_amt.value))	);
		fm.rent_tot_amt2.value 	= parseDecimal( toInt(parseDigit(fm.tot_fee_amt.value)) 	+ toInt(parseDigit(fm.tot_cons1_amt.value)) 	+ toInt(parseDigit(fm.tot_cons2_amt.value))	);


		//부대비용
		fm.etc_tot_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_s_amt.value)) 		+ toInt(parseDigit(fm.ins_m_s_amt.value)) 	+ toInt(parseDigit(fm.ins_h_s_amt.value)) 	+ toInt(parseDigit(fm.oil_s_amt.value)) 	+ toInt(parseDigit(fm.km_s_amt.value))		+ toInt(parseDigit(fm.fine_s_amt.value))	);		
		fm.etc_tot_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_amt.value)) 		+ toInt(parseDigit(fm.ins_m_amt.value)) 	+ toInt(parseDigit(fm.ins_h_amt.value)) 	+ toInt(parseDigit(fm.oil_amt.value)) 		+ toInt(parseDigit(fm.km_amt.value))		+ toInt(parseDigit(fm.fine_s_amt.value))        );		
		
		
		
				
		if(fm.rent_st.value == '1' || fm.rent_st.value == '12'){
		//	fm.rent_sett_amt.value = parseDecimal( toInt(parseDigit(fm.rent_tot_amt2.value)) + toInt(parseDigit(fm.etc_tot_amt.value)) - toInt(parseDigit(fm.t_dc_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
		}else{
		//	fm.rent_sett_amt.value = parseDecimal( toInt(parseDigit(fm.rent_tot_amt2.value)) + toInt(parseDigit(fm.etc_tot_amt.value)) - toInt(parseDigit(fm.t_dc_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)));
		}
		
	}

//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
