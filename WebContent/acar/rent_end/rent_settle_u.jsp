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

	
	//�α���ID&������ID&����
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
	
	
	
	
	
	Vector users = c_db.getUserList("", "", "EMP"); //����� ����Ʈ
	int user_size = users.size();	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAll("0003"); 
	int bank_size = banks.length;

	//����� ����Ʈ
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	//�ܱ������-���뺸����
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(s_cd, "4");
	//�ܱ�뿩����
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	//����������
	ScdRentBean sr_bean0 = rs_db.getScdRentCase(s_cd, "6");
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//�Ա�ó��
	Vector conts = rs_db.getScdRentList(s_cd);
	int cont_size = conts.size();
	//�̼�ä��
	Vector conts2 = rs_db.getScdRentNoList(s_cd);
	int cont_size2 = conts2.size();
	
	//�ܱ�뿩��������
	RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);
	//�뿪�������
	ScdDrivBean sd_bean1 = rs_db.getScdDrivCase(s_cd, "1");
	ScdDrivBean sd_bean2 = rs_db.getScdDrivCase(s_cd, "2");
	//������
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
	//�ſ�ī�����
	Vector cards = rs_db.getRentContCardList(s_cd);
	int card_size = cards.size();	
	//�̼����·�
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
	
	
	//�˾������� ����
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
	
	//�˾������� ����
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
	
		
	//�ܱ�뿩---------------------------------------------------------------------------------------------------------
			
	//�뿩�ϼ� ���ϱ�
	function getRentTime() {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
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
		}else{//�ʰ� or �̸�
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
	
	//����뿩�� �ڵ����
	function getFee_sam(){
		var fm = document.form1;
		fm.action = '/acar/rent_settle/short_fee_nodisplay.jsp';
		<%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
		fm.action = '/acar/rent_settle/short_fee_nodisplay2.jsp';
		<%}%>
		fm.target = 'i_no';
		fm.submit();
	}
	
	//�ݾ� ����	
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
		
		//�Ѱ���ݾ�											
		fm.rent_tot_s_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons2_s_amt.value)) );
		fm.rent_tot_v_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_v_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)) );
		fm.rent_tot_amt.value 	= parseDecimal(	toInt(parseDigit(fm.fee_amt.value))   + toInt(parseDigit(fm.cons1_amt.value))   + toInt(parseDigit(fm.cons2_amt.value))   );
			
		
		<%}else{%>	
				
		//����
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
		//�߰�
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
			
		//�δ���
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
			
		//�뿪���1
		}else if(obj==fm.d_pay_amt1 || obj==fm.d_pay_amt2){
			fm.d_pay_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.d_pay_amt1.value)) + toInt(parseDigit(fm.d_pay_amt2.value)));
		}

		//�����հ�
		fm.ag_t_fee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_s_amt.value)) 	+ toInt(parseDigit(fm.ag_navi_s_amt.value))	+ toInt(parseDigit(fm.ag_etc_s_amt.value))	+ toInt(parseDigit(fm.ag_ins_s_amt.value))	);
		fm.ag_t_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_v_amt.value)) 	+ toInt(parseDigit(fm.ag_navi_v_amt.value))	+ toInt(parseDigit(fm.ag_etc_v_amt.value))		);
		fm.ag_t_fee_amt.value   	= parseDecimal( toInt(parseDigit(fm.ag_inv_amt.value)) 		+ toInt(parseDigit(fm.ag_navi_amt.value))	+ toInt(parseDigit(fm.ag_etc_amt.value))	+ toInt(parseDigit(fm.ag_ins_s_amt.value))	);		
		fm.ag_tot_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_s_amt.value))	);
		fm.ag_tot_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_amt.value)) 		+ toInt(parseDigit(fm.ag_cons1_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_amt.value))	);
		
						
		//�߰��հ�
		fm.add_t_fee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.add_inv_s_amt.value)) 	+ toInt(parseDigit(fm.add_navi_s_amt.value))	+ toInt(parseDigit(fm.add_etc_s_amt.value))	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
		fm.add_t_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.add_inv_v_amt.value)) 	+ toInt(parseDigit(fm.add_navi_v_amt.value))	+ toInt(parseDigit(fm.add_etc_v_amt.value))		);
		fm.add_t_fee_amt.value   	= parseDecimal( toInt(parseDigit(fm.add_inv_amt.value)) 	+ toInt(parseDigit(fm.add_navi_amt.value))	+ toInt(parseDigit(fm.add_etc_amt.value))	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);		
		if(obj==fm.add_inv_s_amt || obj==fm.navi_s_amt || obj==fm.etc_s_amt || obj==fm.ins_s_amt){
			//�߰� �뿩���Ѿ�, �հ�
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

		//����
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

	//�뿪���:���� ���÷���
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
	
	//�ݾ� ����	
	function pay_set_amt(){
		var fm = document.form1;	
		if(fm.mode.value != 'u') return;		
		fm.rest_amt1.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt2.value)) - toInt(parseDigit(fm.pay_amt1.value))) ;
		fm.rest_amt2.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt2.value)) - toInt(parseDigit(fm.pay_amt1.value)) - toInt(parseDigit(fm.pay_amt2.value))) ;
	}			
	


	
	// ��Ÿ ------------------------------------------------------------------------------------------------
	
	//����������Ȳ ��ȸ
	function car_reserve(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserve", "left=50, top=50, width=820, height=400, scrollbars=yes");
	}

	//��������������Ȳ ��ȸ
	function car_reserve2(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve_dk.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserveDK", "left=50, top=50, width=820, height=400, scrollbars=yes");
	}


	//����ϱ�
	function all_reset(){
		var fm = document.form1;	
		fm.reset();
	}
	
	//�����ϱ�
	function save(upd_mode){
		var fm = document.form1;
		fm.upd_mode.value = upd_mode;		
		if(fm.ret_dt.value != ''){
			fm.h_ret_dt.value = fm.ret_dt.value+fm.ret_dt_h.value+fm.ret_dt_s.value;		
		}
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}	
		fm.action = 'rent_settle_u_a.jsp';
