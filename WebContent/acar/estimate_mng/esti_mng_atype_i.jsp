<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_bean2" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw  = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id    = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id  = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String gubun1   = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2   = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3   = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4   = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5   = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6   = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt     = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt     = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd     = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd     = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
  
	String st       = request.getParameter("st")==null?"":request.getParameter("st");
	String est_id   = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String set_code   = request.getParameter("set_code")==null?"":request.getParameter("set_code");
	String eh_code   = request.getParameter("eh_code")==null?"":request.getParameter("eh_code");
	String spe_seq  = request.getParameter("spe_seq")==null?"":request.getParameter("spe_seq");
	String est_table= request.getParameter("est_table")==null?"":request.getParameter("est_table");
	String cmd      = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String spe_cmd      = request.getParameter("spe_cmd")==null?"":request.getParameter("spe_cmd");
	String spe_car_nm = request.getParameter("spe_car_nm")==null?"":request.getParameter("spe_car_nm");
	String damdang_id   = ck_acar_id;
	
	/*******사전계약관리*******/
	String pur_seq = request.getParameter("pur_seq")==null?"":request.getParameter("pur_seq");
	String pur_car_nm = request.getParameter("pur_car_nm")==null?"":request.getParameter("pur_car_nm");
	String pur_car_opt = request.getParameter("pur_car_opt")==null?"":request.getParameter("pur_car_opt");
	String pur_car_col = request.getParameter("pur_car_col")==null?"":request.getParameter("pur_car_col");
	String pur_car_in_col = request.getParameter("pur_car_in_col")==null?"":request.getParameter("pur_car_in_col");
	String pur_car_garnish_col = request.getParameter("pur_car_garnish_col")==null?"":request.getParameter("pur_car_garnish_col");
	
	String pur_eco_yn = request.getParameter("pur_eco_yn")==null?"":request.getParameter("pur_eco_yn");
	String pur_car_amt = request.getParameter("pur_car_amt")==null?"":request.getParameter("pur_car_amt");
	String pur_con_amt = request.getParameter("pur_con_amt")==null?"":request.getParameter("pur_con_amt");
	String pur_dlv_est_dt = request.getParameter("pur_dlv_est_dt")==null?"":request.getParameter("pur_dlv_est_dt");
	String pur_con_pay_dt = request.getParameter("pur_con_pay_dt")==null?"":request.getParameter("pur_con_pay_dt");
	String pur_etc = request.getParameter("pur_etc")==null?"":request.getParameter("pur_etc");
	
	String pur_from_page = request.getParameter("pur_from_page")==null?"":request.getParameter("pur_from_page");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	/*********************/
	
	CommonDataBase c_db   = CommonDataBase.getInstance();
	EstiDatabase e_db   = EstiDatabase.getInstance();
	CarOfficeDatabase umd   = CarOfficeDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstDatabase cmb  = CarMstDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	e_bean = e_db.getEstimateCase(est_id);
	
	//표준월대여료에서 연결
	if (est_table.equals("hp")) {
		e_bean = e_db.getEstimateHpCase(est_id);
	}
  
	//표준월대여료에서 연결
	if (est_table.equals("esti_spe")) {
	  	e_bean = e_db.getEstimateCuCase(est_id);
	}
	
	//스폐셜견적에서 연결
	if (est_table.equals("esti_spe")) {
		if (e_bean.getEst_id().equals("")) {
	   		e_bean = e_db.getEstimateSpeCarCase(est_id, spe_seq);
		    e_bean.setOpt_chk   ("0");
		  	e_bean.setIns_per   ("1");
		  	e_bean.setInsurant  ("1");
		  	e_bean.setIns_dj    ("2");
		  	e_bean.setIns_age   ("1");
		  	//수입차이면 500,000
		  	e_bean.setCar_ja    (300000);   
		  	if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5) {
		    	e_bean.setCar_ja  (500000);
		  	}   
	  	}
	}
  
	String a_a[] = new String[4];
	String opt_chk[] = new String[4];
	
	for (int j = 0; j < 4; j++) {
		a_a[j]      = "";
		opt_chk[j] = "0";
	}
	
	if (est_table.equals("esti_spe")) {
		if (spe_cmd.equals("")) {		  
	   		int a_a_len = e_bean.getA_a().length();
	   		for (int j = 0; j < a_a_len/2; j++) {
	   			a_a[j] = e_bean.getA_a().substring(j*2,(j+1)*2);
	     		if (a_a[j].equals("22") || a_a[j].equals("12")) {
	       			opt_chk[j] = "1";
	     		}
	   		}
	 	}
		
	   	if (a_a[0].equals("")) {
	   		e_bean.setA_a("22");
	     	opt_chk[0] = "1";
	   	}
	}
  
	if (!e_bean.getReg_id().equals("") && !e_bean.getReg_id().equals("2016006")) {
		damdang_id = e_bean.getReg_id();
	}
	
	//자동차회사 리스트
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	float jg_f = 0;
	float jg_g = 0;
	String jg_w = "0";
	String jg_h = "0";
	String jg_i = "0";
	String jg_b = "";
  
	//비교견적시 엔진조회
	if (cmd.equals("re")) {
		jg_b = e_db.getJg_b(e_bean.getCar_comp_id(), e_bean.getCar_cd(), e_bean.getCar_id());
	} else {
	 	jg_b = "";
	}
  
	if (est_id.equals("")) {
		e_bean.setCar_comp_id   ("0001");
	  	e_bean.setA_a     		("22");
		//  e_bean.setA_b     		("36");
		e_bean.setA_b     		("48");		//디폴트 48개월로 수정(2018.03.12)
		e_bean.setOpt_chk   	("1");
		e_bean.setIns_per   	("1");
		e_bean.setInsurant    	("1");
		e_bean.setIns_dj    	("2");
		e_bean.setIns_age   	("1");
		e_bean.setCar_ja    	(300000);		
	} else {
	 
	  	cm_bean2 = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	  	if (est_table.equals("hp") && e_bean.getIns_per().equals("")) {
	    	if (e_bean.getEst_nm().indexOf("2_f") != -1) {
	    		e_bean.setIns_per   ("2");
	    	} else {
	    		e_bean.setIns_per   ("1");
	    	}
	  	}
	  
		//차종변수
		ej_bean = e_db.getEstiJgVarCase(cm_bean2.getJg_code(), "");
		jg_f = ej_bean.getJg_f()*100;
		jg_g = ej_bean.getJg_g()*100;
		jg_w = ej_bean.getJg_w();
		jg_h = ej_bean.getJg_h();
		jg_i = ej_bean.getJg_i();
	  
		//수입차이면 500,000    
		if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5) {
			e_bean.setCar_ja  (500000);
		}
	}
  
	//20120901부터 영업수당율 최대3% 이내에서 선택가능 - 디폴트 0%
	jg_f = 0;
	jg_g = 0;
	
	//제조사 목록의 비고 표시
	Hashtable com_ht = umd.getCarCompCase("0001");
	String etc = String.valueOf(com_ht.get("ETC"));
	String bigo = String.valueOf(com_ht.get("BIGO"));
	
	//차종리스트
	CarMstBean cm_r [] = cmb.getCarKindAll_Esti(e_bean.getCar_comp_id());
	
	//테스트용
	CarMstBean cm_r2 [] =  cmb.getCarKindAll(e_bean.getCar_comp_id());	
	
	//대여상품명
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y");
	int good_size = goods.length;
	
	//차량인도지역
	CodeBean[] code33 = c_db.getCodeAll3("0033");
	int code33_size = code33.length;
	
	//전기차 고객주소지
	CodeBean[] code34 = c_db.getCodeAll3("0034");
	int code34_size = code34.length;
	
	//수소차 고객주소지
	CodeBean[] code37 = c_db.getCodeAll3("0037");
	int code37_size = code37.length;  
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//신규추가
	EstimateBean e_bean2 = new EstimateBean();
	EstimateBean e_bean3 = new EstimateBean();
	EstimateBean e_bean4 = new EstimateBean();
	
	Vector vars = new Vector();
	int size = 0;
	
	if (e_bean.getPrint_type().equals("6")) {
	 	if (spe_cmd.equals("")) {
			vars = e_db.getABTypeEstIds2(set_code, est_id);
			size = vars.size();
		
			for (int i = 0; i < size; i++) {
				Hashtable var = (Hashtable)vars.elementAt(i);
				if (i==0) e_bean = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
				if (i==1) e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
				if (i==2) e_bean3 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
				if (i==3) e_bean4 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			}
		
	 	} else {
	 		if (!eh_code.equals("")) {
				vars = e_db.getABTypeEstIds4(set_code, est_id, eh_code);
				size = vars.size();
			
				for (int i = 0; i < size; i++) {
					Hashtable var = (Hashtable)vars.elementAt(i);
					if (i==0) e_bean = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
					if (i==1) e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
					if (i==2) e_bean3 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
					if (i==3) e_bean4 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
				}
			
	 		} else {
	 			vars = e_db.getABTypeEstIds5(set_code, est_id, eh_code);
	 			size = vars.size();
	 		  	
	 		    e_bean = e_db.getEstimateCase(est_id);
	 		  	e_bean.setReturn_select("0");
	 		    e_bean.setA_a("22");
	 		    e_bean.setOpt_chk("1");
	 		    
	 		    e_bean2 = e_db.getEstimateCase(est_id);
	 		  	e_bean2.setReturn_select("1");
	 		  	e_bean2.setA_a("22");
	 		    e_bean2.setOpt_chk("0");
	 		    
	 		    e_bean3 = e_db.getEstimateCase(est_id);
	 		}
	 	}
	
	} else {
		e_bean2 = e_bean;
		e_bean3 = e_bean;
		e_bean4 = e_bean;
	}
  
  	// 비교견적일때만 값셋팅
	String ecar_pur_sub_amt_val = "";	
	if (cmd.equals("re")) {
		ecar_pur_sub_amt_val = String.valueOf(e_bean.getEcar_pur_sub_amt());
	}
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" type="text/css" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<style>
.num_weight {
	font-weight: 800 !important;
}
/* 보증보험 readonly background custom */
.gi_per:-moz-read-only { /* For Firefox */
  background-color: #E5E5E5;
}
.gi_per:read-only {
  background-color: #E5E5E5;
}
.gi_per[readonly] {
  background-color: #E5E5E5;
}
.gi_amt:-moz-read-only { /* For Firefox */
  background-color: #E5E5E5;
}
.gi_amt:read-only {
  background-color: #E5E5E5;
}
.gi_amt[readonly] {
  background-color: #E5E5E5;
}
#btnOk {
	margin-right: 15px !important;
}
.dialogBtnCustom {
	padding: 5px 15px !important;
	font-size: 14px !important;
    border: 1px solid #349BD5 !important;
    background: #349BD5 !important;
    font-weight: normal !important;
    color: #FFFFFF !important;
}
.dialogBtnCustom:hover {
	padding: 5px 15px !important;
	font-size: 14px !important;
    border: 1px solid #187ab1 !important;
    background: #187ab1 !important;
    font-weight: normal !important;
    color: #FFFFFF !important;
}
#esti_condition{
	border: 0.1px solid rgba(176, 186, 236, 0.5) !important;
}
#esti_condition td{
	border: 0.1px solid rgba(176, 186, 236, 0.5) !important;
}
.equal-condition{
	font-size: 20px; 
	font-weight: bold; 
	text-align: center;
}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.js"></script>
<!-- dialog 라이브러리 -->
<script type="text/javascript" src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript" src="https://nowonbun.github.io/Loader/dialog.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script>
$(function() {
	// 옵션을 설정한다.
	dialog.set({
		// 다이얼로그가 show될 때의 액션 설정
		/* show: {
			effect: "blind",
			duration: 400
		}, */
		// 다이얼로그가 hide될 때의 액션 설정
		/* hide: {
			effect: "explode",
			duration: 400
		}, */
		// 타이틀 설정
		//title: "",
		//width: 450,
        //height: 300,
        position: { my: "center", at: "top+100", of: window },
		// 모달 여부
		modal: true,
		resizable: false,
		draggable: false, //창 드래그 못하게
		// 버튼 설정
		/* buttons: {
			OK: function() {
				EstiReg();
				dialog.close();
			},
			Cancel: function() {
				dialog.close();
			}
		} */
		buttons: [
			{
		        text: "확인",
		        "id": "btnOk",
		        "class": "dialogBtnCustom",
		        click: function () {
		        	EstiReg();
		        	dialog.close();
		        }
	    	},
	    	{
		        text: "취소",
		        "id": "btnCancel",
		        "class": "dialogBtnCustom",
		        click: function () {
		        	dialog.close();
		        }
	    	}
	    ],
	    close: function () {
	    	dialog.close();
	    }
	});
});
</script>
<script language="JavaScript">
<!--
function replaceFloatRound(per) {
	return Math.round(per*1000)/10;
}
  
function replaceFloatRound2(per) {
    return Math.round(per*10)/10; 
}
  
//기존고객찾기
function search_cust() {
    var fm = document.form1;
    var SUBWIN="search_cust_list.jsp?t_wd="+fm.est_nm.value;    
    window.open(SUBWIN, "SubCust", "left=10, top=10, width=1250, height=800, scrollbars=yes, status=yes");   
}
  
function enter() {
    var keyValue = event.keyCode;
    if (keyValue =='13') search_cust();
} 
  
//자동차회사 변경시 차명코드 출력하기
function GetCarCode() {
    var fm = document.form1;
    var fm2 = document.form2;
    
    //수입차 선택시 수입차 출고 초기화 및 하단입력 show/hide
    var num_car_comp_id = Number($("#car_comp_id option:selected").val());
    
  	//현대,기아는 자체탁송료 조회버튼 활성화
	if (num_car_comp_id < 3) {
		tr_cons_cost_y.style.display='';		
		tr_cons_cost_n.style.display='none';	
	}else{
		tr_cons_cost_y.style.display='none';	
		tr_cons_cost_n.style.display='';		
	}   
  
    if (num_car_comp_id > 5) {
    	$("#import_pur_st_1").prop("checked", true);
    	$("#import_content_1").show();
    	//자체출고 및 영업사원출고선택에 따라 하단입력 show/hide
    	release_type();
    	
    	// 수입차 선택 시 렌트, 리스, 종합 비활성화
    	fm.print_type[0].checked = true;
    	fm.print_type[2].checked = false;
    	fm.print_type[3].checked = false;
    	fm.print_type[4].checked = false;
    	
    	fm.print_type[2].disabled = true;
    	fm.print_type[3].disabled = true;
    	fm.print_type[4].disabled = true;
    	
    } else {
    	$("#import_pur_st_1").prop("checked", true);
    	$("#import_content_1").hide();
    	//자체출고 및 영업사원출고선택에 따라 하단입력 show/hide
    	release_type();
    	
    	fm.print_type[2].disabled = false;
    	fm.print_type[3].disabled = false;
    	fm.print_type[4].disabled = false;
    }
    
    // 20210318. 수입 일본차 신형번호판 신청 불가 처리. 제조사 렉서스, 도요타, 혼다, 닛산, 인피니티
    var comp_id = $("#car_comp_id option:selected").val();
    if(comp_id == '0044' || comp_id=='0007' || comp_id=='0025' || comp_id=='0033' || comp_id=='0048'){
    	fm.new_license_plate[0].style.display = 'none';
		fm.new_license_plate[1].style.display = 'none';
		fm.new_license_plate[2].style.display = 'none';
		fm.new_license_plate[3].style.display = 'none';
		fm.new_license_plate[0].previousElementSibling.style.display = 'none';
		fm.new_license_plate[1].previousElementSibling.style.display = 'none';
		fm.new_license_plate[2].previousElementSibling.style.display = 'none';
		fm.new_license_plate[3].previousElementSibling.style.display = 'none';
		fm.new_license_plate[0].value = "0";
		fm.new_license_plate[1].value = "0";
		fm.new_license_plate[2].value = "0";
		fm.new_license_plate[3].value = "0";
    } else {
    	fm.new_license_plate[0].style.display = '';
		fm.new_license_plate[1].style.display = '';
		fm.new_license_plate[2].style.display = '';
		fm.new_license_plate[3].style.display = '';
		fm.new_license_plate[0].previousElementSibling.style.display = '';
		fm.new_license_plate[1].previousElementSibling.style.display = '';
		fm.new_license_plate[2].previousElementSibling.style.display = '';
		fm.new_license_plate[3].previousElementSibling.style.display = '';
		fm.new_license_plate[0].value = "1";
		fm.new_license_plate[1].value = "1";
		fm.new_license_plate[2].value = "1";
		fm.new_license_plate[3].value = "1";
    }
    
    te = fm.code;
    te.options[0].value = '';
    te.options[0].text = '조회중';
    
    fm2.sel.value = "form1.code";
    fm2.car_comp_id.value = fm.car_comp_id.value;
    fm2.mode.value = '8';
    fm2.rent_way.value = '';    
    fm2.a_a.value = '';   
    fm2.target="i_no";
    fm2.submit();
}
  
//세부리스트 (차종,옵션,색상)
function sub_list(idx) {
    var fm = document.form1;    
    if (fm.code.value == '') { alert('차명을 선택하십시오.'); return;}
    if (idx != 1 && fm.car_name.value == '') {  alert("차종을 선택하세요"); return;  }
    //파라미터 jg_g_7 추가
    var jg_g_7_val = "";
    if (idx != 1) {
    	jg_g_7_val = fm.jg_g_7.value;
    }
    var garnish_yn_opt_st = fm.garnish_yn_opt_st.value;
	var hook_yn_opt_st = fm.hook_yn_opt_st.value;
    var SUBWIN="./search_sub_list.jsp?idx="+idx+"&a_a=&car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&rent_dt="+fm.rent_dt.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text+"&jg_g_7="+jg_g_7_val+"&garnish_yn_opt_st="+garnish_yn_opt_st+"&hook_yn_opt_st="+hook_yn_opt_st;  
    window.open(SUBWIN, "SubList", "left=100, top=100, width=1200, height=800, scrollbars=yes, status=yes");
}

    
//비율==금액 변환
function compare(idx, obj) {
    var fm = document.form1;
    
    if (obj == fm.rg_8[idx]) {
    
      	fm.rg_8_amt[idx].value  = parseDecimal( getCutRoundNumber(toInt(parseDigit(fm.o_1.value)) * toFloat(fm.rg_8[idx].value) / 100, 1000 ));
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          		fm.rg_8_amt[idx].value = parseDecimal( getCutRoundNumber(toInt(parseDigit(fm.o_12.value)) * toFloat(fm.rg_8[idx].value) / 100, 1000 ));
        	}
      	}
      
    } else if (obj == fm.rg_8_amt[idx]) {
    	
    	fm.rg_8[idx].value  = replaceFloatRound( toInt(parseDigit(fm.rg_8_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) );
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          		fm.rg_8[idx].value = replaceFloatRound( toInt(parseDigit(fm.rg_8_amt[idx].value)) / toInt(parseDigit(fm.o_12.value)) );
        	}
      	}
      	var r_idx = idx+1;
      	$("#sel_rg_8_"+r_idx+" option[value='directInput']").prop("selected",true);
      
    } else if (obj == fm.pp_per[idx]) {
    
      	fm.pp_amt[idx].value  = parseDecimal( toInt(parseDigit(fm.o_1.value)) * toFloat(fm.pp_per[idx].value) / 100 );            
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          		fm.pp_amt[idx].value = parseDecimal( toInt(parseDigit(fm.o_12.value)) * toFloat(fm.pp_per[idx].value) / 100 );            
        	}
      	}
      
    } else if (obj == fm.pp_amt[idx]) {
    
      	fm.pp_per[idx].value  = replaceFloatRound( toInt(parseDigit(fm.pp_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) );
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          	fm.pp_per[idx].value = replaceFloatRound( toInt(parseDigit(fm.pp_amt[idx].value)) / toInt(parseDigit(fm.o_12.value)) );
        	}
      	}
      
    } else if (obj == fm.ro_13[idx]) {
    
      	fm.ro_13_amt[idx].value = parseDecimal( getCutRoundNumber(toInt(parseDigit(fm.o_1.value)) * toFloat(fm.ro_13[idx].value) / 100, 1000 )); 
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          		fm.ro_13_amt[idx].value = parseDecimal( getCutRoundNumber( toInt(parseDigit(fm.o_12.value)) * toFloat(fm.ro_13[idx].value) / 100, 1000 ));  
        	}
      	} 
      
    } else if (obj == fm.ro_13_amt[idx]) {
    
      	fm.ro_13[idx].value = replaceFloatRound( toInt(parseDigit(fm.ro_13_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) );
      
      	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
        	if (fm.ls_yn.value == 'Y') {
          		fm.ro_13[idx].value = replaceFloatRound( toInt(parseDigit(fm.ro_13_amt[idx].value)) / toInt(parseDigit(fm.o_12.value)) );
        	}
      	} 
      
    } else if (obj == fm.gi_per[idx]) {
    	
    	var temp_gi_per = fm.gi_per[idx].value;    	
    	var result_gi_amt = toInt(parseDigit(fm.o_1.value)) * toFloat(fm.gi_per[idx].value) / 100;
    	
    	if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
			if (fm.ls_yn.value == 'Y') {
				result_gi_amt = toInt(parseDigit(fm.o_12.value)) * toFloat(fm.gi_per[idx].value) / 100;
			}
      	}
    	
		var unit_num = 100000;
		var round_gi_amt = Math.round(result_gi_amt/unit_num) * unit_num;
		var trunc_gi_amt = Math.floor(result_gi_amt/unit_num) * unit_num;
    	
    	if (temp_gi_per > 34) {
    		fm.gi_amt[idx].value = parseDecimal(trunc_gi_amt);
    	} else {
    		fm.gi_amt[idx].value = parseDecimal(round_gi_amt);
    	}
    	
    	/*
    	fm.gi_amt[idx].value = parseDecimal( toInt(parseDigit(fm.o_1.value)) * toFloat(fm.gi_per[idx].value) / 100 );
    	
		if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
			if (fm.ls_yn.value == 'Y') {
				fm.gi_amt[idx].value = parseDecimal( toInt(parseDigit(fm.o_12.value)) * toFloat(fm.gi_per[idx].value) / 100 );
			}
      	}
		*/
      
    } else if (obj == fm.gi_amt[idx]) {
      
    	if (toInt(parseDigit(fm.gi_amt[idx].value)) == 0) {
	    	fm.gi_per[idx].value = replaceFloatRound(0);
    	} else {
	    	fm.gi_per[idx].value = replaceFloatRound( toInt(parseDigit(fm.gi_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) );
    	}
      
		if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '12') {
			if (fm.ls_yn.value == 'Y') {
		  		if (toInt(parseDigit(fm.gi_amt[idx].value)) == 0) {
		   			fm.gi_per[idx].value = replaceFloatRound(0);
		  		} else {
		   			fm.gi_per[idx].value = replaceFloatRound( toInt(parseDigit(fm.gi_amt[idx].value)) / toInt(parseDigit(fm.o_12.value)) );
		  		}          	
		  	}
		} 
	} 
}
  
//인수 반납유형 선택
function return_type(idx) {
	var fm = document.form1;
	  
	var jg_g_7 = fm.jg_g_7.value;
	var jg_code = fm.jg_code.value;
	var car_comp_id = $("#car_comp_id option:selected").val();
	  
	var cmd = fm.cmd.value;
	  
	//테슬라는 인수반납유형을 타지않기때문에 체크
	if ( (jg_g_7 == "3") && (car_comp_id != "0056" && jg_code != "9133" && jg_code != "9015435" && jg_code != "9015436" && jg_code != "9015437" ) ) {
		//인수반납유형 선택시 반납형일 경우 매입옵션 미부여
		if (fm.return_select[idx].value == '0') {
			fm.opt_chk[idx].options[1].selected = true;
			fm.opt_chk[idx].disabled = true;
			  
			$("#ro_13_"+idx+"_display_1").show();
			$("#ro_13_"+idx+"_display_2").hide();
			  
		} else if (fm.return_select[idx].value == '1') {
			fm.opt_chk[idx].options[0].selected = true;
			fm.opt_chk[idx].disabled = true;

			$("#ro_13_"+idx+"_display_1").hide();
			$("#ro_13_"+idx+"_display_2").show();
			  
		} else {
			fm.opt_chk[idx].options[1].selected = true;
			fm.opt_chk[idx].disabled = false;
			  
			$("#ro_13_"+idx+"_display_1").show();
			$("#ro_13_"+idx+"_display_2").hide();
		}
		  
		if (idx == 2 || idx == 3) {
			if (fm.return_select[idx].value == "0") {
				//fm.a_a[idx].options[1].selected = true;
				//if (cmd != "re") {
				if (fm.a_a[idx].value == "21") {
					fm.a_a[idx].options[1].selected = true;
				} else if (fm.a_a[idx].value == "11") {
					fm.a_a[idx].options[3].selected = true;
				}
				//}
				  
				fm.a_a[idx].options[0].disabled = true;
				fm.a_a[idx].options[1].disabled = false;
				fm.a_a[idx].options[2].disabled = true;
				fm.a_a[idx].options[3].disabled = false;
				fm.a_a[idx].options[4].disabled = true;
				  
			} else if (fm.return_select[idx].value == "1") {
				//fm.a_a[idx].options[1].selected = true;
				  
				fm.a_a[idx].options[0].disabled = false;
				fm.a_a[idx].options[1].disabled = false;
				fm.a_a[idx].options[2].disabled = false;
				fm.a_a[idx].options[3].disabled = false;
				fm.a_a[idx].options[4].disabled = false;
			}
		}
	}
}
  
	//상품선택시 매입옵션 구분 셋팅
	function SelectA_a(idx) {
	 	var fm = document.form1;
	  
	 	var jg_g_7 = fm.jg_g_7.value;
	 	var jg_code = fm.jg_code.value;  	
	 	var car_comp_id = $("#car_comp_id option:selected").val();
	 
		//면세가 표기가 "면세가격기준" 차량이면 리스불가(20190502)
		if (fm.a_a[idx].value=="11"||fm.a_a[idx].value=="12") {
			if (fm.duty_free_opt.value=="1") {
				alert("차량가격 개소세 면세가 표기차량은 리스 견적이 안됩니다.");
				fm.a_a[idx].options[1].selected = true;
			}
		}
		
		//신차 리스 견적시 보증보험 입력 불가
		if (fm.a_a[idx].value=="11"||fm.a_a[idx].value=="12") {
			$("#gi_per_"+(idx+1)).prop("readonly", true);
			$("#gi_per_"+(idx+1)).val("0");
			$("#gi_amt_"+(idx+1)).prop("readonly", true);
			$("#gi_amt_"+(idx+1)).val("0");
		} else {
			$("#gi_per_"+(idx+1)).prop("readonly", false);
			$("#gi_amt_"+(idx+1)).prop("readonly", false);
		}
		
	  	
			fm.a_a[1].disabled = false;
			if (fm.a_a[idx].value == '11' || fm.a_a[idx].value == '21') {//일반식     
			  fm.opt_chk[idx].options[0].selected = true;     
			} else {
			  fm.opt_chk[idx].options[1].selected = true;     
			}
		
	}
  
        
//제조사D/C 입력후 차가계산하기
function set_amt() {
	var fm = document.form1;  
    	fm.o_1.value  = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value))  - toInt(parseDigit(fm.tax_dc_amt.value)));        
    if (fm.ls_yn.value == 'Y') {
    	fm.o_12.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt2.value)) - toInt(parseDigit(fm.tax_dc_amt.value)));    
    }    
}
  
