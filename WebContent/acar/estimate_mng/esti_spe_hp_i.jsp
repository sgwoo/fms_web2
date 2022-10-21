<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*, acar.secondhand.*, acar.car_mst.*, acar.car_register.*, acar.cont.*, acar.client.*" %>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiMBean" scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="bc_db" class="acar.bad_cust.BadCustDatabase" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 	scope="page"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	
	String est_id 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String chk 			= request.getParameter("chk")==null?"":request.getParameter("chk");  				//최초입력 여부
	String bb_chk 	= request.getParameter("bb_chk")==null?"":request.getParameter("bb_chk");  	//부재중 여부
	String t_chk		= request.getParameter("t_chk")==null?"":request.getParameter("t_chk");  		//상담및 통화
	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");  	
	String car_mng_id		= "";
	String rent_mng_id	= "";
	String rent_l_cd		= "";
	String reg_code = "";
	// 목록보기 클릭시 전단계 검색조건 유지를 위해 추가
	String period_gubun = request.getParameter("period_gubun")==null?"":request.getParameter("period_gubun");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String branch = request.getParameter("branch")==null?"":request.getParameter("branch");		//영업지점 검색추가
	
	if (!bb_chk.equals("") &&  !t_chk.equals("") ) {
		bb_chk = "";
	}
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();

	u_bean = umd.getUsersBean(user_id);

	//스마트견적 요청
	e_bean = e_db.getEstiSpeCase(est_id);
	
	//희망차종
	EstimateBean [] e_r = e_db.getEstiSpeCarList(est_id);
	int size = e_r.length;
	
	for(int i=0; i<size; i++){
    EstimateBean car_bean = e_r[i];
		if(!car_bean.getCar_mng_id().equals("")){
			car_mng_id = car_bean.getCar_mng_id();
		}
	}
	
	//통화내역
	EstiMBean em_r [] = e_db.getEstiMAll(est_id, user_id);
	
	//홈페이지-실시간견적 : 신차,재리스
	EstimateBean e_bean2 = e_db.getEstimateCuCase(est_id);
	
	//차량예약
	ShResBean shBn = shDb.getShResEst(est_id);
	
	//차량등록정보 - 재리스
	if(!e_bean2.getMgr_nm().equals("")){
		cr_bean = crd.getCarRegBean(e_bean2.getMgr_nm());
		car_mng_id = e_bean2.getMgr_nm();
	}

	String rmcont_yn = "";
		
	//홈페이지-차량예약에서 월렌트견적 찾기
	EstimateBean e_bean3 = new EstimateBean();
	if(!shBn.getCar_mng_id().equals("") && !shBn.getReg_code().equals("")){
		e_bean3 = e_db.getEstimateCuRmCase(shBn.getCar_mng_id(), shBn.getReg_code());
		rmcont_yn = shDb.getRmContYn(shBn.getEst_id());
		car_mng_id = shBn.getCar_mng_id();
		reg_code = shBn.getEst_id();
	}
	
	//차량등록정보 - 월렌트
	if(!e_bean3.getMgr_nm().equals("")){
		cr_bean = crd.getCarRegBean(e_bean3.getMgr_nm());
		car_mng_id = e_bean3.getMgr_nm();
	}	

	//운전자정보	
 	Vector driverInfo = shDb.getMonthRentDriverInfo(est_id);
 	
	String bc_lic_no = "";
	String driver_cell = "";
  	if(driverInfo.size() > 0){
  		for(int i=0; i<driverInfo.size(); i++){ 
			Hashtable driver = (Hashtable)driverInfo.elementAt(i);
			if(bc_lic_no.equals("")){
				bc_lic_no = String.valueOf(driver.get("DRIVER_NUM"));
			}
			if(driver_cell.equals("")){
				driver_cell = String.valueOf(driver.get("DRIVER_CELL"));
			}
		}
	}
	//미납금액 확인
	String client_id = "";	
	
	if(!car_mng_id.equals("")){
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
		rent_l_cd 		= String.valueOf(cont.get("RENT_L_CD"));		
	}
	
	Hashtable ycont = a_db.getContViewUseYCarCase(car_mng_id);	
	
	//배차상태
	Hashtable reserv = rs_db.getResCarCase(car_mng_id, "2");
	String use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
	
	if(use_st.equals("null")){
		reserv = rs_db.getResCarCase(car_mng_id, "1");
		use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
	}
	
	//주차장 정보
	CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;
	
	//차량정보	
	Hashtable ht_car = shDb.getShBase(car_mng_id);
	String park = String.valueOf(ht_car.get("PARK"));
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script>
$(document).ready(function(){
	//담당자 정보 있으면 담당자 등록하라는 메세지 안나오게 처리
	if($('#regBtn').length > 0){
		$('#damdangInfo').show();
	}
})
</script>
<script language="JavaScript">
	function tell_save(gubun){
		var fm = document.form1;
		if(fm.est_id.value == ''){ 	alert('est_id가 없습니다. 확인하십시오.'); return; }
		if(fm.user_id.value == ''){ alert('user_id가 없습니다. 확인하십시오.'); return; }
		if(gubun=='00')	{
			fm.note.value = "통화함";
			fm.gubun.value = "0";
		} else if(gubun=='01')	{
			fm.note.value = "부재중";
			fm.gubun.value = "1";
		} else if(gubun=='02')  {
			fm.note.value = "결번(잘못된번호)";
			fm.gubun.value = "2";
		} else if(gubun=='19')  {
			fm.note.value = "부재중 문자발송";
			fm.gubun.value = "1";
		}
		
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
		
		fm.action = "esti_memo_null_ui.jsp";
		fm.target = "i_no";
		fm.submit();
		
		link.getAttribute('href',originFunc);
	}
	
	function save(){
		var fm = document.form1;
		if(fm.est_id.value == ''){ 	alert('est_id가 없습니다. 확인하십시오.'); return; }
		if(fm.user_id.value == ''){ alert('user_id가 없습니다. 확인하십시오.'); return; }
		if(fm.note.value == ''){ 	alert('통화내용이 없습니다. 확인하십시오.'); return; }
		if(!confirm('등록하시겠습니까?')){	return; }					
		
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
		
		fm.action = "esti_memo_null_ui.jsp";
		fm.target = "i_no";
		fm.submit();
		
		link.getAttribute('href',originFunc);
	}
	
	function change(arg){
		var fm = document.form1;
	
		if(arg=='03')			fm.note.value = "나그네";
		else if(arg=='04')	fm.note.value = "담당자 미확인";
		else if(arg=='05')	fm.note.value = "영업사원";
		else if(arg=='06')	fm.note.value = "기존업체";
		else if(arg=='07')	fm.note.value = "단기대여";
		else if(arg=='08')	fm.note.value = "비교견적중";
		else if(arg=='09')	fm.note.value = "오프리스조회";
		else if(arg=='10')	fm.note.value = "진행업체견적검토용";
		else if(arg=='11')	fm.note.value = "타사렌트(리스)로 계약함";
		else if(arg=='12')	fm.note.value = "할부구매함";
		else if(arg=='13')	fm.note.value = "장기간보류";
		else if(arg=='14')	fm.note.value = "미리검토함";
		else if(arg=='15')	fm.note.value = "검토중임";
		else if(arg=='16')	fm.note.value = "계약체결";
		else if(arg=='17')	fm.note.value = "무관심";
		else if(arg=='18')	fm.note.value = "기타";
		else if(arg=='19')	fm.note.value = "부재중문자발송";
	}
	
	function EstiATypeReg(st, car_mng_id, seq){
		var fm = document.form1;		
		if(!confirm('견적하시겠습니까?')){	return; }
		fm.spe_seq.value = seq;
		fm.target = "d_content";
		if(car_mng_id == ''){
			fm.st.value = st;
			fm.est_table.value = 'esti_spe';
			fm.action = "esti_mng_atype_i.jsp";
			if(st == '2'){
				fm.target = "i_no";
			} 
		}else{
			fm.st.value = '';
			fm.car_mng_id.value = car_mng_id;
			fm.est_table.value = 'esti_spe';
			fm.action = "/acar/secondhand/secondhand_detail_frame.jsp";
		}
		fm.submit();
	}
	function EstiATypeRegSpe(spe_car_nm){
		var fm = document.form1;
		if(!confirm('견적하시겠습니까?')){	return; }
		fm.spe_car_nm.value = spe_car_nm;
		fm.target = "d_content";
		fm.est_table.value = 'esti_spe';
		fm.action = "esti_mng_atype_i.jsp";
		fm.submit();
	}
	
	//문자내용 발송하기
	function msg_send(){ 
		fm = document.form1;
		if(!confirm("[<%if(!e_bean.getEst_agnt().equals("")){%><%=e_bean.getEst_agnt()%><%} else {%><%=e_bean.getEst_nm()%><%}%> 고객님께서 요청하신 견적 상담을 위해 전화드렸으나 연결이 되지 않아 문자 남깁니다. 언제든 상담이 가능하니 통화 가능하실 때 연락주세요.] 부재중 관련 문자내용을 발송하시겠습니까?"))	return;
		fm.target = "i_no";
		fm.action = "send_case.jsp";
		fm.submit();		
		tell_save("19");
	}

	//목록보기
	function go_list(){
		var prevLink = document.getElementById("prev_page").value;
		var fm = document.form1;
		if(prevLink != "" && prevLink != null){
			fm.action = prevLink;
		}else{
			fm.action = '/acar/estimate_mng/esti_spe_hp_grid_big_frame.jsp';
		}
		fm.target = 'd_content';
		fm.submit(); 
		
		/* var period_gubun = $("#period_gubun").val();
		var gubun4 = $("#gubun4").val();
		var s_dt = $("#s_dt").val();
		var e_dt = $("#e_dt").val();
		var esti_m = $("#esti_m").val();
		var branch = $("#branch").val(); */
	}
	
	//견적서보기
	function EstiView(est_st, est_id, spe_est_id){
		var SUBWIN="";
		if(est_st=='월렌트')	SUBWIN="/acar/secondhand_hp/estimate_rm_new.jsp?est_id="+est_id+"&spe_est_id="+spe_est_id+"&acar_id=<%=ck_acar_id%>&from_page=";
		if(est_st=='재리스')	SUBWIN="/acar/secondhand_hp/estimate_fms.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_fms";
		if(est_st=='신차')		SUBWIN="/acar/main_car_hp/estimate_fms.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");				
	}
	
	function ReEsti(est_st, est_id, car_mng_id, spe_est_id){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.car_mng_id.value = car_mng_id;
		fm.cmd.value = 're';
		fm.est_table.value = 'esti_spe';
		if(est_st=='월렌트'){
			fm.est_id.value = spe_est_id;
		}
		if(est_st=='월렌트')	fm.action = '/acar/secondhand/secondhand_detail_frame.jsp';
		if(est_st=='재리스')	fm.action = '/acar/secondhand/secondhand_detail_frame.jsp';
		if(est_st=='신차')	fm.action = 'esti_mng_atype_i.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//전기차 수소차비교견적
	function ReEsti6(est_st, est_id, car_mng_id, spe_est_id, set_code, eh_code){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.set_code.value = set_code;
		fm.eh_code.value = eh_code;
		fm.car_mng_id.value = car_mng_id;
		fm.cmd.value = 're';
		fm.spe_cmd.value = 're_6';
		fm.est_table.value = 'esti_spe';
		if(est_st=='월렌트'){
			fm.est_id.value = spe_est_id;
		}
		if(est_st=='월렌트')	fm.action = '/acar/secondhand/secondhand_detail_frame.jsp';
		if(est_st=='재리스')	fm.action = '/acar/secondhand/secondhand_detail_frame.jsp';
		if(est_st=='신차')	fm.action = 'esti_mng_atype_i.jsp';
		fm.target = 'd_content';
		fm.submit();
	}
	
	//예약이력	
	function view_sh_res_h(){
		var SUBWIN="/acar/secondhand/reserveCarHistory.jsp?car_mng_id=<%=shBn.getCar_mng_id()%>";
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}	
	
	//계약확정으로 전환하기
	function reserveCar2Cng(car_mng_id, seq, situation, damdang_id, shres_reg_dt, shres_cust_nm, shres_cust_tel){
		var fm = document.form1;
		
		var sms_msg = fm.sms_msg.options[fm.sms_msg.selectedIndex].value;
		var sms_msg2 = fm.sms_msg2.options[fm.sms_msg2.selectedIndex].value;
		
		if(damdang_id == ""){
			alert("담당자등록을 먼저 하세요");
			return;
		}
				
		//if(sms_msg == ""){
		//	alert("준비물을 선택해주세요");
		//	fm.sms_msg.focus();
		//	return;
		//}
		
		//if(sms_msg2 == ""){
		//	alert("차고지를 선택해주세요");
		//	fm.sms_msg2.focus();
		//	return;
		//}
		
		fm.car_mng_id.value = car_mng_id;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		fm.shres_cust_nm.value = shres_cust_nm;
		fm.shres_cust_tel.value = shres_cust_tel;
		if(!confirm("상담중에서 계약확정으로 전환 하시겠습니까?"))	return;
		fm.action = "/acar/secondhand/reserveCar2cng.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	//예약취소하기
	function cancelCar(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.car_mng_id.value = car_mng_id;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("예약을 취소 하시겠습니까?"))	return;
		fm.action = "/acar/secondhand/cancelCar.jsp";
		fm.target = "i_no";
		fm.submit();
	}	
	//월렌트계약 연동하기
	function RmContReg(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		
		var sms_msg = fm.sms_msg.options[fm.sms_msg.selectedIndex].value;
		var sms_msg2 = fm.sms_msg2.options[fm.sms_msg2.selectedIndex].value;
		
		if(damdang_id == ""){
			alert("담당자등록을 먼저 하세요");
			return;
		}
				
		if(sms_msg == ""){
			alert("준비물을 선택해주세요");
			fm.sms_msg.focus();
			return;
		}
		
		if(sms_msg2 == ""){
			alert("차고지를 선택해주세요");
			fm.sms_msg2.focus();
			return;
		}
				
		fm.car_mng_id.value = car_mng_id;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		
		//연체금액이 있는지 확인한다.
		//if(fm.client_id.value != '' && fm.badamt_chk.value == ''){
			//alert('<%=e_bean.getEst_nm()%> 고객의 연체금액을 보고 [확인] 하십시오.');
			//return;
		//}
				
		if(!confirm("월렌트계약 등록하시겠습니까?"))	return;
		fm.action = "/acar/secondhand/rmcontReg.jsp";
		fm.target = "i_no";
		fm.submit();
	}		
	
	function registerDamdang(estId){
		if(confirm("담당자로 등록하시겠습니까?")){
			var id = '<%=ck_acar_id%>';
			$.ajax({
				url:'/acar/estimate_mng/reg_damdang.jsp?id='+id+"&estId="+estId,
				contentType:"application/json",
				type:'POST',
				success:function(response){
					location.reload();
				},
				error:function(response,status,error){
					alert(response);
				}
			});
		}
	}
	
	//스캔등록
	function scan_reg(content_code, content_seq, file_st_nm){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&content_code="+content_code+"&content_seq="+content_seq+"&file_st_nm="+file_st_nm, "SCAN", "left=10, top=10, width=720, height=200, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//리뉴얼 이후 홈페이지에서 견적한 건은 홈페이지 견적서 페이지 호출
	function smartEstView(est_id){
		var url = "https://www.amazoncar.co.kr/smart/print?estimateId=" + est_id;
   		window.open(url,"printPopup","width=1010,height=800,top=0,left=100,scrollbars=yes");	
	}
	
	//거래처 연체금액
	function view_dlyamt(client_id)
	{
		window.open('/acar/account/stat_settle_sc_in_view_sub_list_client.jsp?badamt_chk_from=esti_spe_hp_i.jsp&client_id='+client_id, "CLIENT_DLVAMT", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//불량고객 
	function view_badcust(est_nm, lic_no, est_tel, est_o_tel, est_mail, est_fax, est_comp_tel, est_comp_cel, driver_cell)
	{
		window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_spe_hp_i.jsp&est_nm='+est_nm+'&lic_no='+lic_no+'&est_tel='+est_tel+'&est_o_tel='+est_o_tel+'&est_mail='+est_mail+'&est_fax='+est_fax+'&est_comp_tel='+est_comp_tel+'&est_comp_cel='+est_comp_cel+'&driver_cell='+driver_cell, "BADCUST", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//고객 조회
	function search_client(){window.open("/fms2/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&t_wd=<%=e_bean.getEst_nm()%>&from_page=/acar/estimate_mng/esti_spe_hp_i.jsp","CLIENT","left=10,top=10,width=1100,height=600,scrollbars=yes,status=yes,resizable=yes");}
	
	//배차현황 세부내역 조회
	function view_rentcont(use_st, rent_s_cd){
		var SUBWIN="/acar/res_stat/res_rent_u.jsp?mode=view&c_id=<%=car_mng_id%>&s_cd="+rent_s_cd;
		if(use_st == '배차'){
			SUBWIN="/acar/rent_mng/res_rent_u.jsp?mode=view&c_id=<%=car_mng_id%>&s_cd="+rent_s_cd;
		}
		window.open(SUBWIN, "view_rentcont", "left=5, top=50, width=1000, height=650, scrollbars=yes, status=yes");
	}
	
//-->
</script>
</head>
<body leftmargin="15">
<input type="hidden" name="prev_page" id="prev_page" value="<%=from_page%>"/>
<form action="./esti_memo_null_ui.jsp" name="form1" method="POST" >
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="gubun1" value="<%=gubun1%>">
	<input type="hidden" name="gubun2" value="<%=gubun2%>">
	<input type="hidden" name="gubun3" value="<%=gubun3%>">
	<input type="hidden" name="gubun4" id="gubun4" value="<%=gubun4%>">
	<input type="hidden" name="s_dt" id="s_dt" value="<%=s_dt%>">
	<input type="hidden" name="e_dt" id="e_dt" value="<%=e_dt%>">
	<input type="hidden" name="est_id" value="<%=est_id%>">
	<input type="hidden" name="set_code" value="">
	<input type="hidden" name="eh_code" value="">
	<input type="hidden" name="cmd" value="">
	<input type="hidden" name="spe_cmd" value="">
	<input type="hidden" name="gubun" value="">
	<input type="hidden" name="spe_seq" value="">
	<input type="hidden" name="est_table" value="">
	<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
	<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
	<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
	<input type="hidden" name="reg_code" value="<%=reg_code%>">
	<input type="hidden" name="st" value="">
	<input type="hidden" name="sendname" value="<%=u_bean.getUser_nm()%>">
	<input type="hidden" name="sendphone" value="<%=u_bean.getUser_m_tel()%>">
	<input type="hidden" name="user_pos" value="<%=u_bean.getUser_pos()%>">
	<input type="hidden" name="destphone" value="<%=e_bean.getEst_tel()%>">
	<input type="hidden" name="destname" value=<%if(!e_bean.getEst_agnt().equals("")){%>"<%=e_bean.getEst_agnt()%>"<%} else {%>"<%=e_bean.getEst_nm()%>"<%}%>>
	<input type="hidden" name="msg_type" value="5">
	<input type="hidden" name="msgs" value="">
	<input type="hidden" name="spe_car_nm" value=""> 
	<input type="hidden" name="spe_est_id" value="">
	<input type="hidden" name="from_page" value="/acar/estimate_mng/esti_spe_hp_i.jsp">
	<input type="hidden" name="shres_seq" value="">
	<input type="hidden" name="situation" value="">
	<input type="hidden" name="damdang_id" value="">
	<input type="hidden" name="shres_reg_dt" value="">
	<input type="hidden" name="shres_cust_nm" value="">
	<input type="hidden" name="shres_cust_tel" value="">
	<!-- 목록보기 클릭시 전단계 검색조건 유지를 위해 추가 -->
	<input type="hidden" name="period_gubun" id="period_gubun" value="<%=period_gubun%>">
	<input type="hidden" name="esti_m" id="esti_m" value="<%=esti_m%>">
	<input type="hidden" name="branch" id="branch" value="<%=branch%>"> <!-- 영업지점 검색 추가 -->
	
	<input type='hidden' name='badamt_chk_from' value='esti_spe_hp_i.jsp'>
	<input type='hidden' name='badamt_chk' value=''> 
	<input type='hidden' name='badcust_chk_from' value='esti_spe_hp_i.jsp'>
	<input type='hidden' name='badcust_chk' value=''>   
	<input type="hidden" name="sh_req" value="">
  
   
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr>
    <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
          <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 스마트견적관리 > <span class=style5>견적요청 보기 </span></span></td>
          <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align="right"><a href="javascript:go_list();"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
  </tr>
  <tr>
    <td class=line2></td>
  </tr>
	<tr>
    <td class="line">
 	    <table border="0" cellpadding=0 cellspacing="1" width=100%>
        <tr>
          <td class=title width=10%>성명/법인명</td>
          <td width=15%>&nbsp;<%=e_bean.getEst_nm()%>
          	<%if(e_bean.getClient_yn().equals("Y")){%>
          	<br>&nbsp; - 기존고객 
          	<%  //고객 확인
				Vector vt_chk2 = al_db.getClientRentCheck(e_bean.getEst_nm(), e_bean.getEst_nm(), "", bc_lic_no, e_bean.getEst_tel(), e_bean.getUrgen_tel(), "", e_bean.getEst_email(), e_bean.getEst_fax());
				int vt_chk2_size = vt_chk2.size();
				if(vt_chk2_size==1){
					Hashtable ht_cust = (Hashtable)vt_chk2.elementAt(0);
					client_id = String.valueOf(ht_cust.get("CLIENT_ID"));
			%>
						<input type="button" class="button" id="bad_amt" value='채권보기' onclick="javascript:view_dlyamt('<%=ht_cust.get("CLIENT_ID")%>');">
						<%	Vector conts = l_db.getContList(client_id);
							int cont_size = conts.size(); 							
							if(cont_size > 0){
								for(int i = 0 ; i < 1 ; i++){
									Hashtable cont = (Hashtable)conts.elementAt(i);%>
									<br>&nbsp; (최근 영업담당자 : <%=cont.get("USER_NM2")%>)
						<%		}
							}	
						%>			
          	<%	}%>
          	<%	if(vt_chk2_size>1){%> : 유사정보가 1건 이상입니다.
          	<span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
          	<% 		Hashtable ht_cust = (Hashtable)vt_chk2.elementAt(0);
					client_id = String.valueOf(ht_cust.get("CLIENT_ID"));
					Vector conts = l_db.getContList(client_id);
					int cont_size = conts.size(); 							
					if(cont_size > 0){
						for(int i = 0 ; i < 1 ; i++){
							Hashtable cont = (Hashtable)conts.elementAt(i);
			%>
									<br>&nbsp; (최근 영업담당자 : <%=cont.get("USER_NM2")%>)
						<%		}
							}	
						%>			
					
          	<%	}%>
          	<%}%> 
          	<%	//불량고객 확인
								//Vector vt_chk1 = bc_db.getBadCustRentCheck(e_bean.getEst_nm(), e_bean.getEst_nm(), "", bc_lic_no, e_bean.getEst_tel(), e_bean.getUrgen_tel(), e_bean.getEst_comp_tel(), e_bean.getEst_email(), e_bean.getEst_fax(), e_bean.getEst_comp_cel(), driver_cell);
								//int vt_chk1_size = vt_chk1.size();
								//if(vt_chk1_size>0){
						%> 
						      <!--  <br>&nbsp; - 불량고객 
						      <input type="button" class="button" id="bad_cust" value='내용보기' onclick="javascript:view_badcust('<%=e_bean.getEst_nm()%>', '<%=bc_lic_no%>', '<%=e_bean.getEst_tel()%>', '<%=e_bean.getUrgen_tel()%>', '<%=e_bean.getEst_email()%>', '<%=e_bean.getEst_fax()%>', '<%=e_bean.getEst_comp_tel()%>', '<%=e_bean.getEst_comp_cel()%>', '<%=driver_cell%>');">
						      -->
						      
						<%	//}%>          	  
          	<input type='hidden' name='client_id' value='<%=client_id%>'>   
          </td>
          <td width=10% class=title>생년월일<br>/사업자번호</td>
          <td width=15%>&nbsp;<%=e_bean.getEst_ssn()%><span id="koreanAge" style="color:red;"></span></td>
          <td width=10% class=title>담당자</td>
          <td width=15%>&nbsp;<%=e_bean.getEst_agnt()%></td>
          <td width=10% class=title>전화번호</td>
          <td width=15%>&nbsp;<%=AddUtil.phoneFormat(e_bean.getEst_tel())%></td>
        </tr>
        <tr>
          <td class=title>유선번호</td>
          <td>&nbsp;<%=AddUtil.phoneFormat(e_bean.getUrgen_tel())%></td>
          <td class=title>팩스번호</td>
          <td>&nbsp;<%=AddUtil.phoneFormat(e_bean.getEst_fax())%></td>
          <td class=title>업종</td>
          <td align="left">&nbsp;<%=e_bean.getEst_bus()%></td>
          <td class=title>업력/운전경력</td>
          <td>&nbsp;<%=e_bean.getEst_year()%><%=e_bean.getDriver_year()%></td>
        </tr>      
        <tr>
          <td class=title>회사연락처</td>
          <td>&nbsp;<%=AddUtil.phoneFormat(e_bean.getEst_comp_tel())%></td>
          <td class=title>대표자명</td>
          <td>&nbsp;<%=e_bean.getEst_comp_ceo()%></td>
          <td class=title>대표자연락처</td>
          <td align="left" colspan='3'>&nbsp;<%=AddUtil.phoneFormat(e_bean.getEst_comp_cel())%></td>
        </tr>               
		<tr>
          <td class=title>이메일</td>
          <td align="left">&nbsp;<%=e_bean.getEst_email()%></td>
          <td class=title>          
		  <%if (e_bean.getEst_st().equals("PE9") || e_bean.getEst_st().equals("PH9") || e_bean.getEst_st().equals("ME9") || e_bean.getEst_st().equals("MH9")) {%>
		  	고객주소지
		  <%}else{%>
		     지역
		  <%}%>
		  </td>
          <td>
          <%if (!e_bean.getEst_st().equals("ARS")) {%>
          &nbsp;<%=e_bean.getEst_area()%>
		  <%}%>
          </td>
          <td class=title>실거주지주소</td>
          <td align="left" colspan="3">&nbsp;<%=e_bean.getZipcode()%>&nbsp;<%=e_bean.getAddr1()%>&nbsp;<%=e_bean.getAddr2()%></td>
        </tr>
		<tr>
          <td class=title>계좌번호</td>
          <td align="left" colspan="3">&nbsp;<%=e_bean.getBank()%>&nbsp;<%=e_bean.getAccount()%></td>
          <td class=title>차량이용지 주소</td>
          <td align="left" colspan="3">&nbsp;<%=e_bean.getCar_use_addr1()%>&nbsp;<%=e_bean.getCar_use_addr2()%></td>
        </tr>
        <tr>
          <td class=title>기타요청사항</td>
          <td colspan="7">&nbsp;<%=e_bean.getEtc()%></td>
        </tr>    
        <% if(!shBn.getCar_mng_id().equals("")){ 
               Vector docList = c_db.getAcarAttachFileList("ESTI_SPE",est_id,-1);
        %>
        <tr>
          <td class="title">첨부서류</td>
          <td colspan="7">
          	<ul>
          		<%
          			String file_st[]	 = new String[4];
								file_st[0] = "001";
								file_st[1] = "002";
								file_st[2] = "003";
								file_st[3] = "004";
          			String file_nm[]	 = new String[4];
								file_nm[0] = "운전면허증사본";
								file_nm[1] = "자동이체계좌사본";
								file_nm[2] = "사업자등록증사본";
								file_nm[3] = "추가 운전자 운전면허증 사본";
          		%>
          		<%for(int j=0; j<4; j++){
          				String file_yn = "";
          		%>
          		<%	for(int i=0; i<docList.size(); i++){
          					//001 : 통장사본 , 002-003 : 사업자등록증 사본
          					Hashtable doc = (Hashtable)docList.elementAt(i);
          		    	String file_title = (String)doc.get("CONTENT_SEQ");
          		    	if(file_title.split("-")[1].equals(file_st[j])){
          						file_yn = "Y";
          		%>
          			<li><%=file_nm[j]%> : <a href="javascript:openPopP('<%=doc.get("FILE_TYPE")%>','<%=doc.get("SEQ")%>');" title='보기' ><%=doc.get("FILE_NAME")%></a>
          			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          			    <a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=doc.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
          			</li>          				
          		<%		}%>
          		<%	}
          				if(file_yn.equals("")){%>
          			<li> <%=file_nm[j]%> : &nbsp;<a href="javascript:scan_reg('ESTI_SPE','<%=est_id%>-<%=file_st[j]%>','<%=file_nm[j]%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></li>	
          		<%	}%>
          		<%}%>
          	</ul>
          </td>
        </tr>
        <% } %>
      </table>
    </td>
  </tr>
    <tr> 
        <td><font color=red>※ 불량고객 확인하기</font>
        	&nbsp;&nbsp;&nbsp;        	
        	<input type="button" class="button" id="bad_cust" value='고객확인' onclick="javascript:view_badcust('<%=e_bean.getEst_nm()%>', '<%=bc_lic_no%>', '<%=e_bean.getEst_tel()%>', '<%=e_bean.getUrgen_tel()%>', '<%=e_bean.getEst_email()%>', '<%=e_bean.getEst_fax()%>', '<%=e_bean.getEst_comp_tel()%>', '<%=e_bean.getEst_comp_cel()%>', '<%=driver_cell%>');">        	        	        	
        </td>
    </tr>
    <tr>  
  <%
    if(driverInfo.size() > 0){
  %>
  <tr>
	 <td class="h"></td>
  </tr>
  <tr>
	 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>운전자 정보</span></td>
  </tr>
  <tr>
	  <td class="line">
	 	<table border="0" cellpadding=0 cellspacing="1" width=100%>
	        <tr>
	          <td class=title width=10%>운전자명</td>
	          <td width=10% class=title>운전면허번호</td>
	          <td width=10% class=title>운전자 연락처</td>
	          <td width=10% class=title>비고</td>
	          <td width=10% class=title>면허취득년도</td>
	        </tr>
	        <%  for(int i=0; i<driverInfo.size(); i++){ 
	        		Hashtable driver = (Hashtable)driverInfo.elementAt(i);
	        		//면허취득년도 추가
	        		String get_d_num_year = ((String)driver.get("DRIVER_NUM")).replace("-","").substring(2,4);
	        		if(AddUtil.parseInt(get_d_num_year) >= 40)  	{	get_d_num_year = "19"+(String)get_d_num_year;	}
	        		else if(AddUtil.parseInt(get_d_num_year) < 40)	{	get_d_num_year = "20"+(String)get_d_num_year;	}
	        %>
	        <tr>
	        	<td align="center"><%if(driver.get("DRIVER_NM").equals("") && i == 0){%><%=e_bean.getEst_nm()%><%}else{%><%=driver.get("DRIVER_NM")%><%}%></td>
	        	<td align="center"><%=driver.get("DRIVER_NUM")%></td>
	        	<td align="center"><%if(driver.get("DRIVER_CELL").equals("") && i == 0){%><%=e_bean.getEst_tel()%><%}else{%><%=driver.get("DRIVER_CELL")%><%}%></td>
	        	<td align="center"><%if(i == 0){%>계약자 본인<%}else{%>추가 운전자<%} %></td>
	        	<td align="center"><%=get_d_num_year%> 년</td> <!-- 면허취득년도 추가 -->
	        </tr>
	        <%  } %>
	     </table>
	 </td>
  </tr>
  <%} %>
  <%if(e_bean2.getEst_id().equals("") && e_bean3.getEst_id().equals("")){%>
  <tr>
    <td class=h></td>
  </tr>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>희망차종</span></td>
	</tr>  
  <tr>
    <td class=line2></td>
  </tr>  
	<tr>
		<td class="line">
			<table border="0" cellpadding=0 cellspacing="1" width=100%>
				<%if(size>0){%>
        <tr>
          <td class=title width=3%>연번</td>
          <td class=title width=7%>구분</td>
          <td class=title width=25%>차명</td>
          <td class=title width=25%>옵션</td>
          <td class=title width=10%>색상</td>
          <td class=title width=10%>대여상품</td>
          <td class=title width=10%>대여기간</td>
          <td class=title width=10%>약정운행거리</td>
        </tr>
				<%	for(int i=0; i<size; i++){
    					EstimateBean car_bean = e_r[i];
							int a_a_len = car_bean.getA_a().length();
							String a_a[]	= new String[4];
							for(int j=0; j<4; j++){
								a_a[j] = "";
							}
							for(int j=0; j<a_a_len/2; j++){
								a_a[j] = car_bean.getA_a().substring(j*2,(j+1)*2);
							}
							if(!car_bean.getCar_mng_id().equals("")){
								//차량정보
								Hashtable ht = shDb.getShBase(car_bean.getCar_mng_id());
								car_bean.setEst_ssn	(c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")), "CAR_COM"));
								car_bean.setCar_nm	(String.valueOf(ht.get("CAR_NAME")));
								car_bean.setOpt			(String.valueOf(ht.get("OPT")));
								car_bean.setCol			(String.valueOf(ht.get("COL")));
							}
				%>
        <tr>
          <td align=center rowspan='2'><%=i+1%></td>
          <td align=center rowspan='2'>
									<%if(car_bean.getCar_mng_id().equals("")){%>
									[신차]
									<%}else{%>
									<%	if(car_bean.getA_b().equals("1")){%>[월렌트]<%}else{%>[재리스]<%}%> <%=car_bean.getEst_nm()%>
									<%}%>
					</td>
					<td align=center rowspan='2'><%=car_bean.getEst_ssn()%> <%=car_bean.getCar_nm()%> <%=car_bean.getCar_name()%></td>
					<td align=center><%=car_bean.getOpt()%></td>
					<td align=center><%=car_bean.getCol()%> <%=car_bean.getIn_col()%></td>
					<td align=center>
									<%for(int j=0; j<4; j++){%>
									<%	if(a_a[j].equals("11")){%>리스<br>일반식<%}%>
									<%	if(a_a[j].equals("12")){%>리스<br>기본식<%}%>
									<%	if(a_a[j].equals("21")){%>렌트<br>일반식<%}%>
									<%	if(a_a[j].equals("22")){%>렌트<br>기본식<%}%>
									<%}%>
					</td>
					<td align=center><%=car_bean.getA_b()%>개월</td>
					<td align=center><%=car_bean.getAgree_dist()%>km</td>
				</tr>
				<tr>
				  <td align=center colspan='5'>
									<%if(car_bean.getCar_mng_id().equals("")){//신차%>
									
									<%	if(!a_a[0].equals("") && !car_bean.getCar_id().equals("") && !car_bean.getCar_seq().equals("")){%>
									<a href="javascript:EstiATypeReg('2','<%=car_bean.getCar_mng_id()%>','<%=car_bean.getSeq()%>')"><img src=/acar/images/center/button_est_gb.gif align="absmiddle" border="0" alt="기본견적"></a>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<%	}%>
									
									<a href="javascript:EstiATypeReg('3','<%=car_bean.getCar_mng_id()%>','<%=car_bean.getSeq()%>')"><img src=/acar/images/center/button_est_jj.gif align="absmiddle" border="0" alt="조정견적"></a>
									
									<%	if(car_bean.getCar_id().equals("") && car_bean.getCar_seq().equals("")){%>
									        <br>* 세부차종 선택이 되지 않았습니다. 조정견적에서 차종 및 세부 조건 맞추어 견적하세요.
									<%	}%>
									
									<%}else{//재리스,월렌트%>
									
									<a href="javascript:EstiATypeReg('3','<%=car_bean.getCar_mng_id()%>','<%=car_bean.getSeq()%>')"><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a>
									
									<%}%>
				  </td>
				</tr>
				<%	}%>
				<%}else{%>
				<%		if(!e_bean.getCar_nm().equals("")){%>
        <tr>
          <td width=10% class=title>희망차종<%if(!e_bean.getCar_nm2().equals("")){%>1<%}%></td>
          <td>&nbsp;
	          	<%if (e_bean.getEst_st().equals("PE9") || e_bean.getEst_st().equals("PH9") || e_bean.getEst_st().equals("ME9") || e_bean.getEst_st().equals("MH9")) {%>
					<font style="color:red;">사전예약</font> - <%=e_bean.getCar_nm()%>
				<%}else{%>
				<%=e_bean.getCar_nm()%>
				&nbsp;&nbsp;&nbsp;&nbsp;
                <a href="javascript:EstiATypeRegSpe('<%=e_bean.getCar_nm()%>')"><img src=/acar/images/center/button_est_jj.gif align="absmiddle" border="0" alt="조정견적"></a>
				<%}%>
       			<%-- &nbsp;<%=e_bean.getCar_nm()%> --%>
									<%-- &nbsp;&nbsp;&nbsp;&nbsp;
                  <a href="javascript:EstiATypeRegSpe('<%=e_bean.getCar_nm()%>')"><img src=/acar/images/center/button_est_jj.gif align="absmiddle" border="0" alt="조정견적"></a> --%>          	
          </td>
        </tr>
			<%} else {%>
				
				<%if (e_bean.getEst_st().equals("PC4") || e_bean.getEst_st().equals("MO4") || e_bean.getEst_st().equals("ARS")) {%>
		<tr>
          <td width=10% class=title>희망차종</td>
          <td>&nbsp;<!-- <font style="color:blue;">사전예약</font> -  --><%=e_bean.getEtc()%>
          </td>
        </tr>
        		<%}%>      
        		  
			<%}%>
				
				<%		if(!e_bean.getCar_nm2().equals("")){%>
        <tr>
          <td class=title>희망차종2</td>
          <td>&nbsp;<%=e_bean.getCar_nm2()%>
									&nbsp;&nbsp;&nbsp;&nbsp;
                  <a href="javascript:EstiATypeRegSpe('<%=e_bean.getCar_nm2()%>')"><img src=/acar/images/center/button_est_jj.gif align="absmiddle" border="0" alt="조정견적"></a>          	
          	</td>
        </tr>
				<%		}%>
				<%		if(!e_bean.getCar_nm3().equals("")){%>
        <tr>
          <td class=title>희망차종3</td>
          <td>&nbsp;<%=e_bean.getCar_nm3()%>
									&nbsp;&nbsp;&nbsp;&nbsp;
                  <a href="javascript:EstiATypeRegSpe('<%=e_bean.getCar_nm3()%>')"><img src=/acar/images/center/button_est_jj.gif align="absmiddle" border="0" alt="조정견적"></a>          	
          	</td>
        </tr>
				<%		}%>
				<%}%>
      </table>
    </td>
  </tr>
  <%}else{%>  
  <tr>
    <td class=h></td>
  </tr> 
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(!e_bean3.getEst_id().equals("")){%>상담요청<%}else{%>실시간견적<%}%></span></td>
	</tr>    
	<tr>
		<td class="line">
			<table border="0" cellpadding=0 cellspacing="1" width=100%>
        <tr>
          <td class=title width=10%>구분</td>
          <td class=title width=15%>차명</td>
          <td class=title width=20%>옵션</td>
          <td class=title width=5%>색상</td>
          <td class=title width=5%>대여<br>상품</td>
          <td class=title width=5%>대여<br>기간</td>
          <td class=title width=7%>약정<br>운행거리</td>
          <td class=title width=5%>매입<br>옵션</td>
          <td class=title width=10%>선수금</td>
          <td class=title width=13%>보험</td>
          <td class=title width=5%>용품</td>
        </tr>
        <%
        	EstimateBean e_bean4 = new EstimateBean();
        	
        	if(!e_bean2.getEst_id().equals("")) e_bean4 = e_bean2;
        	if(!e_bean3.getEst_id().equals("")) e_bean4 = e_bean3;
        	
        	CarMstBean cm_bean = a_cmb.getCarNmCase(e_bean4.getCar_id(), e_bean4.getCar_seq());
        	
        	String est_st = "";
        	if(e_bean4.getMgr_nm().equals("")) { 
        		est_st = "신차";
        	}else{
        		if(e_bean4.getA_b().equals("1") && e_bean4.getMgr_ssn().equals("rm1")){	
        			est_st = "월렌트";
        		}else{	
        			est_st = "재리스";
        		}
        	}
        %>
        <tr>
          <td align=center><%=est_st%><%if(!cr_bean.getCar_no().equals("")){%>&nbsp;<%=cr_bean.getCar_no()%><%}%></td>
          <td align=center><%=cm_bean.getCar_comp_nm()%> <%=cm_bean.getCar_nm()%> <%=cm_bean.getCar_name()%></td>
          <td align=center><%=e_bean4.getOpt()%></td>
          <td align=center>외장: <%=e_bean4.getCol()%><br>내장: <%=e_bean4.getIn_col()%></td>
          <td align=center><%if(est_st.equals("월렌트")){%>월렌트<%}else{%><%=c_db.getNameByIdCode("0009", "", e_bean4.getA_a())%><%}%></td>
          <td align=center><%=e_bean4.getA_b()%>개월</td>
          <td align=center><%=AddUtil.parseDecimal(e_bean4.getAgree_dist())%>km/년</td>
          <td align=center><%if(e_bean4.getOpt_chk().equals("0")){%>미부여<%}else if(e_bean4.getOpt_chk().equals("1")){%>부여<%}%></td>
          <td align=center>
          	    보증금:<%=e_bean4.getRg_8()%>%
            <br>선납금:<%=e_bean4.getPp_per()%>%
            <br>보증보험:<%=e_bean4.getGi_per()%>%
          </td>
          <td align=center>
          	    운전자연령:<%if(e_bean4.getIns_age().equals("1")){%>만26세이상<%}else if(e_bean4.getIns_age().equals("2")){%>만21세이상<%}else if(e_bean4.getIns_age().equals("3")){%>만24세이상<%}%>
          	<br>대물/자손:<%if(e_bean4.getIns_dj().equals("1")){%>5천만원/5천만원<%}else if(e_bean4.getIns_dj().equals("2")){%>1억원/1억원<%}else if(e_bean4.getIns_dj().equals("4")){%>2억원/1억원<%}else if(e_bean4.getIns_dj().equals("8")){%>3억원/1억원<%}else if(e_bean4.getIns_dj().equals("3")){%>5억원/1억원<%}%>
          	<br>자차면책금:<%=AddUtil.parseDecimal(e_bean4.getCar_ja())%>원
          </td>
          <td align=center><%if(e_bean4.getTint_s_yn().equals("Y")){%>전면 썬팅<%}%><br>&nbsp;<%if(e_bean4.getTint_n_yn().equals("Y")){%>거치형 내비게이션<%}%><br>&nbsp;<%if(e_bean4.getTint_eb_yn().equals("Y")){%>이동형 충전기<%}%></td>
        </tr>        
        <tr>
          <td class=title>대여요금</td>
          <td colspan='3'>&nbsp;
          	월대여료 :  <%if(e_bean4.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt())%>원&nbsp;<%}%>
          	( 공급가 : <%if(e_bean4.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt())%>원&nbsp;<%}%>
          	  부가세 : <%if(e_bean4.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_v_amt())%>원&nbsp;<%}%>)
          </td>
          <td class=title colspan='2'>위약금</td>
          <td colspan='5'>&nbsp;
          	적용위약율 : <%=e_bean4.getCls_per()%>%&nbsp;
          	( 필요위약율 : <%=e_bean4.getCls_n_per()%>% )
          </td>
        </tr>
        
		<%if (est_st.equals("재리스")) {%>
        <tr>
        	<td class=title>현위치</td>
        	<td colspan='3'>&nbsp;
        		<%if (e_bean4.getBr_from().equals("0")) {%>서울<%}%>
                <%if (e_bean4.getBr_from().equals("1")) {%>대전<%}%>
                <%if (e_bean4.getBr_from().equals("2")) {%>대구<%}%>
                <%if (e_bean4.getBr_from().equals("3")) {%>광주<%}%>
                <%if (e_bean4.getBr_from().equals("4")) {%>부산<%}%>
        	</td>
        	<td class=title colspan='2'>고객주소지<br>(차량인도지역)</td>
        	<td colspan='5'>&nbsp;
        		<%if (e_bean4.getBr_to_st().equals("0")) {%>수도권<%}%>
                <%if (e_bean4.getBr_to_st().equals("1")) {%>대전/세종/충남/충북<%}%>
                <%if (e_bean4.getBr_to_st().equals("2")) {%>대구/경북<%}%>
                <%if (e_bean4.getBr_to_st().equals("3")) {%>광주/전남/전북<%}%>
                <%if (e_bean4.getBr_to_st().equals("4")) {%>부산/울산/경남<%}%>
                <%if (e_bean4.getBr_to_st().equals("5")) {%>강원<%}%>
                <input type="hidden" name="br_to_st" value="<%=e_bean4.getBr_to_st()%>">
        	</td>
        </tr>
		<%}%>
        
        <tr>
          <td class=title>견적서</td>
          <td colspan='3'>&nbsp;
			<%
			if(!e_bean2.getEst_id().equals("")){	// 홈페이지에서 견적을 낸 경우
			%>
						<a href="javascript:smartEstView(<%=e_bean2.getEst_id()%>)"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
			<%
			}else{	// 홈페이지 리뉴얼 이전의 견적
			%>
						<a href="javascript:EstiView('<%=est_st%>','<%=e_bean4.getEst_id()%>','<%=est_id%>')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
			<%
			}	
			%>			
          </td>
          <td class=title colspan='2'>비교견적</td>
          <td colspan='5'>&nbsp;
          		<%if (e_bean4.getPrint_type().equals("6")) {%>
					<a href="javascript:ReEsti6('<%=est_st%>','<%=e_bean4.getEst_id()%>','<%=e_bean4.getMgr_nm()%>','<%=est_id%>','<%=e_bean4.getSet_code()%>','<%=e_bean4.getEh_code()%>')"><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a>
          		<%} else {%>
					<a href="javascript:ReEsti('<%=est_st%>','<%=e_bean4.getEst_id()%>','<%=e_bean4.getMgr_nm()%>','<%=est_id%>')"><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a>
          		<%}%>
          </td>
        </tr>
        <%	//최근30일이내 견적여부
        	String rent_gubun = "1";
        	if(est_st.equals("신차")){		rent_gubun = "1";	}	//신차
        	else if(est_st.equals("재리스")){	rent_gubun = "7";	}	//재리스 
    		Vector vt_chk = e_db.getEstimateCustEstCheck(rent_gubun, e_bean.getEst_nm(), e_bean.getEst_ssn(), e_bean.getEst_tel(), e_bean.getEst_fax(), e_bean.getEst_email(), e_bean.getReg_dt().substring(0,8));
    		int vt_chk_size = vt_chk.size();
    		String est_check = "";
	    	if(vt_chk_size > 0){
	    		for (int i = 0 ; i < vt_chk_size ; i++){	
	           		Hashtable ht = (Hashtable)vt_chk.elementAt(i);
      				UsersBean user_bean 	= umd.getUsersBean(String.valueOf(ht.get("USER_NM")));
      				//일치여부 체크하여 문구추가(20180822)
      				String ssn_yn = String.valueOf(ht.get("SSN_YN"));	//주민등록번호/사업자번호 일치여부
      				String tel_yn = String.valueOf(ht.get("TEL_YN"));	//전화번호 일치여부
      				String fax_yn = String.valueOf(ht.get("FAX_YN"));	//팩스번호 일치여부	
      				String email_yn = String.valueOf(ht.get("EMAIL_YN"));	//이메일 일치여부
      				
      				if(!user_bean.getDept_id().equals("1000")){
      					if(i==0)	est_check += "&nbsp;&nbsp;##고객상호/이름 or 사업자등록번호 or 연락처 or FAX or 이메일주소로 검색한 결과## ["+String.valueOf(ht.get("EST_NM"))+"]는 최근 30일이내 견적한 고객입니다.<br><br>&nbsp;&nbsp;&lt;견적내역 검색결과&gt;<br>";
      					est_check += "&nbsp;&nbsp;("+ String.valueOf(ht.get("REG_DT2")) +") 견적담당자는 " +String.valueOf(ht.get("USER_NM"))+ " "+ String.valueOf(ht.get("USER_POS"))+ " " +String.valueOf(ht.get("USER_M_TEL"));
      					if(!ssn_yn.equals("Y")&&!tel_yn.equals("Y")&&!fax_yn.equals("Y")&&!email_yn.equals("Y")){
      						est_check += "&nbsp;&nbsp;고객상호/이름만 일치하는 건입니다. (실제 동일고객인지 확인 필요합니다)";
      					}
      					est_check += "<br>";
      				}
      				if(i==4) break;
	           	}
	    	}
	    	if(!est_check.equals("")){
        %>
		        <tr>
		        	<td class=title>견적이력</td>
		          	<td colspan='10'><br><%=est_check%><br></td>
		        </tr>
		<%	} %>        
      </table>
    </td>
  </tr> 
  <%}%>
  <%	if(!shBn.getCar_mng_id().equals("")){
  			Vector sr = shDb.getShResList(shBn.getCar_mng_id(), shBn.getReg_code(), shBn.getEst_id());
				int sr_size = sr.size();
  %>
  <tr>
    <td class=h></td>
  </tr>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량예약&nbsp;&nbsp;<a href="javascript:view_sh_res_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a></span>
	</tr>
  <tr>
    <td class=line2></td>
  </tr>
  <tr>
    <td class="line">
    	<table width="100%" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td class="title" width="5%">순위</td>
          <td class="title" width="10%">담당자</td>
          <td class="title" width="10%">진행상황</td>
          <td class="title" width="15%">예약기간</td>
          <td class="title" width="35%">메모</td>
          <td class="title" width="10%">등록일자</td>
          <td class="title" width="15%">처리</td>
        </tr>
				<%	int sh_res_reg_chk = 0;
						for(int i = 0 ; i < sr_size ; i++){
							Hashtable sr_ht = (Hashtable)sr.elementAt(i);
							
							if(String.valueOf(sr_ht.get("SITUATION")).equals("2") && String.valueOf(sr_ht.get("RES_NUM")).equals("1")) sh_res_reg_chk = 1;
				%>
        <tr> 
          <td align="center"><%=sr_ht.get("RES_NUM")%></td>
          <td align="center">
		  <%
		  	String damdangName = c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER");
		  	if(damdangName != "" && damdangName != null){
		  %>          	
		  	<%=damdangName%>
		  <%}else{%>
		  	<a href="javascript:registerDamdang('<%=String.valueOf(sr_ht.get("EST_ID"))%>')"><img src="../images/button_in_regd.gif" id="regBtn"/></a> <!-- 담당자가 없을 경우 담당자 등록 버튼이 나타난다 -->
		  <%} %>
          </td>
          <td align="center"><%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))				out.print("상담중");
        												else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("계약확정");
        												else if(String.valueOf(sr_ht.get("SITUATION")).equals("3"))		out.print("계약연동");%>
        	</td>
          <td align="center">
					  <%if(!String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>
					    <%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %>
					  <%}%>
					</td>
          <td>&nbsp;<%=sr_ht.get("CUST_NM")%>&nbsp;<%=sr_ht.get("CUST_TEL")%>&nbsp;<%=sr_ht.get("MEMO")%></td>
          <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %></td>
          <td align="center" rowspan="2">
          	
          	
          	<%	if(String.valueOf(sr_ht.get("EST_ID")).equals(est_id)){%>
          	
						<%		if(String.valueOf(ycont.get("CAR_ST")).equals("2")){%>          	
          	
          	<!--계약확정-->
					  <%			if(String.valueOf(sr_ht.get("RES_NUM")).equals("1") && String.valueOf(sr_ht.get("SITUATION")).equals("0") && !String.valueOf(sr_ht.get("USE_YN")).equals("N")){%>
					  <a href="javascript:reserveCar2Cng('<%=shBn.getCar_mng_id()%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>', '<%=sr_ht.get("CUST_NM")%>', '<%=sr_ht.get("CUST_TEL")%>');" title='차량예약 계약확정하기'><img src=/acar/images/center/button_in_dec.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
					  <%			}%>
					  
            <!--월렌트계약 연동-->
					  <%			if(String.valueOf(sr_ht.get("RES_NUM")).equals("1") && String.valueOf(sr_ht.get("SITUATION")).equals("2") && String.valueOf(sr_ht.get("USE_YN")).equals("Y") && rmcont_yn.equals("")){%>
					  <a href="javascript:RmContReg('<%=shBn.getCar_mng_id()%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='월렌트계약 연동하기'><img src=/acar/images/center/button_in_mlink.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
					  <%			}%>
					  
					  <%		}%>
					  
					  <!--예약취소-->
					  <%		if(String.valueOf(sr_ht.get("USE_YN")).equals("N")){%>
					  <%			if(String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>취소<%}else{%>만료<%}%>
					  <%		}else{%>
					  <a href="javascript:cancelCar('<%=shBn.getCar_mng_id()%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='차량예약 취소하기'><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a>
					  <%		}%>
					  
			<%	}%>
					  
          	
		  </td>
        </tr>
        <tr>
        	<td align="center" colspan="6">
        		 <%		if((String.valueOf(sr_ht.get("RES_NUM")).equals("1") && String.valueOf(sr_ht.get("SITUATION")).equals("0") && !String.valueOf(sr_ht.get("USE_YN")).equals("N"))||(String.valueOf(sr_ht.get("RES_NUM")).equals("1") && String.valueOf(sr_ht.get("SITUATION")).equals("2") && String.valueOf(sr_ht.get("USE_YN")).equals("Y") && rmcont_yn.equals(""))){%>
        		[준비물]   
        		<select name='sms_msg'>
                        <option value="">================선택================</option>
						            <option value="본인명의 신용카드(체크카드 불가), 운전면허증">일반개인/본인방문/본인만 운전</option>
						            <option value="본인명의 신용카드(체크카드 불가), 운전면허증, 추가운전자(배우자) 면허증 사본">일반개인/본인방문/추가운전자(배우자) 있는경우</option>
						            <option value="">------------------------------------------------------------</option>
						            <option value="본인명의 신용카드(체크카드 불가), 운전면허증, 사업자 사본">개인사업자/본인방문/본인만 운전</option>
						            <option value="본인명의 신용카드(체크카드 불가), 운전면허증, 사업자 사본, 추가운전자 [건강보험 자격확인서], 추가운전자 면허증사본">개인사업자/본인방문/추가운전자 있는경우</option>
						            <option value="개인사업자 명의 신용카드(체크카드는 불가), 계약자(개인사업자) 운전면허증 사본, 사업자 사본, 운전자 [건강보험 자격확인서], 운전자 면허증">개인사업자/직원방문/계약자 운전자 여부 상관없이</option>
						            <option value="">------------------------------------------------------------</option>
						            <option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 대표자 개인카드 [체크카드 불가], 대표이사 운전면허증, 사업자 사본">법인/대표자방문/본인만 운전</option>
						            <option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 대표자 개인카드 [체크카드 불가], 대표이사 운전면허증, 사업자 사본, 추가운전자 [건강보험 자격확인서], 추가운전자 면허증사본">법인/대표자방문/추가운전자 있는경우</option>
						            <option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 법인 임직원 개인카드 [체크카드 불가], 사업자 사본, 방문자 [건강보험 자격확인서], 방문자 운전면허증">법인/직원방문/방문자만 운전</option>
						            <option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 법인 임직원 개인카드 [체크카드 불가], 사업자 사본, 방문자 [건강보험 자격확인서], 방문자 운전면허증, 추가운전자 [건강보험 자격확인서], 추가운전자 면허증사본">법인/직원방문/추가운전자 있는경우</option>
				</select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				[차고지]   
				<select name='sms_msg2'>
					<option value="">================선택================</option>
					<!--<option value="seoul1">목동주차장:한마음 공영 주차장(서문출입구 직전 20m)</option>-->
					<option value="seoul">영등포주차장:영등포 영남주차장</option>
					<option value="busan1">부산주차장1:부산지점 하이트빌딩 3층</option>
					<option value="busan2">부산주차장2:웰메이드오피스텔 지하1층 주차장</option>
					<!-- <option value="daejeon1">대전주차장1:금호자동차공업사 2층 (주)아마존카 대전지점</option> -->
					<option value="daejeon2">대전주차장:(주)현대카독크 2층 (주)아마존카 대전지점</option>
					<option value="daegu">대구주차장:(주)성서현대정비센터</option>
					<option value="kwangju">광주주차장:상무1급자동차공업사</option>
				</select>
				<%} %>
        	</td>
        </tr>
				<%}%>
				<%if(sr_size==0){%>
        <tr>
          <td align="center" colspan="7">등록된 데이타가 없습니다.</td>
        </tr>
				<%}%>
      </table>
	  </td>
  </tr>
  <%}%>
  <tr>
  	<td>
  		<span style="color:red;display:none;" id="damdangInfo">*** 담당자가 없습니다. 담당자 등록하고 차량예약 업무진행하십시오</span></td>
  </tr>
  <!-- 배차현황추가 20190424 -->
  <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차현황</span></td>
    </tr>
	<%if(!use_st.equals("null")){%>
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">계약구분</td>
                    <% if (String.valueOf(reserv.get("RENT_ST")).equals("차량정비")) { %>
	                    <td width="34%">&nbsp;<a href="javascript:view_rentcont('<%=reserv.get("USE_ST")%>','<%=reserv.get("RENT_S_CD")%>');"><%=reserv.get("RENT_ST")%></a></td>
	                    <td class="title" width="16%">현위치</td>
						<td width="34%">&nbsp;			
							<%for(int i = 0 ; i < good_size ; i++){
								CodeBean good = goods[i];
								if(park.equals(good.getNm_cd()))%><%= good.getNm()%>
							<%}%>
						</td>
					<% } else { %>
						<td width="84%" colspan='3'>&nbsp;<a href="javascript:view_rentcont('<%=reserv.get("USE_ST")%>','<%=reserv.get("RENT_S_CD")%>');"><%=reserv.get("RENT_ST")%></a></td>	                    
					<% } %>
    		    </tr>
    		    <tr>
                    <td class="title" width="16%">대여기간</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_DT")))%>~<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT")))%>
					&nbsp;&nbsp;&nbsp;
					[등록] <%=AddUtil.ChangeDate2(String.valueOf(reserv.get("REG_DT")))%> <%=c_db.getNameById(String.valueOf(reserv.get("REG_ID")),"USER")%>
					</td>
					<td class="title" width="16%">사용자</td>
                    <td width="34%">&nbsp;<%=reserv.get("FIRM_NM")%>&nbsp;<%=reserv.get("CUST_NM")%></td>					
                </tr>
            </table>
	    </td>
    </tr>
    	<%	if(String.valueOf(reserv.get("RENT_ST")).equals("업무대여")){%>
	<input type="hidden" name="ret_dt" 		value="">
	<%	}else{%>
	<input type="hidden" name="ret_dt" 		value="<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT2")))%>">
	<%	}%>
	<%}else{%>
	<input type="hidden" name="ret_dt" 		value="">
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">계약구분</td>
                    <td width="34%">&nbsp;대기</td>
                    <td class="title" width="16%">현위치</td>
                    <td width="34%">&nbsp;
						<%for(int i = 0 ; i < good_size ; i++){
							CodeBean good = goods[i];
							if(park.equals(good.getNm_cd()))%><%= good.getNm()%>
						<%}%>
        			</td>
                </tr>
            </table>
	    </td>
    </tr>
	<%}%>
  <tr>
  	<td><hr></td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
  </tr>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>통화 내역</span></td>
	</tr>
  <tr>
    <td class=line2></td>
  </tr>
	<tr>
    <td class='line'> 
      <table  border=0 cellspacing=1 cellpadding="0" width="100%">
        <tr> 
          <td class=title width=10%>날짜</td>
          <td class=title width=10%>작성자</td>
          <td class=title width=80%>통화내용</td>
        </tr>
        <%for(int i=0; i<em_r.length; i++){
        		em_bean = em_r[i];
        %>
        <tr> 
          <td align=center><%= AddUtil.ChangeDate3(em_bean.getReg_dt()) %></td>
          <td align=center><%=c_db.getNameById(em_bean.getUser_id(), "USER")%></td>
          <td>&nbsp;<%=Util.htmlBR(em_bean.getNote())%></td>
        </tr>
        <%}%>
        <%if(em_r.length == 0){%>
        <tr> 
          <td align=center height=25 colspan="3">등록된 데이타가 없습니다.</td>
        </tr>
        <%}%>
			</table>
		</td>
	</tr>
  <tr>
  	<td class=h></td>
  </tr>
  <%if ( chk.equals("1") || !bb_chk.equals("") ) {%> 
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>통화관련 간편 클릭</span></td>
	</tr>
  <tr>
    <td align="left">   
      <a href="javascript:tell_save('00')"><img src=/acar/images/center/button_call_con.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
      <a href="javascript:tell_save('01')"><img src=/acar/images/center/button_call_bj.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
      <a href="javascript:tell_save('02')"><img src=/acar/images/center/button_call_nnum.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
	    <a href="javascript:msg_send()">[부재중문자발송]</a>&nbsp;&nbsp; 
    </td>
  </tr>
	<tr><td><font color=red>***</font>&nbsp;[통화연결]은 통화를 시도하는 시점에 누르지 말고 상담 요청한 고객과 전화로 연결된 순간에 클릭을 하여야 합니다.</td></tr>
  <% } %>
  <tr>
  	<td class=h></td>
  </tr>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>상담결과 입력</span></td>
	</tr>
  <tr>
    <td class=line2></td>
  </tr>
  <tr>
    <td class=line>
      <table border="0" cellspacing="1" width=100%>
        <tr>
          <td class=title width=10% rowspan="2">내용</td>
          <td>&nbsp;<textarea name="note" cols=100 rows=5 onBlur="javascript:change(this.value);" class=default></textarea>
            &nbsp;<a id="submitLink" href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
          </td>
        </tr>
        <tr>
          <td style="font-size:9pt">
					  &nbsp;03:나그네 04:담당자미확인 05:영업사원 06:기존업체 07:단기대여 08:비교견적中<br> 
					  &nbsp;09:오프리스조회 10:진행업체견적검토用 11:타사렌트(리스)로계약함 12:할부구매함<br>
					  &nbsp;13:장기간보류 14:미리검토함 15:검토중임 16:계약체결 17:무관심 18:기타 19:부재중문자발송
					</td>
        </tr>
      </table>
    </td>
  </tr>	
	<tr>
		<td>
			<font color=red>***</font>&nbsp;상단의 번호를 사용하시면 편리합니다.
		</td>
	</tr>
  <% if ( chk.equals("1") || !bb_chk.equals("") ) {%>
  <% } else {%>   
	<tr>
		<td>
			<font color=red>***</font>&nbsp;특별히 입력할 상담결과과 없으면 나가도 됩니다.
		</td>
	</tr>
	<% } %>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
