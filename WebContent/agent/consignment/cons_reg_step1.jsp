<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.user_mng.*"%>
<%@ page import="acar.tint.*"%>
<%@ page import="acar.consignment.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/agent/cookies.jsp" %> 
<%@ include file="/agent/access_log.jsp" %>

<%
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String sub_l_cd 	= request.getParameter("sub_l_cd")==null?"":request.getParameter("sub_l_cd");
	String sub_c_id 	= request.getParameter("sub_c_id")==null?"":request.getParameter("sub_c_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String mm_seq		= request.getParameter("mm_seq")==null?"":request.getParameter("mm_seq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Hashtable car = new Hashtable();
	Hashtable car1 = new Hashtable();
	Hashtable car2 = new Hashtable();
	
	if(!car_mng_id.equals(""))	car1 = t_db.getUseLcCont(car_mng_id, "");
	if(!sub_c_id.equals(""))	car2 = t_db.getUseLcCont(sub_c_id, sub_l_cd);
	
	if(from_page.equals("/agent/car_pur/pur_doc_u.jsp") && !rent_l_cd.equals(""))	car1 = t_db.getUseLcCont("", rent_l_cd);
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "AGENT");
	int user_size = users.size();
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	Vector  codes2 = new Vector();
	int c_size2 = 0;	

	codes2 = c_db.getCodeAllV_0022_all("0022");	
	c_size2= codes2.size();
	
	String display = "";
	String cons_cau = "";
	String cost_st = "";
	String pay_st = "";
	
	ConsignmentBean cons_mm 		= cs_db.getConsignmentMM(mm_seq);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//���̱��ϱ�
function cut_length(f,cut_len) {
	var fm = document.form1;	
	var max_len = f.length;
	var len = 0;
	var rf = "";
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
		if(len <= cut_len){
			rf=rf+t;
		}
	}
	fm.sms_msg.value = rf;
}