//최대잔가율 조회
function searchO13(idx) {
    var fm = document.sh_form;
    var fm2 = document.form1;
    var car_comp_id = $("#car_comp_id option:selected").val();
    var jg_code = fm2.jg_code.value;
    var agree_dist = fm2.agree_dist[idx].value;
    
    <%-- <%if (!(nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업팀장", user_id) || user_id.equals("000057"))) {%>
    if (Number(jg_code) > 9000000 && Number(jg_code) < 9036000) {
    	if (Number(agree_dist.replace(/,/g,"")) > 60000) {
    		alert("연간 약정운행거리 최대값을 초과하여 입력하였습니다.\n\n* 차종별 연간 약정운행거리 최대값\n- 스타렉스 벤 및 트럭 : 6만km/년 이하\n- 그외차종 : 5만km/년 이하");
    		return;
    	}
    } else {
    	if (Number(agree_dist.replace(/,/g,"")) > 50000) {
    		alert("연간 약정운행거리 최대값을 초과하여 입력하였습니다.\n\n* 차종별 연간 약정운행거리 최대값\n- 스타렉스 벤 및 트럭 : 6만km/년 이하\n- 그외차종 : 5만km/년 이하");
    		return;
    	}
    }
    <%}%> --%>
    
    if (fm2.car_id.value == '') {   	alert('차종을 선택하십시오');     return; }
    if (fm2.car_amt.value == '') {  	alert('차량금액을 확인하십시오');   return; }           
    if (fm2.a_a[idx].value == '') {   alert('대여상품을 선택하십시오');   return; }
    if (fm2.a_b[idx].value == '') {   alert('대여기간을 선택하십시오');   return; }
    
    if (fm2.est_yn[idx].checked ==false)  fm2.est_yn[idx].checked = true;
    
    fm.rent_dt.value   		= fm2.rent_dt.value;
    fm.car_id.value   		= fm2.car_id.value;
    fm.car_seq.value  		= fm2.car_seq.value;
    fm.car_amt.value  		= fm2.car_amt.value;
    fm.opt_amt.value 	 	= fm2.opt_amt.value;
    fm.opt_amt_m.value 	= fm2.opt_amt_m.value;
    fm.col_amt.value  		= fm2.col_amt.value;
    fm.dc_amt.value  	 	= fm2.dc_amt.value;
    fm.o_1.value    			= fm2.o_1.value;    
    fm.jg_opt_st.value 		= fm2.jg_opt_st.value;
    fm.jg_col_st.value  	= fm2.jg_col_st.value;
    fm.a_a.value    		= fm2.a_a[idx].value;
    fm.a_b.value    		= fm2.a_b[idx].value; 
    fm.agree_dist.value 	= fm2.agree_dist[idx].value;
    fm.ecar_loc_st.value 	= fm2.ecar_loc_st[idx].value;
    fm.hcar_loc_st.value 	= fm2.hcar_loc_st[idx].value;
    /* fm.eco_e_tag.value   	= fm2.eco_e_tag[idx].value; */
    fm.rtn_run_amt_yn.value 	= fm2.rtn_run_amt_yn[idx].value;
    
    fm.idx.value    		= idx;  
    
	if (fm2.print_type[0].checked ==true) 	fm.print_type.value	= '1';	
	if (fm2.print_type[1].checked ==true) 	fm.print_type.value	= '5';	
	if (fm2.print_type[2].checked ==true) 	fm.print_type.value	= '2';	
	if (fm2.print_type[3].checked ==true) 	fm.print_type.value	= '3';	
	if (fm2.print_type[4].checked ==true) 	fm.print_type.value	= '4';	
	if (fm2.print_type[5].checked ==true) 	fm.print_type.value	= '6';	
	
	if (fm.print_type.value == '5') {
		fm.ecar_loc_st.value = fm2.ecar_loc_st[0].value;
		fm.hcar_loc_st.value = fm2.hcar_loc_st[0].value;
		/* fm.eco_e_tag.value   = fm2.eco_e_tag[0].value; */
	}
				
	if (fm2.jg_g_7.value == '3' && fm.ecar_loc_st.value == '') {
		if ( jg_code != "5866" && jg_code != "6316111" && Number(fm2.jg_g_15.value) > 0 ) {				
			alert('전기차 고객주소지를 선택하십시오.'); return;
		}
	}
			
	if (fm2.jg_g_7.value == '4' && fm.hcar_loc_st.value == '') {
		alert('수소차 고객주소지를 선택하십시오.'); return;
	}
    
    var car_price     = toInt(parseDigit(fm.o_1.value));    
    
//     fm2.rg_8[idx].value     = '25';
    
	/* 
	if (car_price <= 45000000) {
		fm2.rg_8[idx].value     = '20';
    } 
	*/    
	
// 	if (Number($("#car_comp_id option:selected").val()) <= 5) {
// 		fm2.rg_8[idx].value     = '20';
// 	} else {
// 		fm2.rg_8[idx].value     = '25';
// 	}
    
    //전기차는 기본 보증금에서 10% 빼준다
    //20190612 테슬라로 인해 친환경차구분에서 엔진구분으로 변경
    /* if (fm2.jg_g_7.value == '3') { */
//     if ( Number(fm2.jg_b.value) > 4 ) {
//      	fm2.rg_8[idx].value     = toInt(fm2.rg_8[idx].value)-10;
//     }
    
    // 기본보증금 계산식 수정 2021.07.09.
    // 기본보증금 계산식 수정 2022.05.06.
    if(Number($("#car_comp_id option:selected").val()) > 5){ // 수입차
//     	if (Number(fm2.jg_g_7.value) > 2) 	fm2.rg_8[idx].value = 15;	// 친환경차 구분상 전기/수소차
//     	else 												fm2.rg_8[idx].value = 25;
    	fm2.rg_8[idx].value = 25;
    } else{	// 국산차
//     	if (Number(fm2.jg_g_7.value) > 2) 	fm2.rg_8[idx].value = 10;	// 친환경차 구분상 전기/수소차
//     	else 												fm2.rg_8[idx].value = 20;
    	fm2.rg_8[idx].value = 20;
    }
    console.log(fm2.rg_8[idx].value);
 	// 친환경차 구분상 전기차면서 차량가격 합계 금액이 8천만원 초과 시 +10%, 6500만원 넘으면 +5%, 6500만원 이하면 그대로.
 	// 친환경차 구분상 전기차면서 차량가격 7500만원 이하면 -5%  2022.05.06.
    if (fm2.jg_g_7.value == '3'){
//     	if(car_price > 80000000)			fm2.rg_8[idx].value = Number(fm2.rg_8[idx].value) + 10;
// 		else if(car_price > 65000000) 	fm2.rg_8[idx].value = Number(fm2.rg_8[idx].value) + 5;
    	
    	if(car_price <= 75000000)			fm2.rg_8[idx].value = Number(fm2.rg_8[idx].value) - 5;
    }
 	// 수소차면 -5%
 	if(fm2.jg_g_7.value == '4'){
 		fm2.rg_8[idx].value = Number(fm2.rg_8[idx].value) - 5;
 	}
 	console.log(fm2.rg_8[idx].value);
    	
    //전기차, 수소차는 기본 보증금에서 10% 빼준다
    /* if (fm2.jg_b.value == '3' || fm2.jg_b.value == '4') { //3 전기차, 4 수소차
     	fm2.rg_8[idx].value     = toInt(fm2.rg_8[idx].value)-10;
    } */
    
    var r_idx = idx + 1;
    $("#sel_rg_8_"+r_idx+" option[value='"+fm2.rg_8[idx].value+"']").prop("selected", true);
    
    //렌트
    if (fm.a_a.value == '22' || fm.a_a.value == '21') {
      	if (fm2.jg_h.value != '1') {
        	alert('렌트운영차량이 아닙니다.');
        	return;
      	}   
    }   
    
    //리스DC 상이할때
    if (fm.a_a.value == '11' || fm.a_a.value == '12') {
      	if (fm2.jg_i.value != '1') {
        	alert('리스운영차량이 아닙니다.');
        	return;
      	}                 
      	if (fm2.ls_yn.value == 'Y') {
        	fm.dc_amt.value     = fm2.dc_amt2.value;
        	fm.o_1.value      	= fm2.o_12.value; 
        	car_price       		= toInt(parseDigit(fm2.o_12.value));              
      	}
    }

    fm2.rg_8_amt[idx].value = parseDecimal(getCutRoundNumber(car_price * toFloat(fm2.rg_8[idx].value) /100, 1000 ));
    
    //20141002 선납금, 보증보험료 있으면 재계산
    compare(idx, fm2.pp_per[idx]);
    compare(idx, fm2.gi_per[idx]);

    if ((fm.print_type.value == '2' || fm.print_type.value == '3' || fm.print_type.value == '4') && idx > 0) {
		return;
    }
    
    fm2.search_o13_yn.value = 'Y';
            
    fm.action = '/acar/estimate_mng/get_o13_20141223.jsp';    
    fm.target = 'i_no'; 
    
<%if (nm_db.getWorkAuthUser("전산팀", user_id)) {%>
	if (fm2.O13_yn.checked == true) {
		fm.target = '_blank';
	}
<%}%>
    
    fm.submit();
    
} 
  
// 세자리 수마다 콤마 넣기
function numberWithCommas(x) {
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
    
//견적내기
function EstiReg() {
    var fm = document.form1;
    
    var jg_code = fm.jg_code.value;
    var car_comp_id = $("#car_comp_id option:selected").val();
    var doc_type_value = $('input:radio[name="doc_type"]:checked').val();
    
    //20160701 일시중지
    <%if (AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) == 20160701) {%>
    	//alert('7월1일 개별소비세 인상으로 견적 준비중입니다. 엑셀견적프로그램을 이용하여 주십시오.');
    	//return;
    <%}%>
    
    fm.est_nm.value = fm.est_nm.value.trim();
    /* 
    var temp_est_nm = fm.est_nm.value;    
	for (var i = 0; i < fm.est_nm.value.length; i++) { // 값이 들어간 길이 만큼 제목과 본문의 공백을 제거
		temp_est_nm = temp_est_nm.replace(" ", "");
	} 
	*/
        
    if (fm.est_nm.value == '') {
    	alert('고객/상호명를 입력하십시오');
    	fm.est_nm.focus();
    	return;
    }
    
    if (fm.code.value == '') {    	alert('차명을 선택하십시오');       	return; }
    if (fm.car_id.value == '') {    alert('차종을 선택하십시오');       	return; }
    if (fm.car_amt.value == '') {   alert('차량가격을 확인하십시오');     	return; }       
    if (fm.a_a[0].value == '') {    alert('대여상품을 선택하십시오');     	return; }
    if (fm.a_b[0].value == '') {    alert('대여기간을 선택하십시오');     	return; }
    
    //20160520 아슬란 특판출고관련 통보메시지
    if (fm.jg_code.value == '4156' || fm.jg_code.value == '4157' || fm.jg_code.value == '4012591' || fm.jg_code.value == '4012592') {
    	alert('법인판매팀 출고기준 견적입니다. 영업사원을 통한 간접영업의 경우에도 법무판매팀 출고를 하고, 당사에서 출고보전 수당을 지급하도록 합니다. (지점 및 대리점 출고 불가 차종)');
    }
    
    //20191004 마이티, 메가트럭등 2.4통 초과하는차량은 견적시 안내사항 팝업노출 - 김진좌 팀장 요청사항
    if ((Number(fm.jg_code.value) >= 9142 && Number(fm.jg_code.value) <= 9152) || (Number(fm.jg_code.value) >= 9017212 && Number(fm.jg_code.value) <= 9018112)) {
    	
    	var msg = "계약전 안내사항\n\n" +
    					"1. 2.4톤 이상 차량(마이티, 메가트럭 등)은,\n" +
						"차고지증명으로 인하여 출고후, 등록일이 약 7일~최대 10일 소요 됩니다.\n\n" +
						"2. 해당 차량, 출고후 등록일까지 고객 차고지에 보관 가능해야 합니다.\n\n" +
						"3. 용품작업 불가 (블랙박스 직접장착, 선팅작업불가)";
    	
    	if (!confirm(msg)) {
   			return;
    	}
    }
    
<%if (!est_table.equals("esti_spe")) {%>
    //비교견적일때 입력값과 초기값 비교해서 최대잔가 재계산여부 체크
    <%if (!e_bean.getEst_id().equals("")) {%>
    if (fm.o_1.value != '<%=AddUtil.parseDecimal(e_bean.getO_1())%>' || fm.a_b[0].value != '<%=e_bean.getA_b()%>' ) {    
    	if (fm.search_o13_yn.value == '') { 
        	alert('견적1의 조건이 변경되었으므로 최대잔가를 재계산하여 주십시오.');
        	return;
      	}
    }
    <%}%>
<%}%>
    
    var ins_confirm = 'N';    
    
    var est_yn_count = 0;
    
<%for (int j = 0; j < 4; j++) {%>
    if (fm.est_yn[<%=j%>].checked == true) {
    	      	
    	est_yn_count++;
    	
<%-- 		if (fm.tint_s_yn[<%=j%>].checked ==true) fm.r_tint_s_yn[<%=j%>].value = 'Y'; --%>
		if (fm.tint_sn_yn[<%=j%>].checked ==true) fm.r_tint_sn_yn[<%=j%>].value = 'Y'; // 전면썬팅 미시공할인 체크
		
		if (fm.tint_ps_yn[<%=j%>].checked ==true) {	
			fm.r_tint_ps_yn[<%=j%>].value = 'Y';		// 고급썬팅
		    fm.r_tint_ps_nm[<%=j%>].value =	 fm.tint_ps_nm[<%=j%>].value;		// 고급썬팅 내용
			fm.r_tint_ps_amt[<%=j%>].value = fm.tint_ps_amt[<%=j%>].value;		// 고급썬팅 추가금액(공급가)
			fm.r_tint_ps_st[<%=j%>].value = fm.setTint_ps_sel[<%=j%>].value;	// 고급썬팅 선택값
		}
		
		if (fm.tint_cons_yn[<%=j%>].checked ==true) {	
			fm.r_tint_cons_yn[<%=j%>].value = 'Y';
			fm.r_tint_cons_amt[<%=j%>].value = fm.tint_cons_amt[<%=j%>].value;		// 추가탁송료
		}
		
		if (fm.tint_n_yn[<%=j%>].checked ==true) fm.r_tint_n_yn[<%=j%>].value = 'Y';
		if (fm.tint_bn_yn[<%=j%>].checked ==true) fm.r_tint_bn_yn[<%=j%>].value = 'Y';
		if (fm.tint_eb_yn[<%=j%>].checked ==true) fm.r_tint_eb_yn[<%=j%>].value = 'Y';
		
<%-- 		if (fm.tint_s_yn[<%=j%>].checked ==false) fm.r_tint_s_yn[<%=j%>].value = 'N';		// 전면썬팅 체크 해제 시 값 변경 추가 2017.12.27 --%>
		if (fm.tint_sn_yn[<%=j%>].checked ==false) fm.r_tint_sn_yn[<%=j%>].value = 'N';		// 전면썬팅 미시공할인 체크 해제 시 값 변경 추가 2017.12.27
		if (fm.tint_ps_yn[<%=j%>].checked ==false) fm.r_tint_ps_yn[<%=j%>].value = 'N';		// 고급썬팅 체크 해제 시 값 변경 추가 2017.12.27
		if (fm.tint_cons_yn[<%=j%>].checked ==false) fm.r_tint_cons_yn[<%=j%>].value = 'N';		// 추가탁송료 체크 해제 시 값 변경 추가 2020.06.15
		if (fm.tint_n_yn[<%=j%>].checked ==false) fm.r_tint_n_yn[<%=j%>].value = 'N';		// 거치형 내비게이션 체크 해제 시 값 변경 추가 2017.12.27
		if (fm.tint_bn_yn[<%=j%>].checked ==false) fm.r_tint_bn_yn[<%=j%>].value = 'N';		// 블랙박스 미제공 할인 (빌트인캠,고객장착..)
		if (fm.tint_cons_yn[<%=j%>].checked ==false) fm.r_tint_cons_yn[<%=j%>].value = 'N';		// 추가탁송료
		if (fm.tint_eb_yn[<%=j%>].checked ==false) fm.r_tint_eb_yn[<%=j%>].value = 'N';		// 거치형 내비게이션 체크 해제 시 값 변경 추가 2017.12.27
		
    	fm.r_a_a[<%=j%>].value = fm.a_a[<%=j%>].value;
    	fm.r_ins_per[<%=j%>].value = fm.ins_per[<%=j%>].value;
    	fm.r_ins_dj[<%=j%>].value = fm.ins_dj[<%=j%>].value;
    	fm.r_ins_age[<%=j%>].value = fm.ins_age[<%=j%>].value;
    	fm.r_loc_st[<%=j%>].value = fm.loc_st[<%=j%>].value;
    	fm.r_ecar_loc_st[<%=j%>].value = fm.ecar_loc_st[<%=j%>].value;
    	fm.r_hcar_loc_st[<%=j%>].value = fm.hcar_loc_st[<%=j%>].value;
    	<%-- fm.r_eco_e_tag[<%=j%>].value = fm.eco_e_tag[<%=j%>].value; --%>
    	fm.r_com_emp_yn[<%=j%>].value = fm.com_emp_yn[<%=j%>].value;
    	fm.r_new_license_plate[<%=j%>].value = fm.new_license_plate[<%=j%>].value;
    	            
      	//렌트
      	if (fm.a_a[<%=j%>].value == '22' || fm.a_a[<%=j%>].value == '21') {
        	if (fm.jg_h.value != '1') {
          		alert('렌트운영차량이 아닙니다.');
          		return;
        	}
        	//24세는 렌트견적안됨
        	if (fm.ins_age[<%=j%>].value == '3') {
          		alert('운전연령 만24세이상은 리스만 가능합니다.');
          		return;
        	}           
      	} else {
        	if (fm.jg_i.value != '1') {
          		alert('리스운영차량이 아닙니다.');
          		return;
        	}                 
      	}
      
      	//20131104 영업수당 3% 초과시 견적 안됨
      	if (toFloat(fm.o_11[<%=j%>].value) > 3) {
        	alert('영업사원 수당율이 3%를 초과할 수 없습니다.');
        	return;
      	}
      
      	//20150414 대물5억일때 메시지
      	if (fm.ins_dj[<%=j%>].value == '3') {
        	ins_confirm = 'Y';  
      	}
      
      	//전기차
      	if (fm.jg_g_7.value == '3') {
      	
      		if (fm.print_type[1].checked == true && <%=j%> > 0) {
      		} else {
	      		if (fm.ecar_loc_st[<%=j%>].value == '') {
  	        		if ( jg_code != "5866" && jg_code != "6316111"  && Number(fm.jg_g_15.value) > 0 ) {
		      			alert('전기차 고객주소지를 선택하십시오.');
	    	    		return;
  	        		}
      	  		}  	
      		}
      		
	        //전기차는 24개월이상만
	      	if (toInt(fm.a_b[<%=j%>].value) < 24) {
	          alert('전기차는 24개월이상만 견적 가능합니다.');
	          return;
	        }
	        
	        //전기차 고객주소지 선택 후 최대잔가율 계산하도록 유도(2018.04.25)
	        if (fm.ecar_pur_sub_amt.value == '') {
	        	alert('최대잔가율을 계산해주세요.');
	        	return;
	        }
        
      	//수소차
      	} else if (fm.jg_g_7.value == '4') {
      	
        	//수소차는 24개월이상만
      		if (toInt(fm.a_b[<%=j%>].value) < 24) {
          		alert('수소차는 24개월이상만 견적 가능합니다.');
          		return;
        	}
        	
        	//수소차 최대잔가율 계산하도록 유도
        	if (fm.ecar_pur_sub_amt.value == '') {
       			alert('최대잔가율을 계산해주세요.');
        		return;
        	}        
        
      	} else {
      		//전기차제외 12~60개월만
      		if (toInt(fm.a_b[<%=j%>].value) < 12 || toInt(fm.a_b[<%=j%>].value) > 60) {
          		alert('대여기간이 12개월~60개월의 견적이 가능합니다.');
          		return;
        	}  	
        	fm.r_tint_eb_yn[<%=j%>].value = 'N';
      	}
      
      	var r_ro_13_amt = toInt(parseDigit(fm.o_1.value)) * toFloat(fm.ro_13[<%=j%>].value) / 100;
      	var cha_line_amt = toInt(parseDigit(fm.o_1.value)) * 0.05 / 100;
      
      	if (fm.a_a[<%=j%>].value == '11' || fm.a_a[<%=j%>].value == '12') {
	        if (fm.ls_yn.value == 'Y') {
	          	r_ro_13_amt = toInt(parseDigit(fm.o_12.value)) * toFloat(fm.ro_13[<%=j%>].value) / 100;
	          	cha_line_amt = toInt(parseDigit(fm.o_12.value)) * 0.05 / 100;
	        }
      	} 
      
      	var r_cha_ro_13_amt = toInt(parseDigit(fm.ro_13_amt[<%=j%>].value))-r_ro_13_amt;
      
      	if (r_cha_ro_13_amt > cha_line_amt || r_cha_ro_13_amt < -cha_line_amt) {
      		alert('차가에 적용잔가율을 계산한 금액과 전용잔가금액이 다릅니다. 확인하십시오.');
      		return;
      	}
      
		// 보증금 제한 2018.01.10
		<%-- 
		var regex = "/,/gi";
		if (fm.jg_g_7.value == '3' || fm.jg_g_7.value == '4') {		// 전기차,수소차 일 경우
			var deposit = fm.o_1.value.replace(/,/gi,'') - fm.ecar_pur_sub_amt.value;		// 보증금은 차량가격 - 구매보조금
			var rg_8_amt_replace = fm.rg_8_amt[<%=j%>].value.replace(/,/gi,'');		// 보증금 금액
			if (rg_8_amt_replace > deposit) {
				alert('보증금은 '+numberWithCommas(deposit)+'원 (차량가격 - 구매보조금) 이내만 납부 가능합니다. \n\n추가로 초기납입금 납부를 원할 경우 선납금으로 납부하시면 됩니다.');
				return;
			}
		} else {		// 전기차가 아닐 경우 보증금 차가 100% 제한		2018.01.04
			var normal_car_rg8 = fm.rg_8_amt[<%=j%>].value.replace(/,/gi,'');		// 보증금액
			var normal_car_total = fm.o_1.value.replace(/,/gi,'');								// 차량가격
			if (Number(normal_car_rg8) > Number(normal_car_total)) {
				alert('보증금은 차가의 100% 이내만 납부 가능합니다. \n\n추가로 초기납입금 납부를 원할 경우 선납금으로 납부하시면 됩니다.');
				return;
			}
		} 
		--%>
      
      	//자차면책금 점검
      	if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
      		if (parseDigit(fm.car_ja[<%=j%>].value) != '500000') {
      			alert('면책금 금액이 틀렸습니다.'); return;
      		}
      	} else {
      		if (parseDigit(fm.car_ja[<%=j%>].value) == '300000' || parseDigit(fm.car_ja[<%=j%>].value) == '200000' || parseDigit(fm.car_ja[<%=j%>].value) == '100000') {
      		} else {
      			alert('면책금 금액이 틀렸습니다.'); return;
      		}
      	}
      	
		//개인사업자일때 선택으로 되어있으면 가입 또는 미가입으로 선택하도록 수정
        if (doc_type_value == "2") {
    	    if (fm.com_emp_yn[<%=j%>].value == "") {
    	    	alert("임직원 한정운전특약 가입 여부를 선택해주세요.\n\n성실신고확인대상자, 전문직업종 개인사업자는 2021년1월1일 이후부터 업무전용자동차보험에 가입하여야 합니다. 단, 사업자별 1대는 업무전용자동차보험 가입대상에서 제외, 1대를 제외한 나머지 차량 업무전용자동차보험 미가입 시 비용의 50%만 인정됩니다.\n\n자세한 내용은 홈페이지 하단 [손비처리 기준]을 참고해주세요.");
    			return;
    	  	}
        }
      	
    }
    
    <%if (!(nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업팀장", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
    if (Number(fm.jg_code.value) > 9000000 && Number(fm.jg_code.value) < 9036000) {	
    	if (Number(fm.agree_dist[<%=j%>].value.replace(/,/g,"")) < 5000 || Number(fm.agree_dist[<%=j%>].value.replace(/,/g,"")) > 60000) {
    		alert("연간 약정운행거리 최대값을 초과하여 입력하였습니다.\n\n* 차종별 연간 약정운행거리 최대값\n- 스타렉스 벤 및 트럭 : 5,000 ~ 60,000km/년 이하\n- 그외차종 : 5,000 ~ 50,000km/년 이하");
    		return;
    	}
    } else {
    	if (Number(fm.agree_dist[<%=j%>].value.replace(/,/g,"")) < 5000 || Number(fm.agree_dist[<%=j%>].value.replace(/,/g,"")) > 50000) {
    		alert("연간 약정운행거리 최대값을 초과하여 입력하였습니다.\n\n* 차종별 연간 약정운행거리 최대값\n- 스타렉스 벤 및 트럭 : 5,000 ~ 60,000km/년 이하\n- 그외차종 : 5,000 ~ 50,000km/년 이하");
    		return;
    	}
    }
    <%}%>
    
<%}%>
    
    if (est_yn_count == 0) {
    	alert("선택된 견적이 없습니다. 견적을 선택해 주세요.");
    	return;
    }
    
    //수입차는 옵션,색상가격 넣을수 없음.
    if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
    	//if (toInt(parseDigit(fm.opt_amt.value)) > 0) {    alert('수입차는 옵션금액이 추가되면 견적할 수 없습니다.');      return; }
      	//if (toInt(parseDigit(fm.col_amt.value)) > 0) {    alert('수입차는 색상금액이 추가되면 견적할 수 없습니다.');      return; }
      	if (toInt(parseDigit(fm.dc_amt.value)) > 0) {     
      		alert('수입차는 제조사DC금액이 추가되면 견적할 수 없습니다.');
      		return;
      	}
    }
    
    //수입차가 리스일때 피보험자는 아마존카로 할 수 없다.
    <%-- 
    if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
    	var ins_per_count = 0;
    	<%for (int z = 0; z < 4; z++) {%>
		if (fm.est_yn[<%=z%>].checked ==true) {
			if (fm.a_a[<%=z%>].value == '12' || fm.a_a[<%=z%>].value == '11') {				
				if (fm.ins_per[<%=z%>].value == "1") {					
					ins_per_count++;
				}
			}
		}
  		<%}%>
  		
  		if (ins_per_count != 0) {
  			alert("수입차 리스는 고객피보험자로 견적해야 합니다.");
  			return;
  		}
    } 
    --%>
    
  	//트럭일반식 불가-20190829
	if ((toInt(jg_code) > 9120 && toInt(jg_code) < 9410) || (toInt(jg_code) > 9015410 && toInt(jg_code) < 9045010)) {
		var truck_count = 0;
    	<%for (int z = 0; z < 4; z++) {%>		
		if (fm.a_a[<%=z%>].value == '11' || fm.a_a[<%=z%>].value == '21') {
			truck_count++;
		}		
  		<%}%>
  		
  		if (truck_count != 0) {
  			alert("트럭은 일반식 견적이 되지 않습니다.");
  			return;
  		}
	}
    
    if (ins_confirm == 'Y') {
    	alert('대물 보상한도 5억원은 계약서 작성전에 렌터카공제조합에 미리 승인을 받아야 합니다.');     
    }

    //수입차 견적별종합은 렌트와 리스를 섞어서 견적할수 없음.
    if (fm.print_type[1].checked == true && toInt(parseDigit(fm.car_comp_id.value)) > 5) {
    	var r_cnt = 0;
    	var l_cnt = 0;
    	<%for (int j = 0; j < 4; j++) {%>
   		if (fm.est_yn[<%=j%>].checked ==true) {
   			if (fm.a_a[<%=j%>].value == '22' || fm.a_a[<%=j%>].value == '21') r_cnt++;
   			if (fm.a_a[<%=j%>].value == '12' || fm.a_a[<%=j%>].value == '11') l_cnt++;
   		}
      	<%}%>
     	if (r_cnt>0 && l_cnt>0) {
      		alert('견적별 종합에서 수입차 견적시 렌트/리스 혼합견적은 불가능합니다.');   return; 
      	}
    } 
    
<%for (int j = 0; j < 4; j++) {%>
	// 전면썬팅과 고급썬팅은 모두 체크 할 수 없다. 2017.12.18
<%--     if (fm.tint_s_yn[<%=j%>].checked && fm.tint_ps_yn[<%=j%>].checked) { --%>
//     	alert('전면썬팅과 고급썬팅 중 하나만 체크하세요.'); return;
//     }
	
	// 고급썬팅(전면포함)과 전면썬팅 미시공 할인은 함께 체크할 수 없음. 2021.09.13
	if( fm.tint_ps_yn[<%=j%>].checked && fm.tint_sn_yn[<%=j%>].checked ){
		alert('고급썬팅(전면포함) 선택시 전면썬팅 미시공 할인이 견적에 반영되므로 고급썬팅(전면포함)과 전면썬팅 미시공 할인을 동시에 선택할 필요가 없습니다.\n고급썬팅(전면포함) 체크시 전면썬팅 미시공 할인 체크를 풀어주세요.');
		return;
	}
    
    // 고급썬팅 체크 후 견적반영 금액이 0원일 수 없다.
    if (fm.tint_ps_yn[<%=j%>].checked && uncomma(fm.tint_ps_amt[<%=j%>].value) < 1) {
    	alert('고급썬팅 금액을 입력하세요.'); return;
    }
    
    // 고급썬팅 체크 후 견적반영 금액이 50만원 이상일 수 없다.
    if (fm.tint_ps_yn[<%=j%>].checked && uncomma(fm.tint_ps_amt[<%=j%>].value) > 500000) {
    	alert('고급썬팅 최대한도 견적금액은 50만원 입니다.\n50만원 초과분의 썬팅비용은 고객부담입니다.\n(중도해지시 잔가 가치는 인정받지 못하면서 위약금 처리되면 손해)'); return;
    }
<%}%>
    
	if (fm.badcust_chk.value == '') {
		//alert('불량고객 확인을 하십시오.'); 	return;		
		//window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_atype_i.jsp&est_nm='+fm.est_nm.value+'&est_tel='+fm.est_tel.value+'&est_mail='+fm.est_email.value+'&est_fax='+fm.est_fax.value, "BADCUST", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
		//return;
	}
			
	// 견적전 제조사DC 비고내용중 월 조건 반영 문구의 달과 현재 달이 다를경우 알림창
	var temp_bigo = fm.bigo.value;
	var replace_bigo = temp_bigo.replace(/[^0-9]/g,"");
	
	var today = new Date();
	var get_mm = today.getMonth()+1;
	
	if (temp_bigo != "") {
		if (replace_bigo != get_mm) {
			alert("견적일자의 월과 조건 반영 월이 다릅니다. \n\n담당자에게 확인 부탁드립니다.");
		}
	}
	
	//if (!confirm('견적하시겠습니까?')) { return; }
	
	// 견적전 disabled 해제	
	$("#est_yn_1").attr("disabled", false);
	$("#est_yn_2").attr("disabled", false);
	
	fm.return_select[0].disabled = false;
	fm.return_select[1].disabled = false;	
	fm.return_select[2].disabled = false;	
	fm.return_select[3].disabled = false;
	
	fm.a_a[0].disabled = false;
	fm.a_a[1].disabled = false;	
	fm.a_a[2].disabled = false;	
	fm.a_a[3].disabled = false;
	
	fm.opt_chk[0].disabled = false;
	fm.opt_chk[1].disabled = false;
	fm.opt_chk[2].disabled = false;
	fm.opt_chk[3].disabled = false;
	
	//대여기간
	$("#sel_a_b_2").attr("disabled", false); 
	$("#a_b_2").attr("disabled", false);
	//적용약정운행거리
	$("#sel_agree_dist_2").attr("disabled", false);
	$("#agree_dist_2").attr("disabled", false);
	//보증금
	$("#sel_rg_8_2").attr("disabled", false);
	$("#rg_8_2").attr("disabled", false);
	$("#rg_8_amt_2").attr("disabled", false);
	//선납금
	$("#pp_per_2").attr("disabled", false);
	$("#pp_amt_2").attr("disabled", false);
	//개시대여료
	$("#g_10_2").attr("disabled", false);
	//보증보험
	$("#gi_per_2").attr("disabled", false);
	$("#gi_amt_2").attr("disabled", false);
	//영업수당
	$("#sel_o_11_2").attr("disabled", false);
	$("#o_11_2").attr("disabled", false);
	//대여료DC
	$("#fee_dc_per_2").attr("disabled", false);    
    
  	//차량인도지역
	$("#loc_st_1").attr("disabled", false);
	$("#loc_st_2").attr("disabled", false);
	$("#loc_st_3").attr("disabled", false);
	$("#loc_st_4").attr("disabled", false);
	
	// 렌트, 리스, 종합 견적 시 disabled 처리 항목 submit 전 활성화
	// 렌트, 리스, 종합 견적 시 disabled 처리 항목 submit 전 활성화
	var printType = fm.print_type.value;
	if(printType == 2 || printType == 3 || printType == 4){
		// 대여상품
		fm.a_a[0].disabled = false;
		fm.a_a[1].disabled = false;
		fm.a_a[2].disabled = false;
		fm.a_a[3].disabled = false;
		      
		// 매입옵션 항목 비활성화
		fm.opt_chk[0].disabled = false;
		fm.opt_chk[1].disabled = false;
		fm.opt_chk[2].disabled = false;
		fm.opt_chk[3].disabled = false;
		
		for(var i=1; i<4; i++){
			// 비활성화 해제
			fm.sel_a_b[i].disabled = false;				// 대여기간
			fm.a_b[i].disabled = false;						// 대여기간
			fm.b_agree_dist[i].disabled = false;			// 표준 약정운행거리
			fm.sel_agree_dist[i].disabled = false;		// 적용 약정운행거리
			fm.agree_dist[i].disabled = false;				// 적용 약정운행거리
			fm.b_o_13[i].disabled = false;					// 표준 최대잔가
			fm.o_13[i].disabled = false;					// 표준 최대잔가
			fm.ro_13[i].disabled = false;					// 적용잔가
			fm.ro_13_amt[i].disabled = false;			// 적용잔가
			
			// 견적 2, 3, 4 항목에 견적 1 값 세팅.
			// 보증금
			fm.sel_rg_8[i].value = fm.sel_rg_8[0].value;
			fm.rg_8[i].value = fm.rg_8[0].value;
			fm.rg_8_amt[i].value = fm.rg_8_amt[0].value;
			// 선납금
			fm.pp_per[i].value = fm.pp_per[0].value;
			fm.pp_amt[i].value = fm.pp_amt[0].value;
			
		}
	}
    
    var link = document.getElementById("submitLink");
	var originFunc = link.getAttribute("href");
	link.setAttribute('href', "javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
    fm.cmd.value = "i";
    fm.action = 'esti_mng_atype_i_a.jsp';
    fm.target = "i_no";    
    
    fm.submit();
    
    link.getAttribute('href', originFunc);
}
  
//badcust_chk로 confirm 대체
function confirmDialog() {
	var fm = document.form1;
	var flag = false;
	for(var i=0; i<fm.o_13.length; i++){
		var o_13 = fm.o_13[i].value;
		var ro_13 = fm.ro_13[i].value;
		var fee_dc_per = fm.fee_dc_per[i].value;

		if( o_13-ro_13 > 3 && fee_dc_per > 0)	flag = true;
	}
	if(flag){
		alert('적용잔가율 조정에 따른 대여요금 할인이 반영되어 있는 상태에서 추가적인 대여료 D/C가 견적에 들어가 있습니다. 추가적인 대여료 D/C 반영 관련하여 영업팀장과 협의가 필요합니다.');
		<%if (!(nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
			return;
		<%}%>
	}
	
	/* if(fm.car_comp_id.value == '0056'){
		for(var i=0; i<fm.agree_dist.length; i++){
			var agree_dist = fm.agree_dist[i].value.replace(',', '');
			if(agree_dist < 10000 || agree_dist > 30000){
				alert('테슬라 차량은 약정운행거리 1~3만km만 가능합니다.');
				return;
			}
		}
	} */
	
	if (fm.badcust_chk.value == "Y") {
		dialog.open("<p style='text-align: center; font-size: 14px;'>견적 하시겠습니까?</p>");
	} else {
		EstiReg();
	}
}

//콤마풀기
function uncomma(str) {
    str = String(str);
    return str.replace(/[^\d]+/g, "");
}
  
//견적내기-기본견적시 바로 처리
function EstiRegAuto() {
    var fm = document.form1;
    
    //20160701 일시중지
    <%if (AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) == 20160701) {%>
    	//alert('7월1일 개별소비세 인상으로 견적 준비중입니다. 엑셀견적프로그램을 이용하여 주십시오.');
    	//return;
    <%}%>
        
    var car_price = toInt(parseDigit(fm.o_1.value));
    
<%for (int j=0; j<4; j++) {%>
    	
    if (fm.est_yn[<%=j%>].checked ==true) {
      
<%-- 		if (fm.tint_s_yn[<%=j%>].checked ==true) fm.r_tint_s_yn[<%=j%>].value = 'Y'; --%>
		if (fm.tint_sn_yn[<%=j%>].checked ==true) fm.r_tint_sn_yn[<%=j%>].value = 'Y';
		
		if (fm.tint_ps_yn[<%=j%>].checked ==true) {	
			fm.r_tint_ps_yn[<%=j%>].value = 'Y';		// 고급썬팅
		    fm.r_tint_ps_nm[<%=j%>].value =	 fm.tint_ps_nm[<%=j%>].value;		// 고급썬팅 내용
			fm.r_tint_ps_amt[<%=j%>].value = fm.tint_ps_amt[<%=j%>].value;		// 고급썬팅 추가금액(공급가)
			fm.r_tint_ps_st[<%=j%>].value = fm.setTint_ps_sel[<%=j%>].value;	// 고급썬팅 선택값
		}
		
		if (fm.tint_cons_yn[<%=j%>].checked == true) {	
			fm.r_tint_cons_yn[<%=j%>].value = 'Y';
			fm.r_tint_cons_amt[<%=j%>].value = fm.tint_cons_amt[<%=j%>].value;		// 추가탁송료
		}
		
    	if (fm.tint_n_yn[<%=j%>].checked ==true) fm.r_tint_n_yn[<%=j%>].value = 'Y';
    	if (fm.tint_bn_yn[<%=j%>].checked ==true) fm.r_tint_bn_yn[<%=j%>].value = 'Y';
		if (fm.tint_eb_yn[<%=j%>].checked ==true) fm.r_tint_eb_yn[<%=j%>].value = 'Y';
		
<%-- 		if (fm.tint_s_yn[<%=j%>].checked ==false) fm.r_tint_s_yn[<%=j%>].value = 'N';		// 전면썬팅 체크 해제 시 값 변경 추가 2017.12.27 --%>
		if (fm.tint_sn_yn[<%=j%>].checked ==false) fm.r_tint_sn_yn[<%=j%>].value = 'N';		// 전면썬팅 미시공 할인 체크 해제
		if (fm.tint_ps_yn[<%=j%>].checked ==false) fm.r_tint_ps_yn[<%=j%>].value = 'N';	// 고급썬팅 체크 해제 시 값 변경 추가 2017.12.27
		if (fm.tint_n_yn[<%=j%>].checked ==false) fm.r_tint_n_yn[<%=j%>].value = 'N';		// 거치형 내비게이션 체크 해제 시 값 변경 추가 2017.12.27
		if (fm.tint_cons_yn[<%=j%>].checked ==false) fm.r_tint_cons_yn[<%=j%>].value = 'N';	// 추가탁송료 체크 해제 시 값 변경 추가 2020.06.15
		if (fm.tint_bn_yn[<%=j%>].checked ==false) fm.r_tint_bn_yn[<%=j%>].value = 'N';		// 블랙박스 미제공 할인 (빌트인캠,고객장착..)
		if (fm.tint_eb_yn[<%=j%>].checked ==false) fm.r_tint_eb_yn[<%=j%>].value = 'N';		// 거치형 내비게이션 체크 해제 시 값 변경 추가 2017.12.27
		
    	fm.r_a_a[<%=j%>].value = fm.a_a[<%=j%>].value;
    	fm.r_ins_per[<%=j%>].value = fm.ins_per[<%=j%>].value;
    	fm.r_ins_dj[<%=j%>].value = fm.ins_dj[<%=j%>].value;
    	fm.r_ins_age[<%=j%>].value = fm.ins_age[<%=j%>].value;
    	fm.r_loc_st[<%=j%>].value = fm.loc_st[<%=j%>].value;
    	fm.r_ecar_loc_st[<%=j%>].value = fm.ecar_loc_st[<%=j%>].value;
    	<%-- fm.r_eco_e_tag[<%=j%>].value = fm.eco_e_tag[<%=j%>].value; --%>
    	fm.r_com_emp_yn[<%=j%>].value = fm.com_emp_yn[<%=j%>].value;
    	fm.r_new_license_plate[<%=j%>].value = fm.new_license_plate[<%=j%>].value;
      
<%--       	fm.rg_8[<%=j%>].value     = '25'; --%>
      
//       	if (car_price <= 45000000) {
<%-- 			fm.rg_8[<%=j%>].value     = '20'; --%>
//       	} 

		//전기차는 기본 보증금에서 10% 빼준다
      	/* if (fm.jg_g_7.value == '3') { */
      	if (fm.jg_b.value == '5') {
<%--       		fm.rg_8[<%=j%>].value = toInt(fm.rg_8[<%=j%>].value)-10;      	 --%>
      		//수소차는 기본 보증금에서 15% 빼준다
      	/* else if (fm.jg_g_7.value == '4') { */
      	} else if (fm.jg_b.value == '6') {
<%--       		fm.rg_8[<%=j%>].value     = toInt(fm.rg_8[<%=j%>].value)-15;      	 --%>
      	} else {
			fm.r_tint_eb_yn[<%=j%>].value = 'N';
      	}
      	
     	// 기본보증금 계산식 수정 2021.07.09.
        if(Number($("#car_comp_id option:selected").val()) > 5){ // 수입차
<%--         	if (Number(fm.jg_g_7.value) > 2) 	fm.rg_8[<%=j%>].value = 15;	// 친환경차 구분상 전기/수소차 --%>
<%--         	else 												fm.rg_8[<%=j%>].value = 25; --%>
        	fm.rg_8[<%=j%>].value = 25;
        } else{	// 국산차
<%--         	if (Number(fm.jg_g_7.value) > 2) 	fm.rg_8[<%=j%>].value = 10;	// 친환경차 구분상 전기/수소차 --%>
<%--         	else 												fm.rg_8[<%=j%>].value = 20; --%>
        	fm.rg_8[<%=j%>].value = 20;
        } 
     	// 친환경차 구분상 전기차면서 차량가격 합계 금액이 8천만원 초과 시 +10%, 6500만원 넘으면 +5%, 6500만원 이하면 그대로.
     	// 친환경차 구분상 전기차면서 차량가격 7500만원 이하면 -5%  2022.05.06.
        if (fm.jg_g_7.value == '3') {
        	<%-- if(car_price > 80000000)			fm.rg_8[<%=j%>].value = Number(fm.rg_8[<%=j%>].value) + 10;
    		else if(car_price > 65000000) 	fm.rg_8[<%=j%>].value = Number(fm.rg_8[<%=j%>].value) + 5; --%>
    		if(car_price <= 75000000)	 fm.rg_8[<%=j%>].value = Number(fm.rg_8[<%=j%>].value) - 5;
        }
     	// 수소차면 -5%
     	if(fm.jg_g_7.value == '4'){
     		fm.rg_8[<%=j%>].value = Number(fm.rg_8[<%=j%>].value) - 5;
     	}
                  
      	fm.rg_8_amt[<%=j%>].value   = parseDecimal(car_price * toFloat(fm.rg_8[<%=j%>].value) /100 );
      
      	if (fm.a_a[<%=j%>].value == '22' || fm.a_a[<%=j%>].value == '21') {
        	if (fm.jg_h.value != '1') {
          		alert('렌트운영차량이 아닙니다.');
          		return;
        	} 
        	//24세는 렌트견적안됨
        	if (fm.ins_age[<%=j%>].value == '3') {
          		alert('운전연령 만24세이상은 리스만 가능합니다.');
          		return;
        	}
		} else {
			if (fm.jg_i.value != '1') {
				alert('리스운영차량이 아닙니다.');
          		return;
			}
      	} 
      
      	//자차면책금 점검
      	if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
      		if (parseDigit(fm.car_ja[<%=j%>].value) != '500000') {
      			alert('면책금 금액이 틀렸습니다.'); return;
      		}
      	} else {
      		if (parseDigit(fm.car_ja[<%=j%>].value) == '300000' || parseDigit(fm.car_ja[<%=j%>].value) == '200000' || parseDigit(fm.car_ja[<%=j%>].value) == '100000') {
      		} else {
      			alert('면책금 금액이 틀렸습니다.'); return;
      		}
      	}
    }
<%}%>
    
	if (fm.badcust_chk.value == '') {
		//alert('불량고객 확인을 하십시오.'); 	return;			
		//window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_atype_i.jsp&est_nm='+fm.est_nm.value+'&est_tel='+fm.est_tel.value+'&est_mail='+fm.est_email.value+'&est_fax='+fm.est_fax.value, "BADCUST", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
		//return;
	}
			    
    fm.cmd.value = "i";
    fm.action = 'esti_mng_atype_i_a.jsp';
    fm.target = "i_no";    
    fm.submit();
    
}
    