<script>
//생년월일/사업자 번호 만나이 계산
function getKoreanAge(est_st, est_ssn){		// 계산 형식은 /fms2/lc_rent/search_age.jsp파일의 Search(birth) 함수 참고
	if(est_st.length == 3 && est_ssn != null){
		var substr_est_st = est_st.substr(2,1);
		if(substr_est_st == '3'){	// 개인일 때만 만나이 표시
			var regex = /[^0-9]/gi;
			var removeCharacter = est_ssn.replace(regex, "");	
						
			var birthYear;
			var birthFullYear;
			var birthMon;
			var birthDay;
			
			if(removeCharacter.length == 6){		// 810515 형식
				birthYear = removeCharacter.substr(0, 2);	// 숫자이외 제거
				if(birthYear > 20){	// 1921년도, 1922년, 1923년 ...
					birthFullYear = 19;
				}else {		// 2020년, 2019년, 2018년 ...
					birthFullYear = 20;
				}
				birthFullYear += birthYear;
				birthMon = removeCharacter.substr(2, 2);
				birthDay = removeCharacter.substr(4, 2);
			}else if(removeCharacter.length == 8){	// 19810515 형식
				birthFullYear = removeCharacter.substr(0, 4);
				birthMon = removeCharacter.substr(4, 2);
				birthDay = removeCharacter.substr(6, 2);
			}
			
			var birthdaymd = birthMon;
			birthdaymd += birthDay;
						
			var today = new Date();
			var year = today.getFullYear();
			var month = (today.getMonth()+1);
			var day = today.getDate();
			
			//var monthDay = month + day;	// monthDay 가 1218 형식으로 되어야 하나 정수형 덧셈이 이루어져서 
			var monthDay = month;
			monthDay += day.toString();	// 문자열로 변환 후 더할 수 있도록 변경함		2017.12.18
						
			var age = " (만 ";
			age += monthDay < birthdaymd ? year - birthFullYear -1 : year - birthFullYear;
			age += "세)";
						
			document.getElementById("koreanAge").innerText = age;
		}
	}
}

document.addEventListener('DOMContentLoaded', function(){
	getKoreanAge('<%=e_bean.getEst_st()%>', '<%=e_bean.getEst_ssn()%>');
});
	
</script>
</html>
