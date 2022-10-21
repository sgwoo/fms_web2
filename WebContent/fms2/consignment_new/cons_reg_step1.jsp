<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.user_mng.*"%>
<%@ page import="acar.consignment.*, acar.car_register.*, acar.client.*, acar.cont.*, acar.car_mst.*"%>
<%@ page import="acar.tint.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "07", "02", "01");	
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String sub_l_cd 	= request.getParameter("sub_l_cd")==null?"":request.getParameter("sub_l_cd");
	String sub_c_id 	= request.getParameter("sub_c_id")==null?"":request.getParameter("sub_c_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String mm_seq		= request.getParameter("mm_seq")==null?"":request.getParameter("mm_seq");
	
	String off_id 	= request.getParameter("off_id")  ==null?""   :request.getParameter("off_id");
	String off_nm 	= request.getParameter("off_nm")  ==null?""   :request.getParameter("off_nm");
	
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	String cons_su 	= request.getParameter("cons_su")==null?"":request.getParameter("cons_su");
	
	ConsignmentBean b_cons = cs_db.getConsignment(cons_no, 1);
	
	int cons_su_val = b_cons.getCons_su();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
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
	
	
	String display = "";
	String cons_cau = "";
	String cost_st = "";
	String pay_st = "";
	
	ConsignmentBean cons_mm 		= cs_db.getConsignmentMM(mm_seq);
	
	String white = "";
	String disabled = "";
	
%>

<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script> -->
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
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
		window.open("/tax/pop_search/s_car.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&s_kd=2&t_wd="+fm.car_no[idx].value+"&idx="+idx+"&size="+fm.cons_su.value, "CAR", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
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
		window.open("cons_reg_back_list.jsp", "REG_BACK_LIST", "left=10, top=10, width=1200, height=600, scrollbars=yes, status=yes, resizable=yes");	
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
		var br_id = fm.br_id.value;
		var s_kd 	= '1';
	
	   var chk_client = '';			
	   		
		if(st == 'from' && fm.from_st[idx].value == ''){		alert('출발 구분을 선택하십시오.'); 	return;		}
		if(st == 'to' && fm.to_st[idx].value == ''){			alert('도착 구분을 선택하십시오.'); 	return;		}		
	
		
		if( fm.other[idx].value == 'R' ){			     		        
			if(st == 'from' ) {
				fm.from_place[idx].value=''; //초기화 
				fm.from_comp[idx].value='';			
			}
			 
		}
		
		if(value == '2'){ 
			width 	= 800;
			firm_nm = fm.firm_nm[idx].value;
			if(firm_nm == '아마존카' || firm_nm == '(주)아마존카'){
				firm_nm = fm.car_no[idx].value;
				s_kd = '2';
			}
		}
		
		chk_client =  fm.client_id[idx].value;
		
	//	alert(chk_client);
		
		window.open("s_place.jsp?chk_client="+chk_client+"&go_url=/fms2/consignment_new/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&req_id="+req_id+"&br_id="+br_id, "PLACE", "left=10, top=10, width="+width+", height=400, scrollbars=yes, status=yes, resizable=yes");		
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
		
		if(value == "3" || value == "4" || value == "5") {
			$("[name=search]").eq(idx).css('display','inline-block');
			$("[name=sub_car_no]").eq(idx).css('display','inline-block');
			$("[name=car_no_text]").eq(idx).css('display','inline-block');
		} else {
			$("[name=search]").eq(idx).css('display','none');
			$("[name=sub_car_no]").eq(idx).css('display','none');
			$("[name=car_no_text]").eq(idx).css('display','none');
		}
		// 사유 변경 시 sub_l_cd 초기화
		$("[name=sub_rent_l_cd]").eq(idx).val("");
		$("[name=sub_car_no]").eq(idx).val("");
		
		//탁송사유:사고대차회수 시 폼세팅
		view_bondForm(value, idx);
		
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
	
	//탁송내용 복사하기 - 회수관련처리 
	function value_copy3(idx){
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
				
		fm.to_req_dt[idx].value 		= fm.from_req_dt[copy_idx].value;
		fm.to_req_h[idx].value 		= fm.from_req_h[copy_idx].value;
		fm.to_req_s[idx].value 		= fm.from_req_s[copy_idx].value;
			
		fm.from_req_dt[idx].value 	= fm.to_req_dt[copy_idx].value;
		fm.from_req_h[idx].value 	= fm.to_req_h[copy_idx].value;
		fm.from_req_s[idx].value 	= fm.to_req_s[copy_idx].value;
	}		
	
	function save(){
		var fm = document.form1;
		var size = toInt(fm.cons_su.value);
		var vali_switch = true;
		var cons_cau1 = $("#cons_cau0").val(); // 탁송1 사유
		var cons_cau2 = $("#cons_cau1").val(); // 탁송2 사유
			
				
		if($('input:radio[name=cons_st]').eq(0).is(':checked') == true) {
			// 편도
			if(cons_cau1 == "3" || cons_cau1 == "4" || cons_cau1 == "5") {
				if(!$("[name=sub_rent_l_cd]").eq(0).val()) {
					alert("탁송 사유가 지연/정비/사고/대차 인도의 경우 고객 원계약 정보를 선택해야 합니다.");
					return;
				}
			}
		} else {
			// 왕복
			if(cons_cau1 == "3" || cons_cau1 == "4" || cons_cau1 == "5") {
				if(!$("[name=sub_rent_l_cd]").eq(0).val()) {
					alert("탁송 사유가 지연/정비/사고/대차 인도의 경우 고객 원계약 정보를 선택해야 합니다.");
					return;
				}
			}
			
			if(cons_cau2 == "3" || cons_cau2 == "4" || cons_cau2 == "5") {
				if(!$("[name=sub_rent_l_cd]").eq(1).val()) {
					alert("탁송 사유가 지연/정비/사고/대차 인도의 경우 고객 원계약 정보를 선택해야 합니다.");
					return;
				}
			} 
		}
		
		if(fm.off_id.value == "")	{ 	alert("선택된 탁송업체가 없습니다."); 	return;	}
//		if(fm.cons_su.value == "")	{ 	alert("차량대수를 입력하십시오."); 		return;	}
//		if(fm.cons_su.value == "0")	{ 	alert("차량대수를 입력하십시오."); 		return;	}

		
	//	if(fm.off_id.value == '003158'){  //아마존카 자체탁송
		
	//		if(fm.cmp_app.value == "" || fm.cmp_app.value == "S00" || fm.cmp_app.value == "D00" || fm.cmp_app.value == "B00"){	alert('탁송구간을 선택하십시오.');	return;}
	//	}
		
		if(fm.off_id.value == '002740' || fm.off_id.value == '003158' || fm.off_id.value == '009217' || fm.off_id.value == '010255'  ){  //전국탁송, 아마존카, 아마존탁송, 스마일TS ,퍼스트드라이브(대전) 인 경우 필수
			if(fm.cons_st[0].checked == true){ 	
			//	alert(fm.cmp_app[0].value);
				if(fm.cmp_app[0].value == "" || fm.cmp_app[0].value == "S00" || fm.cmp_app[0].value == "D00" || fm.cmp_app[0].value == "B00" || fm.cmp_app[0].value == "C00" || fm.cmp_app[0].value == "E00"  || fm.cmp_app[0].value == "F00"  || fm.cmp_app[0].value == "T00" || fm.cmp_app[0].value == "W00"){	alert('탁송구간을 선택하십시오.');	return;}
		   	} else {
				if(fm.cmp_app[0].value == "" || fm.cmp_app[0].value == "S00" || fm.cmp_app[0].value == "D00" || fm.cmp_app[0].value == "B00" || fm.cmp_app[0].value == "C00" || fm.cmp_app[0].value == "E00"  || fm.cmp_app[0].value == "F00"  || fm.cmp_app[0].value == "T00" || fm.cmp_app[0].value == "W00"){	alert('탁송구간1을 선택하십시오.');	return;}
				if(fm.cmp_app[1].value == "" || fm.cmp_app[1].value == "S00" || fm.cmp_app[1].value == "D00" || fm.cmp_app[1].value == "B00" || fm.cmp_app[1].value == "C00" || fm.cmp_app[1].value == "E00"  || fm.cmp_app[1].value == "F00"  || fm.cmp_app[1].value == "T00" || fm.cmp_app[0].value == "W00"){	alert('탁송구간2을 선택하십시오.');	return;}
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
		
		var cons_st_txt = "편도";
		if (fm.cons_st.value == "2") {
			cons_st_txt = "왕복";
		}
		
		var from_comp_txt = "";
		var to_comp_txt = "";
		
		var from_comp_txt2 = "";
		var to_comp_txt2 = "";
		
		var from_tel_txt = "";
		var to_tel_txt = "";
		
		var from_tel_txt2 = "";
		var to_tel_txt2 = "";
		
		var cons_cau_txt = "";
		var cons_cau_txt2 = "";
		
		var cons_cau_add_txt = "";
		
		if (fm.cons_st.value == "2") {
			//탁송1
			if (fm.from_st[0].value == "2" || fm.from_st[0].value == "3") {
				if (fm.from_m_tel[0].value == "") {
					from_tel_txt = "/연락처:" + fm.from_tel[0].value;
				} else {
					from_tel_txt = "/연락처:" + fm.from_m_tel[0].value;
				}
				from_comp_txt = "/출발 상호:" + fm.from_comp[0].value + from_tel_txt;
			}
			if (fm.to_st[0].value == "2" || fm.to_st[0].value == "3") {
				if (fm.to_m_tel[0].value == "") {
					to_tel_txt = "/연락처:" + fm.to_tel[0].value;
				} else {
					to_tel_txt = "/연락처:" + fm.to_m_tel[0].value;
				}
				to_comp_txt = "/도착 상호:" + fm.to_comp[0].value + to_tel_txt;
			}
			
			cons_cau_txt = cons_cau_change_txt(0, fm.cons_cau[0].value);
			
			//탁송2
			if (fm.from_st[1].value == "2" || fm.from_st[1].value == "3") {
				if (fm.from_m_tel[1].value == "") {
					from_tel_txt2 = "/연락처:" + fm.from_tel[1].value;
				} else {
					from_tel_txt2 = "/연락처:" + fm.from_m_tel[1].value;
				}
				from_comp_txt2 = "/출발 상호:" + fm.from_comp[1].value + from_tel_txt2;
			}
			
			if (fm.to_st[1].value == "2" || fm.to_st[1].value == "3") {
				if (fm.to_m_tel[1].value == "") {
					to_tel_txt2 = "/연락처:" + fm.to_tel[1].value;
				} else {
					to_tel_txt2 = "/연락처:" + fm.to_m_tel[1].value;
				}
				to_comp_txt2 = "/도착 상호:" + fm.to_comp[1].value + to_tel_txt2;
			}
			
			cons_cau_txt2 = cons_cau_change_txt(1, fm.cons_cau[1].value);
			
			//신차가 아닐때 추가문구
			if (fm.cons_cau[0].value != "1" || fm.cons_cau[1].value != "1") {
				cons_cau_add_txt = "//★ 기타사항 ★ 전면유리 사진촬영, 상처부위 사진촬영";
			}
			
		} else {
			
			if (fm.from_st[0].value == "2" || fm.from_st[0].value == "3") {
				if (fm.from_m_tel[0].value == "") {
					from_tel_txt = "/연락처:" + fm.from_tel[0].value;
				} else {
					from_tel_txt = "/연락처:" + fm.from_m_tel[0].value;
				}
				from_comp_txt = "/출발 상호:" + fm.from_comp[0].value + from_tel_txt;
			}
			
			if (fm.to_st[0].value == "2" || fm.to_st[0].value == "3") {
				if (fm.to_m_tel[0].value == "") {
					to_tel_txt = "/연락처:" + fm.to_tel[0].value;
				} else {
					to_tel_txt = "/연락처:" + fm.to_m_tel[0].value;
				}
				to_comp_txt = "/도착 상호:" + fm.to_comp[0].value + to_tel_txt;
			}
			
			cons_cau_txt = cons_cau_change_txt(0, fm.cons_cau[0].value);
			
			//신차가 아닐때 추가문구
			if (fm.cons_cau[0].value != "1") {
				cons_cau_add_txt = "//★ 기타사항 ★ 전면유리 사진촬영, 상처부위 사진촬영";
			}
		}
		
		//cut_length("[탁송지원요청]탁송구분:"+cons_st_txt+"/차량번호:"+fm.car_no[0].value+"/"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"시/출발:"+fm.from_place[0].value+" "+from_comp_txt+"/도착:"+fm.to_place[0].value+" "+to_comp_txt,200);
		//cut_length2("[탁송]탁송구분:"+cons_st_txt+"/차량번호:"+fm.car_no[0].value+"/"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"시/출발:"+fm.from_place[0].value+" "+from_comp_txt+"/도착:"+fm.to_place[0].value+" "+to_comp_txt,200);
		
		//왕복일경우
		if (fm.cons_st.value == "2") {
			
			fm.sms_msg.value = "[탁송지원요청]탁송구분:"+cons_st_txt+
											"//탁송1//탁송사유:"+cons_cau_txt+"/차량번호:"+fm.car_no[0].value+"/차명:"+fm.car_nm[0].value+"/"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"시//출발:"+fm.from_place[0].value+" "+from_comp_txt+"//도착:"+fm.to_place[0].value+" "+to_comp_txt +
											"//탁송2//탁송사유:"+cons_cau_txt2+"/차량번호:"+fm.car_no[1].value+"/차명:"+fm.car_nm[0].value+"/"+fm.from_req_dt[1].value+" "+fm.from_req_h[1].value+"시//출발:"+fm.from_place[1].value+" "+from_comp_txt2+"//도착:"+fm.to_place[1].value+" "+to_comp_txt2 + " " + cons_cau_add_txt;
											
			fm.sms_msg2.value = "[탁송]탁송구분:"+cons_st_txt+
											"//탁송1//탁송사유:"+cons_cau_txt+"/차량번호:"+fm.car_no[0].value+"/차명:"+fm.car_nm[0].value+"/"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"시//출발:"+fm.from_place[0].value+" "+from_comp_txt+"//도착:"+fm.to_place[0].value+" "+to_comp_txt +
											"//탁송2//탁송사유:"+cons_cau_txt2+"/차량번호:"+fm.car_no[1].value+"/차명:"+fm.car_nm[1].value+"/"+fm.from_req_dt[1].value+" "+fm.from_req_h[1].value+"시//출발:"+fm.from_place[1].value+" "+from_comp_txt2+"//도착:"+fm.to_place[1].value+" "+to_comp_txt2 + " " + cons_cau_add_txt;
			
		} else {			
			fm.sms_msg.value = "[탁송지원요청]탁송구분:"+cons_st_txt+"/탁송사유:"+cons_cau_txt+"/차량번호:"+fm.car_no[0].value+"/차명:"+fm.car_nm[0].value+"//"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"시//출발:"+fm.from_place[0].value+" "+from_comp_txt+"//도착:"+fm.to_place[0].value+" "+to_comp_txt + " " + cons_cau_add_txt;
			fm.sms_msg2.value = "[탁송]탁송구분:"+cons_st_txt+"/탁송사유:"+cons_cau_txt+"/차량번호:"+fm.car_no[0].value+"/차명:"+fm.car_nm[0].value+"//"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"시//출발:"+fm.from_place[0].value+" "+from_comp_txt+"//도착:"+fm.to_place[0].value+" "+to_comp_txt + " " + cons_cau_add_txt;
		}		
		
		// 2018.03.12
		// 탁송사유에 회수가 들어가거나 만기반납 일 경우 출발의 구분이 고객인 경우 핸드폰 번호가 반드시 들어가야 한다.
		$("select[name=cons_cau] option:selected").each(function(i, selected){
			var cons_cau_val = $(selected).text();
			if(cons_cau_val.indexOf("회수")>0 || cons_cau_val.indexOf("기반납")>0){
				if(fm.from_st[i].value==2){// 출발 구분이 고객일 경우
					if(fm.from_m_tel[i].value.length < 11) {
						if($("input[name=cons_st]:checked").val()==1){
							if(i==1) {
								return false;
							}
						}
						alert((i+1)+"번 탁송 : 출발-연락처 핸드폰 번호를 입력하십시오.");
						vali_switch = false;
						fm.from_m_tel[i].focus();
						return false;
					}
				}
			}
		});
		
		//채권양도 통지서 및 위임장 데이터 체크
		var cons_cau0 = $("#cons_cau0 option:selected").val();
		var cons_cau1 = $("#cons_cau1 option:selected").val();
		if(cons_cau0=="10" || cons_cau1=="10"){
			//if(fm.bond_trf_chk.checked==true){
				if($('#bond_trf_yn').val()=='Y'){
					var text = bond_trf_check();
					if(text!=""){
						alert(text);
						return;
					}
				}
			//}
		} 
				
		//아마존탁송 - 20220401 변경건   (주)신엠제이모터스   to_comp  (주)아마존카 본사
		// 영남주차장, 신엠제이 : 기존요금과 동일,  영남주차장,신엠제이외 : 변경요금 적용 ( 코드중 T136이후 사용 )
		//아마존탁송 - 202207변경  	if ( fm.from_comp[0].value.indexOf("(주)아마존카 본사") !=-1 ||  fm.to_comp[0].value.indexOf("(주)아마존카 본사") !=-1) {
		/* 아마존탁송 - 탁송사에서 선택하기로 함 - 202209 
		if( fm.off_id.value == '009217') {	
						
			if (fm.cons_st.value == "2") {
				//탁송1
				if (fm.cmp_app[0].value >= "E01" && fm.cmp_app[0].value <= "E47") {  //영남주차장만 사용 (지방으로 탁송은 상관없음)
												
					if ( fm.from_comp[0].value.indexOf("오토크린") !=-1 || fm.to_comp[0].value.indexOf("오토크린") !=-1|| fm.from_comp[0].value.indexOf("아마존모터스") !=-1 || fm.to_comp[0].value.indexOf("아마존모터스") !=-1)   {		
					} else {
						alert("1번 탁송 구간을 (영남 및 그외정비소   출발/도착)구간으로 다시 선택하세요!!!"); 	
						return;						
					}						
				}
			
				if (fm.cmp_app[0].value >= "C01" && fm.cmp_app[0].value <= "C47") {  //정비소출발인경우  ( 지방으로 탁송은 상관없음)	
				 				
					if ( fm.from_comp[0].value.indexOf("오토크린") !=-1 || fm.to_comp[0].value.indexOf("오토크린") !=-1|| fm.from_comp[0].value.indexOf("아마존모터스") !=-1 || fm.to_comp[0].value.indexOf("아마존모터스") !=-1)   {		
				   		alert("1번 탁송 구간을 (정비소(오토크린, 아마존모터스) 출발/도착)구간으로 다시 선택하세요!!!"); 
						return;						
					}		
											
				}			
								
				//탁송2
				if (fm.cmp_app[1].value >= "E01" && fm.cmp_app[1].value <= "E47") {  //영남주차장만 사용 (지방으로 탁송은 상관없음)
												
					if ( fm.from_comp[1].value.indexOf("오토크린") !=-1 || fm.to_comp[1].value.indexOf("오토크린") !=-1|| fm.from_comp[1].value.indexOf("아마존모터스") !=-1 || fm.to_comp[1].value.indexOf("아마존모터스") !=-1)   {		
					} else {
						alert("2번 탁송 구간을 (영남 및 그외정비소  출발/도착)구간으로 다시 선택하세요!!!"); 	
						return;						
					}						
				}
			
				if (fm.cmp_app[1].value >= "C01" && fm.cmp_app[1].value <= "C47") {  //정비소출발인경우  ( 지방으로 탁송은 상관없음)	
				 				
					if ( fm.from_comp[1].value.indexOf("오토크린") !=-1 || fm.to_comp[1].value.indexOf("오토크린") !=-1|| fm.from_comp[1].value.indexOf("아마존모터스") !=-1 || fm.to_comp[1].value.indexOf("아마존모터스") !=-1)   {		
				   		alert("2번 탁송 구간을 (정비소(오토크린, 아마존모터스)출발/도착)구간으로 다시 선택하세요!!!"); 
						return;						
					}		
											
				}			
					
				
			} else {  //편도 
				//탁송1
				if (fm.cmp_app[0].value >= "E01" && fm.cmp_app[0].value <= "E47") {  //영남주차장만 사용 (지방으로 탁송은 상관없음)
												
					if ( fm.from_comp[0].value.indexOf("오토크린") !=-1 || fm.to_comp[0].value.indexOf("오토크린") !=-1|| fm.from_comp[0].value.indexOf("아마존모터스") !=-1 || fm.to_comp[0].value.indexOf("아마존모터스") !=-1)   {		
					} else {
						alert("1번 탁송 구간을 (영남 및 그외정비소  출발/도착)구간으로 다시 선택하세요!!!"); 	
						return;						
					}						
				}
			
				if (fm.cmp_app[0].value >= "C01" && fm.cmp_app[0].value <= "C47") {  //정비소출발인경우  ( 지방으로 탁송은 상관없음)	
				 				
					if ( fm.from_comp[0].value.indexOf("오토크린") !=-1 || fm.to_comp[0].value.indexOf("오토크린") !=-1|| fm.from_comp[0].value.indexOf("아마존모터스") !=-1 || fm.to_comp[0].value.indexOf("아마존모터스") !=-1)   {		
				   		alert("1번 탁송 구간을 (정비소정비소(오토크린, 아마존모터스) 출발/도착)구간으로 다시 선택하세요!!!"); 
						return;						
					}		
											
				}				
			}								
		}
		*/
		
		if(vali_switch){
			if(confirm('등록하시겠습니까?')){
				var link = document.getElementById("submitLink");
				var originFunc = link.getAttribute("href");
				link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
				
			//  fm.bond_trf_yn.value='N';
				/* if($('#bond_trf_yn').val()=='Y'){
					if(fm.bond_trf_chk.checked==true){	fm.bond_trf_yn.value='Y';	}
					else{								fm.bond_trf_yn.value='N';	}
				} */
				
				
				fm.action='cons_reg_step1_a.jsp';
				fm.target='i_no';
				//fm.target='_blank';
				fm.submit();
						
				link.getAttribute('href',originFunc);
			}
		}
	}
	
	//탁송사유 text
	function cons_cau_change_txt(idx, val) {
		
		var cons_cau_txt = "";
		
		if (fm.cons_cau[idx].value == "1") {
			cons_cau_txt = "신차 및 재리스 대여차량인도";
		} else if (fm.cons_cau[idx].value == "3") {
			cons_cau_txt = "지연대차인도";
		} else if (fm.cons_cau[idx].value == "4") {
			cons_cau_txt = "정비대차인도";
		} else if (fm.cons_cau[idx].value == "5") {
			cons_cau_txt = "사고대차인도";
		} else if (fm.cons_cau[idx].value == "6") {
			cons_cau_txt = "정비차량인도";
		} else if (fm.cons_cau[idx].value == "7") {
			cons_cau_txt = "사고차량인도";
		} else if (fm.cons_cau[idx].value == "8") {
			cons_cau_txt = "지연대차회수";
		} else if (fm.cons_cau[idx].value == "9") {
			cons_cau_txt = "정비대차회수";
		} else if (fm.cons_cau[idx].value == "10") {
			cons_cau_txt = "사고대차회수";
		} else if (fm.cons_cau[idx].value == "11") {
			cons_cau_txt = "정비차량회수";
		} else if (fm.cons_cau[idx].value == "12") {
			cons_cau_txt = "사고차량회수";
		} else if (fm.cons_cau[idx].value == "13") {
			cons_cau_txt = "중도해지회수";
		} else if (fm.cons_cau[idx].value == "14") {
			cons_cau_txt = "만기반납";
		} else if (fm.cons_cau[idx].value == "15") {
			cons_cau_txt = "대여차량회수";
		} else if (fm.cons_cau[idx].value == "16") {
			cons_cau_txt = "본사이동";
		} else if (fm.cons_cau[idx].value == "17") {
			cons_cau_txt = "지점이동";
		} else if (fm.cons_cau[idx].value == "18") {
			cons_cau_txt = "정기검사";
		} else if (fm.cons_cau[idx].value == "19") {
			cons_cau_txt = "차량점검";
		} else if (fm.cons_cau[idx].value == "20") {
			cons_cau_txt = "기타";
		} else if (fm.cons_cau[idx].value == "21") {
			cons_cau_txt = "월렌트차량인도";
		} else if (fm.cons_cau[idx].value == "22") {
			cons_cau_txt = "월렌트차량회수";
		} else if (fm.cons_cau[idx].value == "23") {
			cons_cau_txt = "경매탁송";
		} else if (fm.cons_cau[idx].value == "24") {
			cons_cau_txt = "임시검사";
		}
		
		return cons_cau_txt;
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

	//탁송의뢰서 출력
	function ConsPrint(seq){
		var fm = document.form1;	
		var width 	= 800;
		var height 	= 860;		
		window.open("cons_reg_print.jsp?cons_no=<%=cons_no%>&seq="+seq+"&step=2", "Print", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}
	
	function ConsCarList(car_no, from_req_dt){
		var fm = document.form1;	
		var width 	= 800;
		var height 	= 300;		
		window.open("cons_car_list.jsp?car_no="+car_no+"&from_req_dt="+from_req_dt, "CarList", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}
	
	//채권양도 통지서 정보입력창 폼(20181113)
	function view_bondForm(value, idx){
		var fm = document.form1;
		var cons_cau2 = idx=='0'?$('#cons_cau1 option:selected').val():$('#cons_cau0 option:selected').val();
		
		if($('input[name=cons_st]:checked').val()=='1'){//편도
			if(value=='10'){	$('.bondForm').css('display','block');
								$('#bond_trf_yn').val('Y');	}
			else{				$('.bondForm').css('display','none');
								$('#bond_trf_yn').val('N');	}
		}else if($('input[name=cons_st]:checked').val()=='2'){//왕복
			//if(idx=='0'){//탁송1
				if(value=='10'){
					$('.bondForm').css('display','block');		$('#bond_trf_yn').val('Y');
				}else if(value=='7'){
					if(cons_cau2=='10'){$('.bondForm').css('display','block');	$('#bond_trf_yn').val('Y');	}
					else{				$('.bondForm').css('display','none');	$('#bond_trf_yn').val('N');	}
				}else{
					if(cons_cau2=='10'){$('.bondForm').css('display','block');	$('#bond_trf_yn').val('Y');	}
					else{				$('.bondForm').css('display','none');	$('#bond_trf_yn').val('N');	}
				}
			
			
		}
	}
	
	//휴차/대차기간 일자계산
	function set_ins_use_dt(){
		var fm = document.form1;
		if(fm.ins_use_st.value != '' && fm.ins_use_et.value != ''){
			var m  = 30*24*60*60*1000;		//달
			var l  = 24*60*60*1000;  		// 1일
			var lh = 60*60*1000;  			// 1시간
			var lm = 60*1000;  	 	 		// 1분
			var d1 = replaceString('-','',fm.ins_use_st.value)+fm.use_st_h.value+fm.use_st_s.value;
			var d2 = replaceString('-','',fm.ins_use_et.value)+fm.use_et_h.value+fm.use_et_s.value;
			var t1 = getDateFromString(d1).getTime();
			var t2 = getDateFromString(d2).getTime();
			var t3 = t2 - t1;
			fm.ins_use_day.value 	= parseInt(t3/l);
			fm.use_hour.value 		= parseInt(((t3%m)%l)/lh);
			
			if(toInt(d1)>0 && toInt(d1)==toInt(d2) && fm.ins_use_day.value == '0' && fm.use_hour.value == '0'){
				fm.ins_use_day.value 	= 1;
			}
			
			if(toInt(parseDigit(fm.ins_day_amt.value))>0){
				fm.ins_req_amt.value = parseDecimal( ((toInt(parseDigit(fm.ins_day_amt.value)) * toInt(fm.ins_use_day.value)) + (toInt(parseDigit(fm.ins_day_amt.value))/24 * toInt(fm.use_hour.value))) * (toInt(fm.ot_fault_per.value)/100) );
				if(fm.ins_req_gu.value == '1'){		//휴차료
					fm.mc_s_amt.value = fm.ins_req_amt.value;
				}else{				
					fm.mc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_req_amt.value))));
					fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_req_amt.value)) - toInt(parseDigit(fm.mc_s_amt.value)));					
				}
			}
		}
	}
	
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}
	
	//청구금액 셋팅
	function set_reqamt(st){
		var fm = document.form1;
		if(fm.ac_car_mng_id.value == ''){	alert('대차/사고/탁송조회를 해주세요.');		return;	}
		if(fm.ins_use_day.value == '') 		set_ins_use_dt();		
		if(fm.ins_use_day.value == ''){		alert('이용일수를 입력하십시오.'); return;}
		if(fm.use_hour.value == '') 		set_ins_use_dt();
		if(fm.use_hour.value == ''){		alert('이용시간을 입력하십시오. 대차종료일자에서 커서를 뒀다가 나오시면 자동계산 합니다.'); return;}
		fm.st.value = st;
		fm.action='getMyAccidReqAmt.jsp';
		
		if(st == 'view'){
			fm.target='_blank';
		}else{
			<%-- if(toInt(replaceString('-','',fm.ins_use_st.value)) < <%=a_bean.getAccid_dt().substring(0,8)%>){
				alert('사고일자보다 대차시작일이 빠릅니다. 확인하십시오.');
				return;
			} --%>			
			fm.target='i_no';
		}		
		fm.submit();
	}
	
	//사고차량의 차량번호체크
	function getOriginCarMngId(value, idx){
		var fm = document.form1;
		if(value=="7"){	//사고차량인도
			if(fm.car_no[idx].value==""){
				alert("탁송 "+(idx+1)+"의 차량번호/차대번호를 조회해 주세요.");
				return false;
			}else{
				$("#sch_ac_c_id").val(fm.car_mng_id[idx].value);
				$("#sch_ac_car_no").val(fm.car_no[idx].value);
			}
		}else{
			
		}	
	}
	
	//사고조회 팝업(20181224)
	function search_total(){
		var fm = document.form1;
		var c_id = "";
		var l_cd = "";
		var d_c_id = "";
		var d_l_cd = "";
		var cons_cau0 = $("#cons_cau0 option:selected").val();
		var cons_cau1 = $("#cons_cau1 option:selected").val();
		if(cons_cau0==""){	alert("탁송1 의 탁송사유를 선택해주세요.");	return;		}
		if(fm.cons_st.value=='2' && cons_cau1==""){	alert("탁송2 의 탁송사유를 선택해주세요.");	return;		}
		//if(/* mode=='sch_car'||mode=='sch_cons' */true){
		//	if(cons_cau0=="10"){		c_id = fm.car_mng_id[0].value;	l_cd = fm.rent_l_cd[0].value;	}
		//	else if(cons_cau1=="10"){	c_id = fm.car_mng_id[1].value;	l_cd = fm.rent_l_cd[1].value;	}
			if(cons_cau0=="10"){		c_id = $("#car_mng_id_0").val();	l_cd = $("#rent_l_cd_0").val();	}
			else if(cons_cau1=="10"){	c_id = $("#car_mng_id_1").val();	l_cd = $("#rent_l_cd_1").val();	}
			
			if(c_id==""){	alert("탁송사유:사고대차회수\n의 차량번호/차대번호를 조회해 주세요."); return;	}
			
		//	if(cons_cau0=="7"){			d_c_id = fm.car_mng_id[0].value;	d_l_cd = fm.rent_l_cd[0].value;		}
		//	else if(cons_cau1=="7"){	d_c_id = fm.car_mng_id[1].value;	d_l_cd = fm.rent_l_cd[1].value;		}
			if(cons_cau0=="7"){			d_c_id = $("#car_mng_id_0").val();	d_l_cd = $("#rent_l_cd_0").val();	}
			else if(cons_cau1=="7"){	d_c_id = $("#car_mng_id_1").val();	d_l_cd = $("#rent_l_cd_1").val();	}
			
			if((cons_cau0=="7"||cons_cau1=="7") && d_c_id==""){	alert("탁송사유:사고차량인도\n의 차량번호/차대번호를 조회해 주세요."); return;	}
		//}
		window.open("/tax/pop_search/s_for_bond_trf.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&s_kd=2&t_wd=&idx=&size=&c_id="+c_id+"&l_cd="+l_cd+"&d_c_id="+d_c_id+"&d_l_cd="+d_l_cd, "CAR", "left=10, top=10, width=900, height=900, scrollbars=yes, status=yes, resizable=yes");
	}
	
	function bond_trf_check(){ 
		var fm = document.form1;
		var text = ""
	//	if(fm.ac_rent_mng_id.value=="" || fm.ac_rent_l_cd.value=="" || fm.ac_client_id.value=="" || 
	//	   fm.ac_client_st.value=="" || fm.ac_client_nm.value=="" || fm.ac_firm_nm.value=="" || 
	//	   fm.ac_zip.value=="" || fm.ac_addr.value=="" || fm.ac_car_mng_id.value=="" ||
	//	   fm.ac_car_no.value=="" || fm.ac_car_nm.value=="" || fm.ac_ins_req_gu.value=="" ){
		if(fm.ac_rent_mng_id.value=="" || fm.ac_rent_l_cd.value==""){
			text = "대차/사고/탁송조회를 해주세요. 계약정보 (조회할수)없음";
		}else if(fm.ac_client_id.value=="" || fm.ac_client_st.value=="" || fm.ac_client_nm.value=="" || fm.ac_firm_nm.value==""){
			text = "대차/사고/탁송조회를 해주세요. 고객정보 (조회할수)없음";
		}else if(fm.ac_addr.value==""){
			text = "대차/사고/탁송조회를 해주세요. 고객주소 (조회할수)없음\n\n고객정보에서 고객주소 및 우편번호를 모두 입력해주세요.";
		}else if(fm.ac_car_mng_id.value=="" || fm.ac_car_no.value=="" || fm.ac_car_nm.value==""){
			text = "대차/사고/탁송조회를 해주세요. 차량정보 (조회할수)없음";
		}else if(fm.ac_birth.value=="" && fm.ac_enp_no==""){
			text = "대차/사고/탁송조회를 해주세요. 고객 생년월일/사업자번호 (조회할수)없음\n\n고객의 생년월일(개인)/사업자번호(개인사업자,법인사업자)를 입력해주세요.";
		}else if(fm.accid_dt.value==""){
			text = "사고등록 조회내역이 없습니다. 사고일자를 직접 입력해주세요.";	
		}else if(fm.ins_com_nm.value==""){
			text = "사고등록 내역중 상대보험사 정보를 가져올수 없습니다. 수신처(상대보험사/상호)를 직접 입력해주세요.";
		}else if(fm.ins_use_st.value==""||fm.ins_use_st.value.replace(/-/gi,"").length!=8 ||
				 fm.ins_use_et.value==""||fm.ins_use_et.value.replace(/-/gi,"").length!=8 ){
			text = "수리기간을 정확히 입력해주세요.\n\n예) 2018-12-25";
		}else if(fm.ins_req_amt.value=="" || fm.ins_day_amt.value==""||fm.ins_req_amt.value==0 || fm.ins_day_amt.value==0){
			text = "수리기간의 [계산하기]를 실행해주세요.";
		}
		return text;
	} 
	function select(sub_rent_l_cd, idx, age_scp, car_no) {
		$("[name=sub_rent_l_cd]").eq(idx).val(sub_rent_l_cd);
		$("[name=age_scp]").eq(idx).val(age_scp);
		$("[name=sub_car_no]").eq(idx).val(car_no);
		if(!car_no) {
			$("[name=sub_car_no]").eq(idx).val(sub_rent_l_cd);
		}
		var age_scp = $("[name=age_scp]").eq(idx).val();
	}
	
	function test() {
		alert("원계약 조회 버튼을 클릭하여 선택하세요.");
	}

	$(document).on("click","[name=search]", function(){
		var fm = document.form1;
		var idx = $("[name=search]").index(this);
		$("[name=sub_rent_l_cd]").eq(idx).val("");
		$("[name=sub_car_no]").eq(idx).val("");
		// 3: 지연대차 인도, 4: 정비대차 인도, 5: 사고대차 인도
		window.open("client_s.jsp?idx="+idx, "CLIENT_SEARCH", "left=50, top=50, width=1020, height=700, resizable=yes, scrollbars=yes, status=yes");
	}); 
	
	
	$(document).ready(function(){
		rent_st = '<%=rent_st%>';
		if(rent_st == "2" || rent_st == "3" || rent_st == "10") {
			$("[name=search]").eq(0).css('display','inline-block');
			$("[name=sub_car_no]").eq(0).css('display','inline-block');
			$("[name=car_no_text]").eq(0).css('display','inline-block');
		}
	});

