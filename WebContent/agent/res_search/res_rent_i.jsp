<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.insur.*, acar.estimate_mng.*, acar.secondhand.*, acar.offls_pre.*, acar.car_mst.*,acar.cont.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="shDb" scope="page" class="acar.secondhand.SecondhandDatabase"/>
<jsp:useBean id="oh_db" scope="session" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>


<%
	CommonDataBase 	c_db 	= CommonDataBase.getInstance();
	LoginBean 	login 	= LoginBean.getInstance();
	InsDatabase 	ai_db 	= InsDatabase.getInstance();	
	EstiDatabase edb		= EstiDatabase.getInstance();
	

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
	
	
	//로그인ID&영업소ID&권한	
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "22", "05", "03");
	
	
	String c_id 		= request.getParameter("c_id")		==null?"":request.getParameter("c_id");
	String rent_st 		= request.getParameter("rent_st")	==null?"":request.getParameter("rent_st");
	String rent_start_dt 	= request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt 	= request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt");
	String use_st 		= request.getParameter("use_st")	==null?"":request.getParameter("use_st");	
	String ins_st 		= request.getParameter("ins_st")	==null?"":request.getParameter("ins_st");
	String rent_mon		= request.getParameter("rent_mon")	==null?"":request.getParameter("rent_mon");
	
	
	//영업소 리스트 조회
	Vector branches = c_db.getBranchList(); 
	int brch_size = branches.size();
	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();	
	
	
	

	
	
	
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	
	//예약현황
	Vector conts = rs_db.getResCarList(c_id);
	int cont_size = conts.size();
	
	
	int use_cnt = 0;
	int rent_cnt = 0;
	
	if(cont_size > 0){
  		for(int i = 0 ; i < cont_size ; i++){
    			Hashtable reservs = (Hashtable)conts.elementAt(i);
    			if(String.valueOf(reservs.get("USE_ST")).equals("예약") || String.valueOf(reservs.get("USE_ST")).equals("배차")){
				use_cnt ++;
				if(String.valueOf(reservs.get("USE_ST")).equals("예약") && String.valueOf(reservs.get("RENT_ST")).equals("장기대기")){
					rent_cnt ++;
				}
			}
		}
	}
	
	
	//최근 홈페이지 적용대여료
	Hashtable hp = oh_db.getSecondhandCase_20090901("", "", c_id);	
	

	//보험정보
	if(ins_st.equals("")) ins_st = ai_db.getInsSt(c_id);
	InsurBean ins = ai_db.getIns(c_id, ins_st);
	String ins_com_nm = ai_db.getInsComNm(c_id);
	
	
	//견적정보
	String est_id = "";
	
			
	//차량정보
	Hashtable sb_ht = shDb.getShBase(c_id);
	
	String tot_dist 		= String.valueOf(sb_ht.get("TOT_DIST"));
	String today_dist 		= String.valueOf(sb_ht.get("TODAY_DIST"));
	String serv_dt	 		= String.valueOf(sb_ht.get("SERV_DT"));
	
	
	//탁송구간
	CodeBean[] codes2 = c_db.getCodeAll_0022("0022");
	int c_size2 = codes2.length;
	
	
	String rent_mng_id = String.valueOf(reserv.get("RENT_MNG_ID"));
	String rent_l_cd = String.valueOf(reserv.get("RENT_L_CD"));
	
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	
	//차종코드 
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	

	String rent_months	= "";
	String rent_days	= "";
	
	int fee_amt = 0;	
	int fee_amt_m = 0;
	int fee_amt_d = 0;
	int fee_amt_h = 0;
	
	//공휴일 정보
		Vector hdays = c_db.getHolidayList();
		int hdaysSize = hdays.size();
		String[] hdaysArray = new String[hdaysSize];
		for (int i = 0 ; i < hdaysSize ; i++){
			Hashtable hday = (Hashtable)hdays.elementAt(i);
//	 		System.out.println(hday.get("HDAY"));
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
<!-- <script src="http://code.jquery.com/jquery-1.10.2.js"></script> -->
<!-- <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script> -->
<script language="JavaScript">
<!--
	var hdaysArray = "<%=Arrays.toString(hdaysArray)%>".replaceAll("[","").replaceAll("]","").split(",");
	//단기대여---------------------------------------------------------------------------------------------------------
	
	//고객 조회
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

	

	//대여일수 구하기
	function getRentTime() {
					
		var fm = document.form1;
				
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  		// 1시간
		lm = 60*1000;  	 	 	// 1분
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
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}

	//시분 세팅	
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
		

	
	//저장하기
	function save(){
		var fm = document.form1;
		var rent_st = $("#rent_st").val();
		var ins_change_flag = $("#ins_change_flag").is(":checked");
		var ins_change_flag_input = "";
		
		// 21세만 해당
		if(ins_change_flag) {
			ins_change_flag_input = "N"; // 보유차 보험 변경 X
		} else {
			ins_change_flag_input = "Y"; // 보유차 보험 변경 O
		}
		
		$("#ins_change_flag_input").val(ins_change_flag_input);
		
		if(rent_st == "3" || rent_st == "2" || rent_st == "10"){
			if(fm.c_cust_id.value == '') { 
				alert('고객 원계약 정보를 선택하세요.');
				return;
			} 
			var age1 = 0; // 대여 차량 보험 연령
			var age2 = 0; // 계약 차량 보험 연령
			var rent_start_dt = $("#rent_start_dt").val().replaceAll("-",""); // 약정 기간 시작일
			var rent_end_dt = $("#rent_end_dt").val().replaceAll("-",""); // 약정 기간 종료일
			var ins_change_std_dt = $("#ins_change_std_dt").val().replaceAll("-",""); // 보험 변경 기준일

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
			
			if((rent_st == "3" && (age1 > age2)) || (rent_st == "10" && (age1 > age2)) ) {
				if(!$("#ins_change_std_dt").val()) {
					alert("보험변경 기준일을 입력하세요.");
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
				var week = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');
				var todayLabel = week[day];
				var hours = today.getHours();
				var today_yyyymmdd = year+month+date;
				
				if(parseInt(rent_start_dt) >= parseInt(rent_end_dt)) {
					alert("약정 기간 시작일과 종료일을 확인하세요.");
					return;
				} 
				if(ins_change_flag_input == "Y") {
					// 오후 5시 이전인 경우
					if(hours < 17) {
						if(parseInt(ins_change_std_dt) >= parseInt(rent_start_dt)) {
							alert("보험 변경 기준일은 약정 기간의 시작일 보다 빨라야합니다.\n확인 후 다시 저장하세요.");
							return;
						} else if(parseInt(ins_change_std_dt) < parseInt(today_yyyymmdd)) {
							alert("보험 변경 기준일은 오늘보다 빠를 수 없습니다.\n확인 후 다시 저장하세요.");
							return;
						}  
					} 
					// 오후 5시 이후인 경우
					else {
						if(parseInt(ins_change_std_dt) == parseInt(today_yyyymmdd)) {
							alert("오후 17시 이후는 보험 업무 마감으로 보험 변경 기준일을 당일로 지정할 수 없습니다.\n당일 날짜로 등록이 필요한 경우 보험 담당자에게 문의하세요.");
							return;
						} else if(parseInt(ins_change_std_dt) >= parseInt(rent_start_dt)) {
							alert("보험 변경 기준일은 약정 기간의 시작일 보다 빨라야합니다.\n확인 후 다시 저장하세요.");
							return;
						} else if(parseInt(ins_change_std_dt) < parseInt(today_yyyymmdd)) {
							alert("보험 변경 기준일은 오늘보다 빠를 수 없습니다.\n확인 후 다시 저장하세요.");
							return;
						}   
					}
				}
			}
		}
		if(toInt(fm.rent_cnt.value) > 0){
			if(!confirm('재리스 계약확정되어 장기대기로 예약되어 있는 차량입니다.\n\n등록하시겠습니까?')){	return;	}
		}else{
			if(toInt(fm.use_cnt.value) > 0){
				if(!confirm('현재 예약 혹은 배차중인 차량입니다.\n\n등록하시겠습니까?')){	return;	}
			}
		}
				
		if(fm.c_id.value == '')		{ alert('차량선택이 잘못되었습니다\n\n목록에서 선택하십시오'); 		return; }
		if(fm.rent_st.value == '')	{ alert('계약구분이 잘못되었습니다\n\n전페이지에서 선택하십시오'); 	return; }		
		

		if(fm.c_cust_id.value == '')		{ alert('고객을 선택하십시오'); return; }
		if(fm.c_cust_id.value == '000228')	{ alert('아마존카로는 입력할 수 없습니다. 고객을 선택하십시오'); return; }

		
		if(fm.rent_dt.value == '')	{ alert('계약일자를 입력하십시오'); 		fm.rent_dt.focus(); 		return; }
		if(fm.s_brch_id.value == '')	{ alert('영업소를 입력하십시오'); 		fm.brch_id.focus(); 		return; }
		if(fm.bus_id.value == '')	{ alert('담당자를 입력하십시오'); 		fm.bus_id.focus(); 		return; }
		if(fm.rent_start_dt.value == ''){ alert('이용기간 시작일시를 입력하십시오'); 	fm.rent_start_dt.focus(); 	return; }
		if(fm.deli_plan_dt.value == '')	{ alert('배차예정일시를 입력하십시오'); 	fm.deli_plan_dt.focus(); 	return; }
		
		if(fm.age_scp.value != fm.d_car_ins_age_cd.value){ 
			if(!confirm('사유발생차량과 대차차량의 보험연령이 다릅니다. 등록하시겠습니까?')){	return;	}
		}	
		
		
		if(!max_length(fm.deli_loc.value,40)){	alert('배차위치 길이는 '+get_length(fm.deli_loc.value)+'자(공백포함) 입니다.\n\n사유는 한글20자/영문40자까지 입력이 가능합니다.'); return; } 
		if(!max_length(fm.ret_loc.value,40)) {	alert('반차위치 길이는 '+get_length(fm.ret_loc.value)+'자(공백포함) 입니다.\n\n사유는 한글20자/영문40자까지 입력이 가능합니다.'); return; } 		
		
		
		
		if(fm.rent_start_dt.value != '')
			fm.h_rent_start_dt.value = fm.rent_start_dt.value+fm.rent_start_dt_h.value+fm.rent_start_dt_s.value;
		if(fm.rent_end_dt.value != '')
			fm.h_rent_end_dt.value = fm.rent_end_dt.value+fm.rent_end_dt_h.value+fm.rent_end_dt_s.value;
		if(fm.deli_plan_dt.value != '')
			fm.h_deli_plan_dt.value = fm.deli_plan_dt.value+fm.deli_plan_dt_h.value+fm.deli_plan_dt_s.value;
		if(fm.ret_plan_dt.value != '')
			fm.h_ret_plan_dt.value = fm.ret_plan_dt.value+fm.ret_plan_dt_h.value+fm.ret_plan_dt_s.value;
		
		if(!confirm('등록하시겠습니까?')){	return;	}
			
		fm.action = 'res_rent_i_a.jsp';
//		fm.target = 'd_content';
		fm.target='i_no';
		fm.submit();
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
            ,buttonText: "선택"           
            ,yearSuffix: "년" 
            ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12']
            ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
            ,dayNamesMin: ['일','월','화','수','목','금','토'] 
            ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] 
            ,minDate: "-0D" //(-1D:하루, -1M:한 달, -1Y:일 년)
	         ,beforeShowDay: function(date){
	             show = true;
	             if(date.getDay() == 0 || date.getDay() == 6){show = false;} // 주말 제외
	             for (var i = 0; i < hdaysArray.length; i++) {
	                 if (new Date(hdaysArray[i]).toString() == date.toString()) {show = false;} // 공휴일 제외
	                 
	             }
	             var display = [show,'',(show)?'':'주말 및 공휴일 선택 불가'];
	             return display;
	         }
        });                    
        
        $('#ins_change_std_dt').datepicker('setDate', 'today'); // 최초 날짜 세팅 시 오늘 날짜 설정
        $(".ui-datepicker-trigger").css("margin-left","3px"); // 캘린더 이미지 위치 조정
        $(".ui-datepicker-trigger").css("margin-bottom","-3px"); // 캘린더 이미지 위치 조정
        
	 });
	
	$(document).ready(function(){
	    $("#ins_change_flag").change(function(){
	        if($("#ins_change_flag").is(":checked")){
	            alert("보험연령 21세 고객, 대차 차량 21세로 연령 변경 없음을 체크 하셨습니다.\n실제 연령 변경 신청이 안 되며 대차 차량은 이후 사고 발생 시 자동차 보상처리가 면책 처리되며 모든 담당자 또는 고객은 서로 간의 고지의 유무에 따라 과실자가 정해지며 책임있는 사유로 그 손해를 배상할 책임을 집니다.");
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
 <input type='hidden' name='from_page' value='/agent/res_search/res_rent_i.jsp'>
 <input type='hidden' name='site_id' value=''>
 <input type='hidden' name='mng_id' value=''>
 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 영업지원 > 예약관리 > <span class=style5>예약등록 ( 
                    지연대차
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
        <td width="30%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span></td>
        <td align="right" width="70%"></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>차량번호</td>
                    <td>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class=title>차명</td>
                    <td align="left" colspan="3">&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)&nbsp;</td>
                    <td class=title>차대번호</td>
                    <td colspan=3>&nbsp;<%=reserv.get("CAR_NUM")%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>최초등록일</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                    <td class=title width=10%>출고일자</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
                    <td class=title width=11%>배기량</td>
                    <td width=10%>&nbsp;<%=reserv.get("DPM")%>cc</td>
                    <td class=title width=10%>칼라</td>
                    <td width=10%>&nbsp;<%=reserv.get("COLO")%></td>
                    <td class=title width=9%>연료</td>
                    <td width=10%>&nbsp;<%=reserv.get("FUEL_KD")%></td>
                </tr>
                <tr> 
                    <td class=title>선택사양</td>
                    <td colspan="9">&nbsp;<%=reserv.get("OPT")%></td>                                        
                </tr>
				<tr> 
                    <td class=title width=10%>검사유효기간</td>
                    <td width=23% colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%></td>
                    <td class=title>차령만료일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("CAR_END_DT")))%></td>
                    <td class=title>점검유효기간</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_END_DT")))%></td>
                </tr>                
                <!--보험정보-->
                <tr> 
                    <td class=title>보험회사</td>
                    <td >&nbsp;<%=ins_com_nm%>
        			<%if(ins.getVins_spe().equals("애니카")){%>(애니카)<%}%>
        			</td>
                  <td class=title>피보험자</td>
                  <td>&nbsp;<%if(ins.getCon_f_nm().equals("아마존카")){%><%=ins.getCon_f_nm()%><%}else{%><b><font color='#990000'><%=ins.getCon_f_nm()%></font></b><%}%></td>
                  <td class=title>보험연령</td>
                  <td>&nbsp;
                    	<%if(ins.getAge_scp().equals("1")){%>21세이상<%}%>
                        <%if(ins.getAge_scp().equals("4")){%>24세이상<%}%>
                        <%if(ins.getAge_scp().equals("2")){%>26세이상<%}%>
                        <%if(ins.getAge_scp().equals("3")){%>전연령<%}%>
                        <%if(ins.getAge_scp().equals("5")){%>30세이상<%}%>
                        <%if(ins.getAge_scp().equals("6")){%>35세이상<%}%>
                        <%if(ins.getAge_scp().equals("7")){%>43세이상<%}%>
						<%if(ins.getAge_scp().equals("8")){%>48세이상<%}%>
						<%if(ins.getAge_scp().equals("9")){%>22세이상<%}%>
						<%if(ins.getAge_scp().equals("10")){%>28세이상<%}%>
						<%if(ins.getAge_scp().equals("11")){%>35세이상~49세이하<%}%>
			<input type="hidden" name="age_scp" value="<%=ins.getAge_scp()%>" id="age_scp_1">
                  </td>   
                    <td class=title>예상주행거리</td>
                    <td colspan="3">&nbsp;&nbsp;<%=AddUtil.parseDecimal(today_dist)%>km&nbsp;(최종입력:<%=AddUtil.parseDecimal(tot_dist)%>km, <%=AddUtil.ChangeDate2(serv_dt)%>)   	    	      
                    </td>                         			
                </tr>                
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("11")||rent_st.equals("12")){%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right">                
        </td>
    </tr>

    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>구분 </td>
                    <td width=21%> 
                      &nbsp;
					  <select name='cust_st'>
                        <option value='1'>고객</option>
                      </select>
					  &nbsp;<a href="javascript:cust_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>					 
                    </td>
                    <td class=title width=10%>성명</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="c_cust_nm" value="" size="30" class=whitetext>
                    </td>
                    <td class=title width=10%>생년월일</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="c_ssn" value="" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>상호</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="c_firm_nm" value="" size="80" class=whitetext>
                    </td>
                    <td class=title>사업자등록번호</td>
                    <td> 
                      &nbsp;<input type="text" name="c_enp_no" value="" size="15" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>비상연락처</td>
                    <td  colspan='5'> 
                      <input type="hidden" name="mgr_st2" value="2">
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 성명:&nbsp; 
                      <input type="text" name="mgr_nm2" value="" class=text size="10">
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 연락처:&nbsp; 
                      <input type="text" name="m_tel2" value="" size="15" class=text>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> 관계:&nbsp; 
                      <input type="text" name="m_etc2" value="" size="58" class=text>
                    </td>
                </tr>
                <tr>
                    <td class=title>보험연령</td>
                    <td colspan='5'>
                      &nbsp;<input type="text" name="d_car_ins_age" size="20" class=whitetext>
                        <input type="hidden" name="d_car_ins_age_cd" value="" id="age_scp_2"></td>
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

	<tr><td class=h></td></tr>					
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약정보</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td width=15%> 
                      &nbsp;<input type="text" name="rent_s_cd" value="" size="10" class=whitetext>
                    </td>
                    <td class=title width=10%>계약일자</td>
                    <td width=16%> 
                      &nbsp;<input type="text" name="rent_dt" value="<%=AddUtil.getDate()%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>영업소</td>
                    <td width=15%> 
                      &nbsp;<select name='s_brch_id'>
                        <option value=''>전체</option>
                        <%if(brch_size > 0){
        					for (int i = 0 ; i < brch_size ; i++){
        						Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%= branch.get("BR_ID") %>' <%if(br_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width=10% class=title><%if(rent_st.equals("12")){%>최초영업자<%}else{%>담당자<%}%></td>
                    <td width=14%> 
                      &nbsp;<select name='bus_id'>
                        <option value="">미지정</option>
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
	                	if(client_st =='법인' && parseInt(<%=ej_bean.getSh_code()%>)>1999999 && parseInt(<%=ej_bean.getSh_code()%>)<7000000){
		                	$('#com_emp_yn_td').show();
	                	}else if(client_st =='법인' && parseInt(<%=ej_bean.getSh_code()%>)>1999 && parseInt(<%=ej_bean.getSh_code()%>)<7000){
	                		$('#com_emp_yn_td').show();		
		                }else{
		                	$('#com_emp_yn_td').hide();
		                }
	                }
               	
                </script>
                 
              <tr id="com_emp_yn_td" style="display:none;">
                <td class=title>임직원운전한정특약</td>
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
							<option value="Y" id="com_emp_y"<%if(com_emp_yn.equals("Y")){%> selected <%}%>>가입</option>
							<option value="N" id="com_emp_n" <%if(com_emp_yn.equals("N")){%> selected <%}%>>미가입</option>
						</select>
						 &nbsp;&nbsp;※  주의사항 :
                     	 <input type="text" name="m_etc2" value="신차계약(본 계약)의 보험 선택이 임직원운정한정특약 가입이면 가입으로, 미가입이면 미가입으로 선택" size="120" class=text  readonly="readonly" style="font-weight:bold;border:none;">
						
                    </td>  
                </tr>
                
                <tr> 
                    <td class=title>약정기간</td>
                    <td colspan="5"> 
                      &nbsp;<input type="text" name="rent_start_dt" id="rent_start_dt" value="<%=AddUtil.ChangeDate2(rent_start_dt)%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'>
                      <select name="rent_start_dt_h" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<=24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="rent_start_dt_s" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                      ~ 
                      <input type="text" name="rent_end_dt" id="rent_end_dt" value="<%=AddUtil.ChangeDate2(rent_end_dt)%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'>
                      <select name="rent_end_dt_h" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<=24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%//if(i == 24) out.println("selected");%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="rent_end_dt_s" onChange="getRentTime(); setDtHS(this);">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>

                      ( 
                      <input type="text" name="rent_hour" value="0" size="4" class=text>
                      시간 
                      <input type="text" name="rent_days" value="<%=rent_days%>" size="4" class=text>
                      일
                      <input type="text" name="rent_months" value="<%=rent_months%>" size="4" class=text>
                      개월 )
                    </td>
                    <td width=10% class=title>관리담당자</td>
                    <td width=14%> 
                      <input type='hidden' name='mng_nm' value=''>                      
                    </td>                    
                </tr>
                <tr> 
                    <td class=title>보험 변경 기준일</td>
                    <td colspan="7"> 
                      &nbsp;<input type="text" name="ins_change_std_dt" id="ins_change_std_dt" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();' readonly>
					  <input type="checkbox" id="ins_change_flag" name="ins_change_flag" style="margin-left:90px;"><span>보험 변경 없음</span>&nbsp;&nbsp;<span style="color: red;font-weight: bold;">*21세 보험 고객인 경우 보유차(26세)를 21세 보험으로 변경 요청하지 않을 경우 체크</span> 
					  <input type="hidden" id="ins_change_flag_input" name="ins_change_flag_input"/>
                </tr>
                <tr> 
                    <td class=title>기타 특이사항</td>
                    <td colspan="7"> 
                      &nbsp;<textarea name="etc" cols="110" rows="3" class=default></textarea>
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차/반차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>배차예정일시</td>
                    <td width=41%> 
                      &nbsp;<input type="text" name="deli_plan_dt" value="<%=AddUtil.ChangeDate2(rent_start_dt)%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value); <%if(rent_st.equals("12")){%>set_est_dt();<%}%>'>
                      <select name="deli_plan_dt_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="deli_plan_dt_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title width=10%>배차위치</td>
                    <td width=39%> 
                     &nbsp;<input type="text" name="deli_loc" value="" size="60" class=text>
                    </td>
                </tr>
    		    <input type='hidden' name="deli_dt">
    		    <input type='hidden' name="deli_dt_h">
    		    <input type='hidden' name="deli_dt_s">
    		    <input type='hidden' name="deli_mng_id">
                <tr> 
                    <td class=title>반차예정일시</td>
                    <td> 
                      &nbsp;<input type="text" name="ret_plan_dt" value="<%=AddUtil.ChangeDate2(rent_end_dt)%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="ret_plan_dt_h">
                        <%for(int i=0; i<=24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%//if(i == 24) out.println("selected");%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="ret_plan_dt_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>반차위치</td>
                    <td> 
                      &nbsp;<input type="text" name="ret_loc" value="" size="60" class=text>
                    </td>
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
	  <td colspan="2">* 예약차량에 한해서 배차예정일시로 부터 24시간이 경과되는 시점에도 예약상태라면 자동취소되니 업무에 참고하십시오.</td>
	</tr>
	<%if(rent_cnt>0){%>
	<tr>
	  <td colspan="2"><font color='red'><b>* 재리스 계약확정되어 장기대기로 예약되어 있는 차량입니다.</b></font></td>
	</tr>
	<%}else{%>
	<%	if(use_cnt>0){%>
	<tr>
	  <td colspan="2"><font color='red'><b>* 현재 예약 혹은 배차중인 차량입니다.</b></font></td>
	</tr>
	<%	}%>
	<%}%>
<input type='hidden' name='use_cnt' value='<%=use_cnt%>'>
<input type='hidden' name='rent_cnt' value='<%=rent_cnt%>'>	

</table>
</form>
<script language='javascript'>
<!--	
	getRentTime();
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

