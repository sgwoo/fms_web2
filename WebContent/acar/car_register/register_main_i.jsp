<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.car_register.*, acar.cont.*, acar.car_mst.*, acar.insur.*, acar.estimate_mng.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ins"     class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="rs_db"   class="acar.res_search.ResSearchDatabase" scope="page"/>
<jsp:useBean id="a_db"    class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//브라우저가 크롬일 경우 판별		2018.03.05
	String ua = request.getHeader("User-Agent");
	boolean isChrome = false;
	if(ua.contains("Chrome")){
		isChrome = true;
	}

	//자동차등록화면 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "02", "01");
	
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd	 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	// 차량관리 > 차량등록관리 > 자동차관리에서 오는 경우와 영업관리 > 계출관리 > 납품준비상황에서 오는 경우를 구분짓기 위해 추가		2017. 11. 28
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	// 납품준비상황에서 등록일자 등록 버튼으로 이동할 경우 인수지를 매개체 데이터 이동			2017. 12. 8
	String udt_st = request.getParameter("udt_st")==null?"":request.getParameter("udt_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//자동차회사&차종&자동차명
	CarMstBean mst = a_cmb.getCarEtcNmCase(rent_mng_id, rent_l_cd);
	
	//보험정보
	InsDatabase ai_db = InsDatabase.getInstance();
	String ins_st = ai_db.getInsSt(car_mng_id);
	ins = ai_db.getIns(car_mng_id, ins_st);
	ins_st = ins_st ==null?"0":ins_st;
	
	
	//자동계산 필요------------------------------------------------------------------------------------------
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//차종정보
	cm_bean = a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
  	//차량등록지역
  	CodeBean[] code32 = c_db.getCodeAll3("0032");
  	int code32_size = code32.length;
  	
	String var_seq = "";
	String a_a = "";
	String a_e = cm_bean.getS_st();
	if(base.getCar_st().equals("1")) a_a = "2";
	if(base.getCar_st().equals("3")) a_a = "1";
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//계산식변수
	Hashtable sik 		= e_db.getEstiSikVar();
	Hashtable s_e 		= (Hashtable)sik.get("s_e");		//등록세
	Hashtable s_g 		= (Hashtable)sik.get("s_g");		//취득세
	Hashtable s_h 		= (Hashtable)sik.get("s_h");		//채권매입액
	Hashtable s_j 		= (Hashtable)sik.get("s_j");		//채권할인비용
	
	//등록세 자동 계산 추가(2018.01.05)
	long tax_amt2 = 0;
	
	//취득세 자동 계산 추가(2017.12.01)
	long tax_amt3 = 0;
	if(rent_l_cd.length() > 0){
		Hashtable ht = a_db.getRentBoardSubCase(rent_l_cd);
		if(base.getCar_gu().equals("1")){	// 1.신차 계산식
			
			//등록세 수식(/fms2/car_pur/rent_board_excel.jsp 파일에 있는 등록세 수식 참고, 납품준비상황 취득세명의변경에 금융회사가 있는 경우에 차량등록화면에서 등록세에 금액이 들어간다. 2018.01.05)
			if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){
				
	      	}else{
	        	if(String.valueOf(ht.get("S_ST")).equals("8") || String.valueOf(ht.get("S_ST")).equals("7")){//화물
	        		if(String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802"))){
	        			
	        		}else{
	        			tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX3")));
					}
				}else{
					if(String.valueOf(ht.get("CAR_ST")).equals("렌트")){//렌트
						tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX2")));
					}else{//리스
						if(String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")){
							//경차 리스 50만원 경감
							tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX2")));
						}else{
							tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX5")));
						}
					}
				}
			}
			
			// ----------------------------------------------------------------------------------------------------------------------------------------------------------신차 start
			if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){
				if(String.valueOf(ht.get("S_ST")).equals("8") || String.valueOf(ht.get("S_ST")).equals("7")){//화물
					if(String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802"))){
						
					}else{
						tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX5")));
					}
				}else{
					if(String.valueOf(ht.get("CAR_ST")).equals("렌트")){//렌트
						tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
					}else{//리스
						if(String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")){
							//경차 리스 50만원 경감
							tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
						}else{
							tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX7")));
						}
					}
				}
			}else{
				if(String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
					//경차 리스 50만원 경감
					tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
				}else{
					tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
				}
			}
			
			//친환경차 취득세 감면
			if(!String.valueOf(ht.get("JG_G_7")).equals("")){
				if(String.valueOf(ht.get("JG_G_7")).equals("1") || String.valueOf(ht.get("JG_G_7")).equals("2")){
					//20200101 하이브리드 취득세 감면혜택 일부 축소 1400000->900000
					//20210101 하이브리드 취득세 감면혜택 일부 축소  900000->400000
					tax_amt3 = tax_amt3 - 400000;
				}else if(String.valueOf(ht.get("JG_G_7")).equals("3") || String.valueOf(ht.get("JG_G_7")).equals("4")){
					tax_amt3 = tax_amt3 - 1400000;
				}
				if(tax_amt3 < 0)	tax_amt3 = 0;
			}
			//경차 리스 50만원 경감-> 2022년 75만원
			if(String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
				if(AddUtil.parseInt(String.valueOf(ht.get("DLV_DT"))) >= 20220101){
					if(tax_amt3<750000){
						tax_amt3 = 0;
					}else{
						tax_amt3 = tax_amt3-750000;
					}
				}else{
					if(tax_amt3<500000){
						tax_amt3 = 0;
					}else{
						tax_amt3 = tax_amt3-500000;
					}
				}				
			}
			
			// ----------------------------------------------------------------------------------------------------------------------------------------------------------신차 end
		}else {	// 0.재리스, 2.중고차, 3.월렌트 계산식
			
			// ----------------------------------------------------------------------------------------------------------------------------------------------------------재리스,중고차,월렌트 start
			if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){
				if(String.valueOf(ht.get("S_ST")).equals("8") || String.valueOf(ht.get("S_ST")).equals("7")){//화물
					if(String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802"))){
						
					}else{
						tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX5")));
					}
				}else{
					if(String.valueOf(ht.get("CAR_ST")).equals("렌트")){//렌트
						tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
					}else{//리스
						if(String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")){
							tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
						}else{
							tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX7")));
						}
					}
				}
			}else{
				if(String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
					tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
				}else{
					tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
				}
			}
			//친환경차 취득세 감면
			if(!String.valueOf(ht.get("JG_G_7")).equals("")){
				if(String.valueOf(ht.get("JG_G_7")).equals("1") || String.valueOf(ht.get("JG_G_7")).equals("2")){
					//20200101 하이브리드 취득세 감면혜택 일부 축소 1400000->900000
					//20210101 하이브리드 취득세 감면혜택 일부 축소  900000->400000
					tax_amt3 = tax_amt3 - 400000;
				}else if(String.valueOf(ht.get("JG_G_7")).equals("3") || String.valueOf(ht.get("JG_G_7")).equals("4")){
					tax_amt3 = tax_amt3 - 1400000;
				}
				if(tax_amt3 < 0)	tax_amt3 = 0;
			}			
			//경차 리스 50만원 경감-> 2022년 75만원
			if(String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
				if(AddUtil.parseInt(String.valueOf(ht.get("DLV_DT"))) >= 20220101){
					if(tax_amt3<750000){
						tax_amt3 = 0;
					}else{
						tax_amt3 = tax_amt3-750000;
					}
				}else{
					if(tax_amt3<500000){
						tax_amt3 = 0;
					}else{
						tax_amt3 = tax_amt3-500000;
					}
				}
			}			
			// ----------------------------------------------------------------------------------------------------------------------------------------------------------재리스,중고차,월렌트 end
		}

	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//등록하기
	function CarRegReg(){
		var theForm = document.CarRegForm;	
		if(!CheckInputField()){				return;	}		
		if(!confirm('등록하시겠습니까?')){	return;	}
		theForm.cmd.value = "i";
		theForm.action="./register_null_ui.jsp";
		theForm.target = "nodisplay"
		theForm.submit();
	}
	//수정하기
	function CarRegUp(){
		var theForm = document.CarRegForm;	
		if(!CheckInputField()){			return;	}	
		if(!confirm('수정하시겠습니까?')){	return;	}
		theForm.cmd.value = "u";
		theForm.action = "./register_null_ui.jsp";
		theForm.target = "nodisplay"
		theForm.submit();
	}
	//변경화면
	function CarRegUpDisp(){
		var theForm = document.CarRegForm;	
		theForm.cmd.value = "udp";
		theForm.action = "./register_frame.jsp";
		theForm.target = "d_content"
		theForm.submit();
	}

	//보험팝업
	function OpenIns(){
		var theForm = document.CarRegForm;
		if(theForm.cmd.value=='id'){	alert("상단화면을 등록후 하단 메뉴를 등록하십시오.");	return;	}						
		if(car_mng_id == ''){ 			alert('차량등록을 먼저 하십시오.'); 					return; }
		<%if(ins.getCar_mng_id().equals("")){%>
		var url = "/acar/ins_reg/ins_reg_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&c_id=<%=car_mng_id%>";
		<%}else{%>		
		var url = "/acar/ins_mng/ins_u_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&c_id=<%=car_mng_id%>&ins_st=<%=ins_st%>";		
		<%}%>				
		window.open(url, "Ins", "left=100, top=50, width=850, height=610, scrollbars=no");			
	}

	//하단메뉴 연결
	function FootWin(arg){
		var theForm = document.CarRegForm;
		if(theForm.cmd.value=='id'){	alert("상단화면을 등록후 하단 메뉴를 등록하십시오.");	return;	}	
		
		if(arg == 'HIS'){			theForm.action = "register_his_id.jsp";
		}else if(arg == 'PUR'){		theForm.action = "register_pur_id.jsp";				
		}else if(arg == 'SER'){		theForm.action = "register_service_id.jsp";		
		}else if(arg == 'CHA'){		theForm.action = "register_change_id.jsp";	
		}else if(arg == 'ACQ'){		theForm.action = "register_acquisition_id.jsp";
		}else if(arg == 'MORT'){	theForm.action = "register_mort_id.jsp";
		}else if(arg == 'KEY'){		theForm.action = "register_key_id.jsp";				
		}
		
		theForm.target = "c_foot";
		theForm.submit();
	}

	function ChangeMortDT(){
		var theForm = document.CarRegForm;
		theForm.mort_dt.value = ChangeDate(theForm.mort_dt.value);
	}

	function CheckInputField(){
		var theForm = document.CarRegForm;
		
		if(theForm.car_no.value.indexOf("GJ") != -1 || theForm.car_no.value.indexOf("gj") != -1  || theForm.car_no.value.indexOf("GH") != -1 || theForm.car_no.value.indexOf("gh") != -1  || theForm.car_no.value.indexOf("GA") != -1 || theForm.car_no.value.indexOf("ga") != -1   ){
			alert("자동차관리번호를 확인하십시오. 잘못 입력되어 있습니다."); theForm.car_no.focus(); return false; 
		}
		
		if(theForm.car_no.value==""){		alert("자동차관리번호를 입력하십시요"); 	theForm.car_no.focus(); return false; }
		if(theForm.car_num.value==""){		alert("차대번호를 입력하십시요"); 			theForm.car_num.focus(); return false; }
		if(theForm.car_num.value.length != 17){		alert("차대번호는 17자리입니다. 확인해주세요!"); theForm.car_num.focus(); return false; }
		if(theForm.init_reg_dt.value==""){	alert("최초등록일을 입력하십시요."); 		theForm.init_reg_dt.focus(); return false; }
		if(theForm.car_nm.value==""){		alert("차명을 입력하십시요."); 			theForm.car_nm.focus(); return false; }
		if(theForm.car_ext.value==""){		alert("지역을 선택하십시요"); 			theForm.car_ext.focus(); return false; }
		if(theForm.car_kd.value==""){		alert("차종을 선택하십시요"); 			theForm.car_kd.focus(); return false; }
		if(theForm.car_use.value==""){		alert("용도을 선택하십시요"); 			theForm.car_use.focus(); return false; }						
		if(theForm.car_y_form.value==""){	alert("연식을 입력하십시요."); 			theForm.car_y_form.focus(); return false; }
	
		<%if(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")){ //전기차,수소차%>
		<%}else{%>
		if(theForm.dpm.value==""){  		alert("배기량을 입력하십시요."); 		theForm.dpm.focus(); return false; }
		if(!isNum(theForm.dpm.value)){  	alert("배기량은 숫자만 입력하세요."); 		theForm.dpm.focus(); return false; }		
		<%}%>
		
		if(theForm.taking_p.value==""){		alert("승차정원을 입력하십시요."); 		theForm.taking_p.focus(); return false; }
		if(theForm.fuel_kd.value==""){		alert("연료의 종류를 입력하십시요."); 	theForm.fuel_kd.focus(); return false; }
		if(theForm.conti_rat.value==""){	alert("연비를 입력하십시요."); 			theForm.conti_rat.focus(); return false; }
		if(theForm.loan_st.value==""){		alert("공채구분을 선택하십시요."); 		theForm.loan_st.focus(); return false; }	
		
		//검사유효기간
		if(theForm.maint_st_dt.value==""){		alert("검사유효기간을 입력하십시요."); 	theForm.maint_st_dt.focus(); return false; }	
		if(theForm.maint_end_dt.value==""){		alert("검사유효기간을 입력하십시요."); 	theForm.maint_end_dt.focus(); return false; }	
		
		if(theForm.car_use.value=="1"){
			if(theForm.car_end_dt.value==""){		alert("차령만료일을 입력하십시요."); 	theForm.car_end_dt.focus(); return false; }	
		}	
		
		//차령만료일		
		chk_end();
		
		//검사유효기간
		chk_maint();
		
		<%if(car.getCar_origin().equals("2")){//수입차%>
			if(toInt(parseDigit(theForm.import_car_amt.value)) >0 && theForm.import_tax_dt.value ==''){
				alert("수입차신고일을 입력하십시요."); 	theForm.import_tax_dt.focus(); return false; 
			}
		<%} else { %>	
			<%if(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")){ //전기차,수소차%>
			<%}else{%>
		  	//배기량 - 오차 +/-  100
			var mst_dpm ='<%=mst.getDpm()%>';		
		 	var dpm_chk_amt 	= toInt(mst_dpm)    -   toInt(parseDigit(theForm.dpm.value))  ;	 	
			if  (Math.abs(dpm_chk_amt) > 100 ) {
			 	 alert("배기량을 확인하세요!!");
			 	 return false;
			}
			<%}%>	
		<%}%>	
		
		//수입차일대 차량소비자가와 개별소비세과세가격 입력 검산
		<%if(ej_bean.getJg_w().equals("1") || ej_bean.getJg_w().equals("2")){//수입차%>
			if(toInt(parseDigit(theForm.import_car_amt.value)) > <%=car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt()%> ){
				alert("수입차과세가격은 차량소비자가보다 클 수 없습니다. 금액 확인하십시오."); return false;
			}
		<%}%>
						
		return true;
	}

	//목록가기
	function go_to_list(){
		if(document.CarRegForm.from_page.value == "rbs"){	// 영업관리 > 계출관리 > 납품준비상황에서 접속하는 경우
			parent.location='/fms2/car_pur/rent_board_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>';
		}else {	// 차량관리 > 차량등록관리 > 자동차관리에서 접속하는 경우
			parent.location='register_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>';	
		}
	}
	
	function loan_set(){
		var fm = document.CarRegForm;
		if(fm.loan_s_amt.value != '' && fm.loan_b_amt.value != ''){
			fm.loan_s_rat.value = parseFloatCipher3(toFloat(parseDigit(fm.loan_s_amt.value)) / toFloat(parseDigit(fm.loan_b_amt.value))*100, 1);
		}else{
			fm.loan_s_rat.value = '';
		}
	}
	
