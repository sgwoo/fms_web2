<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.user_mng.*"%> 
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%	
	//계약번호 생성 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	LoginBean login = LoginBean.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();


	//로그인ID&영업소ID	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "07");


	
	//영업소 조회
	Vector branches = c_db.getUserBranchs("rent"); 			//영업소 리스트	
	int brch_size = branches.size();
	
	//자동차회사 리스트	
	CarCompBean cc_r [] = umd.getCarCompAllNew("1");

	
	
  //차종소분류
  CodeBean[] goods = c_db.getCodeAll2("0008", "Y");
  int good_size = goods.length;
	
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//자동차구분에 따른 디스플레이	
	function cng_input(param){
		var fm = document.form1;
		
		if(param == '0' || (param == '1' && fm.reject_car.checked == true)){	// 재리스이거나 인수거부차량 신차
			if(param == '0'){
				fm.reject_car.checked 		= false
			}
			fm.car_st.value = '';
			tr_base1.style.display		= '';
			tr_base2.style.display		= '';
			tr_base3.style.display		= '';
			fm.con_cd5.value = '';
			set_car_st();
			
			if(fm.car_name.value != '') fm.reset();
			tr_cartype_2.style.display		= '';					
			td_01.style.display			= 'none';	//출처
			td_02.style.display			= '';
			td_11.style.display			= 'none';	//제작회사
			td_12.style.display			= '';
			td_21.style.display			= 'none';	//차명
			td_22.style.display			= '';
			td_31.style.display			= 'none';	//차종
			td_32.style.display			= '';
			
		}else if(param == '1' && fm.reject_car.checked == false){			// 순수 신차					
			fm.car_st.value = '';
			tr_base1.style.display		= '';
			tr_base2.style.display		= '';
			tr_base3.style.display		= '';
			fm.con_cd5.value = '';
			set_car_st();
			
			if(fm.car_mng_id.value != '') fm.reset();
			tr_cartype_2.style.display		= 'none';
			td_01.style.display			= '';
			td_02.style.display			= 'none';			
			td_11.style.display			= '';
			td_12.style.display			= 'none';
			td_21.style.display			= '';
			td_22.style.display			= 'none';
			td_31.style.display			= '';
			td_32.style.display			= '';
			
		}else if(param == '2'){			// 중고차
			fm.reject_car.checked 		= false
			fm.car_st.value = '2';
			tr_base1.style.display		= 'none';
			tr_base2.style.display		= 'none';
			tr_base3.style.display		= 'none';
			set_car_st();
			
			if(fm.car_mng_id.value != '') fm.reset();
			tr_cartype_2.style.display		= 'none';
			td_01.style.display			= '';
			td_02.style.display			= 'none';			
			td_11.style.display			= '';
			td_12.style.display			= 'none';
			td_21.style.display			= '';
			td_22.style.display			= 'none';
			td_31.style.display			= '';
			td_32.style.display			= '';
			
		}else {
			alert("담당자에게 문의해주세요!");
		}
				
	}
	
	//계약코드에 영업소 코드 넣기
	function set_branch(){
		var fm = document.form1;
		var idx = fm.brch_id.selectedIndex;
		fm.con_cd1.value = fm.brch_id.options[idx].value;
		fm.mng_br_id[idx].selected = true;
	}

	//기존차 조회
	function car_search()
	{
		var fm = document.form1;
		var car_gu = "0";
		window.open("search_ext_car.jsp?car_gu="+car_gu, "EXT_CAR", "left=100, top=100, width=1200, height=700, scrollbars=auto, status=yes");
	}	
	
	//계약코드에 대여구분 코드 넣기
	function set_car_st(){
		var fm = document.form1;
		var car_st = fm.car_st.options[fm.car_st.selectedIndex].value;
		if(car_st == '1') 	fm.con_cd5.value = 'R';
		if(car_st == '2') 	fm.con_cd5.value = 'S';
		if(car_st == '3') 	fm.con_cd5.value = 'L';
		if(car_st == '4') 	fm.con_cd5.value = 'M';
		if(car_st == '5') 	fm.con_cd5.value = 'E';
		if(fm.con_cd5.value == 'S'){ 						//예비
			tr_base1.style.display		= 'none';
			tr_base2.style.display		= 'none';
			tr_base3.style.display		= 'none';
		}else if(fm.con_cd5.value == 'E'){ 			//업무대여
			tr_base1.style.display		= 'none';
			tr_base2.style.display		= 'none';
			tr_base3.style.display		= '';
		}else{																	//대여
			tr_base1.style.display		= '';
			tr_base2.style.display		= '';
			tr_base3.style.display		= '';
		}		
	}	
	
	//출처에 따른 자동차 제조사 출력하기
	function GetCarCompe(){
		var fm = document.form1;
		var fm2 = document.form2;
		var car_origin = fm.car_origin.options[fm.car_origin.selectedIndex].value;
		fm2.car_origin.value = car_origin;
		te = fm.car_comp_id;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.car_comp_id";
		fm2.mode.value = '0';
		fm2.target="i_no";
		fm2.submit();		
	}
	
	//자동차회사 선택시 차종코드 출력하기
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		var car_comp_id = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value;
		fm.con_cd3.value = car_comp_id.substring(0,1);
		fm2.car_comp_id.value = car_comp_id.substring(1);
		fm2.s_st.value = fm.s_st.options[fm.s_st.selectedIndex].value;
		if(fm.car_gu[2].checked == true){//중고차
			fm2.car_st.value = fm.car_st.options[fm.car_st.selectedIndex].value;
		}else{
			fm2.car_st.value = '';
		}		
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.code";
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}
	
	//차종코드 선택시 계약코드 출력하기
	function GetCarCd(){
		var fm = document.form1;	
		var code = fm.code.options[fm.code.selectedIndex].text;
		fm.con_cd4.value = code.substring(1,3);
	}
		
	//세부리스트
	function sub_list(idx){
		var fm = document.form1;
		if(fm.car_comp_id.value == '')		{ 	alert('자동차회사를 선택하십시오.'); 	return;}
		if(fm.code.value == '')			{ 	alert('차명을 선택하십시오.'); 		return;}
		var car_comp_id = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value.substring(1);
		var garnish_yn_opt_st = fm.garnish_yn_opt_st.value;
		var hook_yn_opt_st = fm.hook_yn_opt_st.value;
		var SUBWIN="search_esti_sub_list.jsp?idx="+idx+"&car_comp_id="+car_comp_id+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text+"&garnish_yn_opt_st="+garnish_yn_opt_st+"&hook_yn_opt_st="+hook_yn_opt_st;
		if(fm.car_gu[2].checked == true && idx == 1){//중고차
			SUBWIN="search_esti_sub_oldcar_list.jsp?idx="+idx+"&car_comp_id="+car_comp_id+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text+"&garnish_yn_opt_st="+garnish_yn_opt_st+"&hook_yn_opt_st="+hook_yn_opt_st;
		}
		window.open(SUBWIN, "SubList", "left=100, top=100, width=1200, height=850, scrollbars=yes, status=yes");
	}
	
	//다음단계로 넘어가기
	function save(){	
		var fm = document.form1;

		if(fm.rent_dt.value == '')		{ alert('계약일자를 확인하십시오.'); 		return;}
		if(fm.con_cd1.value == '')		{ alert('계약번호를 확인하십시오.'); 		return;}
		if(fm.con_cd2.value == '')		{ alert('계약번호를 확인하십시오.'); 		return;}
		if(fm.con_cd3.value == '')		{ alert('계약번호를 확인하십시오.'); 		return;}
		if(fm.con_cd4.value == '')		{ alert('계약번호를 확인하십시오.'); 		return;}
		if(fm.con_cd5.value == '')		{ alert('계약번호를 확인하십시오.'); 		return;}
		if(fm.car_origin.value == '')	{ alert('출처를 확인하십시오.'); 				return;}
		
		if(fm.car_st.value == '1' || fm.car_st.value == '3' || fm.car_st.value == '4'){
			if(fm.bus_id.value == '')		{ alert('최초영업자를 확인하십시오.'); 		return;}
			if(fm.rent_st.value == '')	{ alert('계약구분을 확인하십시오.'); 		return;}
			if(fm.bus_st.value == '')		{ alert('영업구분을 확인하십시오.'); 		return;}
			if(fm.rent_way.value == '')	{ alert('관리구분을 확인하십시오.'); 		return;}
			if(fm.bus_id.value.substring(0,1) == '1'){ alert('최초영업자가 부서로 선택되었습니다. 확인해주세요.'); return; }
			if(fm.bus_st.value == '7' && fm.agent_emp_id.value == '')		{ alert('에이전트 계약진행담당자를 선택하십시오.'); 		return;}
			if(fm.bus_agnt_id.value.substring(0,1) == '1'){ alert('영업대리인이 부서로 선택되었습니다. 확인해주세요.'); return; }
			if(fm.mng_br_id.value == ''){ alert('관리지점을 확인하십시오.'); 		return;}
			if(fm.est_area.value == '')	{ alert('차량이용지역(시/도)을 확인하십시오.'); 	return;}
			if(fm.county.value == '')		{ alert('차량이용지역(구/군)을 확인하십시오.'); 	return;}
			if(fm.est_area.value == '시/도'){ alert('차량이용지역(시/도)을 확인하십시오.'); 	return;}
			if(fm.county.value == '구/군'){ alert('차량이용지역(구/군)을 확인하십시오.'); 	return;}
		}

		if(fm.car_st.value == '5'){
			
			if(fm.car_gu[0].checked == true){
				alert('업무대여 신차인 경우 렌트로 입력하고 출고이후에 용도 변경하세요.'); return;
			}
			
			if(fm.mng_br_id.value == ''){ alert('관리지점을 확인하십시오.'); 		return;}
			if(fm.est_area.value == '')	{ alert('차량이용지역(시/도)을 확인하십시오.'); 	return;}
			if(fm.county.value == '')		{ alert('차량이용지역(구/군)을 확인하십시오.'); 	return;}
			if(fm.est_area.value == '시/도'){ alert('차량이용지역(시/도)을 확인하십시오.'); 	return;}
			if(fm.county.value == '구/군'){ alert('차량이용지역(구/군)을 확인하십시오.'); 	return;}
		}
				
		//대차인 경우
		if(fm.rent_st.value == '3'){	
			if(fm.grt_suc_l_cd.value == '')	{ alert('대차의 원계약을 입력하십시오.'); 	return;}
		}
		
		//20151116 신차인 경우 수동변속기 확인
		if(fm.car_gu[0].checked == true && fm.reject_car.checked == false){
			
			if(fm.col.value == '')		{ alert('외장색상을 선택하거나 입력하십시오.'); return; }
			if(fm.in_col.value == '')	{ alert('내장색상을 선택하거나 입력하십시오.'); return; }
			
			if (fm.garnish_yn_opt_st.value == "Y") {
				if(fm.garnish_col.value == "") {
					alert("가니쉬 옵션이 포함되어 있습니다. 가니쉬 색상을 선택해주세요.");
					return;
				}
			}
			
			var auto = 'M/T';
			
			if(fm.auto_yn.value == 'Y') auto = 'A/T';
			
			if(auto == 'M/T' && fm.car_b.value.indexOf('자동변속기') != -1){
				auto = 'A/T';
			}
			if(auto == 'M/T' && fm.opt.value.indexOf('변속기') != -1){
				auto = 'A/T';
			}
			if(auto == 'M/T' && fm.opt.value.indexOf('DCT') != -1){
				auto = 'A/T';
			}
			if(auto == 'M/T' && fm.opt.value.indexOf('C-TECH') != -1){
				auto = 'A/T';
			}	
			
			if(auto == 'M/T' && fm.opt.value.indexOf('A/T') != -1){
				auto = 'A/T';
			}	
			if(auto == 'M/T' && fm.car_b.value.indexOf('무단 변속기') != -1){
				auto = 'A/T';
			}
			
			if(auto == 'M/T'){
				if(!confirm('수동변속기 차량입니다. 1단계를 등록하시겠습니까?')){
					return;
				}
			}
		
		//20171106 재리스인 경우 차량용도랑 용도구분 화인
		}else if(fm.car_gu[1].checked == true){
			if(fm.car_use.value == '1' && fm.car_st.value == '3'){ 
				if(!confirm('영업용차량입니다. 리스로 계약등록하시겠습니까?')){
					return;
				}
			}else if(fm.car_use.value == '2' && fm.car_st.value == '1'){ 
				if(!confirm('자가용차량입니다. 렌트로 계약등록하시겠습니까?')){
					return;
				}
			}
		}
		
		fm.con_cd.value = fm.con_cd1.value+fm.con_cd2.value+fm.con_cd3.value+fm.con_cd4.value+fm.con_cd5.value;
		
		if(confirm('1단계를 등록하시겠습니까?')){
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action='lc_reg_step1_a.jsp';		
			fm.target='d_content';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}
	}
	
	function setColAmt(){
		var fm = document.form1;
		
		if(fm.car_gu[1].checked == true || (fm.car_gu[0].checked == true && fm.reject_car.checked == true)){
		
		}else{
			fm.col_s_amt.value =  parseDecimal(sup_amt(toInt(parseDigit(fm.col_amt.value))));
			fm.col_v_amt.value =  parseDecimal(toInt(parseDigit(fm.col_amt.value))-toInt(parseDigit(fm.col_s_amt.value)));
			
			fm.o_1.value 		= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)));
			fm.o_1_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_s_amt.value)) + toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.col_s_amt.value)));
			fm.o_1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_v_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)) + toInt(parseDigit(fm.col_v_amt.value)));
		}
	}
	
	//대차 원계약조회
	function search_suc_cont()
	{
		var fm = document.form1;	
		window.open("search_suc_cont.jsp", "SERV_SUC_CONT", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}
	
	function cng_suc_input(){
		var fm = document.form1;
		if(fm.rent_st.value == '3'){
			tr_suc.style.display	= '';
		}else{
			tr_suc.style.display	= 'none';
		}
	}
	
	//직원조회
	function User_search(nm, idx)
	{
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  				t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');
		fm.action = "/fms2/lc_rent/search_user.jsp?mode=EMP_Y&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();
	}
	//에이전트직원조회
	function Agent_User_search(nm)
	{
		var fm = document.form1;
		if(fm.bus_st.value != '7')	{ alert('영업구분이 에이전트일 때만 필요합니다.'); 		return;}
		if(fm.bus_id.value == '')		{ alert('최초영업자를 선택하십시오.'); 		return;}
		var t_wd = fm.agent_emp_nm.value;
		window.open("about:blank",'Agent_User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');
		fm.action = "/fms2/lc_rent/search_agent_user.jsp?mode=EMP_Y&nm="+nm+"&t_wd="+t_wd+"&agent_user_id="+fm.bus_id.value;
		fm.target = "Agent_User_search";
		fm.submit();
	}
	
	
//-->
</script>
<script language='javascript'>
<!--
     	var cnt = new Array();
     	cnt[0] = new Array('구/군');
		 	cnt[1] = new Array('구/군','강남구','강동구','강북구','강서구','관악구','광진구','구로구','금천구','노원구','도봉구','동대문구','동작구','마포구','서대문구','서초구','성동구','성북구','송파구','양천구','영등포구','용산구','은평구','종로구','중구','중랑구');
		 	cnt[2] = new Array('구/군','강서구','금정구','남구','동구','동래구','부산진구','북구','사상구','사하구','서구','수영구','연제구','영도구','중구','해운대구','기장군');
		 	cnt[3] = new Array('구/군','남구','달서구','동구','북구','서구','수성구','중구','달성군');
		 	cnt[4] = new Array('구/군','계양구','남구','남동구','동구','미추홀구','부평구','서구','연수구','중구','강화군','옹진군');
		 	cnt[5] = new Array('구/군','광산구','남구','동구','북구','서구');
		 	cnt[6] = new Array('구/군','대덕구','동구','서구','유성구','중구');
		 	cnt[7] = new Array('구/군','남구','동구','북구','중구','울주군');
		 	cnt[8] = new Array('구/군','세종특별자치시');
		 	cnt[9] = new Array('구/군','고양시','과천시','광명시','구리시','군포시','남양주시','동두천시','부천시','성남시','수원시','시흥시','안산시','안양시','오산시','의왕시','의정부시','평택시','하남시','가평군','광주시','김포시','안성시','양주시','양평군','여주군','연천군','용인시','이천시','파주시','포천시','화성시');
		 	cnt[10] = new Array('구/군','강릉시','동해시','삼척시','속초시','원주시','춘천시','태백시','고성군','양구군','양양군','영월군','인제군','정선군','철원군','평창군','홍천군','화천군','횡성군');
		 	cnt[11] = new Array('구/군','제천시','청주시','충주시','괴산군','단양군','보은군','영동군','옥천군','음성군','진천군','청원군','증평군');
		 	cnt[12] = new Array('구/군','공주시','계룡시','보령시','서산시','아산시','천안시','금산군','논산군','당진군','부여군','서천군','연기군','예산군','청양군','태안군','홍성군');
		 	cnt[13] = new Array('구/군','군산시','김제시','남원시','익산시','전주시','정읍시','고창군','무주군','부안군','순창군','완주군','임실군','장수군','진안군');
		 	cnt[14] = new Array('구/군','광양시','나주시','목포시','순천시','여수시','여천시','강진군','고흥군','곡성군','구례군','담양군','무안군','보성군','신안군','여천군','영광군','영암군','완도군','장성군','장흥군','진도군','함평군','해남군','화순군');
		 	cnt[15] = new Array('구/군','경산시','경주시','구미시','김천시','문경시','상주시','안동시','영주시','영천시','포항시','고령군','군위군','봉화군','성주군','영덕군','영양군','예천군','울릉군','울진군','의성군','청도군','청송군','칠곡군');
		 	cnt[16] = new Array('구/군','거제시','김해시','마산시','밀양시','사천시','울산시','진주시','진해시','창원시','통영시','거창군','고성군','남해군','산청군','양산시','의령군','창녕군','하동군','함안군','함양군','합천군');
		 	cnt[17] = new Array('구/군','서귀포시','제주시','남제주군','북제주군');

     	function county_change(add) {
     		var sel=document.form1.county
       		/* 옵션메뉴삭제 */
       		for (i=sel.length-1; i>=0; i--){
        		sel.options[i] = null
        	}
       		/* 옵션박스추가 */
       		for (i=0; i < cnt[add].length;i++){
        		sel.options[i] = new Option(cnt[add][i], cnt[add][i]);
        	}
     	}
//-->
</script>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body leftmargin="15">
<form action="get_car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_origin" value="">
  <input type="hidden" name="car_comp_id" value="">
  <input type="hidden" name="s_st" value="">
  <input type="hidden" name="car_st" value="">
  <input type="hidden" name="code" value="">
  <input type="hidden" name="car_id" value="">
  <input type="hidden" name="view_dt" value="">
  <input type="hidden" name="t_wd" value="">
  <input type="hidden" name="auth_rw" value="">
  <input type="hidden" name="mode" value="">
</form>
<form name='form1' action='' method='post'>
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="con_cd" value="">
  <input type="hidden" name="jg_opt_st" value="">
  <input type="hidden" name="jg_col_st" value="">
  <input type="hidden" name="jg_tuix_st" value="">
  <input type="hidden" name="jg_tuix_opt_st" value="">
  <input type="hidden" name="lkas_yn" value="">					<!-- 차선이탈 제어형 (차종포함) -->
  <input type="hidden" name="lkas_yn_opt_st" value="">		<!-- 차선이탈 제어형 (옵션) -->
  <input type="hidden" name="ldws_yn" value="">					<!-- 차선이탈 경고형 (차종포함) -->
  <input type="hidden" name="ldws_yn_opt_st" value="">		<!-- 차선이탈 경고형 (옵션) -->
  <input type="hidden" name="aeb_yn" value="">					<!-- 긴급제동 제어형 (차종포함) -->
  <input type="hidden" name="aeb_yn_opt_st" value="">		<!-- 긴급제동 제어형 (옵션) -->
  <input type="hidden" name="fcw_yn" value="">					<!-- 긴급제동 경고형 (차종포함) -->
  <input type="hidden" name="fcw_yn_opt_st" value="">		<!-- 긴급제동 경고형 (옵션) -->
  <input type="hidden" name="ev_yn" value="">					<!-- 전기차 여부 정보 -->
  <input type="hidden" name="garnish_yn" value="">				<!-- 가니쉬 여부 -->
  <input type="hidden" name="garnish_yn_opt_st" value="">	<!-- 가니쉬 여부(옵션) -->
  <input type="hidden" name="hook_yn" value="">				<!-- 견인고리 여부 -->
  <input type="hidden" name="hook_yn_opt_st" value="">	<!-- 견인고리 여부(옵션) -->
  <input type="hidden" name="others_device" value="">
  <input type="hidden" name="top_cng_yn" value="">
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td align='left'>&nbsp;&nbsp;<span class=style2> <font color=red>[1단계]</font>   계약번호 생성 및 기초사항 입력</span></td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> 계약번호 </td>
                    <td width="87%">&nbsp; 
        	      <input type='text' class='fix' name='con_cd1' size='2' value='' readonly>
                      -
                      <input type='text' class='fix' name='con_cd2' size='2' value='<%=AddUtil.getDate().substring(2,4)%>' readonly>
                      -
                      <input type='text' class='fix' name='con_cd3' size='1' value='' readonly>
                      -
                      <input type='text' class='fix' name='con_cd4' size='2' readonly>
                      -
                      <input type='text' class='fix' name='con_cd5' size='1' readonly>
                      -00000
        	    </td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align='left'>
	    		&nbsp;<label><input type='radio' name="car_gu" value='1' onClick="javascript:cng_input('1')" checked>
 					신차</label>
 					&nbsp;
 					( <input type="checkbox" name="reject_car" value="Y" onClick="javascript:cng_input('1')"> 인수거부 차량일 때 선택하세요. )
 					&nbsp; 					
  				    <label><input type='radio' name="car_gu" value='0' onClick="javascript:cng_input('0')">
					재리스</label>
					&nbsp;
					<label><input type='radio' name="car_gu" value='2' onClick="javascript:cng_input('2')">
					중고차</label>
				</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan="2" class='title'>항목</td>
                    <td width="70%" class='title'>선택</td>
                    <td width="17%" class='title'>금액</td>
                </tr>
                <tr> 
                    <td colspan="2" class='title'>영업지점</td>
                    <td>&nbsp; 
                      <select name='brch_id' onChange='javascript:set_branch()'>
                        <option value=''>선택</option>
                      <%		for (int i = 0 ; i < brch_size ; i++){
        							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%=branch.get("BR_ID")%>'><%= branch.get("BR_NM")%></option>
                      <%		}%>
                      </select>&nbsp;
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>관리지점</td>
                    <td>&nbsp;
                        <select name='mng_br_id'>
                            <option value=''>선택</option>
                            <%	if(brch_size > 0)	{
            						for (int i = 0 ; i < brch_size ; i++){
            							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                            <option value='<%=branch.get("BR_ID")%>'><%= branch.get("BR_NM")%></option>
                            <%		}
            					}%>
                        </select>
                    </td>   
                    <td>&nbsp;</td>
                </tr>                                 
                <tr id=tr_cartype_2 style='display:none'> 
                    <td colspan="2" class='title'>차량번호</td>
                    <td>&nbsp;
        			  <input type='text'   name='car_no' class='fix' size='15' readonly>
        			  <input type='hidden' name='car_mng_id' value=''>
        			  <input type='hidden' name='old_rent_mng_id' value=''>
        			  <input type='hidden' name='old_rent_l_cd' value=''>			  
        			  <input type='hidden' name='car_use' value=''>			  
                      <a href="javascript:car_search();"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td width="3%" rowspan="8" class='title'>자<br>
                    동<br>차</td>
                    <td width="10%" class='title'>출처</td>
                    <td><table width="100%" border="0" cellpadding="0">
                        <tr>
                          <td id=td_01 style="display:''">&nbsp;
                            <select name="car_origin" onChange="javascript:GetCarCompe()" class='default'>
                              <option value="">선택</option>
                              <option value="1" selected>국산</option>
                              <option value="2">수입</option>
                            </select></td>
                          <td id=td_02 style='display:none'>&nbsp;
        				  <input type='text' name="car_origin_nm" size='60' class='fix' readonly></td>
                        </tr>
                      </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title'>제작회사</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                              <td id=td_11 style="display:''">&nbsp;
                          		<select name="car_comp_id" onChange="javascript:GetCarCode()">
            					  <option value="">선택</option>
                            	<%	for(int i=0; i<cc_r.length; i++){
            					  		cc_bean = cc_r[i];%>
                            	  <option value="<%= cc_bean.getNm_cd() %><%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
                            	<%	}	%>
                          		</select>
                          		&nbsp;&nbsp;차명분류 : 
                          		<select name="s_st" onChange="javascript:GetCarCode()">
                        <option value="">=선 택=</option>
                        <%for(int i = 0 ; i < good_size ; i++){
                  CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>'><%= good.getNm()%></option>
                        <%}%>
                      </select> 
                      (중고차일때 차명분류 사용)
            				</td>
                              <td id=td_12 style='display:none'>&nbsp;
                                  <input type='text' name="car_comp_nm" size='60' class='fix' readonly></td>
                            </tr>
                        </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>차명</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td id=td_21 style="display:''">&nbsp;                    
                					<select name="code" onChange="javascript:GetCarCd()">
                                	  <option value="">선택</option>
                              		</select>
                					&nbsp; </td>
                                <td id=td_22 style='display:none'>&nbsp;
            				    <input type='text' name="car_nm" size='60' class='fix' readonly></td>
                            </tr>
                        </table> 
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>차종</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_31 style="display:''">&nbsp;                    
            					    <a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
            				    </td>
                                <td id=td_32 style="display:''">&nbsp;
                				  	<input type='text' name="car_name" size='60' class='fix' readonly>
                			  		<input type='hidden' name='car_id' value=''>
                			  		<input type='hidden' name='car_seq' value=''>
                					<input type='hidden' name='car_s_amt' value=''>
                					<input type='hidden' name='car_v_amt' value=''>
			        			<input type='hidden' name='auto_yn' value=''>
			        			<input type='hidden' name='car_b' value=''>
                					</td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='car_amt' size='10' value='' maxlength='15' class='fixnum' readonly>
        			  원</td>
                </tr>
                <tr> 
                    <td class='title'>옵션</td>
                    <td>
        			    <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_41 name="td_41" style="display:''">&nbsp;
            				        <a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>					
                                </td>
                                <td id=td_42 style="display:''">&nbsp;
	            				    <input type='text' name="opt" size='60' class='fix' readonly>
	            				    <input type='hidden' name='opt_seq' value=''>
	            				    <input type='hidden' name='opt_s_amt' value=''>
	            				    <input type='hidden' name='opt_v_amt' value=''>	            				    
            				    </td>
                            </tr>
                        </table>
                    </td>
                    <td align="center">
                    	<input type='text' name='opt_amt' size='10' value='' maxlength='13' class='fixnum' readonly>원
                    	<input type='hidden' name='opt_amt_m' value=''>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>색상</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_51 style="display:''">&nbsp;
            				        <a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                                </td>
                                <td id=td_52 style="display:''">&nbsp;
            				    <input type='text' name="col" size='50' class='text'>
								(내장색상(시트): <input type='text' name="in_col" size='20' class='text'> )
								(가니쉬색상: <input type='text' name="garnish_col" size='20' class='text'> )
            				    <input type='hidden' name='col_seq' value=''>
            				    <input type='hidden' name='col_s_amt' value=''>
            				    <input type='hidden' name='col_v_amt' value=''></td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='col_amt' size='10' value='' maxlength='13' class='num' onBlur="javascript:setColAmt()">원</td>
                </tr>
                <tr>
                	<td class="title">연비</td>
                	<td>
                		<table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_41 style="display:''">&nbsp;
            				        <a href="javascript:sub_list('5');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>					
                                </td>
                                <td id=td_42 style="display:''">&nbsp;
            				    <input type='text' name="conti_rat" size='60' class='fix' readonly>
            				    <input type='hidden' name='conti_rat_seq' value=''>
                            </tr>
                        </table>
                	</td>
                	<td></td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>차량가격</td>
                    <td align="center"><input type='text' name='o_1' size='10' value='' maxlength='13' class='fixnum' readonly>					
        				원<input type='hidden' name='o_1_s_amt' value=''><input type='hidden' name='o_1_v_amt' value=''></td>
                </tr>
                <tr> 
                    <td colspan="2" class='title'>용도구분</td>
                    <td>&nbsp; 
                        <select name="car_st" onChange='javascript:set_car_st()'>
                            <option value="">선택</option>
                            <option value="1">렌트</option>
                            <option value="3">리스</option>
                            <option value="5">업무대여</option>
                            <option value="2">예비</option>                            
                        </select>
                        &nbsp; </td>
                    <td>&nbsp;</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>계약일자</td>
                    <td  colspan="5">&nbsp;
                    <input type="text" name="rent_dt" value="<%=AddUtil.getDate()%>" size="11" maxlength='10' class='default' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <tr id=tr_base2 style="display:''">
                    <td width=13% class=title>계약구분</td>
                    <td width="20%">&nbsp;
                        <select name="rent_st" onChange="javascript:cng_suc_input()">
                          <option value=''>선택</option>
                          <option value='1'>신규</option>
                          <option value='3'>대차</option>
                          <option value='4'>증차</option>
                        </select></td>
                    <td width="10%" class=title>영업구분</td>
                    <td width="20%">&nbsp;
                        <select name="bus_st">
                          <option value="">선택</option>
                          <option value="1">인터넷</option>
                          <option value="8">모바일</option>
                          <option value="5">전화상담</option>
                          <option value="2">영업사원</option>
                          <option value="7">에이젼트</option>                          
                          <option value="6">기존업체</option>
                          <option value="3">업체소개</option>
                          <option value="4">catalog</option>                          
                        </select></td>
                    <td width="10%" class=title>관리구분</td>
                    <td width="27%">&nbsp;
                        <select name="rent_way">
                          <option value="">선택</option>
                          <option value="1">일반식</option>
                          <option value="3">기본식</option>
                        </select></td>
                </tr>
                <tr id=tr_base1 style="display:''">
                    <td class=title>최초영업자</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(user_id, "USER")%>" size="12"> 
			<input type="hidden" name="bus_id" value="<%=user_id%>">
			<a href="javascript:User_search('bus_id', '0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
                    </td>
                    <td class=title>계약진행담당자</td>
                    <td>&nbsp;
                    	<input name="agent_emp_nm" type="text" class="text"  readonly value="" size="12"> 
			                <input type="hidden" name="agent_emp_id" value="">
			                <a href="javascript:Agent_User_search('agent_emp_id');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			                (에이전트계약)
                    </td>       
                    <td class=title>영업대리인</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="" size="12"> 
			<input type="hidden" name="bus_agnt_id" value="">
			<a href="javascript:User_search('bus_agnt_id', '1');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
                    </td>					                         
                </tr>	
                <tr id=tr_base3 style="display:''">
                    <td class=title width=13%>차량이용지역</td>
                    <td  colspan="5">&nbsp;
								<select name='est_area' onchange="county_change(this.selectedIndex);">
								   <option value=''>시/도</option>
								   <option value='서울'>서울특별시</option>
								   <option value='부산'>부산광역시</option>
								   <option value='대구'>대구광역시</option>
								   <option value='인천'>인천광역시</option>
								   <option value='광주'>광주광역시</option>
								   <option value='대전'>대전광역시</option>
								   <option value='울산'>울산광역시</option>
								   <option value='세종'>세종특별자치시</option>
								   <option value='경기'>경기도</option>
								   <option value='강원'>강원도</option>
								   <option value='충북'>충청북도</option>
								   <option value='충남'>충청남도</option>
								   <option value='전북'>전라북도</option>
								   <option value='전남'>전라남도</option>
								   <option value='경북'>경상북도</option>
								   <option value='경남'>경상남도</option>
								   <option value='제주'>제주도</option>
								</select>&nbsp;
								<select name='county'>
								   <option value=''>구/군</option>
								</select>                        
					</td>

                </tr>					  
            </table>
	    </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr id=tr_suc style='display:none'>
        <td class='line'>            
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title' width=13%>대차 원계약</td>
                    <td>&nbsp; 
                      <span class="b"><a href="javascript:search_suc_cont()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;계약번호 : <input type='text' name='grt_suc_l_cd' size='15' value='' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='grt_suc_c_no' size='15' value='' class='whitetext' >
					    <input type="hidden" name="grt_suc_m_id" value="">
                    </td>
                </tr>
            </table>
	    </td>
    </tr>		
    <tr>
        <td>&nbsp;</td>
    </tr>
	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr>
	    <td align='right'><a id="submitLink" href="javascript:save();"><img src=/acar/images/center/button_next.gif align=absmiddle border=0></a></td>
	</tr>
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
	//영업지점 로그인자의 소속지점으로 셋팅
	document.form1.brch_id.value = '<%=br_id%>';
	set_branch();
//-->
</script>
</body>
</html>