//불량고객 
function view_badcust()
{
	var fm = document.form1;
    if (fm.est_nm.value == '') {
    	alert('고객/상호명를 입력하십시오');
    	fm.est_nm.focus();
    	return;
    }	
	window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_atype_i.jsp&est_nm='+fm.est_nm.value+'&est_tel='+fm.est_tel.value+'&est_mail='+fm.est_email.value+'&est_fax='+fm.est_fax.value, "BADCUST", "left=10, top=10, width=1400, height=900, resizable=yes, scrollbars=yes, status=yes");
	return;
}	    
  
//출고보전수당 보기
function dlv_con_commi() {
    var fm = document.form1;
    if (fm.code.value == '') {    alert('차명을 선택하십시오');       return; }
    if (fm.car_id.value == '') {    alert('차종을 선택하십시오');       return; }
    if (fm.car_amt.value == '') {     alert('차량가격을 확인하십시오');     return; }   
    
    window.open('about:blank', "DlvConCommi", "left=0, top=0, width=500, height=600, scrollbars=yes, status=yes, resizable=yes");   
    
    fm.target = "DlvConCommi";        
    fm.action = 'view_dlv_con_commi.jsp';   
    fm.submit();  
}

//자체탁송료 조회
function search_cons_cost(){
	var fm = document.form1;
	
	var car_comp_id = $("#car_comp_id option:selected").val();
	
	if (car_comp_id == '') {    alert('제조사를 선택하십시오');       return; }
	if (car_comp_id == '0001' || car_comp_id == '0002') {   
		
		window.open('about:blank', "SearchConsCost", "left=0, top=0, width=800, height=800, scrollbars=yes, status=yes, resizable=yes");		
	
		fm.target = "SearchConsCost";				
		fm.action = 'search_cons_cost.jsp';		
		fm.submit();	
	}
}
  
//영업사원여부 선택시 영업수당 셋팅
function setO11() {
	var fm = document.form1;
  	
    //비교견적일때 - 원견적 조건을 따른다.
    if (fm.cmd.value == 're') {
    	
      	/* if (fm.caroff_emp_yn[1].checked ==true || fm.caroff_emp_yn[2].checked ==true) { */
        //렌트 최대조건이면 렌트/리스 최대
        <%-- if ((<%=e_bean.getA_a()%>==22 || <%=e_bean.getA_a()%>==21) && <%=e_bean.getO_11()%>==fm.jg_f.value) {
         
          <%for (int j=0; j<4; j++) {%>
	          if (fm.est_yn[<%=j%>].checked ==true) {	              
	          	if (<%=j%> == 0) {fm.o_11[<%=j%>].value     = <%=e_bean.getO_11()%>;}
	          	if (<%=j%> == 1) {fm.o_11[<%=j%>].value     = <%=e_bean2.getO_11()%>;}
	          	if (<%=j%> == 2) {fm.o_11[<%=j%>].value     = <%=e_bean3.getO_11()%>;}
	          	if (<%=j%> == 3) {fm.o_11[<%=j%>].value     = <%=e_bean4.getO_11()%>;}	            		            	            
	          }
	        <%}%>
        //리스 최대조건이면 렌트/리스 최대  
        } else if ((<%=e_bean.getA_a()%>==12 || <%=e_bean.getA_a()%>==11) && <%=e_bean.getO_11()%>==fm.jg_g.value) {
          
          <%for (int j=0; j<4; j++) {%>
	          if (fm.est_yn[<%=j%>].checked ==true) {	              
	          	if (<%=j%> == 0) {fm.o_11[<%=j%>].value     = <%=e_bean.getO_11()%>;}
	          	if (<%=j%> == 1) {fm.o_11[<%=j%>].value     = <%=e_bean2.getO_11()%>;}
	          	if (<%=j%> == 2) {fm.o_11[<%=j%>].value     = <%=e_bean3.getO_11()%>;}
	          	if (<%=j%> == 3) {fm.o_11[<%=j%>].value     = <%=e_bean4.getO_11()%>;}	            		            	            
	          }
	        <%}%>
        //최대조건이 아니면 원견적 조건 그대로 간다.                            
        } else {
                	  
        	  <%for (int j=0; j<4; j++) {%>
	            if (fm.est_yn[<%=j%>].checked ==true) {	              
	            	if (<%=j%> == 0) {fm.o_11[<%=j%>].value     = <%=e_bean.getO_11()%>;}
	            	if (<%=j%> == 1) {fm.o_11[<%=j%>].value     = <%=e_bean2.getO_11()%>;}
	            	if (<%=j%> == 2) {fm.o_11[<%=j%>].value     = <%=e_bean3.getO_11()%>;}
	            	if (<%=j%> == 3) {fm.o_11[<%=j%>].value     = <%=e_bean4.getO_11()%>;}	            		            	            
	            }
	          <%}%>
        } --%>
        
      <%-- } else {
        <%for (int j=0; j<4; j++) {%>
            fm.o_11[<%=j%>].value     = 0.0;            
        <%}%>             
      } --%>
      
		//수입차 렌트견적시에는 본사결재1 -4%
		if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
	   	<%for (int j = 0; j < 4; j++) {%>
			fm.fee_dc_per[<%=j%>].value = <%=e_bean.getFee_dc_per()%>;
			
			if (fm.a_a[<%=j%>].value == '22') {//렌트
				fm.ins_per[<%=j%>].options[0].selected = true;
			} else if (fm.a_a[<%=j%>].value == '11' || fm.a_a[<%=j%>].value == '21') {//일반식불가
				alert('수입차는 일반식 견적이 안됩니다.');              
			 	fm.est_yn[<%=j%>].checked = false
				fm.ins_per[<%=j%>].options[0].selected = true;              
			} else {
			  	<%-- fm.ins_per[<%=j%>].options[1].selected = true; --%>
				fm.ins_per[<%=j%>].options[0].selected = true;
			}
			fm.car_ja[<%=j%>].value     = '500,000';
		<%}%>
		}
      
    //신규견적일때
    } else {
		//수입차 렌트견적시에는 본사결재1 -4%
		if (toInt(parseDigit(fm.car_comp_id.value)) > 5) {
        <%for (int j = 0; j < 4; j++) {%>
			if (fm.a_a[<%=j%>].value == '22') {//렌트
              	fm.ins_per[<%=j%>].options[0].selected = true;
            } else if (fm.a_a[<%=j%>].value == '11' || fm.a_a[<%=j%>].value == '21') {//일반식불가
              	alert('수입차는 일반식 견적이 안됩니다.');              
              	fm.est_yn[<%=j%>].checked = false
              	fm.ins_per[<%=j%>].options[0].selected = true;
              
            } else {
              	<%-- fm.ins_per[<%=j%>].options[1].selected = true; --%>
              	fm.ins_per[<%=j%>].options[0].selected = true;
            }
            fm.car_ja[<%=j%>].value     = '500,000';
		<%}%>
		} else {
        <%for (int j=0; j<4; j++) {%>
            fm.car_ja[<%=j%>].value     = '300,000';
        <%}%>       
      	}
   	}
}
  
  
//인쇄방식
function setEst_yn(print_type) {
	  
	//상품별, 견적별종합, 전기차 인수 반납 선택형 에서만 복사버튼 노출되게
    if (print_type==1 || print_type==5 || print_type==6) {
    	$("#btn_copy2, #btn_copy3, #btn_copy4").css("display","");
    } else {
    	$("#btn_copy2, #btn_copy3, #btn_copy4").css("display","none");
    }
	
    var fm = document.form1;
    var jg_g_7 = fm.jg_g_7.value;
    
    //인쇄방식 set value
    $('input:radio[name="print_type"][value="'+print_type+'"]').prop('checked', true);
    
    if (print_type == 6) {
    	
    	tr_ecar_return.style.display = "";

    	ro_13_1_display_1.style.display = "none";
    	ro_13_1_display_2.style.display = "";
    	
    	fm.print_type[0].disabled = true;
		fm.print_type[1].disabled = true;
		fm.print_type[2].disabled = true;
		fm.print_type[3].disabled = true;
		fm.print_type[4].disabled = true;
		fm.print_type[5].disabled = false;

		fm.return_select[0].disabled = true;
		fm.return_select[1].disabled = true;

		fm.a_a[0].options[0].disabled = true;
		fm.a_a[0].options[1].disabled = false;
		fm.a_a[0].options[2].disabled = true;
		fm.a_a[0].options[3].disabled = false;
		fm.a_a[0].options[4].disabled = true;
		
		fm.a_a[1].options[0].disabled = true;
		fm.a_a[1].options[1].disabled = false;
		fm.a_a[1].options[2].disabled = true;
		fm.a_a[1].options[3].disabled = false;
		fm.a_a[1].options[4].disabled = true;

		fm.opt_chk[0].disabled = true;
		fm.opt_chk[1].disabled = true;		
		fm.opt_chk[2].disabled = true;
		fm.opt_chk[3].disabled = true;
    	
		//대여기간
		$("#sel_a_b_2").attr("disabled", true); 
		$("#a_b_2").attr("disabled", true);
		//적용약정운행거리
		$("#sel_agree_dist_2").attr("disabled", true);
		$("#agree_dist_2").attr("disabled", true);
		//보증금
		$("#sel_rg_8_2").attr("disabled", true);
		$("#rg_8_2").attr("disabled", true);
		$("#rg_8_amt_2").attr("disabled", true);
		//선납금
		$("#pp_per_2").attr("disabled", true);
		$("#pp_amt_2").attr("disabled", true);
		//개시대여료
		$("#g_10_2").attr("disabled", true);
		//보증보험
		$("#gi_per_2").attr("disabled", true);
		$("#gi_amt_2").attr("disabled", true);
		//영업수당
		$("#sel_o_11_2").attr("disabled", true);
		$("#o_11_2").attr("disabled", true);
		//대여료DC
		$("#fee_dc_per_2").attr("disabled", true);
		
    } else {		
    	
    	tr_ecar_return.style.display = "none";

    	ro_13_0_display_1.style.display = "";
    	ro_13_0_display_2.style.display = "none";

    	ro_13_1_display_1.style.display = "";
    	ro_13_1_display_2.style.display = "none";

    	ro_13_2_display_1.style.display = "";
    	ro_13_2_display_2.style.display = "none";

    	ro_13_3_display_1.style.display = "";
    	ro_13_3_display_2.style.display = "none";
    	
    	fm.print_type[0].disabled = false;
		fm.print_type[1].disabled = false;
		fm.print_type[2].disabled = false;
		fm.print_type[3].disabled = false;
		fm.print_type[4].disabled = false;
		fm.print_type[5].disabled = true;

		fm.return_select[0].disabled = false;
		fm.return_select[1].disabled = false;

		for (var i = 0; i <= 3; i++) {
			
			//매입옵션 비활성화 일괄 처리
			fm.opt_chk[i].disabled = false;
			
			//대여상품 비활성화 해제 일괄처리
			for (var j = 0; j <= 4; j++) {
				fm.a_a[i].options[j].disabled = false;
			}
			
			//매입옵션
			for (var z = 0; z <= 1; z++) {
				fm.opt_chk[i].options[z].disabled = false;
			}
		}
    	
		//대여기간
		var car_comp_id = $("#car_comp_id option:selected").val();
		/* if (car_comp_id == "0056") {
			$("#sel_a_b_2").attr("disabled", true); 
			$("#a_b_2").attr("readonly", true);
		} else {
			$("#sel_a_b_2").attr("disabled", false); 
			$("#a_b_2").attr("readonly", false);
		} */
		$("#sel_a_b_2").attr("disabled", false); 
		$("#a_b_2").attr("disabled", false);
		
		//적용약정운행거리
		/* if (car_comp_id == "0056") {
			$("#sel_agree_dist_2").attr("disabled", true);
			$("#agree_dist_2").attr("readonly", true);	
		} else {
			$("#sel_agree_dist_2").attr("disabled", false);
			$("#agree_dist_2").attr("readonly", false);
		} */
		$("#sel_agree_dist_2").attr("disabled", false);
		$("#agree_dist_2").attr("disabled", false);
		
		//보증금
		$("#sel_rg_8_2").attr("disabled", false);
		$("#rg_8_2").attr("disabled", false);
		$("#rg_8_amt_2").attr("disabled", false);
		//선납금
		$("#pp_per_2").attr("disabled", false);
		$("#pp_amt_2").attr("disabled", false);
		//개시대여료
		$("#g_10_2").attr("disabled", false);
		//보증보험
		$("#gi_per_2").attr("disabled", true);
		$("#gi_amt_2").attr("disabled", true);
		//영업수당
		$("#sel_o_11_2").attr("disabled", false);
		$("#o_11_2").attr("disabled", false);
		//대여료DC
		$("#fee_dc_per_2").attr("disabled", false);
		
    }
    
    if (fm.car_id.value == '') {  alert('차종을 선택하십시오');     return; }
    if (fm.car_amt.value == '') {   alert('차량금액을 확인하십시오');   return; }     
    
    if (print_type == 1 || print_type == 5 || print_type==6) {
      fm.a_a[0].disabled = false;
      fm.a_a[1].disabled = false;
      fm.a_a[2].disabled = false;
      fm.a_a[3].disabled = false;
    } else {
      fm.a_a[0].disabled = true;
      fm.a_a[1].disabled = true;
      fm.a_a[2].disabled = true;
      fm.a_a[3].disabled = true;
    }
    
    //테슬라 readonly
    /* if (car_comp_id == "0056") {    	
	    fm.a_b[0].readOnly = true;
	    fm.a_b[1].readOnly = true;
	    fm.a_b[2].readOnly = true;
	    fm.a_b[3].readOnly = true;
    } else {    	
	    fm.a_b[0].readOnly = false;   // readonly 해제
	    fm.a_b[1].readOnly = false;   // readonly 해제
	    fm.a_b[2].readOnly = false;   // readonly 해제
	    fm.a_b[3].readOnly = false;   // readonly 해제
    } */
    
    /* fm.a_b[0].readOnly = false;   // readonly 해제
    fm.a_b[1].readOnly = false;   // readonly 해제
    fm.a_b[2].readOnly = false;   // readonly 해제
    fm.a_b[3].readOnly = false;   // readonly 해제 */
    
    //상품별
    if (print_type == 1 || print_type == 5) {
		var car_comp_id = $("#car_comp_id option:selected").val();
      	var jg_code = fm.jg_code.value;
      	var jgG7 = fm.jg_g_7.value;
      	
  		fm.est_yn[0].checked = true;
   		fm.est_yn[1].checked = false;
   		fm.est_yn[2].checked = false;
   		fm.est_yn[3].checked = false;
   		fm.a_a[1].value = '';
   		fm.a_a[2].value = '';
   		fm.a_a[3].value = ''; 
   		SelectA_a(0);
   		setO11();
      
      	if (jgG7 == "3" || jgG7 == "4") {
   		  	if (jg_code == "5866" || jg_code == "6316111") {
   			  	searchO13(0);
   		  	}
      	} else {
    	  	searchO13(0);
      	}
      
    //인수반납선택형
    } else if (print_type==6) {
      	fm.est_yn[0].checked = true;
   	  	fm.est_yn[1].checked = true;
   	  <%if (e_bean3.getReturn_select().equals("")) {%>
		      fm.est_yn[2].checked = false;
   	  <%} else {%>
   			  fm.est_yn[2].checked = true;
   	  <%}%>
   	  
   	  <%if (e_bean4.getReturn_select().equals("")) {%>
   			  fm.est_yn[3].checked = false;
   	  <%} else {%>
   			  fm.est_yn[3].checked = true;
   	  <%}%>
   	  
   	  <%if (e_bean2.getA_a().equals("")) {%>
   			  fm.a_a[1].value = '';
	  <%}%>
	  
// 	  	if (Number($("#car_comp_id option:selected").val()) <= 5) {
// 		  	fm.rg_8[0].value = '20';
// 	  	} else {
// 		  	fm.rg_8[0].value = '25';
// 	  	}
	  
//       	fm.rg_8[0].value = toInt(fm.rg_8[0].value)-10;
      	
     	// 기본보증금 계산식 수정 2021.07.09.
        if(Number($("#car_comp_id option:selected").val()) > 5){ // 수입차
//         	if (Number(fm.jg_g_7.value) > 2) 	fm.rg_8[0].value = 15;	// 친환경차 구분상 전기/수소차
//         	else 												fm.rg_8[0].value = 25;
        	fm.rg_8[0].value = 25;
        } else{	// 국산차
//         	if (Number(fm.jg_g_7.value) > 2) 	fm.rg_8[0].value = 10;	// 친환경차 구분상 전기/수소차
//         	else 												fm.rg_8[0].value = 20;
        	fm.rg_8[0].value = 20;
        } 
        	
     	// 친환경차 구분상 전기차면서 차량가격 합계 금액이 8천만원 초과 시 +10%, 6500만원 넘으면 +5%, 6500만원 이하면 그대로.
     	// 전기차면서 차량가격 7500 이하면 -5%
        if (fm.jg_g_7.value == '3'){
//         	if(car_price > 80000000)			fm.rg_8[0].value = Number(fm.rg_8[0].value) + 10;
//     		else if(car_price > 65000000) 	fm.rg_8[0].value = Number(fm.rg_8[0].value) + 5;
        	if(car_price <= 75000000)			fm.rg_8[0].value = Number(fm.rg_8[0].value) - 5;
        }
     	// 수소차면 -5%
     	if(fm.jg_g_7.value == '4'){
     		fm.rg_8[0].value = Number(fm.rg_8[0].value) - 5;
     	}
      	$("#sel_rg_8_"+1+" option[value='"+fm.rg_8[0].value+"']").prop("selected",true);
      
      	//fm.a_a[2].value = '';
      	//fm.a_a[3].value = ''; 
      	SelectA_a(0);
      	return_type(2);
      	return_type(3);
      	//setO11(); 
      
      	//searchO13(0);
	  	//searchO13(1);
      
    //렌트
   	} /* else if (print_type == 2) {
		fm.est_yn[0].checked = true;
		fm.est_yn[1].checked = true;
		fm.est_yn[2].checked = false;
		fm.est_yn[3].checked = false;
		fm.a_a[0].value = '22';
		fm.a_a[1].value = '21';
		fm.a_a[2].value = '';
		fm.a_a[3].value = ''; 
		document.querySelector('#ins_age_1 option[value="3"]').style.display = 'none';
		document.querySelector('#ins_age_2 option[value="3"]').style.display = 'none';
		document.querySelector('#ins_age_3 option[value="3"]').style.display = 'none';
		document.querySelector('#ins_age_4 option[value="3"]').style.display = 'none';
		SelectA_a(0);
		SelectA_a(1);
		setO11();
		searchO13(0);
		searchO13(1);
		
    //리스
    } else if (print_type == 3) {
		fm.est_yn[0].checked = true;
		fm.est_yn[1].checked = true;
		fm.est_yn[2].checked = false;
		fm.est_yn[3].checked = false;   
		fm.a_a[0].value = '12';
		fm.a_a[1].value = '11';     
		fm.a_a[2].value = '';
		fm.a_a[3].value = '';
		SelectA_a(0);
		SelectA_a(1);
		setO11();   
		searchO13(0);
		searchO13(1);       
    //종합
    } else if (print_type == 4) {
		fm.est_yn[0].checked = true;
		fm.est_yn[1].checked = true;
		fm.est_yn[2].checked = true;
		fm.est_yn[3].checked = true;    
		fm.a_a[0].value = '22';
		fm.a_a[1].value = '21';
		fm.a_a[2].value = '12';
		fm.a_a[3].value = '11';
		SelectA_a(0);
		SelectA_a(1);
		SelectA_a(2);
		SelectA_a(3);
		setO11();   
		searchO13(0); 
		searchO13(1);
		searchO13(2);
		searchO13(3);
    } */
    
    // 렌트, 리스, 종합 견적
    if( print_type == 2 || print_type == 3 || print_type == 4 ){
    	
    	if(print_type == 2){ // 렌트
      		fm.est_yn[0].checked = true;
    		fm.est_yn[1].checked = true;
    		fm.est_yn[2].checked = false;
    		fm.est_yn[3].checked = false;
    		fm.a_a[0].value = '22';
    		fm.a_a[1].value = '21';
    		fm.a_a[2].value = '';
    		fm.a_a[3].value = ''; 
    		SelectA_a(0);
    		SelectA_a(1);
    		setO11();
    		searchO13(0);
    		searchO13(1);
    		
    		// 렌트 견적 시 일부 항목 미노출
    		var targets = document.querySelectorAll('.esti_target');
    		for(var i = 0; i < targets.length; i++){
    			var target = targets[i];
//     			target.style.opacity = 0;
    			target.style.display = 'none';
    		}
    		var targets2 = document.querySelectorAll('.esti_target2');
    		for(var i = 0; i < targets2.length; i++){
    			var target = targets2[i];
//     			target.style.opacity = 0;
    			target.style.display = 'none';
    		}
    		var targets3 = document.querySelectorAll('.esti_target3');
    		for(var i = 0; i < targets3.length; i++){
    			var target = targets3[i];
    			target.style.display = 'none';
    		}
    		
    		// 견적1과 조건 동일 문구 노출
			document.getElementById('equal_condition2').style.display= 'table-cell';
			document.getElementById('equal_condition3').style.display= 'none';
			document.getElementById('equal_condition4').style.display= 'none';
			
			// 견적 3, 4 숨김
			document.getElementById('rent-lease-target3').style.display= 'table-cell';
			document.getElementById('rent-lease-target4').style.display= 'table-cell';
			
      	} else if(print_type == 3){ // 리스
      		fm.est_yn[0].checked = true;
    		fm.est_yn[1].checked = true;
    		fm.est_yn[2].checked = false;
    		fm.est_yn[3].checked = false; 
    		fm.a_a[0].value = '12';
    		fm.a_a[1].value = '11';     
    		fm.a_a[2].value = '';
    		fm.a_a[3].value = '';
    		SelectA_a(0);
    		SelectA_a(1);
    		setO11();
    		searchO13(0);
    		searchO13(1); 
    		
    		// 리스 견적 시 일부 항목 미노출
    		var targets = document.querySelectorAll('.esti_target');
    		for(var i = 0; i < targets.length; i++){
    			var target = targets[i];
//     			target.style.opacity = 0;
    			target.style.display = 'none';
    		}
    		var targets2 = document.querySelectorAll('.esti_target2');
    		for(var i = 0; i < targets2.length; i++){
    			var target = targets2[i];
//     			target.style.opacity = 0;
    			target.style.display = 'none';
    		}
    		var targets3 = document.querySelectorAll('.esti_target3');
    		for(var i = 0; i < targets3.length; i++){
    			var target = targets3[i];
    			target.style.display = 'none';
    		}
    		
    		// 견적1과 조건 동일 문구 노출
			document.getElementById('equal_condition2').style.display= 'table-cell';
			document.getElementById('equal_condition3').style.display= 'none';
			document.getElementById('equal_condition4').style.display= 'none';
			
			// 견적 3, 4 숨김
			document.getElementById('rent-lease-target3').style.display= 'table-cell';
			document.getElementById('rent-lease-target4').style.display= 'table-cell';
			
      	} else if(print_type == 4){ // 종합
      		fm.est_yn[0].checked = true;
    		fm.est_yn[1].checked = true;
    		fm.est_yn[2].checked = true;
    		fm.est_yn[3].checked = true;   
    		fm.a_a[0].value = '22';
    		fm.a_a[1].value = '21';
    		fm.a_a[2].value = '12';
    		fm.a_a[3].value = '11';
    		SelectA_a(0);
    		SelectA_a(1);
    		SelectA_a(2);
    		SelectA_a(3);
    		setO11();
    		searchO13(0); 
    		searchO13(1);
    		searchO13(2);
    		searchO13(3);
    		var targets = document.querySelectorAll('.esti_target');
    		for(var i = 0; i < targets.length; i++){
    			var target = targets[i];
//     			target.style.opacity = 1.0;
    			target.style.display = 'table-cell';
    		}
    		var targets2 = document.querySelectorAll('.esti_target2');
    		for(var i = 0; i < targets2.length; i++){
    			var target = targets2[i];
//     			target.style.opacity = 0;
    			target.style.display = 'none';
    		}
    		var targets3 = document.querySelectorAll('.esti_target3');
    		for(var i = 0; i < targets3.length; i++){
    			var target = targets3[i];
    			target.style.display = 'none';
    		}
    		
    		// 견적1과 조건 동일 문구 노출
    		document.getElementById('equal_condition2').style.display= 'table-cell';
			document.getElementById('equal_condition3').style.display= 'table-cell';
			document.getElementById('equal_condition4').style.display= 'table-cell';
			
			// 견적 3, 4 숨김 항목 미노출
			document.getElementById('rent-lease-target3').style.display= 'none';
			document.getElementById('rent-lease-target4').style.display= 'none';
      	}
    	
    	// 대여상품 disabled 처리
        fm.a_a[0].disabled = true;
        fm.a_a[1].disabled = true;
        fm.a_a[2].disabled = true;
        fm.a_a[3].disabled = true;
        
	    // 매입옵션 항목 비활성화
		fm.opt_chk[0].disabled = true;
		fm.opt_chk[1].disabled = true;
		fm.opt_chk[2].disabled = true;
		fm.opt_chk[3].disabled = true;
		
		// 렌트, 리스, 종합 견적 시 견적2, 3, 4 노출항목 비활성화
		for(var i=1; i<4; i++){
			fm.sel_a_b[i].disabled = true;				// 대여기간
			fm.a_b[i].disabled = true;					// 대여기간
			fm.b_agree_dist[i].disabled = true;		// 표준 약정운행거리
			fm.sel_agree_dist[i].disabled = true;	// 적용 약정운행거리
			fm.agree_dist[i].disabled = true;			// 적용약정운행거리
			fm.b_o_13[i].disabled = true;				// 표준 최대잔가
			fm.o_13[i].disabled = true;					// 조정 최대잔가
			fm.ro_13[i].disabled = true;				// 적용잔가
			fm.ro_13_amt[i].disabled = true;			// 적용잔가
		}
    } else {
    	var targets = document.querySelectorAll('.esti_target');
		for(var i = 0; i < targets.length; i++){
			var target = targets[i];
// 			target.style.opacity = 1.0;
			target.style.display = 'table-cell';
		}
		var targets2 = document.querySelectorAll('.esti_target2');
		for(var i = 0; i < targets2.length; i++){
			var target = targets2[i];
// 			target.style.opacity = 1.0;
			target.style.display = 'table-cell';
		}
		var targets3 = document.querySelectorAll('.esti_target3');
		for(var i = 0; i < targets3.length; i++){
			var target = targets3[i];
			target.style.display = 'table-cell';
		}
		document.getElementById('equal_condition2').style.display= 'none';
		document.getElementById('equal_condition3').style.display= 'none';
		document.getElementById('equal_condition4').style.display= 'none';
		
		// 견적 3, 4 숨김 항목 미노출
		document.getElementById('rent-lease-target3').style.display= 'none';
		document.getElementById('rent-lease-target4').style.display= 'none';
		
		// 매입옵션 항목 비활성화 해제
		fm.opt_chk[0].disabled = false;
		fm.opt_chk[1].disabled = false;
		fm.opt_chk[2].disabled = false;
		fm.opt_chk[3].disabled = false;
		
		// 렌트, 리스, 종합 외 견적 시 견적2, 3, 4 노출항목 비활성화 해제
		for(var i=1; i<4; i++){
			fm.sel_a_b[i].disabled = false;
			fm.a_b[i].disabled = false;
			fm.b_agree_dist[i].disabled = false;
			fm.sel_agree_dist[i].disabled = false;
			fm.agree_dist[i].disabled = false;
			fm.b_o_13[i].disabled = false;
			fm.o_13[i].disabled = false;
			fm.ro_13[i].disabled = false;
			fm.ro_13_amt[i].disabled = false;
		}
    }
    
    // 견적별종합
    // 구분 렌트, 리스, 종합 선택 시 견적별종합과 양식 통합
    if (print_type == 5 || print_type == 2 || print_type == 3 || print_type == 4) {
   	<%for (int j=1; j<4; j++) {%>
		fm.ins_per[<%=j%>].disabled = true;
		fm.ins_dj[<%=j%>].disabled = true;
		fm.ins_age[<%=j%>].disabled = true;
		fm.car_ja[<%=j%>].readOnly = true;
<%--       	fm.tint_s_yn[<%=j%>].disabled = true; --%>
      	fm.tint_sn_yn[<%=j%>].disabled = true;
      	fm.tint_ps_yn[<%=j%>].disabled = true;		// 고급썬팅
      	fm.tint_ps_nm[<%=j%>].disabled = true;
      	fm.tint_ps_amt[<%=j%>].disabled = true;
      	fm.tint_ps_st[<%=j%>].disabled = true;
      	fm.tint_n_yn[<%=j%>].disabled = true;
      	fm.tint_bn_yn[<%=j%>].disabled = true;
		fm.new_license_plate[<%=j%>].disabled = true;
		fm.tint_cons_yn[<%=j%>].disabled = true;
		fm.tint_cons_amt[<%=j%>].disabled = true;
      	fm.tint_eb_yn[<%=j%>].disabled = true;
      	fm.loc_st[<%=j%>].disabled = true;
      	fm.ecar_loc_st[<%=j%>].disabled = true;
      	<%-- fm.eco_e_tag[<%=j%>].disabled = true; --%>
      	fm.com_emp_yn[<%=j%>].disabled = true;
      	fm.car_ja[<%=j%>].style.backgroundColor = 'e5e5e5';
      	fm.setTint_ps_sel[<%=j%>].disabled = true;
   	<%}%>
    //전기차
    } else if (print_type == 6) {
   	<%for (int j=1; j<4; j++) {%>
		fm.ins_per[<%=j%>].disabled = true;
		fm.ins_dj[<%=j%>].disabled = true;
		fm.ins_age[<%=j%>].disabled = true;
		fm.car_ja[<%=j%>].readOnly = true;
<%-- 		fm.tint_s_yn[<%=j%>].disabled = true; --%>
		fm.tint_sn_yn[<%=j%>].disabled = true;
		fm.tint_ps_yn[<%=j%>].disabled = true;		// 고급썬팅
		fm.tint_ps_nm[<%=j%>].disabled = true;
		fm.tint_ps_amt[<%=j%>].disabled = true;
		fm.tint_ps_st[<%=j%>].disabled = true;
		fm.tint_n_yn[<%=j%>].disabled = true;
		fm.tint_bn_yn[<%=j%>].disabled = true;
		fm.new_license_plate[<%=j%>].disabled = true;
		fm.tint_cons_yn[<%=j%>].disabled = true;
		fm.tint_cons_amt[<%=j%>].disabled = true;
		fm.tint_eb_yn[<%=j%>].disabled = true;
		fm.loc_st[<%=j%>].disabled = true;
		fm.ecar_loc_st[<%=j%>].disabled = true;
		<%-- fm.eco_e_tag[<%=j%>].disabled = true; --%>
		fm.com_emp_yn[<%=j%>].disabled = true;
		fm.car_ja[<%=j%>].style.backgroundColor = 'e5e5e5';
		fm.setTint_ps_sel[<%=j%>].disabled = true;
	<%}%>
    } else {
		var carCompId = $("#car_comp_id option:selected").val();
    	
   	<%for (int j=1; j<4; j++) {%>
   		fm.ins_per[<%=j%>].disabled = false;
   		fm.ins_dj[<%=j%>].disabled = false;
   		fm.ins_age[<%=j%>].disabled = false;
   		fm.car_ja[<%=j%>].readOnly = false;
<%--       	fm.tint_s_yn[<%=j%>].disabled = false; --%>
      	fm.tint_sn_yn[<%=j%>].disabled = false;
      	fm.tint_ps_yn[<%=j%>].disabled = false;		// 고급썬팅
      	fm.tint_ps_nm[<%=j%>].disabled = false;
      	fm.tint_ps_amt[<%=j%>].disabled = false;
      	fm.tint_ps_st[<%=j%>].disabled = false;
      	fm.tint_n_yn[<%=j%>].disabled = false;
      	fm.tint_bn_yn[<%=j%>].disabled = false;
		fm.new_license_plate[<%=j%>].disabled = false;
		fm.tint_cons_yn[<%=j%>].disabled = false;
		fm.tint_cons_amt[<%=j%>].disabled = false;
      	fm.tint_eb_yn[<%=j%>].disabled = false;
      	if (carCompId == "0056") {
      		fm.loc_st[<%=j%>].disabled = true;
      	} else {
	      	fm.loc_st[<%=j%>].disabled = false;
      	}
      	fm.ecar_loc_st[<%=j%>].disabled = false;
      	<%-- fm.eco_e_tag[<%=j%>].disabled = false; --%>
      	fm.com_emp_yn[<%=j%>].disabled = false;
      	fm.car_ja[<%=j%>].style.backgroundColor = 'white';
   	<%}%>
    }
    
<%for (int j=0; j<4; j++) {%>
   	fm.r_a_a[<%=j%>].value = fm.a_a[<%=j%>].value;
<%--    	fm.r_tint_s_yn[<%=j%>].value = fm.tint_s_yn[<%=j%>].value; --%>
   	fm.r_tint_sn_yn[<%=j%>].value = fm.tint_sn_yn[<%=j%>].value;
   	fm.r_tint_ps_yn[<%=j%>].value = fm.tint_ps_yn[<%=j%>].value;		// 고급썬팅
   	fm.r_tint_ps_nm[<%=j%>].value = fm.tint_ps_nm[<%=j%>].value;
   	fm.r_tint_ps_amt[<%=j%>].value = fm.tint_ps_amt[<%=j%>].value;
   	fm.r_tint_ps_st[<%=j%>].value = fm.setTint_ps_sel[<%=j%>].value;
   	fm.r_new_license_plate[<%=j%>].value = fm.new_license_plate[<%=j%>].value;
   	fm.r_tint_cons_yn[<%=j%>].value = fm.tint_cons_yn[<%=j%>].value;
   	fm.r_tint_cons_amt[<%=j%>].value = fm.tint_cons_amt[<%=j%>].value;
   	fm.r_tint_n_yn[<%=j%>].value = fm.tint_n_yn[<%=j%>].value;
   	fm.r_tint_bn_yn[<%=j%>].value = fm.tint_bn_yn[<%=j%>].value;
	fm.r_tint_cons_yn[<%=j%>].value = fm.tint_cons_yn[<%=j%>].value;
   	fm.r_tint_cons_amt[<%=j%>].value = fm.tint_cons_amt[<%=j%>].value;
   	fm.r_tint_eb_yn[<%=j%>].value = fm.tint_eb_yn[<%=j%>].value;
   	fm.r_ins_per[<%=j%>].value = fm.ins_per[<%=j%>].value;
   	fm.r_ins_dj[<%=j%>].value = fm.ins_dj[<%=j%>].value;
   	fm.r_ins_age[<%=j%>].value = fm.ins_age[<%=j%>].value;
   	fm.r_loc_st[<%=j%>].value = fm.loc_st[<%=j%>].value;
   	fm.r_ecar_loc_st[<%=j%>].value = fm.ecar_loc_st[<%=j%>].value;
   	<%-- fm.r_eco_e_tag[<%=j%>].value = fm.eco_e_tag[<%=j%>].value; --%>
   	fm.r_com_emp_yn[<%=j%>].value = fm.com_emp_yn[<%=j%>].value;
<%}%>    

}