//차령만료일
function chk_end() { 
	
	var NowDay = new Date();
		
	var  dpm = document.CarRegForm.dpm.value;
	var  car_use = document.CarRegForm.car_use.value;
	var	car_ed = document.CarRegForm.car_end_dt.value;	
	var car_end_dt; // 계산값
		
	if(dpm < 2000 ){
		var DDyear = NowDay.getFullYear() + 5;
	}else{
		var DDyear = NowDay.getFullYear() + 8;
	}
	
	var  date = document.CarRegForm.init_reg_dt.value;
	//어제날짜 구하기			 
	var selectDate = date.split("-");
	var changeDate = new Date();
	changeDate.setFullYear(selectDate[0], selectDate[1]-1, selectDate[2]-1);
		      
	var y = changeDate.getFullYear();
	var m = changeDate.getMonth() + 1;
	var d = changeDate.getDate();
	if(m < 10)    { m = "0" + m; }
	if(d < 10)    { d = "0" + d; }
		      
	var resultDate = y + "-" + m + "-" + d;	  	
	var DDmonth =  m;
	var DDday =  d;	
	
	car_end_dt = DDyear + "-" + DDmonth + "-" + DDday; //차령만료일
	
	if(car_use == 1 ){
		// 오차 + -  한달 인정 - 차량제작일관련
	    if  ( Math.abs(  toInt(replaceString("-","",car_end_dt))  -   toInt(replaceString("-","",car_ed))   )  >31 ) { 
		  	alert("입력한 차령만료일을 확인해 주세요!!");
			return;
        }       	
	}
}