//		fm.target = 'd_content';
		fm.target='i_no';
		fm.submit();
	}
	
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		fm.action = 'rent_en_frame_s.jsp';
		if(fm.list_from_page.value != '') fm.action = fm.list_from_page.value;
		fm.target = 'd_content';
		fm.submit();			
	}	
	
	//����ý��� ��༭
	function view_scan_res(c_id, s_cd){
		window.open("/acar/rent_mng/res_rent_u_print.jsp?c_id="+c_id+"&s_cd="+s_cd+"&mode=fine_doc", "VIEW_SCAN_RES", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}
	

	
	//��ĵ���
	function scan_reg(file_st){
		window.open("/acar/res_stat/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=c_id%>&rent_l_cd=<%=s_cd%>&from_page=/acar/res_mng/res_rent_u.jsp&file_st="+file_st, "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}
	
		

	//�����ϱ�
	function remove(seq, st_nm){
		fm = document.form1;
		fm.remove_seq.value = seq;
		if(!confirm(st_nm+" ������ �����Ͻðڽ��ϱ�?"))		return;		
		fm.target = "i_no";
		fm.action='/acar/res_stat/reg_scan.jsp';
		fm.submit();
	}	
	
	//��ĵ���� ����
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
	
	//�̼����·Ḯ��Ʈ
	function viewSettleFine(){
		var fm = document.form1;
		var SUBWIN="/acar/rent_settle/view_settle_fine.jsp?c_id="+fm.c_id.value+"&s_cd="+fm.s_cd.value;	
		window.open(SUBWIN, "ViewSettleFine", "left=50, top=50, width=820, height=400, scrollbars=yes");		
	}
			
			
	//�����ٰ���
	function move_fee_scd(){
		var fm = document.form1;
		fm.action = '/acar/con_rent/res_fee_c.jsp';
		fm.target = 'd_content';
		fm.submit();						
	}
	
	//�� ����
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > �������� > ���İ��� > <span class=style5><%if(rent_st.equals("1")){%>
                    �ܱ�뿩 
                    <%}else if(rent_st.equals("2")){%>
                    ������� 
                    <%}else if(rent_st.equals("3")){%>
                    ������ 
                    <%}else if(rent_st.equals("9")){%>
                    ������� 		
                    <%}else if(rent_st.equals("10")){%>
                    �������� 				
                    <%}else if(rent_st.equals("4")){%>
                    �����뿩 
                    <%}else if(rent_st.equals("5")){%>
                    �������� 
                    <%}else if(rent_st.equals("6")){%>
                    �������� 
                    <%}else if(rent_st.equals("7")){%>
                    �������� 
                    <%}else if(rent_st.equals("8")){%>
                    ������ 
                    <%}else if(rent_st.equals("11")){%>
                    ��Ÿ 
                    <%}else if(rent_st.equals("12")){%>
                    ����Ʈ
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
        <td width="20%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
        <td align="right" width="80%">
        
            <%if(!rent_st.equals("12")){%>	
    	        <img src=/acar/images/center/arrow.gif>     	    
		<%=reserv.get("CAR_NO")%>
		<a href="javascript:car_reserve();"><img src="/acar/images/center/button_list_dy.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
    		<a href="javascript:car_reserve2();"><img src="/acar/images/center/button_list_dg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;			
    	        <a href='res_rent_p.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_dggy.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp; 
		<a href="javascript:view_scan_res('<%=c_id%>','<%=s_cd%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a>&nbsp;&nbsp; 
    	        <a href='rent_settle_p.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="_blank">���꼭<img src="/images/print.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
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
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class=title>����</td>
                    <td colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                    <td class=title>�����ȣ</td>
                    <td colspan="3">&nbsp;<%=reserv.get("CAR_NUM")%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>���ʵ����</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                    <td class=title width=10%>�������</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
                    <td class=title width=11%>��ⷮ</td>
                    <td width=10%>&nbsp;<%=reserv.get("DPM")%>cc</td>
                    <td class=title width=10%>Į��</td>
                    <td width=10%>&nbsp;<%=reserv.get("COLO")%></td>
                    <td class=title width=9%>����</td>
                    <td width=10%>&nbsp;<%=reserv.get("FUEL_KD")%></td>
                </tr>
                <tr> 
                    <td class=title>���û��</td>
                    <td colspan="3">&nbsp;<%=reserv.get("OPT")%></td>
                    <td class=title>���翹������Ÿ�</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(reserv.get("TODAY_DIST")))%>km</td>
                    <td class=title>����������</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("SERV_DT")))%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
        <td align="right"> 
        <%if(!mode.equals("view")){%>	
            <!--<a href='javascript:save();'> <img src="/images/up_info.gif" width="50" height="18" aligh="absmiddle" border="0"> 
            </a> -->
            <a href="javascript:RentMemo('<%=s_cd%>','<%=c_id%>','<%=ck_acar_id%>');" class="btn" title='��ȭ��������'><img src=/acar/images/center/button_th.gif align=absmiddle border=0></a>&nbsp;
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
                    <td class=title>����</td><!--<a href="javascript:cust_select()"></a>-->
                    <td colspan=2> 
                      &nbsp;<input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
                      <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="20" class=whitetext>
                    </td>
                    <td class=title>����</td>
                    <td colspan="2"> 
                      &nbsp;<input type="text" name="c_cust_nm" value="<%=rc_bean2.getCust_nm()%>" size="25" class=whitetext>
                    </td>
                    <td class=title>�������</td>
                    <td> 
                      &nbsp;<input type="text" name="c_ssn" value="<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td colspan="5"> 
                      &nbsp;<input type="text" name="c_firm_nm" value="<%=rc_bean2.getFirm_nm()%>" size="80" class=whitetext>
                      &nbsp;<span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
                    </td>
                    <td class=title>����ڵ�Ϲ�ȣ</td>
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
                    <td class=title>�ּ�</td>
                    <td colspan="7"> 
					<input type="text" name='c_zip' id="c_zip" size="7" value="<%=rc_bean2.getZip()%>" maxlength='7' >
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='c_addr' id="c_addr"  value="<%=rc_bean2.getAddr()%>"  size="100">

                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>���������ȣ</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="c_lic_no" value="<%=rm_bean4.getLic_no()%>" size="16" class=whitetext onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                    </td>
                    <td class=title width=10%>��������</td>
                    <td width=10%> 
                      &nbsp;<select name='c_lic_st' <%=disabled%>>
                        <option value=''>����</option>
                        <option value='1' <%if(rm_bean4.getLic_st().equals("1"))%>selected<%%>>2������</option>
                        <option value='2' <%if(rm_bean4.getLic_st().equals("2"))%>selected<%%>>1������</option>
                        <option value='3' <%if(rm_bean4.getLic_st().equals("3"))%>selected<%%>>1������</option>
                      </select>
                    </td>
                    <td class=title width=11%>��ȭ��ȣ</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="c_tel" value="<%=rm_bean4.getTel()%>" class=whitetext size="15">
                    </td>
                    <td class=title width=10%>�޴���</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="c_m_tel" value="<%=rm_bean4.getEtc()%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��󿬶�ó</td>
                    <td  colspan='7'> 
                      <input type="hidden" name="mgr_st2" value="2">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp;
                      <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=whitetext size="10">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����ó:&nbsp; 
                      <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=whitetext>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                      <input type="text" name="m_etc2" value="<%=rm_bean2.getEtc()%>" size="58" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title rowspan="3"><%if(rent_st.equals("12")){%>�߰�������<%}else{%>�ǿ�����<br>(�뿪��� ��)<%}%></td>
                    <td  colspan='7'> 
                      <input type="hidden" name="mgr_st1" value="1">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                      <input type="text" name="mgr_nm1" value="<%=rm_bean1.getMgr_nm()%>" class=whitetext size="10">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> �������:&nbsp; 
                      <input type="text" name="m_ssn1" value="<%=AddUtil.ChangeEnpH(rm_bean1.getSsn())%>" size="15" class=whitetext>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ���������ȣ:&nbsp; 
                      <input type="text" name="m_lic_no1" value="<%=rm_bean1.getLic_no()%>" size="16" class=whitetext>
                      &nbsp; <img src=/acar/images/center/arrow.gif> ��������:&nbsp; 
                      <select name='m_lic_st1' <%=disabled%>>
                        <option value=''>����</option>
                        <option value='1' <%if(rm_bean1.getLic_st().equals("1"))%>selected<%%>>2������</option>
                        <option value='2' <%if(rm_bean1.getLic_st().equals("2"))%>selected<%%>>1������</option>
                        <option value='3' <%if(rm_bean1.getLic_st().equals("3"))%>selected<%%>>1������</option>
                      </select> 
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ��ȭ��ȣ:&nbsp; 
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
                    <td  colspan='7'>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> �ּ�:&nbsp;
					<input type="text" name='m_zip1' id="m_zip1" size="7" value="<%=rm_bean1.getZip()%>" maxlength='7' >
					<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='m_addr1' id="m_addr1"  value="<%=rm_bean1.getAddr()%>"  size="100">

                    </td>
                </tr>
                <tr> 
                    <td  colspan='7'>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ��Ÿ:&nbsp;
                      &nbsp;<input type="text" name="m_etc1" value="<%=rm_bean1.getEtc()%>" size="113" class=whitetext>
                    </td>
                </tr>
                <%if(rent_st.equals("12")){%>
                <tr> 
                   <td class=title width=10%>�������뵵</td>
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
                    <td class=title width=10%>����</td><!--<a href="javascript:cust_select()"></a>-->
                    <td width=20%> 
                      &nbsp;<input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
                      <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=21%> 
                      &nbsp;<input type="text" name="c_cust_nm" value="<%=rc_bean2.getCust_nm()%>" size="27" class=whitetext>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="c_ssn" value="<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="c_firm_nm" value="<%=rc_bean2.getFirm_nm()%>" size="80" class=whitetext>
                    </td>
                    <td class=title>����ڵ�Ϲ�ȣ</td>
                    <td> 
                      &nbsp;<input type="text" name="c_enp_no" value="<%=rc_bean2.getEnp_no()%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��󿬶�ó</td>
                    <td  colspan='7'> 
                      &nbsp;<input type="hidden" name="mgr_st2" value="2">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                      <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=whitetext size="10">
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����ó:&nbsp;
                      <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=whitetext>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp; 
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
    <input type='hidden' name='c_firm_nm' value='(��)�Ƹ���ī'>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td width=10%> 
                        &nbsp;<input type='hidden' name='cust_st' value='4'>
                        <input type="text" name="c_cust_st" value="����" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=10%> 
                        &nbsp;<select name='c_cust_nm' onChange='javascript:user_select()' <%=disabled%>>
                            <option value="">==����==</option>
                            <%	if(user_size > 0){
            						for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                            <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean2.getCust_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                            <%		}
            					}		%>
                        </select>
                    </td>
                    <td class=title width=11%>�����Ҹ�</td>
                    <td width=10%> 
                        &nbsp;<input type="text" name="c_brch_nm" value="<%=rc_bean2.getBrch_nm()%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>�μ���</td>
                    <td> 
                        &nbsp;<input type="text" name="c_dept_nm" value="<%=rc_bean2.getDept_nm()%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���������ȣ</td>
                    <td> 
                        &nbsp;<input type="text" name="c_lic_no" value="<%=rc_bean2.getLic_no()%>" size="16" class=whitetext onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                    </td>
                    <td class=title>��������</td>
                    <td> 
                        &nbsp;<input type="text" name="c_lic_st" value="<%=rc_bean2.getLic_st()%>" size="15" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title>��ȭ��ȣ</td>
                    <td> 
                        &nbsp;<input type="text" name="c_tel" value="<%=rc_bean2.getTel()%>" class=whitetext size="15">
                    </td>
                    <td class=title>�޴���</td>
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
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뺸����</span></td>
    </tr>
    <tr id=tr_gua1 style="display:<%if(rent_st.equals("1") || rent_st.equals("12") ) {%>''<%}else{%>none<%}%>"'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=90%> 
                      &nbsp;<select name="gua_st" onchange="javascript:gua_display()" disabled>
                        <option value="">==����==</option>
                        <option value="1" <%if(rf_bean.getGua_st().equals("1")){%>selected<%}%>>�Ժ�</option>
                        <option value="2" <%if(rf_bean.getGua_st().equals("2")){%>selected<%}%>>����</option>
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
                    <td class=title width=10%>����</td>
                    <td width=10%> 
                      &nbsp;<input type="hidden" name="mgr_st3" value="3">
                      <input type="text" name="mgr_nm3" value="<%=rm_bean3.getMgr_nm()%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="m_ssn3" value="<%=AddUtil.ChangeEnpH(rm_bean3.getSsn())%>" size="14" class=whitetext onBlur='javscript:this.value = ChangeSsn(this.value);'>
                    </td>
                    <td class=title width=11%>��ȭ��ȣ</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="m_tel3" value="<%=rm_bean3.getTel()%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>����ڿ��� ����</td>
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
                    <td class=title>�ּ�</td>
                    <td colspan=7> 
					<input type="text" name='m_zip3' id="m_zip3" size="7" value="<%=rm_bean3.getZip()%>" maxlength='7' >
					<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
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
                    <td class=title width=10%>��������</td>
                    <td> 
                      &nbsp;<input type="text" name="gua_cau" value="<%=rf_bean.getGua_cau()%>" size="109" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%if(rent_st.equals("2")){
		//�����������
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());
		//�������
		Hashtable cont_view = a_db.getContViewCase("", rc_bean.getSub_l_cd());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%>����������ȣ</td>
                    <td width=21%>&nbsp;<%=serv.get("CAR_NO")%></td>
                    <td class=title width=10%>����</td>
                    <td width=29%>&nbsp;<%=serv.get("CAR_NM")%></td>
                </tr>
                <tr>
                    <td class=title width="10%">�뿩���</td>
                    <td colspan='5'>&nbsp;<%=cont_view.get("RENT_WAY")%>&nbsp;(<%=cont_view.get("RENT_START_DT")%>~)
                    </td>
                </tr>                      
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("3")){
		//����������
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=10%>����������ȣ</td>
                    <td width=21%>&nbsp;<%=accid.get("CAR_NO")%></td>
                    <td class=title width=10%>����</td>
                    <td width=29%>&nbsp;<%=accid.get("CAR_NM")%></td>
                </tr>
                <tr> 
                    <td class=title> ������ȣ</td>
                    <td>&nbsp;<%=accid.get("P_NUM")%></td>
                    <td class=title>�����ں����</td>
                    <td>&nbsp;<%=accid.get("G_INS")%></td>
                    <td class=title>�����</td>
                    <td>&nbsp;<%=accid.get("G_INS_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rent_st.equals("9")){
		//�����������
		RentInsBean ri_bean = rs_db.getRentInsCase(rc_bean.getRent_s_cd());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title> ������ȣ</td>
                    <td>&nbsp;<%=ri_bean.getIns_num()%></td>
                    <td class=title>�����</td>
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
                    <td class=title width=10%> �����</td>
                    <td width=10%>&nbsp;<%=ri_bean.getIns_nm()%></td>
                    <td class=title width=10%>����ó��</td>
                    <td width=10%>&nbsp;<%=ri_bean.getIns_tel()%></td>
                    <td class=title width=11%">����ó��</td>
                    <td width=10%>&nbsp;<%=ri_bean.getIns_tel2()%></td>
                    <td class=title width=10%>�ѽ�</td>
                    <td>&nbsp;<%=ri_bean.getIns_fax()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>			
    <%}else if(rent_st.equals("6")){
		//������������
		Hashtable serv = rs_db.getInfoServ(c_id, rc_bean.getServ_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=41%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%> ��������</td>
                    <td width=39%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}else if(rent_st.equals("7")){
		//������������
		Hashtable maint = rs_db.getInfoMaint(c_id, rc_bean.getMaint_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>�˻���ȿ�Ⱓ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}else if(rent_st.equals("8")){
		//����������
		Hashtable accid = rs_db.getInfoAccid(c_id, rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=10%>�������</td>
                    <td width=21%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%></td>
                    <td class=title width=10%>�����</td>
                    <td width=29%>&nbsp;<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>�����</td>
                    <td colspan="5">&nbsp;<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <tr><td class=h></td></tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
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
                    <td class=title width=10%>����ȣ</td>
                    <td width=10%>&nbsp;<%=rc_bean.getRent_s_cd()%></td>
                    <td class=title width=10%>�������</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
                    <td class=title width=11%>������</td>
                    <td width=10%>&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(), "BRCH")%></td>
                    <td class=title width=10%><%if(rent_st.equals("12")) {%>���ʿ�����<%}else{%>�����<%}%></td>
                    <td colspan=3>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(), "USER")%></td>
                </tr>
                <tr>                     
                    <td class=title>�����Ⱓ</td>
                    <td colspan=9>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>~ 
                      <%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%></td>
                </tr>
    		  <%
    			if(ext_size > 0){
    				for(int i = 0 ; i < ext_size ; i++){
    					Hashtable ext = (Hashtable)exts.elementAt(i);%>		  
                <tr> 
                    <td class=title>���� [<%=i+1%>]</td>
                    <td colspan="9">&nbsp; 
                        ������� : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_DT")))%> &nbsp;&nbsp;
                        | �뿩�Ⱓ : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_END_DT")))%> &nbsp;&nbsp; 
                        (<%=ext.get("RENT_MONTHS")%>����<%=ext.get("RENT_DAYS")%>��)                   	
                    </td>
                </tr>
    		  <%		
    		  		}
    		  	}%> 	                
                <tr> 
                    <td class=title>��Ÿ</td>
                    <td colspan=9>&nbsp;<%=rc_bean.getEtc()%></td>                    
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����/����</span></td>
	    <td align="right">
	    <%if(!mode.equals("view")){%>	
                <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                <%	if(!rc_bean.getRet_dt_d().equals("")){%>
                <a href="javascript:save('rent_cont');"> <img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
                <%	}%>
                <%}%>
                <%if(nm_db.getWorkAuthUser("������",user_id)){%>
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
                    <td class=title>���������Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_plan_dt())%>
                    </td>
                    <td class=title>���������Ͻ�</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_plan_dt())%></td>
                </tr>
                <tr> 
                    <td class=title>�����Ͻ�</td>
                    <td>
        			&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class=title>�����Ͻ�</td>
                    <td colspan="3">
                      &nbsp;<input type="text" name="ret_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime()'>
                      <select name="ret_dt_h" <%=disabled%>>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="ret_dt_s" <%=disabled%>>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>						
        			<%//=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
                </tr>
                <tr> 
                    <td class=title>������ġ</td>
                    <td>&nbsp;<%=rc_bean.getDeli_loc()%></td>
                    <td class=title>������ġ</td>
                    <td colspan="3">&nbsp;<%=rc_bean.getRet_loc()%></td>
                </tr>
                <tr> 
                    <td class=title>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getDeli_mng_id(), "USER")%></td>
                    <td class=title>���������</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(rc_bean.getRet_mng_id(), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>���ʾ����ð�</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="2" class=whitenum readonly>
                      �ð� 
                      <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=whitenum readonly>
                      �� 
                      <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="2" class=whitenum readonly>
                      ���� </td>
                    <td class=title width=10%>�߰��̿�ð�</td>
                    <td width=21%> 
                      &nbsp;<input type="text" name="add_hour" value="<%=rs_bean.getAdd_hour()%>" size="2" class=<%=white%>num >
                      �ð� 
                      <input type="text" name="add_days" value="<%=rs_bean.getAdd_days()%>" size="2" class=<%=white%>num >
                      �� 
                      <input type="text" name="add_months" value="<%=rs_bean.getAdd_months()%>" size="2" class=<%=white%>num >
                      ���� </td>
                    <td class=title width=10%>���̿�ð�</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="tot_hour" value="<%=rs_bean.getTot_hour()%>" size="2" class=<%=white%>num >
                      �ð� 
                      <input type="text" name="tot_days" value="<%=rs_bean.getTot_days()%>" size="2" class=<%=white%>num >
                      �� 
                      <input type="text" name="tot_months" value="<%=rs_bean.getTot_months()%>" size="2" class=<%=white%>num >
                      ���� </td>
                </tr>
                <tr> 
                    <td class=title>���</td>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span></td>
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
                    <td class=title width=10%>���ݰ�꼭</td>
                    <td width=20%> 
                      &nbsp;<select name="tax_yn" disabled>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getTax_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getTax_yn().equals("N")){%>selected<%}%>>�̹���</option>
                      </select>
                    </td>
                    <td class=title width=10%>���ú���</td>
                    <td width=30%> 
                      &nbsp;<select name="ins_yn" disabled>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getIns_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getIns_yn().equals("N")){%>selected<%}%>>�̰���</option>
                      </select>
                      (��å�� : <input type='text' size='12' maxlength='7' name='car_ja' class='whitenum' value='<%=AddUtil.parseDecimal(rf_bean.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			��)</td>
                    </td>
                    <td class=title width=10%>���������</td>
                    <td> 
                      &nbsp;<select name="my_accid_yn" disabled>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getMy_accid_yn().equals("Y")){%>selected<%}%>>���δ�</option>
                        <option value="N" <%if(rf_bean.getMy_accid_yn().equals("N")){%>selected<%}%>>����</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�������</td>
                    <td> 
                      &nbsp;<select name="paid_way" disabled>
                        <option value="">==����==</option>			  
                        <option value="1" <%if(rf_bean.getPaid_way().equals("1")){%>selected<%}%>>����</option>
                        <option value="2" <%if(rf_bean.getPaid_way().equals("2")){%>selected<%}%>>�ĺ�</option>
                      </select>
                    </td>
                    <td class=title>��������</td>
                    <td colspan="3">
        			    <table border="0" width="100%">
                            <tr>
            				    <td>
                	                &nbsp;<select name="paid_st" disabled>
                    	              <option value="">==����==</option>			  
                        	          <option value="1" <%if(rf_bean.getPaid_st().equals("1")){%>selected<%}%>>����</option>
                            	      <option value="2" <%if(rf_bean.getPaid_st().equals("2")){%>selected<%}%>>�ſ�ī��</option>
                	                </select>				  </td>				
            				    <td id=td_paid style='display:none'>(ī��NO. : 
                		            <input type="text" name="card_no" value="<%=rf_bean.getCard_no()%>" size="30" class=<%=white%>text>
                	                 )
            				    </td>				   
                                <td align="right">&nbsp; </td>
            				</tr>
        			    </table>
                    </td>
                    <!--
                    <td class=title width=10%>�������</td>
                    <td width=29%> 
                      &nbsp;<select name="driver_yn" <%=disabled%>>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getDriver_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getDriver_yn().equals("N")){%>selected<%}%>>������</option>
                      </select>
                      -->
                </tr>
                <tr> 
                    <td class=title>������</td>
                    <td> 
                      &nbsp;<select name="oil_st" disabled>
                        <option value="">==����==</option>			  
                        <option value="1" <%if(rf_bean.getOil_st().equals("1")){%>selected<%}%>>1ĭ</option>
                        <option value="2" <%if(rf_bean.getOil_st().equals("2")){%>selected<%}%>>2ĭ</option>
                        <option value="3" <%if(rf_bean.getOil_st().equals("3")){%>selected<%}%>>3ĭ</option>
                        <option value="f" <%if(rf_bean.getOil_st().equals("f")){%>selected<%}%>>full</option>
                      </select>
                    </td>                        
                    <td class=title>������̼�</td>
                    <td> 
                      &nbsp;<select name="navi_yn" disabled>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getNavi_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getNavi_yn().equals("N")){%>selected<%}%>>����</option>
                      </select>&nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> S / N:&nbsp;<input type='text' name='serial_no'  value="<%=rf_bean.getSerial_no()%>"  size='25' class='text'  readonly >               
                    </td>
                    <td class=title width=10%>GPS</td>
                    <td> 
                      &nbsp;<select name="gps_yn" disabled>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getGps_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getGps_yn().equals("N")){%>selected<%}%>>����</option>
                      </select>
                    </td>
                </tr>          
                <tr> 
                    <td class=title>��������Ÿ�</td>
                    <td> 
                      &nbsp;<input type="text" name="dist_km" value="<%=AddUtil.parseDecimal(rf_bean.getDist_km())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      km
                    </td>                        
                    <td class=title>Ź�ۿ�û</td>
                    <td colspan='3'> 
                      &nbsp;<select name="cons_yn" disabled>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getCons_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getCons_yn().equals("N")){%>selected<%}%>>����</option>
                      </select>
                    </td>            
                </tr>    
               <tr> 
                   <td class=title width=10%>Ư�̻���</td>
                    <td colspan='5'> 
                      &nbsp;<textarea name="fee_etc" cols="110" rows="3" class=default <%=readonly%>><%=rf_bean.getFee_etc()%></textarea>                 
                    </td>                                           
                </tr>       
                <tr> 
                    <td class=title>�ڵ���ü</td>
                    <td  colspan='5'> 
                      &nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                      <select name='cms_bank' disabled>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        				for(int i = 0 ; i < bank_size ; i++){
        					CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(rf_bean.getCms_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        			}%>
                      </select>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> ���¹�ȣ:&nbsp; 
                      <input type='text' name='cms_acc_no' value='<%=rf_bean.getCms_acc_no()%>' size='20' class='whitetext'>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ������:&nbsp; 
                      <input type='text' name='cms_dep_nm' value='<%=rf_bean.getCms_dep_nm()%>' size='20' class='whitetext'>
                    </td>
                </tr>    
                <%if(rent_st.equals("12")){%>
                <tr> 
                    <td class=title>����Ʈ���</td>
                    <td colspan="5">&nbsp;���뿩�� : <%=AddUtil.parseDecimal(e_bean.getFee_s_amt())%>�� (���ް�)
                    	<input type='hidden' name='rm1' value='<%=e_bean.getFee_s_amt()%>'> 
                    	<%if(!rf_bean.getEst_id().equals("")){%>
                          <a href="javascript:EstiPrintRm('2','1','1','<%=e_bean.getFee_s_amt()%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                          &nbsp;
                          (<%=rf_bean.getEst_id()%>)
                        <%}%> 
                        &nbsp;       
                        ������ : <input type='text' name='amt_per' value='<%=rf_bean.getAmt_per()%>' size='10' class='whitetext'>                      
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
                    <td class=title rowspan="2" >����</td>
                    <td class=title colspan="6">���뿩��</td>
                    <td class=title width="11%">�뿩���Ѿ�</td>
                    <td class=title rowspan="2" width="8%">������</td>
                    <td class=title rowspan="2" width="8%">������</td>
                    <td class=title rowspan="2" width="11%">�Ѱ���ݾ�</td>                    
                </tr>
                <tr>
                  <td width="10%" class=title>����뿩��</td>
                  <td width="8%" class=title>D/C</td>
                  <td width="8%" class=title>������̼�</td>
                  <td width="8%" class=title>��Ÿ</td>                  
                  <td width="8%" class=title>���ú����</td>                  
                  <td width="10%" class=title>�հ�</td>                  
                  <td class=title>
                  	<input type="text" name="v_rent_months" value="<%=rc_bean.getRent_months()%>" size="1" class=whitenum>
                      	����
                      	<input type="text" name="v_rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=whitenum>
                      	��
                  </td>           
                </tr>               
                <tr> 
                    <td class=title width="10%">���ް�</td>
                    <td align="center"> 
                      <input type="text" name="inv_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ΰ���</td>
                    <td align="center"> 
                      <input type="text" name="inv_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center"> 
                      <input type="text" name="inv_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getInv_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt()+rf_bean.getDc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="ins_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <!--
                <tr> 
                    <td class=title colspan="2">�Ѱ����ݾ�</td>
                    <td align="center"> 
                      &nbsp;<input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td colspan="7"> 
                      &nbsp;</td>    
                </tr>
                -->
                <tr> 
                    <td class=title>���ʰ����ݾ�</td>
                    <td align="center"> 
                      &nbsp;<input type="text" name="f_rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getF_rent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td class=title>���ʰ������</td>
                    <td colspan="8">&nbsp; 
                      <select name="f_paid_way" disabled>
                        <option value="">==����==</option>			  
                        <option value="1" <%if(rf_bean.getF_paid_way().equals("1")){%>selected<%}%>>1����ġ</option>
                        <option value="2" <%if(rf_bean.getF_paid_way().equals("2")){%>selected<%}%>>�Ѿ�</option>
                      </select>
                      &nbsp; ������
                      <select name="f_paid_way2" disabled>
                        <option value="">==����==</option>			  
                        <option value="1" <%if(rf_bean.getF_paid_way2().equals("1")){%>selected<%}%>>����</option>
                        <option value="2" <%if(rf_bean.getF_paid_way2().equals("2")){%>selected<%}%>>������</option>
                      </select>
                      </td>  
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
    <tr id=tr_pre style="display:<%if(rf_bean.getPaid_way().equals("1")) {%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������/������</span></td>
    </tr>
    <tr id=tr_pre1 style="display:<%if(rf_bean.getPaid_way().equals("1")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=20%>�Աݱ���</td>
                    <td class=title width=20%>���α���</td>
                    <td class=title width=20%>�Ա�����</td>
                    <td class=title width=20%>�Աݱݾ�</td>
                    <td class=title width=20%>�ܾ�</td>
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st1" value="1">
                      ���ຸ����</td>
                    <td align="center"> 
                      <select name="paid_st1" <%=disabled%>>
                        <option value="">==����==</option>			  			  
                        <option value="1" <%if(sr_bean1.getPaid_st().equals("1")){%>selected<%}%>>����</option>
                        <option value="2" <%if(sr_bean1.getPaid_st().equals("2")){%>selected<%}%>>ī��</option>
                        <option value="3" <%if(sr_bean1.getPaid_st().equals("3")){%>selected<%}%>>�ڵ���ü</option>				
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="pay_dt1" value="<%=AddUtil.ChangeDate2(sr_bean1.getPay_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="pay_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getPay_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rest_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getRest_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st2" value="2">
                      �뿩��(����)</td>
                    <td align="center"> 
                      <select name="paid_st2" <%=disabled%>>
                        <option value="">==����==</option>			  			  
                        <option value="1" <%if(sr_bean2.getPaid_st().equals("1")){%>selected<%}%>>����</option>
                        <option value="2" <%if(sr_bean2.getPaid_st().equals("2")){%>selected<%}%>>ī��</option>
                        <option value="3" <%if(sr_bean2.getPaid_st().equals("3")){%>selected<%}%>>�ڵ���ü</option>				
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="pay_dt2" value="<%=AddUtil.ChangeDate2(sr_bean2.getPay_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="pay_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getPay_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rest_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getRest_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>		
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span></td>
	    <td align="right">
        <%if((auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) && (br_id.equals("S1") || rc_bean.getBrch_id().equals(br_id))){%>
        <%	if(!rs_bean.getSett_dt().equals("")){%>
        <a href="javascript:save('rent_settle');"> <img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
        <%	}%>
        <%}%>
        <%if(nm_db.getWorkAuthUser("������",user_id)){%>
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
                    <td class=title width=10%>��������</td>
                    <td width=41%> 
                      &nbsp;<input type="text" name="sett_dt" value="<%=AddUtil.ChangeDate2(rs_bean.getSett_dt())%>" size="12" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>��������Ÿ�</td>
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
                    <td width=10% rowspan="2" class=title>����</td>
                    <td colspan="5" class=title>���뿩��</td>
                    <td width=10% rowspan="2" class=title>�뿩���Ѿ�</td>                    
                    <td width=8% rowspan="2" class=title>������</td>
                    <td width=8% rowspan="2" class=title>������</td>
                    <td width=10% rowspan="2" class=title>�հ�<br>(���ް�)</td>
                    <td width=10% rowspan="2" class=title>�հ�<br>(VAT����)</td>
                </tr>
                <tr>
                  <td width=9% class=title>����</td>
                  <td width=8% class=title>������̼�</td>
                  <td width=9% class=title>��Ÿ</td>
                  <td width=9% class=title>���ú����</td>
                  <td width=9% class=title>�հ�</td>
                </tr>            
                <tr> 
                    <td class=title>����</td>
                    <td align="center">
                      <input type="text" name="ag_inv_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+ext_pay_rent_s_amt)%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_inv_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_inv_amt'   value='<%=rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_navi_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_navi_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>'>			 
                      <input type='hidden' name='ag_navi_amt'   value='<%=rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_etc_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>'>			 
                      <input type='hidden' name='ag_etc_amt'   value='<%=rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_ins_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center">
                      <input type="text" name="ag_t_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getIns_s_amt()+ext_pay_rent_s_amt)%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_t_fee_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_t_fee_amt'   value='<%=rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getIns_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>                      
                    <td align="center">
                      <input type="text" name="ag_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+ext_pay_rent_s_amt)%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_fee_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_fee_amt'   value='<%=rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="ag_cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_cons1_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>'>			 
                      <input type='hidden' name='ag_cons1_amt'   value='<%=rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_cons2_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>'>			 
                      <input type='hidden' name='ag_cons2_amt'   value='<%=rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt()%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="ag_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt()+ext_pay_rent_s_amt)%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt)%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                </tr>
                <tr>
                  <td class=title>�߰�</td> 
                    <td align="center">
                      <input type="text" name="add_inv_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_inv_s_amt())%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_inv_v_amt' value='<%=rs_bean.getAdd_inv_v_amt()%>'>
                      <input type='hidden' name='add_inv_amt' value='<%=rs_bean.getAdd_inv_s_amt()+rs_bean.getAdd_inv_v_amt()%>'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_navi_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_navi_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_navi_v_amt' value='<%=rs_bean.getAdd_navi_v_amt()%>'>
                      <input type='hidden' name='add_navi_amt' value='<%=rs_bean.getAdd_navi_s_amt()+rs_bean.getAdd_navi_v_amt()%>'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_etc_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_etc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_etc_v_amt' value='<%=rs_bean.getAdd_etc_v_amt()%>'>
                      <input type='hidden' name='add_etc_amt' value='<%=rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_etc_v_amt()%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="add_ins_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_ins_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center">
                      <input type="text" name="add_t_fee_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_inv_s_amt()+rs_bean.getAdd_navi_s_amt()+rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_ins_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_t_fee_v_amt' value='<%=rs_bean.getAdd_inv_v_amt()+rs_bean.getAdd_navi_v_amt()+rs_bean.getAdd_etc_v_amt()%>'>
                      <input type='hidden' name='add_t_fee_amt'   value='<%=rs_bean.getAdd_inv_s_amt()+rs_bean.getAdd_navi_s_amt()+rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_ins_s_amt()+rs_bean.getAdd_inv_v_amt()+rs_bean.getAdd_navi_v_amt()+rs_bean.getAdd_etc_v_amt()%>'>
                    </td>                    
                    <td align="center">
                      <input type="text" name="add_fee_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt())%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_fee_v_amt' value='<%=rs_bean.getAdd_fee_v_amt()%>'>
                      <input type='hidden' name='add_fee_amt' value='<%=rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_fee_v_amt()%>'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_cons1_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_cons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_cons1_v_amt' value='<%=rs_bean.getAdd_cons1_v_amt()%>'>
                      <input type='hidden' name='add_cons1_amt' value='<%=rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons1_v_amt()%>'>
                    </td>                      
                    <td align="center">
                      <input type="text" name="add_cons2_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_cons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_cons2_v_amt' value='<%=rs_bean.getAdd_cons2_v_amt()%>'>
                      <input type='hidden' name='add_cons2_amt' value='<%=rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_cons2_v_amt()%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="add_tot_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type="text" name="add_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_cons1_v_amt()+rs_bean.getAdd_cons2_v_amt())%>" size="9" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                </tr>                  
                <tr>
                  <td class=title>����</td> 
                    <td align="center"> 
                      <input type='hidden' name='tot_inv_amt' value='0'>
                      <input type='hidden' name='tot_inv_v_amt' value='0'>
                      <input type="text" name="tot_inv_s_amt" value="0" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type="text" name="tot_navi_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_navi_v_amt' value='0'>
                      <input type='hidden' name='tot_navi_amt' value='0'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="tot_etc_s_amt" value="0" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_etc_v_amt' value='0'>
                      <input type='hidden' name='tot_etc_amt' value='0'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="tot_ins_s_amt" value="0" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_ins_v_amt' value='0'>
                      <input type='hidden' name='tot_ins_amt' value='0'>
                    </td>
                    <td align="center" > 
                      <input type="text" name="tot_t_fee_s_amt" value="0" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_t_fee_v_amt' value='0'>
                      <input type='hidden' name='tot_t_fee_amt' value='0'>
                    </td>                    
                    <td align="center"> 
                      <input type='hidden' name='tot_fee_amt' value='0'>
                      <input type='hidden' name='tot_fee_v_amt' value='0'>
                      <input type="text" name="tot_fee_s_amt" value="0" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type='hidden' name='tot_cons1_amt' value='0'>
                      <input type='hidden' name='tot_cons1_v_amt' value='0'>
                      <input type="text" name="tot_cons1_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type='hidden' name='tot_cons2_amt' value='0'>
                      <input type='hidden' name='tot_cons2_v_amt' value='0'>
                      <input type="text" name="tot_cons2_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center">                       
                      <input type='hidden' name='rent_tot_v_amt' value='0'>
                      <input type="text" name="rent_tot_s_amt" value="0" size="9" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center">                       
                      <input type="text" name="rent_tot_amt2" value="0" size="9" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
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
                    <td class=title width=10% rowspan="2">�δ���</td>
                    <td class=title width=9%>�����</td>
                    <td class=title width=8%>��å��</td>
                    <td class=title width=9%>������</td>
                    <td class=title width=9%>������</td>
                    <td class=title width=9%>km�ʰ�����</td>
                    <td class=title width=10%>�̼����·�</td>
                    <td class=title width=8%>-</td>
                    <td class=title width=8%>-</td>
                    <td class=title width=10%>�հ�<br>(���ް�)</td>
                    <td class=title width=10%>�հ�<br>(VAT����)</td>
                </tr>
                <tr>                  
                    <td align="center"> 
                      <input type='hidden' name='cls_amt' value='<%=rs_bean.getCls_s_amt()+rs_bean.getCls_v_amt()%>'>
                      <input type='hidden' name='cls_v_amt' value='<%=rs_bean.getCls_v_amt()%>'>
                      <input type="text" name="cls_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getCls_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      	��
                   </td>                    
                  <td align="center"><input type='hidden' name='ins_m_amt' value='<%=rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt()%>'>
                    <input type='hidden' name='ins_m_v_amt' value='<%=rs_bean.getIns_m_v_amt()%>'>
                    <input type="text" name="ins_m_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_m_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>                  
                  <td align="center"><input type='hidden' name='ins_h_amt' value='<%=rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt()%>'>
                    <input type='hidden' name='ins_h_v_amt' value='<%=rs_bean.getIns_h_v_amt()%>'>
                    <input type="text" name="ins_h_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_h_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>
                  <td align="center"><input type='hidden' name='oil_amt' value='<%=rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt()%>'>
                    <input type='hidden' name='oil_v_amt' value='<%=rs_bean.getOil_v_amt()%>'>
                    <input type="text" name="oil_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getOil_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>
                  <td align="center"><input type='hidden' name='km_amt' value='<%=rs_bean.getKm_s_amt()+rs_bean.getKm_v_amt()%>'>
                    <input type='hidden' name='km_v_amt' value='<%=rs_bean.getKm_v_amt()%>'>
                    <input type="text" name="km_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getKm_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>
                  <td align="center">
                    <input type="text" name="fine_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getFine_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>
		  <td align="center">-</td>	
		  <td align="center">-</td>	
                  <td align="center"><input type="text" name="etc_tot_s_amt" value="0" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>                  
                  <td align="center"><input type="text" name="etc_tot_amt" value="0" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		  </td>                  
                </tr>   
                <tr>
                    <td class=title>VAT</td>
                    <td align="center"><input type="checkbox" name="cls_vat" value="N" <%if(rs_bean.getCls_s_amt()>0 && rs_bean.getCls_v_amt()==0)%>checked<%%> onClick="javascript:set_amt(document.form1.cls_s_amt);">������</td>
                    <td align="center"><input type="checkbox" name="ins_m_vat" value="N" <%if(rs_bean.getIns_m_s_amt()>0 && rs_bean.getIns_m_v_amt()==0)%>checked<%%> onClick="javascript:set_amt(document.form1.ins_m_s_amt);">������</td>
                    <td align="center"><input type="checkbox" name="ins_h_vat" value="N" <%if(rs_bean.getIns_h_s_amt()>0 && rs_bean.getIns_h_v_amt()==0)%>checked<%%>  onClick="javascript:set_amt(document.form1.ins_h_s_amt);">������</td>
                    <td align="center"><input type="checkbox" name="oil_vat" value="N" <%if(rs_bean.getOil_s_amt()>0 && rs_bean.getOil_v_amt()==0)%>checked<%%>  onClick="javascript:set_amt(document.form1.oil_s_amt);">������</td>
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
                  <td class=title width=10%>1�����̻�<br>�������</td> 
                    <td align="center" width=10%>                      
                      <input type="text" name="t_dc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getT_dc_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
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
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ա�ó��</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id=tr_pay1 style="display:''"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td class=title width=20%> 
                      <p>�������</p>
                    </td>
                    <td class=title width=21%>��������</td>
                    <td class=title width=24%>�ݾ�</td>
                    <td class=title width=25%>���</td>
                </tr>
              <%for(int i = 0 ; i < cont_size ; i++){
    					Hashtable sr = (Hashtable)conts.elementAt(i);%>
                <tr> 
                    <td class=title> 
                      <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>
                      ����� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>
                      �����뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>
                      �뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("5")){%>
                      ����뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>
                      ����� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("6")){%>
                      ������
                      <%}%>
                    </td>
                    <td align="center"> 
                      <%if(String.valueOf(sr.get("PAID_ST")).equals("1")){%>
                      ���� 
                      <%}else if(String.valueOf(sr.get("PAID_ST")).equals("2")){%>
                      ī�� 
                      <%}else if(String.valueOf(sr.get("PAID_ST")).equals("3")){%>
                      �ڵ���ü 
                      <%}else if(String.valueOf(sr.get("PAID_ST")).equals("4")){%>
                      ������ 
                      <%}%>
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%></td>
                    <td align="center"> 
                      <input type="text" name="pay_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">-</td>
                </tr>
              <%		//if(String.valueOf(sr.get("RENT_ST")).equals("6")){	
    		  		//	pay_tot_amt = pay_tot_amt - AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  		//}else{
    		  			pay_tot_amt = pay_tot_amt + AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  		//}      		  		
    		  	}%>
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center"> 
                      <input type="text" name="pay_tot_amt" value="<%=Util.parseDecimal(pay_tot_amt)%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
<%	}%>	
    <tr><td class=h></td></tr>
    <tr id=tr_drv_nm style="display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")) {%>''<%}else{%>none<%}%>">	
      <td colspan="2" height="108"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿪���(�������)</span></td>
    </tr>
    <tr id=tr_drv1 style="display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class="title" width=10%>�������</td>
                    <td> 
                      &nbsp;<select name="driv_serv_st" onchange="javascript:driv_display();"  <%=disabled%>>
                        <option value="">����</option>
                        <option value="1" <%if(rs_bean.getDriv_serv_st().equals("1"))%>selected<%%>>�Ҽӿ뿪ȸ��� ���� ����</option>
                        <option value="2" <%if(rs_bean.getDriv_serv_st().equals("2"))%>selected<%%>>�뿩�� ����� �ջ�</option>
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
                    <td class=title width=20%>����</td>
                    <td class=title width=20%>��������</td>
                    <td class=title width=20%>��������</td>
                    <td class=title width=20%>�ݾ�</td>
                    <td class=title width=20%>���</td>
                </tr>
                <tr id=tr_scd style="display:''"> 
                    <td align="center">�Ա� 
                      <input type="hidden" name="d_rent_st1" value="1">
                    </td>
                    <td align="center"> 
                      <select name="d_paid_st1" <%=disabled%>>
                        <option value="1" <%if(sd_bean1.getPaid_st().equals("1"))%>selected<%%>>����</option>
                        <option value="2" <%if(sd_bean1.getPaid_st().equals("2"))%>selected<%%>>ī��</option>
                        <option value="3" <%if(sd_bean1.getPaid_st().equals("3"))%>selected<%%>>�ڵ���ü</option>
                        <option value="4" <%if(sd_bean1.getPaid_st().equals("4"))%>selected<%%>>������</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="d_pay_dt1" value="<%=AddUtil.ChangeDate2(sd_bean1.getPay_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="d_pay_amt1" value="<%=AddUtil.parseDecimal(sd_bean1.getPay_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td align="center"> 
                      <input type="hidden" name="d_rent_st2" value="2">
                    </td>
                    <td align="center"> 
                      <select name="d_paid_st2" <%=disabled%>>
                        <option value="1" <%if(sd_bean2.getPaid_st().equals("1"))%>selected<%%>>����</option>
                        <option value="2" <%if(sd_bean2.getPaid_st().equals("2"))%>selected<%%>>ī��</option>
                        <option value="3" <%if(sd_bean2.getPaid_st().equals("3"))%>selected<%%>>�ڵ���ü</option>
                        <option value="4" <%if(sd_bean2.getPaid_st().equals("4"))%>selected<%%>>������</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="d_pay_dt2" value="<%=AddUtil.ChangeDate2(sd_bean2.getPay_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="d_pay_amt2" value="<%=AddUtil.parseDecimal(sd_bean2.getPay_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class="title"> �հ�</td>
                    <td align="center">&nbsp; </td>
                    <td align="center">&nbsp; </td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="d_pay_tot_amt" value="<%=AddUtil.parseDecimal(sd_bean1.getPay_amt()+sd_bean2.getPay_amt())%>" readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_drv3 style="display:<%if((rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")) && rf_bean.getDriver_yn().equals("Y")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class="title" width=10%>���</td>
                    <td> 
                      &nbsp;<input type='text' size='90' class=<%=white%>text name="driv_serv_etc" value="<%=rs_bean.getDriv_serv_etc()%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_sett_nm2 style="display:<%if(rent_st.equals("1")||rent_st.equals("9") || rent_st.equals("12")) {%>''<%}else{%>none<%}%>">	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
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
                    <td class=title width=10%>�������</td>
                    <td class=title_p style='text-align:left'> 
                    &nbsp;<input type='text' size='12' class=<%=white%>num name="rent_sett_amt" value="<%=AddUtil.parseDecimal(rs_bean.getRent_sett_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                    �� (����뿩�� �հ� + �δ��� �հ�  - �Ա�ó�� �հ�, �������/�뿩������� �ջ��� ��� : �뿪��� �հ� ����)</td>
                </tr>
            </table>
        </td>
    </tr>
    
    <%	if(card_size > 0){%>
    <tr>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�¶��� �ſ�ī�����</span></td>
    </tr>    
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>
                 <tr>
                  <td width="10%" class=title>����</td>
                  <td width="15%" class=title>������ȣ</td>
                  <td width="15%" class=title>�޴�����ȣ</td>		  
                  <td width="10%" class=title>�ݾ�</td>
                  <td width="10%" class=title>ī������</td>
                  <td width="15%" class=title>ȸ������</td>
                  <td width="15%" class=title>����</td>
                  <td width="10%" class=title>����</td>		  
                </tr>    
    <%		for(int i = 0 ; i < card_size ; i++){
    			Hashtable card = (Hashtable)cards.elementAt(i);%>	
                <tr>
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%=card.get("AM_AX_CODE")%></td>
                  <td align="center"><%=card.get("AM_M_TEL")%></td>		  
                  <td align="right"><%=Util.parseDecimal(String.valueOf(card.get("AM_GOOD_AMT")))%>��</td>
                  <td align="center"><%=card.get("CARD_NAME")%></td>
                  <td align="center"><%=card.get("AM_CARD_SIGN")%></td>		  
                  <td align="center"><%=card.get("AM_CARD_REL")%></td>		  
                  <td align="center"><%if(String.valueOf(card.get("TNO")).equals("")){%>��� <%}else{%>���� <%}%></td>		  
                </tr>      			
    <%		}%>
                                
            </table>
        </td>
    </tr>        
    <%	}%>  
    
    <%}%>  
    
    <%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�⺻�� ������� ���</span>
        </td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>                           
                <tr> 
                    <td class=title>��������Ÿ�</td>
                    <td> 
                      &nbsp;<input type="text" name="dist_km" value="<%=AddUtil.parseDecimal(rf_bean.getDist_km())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      km
                    </td>                        
                    <td class=title>Ź�ۿ�û</td>
                    <td> 
                      &nbsp;<select name="cons_yn" <%=disabled%>>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getCons_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getCons_yn().equals("N")){%>selected<%}%>>����</option>
                      </select>
                    </td>   
                     <td class=title width=10%>GPS</td>
                    <td> 
                      &nbsp;<select name="gps_yn" <%=disabled%>>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getGps_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getGps_yn().equals("N")){%>selected<%}%>>����</option>
                      </select>
                    </td>         
                </tr>   
                     
               <tr> 
                   <td class=title width=10%>Ư�̻���</td>
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
                    <td class=title width=10%>û������</td>
                    <td colspan='4'>&nbsp;1�� <%=AddUtil.parseDecimal(rf_bean.getInv_s_amt())%>�� (���ް�)
                      </td>                      
                </tr>       	
                <tr> 
                    <td class=title>����</td>                    
                    <td width="11%" class=title>�뿩���Ѿ�</td>
                    <td width="8%" class=title>������</td>
                    <td width="8%" class=title>������</td>
                    <td width="11%" class=title>�Ѱ���ݾ�</td>
                </tr>            
                <tr> 
                    <td class=title width="10%">���ް�</td>
                    <td align="center"> 
                      <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ΰ���</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr> 
            </table>
        </td>
    </tr>    
    <tr> 
        <td colspan='2'>�� �̿� ���� ��� ��� : 24�ð� �̳� �ݳ� - 1��ġ ��� ����, 24�ð� �̻� �̿�� - 12�ð� ������ �뿩��� ����</td>
    </tr>         