//���̱��ϱ�
function cut_length2(f,cut_len) {
	var fm = document.form1;	
	var max_len = f.length;
	var len = 0;
	var rf = "";
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
		if(len <= cut_len){
			rf=rf+t;
		}
	}
	fm.sms_msg2.value = rf;
}


	//Ź�۾�ü ��ȸ
	function search_off()
	{
		var fm = document.form1;	
		window.open("/agent/cus0601/cus0602_frame.jsp?from_page=/agent/consignment/cons_i_c.jsp&t_wd="+fm.off_nm.value, "SERV_OFF", "left=10, top=10, width=900, height=650, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//Ź�۾�ü ����
	function view_off()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("���õ� Ź�۾�ü�� �����ϴ�."); return;}
		window.open("/agent/cus0601/cus0602_d_frame.jsp?from_page=/agent/consignment/cons_i_c.jsp&off_id="+fm.off_id.value, "SERV_OFF", "left=10, top=10, width=900, height=260, scrollbars=yes, status=yes, resizable=yes");
	}		
		
	//�ڵ��� ��ȸ
	function search_car(idx)
	{
		var fm = document.form1;
		window.open("/agent/tax/pop_search/s_car.jsp?go_url=/agent/consignment/cons_reg_step1.jsp&s_kd=2&t_wd="+fm.car_no[idx].value+"&idx="+idx, "CAR", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//������ڵ�����ȸ
	function search_car_res(idx)
	{
		var fm = document.form1;
		window.open("/agent/tax/pop_search/s_car_res.jsp?go_url=/agent/consignment/cons_reg_step1.jsp&s_kd=5&t_wd="+fm.req_id[idx].options[fm.req_id[idx].selectedIndex].text+"&idx="+idx, "CAR_RES", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
		
	//�ڵ��� ����
	function view_car(idx)
	{
		var fm = document.form1;
		//if(fm.off_id.value == ""){ alert("���õ� Ź�۾�ü�� �����ϴ�."); return;}
		if(fm.car_mng_id[idx].value == ""){ alert("���õ� �ڵ����� �����ϴ�."); return;}	
		window.open("/agent/car_register/car_view.jsp?rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_mng_id="+fm.car_mng_id[idx].value+"&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}			

	//�������� ����
	function view_car_nm(idx){
		var fm = document.form1;
		if(fm.car_mng_id[idx].value == ""){ alert("���õ� �ڵ����� �����ϴ�."); return;}	
		window.open("/agent/car_mst/car_mst_u.jsp?rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value, "VIEW_CAR_NM", "left=20, top=20, width=875, height=650, scrollbars=yes");		
	}

	//�ڵ��� �ܱ��̷� ����
	function view_car_sh(idx)
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("���õ� Ź�۾�ü�� �����ϴ�."); return;}
		if(fm.car_mng_id[idx].value == ""){ alert("���õ� �ڵ����� �����ϴ�."); return;}	
		window.open("/agent/lc_rent/view_res_sub.jsp?c_id="+fm.car_mng_id[idx].value+"&cmd=ud", "VIEW_CAR_RES", "left=100, top=100, width=850, height=450, scrollbars=yes");
	}			
	//�ڵ��� ����̷� ����
	function view_car_lh(idx)
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("���õ� Ź�۾�ü�� �����ϴ�."); return;}
		if(fm.car_mng_id[idx].value == ""){ alert("���õ� �ڵ����� �����ϴ�."); return;}	
		window.open("/agent/off_lease/off_lease_car_his.jsp?car_mng_id="+fm.car_mng_id[idx].value+"&cmd=ud", "VIEW_CAR_RES", "left=100, top=100, width=850, height=450, scrollbars=yes");
	}		

	//Ź�۱��п� ���� ����
	function cng_input_kd(cons_kd){
		var fm = document.form1;
		if(cons_kd == 1){
			fm.off_id.value = '';
			fm.off_nm.value = '';		
		}else{
			fm.off_id.value = '003158';
			fm.off_nm.value = '(��)�Ƹ���ī';				
		}		
	}	

	function cng_code_22(){
		var fm = document.form1;

		drop_deposit();
		
		fm.target='i_no';
		fm.action='/agent/consignment/get_code_22t_nodisplay.jsp?off_id='+fm.off_id.value;
		fm.submit();
	}	
	
	function drop_deposit(){
		var fm = document.form1;
					
		for(j=0; j<2 ; j++){
			var deposit_len = fm.cmp_app[j].length;			
			for(var i = 0 ; i < deposit_len ; i++){
				fm.cmp_app[j].options[deposit_len-(i+1)] = null;
			}
		}
		
	}
	
	function add_deposit(idx, val, str){
		for(j=0; j<2 ; j++){
			document.form1.cmp_app[j][idx] = new Option(str, val);		
		}	
	}
	
	//Ź�۱��п� ���� ����
	function cng_input(cons_su){
		var fm = document.form1;
		
		fm.cons_su.value = cons_su;
		
		cng_input2(cons_su);
	}	
	
	//��������� ���� ���÷���
	function cng_input2(cons_su){
		var fm = document.form1;		
		
		var cons_su = toInt(cons_su);
			
		if(cons_su >2){
			alert('�Է°����� �ִ�Ǽ���2�� �Դϴ�.');
			return;
		}		
		
		<%for(int i=1;i<2;i++){%>
		if(cons_su > <%=i%>){
			tr_cons<%=i%>_1.style.display	= '';
			tr_cons<%=i%>_2.style.display	= '';			
			tr_cons<%=i%>_3.style.display	= '';
			tr_cons<%=i%>_4.style.display	= '';
		}else{
			tr_cons<%=i%>_1.style.display	= 'none';
			tr_cons<%=i%>_2.style.display	= 'none';
			tr_cons<%=i%>_3.style.display	= 'none';
			tr_cons<%=i%>_4.style.display	= 'none';
		}
		<%}%>			
			
	}		
	
	//���/���� ���п� ���� �˾�
	function cng_input3(st, value, idx){
		var fm = document.form1;		
		var width = 600;
		var firm_nm = '';				
		var req_id 	= fm.req_id.value;
		var br_id = fm.br_id.value;
		var s_kd 	= '1';
				
		if(st == 'from' && fm.from_st[idx].value == ''){		alert('��� ������ �����Ͻʽÿ�.'); 	return;		}
		if(st == 'to' && fm.to_st[idx].value == ''){			alert('���� ������ �����Ͻʽÿ�.'); 	return;		}

		if(value == '2'){ 
			width 	= 800;
			firm_nm = fm.firm_nm[idx].value;
			if(firm_nm == '�Ƹ���ī' || firm_nm == '(��)�Ƹ���ī'){
				firm_nm = fm.car_no[idx].value;
				s_kd = '2';
			}
		}
		
		window.open("s_place.jsp?go_url=/agent/consignment/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&req_id="+req_id+"&br_id="+br_id, "PLACE", "left=10, top=10, width="+width+", height=400, scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//���/���� ����� ��ȸ
	function cng_input5(st, value, idx){
		var fm = document.form1;		
		var width = 600;
		var firm_nm = '';
		
		if(st == 'from' && fm.from_st[idx].value == ''){		alert('��� ������ �����Ͻʽÿ�.'); 	return;		}
		if(st == 'to' && fm.to_st[idx].value == ''){			alert('���� ������ �����Ͻʽÿ�.'); 	return;		}

		if(st == 'from')		firm_nm 	= fm.from_comp[idx].value;
		if(st == 'to')			firm_nm 	= fm.to_comp[idx].value;
		
		if(firm_nm == ''){ 		alert('������ �����Ͽ� ��Ҹ� ���� �����Ͽ� �ֽʽÿ�.'); 	return; }
		
		if(value == '1') 		firm_nm 	= replaceString('(��)�Ƹ���ī ','',firm_nm);
		
		if(value == '3'){		alert('���¾�ü�� ����� �˻��� �����ϴ�.');	return; }
		
		window.open("s_man.jsp?go_url=/agent/consignment/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd=1&t_wd="+firm_nm+"&rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_no="+fm.car_no[idx].value, "MAN", "left=10, top=10, width="+width+", height=500, scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//Ź�ۻ����� ����
	function cng_input4(value, idx){
		var fm = document.form1;
		
		if(value == "3" || value == "4" || value == "5") {
			$("[name=search]").eq(idx).css('display','inline-block');
			$("[name=sub_car_no]").eq(idx).css('display','inline-block');
			$("[name=car_no_text]").eq(idx).css('display','inline-block');
		} else {
			$("[name=search]").eq(idx).css('display','none');
			$("[name=sub_car_no]").eq(idx).css('display','none');
			$("[name=car_no_text]").eq(idx).css('display','none');
		}
		// ���� ���� �� sub_l_cd �ʱ�ȭ
		$("[name=sub_rent_l_cd]").eq(idx).val("");
		$("[name=sub_car_no]").eq(idx).val("");
		
		if(value != '20'){
			fm.cost_st[idx].value 	= '1';
			fm.pay_st[idx].value 	= '2';
		}
		if(value == '1' || value == '2' || value == '3' || value == '4' || value == '5' || value == '6' || value == '7' || value == '15' || value == '16'){
			fm.from_st[idx].value 	= '1';
			fm.to_st[idx].value 	= '2';
		}
		if(value == '8' || value == '9' || value == '10' || value == '11' || value == '12' || value == '13' || value == '14' || value == '17'){
			fm.from_st[idx].value 	= '2';
			fm.to_st[idx].value 	= '1';		
		}
		if(value == '8' || value == '9' || value == '10' || value == '11' || value == '12' || value == '13' || value == '14' || value == '15' || value == '16' || value == '17'){
			fm.etc[idx].value = "����� ���� ������ �ݵ�� 1���� ������ ���ֽñ� �ٶ��ϴ�.";
		}else{
			fm.etc[idx].value = "";
		}
	}				
	
	//������ ��ȸ
	function cng_input6(st, value, idx){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 700;	
		var s_kd	= 1;	
		var firm_nm = fm.off_nm.value;
		if(fm.off_id.value == '003158'){
			width 	= 600;
			height 	= 700;
			value = '4';
			s_kd  = 2;
			if(fm.driver_nm[idx].value != '')		firm_nm = fm.driver_nm[idx].value;
			else									firm_nm = '';
			window.open("s_man.jsp?go_url=/agent/consignment/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&cons_dt="+fm.from_req_dt[0].value, "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");					
		}else{
			window.open("s_man.jsp?go_url=/agent/consignment/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm, "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
		}		
	}			
	
	//Ź�۳��� �����ϱ�
	function value_copy(idx){
		var fm = document.form1;
		
			
		//��������Ÿ ��ȣ
		var copy_idx = toInt(fm.cons_copy[idx].value)-1;

		fm.cons_cau[idx].value 		= fm.cons_cau[copy_idx].value;
		fm.cost_st[idx].value 		= fm.cost_st[copy_idx].value;
		fm.pay_st[idx].value 		= fm.pay_st[copy_idx].value;

		fm.from_st[idx].value 		= fm.from_st[copy_idx].value;						
		fm.from_place[idx].value 	= fm.from_place[copy_idx].value;
		fm.from_comp[idx].value 	= fm.from_comp[copy_idx].value;		
		fm.from_title[idx].value 	= fm.from_title[copy_idx].value;
		fm.from_man[idx].value 		= fm.from_man[copy_idx].value;
		fm.from_tel[idx].value 		= fm.from_tel[copy_idx].value;
		fm.from_m_tel[idx].value 	= fm.from_m_tel[copy_idx].value;
		fm.from_req_dt[idx].value 	= fm.from_req_dt[copy_idx].value;
		fm.from_req_h[idx].value 	= fm.from_req_h[copy_idx].value;
		fm.from_req_s[idx].value 	= fm.from_req_s[copy_idx].value;
		
		fm.to_st[idx].value 		= fm.to_st[copy_idx].value;		
		fm.to_place[idx].value 		= fm.to_place[copy_idx].value;
		fm.to_comp[idx].value 		= fm.to_comp[copy_idx].value;		
		fm.to_title[idx].value 		= fm.to_title[copy_idx].value;
		fm.to_man[idx].value 		= fm.to_man[copy_idx].value;
		fm.to_tel[idx].value 		= fm.to_tel[copy_idx].value;
		fm.to_m_tel[idx].value 		= fm.to_m_tel[copy_idx].value;
		fm.to_req_dt[idx].value 	= fm.to_req_dt[copy_idx].value;
		fm.to_req_h[idx].value 		= fm.to_req_h[copy_idx].value;
		fm.to_req_s[idx].value 		= fm.to_req_s[copy_idx].value;
		
		fm.wash_yn[idx].value 		= fm.wash_yn[copy_idx].value;
		fm.oil_yn[idx].value 		= fm.oil_yn[copy_idx].value;
		fm.oil_liter[idx].value 	= fm.oil_liter[copy_idx].value;
		fm.oil_est_amt[idx].value 	= fm.oil_est_amt[copy_idx].value;
		fm.etc[idx].value 			= fm.etc[copy_idx].value;		
		
	}	
	
	//Ź�۳��� �����ϱ� - �պ�ó��
	function value_copy2(idx){
		var fm = document.form1;
		
		
		//��������Ÿ ��ȣ
		var copy_idx = toInt(fm.cons_copy[idx].value)-1;

		if(fm.cons_cau[copy_idx].value == '1') 	fm.cons_cau[idx].value = '8';
		if(fm.cons_cau[copy_idx].value == '8') 	fm.cons_cau[idx].value = '1';
		if(fm.cons_cau[copy_idx].value == '4') 	fm.cons_cau[idx].value = '11';
		if(fm.cons_cau[copy_idx].value == '11') fm.cons_cau[idx].value = '4';
		if(fm.cons_cau[copy_idx].value == '9') 	fm.cons_cau[idx].value = '6';
		if(fm.cons_cau[copy_idx].value == '6') 	fm.cons_cau[idx].value = '9';
		if(fm.cons_cau[copy_idx].value == '5') 	fm.cons_cau[idx].value = '12';
		if(fm.cons_cau[copy_idx].value == '12') fm.cons_cau[idx].value = '5';
		if(fm.cons_cau[copy_idx].value == '10') fm.cons_cau[idx].value = '10';
		if(fm.cons_cau[copy_idx].value == '7') 	fm.cons_cau[idx].value = '7';
		
		fm.cost_st[idx].value 		= fm.cost_st[copy_idx].value;
		fm.pay_st[idx].value 		= fm.pay_st[copy_idx].value;

		fm.to_st[idx].value 		= fm.from_st[copy_idx].value;						
		fm.to_place[idx].value 		= fm.from_place[copy_idx].value;
		fm.to_comp[idx].value 		= fm.from_comp[copy_idx].value;		
		fm.to_title[idx].value 		= fm.from_title[copy_idx].value;
		fm.to_man[idx].value 		= fm.from_man[copy_idx].value;
		fm.to_tel[idx].value 		= fm.from_tel[copy_idx].value;
		fm.to_m_tel[idx].value 		= fm.from_m_tel[copy_idx].value;
		fm.to_req_dt[idx].value 	= fm.from_req_dt[copy_idx].value;
		fm.to_req_h[idx].value 		= fm.from_req_h[copy_idx].value;
		fm.to_req_s[idx].value 		= fm.from_req_s[copy_idx].value;
		
		fm.from_st[idx].value 		= fm.to_st[copy_idx].value;		
		fm.from_place[idx].value 	= fm.to_place[copy_idx].value;
		fm.from_comp[idx].value 	= fm.to_comp[copy_idx].value;		
		fm.from_title[idx].value 	= fm.to_title[copy_idx].value;
		fm.from_man[idx].value 		= fm.to_man[copy_idx].value;
		fm.from_tel[idx].value 		= fm.to_tel[copy_idx].value;
		fm.from_m_tel[idx].value 	= fm.to_m_tel[copy_idx].value;
		fm.from_req_dt[idx].value 	= fm.to_req_dt[copy_idx].value;
		fm.from_req_h[idx].value 	= fm.to_req_h[copy_idx].value;
		fm.from_req_s[idx].value 	= fm.to_req_s[copy_idx].value;
		
		fm.wash_yn[idx].value 		= fm.wash_yn[copy_idx].value;
		fm.oil_yn[idx].value 		= fm.oil_yn[copy_idx].value;
		fm.oil_liter[idx].value 	= fm.oil_liter[copy_idx].value;
		fm.oil_est_amt[idx].value 	= fm.oil_est_amt[copy_idx].value;
		fm.etc[idx].value 			= fm.etc[copy_idx].value;		
		
	}		
	
	function save(){
		var fm = document.form1;
		var size = toInt(fm.cons_su.value);
		var vali_switch = true;
		
		var cons_cau1 = $("#cons_cau0").val(); // Ź��1 ����
		var cons_cau2 = $("#cons_cau1").val(); // Ź��2 ����
		
		if($('input:radio[name=cons_st]').eq(0).is(':checked') == true) {
			// ��
			if(cons_cau1 == "3" || cons_cau1 == "4" || cons_cau1 == "5") {
				if(!$("[name=sub_rent_l_cd]").eq(0).val()) {
					alert("Ź�� ������ ����/����/���/���� �ε��� ��� �� ����� ������ �����ؾ� �մϴ�.");
					return;
				}
			}
		} else {
			// �պ�
			if(cons_cau1 == "3" || cons_cau1 == "4" || cons_cau1 == "5") {
				if(!$("[name=sub_rent_l_cd]").eq(0).val()) {
					alert("Ź�� ������ ����/����/���/���� �ε��� ��� �� ����� ������ �����ؾ� �մϴ�.");
					return;
				}
			}
			
			if(cons_cau2 == "3" || cons_cau2 == "4" || cons_cau2 == "5") {
				if(!$("[name=sub_rent_l_cd]").eq(1).val()) {
					alert("Ź�� ������ ����/����/���/���� �ε��� ��� �� ����� ������ �����ؾ� �մϴ�.");
					return;
				}
			} 
		}
		
		if(fm.off_id.value == "")	{ 	alert("���õ� Ź�۾�ü�� �����ϴ�."); 	return;	}
//		if(fm.cons_su.value == "")	{ 	alert("��������� �Է��Ͻʽÿ�."); 		return;	}
//		if(fm.cons_su.value == "0")	{ 	alert("��������� �Է��Ͻʽÿ�."); 		return;	}

		
		if(fm.off_id.value == '002740' || fm.off_id.value == '003158' || fm.off_id.value == '009217'  || fm.off_id.value == '010255' ){  //����Ź��, �Ƹ���ī, �Ƹ���Ź�� �� ��� �ʼ�
			if(fm.cons_st[0].checked == true){ 	
		//		alert(fm.cmp_app[0].value);
				if(fm.cmp_app[0].value == "" || fm.cmp_app[0].value == "S00" || fm.cmp_app[0].value == "D00" || fm.cmp_app[0].value == "B00" || fm.cmp_app[0].value == "C00" || fm.cmp_app[0].value == "E00"  || fm.cmp_app[0].value == "F00"  || fm.cmp_app[0].value == "T00" || fm.cmp_app[0].value == "W00"){	alert('Ź�۱����� �����Ͻʽÿ�.');	return;}
		    	} else {
				if(fm.cmp_app[0].value == "" || fm.cmp_app[0].value == "S00" || fm.cmp_app[0].value == "D00" || fm.cmp_app[0].value == "B00" || fm.cmp_app[0].value == "C00" || fm.cmp_app[0].value == "E00"  || fm.cmp_app[0].value == "F00"  || fm.cmp_app[0].value == "T00" || fm.cmp_app[0].value == "W00"){	alert('Ź�۱���1�� �����Ͻʽÿ�.');	return;}
				if(fm.cmp_app[1].value == "" || fm.cmp_app[1].value == "S00" || fm.cmp_app[1].value == "D00" || fm.cmp_app[1].value == "B00" || fm.cmp_app[1].value == "C00" || fm.cmp_app[1].value == "E00"  || fm.cmp_app[1].value == "F00"  || fm.cmp_app[1].value == "T00" || fm.cmp_app[1].value == "W00"){	alert('Ź�۱���2�� �����Ͻʽÿ�.');	return;}
			}
		}
		
		if(fm.cons_st[1].checked == true && size < 2){ 	alert('�պ��� ��� �ּ� ��������� 2���Դϴ�.'); return;}
		
		for(i=0; i<size ; i++){
			if(fm.car_no[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : ���õ� ������ �����ϴ�. ������ȣ�� ������ �����ȣ�� ���� �Է��ϼ���");	return;	}
			if(fm.rent_l_cd[i].value == "") 	{ 	alert((i+1)+"�� Ź�� : ������ȸ�� ���� �ʾҽ��ϴ�.");		return;	}
			if(fm.req_id[i].value == "")		{ 	alert((i+1)+"�� �Ƿ��ڸ� �Է��Ͻʽÿ�."); 		return;	}	
			if(fm.cons_cau[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : Ź�ۻ����� �Է��Ͻʽÿ�."); 			return;	}
			if(fm.cons_cau[i].value == "20" && fm.cons_cau_etc[i].value == "") { 	alert((i+1)+"�� Ź�� : Ź�ۻ��� ��Ÿ�� �Է��Ͻʽÿ�."); 	return;	}
			if(fm.cost_st[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : ��뱸���� �����Ͻʽÿ�."); 			return;	}
			if(fm.cost_st[i].value == "2" && fm.cust_amt[i].value == "0") 		{ 	alert((i+1)+"�� Ź�� : ���δ� Ź�۷Ḧ �Է��Ͻʽÿ�."); 	return;	}
			if(fm.pay_st[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : ���ޱ����� �����Ͻʽÿ�."); 			return;	}
			//if(fm.from_st[i].value == "") 		{ 	alert(i+"�� Ź�� : ���-������ �����Ͻʽÿ�."); 		return;	}
			if(fm.from_place[i].value == "") 	{ 	alert((i+1)+"�� Ź�� : ���-��Ҹ� �Է��Ͻʽÿ�."); 		return;	}
			if(fm.from_comp[i].value == "") 	{ 	alert((i+1)+"�� Ź�� : ���-��ȣ/������ �Է��Ͻʽÿ�."); 	return;	}
			if(fm.from_req_dt[i].value == "" || fm.from_req_h[i].value == "" || fm.from_req_s[i].value == "") 	{ 	alert((i+1)+"�� Ź�� : ���-��û�Ͻø� �Է��Ͻʽÿ�."); 	return;	}
			//if(fm.to_st[i].value == "") 		{ 	alert(i+"�� Ź�� : ����-������ �����Ͻʽÿ�."); 		return;	}
			if(fm.to_place[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : ����-��Ҹ� �Է��Ͻʽÿ�."); 		return;	}
			if(fm.to_comp[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : ����-��ȣ/������ �Է��Ͻʽÿ�."); 	return;	}
			if(fm.to_req_dt[i].value == "" || fm.to_req_h[i].value == "" || fm.to_req_s[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : ����-��û�Ͻø� �Է��Ͻʽÿ�."); 	return;	}		
			if(fm.off_id.value == '003158'){
				if(fm.driver_nm[i].value != "" && fm.driver_id[i].value == "") { 	alert((i+1)+"�� Ź�� : �����ڸ� ��ȸ�Ͽ� �����Ͻʽÿ�."); 	return;	}
			}
		}
		
		cut_length("[Ź��������û]����Ͻ�:"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"��/�����:"+fm.from_place[0].value+"/������:"+fm.to_place[0].value,90);
		cut_length2("[Ź��]����Ͻ�:"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"��/�����:"+fm.from_place[0].value+"/������:"+fm.to_place[0].value,90);		
		
		// 2018.03.13
		// Ź�ۻ����� ȸ���� ���ų� ����ݳ� �� ��� ����� ������ ���� ��� �ڵ��� ��ȣ�� �ݵ�� ���� �Ѵ�.
		/* $("select[name=cons_cau] option:selected").each(function(i, selected){
			var cons_cau_val = $(selected).text();
			console.log(cons_cau_val);
		}); */
		$("select[name=cons_cau] option:selected").each(function(i, selected){
			var cons_cau_val = $(selected).text();
			if(cons_cau_val.indexOf("ȸ��")>0 || cons_cau_val.indexOf("��ݳ�")>0){
				if(fm.from_st[i].value==2){// ��� ������ ���� ���
					if(fm.from_m_tel[i].value.length < 11) {
						if($("input[name=cons_st]:checked").val()==1){
							if(i==1) {
								return false;
							}
						}
						alert((i+1)+"�� Ź�� : ���-����ó �ڵ��� ��ȣ�� �Է��Ͻʽÿ�.");
						vali_switch = false;
						fm.from_m_tel[i].focus();
						return false;
					}
				}
			}
		});
		
		//�Ƹ���Ź�� - 20220401 �����   (��)�ſ����̸��ͽ�   to_comp  (��)�Ƹ���ī ����
		// ����������, �ſ����� : ������ݰ� ����,  ����������,�ſ����̿� : ������ ���� ( �ڵ��� T136���� ��� )
		/*
		if( fm.off_id.value == '009217') {	
		
			if (fm.cons_st.value == "2") {
				//Ź��1
				if (fm.cmp_app[0].value >= "T41") {  //����������� �ſ����� �ܿ��� ��� ( �������� Ź���� �������)				   
					if (fm.from_comp[0].value.indexOf("(��)�ſ����̸��ͽ�") !=-1 || fm.from_comp[0].value.indexOf("(��)�Ƹ���ī ����") !=-1 || fm.to_comp[0].value.indexOf("(��)�ſ����̸��ͽ�") !=-1 || fm.to_comp[0].value.indexOf("(��)�Ƹ���ī ����") !=-1) {
						alert("1�� Ź�� ������ (����,�ſ�����)�������� �ٽ� �����ϼ���!!!"); 	
						return;						
					}				
				}
		
				if (fm.cmp_app[0].value <= "T08" || fm.cmp_app[0].value == "T40" ) {  //����������� �ſ����� �ܴ̿� ���� �� ��� �Ұ� ( �������� Ź���� �������)				   
					if (fm.from_comp[0].value.indexOf("(��)�ſ����̸��ͽ�")!=-1 || fm.from_comp[0].value.indexOf("(��)�Ƹ���ī ����")!=-1 || fm.to_comp[0].value.indexOf("(��)�ſ����̸��ͽ�")!=-1 || fm.to_comp[0].value.indexOf("(��)�Ƹ���ī ����")!=-1) {
					} else {	
						alert("1�� Ź�� ������(����,�ſ����� ����)�������� �ٽ� �����ϼ���!!!"); 	
						return;						
					}					
				}
								
				//Ź��2
				if (fm.cmp_app[1].value >= "T41") {  //����������� �ſ����� �ܿ��� ��� ( �������� Ź���� �������)				   
					if (fm.from_comp[1].value.indexOf("(��)�ſ����̸��ͽ�")!=-1 || fm.from_comp[1].value.indexOf("(��)�Ƹ���ī ����")!=-1 || fm.to_comp[1].value.indexOf("(��)�ſ����̸��ͽ�")!=-1 || fm.to_comp[1].value.indexOf("(��)�Ƹ���ī ����")!=-1) {
						alert("2�� Ź�� ������ (����,�ſ�����)�������� �ٽ� �����ϼ���!!!"); 	
						return;						
					}					
				}
				
				if (fm.cmp_app[1].value <= "T08" || fm.cmp_app[1].value == "T40" ) {  //����������� �ſ����� �ܴ̿� ���� �� ��� �Ұ� ( �������� Ź���� �������)				   
					if (fm.from_comp[1].value.indexOf("(��)�ſ����̸��ͽ�")!=-1 || fm.from_comp[1].value.indexOf("(��)�Ƹ���ī ����")!=-1 || fm.to_comp[1].value.indexOf("(��)�ſ����̸��ͽ�")!=-1 || fm.to_comp[1].value.indexOf("(��)�Ƹ���ī ����")!=-1) {
					} else {	
						alert("2�� Ź�� ������ (����,�ſ����� ����)�������� �ٽ� �����ϼ���!!!"); 	
						return;						
					}						
				}
				
			} else {  //�� 
				//Ź��1
				if (fm.cmp_app[0].value >= "T41") {  //����������� �ſ����� �ܿ��� ��� ( �������� Ź���� �������)	
									
					if (fm.from_comp[0].value.indexOf("(��)�ſ����̸��ͽ�") !=-1 || fm.from_comp[0].value.indexOf("(��)�Ƹ���ī ����") !=-1 || fm.to_comp[0].value.indexOf("(��)�ſ����̸��ͽ�") !=-1 || fm.to_comp[0].value.indexOf("(��)�Ƹ���ī ����") !=-1) {						
						alert("1�� Ź�� ������ (����,�ſ�����)�������� �ٽ� �����ϼ���!!!"); 	
						return;						
					}	
				}
			
				if (fm.cmp_app[0].value <= "T08" || fm.cmp_app[0].value == "T40" ) {  //����������� �ſ����� �ܴ̿� ���� �� ��� �Ұ� ( �������� Ź���� �������)				  
					if (fm.from_comp[0].value.indexOf("(��)�ſ����̸��ͽ�") !=-1 || fm.from_comp[0].value.indexOf("(��)�Ƹ���ī ����") !=-1 || fm.to_comp[0].value.indexOf("(��)�ſ����̸��ͽ�") !=-1 || fm.to_comp[0].value.indexOf("(��)�Ƹ���ī ����") !=-1) {
					} else {	
						alert("1�� Ź�� ������(����,�ſ����� ����)�������� �ٽ� �����ϼ���!!! "); 	
						return;						
					}								
				}
				
			}								
		}
		*/	
		
		//�Ƹ���Ź�� - 202207����  	if ( fm.from_comp[0].value.indexOf("(��)�Ƹ���ī ����") !=-1 ||  fm.to_comp[0].value.indexOf("(��)�Ƹ���ī ����") !=-1) {
		
			//�Ƹ���Ź�� - 20220401 �����   (��)�ſ����̸��ͽ�   to_comp  (��)�Ƹ���ī ����
		// ����������, �ſ����� : ������ݰ� ����,  ����������,�ſ����̿� : ������ ���� ( �ڵ��� T136���� ��� )
		//�Ƹ���Ź�� - 202207����  	if ( fm.from_comp[0].value.indexOf("(��)�Ƹ���ī ����") !=-1 ||  fm.to_comp[0].value.indexOf("(��)�Ƹ���ī ����") !=-1) {
		/* �Ƹ���Ź�� - 202209 Ź������ Ź�ۻ簡 ó�� 
			if( fm.off_id.value == '009217') {	
		
			if (fm.cons_st.value == "2") {
				//Ź��1
				if (fm.cmp_app[0].value >= "E01" && fm.cmp_app[0].value <= "E47") {  //���������常 ��� (�������� Ź���� �������)
												
					if ( fm.from_comp[0].value.indexOf("����ũ��") !=-1 || fm.to_comp[0].value.indexOf("����ũ��") !=-1|| fm.from_comp[0].value.indexOf("�Ƹ������ͽ�") !=-1 || fm.to_comp[0].value.indexOf("�Ƹ������ͽ�") !=-1)   {		
					} else {
						alert("1�� Ź�� ������ (������ �׿������  ���/����)�������� �ٽ� �����ϼ���!!!"); 	
						return;						
					}						
				}
			
				if (fm.cmp_app[0].value >= "C01" && fm.cmp_app[0].value <= "C47") {  //���������ΰ��  ( �������� Ź���� �������)	
				 				
					if ( fm.from_comp[0].value.indexOf("����ũ��") !=-1 || fm.to_comp[0].value.indexOf("����ũ��") !=-1|| fm.from_comp[0].value.indexOf("�Ƹ������ͽ�") !=-1 || fm.to_comp[0].value.indexOf("�Ƹ������ͽ�") !=-1)   {		
				   		alert("1�� Ź�� ������ (�����(����ũ��, �Ƹ������ͽ�)���/����)�������� �ٽ� �����ϼ���!!!"); 
						return;						
					}		
											
				}			
								
				//Ź��2
				if (fm.cmp_app[1].value >= "E01" && fm.cmp_app[1].value <= "E47") {  //���������常 ��� (�������� Ź���� �������)
												
					if ( fm.from_comp[1].value.indexOf("����ũ��") !=-1 || fm.to_comp[1].value.indexOf("����ũ��") !=-1|| fm.from_comp[1].value.indexOf("�Ƹ������ͽ�") !=-1 || fm.to_comp[1].value.indexOf("�Ƹ������ͽ�") !=-1)   {		
					} else {
						alert("2�� Ź�� ������ (������ �׿������  ���/����)�������� �ٽ� �����ϼ���!!!"); 	
						return;						
					}						
				}
			
				if (fm.cmp_app[1].value >= "C01" && fm.cmp_app[1].value <= "C47") {  //���������ΰ��  ( �������� Ź���� �������)	
				 				
					if ( fm.from_comp[1].value.indexOf("����ũ��") !=-1 || fm.to_comp[1].value.indexOf("����ũ��") !=-1|| fm.from_comp[1].value.indexOf("�Ƹ������ͽ�") !=-1 || fm.to_comp[1].value.indexOf("�Ƹ������ͽ�") !=-1)   {		
				   		alert("2�� Ź�� ������ (�����(����ũ��, �Ƹ������ͽ�)���/����)�������� �ٽ� �����ϼ���!!!"); 
						return;						
					}		
											
				}				
				
			} else {  //�� 
				//Ź��1
				if (fm.cmp_app[0].value >= "E01" && fm.cmp_app[0].value <= "E47") {  //���������常 ��� (�������� Ź���� �������)
					
					if ( fm.from_comp[0].value.indexOf("����ũ��") !=-1 || fm.to_comp[0].value.indexOf("����ũ��") !=-1|| fm.from_comp[0].value.indexOf("�Ƹ������ͽ�") !=-1 || fm.to_comp[0].value.indexOf("�Ƹ������ͽ�") !=-1)   {		
					} else {
						alert("1�� Ź�� ������ (������ �׿������  ���/����)�������� �ٽ� �����ϼ���!!!"); 	
						return;						
					}						
				}
			
				if (fm.cmp_app[0].value >= "C01" && fm.cmp_app[0].value <= "C47") {  //���������ΰ��  ( �������� Ź���� �������)	
				 				
					if ( fm.from_comp[0].value.indexOf("����ũ��") !=-1 || fm.to_comp[0].value.indexOf("����ũ��") !=-1|| fm.from_comp[0].value.indexOf("�Ƹ������ͽ�") !=-1 || fm.to_comp[0].value.indexOf("�Ƹ������ͽ�") !=-1)   {		
				   		alert("1�� Ź�� ������ (�����(����ũ��, �Ƹ������ͽ�) ���/����)�������� �ٽ� �����ϼ���!!!"); 
						return;						
					}		
											
				}			
				
			}								
		}
		*/
		
		
		
		if(vali_switch){
			if(confirm('����Ͻðڽ��ϱ�?')){		
				fm.action='cons_reg_step1_a.jsp';
				fm.target='i_no';
//				fm.target='d_content';
				fm.submit();
			}		
		}
	}
	
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') {
			if(nm == 'car_no')	search_car(idx);
		}
	}	


//���÷��� Ÿ��-�����ϰ�� üũ
function cng_input1() {
	var fm = document.form1;
if(fm.s_car.checked == true && fm.after_yn.checked == false){
 gubun.style.display = "";
}else{
 gubun.style.display = "none";
}
}

	//������Ʈ������ȸ
	function Agent_User_search(nm, idx)
	{
		var fm = document.form1;
		if(fm.req_id[idx].value == '')		{ alert('�Ƿ��ڸ� �����Ͻʽÿ�.'); 		return;}
		var t_wd = '';
		window.open("about:blank",'Agent_User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');
		fm.action = "/fms2/lc_rent/search_agent_user.jsp?mode=EMP_Y&nm="+nm+"&t_wd="+t_wd+"&idx="+idx+"&agent_user_id="+fm.req_id[idx].value;
		fm.target = "Agent_User_search";
		fm.submit();
	}
	
	function select(sub_rent_l_cd, idx, age_scp, car_no) {
		$("[name=sub_rent_l_cd]").eq(idx).val(sub_rent_l_cd);
		$("[name=age_scp]").eq(idx).val(age_scp);
		if(!car_no) {
			$("[name=sub_car_no]").eq(idx).val(sub_rent_l_cd);
		}
		var age_scp = $("[name=age_scp]").eq(idx).val();
		if(age_scp == "1") {
			
		}
	}
	
	function test() {
		alert("����� ��ȸ ��ư�� Ŭ���Ͽ� �����ϼ���.");
	}

	$(document).on("click","[name=search]", function(){
		var fm = document.form1;
		var idx = $("[name=search]").index(this);
		$("[name=sub_rent_l_cd]").eq(idx).val("");
		$("[name=sub_car_no]").eq(idx).val("");
		
		// 3: �������� �ε�, 4: ������� �ε�, 5: ������ �ε�
		window.open("client_s.jsp?idx="+idx, "CLIENT_SEARCH", "left=50, top=50, width=1020, height=700, resizable=yes, scrollbars=yes, status=yes");
	}); 
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='mm_seq' value='<%=mm_seq%>'> 
 <input type='hidden' name='sms_msg' value=''> 
 <input type='hidden' name='sms_msg2' value=''> 
 <input type='hidden' name='off_msg' value='Y'> 
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > Ź�۰��� > <span class=style5>Ź���Ƿڵ��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
	<%	if(!cons_mm.getMm_seq().equals("")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ȭ��û</span>		
		</td>
	</tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>������ȣ</td>
                    <td>&nbsp;<%=cons_mm.getMm_car_no1()%>, <%=cons_mm.getMm_car_no2()%></td>	
                </tr>	
                <tr> 					
                    <td class='title'>�Ƿڳ���</td>
                    <td>&nbsp;<%=cons_mm.getMm_content()%>        			 
        			</td>	
                </tr>	
            </table>
        </td>
    </tr>	
	<tr>
	    <td align="right" style='height:1; background-color:#e5e5e5;'></td>
	</tr>	
	<tr>
	    <td>&nbsp;</td>
	</tr>						
	<%	}else{%>
	<%		Vector mm_vt = cs_db.getConsignmentRegOffReqNmList(user_id);
			int mm_vt_size = mm_vt.size();
			if(mm_vt_size>0){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ȭ��û �̵�� ����Ʈ</span>		
		</td>
	</tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
				  <td width='5%' class='title'>����</td>
				  <td width='5%' class='title'>����</td>				  
				  <td width='15%' class='title'>Ź�۾�ü</td>
		          <td width='10%' class='title'>Ź������</td>														  
				  <td width='15%' class='title'>������ȣ</td>
				  <td width='50%' class='title'>�Ƿڳ���</td>					
				</tr>			
<%				for(int i = 0 ; i < mm_vt_size ; i++){
					Hashtable mm_ht = (Hashtable)mm_vt.elementAt(i);%>			
                <tr> 
					<td  width='5%' align='center'><%=i+1%></td>
					<td  width='5%' align='center'><a href="javascript:set_cons_mm('<%=mm_ht.get("SEQ")%>', '<%=AddUtil.ChangeDate2(String.valueOf(mm_ht.get("CONS_DT")))%>', '<%=mm_ht.get("CAR_NO1")%>', '<%=mm_ht.get("CAR_NO2")%>', '<%=mm_ht.get("REQ_NM")%>', '<%=mm_ht.get("REG_ID")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></td>					
					<td  width='15%' align='center'><%=mm_ht.get("USER_NM")%></td>
					<td  width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(mm_ht.get("CONS_DT")))%></td>					
					<td  width='20%' align='center'><%=mm_ht.get("CAR_NO1")%><%if(!mm_ht.get("CAR_NO2").equals("")){%>, <%}%><%=mm_ht.get("CAR_NO2")%></td>									
					<td  width='50%'>&nbsp;<%=mm_ht.get("CONTENT")%></td>									
                </tr>	
<%				}%>				
            </table>
        </td>
    </tr>	
	<tr>
	    <td><font color="green">* Ź�۾�ü���� ������ȭ��û�� ����Ͽ�����, Ź�ۿ����� �ȵ� ���� ���� ����Ʈ�� �ֽ��ϴ�. ���ù�ư�� Ŭ���ϸ� �ش� �������� �Է��� �˴ϴ�.</font></td>
	</tr>	
	<tr>
	    <td><font color="green">* ������ȭ��û�� ���ؼ��� 2010-06-08 [Ź�۵�Ͽ����� ����ó�����] �̶� �������� ���׷��̵������� �����Ǿ� �ֽ��ϴ�.</font></td>
	</tr>	
	<tr>
	    <td align="right" style='height:1; background-color:#e5e5e5;'></td>
	</tr>	
	<tr>
	    <td>&nbsp;</td>
	</tr>						
<%			}%>						
<%		}%>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>Ź�ۺз�</td>
                    <td colspan="3">&nbsp;
        			  <input type='radio' name="cons_kd" value='1' onClick="javascript:cng_input_kd(1)" checked>
        				����
        			</td>	
                </tr>		
                <tr> 
                    <td width='13%' class='title'>Ź�۾�ü</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' name="off_nm" value='' size='30' class='text'><!--(��)�Ƹ���ī-->
        			  <input type='hidden' name='off_id' value=''><!--003158-->
        			  <span class="b"><a href="javascript:search_off()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			  <span class="b"><a href="javascript:view_off()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_see.gif"  border="0" align=absmiddle></a></span>
        			</td>
                </tr>
                
                <tr> 
                    <td width='13%' class='title'>Ź�۱���</td>
                    <td  colspan="3">&nbsp;
        			  <input type='radio' name="cons_st" value='1' onClick="javascript:cng_input(1)" <%if(car_mng_id.equals(""))%>checked<%%>>
        				��
        			  <input type='radio' name="cons_st" value='2' onClick="javascript:cng_input(2)" <%if(!car_mng_id.equals("") && !sub_c_id.equals(""))%>checked<%%>>
        				�պ�
        				<input type='hidden' name='cons_su' <%if(!car_mng_id.equals("") && !sub_c_id.equals("")){%>value='2'<%}else{%>value='1'<%}%>>
        			</td>	
                </tr>
                <tr> 
                    <td width='13%' class='title'>�����Է¿���</td>
                    <td >&nbsp;
					<input type="checkbox" name="after_yn" value="Y" onClick="Javascript:cng_input1()">
        			  (Ź�ۿϷ�� �����Է��϶�)</td>

        			<td width='15%' class='title' style='height:32'>��������� �������ۿ���</td>
                    <td >&nbsp;
        			<input type="checkbox" name="s_car" value="Y" onClick="Javascript:cng_input1()">
        			  (��������� �ȵ� ���� Ź���Ƿڸ� �Է��� ��쿡�� üũ�ϼ���.)</td>

                </tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� <b>��üŹ���� ��쿡 Ź��ȸ��� (��)�Ƹ���ī�� �Ǹ�, �����ڿ� Ź�ۼ�����(��������)�� �Է�</b>�Ͻñ� �ٶ��ϴ�.</font></td>
	</tr>	
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� <b>�̵�������϶��� ��ȣ�� ��ȸ�ϰ� ����������ȣ�� �����ȣ�� ���� �Է��Ͻʽÿ�.</b></font> </td>
	</tr>	
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� ������ ���� ���� "��û-��Ÿ"�� �Է��Ͻʽÿ�.</font></td>
	</tr>					
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� �̹� <b>Ź�� �Ϸ�</b>�Ǿ� �ĵ���ϴ� ��쿡�� "��û-<b>��Ÿ</b>"�� ������ �Է��� �ּ���.</font></td>
	</tr>					
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� ���������� ��/����� ��� ���/���������� "���¾�ü"�� �Ͽ� �˻��Ͻʽÿ�.</font></td>
	</tr>					
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� <b>���/���� ������ ���� �Է�</b>�ϼŵ� �˴ϴ�.</font></td>
	</tr>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� <b>�����Է¿���</b>�� üũ�Ǹ� Ź�۾�ü �� ����������� �߼��ϴ� ���ڸ޼����� ���۵��� �ʽ��ϴ�.</font></td>
	</tr>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� <b>1�� Ź�� �Ƿ��ڰ� ���ڹ����� �Ƿ���, Ȯ���ڷ� ����.</b></font></td>
	</tr>	
	<tr>
	    <td class=h></td>
	</tr>					
	<tr>
	    <td align="right" style='height:1; background-color:#e5e5e5;'></td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
    	<td>
        	<div id="gubun" style="display:none">
        		<table width=100% border="0" cellpadding="0" cellspacing=0>
        		    <tr>
        		        <td class=line2></td>
        		    </tr>
        		    <tr>
        		        <td class=line>
        		            <table width=100% border=0 cellspacing=1 cellpadding=0>
                    			<tr>
            	       				<td align="center" class='title' width=13% rowspan=2>���ڼ�����</td>
                					<td>&nbsp; <input type='checkbox' name='f_man' value='Y'>�����&nbsp; &nbsp;&nbsp;<input type='checkbox' name='d_man' value='Y'>Ź�۾�ü&nbsp; </td>
                				</tr>
                    			<tr>
            					    <td style='height:35'><font color=blue>&nbsp;&nbsp; �� ��������� �Ϸ�� �Ŀ� ��������� �Ǵ� �����ڰ� �޼��������⸦ �Ͽ��� �޼����� ���۵˴ϴ�.<br>
                                    &nbsp;&nbsp; �� �պ� Ź���� ��� �׻� [Ź�� 1]�� ����Ź�� ������ �Է��Ͽ� �ֽñ� �ٶ��ϴ�.</font></td>
            	        		</tr>
            	            </table>
            	        </td>
            	     </tr>
            	     <tr>
                	    <td class=h></td>
                	</tr>	
    			</table>
			</div>
		</td>
	</tr>

			
	<%for(int j=0; j<10; j++){
	
		cost_st = "";
		pay_st 	= "";
		
		if(j==0){
			display = "''";
			if(!car_mng_id.equals("") && j==0){
				car = car1;
				if(rent_st.equals("1")) 	cons_cau = "1";
				else if(rent_st.equals("2")) 	cons_cau = "4";
				else if(rent_st.equals("3")) 	cons_cau = "5";
				else if(rent_st.equals("9")) 	cons_cau = "1";
				else if(rent_st.equals("10")) 	cons_cau = "3";
				else if(rent_st.equals("6")) 	cons_cau = "19";
				else if(rent_st.equals("8")) 	cons_cau = "19";
				else if(rent_st.equals("12")) 	cons_cau = "1";
				
				cost_st = "1";
				pay_st	= "2";
			}
		}else{
			if(!sub_l_cd.equals("") && j==1){
			 	car = car2;
				display = "''";
				if(rent_st.equals("2")) 	cons_cau = "11";
				else if(rent_st.equals("3")) 	cons_cau = "12";
				
				cost_st = "1";
				pay_st	= "2";
			}else{
				car = new Hashtable();
				display = "none";
				cons_cau = "";
			}
		}
		%>
	<tr id=tr_cons<%=j%>_1 style="display:<%=display%>">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>Ź��<%=j+1%></span>
		
		</td>
	</tr>
    <tr id=tr_cons<%=j%>_2 style="display:<%=display%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr><td class=line2 style='height:1'></td></tr>
				<%	
					
				%>
                <tr> 
                    <td width='13%' class='title'>������ȣ/�����ȣ</td>
                    <td width='37%'>&nbsp;
        			  <input type='text' name="car_no" value='<%=car.get("CAR_NO")==null?"":car.get("CAR_NO")%>' size='25' class='text' onKeyDown="javasript:enter('car_no', <%=j%>)">
        			  <input type='hidden' name='car_mng_id' value='<%=car.get("CAR_MNG_ID")==null?"":car.get("CAR_MNG_ID")%>'>
        			  <input type='hidden' name='rent_mng_id' value='<%=car.get("RENT_MNG_ID")==null?"":car.get("RENT_MNG_ID")%>'>
        			  <input type='hidden' name='rent_l_cd' value='<%=car.get("RENT_L_CD")==null?"":car.get("RENT_L_CD")%>'>
        			  <input type='hidden' name='client_id' value='<%=car.get("CLIENT_ID")==null?"":car.get("CLIENT_ID")%>'>
        			    <span class="b"><a href="javascript:search_car(<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
						&nbsp;&nbsp;&nbsp;		
					<!--	<span class="b"><a href="javascript:search_car_res(<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">[��/���� ���� ��ȸ]</a></span> -->
        			</td>
        			<td width='13%' class='title'>����</td>
        			<td width='37%'>&nbsp;
        			  <input type='text' name="car_nm" value='<%=car.get("CAR_NM")==null?"":car.get("CAR_NM")%> <%=car.get("CAR_NAME")==null?"":car.get("CAR_NAME")%>' size='40' class='whitetext' readonly>
        			  <span class="b"><a href="javascript:view_car(<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_see.gif"  border="0" align=absmiddle></a></span>
        			  </td>
                </tr>
    		    <tr>
        		    <td class='title'>����</td>
        			<td>&nbsp;
        			  <input type='text' name="car_y_form" value='<%=car.get("CAR_Y_FORM")==null?"":car.get("CAR_Y_FORM")%>' size='40' class='whitetext' readonly>
        			</td>
        		    <td class='title'>����</td>
        			<td>&nbsp;
        			  <input type='text' name="color" value='<%=car.get("COLO")==null?"":car.get("COLO")%>' size='40' class='whitetext' readonly></td>			
    		    </tr>
    		    
    		    <tr>
        		    <td class='title'>�⺻���</td>
        			<td colspan="3" >&nbsp;
        			  <textarea rows='5' cols='100' name='car_b' readonly><%=car.get("CAR_B")==null?"":car.get("CAR_B")%></textarea>        			  
        			</td>
    		    </tr>    	
    		    <tr>
        		    <td class='title'>���û��</td>
        			<td colspan="3" >&nbsp;
        			  <input type='text' name="opt" value='<%=car.get("OPT")==null?"":car.get("OPT")%>' size='100' class='whitetext' readonly>
        			</td>
    		    </tr>    	    		   
    		    
    		    <tr>
        		    <td class='title'>����</td>
        			<td>&nbsp;
        			  <input type='text' name="firm_nm" value='<%=car.get("FIRM_NM")==null?"":car.get("FIRM_NM")%>' size='60' class='whitetext' readonly>
        			</td>
        		    <td class='title'>�����н�����</td>
        			<td>&nbsp;
        				<input type='text' name="r_hipass_yn" value='<%=car.get("HIPASS_YN")==null?"":car.get("HIPASS_YN")%>' size='10' class='whitetext' readonly>
          			</td>	
    		    </tr>
		    </table>
	    </td>
    </tr>
	<%if(j==0){%>
	<tr id=tr_cons<%=j%>_3 style="display:<%=display%>">
	    <td align="right">&nbsp;
	    	<!--
			  <span class="b"><a href="javascript:view_car_sh(<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_dgir.gif"  border="0" align=absmiddle></a></span>&nbsp;
			  <span class="b"><a href="javascript:view_car_lh(<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_jgir.gif"  border="0" align=absmiddle></a></span>
			  -->
			  <input type='hidden' name='cons_copy' value=''>	  
	    </td>
	</tr>	
	<%}else{%>
	<tr id=tr_cons<%=j%>_3 style="display:<%=display%>">
	    <td align="right">
	    &nbsp;<input type='text' name="cons_copy" value='' size='2' class='text'>�� Ź�� <a href="javascript:value_copy(<%=j%>)">���뺹��</a>
		&nbsp;/<a href="javascript:value_copy2(<%=j%>)">�պ�</a>
	    </td>
	</tr>	
	<%}%>
	<tr>
	    <td class=h></td>
	</tr>
    <tr id=tr_cons<%=j%>_4 style="display:<%=display%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr><td class=line2 style='height:1'></td></tr>
    		    <tr>
        		    <td colspan="2" class='title'>�Ƿ���</td>
        		    <td >&nbsp;
        			  <select name='req_id'>
                        <option value="">����</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select>
                      &nbsp;
                      �� �Ƿ���
                      <input name="agent_emp_nm" type="text" class="text"  readonly value="" size="12"> 
			<input type="hidden" name="agent_emp_id" value="">
			<a href="javascript:Agent_User_search('agent_emp_id', <%=j%>);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>						 
        			</td>
        		    <td colspan="2" class='title'>Ź�۱���</td>
        		     <td>&nbsp;        		    
        		    <!-- ������ ��� �ʼ����� : ��� setting -->
        			  <select name="cmp_app">
        			        <option value=''>Ź�۱����� �����ϼ���</option>
							</select>
        			     </td>
    	        </tr>				
    		    <tr>
        		    <td colspan="2" class='title'>Ź�ۻ���</td>
        		    <td colspan="4">&nbsp;
        			  <select name="cons_cau" id="cons_cau<%=j%>" onChange="javascript:cng_input4(this.value, <%=j%>)">
        			    <option value="">����</option>
        				<%for(int i = 0 ; i < c_size ; i++){
        					CodeBean code = codes[i];	%>
        				<option value='<%=code.getNm_cd()%>' <%if(cons_cau.equals(code.getNm_cd()))%>selected<%%>><%= code.getNm()%></option>
        				<%}%>
          			  </select>
        			  &nbsp;��Ÿ���� : <input type='text' name="cons_cau_etc" value='' size='40' class='text'>
        			  &nbsp;<font color="#666666">(�ѱ� 25�� �̳�)</font>
        			  <input type="button" id="search" name="search" onclick="" value="����� ��ȸ" style="display:none">
        			  <span id="car_no_text" name="car_no_text" style="display:none">����� ���� ��ȣ</span> 
        			  <input type="text" id="sub_car_no" name="sub_car_no" class="text" value="" style="display:none" onclick="test()" readonly>
        			  <input type="text" id="sub_rent_l_cd" name="sub_rent_l_cd" class="sub_rent_l_cd" style="display:none">
        			  <input type="text" id="age_scp" name="age_scp" class="age_scp" style="display:none">
        			</td>
    	        </tr>
    		    <tr>
        		    <td colspan="2" class='title'>��뱸��</td>
        			<td>&nbsp;
        			  <select name="cost_st">
        			    <option value="">����</option>
        			    <option value="1" <%if(cost_st.equals("1"))%>selected<%%>>�Ƹ���ī</option>
        			    <option value="2" <%if(cost_st.equals("2"))%>selected<%%>>��</option>								
          			  </select>
        			  &nbsp;<font color=red>[���δ�]Ź�۷� : <input type='text' name="cust_amt" value='0' size='7' class='rednum' onBlur='javascript:this.value=parseDecimal(this.value);'>��</font>
        			</td>						
        		    <td colspan="2" class='title'>���ޱ���</td>
        			<td>&nbsp;
        			  <select name="pay_st">
        			    <option value="">����</option>
        			    <option value="1" <%if(pay_st.equals("1"))%>selected<%%>>����</option>
        			    <option value="2" <%if(pay_st.equals("2"))%>selected<%%>>�ĺ�</option>								
          			  </select>
        			</td>						
    	        </tr>
    		    <tr>
        		    <td rowspan="4" class='title'>��<br>
        	        û</td>
        		    <td class='title'>����</td>
        		    <td colspan="4">&nbsp;
        			  <select name="wash_yn">
        			    <option value="Y">��û</option>
        			    <option value="N" selected>����</option>								
          			  </select>
        			</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>����</td>
        		    <td colspan="4">&nbsp;
        			  <select name="oil_yn">
        			    <option value="Y">��û</option>
        			    <option value="N" selected>����</option>								
          			  </select>
        				������û�� -&gt; 
        			  <input type='text' name="oil_liter" value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				����<!--��--> 
        				Ȥ��
        			  <input type='text' name="oil_est_amt" value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				����ġ ���� ���ּ���.</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>�����н����</td>
        		    <td colspan="4">&nbsp;
        			  <select name="hipass_yn">
        			    <option value="Y">��û</option>
        			    <option value="N" selected>����</option>								
          			  </select>
					  (��ϴ��� �Ƿڽ� �����Ͻʽÿ�.)
        			</td>
    	        </tr>				
    		    <tr>
        		    <td class='title'>��Ÿ</td>
        		    <td colspan="4">&nbsp;
                      <textarea rows='5' cols='90' name='etc' style="color:red"></textarea></td>
    	        </tr>		  
    		    <tr>
        		    <td width="3%" rowspan="6" class='title'>��<br>��</td>
        		    <td width="10%" class='title'>����</td>
        		    <td width="37%">&nbsp;
        			  <select name="from_st" style="width:150px;" onChange="javascript:cng_input3('from', this.value, <%=j%>)">
        			    <option value="">����</option>
        			    <option value="1">�Ƹ���ī</option>
        			    <option value="2">��</option>
        			    <option value="3">���¾�ü</option>
        			    <option value="4">�������</option>				
          			  </select>		
        			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        		    <td width="3%" rowspan="6" class='title'>��<br>��</td>
        		    <td width="10%" class='title'>����</td>
        		    <td width="37%">&nbsp;
        			  <select name="to_st" style="width:150px;" onChange="javascript:cng_input3('to', this.value, <%=j%>)">
        			    <option value="">����</option>
        			    <option value="1">�Ƹ���ī</option>
        			    <option value="2">��</option>
        			    <option value="3">���¾�ü</option>				
          			  </select>			
        			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>			
    		    </tr>
    		    <tr>
        		    <td width="10%" class='title'>���</td>
        		    <td>&nbsp;
                        <input type='text' name="from_place" id="from_place" value='' size='40' class='text' ></td>
        		    <td width="10%" class='title'>���</td>
        		    <td>&nbsp;
                        <input type='text' name="to_place" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>��ȣ/����</td>
        		    <td>&nbsp;
                        <input type='text' name="from_comp" id="from_comp" value='' size='40' class='text' >
        				</td>
        		    <td class='title'>��ȣ/����</td>
        		    <td>&nbsp;
                        <input type='text' name="to_comp" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>�����</td>
        	        <td>&nbsp;�μ�/����
        	          <input type='text' name="from_title" id="from_title" value='' size='20' class='text' ><br>
                      &nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type='text' name="from_man" id="from_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        		    <td class='title'>�����</td>
        		    <td>&nbsp;�μ�/����
        		      <input type='text' name="to_title" value='' size='20' class='text' ><br>
        			  &nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  <input type='text' name="to_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>����ó</td>
        		    <td>&nbsp;�繫��
                        <input type='text' name="from_tel" id="from_tel" value='' size='15' class='text' ><br>
        				&nbsp;�ڵ���
                        <input type='text' name="from_m_tel" id="from_m_tel" value='' size='15' class='text' >
        			</td>
        		    <td class='title'>����ó</td>
        		    <td>&nbsp;�繫��
                        <input type='text' name="to_tel" value='' size='15' class='text' ><br>
        				&nbsp;�ڵ���
                        <input type='text' name="to_m_tel" value='' size='15' class='text' >
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>��û�Ͻ�</td>
        		    <td>&nbsp;
                      <input type='text' name="from_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_req_dt[<%=j%>].value=this.value;'>
                      &nbsp;
        			  <select name="from_req_h" onchange="javascript:document.form1.to_req_h[<%=j%>].value=this.value;">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="from_req_s" onchange="javascript:document.form1.to_req_s[<%=j%>].value=this.value;">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
        		    <td class='title'>��û�Ͻ�</td>
        		    <td>&nbsp;
                      <input type='text' name="to_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;
        			  <select name="to_req_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="to_req_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
    	        </tr>
    		    <tr>
        		    <td colspan="2" class='title'>�����ڸ�</td>
                    <td>&nbsp;
                        <input type='text' name="driver_nm" value='' size='15' class='text' >
        				<input type='hidden' name="driver_id" value=''>
        				<span class="b"><a href="javascript:cng_input6('driver','3',<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif" align="absbottom" border="0"></a></span>
        			</td>
                    <td colspan="2" class='title'>�������ڵ���</td>
                    <td>&nbsp;
                        <input type='text' name="driver_m_tel" value='' size='15' class='text' ></td>
    	        </tr>
				
            </table>
        </td>
    </tr>
<!--
	<tr id=tr_cons<%=j%>_5 style='display:<%=display%>'>
	    <td>&nbsp;</td>
	</tr>		
-->	
	<%}%>	
	<tr>
	    <td align="center">&nbsp;<a href="javascript:window.save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;	
	
	
	<%if(!cons_mm.getMm_seq().equals("")){%>
	set_cons_mm('<%=cons_mm.getMm_seq()%>', '<%=AddUtil.ChangeDate2(cons_mm.getMm_cons_dt())%>', '<%=cons_mm.getMm_car_no1()%>', '<%=cons_mm.getMm_car_no2()%>', '<%=cons_mm.getMm_req_nm()%>', '<%=cons_mm.getReg_id()%>');
	<%}%>
	
	function set_cons_mm(seq, cons_dt, car_no1, car_no2, req_nm, reg_id) {
		fm.mm_seq.value 		= seq;
		fm.cons_kd.checked 	= true;
		fm.after_yn.checked 	= true;
		if(car_no2 == ''){//��
			cng_input(1);
			fm.cons_su.value 		= '1';	
			fm.cons_st[0].checked 	= true;
								
			fm.car_no[0].value 		= car_no1;
			fm.req_id[0].value 		= req_nm;
			fm.from_req_dt[0].value = cons_dt;
			fm.to_req_dt[0].value 	= cons_dt;
		
		}else{//�պ�
			cng_input(2);		
			fm.cons_su.value 		= '2';			
			fm.cons_st[1].checked 	= true;	
			
			fm.car_no[0].value 		= car_no1;
			fm.req_id[0].value 		= req_nm;
			fm.from_req_dt[0].value = cons_dt;
			fm.to_req_dt[0].value 	= cons_dt;
			
			fm.car_no[1].value 		= car_no2;		
			fm.req_id[1].value 		= req_nm;	
			fm.from_req_dt[1].value = cons_dt;
			fm.to_req_dt[1].value 	= cons_dt;
		}
		if(reg_id == '000094'){
			fm.off_nm.value = '�ڸ���Ź��';
			fm.off_id.value = '003524';
		}else if(reg_id == '000223'){
			fm.off_nm.value = '(��)�Ƹ���Ź��';
			fm.off_id.value = '009217';
		}else if(reg_id == '000263'){
			fm.off_nm.value = '������TS';
			fm.off_id.value = '010255';			
		}else if(reg_id == '000127'){
			fm.off_nm.value = '�ڸ���Ź��(�λ�)';
			fm.off_id.value = '004107';
		//}else if(reg_id == '000196'){
		//	fm.off_nm.value = '�ϵ�����(�λ�)';
		//	fm.off_id.value = '008411';
		}
	}
//-->
</script>
</body>
</html>