//검사유효기간
function chk_maint() { 

	var NowDay = new Date();
	
	var  car_use = document.CarRegForm.car_use.value;    //1:업무용
	var  car_kd= document.CarRegForm.car_kd.value;  
	var	maint_st = document.CarRegForm.maint_st_dt.value;
	var	maint_ed = document.CarRegForm.maint_end_dt.value;	
	var	maint_st_dt;    //계산값
	var	maint_end_dt;    //계산값
	
	if(car_use == 1 ){
		var DDyear = NowDay.getFullYear() + 2;
		
	}else if(car_use == 2 && (car_kd == 1 || car_kd == 2 || car_kd == 3 || car_kd == 9) ){
		var DDyear = NowDay.getFullYear() + 4;
	}else if(car_use == 2 && (car_kd == 4 || car_kd == 5 || car_kd == 6 || car_kd == 7 || car_kd == 8) ){
		var DDyear = NowDay.getFullYear() + 1;
	}
			
	var  date = document.CarRegForm.init_reg_dt.value;
	//어제날짜 구하기			 
	var selectDate = date.split("-");
	 var changeDate = new Date();
	 changeDate.setFullYear(selectDate[0], selectDate[1]-1, selectDate[2]-1);
		      
	 var y = changeDate.getFullYear();
	 var m = changeDate.getMonth() + 1;
	 var d = changeDate.getDate();
	 if(m < 10)    { m = "0" + m; }
	 if(d < 10)    { d = "0" + d; }
		      
	var resultDate = y + "-" + m + "-" + d;
	var DDmonth =  m;
	var DDday =  d;	
		
	maint_st_dt = document.CarRegForm.init_reg_dt.value; //검사유효기간 시작일
	maint_end_dt = DDyear + "-" + DDmonth + "-" + DDday; //검사유효기간 종료일
		      
	//검사일
	if(  toInt(replaceString("-","",maint_st_dt))   !=   toInt(replaceString("-","",maint_st))   ) {
		alert("입력한 검사유효기간 시작일을 확인해 주세요!!");
		return;
	}
	
	// 오차 + -  한달 인정 - 차량제작일관련
    if  ( Math.abs(  toInt(replaceString("-","",maint_end_dt))  -   toInt(replaceString("-","",maint_ed))   )  > 31) {
	  	alert("입력한 검사유효기간 만료일을 확인해 주세요!!");
		return;
	}		
	
}

