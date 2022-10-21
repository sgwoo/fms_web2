<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.insur.*, acar.estimate_mng.*, acar.secondhand.*, acar.offls_pre.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="shDb" scope="page" class="acar.secondhand.SecondhandDatabase"/>
<jsp:useBean id="oh_db" scope="session" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	CommonDataBase 	c_db 	= CommonDataBase.getInstance();
	LoginBean 	login 	= LoginBean.getInstance();
	InsDatabase 	ai_db 	= InsDatabase.getInstance();	
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
			
	//����������������
	est_id = shDb.getSearchEstIdShRes(c_id);
	
	if(!est_id.equals("")){
		e_bean = e_db.getEstimateShCase(est_id);		
	}
	
	
	
	//��������
	Hashtable sb_ht = shDb.getShBase(c_id);
	
	String tot_dist 		= String.valueOf(sb_ht.get("TOT_DIST"));
	String today_dist 		= String.valueOf(sb_ht.get("TODAY_DIST"));
	String serv_dt	 		= String.valueOf(sb_ht.get("SERV_DT"));
	
	
	//���������� ���� ��� -> ��������
	if(est_id.equals("")){
		//�縮�� ���
		String  d_flag1 =  e_db.call_sp_esti_reg_sh_res(c_id);
		
		hp = oh_db.getSecondhandCase_20090901("", "", c_id);	
				
		sb_ht = shDb.getShBase(c_id);
				
		tot_dist 		= String.valueOf(sb_ht.get("TOT_DIST"));
		today_dist 		= String.valueOf(sb_ht.get("TODAY_DIST"));
		serv_dt	 		= String.valueOf(sb_ht.get("SERV_DT"));
		
		//����������������
		est_id = shDb.getSearchEstIdShRes(c_id);
	
		if(!est_id.equals("")){
			e_bean = e_db.getEstimateShCase(est_id);		
		}
	}
	
	
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
	
	//������ ����
	Vector hdays = c_db.getHolidayList();
	int hdaysSize = hdays.size();
	String[] hdaysArray = new String[hdaysSize];
	for (int i = 0 ; i < hdaysSize ; i++){
		Hashtable hday = (Hashtable)hdays.elementAt(i);
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
			window.open("client_s_p.jsp?auth_rw="+fm.auth_rw.value+"&br_id="+fm.br_id.value+"&user_id="+fm.user_id.value+"&rent_st="+fm.rent_st.value+"&cust_st="+fm.cust_st.value+"&rent_st=<%=rent_st%>&from_page="+fm.from_page.value+"&rent_start_dt="+fm.rent_start_dt.value, "CLIENT_SEARCH", "left=50, top=50, width=1020, height=700, resizable=yes, scrollbars=yes, status=yes");
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
				
			d1 = replaceString('-','',fm.rent_start_dt.value)+fm.rent_start_dt_h.value+fm.rent_start_dt_s.value;
			d2 = replaceString('-','',fm.rent_end_dt.value)+fm.rent_end_dt_h.value+fm.rent_end_dt_s.value;		
	
			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
					
			t3 = t2 - t1;
			
			fm.rent_months.value 	= parseInt(t3/m);
			fm.rent_days.value 	= parseInt((t3%m)/l);
			fm.rent_hour.value 	= parseInt(((t3%m)%l)/lh);			
				
			fm.deli_plan_dt.value = fm.rent_start_dt.value;
			fm.ret_plan_dt.value = fm.rent_end_dt.value;	
			
			getFee_sam();				
				
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}
	
	//�뿩�ϼ� ���ϱ�
	function getRentTimeChk(st, dt1, dt2) {
		var fm = document.form1;	
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
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
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
		fm.action = 'short_fee_nodisplay2.jsp';
		fm.target = 'i_no';
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

	

	// ������� ------------------------------------------------------------------------------------------------
	
	//���� ��ȸ
	function serv_select(){
		var fm = document.form1;
			fm.serv_id.value 	= "";
			fm.off_nm.value 	= "";
			if(fm.c_cust_id.value == '' && fm.rent_st.value == '2'){ alert('���� �����Ͻʽÿ�.');  return;}
			window.open("sub_select_2_s.jsp?c_id="+fm.sub_c_id.value+"&car_no="+fm.c_car_no.value+"&rent_st="+fm.rent_st.value+"&auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&go_url=/acar/res_search/res_rent_i.jsp", "SERV_SEARCH", "left=50, top=50, width=800, height=600, status=yes, scrollbars=yes");
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
		
		
		if(rent_st == "3" || rent_st == "2" || rent_st == "10"){
			if(fm.c_cust_id.value == '') { 
				alert('�� ����� ������ �����ϼ���.');
				return;
			} 
			var age1 = 0; // �뿩 ���� ���� ����
			var age2 = 0; // ��� ���� ���� ����
			var rent_start_dt = $("#rent_start_dt").val().replaceAll("-",""); // ���� �Ⱓ ������
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
			
			if((rent_st == "3" && (age1 > age2)) || (rent_st == "10" && (age1 > age2)) || (rent_st == "2" && (age1 > age2)) ) {
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
							alert("���� �ټ��� ���Ĵ� ���� ���� �������� ������ �� �� �����ϴ�.\nȮ�� �� �ٽ� �����ϼ���.");
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
				
		if(fm.c_id.value == '')			{ alert('���������� �߸��Ǿ����ϴ�\n\n��Ͽ��� �����Ͻʽÿ�'); 		return; }
		if(fm.rent_st.value == '')		{ alert('��౸���� �߸��Ǿ����ϴ�\n\n������������ �����Ͻʽÿ�'); 	return; }		
		
		
		if(fm.c_cust_id.value == '')		{ alert('���� �����Ͻʽÿ�'); 					return; }
		if(fm.c_cust_id.value == '000228')	{ alert('�Ƹ���ī�δ� �Է��� �� �����ϴ�. ���� �����Ͻʽÿ�'); 	return; }			
		if(fm.rent_end_dt.value == '')		{ alert('�뿩�������� �Է��Ͻʽÿ�'); 					return; }			

		//�������
		if(fm.car_st.value !='5' && fm.rent_way.value =='3' && fm.twomon_yn.value =='Y'){
		
			var con_mon = getRentTimeChk('m', fm.sub_rent_start_dt.value, fm.rent_start_dt.value);
						
			//��������������� �뿩������ 2������������ Ȯ��
			if(con_mon >1){
				if((fm.fee_s_amt.value == '0' || fm.fee_s_amt.value == '') && fm.fee_etc.value == ''){ alert('�뿩�Ḧ �Է��ϰų� Ư�̻��׿� ��û�������� �Է��Ͻʽÿ�.'); 	return; }							
			}
									
			//�Ѱ���ݾ�											
			fm.rent_tot_s_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons2_s_amt.value)) );
			fm.rent_tot_v_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_v_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)) );
			fm.rent_tot_amt.value 	= parseDecimal(	toInt(parseDigit(fm.fee_amt.value))   + toInt(parseDigit(fm.cons1_amt.value))   + toInt(parseDigit(fm.cons2_amt.value))   );
						
			//��������� �����븸 �����ϴ�.
			if(toInt(parseDigit(fm.rent_tot_amt.value))>0 && '<%=reserv.get("CAR_USE")%>'=='2'){
				alert('�⺻�� ���� ��������� �ڰ��������� �ȵ˴ϴ�.'); 	return;
			}
			
			if(toInt(parseDigit(fm.rent_tot_amt.value))>0){
				if(fm.paid_st.value == '')	{ alert('���������� �����Ͻʽÿ�.');  		fm.paid_st.focus(); 		return; }			
			}
			
		}
		
		if(fm.age_scp.value != fm.d_car_ins_age_cd.value){ 
			if(!confirm('���������� ���������� ���迬���� �ٸ��ϴ�. ����Ͻðڽ��ϱ�?')){	return;	}
		}	
		
		
		if(fm.rent_dt.value == '')	{ alert('������ڸ� �Է��Ͻʽÿ�'); 		fm.rent_dt.focus(); 		return; }
		if(fm.s_brch_id.value == '')	{ alert('�����Ҹ� �Է��Ͻʽÿ�'); 		fm.brch_id.focus(); 		return; }
		if(fm.bus_id.value == '')	{ alert('����ڸ� �Է��Ͻʽÿ�'); 		fm.bus_id.focus(); 		return; }
		if(fm.rent_start_dt.value == ''){ alert('�̿�Ⱓ �����Ͻø� �Է��Ͻʽÿ�'); 	fm.rent_start_dt.focus(); 	return; }
		if(fm.deli_plan_dt.value == '')	{ alert('���������Ͻø� �Է��Ͻʽÿ�'); 	fm.deli_plan_dt.focus(); 	return; }

		
		
		if(!max_length(fm.deli_loc.value,40)){	alert('������ġ ���̴� '+get_length(fm.deli_loc.value)+'��(��������) �Դϴ�.\n\n������ �ѱ�20��/����40�ڱ��� �Է��� �����մϴ�.'); return; } 
		if(!max_length(fm.ret_loc.value,40)) {	alert('������ġ ���̴� '+get_length(fm.ret_loc.value)+'��(��������) �Դϴ�.\n\n������ �ѱ�20��/����40�ڱ��� �Է��� �����մϴ�.'); return; } 		
		
					
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
	
      function checkClient_st(client_st){
      	
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
 <input type='hidden' name='rent_st' value='<%=rent_st%>' id="rent_st">
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
 <input type='hidden' name='rm1' value='<%=reserv.get("FEE_S_AMT")%>'> 
 <input type='hidden' name='est_s_amt' value='<%=reserv.get("FEE_S_AMT")%>'> 
 <input type='hidden' name='est_v_amt' value='0'> 
 <input type='hidden' name='est_id' value='<%=est_id%>'>
 <input type='hidden' name='from_page' value='/acar/res_search/res_rent_i2.jsp'>
 <input type='hidden' name='site_id' value=''>
 <input type='hidden' name='mng_id' value=''>
 <input type='hidden' name='car_st' value=''>
 <input type='hidden' name='rent_way' value=''>
 <input type='hidden' name='twomon_yn' value=''>
 <input type='hidden' name='sub_rent_start_dt' value=''>
 <input type='hidden' name='day_s_amt' value='<%=reserv.get("DAY_S_AMT")%>'>
 
 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > �������� > ������� > <span class=style5>������ ( ������� )</span></span></td>
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
                <tr> 
                    <td class=title>�Ϲݴ���</td>
                    <td colspan="9">&nbsp;���뿩�� : <%=Util.parseDecimal(String.valueOf(reserv.get("FEE_S_AMT")))%>��, 1�ϴ뿩�� : <%=Util.parseDecimal(String.valueOf(reserv.get("DAY_S_AMT")))%>�� (���ް�)</td>
                </tr>				
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
            </table>
        </td>
    </tr>	
    <input type='hidden' name='c_zip' value=''>				
    <input type='hidden' name='c_addr' value=''>	
    <input type='hidden' name='c_lic_no' value=''>				
    <input type='hidden' name='c_lic_st' value=''>	
    <input type='hidden' name='c_tel' value=''>				
    <input type='hidden' name='c_m_tel' value=''>		
	<tr>
	    <td class=h></td>
	</tr>
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
                    <td class=title>���迬��</td>
                    <td>
                      &nbsp;<input type="text" name="d_car_ins_age" size="20" class=whitetext>
                        <input type="hidden" name="d_car_ins_age_cd" value="" id="age_scp_2"></td>
                    <td class=title width="10%">�뿩���</td>
                    <td colspan='3'> 
                      &nbsp;<input type="text" name="rent_way_nm" value="" size="30" class=whitetext>
                    </td>
                </tr>
                    
            </table>
        </td>
    </tr>	

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
                <tr> 
                    <td class=title>�����Ⱓ</td>
                    <td colspan="7"> 
                      &nbsp;<input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(rent_start_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();' id ="rent_start_dt">
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
                      <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(rent_end_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'>
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
                      &nbsp;<input type="text" name="ins_change_std_dt" id="ins_change_std_dt" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();' id="ins_change_std_dt" readonly>
                	<input type="checkbox" id="ins_change_flag" name="ins_change_flag" style="margin-left:90px;"><span>���� ���� ����</span>&nbsp;&nbsp;<span style="color: red;font-weight: bold;">*21�� ���� ���� ��� ������(26��)�� 21�� �������� ���� ��û���� ���� ��� üũ</span>
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
                <tr> 
                    <td class=title>�����Ͻ�</td>
                    <td> 
                      &nbsp;<input type="text" name="deli_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="deli_dt_h">
                        <option value="">����</option>			  
                        <%for(int i=0; i<=24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="deli_dt_s" >
                        <option value="">����</option>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>���������</td>
                    <td>
                      &nbsp;<select name='deli_mng_id'>
                        <option value="">������</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
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
    <tr id=tr_fee0 style='display:none'> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�⺻�� ������� ���</span></td>
    </tr>
    <tr id=tr_fee1 style='display:none'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>
                <tr> 
                   <td class=title width=10%>��������</td>
                    <td> 
                      &nbsp;<select name="paid_st">
                    	              		<option value="">==����==</option>			  
                        	          	<option value="1">����</option>
                            	      		<!--<option value="2">�ſ�ī��</option>-->
                            	      		<option value="3">CMS(�ڵ���ü)</option>
                            	      		<option value="4">�������Ա�</option>
                	                	</select>
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
            </table>
        </td>
    </tr>	
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_fee2 style='display:none'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title>����</td>                    
                    <td width="11%" class=title>�뿩���Ѿ�&nbsp;&nbsp;<!--�������  �ڵ����--><a href="javascript:getFee_sam();"><img src=/acar/images/center/button_in_jdgs.gif align=absmiddle border=0></a></td>
                    <td width="8%" class=title>������</td>
                    <td width="8%" class=title>������</td>
                    <td width="11%" class=title>�Ѱ���ݾ�</td>
                </tr>
                <tr>                     
                    <td class=title width="10%">���ް�</td>
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
                <!--
                <tr> 
                    <td class=title>�����ٻ�������</td>
                    <td colspan='4'>&nbsp;<input type="checkbox" name="scd_reg_yn" value="Y"> ( üũ�ϸ� ������������, �Ѱ���ݾ� �հ�� �������� �����մϴ�.) 
                      </td>                      
                </tr>                
                -->
            </table>
        </td>
    </tr>    
    <tr> 
        <td colspan='2'>�� �̿� ���� ��� ��� : 24�ð� �̳� �ݳ� - 1��ġ ��� ����, 24�ð� �̻� �̿�� - 12�ð� ������ �뿩��� ����</td>
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