//법인임직원전용보험 가입여부
function SetComEmpYn() {
	var fm = document.form1;
	
	var doc_type_value = $('input:radio[name="doc_type"]:checked').val();
	
	//특판출고 상시표기_20201217
	/* if (doc_type_value != "1") {
		$("#doc_type_check_div").hide();
		//$('input:checkbox[name="dir_pur_commi_yn"]').attr("checked", "checked");
		$('input:checkbox[name="dir_pur_commi_yn"]').removeAttr("checked");
	} else {
		$("#doc_type_check_div").show();
	} */
	
	var com_emp_yn_html = "";
	
	if (doc_type_value == "1") {
		com_emp_yn_html = "<option value='N'>미가입</option>"+
									"<option value='Y' selected>가입</option>";
				
		$("#com_emp_yn_1").html(com_emp_yn_html);
		$("#com_emp_yn_2").html(com_emp_yn_html);
		$("#com_emp_yn_3").html(com_emp_yn_html);
		$("#com_emp_yn_4").html(com_emp_yn_html);
		
	} else if (doc_type_value == "2") {
		com_emp_yn_html = "<option value='' selected>선택</option>"+
									"<option value='N'>미가입</option>"+
									"<option value='Y'>가입</option>";
									
		$("#com_emp_yn_1").html(com_emp_yn_html);
		$("#com_emp_yn_2").html(com_emp_yn_html);
		$("#com_emp_yn_3").html(com_emp_yn_html);
		$("#com_emp_yn_4").html(com_emp_yn_html);
	} else {
		com_emp_yn_html = "<option value='N' selected>미가입</option>"+
									"<option value='Y'>가입</option>";
					
		$("#com_emp_yn_1").html(com_emp_yn_html);
		$("#com_emp_yn_2").html(com_emp_yn_html);
		$("#com_emp_yn_3").html(com_emp_yn_html);
		$("#com_emp_yn_4").html(com_emp_yn_html);
	}
	
	// 임직원 한정운전특약 노출 조건 기존 차종코드 기준에서 차종소분류코드 기준으로 수정 2021.12.20.
// 	if ((toInt(fm.jg_code.value) > 1999 && toInt(fm.jg_code.value) < 7000) || (toInt(fm.jg_code.value) > 1999999 && toInt(fm.jg_code.value) < 7000000)) {
	var s_st_value = fm.s_st.value;
	if(toInt(s_st_value) > 101 && toInt(s_st_value) < 600 && toInt(s_st_value) != 409){	
		if (doc_type_value == "1" || doc_type_value == "2") {
		//if (fm.doc_type[0].checked == true) {
			
			//보이게_법인일때는 기존대로, 개인사업자일경우 초기값 변경
			tr_com_emp_yn.style.display = "";
			
			if (doc_type_value == "2") {
				fm.com_emp_yn[0].value = "";
				fm.com_emp_yn[1].value = "";
				fm.com_emp_yn[2].value = "";
				fm.com_emp_yn[3].value = "";
			} else {
				fm.com_emp_yn[0].value = "Y";
				fm.com_emp_yn[1].value = "Y";
				fm.com_emp_yn[2].value = "Y";
				fm.com_emp_yn[3].value = "Y";
			}
			
		} else {
			//안보이게
			tr_com_emp_yn.style.display='none';
			fm.com_emp_yn[0].value = "N";
			fm.com_emp_yn[1].value = "N";
			fm.com_emp_yn[2].value = "N";
			fm.com_emp_yn[3].value = "N";
		}
	} else {
		//안보이게
		tr_com_emp_yn.style.display='none';
		fm.com_emp_yn[0].value = "N";
		fm.com_emp_yn[1].value = "N";
		fm.com_emp_yn[2].value = "N";
		fm.com_emp_yn[3].value = "N";
	}
}

//사양보기 버튼(2018.01.18)
function view_spec() {
	var car_comp_id = $("#car_comp_id option:selected").val();
	var code = $("#code option:selected").val();
	var car_id = $("#car_id").val();
	var car_seq = $("#car_seq").val();
	var valus = "?car_comp_id="+car_comp_id+"&code="+code+"&car_id="+car_id+"&car_seq="+car_seq;
	if (code=="") { alert("차명을 선택하십시오.");	$("#code").focus();		return false;	}
	window.open("esti_mng_view_opt.jsp"+valus,"car_b_inc", "left=300, top=100, width=1000, height=900, scrollbars=yes");
}

//대여기간 콤보박스 세팅(2018.03.12)
function setA_b(num,val) {
	if (val=="36") {					$("#a_b_"+num).val("36");	}
	else if (val=="48") {				$("#a_b_"+num).val("48");	}
	else if (val=="60") {				$("#a_b_"+num).val("60");	}
	else if (val=="24") {				$("#a_b_"+num).val("24");	}
	else if (val=="directInput") {	$("#a_b_"+num).val("");		$("#a_b_"+num).focus();		}
} 

//적용 약정운행거리 콤보박스 세팅(2018.03.12)
function setAgree_dist(num,val) {
	if (val==10000) {					$("#agree_dist_"+num).val("10,000");	}
	else if (val==15000) {			$("#agree_dist_"+num).val("15,000");	}
	else if (val==20000) {			$("#agree_dist_"+num).val("20,000");	}
	else if (val==23000) {			$("#agree_dist_"+num).val("23,000");	}
	else if (val==25000) {			$("#agree_dist_"+num).val("25,000");	}
	else if (val==28000) {			$("#agree_dist_"+num).val("28,000");	}
	else if (val==30000) {			$("#agree_dist_"+num).val("30,000");	}
	else if (val==35000) {			$("#agree_dist_"+num).val("35,000");	}
	else if (val==40000) {			$("#agree_dist_"+num).val("40,000");	}
	else if (val==45000) {			$("#agree_dist_"+num).val("45,000");	}
	else if (val==50000) {			$("#agree_dist_"+num).val("50,000");	}
	else if (val=="directInput") {	$("#agree_dist_"+num).val("");		$("#agree_dist_"+num).focus();	}
}

//보증금 콤보박스 세팅(2018.03.12)
function setRg_8(num,val) {
	if (val==0) {						$("#rg_8_"+num).val("0.0");		}
	else if (val==10) {				$("#rg_8_"+num).val("10.0");	}
	else if (val==15) {				$("#rg_8_"+num).val("15.0");	}
	else if (val==20) {				$("#rg_8_"+num).val("20.0");	}
	else if (val==25) {				$("#rg_8_"+num).val("25.0");	}
	else if (val==30) {				$("#rg_8_"+num).val("30.0");	}
	else if (val==35) {				$("#rg_8_"+num).val("35.0");	}
	else if (val==40) {				$("#rg_8_"+num).val("40.0");	}
	else if (val==50) {				$("#rg_8_"+num).val("50.0");	}
	else if (val=="directInput") {	$("#rg_8_"+num).val("");	$("#rg_8_"+num).focus();	}
	
	var fm = document.form1;
	fm.rg_8_amt[num-1].value  = parseDecimal( getCutRoundNumber(toInt(parseDigit(fm.o_1.value)) * toFloat(fm.rg_8[num-1].value) / 100, 1000 ));
    if (fm.a_a[num-1].value == '11' || fm.a_a[num-1].value == '12') {
      	if (fm.ls_yn.value == 'Y') {
        	fm.rg_8_amt[num-1].value = parseDecimal( getCutRoundNumber(toInt(parseDigit(fm.o_12.value)) * toFloat(fm.rg_8[num-1].value) / 100, 1000 ));
      	}
    }
}

//영업수당 콤보박스 세팅(2018.03.12)
function setO_11(num,val) {
	if (val==0) {						$("#o_11_"+num).val("0.0");	}
	else if (val==1) {				$("#o_11_"+num).val("1.0");	}
	else if (val==2) {				$("#o_11_"+num).val("2.0");	}
	else if (val==3) {				$("#o_11_"+num).val("3.0");	}
	else if (val=="directInput") {	$("#o_11_"+num).val("");	$("#o_11_"+num).focus();	}
}

//반올림
function getCutRoundNumber(num, n) {
	var remove_price = num / n;   
    remove_price = Math.round(remove_price); 
    remove_price = remove_price * n;
    return remove_price;
}

//전기차 고객주소지 변경에 따른 차량인도지역 셋팅
function setLoc_st(num, val) {
	
	/* if ($("#car_comp_id option:selected").val() == "0056") {
		document.form1.loc_st[num].value='1';
	} else { */
	document.form1.loc_st[num].value=toInt(val)+1;
	if (val == '7') document.form1.loc_st[num].value='4';
	if (val == '8') document.form1.loc_st[num].value='6';
	if (val == '9') document.form1.loc_st[num].value='7';
	if (val == '10') document.form1.loc_st[num].value='5';
	if (val == '11') document.form1.loc_st[num].value='2';	// 전기차고객주소지 경기 선택 시 차량인도지역 인천/경기 2021.02.24. 
	if (val == '12') LocStSet();	// 전기차 고객주소지 전지역(국고보조금限지원 견적) 선택 시 차량인도지역은 본인 지점을 디폴트 값으로. 2021.11.02. 
	if (val == '13') LocStSet();	// 전기차 고객주소지 보조금 없는 견적 선택 시 차량인도지역은 본인 지점을 디폴트 값으로. 2021.12.13. 
	/* } */
}

//용품-고급썬팅 셀렉트박스 셋팅
function setTint_ps(num, val) {
	if (val=="I") {	$("#tint_ps_span"+num).html(" 견적서표기내용 &nbsp;");	}
	else {			$("#tint_ps_span"+num).html(" FMS표기(참고용)");	}
}

//견적1 기본세팅값 복사하기(2018.05.30)
function copy_esti_1(num) {
	
	var fm = document.form1;	  
    var jg_g_7 = fm.jg_g_7.value;
    var jg_b = fm.jg_b.value;
    var jg_code = fm.jg_code.value;
    var car_comp_id = $("#car_comp_id option:selected").val();
	
	var print_type = $('input:radio[name="print_type"]:checked').val();
	
	$("#est_yn_"		+num).prop("checked", true);//견적 체크
	
	var return_select_val = $("#return_select_0 option:selected").val();
	
	
	$("#a_a_"+num+" option[value='"+ $("#a_a_1 option:selected").val() +"']").prop("selected", true);//대여상품
	$('#a_a_'+num+' option[value=""]').prop('disabled', false);
	$('#a_a_'+num+' option[value="22"]').prop('disabled', false);
	$('#a_a_'+num+' option[value="21"]').prop('disabled', false);
	$('#a_a_'+num+' option[value="12"]').prop('disabled', false);
	$('#a_a_'+num+' option[value="11"]').prop('disabled', false);
		
	
	
	
	$("#sel_a_b_"	+num+" option[value='"+ $("#sel_a_b_1 	option:selected").val() +"']").prop("selected", true);//대여기간 콤보박스
	$("#a_b_"+num).val($("#a_b_1").val());//대여기간
	$("#b_agree_dist_"	+num).val($("#b_agree_dist_1").val());//표준약정운행거리
	$("#sel_agree_dist_"+num+" option[value='"+ $("#sel_agree_dist_1	option:selected").val() +"']").prop("selected", true);//적용약정운행거리 콤보박스
	$("#agree_dist_"	+num).val($("#agree_dist_1"	).val());//적용약정운행거리
	$("#b_o_13_"		+num).val($("#b_o_13_1"		).val());//표준최대잔가
	$("#o_13_"			+num).val($("#o_13_1"		).val());//조정최대잔가
	$("#ro_13_"			+num).val($("#ro_13_1"		).val());//적용잔가(%)
	$("#ro_13_amt_"		+num).val($("#ro_13_amt_1"	).val());//적용잔가(원)
	$("#sel_rg_8_"		+num+" option[value='"+ $("#sel_rg_8_1 	option:selected").val() +"']").prop("selected", true);//보증금 콤보박스
	$("#rg_8_"			+num).val($("#rg_8_1"		).val());	//보증금(%)
	$("#rg_8_amt_"		+num).val($("#rg_8_amt_1"	).val());	//보증금(원)
	$("#pp_per_"		+num).val($("#pp_per_1"		).val());	//선납금(%)
	$("#pp_amt_"		+num).val($("#pp_amt_1"		).val());	//선납금(원)
	$("#g_10_"			+num).val($("#g_10_1"		).val());	//개시대여료
	$("#com_emp_yn_"	+num+" option[value='"+ $("#com_emp_yn_1 option:selected").val() +"']").prop("selected", true);	//법인임직원 한정운전특약 콤보박스
	
	if (print_type!=5) {
		//보험
		$("#ins_per_"		+num+" option[value='"+ $("#ins_per_1 	option:selected").val() +"']").prop("selected", true);	//피보험자 콤보박스
		$("#ins_dj_"		+num+" option[value='"+ $("#ins_dj_1 	option:selected").val() +"']").prop("selected", true);	//대물/자손 콤보박스
		$("#ins_age_"		+num+" option[value='"+ $("#ins_age_1 	option:selected").val() +"']").prop("selected", true);	//운전자연령 콤보박스
		$("#car_ja"		+(num-1)).val($("#car_ja0"		).val());	//자차면책금
		$("#gi_per_"		+num).val($("#gi_per_1"		).val());	//보증보험(%)
		$("#gi_amt_"		+num).val($("#gi_amt_1"		).val());	//보증보험(원)
		//용품
		$("#new_license_plate_"		+num+" option[value='"+ $("#new_license_plate_1 	option:selected").val() +"']").prop("selected", true);	
// 		if ($("#tint_s_yn_1"	).is(":checked")==true) {$("#tint_s_yn_" +num).prop("checked",true);	} else {$("#tint_s_yn_" +num).prop("checked",false);}	//전면썬팅
		if ($("#tint_ps_yn_1").is(":checked")==true) {$("#tint_ps_yn_"+num).prop("checked",true);	} else {$("#tint_ps_yn_"+num).prop("checked",false);}	//고급썬팅
		if ($("#tint_n_yn_1"	).is(":checked")==true) {$("#tint_n_yn_" +num).prop("checked",true);	} else {$("#tint_n_yn_" +num).prop("checked",false);}	//거치형네비게이션
		if ($("#tint_sn_yn_1"	).is(":checked")==true) {$("#tint_sn_yn_" +num).prop("checked",true);	} else {$("#tint_sn_yn_" +num).prop("checked",false);}	//전면썬팅 미시공 할인
		if ($("#tint_bn_yn_1"	).is(":checked")==true) {$("#tint_bn_yn_" +num).prop("checked",true);	} else {$("#tint_bn_yn_" +num).prop("checked",false);}	//블랙박스 미제공 할인 (빌트인캠,고객장착..)
		if ($("#tint_cons_yn_1"	).is(":checked")==true) {$("#tint_cons_yn_" +num).prop("checked",true);	} else {$("#tint_cons_yn_" +num).prop("checked",false);}	//추가탁송료
		$("#tint_cons_amt_"	+num).val($("#tint_cons_amt_1").val());	//추가탁송료
		if ($("#tint_eb_yn_1").is(":checked")==true) {$("#tint_eb_yn_"+num).prop("checked",true);	} else {$("#tint_eb_yn_"+num).prop("checked",false);}	//이동형충전기(전기차)
		$("#setTint_ps_sel_"+num+" option[value='"+ $("#setTint_ps_sel_1 option:selected").val() +"']").prop("selected", true);	//고급썬팅 콤보박스
		$("#tint_ps_nm_"	+num).val($("#tint_ps_nm_1"	).val());	//고급썬팅 견적서 표기내용
		$("#tint_ps_amt_"	+num).val($("#tint_ps_amt_1").val());	//고급썬팅 추가금액(공급가)
		if ($("#setTint_ps_sel_1 option:selected").val()=='I') {	setTint_ps(num-1, 'I');	} else {	setTint_ps(num-1, '');	}	//고급썬팅 표기선택시 문구
		//차량인도지역
		$("#loc_st_"		+num+" option[value='"+ $("#loc_st_1 	option:selected").val() +"']").prop("selected", true);	//차량인도지역 콤보박스
		//전기차일때-전기차고객주소지
		if (form1.jg_g_7.value == '3') {	
			$("#ecar_loc_st_"+num+" option[value='"+ $("#ecar_loc_st_1 option:selected").val() +"']").prop("selected", true);	//전기차 고객주소지 콤보박스
		}
		//수소차일때-수소차고객주소지
		if (form1.jg_g_7.value == '4') {	
			$("#hcar_loc_st_"+num+" option[value='"+ $("#hcar_loc_st_1 option:selected").val() +"']").prop("selected", true);	//수소차 고객주소지 콤보박스
		}
	}
	
	//if (form1.jg_b.value == '5' || form1.jg_b.value == '6') {	//엔진이 전기차 수소차일때
	//	$("#eco_e_tag_"	 +num+" option[value='"+ $("#eco_e_tag_1   option:selected").val() +"']").prop("selected", true);	//맑은 서울스티커 발급 콤보박스
	//}
	
	$("#sel_o_11_"		+num+" option[value='"+ $("#sel_o_11_1 	option:selected").val() +"']").prop("selected", true);	//영업수당 콤보박스
	$("#o_11_"			+num).val($("#o_11_1"		).val());	//영업수당(%)
	$("#fee_dc_per_"	+num).val($("#fee_dc_per_1"	).val());	//대여료D/C
	
}

// 신규_전기차일경우 견적2,3,4의 공통 disable 데이터 견적1과 동일하게 변경
function set_disable_value() {
	
	var fm = document.form1;
    var jg_g_7 = fm.jg_g_7.value;
    var jg_code = fm.jg_code.value;
    var car_comp_id = $("#car_comp_id option:selected").val();
	
	var print_type = $('input:radio[name="print_type"]:checked').val();
		
	
	
}

//신규_전기차 인수반납 선책형 및 반납형 견적일 경우 2번 견적은 1번 선택 옵션을 따라간다.
function set_return2_change() {
	
	var fm = document.form1;
    var jg_g_7 = fm.jg_g_7.value;
    var jg_code = fm.jg_code.value;
    var car_comp_id = $("#car_comp_id option:selected").val();
    
    
	
}

//신규_전기차 인수반납 선책형 및 반납형 견적일 경우 1번견적 최대잔가율 조회시 2번견적또한 같이 조회
function set_time() {
	var fm = document.form1;
    var jg_g_7 = fm.jg_g_7.value;
    var jg_code = fm.jg_code.value;
    var car_comp_id = $("#car_comp_id option:selected").val();
    
    
}

//신규_견적3
function eh_chk(idx) {
	
	var check3_stat = $("#est_yn_3").is(":checked");
	var check4_stat = $("#est_yn_4").is(":checked");
	
	if (idx == "3") {		
		if (check4_stat == true) {
			alert("견적4번이 있는경우 견적3을 해제할 수 없습니다.");
			$("#est_yn_"+idx).prop("checked", true);
			return;
		}
	} else if (idx == "4") {
		if (check3_stat == false) {
			alert("견적3을 먼저 선택한 후 견적4를 선택해 주세요.");
			$("#est_yn_"+idx).prop("checked", false);
			return;
		}
	}
}

//신규_수입차 출고 - 자체출고 및 영업사원출고(자체출고 견적외)
function release_type() {
	var release_val = $(":input:radio[name=import_pur_st]:checked").val();	
	if (release_val == "1") {
		$("#import_content_2").show();
	} else {
		$("#import_content_2").hide();
		//자체출고 선택시 아래 입력값 초기화
		$("#r_dc_amt").val("");
		$("#l_dc_amt").val("");
		
		$("#r_card_amt").val("");
		$("#l_card_amt").val("");
		
		$("#r_cash_back").val("");
		$("#l_cash_back").val("");
		
		$("#r_bank_amt").val("");
		$("#l_bank_amt").val("");
	}
}

//신규_특판출고 체크시 영업수당 0% 초기화 및 변경
function dir_pur_change() {
	var dir_pur_commi_yn = $('input:checkbox[name="dir_pur_commi_yn"]:checked').val();
	
	if (dir_pur_commi_yn == "Y") {
		alert("특판출고 선택시 영업수당은 0%로 고정됩니다.");
		
		$("#sel_o_11_1 option[value='0']").prop("selected", true);
		$("#o_11_1").val("0.0");
		
		$("#sel_o_11_2 option[value='0']").prop("selected", true);
		$("#o_11_2").val("0.0");
		
		$("#sel_o_11_3 option[value='0']").prop("selected", true);
		$("#o_11_3").val("0.0");
		
		$("#sel_o_11_4 option[value='0']").prop("selected", true);
		$("#o_11_4").val("0.0");
	}
}

function set_other_esti_value(tag){
	var fm = document.form1;
	var print_type = fm.print_type.value;
	
	// 렌트, 리스, 종합 견적 시에만 해당.
	if( !(print_type == 2 || print_type == 3 || print_type == 4 ) ) return;
	
	var name = tag.name;
	
	if( name.includes('a_b') ){	// 대여기간
		
		var index = fm.sel_a_b[0].selectedIndex;
		var sel_a_b_list = fm.sel_a_b;
		var a_b_list = fm.a_b;
		
		for(var i=1; i<4; i++){
			sel_a_b_list[i].options[index].selected = true;
			a_b_list[i].value = a_b_list[0].value;
		}
		
	} else if( name.includes('agree_dist') ){	// 적용 약정운행거리
		
		var index = fm.sel_agree_dist[0].selectedIndex;
		var sel_agree_dist_list = fm.sel_agree_dist;
		var agree_dist_list = fm.agree_dist;
		
		for(var i=1; i<4; i++){
			sel_agree_dist_list[i].options[index].selected = true;
			agree_dist_list[i].value = agree_dist_list[0].value;
		}
		
	} else if( name.includes('rg_8') ){	// 보증금
		
		var index = fm.sel_rg_8[0].selectedIndex;
		var sel_rg_8_list = fm.sel_rg_8;
		var rg_8_list = fm.rg_8;
		var rg_8_amt_list = fm.rg_8_amt;
		
		for(var i=1; i<4; i++){
			sel_rg_8_list[i].options[index].selected = true;
			rg_8_list[i].value = rg_8_list[0].value;
			rg_8_amt_list[i].value = rg_8_amt_list[0].value;
		}
	
	} else if( name.includes('pp') ){	// 선납금
		var pp_per = fm.pp_per;
		var pp_amt = fm.pp_amt;
		
		for(var i=1; i<4; i++){
			pp_per[i].value = pp_per[0].value;
			pp_amt[i].value = pp_amt[0].value;
		}
		
	} else if( name == 'g_10' ){	// 개시대여료
		var g_10 = fm.g_10;
		
		for(var i=1; i<4; i++){
			g_10[i].value = g_10[0].value;
		}
	
	} else if( name == 'fee_dc_per' ){	// 대여료 D/C
		var fee_dc_per = fm.fee_dc_per;
	
		for(var i=1; i<4; i++){
			fee_dc_per[i].value = fee_dc_per[0].value;
		}
	} else if( name == 'ecar_loc_st' ){ // 전기차 고객주소지
		var ecar_loc_st = fm.ecar_loc_st;
	
		for(var i=1; i<4; i++){
			ecar_loc_st[i].value = ecar_loc_st[0].value;
		}
	} else if( name == 'hcar_loc_st' ){ // 수소차 고객주소지
		var hcar_loc_st = fm.hcar_loc_st;
		
		for(var i=1; i<4; i++){
			hcar_loc_st[i].value = hcar_loc_st[0].value;
		}
	}
}

function view_car_bbs(){
	var fm = document.form1;
	var car_comp_id = $("#car_comp_id option:selected").val();
	if (car_comp_id == '') {    alert('제조사를 선택하십시오');       return; }
	window.open('about:blank', "ViewCarBbs", "left=0, top=0, width=800, height=800, scrollbars=yes, status=yes, resizable=yes");		
	fm.target = "ViewCarBbs";				
	fm.action = 'view_car_bbs.jsp';		
	fm.submit();	
}	

