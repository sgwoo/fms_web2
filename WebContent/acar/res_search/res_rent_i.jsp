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
	
	
	//�α���ID&������ID&����	
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
	
	
	//������ ����Ʈ ��ȸ
	Vector branches = c_db.getBranchList(); 
	int brch_size = branches.size();
	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();	
	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAll("0003"); 
	int bank_size = banks.length;

	
	//����� ����Ʈ
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	
	//������Ȳ
	Vector conts = rs_db.getResCarList(c_id);
	int cont_size = conts.size();
	
	
	int use_cnt = 0;
	int rent_cnt = 0;
	
	if(cont_size > 0){
  		for(int i = 0 ; i < cont_size ; i++){
    			Hashtable reservs = (Hashtable)conts.elementAt(i);
    			if(String.valueOf(reservs.get("USE_ST")).equals("����") || String.valueOf(reservs.get("USE_ST")).equals("����")){
				use_cnt ++;
				if(String.valueOf(reservs.get("USE_ST")).equals("����") && String.valueOf(reservs.get("RENT_ST")).equals("�����")){
					rent_cnt ++;
				}
			}
		}
	}
	
	
	//�ֱ� Ȩ������ ����뿩��
	Hashtable hp = oh_db.getSecondhandCase_20090901("", "", c_id);	
	

	//��������
	if(ins_st.equals("")) ins_st = ai_db.getInsSt(c_id);
	InsurBean ins = ai_db.getIns(c_id, ins_st);
	String ins_com_nm = ai_db.getInsComNm(c_id);
	
	
	//��������
	String est_id = "";
	EstimateBean e_bean = new EstimateBean();
			
	
	
	
	//��������
	Hashtable sb_ht = shDb.getShBase(c_id);
	
	String tot_dist 		= String.valueOf(sb_ht.get("TOT_DIST"));
	String today_dist 		= String.valueOf(sb_ht.get("TODAY_DIST"));
	String serv_dt	 		= String.valueOf(sb_ht.get("SERV_DT"));
	
	
	
	
	
	//Ź�۱���
	CodeBean[] codes2 = c_db.getCodeAll_0022("0022");
	int c_size2 = codes2.length;
	
	
	//��������
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
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	
	//�����ڵ� 
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//������ ����
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
	//�ܱ�뿩---------------------------------------------------------------------------------------------------------
	
	//�� ��ȸ
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
	
	//��������� ��ȸ
	function mngid_select(){
		var fm = document.form1;
		if(fm.c_cust_id.value == ''){
			alert('���� ���� �����Ͻʽÿ�.');
			return;
		}
		if(fm.mng_id.value != ''){
			if(!confirm('�ŷ�ó�� ���� ����ڰ� �ֽ��ϴ�. �ٸ� ������ ��ȸ�Ͻðڽ��ϱ�?')){	return;	}
		}
		window.open("search_mngid.jsp?c_id=<%=c_id%>&s_brch_id="+fm.s_brch_id.value, "MNGID_SEARCH", "left=50, top=0, width=420, height=700, resizable=yes, scrollbars=yes, status=yes");		
	}

	//�������� ��ȸ
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.c_cust_id.value == ''){
			alert('���� ���� �����Ͻʽÿ�.');
			return;
		}		
		//�ʱ�ȭ
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
	
	//���ڵ���ü���� ��ȸ
	function search_cms(){
		var fm = document.form1;
		if(fm.c_cust_id.value == ''){
			alert('���� ���� �����Ͻʽÿ�.');
			return;
		}		
		window.open("search_cms.jsp?client_id="+fm.c_cust_id.value, "SEARCH_CMS", "left=50, top=0, width=820, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	
	//�׺���̼�
	function search_navi(){
		var fm = document.form1;
		if(fm.c_cust_id.value == ''){
			alert('���� ���� �����Ͻʽÿ�.');
			return;
		}		
		window.open("search_navi.jsp?client_id="+fm.c_cust_id.value, "SEARCH_CMS", "left=50, top=0, width=820, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	
	//���뺸���� ���÷���
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
	
	//�뿩�ϼ� ���ϱ�
	function getRentTime() {
					
		var fm = document.form1;
				
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  		// 1�ð�
		lm = 60*1000;  	 	 	// 1��
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

	//�ú� ����	
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
		
	//����뿩�� �ڵ����
	function getFee_sam(){
		var fm = document.form1;
		fm.action = 'short_fee_nodisplay.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
	
	//1ȸ�������� �������� �Աݿ����� ����
	function set_est_dt(){	
		var fm = document.form1;		
		fm.target = "i_no";				
		fm.action = "get_scddt_nodisplay.jsp";
		fm.submit();								
	}
	
	//Ź�۱������ý� ������ ����
	function cons_yn_display(){
		var fm = document.form1;	
		if(fm.cmp_app.value != ''){
			fm.action = 'cmp_app_nodisplay.jsp';
			fm.target = 'i_no';
			fm.submit();			
		}
	}
	
	//�׺���̼��̿�� ����
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
	
	//�ݾ� ����	
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
		

		
		
		
		//�Ѱ���ݾ�											
		fm.rent_tot_s_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons2_s_amt.value)) );
		fm.rent_tot_v_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_v_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)) );
		fm.rent_tot_amt.value 	= parseDecimal(	toInt(parseDigit(fm.fee_amt.value))   + toInt(parseDigit(fm.cons1_amt.value))   + toInt(parseDigit(fm.cons2_amt.value))   );
				
		
	}			

	//�ݾ� ����	
	function pay_set_amt(){
	
		var fm = document.form1;
		
		
		
		fm.total_pay_amt.value = 0;
				
		fm.rest_amt1.value 	= parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value))) ;
		fm.rest_amt2.value 	= parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value)) - toInt(parseDigit(fm.pay_amt2.value))) ;
		
		fm.rent_s_amt0.value 	= fm.pay_amt0.value;
		fm.rent_v_amt0.value 	= 0;
		
		//�ѱݾװ� �������ѱݾ��� �´ٸ� ���������Ұ� ����
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
			fm.serv_id.value 	= "";
			fm.off_nm.value 	= "";
			if(fm.c_cust_id.value == '' && fm.rent_st.value == '2'){ alert('���� �����Ͻʽÿ�.');  return;}
			window.open("sub_select_2_s.jsp?c_id="+fm.sub_c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&go_url=/acar/res_search/res_rent_i.jsp", "SERV_SEARCH", "left=50, top=50, width=800, height=600, status=yes, scrollbars=yes");
	}	

	
	// ������ ------------------------------------------------------------------------------------------------
	
	//��� ��ȸ
	function accid_select(){
		var fm = document.form1;
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
			window.open("sub_select_3_a.jsp?auth_rw="+fm.auth_rw.value+"&c_id="+fm.sub_c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&user_id="+fm.user_id.value+"&go_url=/acar/res_search/res_rent_i.jsp", "ACCID_SEARCH", "left=50, top=50, width=830, height=600, status=yes, scrollbars=yes");
	}	


	// �뿩 �� �������� ------------------------------------------------------------------------------------------------
	
	//���� ��ȸ
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

	
	// �������� ------------------------------------------------------------------------------------------------
	
	//�������� ��ȸ
	function maint_select(){
		var fm = document.form1;
			fm.seq_no.value 	= "";
			fm.che_kd.value 	= "";
			fm.che_no.value		= "";
			fm.che_comp.value	= "";
			window.open("sub_select_5_m.jsp?c_id="+fm.c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value, "ACCID_SEARCH", "left=50, top=50, width=800, height=300, status=yes, scrollbars=yes");
	}	

	
	// ��Ÿ ------------------------------------------------------------------------------------------------
	

	//����������Ȳ ��ȸ
	function car_reserve(){
		var fm = document.form1;
		var SUBWIN="car_reserve.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserve", "left=50, top=50, width=820, height=500, scrollbars=yes");
	}

	//��������������Ȳ ��ȸ
	function car_reserve2(){
		var fm = document.form1;
		var SUBWIN="car_reserve_dk.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserveDK", "left=50, top=50, width=820, height=500, scrollbars=yes");
	}

	//�����ü ��ȸ
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
		
	//�����ϱ�
	function save(){
		var fm = document.form1;
		var rent_st = $("#rent_st").val();
		var ins_change_flag = $("#ins_change_flag").is(":checked");
		var ins_change_flag_input = "";
		
		// 21���� �ش�
		if(ins_change_flag) {
			ins_change_flag_input = "N"; // ������ ���� ���� X
		} else {
			ins_change_flag_input = "Y"; // ������ ���� ���� O
		}
		
		$("#ins_change_flag_input").val(ins_change_flag_input);
		
// 		alert($("#ins_change_flag_input").val());
		
		if(rent_st == "3" || rent_st == "2" || rent_st == "10"){
			if(fm.c_cust_id.value == '') { 
				alert('�� ����� ������ �����ϼ���.');
				return;
			} 
			var age1 = 0; // �뿩 ���� ���� ����
			var age2 = 0; // ��� ���� ���� ����
			var rent_start_dt = $("#rent_start_dt").val().replaceAll("-",""); // ���� �Ⱓ ������
			var rent_end_dt = $("#rent_end_dt").val().replaceAll("-",""); // ���� �Ⱓ ������
			var ins_change_std_dt = $("#ins_change_std_dt").val().replaceAll("-",""); // ���� ���� ������

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
					alert("���躯�� �������� �Է��ϼ���.");
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
				var week = new Array('�Ͽ���', '������', 'ȭ����', '������', '�����', '�ݿ���', '�����');
				var todayLabel = week[day];
				var hours = today.getHours();
				var today_yyyymmdd = year+month+date;
				
				if(parseInt(rent_start_dt) >= parseInt(rent_end_dt)) {
					alert("���� �Ⱓ �����ϰ� �������� Ȯ���ϼ���.");
					return;
				} 
				// 21�� ���� ������ ��쿡�� ���躯�� ��¥ üũ ����
				if(ins_change_flag_input == "Y") {
					// ���� 5�� ������ ���
					if(hours < 17) {
						if(parseInt(ins_change_std_dt) >= parseInt(rent_start_dt)) {
							alert("���� ���� �������� ���� �Ⱓ�� ������ ���� ������մϴ�.\nȮ�� �� �ٽ� �����ϼ���.");
							return;
						} else if(parseInt(ins_change_std_dt) < parseInt(today_yyyymmdd)) {
							alert("���� ���� �������� ���ú��� ���� �� �����ϴ�.\nȮ�� �� �ٽ� �����ϼ���.");
							return;
						}
					} 
					// ���� 5�� ������ ���
					else {
						if(parseInt(ins_change_std_dt) == parseInt(today_yyyymmdd)) {
							alert("���� 17�� ���Ĵ� ���� ���� �������� ���� ���� �������� ���Ϸ� ������ �� �����ϴ�.\n���� ��¥�� ����� �ʿ��� ��� ���� ����ڿ��� �����ϼ���.");
							return;
						} else if(parseInt(ins_change_std_dt) >= parseInt(rent_start_dt)) {
							alert("���� ���� �������� ���� �Ⱓ�� ������ ���� ������մϴ�.\nȮ�� �� �ٽ� �����ϼ���.");
							return;
						} else if(parseInt(ins_change_std_dt) < parseInt(today_yyyymmdd)) {
							alert("���� ���� �������� ���ú��� ���� �� �����ϴ�.\nȮ�� �� �ٽ� �����ϼ���.");
							return;
						}   
					}
				}
			}
		}
		
		if(toInt(fm.rent_cnt.value) > 0){
			if(!confirm('�縮�� ���Ȯ���Ǿ� ������ ����Ǿ� �ִ� �����Դϴ�.\n\n����Ͻðڽ��ϱ�?')){	return;	}
		}else{
			if(toInt(fm.use_cnt.value) > 0){
				if(!confirm('���� ���� Ȥ�� �������� �����Դϴ�.\n\n����Ͻðڽ��ϱ�?')){	return;	}
			}
		}
				
		if(fm.c_id.value == '')		{ alert('���������� �߸��Ǿ����ϴ�\n\n��Ͽ��� �����Ͻʽÿ�'); 		return; }
		if(fm.rent_st.value == '')	{ alert('��౸���� �߸��Ǿ����ϴ�\n\n������������ �����Ͻʽÿ�'); 	return; }		
		
		
		if(fm.rent_st.value == '1' || fm.rent_st.value == '9' || fm.rent_st.value == '12'){		
		
			if(fm.c_cust_id.value == '')		{ alert('���� �����Ͻʽÿ�'); return; }
			if(fm.c_cust_id.value == '000228')	{ alert('�Ƹ���ī�δ� �Է��� �� �����ϴ�. ���� �����Ͻʽÿ�'); return; }			
			if(fm.rent_end_dt.value == '')		{ alert('�뿩�������� �Է��Ͻʽÿ�'); return; }			
			
			if(fm.rent_st.value == '1' || fm.rent_st.value == '9'){	
				if(toInt(fm.rent_months.value) == 0 && toInt(fm.rent_days.value) == 0 && toInt(fm.rent_hour.value) == 0){ 
					alert('�����Ⱓ�� Ȯ���Ͻʽÿ�.'); return;
				}
				if(fm.rent_st.value != '12' && toInt(fm.rent_months.value) == 1 && (toInt(fm.rent_days.value) > 0 || toInt(fm.rent_hour.value) > 0)){ 
					alert('1���� �̻��� ��������� �Է����ֽʽÿ�.'); return;
				}
			}
			if(fm.fee_s_amt.value == '0' || fm.fee_s_amt.value == ''){ alert('����뿩�Ḧ �Է��Ͻʽÿ�.'); return; }			
			
		
		}else if(fm.rent_st.value == '2'){
			if(fm.c_cust_id.value == ''){ alert('���� �����Ͻʽÿ�'); return; }
			if(fm.age_scp.value != fm.d_car_ins_age_cd.value){ 
				if(!confirm('���������� ���������� ���迬���� �ٸ��ϴ�. ����Ͻðڽ��ϱ�?')){	return;	}
			}	
		
		}else if(fm.rent_st.value == '3'){
			if(fm.c_cust_id.value == ''){ alert('���� �����Ͻʽÿ�'); return; }
			if(fm.age_scp.value != fm.d_car_ins_age_cd.value){ 
				if(!confirm('��������� ���������� ���迬���� �ٸ��ϴ�. ����Ͻðڽ��ϱ�?')){	return;	}
			}	

		}else if(fm.rent_st.value == '4' || fm.rent_st.value == '5'){
			if(fm.c_cust_nm.value == ''){ alert('����ڸ� �����Ͻʽÿ�'); return; }

		}else if(fm.rent_st.value == '10'){//��������
			if(fm.c_cust_id.value == '')		{ alert('���� �����Ͻʽÿ�'); return; }
			if(fm.c_cust_id.value == '000228')	{ alert('�Ƹ���ī�δ� �Է��� �� �����ϴ�. ���� �����Ͻʽÿ�'); return; }
			if(fm.age_scp.value != fm.d_car_ins_age_cd.value){ 
				if(!confirm('���������� ���������� ���迬���� �ٸ��ϴ�. ����Ͻðڽ��ϱ�?')){	return;	}
			}	
		}
		
		if(fm.rent_dt.value == '')	{ alert('������ڸ� �Է��Ͻʽÿ�'); 		fm.rent_dt.focus(); 		return; }
		if(fm.s_brch_id.value == '')	{ alert('�����Ҹ� �Է��Ͻʽÿ�'); 		fm.brch_id.focus(); 		return; }
		if(fm.bus_id.value == '')	{ alert('����ڸ� �Է��Ͻʽÿ�'); 		fm.bus_id.focus(); 		return; }
		if(fm.rent_start_dt.value == ''){ alert('�̿�Ⱓ �����Ͻø� �Է��Ͻʽÿ�'); 	fm.rent_start_dt.focus(); 	return; }
		if(fm.deli_plan_dt.value == '')	{ alert('���������Ͻø� �Է��Ͻʽÿ�'); 	fm.deli_plan_dt.focus(); 	return; }
		
		
		if(!max_length(fm.deli_loc.value,40)){	alert('������ġ ���̴� '+get_length(fm.deli_loc.value)+'��(��������) �Դϴ�.\n\n������ �ѱ�20��/����40�ڱ��� �Է��� �����մϴ�.'); return; } 
		if(!max_length(fm.ret_loc.value,40)) {	alert('������ġ ���̴� '+get_length(fm.ret_loc.value)+'��(��������) �Դϴ�.\n\n������ �ѱ�20��/����40�ڱ��� �Է��� �����մϴ�.'); return; } 		
		
		//���������ȣ �ڸ���üũ �� formating ���� �߰�(2018.02.07)
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
					
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
		
		if(fm.rent_start_dt.value != '')
			fm.h_rent_start_dt.value = fm.rent_start_dt.value+fm.rent_start_dt_h.value+fm.rent_start_dt_s.value;
		if(fm.rent_end_dt.value != '')
			fm.h_rent_end_dt.value = fm.rent_end_dt.value+fm.rent_end_dt_h.value+fm.rent_end_dt_s.value;
		if(fm.deli_plan_dt.value != '')
			fm.h_deli_plan_dt.value = fm.deli_plan_dt.value+fm.deli_plan_dt_h.value+fm.deli_plan_dt_s.value;
		if(fm.ret_plan_dt.value != '')
			fm.h_ret_plan_dt.value = fm.ret_plan_dt.value+fm.ret_plan_dt_h.value+fm.ret_plan_dt_s.value;
		if(fm.deli_dt.value != ''){
			if(fm.deli_dt_h.value == ''){ alert('���� �ð��� �����Ͻʽÿ�'); return; }
			if(fm.deli_dt_s.value == ''){ alert('���� ���� �����Ͻʽÿ�'); return; }			
			if(fm.deli_loc.value == ''){ alert('������ġ�� �Է��Ͻʽÿ�'); return; }						
			if(fm.deli_mng_id.value == ''){ alert('��������ڸ� �����Ͻʽÿ�'); return; }
			fm.h_deli_dt.value = fm.deli_dt.value+fm.deli_dt_h.value+fm.deli_dt_s.value;			
		}
			
		fm.action = 'res_rent_i_a.jsp';
