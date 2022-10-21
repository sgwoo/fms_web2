<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*, acar.cont.*, acar.estimate_mng.*, acar.cont.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	String end_est_yn 	= request.getParameter("end_est_yn")	==null?"":request.getParameter("end_est_yn");

	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "05", "02");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String disabled = "disabled";
	String white = "white";
	String readonly = "readonly";
	if(mode.equals("u")){
		disabled = "";
		white = "";
		readonly = "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList(); //������ ����Ʈ ��ȸ
	int brch_size = branches.size();
	
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
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
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
	//�Աݽ�����
	Vector conts = rs_db.getScdRentList(s_cd, "fee");
	int cont_size = conts.size();
	//������
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
	//�ſ�ī�����
	Vector cards = rs_db.getRentContCardList(s_cd);
	int card_size = cards.size();
	
	//�ڵ���ü�� ���� cont ���� �����
	String rm_rent_mng_id = c_id;
	String rm_rent_l_cd   = "RM00000"+s_cd;
	
	//cms_mng
	ContCmsBean cms = a_db.getCmsMng(rm_rent_mng_id, rm_rent_l_cd);	
	
	int cms_scd_cnt = 0;
	
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	
	if(rf_bean.getFee_s_amt()>0 && rf_bean.getInv_s_amt()==0){
		rf_bean.setInv_s_amt(rf_bean.getFee_s_amt());
		rf_bean.setInv_v_amt(rf_bean.getFee_v_amt());
	}	
	
	

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='/include/estimate.js'></script>
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
	

	
	//�� ��ȸ
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
	
	//���뺸���� ���÷���
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

	//��������:ī���ȣ ���÷���
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
	
	//�������:������ ���÷���
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

	//�ǿ����� ����
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
		if(cnt == '1'){//����
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
		
	//�뿩�ϼ� ���ϱ�
	function getRentTime() {
		var fm = document.form1;	
		if(fm.mode.value != 'u') return;		
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;			

		if(fm.rent_start_dt.value != '' && fm.rent_end_dt.value != ''){
		
			//����Ʈ ���뿩���(20120614)
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
										
				fm.rent_months.value 		= parseInt(t3/m);
				fm.rent_days.value 		= parseInt((t3%m)/l);
				fm.rent_hour.value 		= parseInt(((t3%m)%l)/lh);						
				
				<%if(rc_bean.getRent_st().equals("2") && rf_bean.getRent_tot_amt() > 0){%>				
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
	
	//�ú� ����	
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
	
	//����뿩�� �ڵ����
	function getFee_sam(){
		var fm = document.form1;
		if(fm.mode.value != 'u') return;		
		fm.action = '/acar/res_search/short_fee_nodisplay.jsp';
		<%if(rc_bean.getRent_st().equals("2") && rf_bean.getRent_tot_amt() > 0){%>
		fm.action = '/acar/res_search/short_fee_nodisplay2.jsp';
		<%}%>
		fm.target = 'i_no';
		fm.submit();
	}
	
	//�ݾ� ����	
	function set_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;	
		if(fm.mode.value != 'u') return;	
		
		<%if(rc_bean.getRent_st().equals("2") && rf_bean.getRent_tot_amt() > 0){%>
		
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
		
		//�Ѱ���ݾ�											
		fm.rent_tot_s_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons2_s_amt.value)) );
		fm.rent_tot_v_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_v_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)) );
		fm.rent_tot_amt.value 	= parseDecimal(	toInt(parseDigit(fm.fee_amt.value))   + toInt(parseDigit(fm.cons1_amt.value))   + toInt(parseDigit(fm.cons2_amt.value))   );
						
		
		
		
	}			

	//�ݾ� ����	
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
	
	//���ʰ������ ����
	function f_paid_way_display(){
		var fm = document.form1;
		
		if(fm.f_paid_way.value == '1'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.dc_amt.value)) + toInt(parseDigit(fm.ins_amt.value)) + toInt(parseDigit(fm.navi_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.cons1_amt.value)) );
		}else if(fm.f_paid_way.value == '2'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.m2_dc_amt.value)) - toInt(parseDigit(fm.m3_dc_amt.value)) + toInt(parseDigit(fm.cons1_amt.value)) );
		}
		
		//������ �������Կ���
		if(fm.f_paid_way2.value == '1'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.f_rent_tot_amt.value)) + toInt(parseDigit(fm.cons2_amt.value)));
		}
		
		pay_set_amt();				
	
	}				
	

	// ������� ------------------------------------------------------------------------------------------------
	
	//���� ��ȸ
	function serv_select(){
		var fm = document.form1;
		if(fm.mode.value != 'u') return;		
			fm.serv_id.value 	= "";
			fm.off_nm.value 	= "";
			if(fm.c_cust_id.value == '' && fm.rent_st.value == '2'){ alert('���� �����Ͻʽÿ�.');  return;}
			window.open("/acar/res_search/sub_select_2_s.jsp?c_id="+fm.sub_c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value, "SERV_SEARCH", "left=50, top=50, width=800, height=600, status=yes");
	}	

	
	// ������ ------------------------------------------------------------------------------------------------
	
	//��� ��ȸ
	function accid_select(){
		var fm = document.form1;
		if(fm.mode.value != 'u') return;		
			fm.accid_id.value 	= "";
			fm.off_nm.value 	= "";
			if(fm.rent_st.value == '3'){
				fm.our_num.value	= "";
				fm.ins_nm.value		= "";
				fm.ins_mng_nm.value	= "";			
				if(fm.c_cust_id.value == '' && fm.rent_st.value == '3'){ alert('���� �����Ͻʽÿ�.');  return;}				
			}else{
				fm.accid_dt.value = "";
				fm.accid_mng_nm.value = "";
				fm.accid_cont.value = "";
			}
			window.open("/acar/res_search/sub_select_3_a.jsp?c_id="+fm.sub_c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&user_id="+fm.user_id.value, "ACCID_SEARCH", "left=50, top=50, width=800, height=300, status=yes");
	}	


	// �뿩 �� �������� ------------------------------------------------------------------------------------------------
	
	//���� ��ȸ
	function user_select(){
		return;
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

	
	// �������� ------------------------------------------------------------------------------------------------
	
	//�������� ��ȸ
	function maint_select(){
		var fm = document.form1;
		if(fm.mode.value != 'u') return;		
			fm.seq_no.value 	= "";
			fm.che_kd.value 	= "";
			fm.che_no.value		= "";
			fm.che_comp.value	= "";
			window.open("/acar/res_search/sub_select_5_m.jsp?c_id="+fm.c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value, "ACCID_SEARCH", "left=50, top=50, width=800, height=300, status=yes");
	}	

	
	// ��Ÿ ------------------------------------------------------------------------------------------------
	




	//����������Ȳ ��ȸ
	function car_reserve(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserve", "left=50, top=50, width=820, height=500, scrollbars=yes");
	}

	//��������������Ȳ ��ȸ
	function car_reserve2(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve_dk.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserveDK", "left=50, top=50, width=820, height=700, scrollbars=yes");
	}

	//�����ü ��ȸ
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
	

	//����ϱ�
	function all_reset(){
		var fm = document.form1;	
		fm.reset();
	}
	
	//�����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.mode.value != 'u'){
			fm.mode.value = 'u';
			fm.action = 'res_rent_u.jsp';
			fm.target = 'd_content';
			fm.submit();
		}else{
			//���������ȣ �ڸ���üũ �� formating ���� �߰�(2018.02.07)
			<%if(rc_bean.getRent_st().equals("1")||rc_bean.getRent_st().equals("9")){%>
				if(fm.c_lic_no.value!=""){
					var chk_lic_no_res = CheckLic_no(fm.c_lic_no.value);
					if(chk_lic_no_res=='N'){	return false;	}
				}
				if(fm.m_lic_no1.value!=""){
					var chk_lic_no_res2 = CheckLic_no(fm.m_lic_no1.value);
					if(chk_lic_no_res2=='N'){	return false;	}
				}
			<%}else if(rc_bean.getRent_st().equals("4") || rc_bean.getRent_st().equals("5")){%>
				if(fm.c_lic_no.value!=""){
					var chk_lic_no_res = CheckLic_no(fm.c_lic_no.value);
					if(chk_lic_no_res=='N'){	return false;	}
				}
			<%}%>	
			
			if(fm.c_id.value == ''){ alert('���������� �߸��Ǿ����ϴ�\n\n��Ͽ��� �����Ͻʽÿ�'); return; }
			if(fm.rent_st.value == ''){ alert('��౸���� �߸��Ǿ����ϴ�\n\n������������ �����Ͻʽÿ�'); return; }		
			if(fm.rent_st.value == '1' || fm.rent_st.value == '9' || fm.rent_st.value == '12'){
				if(fm.rent_st.value != '12' && fm.gua_st.value == ''){ alert('���� ���θ� �����Ͻʽÿ�'); fm.gua_st.focus(); return; }
				if(fm.c_cust_id.value == ''){ alert('���� �����Ͻʽÿ�'); return; }
				if(fm.tax_yn.value == ''){ alert('���ݰ�꼭 ���� ���θ� �����Ͻʽÿ�'); fm.tax_yn.focus(); return; }
				if(fm.ins_yn.value == ''){ alert('���ú��� ���� ���θ� �����Ͻʽÿ�'); fm.ins_yn.focus(); return; }
				if(fm.paid_way.value == ''){ alert('��������� �����Ͻʽÿ�'); fm.paid_way.focus(); return; }
				if(fm.paid_st.value == ''){ alert('���������� �����Ͻʽÿ�'); fm.paid_st.focus(); return; }
				if(fm.fee_s_amt.value == ''){ alert('����뿩�Ḧ Ȯ���Ͻʽÿ�'); fm.fee_s_amt.focus(); return; }
				if(fm.rent_tot_amt.value == ''){ alert('�Ѱ����ݾ��� Ȯ���Ͻʽÿ�'); fm.rent_tot_amt.focus(); return; }
				
			}else if(fm.rent_st.value == '2'){
				if(fm.c_cust_id.value == ''){ alert('���� �����Ͻʽÿ�'); return; }
			}else if(fm.rent_st.value == '3'){
				if(fm.c_cust_id.value == ''){ alert('���� �����Ͻʽÿ�'); return; }
			}else if(fm.rent_st.value == '4' || fm.rent_st.value == '5'){
				if(fm.c_cust_nm.value == ''){ alert('����ڸ� �����Ͻʽÿ�'); return; }
			}else if(fm.rent_st.value == '10'){
				if(fm.c_cust_id.value == ''){ alert('���� �����Ͻʽÿ�'); return; }
			}
			if(fm.rent_dt.value == ''){ alert('������ڸ� �Է��Ͻʽÿ�'); fm.rent_dt.focus(); return; }
			if(fm.s_brch_id.value == ''){ alert('�����Ҹ� �Է��Ͻʽÿ�'); fm.brch_id.focus(); return; }
			if(fm.bus_id.value == ''){ alert('����ڸ� �Է��Ͻʽÿ�'); fm.bus_id.focus(); return; }
			if(fm.rent_start_dt.value == ''){ alert('�̿�Ⱓ �����Ͻø� �Է��Ͻʽÿ�'); fm.rent_start_dt.focus(); return; }
			if(fm.deli_plan_dt.value == ''){ alert('���������Ͻø� �Է��Ͻʽÿ�'); fm.deli_plan_dt.focus(); return; }
			
			if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		
			if(fm.rent_start_dt.value != '')
				fm.h_rent_start_dt.value = fm.rent_start_dt.value+fm.rent_start_dt_h.value+fm.rent_start_dt_s.value;
			if(fm.rent_end_dt.value != '')
				fm.h_rent_end_dt.value = fm.rent_end_dt.value+fm.rent_end_dt_h.value+fm.rent_end_dt_s.value;
			if(fm.deli_plan_dt.value != '')
				fm.h_deli_plan_dt.value = fm.deli_plan_dt.value+fm.deli_plan_dt_h.value+fm.deli_plan_dt_s.value;
			if(fm.ret_plan_dt.value != '')
				fm.h_ret_plan_dt.value = fm.ret_plan_dt.value+fm.ret_plan_dt_h.value+fm.ret_plan_dt_s.value;
			if(fm.deli_dt.value != '')
				fm.h_deli_dt.value = fm.deli_dt.value+fm.deli_dt_h.value+fm.deli_dt_s.value;
			if(fm.ret_dt.value != '')
				fm.h_ret_dt.value = fm.ret_dt.value+fm.ret_dt_h.value+fm.ret_dt_s.value;
			
			fm.action = 'res_rent_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		fm.action = 'rent_mn_frame_s.jsp';
		if('<%=list_from_page%>' != '') fm.action = '<%=list_from_page%>';
		fm.target = 'd_content';
		fm.submit();			
	}	
	
	//Ź���Ƿڵ��
	function tint_reg_link(){
		var fm = document.form1;
		var auth_rw 	= fm.auth_rw.value;
		var br_id 		= fm.br_id.value;
		var user_id		= fm.user_id.value;						
		var car_mng_id 	= fm.c_id.value;
		var sub_l_cd 	= fm.sub_l_cd.value;
		var sub_c_id 	= fm.sub_c_id.value;
		var rent_st 	= fm.rent_st.value;		
		location = "/fms2/consignment_new/cons_reg_step1.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&car_mng_id="+car_mng_id+"&sub_l_cd="+sub_l_cd+"&sub_c_id="+sub_c_id+"&rent_st="+rent_st;		
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
	
	//����Ʈ ��������� ����
	function mng_id_reg(brch_id){
		var fm = document.form1;
		window.open("about:blank", "MNGID_REG", "left=100, top=10, width=700, height=600, resizable=yes, scrollbars=yes, status=yes");			
		fm.mngid_reg_brch_id.value = brch_id;
		fm.target = 'MNGID_REG';
		fm.action = 'mng_id_reg.jsp';
		fm.submit();							
	}
		
	function RentMemo(s_cd, c_id, user_id){
		var SUBWIN="/acar/con_rent/res_memo_i.jsp?s_cd="+s_cd+"&c_id="+c_id+"&user_id="+user_id;	
		window.open(SUBWIN, "RentMemoDisp", "left=100, top=100, width=580, height=700, scrollbars=yes");
	}	
		
	//������
	function reserve_action(mode){
		var fm = document.form1;
		window.open("about:blank", "ACTION", "left=100, top=100, width=900, height=560, resizable=yes, scrollbars=yes, status=yes");			
		fm.mode.value = mode;
		fm.target = 'ACTION';
		fm.action = 'res_action.jsp';
		fm.submit();			
	}	
	
	//ī�����������ȣ�߼�
	function ax_hub_orderno_send(rent_st, tm){
		var fm = document.form1;
		fm.scd_rent_st.value = rent_st;
		fm.scd_tm.value = tm;
		window.open("about:blank", "AX_HUB_ORDER_SEND", "left=100, top=10, width=700, height=500, resizable=yes, scrollbars=yes, status=yes");			
		fm.target = 'AX_HUB_ORDER_SEND';
		fm.action = '/acar/rent_mng/ax_hub_order_send.jsp';
		fm.submit();			
	}
	
	//CMS��û
	function cms_reg(rent_st, tm){
		var fm = document.form1;
		fm.scd_rent_st.value = rent_st;
		fm.scd_tm.value = tm;
		window.open("about:blank", "CMS_REG", "left=100, top=10, width=700, height=500, resizable=yes, scrollbars=yes, status=yes");			
		fm.target = 'CMS_REG';
		fm.action = '/acar/rent_mng/cms_reg.jsp';
		fm.submit();			
	}
	
	//�������������̷�
	function EstiHistory(){
		var fm = document.form1;
		window.open("about:blank", "ESTI_HISTORY", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");			
		fm.target = 'ESTI_HISTORY';
		fm.action = '/acar/rent_mng/rm_esti_history.jsp';
		fm.submit();				
	}
	
	//�׺���̼��̿�� ����
	function navi_yn_display(){
		var fm = document.form1;

		if(fm.navi_yn.value == 'Y'){
			fm.navi_amt.value = 27500;						
		}else{
			fm.navi_amt.value = 0;
			fm.serial_no.value = "";			
		}	
		set_amt(fm.navi_amt);		
	}
	
	//�׺���̼�
	function search_navi(){
		var fm = document.form1;
		if(fm.c_cust_id.value == ''){
			alert('���� ���� �����Ͻʽÿ�.');
			return;
		}		
		window.open("/acar/res_search/search_navi.jsp?client_id="+fm.c_cust_id.value, "SEARCH_CMS", "left=50, top=0, width=820, height=600, resizable=yes, scrollbars=yes, status=yes");		
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
		
	//����Ʈ���� 1�����̻��϶� ������ ����
	function go_esti_print(){  
		var fm = document.form2;
		fm.action = "/acar/secondhand_hp/estimate_rm_new.jsp";
		fm.target = "_blank";
		fm.submit();
	}					
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
 <input type='hidden' name='use_st' value='<%=use_st%>'>
 <input type='hidden' name='c_cust_id' value='<%=rc_bean.getCust_id()%>'>
 <input type='hidden' name='site_id' value='<%=rc_bean.getSite_id()%>'>
 <input type='hidden' name='sub_c_id' value='<%=rc_bean.getSub_c_id()%>'>
 <input type='hidden' name='h_rent_start_dt' value=''>
 <input type='hidden' name='h_rent_end_dt' value=''>
 <input type='hidden' name='h_deli_plan_dt' value=''>
 <input type='hidden' name='h_ret_plan_dt' value=''>
 <input type='hidden' name='h_deli_dt' value=''>
 <input type='hidden' name='h_ret_dt' value=''> 
 <input type='hidden' name='c_car_no' value='<%=rc_bean2.getCar_no()%>'>
 <input type='hidden' name='section' value='<%=reserv.get("SECTION")%>'>
 <input type='hidden' name='sub_l_cd' value='<%=rc_bean.getSub_l_cd()%>'>
 <input type='hidden' name='from_page' value='/acar/rent_mng/res_rent_u.jsp'>
 <input type='hidden' name='remove_seq' value=''> 
 <input type='hidden' name='rent_mng_id' value='<%=c_id%>'>
 <input type='hidden' name='rent_l_cd' value='<%=s_cd%>'>
 <input type='hidden' name='amt_per' value='<%=rf_bean.getAmt_per()%>'>    
 <input type='hidden' name='end_est_yn' value='<%=end_est_yn%>'>    
 <input type='hidden' name='scd_rent_st' value=''>   
 <input type='hidden' name='scd_tm' value=''>   
<input type='hidden' name='day_s_amt' value='<%=rf_bean.getInv_s_amt()%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
					<span class=style1>
					<%if(!mode.equals("fine_doc")){%>
					����ý��� > ��������� > ������ > <span class=style5>������� ( 
					<%}%>
                    <%if(rc_bean.getRent_st().equals("1")){%>
                    �ܱ�뿩 
                    <%}else if(rc_bean.getRent_st().equals("2")){%>
                    ������� 
                    <%}else if(rc_bean.getRent_st().equals("3")){%>
                    ������ 
                    <%}else if(rc_bean.getRent_st().equals("9")){%>
                    ������� 
                    <%}else if(rc_bean.getRent_st().equals("10")){%>
                    �������� 		
                    <%}else if(rc_bean.getRent_st().equals("4")){%>
                    �����뿩 
                    <%}else if(rc_bean.getRent_st().equals("5")){%>
                    �������� 
                    <%}else if(rc_bean.getRent_st().equals("6")){%>
                    �������� 
                    <%}else if(rc_bean.getRent_st().equals("7")){%>
                    �������� 
                    <%}else if(rc_bean.getRent_st().equals("8")){%>
                    ������ 
                    <%}else if(rc_bean.getRent_st().equals("11")){%>
                    ��Ÿ 
                   
                    <%}%>
					<%if(!mode.equals("fine_doc")){%>
                    )</span>
					<%}%>
					</span>
					</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr><td class=h></td></tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� (<%=c_id%>)</span></td>
        <td align="right">
    	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    	    <%	if(mode.equals("")){%>
            <a href='javascript:save();'><img src="/acar/images/center/<%if(mode.equals("u")){%>button_modify<%}else{%>button_modify_s<%}%>.gif" align="absmiddle" border="0"></a>&nbsp; 
            <%	}%>
            <%}%>
            <%if(!mode.equals("view")){%>						
            &nbsp;<a href='javascript:go_to_list();'><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>	    
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
                <!--
                <tr> 
                    <td class=title>����������</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAX_DT")))%></td>
                    <td class=title>������ġ</td>
                    <td>&nbsp;</td>
                    <td class=title>�ε�������</td>
                    <td colspan="3">&nbsp;</td>
                </tr>
                -->
				<tr> 
                    <td class=title width=10%>�˻���ȿ�Ⱓ</td>
                    <td width=23% colspan="3">&nbsp; 
                      <input type="text" name="maint_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>" size="10" class=whitetext>
                      ~ 
                      <input type="text" name="maint_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%>" size="10" class=whitetext>
                      &nbsp; </td>
                    <td class=title>���ɸ�����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("CAR_END_DT")))%>" size="10" class=whitetext>
                    </td>
                    <td class=title>������ȿ�Ⱓ</td>
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
    <tr id=tr_cust_nm style="display:<%if(rc_bean.getRent_st().equals("1")||rc_bean.getRent_st().equals("2")||rc_bean.getRent_st().equals("3")||rc_bean.getRent_st().equals("4")||rc_bean.getRent_st().equals("5")||rc_bean.getRent_st().equals("9")||rc_bean.getRent_st().equals("10")) {%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
        <td align="right">		  
            <%if(!mode.equals("fine_doc")){%>
            
    	        <img src=/acar/images/center/arrow.gif><%=reserv.get("CAR_NO")%>
		<a href="javascript:car_reserve();"><img src="/acar/images/center/button_list_dy.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
    		<a href="javascript:car_reserve2();"><img src="/acar/images/center/button_list_dg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;                
	    	
	    <%if(!mode.equals("view")){%>
		<a href="javascript:view_scan_res('<%=c_id%>','<%=s_cd%>')" onMouseOver="window.status=''; return true" title='���·�÷�ι���'><img src=/acar/images/center/button_file_gtr.gif border=0 align=absmiddle></a>&nbsp;
		<a href="javascript:move_fee_scd()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_sch.gif align=absmiddle border="0"></a>&nbsp;&nbsp;		
	    <%}%>	
		<a href="javascript:RentMemo('<%=s_cd%>','<%=c_id%>','<%=ck_acar_id%>');" class="btn" title='��ȭ��������'><img src=/acar/images/center/button_th.gif align=absmiddle border=0></a>&nbsp;
		<%if(end_est_yn.equals("Y")){%>
		<a href="javascript:reserve_action('A');" class="btn" title='�������ϱ�'><img src=/acar/images/center/button_yj.gif align=absmiddle border=0></a>&nbsp;
		<%}%>		
	    <%}%>	
        </td>
    </tr>
    <%if(rc_bean.getRent_st().equals("1")||rc_bean.getRent_st().equals("9")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>
        			<%if(mode.equals("u")){%>
        			���� <!--<a href="javascript:cust_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>-->
        			<%}else{%>
        			����
        			<%}%>			
        			</td>
                    <td colspan="2"> 
                        &nbsp;<input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
                        <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="25" class=whitetext>
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
                        &nbsp;<input type="text" name="c_firm_nm" value="<%=rc_bean2.getFirm_nm()%>" size="50" class=whitetext>
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
					<input type="text" name='c_zip' id="c_zip" size="7" value="<%=rc_bean2.getZip()%>"  maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='c_addr' id="c_addr" value="<%=rc_bean2.getAddr()%>" size="47">
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>���������ȣ</td>
                    <td width=12%> 
                        &nbsp;<input type="text" name="c_lic_no" value="<%=rm_bean4.getLic_no()%>" size="16" class=<%=white%>text onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                    </td>
                    <td class=title width=10%>��������</td>
                    <td width=8%> 
                        &nbsp;<select name='c_lic_st' <%=disabled%>>
                        <option value=''>����</option>
                        <option value='1' <%if(rm_bean4.getLic_st().equals("1"))%>selected<%%>>2������</option>
                        <option value='2' <%if(rm_bean4.getLic_st().equals("2"))%>selected<%%>>1������</option>
                        <option value='3' <%if(rm_bean4.getLic_st().equals("3"))%>selected<%%>>1������</option>
                      </select> 
                    </td>
                    <td class=title width=11%>��ȭ��ȣ</td>
                    <td width=10%> 
                        &nbsp;<input type="text" name="c_tel" value="<%=rm_bean4.getTel()%>" class=<%=white%>text size="15">
                    </td>
                    <td class=title width=10%>�޴���</td>
                    <td> 
                        &nbsp;<input type="text" name="c_m_tel" value="<%=rm_bean4.getEtc()%>" size="15" class=<%=white%>text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��󿬶�ó</td>
                    <td colspan='7'> 
                        <input type="hidden" name="mgr_st2" value="2">
                        &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp;
                        <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=<%=white%>text size="10">
                        &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����ó:&nbsp; 
                        <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=<%=white%>text>
                        &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                        <input type="text" name="m_etc2" value="<%=rm_bean2.getEtc()%>" size="38" class=<%=white%>text>
                    </td>
                </tr>
                
                <tr> 
                    <td class=title rowspan="4">�ǿ�����<br>(�뿪��� ��)</td>
                    <td  colspan='7'> 
                        &nbsp;<input type="checkbox" name="cust_sam_chk" value="N" onclick="javascript:mgr1_set();">
                        ���� ���� ����
                        </td>
                </tr>		  
                <tr> 
                    <td colspan='7'>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp;
                        <input type="hidden" name="mgr_st1" value="1">
                        <input type="text" name="mgr_nm1" value="<%=rm_bean1.getMgr_nm()%>" class=<%=white%>text size="10">
                        &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> �������:&nbsp;
                        <input type="text" name="m_ssn1" value="<%=AddUtil.ChangeEnpH(rm_bean1.getSsn())%>" size="15" class=<%=white%>text>
                        &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ���������ȣ:&nbsp; 
                        <input type="text" name="m_lic_no1" value="<%=rm_bean1.getLic_no()%>" size="16" class=<%=white%>text onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                        &nbsp; <img src=/acar/images/center/arrow.gif> ��������:&nbsp; 
                      <select name='m_lic_st1' <%=disabled%>>
                        <option value=''>����</option>
                        <option value='1' <%if(rm_bean1.getLic_st().equals("1"))%>selected<%%>>2������</option>
                        <option value='2' <%if(rm_bean1.getLic_st().equals("2"))%>selected<%%>>1������</option>
                        <option value='3' <%if(rm_bean1.getLic_st().equals("3"))%>selected<%%>>1������</option>
                      </select> 
                        &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ��ȭ��ȣ:&nbsp;  
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
                    <td colspan='7'>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> �ּ�:&nbsp 
					<input type="text" name='m_zip1' id="m_zip1" size="7" value="<%=rm_bean1.getZip()%>"  maxlength='7'>
					<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='m_addr1' id="m_addr1" value="<%=rm_bean1.getAddr()%>" size="47">

                    </td>
                </tr>
               <tr> 
                    <td  colspan='7'>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ��Ÿ:&nbsp;                       
                      <input type="text" name="m_etc1" value="<%=rm_bean1.getEtc()%>" size="113" class=<%=white%>text>
                    </td>
                </tr>    
                
            </table>
        </td>
    </tr>
    <%}else if(rc_bean.getRent_st().equals("2") || rc_bean.getRent_st().equals("3") || rc_bean.getRent_st().equals("10")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>
        			<%if(mode.equals("u")){%>
        			���� <a href="javascript:cust_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
        			<%}else{%>
        			����
        			<%}%>
        			</td>
                    <td width=20%> 
                        &nbsp;<input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
                        <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=21%> 
                        &nbsp;<input type="text" name="c_cust_nm" value="<%=rc_bean2.getCust_nm()%>" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=29%> 
                        &nbsp;<input type="text" name="c_ssn" value="<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td colspan="3"> 
                        &nbsp;<input type="text" name="c_firm_nm" value="<%=rc_bean2.getFirm_nm()%>" size="50" class=whitetext>
                    </td>
                    <td class=title>����ڵ�Ϲ�ȣ</td>
                    <td> 
                        &nbsp;<input type="text" name="c_enp_no" value="<%=rc_bean2.getEnp_no()%>" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��󿬶�ó</td>
                    <td  colspan='7'> 
                        <input type="hidden" name="mgr_st2" value="2">
                        &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp;  
                        <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=<%=white%>text size="10">
                        &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> ����ó:&nbsp;
                        <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=<%=white%>text>
                        &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> ����:&nbsp;
                        <input type="text" name="m_etc2" value="<%=rm_bean2.getEtc()%>" size="38" class=<%=white%>text>
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
    <%}else if(rc_bean.getRent_st().equals("4") || rc_bean.getRent_st().equals("5")){%>
    <input type='hidden' name='c_firm_nm' value='(��)�Ƹ���ī'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
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
    <tr id=tr_gua style="display:<%if(rc_bean.getRent_st().equals("1")) {%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뺸����</span></td>
    </tr>
    <tr id=tr_gua1 style="display:<%if(rc_bean.getRent_st().equals("1")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td> 
                      &nbsp;<select name="gua_st" onchange="javascript:gua_display()" <%=disabled%>>
                        <option value="">==����==</option>
                        <option value="1" <%if(rf_bean.getGua_st().equals("1")){%>selected<%}%>>�Ժ�</option>
                        <option value="2" <%if(rf_bean.getGua_st().equals("2")){%>selected<%}%>>����</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_gua2 style="display:<%if(rc_bean.getRent_st().equals("1") && rf_bean.getGua_st().equals("1")) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td width=10%> 
                        &nbsp;<input type="hidden" name="mgr_st3" value="3">
                        <input type="text" name="mgr_nm3" value="<%=rm_bean3.getMgr_nm()%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=10%> 
                        &nbsp;<input type="text" name="m_ssn3" value="<%=AddUtil.ChangeEnpH(rm_bean3.getSsn())%>" size="14" class=<%=white%>text onBlur='javscript:this.value = ChangeSsn(this.value);'>
                    </td>
                    <td class=title width=11%>��ȭ��ȣ</td>
                    <td width=10%> 
                        &nbsp;<input type="text" name="m_tel3" value="<%=rm_bean3.getTel()%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title width=10%>����ڿ��� ����</td>
                    <td> 
                        &nbsp;<input type="text" name="m_etc3" value="<%=rm_bean3.getEtc()%>" size="9" class=<%=white%>text>
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
                    <td class=title>�ּ�</td>
                    <td colspan=7> 
					<input type="text" name='m_zip3' id="m_zip3" size="7" value="<%=rm_bean3.getZip()%>"  maxlength='7'>
					<input type="button" onclick="openDaumPostcode3()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='m_addr3' id="m_addr3" value="<%=rm_bean3.getAddr()%>" size="47">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_gua3 style="display:<%if(rc_bean.getRent_st().equals("1") && rf_bean.getGua_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td> 
                        &nbsp;<input type="text" name="gua_cau" value="<%=rf_bean.getGua_cau()%>" size="109" class=<%=white%>text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%if(rc_bean.getRent_st().equals("2")){
		//�����������
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());
		//�������
		Hashtable cont_view = a_db.getContViewCase("", rc_bean.getSub_l_cd());
		%>
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
                    <td class=title width="10%" style='height:38'>
        			<%if(mode.equals("u")){%>
        			�������� <a href="javascript:serv_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
        			<%}else{%>
        			��������
        			<%}%>
        			</td>
                    <td width="20%"> 
                        &nbsp;<input type="hidden" name="serv_id" value="<%=rc_bean.getServ_id()%>">
                        <input type="text" name="off_nm" value="<%=serv.get("OFF_NM")%>" size="25" class=whitetext>
                    </td>
                    <td class=title width="10%">����������ȣ</td>
                    <td width="21%"> 
                        &nbsp;<input type="text" name="car_no" value="<%=serv.get("CAR_NO")%>" size="15" class=whitetext>
                    </td>
                    <td class=title width="10%">����</td>
                    <td width="29%"> 
                        &nbsp;<input type="text" name="car_nm" value="<%=serv.get("CAR_NM")%>" size="20" class=whitetext>
                    </td>
                </tr>
                <tr>
                    <td class=title>���迬��</td>
                    <td>
                      &nbsp;<input type="text" name="d_car_ins_age" size="20" class=whitetext>
                        <input type="hidden" name="d_car_ins_age_cd" value=""></td>
                    <td class=title width="10%">�뿩���</td>
                    <td colspan='3'> 
                      &nbsp;<input type="text" name="rent_way_nm" value="<%=cont_view.get("RENT_WAY")%>" size="15" class=whitetext>
                      (<%=cont_view.get("RENT_START_DT")%>~)
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
	<%}else if(rc_bean.getRent_st().equals("3")){
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
                    <td class=title width=10%>
        			<%if(mode.equals("u")){%>
        			�������� <a href="javascript:accid_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
        			<%}else{%>
        			��������
        			<%}%>			
        			</td>
                    <td width=20%> 
                        &nbsp;<input type="hidden" name="accid_id" value="<%=rc_bean.getAccid_id()%>">
                        <input type="text" name="off_nm" value="<%=accid.get("OFF_NM")%>" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%>����������ȣ</td>
                    <td width=21%> 
                        &nbsp;<input type="text" name="car_no" value="<%=accid.get("CAR_NO")%>" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=29%>
                        &nbsp;<input type="text" name="car_nm" value="<%=accid.get("CAR_NM")%>" size="20" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title> ������ȣ</td>
                    <td> 
                      &nbsp;<input type="text" name="our_num" value="<%=accid.get("P_NUM")%>" size="25" class=whitetext>
                    </td>
                    <td class=title>�����ں����</td>
                    <td> 
                      &nbsp;<input type="text" name="ins_nm" value="<%=accid.get("G_INS")%>" size="15" class=whitetext>
                    </td>
                    <td class=title>�����</td>
                    <td>
                      &nbsp;<input type="text" name="ins_mng_nm" value="<%=accid.get("G_INS_NM")%>" size="20" class=whitetext>
                    </td>
                </tr>
                <tr>
                    <td class=title>���迬��</td>
                    <td colspan='5'>
                      &nbsp;<input type="text" name="d_car_ins_age" size="20" class=whitetext>
                        <input type="hidden" name="d_car_ins_age_cd" value=""></td>
                </tr>                  
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rc_bean.getRent_st().equals("9")){
		//�����������
		RentInsBean ri_bean = rs_db.getRentInsCase(s_cd);%>
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
                    <td> 
                      &nbsp;<input type="text" name="ins_num" value="<%=ri_bean.getIns_num()%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title>�����</td>
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
                    <td class=title width=10%> �����</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="ins_nm" value="<%=ri_bean.getIns_nm()%>" size="14" class=<%=white%>text maxlength="10" >
                    </td>
                    <td class=title width=10%>����ó��</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="ins_tel" value="<%=ri_bean.getIns_tel()%>" size="13" class=<%=white%>text maxlength="15" >
                    </td>
                    <td class=title width=11%>����ó��</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="ins_tel2" value="<%=ri_bean.getIns_tel2()%>" size="13" class=<%=white%>text maxlength="15" >
                    </td>
                    <td class=title width=10%>�ѽ�</td>
                    <td> 
                      &nbsp;<input type="text" name="ins_fax" value="<%=ri_bean.getIns_fax()%>" size="13" class=<%=white%>text maxlength="15" >
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>		
	<%}else if(rc_bean.getRent_st().equals("6")){
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
                    <td class=title width=10%>
        			<%if(mode.equals("u")){%>
        			�������� <a href="javascript:serv_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
        			<%}else{%>
        			��������
        			<%}%>			
        			</td>
                    <td width=41%> 
                      &nbsp;<input type="hidden" name="serv_id" value="<%=rc_bean.getServ_id()%>">
                      <input type="text" name="off_nm" value="<%=serv.get("OFF_NM")%>" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%> ��������</td>
                    <td width=39%>
                      &nbsp;<input type="text" name="serv_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%>" size="12" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr><td class=h></td></tr>	
	<%}else if(rc_bean.getRent_st().equals("7")){
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
                    <td width=90%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rc_bean.getRent_st().equals("8")){
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
                    <td class=title width=10% style='height:37'>
        			<%if(mode.equals("u")){%>
        			�������� <a href="javascript:accid_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
        			<%}else{%>
        			��������
        			<%}%>			
        			</td>
                    <td width=20%> 
                      &nbsp;<input type="hidden" name="accid_id" value="<%=rc_bean.getAccid_id()%>">
                      <input type="text" name="off_nm" value="<%=accid.get("OFF_NM")%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=21%> 
                      &nbsp;<input type="text" name="accid_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%>" size="15" class=<%=white%>text>
                    </td>
                    <td class=title width=10%>�����</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="accid_mng_nm" value="<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%>" size="20" class=<%=white%>text>
                    </td>
                </tr>
                <tr> 
                    <td class=title> �����</td>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	    <td align="right"><font color="#999999">
		<%if(!mode.equals("fine_doc")){%>
        		<%if(!rc_bean.getReg_id().equals("")){%>
        			<img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(rc_bean.getReg_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> : 
        			<%=AddUtil.ChangeDate2(rc_bean.getReg_dt())%>
        		<%}%>	  
        		<%if(!rc_bean.getUpdate_id().equals("")){%>
        			&nbsp;&nbsp;<img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(rc_bean.getUpdate_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> :
        			<%=AddUtil.ChangeDate2(rc_bean.getUpdate_dt())%>
        		<%}%>
		<%}%>
		<%if(!mode.equals("view")){%>
		&nbsp;&nbsp;&nbsp;<a href="javascript:tint_reg_link();"><img src="/acar/images/center/button_reg_p_ts.gif" align="absmiddle" border="0"></a>&nbsp;
		<%}%>
        </font></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>��౸��</td>
                   <%if(rc_bean.getRent_st().equals("10")){ %>
                    <td colspan="3"> 
                    <%}else{ %>
                    <td colspan="9"> 
                    <%} %>
                    &nbsp;<select name="rent_st" <%=disabled%>>
                        <option value="1"  <%if(rc_bean.getRent_st().equals("1"))%> selected<%%>>�ܱ�뿩</option>
                        <option value="2"  <%if(rc_bean.getRent_st().equals("2"))%> selected<%%>>�������</option>
                        <option value="3"  <%if(rc_bean.getRent_st().equals("3"))%> selected<%%>>������</option>
                        <option value="9"  <%if(rc_bean.getRent_st().equals("9"))%> selected<%%>>�������</option>
                        <option value="10" <%if(rc_bean.getRent_st().equals("10"))%>selected<%%>>��������</option>
                        <option value="4"  <%if(rc_bean.getRent_st().equals("4"))%> selected<%%>>�����뿩</option>        
                        <option value="6"  <%if(rc_bean.getRent_st().equals("6"))%> selected<%%>>��������</option>
                        <option value="8"  <%if(rc_bean.getRent_st().equals("8"))%> selected<%%>>������</option>
                        <option value="11" <%if(rc_bean.getRent_st().equals("11"))%>selected<%%>>�����</option>                        
                      </select>
                      <%if(rent_st.equals("10")){%>(<%=rc_bean.getSub_l_cd()%>)<%}%>
        
                    </td>
                    <%if(rc_bean.getRent_st().equals("10")){ %>
                    <td class=title  width=10%>��������������Ư��</td>
                    <td colspan="5"> 
                      &nbsp;<input type="text" name="s_cd" value="<%if(rc_bean.getCom_emp_yn().equals("Y")){%>����<%}else{%>�̰���<%} %>" size="10" class=whitetext readonly>
                    </td>
                    <%} %>
                </tr>		  				
                <tr> 
                    <td class=title width=10%>����ȣ</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="s_cd" value="<%=rc_bean.getRent_s_cd()%>" size="10" class=whitetext readonly>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=10%> 
                      &nbsp;<input type="text" name="rent_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%>" size="12" class=whitetext readonly onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>������</td>
                    <td width=10%><!--<input type='hidden' name='s_brch_id' value='<%=rc_bean.getBrch_id()%>'>-->
                      &nbsp;<select name='s_brch_id'>
                        <option value=''>��ü</option>
                        <%if(brch_size > 0){
        					for (int i = 0 ; i < brch_size ; i++){
        						Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%= branch.get("BR_ID") %>' <%if(rc_bean.getBrch_id().equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width=10% class=title>�����</td>
                    <td width=10%><input type='hidden' name='bus_id' value='<%=rc_bean.getBus_id()%>'> 
                      &nbsp;<select name='bus_id_sub' disabled>
                        <option value="">������</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width=10% class=title>���������</td>
                    <td width=10%><input type='hidden' name='mng_id' value='<%=rc_bean.getMng_id()%>'> 
                      &nbsp;
                      <%=c_db.getNameById(rc_bean.getMng_id(),"USER")%>
                      <%
                      		String sl_mng_dept_jang = nm_db.getWorkAuthUser("�����������");
                      		String sl_rm_mng_user 	= nm_db.getWorkAuthUser("�������Ʈ���");
                      %>                                            
                    </td>                    
                </tr>
				<%if(!mode.equals("fine_doc")){%>
                <tr> 
                    <td class=title>�����Ⱓ</td>
                    <td colspan="9"> 
                      &nbsp;<input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRent_start_dt_d())%>" size="12" class=<%=white%>text  onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'>
        			  <input type='hidden' name='rent_start_dt_h' value='<%=rc_bean.getRent_start_dt_h()%>'>
        			  <input type='hidden' name='rent_start_dt_s' value='<%=rc_bean.getRent_start_dt_s()%>'> 
                      <select name="rent_start_dt_h_sub" onChange="getRentTime(); setDtHS(this);" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_start_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="rent_start_dt_s_sub" onChange="getRentTime(); setDtHS(this);" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_start_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      ~ 
                      <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRent_end_dt_d())%>" size="12" class=<%=white%>text  onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'>
        			  <input type='hidden' name='rent_end_dt_h' value='<%=rc_bean.getRent_end_dt_h()%>'> 
        			  <input type='hidden' name='rent_end_dt_s' value='<%=rc_bean.getRent_end_dt_s()%>'> 
                      <select name="rent_end_dt_h_sub" onChange="getRentTime(); setDtHS(this);" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_end_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="rent_end_dt_s_sub" onChange="getRentTime(); setDtHS(this);" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_end_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      ( 
                      <input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="4" class=<%=white%>text >
                      �ð� 
                      <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="4" class=<%=white%>text >
                      ��
                      <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="4" class=<%=white%>text >
                      ���� ) 
                      </td>
                </tr>
				<%}%>
				
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
                    <td class=title>��Ÿ Ư�̻���</td>
                    <td colspan="9"> 
                      &nbsp;<textarea name="etc" cols="110" rows="3" class=default <%=readonly%>><%=rc_bean.getEtc()%></textarea>
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����/����</span></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>���������Ͻ�</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="deli_plan_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='hidden' name='deli_plan_dt_h' value='<%=rc_bean.getDeli_plan_dt_h()%>'>
        			  <input type='hidden' name='deli_plan_dt_s' value='<%=rc_bean.getDeli_plan_dt_s()%>'>
                      <select name="deli_plan_dt_h_sub" disabled>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="deli_plan_dt_s_sub" disabled>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>���������Ͻ�</td>
                    <td> 
                      &nbsp;<input type="text" name="ret_plan_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="ret_plan_dt_h" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="ret_plan_dt_s" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>�����Ͻ�</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="deli_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='hidden' name='deli_dt_h' value='<%=rc_bean.getDeli_dt_h()%>'>
        	      <input type='hidden' name='deli_dt_s' value='<%=rc_bean.getDeli_dt_s()%>'>
                      <select name="deli_dt_h_sub" disabled>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="deli_dt_s_sub" disabled>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title width=10%>���������</td>
                    <td width=21%> 
                      &nbsp;<select name='deli_mng_id' <%=disabled%>>
                        <option value="">������</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getDeli_mng_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td class=title width=10%>�����Ͻ�</td>
                    <td width=29%>
                      &nbsp;<input type="text" name="ret_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%>" size="12" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='hidden' name='ret_dt_h' value='<%=rc_bean.getRet_dt_h()%>'>
        	      <input type='hidden' name='ret_dt_s' value='<%=rc_bean.getRet_dt_s()%>'>
                      <select name="ret_dt_h_sub" disabled>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="ret_dt_s_sub" disabled>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>			
        			</td>
                </tr>
                <tr> 
                    <td class=title>������ġ</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="deli_loc" value="<%=rc_bean.getDeli_loc()%>" size="40" class=<%=white%>text readonly>
                    </td>
                    <td class=title>������ġ</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%if(rc_bean.getRent_st().equals("1") || rc_bean.getRent_st().equals("9")){%>
    <tr id=tr_fee style="display:''"> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span> 
          <%if(rc_bean.getRent_st().equals("1") || rc_bean.getRent_st().equals("9")){%><font color="red">�� ����뿩��� �뿩�Ⱓ ������ <b>�Ѵ뿩���</b>�Դϴ�.</font><%}%>
        </td>
    </tr>
    <tr id=tr_fee style="display:''"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>
                          
                <tr> 
                    <td class=title width=10%>���ݰ�꼭</td>
                    <td width=10%> 
                      &nbsp;<select name="tax_yn" <%=disabled%>>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getTax_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getTax_yn().equals("N")){%>selected<%}%>>�̹���</option>
                      </select>
                    </td>
                    <td class=title width=10%>���ú���</td>
                    <td width=31%> 
                      &nbsp;<select name="ins_yn" <%=disabled%>>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getIns_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getIns_yn().equals("N")){%>selected<%}%>>�̰���</option>
                      </select>
                      (��å�� : <input type='text' size='12' maxlength='7' name='car_ja' class='num' value='<%=AddUtil.parseDecimal(rf_bean.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			��)</td>
                    <td class=title width=10%>���������</td>
                    <td> 
                      &nbsp;<select name="my_accid_yn" <%=disabled%>>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getMy_accid_yn().equals("Y")){%>selected<%}%>>���δ�</option>
                        <option value="N" <%if(rf_bean.getMy_accid_yn().equals("N")){%>selected<%}%>>����</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�������</td>
                    <td> 
                      &nbsp;<select name="paid_way" onchange="javascript:paid_way_display();" <%=disabled%>><!-- -->
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
                	                &nbsp;<select name="paid_st" onchange="javascript:paid_display();" <%=disabled%>><!-- -->
                    	              <option value="">==����==</option>			  
                        	      <option value="1" <%if(rf_bean.getPaid_st().equals("1")){%>selected<%}%>>����</option>
                            	      <option value="2" <%if(rf_bean.getPaid_st().equals("2")){%>selected<%}%>>�ſ�ī��</option>
                            	      <option value="3" <%if(rf_bean.getPaid_st().equals("3")){%>selected<%}%>>�ڵ���ü</option>
                            	      <option value="4" <%if(rf_bean.getPaid_st().equals("4")){%>selected<%}%>>�������Ա�</option>					  
                	                </select>				  </td>				
            				    <td id=td_paid  style="display:<%if(rf_bean.getPaid_st().equals("2")){%>''<%}else{%>none<%}%>">(ī��NO. : 
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
                    <td class=title>������</td>
                    <td> 
                      &nbsp;<select name="oil_st" <%=disabled%>>
                        <option value="">==����==</option>			  
                        <option value="1" <%if(rf_bean.getOil_st().equals("1")){%>selected<%}%>>1ĭ</option>
                        <option value="2" <%if(rf_bean.getOil_st().equals("2")){%>selected<%}%>>2ĭ</option>
                        <option value="3" <%if(rf_bean.getOil_st().equals("3")){%>selected<%}%>>3ĭ</option>
                        <option value="f" <%if(rf_bean.getOil_st().equals("f")){%>selected<%}%>>full</option>
                      </select>
                    </td>   
                     <td class=title>�׺���̼�</td>
                    <td colspan="3"> 
                      &nbsp;<select name="navi_yn" >
                        <option value="">==����==</option>			  
                         <option value="Y" <%if(rf_bean.getNavi_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getNavi_yn().equals("N")){%>selected<%}%>>����</option>
                        </select>
                <% if  ( user_id.equals("000063")) {%>   <a href='javascript:search_navi()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><% } %>
                        &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> S / N:&nbsp; 
                      <input type='text' name='serial_no'  value="<%=rf_bean.getSerial_no()%>"  size='30' class='text'  readonly >               
                    </td>
                                                                     
                </tr>          
                <tr> 
                    <td class=title>��������Ÿ�</td>
                    <td> 
                      &nbsp;<input type="text" name="dist_km" value="<%=AddUtil.parseDecimal(rf_bean.getDist_km())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      km
                    </td>                        
                    <td class=title>Ź�ۿ�û</td>
                    <td > 
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
                <tr> 
                    <td class=title>�ڵ���ü</td>
                    <td  colspan='5'> 
                      &nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                      <select name='cms_bank'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        				for(int i = 0 ; i < bank_size ; i++){
        					CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(rf_bean.getCms_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        			}%>
                      </select>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> ���¹�ȣ:&nbsp; 
                      <input type='text' name='cms_acc_no' value='<%=rf_bean.getCms_acc_no()%>' size='20' class='text'>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ������:&nbsp; 
                      <input type='text' name='cms_dep_nm' value='<%=rf_bean.getCms_dep_nm()%>' size='20' class='text'>
                    </td>
                </tr>   
               
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr id=tr_fee1 style="display:<%if(rc_bean.getRent_st().equals("1") || rc_bean.getRent_st().equals("9")) {%>''<%}else{%>none<%}%>"> 
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
                  <td width="8%" class=title>�׺���̼�</td>
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
                      <input type="text" name="inv_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ΰ���</td>
                    <td align="center"> 
                      <input type="text" name="inv_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_v_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center"> 
                      <input type="text" name="inv_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getInv_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt()+rf_bean.getDc_v_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="ins_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="7" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                      <input type='hidden' name="m2_dc_amt" value="<%=rf_bean.getM2_dc_amt()%>">
                      <input type='hidden' name="m3_dc_amt" value="<%=rf_bean.getM3_dc_amt()%>">
                <tr> 
                    <td class=title>���ʰ����ݾ�</td>
                    <td align="center"> 
                      &nbsp;<input type="text" name="f_rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getF_rent_tot_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td class=title>���ʰ������</td>
                    <td colspan="8">&nbsp; 
                      <select name="f_paid_way" onchange="javascript:f_paid_way_display();" <%=disabled%>>
                        <option value="">==����==</option>			  
                        <option value="1" <%if(rf_bean.getF_paid_way().equals("1")){%>selected<%}%>>1����ġ</option>
                        <option value="2" <%if(rf_bean.getF_paid_way().equals("2")){%>selected<%}%>>�Ѿ�</option>
                      </select>
                      &nbsp; ������
                      <select name="f_paid_way2" onchange="javascript:f_paid_way_display();" <%=disabled%>>
                        <option value="">==����==</option>			  
                        <option value="1" <%if(rf_bean.getF_paid_way2().equals("1")){%>selected<%}%>>����</option>
                        <option value="2" <%if(rf_bean.getF_paid_way2().equals("2")){%>selected<%}%>>������</option>
                      </select>
                      </td>  
                </tr>
            </table>
        </td>
    </tr>    	
    <%}%>
    <%if(rc_bean.getRent_st().equals("2") && rf_bean.getRent_tot_amt() > 0){%>
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
                    <td class=title width=10%>��������</td>
                    <td width=40%> 
                      &nbsp;<select name="paid_st" <%=disabled%>>
                    	              <option value="">==����==</option>			  
                        	      <option value="1" <%if(rf_bean.getPaid_st().equals("1")){%>selected<%}%>>����</option>
                            	      <!--<option value="2" <%if(rf_bean.getPaid_st().equals("2")){%>selected<%}%>>�ſ�ī��</option>-->
                            	      <option value="3" <%if(rf_bean.getPaid_st().equals("3")){%>selected<%}%>>�ڵ���ü</option>
                            	      <option value="4" <%if(rf_bean.getPaid_st().equals("4")){%>selected<%}%>>�������Ա�</option>					  
                	                </select>
                    </td>                        
                    <td class=title width=10%>Ź�ۿ�û</td>
                    <td> 
                      &nbsp;<select name="cons_yn" <%=disabled%>>
                        <option value="">==����==</option>			  
                        <option value="Y" <%if(rf_bean.getCons_yn().equals("Y")){%>selected<%}%>>����</option>
                        <option value="N" <%if(rf_bean.getCons_yn().equals("N")){%>selected<%}%>>����</option>
                      </select>
                    </td>   
                </tr>   
                     
               <tr> 
                   <td class=title width=10%>Ư�̻���</td>
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
                    <td class=title>û������</td>
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
                      <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ΰ���</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr> 
                <!--
                <%if(white.equals("") && cont_size == 0){%>
                <tr> 
                    <td class=title>�����ٻ�������</td>
                    <td colspan='4'>&nbsp;<input type="checkbox" name="scd_reg_yn" value="Y"> ( üũ�ϸ� ������������, �Ѱ���ݾ� �հ�� �������� �����մϴ�.) 
                      </td>                      
                </tr>            
                <%}%>                           
                -->
            </table>
        </td>
    </tr>    
    <tr> 
        <td colspan='2'>�� �̿� ���� ��� ��� : 24�ð� �̳� �ݳ� - 1��ġ ��� ����, 24�ð� �̻� �̿�� - 12�ð� ������ �뿩��� ����</td>
    </tr>         
    <%}%>    
    <tr><td class=h></td></tr>	
    <tr id=tr_pre style="display:<%if(rf_bean.getPaid_way().equals("1") ) {%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������/������</span></td>
    </tr>
    <tr id=tr_pre1 style="display:<%if(rf_bean.getPaid_way().equals("1") ) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
                    <td class=line2 colspan=5 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>�Աݱ���</td>
                    <td class=title width=15%>���α���</td>
                    <td class=title width=10%>�Աݿ�����</td>
                    <td class=title width=10%>�Ա�����</td>
                    <td class=title width=15%>û���ݾ�</td>
                    <td class=title width=15%>�Աݱݾ�</td>
                    <td class=title width=10%>û���ܾ�</td>
                    <td class=title width=15%>-</td>
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st0" value="6">
                      <input type="hidden" name="tm0" value="<%=sr_bean0.getTm()%>">
        	      <input type="hidden" name="rent_s_amt0" value="<%=AddUtil.parseDecimal(sr_bean0.getRent_s_amt())%>">
        	      <input type="hidden" name="rent_v_amt0" value="<%=AddUtil.parseDecimal(sr_bean0.getRent_v_amt())%>">
        	      <input type="hidden" name="rest_amt0" value="<%=AddUtil.parseDecimal(sr_bean0.getRest_amt())%>">			  
                      ������</td>
                    <td align="center"> 
                      <select name="paid_st0" <%=disabled%>>
                        <option value="">==����==</option>			  			  
                        <option value="1" <%if(sr_bean0.getPaid_st().equals("1")){%>selected<%}%>>����</option>
                        <option value="2" <%if(sr_bean0.getPaid_st().equals("2")){%>selected<%}%>>�ſ�ī��</option>
                        <option value="3" <%if(sr_bean0.getPaid_st().equals("3")){%>selected<%}%>>�ڵ���ü</option>
                        <option value="4" <%if(sr_bean0.getPaid_st().equals("4")){%>selected<%}%>>�������Ա�</option>			
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
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="pay_amt0" value="<%=AddUtil.parseDecimal(sr_bean0.getPay_amt())%>" readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center" colspan="2">��������� ȯ���� ������</td>  
                </tr>                
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st1" value="1">
                      <input type="hidden" name="tm1" value="<%=sr_bean1.getTm()%>">
                        <input type="hidden" name="rent_s_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getRent_s_amt())%>">
        		     <input type="hidden" name="rent_v_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getRent_v_amt())%>">			  
                      �����</td>
                    <td align="center"> 
                      <select name="paid_st1" <%=disabled%>>
                        <option value="">==����==</option>
                        <option value="1" <%if(sr_bean1.getPaid_st().equals("1")){%>selected<%}%>>����</option>
                        <option value="2" <%if(sr_bean1.getPaid_st().equals("2")){%>selected<%}%>>�ſ�ī��</option>
                        <option value="3" <%if(sr_bean1.getPaid_st().equals("3")){%>selected<%}%>>�ڵ���ü</option>
                        <option value="4" <%if(sr_bean1.getPaid_st().equals("4")){%>selected<%}%>>�������Ա�</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>text name="est_dt1" value="<%=AddUtil.ChangeDate2(sr_bean1.getEst_dt())%>"  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>                    
                    <td align="center"> 
                      <input type='text' size='12' class=whitetext name="pay_dt1" value="<%=AddUtil.ChangeDate2(sr_bean1.getPay_dt())%>" readonly onBlur='javscript:this.value=ChangeDate(this.value);'>
                      <%if(sr_bean1.getPay_dt().equals("")) sr_bean1.setPay_amt(0);%>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rent_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getRent_s_amt()+sr_bean1.getRent_v_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="pay_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getPay_amt())%>" readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rest_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getRest_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">-</td>  
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st2" value="2">
                      <input type="hidden" name="tm2" value="<%=sr_bean2.getTm()%>">
                        <input type="hidden" name="rent_s_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getRent_s_amt())%>">
        		     <input type="hidden" name="rent_v_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getRent_v_amt())%>">
                      �����뿩��</td>
                    <td align="center"> 
                      <select name="paid_st2" <%=disabled%>>
                        <option value="">==����==</option>			  			  
                        <option value="1" <%if(sr_bean2.getPaid_st().equals("1")){%>selected<%}%>>����</option>
                        <option value="2" <%if(sr_bean2.getPaid_st().equals("2")){%>selected<%}%>>�ſ�ī��</option>
                        <option value="3" <%if(sr_bean2.getPaid_st().equals("3")){%>selected<%}%>>�ڵ���ü</option>
                        <option value="4" <%if(sr_bean2.getPaid_st().equals("4")){%>selected<%}%>>�������Ա�</option>		
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
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="pay_amt1" value="<%=AddUtil.parseDecimal(sr_bean2.getPay_amt())%>" readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                      
                    <td align="center"> 
                      <input type='text' size='12' class=<%=white%>num name="rest_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getRest_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">
                      
                    </td>                          
                </tr>
                <%
                	int scd_total_amt 	= sr_bean1.getRent_s_amt()+sr_bean1.getRent_v_amt()+sr_bean2.getRent_s_amt()+sr_bean2.getRent_v_amt();
    		  	int scd_pay_total_amt 	= sr_bean1.getPay_amt()+sr_bean2.getPay_amt();
                %>
                
                <%if(cont_size == 0){%>
                <tr> 
                    <td class=title colspan='4'>�հ�</td>
                    <td align="center"><input type="text" name="scd_total_amt" value="<%=Util.parseDecimal(scd_total_amt)%>" size="12" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">
                      <input type="text" name="scd_pay_total_amt" value="<%=Util.parseDecimal(scd_pay_total_amt)%>" size="12" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center" colspan='2'><%if(scd_total_amt-scd_pay_total_amt>0){%>�Ա����� : <font color=red><%=Util.parseDecimal(scd_total_amt-scd_pay_total_amt)%>��</font><%}%></td>                    
                </tr>                         
                <%}%>                
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_pay_nm style="display:<%if(cont_size > 0) {%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ݿ� ������</span></td>
    </tr>
    <tr id=tr_pay1 style="display:<%if(cont_size > 0) {%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
                    <td class=line2 colspan=5 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>�Աݱ���</td>
                    <td class=title width=15%>���α���</td>
                    <td class=title width=10%>�Աݿ�����</td>
                    <td class=title width=10%>�Ա�����</td>
                    <td class=title width=15%>û���ݾ�</td>
                    <td class=title width=15%>�Աݱݾ�</td>
                    <td class=title width=10%>-</td>
                    <td class=title width=15%>-</td>
                </tr>
    		  <%	
    			if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable sr = (Hashtable)conts.elementAt(i);
    					scd_total_amt 		= scd_total_amt 	+ AddUtil.parseInt(String.valueOf(sr.get("RENT_AMT")));
    					scd_pay_total_amt 	= scd_pay_total_amt 	+ AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));%>		  
                <tr> 
                    <td class=title> 
                      <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>
                      ���ຸ���� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>
                      �����뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>
                      �뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("5")){%>
                      ����뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>
                      ����� 
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
        			�������Ա�
        			<%}%>				
        			</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("EST_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%></td>
                    <td align="center"><input type="text" name="incom_rent_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("RENT_AMT")))%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                      <td align="center"><input type="text" name="incom_pay_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">
                        -
                    </td>  
                    <td align="center">
                        
                    </td>                            
                </tr>
    		  <%		
    		  		}
    		  	}%> 
    		<%if(cont_size > 0){%>  	  	
                <tr> 
                    <td class=title colspan='4'>������ �հ�(������/������ ����)</td>
                    <td align="center"><input type="text" name="scd_total_amt" value="<%=Util.parseDecimal(scd_total_amt)%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center"><input type="text" name="scd_pay_total_amt" value="<%=Util.parseDecimal(scd_pay_total_amt)%>" size="12" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>                                            
                    <td align="center" colspan='2'><%if(scd_total_amt-scd_pay_total_amt>0){%>�Ա����� : <font color=red><%=Util.parseDecimal(scd_total_amt-scd_pay_total_amt)%>��</font><%}%></td>                    
                </tr>   
                <%}%>   
                <%if(!cms.getCms_bank().equals("")){%>
                <tr> 
                    <td class=title>CMS��û</td>
                    <td colspan='7'>
                      <b><%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%></b>
        	      <%=cms.getCms_bank()%> <%=cms.getCms_acc_no()%> <%=cms.getCms_dep_nm()%>        	      
                    </td>
                </tr>                   
                <%}%>     		  				  
            </table>
        </td>
    </tr>    
    <tr><td class=h></td></tr>
    <tr> 
        <td width="20%"></td>
        <td align="right"> 
        <%if(!mode.equals("view")){%>
        	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>        
        		<a href='javascript:save();'><img src="/acar/images/center/<%if(mode.equals("u")){%>button_modify<%}else{%>button_modify_s<%}%>.gif"  align="absmiddle" border="0"></a>&nbsp;         
        	<%}%>
        <%}%>
    </tr>    
    <tr>
	<td colspan="2">* �Ա�ó���� �������� ������ �� �����ϴ�. �ѹ��� �Աݴ���ڿ��� �����ϼ���.</td>
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
                  <td width="5%" class=title>����</td>
                  <td width="15%" class=title>������ȣ</td>
                  <td width="15%" class=title>�޴�����ȣ</td>		  
                  <td width="10%" class=title>�ݾ�</td>
                  <td width="10%" class=title>ī������</td>
                  <td width="15%" class=title>ȸ������</td>
                  <td width="10%" class=title>����</td>
                  <td width="15%" class=title>��������</td>
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
                  <td align="center"><%=card.get("APP_TIME")%></td>		  
                  <td align="center"><%if(String.valueOf(card.get("TNO")).equals("")) {%>��� <%}else{%>���� <%}%></td>		                    
                </tr>      			
    <%		}%>
                                
            </table>
        </td>
    </tr>        
    <%	}%>
    
    <%if(!mode.equals("view")){%>
    						
    <tr><td class=h></td></tr>	
    <tr>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�⺻��ĵ����</span>
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
                <%if(rc_bean.getRent_st().equals("2") && rf_bean.getRent_tot_amt() > 0){%>
                                                
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
                                
                                
                <%if(rc_bean.getRent_st().equals("1") || rc_bean.getRent_st().equals("9")){//�ܱ�뿩,�������,����Ʈ%>
                
                <%	scan_num++;%>
                   
                <!-- �ڵ����뿩�̿��༭ -->
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�ڵ����뿩�̿��༭</td>
                    <td align="center">
                            (��) <a href='res_rent_p.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp; 		      
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