//-->
</script>
</head>
<body onload="javascript:document.form1.est_nm.focus();">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<form action="/acar/estimate_mng/get_carcd_null.jsp" name="form2" method="post">
	    <input type="hidden" name="sel" value="">
	    <input type="hidden" name="car_comp_id" value="">
	    <input type="hidden" name="code" value="">
	    <input type="hidden" name="mode" value="">
	    <input type="hidden" name="rent_way" value="">  
	    <input type="hidden" name="a_a" value="">   
  	</form>
  	
	<form action='/acar/estimate_mng/get_o13_20110101.jsp' name="sh_form" method='post'>
		<input type='hidden' name="car_id"      value="">    
		<input type='hidden' name="car_seq"     value="">    
		<input type='hidden' name="car_amt"     value="">  
		<input type='hidden' name="opt_amt"     value="">  
		<input type='hidden' name="opt_amt_m" value="">  
		<input type='hidden' name="col_amt"     value="">      
		<input type='hidden' name="dc_amt"      value="">      
		<input type='hidden' name="o_1"     value="">          
		<input type='hidden' name="a_a"     value="">
		<input type='hidden' name="a_b"     value="">  
		<input type='hidden' name="esti_type"     value="a">    
		<input type='hidden' name="idx"     value="0">      
		<input type='hidden' name="print_type"    value="1">      
		<input type='hidden' name="agree_dist"    value="">      
		<input type='hidden' name="jg_opt_st"     value="">      
		<input type='hidden' name="jg_col_st"     value="">      
		<input type='hidden' name="ecar_loc_st"   value="">     
		<input type='hidden' name="hcar_loc_st"   value="">     
		<!-- <input type='hidden' name="eco_e_tag"   value=""> -->   
		<input type='hidden' name="rent_dt"   value="">
		<input type='hidden' name="rtn_run_amt_yn"   value="">
		
	</form>
	
  	<form action="./esti_mng_atype_i_a.jsp" name="form1" method="POST">
	    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	    <input type="hidden" name="br_id" value="<%=br_id%>">
	    <input type="hidden" name="user_id" value="<%=user_id%>">
	    <input type="hidden" name="gubun1" value="<%=gubun1%>">
	    <input type="hidden" name="gubun2" value="<%=gubun2%>">
	    <input type="hidden" name="gubun3" value="<%=gubun3%>">
	    <input type="hidden" name="gubun4" value="<%=gubun4%>">
		<input type="hidden" name="gubun5" value="<%=gubun5%>">
		<input type="hidden" name="gubun6" value="<%=gubun6%>">  
	    <input type="hidden" name="s_dt" value="<%=s_dt%>">
	    <input type="hidden" name="e_dt" value="<%=e_dt%>">
	    <input type="hidden" name="s_kd" value="<%=s_kd%>">
	    <input type="hidden" name="t_wd" value="<%=t_wd%>">
	    <input type="hidden" name="est_id" value="<%=est_id%>"> 
	    <input type="hidden" name="cmd" value="<%=cmd%>">
	    <input type="hidden" name="s_st" value="">
	    <input type="hidden" name="a_e" value="">
		<input type="hidden" name="ls_yn" value="">
		<input type="hidden" name="dc_amt2" value="">
		<input type="hidden" name="o_12" value="">
		<input type="hidden" name="ecar_pur_sub_amt" value="<%=ecar_pur_sub_amt_val%>">
		<input type="hidden" name="jg_f" value="<%=jg_f%>">
		<input type="hidden" name="jg_g" value="<%=jg_g%>">
		<input type="hidden" name="jg_w" value="<%=jg_w%>">
		<input type="hidden" name="jg_h" value="<%=jg_h%>">
		<input type="hidden" name="jg_i" value="<%=jg_i%>">
		<input type="hidden" name="jg_b" value="<%=jg_b%>">
		<input type="hidden" name="jg_g_7" value="<%=ej_bean.getJg_g_7()%>">
  
		<%for (int j=0; j<4; j++) {%>
		<input type="hidden" name="r_a_a" value="">
		<input type="hidden" name="r_tint_s_yn" value="">
		<input type="hidden" name="r_tint_sn_yn" value="">
		<input type="hidden" name="r_tint_ps_yn" value="">
		<input type="hidden" name="r_tint_ps_nm" value="">
		<input type="hidden" name="r_tint_ps_amt" value="">
		<input type="hidden" name="r_tint_ps_st" value="">
		<input type="hidden" name="r_tint_n_yn" value="">
		<input type="hidden" name="r_tint_bn_yn" value="">
		<input type="hidden" name="r_new_license_plate" value="">
		<input type="hidden" name="r_tint_cons_yn" value="">
		<input type="hidden" name="r_tint_cons_amt" value="">
		<input type="hidden" name="r_ins_per" value="">
		<input type="hidden" name="r_ins_dj" value="">
		<input type="hidden" name="r_ins_age" value="">
		<input type="hidden" name="r_loc_st" value="">
		<input type="hidden" name="r_ecar_loc_st" value="">
		<input type="hidden" name="r_hcar_loc_st" value="">
		<!-- <input type="hidden" name="r_eco_e_tag" value=""> -->
		<input type="hidden" name="r_com_emp_yn" value="">
		<input type="hidden" name="r_tint_eb_yn" value="">
		<input type="hidden" name="tint_ps_st" value="">	
		<%}%>
	
		<input type="hidden" name="jg_opt_st" value="<%=e_bean.getJg_opt_st()%>">
		<input type="hidden" name="jg_col_st" value="<%=e_bean.getJg_col_st()%>">
		<input type="hidden" name="jg_code" value="<%=ej_bean.getSh_code()%>">
		<input type="hidden" name="search_o13_yn" value="">
    
		<%-- <input type="hidden" name="jg_tuix_st" value="<%=e_bean.getJg_tuix_st()%>"> --%>
		<%-- <input type="hidden" name="lkas_yn" value="<%=e_bean.getLkas_yn()%>"> --%>
		<%-- <input type="hidden" name="ldws_yn" value="<%=e_bean.getLdws_yn()%>"> --%>
		<%-- <input type="hidden" name="aeb_yn" value="<%=e_bean.getAeb_yn()%>"> --%>
		<%-- <input type="hidden" name="fcw_yn" value="<%=e_bean.getFcw_yn()%>"> --%>
		<input type="hidden" name="jg_tuix_st" value="<%if (e_bean.getJg_tuix_st().equals("")) {%><%=cm_bean2.getJg_tuix_st()%><%} else {%><%=e_bean.getJg_tuix_st()%><%}%>">
		<input type="hidden" name="jg_tuix_opt_st" value="<%=e_bean.getJg_tuix_opt_st()%>">
		<input type="hidden" name="lkas_yn" value="<%if (e_bean.getLkas_yn().equals("")) {%><%=cm_bean2.getLkas_yn()%><%} else {%><%=e_bean.getLkas_yn()%><%}%>">
		<input type="hidden" name="lkas_yn_opt_st" value="<%=e_bean.getLkas_yn_opt_st()%>">
		<input type="hidden" name="ldws_yn" value="<%if (e_bean.getLdws_yn().equals("")) {%><%=cm_bean2.getLdws_yn()%><%} else {%><%=e_bean.getLdws_yn()%><%}%>">
		<input type="hidden" name="ldws_yn_opt_st" value="<%=e_bean.getLdws_yn_opt_st()%>">
		<input type="hidden" name="aeb_yn" value="<%if (e_bean.getAeb_yn().equals("")) {%><%=cm_bean2.getAeb_yn()%><%} else {%><%=e_bean.getAeb_yn()%><%}%>">
		<input type="hidden" name="aeb_yn_opt_st" value="<%=e_bean.getAeb_yn_opt_st()%>">
		<input type="hidden" name="fcw_yn" value="<%if (e_bean.getFcw_yn().equals("")) {%><%=cm_bean2.getFcw_yn()%><%} else {%><%=e_bean.getFcw_yn()%><%}%>">
		<input type="hidden" name="fcw_yn_opt_st" value="<%=e_bean.getFcw_yn_opt_st()%>">
		<input type="hidden" name="garnish_yn" value="">				<!-- 가니쉬 여부 -->
		<input type="hidden" name="garnish_yn_opt_st" value="<%if (e_bean.getGarnish_yn().equals("")) {%><%=cm_bean2.getGarnish_yn()%><%} else {%><%=e_bean.getGarnish_yn()%><%}%>">	<!-- 가니쉬 여부(옵션) -->
		<input type="hidden" name="hook_yn" value="">				<!-- 견인고리 여부 -->
		<input type="hidden" name="hook_yn_opt_st" value="<%if (e_bean.getHook_yn().equals("")) {%><%=cm_bean2.getHook_yn()%><%} else {%><%=e_bean.getHook_yn()%><%}%>">	<!-- 견인고리 여부(옵션) -->
		
		<input type='hidden' name='badcust_chk_from' value='esti_mng_atype_i.jsp'>
		
		<input type='hidden' name='duty_free_opt' value='<%if (!est_id.equals("")) {%><%=cm_bean2.getDuty_free_opt()%><%}%>'>
		<input type="hidden" name="jg_g_15" value="<%=ej_bean.getJg_g_15()%>">     
  
    <tr>
      	<td colspan=2>
          	<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 견적관리 > <span class=style5>신차다중견적내기</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
      	</td>
    </tr>
    <tr>
        <td class=h colspan=2></td>
    </tr>
    <%if (!spe_car_nm.equals("")) {%>   
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>스마트견적</span> <b>[희망차종] : <font color=green><%=spe_car_nm%></font></b></td>
    </tr>
    <tr>
        <td class=h colspan=2></td>
    </tr>
    <%}%>    
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span> <a href="javascript:search_cust()" onMouseOver="window.status=''; return true" title="고객조회하기. 클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a>
    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <font color=red>※ 불량고객 확인하기</font>
        	&nbsp;&nbsp;&nbsp;        	
        	<input type="button" class="button" id="bad_cust" value='고객확인' onclick="javascript:view_badcust();">
        	<input name="badcust_chk" type="text" class="text"  readonly value="" size="1">        	
        </td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan=2> 
            <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=25%>상호 또는 성명</td>
                    <td class=title width=25%>호칭 또는 담당자이름+호칭</td>
                    <td rowspan='2' width=50%>
                    	&nbsp;* 상호 또는 성명란에는 사업자면 상호만을, 개인이면 성명만을 적습니다.<br>
                    	&nbsp;&nbsp;&nbsp;&nbsp; 단, (주) 또는 주식회사는 기재하여도 됩니다.
                    </td>
                </tr>            
                <tr> 
                    <td align='center'> 
                        <input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="25" maxlength='50' class=text onKeyDown='javascript:enter()' style='IME-MODE: active'>
                    </td>
                    <td align='center'> 
                        <input type="text" name="mgr_nm" value="<%=e_bean.getMgr_nm()%>" size="25" class=text>&nbsp;님 귀하
                    </td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr>
        <td class=h colspan=2></td>
    </tr>       
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=15%>사업자등록번호</td>
                    <td width=35%>
                        &nbsp;
                        <input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" class=text>
                    </td>
                    <td class=title width=10%>이메일주소</td>
                    <td colspan="3">
                    	&nbsp;
                    	<input type="text" name="est_email" value="<%=e_bean.getEst_email()%>" size="50" class=text style='IME-MODE: inactive'>                
					</td>
                </tr>
                <tr>
                    <td class=title>전화번호</td>
                    <td>
                        &nbsp;
                        <input type="text" name="est_tel" value="<%=e_bean.getEst_tel()%>" size="15" class=text>
                    </td>
                    <td class=title>FAX</td>
                    <td colspan="3">
                        &nbsp;
                        <input type="text" name="est_fax" value="<%=e_bean.getEst_fax()%>" size="15" class=text>
                    </td>
                </tr>             
                <tr>
                    <td class=title>고객구분</td>
                    <td colspan="5">
                      	<div style="float: left;">
                      		&nbsp;
                      		<input type="radio" id="doc_type_1" name="doc_type" value="1" onClick="javascript:SetComEmpYn()" <% if (e_bean.getDoc_type().equals("1")||e_bean.getDoc_type().equals("")) out.print("checked"); %>>
                      		<label for="doc_type_1">법인고객</label>
                      		&nbsp;
	            			<input type="radio" id="doc_type_2" name="doc_type" value="2" onClick="javascript:SetComEmpYn()" <% if (e_bean.getDoc_type().equals("2")) out.print("checked"); %>>
		            		<label for="doc_type_2">개인사업자</label>
		            		&nbsp;
	            			<input type="radio" id="doc_type_3" name="doc_type" value="3" onClick="javascript:SetComEmpYn()" <% if (e_bean.getDoc_type().equals("3")) out.print("checked"); %>>
		            		<label for="doc_type_3">개인&nbsp;(고객구분에 따라 견적서에 필요서류를 표기합니다.)</label>
                      	</div>
	           		  	<%-- <div style="float: left; <%if (e_bean.getDoc_type().equals("2") || e_bean.getDoc_type().equals("3")) {%>display: none;<%}%>" id="doc_type_check_div"> --%>
	           		  	<div style="float: left;" id="doc_type_check_div">
							&nbsp;&nbsp;&nbsp;
	           		  		<input type="checkbox" id="dir_pur_commi_yn" name="dir_pur_commi_yn" value="Y" onclick="javascript:dir_pur_change()" <% if (e_bean.getDir_pur_commi_yn().equals("Y")) out.print("checked"); %>>
	           		  		<label for="dir_pur_commi_yn">특판출고(실적이관가능)</label>
	           		  	</div>
                    </td>
                </tr>
                <tr>
                    <td class=title>신용도</td>
                    <td>
                    	&nbsp;
                    	<input type="radio" id="spr_yn_2" name="spr_yn" value="2" <% if (e_bean.getSpr_yn().equals("2")||e_bean.getSpr_yn().equals("")) out.print("checked"); %>>
                    	<label for="spr_yn_2">초우량기업</label>
                    	&nbsp;
			            <input type="radio" id="spr_yn_1" name="spr_yn" value="1" <% if (e_bean.getSpr_yn().equals("1")) out.print("checked"); %>>
			            <label for="spr_yn_1">우량기업</label>
			            &nbsp; 
			            <input type="radio" id="spr_yn_0" name="spr_yn" value="0" <% if (e_bean.getSpr_yn().equals("0")) out.print("checked"); %>>
			            <label for="spr_yn_0">일반기업</label>
			            &nbsp;
			            <input type="radio" id="spr_yn_3" name="spr_yn" value="3" <% if (e_bean.getSpr_yn().equals("3")) out.print("checked"); %>>
						<label for="spr_yn_3">신설법인</label>
					</td>
                    <td width=10% class=title>영업구분</td>
                    <td width=10%>
                    	&nbsp;
                    	<select name="bus_st">
	                        <option value="">선택</option>                        
	                        <option value="1" <%if (e_bean.getBus_st().equals("1")) {%>selected<%}%>>인터넷</option>
	                        <option value="8" <%if (e_bean.getBus_st().equals("8")) {%>selected<%}%>>모바일</option>
	                        <option value="5" <%if (e_bean.getBus_st().equals("5")) {%>selected<%}%>>전화상담</option>
	                        <option value="2" <%if (e_bean.getBus_st().equals("2")) {%>selected<%}%>>영업사원</option>
	                        <option value="7" <%if (e_bean.getBus_st().equals("7")) {%>selected<%}%>>에이젼트</option>
	                        <option value="6" <%if (e_bean.getBus_st().equals("6")) {%>selected<%}%>>기존업체</option>
	                        <option value="3" <%if (e_bean.getBus_st().equals("3")) {%>selected<%}%>>업체소개</option>
	                        <option value="4" <%if (e_bean.getBus_st().equals("4")) {%>selected<%}%>>catalog</option>
                      	</select>
					</td>
                    <td width=10% class=title>비용비교</td>
                    <td width=10%>
                    	&nbsp;
                    	<input type="radio" id="compare_n" name="compare_yn" value="N" <% if (e_bean.getCompare_yn().equals("N")||e_bean.getCompare_yn().equals("")) out.print("checked"); %>>
                    	<label for="compare_n">없음</label>
                    	&nbsp;
            			<input type="radio" id="compare_y" name="compare_yn" value="Y" <% if (e_bean.getCompare_yn().equals("Y")) out.print("checked"); %>>
            			<label for="compare_y">있음</label> 
					</td>
                </tr>
                <tr>
                    <td class=title>견적유효기간</td>
                    <td colspan="5">
                    	&nbsp;
                    	<input type="radio" id="vali_type_0" name="vali_type" value="0" <% if (e_bean.getVali_type().equals("0")||e_bean.getVali_type().equals("")) out.print("checked"); %>>
                    	<label for="vali_type_0">날짜만표기(10일/당월, 기본 10일이나 10일전 익월로 넘어갈 경우에는 당월말 까지로 한다.)</label>
            			&nbsp;
            			<input type="radio" id="vali_type_1" name="vali_type" value="1" <% if (e_bean.getVali_type().equals("1")) out.print("checked"); %>>
            			<label for="vali_type_1">메이커D/C 변경 가능성 언급(10일)</label> 
            			&nbsp;
            			<input type="radio" id="vali_type_2" name="vali_type" value="2" <% if (e_bean.getVali_type().equals("2")) out.print("checked"); %>>
            			<label for="vali_type_2">미확정견적</label> 
                    </td>                	
                </tr>
                <tr>
                    <td class=title>초기납입금안내문구</td>
                    <td colspan="3">
                    	&nbsp;
                    	<input type="radio" id="pp_ment_yn_y" name="pp_ment_yn" value="Y" <%if (e_bean.getPp_ment_yn().equals("Y"))out.print("checked");%>>
                    	<label for="pp_ment_yn_y">표기(초기납입금은 고객님의 신용도에 따라 심사과정에서 조정될 수 있습니다.)</label>
                      	&nbsp;
                      	<input type="radio" id="pp_ment_yn_n" name="pp_ment_yn" value="N" <% if (e_bean.getPp_ment_yn().equals("N")||e_bean.getPp_ment_yn().equals("")) out.print("checked");%>>
                      	<label for="pp_ment_yn_n">미표기</label>
					</td>
					<td class=title>보증보험료산출 등급</td>
                	<td>
                		&nbsp;
                		<select name="gi_grade" id="gi_grade">
                			<option value="" <%if (e_bean.getGi_grade().equals("")) {%>selected<%}%>>보험료미표기</option>
                			<option value="1" <%if (e_bean.getGi_grade().equals("1")) {%>selected<%}%>>1등급</option>
                			<option value="2" <%if (e_bean.getGi_grade().equals("2")) {%>selected<%}%>>2등급</option>
                			<option value="3" <%if (e_bean.getGi_grade().equals("3")) {%>selected<%}%>>3등급</option>
                			<option value="4" <%if (e_bean.getGi_grade().equals("4")) {%>selected<%}%>>4등급</option>
                			<option value="5" <%if (e_bean.getGi_grade().equals("5")) {%>selected<%}%>>5등급</option>
                			<option value="6" <%if (e_bean.getGi_grade().equals("6")) {%>selected<%}%>>6등급</option>
                			<%-- <option value="7" <%if (e_bean.getGi_grade().equals("7")) {%>selected<%}%>>7등급</option> --%>
                		</select>
                	</td>
                </tr>
                <tr>
                    <td class=title>담당자</td>
                    <td colspan="4"><!-- colspan="3" -->
                    	&nbsp;
                    	<select name='damdang_id' class=default>            
                        	<option value="">미지정</option>
	                   	<%if (user_size > 0) {%>
	                   		<%for (int i = 0; i < user_size; i++) {
                      			Hashtable user = (Hashtable)users.elementAt(i);
                      		%>
                    		<option value='<%=user.get("USER_ID")%>' <% if (damdang_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
	                    	<%}%>
						<%}%>
                		</select>            
            			&nbsp;&nbsp;&nbsp;
			            <label><input type="radio" name="caroff_emp_yn" value="1" onClick="javascript:setO11();" <%if (e_bean.getCaroff_emp_yn().equals("1") || e_bean.getCaroff_emp_yn().equals("")) {%>checked<%}%>>영업사원없음</label>
			            <label><input type="radio" name="caroff_emp_yn" value="2" onClick="javascript:setO11();" <%if (e_bean.getCaroff_emp_yn().equals("2")) {%>checked<%}%>>영업사원있음(당사 담당자 표기)</label>
			            <label><input type="radio" name="caroff_emp_yn" value="3" onClick="javascript:setO11();" <%if (e_bean.getCaroff_emp_yn().equals("3")) {%>checked<%}%>>영업사원있음(당사 담당자 미표기)</label>
			            
			            <!-- 20201020 개소세환원문구 모든차종에대해 표기로 변경됨에 따라 아래 견적서 개소세환원문구 표기여부 임시 주석처리 -->
			            <input type="hidden" name="info_st" id="info_st" value="">
					</td>
					<td id=tr_cons_cost_y style="display:<%if(e_bean.getCar_comp_id().equals("0001") || e_bean.getCar_comp_id().equals("0002")){%>''<%}else{%>none<%}%>"> 
            			<input type="button" class="button" value="자체탁송료 조회" onclick="javascript:search_cons_cost();">
        			</td>
        			<td id=tr_cons_cost_n style="display:<%if(e_bean.getCar_comp_id().equals("0001") || e_bean.getCar_comp_id().equals("0002")){%>none<%}else{%>''<%}%>"> 
            			&nbsp;
        			</td>
					<%-- <td class=title>개소세환원 안내문구</td>
                	<td>&nbsp;
                		<select name="info_st" id="info_st">
                			<option value="" <%if (e_bean.getInfo_st().equals("")) {%>selected<%}%>>안내문표기</option>
                			<option value="N" <%if (e_bean.getInfo_st().equals("N")) {%>selected<%}%>>안내문미표기</option>
                		</select>
                	</td> --%>
                </tr>
            </table>
        </td>
    </tr>
    

    
<!-- 사전계약관리 입력정보 -->
<%if (pur_from_page.equals("pur_pre_c.jsp")) {%>
	<tr>
        <td class=h colspan=2></td>
    </tr>
	<tr>
        <td class=h colspan=2></td>
    </tr>
    <tr>
        <td colspan="2">
        	<font class="num_weight" color="red">※ 사전계약관리 차량정보 및 예약현황 입니다. 차량정보 및 예약현황을 확인 후 아래 견적 정보를 선택 후 견적을 진행해주세요.</font>
        </td>
    </tr>
    <tr>
        <td colspan="2">
        	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사전계약관리 차량정보 및 예약현황</span>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td class=line colspan="2">
            <table border="0" cellspacing="1" width=100%>
				<tr>
				    <td class=title width=13%>차명</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_car_nm%>
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>옵션</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_car_opt%>
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>색상</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;외장 : <%=pur_car_col%>&nbsp;&nbsp;&nbsp;&nbsp;내장(가니쉬 포함) : <%=pur_car_in_col%>
				    	<!-- <%=pur_car_garnish_col%> -->
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>엔진</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_eco_yn%>
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>소비자가</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_car_amt%> 원
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>계약금</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_con_amt%> 원
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>계약금지급일</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_con_pay_dt%>
				    </td>
				</tr>
				<tr>
				    <td class=title width=13%>출고예정일</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_dlv_est_dt%>
				    </td>
				</tr>
				<tr> 
				    <td class=title width=13%>비고</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;&nbsp;<%=pur_etc%>
				    </td>
				</tr>
			</table>
		</td>
	</tr>
	<%if (!pur_seq.equals("")) {%>
		<%
		//예약자리스트
		Vector off_pre_vt = cop_db.getCarOffPreSeqResList(pur_seq);
		int off_pre_vt_size = off_pre_vt.size();
		%>
	<tr>
        <td class=h colspan=2></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td class=line colspan="2">
            <table border="0" cellspacing="1" width=100%>
				<tr> 
				    <td width=5% class=title>연번</td>
		            <td width=10% class=title>예약자</td>
		            <td width=15% class=title>고객명</td>
		            <td width=10% class=title>연락처</td>
		            <td width=15% class=title>주소</td>
		            <td width=20% class=title>메모</td>
		            <td width=10% class=title>예약등록일</td>
		            <td width=10% class=title>예약취소일</td>
				</tr>
			<%for (int i = 0; i < off_pre_vt_size; i++) {
				Hashtable pur_ht = (Hashtable)off_pre_vt.elementAt(i);%>
				<tr> 
				    <td align='center'><%=i+1%></td>
                    <td align='center'><%=pur_ht.get("BUS_NM")%></td>
                    <td align='center'><%=pur_ht.get("FIRM_NM")%></td>
                    <td align='center'><%=pur_ht.get("CUST_TEL")%></td>
                    <td align='center'><%=pur_ht.get("ADDR")%></td>
                    <td align='center'><%=pur_ht.get("MEMO")%></td>
                    <td align='center'><%=pur_ht.get("REG_DT")%></td>
                    <td align='center'><%=pur_ht.get("CLS_DT")%></td>
				</tr>
			<%}%>
			</table>
		</td>
	</tr>
	<%}%>	
	<tr>
        <td class=h colspan=2></td>
    </tr>
<%}%>
    
    <tr>
        <td class=h colspan=2></td>
    </tr>  

    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span></td>
    </tr>
    
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
				<tr> 
				    <td class=title width=15%>제조사</td>
				    <td colspan="2" valign=middle>
				    	&nbsp;
				    	<select name="car_comp_id" id="car_comp_id" onChange="javascript:GetCarCode()">
						<%for (int i=0; i<cc_r.length; i++) {
							cc_bean = cc_r[i];						
							//if (cc_bean.getCode().equals("0018")) continue;
						%>
							<option value="<%= cc_bean.getCode() %>" <%if (e_bean.getCar_comp_id().equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
						<%}%>
						</select>&nbsp;&nbsp;
						<textarea id="etc" name="etc" cols="130" rows="1" style="overflow: hidden; border: 0;" readonly><%=etc%></textarea>
					</td>
				</tr>
                <tr> 
                    <td class=title>차명</td>
                    <td>
                    	&nbsp;
                    	<select name="code" id="code">
                        	<option value="">선택</option>
                        <%for (int i=0; i<cm_r.length; i++) {
                            cm_bean = cm_r[i];%>
                        	<option value="<%= cm_bean.getCode() %>" <%if (e_bean.getCar_cd().equals(cm_bean.getCode()))%>selected<%%>><%=cm_bean.getCar_nm()%></option>
                        <%}%>
                      	</select>
                    </td>
                    <td align="center"><input type="button" class="button" value="해당차종 관련 공지사항" onclick="javascript:view_car_bbs();"></td>
                </tr>
                <tr>
                    <td class=title>차종</td>
                    <td width=66%>
						&nbsp;
						<a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                      	<input type="text" name="car_name" value="<%=cm_bean2.getCar_name()%>" size="50" class=whitetext readonly>
                      	<input type="hidden" name="car_id" id="car_id" value="<%=e_bean.getCar_id()%>">
                      	<input type="hidden" name="car_seq" id="car_seq" value="<%=e_bean.getCar_seq()%>">
                      	<input type="button" class="button" id="btn_view_spec" value="사양보기" onclick="javascript:view_spec();">
                    </td>
                    <td align="center">
                    	&nbsp;
                    	<input type="text" name="car_amt" value="<%=AddUtil.parseDecimal(e_bean.getCar_amt())%>" size="15" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value); set_amt();' readonly>
                    	원
                    </td>
                </tr>
                <tr> 
                    <td class=title>옵션</td>
                    <td>
                    	&nbsp;
                    	<a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                      	<input type="text" name="opt" value="<%=e_bean.getOpt()%>" size="75" class=whitetext readonly>
                      	<input type="hidden" name="opt_seq" value="<%=e_bean.getOpt_seq()%>">
                    </td>
                    <td align="center">
                      	&nbsp;
                      	<input type="text" name="opt_amt" value="<%=AddUtil.parseDecimal(e_bean.getOpt_amt())%>" size="15" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value); set_amt();' readonly>
                      	원
                      	<input type="hidden" name="opt_amt_m" value="<%=AddUtil.parseDecimal(e_bean.getOpt_amt_m())%>" size="15" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value);' readonly>
                    </td>
                </tr>
                <tr> 
                    <td class=title>색상</td>
                    <td>
                    	&nbsp;
                    	<a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                      	외장: <input type="text" name="col" value="<%=e_bean.getCol()%>" size="27" class=whitetext readonly>
                  		&nbsp;&nbsp;&nbsp;&nbsp;
                  		내장: <input type="text" name="in_col" value="<%=e_bean.getIn_col()%>" size="27" class=whitetext readonly>
                  		&nbsp;&nbsp;&nbsp;&nbsp;
                  		가니쉬: <input type="text" name="garnish_col" value="<%=e_bean.getGarnish_col()%>" size="27" class=whitetext readonly>
                      <input type="hidden" name="col_seq" value="<%=e_bean.getCol_seq()%>">
					</td>
                    <td align="center"> 
                      	&nbsp;
                      	<input type="text" name="col_amt" value="<%=AddUtil.parseDecimal(e_bean.getCol_amt())%>" size="15" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value); set_amt();' readonly>
                      	원
                    </td>
                </tr>
                <tr>
                	<td class="title">연비</td>
                	<td>
                		&nbsp;
                		<a href="javascript:sub_list('5');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                      	<input type="text" name="conti_rat" value="<%=e_bean.getConti_rat()%>"  size="75" class=whitetext readonly>
                      	<input type="hidden" name="conti_rat_seq" value="<%=e_bean.getConti_rat()%>">
                    </td>
                    <td align="center"> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>제조사DC</td>
                    <td>
                    	&nbsp;
                    	<a href="javascript:sub_list('4');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                      	<input type="text" name="dc" value="<%=e_bean.getDc()%>" size="45" class=text>
                      	<input type="hidden" name="dc_seq" value="<%=e_bean.getDc_seq()%>">
                      	<input type="hidden" name="esti_d_etc" value="<%=e_bean.getEsti_d_etc()%>">
                      	<input type="text" name="bigo" value="<%=bigo%>" size="45" class=whitetext>
                    </td>
                    <td align="center">
                    	- <input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(e_bean.getDc_amt())%>" size="15" class=num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                    	원
                    </td>
                </tr>
                
                <tr id=tr_ecar_tax style="display:<%if (e_bean.getTax_dc_amt() > 0) {%>''<%} else {%>none<%}%>">
                	<td class=title>개별소비세</td>
                    <td> 
                    	&nbsp;개별소비세 및 교육세 감면 
                    </td>
                    <td align="center">
                    	- <input type="text" name="tax_dc_amt" value="<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%>" size="15" class=whitenum onBlur='javscript:this.value = parseDecimal(this.value);'>
                    	원
                    </td>
                </tr>  
                
                <tr> 
                    <td class=title>비고</td>
                    <td> 
                    	&nbsp;
                    	<textarea id="car_etc" name="car_etc" cols="100" rows="3" style="overflow: hidden; border: 0;" readonly></textarea>
                      	<input type="hidden" id="car_etc2" name="car_etc2">
                    </td>
                    <td align="center">&nbsp;</td>
                </tr>
                
                <tr> 
                    <td class=title colspan="2">차량가격</td>
                    <td align="center">
                    	&nbsp;
                    	<input type="text" name="o_1" value="<%=AddUtil.parseDecimal(e_bean.getO_1())%>" size="15" class=whitenum readonly>
                    	원
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    
    <tr>
        <td class=h></td>
    </tr>
     
    <tr>
        <td align="right"><a href="javascript:dlv_con_commi();"><img src=/acar/images/center/button_sd_cg.gif align=absmiddle border=0 alt='출고보전수당'></a></td>
    </tr>
    
    <!-- START_수입차 -->
    <tr id="import_content_1" style="display: <%if (!e_bean.getImport_pur_st().equals("")) {%>''<%} else {%>none<%}%>">
        <td>
        	<table border=0 cellspacing=0 cellpadding=0 width=100%>
        		<tr>
        			<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수입차</span></td>
        		</tr>
        	</table>
        	<table border=0 cellspacing=0 cellpadding=0 width=100%>
        		<tr>
			        <td class=line2></td>
			    </tr>
        		<tr>
        			<td class="line">
        				<table border="0" cellspacing="1" width=100%>
			            	<tr> 
			                    <td class=title width="15%">수입차출고</td> 
						        <td align="left">
						        	&nbsp;
						        	<input type="radio" name="import_pur_st" id="import_pur_st_1" value="0" <%if (e_bean.getImport_pur_st().equals("0") || e_bean.getImport_pur_st().equals("")) {%>checked<%}%> onchange="javascript:release_type();">
						        	<label for="import_pur_st_1">자체출고</label>
						        	&nbsp;
						          	<input type="radio" name="import_pur_st" id="import_pur_st_2" value="1" <%if (e_bean.getImport_pur_st().equals("1")) {%>checked<%}%> onchange="javascript:release_type();">
						          	<label for="import_pur_st_2">영업사원출고 (자체출고 견적외)</label>
						        </td>
			                </tr>
			            </table>
        			</td>
        		</tr>
        	</table>
        </td>
    </tr>
    
    <tr id="import_content_2" style="display: <%if (e_bean.getImport_pur_st().equals("1")) {%>''<%} else {%>none<%}%>">
        <td>
        	<table border=0 cellspacing=0 cellpadding=0 width=100%>
        		<tr>
			        <td class=h></td>
			    </tr>
        		<tr>
			        <td class=line2></td>
			    </tr>
        		<tr>
        			<td class="line">
        				<table border="0" cellspacing="1" width=100%>
			            	<tr>
			                    <td class=title width="15%">적용면세차가</td>
			                    <td align="left">
			                    	&nbsp;<input type="text" name="car_b_p2" id="car_b_p2" class="whitenum" size="15" value="<%=AddUtil.parseDecimal(e_bean.getCar_b_p2())%>" readonly> 원
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">세금계산서D/C</td>
			                    <td align="left">
			                    	&nbsp;
			                    	렌트&nbsp;&nbsp;<input type="text" name="r_dc_amt" id="r_dc_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getR_dc_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> 원 /
			                    	&nbsp;
			                    	리스&nbsp;&nbsp;<input type="text" name="l_dc_amt" id="l_dc_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getL_dc_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> 원
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">카드결제금액</td>
			                    <td align="left">
			                    	&nbsp;
			                    	렌트&nbsp;&nbsp;<input type="text" name="r_card_amt" id="r_card_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getR_card_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> 원 /
			                    	&nbsp;
			                    	리스&nbsp;&nbsp;<input type="text" name="l_card_amt" id="l_card_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getL_card_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> 원
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">Cash Back</td>
			                    <td align="left">
			                    	&nbsp;
			                    	렌트&nbsp;&nbsp;<input type="text" name="r_cash_back" id="r_cash_back" class="num" value="<%=AddUtil.parseDecimal(e_bean.getR_cash_back())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> 원 /
			                    	&nbsp;
			                    	리스&nbsp;&nbsp;<input type="text" name="l_cash_back" id="l_cash_back" class="num" value="<%=AddUtil.parseDecimal(e_bean.getL_cash_back())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> 원
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">탁송썬팅비용등</td>
			                    <td align="left">
			                    	&nbsp;
			                    	렌트&nbsp;&nbsp;<input type="text" name="r_bank_amt" id="r_bank_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getR_bank_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> 원 /
			                    	&nbsp;
			                    	리스&nbsp;&nbsp;<input type="text" name="l_bank_amt" id="l_bank_amt" class="num" value="<%=AddUtil.parseDecimal(e_bean.getL_bank_amt())%>" onBlur="javscript:this.value = parseDecimal(this.value);"> 원
			                    </td>
			                </tr>
			            </table>
        			</td>
        		</tr>        		
        	</table>
        </td>
    </tr>
    <!-- END_수입차 -->
    
    <tr>
        <td><font class="num_weight" color="red">※ 차량가격/색상/대여기간/약정운행거리가 변경되었을 경우 최대잔가율을 꼭 재계산하십시오.</font></td>
    </tr>
    <tr>
        <td>※ 보증금율은 최대잔가 계산시 표준보증금율로 변경됩니다.</td>
    </tr>
    <tr>
        <td>※ 영업수당율/대여료DC율은 <%if (cmd.equals("re")) {%>원견적의 조건을<%} else {%>입력한 값을<%}%> 그대로 사용합니다.</td>
    </tr>
    <tr>
        <td>※ 견적별 종합의 경우 보험,용품,차량인도지역,전기차고객주소지는 견적1의 조건으로 고정됩니다. 견적별 종합에서 수입차 견적시 렌트/리스 혼합견적은 불가능합니다.</td>
    </tr>
    <%if (nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("엑셀견적관리자", user_id) || nm_db.getWorkAuthUser("홈페이지견적반영2", user_id)) {%>
    <tr>
        <td>※ 견적일자 : <input type="text" name="rent_dt" value="<%=AddUtil.getDate()%>" size="10" class=text></td>
    </tr>
    <%}else{ %>
    <input type='hidden' name="rent_dt"   value="">
    <%} %>
    <tr>
        <td class=h></td>
    </tr>
    
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약조건</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='' colspan="2"> 
            <table border="0" cellspacing="0" width=100% id='esti_condition'>
				<tr>
					<td colspan='2' class=title>구분</td>
                  	<td colspan='4'>
                  		&nbsp;
			            <label>
				            <input type="radio" name="print_type" value="1" onClick="javascript:setEst_yn(1);" <% if (e_bean.getPrint_type().equals("1")||e_bean.getPrint_type().equals("5")||e_bean.getPrint_type().equals("")) out.print("checked"); %> <% if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) { %>disabled<% } %>>
				               상품별
						</label>
						&nbsp;
			            <label>
				            <input type="radio" name="print_type" value="5" onClick="javascript:setEst_yn(5);" <% if (e_bean.getPrint_type().equals("6")) { %>disabled<% } %>>
							견적별종합
			            </label>
			            &nbsp;
			            <label>
			            	<input type="radio" name="print_type" value="2" onClick="javascript:setEst_yn(2);" <% if (e_bean.getPrint_type().equals("2")) out.print("checked"); %> <% if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) { %>disabled<% } %>>
							렌트
						</label>
						&nbsp;
			            <label>
			            	<input type="radio" name="print_type" value="3" onClick="javascript:setEst_yn(3);" <% if (e_bean.getPrint_type().equals("3")) out.print("checked"); %> <% if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) { %>disabled<% } %>>
			                   리스
	                 	</label>
	                 	&nbsp;
			            <label>
			            	<input type="radio" name="print_type" value="4" onClick="javascript:setEst_yn(4);" <% if (e_bean.getPrint_type().equals("4")) out.print("checked"); %> <% if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) { %>disabled<% } %>>
			                   종합
	                  	</label>
	                  	&nbsp;
			            <label <%if ((e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6"))) {%>style="display: ;"<%} else {%>style="display: none;"<%}%>>
			            	<input type="radio" name="print_type" value="6" onClick="javascript:setEst_yn(6);" <% if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) out.print("checked"); %> <% if (!e_bean.getPrint_type().equals("6") || !e_bean2.getPrint_type().equals("6") || !e_bean3.getPrint_type().equals("6") || !e_bean4.getPrint_type().equals("6")) { %>disabled<% } %>>
							전기차 인수 / 반납 선택형 및 반납형 견적
						</label>
                  	</td>
                </tr>             
                <tr>
                  	<td colspan='2' class=title>선택</td>
                  	<td width="22%" class=title>
                  		<input type="checkbox" name="est_yn" id="est_yn_1" value="Y" checked <%if (e_bean.getPrint_type().equals("6")) {%>disabled<%} else {%><%}%> onClick="javascript:setO11();">
                  		견적1
                  	</td>
                  	<td width="21%" class=title>
	                  	<table width="100%">
	                  		<tr>
	                  			<td width="95%" class=title style="border: none !important;">
	                  				<input type="checkbox" name="est_yn" id="est_yn_2" value="Y" <%if (est_table.equals("esti_spe") && !a_a[1].equals("")) {%>checked<%} else if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) {%>checked<%}%> <%if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) {%>disabled<%} else {%><%}%> onClick="javascript:setO11();">
	                  				견적2
	                  			</td>
	                  			<td width="5%" class=title  style="border: none !important;">
	                  				<input type="button" class="button" id="btn_copy2" value="복사" style="margin-left: 20px;" onclick="javascript:copy_esti_1('2');">
	                  			</td>
	                  		</tr>
	                  	</table>
                  	</td>
                  	<td width="21%" class='title esti_target'>
	                  	<table width="100%">
	                  		<tr>
	                  			<td width="95%" class=title style="border: none !important;">
	                  				<input type="checkbox" name="est_yn" id="est_yn_3" value="Y" <%if (est_table.equals("esti_spe") && !a_a[2].equals("")) {%>checked<%}%> onClick="javascript:setO11();eh_chk('3');">
	                  				견적3
	                  			</td>
	                  			<td width="5%" class=title style="border: none !important;">
	                  				<input type="button" class="button" id="btn_copy3" value="복사" style="margin-left: 20px;" onclick="javascript:copy_esti_1('3');">
	                  			</td>
	                  		</tr>
	                  	</table>
                  	</td>
                  	<td width="21%" class='title esti_target'>
	                  	<table width="100%">
	                  		<tr>
	                  			<td width="95%" class=title style="border: none !important;">
	                  				<input type="checkbox" name="est_yn" id="est_yn_4" value="Y" <%if (est_table.equals("esti_spe") && !a_a[3].equals("")) {%>checked<%}%> onClick="javascript:setO11();eh_chk('4');">
	                  				견적4
	                  			</td>
	                  			<td width="5%" class=title style="border: none !important;">
	                  				<input type="button" class="button" id="btn_copy4" value="복사" style="margin-left: 20px;" onclick="javascript:copy_esti_1('4');">
                  				</td>
                  			</tr>
	                  	</table>
                  	</td>
                  	<td id='rent-lease-target3' style='display:none; border-top: 0 !important; border-bottom: 0 !important; border-right: 0 !important;' rowspan='23'></td>
                  	<td id='rent-lease-target4' style='display:none; border: 0 !important;' rowspan='23'></td>
                </tr>   
                                                
                <!-- 신규_printtype -->
                <tr id=tr_ecar_return style="display:<%if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) {%>''<%} else {%>none<%}%>">
                  	<td colspan='2' class=title>인수/반납 유형</td>
                  	<td>
                  		&nbsp;
                  		<select name="return_select" id="return_select_0" onChange="javascript:return_type(0); setO11();">
                      		<option value="" <%if (e_bean.getReturn_select().equals("")) {%> selected<%}%>>=선 택=</option>
                      		<option value="0" <%if (e_bean.getReturn_select().equals("0")) {%> selected<%}%>>인수/반납 선택형</option>
                      		<option value="1" <%if (e_bean.getReturn_select().equals("1")) {%> selected<%}%>>반납형</option>
                    	</select> 
                  	</td>
                  	<td>
                  		&nbsp;
                  		<select name="return_select" id="return_select_1" onChange="javascript:return_type(1); setO11();">
                  			<%-- <option value="" <%if (e_bean.getReturn_select().equals("")) {%> selected<%}%>>=선 택=</option>
		                    <option value="0" <%if (e_bean.getReturn_select().equals("0")) {%> selected<%}%>>인수/반납 선택형</option>
		                    <option value="1" <%if (e_bean.getReturn_select().equals("1")) {%> selected<%}%>>반납형</option> --%>
		                    <option value="" <%if (e_bean2.getReturn_select().equals("")) {%> selected<%}%>>=선 택=</option>
		                    <option value="0" <%if (e_bean2.getReturn_select().equals("0")) {%> selected<%}%>>인수/반납 선택형</option>
		                    <option value="1" <%if (e_bean2.getReturn_select().equals("1")) {%> selected<%}%>>반납형</option>
                    	</select> 
                  	</td>
                  	<td>
                  		&nbsp;
                  		<select name="return_select" id="return_select_2" onChange="javascript:return_type(2); setO11();">
                      		<%-- <option value="" <%if (e_bean.getReturn_select().equals("")) {%> selected<%}%>>=선 택=</option>
                      		<option value="0" <%if (e_bean.getReturn_select().equals("0")) {%> selected<%}%>>인수/반납 선택형</option>
                      		<option value="1" <%if (e_bean.getReturn_select().equals("1")) {%> selected<%}%>>반납형</option> --%>
                      		<option value="" <%if (e_bean3.getReturn_select().equals("")) {%> selected<%}%>>=선 택=</option>
                      		<option value="0" <%if (e_bean3.getReturn_select().equals("0")) {%> selected<%}%>>인수/반납 선택형</option>
                      		<option value="1" <%if (e_bean3.getReturn_select().equals("1")) {%> selected<%}%>>반납형</option>
                    	</select> 
                  	</td>
                  	<td>
                  		&nbsp;
                  		<select name="return_select" id="return_select_3" onChange="javascript:return_type(3); setO11();">
                      		<%-- <option value="" <%if (e_bean.getReturn_select().equals("")) {%> selected<%}%>>=선 택=</option>
                      		<option value="0" <%if (e_bean.getReturn_select().equals("0")) {%> selected<%}%>>인수/반납 선택형</option>
                      		<option value="1" <%if (e_bean.getReturn_select().equals("1")) {%> selected<%}%>>반납형</option> --%>
                      		<option value="" <%if (e_bean4.getReturn_select().equals("")) {%> selected<%}%>>=선 택=</option>
                      		<option value="0" <%if (e_bean4.getReturn_select().equals("0")) {%> selected<%}%>>인수/반납 선택형</option>
                      		<option value="1" <%if (e_bean4.getReturn_select().equals("1")) {%> selected<%}%>>반납형</option>
                    	</select> 
                  	</td>
                </tr>

                <tr> 
                    <td colspan='2' class=title>대여상품</td>
                    <td>
                    	&nbsp;
                    	<select name="a_a" id="a_a_1" onChange="javascript:SelectA_a(0); setO11();">
	                        <option value="">=선 택=</option>
                        <%for (int i = 0 ; i < good_size ; i++) {
	                  		CodeBean good = goods[good_size-i-1];%>
	                        <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[0].equals(good.getNm_cd())) {%>selected<%} else {%><%if (e_bean.getA_a().equals(good.getNm_cd())) {%>selected<%}%><%}%>><%= good.getNm()%></option>
	                    <%}%>
                        </select>
                    </td>
                    <td>
                    	&nbsp;
                    	<select name="a_a" id="a_a_2" onChange="javascript:SelectA_a(1); setO11();">
	                        <option value="">=선 택=</option>
                        <%for (int i = 0 ; i < good_size ; i++) {
	                  		CodeBean good = goods[good_size-i-1];%>
	                        <%-- <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[1].equals(good.getNm_cd())) {%>selected<%} else {%><%if (good.getNm().equals("장기렌트 기본식"))%>selected<%%><%}%>><%= good.getNm()%></option> --%>
	                        <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[1].equals(good.getNm_cd())) {%> selected <%} else {%><%if (e_bean2.getPrint_type().equals("6")) {%><%if (e_bean2.getA_a().equals(good.getNm_cd())) {%>selected<%}%><%} else {%><%if (good.getNm().equals("장기렌트 기본식")) {%>selected<%}%><%}%><%}%>><%= good.getNm()%></option>
                        <%}%>
                        </select> 
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select name="a_a" id="a_a_3" onChange="javascript:SelectA_a(2); setO11();">
	                        <option value="">=선 택=</option>
                        <%for (int i = 0 ; i < good_size ; i++) {
	                  		CodeBean good = goods[good_size-i-1];%>
	                        <%-- <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[2].equals(good.getNm_cd())) {%>selected<%} else {%><%if (good.getNm().equals("장기렌트 기본식"))%>selected<%%><%}%>><%= good.getNm()%></option> --%>
	                        <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[2].equals(good.getNm_cd())) {%> selected <%} else {%><%if (e_bean3.getPrint_type().equals("6")) {%><%if (e_bean3.getA_a().equals(good.getNm_cd())) {%>selected<%}%><%} else {%><%if (good.getNm().equals("장기렌트 기본식")) {%>selected<%}%><%}%><%}%>><%= good.getNm()%></option>
                        <%}%>
                        </select> 
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select name="a_a" id="a_a_4" onChange="javascript:SelectA_a(3); setO11();">
	                        <option value="">=선 택=</option>
                        <%for (int i = 0 ; i < good_size ; i++) {
	                  		CodeBean good = goods[good_size-i-1];%>
	                        <%-- <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[3].equals(good.getNm_cd())) {%>selected<%} else {%><%if (good.getNm().equals("장기렌트 기본식"))%>selected<%%><%}%>><%= good.getNm()%></option> --%>
	                        <option value='<%= good.getNm_cd()%>' <%if (est_table.equals("esti_spe") && a_a[3].equals(good.getNm_cd())) {%> selected <%} else {%><%if (e_bean4.getPrint_type().equals("6")) {%><%if (e_bean4.getA_a().equals(good.getNm_cd())) {%>selected<%}%><%} else {%><%if (good.getNm().equals("장기렌트 기본식")) {%>selected<%}%><%}%><%}%>><%= good.getNm()%></option>
                        <%}%>
                        </select> 
                    </td>
                </tr>
                <tr> 
                    <td colspan='2' class=title>대여기간</td>
                    <!-- 콤보박스로 수정(2018.03.12) -->
                    <td>
                    	&nbsp;
                    	<select id="sel_a_b_1" name='sel_a_b' onchange="javascript:setA_b('1',this.value); set_return2_change(); set_other_esti_value(this);">
                   			<option value="24"<%if (e_bean.getA_b().equals("24")) {%> selected<%}%>>24</option>
                   			<option value="36"<%if (e_bean.getA_b().equals("36")) {%> selected<%}%>>36</option>
							<option value="48"<%if (e_bean.getA_b().equals("48")) {%> selected<%}%>>48</option>
							<option value="60"<%if (e_bean.getA_b().equals("60")) {%> selected<%}%>>60</option> <!--  <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
							<option value="directInput"<%if (!e_bean.getA_b().equals("24")&&!e_bean.getA_b().equals("36")&&!e_bean.getA_b().equals("48")&&!e_bean.getA_b().equals("60")) {%> selected<%}%> >직접입력</option> <!-- <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="a_b" size="4" id="a_b_1" value="<%=e_bean.getA_b()%>" onBlur='javascript:set_return2_change(); set_other_esti_value(this);'>&nbsp;개월 <!--  <%if (e_bean.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td>
                    	&nbsp;
                    	<select id="sel_a_b_2" name='sel_a_b' onchange="javascript:setA_b('2',this.value);">
                    	<%if (est_table.equals("esti_spe") || !e_bean2.getA_b().equals("")) {%>
                    		<option value="24"<%if (e_bean2.getA_b().equals("24")) {%> selected<%}%>>24</option>
                    		<option value="36"<%if (e_bean2.getA_b().equals("36")) {%> selected<%}%>>36</option>
							<option value="48"<%if (e_bean2.getA_b().equals("48")) {%> selected<%}%>>48</option>
							<option value="60"<%if (e_bean2.getA_b().equals("60")) {%> selected<%}%>>60</option> <!--  <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%} else {%>
							<option value="24">24</option>
							<option value="36">36</option>
							<option value="48" selected>48</option>
							<option value="60">60</option> <!--  <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%}%>	
							<option value="directInput"<%if (!e_bean2.getA_b().equals("24")&&!e_bean2.getA_b().equals("36")&&!e_bean2.getA_b().equals("48")&&!e_bean2.getA_b().equals("60")) {%> selected<%}%>>직접입력</option> <!--  <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="a_b" size="4" id="a_b_2" value="<%=e_bean2.getA_b()%>" >&nbsp;개월 <!-- <%if (e_bean2.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select id="sel_a_b_3" name='sel_a_b' onchange="javascript:setA_b('3',this.value);">
                    	<%if (est_table.equals("esti_spe") || !e_bean3.getA_b().equals("")) {%>
                    		<option value="24"<%if (e_bean3.getA_b().equals("24")) {%> selected<%}%>>24</option>
                    		<option value="36"<%if (e_bean3.getA_b().equals("36")) {%> selected<%}%>>36</option>
							<option value="48"<%if (e_bean3.getA_b().equals("48")) {%> selected<%}%>>48</option>
							<option value="60"<%if (e_bean3.getA_b().equals("60")) {%> selected<%}%>>60</option> <!--  <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%} else {%>
							<option value="24">24</option>
							<option value="36">36</option>
							<option value="48" selected>48</option>
							<option value="60">60</option><!--  <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%}%>	
							<option value="directInput"<%if (!e_bean2.getA_b().equals("24")&&!e_bean3.getA_b().equals("36")&&!e_bean3.getA_b().equals("48")&&!e_bean3.getA_b().equals("60")) {%> selected<%}%> >직접입력</option> <!-- <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="a_b" size="4" id="a_b_3" value="<%=e_bean3.getA_b()%>">&nbsp;개월 <!--  <%if (e_bean3.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select id="sel_a_b_4" name='sel_a_b' onchange="javascript:setA_b('4',this.value);">
                    	<%if (est_table.equals("esti_spe") || !e_bean4.getA_b().equals("")) {%>
                    		<option value="24"<%if (e_bean4.getA_b().equals("24")) {%> selected<%}%>>24</option>
                    		<option value="36"<%if (e_bean4.getA_b().equals("36")) {%> selected<%}%>>36</option>
							<option value="48"<%if (e_bean4.getA_b().equals("48")) {%> selected<%}%>>48</option>
							<option value="60"<%if (e_bean4.getA_b().equals("60")) {%> selected<%}%>>60</option> <!--  <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%} else {%>
							<option value="24">24</option>
							<option value="36">36</option>
							<option value="48" selected>48</option>
							<option value="60">60</option> <!--  <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						<%}%>	
							<option value="directInput"<%if (!e_bean2.getA_b().equals("24")&&!e_bean4.getA_b().equals("36")&&!e_bean4.getA_b().equals("48")&&!e_bean4.getA_b().equals("60")) {%> selected<%}%>>직접입력</option><!--  <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="a_b" size="4" id="a_b_4" value="<%=e_bean4.getA_b()%>" >&nbsp;개월 <!-- <%if (e_bean4.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                </tr>
                <tr> 
                    <td width='3%' rowspan="2" class=title>운행<br>거리</td>
                    <td class=title width='12%'>표준 약정운행거리</td>
                    <td>
                    	&nbsp;
                        <input type="text" name="b_agree_dist" id="b_agree_dist_1" class=whitenum readonly size="10" value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/년
					</td>
                    <td>
                    	&nbsp;
					    <input type="text" name="b_agree_dist" id="b_agree_dist_2" class=whitenum readonly size="10" value='<%=AddUtil.parseDecimal(e_bean2.getB_agree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
					    km/년
					</td>
                    <td class='esti_target'>
                    	&nbsp;
					    <input type="text" name="b_agree_dist" id="b_agree_dist_3" class=whitenum readonly size="10" value='<%=AddUtil.parseDecimal(e_bean3.getB_agree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
					    km/년
				    </td>
                    <td class='esti_target'>
                    	&nbsp;
						<input type="text" name="b_agree_dist" id="b_agree_dist_4" class=whitenum readonly size="10" value='<%=AddUtil.parseDecimal(e_bean4.getB_agree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
					    km/년
					</td>
                </tr>                   
                <tr> 
                    <td class=title>적용 약정운행거리</td>   
      				<!-- 콤보박스로 수정(2018.03.12) -->
      				<td>
      					&nbsp;
                    	<select class="sel_a_dist" id="sel_agree_dist_1" name='sel_agree_dist' onchange="javascript:setAgree_dist('1', this.value); set_return2_change(); set_other_esti_value(this);">
                   			<option value="10000" <%if (e_bean.getAgree_dist()==10000) {%>selected<%}%>>10,000</option>
							<option value="15000" <%if (e_bean.getAgree_dist()==15000) {%>selected<%}%>>15,000</option>
							<option value="20000" <%if (e_bean.getAgree_dist()==20000) {%>selected<%}%>>20,000</option>
							<option value="23000" <%if (e_bean.getAgree_dist()==23000) {%>selected<%}%>>23,000</option>
							<option value="25000" <%if (e_bean.getAgree_dist()==25000) {%>selected<%}%>>25,000</option>
							<option value="28000" <%if (e_bean.getAgree_dist()==28000) {%>selected<%}%>>28,000</option>
							<option value="30000" <%if (e_bean.getAgree_dist()==30000) {%>selected<%}%>>30,000</option>
<%-- 							<%if (!e_bean.getCar_comp_id().equals("0056")) {%> --%>
							<option value="35000" <%if (e_bean.getAgree_dist()==35000) {%>selected<%}%>>35,000</option>
							<option value="40000" <%if (e_bean.getAgree_dist()==40000) {%>selected<%}%>>40,000</option>
							<option value="45000" <%if (e_bean.getAgree_dist()==45000) {%>selected<%}%>>45,000</option>
							<option value="50000" <%if (e_bean.getAgree_dist()==50000) {%>selected<%}%>>50,000</option>
<%-- 							<%} %> --%>
							<%-- <option value="35000" <%if (e_bean.getAgree_dist()==35000) {%>selected<%}%> <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%>>35,000</option>
							<option value="40000" <%if (e_bean.getAgree_dist()==40000) {%>selected<%}%> <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%>>40,000</option>
							<option value="45000" <%if (e_bean.getAgree_dist()==45000) {%>selected<%}%> <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%>>45,000</option>
							<option value="50000" <%if (e_bean.getAgree_dist()==50000) {%>selected<%}%> <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%>>50,000</option> --%>
							<option value="directInput" <%if (e_bean.getAgree_dist()!=10000 && e_bean.getAgree_dist()!=15000 && e_bean.getAgree_dist()!=20000 && e_bean.getAgree_dist()!=23000 && e_bean.getAgree_dist()!=25000 && e_bean.getAgree_dist()!=28000
														 && e_bean.getAgree_dist()!=30000 && e_bean.getAgree_dist()!=35000 && e_bean.getAgree_dist()!=40000 && e_bean.getAgree_dist()!=45000
													  	 && e_bean.getAgree_dist()!=50000) {%>selected<%}%> >직접입력</option> <!-- <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="agree_dist" class="num" size="10" id="agree_dist_1" value="<%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>"  onBlur='javascript:this.value=parseDecimal(this.value);set_return2_change(); set_other_esti_value(this);'>&nbsp;km/년 <!-- <%if (e_bean.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td>
                    	&nbsp;
                    	<select class="sel_a_dist" id="sel_agree_dist_2" name='sel_agree_dist' onchange="javascript:setAgree_dist('2', this.value);">
                   			<option value="10000" <%if (e_bean2.getAgree_dist()==10000) {%>selected<%}%>>10,000</option>
							<option value="15000" <%if (e_bean2.getAgree_dist()==15000) {%>selected<%}%>>15,000</option>
							<option value="20000" <%if (e_bean2.getAgree_dist()==20000) {%>selected<%}%>>20,000</option>
							<option value="23000" <%if (e_bean2.getAgree_dist()==23000) {%>selected<%}%>>23,000</option>
							<option value="25000" <%if (e_bean2.getAgree_dist()==25000) {%>selected<%}%>>25,000</option>
							<option value="28000" <%if (e_bean2.getAgree_dist()==28000) {%>selected<%}%>>28,000</option>
							<option value="30000" <%if (e_bean2.getAgree_dist()==30000) {%>selected<%}%>>30,000</option>
<%-- 							<%if (!e_bean.getCar_comp_id().equals("0056")) {%> --%>
							<option value="35000" <%if (e_bean.getAgree_dist()==35000) {%>selected<%}%>>35,000</option>
							<option value="40000" <%if (e_bean.getAgree_dist()==40000) {%>selected<%}%>>40,000</option>
							<option value="45000" <%if (e_bean.getAgree_dist()==45000) {%>selected<%}%>>45,000</option>
							<option value="50000" <%if (e_bean.getAgree_dist()==50000) {%>selected<%}%>>50,000</option>
<%-- 							<%} %> --%>
							<%-- <option value="35000" <%if (e_bean2.getAgree_dist()==35000) {%>selected<%}%> <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%>>35,000</option>
							<option value="40000" <%if (e_bean2.getAgree_dist()==40000) {%>selected<%}%> <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%>>40,000</option>
							<option value="45000" <%if (e_bean2.getAgree_dist()==45000) {%>selected<%}%> <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%>>45,000</option>
							<option value="50000" <%if (e_bean2.getAgree_dist()==50000) {%>selected<%}%> <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%>>50,000</option> --%>
							<option value="directInput" <%if (e_bean2.getAgree_dist()!=10000 && e_bean2.getAgree_dist()!=15000 && e_bean2.getAgree_dist()!=20000 && e_bean2.getAgree_dist()!=23000 && e_bean2.getAgree_dist()!=25000 && e_bean2.getAgree_dist()!=28000
														 && e_bean2.getAgree_dist()!=30000 && e_bean2.getAgree_dist()!=35000 && e_bean2.getAgree_dist()!=40000 && e_bean2.getAgree_dist()!=45000
													  	 && e_bean2.getAgree_dist()!=50000) {%>selected<%}%> >직접입력</option> <!-- <%if (e_bean2.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="agree_dist" class="num" size="10" id="agree_dist_2" value="<%=AddUtil.parseDecimal(e_bean2.getAgree_dist())%>"  onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km/년 <!-- <%if (e_bean2.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select class="sel_a_dist" id="sel_agree_dist_3" name='sel_agree_dist' onchange="javascript:setAgree_dist('3', this.value);">
                   			<option value="10000" <%if (e_bean3.getAgree_dist()==10000) {%>selected<%}%>>10,000</option>
							<option value="15000" <%if (e_bean3.getAgree_dist()==15000) {%>selected<%}%>>15,000</option>
							<option value="20000" <%if (e_bean3.getAgree_dist()==20000) {%>selected<%}%>>20,000</option>
							<option value="23000" <%if (e_bean3.getAgree_dist()==23000) {%>selected<%}%>>23,000</option>
							<option value="25000" <%if (e_bean3.getAgree_dist()==25000) {%>selected<%}%>>25,000</option>
							<option value="28000" <%if (e_bean3.getAgree_dist()==28000) {%>selected<%}%>>28,000</option>
							<option value="30000" <%if (e_bean3.getAgree_dist()==30000) {%>selected<%}%>>30,000</option>
<%-- 							<%if (!e_bean.getCar_comp_id().equals("0056")) {%> --%>
							<option value="35000" <%if (e_bean.getAgree_dist()==35000) {%>selected<%}%>>35,000</option>
							<option value="40000" <%if (e_bean.getAgree_dist()==40000) {%>selected<%}%>>40,000</option>
							<option value="45000" <%if (e_bean.getAgree_dist()==45000) {%>selected<%}%>>45,000</option>
							<option value="50000" <%if (e_bean.getAgree_dist()==50000) {%>selected<%}%>>50,000</option>
<%-- 							<%} %> --%>
							<%-- <option value="35000" <%if (e_bean3.getAgree_dist()==35000) {%>selected<%}%> <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%>>35,000</option>
							<option value="40000" <%if (e_bean3.getAgree_dist()==40000) {%>selected<%}%> <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%>>40,000</option>
							<option value="45000" <%if (e_bean3.getAgree_dist()==45000) {%>selected<%}%> <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%>>45,000</option>
							<option value="50000" <%if (e_bean3.getAgree_dist()==50000) {%>selected<%}%> <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%>>50,000</option> --%>
							<option value="directInput" <%if (e_bean3.getAgree_dist()!=10000 && e_bean3.getAgree_dist()!=15000 && e_bean3.getAgree_dist()!=20000 && e_bean3.getAgree_dist()!=23000 && e_bean3.getAgree_dist()!=25000 && e_bean3.getAgree_dist()!=28000
														 && e_bean3.getAgree_dist()!=30000 && e_bean3.getAgree_dist()!=35000 && e_bean3.getAgree_dist()!=40000 && e_bean3.getAgree_dist()!=45000
													  	 && e_bean3.getAgree_dist()!=50000) {%>selected<%}%> >직접입력</option> <!-- <%if (e_bean3.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="agree_dist" class="num" size="10" id="agree_dist_3" value="<%=AddUtil.parseDecimal(e_bean3.getAgree_dist())%>"  onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km/년 <!-- <%if (e_bean3.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select class="sel_a_dist" id="sel_agree_dist_4" name='sel_agree_dist' onchange="javascript:setAgree_dist('4', this.value);">
                   			<option value="10000" <%if (e_bean4.getAgree_dist()==10000) {%>selected<%}%>>10,000</option>
							<option value="15000" <%if (e_bean4.getAgree_dist()==15000) {%>selected<%}%>>15,000</option>
							<option value="20000" <%if (e_bean4.getAgree_dist()==20000) {%>selected<%}%>>20,000</option>
							<option value="23000" <%if (e_bean4.getAgree_dist()==23000) {%>selected<%}%>>23,000</option>
							<option value="25000" <%if (e_bean4.getAgree_dist()==25000) {%>selected<%}%>>25,000</option>
							<option value="28000" <%if (e_bean4.getAgree_dist()==28000) {%>selected<%}%>>28,000</option>
							<option value="30000" <%if (e_bean4.getAgree_dist()==30000) {%>selected<%}%>>30,000</option>
<%-- 							<%if (!e_bean.getCar_comp_id().equals("0056")) {%> --%>
							<option value="35000" <%if (e_bean.getAgree_dist()==35000) {%>selected<%}%>>35,000</option>
							<option value="40000" <%if (e_bean.getAgree_dist()==40000) {%>selected<%}%>>40,000</option>
							<option value="45000" <%if (e_bean.getAgree_dist()==45000) {%>selected<%}%>>45,000</option>
							<option value="50000" <%if (e_bean.getAgree_dist()==50000) {%>selected<%}%>>50,000</option>
<%-- 							<%} %> --%>
							<%-- <option value="35000" <%if (e_bean4.getAgree_dist()==35000) {%>selected<%}%> <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%>>35,000</option>
							<option value="40000" <%if (e_bean4.getAgree_dist()==40000) {%>selected<%}%> <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%>>40,000</option>
							<option value="45000" <%if (e_bean4.getAgree_dist()==45000) {%>selected<%}%> <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%>>45,000</option>
							<option value="50000" <%if (e_bean4.getAgree_dist()==50000) {%> selected<%}%> <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%>>50,000</option> --%>
							<option value="directInput" <%if (e_bean4.getAgree_dist()!=10000 && e_bean4.getAgree_dist()!=15000 && e_bean4.getAgree_dist()!=20000 && e_bean4.getAgree_dist()!=23000 && e_bean4.getAgree_dist()!=25000 && e_bean4.getAgree_dist()!=28000
														 && e_bean4.getAgree_dist()!=30000 && e_bean4.getAgree_dist()!=35000 && e_bean4.getAgree_dist()!=40000 && e_bean4.getAgree_dist()!=45000
													  	 && e_bean4.getAgree_dist()!=50000) {%>selected<%}%> >직접입력</option> <!-- <%if (e_bean4.getCar_comp_id().equals("0056")) {%>disabled<%}%> -->
						</select>
                    	<input type="text" name="agree_dist" class="num" size="10" id="agree_dist_4" value="<%=AddUtil.parseDecimal(e_bean4.getAgree_dist())%>"  onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km/년 <!-- <%if (e_bean4.getCar_comp_id().equals("0056")) {%>readonly<%}%> -->
                    </td>
                </tr>  
                <tr> 
                    <td width='3%' rowspan="4" class=title>잔가</td>
                    <td class=title width='12%'>표준 최대잔가</td>
                    <td>
                    	&nbsp;
                        <input type="text" name="b_o_13" id="b_o_13_1" size="4" value='<%=e_bean.getB_o_13()%>' class=whitenum readonly  onblur="javascript:compare(0, this)">
                        %
                        <!-- 영업기획팀, 김진좌 팀장, 고연미 차장만 권한. + 전산팀 -->
                        <%if ((nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
                        &nbsp;&nbsp;&nbsp;&nbsp;
	                        <select name='rtn_run_amt_yn' id='rtn_run_amt_yn_1' onchange="javascript:searchO13(0);">
	                        	<option value='0'>환급대여료 적용</option>
	                        	<option value='1'>미적용</option>
	                        </select>
                        <%} else {%>
                        	<input type='hidden' name='rtn_run_amt_yn' value='0' />
                        <%} %>
					</td>
                    <td>
                    	&nbsp;
                        <input type="text" name="b_o_13" id="b_o_13_2" size="4" value='<%=e_bean2.getB_o_13()%>' class=whitenum readonly  onblur="javascript:compare(1, this)">
     					 %
     					 <!-- 영업기획팀, 김진좌 팀장, 고연미 차장만 권한. + 전산팀 -->
                        <%if ((nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
                        &nbsp;&nbsp;&nbsp;&nbsp;
	                        <select name='rtn_run_amt_yn' id='rtn_run_amt_yn_2' onchange="javascript:searchO13(1);">
	                        	<option value='0'>환급대여료 적용</option>
	                        	<option value='1'>미적용</option>
	                        </select>
                        <%} else {%>
                        	<input type='hidden' name='rtn_run_amt_yn' value='0' />
                        <%} %>
  					 </td>
                    <td class='esti_target'>
                    	&nbsp;
                        <input type="text" name="b_o_13" id="b_o_13_3" size="4" value='<%=e_bean3.getB_o_13()%>' class=whitenum readonly  onblur="javascript:compare(2, this)">
      					%
      					<!-- 영업기획팀, 김진좌 팀장, 고연미 차장만 권한. + 전산팀 -->
                        <%if ((nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
                        &nbsp;&nbsp;&nbsp;&nbsp;
	                        <select name='rtn_run_amt_yn' id='rtn_run_amt_yn_3' onchange="javascript:searchO13(2);">
	                        	<option value='0'>환급대여료 적용</option>
	                        	<option value='1'>미적용</option>
	                        </select>
                        <%} else {%>
                        	<input type='hidden' name='rtn_run_amt_yn' value='0' />
                        <%} %>
   					</td>
                    <td class='esti_target'>
                    	&nbsp;
                        <input type="text" name="b_o_13" id="b_o_13_4" size="4" value='<%=e_bean4.getB_o_13()%>' class=whitenum readonly  onblur="javascript:compare(3, this)">
      					%
      					<!-- 영업기획팀, 김진좌 팀장, 고연미 차장만 권한. + 전산팀 -->
                        <%if ((nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
                        &nbsp;&nbsp;&nbsp;&nbsp;
	                        <select name='rtn_run_amt_yn' id='rtn_run_amt_yn_4' onchange="javascript:searchO13(3);">
	                        	<option value='0'>환급대여료 적용</option>
	                        	<option value='1'>미적용</option>
	                        </select>
                        <%} else {%>
                        	<input type='hidden' name='rtn_run_amt_yn' value='0' />
                        <%} %>
   					</td>
                </tr>
                
                <tr>                     
                    <td class=title>조정 최대잔가</td>
                    <td>
                    	&nbsp;
                        <input type="text" name="o_13" id="o_13_1" size="4" value='<%=e_bean.getO_13()%>' class="whitenum num_weight" readonly  onblur="javascript:compare(0, this)">
                        <span class="num_weight">%</span>
                        &nbsp;&nbsp;&nbsp;
                        <a onclick="set_time()" href="javascript:searchO13(0);"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
                        <%if (nm_db.getWorkAuthUser("전산팀",user_id)) {//잔가계산 점검%>
                        <input type="checkbox" name="O13_yn" value="Y" >점검
                        <%}%>
                    </td>
                    <td>
                    	&nbsp;
                        <input type="text" name="o_13" id="o_13_2" size="4" value='<%=e_bean2.getO_13()%>' class="whitenum num_weight" readonly  onblur="javascript:compare(1, this)">
      					<span class="num_weight">%</span>
      					&nbsp;&nbsp;&nbsp;
      					<a href="javascript:searchO13(1);"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
      				</td>
                    <td class='esti_target'>
                    	&nbsp;
                        <input type="text" name="o_13" id="o_13_3" size="4" value='<%=e_bean3.getO_13()%>' class="whitenum num_weight" readonly  onblur="javascript:compare(2, this)">
      					<span class="num_weight">%</span>
      					&nbsp;&nbsp;&nbsp;
      					<a href="javascript:searchO13(2);"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
      				</td>
                    <td class='esti_target'>
                    	&nbsp;
                        <input type="text" name="o_13" id="o_13_4" size="4" value='<%=e_bean4.getO_13()%>' class="whitenum num_weight" readonly  onblur="javascript:compare(3, this)">
      					<span class="num_weight">%</span>
      					&nbsp;&nbsp;&nbsp;
      					<a href="javascript:searchO13(3);"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
      				</td>
                </tr>              
                                                  
                <tr> 
                    <td class=title>적용잔가</td>
                    <td>
                    	<%-- <div id="ro_13_0_display_1" style="display: <%if (e_bean.getOpt_chk().equals("0")) {%>none<%} else {%><%}%>"> --%>
                    	<div id="ro_13_0_display_1" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean.getCar_comp_id().equals("0056")) {%><%if (e_bean.getOpt_chk().equals("0")) {%>none<%} else {%><%}%><%} else {%><%}%>">
	                    	&nbsp;
		                    <input type="text" name="ro_13" id="ro_13_1" size="4" value='<%=e_bean.getRo_13()%>' class="num num_weight"  onblur="javascript:compare(0, this);set_return2_change();">
		                    <span class="num_weight">%</span><br>&nbsp;
		                    <input type="text" name="ro_13_amt" id="ro_13_amt_1" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_return2_change();'>
		                        원
                        </div>
                        <%-- <div id="ro_13_0_display_2" style="display: <%if (e_bean.getOpt_chk().equals("0")) {%><%} else {%>none<%}%>"> --%>
                        <div id="ro_13_0_display_2" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean.getCar_comp_id().equals("0056")) {%><%if (e_bean.getOpt_chk().equals("0")) {%><%} else {%>none<%}%><%} else {%>none<%}%>">
					    	&nbsp;
					    	미공개
					    </div>
                        <div id="ro_13_0_display_3" style="float: right; text-align: right; margin-top: -40px; margin-right: 15px; display: <%if (e_bean.getCar_comp_id().equals("0056")) {%><%} else {%>none<%}%>">
					    	<!-- ※ 정기점검 면제조건:<br>
					    	조정최대잔가 -3%,<br>
					    	잔가조정전 위약금율 사용 -->
					    </div>
                    </td>
                    <td>
                    	<%-- <div id="ro_13_1_display_1" style="display: <%if (e_bean2.getOpt_chk().equals("0")) {%>none<%} else {%><%}%>"> --%>
                    	<div id="ro_13_1_display_1" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean2.getCar_comp_id().equals("0056")) {%><%if (e_bean2.getOpt_chk().equals("0")) {%>none<%} else {%><%}%><%} else {%><%}%>">
	                    	&nbsp;
		                    <input type="text" name="ro_13" id="ro_13_2" size="4" value='<%=e_bean2.getRo_13()%>' class="num num_weight" onblur="javascript:compare(1, this)">
						    <span class="num_weight">%</span><br>&nbsp;
						    <input type="text" name="ro_13_amt" id="ro_13_amt_2" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(1, this);'>
						     원
					    </div>
					    <%-- <div id="ro_13_1_display_2" style="display: <%if (e_bean2.getOpt_chk().equals("0")) {%><%} else {%>none<%}%>"> --%>
					    <div id="ro_13_1_display_2" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean2.getCar_comp_id().equals("0056")) {%><%if (e_bean2.getOpt_chk().equals("0")) {%><%} else {%>none<%}%><%} else {%>none<%}%>">
					    	&nbsp;
					    	미공개
					    </div>
					    <div id="ro_13_1_display_3" style="float: right; text-align: right; margin-top: -40px; margin-right: 15px; display: <%if (e_bean2.getCar_comp_id().equals("0056")) {%><%} else {%>none<%}%>">
							<!-- ※ 정기점검 면제조건:<br>
							조정최대잔가 -3%,<br>
					    	잔가조정전 위약금율 사용 -->
					    </div>
				    </td>
                    <td class='esti_target'>
                    	<!-- <div id="ro_13_2_display_1"> -->
                    	<div id="ro_13_2_display_1" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean3.getCar_comp_id().equals("0056")) {%><%if (e_bean3.getOpt_chk().equals("0")) {%>none<%} else {%><%}%><%} else {%><%}%>">
	                    	&nbsp;
	                        <input type="text" name="ro_13" id="ro_13_3" size="4" value='<%=e_bean3.getRo_13()%>' class="num num_weight" onblur="javascript:compare(2, this)">
							<span class="num_weight">%</span><br>&nbsp;
							<input type="text" name="ro_13_amt" id="ro_13_amt_3" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(2, this);'>
							원
						</div>
						<!-- <div id="ro_13_2_display_2" style="display: none;"> -->
						<div id="ro_13_2_display_2" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean3.getCar_comp_id().equals("0056")) {%><%if (e_bean3.getOpt_chk().equals("0")) {%><%} else {%>none<%}%><%} else {%>none<%}%>">
					    	&nbsp;
					    	미공개
					    </div>
					    <div id="ro_13_2_display_3" style="float: right; text-align: right; margin-top: -40px; margin-right: 15px; display: <%if (e_bean3.getCar_comp_id().equals("0056")) {%><%} else {%>none<%}%>">
					    	<!-- ※ 정기점검 면제조건:<br>
					    	조정최대잔가 -3%,<br>
					    	잔가조정전 위약금율 사용 -->
					    </div>
					</td>
                    <td class='esti_target'>
                    	<!-- <div id="ro_13_3_display_1"> -->
                    	<div id="ro_13_3_display_1" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean4.getCar_comp_id().equals("0056")) {%><%if (e_bean4.getOpt_chk().equals("0")) {%>none<%} else {%><%}%><%} else {%><%}%>">
	                    	&nbsp;
	                        <input type="text" name="ro_13" id="ro_13_4" size="4" value='<%=e_bean4.getRo_13()%>' class="num num_weight" onblur="javascript:compare(3, this)">
							<span class="num_weight">%</span><br>&nbsp;
							<input type="text" name="ro_13_amt" id="ro_13_amt_4" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(3, this);'>
							원
						</div>
						<!-- <div id="ro_13_3_display_2" style="display: none;"> -->
						<div id="ro_13_3_display_2" style="display: <%if (ej_bean.getJg_g_7().equals("3") && !e_bean4.getCar_comp_id().equals("0056")) {%><%if (e_bean4.getOpt_chk().equals("0")) {%><%} else {%>none<%}%><%} else {%>none<%}%>">
					    	&nbsp;
					    	미공개
					    </div>
					    <div id="ro_13_3_display_3" style="float: right; text-align: right; margin-top: -40px; margin-right: 15px; display: <%if (e_bean4.getCar_comp_id().equals("0056")) {%><%} else {%>none<%}%>">
					    	<!-- ※ 정기점검 면제조건:<br>
					    	조정최대잔가 -3%,<br>
					    	잔가조정전 위약금율 사용 -->
					    </div>
					</td>
                </tr>                    
                        
                <tr> 
                    <td class=title>매입옵션</td>
                    <td>
                    	&nbsp;
                    	<select name="opt_chk" id="opt_chk_1">
                      		<option value="0" <%if (est_table.equals("esti_spe") && opt_chk[0].equals("0")) {%>selected<%} else {%><%if (e_bean.getOpt_chk().equals("0")) {%>selected<%}%><%}%>>미부여</option>
                      		<option value="1" <%if (est_table.equals("esti_spe") && opt_chk[0].equals("1")) {%>selected<%} else {%><%if (e_bean.getOpt_chk().equals("1")) {%>selected<%}%><%}%>>부여</option>
                    	</select>
                    </td>
                    <td>
                    	&nbsp;
                    	<select name="opt_chk" id="opt_chk_2">
                      		<option value="0" <%if (est_table.equals("esti_spe") && opt_chk[1].equals("0")) {%>selected<%} else {%><%if (e_bean2.getOpt_chk().equals("0")) {%>selected<%}%><%}%>>미부여</option>
                      		<option value="1" <%if (est_table.equals("esti_spe") && opt_chk[1].equals("1")) {%>selected<%} else {%><%if (e_bean2.getOpt_chk().equals("1")) {%>selected<%}%><%}%>>부여</option>
                    	</select>
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select name="opt_chk" id="opt_chk_3">
                      		<option value="0" <%if (est_table.equals("esti_spe") && opt_chk[2].equals("0")) {%>selected<%} else {%><%if (e_bean3.getOpt_chk().equals("0")) {%>selected<%}%><%}%>>미부여</option>
                      		<option value="1" <%if (est_table.equals("esti_spe") && opt_chk[2].equals("1")) {%>selected<%} else {%><%if (e_bean3.getOpt_chk().equals("1")) {%>selected<%}%><%}%>>부여</option>
                    	</select>
                    </td>
                    <td class='esti_target'>
                    	&nbsp;
                    	<select name="opt_chk" id="opt_chk_4">
                      		<option value="0" <%if (est_table.equals("esti_spe") && opt_chk[3].equals("0")) {%>selected<%} else {%><%if (e_bean4.getOpt_chk().equals("0")) {%>selected<%}%><%}%>>미부여</option>
                      		<option value="1" <%if (est_table.equals("esti_spe") && opt_chk[3].equals("1")) {%>selected<%} else {%><%if (e_bean4.getOpt_chk().equals("1")) {%>selected<%}%><%}%>>부여</option>
                    	</select>
                    </td>
                </tr> 
                <tr> 
                    <td rowspan="3" class=title>선수</td>
                    <td class=title>보증금</td>  
				      <!-- 콤보박스로 수정(2018.03.12) -->
			      	<td>
			      		&nbsp;
                    	<select id="sel_rg_8_1" name='sel_rg_8' onchange="javascript:setRg_8('1',this.value);set_return2_change(); set_other_esti_value(this);">
                   			<option value="0" <%if (e_bean.getRg_8()==0) {%> selected<%}%>>0</option>
							<option value="10"<%if (e_bean.getRg_8()==10) {%> selected<%}%>>10</option>
							<option value="15"<%if (e_bean.getRg_8()==15) {%> selected<%}%>>15</option>
							<option value="20"<%if (e_bean.getRg_8()==20) {%> selected<%}%>>20</option>
							<option value="25"<%if (e_bean.getRg_8()==25) {%> selected<%}%>>25</option>
							<option value="30"<%if (e_bean.getRg_8()==30) {%> selected<%}%>>30</option>
							<option value="35"<%if (e_bean.getRg_8()==35) {%> selected<%}%>>35</option>
							<option value="40"<%if (e_bean.getRg_8()==40) {%> selected<%}%>>40</option>
							<option value="50"<%if (e_bean.getRg_8()==50) {%> selected<%}%>>50</option>
							<option value="directInput"<%if (e_bean.getRg_8()!= 0 && e_bean.getRg_8()!=10 && e_bean.getRg_8()!=15 && e_bean.getRg_8()!=20 
														 && e_bean.getRg_8()!=25 && e_bean.getRg_8()!=30 && e_bean.getRg_8()!=35 && e_bean.getRg_8()!=40
														 && e_bean.getRg_8()!=50) {%> selected<%}%>>직접입력</option></select>
                    	<input type="text" name="rg_8" class="num" size="4" id="rg_8_1" value="<%=e_bean.getRg_8()%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_return2_change(); set_other_esti_value(this);'>&nbsp;%<br>&nbsp;
				      	<input type="text" name="rg_8_amt" id="rg_8_amt_1" value='<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>' class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_return2_change(); set_other_esti_value(this);'>&nbsp;원
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select id="sel_rg_8_2" name='sel_rg_8' onchange="javascript:setRg_8('2',this.value);">
                   			<option value="0" <%if (e_bean2.getRg_8()==0) {%> selected<%}%>>0</option>
							<option value="10"<%if (e_bean2.getRg_8()==10) {%> selected<%}%>>10</option>
							<option value="15"<%if (e_bean2.getRg_8()==15) {%> selected<%}%>>15</option>
							<option value="20"<%if (e_bean2.getRg_8()==20) {%> selected<%}%>>20</option>
							<option value="25"<%if (e_bean2.getRg_8()==25) {%> selected<%}%>>25</option>
							<option value="30"<%if (e_bean2.getRg_8()==30) {%> selected<%}%>>30</option>
							<option value="35"<%if (e_bean2.getRg_8()==35) {%> selected<%}%>>35</option>
							<option value="40"<%if (e_bean2.getRg_8()==40) {%> selected<%}%>>40</option>
							<option value="50"<%if (e_bean2.getRg_8()==50) {%> selected<%}%>>50</option>
							<option value="directInput"<%if (e_bean2.getRg_8()!= 0 && e_bean2.getRg_8()!=10 && e_bean2.getRg_8()!=15 && e_bean2.getRg_8()!=20 
														 && e_bean2.getRg_8()!=25 && e_bean2.getRg_8()!=30 && e_bean2.getRg_8()!=35 && e_bean2.getRg_8()!=40
														 && e_bean2.getRg_8()!=50) {%> selected<%}%>>직접입력</option></select>
                    	<input type="text" name="rg_8" class="num" size="4" id="rg_8_2" value="<%=e_bean2.getRg_8()%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(1, this);'>&nbsp;%<br>&nbsp;
				      	<input type="text" name="rg_8_amt" id="rg_8_amt_2" value='<%=AddUtil.parseDecimal(e_bean2.getRg_8_amt())%>' class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(1, this);'>&nbsp;원
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select id="sel_rg_8_3" name='sel_rg_8' onchange="javascript:setRg_8('3',this.value);">
                   			<option value="0" <%if (e_bean3.getRg_8()==0) {%> selected<%}%>>0</option>
							<option value="10"<%if (e_bean3.getRg_8()==10) {%> selected<%}%>>10</option>
							<option value="15"<%if (e_bean3.getRg_8()==15) {%> selected<%}%>>15</option>
							<option value="20"<%if (e_bean3.getRg_8()==20) {%> selected<%}%>>20</option>
							<option value="25"<%if (e_bean3.getRg_8()==25) {%> selected<%}%>>25</option>
							<option value="30"<%if (e_bean3.getRg_8()==30) {%> selected<%}%>>30</option>
							<option value="35"<%if (e_bean3.getRg_8()==35) {%> selected<%}%>>35</option>
							<option value="40"<%if (e_bean3.getRg_8()==40) {%> selected<%}%>>40</option>
							<option value="50"<%if (e_bean3.getRg_8()==50) {%> selected<%}%>>50</option>
							<option value="directInput"<%if (e_bean3.getRg_8()!= 0 && e_bean3.getRg_8()!=10 && e_bean3.getRg_8()!=15 && e_bean3.getRg_8()!=20 
														 && e_bean3.getRg_8()!=25 && e_bean3.getRg_8()!=30 && e_bean3.getRg_8()!=35 && e_bean3.getRg_8()!=40
														 && e_bean3.getRg_8()!=50) {%> selected<%}%>>직접입력</option></select>
                    	<input type="text" name="rg_8" class="num" size="4" id="rg_8_3" value="<%=e_bean3.getRg_8()%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(2, this);'>&nbsp;%<br>&nbsp;
				      	<input type="text" name="rg_8_amt" id="rg_8_amt_3" value='<%=AddUtil.parseDecimal(e_bean3.getRg_8_amt())%>' class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(2, this);'>&nbsp;원
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select id="sel_rg_8_4" name='sel_rg_8' onchange="javascript:setRg_8('4',this.value);">
                   			<option value="0" <%if (e_bean4.getRg_8()==0) {%> selected<%}%>>0</option>
							<option value="10"<%if (e_bean4.getRg_8()==10) {%> selected<%}%>>10</option>
							<option value="15"<%if (e_bean4.getRg_8()==15) {%> selected<%}%>>15</option>
							<option value="20"<%if (e_bean4.getRg_8()==20) {%> selected<%}%>>20</option>
							<option value="25"<%if (e_bean4.getRg_8()==25) {%> selected<%}%>>25</option>
							<option value="30"<%if (e_bean4.getRg_8()==30) {%> selected<%}%>>30</option>
							<option value="35"<%if (e_bean4.getRg_8()==35) {%> selected<%}%>>35</option>
							<option value="40"<%if (e_bean4.getRg_8()==40) {%> selected<%}%>>40</option>
							<option value="50"<%if (e_bean4.getRg_8()==50) {%> selected<%}%>>50</option>
							<option value="directInput"<%if (e_bean4.getRg_8()!= 0 && e_bean4.getRg_8()!=10 && e_bean4.getRg_8()!=15 && e_bean4.getRg_8()!=20 
														 && e_bean4.getRg_8()!=25 && e_bean4.getRg_8()!=30 && e_bean4.getRg_8()!=35 && e_bean4.getRg_8()!=40
														 && e_bean4.getRg_8()!=50) {%> selected<%}%>>직접입력</option></select>
                    	<input type="text" name="rg_8" class="num" size="4" id="rg_8_4" value="<%=e_bean4.getRg_8()%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(3, this);'>&nbsp;%<br>&nbsp;
				      	<input type="text" name="rg_8_amt" id="rg_8_amt_4" value='<%=AddUtil.parseDecimal(e_bean4.getRg_8_amt())%>' class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(3, this);'>&nbsp;원
                    </td>
                    <td id='equal_condition2' class='equal-condition' style='display: none;' rowspan='14'>견적1과 조건 동일</td>
                	<td id='equal_condition3' class='equal-condition' style='display: none;' rowspan='14'>견적1과 조건 동일</td>
                	<td id='equal_condition4' class='equal-condition' style='display: none;' rowspan='14'>견적1과 조건 동일</td>
                </tr>
                <tr> 
                    <td class=title>선납금</td>
                    <td>
                    	&nbsp;
                      	<input type="text" name="pp_per" id="pp_per_1" class=num size="4" value='<%=e_bean.getPp_per()%>' onBlur="javascript:compare(0, this);set_return2_change();"> %
                      	<br>
                      	&nbsp;
                      	<input type="text" name="pp_amt" id="pp_amt_1" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_return2_change();'> 원
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                        <input type="text" name="pp_per" id="pp_per_2" class=num size="4" value='<%=e_bean2.getPp_per()%>' onBlur="javascript:compare(1, this)"> %
				      	<br>
					    &nbsp;
      					<input type="text" name="pp_amt" id="pp_amt_2" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean2.getPp_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(1, this);'> 원 
      				</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                        <input type="text" name="pp_per" id="pp_per_3" class=num size="4" value='<%=e_bean3.getPp_per()%>' onBlur="javascript:compare(2, this)"> %
      					<br>
      					&nbsp;
      					<input type="text" name="pp_amt" id="pp_amt_3" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean3.getPp_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(2, this);'> 원 
      				</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                        <input type="text" name="pp_per" id="pp_per_4" class=num size="4" value='<%=e_bean4.getPp_per()%>' onBlur="javascript:compare(3, this)"> %
				      	<br>
				    	&nbsp;
					    <input type="text" name="pp_amt" id="pp_amt_4" class=num size="10" value='<%=AddUtil.parseDecimal(e_bean4.getPp_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(3, this);'> 원 
					</td>
                </tr>
                <tr> 
                    <td class=title>개시대여료</td>
                    <td>
                    	&nbsp;
                    	<font color="#666666"> 
                      		<input type="text" name="g_10" id="g_10_1" class=num size="2" value="<%=e_bean.getG_10()%>" onBlur='javascript:set_return2_change(); set_other_esti_value(this);'>
                      		개월치
                      	</font>
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<font color="#666666">
                      		<input type="text" name="g_10" id="g_10_2" class=num size="2" value="<%=e_bean2.getG_10()%>">
            				개월치
           				</font>
           			</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<font color="#666666">
                      		<input type="text" name="g_10" id="g_10_3" class=num size="2" value="<%=e_bean3.getG_10()%>">
            				개월치
            			</font>
            		</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<font color="#666666">
	                      	<input type="text" name="g_10" id="g_10_4" class=num size="2" value="<%=e_bean4.getG_10()%>">
	            			개월치
	            		</font>
	            	</td>
                </tr>
                <tr> 
                    <td rowspan="5" class=title>보험</td>
                    <td class=title>피보험자</td>
                  	<td>
                  		&nbsp;
                  		<select name="ins_per" id="ins_per_1" onchange="javascript:set_disable_value();">
                      		<option value="1" <%if (e_bean.getIns_per().equals("1")) {%>selected<%}%>>아마존카(보험포함)</option>
                      		<%-- <option value="2" <%if (e_bean.getIns_per().equals("2")) {%>selected<%}%> disabled>고객(보험미포함)</option> --%>
                    	</select>
                    </td>
                    <td class='esti_target3'>
                    	&nbsp;
                    	<select name="ins_per" id="ins_per_2">
                          	<option value="1" <%if (e_bean2.getIns_per().equals("1") || e_bean2.getIns_per().equals("")) {%>selected<%}%>>아마존카(보험포함)</option>
                          	<%-- <option value="2" <%if (e_bean2.getIns_per().equals("2")) {%>selected<%}%> disabled>고객(보험미포함)</option> --%>
                      	</select>
                    </td>
                    <td class='esti_target3'>
                    	&nbsp;
                    	<select name="ins_per" id="ins_per_3">
                        	<option value="1" <%if (e_bean.getIns_per().equals("1") || e_bean.getIns_per().equals("")) {%>selected<%}%>>아마존카(보험포함)</option>
                          	<%-- <option value="2" <%if (e_bean.getIns_per().equals("2")) {%>selected<%}%> disabled>고객(보험미포함)</option> --%>
                      	</select>
                    </td>
                    <td class='esti_target3'>
                    	&nbsp;
                    	<select name="ins_per" id="ins_per_4">
                          	<option value="1" <%if (e_bean.getIns_per().equals("1") || e_bean.getIns_per().equals("")) {%>selected<%}%>>아마존카(보험포함)</option>
                          	<%-- <option value="2" <%if (e_bean.getIns_per().equals("2")) {%>selected<%}%> disabled>고객(보험미포함)</option> --%>
                      	</select>
                    </td>
                </tr>
                <tr>
                  	<td class=title>대물/자손</td>
                  	<td>
                  		&nbsp;
                  		<select name="ins_dj" id="ins_dj_1" onchange="javascript:set_disable_value();">
                      		<%-- <option value="1" <%if (e_bean.getIns_dj().equals("1")) {%>selected<%}%>>5천만원/5천만원</option> --%>
                      		<option value="2" <%if (e_bean.getIns_dj().equals("2")) {%>selected<%}%>>1억원/1억원</option>
                      		<option value="4" <%if (e_bean.getIns_dj().equals("4")) {%>selected<%}%>>2억원/1억원</option>
                      		<option value="8" <%if (e_bean.getIns_dj().equals("8")) {%>selected<%}%>>3억원/1억원</option>
                      		<option value="3" <%if (e_bean.getIns_dj().equals("3")) {%>selected<%}%>>5억원/1억원</option>
                    	</select>
                    </td>
                  	<td class='esti_target2'>
                  		&nbsp;
                  		<select name="ins_dj" id="ins_dj_2">
	                        <%-- <option value="1" <%if (e_bean.getIns_dj().equals("1")) {%>selected<%}%>>5천만원/5천만원</option> --%>
	                        <option value="2" <%if (e_bean2.getIns_dj().equals("2") || e_bean2.getIns_dj().equals("")) {%>selected<%}%>>1억원/1억원</option>
	                        <option value="4" <%if (e_bean2.getIns_dj().equals("4")) {%>selected<%}%>>2억원/1억원</option>
	                        <option value="8" <%if (e_bean2.getIns_dj().equals("8")) {%>selected<%}%>>3억원/1억원</option>
	                        <option value="3" <%if (e_bean2.getIns_dj().equals("3")) {%>selected<%}%>>5억원/1억원</option>
                    	</select>
                    </td>
                  	<td class='esti_target esti_target2'>
                  		&nbsp;
                  		<select name="ins_dj" id="ins_dj_3">
	                        <%-- <option value="1" <%if (e_bean.getIns_dj().equals("1")) {%>selected<%}%>>5천만원/5천만원</option> --%>
	                        <option value="2" <%if (e_bean.getIns_dj().equals("2") || e_bean.getIns_dj().equals("")) {%>selected<%}%>>1억원/1억원</option>
	                        <option value="4" <%if (e_bean.getIns_dj().equals("4")) {%>selected<%}%>>2억원/1억원</option>
	                        <option value="8" <%if (e_bean.getIns_dj().equals("8")) {%>selected<%}%>>3억원/1억원</option>
	                        <option value="3" <%if (e_bean.getIns_dj().equals("3")) {%>selected<%}%>>5억원/1억원</option>
                    	</select>
                    </td>
                  	<td class='esti_target esti_target2'>
                  		&nbsp;
                  		<select name="ins_dj" id="ins_dj_4">
	                        <%-- <option value="1" <%if (e_bean.getIns_dj().equals("1")) {%>selected<%}%>>5천만원/5천만원</option> --%>
	                        <option value="2" <%if (e_bean.getIns_dj().equals("2") || e_bean.getIns_dj().equals("")) {%>selected<%}%>>1억원/1억원</option>
	                        <option value="4" <%if (e_bean.getIns_dj().equals("4")) {%>selected<%}%>>2억원/1억원</option>
	                        <option value="8" <%if (e_bean.getIns_dj().equals("8")) {%>selected<%}%>>3억원/1억원</option>
	                        <option value="3" <%if (e_bean.getIns_dj().equals("3")) {%>selected<%}%>>5억원/1억원</option>
	                    </select>
					</td>
                </tr>
                <tr>
                  	<td class=title>운전자연령</td>
                    <td>
                    	&nbsp;
                    	<select name="ins_age" id="ins_age_1" onchange="javascript:set_disable_value();">
		                  	<option value="1" <%if (e_bean.getIns_age().equals("1")) {%>selected<%}%>>만26세이상</option>
		                  	<option value="3" <%if (e_bean.getIns_age().equals("3")) {%>selected<%}%>>만24세이상</option>
		                  	<option value="2" <%if (e_bean.getIns_age().equals("2")) {%>selected<%}%>>만21세이상</option>
                  		</select>
					</td>
                    <td class='esti_target2'>
                    	&nbsp;
                   		<select name="ins_age" id="ins_age_2">
                          	<option value="1" <%if (e_bean2.getIns_age().equals("1") || e_bean2.getIns_age().equals("")) {%>selected<%}%>>만26세이상</option>
                          	<option value="3" <%if (e_bean2.getIns_age().equals("3")) {%>selected<%}%>>만24세이상</option>
                          	<option value="2" <%if (e_bean2.getIns_age().equals("2")) {%>selected<%}%>>만21세이상</option>
                        </select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                   		<select name="ins_age" id="ins_age_3">
                          	<option value="1" <%if (e_bean.getIns_age().equals("1") || e_bean.getIns_age().equals("")) {%>selected<%}%>>만26세이상</option>
                          	<option value="3" <%if (e_bean.getIns_age().equals("3")) {%>selected<%}%>>만24세이상</option>
                          	<option value="2" <%if (e_bean.getIns_age().equals("2")) {%>selected<%}%>>만21세이상</option>
                        </select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="ins_age" id="ins_age_4">
                          	<option value="1" <%if (e_bean.getIns_age().equals("1") || e_bean.getIns_age().equals("")) {%>selected<%}%>>만26세이상</option>
                          	<option value="3" <%if (e_bean.getIns_age().equals("3")) {%>selected<%}%>>만24세이상</option>
                          	<option value="2" <%if (e_bean.getIns_age().equals("2")) {%>selected<%}%>>만21세이상</option>
                        </select>
                    </td>
                </tr>
     
                <tr> 
                    <td class=title>자차면책금</td>
                    <td>
                    	&nbsp;
                    	<input type="text" id="car_ja0"  name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);set_disable_value();'>
          				원
          			</td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<input type="text" id="car_ja1" name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean2.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
            			원
            		</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<input type="text" id="car_ja2" name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
            			원
            		</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<input type="text" id="car_ja3" name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
            			원
            		</td>
                </tr>
            
                <tr> 
                    <td class=title>보증보험</td>
                    <td>
                    	&nbsp;
                      	<input type="text" name="gi_per" id="gi_per_1" class="num gi_per" size="4" disabled value='<%=e_bean.getGi_per()%>' onBlur="javascript:compare(0, this);set_return2_change();" <%if (est_table.equals("esti_spe") && (a_a[0].equals("12") || a_a[0].equals("11"))) {%>readonly<%} else {%><%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>readonly<%}%><%}%>>
                      	%
                      	<br>
                      	&nbsp;
                      	<input type="text" name="gi_amt" id="gi_amt_1" class="num gi_amt" size="10" disabled value='<%=AddUtil.parseDecimal(e_bean.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_return2_change();' <%if (est_table.equals("esti_spe") && (a_a[0].equals("12") || a_a[0].equals("11"))) {%>readonly<%} else {%><%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>readonly<%}%><%}%>>
                      	원
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                        <input type="text" name="gi_per" id="gi_per_2" class="num gi_per" size="4" disabled value='<%=e_bean2.getGi_per()%>' onBlur="javascript:compare(1, this)" <%if (est_table.equals("esti_spe") && (a_a[1].equals("12") || a_a[1].equals("11"))) {%> readonly <%} else {%><%if (e_bean2.getPrint_type().equals("6")) {%><%if (e_bean2.getA_a().equals("12") || e_bean2.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
      					%<br>
				      	&nbsp;
				      	<input type="text" name="gi_amt" id="gi_amt_2" class="num gi_amt" size="10" disabled value='<%=AddUtil.parseDecimal(e_bean2.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(1, this);' <%if (est_table.equals("esti_spe") && (a_a[1].equals("12") || a_a[1].equals("11"))) {%> readonly <%} else {%><%if (e_bean2.getPrint_type().equals("6")) {%><%if (e_bean2.getA_a().equals("12") || e_bean2.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
				      	원
				    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                        <input type="text" name="gi_per" id="gi_per_3" class="num gi_per" size="4" disabled value='<%=e_bean3.getGi_per()%>' onBlur="javascript:compare(2, this)" <%if (est_table.equals("esti_spe") && (a_a[2].equals("12") || a_a[2].equals("11"))) {%> readonly <%} else {%><%if (e_bean3.getPrint_type().equals("6")) {%><%if (e_bean3.getA_a().equals("12") || e_bean3.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
				      	%<br>
				      	&nbsp;
				      	<input type="text" name="gi_amt" id="gi_amt_3" class="num gi_amt" size="10" disabled value='<%=AddUtil.parseDecimal(e_bean3.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(2, this);' <%if (est_table.equals("esti_spe") && (a_a[2].equals("12") || a_a[2].equals("11"))) {%> readonly <%} else {%><%if (e_bean3.getPrint_type().equals("6")) {%><%if (e_bean3.getA_a().equals("12") || e_bean3.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
				      	원
				    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                        <input type="text" name="gi_per" id="gi_per_4" class="num gi_per" size="4" disabled value='<%=e_bean4.getGi_per()%>' onBlur="javascript:compare(3, this)" <%if (est_table.equals("esti_spe") && (a_a[3].equals("12") || a_a[3].equals("11"))) {%> readonly <%} else {%><%if (e_bean4.getPrint_type().equals("6")) {%><%if (e_bean4.getA_a().equals("12") || e_bean4.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
						%<br>
				      	&nbsp;
				      	<input type="text" name="gi_amt" id="gi_amt_4" class="num gi_amt" size="10" disabled value='<%=AddUtil.parseDecimal(e_bean4.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(3, this);' <%if (est_table.equals("esti_spe") && (a_a[3].equals("12") || a_a[3].equals("11"))) {%> readonly <%} else {%><%if (e_bean4.getPrint_type().equals("6")) {%><%if (e_bean4.getA_a().equals("12") || e_bean4.getA_a().equals("11")) {%>readonly<%}%><%} else {%><%}%><%}%>>
				      	원
				    </td>
                </tr>
                
                <%
                	// 경차, 승합/화물차는 임직원한정운전특약 라인 안 보이도록.
//                 	int sh_code_num = 0;
//             		if(!ej_bean.getSh_code().equals("")) sh_code_num = Integer.parseInt(ej_bean.getSh_code());
            		
            		boolean flag1 = false;
//             		if(sh_code_num == 0 || (sh_code_num>1999 && sh_code_num<7000) || (sh_code_num>1999999 && sh_code_num<7000000)) flag1 = true;
            	
					// 임직원 한정운전특약 노출 조건 기존 차종코드에서 차종소분류코드 기준으로 수정. 2021.12.20.
            		int s_st_num = 0;
            		if(!cm_bean.getS_st().equals("")) {
            			s_st_num = Integer.parseInt(cm_bean.getS_st());
            		} else if(!s_st.equals("")){
            			s_st_num = Integer.parseInt(s_st);
            		}
            		
            		if((s_st_num > 101 && s_st_num < 600 && s_st_num != 409)) flag1 = true;
                %>
                <tr id=tr_com_emp_yn style="display:<%if (e_bean.getCom_emp_yn().equals("N") || !flag1 ) {%>none<%} else {%>''<%}%>">
                  	<td colspan='2' class=title><!-- 법인 -->임직원 한정운전특약</td>
                    <td>
                    	&nbsp;
                    	<select name="com_emp_yn" id="com_emp_yn_1" onchange="javascript:set_disable_value();">
                    		<%-- <%if (e_bean.getDoc_type().equals("2")) {%> --%>
                    		<%if (e_bean.getDoc_type().equals("2") && flag1 ) {%>
		                  	<option value="" <%if (e_bean.getCom_emp_yn().equals("")) {%>selected<%}%>>선택</option>
                    		<%}%>
		                  	<option value="N" <%if (e_bean.getCom_emp_yn().equals("N")) {%>selected<%}%>>미가입</option>
                    		<%if( flag1 ){ %>
		                  	<option value="Y" <%if (e_bean.getCom_emp_yn().equals("Y")) {%>selected<%}%>>가입</option>
                    		<%}%>
	                  	</select>                    
	                </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select name="com_emp_yn" id="com_emp_yn_2">
                    		<%-- <%if (e_bean.getDoc_type().equals("2")) {%> --%>
                    		<%if (e_bean.getDoc_type().equals("2") && flag1 ) {%>
		                  	<option value="" <%if (e_bean2.getCom_emp_yn().equals("")) {%>selected<%}%>>선택</option>
                    		<%}%>
                  			<option value="N" <%if (e_bean2.getCom_emp_yn().equals("N")) {%>selected<%}%>>미가입</option>
                  			<%if( flag1 ){ %>
                  			<option value="Y" <%if (e_bean2.getCom_emp_yn().equals("Y")) {%>selected<%}%>>가입</option>
                    		<%}%>
                        </select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="com_emp_yn" id="com_emp_yn_3">
                    		<%-- <%if (e_bean.getDoc_type().equals("2")) {%> --%>
                    		<%if (e_bean.getDoc_type().equals("2") && flag1 ) {%>
		                  	<option value="" <%if (e_bean.getCom_emp_yn().equals("")) {%>selected<%}%>>선택</option>
                    		<%}%>
                  			<option value="N" <%if (e_bean.getCom_emp_yn().equals("N")) {%>selected<%}%>>미가입</option>
                  			<%if( flag1 ){ %>
                  			<option value="Y" <%if (e_bean.getCom_emp_yn().equals("Y")) {%>selected<%}%>>가입</option>
                    		<%}%>
                        </select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="com_emp_yn" id="com_emp_yn_4">
                    		<%-- <%if (e_bean.getDoc_type().equals("2")) {%> --%>
                    		<%if (e_bean.getDoc_type().equals("2") && flag1 ) {%>
		                  	<option value="" <%if (e_bean.getCom_emp_yn().equals("")) {%>selected<%}%>>선택</option>
                    		<%}%>
                  			<option value="N" <%if (e_bean.getCom_emp_yn().equals("N")) {%>selected<%}%>>미가입</option>
                  			<%if( flag1 ){ %>
                  			<option value="Y" <%if (e_bean.getCom_emp_yn().equals("Y")) {%>selected<%}%>>가입</option>
                    		<%}%>
                        </select>
                    </td>
                </tr>
                
                <% 
                	String jg_code = ej_bean.getSh_code(); // 차종코드
                	int jg_code_num = 0;
                	if(!jg_code.equals("")) jg_code_num = Integer.parseInt(jg_code);
                	String car_comp_id = e_bean.getCar_comp_id(); // 제조사
                	int car_comp_id_num = 0;
                	if(!car_comp_id.equals("")) car_comp_id_num = Integer.parseInt(car_comp_id);
                %>
                <tr id="tr_tint_s_yn" <%if (e_bean.getCar_comp_id().equals("0056") || e_bean.getCar_comp_id().equals("0057") || (jg_code_num > 9017300 && jg_code_num < 9018200 ) ) {%>style="display:none;"<%}%>>
                    <td colspan='2' class=title>용품</td>
                    <td>
                    	<%-- &nbsp;
                      	<label><input type="checkbox" name="tint_s_yn" id="tint_s_yn_1" value="Y" <%if (e_bean.getTint_s_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 전면썬팅(기본형)</label>
                      	<br> --%>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_ps_yn" id="tint_ps_yn_1" value="Y" <%if (e_bean.getTint_ps_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 고급썬팅(전면포함)</label>
                      	<select name="setTint_ps_sel" id="setTint_ps_sel_1" onchange="javascript:set_disable_value();">
                      		<option value="Y">견적서표기</option>
                      		<option value="N">견적서미표기</option>
                      		<option value="I">내용직접입력</option>
                      	</select>
                      	<br>
                      	<span style="margin-left:0.9cm;" id="tint_ps_span0"><%if (e_bean.getTint_ps_st().equals("I")) {%> 견적서 표기내용 &nbsp;<%} else {%> FMS표기(참고용)<%}%></span>
                      	<input type="text" id="tint_ps_nm_1" name="tint_ps_nm" value='<%=e_bean.getTint_ps_nm()%>' size="12" class="num" onBlur='javascript:set_disable_value();'><br>
                      	<span style="margin-left:0.9cm;"> 용품점 지급금액(공급가)</span><input type="text" name="tint_ps_amt" id="tint_ps_amt_1" size="6" class="num"
                      	onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);set_disable_value();' value='<%=AddUtil.parseDecimal(e_bean.getTint_ps_amt())%>'> 원
                      	
                      	<span id="tint_sn_yn_div_1" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
	                      	<br>
	                      	&nbsp;
	                      	<label><input type="checkbox" name="tint_sn_yn" id="tint_sn_yn_1" value="Y" <%if (e_bean.getTint_sn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 전면썬팅 미시공 할인</label>
                      	</span>
                      	<span id="tint_bn_yn_div_1" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
	                      	<br>
	                      	&nbsp;
	                      	<label><input type="checkbox" name="tint_bn_yn" id="tint_bn_yn_1" value="Y" <%if (e_bean.getTint_bn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 블랙박스 미제공할인(빌트인캠,고객장착)</label>
                      	</span>
                      	<br>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_cons_yn" id="tint_cons_yn_1" value="Y" <%if (e_bean.getTint_cons_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 추가탁송료등</label>
                      	<input type="text" name="tint_cons_amt" id="tint_cons_amt_1" size="6" class="num" onBlur='javascript:this.value=parseDecimal(this.value); compare(0, this); set_disable_value();' value='<%=AddUtil.parseDecimal(e_bean.getTint_cons_amt())%>'> 원
                      	<br>
                      	&nbsp;
                      	<label 
                      	<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>
                      	> 번호판구분</label>
                      	<select name="new_license_plate" id="new_license_plate_1" onchange="javascript:set_disable_value();" 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>
                      	>
                      		<option value="1" <%if (e_bean.getNew_license_plate().equals("") || e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) {%>selected<%}%>>신형</option>
                      		<option value="0" <%if (e_bean.getNew_license_plate().equals("0")) {%>selected<%}%>>구형(요금할인)</option>
                      		<%-- <option value="" <%if (e_bean.getNew_license_plate().equals("")) {%>selected<%}%>>요청없음</option>
                      		<option value="1" <%if (e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")) {%>selected<%}%>>신청</option> --%>
<%--                       		<option value="1" <%if (e_bean.getNew_license_plate().equals("1")) {%>selected<%}%>>수도권</option> --%>
<%--                       		<option value="2" <%if (e_bean.getNew_license_plate().equals("2")) {%>selected<%}%>>대전/대구/광주/부산</option> --%>
                      	</select>
                      	
                      	<label style="display: none;"><input type="checkbox" name="tint_n_yn" id="tint_n_yn_1" value="Y" <%if (e_bean.getTint_n_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 거치형 내비게이션</label>
                      	<!-- <br>&nbsp; -->
                      	<label style="display: none;"><input type="checkbox" name="tint_eb_yn" id="tint_eb_yn_1" value="Y" <%if (e_bean.getTint_eb_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 이동형 충전기(전기차)</label>
                    </td>
                    
                    <td class='esti_target2'>
                    	<%-- &nbsp;
                      	<label><input type="checkbox" name="tint_s_yn" id="tint_s_yn_2" value="Y" <%if (e_bean2.getTint_s_yn().equals("Y")) {%>checked<%}%>> 전면썬팅(기본형)</label>
                      	<br> --%>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_ps_yn" id="tint_ps_yn_2" value="Y" <%if (e_bean2.getTint_ps_yn().equals("Y")) {%>checked<%}%>> 고급썬팅(전면포함)</label>
                      	<select name="setTint_ps_sel" id="setTint_ps_sel_2" onchange="javascript:setTint_ps('1', this.value);">
	                      	<option value="Y">견적서표기</option>
	                      	<option value="N">견적서미표기</option>
	                      	<option value="I">내용직접입력</option>
                      	</select>
                      	<br>
                      	<span style="margin-left:0.9cm;" id="tint_ps_span1"><%if (e_bean2.getTint_ps_st().equals("I")) {%> 견적서 표기내용 &nbsp;<%} else {%> FMS표기(참고용)<%}%></span>
                      	<input type="text" id="tint_ps_nm_2" name="tint_ps_nm" value='<%=e_bean2.getTint_ps_nm()%>' size="12" class="num"><br>
                      	<span style="margin-left:0.9cm;">용품점 지급금액(공급가)</span><input type="text" name="tint_ps_amt" id="tint_ps_amt_2" size="6" class="num"
                      	onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean2.getTint_ps_amt())%>'> 원
                      	<br>
                      	<span id="tint_sn_yn_div_2" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_sn_yn" id="tint_sn_yn_2" value="Y" <%if (e_bean2.getTint_sn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 전면썬팅 미시공 할인</label>
                      	<br>
                      	</span>
                      	<span id="tint_bn_yn_div_2" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_bn_yn" id="tint_bn_yn_2" value="Y" <%if (e_bean2.getTint_bn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 블랙박스 미제공할인(빌트인캠,고객장착)</label>
                      	<br>
                      	</span>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_cons_yn" id="tint_cons_yn_2" value="Y" <%if (e_bean2 .getTint_cons_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 추가탁송료등</label>
                      	<input type="text" name="tint_cons_amt" id="tint_cons_amt_2" size="6" class="num" onBlur='javascript:this.value=parseDecimal(this.value); compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean2.getTint_cons_amt())%>'> 원
                      	<br>
                      	&nbsp;
                      	<label <%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>
                      	> 번호판구분</label>
                      	<select name="new_license_plate" id="new_license_plate_2" onchange="javascript:set_disable_value();" 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>
                      		>
                      		<option value="1">신형</option>
                      		<option value="0">구형(요금할인)</option>
                      		<!-- <option value="">요청없음</option>
                      		<option value="1">신청</option> -->
<!--                       		<option value="1">수도권</option> -->
<!--                       		<option value="2">대전/대구/광주/부산</option> -->
                      	</select>
                      	
                      	<label style="display: none;"><input type="checkbox" name="tint_n_yn" id="tint_n_yn_2" value="Y" <%if (e_bean2.getTint_n_yn().equals("Y")) {%>checked<%}%>> 거치형 내비게이션</label>
                      	<!-- <br>&nbsp; -->
                      	<label style="display: none;"><input type="checkbox" name="tint_eb_yn" id="tint_eb_yn_2" value="Y" <%if (e_bean2.getTint_eb_yn().equals("Y")) {%>checked<%}%>> 이동형 충전기(전기차)</label>
        			</td>
        			
                    <td class='esti_target esti_target2'>
                    	<%-- &nbsp;
                      	<label><input type="checkbox" name="tint_s_yn" id="tint_s_yn_3" value="Y" <%if (e_bean.getTint_s_yn().equals("Y")) {%>checked<%}%>> 전면썬팅(기본형)</label>
                      	<br> --%>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_ps_yn" id="tint_ps_yn_3" value="Y" <%if (e_bean.getTint_ps_yn().equals("Y")) {%>checked<%}%>> 고급썬팅(전면포함)</label>
                      	<select name="setTint_ps_sel" id="setTint_ps_sel_3" onchange="javascript:setTint_ps('2', this.value);">
	                      	<option value="Y">견적서표기</option>
	                      	<option value="N">견적서미표기</option>
	                      	<option value="I">내용직접입력</option>
                      	</select>
                      	<br>
                      	<span style="margin-left:0.9cm;" id="tint_ps_span2"><%if (e_bean.getTint_ps_st().equals("I")) {%> 견적서 표기내용 &nbsp;<%} else {%> FMS표기(참고용)<%}%></span>
                      	<input type="text" id="tint_ps_nm_3" name="tint_ps_nm" value='<%=e_bean.getTint_ps_nm()%>' size="12" class="num"><br>
                      	<span style="margin-left:0.9cm;">용품점 지급금액(공급가)</span><input type="text" name="tint_ps_amt" id="tint_ps_amt_3" size="6" class="num"
                      	onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean.getTint_ps_amt())%>'> 원
                      	<br>
                      	<span id="tint_sn_yn_div_3" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_sn_yn" id="tint_sn_yn_3" value="Y" <%if (e_bean.getTint_sn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 전면썬팅 미시공 할인</label>
                      	<br>
                      	</span>
                      	<span id="tint_bn_yn_div_3" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_bn_yn" id="tint_bn_yn_3" value="Y" <%if (e_bean.getTint_bn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 블랙박스 미제공할인(빌트인캠,고객장착)</label>
                      	<br>
                      	</span>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_cons_yn" id="tint_cons_yn_3" value="Y" <%if (e_bean.getTint_cons_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 추가탁송료등</label>
                      	<input type="text" name="tint_cons_amt" id="tint_cons_amt_3" size="6" class="num" onBlur='javascript:this.value=parseDecimal(this.value); compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean.getTint_cons_amt())%>'> 원
                      	<br>
                      	&nbsp;
                      	<label 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>> 번호판구분</label>
                      	<select name="new_license_plate" id="new_license_plate_3" onchange="javascript:set_disable_value();" 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>>
                      		<option value="1">신형</option>
                      		<option value="0">구형(요금할인)</option>
                      		<!-- <option value="">요청없음</option>
                      		<option value="1">신청</option> -->
<!--                       		<option value="1">수도권</option> -->
<!--                       		<option value="2">대전/대구/광주/부산</option> -->
                      	</select>
                      	
                      	<label style="display: none;"><input type="checkbox" name="tint_n_yn" id="tint_n_yn_3" value="Y" <%if (e_bean.getTint_n_yn().equals("Y")) {%>checked<%}%>> 거치형 내비게이션</label>
                      	<!-- <br>&nbsp; -->
                      	<label style="display: none;"><input type="checkbox" name="tint_eb_yn" id="tint_eb_yn_3" value="Y" <%if (e_bean.getTint_eb_yn().equals("Y")) {%>checked<%}%>> 이동형 충전기(전기차)</label>
        			</td>
        			
                    <td class='esti_target esti_target2'>
                    	<%-- &nbsp;
                      	<label><input type="checkbox" name="tint_s_yn" id="tint_s_yn_4" value="Y" <%if (e_bean.getTint_s_yn().equals("Y")) {%>checked<%}%>> 전면썬팅(기본형)</label>
                      	<br> --%>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_ps_yn" id="tint_ps_yn_4" value="Y" <%if (e_bean.getTint_ps_yn().equals("Y")) {%>checked<%}%>> 고급썬팅(전면포함)</label>
                      	<select name="setTint_ps_sel" id="setTint_ps_sel_4" onchange="javascript:setTint_ps('3', this.value);">
	                      	<option value="Y">견적서표기</option>
	                      	<option value="N">견적서미표기</option>
	                      	<option value="I">내용직접입력</option>
                      	</select>
                      	<br>
                      	<span style="margin-left:0.9cm;" id="tint_ps_span3"><%if (e_bean.getTint_ps_st().equals("I")) {%> 견적서 표기내용 &nbsp;<%} else {%> FMS표기(참고용)<%}%></span>
                      	<input type="text" id="tint_ps_nm_4" name="tint_ps_nm" value='<%=e_bean.getTint_ps_nm()%>' size="12" class="num"><br>
                      	<span style="margin-left:0.9cm;">용품점 지급금액(공급가)</span><input type="text" name="tint_ps_amt" id="tint_ps_amt_4" size="6" class="num"
                      	onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean.getTint_ps_amt())%>'> 원
                      	<br>
                      	<span id="tint_sn_yn_div_4" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_sn_yn" id="tint_sn_yn_4" value="Y" <%if (e_bean.getTint_sn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 전면썬팅 미시공 할인</label>
                      	<br>
                      	</span>
                      	<span id="tint_bn_yn_div_4" <%if(car_comp_id_num > 5) {%>style="display:none;"<%} %>>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_bn_yn" id="tint_bn_yn_4" value="Y" <%if (e_bean.getTint_bn_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 블랙박스 미제공할인(빌트인캠,고객장착)</label>
                      	<br>
                      	</span>
                      	&nbsp;
                      	<label><input type="checkbox" name="tint_cons_yn" id="tint_cons_yn_4" value="Y" <%if (e_bean.getTint_cons_yn().equals("Y")) {%>checked<%}%> onclick="javascript:set_disable_value();"> 추가탁송료등</label>
                      	<input type="text" name="tint_cons_amt" id="tint_cons_amt_4" size="6" class="num" onBlur='javascript:this.value=parseDecimal(this.value); compare(0, this);' value='<%=AddUtil.parseDecimal(e_bean.getTint_cons_amt())%>'> 원
                      	<br>
                      	&nbsp;
                      	<label 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>> 번호판구분</label>
                      	<select name="new_license_plate" id="new_license_plate_4" onchange="javascript:set_disable_value();" 
                      		<%if ( ( jg_code_num > 9018110 && jg_code_num < 9018999 ) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6") || e_bean.getCar_comp_id().equals("0044") || e_bean.getCar_comp_id().equals("0007") || e_bean.getCar_comp_id().equals("0025") || e_bean.getCar_comp_id().equals("0033") || e_bean.getCar_comp_id().equals("0048")) {%>style="display:none;"<%}%>>
                      		<option value="1">신형</option>
                      		<option value="0">구형(요금할인)</option>
                      		<!-- <option value="">요청없음</option>
                      		<option value="1">신청</option> -->
<!--                       		<option value="1">수도권</option> -->
<!--                       		<option value="2">대전/대구/광주/부산</option> -->
                      	</select>
                      	
                      	<label style="display: none;"><input type="checkbox" name="tint_n_yn" id="tint_n_yn_4" value="Y" <%if (e_bean.getTint_n_yn().equals("Y")) {%>checked<%}%>> 거치형 내비게이션</label>
                      	<!-- <br>&nbsp; -->
                      	<label style="display: none;"><input type="checkbox" name="tint_eb_yn" id="tint_eb_yn_4" value="Y" <%if (e_bean.getTint_eb_yn().equals("Y")) {%>checked<%}%>> 이동형 충전기(전기차)</label>
        			</td>
                </tr>
                
                <%-- <tr id=tr_ecar_loc style="display:<%if (ej_bean.getJg_g_7().equals("3")) {%>''<%} else {%>none<%}%>"> --%> 
                <tr id="tr_ecar_loc" style="display:<%if (ej_bean.getSh_code().equals("5866") || ej_bean.getSh_code().equals("6316111")) {%>none<%} else {%><%if (ej_bean.getJg_g_7().equals("3")) {%><%} else {%>none<%}%><%if ( ej_bean.getJg_g_15() > 0 ) {%><%} else {%>none<%}%><%}%>"> 
                    <td colspan='2' class=title>전기차 고객주소지</td>
                    
				<!-- 20200914 포터일렉트릭, 봉고EV, 모델3 비교견적 관련으로 임시로 나눔(기존 코드는 else) 
				   9133	9015435	포터 일렉트릭
                   9237	9025435	봉고 EV
                   3871	3313111	모델3
				-->
<%-- 				<%if (!(ej_bean.getSh_code().equals("9133") || ej_bean.getSh_code().equals("9237") || ej_bean.getSh_code().equals("3871") || ej_bean.getSh_code().equals("9015435") || ej_bean.getSh_code().equals("9025435") || ej_bean.getSh_code().equals("3313111") || ej_bean.getSh_code().equals("3313112") || ej_bean.getSh_code().equals("3313113") || ej_bean.getSh_code().equals("3313114") || ej_bean.getSh_code().equals("9015436") || ej_bean.getSh_code().equals("9015437") || ej_bean.getSh_code().equals("9025439") || ej_bean.getSh_code().equals("9025440") )) {%> --%>
				<!-- 20210302 전기화물차, 전기화물차 외 전기차 비교견적 관련으로 임시 구분. -->
				<%if ( AddUtil.parseInt(ej_bean.getSh_code()) < 8000000 ){ // 전기화물차 외 전기차%>
                    <td>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_1" onChange="javascript:setLoc_st('0', this.value); set_disable_value(); set_other_esti_value(this);">
							<option value="" <%if (!(e_bean.getEcar_loc_st().equals("4") || e_bean.getEcar_loc_st().equals("5"))) {%>selected<%}%>>선택</option>
						<%for (int i = 0; i < code34_size; i++) {
                            CodeBean code = code34[i];%>
	                       	<option value='<%= code.getNm_cd()%>' 
	                       		<%if ( code.getNm_cd().equals(e_bean.getEcar_loc_st()) ) {%>selected<%}%>
	                       		<%if(code.getNm_cd().equals("12")){ %>style="display: none;"<%} %>
<%-- 	                       		<%if ((e_bean.getEcar_loc_st().equals("0") && code.getNm_cd().equals("0")) || (e_bean.getEcar_loc_st().equals("12") && code.getNm_cd().equals("12")) || (e_bean.getEcar_loc_st().equals("13") && code.getNm_cd().equals("13"))) {%>selected<%}%>  --%>
<%-- 	                       		<%if ( !( code.getNm_cd().equals("0") || code.getNm_cd().equals("12") || code.getNm_cd().equals("13")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
	                       		>
	                       		<%= code.getNm()%>
	                       	</option>
                        <%}%>
                      	</select>
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_2" onChange="javascript:setLoc_st('1', this.value);">
							<option value="" <%if (!(e_bean2.getEcar_loc_st().equals("4") || e_bean2.getEcar_loc_st().equals("5"))) {%>selected<%}%>>선택</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
                        	<option value='<%= code.getNm_cd()%>'
                        		<%if ( code.getNm_cd().equals(e_bean.getEcar_loc_st()) ) {%>selected<%}%> 
                        		<%if(code.getNm_cd().equals("12")){ %>style="display: none;"<%} %>
<%--                         		<%if ((e_bean2.getEcar_loc_st().equals("0") && code.getNm_cd().equals("0")) || (e_bean2.getEcar_loc_st().equals("12") && code.getNm_cd().equals("12")) || (e_bean2.getEcar_loc_st().equals("13") && code.getNm_cd().equals("13"))) {%>selected<%}%>  --%>
<%--                         		<%if ( !( code.getNm_cd().equals("0") || code.getNm_cd().equals("12") || code.getNm_cd().equals("13")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
                        		>
                        		<%= code.getNm()%>
                        	</option>
                       	<%}%>
                      	</select>
					</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_3" onChange="javascript:setLoc_st('2', this.value);">
							<option value="" <%if (!(e_bean.getEcar_loc_st().equals("4") || e_bean.getEcar_loc_st().equals("5"))) {%>selected<%}%>>선택</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
							<option value='<%= code.getNm_cd()%>'
								<%if ( code.getNm_cd().equals(e_bean.getEcar_loc_st()) ) {%>selected<%}%> 
								<%if(code.getNm_cd().equals("12")){ %>style="display: none;"<%} %>
<%-- 							<%if ((e_bean.getEcar_loc_st().equals("0") && code.getNm_cd().equals("0")) || (e_bean.getEcar_loc_st().equals("12") && code.getNm_cd().equals("12")) || (e_bean.getEcar_loc_st().equals("13") && code.getNm_cd().equals("13"))) {%>selected<%}%>  --%>
<%-- 							<%if ( !( code.getNm_cd().equals("0") || code.getNm_cd().equals("12") || code.getNm_cd().equals("13")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
							>
							<%= code.getNm()%>
							</option>
                       	<%}%>
                      	</select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_4" onChange="javascript:setLoc_st('3', this.value);">
							<option value="" <%if (!(e_bean.getEcar_loc_st().equals("4") || e_bean.getEcar_loc_st().equals("5"))) {%>selected<%}%>>선택</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
                        	<option value='<%= code.getNm_cd()%>'
                        		<%if ( code.getNm_cd().equals(e_bean.getEcar_loc_st()) ) {%>selected<%}%> 
                        		<%if(code.getNm_cd().equals("12")){ %>style="display: none;"<%} %>
<%--                         		<%if ((e_bean.getEcar_loc_st().equals("0") && code.getNm_cd().equals("0")) || (e_bean.getEcar_loc_st().equals("12") && code.getNm_cd().equals("12")) || (e_bean.getEcar_loc_st().equals("13") && code.getNm_cd().equals("13"))) {%>selected<%}%>  --%>
<%--                         		<%if ( !( code.getNm_cd().equals("0") || code.getNm_cd().equals("12") || code.getNm_cd().equals("13")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
                        	>
                        	<%= code.getNm()%>
                        	</option>
                       	<%}%>
                      </select>
					</td>
					
				<%} else { // 전기화물차%>
				
					<td>
						&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_1" onChange="javascript:setLoc_st('0', this.value); set_disable_value(); set_other_esti_value(this);">
							<option value="" <%if (!e_bean.getEcar_loc_st().equals("5")) {%>selected<%}%>>선택</option>
						<%for (int i = 0; i < code34_size; i++) {
                            CodeBean code = code34[i];%>
	                       	<option value='<%= code.getNm_cd()%>' 
	                       		<%if (e_bean.getEcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%> 
<%-- 	                       		<%if ( !( code.getNm_cd().equals("1") || code.getNm_cd().equals("4") || code.getNm_cd().equals("5")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
	                       		<%if(code.getNm_cd().equals("12") || code.getNm_cd().equals("13")){ %>style="display: none;"<%} %>
	                       	>
	                       		<%= code.getNm()%>
	                       	</option>
                        <%}%>
                      	</select>
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_2" onChange="javascript:setLoc_st('1', this.value);">
							<option value="" <%if (e_bean2.getEcar_loc_st().equals("")) {%>selected<%}%>>선택</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
                        	<option value='<%= code.getNm_cd()%>' 
                        	<%if (e_bean2.getEcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>
<%--                         	<%if ( !( code.getNm_cd().equals("1") || code.getNm_cd().equals("4") || code.getNm_cd().equals("5")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
                        	<%if(code.getNm_cd().equals("12") || code.getNm_cd().equals("13")){ %>style="display: none;"<%} %>
                        	>
                        		<%= code.getNm()%>
                        	</option>
                       	<%}%>
                      	</select>
					</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_3" onChange="javascript:setLoc_st('2', this.value);">
							<option value="" <%if (e_bean.getEcar_loc_st().equals("")) {%>selected<%}%>>선택</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
							<option value='<%= code.getNm_cd()%>' 
								<%if (e_bean.getEcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>
<%-- 								<%if ( !( code.getNm_cd().equals("1") || code.getNm_cd().equals("4") || code.getNm_cd().equals("5")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
								<%if(code.getNm_cd().equals("12") || code.getNm_cd().equals("13")){ %>style="display: none;"<%} %>
							>
								<%= code.getNm()%>
							</option>
                       	<%}%>
                      	</select>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="ecar_loc_st" id="ecar_loc_st_4" onChange="javascript:setLoc_st('3', this.value);">
							<option value="" <%if (e_bean.getEcar_loc_st().equals("")) {%>selected<%}%>>선택</option>
                   	  	<%for (int i = 0; i < code34_size; i++) {
                           	CodeBean code = code34[i];%>
                        	<option value='<%= code.getNm_cd()%>' 
                        		<%if (e_bean.getEcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>
<%--                         		<%if ( !( code.getNm_cd().equals("1") || code.getNm_cd().equals("4") || code.getNm_cd().equals("5")) ) {%>disabled style="background-color: #E5E5E5;"<%}%> --%>
                        		<%if(code.getNm_cd().equals("12") || code.getNm_cd().equals("13")){ %>style="display: none;"<%} %>
                        	>
                        		<%= code.getNm()%>
                        	</option>
                       	<%}%>
                      </select>
					</td>
					
				<%}%>
                </tr>
                
                <!-- 신규_수소차 -->
                <tr id=tr_hcar_loc style="display:<%if (ej_bean.getJg_g_7().equals("4")) {%>''<%} else {%>none<%}%>"> 
                    <td colspan='2' class=title>수소차 고객주소지</td>
                    <td>
                    	&nbsp;
                    	<select name="hcar_loc_st" id="hcar_loc_st_1" onChange="javascript:setLoc_st('0',this.value); set_other_esti_value(this);">
                    	  	<option value="" <%if (e_bean.getHcar_loc_st().equals(""))%>selected<%%>>선택</option>
                   	  	<%for (int i = 0 ; i < code37_size ; i++) {
                            CodeBean code = code37[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getHcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                        
						</select> 
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select name="hcar_loc_st" id="hcar_loc_st_2" onChange="javascript:setLoc_st('1',this.value);">
                    	  	<option value="" <%if (e_bean2.getHcar_loc_st().equals(""))%>selected<%%>>선택</option>
                   	  	<%for (int i = 0 ; i < code37_size ; i++) {
                            CodeBean code = code37[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean2.getHcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                        
                      	</select> 
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="hcar_loc_st" id="hcar_loc_st_3" onChange="javascript:setLoc_st('2',this.value);">
                    	  	<option value="" <%if (e_bean.getHcar_loc_st().equals(""))%>selected<%%>>선택</option>
                   	  	<%for (int i = 0 ; i < code37_size ; i++) {
                            CodeBean code = code37[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getHcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                        
                   		</select>
                   	</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="hcar_loc_st" id="hcar_loc_st_4" onChange="javascript:setLoc_st('3',this.value);">
                    	  	<option value="" <%if (e_bean.getHcar_loc_st().equals(""))%>selected<%%>>선택</option>
                   	  	<%for (int i = 0 ; i < code37_size ; i++) {
                            CodeBean code = code37[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getHcar_loc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>                        
                      	</select>
					</td>
                </tr>
                
                <!-- 맑은서울스티커 불필요로 주석처리  2021.02.08. -->
		        <%-- <tr id=tr_eco_etag style="display:<%if (ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||
		        		ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")||ej_bean.getJg_g_7().equals("5")) {%>''<%} else {%>none<%}%>"> --%>
		        <%-- <tr id=tr_eco_etag style="display:<%if (ej_bean.getJg_b().equals("3") || ej_bean.getJg_b().equals("4") || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%>''<%} else {%>none<%}%>"> --%>
<%-- 		        <tr id=tr_eco_etag style="display:<%if (ej_bean.getJg_b().equals("3") || ej_bean.getJg_b().equals("4")) {%>''<%} else {%>none<%}%>"> --%>
<!-- 		        	<td colspan='2' class=title> -->
<!-- 		        		맑은서울스티커 발급 -->
<!-- 		        		<br> -->
<!-- 		        		(남산터널 이용 전자태그) -->
<!-- 		        	</td> -->
<!--                     <td> -->
<!--                     	&nbsp; -->
<!--                     	<select name="eco_e_tag" id="eco_e_tag_1" onchange="javascript:set_disable_value();"> -->
<%--                    		<%if (ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%> --%>
<!--         		        	<option value="">선택</option> -->
<!--         		        	<option value="0" selected>미발급</option> -->
<!--                         	<option value="1">발급</option> -->
<%--                    		<%} else {%> --%>
<%--         		        	<option value="" <%if (e_bean.getEco_e_tag().equals("")) {%>selected<%}%>>선택</option> --%>
<%--         		        	<option value="0" <%if (e_bean.getEco_e_tag().equals("0")) {%>selected<%}%>>미발급</option> --%>
<%--                         	<option value="1" <%if (e_bean.getEco_e_tag().equals("1")) {%>selected<%}%>>발급</option> --%>
<%--                    		<%}%> --%>
<!--                       	</select> -->
<!--                       	&nbsp; -->
<!--                       	<textarea class="white_sizeFix" cols="26" rows="2">하이브리드차량 맑은서울&#13;&#10;발급시 서울등록/대여료상승</textarea> -->
<!--                     </td> -->
<!--                     <td> -->
<!--                     	&nbsp; -->
<!--                     	<select name="eco_e_tag" id="eco_e_tag_2"> -->
<%--                     	<%if (ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%> --%>
<!--         		        	<option value="">선택</option> -->
<!--         		        	<option value="0" selected>미발급</option> -->
<!--                         	<option value="1">발급</option> -->
<%--                    		<%} else {%> --%>
<%--         		        	<option value="" <%if (e_bean2.getEco_e_tag().equals("")) {%>selected<%}%>>선택</option> --%>
<%--         		        	<option value="0" <%if (e_bean2.getEco_e_tag().equals("0")) {%>selected<%}%>>미발급</option> --%>
<%--                         	<option value="1" <%if (e_bean2.getEco_e_tag().equals("1")) {%>selected<%}%>>발급</option> --%>
<%--                    		<%}%>                                              --%>
<!--                       	</select> -->
<!-- 						&nbsp; -->
<!-- 						<textarea class="white_sizeFix" cols="26" rows="2">하이브리드차량 맑은서울&#13;&#10;발급시 서울등록/대여료상승</textarea> -->
<!-- 					</td> -->
<!--                     <td> -->
<!--                     	&nbsp; -->
<!--                     	<select name="eco_e_tag" id="eco_e_tag_3"> -->
<%--                     	<%if (ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%> --%>
<!--         		        	<option value="">선택</option> -->
<!--         		        	<option value="0" selected>미발급</option> -->
<!--                         	<option value="1">발급</option> -->
<%--                    		<%} else {%> --%>
<%--         		        	<option value="" <%if (e_bean.getEco_e_tag().equals("")) {%>selected<%}%>>선택</option> --%>
<%--         		        	<option value="0" <%if (e_bean.getEco_e_tag().equals("0")) {%>selected<%}%>>미발급</option> --%>
<%--                         	<option value="1" <%if (e_bean.getEco_e_tag().equals("1")) {%>selected<%}%>>발급</option> --%>
<%--                    		<%}%>                                              --%>
<!--                       	</select> -->
<!--                       	&nbsp; -->
<!--                       	<textarea class="white_sizeFix" cols="26" rows="2">하이브리드차량 맑은서울&#13;&#10;발급시 서울등록/대여료상승</textarea> -->
<!--                     </td> -->
<!--                     <td> -->
<!--                     	&nbsp; -->
<!--                     	<select name="eco_e_tag" id="eco_e_tag_4"> -->
<%--                     	<%if (ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%> --%>
<!--         		        	<option value="">선택</option> -->
<!--         		        	<option value="0" selected>미발급</option> -->
<!--                         	<option value="1">발급</option> -->
<%--                    		<%} else {%> --%>
<%--         		        	<option value="" <%if (e_bean.getEco_e_tag().equals("")) {%>selected<%}%>>선택</option> --%>
<%--         		        	<option value="0" <%if (e_bean.getEco_e_tag().equals("0")) {%>selected<%}%>>미발급</option> --%>
<%--                         	<option value="1" <%if (e_bean.getEco_e_tag().equals("1")) {%>selected<%}%>>발급</option> --%>
<%--                    		<%}%>                                               --%>
<!--                       	</select> -->
<!--                       	&nbsp; -->
<!--                       	<textarea class="white_sizeFix" cols="26" rows="2">하이브리드차량 맑은서울&#13;&#10;발급시 서울등록/대여료상승</textarea> -->
<!-- 					</td> -->
<!-- 		        </tr> -->
		        
                <tr> 
                    <td colspan='2' class=title>차량인도지역</td>
                    <td>
                    	&nbsp;
                    	<select name="loc_st" id="loc_st_1" onchange="javascript:set_disable_value();" <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%} else {%><%}%>>
               	  		<%for (int i = 0 ; i < code33_size ; i++) {
							CodeBean code = code33[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getLoc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                    	<%}%>
                      	</select>
                      	<%-- <span id="loc_st_cmt_1" style="display: <%if (e_bean.getCar_comp_id().equals("0056")) {%>''<%} else {%>none<%}%>; font-size: 10px; letter-spacing: 0px;">서울강서서비스센터에서 교육 후 인도</span> --%>
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select name="loc_st" id="loc_st_2" <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%} else {%><%}%>>
                   	  	<%for (int i = 0 ; i < code33_size ; i++) {
                            CodeBean code = code33[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean2.getLoc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select>
                      <%-- <span id="loc_st_cmt_2" style="display: <%if (e_bean.getCar_comp_id().equals("0056")) {%>''<%} else {%>none<%}%>; font-size: 10px; letter-spacing: 0px;">서울강서서비스센터에서 교육 후 인도</span> --%>
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="loc_st" id="loc_st_3" <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%} else {%><%}%>>
                  	  	<%for (int i = 0 ; i < code33_size ; i++) {
                            CodeBean code = code33[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getLoc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      	</select>
                      	<%-- <span id="loc_st_cmt_3" style="display: <%if (e_bean.getCar_comp_id().equals("0056")) {%>''<%} else {%>none<%}%>; font-size: 10px; letter-spacing: 0px;">서울강서서비스센터에서 교육 후 인도</span> --%>
                    </td>
					<td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select name="loc_st" id="loc_st_4" <%if (e_bean.getCar_comp_id().equals("0056")) {%>disabled<%} else {%><%}%>>
                   	  	<%for (int i = 0 ; i < code33_size ; i++) {
                            CodeBean code = code33[i];%>
                        	<option value='<%= code.getNm_cd()%>' <%if (e_bean.getLoc_st().equals(code.getNm_cd())) {%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      	</select>
                      	<%-- <span id="loc_st_cmt_4" style="display: <%if (e_bean.getCar_comp_id().equals("0056")) {%>''<%} else {%>none<%}%>; font-size: 10px; letter-spacing: 0px;">서울강서서비스센터에서 교육 후 인도</span> --%>
					</td>
                </tr> 
                
			  	<input type="hidden" name="udt_st" value="">
			  	<input type="hidden" name="udt_st" value="">
			  	<input type="hidden" name="udt_st" value="">
			  	<input type="hidden" name="udt_st" value="">
                                  
                <tr> 
                    <td colspan='2' class=title>영업수당</td>
          			<!-- 콤보박스로 수정(2018.03.12) -->
			        <td>
			        	&nbsp;
                    	<select id="sel_o_11_1" onchange="javascript:setO_11('1',this.value);set_return2_change();dir_pur_change();">
                   			<option value="0"<%if (e_bean.getO_11()==0) {%> selected<%}%>>0</option>
							<option value="1.0"<%if (e_bean.getO_11()==1.0) {%> selected<%}%>>1.0</option>
							<option value="2.0"<%if (e_bean.getO_11()==2.0) {%> selected<%}%>>2.0</option>
							<option value="3.0"<%if (e_bean.getO_11()==3.0) {%> selected<%}%>>3.0</option>
							<option value="directInput"<%if (e_bean.getO_11()!=0 && e_bean.getO_11()!=1.0 && e_bean.getO_11()!=2.0 && e_bean.getO_11()!=3.0) {%> selected<%}%>>직접입력</option>
						</select>
                    	<input type="text" name="o_11" class="num" maxlength="3" size="3" id="o_11_1" value="<%=e_bean.getO_11()%>" onBlur='javascript:set_return2_change();dir_pur_change();'>
                    	&nbsp;%<br>&nbsp;
                    </td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	<select id="sel_o_11_2" onchange="javascript:setO_11('2',this.value);dir_pur_change();">
                   			<option value="0"<%if (e_bean2.getO_11()==0) {%> selected<%}%>>0</option>
							<option value="1.0"<%if (e_bean2.getO_11()==1.0) {%> selected<%}%>>1.0</option>
							<option value="2.0"<%if (e_bean2.getO_11()==2.0) {%> selected<%}%>>2.0</option>
							<option value="3.0"<%if (e_bean2.getO_11()==3.0) {%> selected<%}%>>3.0</option>
							<option value="directInput"<%if (e_bean2.getO_11()!=0 && e_bean2.getO_11()!=1.0 && e_bean2.getO_11()!=2.0 && e_bean2.getO_11()!=3.0) {%> selected<%}%>>직접입력</option>
						</select>
                    	<input type="text" name="o_11" class="num" maxlength="3" size="3" id="o_11_2" value="<%=e_bean2.getO_11()%>" onBlur='javascript:dir_pur_change();'>
                    	&nbsp;%<br>&nbsp;
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select id="sel_o_11_3" onchange="javascript:setO_11('3',this.value);dir_pur_change();">
                   			<option value="0"<%if (e_bean3.getO_11()==0) {%> selected<%}%>>0</option>
							<option value="1.0"<%if (e_bean3.getO_11()==1.0) {%> selected<%}%>>1.0</option>
							<option value="2.0"<%if (e_bean3.getO_11()==2.0) {%> selected<%}%>>2.0</option>
							<option value="3.0"<%if (e_bean3.getO_11()==3.0) {%> selected<%}%>>3.0</option>
							<option value="directInput"<%if (e_bean3.getO_11()!=0 && e_bean3.getO_11()!=1.0 && e_bean3.getO_11()!=2.0 && e_bean3.getO_11()!=3.0) {%> selected<%}%>>직접입력</option>
						</select>
                    	<input type="text" name="o_11" class="num" maxlength="3" size="3" id="o_11_3" value="<%=e_bean3.getO_11()%>" onBlur='javascript:dir_pur_change();'>
                    	&nbsp;%<br>&nbsp;
                    </td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	<select id="sel_o_11_4" onchange="javascript:setO_11('4',this.value);dir_pur_change();">
                   			<option value="0"<%if (e_bean4.getO_11()==0) {%> selected<%}%>>0</option>
							<option value="1.0"<%if (e_bean4.getO_11()==1.0) {%> selected<%}%>>1.0</option>
							<option value="2.0"<%if (e_bean4.getO_11()==2.0) {%> selected<%}%>>2.0</option>
							<option value="3.0"<%if (e_bean4.getO_11()==3.0) {%> selected<%}%>>3.0</option>
							<option value="directInput"<%if (e_bean4.getO_11()!=0 && e_bean4.getO_11()!=1.0 && e_bean4.getO_11()!=2.0 && e_bean4.getO_11()!=3.0) {%> selected<%}%>>직접입력</option>
						</select>
                    	<input type="text" name="o_11" class="num" maxlength="3" size="3" id="o_11_4" value="<%=e_bean4.getO_11()%>" onBlur='javascript:dir_pur_change();'>
                    	&nbsp;%<br>&nbsp;
                    </td>
                </tr>                     
                <tr> 
                    <td colspan='2' class=title>대여료D/C</td>
                    <td>
                    	&nbsp;
                    	대여료의
                    	<input type="text" name="fee_dc_per" id="fee_dc_per_1" size="4" value='<%=e_bean.getFee_dc_per()%>' class=num onBlur='javascript:set_return2_change(); set_other_esti_value(this);'>
          				%
          			</td>
                    <td class='esti_target2'>
                    	&nbsp;
                    	대여료의
                      	<input type="text" name="fee_dc_per" id="fee_dc_per_2" size="4" value='<%=e_bean2.getFee_dc_per()%>' class=num>
          				%
          			</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                   		대여료의
                      	<input type="text" name="fee_dc_per" id="fee_dc_per_3" size="4" value='<%=e_bean3.getFee_dc_per()%>' class=num>
          				%
          			</td>
                    <td class='esti_target esti_target2'>
                    	&nbsp;
                    	대여료의
                      	<input type="text" name="fee_dc_per" id="fee_dc_per_4" size="4" value='<%=e_bean4.getFee_dc_per()%>' class=num>
          				%
          			</td>
                </tr>       
            </table>
        </td>
    </tr>
    
    <tr> 
        <td colspan="2"><font color="#666666">* 적용잔가율 : 매입옵션 금액임, 미입력시 최대잔가율로 계산됨</font> </td>
    </tr> 
    
    <tr>
        <td class=h></td>
    </tr>
    
    <tr> 
        <td align=center colspan="2"> 
            <!-- <a id="submitLink" href="javascript:EstiReg();"><img src=/acar/images/center/button_est.gif align=absmiddle border=0></a> -->
            <a id="submitLink" href="javascript:confirmDialog();"><img src=/acar/images/center/button_est.gif align=absmiddle border=0></a>
        </td>
    </tr>
  </form>
</table>
<script>
<!--	

//스폐셜견적에서 연결
<%if (est_table.equals("esti_spe")) {%>
	set_amt();	
<%}%>	
	
<%if (est_table.equals("hp")) {%>
	document.form1.gi_per[0].value = 0; 
	document.form1.gi_amt[0].value = 0;
<%}%>

<%if (!est_table.equals("hp") && e_bean.getGi_amt()>0 && e_bean.getGi_per()==0) {%>
	compare(0, document.form1.gi_amt[0]);
<%}%>

<%if (est_table.equals("esti_spe") && st.equals("2")) { //기본견적시 바로 계산%>
	searchO13(0);
  	EstiRegAuto();
<%}%>

<%if (e_bean.getPrint_type().equals("2") || e_bean.getPrint_type().equals("3") || e_bean.getPrint_type().equals("4") || e_bean.getPrint_type().equals("5")) {%>
	setEst_yn(<%=e_bean.getPrint_type()%>);
<%} else if (e_bean.getPrint_type().equals("6") || e_bean2.getPrint_type().equals("6") || e_bean3.getPrint_type().equals("6") || e_bean4.getPrint_type().equals("6")) {%>
	setEst_yn("6");
<%}%>
	
// 2017.12.22
	
/* $("input[name=tint_s_yn]").on("click", function() {
	$(this + 'input[type=checkbox]:(:checked)').each(function() {
		$(this).attr('checked', true).val('N');
	});
}); */
	
	LocStSet();
	
//차량인도지역 디폴트
function LocStSet() {
	<%  
	if (e_bean.getLoc_st().equals("")) {
		if (br_id.equals("S1")) {    e_bean.setLoc_st("1");
        } else if (br_id.equals("S2")) { e_bean.setLoc_st("1");
        } else if (br_id.equals("S3")) { e_bean.setLoc_st("1");
        } else if (br_id.equals("S4")) { e_bean.setLoc_st("1");
        } else if (br_id.equals("S5")) { e_bean.setLoc_st("1");
        } else if (br_id.equals("S6")) { e_bean.setLoc_st("1");
        } else if (br_id.equals("I1")) { e_bean.setLoc_st("2");
        } else if (br_id.equals("K3")) { e_bean.setLoc_st("2");
        } else if (br_id.equals("D1")) { e_bean.setLoc_st("4");
        } else if (br_id.equals("G1")) { e_bean.setLoc_st("6");
        } else if (br_id.equals("J1")) { e_bean.setLoc_st("5");
        } else if (br_id.equals("B1")) { e_bean.setLoc_st("7");
        } else if (br_id.equals("U1")) { e_bean.setLoc_st("7"); }            
	}
    %>	

	document.form1.loc_st[0].value = <%=e_bean.getLoc_st()%>;
	document.form1.loc_st[1].value = <%=e_bean.getLoc_st()%>;
	document.form1.loc_st[2].value = <%=e_bean.getLoc_st()%>;
	document.form1.loc_st[3].value = <%=e_bean.getLoc_st()%>;
}
	
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>