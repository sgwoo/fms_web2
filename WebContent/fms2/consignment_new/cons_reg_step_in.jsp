<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.user_mng.*"%>
<%@ page import="acar.tint.*"%>
<%@ page import="acar.consignment.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "22", "01");	
	
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
	
	if(from_page.equals("/fms2/car_pur/pur_doc_u.jsp") && !rent_l_cd.equals(""))	car1 = t_db.getUseLcCont("", rent_l_cd);
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
//	CodeBean[] codes2 = c_db.getCodeAll_0022("0022");	
//	int c_size2 = codes2.length;
			
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
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//길이구하기
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

//길이구하기
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

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	

	//탁송업체 조회
	function search_off()
	{
		var fm = document.form1;	
		window.open("/acar/cus0601/cus0602_frame.jsp?from_page=/fms2/consignment_new/cons_i_c.jsp&t_wd="+fm.off_nm.value, "SERV_OFF", "left=10, top=10, width=900, height=650, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//탁송업체 보기
	function view_off()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("선택된 탁송업체가 없습니다."); return;}
		window.open("/acar/cus0601/cus0602_d_frame.jsp?from_page=/fms2/consignment_new/cons_i_c.jsp&off_id="+fm.off_id.value, "SERV_OFF", "left=10, top=10, width=900, height=260, scrollbars=yes, status=yes, resizable=yes");
	}		
		
	//자동차 조회
	function search_car(idx)
	{
		var fm = document.form1;
		window.open("/tax/pop_search/s_car.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&s_kd=2&t_wd="+fm.car_no[idx].value+"&idx="+idx, "CAR", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//배반차자동차조회
	function search_car_res(idx)
	{
		var fm = document.form1;
		window.open("/tax/pop_search/s_car_res.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&s_kd=5&t_wd="+fm.req_id[idx].options[fm.req_id[idx].selectedIndex].text+"&idx="+idx, "CAR_RES", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//회수 리스트 보기
	function search_car_back()
	{
		var fm = document.form1;
		window.open("cons_rec_back_list.jsp", "REC_BACK_LIST", "left=10, top=10, width=1200, height=600, scrollbars=yes, status=yes, resizable=yes");
		
	}
		
	//자동차 보기
	function view_car(idx)
	{
		var fm = document.form1;
		//if(fm.off_id.value == ""){ alert("선택된 탁송업체가 없습니다."); return;}
		if(fm.car_mng_id[idx].value == ""){ alert("선택된 자동차가 없습니다."); return;}	
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_mng_id="+fm.car_mng_id[idx].value+"&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}			

	//차종내역 보기
	function view_car_nm(idx){
		var fm = document.form1;
		if(fm.car_mng_id[idx].value == ""){ alert("선택된 자동차가 없습니다."); return;}	
		window.open("/acar/car_mst/car_mst_u.jsp?rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value, "VIEW_CAR_NM", "left=20, top=20, width=875, height=650, scrollbars=yes");		
	}

	//자동차 단기이력 보기
	function view_car_sh(idx)
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("선택된 탁송업체가 없습니다."); return;}
		if(fm.car_mng_id[idx].value == ""){ alert("선택된 자동차가 없습니다."); return;}	
		window.open("/fms2/lc_rent/view_res_sub.jsp?c_id="+fm.car_mng_id[idx].value+"&auth_rw="+fm.auth_rw.value+"&cmd=ud", "VIEW_CAR_RES", "left=100, top=100, width=850, height=450, scrollbars=yes");
	}			
	//자동차 장기이력 보기
	function view_car_lh(idx)
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("선택된 탁송업체가 없습니다."); return;}
		if(fm.car_mng_id[idx].value == ""){ alert("선택된 자동차가 없습니다."); return;}	
		window.open("/acar/off_lease/off_lease_car_his.jsp?car_mng_id="+fm.car_mng_id[idx].value+"&auth_rw="+fm.auth_rw.value+"&cmd=ud", "VIEW_CAR_RES", "left=100, top=100, width=850, height=450, scrollbars=yes");
	}		

	//탁송구분에 따른 셋팅
	function cng_input_kd(cons_kd){
		var fm = document.form1;
		
		if(cons_kd == 1){
			fm.off_id.value = '';
			fm.off_nm.value = '';		
		}else{
		//	fm.off_id.value = '003158';
		//	fm.off_nm.value = '(주)아마존카';	
			fm.off_id.value = '';
			fm.off_nm.value = '';				
		}		
	}	

	function cng_code_22(){
		var fm = document.form1;

		drop_deposit();
		
		fm.target='i_no';
		fm.action='/fms2/consignment_new/get_code_22t_nodisplay.jsp?off_id='+fm.off_id.value;
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
	
	//탁송구분에 따른 셋팅
	function cng_input(cons_su){
		var fm = document.form1;
		
		fm.cons_su.value = cons_su;
		
//		var cons_su = toInt(fm.cons_su.value);
		
		cng_input2(cons_su);
	}	
	
	//차량대수에 따른 디스플레이
	function cng_input2(cons_su){
		var fm = document.form1;		
		
		var cons_su = toInt(cons_su);
			
		if(cons_su >2){
			alert('입력가능한 최대건수는2건 입니다.');
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
	
	//출발/도착 구분에 따른 팝업
	function cng_input3(st, value, idx){
		var fm = document.form1;		
		var width = 600;
		var firm_nm = '';				
		var req_id 	= fm.req_id.value;
		var s_kd 	= '1';
				
		if(st == 'from' && fm.from_st[idx].value == ''){		alert('출발 구분을 선택하십시오.'); 	return;		}
		if(st == 'to' && fm.to_st[idx].value == ''){			alert('도착 구분을 선택하십시오.'); 	return;		}

		if(value == '2'){ 
			width 	= 800;
			firm_nm = fm.firm_nm[idx].value;
			if(firm_nm == '아마존카' || firm_nm == '(주)아마존카'){
				firm_nm = fm.car_no[idx].value;
				s_kd = '2';
			}
		}
		
		window.open("s_place.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&req_id="+req_id, "PLACE", "left=10, top=10, width="+width+", height=400, scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//출발/도착 담당자 조회
	function cng_input5(st, value, idx){
		var fm = document.form1;		
		var width = 600;
		var firm_nm = '';
		
		if(st == 'from' && fm.from_st[idx].value == ''){		alert('출발 구분을 선택하십시오.'); 	return;		}
		if(st == 'to' && fm.to_st[idx].value == ''){			alert('도착 구분을 선택하십시오.'); 	return;		}

		if(st == 'from')		firm_nm 	= fm.from_comp[idx].value;
		if(st == 'to')			firm_nm 	= fm.to_comp[idx].value;
		
		if(firm_nm == ''){ 		alert('구분을 선택하여 장소를 먼저 선택하여 주십시오.'); 	return; }
		
		if(value == '1') 		firm_nm 	= replaceString('(주)아마존카 ','',firm_nm);
		
		if(value == '3'){		alert('협력업체는 담당자 검색이 없습니다.');	return; }
		
		window.open("s_man.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd=1&t_wd="+firm_nm+"&rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_no="+fm.car_no[idx].value, "MAN", "left=10, top=10, width="+width+", height=500, scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//탁송사유별 셋팅
	function cng_input4(value, idx){
		var fm = document.form1;		
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
			fm.etc[idx].value = "주유등에 불이 들어오면 반드시 1만원 충전을 해주시기 바랍니다.";
		}else{
			fm.etc[idx].value = "";
		}
	}				
	
	//운전자 조회
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
			window.open("s_man.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&cons_dt="+fm.from_req_dt[0].value, "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");					
		}else{
			window.open("s_man.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm, "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
		}		
	}			
	
	//탁송내용 복사하기
	function value_copy(idx){
		var fm = document.form1;
		
			
		//원본데이타 번호
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
	
	//탁송내용 복사하기 - 왕복처리
	function value_copy2(idx){
		var fm = document.form1;
		
		
		//원본데이타 번호
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
		
		if(fm.off_id.value == "")	{ 	alert("선택된 탁송업체가 없습니다."); 	return;	}
//		if(fm.cons_su.value == "")	{ 	alert("차량대수를 입력하십시오."); 		return;	}
//		if(fm.cons_su.value == "0")	{ 	alert("차량대수를 입력하십시오."); 		return;	}

		
	//	if(fm.off_id.value == '003158'){  //아마존카 자체탁송
		
	//		if(fm.cmp_app.value == "" || fm.cmp_app.value == "S00" || fm.cmp_app.value == "D00" || fm.cmp_app.value == "B00"){	alert('탁송구간을 선택하십시오.');	return;}
	//	}
		
		if(fm.off_id.value == '002740' || fm.off_id.value == '003158' || fm.off_id.value == '009217'){  //전국탁송, 아마존카, 아마존탁송 인 경우 필수
			if(fm.cons_st[0].checked == true){ 	
		//		alert(fm.cmp_app[0].value);
				if(fm.cmp_app[0].value == "" || fm.cmp_app[0].value == "S00" || fm.cmp_app[0].value == "D00" || fm.cmp_app[0].value == "B00"){	alert('탁송구간을 선택하십시오.');	return;}
		    	} else {
				if(fm.cmp_app[0].value == "" || fm.cmp_app[0].value == "S00" || fm.cmp_app[0].value == "D00" || fm.cmp_app[0].value == "B00"){	alert('탁송구간1을 선택하십시오.');	return;}
				if(fm.cmp_app[1].value == "" || fm.cmp_app[1].value == "S00" || fm.cmp_app[1].value == "D00" || fm.cmp_app[1].value == "B00"){	alert('탁송구간2을 선택하십시오.');	return;}
			}
		}
		
		if(fm.cons_st[1].checked == true && size < 2){ 	alert('왕복인 경우 최소 차량대수는 2대입니다.'); return;}
		
		for(i=0; i<size ; i++){
			
			if(fm.car_no[i].value == ""||fm.car_no[i].value.length <= 4) 		{ 	alert((i+1)+"번 탁송 : 선택된 차량이 없습니다. 차량번호를 전부 입력하세요. 없으면 차대번호를 직접 입력하세요");	return;	}
			if(fm.rent_l_cd[i].value == "") 	{ 	alert((i+1)+"번 탁송 : 차량조회가 되지 않았습니다.");		return;	}
			if(fm.req_id[i].value == "")		{ 	alert((i+1)+"번 의뢰자를 입력하십시오."); 		return;	}	
			if(fm.cons_cau[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 탁송사유를 입력하십시오."); 			return;	}
			if(fm.cons_cau[i].value == "20" && fm.cons_cau_etc[i].value == "") { 	alert((i+1)+"번 탁송 : 탁송사유 기타를 입력하십시오."); 	return;	}
			if(fm.cost_st[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 비용구분을 선택하십시오."); 			return;	}
			if(fm.cost_st[i].value == "2" && fm.cust_amt[i].value == "0") 		{ 	alert((i+1)+"번 탁송 : 고객부담 탁송료를 입력하십시오."); 	return;	}
			if(fm.pay_st[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 지급구분을 선택하십시오."); 			return;	}
			//if(fm.from_st[i].value == "") 		{ 	alert(i+"번 탁송 : 출발-구분을 선택하십시오."); 		return;	}
			if(fm.from_place[i].value == "") 	{ 	alert((i+1)+"번 탁송 : 출발-장소를 입력하십시오."); 		return;	}
			if(fm.from_comp[i].value == "") 	{ 	alert((i+1)+"번 탁송 : 출발-상호/성명을 입력하십시오."); 	return;	}
			if(fm.from_req_dt[i].value == "" || fm.from_req_h[i].value == "" || fm.from_req_s[i].value == "") 	{ 	alert((i+1)+"번 탁송 : 출발-요청일시를 입력하십시오."); 	return;	}
			//if(fm.to_st[i].value == "") 		{ 	alert(i+"번 탁송 : 도착-구분을 선택하십시오."); 		return;	}
			if(fm.to_place[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 도착-장소를 입력하십시오."); 		return;	}
			if(fm.to_comp[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 도착-상호/성명을 입력하십시오."); 	return;	}
			if(fm.to_req_dt[i].value == "" || fm.to_req_h[i].value == "" || fm.to_req_s[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 도착-요청일시를 입력하십시오."); 	return;	}		
			if(fm.off_id.value == '003158'){
				if(fm.driver_nm[i].value != "" && fm.driver_id[i].value == "") { 	alert((i+1)+"번 탁송 : 운전자를 조회하여 선택하십시오."); 	return;	}
			}
		}
		
		cut_length("[탁송지원요청]"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"시/출발:"+fm.from_place[0].value+"/도착:"+fm.to_place[0].value,100);
		cut_length2("[탁송]"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"시/출발:"+fm.from_place[0].value+"/도착:"+fm.to_place[0].value,100);		
			
		if(confirm('등록하시겠습니까?')){		
			fm.action='cons_reg_step1_a.jsp';
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
		}		
	}
	
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') {
			if(nm == 'car_no')	search_car(idx);
		}
	}	


//디스플레이 타입-신차일경우 체크
function cng_input1() {
	var fm = document.form1;
if(fm.s_car.checked == true && fm.after_yn.checked == false){
 gubun.style.display = "";
}else{
 gubun.style.display = "none";
}
}

	function AncDisp(bbs_id){
		var SUBWIN="/acar/off_anc/anc_c.jsp?from_page=/fms2/off_anc/upgrade_frame.jsp&bbs_id=" + bbs_id;	
		window.open(SUBWIN, "AncDisp", "left=10, top=10, width=650, height=750, scrollbars=yes");
	}

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
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 탁송관리 > <span class=style5>탁송의뢰등록</span></span></td>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사전전화요청</span>		
		</td>
	</tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>차량번호</td>
                    <td>&nbsp;<%=cons_mm.getMm_car_no1()%>, <%=cons_mm.getMm_car_no2()%></td>	
                </tr>	
                <tr> 					
                    <td class='title'>의뢰내용</td>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사전전화요청 미등록 리스트</span>		
		</td>
	</tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
				  <td width='5%' class='title'>연번</td>
				  <td width='5%' class='title'>선택</td>				  
				  <td width='15%' class='title'>탁송업체</td>
		          <td width='10%' class='title'>탁송일자</td>														  
				  <td width='15%' class='title'>차량번호</td>
				  <td width='50%' class='title'>의뢰내용</td>					
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
	    <td><font color="green">* 탁송업체에서 사전전화요청을 등록하였으나, 탁송연결이 안된 것이 위의 리스트에 있습니다. 선택버튼을 클릭하면 해당 내용으로 입력이 됩니다.</font></td>
	</tr>	
	<tr>
	    <td><font color="green">* 사전전화요청에 대해서는 <a href="javascript:AncDisp('1994');">2010-06-08 [탁송등록에관한 간편처리방안]</a>이란 제목으로 업그레이드정보에 공지되어 있습니다.</font></td>
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
                    <td width='13%' class='title'>탁송분류</td>
                    <td colspan="3">&nbsp;
        			  <input type='radio' name="cons_kd" value='1' onClick="javascript:cng_input_kd(1)" checked>
        				외주
        			  <!--<input type='radio' name="cons_kd" value='2' onClick="javascript:cng_input_kd(2)">
        				자체 -->
        			</td>	
                </tr>		
                <tr> 
                    <td width='13%' class='title'>탁송업체</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' name="off_nm" value='' size='30' class='text'><!--(주)아마존카-->
        			  <input type='hidden' name='off_id' value=''><!--003158-->
        			  <span class="b"><a href="javascript:search_off()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			  <span class="b"><a href="javascript:view_off()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_see.gif"  border="0" align=absmiddle></a></span>
        			</td>
                </tr>
                
                <tr> 
                    <td width='13%' class='title'>탁송구분</td>
                    <td  colspan="3">&nbsp;
        			  	<input type='radio' name="cons_st" value='1' onClick="javascript:cng_input(1)" <%if(car_mng_id.equals(""))%>checked<%%>>편도
        			  	<input type='radio' name="cons_st" value='2' onClick="javascript:cng_input(2)" <%if(!car_mng_id.equals("") && !sub_c_id.equals(""))%>checked<%%>>왕복&nbsp;
        				<span class="b"><a href="javascript:search_car_back()" onMouseOver="window.status=''; return true" title="클릭하세요">[회수]</a></span>
        				<input type='hidden' name='cons_su' <%if(!car_mng_id.equals("") && !sub_c_id.equals("")){%>value='2'<%}else{%>value='1'<%}%>>
        			</td>	
        			<!--	  
                    <td width='13%' class='title'>차량대수</td>
                    <td width="37%">&nbsp;
                      <input type='text' name="cons_su" value='1' size='2' class='text' onBlur='javscript:cng_input2(this.value);'>
                    &nbsp;건</td>
        			-->
                </tr>
                <tr> 
                    <td width='13%' class='title'>사후입력여부</td>
                    <td >&nbsp;
					<input type="checkbox" name="after_yn" value="Y" onClick="Javascript:cng_input1()">
        			  (탁송완료건 사후입력일때)</td>

        			<td width='15%' class='title' style='height:32'>신차등록후 문자전송여부</td>
                    <td >&nbsp;
        			<input type="checkbox" name="s_car" value="Y" onClick="Javascript:cng_input1()">
        			  (차량등록이 안된 신차 탁송의뢰를 입력한 경우에만 체크하세요.)</td>

                </tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ <b>자체탁송일 경우에 탁송회사는 (주)아마존카가 되며, 운전자에 탁송수행자(본사직원)를 입력</b>하시기 바랍니다.</font></td>
	</tr>	
	<!--					
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 등록할수 있는 최대건수는 10건이며 편도와 왕복을 같이 등록할 수는 없습니다.</font> </td>
	</tr>	
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ <b>왕복</b> 1건일때는 "차량대수" <b>2건</b>으로 입력해야 합니다.</font> </td>
	</tr>	
	-->
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ <b>미등록차량일때는 상호로 조회하고 예정차량번호나 차대번호를 직접 입력하십시오.</b></font> </td>
	</tr>	
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 운전자 지정 등은 "요청-기타"에 입력하십시오.</font></td>
	</tr>					
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 이미 <b>탁송 완료</b>되어 후등록하는 경우에는 "요청-<b>기타</b>"에 내용을 입력해 주세요.</font></td>
	</tr>					
	<!--
	<tr>
	  <td><font color=#666666>&nbsp;※ 5월19일부터는 FMS 등록없이 전화로 의뢰하여 이미 탁송이 이루어진 경우에도 꼭 등록하십시오. 이 경우일 때는 "요청-기타"에 이미 탁송처리된 것을 명시하여야 합니다.</font></td>
	</tr>
	-->
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 명진공업사 입/출고일 경우 출발/도착구분을 "협력업체"로 하여 검색하십시오.</font></td>
	</tr>					
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ <b>출발/도착 내용은 직접 입력</b>하셔도 됩니다.</font></td>
	</tr>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ <b>사후입력여부</b>에 체크되면 탁송업체 및 당사직원에게 발송하던 문자메세지가 전송되지 않습니다.</font></td>
	</tr>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ <b>1번 탁송 의뢰자가 전자문서에 의뢰자, 확인자로 들어간다.</b></font></td>
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
            	       				<td align="center" class='title' width=13% rowspan=2>문자수신자</td>
                					<td>&nbsp; <input type='checkbox' name='f_man' value='Y'>담당자&nbsp; &nbsp;&nbsp;<input type='checkbox' name='d_man' value='Y'>탁송업체&nbsp; </td>
                				</tr>
                    			<tr>
            					    <td style='height:35'><font color=blue>&nbsp;&nbsp; ※ 차량등록이 완료된 후에 차량등록자 또는 내근자가 메세지보내기를 하여야 메세지가 전송됩니다.<br>
                                    &nbsp;&nbsp; ※ 왕복 탁송인 경우 항상 [탁송 1]에 신차탁송 정보를 입력하여 주시기 바랍니다.</font></td>
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
			display = "";
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
				display = "";
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
	<tr id=tr_cons<%=j%>_1 style='display:<%=display%>'>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>탁송<%=j+1%></span>
		
		</td>
	</tr>
    <tr id=tr_cons<%=j%>_2 style='display:<%=display%>'> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr><td class=line2 style='height:1'></td></tr>
				<%	
					
				%>
                <tr> 
                    <td width='13%' class='title'>차량번호/차대번호</td>
                    <td width='37%'>&nbsp;
        			  <input type='text' name="car_no" value='<%=car.get("CAR_NO")==null?"":car.get("CAR_NO")%>' size='25' class='text' onKeyDown="javasript:enter('car_no', <%=j%>)">
        			  <input type='hidden' name='car_mng_id' value='<%=car.get("CAR_MNG_ID")==null?"":car.get("CAR_MNG_ID")%>'>
        			  <input type='hidden' name='rent_mng_id' value='<%=car.get("RENT_MNG_ID")==null?"":car.get("RENT_MNG_ID")%>'>
        			  <input type='hidden' name='rent_l_cd' value='<%=car.get("RENT_L_CD")==null?"":car.get("RENT_L_CD")%>'>
        			  <input type='hidden' name='client_id' value='<%=car.get("CLIENT_ID")==null?"":car.get("CLIENT_ID")%>'>
        			    <span class="b"><a href="javascript:search_car(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
						&nbsp;&nbsp;&nbsp;		
						<span class="b"><a href="javascript:search_car_res(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요">[배/반차 차량 조회]</a></span>
        			</td>
        			<td width='13%' class='title'>차명</td>
        			<td width='37%'>&nbsp;
        			  <input type='text' name="car_nm" value='<%=car.get("CAR_NM")==null?"":car.get("CAR_NM")%> <%=car.get("CAR_NAME")==null?"":car.get("CAR_NAME")%>' size='40' class='whitetext' readonly>
        			  <span class="b"><a href="javascript:view_car(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_see.gif"  border="0" align=absmiddle></a></span>
        			  </td>
                </tr>
    		    <tr>
        		    <td class='title'>연식</td>
        			<td>&nbsp;
        			  <input type='text' name="car_y_form" value='<%=car.get("CAR_Y_FORM")==null?"":car.get("CAR_Y_FORM")%>' size='40' class='whitetext' readonly>
        			</td>
        		    <td class='title'>색상</td>
        			<td>&nbsp;
        			  <input type='text' name="color" value='<%=car.get("COLO")==null?"":car.get("COLO")%>' size='40' class='whitetext' readonly></td>			
    		    </tr>
    		    
    		    <tr>
        		    <td class='title'>기본사양</td>
        			<td colspan="3" >&nbsp;
        			  <textarea rows='5' cols='100' name='car_b' readonly><%=car.get("CAR_B")==null?"":car.get("CAR_B")%></textarea>        			  
        			</td>
    		    </tr>    	
    		    <tr>
        		    <td class='title'>선택사양</td>
        			<td colspan="3" >&nbsp;
        			  <input type='text' name="opt" value='<%=car.get("OPT")==null?"":car.get("OPT")%>' size='100' class='whitetext' readonly>
        			</td>
    		    </tr>    	    		   
    		    
    		    <tr>
        		    <td class='title'>고객명</td>
        			<td>&nbsp;
        			  <input type='text' name="firm_nm" value='<%=car.get("FIRM_NM")==null?"":car.get("FIRM_NM")%>' size='60' class='whitetext' readonly>
        			</td>
        		    <td class='title'>하이패스여부</td>
        			<td>&nbsp;
        				<input type='text' name="r_hipass_yn" value='<%=car.get("HIPASS_YN")==null?"":car.get("HIPASS_YN")%>' size='10' class='whitetext' readonly>
          			</td>	
        				  <!--
        		    <td class='title'>신차여부</td>
        			<td>&nbsp;
        				<input type='hidden' name="car_gu" value='<%=car.get("CAR_GU")==null?"":car.get("CAR_GU")%>' id="cargu" size='40' class='whitetext'>
        				<input type='hidden' name="shin_car" value='<%=car.get("SHIN_CAR")==null?"":car.get("SHIN_CAR")%>' id="shincar" size='40' class='whitetext'  >
          			</td>
          			-->
    		    </tr>
		    </table>
	    </td>
    </tr>
	<%if(j==0){%>
	<tr id=tr_cons<%=j%>_3 style='display:<%=display%>'>
	    <td align="right">&nbsp;
			  <span class="b"><a href="javascript:view_car_sh(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_dgir.gif"  border="0" align=absmiddle></a></span>&nbsp;
			  <span class="b"><a href="javascript:view_car_lh(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_jgir.gif"  border="0" align=absmiddle></a></span>
			  <input type='hidden' name='cons_copy' value=''>	  
	    </td>
	</tr>	
	<%}else{%>
	<tr id=tr_cons<%=j%>_3 style='display:<%=display%>'>
	    <td align="right">
	    &nbsp;<input type='text' name="cons_copy" value='' size='2' class='text'>번 탁송 <a href="javascript:value_copy(<%=j%>)">내용복사</a>
		&nbsp;/<a href="javascript:value_copy2(<%=j%>)">왕복</a>
	    </td>
	</tr>	
	<%}%>
	<tr>
	    <td class=h></td>
	</tr>
    <tr id=tr_cons<%=j%>_4 style='display:<%=display%>'> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr><td class=line2 style='height:1'></td></tr>
    		    <tr>
        		    <td colspan="2" class='title'>의뢰자</td>
        		    <td >&nbsp;
        			  <select name='req_id'>
                        <option value="">선택</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select>
        			</td>
        		    <td colspan="2" class='title'>탁송구간</td>
        		    <td>&nbsp;        		    
        		    <!-- 전국인 경우 필수선택 : 요금 setting -->
        			  <select name="cmp_app">
        			        <option value=''>탁송구간을 선택하세요</option>
        			     </td>
        		
    	        </tr>				
    		    <tr>
        		    <td colspan="2" class='title'>탁송사유</td>
        		    <td colspan="4">&nbsp;
        			  <select name="cons_cau" onChange="javascript:cng_input4(this.value, <%=j%>)">
        			    <option value="">선택</option>
        				<%for(int i = 0 ; i < c_size ; i++){
        					CodeBean code = codes[i];	%>
        				<option value='<%=code.getNm_cd()%>' <%if(cons_cau.equals(code.getNm_cd()))%>selected<%%>><%= code.getNm()%></option>
        				<%}%>
          			  </select>
        			  &nbsp;기타사유 : <input type='text' name="cons_cau_etc" value='' size='40' class='text'>
        			  &nbsp;<font color="#666666">(한글 25자 이내)</font>
        			</td>
    	        </tr>
    		    <tr>
        		    <td colspan="2" class='title'>비용구분</td>
        			<td>&nbsp;
        			  <select name="cost_st">
        			    <option value="">선택</option>
        			    <option value="1" <%if(cost_st.equals("1"))%>selected<%%>>아마존카</option>
        			    <option value="2" <%if(cost_st.equals("2"))%>selected<%%>>고객</option>								
          			  </select>
        			  &nbsp;<font color=red>[고객부담]탁송료 : <input type='text' name="cust_amt" value='0' size='7' class='rednum' onBlur='javascript:this.value=parseDecimal(this.value);'>원</font>
        			</td>						
        		    <td colspan="2" class='title'>지급구분</td>
        			<td>&nbsp;
        			  <select name="pay_st">
        			    <option value="">선택</option>
        			    <option value="1" <%if(pay_st.equals("1"))%>selected<%%>>선불</option>
        			    <option value="2" <%if(pay_st.equals("2"))%>selected<%%>>후불</option>								
          			  </select>
        			</td>						
    	        </tr>
    		    <tr>
        		    <td rowspan="4" class='title'>요<br>
        	        청</td>
        		    <td class='title'>세차</td>
        		    <td colspan="4">&nbsp;
        			  <select name="wash_yn">
        			    <option value="Y">요청</option>
        			    <option value="N" selected>없음</option>								
          			  </select>
        			</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>주유</td>
        		    <td colspan="4">&nbsp;
        			  <select name="oil_yn">
        			    <option value="Y">요청</option>
        			    <option value="N" selected>없음</option>								
          			  </select>
        				주유요청시 -&gt; 
        			  <input type='text' name="oil_liter" value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				리터<!--ℓ--> 
        				혹은
        			  <input type='text' name="oil_est_amt" value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				원어치 주유 해주세요.</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>하이패스등록</td>
        		    <td colspan="4">&nbsp;
        			  <select name="hipass_yn">
        			    <option value="Y">요청</option>
        			    <option value="N" selected>없음</option>								
          			  </select>
					  (등록대행 의뢰시 선택하십시오.)
        			</td>
    	        </tr>				
    		    <tr>
        		    <td class='title'>기타</td>
        		    <td colspan="4">&nbsp;
                      <textarea rows='5' cols='90' name='etc' style="color:red"></textarea></td>
    	        </tr>		  
    		    <tr>
        		    <td width="3%" rowspan="6" class='title'>출<br>발</td>
        		    <td width="10%" class='title'>구분</td>
        		    <td width="37%">&nbsp;
        			  <select name="from_st" onChange="javascript:cng_input3('from', this.value, <%=j%>)">
        			    <option value="">선택</option>
        			    <option value="1">아마존카</option>
        			    <option value="2">고객</option>
        			    <option value="3">협력업체</option>
        			    <option value="4">신차출발</option>				
          			  </select>		
        			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        		    <td width="3%" rowspan="6" class='title'>도<br>착</td>
        		    <td width="10%" class='title'>구분</td>
        		    <td width="37%">&nbsp;
        			  <select name="to_st" onChange="javascript:cng_input3('to', this.value, <%=j%>)">
        			    <option value="">선택</option>
        			    <option value="1">아마존카</option>
        			    <option value="2">고객</option>
        			    <option value="3">협력업체</option>				
          			  </select>			
        			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>			
    		    </tr>
    		    <tr>
        		    <td width="10%" class='title'>장소</td>
        		    <td>&nbsp;
                        <input type='text' name="from_place" value='' size='40' class='text' ></td>
        		    <td width="10%" class='title'>장소</td>
        		    <td>&nbsp;
                        <input type='text' name="to_place" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>상호/성명</td>
        		    <td>&nbsp;
                        <input type='text' name="from_comp" value='' size='40' class='text' >
        				</td>
        		    <td class='title'>상호/성명</td>
        		    <td>&nbsp;
                        <input type='text' name="to_comp" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>담당자</td>
        	        <td>&nbsp;부서/직위
        	          <input type='text' name="from_title" value='' size='20' class='text' ><br>
                      &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type='text' name="from_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        		    <td class='title'>담당자</td>
        		    <td>&nbsp;부서/직위
        		      <input type='text' name="to_title" value='' size='20' class='text' ><br>
        			  &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  <input type='text' name="to_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>연락처</td>
        		    <td>&nbsp;사무실
                        <input type='text' name="from_tel" value='' size='15' class='text' ><br>
        				&nbsp;핸드폰
                        <input type='text' name="from_m_tel" value='' size='15' class='text' >
        			</td>
        		    <td class='title'>연락처</td>
        		    <td>&nbsp;사무실
                        <input type='text' name="to_tel" value='' size='15' class='text' ><br>
        				&nbsp;핸드폰
                        <input type='text' name="to_m_tel" value='' size='15' class='text' >
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>요청일시</td>
        		    <td>&nbsp;
                      <input type='text' name="from_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_req_dt[<%=j%>].value=this.value;'>
                      &nbsp;
        			  <select name="from_req_h" onchange="javascript:document.form1.to_req_h[<%=j%>].value=this.value;">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="from_req_s" onchange="javascript:document.form1.to_req_s[<%=j%>].value=this.value;">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
        		    <td class='title'>요청일시</td>
        		    <td>&nbsp;
                      <input type='text' name="to_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;
        			  <select name="to_req_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="to_req_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
    	        </tr>
    		    <tr>
        		    <td colspan="2" class='title'>운전자명</td>
                    <td>&nbsp;
                        <input type='text' name="driver_nm" value='' size='15' class='text' >
        				<input type='hidden' name="driver_id" value=''>
        				<span class="b"><a href="javascript:cng_input6('driver','3',<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absbottom" border="0"></a></span>
        			</td>
                    <td colspan="2" class='title'>운전자핸드폰</td>
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
	
	 <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>
	<tr>
	    <td align="center">&nbsp;<a href="javascript:window.save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>	
	<% } %>
		
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
		if(car_no2 == ''){//편도
			cng_input(1);
			fm.cons_su.value 		= '1';	
			fm.cons_st[0].checked 	= true;
								
			fm.car_no[0].value 		= car_no1;
			fm.req_id[0].value 		= req_nm;
			fm.from_req_dt[0].value = cons_dt;
			fm.to_req_dt[0].value 	= cons_dt;
		
		}else{//왕복
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
			fm.off_nm.value = '코리아탁송';
			fm.off_id.value = '003524';
		}else if(reg_id == '000223'){
			fm.off_nm.value = '(주)아마존탁송';
			fm.off_id.value = '009217';
		}else if(reg_id == '000263'){
			fm.off_nm.value = '스마일TS';
			fm.off_id.value = '010255';
		}else if(reg_id == '000127'){
			fm.off_nm.value = '코리아탁송(부산)';
			fm.off_id.value = '004107';
		//}else if(reg_id == '000196'){
		//	fm.off_nm.value = '일등전국(부산)';
		//	fm.off_id.value = '008411';
		}
	}
//-->
</script>
</body>
</html>