<%	if(cont_size > 0){%>
    <tr id=tr_pay_nm style="display:''">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ա�ó��</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id=tr_pay1 style="display:''"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td class=title width=20%> 
                      <p>�������</p>
                    </td>
                    <td class=title width=21%>��������</td>
                    <td class=title width=24%>�ݾ�</td>
                    <td class=title width=25%>���</td>
                </tr>
              <%for(int i = 0 ; i < cont_size ; i++){
    					Hashtable sr = (Hashtable)conts.elementAt(i);%>
                <tr> 
                    <td class=title> 
                      <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>
                      ����� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>
                      �����뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>
                      �뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("5")){%>
                      ����뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>
                      ����� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("6")){%>
                      ������
                      <%}%>
                    </td>
                    <td align="center"> 
                      <%if(String.valueOf(sr.get("PAID_ST")).equals("1")){%>
                      ���� 
                      <%}else if(String.valueOf(sr.get("PAID_ST")).equals("2")){%>
                      ī�� 
                      <%}else if(String.valueOf(sr.get("PAID_ST")).equals("3")){%>
                      �ڵ���ü 
                      <%}else if(String.valueOf(sr.get("PAID_ST")).equals("4")){%>
                      ������ 
                      <%}%>
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%></td>
                    <td align="center"> 
                      <input type="text" name="pay_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">-</td>
                </tr>
              <%		//if(String.valueOf(sr.get("RENT_ST")).equals("6")){	
    		  		//	pay_tot_amt = pay_tot_amt - AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  		//}else{
    		  			pay_tot_amt = pay_tot_amt + AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  		//}      		  		
    		  	}%>
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center"> 
                      <input type="text" name="pay_tot_amt" value="<%=Util.parseDecimal(pay_tot_amt)%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
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
                    <td class=title width=10%>��������</td>
                    <td width=41%> 
                      &nbsp;<input type="text" name="sett_dt" value="<%=AddUtil.ChangeDate2(rs_bean.getSett_dt())%>" size="12" class=<%=white%>text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>��������Ÿ�</td>
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
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�⺻��ĵ����</span>
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
                    <td width="10%" class=title>����</td>
                    <td width="25%" class=title>����</td>                    
                    <td width="25%" class=title>��ĵ����</td>
                    <td width="25%" class=title>�������</td>
                    <td width="15%" class=title>����</td>		  
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
                   
                   
                <!-- �⺻�� ���� ������� ������ -->   
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
                    <td align="center">�⺻�������������������</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�⺻�������������������</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <%}%>
                                
                                
                <%if(rent_st.equals("1") || rent_st.equals("9") || rent_st.equals("12")){//�ܱ�뿩,�������,����Ʈ%>
                
                <%	scan_num++;%>
                   
                <!-- �ڵ����뿩�̿��༭ -->
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�ڵ����뿩�̿��༭</td>
                    <td align="center">
                        <%if(rent_st.equals("12")){%>
                            <%if(AddUtil.parseInt(rc_bean.getRent_dt()) > 20120830){%>
                    	        (��) <a href='/acar/secondhand_hp/rm_car_doc_new.jsp?rent_s_cd=<%=s_cd%>&car_mng_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                    	    <%}else{%>
                    	        (��) <a href='/acar/secondhand_hp/rm_car_doc.jsp?rent_s_cd=<%=s_cd%>&car_mng_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                    	    <%}%>
                        <%}else{%>
                            (��) <a href='res_rent_p.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp; 		      
                        <%}%>
                    </td>
                    <td align="center">��������</td>		  
                    <td align="center"></td>		  
                </tr>  
                                
                <!-- ��༭(��)-jpg���� -->
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
                    <td align="center">��༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">��༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                
                <!-- ��༭(��)-jpg���� -->
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
                    <td align="center">��༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">��༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                
                                
                <!-- ����ڵ����jpg -->
                <%	if(!rc_bean2.getEnp_no().equals("")){ //����,���λ����%>
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
                    <td align="center">����ڵ����jpg</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%			}
                		}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">����ڵ����jpg</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%		}%>
                <%	}%>

                <%	if(rc_bean2.getCust_st().equals("����")){%>
                
                <!-- ���ε��ε -->    
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
                    <td align="center">���ε��ε</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%			}
                		}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">���ε��ε</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%		}%>
                
                <!-- �����ΰ����� -->    
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
                    <td align="center">�����ΰ�����</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%			}
                		}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�����ΰ�����</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%		}%>                
                                            
                <%	}%>   
                

                <!-- �ź���jpg -->
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
                    <td align="center">�ź���jpg</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�ź���jpg</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
          
                <!-- �ֿ����ڿ��������� -->
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
                    <td align="center">�ֿ����ڿ���������</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�ֿ����ڿ���������</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>       
                
                <!-- �߰������ڿ��������� -->
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
                    <td align="center">�߰������ڿ���������</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�߰������ڿ���������</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                      
                
                <!-- ����纻 -->
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
                    <td align="center">����纻</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">����纻</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                          
                
                <%}%>    
                

                <!-- ���������ε��� -->
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
                    <td align="center">���������ε���</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">���������ε���</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>         
                
                <!-- ���������μ��� -->
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
                    <td align="center">���������μ���</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">���������μ���</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                                         
                
                
                <!-- ��Ÿ -->
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
                    <td align="center">��Ÿ</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">��Ÿ</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                   
                

                <!-- �߰� -->
                <% 	scan_num++; 
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�߰�</td>
                    <td align="center"><a href="javascript:scan_reg('')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
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
	
		//����		
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


		//�δ���
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