function reg_sum(){
		var fm = document.CarRegForm;
		var reg_amt = fm.reg_amt.value;
		var car_use = fm.car_use.value;
		var car_kd = fm.car_kd.value;
		
		var gs_amt = th_rndd(<%=car.getCar_fs_amt()+car.getSd_cs_amt()-car.getDc_cs_amt()%>);
		var r_amt = 0;
		
		if(gs_amt != ''){
			
			//파주시청 세정과 홈페이지 참고하여 세율계산함

			if(car_use == 1 ){ //영업용차량은 표준과세액의 2%
				gs_amt = ((gs_amt * 0.02 )/10);
			}else if(car_use == 2 && car_kd != 1 && car_kd != 2 && car_kd != 3){//비영업용차량이면서 승용차가 아닌경우 3%
				gs_amt = ((gs_amt * 0.03 )/10);
			}else{ //비영업용차량이면서 승용차는 표준과세액의 5%
				gs_amt = ((gs_amt * 0.05 )/10);
			}
			
				gs_amt = Math.floor(gs_amt);
				gs_amt = gs_amt * 10;
		}else{
			gs_amt = '';
		}
	
		r_amt = reg_amt - gs_amt ; 
		 
	    //백원미만 차이 인정 - 끝전때문
		if ( Math.abs(r_amt) > 100) {
			alert("입력한 등록세 금액을 확인해 주세요!!");
			fm.reg_amt.value = "";
		}
		
}
	
function acq_sum(){
		var fm = document.CarRegForm;
		var acq_amt = fm.acq_amt.value;
		var gs_amt = th_rndd(<%=car.getCar_fs_amt()+car.getSd_cs_amt()-car.getDc_cs_amt()%>);
		var a_amt = 0;
		
		if(gs_amt != ''){
				gs_amt = ((gs_amt * 0.02 )/10);
				gs_amt = Math.floor(gs_amt);
				gs_amt = gs_amt * 10;

		}else{
			gs_amt = '';
		}

		a_amt = acq_amt - gs_amt ; 
		 
	    //백원미만 차이 인정 - 끝전때문
		if ( Math.abs(a_amt) > 100) {
			alert("입력한 취득세 금액을 확인해 주세요!!");
			fm.acq_amt.value = "";
		}
	}


