<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.car_register.*, acar.client.*, acar.cont.*, acar.car_mst.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %> 

<%
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	//탁송의뢰 1번
	ConsignmentBean b_cons = cs_db.getConsignment(cons_no, 1);
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettleCommi("2", cons_no);
	
	//의뢰자
	UsersBean sender_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	//수신자
	UsersBean target_bean 	= new UsersBean();
	if(doc.getUser_id2().equals("")){
		target_bean = umd.getUsersBean(user_id);
		doc.setUser_id2(user_id);
	}else{
		target_bean = umd.getUsersBean(doc.getUser_id2());
	}
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	Vector  codes2 = new Vector();
	int c_size2 = 0;	

	codes2 = c_db.getCodeAllV_0022_all("0022");	
	c_size2= codes2.size();
	
	
	String white = "";
	String disabled = "";
	
//	white = "white";
//	disabled = "disabled";
	
	if(user_id.equals(doc.getUser_id2()) && !b_cons.getOff_nm().equals("(주)아마존카")){
		white = "white";
		disabled = "disabled";
	}
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
	//리스트
	function list(){
		var fm = document.form1;			
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/agent/doc_settle/doc_settle_frame.jsp';
		}else{
			if(fm.from_page.value == ''){
				fm.action = 'cons_rec_frame.jsp';
			}else{
				fm.action = fm.from_page.value;
			}
		}
		fm.target = 'd_content';
		fm.submit();
	}	


	//탁송업체 조회
	function search_off()
	{
		window.open("/agent/cus0601/cus0602_frame.jsp?from_page=/agent/consignment/cons_i_c.jsp", "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//탁송업체 보기
	function view_off()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("선택된 탁송업체가 없습니다."); return;}
		window.open("/agent/cus0601/cus0602_d_frame.jsp?from_page=/agent/consignment/cons_i_c.jsp&off_id="+fm.off_id.value, "SERV_OFF", "left=10, top=10, width=900, height=250, scrollbars=yes, status=yes, resizable=yes");
	}		
		
	//자동차 조회
	function search_car(idx)
	{
		window.open("/agent/tax/pop_search/s_car.jsp?go_url=/agent/consignment/cons_reg_step1.jsp&s_kd=2&idx="+idx, "CAR", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//자동차 보기
	function view_car(idx)
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("선택된 탁송업체가 없습니다."); return;}
		if(fm.car_mng_id[idx].value == ""){ alert("선택된 자동차가 없습니다."); return;}	
		window.open("/agent/car_register/car_view.jsp?rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_mng_id="+fm.car_mng_id[idx].value+"&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}			

	//탁송구분에 따른 셋팅
	function cng_input(st){
		var fm = document.form1;
		
		var cons_su = toInt(fm.cons_su.value);
		
		if(cons_su == 1 && st == 2){
			fm.cons_su.value = 2;
			tr_cons1_1.style.display	= '';
			tr_cons1_2.style.display	= '';
			tr_cons1_3.style.display	= '';
			tr_cons1_4.style.display	= '';
			tr_cons1_5.style.display	= '';
		}		
	}	
	
	//차량대수에 따른 디스플레이
	function cng_input2(cons_su){
		var fm = document.form1;		
		var cons_su = toInt(cons_su);
		
		return;
		
		if(cons_su >10){
			alert('입력가능한 최대건수는 10건 입니다.');
			return;
		}		
		
		<%for(int i=1;i<10;i++){%>
		if(cons_su > <%=i%>){
			tr_cons<%=i%>_1.style.display	= '';
			tr_cons<%=i%>_2.style.display	= '';			
			tr_cons<%=i%>_3.style.display	= '';
			tr_cons<%=i%>_4.style.display	= '';
			tr_cons<%=i%>_5.style.display	= '';
		}else{
			tr_cons<%=i%>_1.style.display	= 'none';
			tr_cons<%=i%>_2.style.display	= 'none';
			tr_cons<%=i%>_3.style.display	= 'none';
			tr_cons<%=i%>_4.style.display	= 'none';
			tr_cons<%=i%>_5.style.display	= 'none';
		}
		<%}%>			
			
	}		
	
	//출발/도착 구분에 따른 팝업
	function cng_input3(st, value, idx){
		var fm = document.form1;		
		var width 	= 600;
		var height 	= 400;
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
		
		window.open("s_place.jsp?go_url=/agent/consignment/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&req_id="+req_id, "PLACE", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//출발/도착 담당자 조회
	function cng_input5(st, value, idx){
		var fm = document.form1;		
		var width 	= 600;
		var height 	= 500;
		var firm_nm = '';
		
		if(st == 'from' && fm.from_st[idx].value == ''){		alert('출발 구분을 선택하십시오.'); 	return;		}
		if(st == 'to' && fm.to_st[idx].value == ''){			alert('도착 구분을 선택하십시오.'); 	return;		}

		if(st == 'from')		firm_nm 	= fm.from_comp[idx].value;
		if(st == 'to')			firm_nm 	= fm.to_comp[idx].value;
		
		if(firm_nm == ''){ 		alert('구분을 선택하여 장소를 먼저 선택하여 주십시오.'); 	return; }
		
		if(value == '1') 		firm_nm 	= replaceString('(주)아마존카 ','',firm_nm);
		
		if(value == '3'){		alert('협력업체는 담당자 검색이 없습니다.');	return; }
		
		window.open("s_man.jsp?go_url=/agent/consignment/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd=1&t_wd="+firm_nm+"&rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_no="+fm.car_no[idx].value, "MAN", "left=10, top=10, width="+width+", height=500, scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//운전자 조회
	function cng_input6(st, value, idx){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 700;		
		var firm_nm = '<%=b_cons.getOff_nm()%>';
		if('<%=b_cons.getOff_id()%>' == '003158'){
			width 	= 600;
			height 	= 700;
			value = '4';
			s_kd  = 2;
			if(<%=b_cons.getCons_su()%> > 1){
				if(fm.driver_nm[idx].value != '')		firm_nm = fm.driver_nm[idx].value;
				else									firm_nm = '';
			}else{
				if(fm.driver_nm.value != '')			firm_nm = fm.driver_nm.value;
				else									firm_nm = '';			
			}
			alert(firm_nm);
			window.open("s_man.jsp?go_url=/agent/consignment/cons_reg_step2.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&size=<%=b_cons.getCons_su()%>", "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");					
		}else{				
			window.open("s_man.jsp?go_url=/agent/consignment/cons_reg_step2.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd=1&t_wd="+firm_nm+"&size=<%=b_cons.getCons_su()%>", "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
		}
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
	}				
	
	//예정일시 셋팅
	function cng_input7(st, idx){
		var fm = document.form1;	
		
		if(st == 'from'){
			if(fm.from_est_chk[idx].checked == true){
				fm.from_est_dt[idx].value 	= fm.from_req_dt[idx].value;
				fm.from_est_h[idx].value 	= fm.from_req_h[idx].value;
				fm.from_est_s[idx].value 	= fm.from_req_s[idx].value;		
				
				if(fm.to_est_dt[idx].value == ''){
					fm.to_est_dt[idx].value 	= fm.from_req_dt[idx].value;
					fm.to_est_h[idx].value 		= fm.from_req_h[idx].value;
					fm.to_est_s[idx].value 		= fm.from_req_s[idx].value;														
				}				
			}	
		}else{
			if(fm.to_est_chk[idx].checked == true){		
				fm.to_est_dt[idx].value 	= fm.to_req_dt[idx].value;
				fm.to_est_h[idx].value 		= fm.to_req_h[idx].value;
				fm.to_est_s[idx].value 		= fm.to_req_s[idx].value;									
			}
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
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		var size = toInt(fm.cons_su.value);
		var vali_switch = true;
		
		fm.doc_bit.value = doc_bit;
		
		if(size >1){
			for(i=0; i<size ; i++){		
				if(fm.from_est_dt[i].value == "" || fm.from_est_h[i].value == "" || fm.from_est_s[i].value == "") 	{ 	alert((i+1)+"번 탁송 : 출발-예정일시를 입력하십시오."); 	return;	}					
				if(fm.to_est_dt[i].value == ""   || fm.to_est_h[i].value == ""   || fm.to_est_s[i].value == "") 	{ 	alert((i+1)+"번 탁송 : 도착-예정일시를 입력하십시오."); 	return;	}			
				if(fm.driver_nm[i].value == "") 	{ 	alert((i+1)+"번 탁송 : 운전자명을 입력하십시오."); 		return;	}
				if(fm.driver_m_tel[i].value == "") 	{ 	alert((i+1)+"번 탁송 : 운전자핸드폰을 입력하십시오."); 	return;	}
				if(fm.off_id.value == '003158'){
					if(fm.driver_nm[i].value != "" && fm.driver_id[i].value == "") { 	alert((i+1)+"번 탁송 : 운전자를 조회하여 선택하십시오."); 	return;	}
				}
			}
		}else{
				var i=0;
				if(fm.from_est_dt.value == "" || fm.from_est_h.value == "" || fm.from_est_s.value == "") 	{ 	alert((i+1)+"번 탁송 : 출발-예정일시를 입력하십시오."); 	return;	}					
				if(fm.to_est_dt.value == ""   || fm.to_est_h.value == ""   || fm.to_est_s.value == "") 		{ 	alert((i+1)+"번 탁송 : 도착-예정일시를 입력하십시오."); 	return;	}			
				if(fm.driver_nm.value == "") 		{ 	alert((i+1)+"번 탁송 : 운전자명을 입력하십시오."); 		return;	}
				if(fm.driver_m_tel.value == "") 	{ 	alert((i+1)+"번 탁송 : 운전자핸드폰을 입력하십시오."); 	return;	}
				if(fm.off_id.value == '003158'){
					if(fm.driver_nm.value != "" && fm.driver_id.value == "") { 	alert((i+1)+"번 탁송 : 운전자를 조회하여 선택하십시오."); 	return;	}
				}
		}
		
		// 탁송사유에 회수가 포함되거나 만기반납인 경우에서 출발 구분이 고객인 경우는 핸드폰 번호가 반드시 들어가야 한다. 2018.03.13
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
					}
				}
			}
		});
		
		if(vali_switch){
			if(confirm('결재하시겠습니까?')){	
				fm.action='cons_reg_step2_a.jsp';		
//				fm.target='i_no';
				fm.target='d_content';
				fm.submit();
			}		
		}							
	}	
	
	function save(){
		var fm = document.form1;
		var size = toInt(fm.cons_su.value);
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
		if(fm.cons_su.value == "")	{ 	alert("차량대수를 입력하십시오."); 		return;	}
		if(fm.cons_su.value == "0")	{ 	alert("차량대수를 입력하십시오."); 		return;	}
		
		if(fm.off_id.value == '002740' || fm.off_id.value == '003158' || fm.off_id.value == '009217' || fm.off_id.value == '010255' ){
	//	if(fm.off_id.value == '003158'){
			if(fm.cmp_app.value == "" || fm.cmp_app.value == "S00" || fm.cmp_app.value == "D00" || fm.cmp_app.value == "B00" || fm.cmp_app.value == "C00" || fm.cmp_app.value == "E00"  || fm.cmp_app.value == "F00"  || fm.cmp_app.value == "T00"){	alert('탁송구간을 선택하십시오.');	return;}
		}
		
		for(i=0; i<size ; i++){
			if(fm.car_no[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 선택된 차량이 없습니다."); 			return;	}
			if(fm.req_id[i].value == "")		{ 	alert((i+1)+"번 의뢰자를 입력하십시오."); 					return;	}				
			if(fm.cons_cau[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 탁송사유를 입력하십시오."); 			return;	}
			if(fm.cons_cau[i].value == "20" && fm.cons_cau_etc[i].value == "") 
												{ 	alert((i+1)+"번 탁송 : 탁송사유 기타를 입력하십시오."); 	return;	}
			if(fm.cost_st[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 비용구분을 선택하십시오."); 			return;	}
			if(fm.pay_st[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 지급구분을 선택하십시오."); 			return;	}
			//if(fm.from_st[i].value == "") 	{ 	alert(i+"번 탁송 : 출발-구분을 선택하십시오."); 		return;	}
			if(fm.from_place[i].value == "") 	{ 	alert((i+1)+"번 탁송 : 출발-장소를 입력하십시오."); 		return;	}
			if(fm.from_comp[i].value == "") 	{ 	alert((i+1)+"번 탁송 : 출발-상호/성명을 입력하십시오."); 	return;	}
			if(fm.from_req_dt[i].value == "" || fm.from_req_h[i].value == "" || fm.from_req_s[i].value == "") 	
												{ 	alert((i+1)+"번 탁송 : 출발-요청일시를 입력하십시오."); 	return;	}
			//if(fm.to_st[i].value == "") 		{ 	alert(i+"번 탁송 : 도착-구분을 선택하십시오."); 		return;	}
			if(fm.to_place[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 도착-장소를 입력하십시오."); 		return;	}
			if(fm.to_comp[i].value == "") 		{ 	alert((i+1)+"번 탁송 : 도착-상호/성명을 입력하십시오."); 	return;	}
			if(fm.to_req_dt[i].value == "" || fm.to_req_h[i].value == "" || fm.to_req_s[i].value == "") 		
												{ 	alert((i+1)+"번 탁송 : 도착-요청일시를 입력하십시오."); 	return;	}
		}
		
		if(confirm('수정하시겠습니까?')){		
			fm.action='cons_reg_step2_a.jsp';
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}		
	}
	
	function cons_delete(mode, seq){
		var fm = document.form1;
		
		fm.mode.value = mode;
		fm.del_seq.value = seq;
		
		if(confirm('삭제하시겠습니까?')){
		if(confirm('진짜로 삭제하시겠습니까?')){
			fm.action='cons_delete.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}}
	}		
	
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
	
	function cons_rec_sms(){
		var fm = document.form1;	
		fm.doc_bit.value = 'sms';
		
		if(confirm('문자를 발송하시겠습니까?')){	
			fm.action='cons_reg_step2_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}											
	}
	
	function cons_req_sms(){
		var fm = document.form1;	
		fm.doc_bit.value = 'sms_standby';
		
		cut_length("[탁송지원요청]출발일시:"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"시/출발지:"+fm.from_place[0].value+"/도착지:"+fm.to_place[0].value,90);
			
		if(confirm('문자를 발송하시겠습니까?')){	
		if(confirm('발송메시지:'+fm.sms_msg.value)){			
			fm.action='cons_reg_step2_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}}
	}	
	
	//의뢰자 변경
	function doc_id_cng(){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 200;		
		window.open("cons_reg_cng.jsp?cons_no=<%=cons_no%>", "CNG", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}	
	
	//탁송업체 변경
	function doc_off_cng(){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 200;		
		window.open("cons_reg_off_cng.jsp?cons_no=<%=cons_no%>", "OFF_CNG", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}		

	
function f_man_sms(){
	var fm = document.form1;	
	fm.doc_bit.value = 'f_sms';
	
	if(confirm('문자를 발송하시겠습니까?')){
		if(confirm('발송메시지:[탁송요청]-신차 탁송준비 완료!!')){
			fm.action='cons_reg_step2_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}
	}
}
	
function d_man_sms(){
	var fm = document.form1;	
	fm.doc_bit.value = 'd_sms';
	
	cut_length("[탁송요청]출발일시:"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"시/출발지:"+fm.from_place[0].value+"/도착지:"+fm.to_place[0].value,90);
		
	if(confirm('문자를 발송하시겠습니까?')){	
		if(confirm('발송메시지:'+fm.sms_msg.value)){			
			fm.action='cons_reg_step2_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}
	}
}

	//에이전트직원조회
	function Agent_User_search(nm, idx)
	{
		var fm = document.form1;
		if(fm.req_id[idx].value == '')		{ alert('의뢰자를 선택하십시오.'); 		return;}
		var t_wd = '';
		window.open("about:blank",'Agent_User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');
		fm.action = "/fms2/lc_rent/search_agent_user.jsp?mode=EMP_Y&nm="+nm+"&t_wd="+t_wd+"&idx="+idx+"&agent_user_id="+fm.req_id[idx].value;
		fm.target = "Agent_User_search";
		fm.submit();
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
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='cons_no' 	value='<%=cons_no%>'>
  <input type='hidden' name='off_id' 	value='<%=b_cons.getOff_id()%>'>
  <input type='hidden' name='off_nm' 	value='<%=b_cons.getOff_nm()%>'>
  <input type='hidden' name='reg_code' 	value='<%=b_cons.getReg_code()%>'>
<!--  <input type='hidden' name='req_id' 	value='<%=doc.getUser_id1()%>'>-->
  <input type='hidden' name="doc_no" 	value="<%=doc.getDoc_no()%>">  
  <input type='hidden' name="doc_bit" 	value="">
  <input type='hidden' name="del_seq" 	value="">  
  <input type='hidden' name="sms_msg" 	value="">    
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 탁송관리 > <span class=style5>탁송의뢰수신</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>

    <tr>
	    <td align='right'><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>탁송번호</td>
                    <td>&nbsp;
        			  <%=cons_no%>
        			</td>
                    <td width='13%' class='title'>탁송업체</td>
                    <td>&nbsp;
        			  <%=b_cons.getOff_nm()%>
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:view_off()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			  <%if(b_cons.getOff_id().equals("003158") && doc.getUser_dt2().equals("")){%>
        			  <%	if(doc.getUser_id1().equals(user_id)){%>
        			  <a href="javascript:doc_off_cng();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_modify_b.gif" align="absbottom" border="0"></a>
        			  <%	}%>
        			  <%}%>
        			</td>
                </tr>		  
                <tr>
                    <td width='13%' class='title'>탁송구분</td>
                    <td width="37%">&nbsp;
        			  <input type='radio' name="cons_st" value='1' <%if(b_cons.getCons_st().equals("1")){%>checked<%}%> <%=disabled%>>
        				편도
        			  <input type='radio' name="cons_st" value='2' <%if(b_cons.getCons_st().equals("2")){%>checked<%}%> <%=disabled%>>
        				왕복
        			</td>		  		  
                    <td width='13%' class='title'>차량대수</td>
                    <td width="37%">&nbsp;
                      <input type='text' name="cons_su" value='<%=b_cons.getCons_su()%>' size='2' class='<%//=white%>whitetext' onBlur='javscript:cng_input2(this.value);'>
        			  &nbsp;건
                    </td>					
                </tr>
                <tr> 
                    <td width='13%' class='title'>사후입력여부</td>
                    <td colspan="3">&nbsp;
					<input type="checkbox" name="after_yn" value="Y" <%if(b_cons.getAfter_yn().equals("Y")){%>selected<%}%>>
        			  (탁송완료건 사후입력일때)
                </tr>           					
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>		
    <tr> 
        <td class='line'> 		
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>
                <tr>
                    <td class=title width=13% rowspan="2">결재</td>
                    <td class=title width=15%>지점명</td>
                    <td class=title width=11%>의뢰</td>
                    <td class=title width=11%>수신</td>
                    <td class=title width=13%>정산</td>
                    <td class=title width=12%>청구</td>
                    <td class=title width=12%>확인</td>
                    <td class=title width=13%>기안</td>
                </tr>
                <tr>
                    <td align="center"><font color="#999999"><%=sender_bean.getBr_nm()%></font></td>
                    <td align="center"><font color="#999999"><%=sender_bean.getUser_nm()%><br><%=doc.getUser_dt1()%></font></td>
                    <td align="center"><font color="#999999"><%=target_bean.getUser_nm()%><br><%if(doc.getUser_id2().equals(user_id)){%><!--<a href="javascript:doc_sanction('2')">결재</a>--><%}%><br>&nbsp;</font></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
        			<td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>		
	<%if(doc.getUser_dt2().equals("")){%>
	
	<%if(doc.getUser_id2().equals(user_id) ){%>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>
    		    <tr>
        		    <td width="4%" rowspan="2" class='title'>연번</td>
        			<td width="9%" rowspan="2" class='title'>차량번호</td>
        		    <td colspan="2" class='title'>출발</td>
        			<td colspan="2" class='title'>도착</td>
        		    <td colspan="2" class='title'>운전자</td>
    	        </tr>
    		    <tr>
        		    <td width="12%" class='title'>장소</td>
        		    <td width="18%" class='title'>예정일시</td>
        		    <td width="12%" class='title'>장소</td>
        		    <td width="18%" class='title'>예정일시</td>
        		    <td width="13%" class='title'>성명</td>
        		    <td width="14%" class='title'>핸드폰</td>
    	        </tr>
    		  <%for(int j=0; j<b_cons.getCons_su(); j++){
    				ConsignmentBean cons 		= cs_db.getConsignment(cons_no, j+1);%>
    		  <%		String from_dt = "";
    			  		String from_h = "";
    					String from_s = "";
    					String get_from_dt = cons.getFrom_req_dt();
    					if(get_from_dt.length() == 12){
    						from_dt = get_from_dt.substring(0,8);
    						from_h 	= get_from_dt.substring(8,10);
    						from_s	= get_from_dt.substring(10,12);
    					}
    					String to_dt = "";
    			  		String to_h = "";
    					String to_s = "";
    					String get_to_dt = cons.getTo_req_dt();
    			  		if(get_to_dt.length() == 12){
    						to_dt 	= get_to_dt.substring(0,8);
    						to_h 	= get_to_dt.substring(8,10);
    						to_s 	= get_to_dt.substring(10,12);
    					}
    					String driver_nm 	= cons.getDriver_nm();
    					String driver_id 	= cons.getDriver_nm();
    					String driver_m_tel = cons.getDriver_m_tel();
    					if(!driver_nm.equals("") && cons.getOff_id().equals("003158")) driver_nm = c_db.getNameById(cons.getDriver_nm(),"USER");
    					if(driver_nm.equals("")){
    						driver_nm 		= target_bean.getUser_nm();
    						driver_id 		= target_bean.getUser_id();
    						driver_m_tel 	= target_bean.getUser_m_tel();
    					}
    					%>						
    		    <tr>
        		    <td align="center"><%=j+1%></td>
        			<td align="center"><%=cons.getCar_no()%></td>
        		    <td align="center"><%=cons.getFrom_place()%></td>
        			<td align="center"><input type='text' name="from_est_dt" value='<%=AddUtil.ChangeDate2(from_dt)%>' size='12' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                      <input type='text' name="from_est_h" value='<%=from_h%>' size='1' maxlength="2" class='default'>
                      시
                      <input type='text' name="from_est_s" value='<%=from_s%>' size='1' maxlength="2" class='default'>
                    분</td>			
        		    <td align="center"><%=cons.getTo_place()%></td>
        		    <td align="center"><input type='text' name="to_est_dt" value='<%=AddUtil.ChangeDate2(to_dt)%>' size='12' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                      <input type='text' name="to_est_h" value='<%=to_h%>' size='1' maxlength="2" class='default'>
                      시
                      <input type='text' name="to_est_s" value='<%=to_s%>' size='1' maxlength="2" class='default'>
                    분</td>
        		    <td align="center"><input type='text' name="driver_nm" value='<%=driver_nm%>' size='10' class='default'><input type='hidden' name="driver_id" value='<%=driver_id%>'>&nbsp;<span class="b"><a href="javascript:cng_input6('driver','3',<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span></td>
        		    <td align="center"><input type='text' name="driver_m_tel" value='<%=driver_m_tel%>' size='15' class='default'></td>
    	        </tr>
    		    <%}%>		  
			    <%for(int j=b_cons.getCons_su(); j<10; j++){%>	
    		    <tr style='display:none'>
        		    <td align="center"><%=j+1%></td>
        			<td align="center"><%//=cons.getCar_no()%></td>
        		    <td align="center"><%//=cons.getFrom_place()%></td>
        			<td align="center"><input type='text' name="from_est_dt" value='<%//=AddUtil.ChangeDate2(from_dt)%>' size='12' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                      <input type='text' name="from_est_h" value='<%//=from_h%>' size='1' maxlength="2" class='default'>
                      시
                      <input type='text' name="from_est_s" value='<%//=from_s%>' size='1' maxlength="2" class='default'>
                    분</td>			
        		    <td align="center"><%//=cons.getTo_place()%></td>
        		    <td align="center"><input type='text' name="to_est_dt" value='<%//=AddUtil.ChangeDate2(to_dt)%>' size='12' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                      <input type='text' name="to_est_h" value='<%//=to_h%>' size='1' maxlength="2" class='default'>
                      시
                      <input type='text' name="to_est_s" value='<%//=to_s%>' size='1' maxlength="2" class='default'>
                    분</td>
        		    <td align="center"><input type='text' name="driver_nm" value='<%//=driver_nm%>' size='10' class='default'><input type='hidden' name="driver_id" value='<%//=driver_id%>'>&nbsp;<span class="b"><a href="javascript:cng_input6('driver','3',<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span></td>
        		    <td align="center"><input type='text' name="driver_m_tel" value='<%//=driver_m_tel%>' size='15' class='default'></td>
    	        </tr>							
				<%}%>
    		</table>
	    </td>
    </tr>		
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>				
	<tr>
	    <td align="center">&nbsp;<a href="javascript:doc_sanction('2');"><img src=/acar/images/center/button_gj.gif align=absmiddle border=0></a></td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>		
	<tr>
	    <td><font color=#999999>&nbsp;※ 출발/도착 예정일시 : 의뢰자가 입력한 요청일시가 디폴트값입니다. 예정일시를 수정하세요. / 운전자 : 성명과 핸드폰을 입력하세요.</font> </td>
	</tr>			
	<tr>
	    <td><font color=#999999>&nbsp;※ 선등록이 원칙이나 시행초기라 전화접수후 등록되는 건들이 있습니다. 탁송이 중복되지 않도록 요청-기타또는 요청일시를 보고 업무 진행하세요.</font> </td>
	</tr>			
	<tr>
	    <td><font color=#999999>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;귀사에 이미 접수된 건인지도 확인해야 될 것 같습니다. 탁송완료건이라도 FMS상 수신,정산,청구는 해야 합니다.</font> </td>
	</tr>			
	<tr>
	    <td><font color=#999999>&nbsp;※ 기사 배정 시 에스폼의 임시저장 문서로 등록됩니다. 기사 재배정 시에는 에스폼상에 임시저장된 문서를 삭제하신 다음 진행해 주시기 바랍니다.</font> </td>
	</tr>		
	<%}%>	
	<%}%>
	<tr>
	    <td class=h></td>
	</tr>		
	<tr>
	    <td align="right" style='height:1; background-color=e5e5e5;'></td>
	</tr>	
	<tr>
	    <td class=h></td>
	</tr>
	<%for(int j=0; j<b_cons.getCons_su(); j++){
		//탁송의뢰 1번
		ConsignmentBean cons 		= cs_db.getConsignment(cons_no, j+1);
		CarRegBean 	car 		= crd.getCarRegBean(cons.getCar_mng_id());
		ContCarBean 	car_etc 	= a_db.getContCarNew(cons.getRent_mng_id(), cons.getRent_l_cd());
		ClientBean 	client 		= al_db.getNewClient(cons.getClient_id());
		CarMstBean 	cm_bean 	= cmb.getCarNmCase(String.valueOf(car_etc.getCar_id()), String.valueOf(car_etc.getCar_seq()));
	%>
	<tr id=tr_cons<%=j%>_1 style="display:''">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>탁송<%=j+1%></span></td>
	</tr>
    <tr id=tr_cons<%=j%>_2 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>
                <tr> 
                    <td width='13%' class='title'>차량번호</td>
                    <td width='37%'>&nbsp;
        			  <input type='text' name="car_no" value='<%=cons.getCar_no()%>' size='30' class='whitetext' readonly>
        			  <input type='hidden' name='seq' value='<%=cons.getSeq()%>'>
        			  <input type='hidden' name='car_mng_id' value='<%=cons.getCar_mng_id()%>'>
        			  <input type='hidden' name='rent_mng_id' value='<%=cons.getRent_mng_id()%>'>
        			  <input type='hidden' name='rent_l_cd' value='<%=cons.getRent_l_cd()%>'>
        			  <input type='hidden' name='client_id' value='<%=cons.getClient_id()%>'>
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:search_car(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>
        			<td width='13%' class='title'>차명</td>
        			<td width='37%'>&nbsp;
    			    <input type='text' name="car_nm" value='<%=cons.getCar_nm()%>' size='40' class='whitetext' readonly></td>
                </tr>
    		    <tr>
        		    <td class='title'>연식</td>
        			<td>&nbsp;
        			  <input type='text' name="car_y_form" value='<%=car.getCar_y_form()%>' size='40' class='whitetext' readonly>
        			</td>
        		    <td class='title'>색상</td>
        			<td>&nbsp;
    			    <input type='text' name="color" value='<%=car_etc.getColo()%>' size='40' class='whitetext' readonly></td>			
    		    </tr>
    		    <tr>
        		    <td class='title'>기본사양</td>
        			<td colspan="3" >&nbsp;
        			  <textarea rows='5' cols='100' name='car_b' readonly><%=cm_bean.getCar_b()%></textarea>        			  
        			</td>
    		    </tr>    	
    		    <tr>
        		    <td class='title'>선택사양</td>
        			<td colspan="3" >&nbsp;
        			  <input type='text' name="opt" value='<%=car_etc.getOpt()%>' size='100' class='whitetext' readonly>
        			</td>
    		    </tr>    	     		    
    		    <tr>
        		    <td class='title'>고객명</td>
        			<td>&nbsp;
        			  <input type='text' name="firm_nm" value='<%=client.getFirm_nm()%>' size='70' class='whitetext' readonly>
        			</td>
        		<td class='title'>하이패스여부</td>
        			<td>&nbsp;
        				<select name="r_hipass_yn" disabled >
                        <option value=''>선택</option>
                        <option value='Y' <%if(car_etc.getHipass_yn().equals("Y"))%>selected<%%>>있음</option>
                        <option value='N' <%if(car_etc.getHipass_yn().equals("N"))%>selected<%%>>없음</option>
                      </select>
          			</td>	
    		    </tr>
		    </table>
	    </td>
    </tr>
	<tr id=tr_cons<%=j%>_3 style="display:''">
	    <td align="right">&nbsp;
	    </td>
	</tr>	
    <tr id=tr_cons<%=j%>_4 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>		  
    		    <tr>
        		    <td colspan="2" class='title'>의뢰자</td>
        		    <td >&nbsp;
					<%if(cons.getReq_id().equals("")) cons.setReq_id(doc.getUser_id1());%>
        			  <select name='req_id' <%=disabled%>>
                        <option value="">선택</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(cons.getReq_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select>
                      &nbsp;
                      실 의뢰자
                      <input name="agent_emp_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cons.getAgent_emp_id(),"CAR_OFF_EMP")%>" size="12"> 
			<input type="hidden" name="agent_emp_id" value="<%=cons.getAgent_emp_id()%>">
			<a href="javascript:Agent_User_search('agent_emp_id', <%=j%>);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>						 
        			</td>
        		    <td colspan="2" class='title'>탁송구간</td>
        		    <td >&nbsp;
        			  <select name="cmp_app" <%=disabled%>>
        			    <option value="">선택</option>
        					<%for(int i = 0 ; i < c_size2 ; i++){
        					Hashtable code2 = (Hashtable)codes2.elementAt(i);%>
        					<option value='<%=code2.get("NM_CD")%>' <%if(cons.getCmp_app().equals(String.valueOf(code2.get("NM_CD") ))){%>selected<%}%>><%=code2.get("NM")%></option>
        				<%}%>
          			  </select>
        			  <!--(자체탁송일때)-->
        			</td>					
    	        </tr>				
    		    <tr>
        		    <td colspan="2" class='title'>탁송사유</td>
        		    <td colspan="4">&nbsp;
        			  <select name="cons_cau" onChange="javascript:cng_input4(this.value, <%=j%>)" <%=disabled%>>
        			    <option value="">선택</option>
        				<%for(int i = 0 ; i < c_size ; i++){
        					CodeBean code = codes[i];	%>
        				<option value='<%=code.getNm_cd()%>' <%if(cons.getCons_cau().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
        				<%}%>
          			  </select>
        			  &nbsp;기타사유 : <input type='text' name="cons_cau_etc" value='<%=cons.getCons_cau_etc()%>' size='40' class='<%=white%>text'>
        			</td>
    	        </tr>
    		    <tr>
        		    <td colspan="2" class='title'>비용구분</td>
        			<td>&nbsp;
        			  <select name="cost_st" <%=disabled%>>
        			    <option value="">선택</option>
        			    <option value="1" <%if(cons.getCost_st().equals("1")){%>selected<%}%>>아마존카</option>
        			    <option value="2" <%if(cons.getCost_st().equals("2")){%>selected<%}%>>고객</option>								
          			  </select>
        			  <%if(white.equals("")){%>
        			  &nbsp;<font color=red>[고객부담]탁송료 : <input type='text' name="cust_amt" value='0' size='7' class='rednum' onBlur='javascript:this.value=parseDecimal(this.value);'>원</font>
        			  <%}else{%>
        			  <%	if(cons.getCost_st().equals("2") && cons.getPay_st().equals("1")){%>
        			  &nbsp;<font color=red>[고객부담]탁송료 : <input type='text' name="cust_amt" value='0' size='7' class='rednum' onBlur='javascript:this.value=parseDecimal(this.value);'>원</font>
        			  <%	}%>
        			  <%}%>
        			</td>						
        		    <td colspan="2" class='title'>지급구분</td>
        			<td>&nbsp;
        			  <select name="pay_st" <%=disabled%>>
        			    <option value="">선택</option>
        			    <option value="1" <%if(cons.getPay_st().equals("1")){%>selected<%}%>>선불</option>
        			    <option value="2" <%if(cons.getPay_st().equals("2")){%>selected<%}%>>후불</option>								
          			  </select>
        			</td>						
    	        </tr>
    		    <tr>
        		    <td rowspan="4" class='title'>요<br>
        	        청</td>
        		    <td class='title'>세차</td>
        		    <td colspan="4">&nbsp;
        			  <select name="wash_yn" <%=disabled%>>
        			    <option value="">선택</option>
        			    <option value="Y" <%if(cons.getWash_yn().equals("Y")){%>selected<%}%>>요청</option>
        			    <option value="N" <%if(cons.getWash_yn().equals("N")){%>selected<%}%>>없음</option>								
          			  </select>
        			</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>주유</td>
        		    <td colspan="4">&nbsp;
        			  <select name="oil_yn" <%=disabled%>>
        			    <option value="">선택</option>
        			    <option value="Y" <%if(cons.getOil_yn().equals("Y")){%>selected<%}%>>요청</option>
        			    <option value="N" <%if(cons.getOil_yn().equals("N")){%>selected<%}%>>없음</option>								
          			  </select>
        				주유요청시 -&gt; 
        			  <input type='text' name="oil_liter" value='<%=Util.parseDecimal(cons.getOil_liter())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				리터<!--ℓ--> 
        				혹은
        			  <input type='text' name="oil_est_amt" value='<%=Util.parseDecimal(cons.getOil_est_amt())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				원어치 주유 해주세요.</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>하이패스등록</td>
        		    <td colspan="4">&nbsp;
        			  <select name="hipass_yn">
        			    <option value="Y" <%if(cons.getHipass_yn().equals("Y")){%>selected<%}%>>요청</option>
        			    <option value="N" <%if(cons.getHipass_yn().equals("N")||cons.getHipass_yn().equals("")){%>selected<%}%>>없음</option>								
          			  </select>
					  (등록대행 의뢰시 선택하십시오.)
        			</td>
    	        </tr>								
    		    <tr>
    		        <td class='title'>기타</td>
    		        <td colspan="4">&nbsp;
                    <textarea rows='5' cols='90' name='etc' class='<%=white%>'><%=cons.getEtc()%></textarea></td>
    	        </tr>		  
    		    <tr>
        		    <td width="3%" rowspan="6" class='title'>출<br>발</td>
        		    <td width="10%" class='title'>구분</td>
        		    <td width="37%">&nbsp;
        			  <select name="from_st" onChange="javascript:cng_input3('from', this.value, <%=j%>)" <%=disabled%>>
        			    <option value="">선택</option>
        			    <option value="1" <%if(cons.getFrom_st().equals("1")){%>selected<%}%>>아마존카</option>
        			    <option value="2" <%if(cons.getFrom_st().equals("2")){%>selected<%}%>>고객</option>
        			    <option value="3" <%if(cons.getFrom_st().equals("3")){%>selected<%}%>>협력업체</option>
        			    <option value="4" <%if(cons.getFrom_st().equals("4")){%>selected<%}%>>신차출발</option>				
          			  </select>
        			  <%if(white.equals("")){%>		
        			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>
        		    <td width="3%" rowspan="6" class='title'>도<br>착</td>
        		    <td width="10%" class='title'>구분</td>
        		    <td width="37%">&nbsp;
        			  <select name="to_st" onChange="javascript:cng_input3('to', this.value, <%=j%>)" <%=disabled%>>
        			    <option value="">선택</option>
        			    <option value="1" <%if(cons.getTo_st().equals("1")){%>selected<%}%>>아마존카</option>
        			    <option value="2" <%if(cons.getTo_st().equals("2")){%>selected<%}%>>고객</option>
        			    <option value="3" <%if(cons.getTo_st().equals("3")){%>selected<%}%>>협력업체</option>				
          			  </select>
        			  <%if(white.equals("")){%>			
        			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>			
    		    </tr>
    		    <tr>
        		    <td width="10%" class='title'>장소</td>
        		    <td>&nbsp;
                        <input type='text' name="from_place" id="from_place" value='<%=cons.getFrom_place()%>' size='40' class='<%=white%>text' ></td>
        		    <td width="10%" class='title'>장소</td>
        		    <td>&nbsp;
                    <input type='text' name="to_place" value='<%=cons.getTo_place()%>' size='40' class='<%=white%>text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>상호/성명</td>
        		    <td>&nbsp;
                        <input type='text' name="from_comp" id="from_comp" value='<%=cons.getFrom_comp()%>' size='40' class='<%=white%>text' >
        				</td>
        		    <td class='title'>상호/성명</td>
        		    <td>&nbsp;
                        <input type='text' name="to_comp" value='<%=cons.getTo_comp()%>' size='40' class='<%=white%>text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>담당자</td>
        	        <td>&nbsp;부서/직위
        	          <input type='text' name="from_title" id="from_title" value='<%=cons.getFrom_title()%>' size='20' class='<%=white%>text' ><br>
                      &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type='text' name="from_man" id="from_man" value='<%=cons.getFrom_man()%>' size='20' class='<%=white%>text' >
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>
        		    <td class='title'>담당자</td>
        		    <td>&nbsp;부서/직위
        		      <input type='text' name="to_title" value='<%=cons.getTo_title()%>' size='20' class='<%=white%>text' ><br>
        			  &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  <input type='text' name="to_man" value='<%=cons.getTo_man()%>' size='20' class='<%=white%>text' >
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>연락처</td>
        		    <td>&nbsp;사무실
                        <input type='text' name="from_tel" id="from_tel" value='<%=cons.getFrom_tel()%>' size='15' class='<%=white%>text' ><br>
        				&nbsp;핸드폰
                        <input type='text' name="from_m_tel" id="from_m_tel" value='<%=cons.getFrom_m_tel()%>' size='15' class='<%=white%>text' >
        			</td>
        		    <td class='title'>연락처</td>
        		    <td>&nbsp;사무실
                        <input type='text' name="to_tel" value='<%=cons.getTo_tel()%>' size='15' class='<%=white%>text' ><br>
        				&nbsp;핸드폰
                        <input type='text' name="to_m_tel" value='<%=cons.getTo_m_tel()%>' size='15' class='<%=white%>text' >
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>요청일시</td>
        		    <td>&nbsp;
        			  <%	String from_req_dt = "";
        			  		String from_req_h = "";
        					String from_req_s = "";
        			  		if(cons.getFrom_req_dt().length() == 12){
        						from_req_dt = cons.getFrom_req_dt().substring(0,8);
        						from_req_h 	= cons.getFrom_req_dt().substring(8,10);
        						from_req_s	= cons.getFrom_req_dt().substring(10,12);
        					}%>
                      <input type='text' name="from_req_dt" value='<%=AddUtil.ChangeDate2(from_req_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_req_dt[<%=j%>].value=this.value;'>
                      &nbsp;
        			  <select name="from_req_h" onchange="javascript:document.form1.to_req_h[<%=j%>].value=this.value;" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(from_req_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="from_req_s" onchange="javascript:document.form1.to_req_s[<%=j%>].value=this.value;" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(from_req_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
        		    <td class='title'>요청일시</td>
        		    <td>&nbsp;
        			  <%	String to_req_dt = "";
        			  		String to_req_h = "";
        					String to_req_s = "";
        			  		if(cons.getTo_req_dt().length() == 12){
        						to_req_dt 	= cons.getTo_req_dt().substring(0,8);
        						to_req_h 	= cons.getTo_req_dt().substring(8,10);
        						to_req_s 	= cons.getTo_req_dt().substring(10,12);
        					}%>			
                      <input type='text' name="to_req_dt" value='<%=AddUtil.ChangeDate2(to_req_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;
        			  <select name="to_req_h" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(to_req_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="to_req_s" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(to_req_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
    	        </tr>  
            </table>
        </td>
    </tr>
	<tr id=tr_cons<%=j%>_5 style="display:''">
	    <td align="right">&nbsp;<a href="javascript:ConsPrint(<%=cons.getSeq()%>)"><img src="/acar/images/printer.gif" border="0"></a>
	  <%Vector vt = cs_db.getConsignmentCarList(cons.getCar_no(), from_req_dt);
		int vt_size = vt.size();
		if(vt_size>1){%>
		<a href="javascript:ConsCarList('<%=cons.getCar_no()%>','<%=from_req_dt%>')"><font color=red>동일차량/동일요청일로 등록된 탁송의뢰가 있습니다.</font></a>&nbsp;
	  <%}%>
	    </td>
	</tr>		
	<%}%>		
	<%for(int j=b_cons.getCons_su(); j<10; j++){%>
	<tr id=tr_cons<%=j%>_1 style="display:<%if(j==0){%>''<%}else{%>none<%}%>">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>탁송<%=j+1%></span></td>
	</tr>
    <tr id=tr_cons<%=j%>_2 style="display:<%if(j==0){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>
                <tr> 
                    <td width='13%' class='title'>차량번호</td>
                    <td width='37%'>&nbsp;
        			  <input type='text' name="car_no" value='' size='15' class='whitetext' readonly>
        			  <input type='hidden' name='seq' value='<%=j+1%>'>
        			  <input type='hidden' name='car_mng_id' value=''>
        			  <input type='hidden' name='rent_mng_id' value=''>
        			  <input type='hidden' name='rent_l_cd' value=''>
        			  <input type='hidden' name='client_id' value=''>			  
        			  <span class="b"><a href="javascript:search_car(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			</td>
        			<td width='13%' class='title'>차명</td>
        			<td width='37%'>&nbsp;
    			    <input type='text' name="car_nm" value='' size='40' class='whitetext' readonly></td>
                </tr>
    		    <tr>
        		    <td class='title'>연식</td>
        			<td>&nbsp;
        			  <input type='text' name="car_y_form" value='' size='40' class='whitetext' readonly>
        			</td>
        		    <td class='title'>색상</td>
        			<td>&nbsp;
    			    <input type='text' name="color" value='' size='40' class='whitetext' readonly></td>			
    		    </tr>
    		    <tr>
        		    <td class='title'>고객명</td>
        			<td colspan="3">&nbsp;
        			  <input type='text' name="firm_nm" value='' size='70' class='whitetext' readonly>
        			</td>
    		    </tr>
    		</table>
	    </td>
    </tr>
	<%if(j==0){%>
	<tr id=tr_cons<%=j%>_3 style="display:<%if(j==0){%>''<%}else{%>none<%}%>">
	    <td align="right">&nbsp;</td>
	</tr>	
	<%}else{%>
	<tr id=tr_cons<%=j%>_3 style="display:<%if(j==0){%>''<%}else{%>none<%}%>">
	    <td align="right">&nbsp;<input type='text' name="cons_copy" value='' size='2' class='text'><a href="javascript:value_copy(<%=j%>)">번 탁송내용 복사하기</a></td>
	</tr>	
	<%}%>
    <tr id=tr_cons<%=j%>_4 style="display:<%if(j==0){%>''<%}else{%>none<%}%>"> 
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
                        <option value='<%=user.get("USER_ID")%>' ><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
        					</select>
                      &nbsp;
                      실 의뢰자
                      <input name="agent_emp_nm" type="text" class="text"  readonly value="" size="12"> 
			<input type="hidden" name="agent_emp_id" value="">
			<a href="javascript:Agent_User_search('agent_emp_id', <%=j%>);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>						         					
        					
        			</td>
        		    <td colspan="2" class='title'>탁송구간</td>
        		    <td >&nbsp;
        			  <select name="cmp_app">
        			    <option value="">선택</option>
        				<%for(int i = 0 ; i < c_size2 ; i++){
        				 				Hashtable code2 = (Hashtable)codes2.elementAt(i);%>
        					<option value='<%=code2.get("NM_CD")%>'><%=code2.get("NM")%></option>
        				<%}%>
          			  </select>
        			  <!--(자체탁송일때)-->
        			</td>					
    	        </tr>					
    		    <tr>
        		    <td colspan="2" class='title'>탁송사유</td>
        		    <td colspan="4">&nbsp;
        			  <select name="cons_cau" onChange="javascript:cng_input4(this.value, <%=j%>)">
        			    <option value="">선택</option>
        				<%for(int i = 0 ; i < c_size ; i++){
        					CodeBean code = codes[i];	%>
        				<option value='<%=code.getNm_cd()%>'><%= code.getNm()%></option>
        				<%}%>
          			  </select>
        			  &nbsp;기타사유 : <input type='text' name="cons_cau_etc" value='' size='40' class='text'>
        			</td>
        	    </tr>
    		    <tr>
        		    <td colspan="2" class='title'>비용구분</td>
        			<td>&nbsp;
        			  <select name="cost_st">
        			    <option value="">선택</option>
        			    <option value="1">아마존카</option>
        			    <option value="2">고객</option>								
          			  </select>
        			</td>						
        		    <td colspan="2" class='title'>지급구분</td>
        			<td>&nbsp;
        			  <select name="pay_st">
        			    <option value="">선택</option>
        			    <option value="1">선불</option>
        			    <option value="2">후불</option>								
          			  </select>
        			</td>						
    	        </tr>
    		    <tr>
        		    <td rowspan="3" class='title'>요<br>청</td>
        		    <td class='title'>세차</td>
        		    <td colspan="4">&nbsp;
        			  <select name="wash_yn">
        			    <option value="">선택</option>
        			    <option value="Y">요청</option>
        			    <option value="N">없음</option>								
          			  </select>
        			</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>주유</td>
        		    <td colspan="4">&nbsp;
        			  <select name="oil_yn">
        			    <option value="">선택</option>
        			    <option value="Y">요청</option>
        			    <option value="N">없음</option>								
          			  </select>
        				주유요청시 -&gt; 
        			  <input type='text' name="oil_liter" value='' size='11' class='text' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				리터<!--ℓ--> 
        				혹은
    			    <input type='text' name="oil_est_amt" value='' size='11' class='text' onBlur='javascript:this.value=parseDecimal(this.value);'> 
    				원어치 주유 해주세요.</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>기타</td>
        		    <td colspan="4">&nbsp;
                      <textarea rows='5' cols='90' name='etc'></textarea></td>
    	        </tr>		  
    		    <tr>
        		    <td width="3%" rowspan="7" class='title'>출<br>발</td>
        		    <td width="10%" class='title'>구분</td>
        		    <td width="37%">&nbsp;
        			  <select name="from_st" onChange="javascript:cng_input3('from', this.value, <%=j%>)">
        			    <option value="">선택</option>
        			    <option value="1">아마존카</option>
        			    <option value="2">고객</option>
        			    <option value="3">협력업체</option>
        			    <option value="4">협력업체</option>					
          			  </select>		
        			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			</td>
        		    <td width="3%" rowspan="7" class='title'>도<br>착</td>
        		    <td width="10%" class='title'>구분</td>
        		    <td width="37%">&nbsp;
        			  <select name="to_st" onChange="javascript:cng_input3('to', this.value, <%=j%>)">
        			    <option value="">선택</option>
        			    <option value="1">아마존카</option>
        			    <option value="2">고객</option>
        			    <option value="3">협력업체</option>				
          			  </select>			
        			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			</td>			
    		    </tr>
    		    <tr>
        		    <td width="10%" class='title'>장소</td>
        		    <td>&nbsp;
                        <input type='text' name="from_place" id="from_place" value='' size='40' class='text' ></td>
        		    <td width="10%" class='title'>장소</td>
        		    <td>&nbsp;
                        <input type='text' name="to_place" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>상호/성명</td>
        		    <td>&nbsp;
                        <input type='text' name="from_comp" id="from_comp" value='' size='40' class='text' >
        				</td>
        		    <td class='title'>상호/성명</td>
        		    <td>&nbsp;
                        <input type='text' name="to_comp" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>담당자</td>
        	        <td>&nbsp;부서/직위
        	          <input type='text' name="from_title" id="from_title" value='' size='20' class='text' ><br>
                      &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type='text' name="from_man" id="from_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			</td>
        		    <td class='title'>담당자</td>
        		    <td>&nbsp;부서/직위
        		      <input type='text' name="to_title" value='' size='20' class='text' ><br>
        			  &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  <input type='text' name="to_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>연락처</td>
        		    <td>&nbsp;
                        <input type='text' name="from_tel" id="from_tel" value='' size='15' class='text' >
        				&nbsp;핸드폰
                        <input type='text' name="from_m_tel" id="from_m_tel"value='' size='15' class='text' >
        			</td>
        		    <td class='title'>연락처</td>
        		    <td>&nbsp;
                        <input type='text' name="to_tel" value='' size='15' class='text' >
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
        		    <td class='title'>예정일시</td>
        		    <td>&nbsp;
                      <input type='text' name="from_est_dt" value='' size='11' class='text' >
        			  &nbsp;
        			  <input type='text' name="from_est_h" value='' size='2' class='text' >
        			  시&nbsp;
        			  <input type='text' name="from_est_s" value='' size='2' class='text' >
        			  분
        			  <input type='checkbox' name="from_est_chk" value='Y' onClick="javascript:cng_input7('from', <%=j%>)">요청일시
        			</td>
        	        <td class='title'>예정일시</td>
        	        <td>&nbsp;
                      <input type='text' name="to_est_dt" value='' size='11' class='text' >
        			  &nbsp;
        			  <input type='text' name="to_est_h" value='' size='2' class='text' >
        			  시&nbsp;
        			  <input type='text' name="to_est_s" value='' size='2' class='text' >
        			  분
        			  <input type='checkbox' name="to_est_chk" value='Y' onClick="javascript:cng_input7('from', <%=j%>)">요청일시
        			</td>
    		    </tr>
    		  <!--
    		  <tr>
    		    <td colspan="2" class='title'>운전자명</td>
                <td>&nbsp;
                    <input type='text' name="driver_nm" value='' size='15' class='text' ></td>
                <td colspan="2" class='title'>운전자핸드폰</td>
                <td>&nbsp;
                    <input type='text' name="driver_m_tel" value='' size='15' class='text' ></td>
    	      </tr>-->		  
            </table>
        </td>
    </tr>	
	<tr id=tr_cons<%=j%>_5 style="display:<%if(j==0){%>''<%}else{%>none<%}%>">
	    <td>&nbsp;</td>
	</tr>		
	<%}%>
	<tr>
	    <td align="center">
	    <%if(doc.getUser_id1().equals(user_id) && b_cons.getDriver_nm().equals("")  ){%>
	    <a href="javascript:save();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif" align="absbottom" border="0"></a>&nbsp;
		<%}%>
		<%if(doc.getUser_dt2().equals("") && doc.getUser_id1().equals(user_id)){%>
		<a href="javascript:cons_delete('all','');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_delete.gif" align="absbottom" border="0"></a>
		<%}%>
	    </td>
	</tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<tr>
		
		<td align="" class='' >
			
		</td>
	</tr>		
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>	
	<tr>
	    <td align="center">
	
		<%if(doc.getUser_dt2().equals("") && (doc.getUser_id2().equals(user_id))){%>
	    &nbsp;&nbsp;<a href="javascript:cons_rec_sms();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_sms_send.gif" align="absmiddle" border="0"></a>
		<%}%>
		&nbsp;
		<%-- <%if((doc.getUser_id2().equals(user_id))){%>
	    <a href="javascript:cons_req_sms();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_sms_jw.gif" border="0" align=absmiddle></a>
		<%}%>		 --%>
	    </td>
	</tr>
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
//-->
</script>
</body>
</html>