//		fm.target = 'd_content';
		fm.target='i_no';
		fm.submit();
	}
	
	//����Ʈ ����
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
	
	//�������� ����
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=c_id%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=reserv.get("RENT_MNG_ID")%>&rent_l_cd=<%=reserv.get("RENT_L_CD")%>&car_mng_id=<%=c_id%>&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}		
	
	//�������� ����
	function view_car_nm(){
		window.open("/acar/car_mst/car_mst_u.jsp?car_id=<%=reserv.get("CAR_ID")%>&car_seq=<%=reserv.get("CAR_SEQ")%>", "VIEW_CAR_NM", "left=20, top=20, width=875, height=650, scrollbars=yes");		
	}
	
	//����Ʈ�϶� �������ý� �ڵ����� 20120424
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
             ,buttonText: "����"           
             ,yearSuffix: "��" 
             ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12']
             ,monthNames: ['1��','2��','3��','4��','5��','6��','7��','8��','9��','10��','11��','12��']
             ,dayNamesMin: ['��','��','ȭ','��','��','��','��'] 
             ,dayNames: ['�Ͽ���','������','ȭ����','������','�����','�ݿ���','�����'] 
             ,minDate: "-0D" //(-1D:�Ϸ�, -1M:�� ��, -1Y:�� ��)
	         ,beforeShowDay: function(date){
	             show = true;
	             if(date.getDay() == 0 || date.getDay() == 6){show = false;} // �ָ� ����
	             for (var i = 0; i < hdaysArray.length; i++) {
	                 if (new Date(hdaysArray[i]).toString() == date.toString()) {show = false;} // ������ ����
	                 
	             }
	             var display = [show,'',(show)?'':'�ָ� �� ������ ���� �Ұ�'];
	             return display;
	         }
         });                    
         
         $('#ins_change_std_dt').datepicker('setDate', 'today'); // ���� ��¥ ���� �� ���� ��¥ ����
         $(".ui-datepicker-trigger").css("margin-left","3px"); // Ķ���� �̹��� ��ġ ����
         $(".ui-datepicker-trigger").css("margin-bottom","-3px"); // Ķ���� �̹��� ��ġ ����
         
	 });
	 
	 $(document).ready(function(){
		    $("#ins_change_flag").change(function(){
		        if($("#ins_change_flag").is(":checked")){
		            alert("���迬�� 21�� ��, ���� ���� 21���� ���� ���� ������ üũ �ϼ̽��ϴ�.\n���� ���� ���� ��û�� �� �Ǹ� ���� ������ ���� ��� �߻� �� �ڵ��� ����ó���� ��å ó���Ǹ� ��� ����� �Ǵ� ���� ���� ���� ������ ������ ���� �����ڰ� �������� å���ִ� ������ �� ���ظ� ����� å���� ���ϴ�.");
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > �������� > ������� > <span class=style5>������ ( 
                    <%if(rent_st.equals("1")){%>
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
                �����
                
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
        <td width="30%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� (<%=c_id%>)</span></td>
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
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=reserv.get("CAR_NO")%></a></td>
                    <td class=title>����</td>
                    <td align="left" colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=reserv.get("CAR_NAME")%></a> (<%=reserv.get("SECTION")%>)&nbsp;</td>
                    <td class=title>�����ȣ</td>
                    <td colspan=3>&nbsp;<%=reserv.get("CAR_NUM")%></td>
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
                    <td colspan="9">&nbsp;<%=reserv.get("OPT")%></td>                                        
                </tr>
				<tr> 
                    <td class=title width=10%>�˻���ȿ�Ⱓ</td>
                    <td width=23% colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%></td>
                    <td class=title>���ɸ�����</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("CAR_END_DT")))%></td>
                    <td class=title>������ȿ�Ⱓ</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_END_DT")))%></td>
                </tr>                
                <!--��������-->
                <tr> 
                    <td class=title>����ȸ��</td>
                    <td >&nbsp;<a href="javascript:view_ins()"><%=ins_com_nm%></a>
        			<%if(ins.getVins_spe().equals("�ִ�ī")){%>(�ִ�ī)<%}%>
        			</td>
                  <td class=title>�Ǻ�����</td>
                  <td>&nbsp;<%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%><%=ins.getCon_f_nm()%><%}else{%><b><font color='#990000'><%=ins.getCon_f_nm()%></font></b><%}%></td>
                  <td class=title>���迬��</td>
                  <td>&nbsp;
                    	<%if(ins.getAge_scp().equals("1")){%>21���̻�<%}%>
                        <%if(ins.getAge_scp().equals("4")){%>24���̻�<%}%>
                        <%if(ins.getAge_scp().equals("2")){%>26���̻�<%}%>
                        <%if(ins.getAge_scp().equals("3")){%>������<%}%>
                        <%if(ins.getAge_scp().equals("5")){%>30���̻�<%}%>
                        <%if(ins.getAge_scp().equals("6")){%>35���̻�<%}%>
                        <%if(ins.getAge_scp().equals("7")){%>43���̻�<%}%>
						<%if(ins.getAge_scp().equals("8")){%>48���̻�<%}%>
						<%if(ins.getAge_scp().equals("9")){%>22���̻�<%}%>
						<%if(ins.getAge_scp().equals("10")){%>28���̻�<%}%>
						<%if(ins.getAge_scp().equals("11")){%>35���̻�~49������<%}%>
			<input type="hidden" name="age_scp" value="<%=ins.getAge_scp()%>" id="age_scp_1">
                  </td>   
                    <td class=title>��������Ÿ�</td>
                    <td colspan="3">&nbsp;&nbsp;<%=AddUtil.parseDecimal(today_dist)%>km&nbsp;(�����Է�:<%=AddUtil.parseDecimal(tot_dist)%>km, <%=AddUtil.ChangeDate2(serv_dt)%>)
   	    	      &nbsp;&nbsp;
		      <span class="b"><a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="���񳻿�����"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>  	
                    </td>                         			
                </tr>                
                <%if(!rent_st.equals("1") && !rent_st.equals("9")){%>
                <tr> 
                    <td class=title>�Ϲݴ���</td>
                    <td colspan="9">&nbsp;���뿩�� : <%=Util.parseDecimal(String.valueOf(reserv.get("FEE_S_AMT")))%>��, 1�ϴ뿩�� : <%=Util.parseDecimal(String.valueOf(reserv.get("DAY_S_AMT")))%>�� (���ް�)</td>
                </tr>				
                <%}%>		
    		  
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("11")){%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
        <td align="right">
                .<img src=/acar/images/center/arrow.gif> <%=reserv.get("CAR_NO")%> �뿩����Ʈ <a href="javascript:car_reserve();"><img src="/acar/images/center/button_see.gif" align="absmiddle" border="0"></a>
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
                    <td class=title>���� </td>
                    <td> 
                      &nbsp;<select name='cust_st'>
                        <option value='1' selected>��</option>
                        <option value='4'>����</option>						
                      </select>
					  &nbsp;<a href="javascript:cust_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
					  <!--
					  <input type='hidden' name='cust_st' value=''>
                      <input type="text" name="c_cust_st" value="" size="15" class=whitetext>
					  -->					  
                    </td>
                    <td class=title>����</td>
                    <td> 
                      &nbsp;<input type="text" name="c_cust_nm" value="" size="18" class=whitetext>
                    </td>
                    <td class=title>�������/���ι�ȣ</td>
                    <td colspan=3> 
                      &nbsp;<input type="text" name="c_ssn" value="" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="c_firm_nm" value="" size="60" class=whitetext>
                    </td>
                    <td class=title>����ڵ�Ϲ�ȣ</td>
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
                    <td class=title>�ּ�</td>
                    <td colspan="7"> 
					<input type="text" name='c_zip' id="c_zip" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='c_addr' id="c_addr" size="100">
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>���������ȣ</td>
                    <td width=17%>&nbsp;
                      <a href='javascript:search_mgr(4)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
                      &nbsp;<input type="text" name="c_lic_no" value="" size="16" class=text onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                    </td>
                    <td class=title width=10%>��������</td>
                    <td width=14%> 
                      &nbsp;<select name='c_lic_st'>
                        <option value=''>����</option>
                        <option value='1'>2������</option>
                        <option value='2'>1������</option>
                        <option value='3'>1������</option>
                      </select>                      
                    </td>
                    <td class=title width=10%>��ȭ��ȣ</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="c_tel" value="" class=text size="15">
                    </td>
                    <td class=title width=10%>�޴���</td>
                    <td width=14%> 
                      &nbsp;<input type="text" name="c_m_tel" value="" size="15" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��󿬶�ó</td>
                    <td  colspan='7'>&nbsp; 
                      <a href='javascript:search_mgr(2)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
                      &nbsp;<img src=/acar/images/center/arrow.gif><input type="hidden" name="mgr_st2" value="2">
                      ����:&nbsp; 
                      <input type="text" name="mgr_nm2" value="" class=text size="9">
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> ����ó:&nbsp; 
                      <input type="text" name="m_tel2" value="" size="13" class=text>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                      <input type="text" name="m_etc2" value="" size="62" class=text>
                    </td>
                </tr>
                
                <tr> 
                    <td class=title rowspan="4">�ǿ�����<br>(�뿪��� ��)</td>
                    <td  colspan='7'>                                             
                      <input type="checkbox" name="cust_sam_chk" value="N" onclick="javascript:mgr1_set();">
                      ���� ���� ����                      
                    </td>
                </tr>
                <tr> 
                    <td  colspan='7'>&nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                      <input type="hidden" name="mgr_st1" value="1">
                      <input type="text" name="mgr_nm1" value="" class=text size="10">
                      &nbsp; <img src=/acar/images/center/arrow.gif> �������:&nbsp; 
                      <input type="text" name="m_ssn1" value="" size="15" class=tex tmaxlength='8' >
                      &nbsp; <img src=/acar/images/center/arrow.gif> ���������ȣ:&nbsp; 
                      <input type="text" name="m_lic_no1" value="" size="16" class=text>
                      &nbsp; <img src=/acar/images/center/arrow.gif> ��������:&nbsp; 
                      <select name='m_lic_st1'>
                        <option value=''>����</option>
                        <option value='1'>2������</option>
                        <option value='2'>1������</option>
                        <option value='3'>1������</option>
                      </select>  
                      &nbsp; <img src=/acar/images/center/arrow.gif> ��ȭ��ȣ:&nbsp; 
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
                    <td  colspan='7'>&nbsp;<img src=/acar/images/center/arrow.gif> �ּ�:&nbsp; 
					<input type="text" name='m_zip1' id="m_zip2" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='m_addr1' id="m_addr2" size="100">
					
                    </td>
                </tr>
                <tr> 
                    <td  colspan='7'>&nbsp;<img src=/acar/images/center/arrow.gif> ��Ÿ:&nbsp;                       
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
                    <td class=title width=10%>���� </td>
                    <td width=21%> 
                      &nbsp;
					  <select name='cust_st'>
                        <option value='1'>��</option>
                      </select>
					  &nbsp;<a href="javascript:cust_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
					  <!--
					  <input type='hidden' name='cust_st' value=''>
                      <input type="text" name="c_cust_st" value="" size="15" class=whitetext>
					  -->
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="c_cust_nm" value="" size="30" class=whitetext>
                    </td>
                    <td class=title width=10%>�������/���ι�ȣ</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="c_ssn" value="" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="c_firm_nm" value="" size="80" class=whitetext>
                    </td>
                    <td class=title>����ڵ�Ϲ�ȣ</td>
                    <td> 
                      &nbsp;<input type="text" name="c_enp_no" value="" size="15" class=whitetext>
                    </td>
                </tr>
        	    <%if(!rent_st.equals("11")){%>
                <tr> 
                    <td class=title>��󿬶�ó</td>
                    <td  colspan='5'> 
                      <input type="hidden" name="mgr_st2" value="2">
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                      <input type="text" name="mgr_nm2" value="" class=text size="10">
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> ����ó:&nbsp; 
                      <input type="text" name="m_tel2" value="" size="15" class=text>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                      <input type="text" name="m_etc2" value="" size="58" class=text>
                    </td>
                </tr>
    		    <%}%>
    		    <%if(rent_st.equals("10")){%>
                <tr>
                    <td class=title>���迬��</td>
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
    <input type='hidden' name='c_firm_nm' value='(��)�Ƹ���ī'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td width=15%> 
                      &nbsp;
					  <select name='cust_st'>
                        <option value='4'>����</option>
                      </select>
					  <!--					  
					  <input type='hidden' name='cust_st' value='4'>
                      <input type="text" name="c_cust_st" value="����" size="15" class=whitetext>
					  -->
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=16%> 
                      &nbsp;<select name='c_cust_nm' onChange='javascript:user_select()'>
                        <option value="">==����==</option>			  
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                    <td class=title width=10%>�����Ҹ�</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="c_brch_nm" value="" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>�μ���</td>
                    <td width=14%> 
                      &nbsp;<input type="text" name="c_dept_nm" value="" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���������ȣ</td>
                    <td> 
                      &nbsp;<input type="text" name="c_lic_no" value="" size="16" class=whitetext onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                    </td>
                    <td class=title>��������</td>
                    <td> 
                      &nbsp;<input type="text" name="c_lic_st" value="" size="15" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title>��ȭ��ȣ</td>
                    <td> 
                      &nbsp;<input type="text" name="c_tel" value="" class=whitetext size="15">
                    </td>
                    <td class=title>�޴���</td>
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
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뺸����</span></td>
    </tr>
    <tr id=tr_gua1 style="display:<%if(rent_st.equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=2 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td> 
                      &nbsp;<select name="gua_st" onchange="javascript:gua_display()">
                        <option value="">==����==</option>
                        <option value="1">�Ժ�</option>
                        <option value="2">����</option>
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
                    <td class=title width=10%>����</td>
                    <td width=15%> 
                      &nbsp;<input type="hidden" name="mgr_st3" value="3">
                      <input type="text" name="mgr_nm3" value="" size="15" class=text>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=16%> 
                      &nbsp;<input type="text" name="m_ssn3" value="" size="14" maxlength='8' class=text onBlur='javscript:this.value = ChangeSsn(this.value);'>
                    </td>
                    <td class=title width=10%>��ȭ��ȣ</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="m_tel3" value="" size="15" class=text>
                    </td>
                    <td class=title width=10%>����ڿ��� ����</td>
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
                    <td class=title>�ּ�</td>
                    <td colspan=7> 
					<input type="text" name='m_zip3' id="m_zip3" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode3()" value="�����ȣ ã��"><br>
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
                    <td class=title width=10%>��������</td>
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
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="10%" style='height:38'>�������� <a href="javascript:serv_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a></td>
                    <td width="21%"> 
                      &nbsp;<input type="hidden" name="serv_id" value="">
                      <input type="text" name="off_nm" value="" size="25" class=whitetext>
                    </td>
                    <td class=title width="10%">����������ȣ</td>
                    <td width="20%"> 
                      &nbsp;<input type="text" name="car_no" value="" size="15" class=whitetext>
                    </td>
                    <td class=title width="10%">����</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="car_nm" size="20" class=whitetext>
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
	<%}else if(rent_st.equals("3")){%>	
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
                    <td class=title width=10% style='height:37'>�������� <a href="javascript:accid_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a></td>
                    <td width=21%> 
                      &nbsp;<input type="hidden" name="accid_id" value="">
                      <input type="text" name="off_nm" value="" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%>����������ȣ</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="car_no" value="" size="15" class=whitetext>
                    </td>
                    <td class=title width=10%>����</td>
                    <td width=29%>
                      &nbsp;<input type="text" name="car_nm" value="" size="20" class=whitetext>
                    </td>
                </tr>
                  <tr> 
                    <td class=title width=10%>�˻���ȿ�Ⱓ</td>
                    <td width=23% colspan="1">&nbsp;
                    	<input type="text" id="serv_maint_st_dt" name="serv_maint_st_dt"  size="8" class=whitetext>~&nbsp;
                    	<input type="text" id="serv_maint_end_dt" name="serv_maint_end_dt"  size="8"  class=whitetext>
                    </td>
                    <td class=title>���ɸ�����</td>
                    <td>&nbsp;
                    	<input type="text" id="serv_car_end_dt" name="serv_car_end_dt"  size="8" class=whitetext>
                    </td>
                    <td class=title>������ȿ�Ⱓ</td>
                    <td colspan="1">&nbsp;
                    	<input type="text" id="serv_test_st_dt" name="serv_test_st_dt"  size="8" class=whitetext>~&nbsp;
                    	<input type="text" id="serv_test_end_dt" name="serv_test_end_dt"  size="8" class=whitetext>
                    </td>
                </tr>       
                <tr> 
                    <td class=title> ������ȣ</td>
                    <td> 
                      &nbsp;<input type="text" name="our_num" value="" size="25" class=whitetext>
                    </td>
                    <td class=title>�����ں����</td>
                    <td> 
                      &nbsp;<input type="text" name="ins_nm" value="" size="15" class=whitetext>
                    </td>
                    <td class=title>�����</td>
                    <td>
                      &nbsp;<input type="text" name="ins_mng_nm" value="" size="20" class=whitetext>
                    </td>
                </tr>
                <tr>
                    <td class=title>���迬��</td>
                    <td colspan='5'>
                      &nbsp;<input type="text" name="d_car_ins_age" size="20" class=whitetext  >
                        <input type="hidden" name="d_car_ins_age_cd" value="" id="age_scp_2"></td>
                </tr>                
            </table>
        </td>
    </tr>
	<%}else if(rent_st.equals("9")){%>	
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
                      &nbsp;<input type="text" name="ins_num" value="" size="15" class=text>
                    </td>
                    <td class=title>�����</td>
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
                    <td class=title width=10%>�����</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="ins_nm" size="14" class=text maxlength="10" >
                    </td>
                    <td class=title width=10%>����ó��</td>
                    <td width=16%> 
                      &nbsp;<input type="text" name="ins_tel" size="13" class=text maxlength="15" >
                    </td>
                    <td class=title width=10%>����ó��</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="ins_tel2" size="13" class=text maxlength="15" >
                    </td>
                    <td class=title width=10%>�ѽ�</td>
                    <td width=14%> 
                      &nbsp;<input type="text" name="ins_fax" size="13" class=text maxlength="15" >
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}else if(rent_st.equals("6")){%>		
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
                    <td class=title width=10% style='height:37'>�������� <a href="javascript:serv_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a></td>
                    <td width=41%> 
                      &nbsp;<input type="hidden" name="serv_id" value="">
                      <input type="text" name="off_nm" value="" size="25" class=whitetext>
                    </td>
                    <td class=title width=10%> ��������</td>
                    <td width=39%>
                      &nbsp;<input type="text" name="serv_dt" value="" size="12" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>		
	<%}else if(rent_st.equals("7")){%>				
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
	<%}else if(rent_st.equals("8")){%>		
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
                    <td class=title width=10% style='height:37'>�������� <a href="javascript:accid_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a></td>
                    <td width=21%> 
                      &nbsp;<input type="hidden" name="accid_id" value="">
                      <input type="text" name="off_nm" value="" size="30" class=text>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="accid_dt" value="" size="15" class=text>
                    </td>
                    <td class=title width=10%>�����</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="accid_mng_nm" value="" size="20" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title> �����</td>
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
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title width=10%>����ȣ</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="rent_s_cd" value="" size="10" class=whitetext>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=16%> 
                      &nbsp;<input type="text" name="rent_dt" value="<%=AddUtil.getDate()%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>������</td>
                    <td width=15%> 
                    
                      &nbsp;<select name='s_brch_id'>
                        <option value=''>��ü</option>
                        <%if(brch_size > 0){
        					for (int i = 0 ; i < brch_size ; i++){
        						Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%= branch.get("BR_ID") %>' <%if(br_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width=10% class=title>�����</td>
                    <td width=14%> 
                      &nbsp;<select name='bus_id'>
                        <option value="">������</option>
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
                	if(client_st =='����' && parseInt(<%=ej_bean.getSh_code()%>)>1999999 && parseInt(<%=ej_bean.getSh_code()%>)<7000000){
	                		$('#com_emp_yn_td').show();
	                }else if(client_st =='����' && parseInt(<%=ej_bean.getSh_code()%>)>1999 && parseInt(<%=ej_bean.getSh_code()%>)<7000){
	                		$('#com_emp_yn_td').show();
	                }else{
	                	$('#com_emp_yn_td').hide();
	                }
                }
               	
                </script>
                 
              <tr id="com_emp_yn_td" style="display:none;">
                <td class=title>��������������Ư��</td>
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
							<option value="Y" id="com_emp_y"<%if(com_emp_yn.equals("Y")){%> selected <%}%>>����</option>
							<option value="N" id="com_emp_n" <%if(com_emp_yn.equals("N")){%> selected <%}%>>�̰���</option>
						</select>
						 &nbsp;&nbsp;��  ���ǻ��� :
                     	 <input type="text" name="m_etc2" value="�������(�� ���)�� ���� ������ ��������������Ư�� �����̸� ��������, �̰����̸� �̰������� ����" size="120" class=text  readonly="readonly" style="font-weight:bold;border:none;">
						
                    </td>  
                </tr>
                <tr> 
                    <td class=title>�����Ⱓ</td>
                    <td colspan="7"> 
                      &nbsp;<input type="text" name="rent_start_dt" id="rent_start_dt" value="<%=AddUtil.ChangeDate2(rent_start_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'>
                      <select name="rent_start_dt_h" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<=24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="rent_start_dt_s" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      ~ 
                      <input type="text" name="rent_end_dt" id="rent_end_dt" value="<%=AddUtil.ChangeDate2(rent_end_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'>
                      <select name="rent_end_dt_h" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<=24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%//if(i == 24) out.println("selected");%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="rent_end_dt_s" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      
                      ( 
                      <input type="text" name="rent_hour" value="0" size="4" class=text>
                      �ð� 
                      <input type="text" name="rent_days" value="<%=rent_days%>" size="4" class=text>
                      ��
                      <input type="text" name="rent_months" value="<%=rent_months%>" size="4" class=text>
                      ���� )
                      
                    </td>         
                </tr>
                <tr> 
                    <td class=title>���� ���� ������</td>
                    <td colspan="7"> 
                      &nbsp;<input type="text" name="ins_change_std_dt" id="ins_change_std_dt" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();' readonly>
					  <input type="checkbox" id="ins_change_flag" name="ins_change_flag" style="margin-left:90px;"><span>���� ���� ����</span>&nbsp;&nbsp;<span style="color: red;font-weight: bold;">* ����� ������ 21�������� ���� �����ڰ� 21���� �ƴҰ�� üũ</span> 
					  <input type="hidden" id="ins_change_flag_input" name="ins_change_flag_input"/> 
                </tr>
                <tr> 
                    <td class=title>���������</td>
                    <td colspan="7"> 
                      &nbsp;<input type='hidden' name='mng_nm' value=''>
                      <input type="radio" name="mng_st" value="1" <%if(!user_bean.getLoan_st().equals("1")){%>checked<%}%>>
                      ���������� 
                      <input type="radio" name="mng_st" value="2" <%if(user_bean.getLoan_st().equals("1")){%>checked<%}%>>
                      �����ں���                       
                    </td>
                </tr>		                
                <tr> 
                    <td class=title>��Ÿ Ư�̻���</td>
                    <td colspan="7"> 
                      &nbsp;<textarea name="etc" cols="110" rows="3" class=default></textarea>
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
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>���������Ͻ�</td>
                    <td width=41%> 
                      &nbsp;<input type="text" name="deli_plan_dt" value="<%=AddUtil.ChangeDate2(rent_start_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="deli_plan_dt_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="deli_plan_dt_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title width=10%>������ġ</td>
                    <td width=39%> 
                     &nbsp;<input type="text" name="deli_loc" value="" size="60" class=text>
                    </td>
                </tr>
    		    <input type='hidden' name="deli_dt">
    		    <input type='hidden' name="deli_dt_h">
    		    <input type='hidden' name="deli_dt_s">
    		    <input type='hidden' name="deli_mng_id">
                <tr> 
                    <td class=title>���������Ͻ�</td>
                    <td> 
                      &nbsp;<input type="text" name="ret_plan_dt" value="<%=AddUtil.ChangeDate2(rent_end_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="ret_plan_dt_h">
                        <%for(int i=0; i<=24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%//if(i == 24) out.println("selected");%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="ret_plan_dt_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>������ġ</td>
                    <td> 
                      &nbsp;<input type="text" name="ret_loc" value="" size="60" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_fee style="display:<%if(rent_st.equals("1") || rent_st.equals("9")){%>''<%}else{%>none<%}%>"> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span>
            <%if(rent_st.equals("1") || rent_st.equals("9")){%>&nbsp;&nbsp;<font color="red">�� ����뿩��� �뿩�Ⱓ ������ <b>�Ѵ뿩���</b>�Դϴ�.</font><%}%>
        </td>
    </tr>
    <tr id=tr_fee style="display:<%if(rent_st.equals("1") || rent_st.equals("9") ){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>���ݰ�꼭</td>
                    <td width=15%> 
                      &nbsp;<select name="tax_yn">
                        <option value="">==����==</option>			  
                        <option value="Y">����</option>
                        <option value="N">�̹���</option>
                      </select>
                    </td>
                    <td class=title width=10%>���ú���</td>
                    <td width=30%> 
                      &nbsp;<select name="ins_yn">
                        <option value="">==����==</option>			  
                        <option value="Y">����</option>
                        <option value="N">�̰���</option>
                      </select>
                      (��å�� : <input type='text' size='12' maxlength='7' name='car_ja' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			��)</td>
                    <td class=title width=10%>���������</td>
                    <td> 
                      &nbsp;<select name="my_accid_yn">
                        <option value="">==����==</option>			  
                        <option value="Y">���δ�</option>
                        <option value="N">����</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�������</td>
                    <td> 
                      &nbsp;<select name="paid_way" onchange="javascript:paid_way_display();">
                        <option value="">==����==</option>			  
                        <option value="1">����</option>
                        <option value="2">�ĺ�</option>
                      </select>
                    </td>
                    <td class=title>��������</td>
                    <td >
        			    <table border="0" width="100%">
                            		<tr>
            				    <td>
                	                	<select name="paid_st" onchange="javascript:paid_display();">
                    	              		<option value="">==����==</option>			  
                        	          	<option value="1">����</option>
                            	      		<option value="2">�ſ�ī��</option>
                            	      		<option value="3">�ڵ���ü</option>
                            	      		<option value="4">�������Ա�</option>
                	                	</select>				  
                	                    </td>				
            				    <td id=td_paid style='display:none'>
            				      <!--
            				      ( ī��NO. : 
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
                        <option value="">==����==</option>			  
                        <option value="Y">����</option>
                        <option value="N">>����</option>
                      </select>
                    </td>  
                </tr>
                <tr> 
                    <td class=title>������</td>
                    <td> 
                      &nbsp;<select name="oil_st">
                        <option value="">==����==</option>			  
                        <option value="1">1ĭ</option>
                        <option value="2">2ĭ</option>
                        <option value="3">3ĭ</option>
                        <option value="f">full</option>
                      </select>
                    </td>   
                    <td class=title>�׺���̼�</td>
                    <td colspan="3"> 
                      &nbsp;<select name="navi_yn" onchange="javascript:navi_yn_display();">
                        <option value="">==����==</option>			  
                        <option value="Y">����</option>
                        <option value="N">����</option>
                        </select>
                        <font color=red>* �����忡�� �׺���̼� ��� �ݵ�� Ȯ���ϼ���. </font>
             
                    </td>
                   
                </tr>          
                <tr> 
                   <td class=title width=10%>��������Ÿ�</td>
                    <td> 
                      <input type="text" name="dist_km" value="<%=AddUtil.parseDecimal(today_dist)%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      km
                    </td>                                     
                                
                    <td class=title>Ź�ۿ�û</td>
                    <td colspan='3'> 
                      &nbsp;<select name="cons_yn">
                        <option value="">==����==</option>			  
                        <option value="Y">����</option>
                        <option value="N">����</option>
                      </select>
                      &nbsp; Ź�۱��� : 
                      <select name="cmp_app" onchange="javascript:cons_yn_display();">
        			    <option value="">����</option>
        				<%for(int i = 0 ; i < c_size2 ; i++){
        					CodeBean code22 = codes2[i];	%>
        				<option value='<%=code22.getNm_cd()%>'><%= code22.getNm()%></option>
        				<%}%>
          			  </select>
                    </td>                
                </tr>    
               <tr> 
                   <td class=title width=10%>Ư�̻���</td>
                    <td colspan='5'>&nbsp;
                      <textarea name="fee_etc" cols="110" rows="3" class=default></textarea>                      
                    </td>                                           
                </tr>  
                <tr> 
                    <td class=title>�ڵ���ü</td>
                    <td  colspan='5'>&nbsp; 
                      <a href='javascript:search_cms()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
                      &nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                      <select name='cms_bank'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        				for(int i = 0 ; i < bank_size ; i++){
        					CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>'><%=bank.getNm()%></option>
                        <%		}
        			}%>
                      </select>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> ���¹�ȣ:&nbsp; 
                      <input type='text' name='cms_acc_no' value='' size='20' class='text'>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ������:&nbsp; 
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
                    <td rowspan="2" class=title>����</td>
                    <td colspan="6" class=title>���뿩��&nbsp;&nbsp;<!--�ܱ�뿩/�������/����Ʈ  �ڵ����--><a href="javascript:getFee_sam();"><img src=/acar/images/center/button_in_jdgs.gif align=absmiddle border=0></a></td>
                    <td width="11%" class=title>�뿩���Ѿ�</td>
                    <td width="8%" rowspan="2" class=title>������</td>
                    <td width="8%" rowspan="2" class=title>������</td>
                    <td width="11%" rowspan="2" class=title>�Ѱ���ݾ�</td>
                </tr>
                <tr>
                  <td width="10%" class=title>����뿩��</td>
                  <td width="8%" class=title>D/C</td>
                  <td width="8%" class=title>�׺���̼�</td>
                  <td width="8%" class=title>��Ÿ</td>                  
                  <td width="8%" class=title>���ú����</td>                  
                  <td width="10%" class=title>�հ�</td>                  
                  <td class=title>
                  	<input type="text" name="v_rent_months" value="<%=rent_months%>" size="1" class=whitenum>
                      	����
                      	<input type="text" name="v_rent_days" value="<%=rent_days%>" size="2" class=whitenum>
                      	��
                  </td>                  
                </tr>
                <tr>                     
                    <td class=title width="10%">���ް�</td>
                    <td align="center"> 
                      <input type="text" name="inv_s_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_s_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_s_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_s_amt" value="" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_s_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_s_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">
                      <input type="text" name="cons1_s_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
  		      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ΰ���</td>
                    <td align="center"> 
                      <input type="text" name="inv_v_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_v_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_v_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_v_amt" value="" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_v_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">
                      <input type="text" name="cons1_v_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>                      
                </tr>
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center"> 
                      <input type="text" name="inv_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="dc_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="navi_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="etc_amt" value="" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="ins_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="t_fee_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">
                      <input type="text" name="cons1_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>                      
                </tr>
                <input type='hidden' name="m2_dc_amt" value="">
                <input type='hidden' name="m3_dc_amt" value="">
                <!--      
                <tr> 
                    <td class=title>�Ѱ����ݾ�</td>
                    <td align="center"> 
                      &nbsp;<input type="text" name="rent_tot_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
                      </td>
                    <td colspan="9"> 
                      &nbsp;
                      2ȸ���뿩�� ���αݾ� <input type="text" name="m2_dc_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      �� / 
                      3ȸ���뿩�� ���αݾ� <input type="text" name="m3_dc_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
                    </td>  
                </tr>
                -->
                <tr> 
                    <td class=title>���ʰ����ݾ�</td>
                    <td align="center"> 
                      &nbsp;<input type="text" name="f_rent_tot_amt" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td class=title>���ʰ������</td>
                    <td colspan="8">&nbsp; 
                      <select name="f_paid_way" onchange="javascript:f_paid_way_display();">
                        <option value="">==����==</option>			  
                        <option value="1">1����ġ</option>
                        <option value="2">�Ѿ�</option>
                      </select>
                      &nbsp; ������
                      <select name="f_paid_way2" onchange="javascript:f_paid_way_display();">
                        <option value="">==����==</option>
                        <option value="1">����</option>
                        <option value="2">������</option>
                      </select>
                      </td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr id=tr_pre style='display:none'>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������/������ ������</span></td>
    </tr>
    <tr id=tr_pre1 style='display:none'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title width=20%>�׸�</td>
                    <td class=title width=20%>�Աݹ��</td>
                    <td class=title width=20%>�Աݿ�����</td>
                    <td class=title width=20%>û���ݾ�</td>                    
                    <td class=title width=20%>�ܾ�</td>
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st0" value="6">
        	      <input type="hidden" name="rent_s_amt0" value="0">
        	      <input type="hidden" name="rent_v_amt0" value="0">
        	      <input type="hidden" name="rest_amt0" value="0">
                      ������</td>
                    <td align="center"> 
                      <select name="paid_st0">
                        <option value="">==����==</option>			  			  
                        <option value="1" selected>����</option>
                        <!--<option value="2">�ſ�ī��</option>-->
                        <!--<option value="3">�ڵ���ü</option>-->
                        <option value="4">�������Ա�</option>			
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=text name="pay_dt0" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=num name="pay_amt0" value="" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      ��</td>
                    <td align="center"> 
                      ��������� ȯ���� ������
                    </td>
                </tr>                
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st1" value="1">
        	      <input type="hidden" name="rent_s_amt1" value="0">
        	      <input type="hidden" name="rent_v_amt1" value="0">
                      �����</td>
                    <td align="center"> 
                      <select name="paid_st1">
                        <option value="">==����==</option>			  			  
                        <option value="1">����</option>
                        <!--<option value="2">�ſ�ī��</option>-->
                        <!--<option value="3">�ڵ���ü</option>-->
                        <option value="4">�������Ա�</option>			
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=text name="pay_dt1" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=num name="pay_amt1" value="" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="rest_amt1" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st2" value="2">
        	      <input type="hidden" name="rent_s_amt2" value="0">
        	      <input type="hidden" name="rent_v_amt2" value="0">
                      �����뿩��</td>
                    <td align="center"> 
                      <select name="paid_st2">
                        <option value="">==����==</option>			  			  
                        <option value="1">����</option>
                        <option value="2">�ſ�ī��</option>
                        <option value="3">�ڵ���ü</option>
                        <option value="4">�������Ա�</option>			
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=text name="pay_dt2" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=num name="pay_amt2" value="" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="rest_amt2" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>                
                <%for(int i=3; i<7; i++){ %>
                <tr> 
                    <td class=title> 
                      <input type="hidden" name="rent_st<%=i%>" value="3">
        	      <input type="hidden" name="rent_s_amt<%=i%>" value="0">
        	      <input type="hidden" name="rent_v_amt<%=i%>" value="0">
                      �뿩��</td>
                    <td align="center"> 
                      <select name="paid_st<%=i%>">
                        <option value="">==����==</option>			  			  
                        <option value="1" selected>����</option>
                        <option value="2">�ſ�ī��</option>
                        <option value="3">�ڵ���ü</option>
                        <option value="4">�������Ա�</option>			
                      </select>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=text name="pay_dt<%=i%>" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='12' class=num name="pay_amt<%=i%>" value="" onBlur='javascript:this.value=parseDecimal(this.value); pay_set_amt();'>
                      ��</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="rest_amt<%=i%>" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>                               
                <%}%>
                <tr> 
                    <td class=title colspan='3'>�հ�</td>
                    <td align="center"> 
                      <input type='text' size='12' class=whitenum name="total_pay_amt" value="">
                      ��</td>
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
	  <td colspan="2">* ���������� ���ؼ� ���������Ͻ÷� ���� 24�ð��� ����Ǵ� �������� ������¶�� �ڵ���ҵǴ� ������ �����Ͻʽÿ�.</td>
	</tr>
	<%if(rent_cnt>0){%>
	<tr>
	  <td colspan="2"><font color='red'><b>* �縮�� ���Ȯ���Ǿ� ������ ����Ǿ� �ִ� �����Դϴ�.</b></font></td>
	</tr>
	<%}else{%>
	<%	if(use_cnt>0){%>
	<tr>
	  <td colspan="2"><font color='red'><b>* ���� ���� Ȥ�� �������� �����Դϴ�.</b></font></td>
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