function sum(){
		var fm = document.CarRegForm;
		var reg_amt = fm.reg_amt.value;
		var acq_amt = fm.acq_amt.value;
		var gs_amt1 = th_rndd(<%=car.getCar_fs_amt()+car.getSd_cs_amt()-car.getDc_cs_amt()%>);
		var gs_amt2 = th_rndd(<%=car.getCar_fs_amt()+car.getSd_cs_amt()-car.getDc_cs_amt()%>);
		if(gs_amt1 != ''){
				gs_amt1 = ((gs_amt1 * 0.02 )/10);
				gs_amt1 = Math.floor(gs_amt1);
				gs_amt1 = gs_amt1 * 10;
			fm.reg_amt.value = gs_amt1;
		}else{
			gs_amt1 = '';
		}

		if(gs_amt2 != ''){
				gs_amt2 = ((gs_amt2 * 0.02 )/10);
				gs_amt2 = Math.floor(gs_amt2);
				gs_amt2 = gs_amt2 * 10;
			fm.acq_amt.value = gs_amt2;
		}else{
			gs_amt2 = '';
		}		
	}

function get_makedYear(val){
	if(val.length == 17){
		var fm = document.CarRegForm;
		var str = val.substr(9,1);
		var year = "";
		
		if(		    str=="A"){	year = "2010";	}else if(str=="B"){	year = "2011";	}else if(str=="C"){	year = "2012";	}
		else if(	str=="D"){	year = "2013";	}else if(str=="E"){	year = "2014";	}else if(str=="F"){	year = "2015";	}
		else if(	str=="G"){	year = "2016";	}else if(str=="H"){	year = "2017";	}else if(str=="J"){	year = "2018";	}
		else if(	str=="K"){	year = "2019";	}else if(str=="L"){	year = "2020";	}else if(str=="M"){	year = "2021";	}
		else if(	str=="N"){	year = "2022";	}else if(str=="P"){	year = "2023";	}else if(str=="R"){	year = "2024";	}
		else if(	str=="S"){	year = "2025";	}else if(str=="T"){	year = "2026";	}else if(str=="V"){	year = "2027";	}
		else if(	str=="W"){	year = "2028";	}else if(str=="X"){	year = "2029";	}else if(str=="Y"){	year = "2030";	}
		else if(	str=="1"){	year = "2031";	}else if(str=="2"){	year = "2032";	}else if(str=="3"){	year = "2033";	}
		else if(	str=="4"){	year = "2034";	}else if(str=="5"){	year = "2035";	}else if(str=="6"){	year = "2036";	}
		else if(	str=="7"){	year = "2037";	}else if(str=="8"){	year = "2038";	}else if(str=="9"){	year = "2039";	}
		else{	alert("차대번호 오입력으로 연식을 자동입력 할 수 없습니다. 차대번호 확인해주세요.");	return false;	}
		
		fm.car_y_form.value = year;
	}	
}