</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='cons_reg_step1.jsp' name="form1" method='post'>
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='mm_seq' value='<%=mm_seq%>'> 
 <input type='hidden' name='sms_msg' value=''> 
 <input type='hidden' name='sms_msg2' value=''> 
 <input type='hidden' name='off_msg' value='Y'> 
 <input type='hidden' name='cons_no' value='<%=cons_no%>'>
 <input type='hidden' name='st' value=''>
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
        			  <input type='text' name="off_nm" value='<%=off_nm%>' size='30' class='text'><!--(주)아마존카-->
        			  <input type='hidden' name='off_id' value='<%=off_id%>'><!--003158-->
        			  <span class="b"><a href="javascript:search_off()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			  <span class="b"><a href="javascript:view_off()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_see.gif"  border="0" align=absmiddle></a></span>
        			</td>
                </tr>               
                <tr> 
                    <td width='13%' class='title'>탁송구분</td>
                    <td  colspan="3">&nbsp;
        			  	<input type='radio' name="cons_st" value='1' onClick="javascript:cng_input(1)" <%if(car_mng_id.equals("") || cons_su_val == 1)%>checked<%%>>편도
        			  	<input type='radio' name="cons_st" value='2' onClick="javascript:cng_input(2)" <%if(!car_mng_id.equals("") && !sub_c_id.equals("")|| cons_su_val == 2)%>checked<%%>>왕복&nbsp;
        				<span class="b"><a href="javascript:search_car_back()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_back.gif"  border="0" align=absmiddle></a>&nbsp; ※ 회수를 선택하면 기존 탁송 정보를 불러올 수 있습니다.</span>
        				<input type='hidden' name='cons_su' <%if((!car_mng_id.equals("") && !sub_c_id.equals("")) || cons_su_val == 2) {%>value='2'<%}else{%>value='1'<%}%>>
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
<%//if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
        			<td width='15%' class='title' style='height:32'>신차등록후 메세지전송여부</td>
                    <td >&nbsp;
        			<input type="checkbox" name="s_car" value="Y" onClick="Javascript:cng_input1()">
        			  (차량등록이 안된 신차 탁송의뢰를 입력한 경우에만 체크하세요.)</td>
<%//}%>
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
	    <td style='height:18'><font color=#666666>&nbsp;※ <b>사후입력여부</b>에 체크되면 탁송업체 및 당사직원에게 발송하던 메세지가 전송되지 않습니다.</font></td>
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
            	       				<td align="center" class='title' width=13% rowspan=2>메세지수신자</td>
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
		<%if (cons_no.equals("")) {%>
			<%@ include file="/fms2/consignment_new/cons_reg_step1_inclu.jsp"%>
		<%} else { %>
			<%@ include file="/fms2/consignment_new/cons_reg_step1_inclu2.jsp"%>
		<%}%>
			
		<%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>
	<tr>
	    <td align="center">&nbsp;<a id="submitLink" href="javascript:save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
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