//-->
</script>
</head>
<body leftmargin="15"  >
<form action="register_null_ui.jsp" name="CarRegForm" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="q_sort_nm" value="<%=q_sort_nm%>">
<input type="hidden" name="q_sort" value="<%=q_sort%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="reg_dt" value="<%=Util.getDate()%>">
<input type="hidden" name="reg_nm" value="<%=c_db.getNameById(user_id, "USER")%>">
<input type="hidden" name="car_fs_amt" value="<%=car.getCar_fs_amt()%>">
<input type="hidden" name="sd_cs_amt" value="<%=car.getSd_cs_amt()%>">
<input type="hidden" name="dc_cs_amt" value="<%=car.getDc_cs_amt()%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="new_license_plate" id="new_license_plate" value="<%=car.getNew_license_plate()%>">
<input type="hidden" name="udt_st" id="udt_st" value="<%=udt_st%>">
<input type="hidden" name="acq_amt_card" id="acq_amt_card"><!-- 취득세가 있고 지역이 서울이 아닐 경우 취득세결재가 카드결재로 하기위해 추가 2017.12.13 -->
<input type="hidden" name="isChrome" id="isChrome" value="<%=isChrome%>"><!-- 브라우저가 크롬인지 아닌지 판별 2018.03.05 -->
<input type="hidden" name="car_size" id="car_size" value="<%=cm_bean.getJg_code()%>"><!-- 차종 선택에서 자동차 코드가 8000 이하는 승용차, 8000 초과 9000 이하는 승합차, 9000 초과는 화물차량만 선택 가능 2018.03.05 -->

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 자동차관리 > <span class=style5>자동차등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td align="right">
    	   <%if(auth_rw.equals("4")||auth_rw.equals("6")){%> 
           	<a href="javascript:CarRegReg()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_write.gif align=absmiddle border=0></a>&nbsp;
              <% }%> 	
			<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>	
	  </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="12%" class=title>최초등록일</td>
                    <td width="33%">&nbsp; 
                      <input type="text" name="init_reg_dt" value="<%=Util.getDate()%>" size="12" class=text  maxlength="12" onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>지역</td>
                    <td colspan="3">&nbsp; 
                      <select name="car_ext" id="car_ext">
                        <option value="">선택</option>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(car.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                                                
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>자동차번호</td>
                    <td>&nbsp; 
                      <input type="text" name="car_no" id="car_no" value="<%=pur.getEst_car_no()%>" size="15" class=text maxlength="15">
                    </td>
                    <td class=title>차종</td>
                    <td width=20%>&nbsp; 
                      <select name="car_kd" id="car_kd" style="width:115px">
                        <option value="" selected>선택</option><!-- 입력 화면 진입시 선택이 디폴트 선택으로 변경 2018.03.07 -->
                        <option value="1" id="big_pass">대형승용</option>
                        <option value="2" id="mid_pass">중형승용</option>
                        <option value="3" id="small_pass">소형승용</option>
                        <option value="9" id="ssmall_pass">경형승용</option>
                        <option value="4" id="mid_van">중형승합</option>
                        <option value="5" id="small_van">소형승합</option>
                        <option value="8" id="big_truck">대형화물</option>
                        <option value="7" id="mid_truck">중형화물</option>
                        <option value="6" id="small_truck">소형화물</option>
                      </select>
                    </td>
                    <td class=title width=10%>용도</td>
                    <td width="15%">&nbsp; 
                      <select name="car_use">
                        <option value="">선택</option>			  
                        <option value="1" <%if(base.getCar_st().equals("1")||base.getCar_gu().equals("2"))%>selected<%%>>영업용</option>
                        <option value="2" <%if(base.getCar_st().equals("3"))%>selected<%%>>자가용</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>차명</td>
                    <td>&nbsp;<%=mst.getCar_nm()%> <%=mst.getCar_name()%> 
                      <input type="hidden" name="car_nm" value="<%=mst.getCar_nm()%>">
                    </td>
                    <td class=title>형식</td>
                    <td>&nbsp; 
                      <input type="text" name="car_form" value="<%=cr_bean.getCar_form()%>" size="15" class=text>
                    </td>
                    <td class=title>연식</td>
                    <td>&nbsp; 
                      <input type="text" name="car_y_form" value="<%=cr_bean.getCar_y_form()%>" size="6" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>차대번호</td>
                    <td>&nbsp; 
                      <input type="text" name="car_num" value="<%=pur.getCar_num()%>" size="30" class=text maxlength="20" onblur="javascript:get_makedYear(this.value);">
                    </td>
                    <td class=title>원동기형식</td>
                    <td colspan=3>&nbsp; 
                      <input type="text" name="mot_form" value="<%=cr_bean.getMot_form()%>" size="30" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>재원</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr>                    
                    <td class=title width=12%>배기량</td>                    
                    <td width=15%>&nbsp; 
                      <input type="text" name="dpm" value="" size="4" class=text>
                    cc</td>
                    <td class=title width=10%>승차정원</td>                    
                    <td width=15%>&nbsp; 
                      <input type="text" name="taking_p" value="<%if(ej_bean.getJg_g_17()!=0){%><%=ej_bean.getJg_g_17()%><%}%>" size="2" class=text>
                    명</td>
                    <td class=title width=10%>길이</td>                    
                    <td width=15%>&nbsp; 
                      <input type="text" name="car_length" value="" size="6" class=num>&nbsp;mm
                    </td>
                    <td class=title width=10%>너비</td>                    
                    <td width=13%>&nbsp; 
                      <input type="text" name="car_width" value="" size="6" class=num>&nbsp;mm
                    </td>
                </tr>
                <tr>                    
                    <td class=title>연료의종류</td>                    
                    <td colspan="3">&nbsp;
                      <select name="fuel_kd">
                        <option value="">선택</option>
                        <option value="1" <% if(cm_bean.getDiesel_yn().equals("1"))%>selected<%%>>휘발유</option>
                        <option value="3" <% if(cm_bean.getS_st().equals("301")||cm_bean.getS_st().equals("302"))%>selected<%%>>LPG</option>
                        <option value="4" <% if(cm_bean.getDiesel_yn().equals("Y"))%>selected<%%>>경유</option>
                        <option value="5" >휘발유+LPG겸용</option>                        
                        <option value="7" <% if(cm_bean.getDiesel_yn().equals("3")||cm_bean.getDiesel_yn().equals("4"))%>selected<%%>>휘발유+전기</option>
                        <option value="8" <% if(cm_bean.getDiesel_yn().equals("5"))%>selected<%%>>전기</option>
                        <option value="9" <% if(cm_bean.getDiesel_yn().equals("6"))%>selected<%%>>수소</option>
                        <option value="10" <% if(cm_bean.getDiesel_yn().equals("10"))%>selected<%%>>경유+전기</option>
                      </select>
                      <span style="font-size:8pt"> (연비
                      <input type="text" name="conti_rat" value="" size="4" class=text> km/L)</span></td>
                    <td class=title>타이어</td>                            
                    <td>&nbsp; 
                      <input type="text" name="tire" value="" size="20" class=text>
                    </td>                    
                    <td class=title>최대적재량</td>
                    <td>&nbsp;
                      <input type="text" name="max_kg" value="" size="4" class=text> kg</td>
                </tr>				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>비고</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=12%>최초등록번호</td>
                    <td width=15%>&nbsp;
                      <input type="text" name="first_car_no" value="자동생성" size="15" class=whitetext maxlength="15" readonly></td>
                    <td class=title width=10%>일반성보증</td>
                    <td width=26%>&nbsp; 
                      <input type="text" name="guar_gen_y" value="" size="4" class=text>
                      년 
                      <input type="text" name="guar_gen_km" value="" size="8" class=text>
                    km </td>
                    <td class=title width=10%>내구성보증</td>
                    <td width="27%">&nbsp; 
                      <input type="text" name="guar_endur_y" value="" size="4" class=text>
                      년 
                      <input type="text" name="guar_endur_km" value="" size="8" class=text>
                    km </td>
                </tr>
                <tr>
                    <td class=title>차령만료일</td>
                    <td>&nbsp;
                      <input type="text" name="car_end_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title>검사유효기간</td>
                    <td>&nbsp;
                      	<input type="text" name="maint_st_dt" value="<%=Util.getDate()%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
        			  	<input type="text" name="maint_end_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); '>
        			</td>
                    <td class=title>점검유효기간</td>
                    <td>&nbsp;
                        <input type="text" name="test_st_dt" value=""  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
          				~
          				<input type="text" name="test_end_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); '>
                    </td>
                </tr>
                <%if(ej_bean.getJg_w().equals("1") || ej_bean.getJg_w().equals("2")){//수입차%>
                <tr> 
                    <td class=title>수입차과세가격</td>
                    <td>&nbsp;
                      <input type="text" name="import_car_amt" value="" size="10" class=num onBlur='javscript:this.value=parseDecimal(this.value);'>
                    원</td>
                    <td class=title>수입차세금</td>
                    <td>&nbsp; 
                      관세
                      <input type="text" name="import_tax_amt" value="" size="10" class=num onBlur='javscript:this.value=parseDecimal(this.value);'>
                      원,
                      개별소비세
                      <input type="text" name="import_spe_tax_amt" value="" size="10" class=num onBlur='javscript:this.value=parseDecimal(this.value);'>
                      원                    
                    </td>
                    <td class=title>수입차신고일</td>
                    <td>&nbsp; 
                      <input type="text" name="import_tax_dt" value="" size="10" class=text>
                    &nbsp;&nbsp;
                    (수입신고필증)
                    </td>                    
                </tr>                
                <%}else{%>
                <input type='hidden' name="import_car_amt" value="0">
                <input type='hidden' name="import_tax_amt" value="0">
                <input type='hidden' name="import_tax_dt" value="">
                <input type='hidden' name="import_spe_tax_amt" value="0">
                <%}%>
            </table>
        </td>
	</tr>	
	<tr>
        <td class=h></td>
    </tr>	
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>등록수수료(금액)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr>                    
                    <td width="12%" class=title>공채(채권)구분</td>                    
                    <td width="15%">&nbsp; 
                      <select name="loan_st">
                        <option value="">선택</option>			  
                   		<option value="2" selected>지역개발공채</option>
                   		<option value="1">지하철공채</option>
                   	  </select>                    	
                    </td>                    
                    <td width="10%" class=title>공채매입시</td>                    
                    <td width="15%">&nbsp; 
                      <input type="text" name="loan_b_amt" value="" size="10" class=num onBlur='javscript:loan_set(); this.value=parseDecimal(this.value);'>
                    원</td>
                    <td width="10%" class=title>공채할인시</td>                    
                    <td width="15%">&nbsp; 
                      <input type="text" name="loan_s_amt" value="" size="10" class=num onBlur='javscript:loan_set(); this.value=parseDecimal(this.value);'>
                    원 </td>
                	<td width="10%" class=title>공채할인율</td>                    
                    <td width="13%">&nbsp; 
                      <input type="text" name="loan_s_rat" value="" size="6" class=num>
                    % </td>                    
                </tr>
                <tr>
                    <td class=title>등록세</td>                    
                    <td>&nbsp; 
                      <input type="text" name="reg_amt" value="<%if(tax_amt2 != 0){%><%=Util.parseDecimal(tax_amt2)%><%}else{%>0<%}%>" size="10" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                    원 </td>
                    <td class=title>취득세</td>                    
                    <td>&nbsp; 
                      <input type="text" name="acq_amt" id="acq_amt" value="<%if(tax_amt3 != 0){%><%=Util.parseDecimal(tax_amt3)%><%}else{%>0<%}%>" size="10" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                    원</td>
                    <td class=title>번호제작비</td>                    
                    <td>&nbsp; 
                      <input type="text" name="no_m_amt" id="no_m_amt" value="<%if(!base.getCar_gu().equals("2") && br_id.equals("S1")){%>8,800<%}%>" size="10" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                    원 <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%><span style="color: red;">(신형번호판신청)</span><%}%></td>
                                      

                	<td class=title>증,인지대</td>                    
                    <td>&nbsp; 
                      <input type="text" name="stamp_amt" value="<%if(base.getCar_gu().equals("2")){%>1,000<%}else if(br_id.equals("S1")){%>2,000<%}%>" size="10" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                      원 </td>                      
                                   </tr>
                <tr>
                    <td class=title>기타수수료</td>                    
                    <td >&nbsp;
        				<input type="text" name="etc" value="" size="10" class=num onBlur="javascript: this.value=parseDecimal(this.value);">
                      원 </td>
                    <td class=title>등록비지출일</td>                    
                    <td  colspan=7 >&nbsp; 
                      <input type="text" name="reg_pay_dt" value="<%=Util.getDate()%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      </td>
    			  
                </tr>
                <tr>                    
                    <td class=title>등록세결재</td>                    
                    <td >&nbsp;
					   <label><input type="checkbox" name="reg_amt_card" value="Y"> 
					    카드결재</label>
        				 </td>
                    <td class=title>번호판대금결재</td>                    
                    <td  colspan=7 >&nbsp; 
                      <input type="checkbox" name="no_amt_card" value="Y"> 
					  카드결재
                      </td>
    			  
                </tr>
				
            </table>
        </td>
    </tr>
</table>
</form>
<center>
<a href="javascript:FootWin('HIS')"  onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_ir.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('PUR')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_cg.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('MORT')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_jdg.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('SER')"  onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_jggs.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('CHA')"  onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_gj.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:OpenIns()"       onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_ins.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('ACQ')"  onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_cd.gif align=absmiddle border=0></a>&nbsp; 
<a href="javascript:FootWin('KEY')"  onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_car_ybk.gif align=absmiddle border=0></a>&nbsp; 
</center>
<script language="JavaScript">
<!--	
	var fm = document.CarRegForm;
	
	// 번호제작비 계산		2017.12.07(1차 작업)		2018.01.05(2차 작업)    2020.04.12
	var car_ext = $("#car_ext").val();	// 지역
	var udt = $("#udt_st").val();
	var car_no = $("#car_no").val();
	var car_use = fm.car_use.value;
	var new_license_plate = $("#new_license_plate").val();
	
	//20220314 번호판 비용변경
	//인천=대전=광주=리스=고객 전기20000, 신형21400, 구형7700
		
	if(car_no == "리 스" || car_use== '2'){		// 용도가 리스일 경우에서 인수지가 본사 일 경우는 번호제작비를 0원으로 나머지 인수지일 경우는 8,800원으로 처리
		if(udt=="본사"){
			$("#no_m_amt").val("0");
		}else {
			$("#no_m_amt").val("7,700");
		}
	}else if(udt=="본사"||udt=="인천"||udt=="광주지점"||udt=="대전지점"||udt=="고객"){
		$("#no_m_amt").val("7,700");
	}else if(udt=="부산지점"){	// 부산
		$("#no_m_amt").val("9,000");
	}else if(udt=="대구지점"){	// 대구
		$("#no_m_amt").val("9,100");
	}else{
		$("#no_m_amt").val("7,700");
	}
	
	//서울
	if($("#car_ext").val() == 1){
		$("#no_m_amt").val("6,800");
	}
	
	//신형번호판 신청일 경우 아래금액으로 셋팅
	if (new_license_plate == "1" || new_license_plate == "2") {
		$("#no_m_amt").val("21,400");
		//20220707 리스는 무조건 21400
		if(car_no == "리 스" || car_use== '2'){
			
		}else{
			if(udt=="대구지점"){
				$("#no_m_amt").val("20,800");
			}
			if(udt=="부산지점"){
				$("#no_m_amt").val("24,000");
			}
			//서울
			if($("#car_ext").val() == 1){
				$("#no_m_amt").val("21,500");
			}
		}	
	}
	//전기차,수소차
	<%if(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4")){ %>
		$("#no_m_amt").val("20,000");
		if(udt=="대구지점"){
			$("#no_m_amt").val("24,100");
		}
		if(udt=="부산지점"){
			$("#no_m_amt").val("24,000");
		}
	<%}%>
	
	
	// 차종 선택에서 자동차 코드가 8000000 이하는 승용차, 8000000 초과 9000000 이하는 승합차, 9000000 초과는 화물차량만 선택 가능 2018.03.05
	var car_size = $("#car_size").val();
	var isChrome = $("#isChrome").val();
	if(car_size < 8001000){	// 승용차
		if(isChrome=="true"){
			$("#car_kd option[id=mid_van]").hide();
			$("#car_kd option[id=small_van]").hide();
			$("#car_kd option[id=big_truck]").hide();
			$("#car_kd option[id=mid_truck]").hide();
			$("#car_kd option[id=small_truck]").hide();	
		}else{
			$("#car_kd option[id=mid_van]").prop('disabled','disabled');
			$("#car_kd option[id=small_van]").prop('disabled','disabled');
			$("#car_kd option[id=big_truck]").prop('disabled','disabled');
			$("#car_kd option[id=mid_truck]").prop('disabled','disabled');
			$("#car_kd option[id=small_truck]").prop('disabled','disabled');
		}
	}else if(car_size < 9001000){// 승합차
		if(isChrome=="true"){
			$("#car_kd option[id=big_pass]").hide();
			$("#car_kd option[id=mid_pass]").hide();
			$("#car_kd option[id=small_pass]").hide();
			$("#car_kd option[id=ssmall_pass]").hide();
			$("#car_kd option[id=big_truck]").hide();
			$("#car_kd option[id=mid_truck]").hide();
			$("#car_kd option[id=small_truck]").hide();	
		}else{
			$("#car_kd option[id=big_pass]").prop('disabled','disabled');
			$("#car_kd option[id=mid_pass]").prop('disabled','disabled');
			$("#car_kd option[id=small_pass]").prop('disabled','disabled');
			$("#car_kd option[id=ssmall_pass]").prop('disabled','disabled');
			$("#car_kd option[id=big_truck]").prop('disabled','disabled');
			$("#car_kd option[id=mid_truck]").prop('disabled','disabled');
			$("#car_kd option[id=small_truck]").prop('disabled','disabled');
		}
	}else{	// 화물차
		if(isChrome=="true"){
			$("#car_kd option[id=big_pass]").hide();
			$("#car_kd option[id=mid_pass]").hide();
			$("#car_kd option[id=small_pass]").hide();
			$("#car_kd option[id=ssmall_pass]").hide();
			$("#car_kd option[id=mid_van]").hide();
			$("#car_kd option[id=small_van]").hide();
		}else{
			$("#car_kd option[id=big_pass]").prop('disabled','disabled');
			$("#car_kd option[id=mid_pass]").prop('disabled','disabled');
			$("#car_kd option[id=small_pass]").prop('disabled','disabled');
			$("#car_kd option[id=ssmall_pass]").prop('disabled','disabled');
			$("#car_kd option[id=mid_van]").prop('disabled','disabled');
			$("#car_kd option[id=small_van]").prop('disabled','disabled');
		}
	}

	<%if(base.getCar_gu().equals("2")){%>
	fm.init_reg_dt.value = ChangeDate('<%=car.getSh_init_reg_dt()%>');
	<%}%>	
	
//-->
</script>	
</body>
</html>