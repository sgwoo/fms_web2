<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.car_mst.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String jg_g_7 = request.getParameter("jg_g_7")==null?"":request.getParameter("jg_g_7");
	String print_type = request.getParameter("print_type")==null?"":request.getParameter("print_type");
	String garnish_yn_opt_st = request.getParameter("garnish_yn_opt_st")==null?"":request.getParameter("garnish_yn_opt_st");
	String hook_yn_opt_st = request.getParameter("hook_yn_opt_st")==null?"":request.getParameter("hook_yn_opt_st");
	String rent_dt	= request.getParameter("rent_dt")	==null?"":request.getParameter("rent_dt");
	
	if(rent_dt.equals("")){
		rent_dt = AddUtil.getDate(4);
	}else{
		rent_dt = AddUtil.replace(rent_dt,"-","");
	}
	
	if(ck_acar_id.equals("000029")){
		//out.println("rent_dt="+rent_dt);
	}
	
	//System.out.println("print_type >>> " + print_type);
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	/* System.out.println(idx);
	System.out.println(car_comp_id);
	System.out.println(car_cd);
	System.out.println(car_id);
	System.out.println(car_seq);
	System.out.println(a_a); */

	//차종변수별 리스트	
	Vector vars = e_db.getCarSubList(idx, car_comp_id, car_cd, car_id, car_seq, a_a);
	int size = vars.size();
	
	String tmp_jg_tuix_st = "";
	String tmp_lkas_yn = "";
	String tmp_ldws_yn = "";
	String tmp_aeb_yn = "";
	String tmp_fcw_yn = "";
	String tmp_garnish_yn = "";
	String tmp_hook_yn = "";
	
	if (idx.equals("2")) {
		Vector vars2 = e_db.getCarSubList("2_1", car_comp_id, car_cd, car_id, car_seq, a_a);
		for (int v = 0 ; v < vars2.size() ; v++) {
			Hashtable var2 = (Hashtable)vars2.elementAt(v);
			
			tmp_jg_tuix_st = var2.get("JG_TUIX_ST").toString();
			tmp_lkas_yn = var2.get("LKAS_YN").toString();
			tmp_ldws_yn = var2.get("LDWS_YN").toString();
			tmp_aeb_yn = var2.get("AEB_YN").toString();
			tmp_fcw_yn = var2.get("FCW_YN").toString();
			tmp_garnish_yn = var2.get("GARNISH_YN").toString();
			tmp_hook_yn = var2.get("HOOK_YN").toString();
			
			/* System.out.println("tmp_jg_tuix_st >>>> " + tmp_jg_tuix_st);
			System.out.println("tmp_lkas_yn >>>> " + tmp_lkas_yn);
			System.out.println("tmp_ldws_yn >>>> " + tmp_ldws_yn);
			System.out.println("tmp_aeb_yn >>>> " + tmp_aeb_yn);
			System.out.println("tmp_fcw_yn >>>> " + tmp_fcw_yn); */
		}
	}
	
	//tuix/tuon 카운트
	int tuix_count = 0;
	
	//과세차가표기차량 카운트
	int duty_free_count = 0;
	int duty_free_count2 = 0;
	if(idx.equals("1")){		
		for(int z = 0 ; z < size ; z++){
			Hashtable temp_var = (Hashtable)vars.elementAt(z);
			
			if (temp_var.get("DUTY_FREE_OPT").equals("0")) {
				duty_free_count++;
			}
			if (temp_var.get("DUTY_FREE_OPT").equals("1")) {
				duty_free_count2++;
			}
		}
	}
	
	if(idx.equals("4") && size==0){
		//vars = e_db.getCarSubList("4_2", car_comp_id, car_cd, car_id, car_seq, a_a);
		//size = vars.size();		
	}
	
	
	if(idx.equals("2")||idx.equals("3")){
		//차명정보
		cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
		//차종변수
		ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	}
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<style>
.parent-title {
    color:#494949;
    font-weight:bold;
    margin-left:8px;
}
.default-title {
	color:#f23053;
	font-weight:bold;
}
.parent-desc {
	font-weight:bold;
	line-height:25px;
}
p {
	margin:5px auto 20px;
}

#tuix {
    font-family: sans-serif, Gulim, AppleGothic, Seoul, Arial;
    cursor: pointer;
    font-weight: bold;
    font-size: 12px;
    padding: 3px 3px 3px 3px;
    background-color: #848484;
    color: #FFF;
    width: 140px;
    height: 17px;
    text-align: center;
    vertical-align: middle;
    margin-left: 10px;
}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function setCodeDir(){		
		var ofm = opener.document.form1;
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;		
		
		<%if(idx.equals("2")){%>
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_s_seq"){		
				if(ck.checked == true){
					cnt++;
				}
			}
		}
		
		if(cnt == 0){
			ofm.opt.value 		= fm.dir_nm.value;
			ofm.opt_seq.value 	= '';
			ofm.opt_amt.value 	= fm.dir_amt.value;			
			ofm.opt_amt_m.value 	= "";			
			ofm.jg_opt_st.value 	= '';	
			ofm.jg_tuix_opt_st.value 	= '';	
		}else{
			save();
		}
					
		<%}else if(idx.equals("3")){%>
		ofm.col.value 		= fm.dir_nm.value;
		ofm.in_col.value	= fm.dir_nm2.value;
		ofm.col_seq.value 	= '';
		ofm.col_amt.value 	= fm.dir_amt.value;				
		ofm.jg_col_st.value 	= '';	
		<%}%>
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));
				
		self.close();				
	}	
	
	function setCode(id, seq, nm, amt, s_st, jg_code, jg_f, jg_g, jg_3, jg_w, jg_h, jg_i, jg_b, jg_opt_st, jg_g_7, end_dt, jg_tuix_st, lkas_yn, ldws_yn, aeb_yn, fcw_yn, car_etc, car_etc2, car_b_p2, duty_free_opt, jg_opt_yn, garnish_yn, hook_yn, jg_g_15) {
		var fm = opener.document.form1;
		
		var car_comp_id = '<%=car_comp_id%>';
		
		<%if (idx.equals("1")) {%>
		if (end_dt == 'N') {
			if(!confirm('이 차종은 단산된 차종으로 재고 확인 바랍니다.')){	return;	}	
		}
		
		var param_jg_g_7 = document.form1.jg_g_7.value;
		
		fm.jg_code.value = jg_code;	
		fm.car_name.value = nm;
		fm.car_id.value = id;
		fm.car_seq.value = seq;
		fm.car_amt.value = parseDecimal(amt);
		fm.s_st.value = s_st;				
		fm.opt.value = '';
		fm.opt_seq.value = '';
		fm.opt_amt.value = '0';		
		fm.opt_amt_m.value = '0';		
		fm.jg_opt_st.value = '';	
		fm.col.value = '';
		fm.col_seq.value = '';
		fm.col_amt.value = '0';		
		fm.in_col.value = '';
		fm.garnish_col.value = '';
		fm.jg_col_st.value = '';	
		fm.dc.value = '';
		fm.dc_seq.value = '';
		fm.dc_amt.value = '0';
		fm.dc_amt2.value = '0';
		fm.esti_d_etc.value = '';
		fm.ls_yn.value = '';		
		fm.jg_g_7.value = jg_g_7;
		fm.tax_dc_amt.value = 0;
		fm.conti_rat.value = '';
		fm.conti_rat_seq.value = '';
		fm.duty_free_opt.value = duty_free_opt;
		fm.jg_g_15.value = jg_g_15;
		
		//수입차일경우
		<%if(AddUtil.parseInt(car_comp_id) > 5){%>
			fm.car_b_p2.value = parseDecimal(car_b_p2);
    	<%}%>
				
    	// 2021.01.13. 차종코드 > 8000000(승합차/화물차)이거나 전기차/수소차일 경우 신형번호판 신청 항목 안 보이도록 처리.
		// 일본 수입차 추가
		// 2021.11.03. 승합/화물차 신형번호판 신청 가능. 메가트럭 제외.
		if( ( Number(jg_code) > 9018110 && Number(jg_code) < 9018999 ) 
				|| Number(jg_b) == 5 || Number(jg_b) == 6 
				|| car_comp_id == '0044' || car_comp_id=='0007' || car_comp_id=='0025' || car_comp_id=='0033' || car_comp_id=='0048' 
			){
			fm.new_license_plate[0].style.display = 'none';
			fm.new_license_plate[1].style.display = 'none';
			fm.new_license_plate[2].style.display = 'none';
			fm.new_license_plate[3].style.display = 'none';
			fm.new_license_plate[0].previousElementSibling.style.display = 'none';
			fm.new_license_plate[1].previousElementSibling.style.display = 'none';
			fm.new_license_plate[2].previousElementSibling.style.display = 'none';
			fm.new_license_plate[3].previousElementSibling.style.display = 'none';
			// 20210304 신형번호판 기본값 '신청'으로 수정하여 승합/화물차, 전기/수소차 기본값 구형번호판으로 변경. 
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
    	
		/* if(jg_g_7=='1' || jg_g_7=='2' || jg_g_7=='3' || jg_g_7=='4'){ */
		//테슬라 추가로 친환경차 구분에서 엔진종류로 변경
		if (Number(jg_b) >= 3){
			opener.tr_ecar_tax.style.display = '';
			//20200506 전기차 및 수소차일 경우 맑은서울스티커 미발급
			// 2021.02.08. 맑은서울스티커 불필요로 주석 처리.
			/* if (Number(jg_b) == 5 || Number(jg_b) == 6) {
				opener.tr_eco_etag.style.display = 'none';
			} else {
				opener.tr_eco_etag.style.display = '';
			}
			fm.eco_e_tag[0].options[1].selected = true;
			fm.eco_e_tag[1].options[1].selected = true;
			fm.eco_e_tag[2].options[1].selected = true;
			fm.eco_e_tag[3].options[1].selected = true; */
		} else {
			opener.tr_ecar_tax.style.display = 'none';
			// opener.tr_eco_etag.style.display = 'none';
			/* fm.eco_e_tag[0].options[0].selected = true;
			fm.eco_e_tag[1].options[0].selected = true;
			fm.eco_e_tag[2].options[0].selected = true;
			fm.eco_e_tag[3].options[0].selected = true; */
		}
		
		fm.ecar_loc_st[0].options[0].selected = true;
		fm.ecar_loc_st[1].options[0].selected = true;
		fm.ecar_loc_st[2].options[0].selected = true;
		fm.ecar_loc_st[3].options[0].selected = true;
		
		//20200313 포터 일렉트릭, 봉고 EV 대구만 선택가능, 그 외에는 원래대로
		autoEcarLocationDisSel(jg_g_7, jg_code);
		
		// 수입차는 용품란 - 전면썬팅 미시공 할인 항목 안 보이도록.
		if(Number(car_comp_id) > 5){
			opener.tint_sn_yn_div_1.style.display = "none";
			opener.tint_sn_yn_div_2.style.display = "none";
			opener.tint_sn_yn_div_3.style.display = "none";
			opener.tint_sn_yn_div_4.style.display = "none";
			opener.tint_sn_yn_1.checked = false;
			opener.tint_sn_yn_2.checked = false;
			opener.tint_sn_yn_3.checked = false;
			opener.tint_sn_yn_4.checked = false;
			
			// 수입차는 블랙박스 미제공할인 항목 미노출 20211028
			opener.tint_bn_yn_div_1.style.display = "none";
			opener.tint_bn_yn_div_2.style.display = "none";
			opener.tint_bn_yn_div_3.style.display = "none";
			opener.tint_bn_yn_div_4.style.display = "none";
			opener.tint_bn_yn_1.checked = false;
			opener.tint_bn_yn_2.checked = false;
			opener.tint_bn_yn_3.checked = false;
			opener.tint_bn_yn_4.checked = false;
			
		} else {
			// 전면썬팅 미시공 할인
			opener.tint_sn_yn_div_1.style.display = "inline";
			opener.tint_sn_yn_div_2.style.display = "inline";
			opener.tint_sn_yn_div_3.style.display = "inline";
			opener.tint_sn_yn_div_4.style.display = "inline";
			
			// 블랙박스 미제공 할인
			opener.tint_bn_yn_div_1.style.display = "inline";
			opener.tint_bn_yn_div_2.style.display = "inline";
			opener.tint_bn_yn_div_3.style.display = "inline";
			opener.tint_bn_yn_div_4.style.display = "inline";
		}
		
		if (jg_g_7 == "3") {
						
			opener.tr_hcar_loc.style.display	= 'none';
			fm.loc_st[0].options[0].selected = true;
			fm.loc_st[1].options[0].selected = true;
			fm.loc_st[2].options[0].selected = true;
			fm.loc_st[3].options[0].selected = true;
			
			if (car_comp_id == "0056" || car_comp_id == '0057'){
				//용품
				opener.tr_tint_s_yn.style.display = "none";
				
				//전면선팅
				$(opener.document).find("#tint_s_yn_1").prop("checked", false);
				$(opener.document).find("#tint_s_yn_2").prop("checked", false);
				$(opener.document).find("#tint_s_yn_3").prop("checked", false);
				$(opener.document).find("#tint_s_yn_4").prop("checked", false);
				
				//전면썬팅 미시공 할인
				$(opener.document).find("#tint_sn_yn_1").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_2").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_3").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_4").prop("checked", false);
				
				//고급썬팅 - 체크박스
				$(opener.document).find("#tint_ps_yn_1").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_2").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_3").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_4").prop("checked", false);
				
				//고급썬팅 - 견적서표기 셀렉트박스
				$(opener.document).find("#setTint_ps_sel_1 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_2 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_3 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_4 option[value='Y']").attr("selected", 'selected');
				
				//고급썬팅 - FMS표기
				$(opener.document).find("#tint_ps_nm_1").val("");
				$(opener.document).find("#tint_ps_nm_2").val("");
				$(opener.document).find("#tint_ps_nm_3").val("");
				$(opener.document).find("#tint_ps_nm_4").val("");
				
				//고급썬팅 - 추가금액
				$(opener.document).find("#tint_ps_amt_1").val("0");
				$(opener.document).find("#tint_ps_amt_2").val("0");
				$(opener.document).find("#tint_ps_amt_3").val("0");
				$(opener.document).find("#tint_ps_amt_4").val("0");
								
				//거치형네비게이션
				$(opener.document).find("#tint_n_yn_1").prop("checked", false);
				$(opener.document).find("#tint_n_yn_2").prop("checked", false);
				$(opener.document).find("#tint_n_yn_3").prop("checked", false);
				$(opener.document).find("#tint_n_yn_4").prop("checked", false);
								
				//블랙박스 미제공 할인 (빌트인캠,고객장착..)
				$(opener.document).find("#tint_bn_yn_1").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_2").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_3").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_4").prop("checked", false);
				
				//신형표지판신청 셀렉트박스
				$(opener.document).find("#new_license_plate_1 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_2 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_3 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_4 option[value='']").attr("selected", 'selected');
				
				//추가탁송료 선택
				$(opener.document).find("#tint_cons_yn_1").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_2").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_3").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_4").prop("checked", false);
				
				//추가탁송료 금액
				$(opener.document).find("#tint_cons_amt_1").val("0");
				$(opener.document).find("#tint_cons_amt_2").val("0");
				$(opener.document).find("#tint_cons_amt_3").val("0");
				$(opener.document).find("#tint_cons_amt_4").val("0");
				
				//이동형충전기(전기차)
				$(opener.document).find("#tint_eb_yn_1").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_2").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_3").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_4").prop("checked", false);
				
				if (jg_code == "5866" || jg_code == "6316111") {
					//전기차고객주소지
					opener.tr_ecar_loc.style.display	= "none";
				} else {
					//전기차고객주소지
					opener.tr_ecar_loc.style.display = "";
				}
				
				//차량인도지역0번만-나머지는 esti_mng_atype_i 에서 진행
				fm.loc_st[0].disabled = false;
				
				//서울강서서비스센터에서 교육 후 인도 - 임시주석 20190821
				/* opener.loc_st_cmt_1.style.display = "";
				opener.loc_st_cmt_2.style.display = "";
				opener.loc_st_cmt_3.style.display = "";
				opener.loc_st_cmt_4.style.display = ""; */
				
			} else {
				opener.tr_tint_s_yn.style.display = "";
				opener.tr_ecar_loc.style.display	= "";
				
				//차량인도지역0번만-나머지는 esti_mng_atype_i 에서 진행
				fm.loc_st[0].disabled = false;
				
				//서울강서서비스센터에서 교육 후 인도 - 임시주석 20190821
				/* opener.loc_st_cmt_1.style.display = "none";
				opener.loc_st_cmt_2.style.display = "none";
				opener.loc_st_cmt_3.style.display = "none";
				opener.loc_st_cmt_4.style.display = "none"; */
			}
			
			if( jg_g_15 > 0 ){
				opener.tr_ecar_loc.style.display	= '';
			} else {
				opener.tr_ecar_loc.style.display	= 'none';
				// 정부보조금 0원인 전기차 견적 시 전기차 고객주소지 보조금 없는 견적으로 임시 등록. 2022.01.25
				$(opener.document).find("#ecar_loc_st_1 option[value='13']").prop("selected", true);
				$(opener.document).find("#ecar_loc_st_2 option[value='13']").prop("selected", true);
				$(opener.document).find("#ecar_loc_st_3 option[value='13']").prop("selected", true);
				$(opener.document).find("#ecar_loc_st_4 option[value='13']").prop("selected", true);
			}
			
		} else if (jg_g_7 == '4') {
			
			opener.tr_ecar_loc.style.display	= 'none';
			opener.tr_hcar_loc.style.display	= '';
			opener.tr_tint_s_yn.style.display = "";
			fm.loc_st[0].options[0].selected = true;
			fm.loc_st[1].options[0].selected = true;
			fm.loc_st[2].options[0].selected = true;
			fm.loc_st[3].options[0].selected = true;
			
			//차량인도지역0번만-나머지는 esti_mng_atype_i 에서 진행
			fm.loc_st[0].disabled = false;
			
			//서울강서서비스센터에서 교육 후 인도
			/* opener.loc_st_cmt_1.style.display = "none";
			opener.loc_st_cmt_2.style.display = "none";
			opener.loc_st_cmt_3.style.display = "none";
			opener.loc_st_cmt_4.style.display = "none"; */
			
		} else {
			opener.tr_ecar_loc.style.display	= 'none';
			opener.tr_hcar_loc.style.display	= 'none';
			opener.tr_tint_s_yn.style.display = "";
			//차량인도지역0번만-나머지는 esti_mng_atype_i 에서 진행
			fm.loc_st[0].disabled = false;
			
			//서울강서서비스센터에서 교육 후 인도
			/* opener.loc_st_cmt_1.style.display = "none";
			opener.loc_st_cmt_2.style.display = "none";
			opener.loc_st_cmt_3.style.display = "none";
			opener.loc_st_cmt_4.style.display = "none"; */
			
			// 마이티/메가트럭 용품란 display: none 처리
			if ( Number(jg_code) > 9017300 && Number(jg_code) < 9018200 ){
				//용품
				opener.tr_tint_s_yn.style.display = "none";
				
				//전면선팅
				$(opener.document).find("#tint_s_yn_1").prop("checked", false);
				$(opener.document).find("#tint_s_yn_2").prop("checked", false);
				$(opener.document).find("#tint_s_yn_3").prop("checked", false);
				$(opener.document).find("#tint_s_yn_4").prop("checked", false);
				
				//전면썬팅 미시공 할인
				$(opener.document).find("#tint_sn_yn_1").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_2").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_3").prop("checked", false);
				$(opener.document).find("#tint_sn_yn_4").prop("checked", false);
				
				//고급썬팅 - 체크박스
				$(opener.document).find("#tint_ps_yn_1").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_2").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_3").prop("checked", false);
				$(opener.document).find("#tint_ps_yn_4").prop("checked", false);
				
				//고급썬팅 - 견적서표기 셀렉트박스
				$(opener.document).find("#setTint_ps_sel_1 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_2 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_3 option[value='Y']").attr("selected", 'selected');
				$(opener.document).find("#setTint_ps_sel_4 option[value='Y']").attr("selected", 'selected');
				
				//고급썬팅 - FMS표기
				$(opener.document).find("#tint_ps_nm_1").val("");
				$(opener.document).find("#tint_ps_nm_2").val("");
				$(opener.document).find("#tint_ps_nm_3").val("");
				$(opener.document).find("#tint_ps_nm_4").val("");
				
				//고급썬팅 - 추가금액
				$(opener.document).find("#tint_ps_amt_1").val("0");
				$(opener.document).find("#tint_ps_amt_2").val("0");
				$(opener.document).find("#tint_ps_amt_3").val("0");
				$(opener.document).find("#tint_ps_amt_4").val("0");
								
				//거치형네비게이션
				$(opener.document).find("#tint_n_yn_1").prop("checked", false);
				$(opener.document).find("#tint_n_yn_2").prop("checked", false);
				$(opener.document).find("#tint_n_yn_3").prop("checked", false);
				$(opener.document).find("#tint_n_yn_4").prop("checked", false);
								
				//블랙박스 미제공 할인 (빌트인캠,고객장착..)
				$(opener.document).find("#tint_bn_yn_1").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_2").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_3").prop("checked", false);
				$(opener.document).find("#tint_bn_yn_4").prop("checked", false);
				
				//신형표지판신청 셀렉트박스
				$(opener.document).find("#new_license_plate_1 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_2 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_3 option[value='']").attr("selected", 'selected');
				$(opener.document).find("#new_license_plate_4 option[value='']").attr("selected", 'selected');
				
				//추가탁송료 선택
				$(opener.document).find("#tint_cons_yn_1").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_2").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_3").prop("checked", false);
				$(opener.document).find("#tint_cons_yn_4").prop("checked", false);
				
				//추가탁송료 금액
				$(opener.document).find("#tint_cons_amt_1").val("0");
				$(opener.document).find("#tint_cons_amt_2").val("0");
				$(opener.document).find("#tint_cons_amt_3").val("0");
				$(opener.document).find("#tint_cons_amt_4").val("0");
				
				//이동형충전기(전기차)
				$(opener.document).find("#tint_eb_yn_1").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_2").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_3").prop("checked", false);
				$(opener.document).find("#tint_eb_yn_4").prop("checked", false);
				
			}
			
			opener.LocStSet();			
		}		
	    	
    	$(opener.document).find("#ro_13_0_display_1").css("display", "");
    	$(opener.document).find("#ro_13_0_display_2").css("display", "none");
    	
    	$(opener.document).find("#ro_13_1_display_1").css("display", "");
    	$(opener.document).find("#ro_13_1_display_2").css("display", "none");
    	
    	$(opener.document).find("#ro_13_2_display_1").css("display", "");
    	$(opener.document).find("#ro_13_2_display_2").css("display", "none");
    	
    	$(opener.document).find("#ro_13_3_display_1").css("display", "");
    	$(opener.document).find("#ro_13_3_display_2").css("display", "none");
		
		if (car_comp_id == "0056") {
				
			$(opener.document).find("#sel_a_b_1 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_2 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_3 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_4 option[value='48']").prop("selected", "selected");
			
			$(opener.document).find("#a_b_1").val("48");
			$(opener.document).find("#a_b_2").val("48");
			$(opener.document).find("#a_b_3").val("48");
			$(opener.document).find("#a_b_4").val("48");					
			
			$(opener.document).find("#sel_a_b_1 option[value='48']").prop("disabled", false);
			//$(opener.document).find("#sel_a_b_1 option[value='60']").prop("disabled", true);		// 테슬라 차량 대여 기간 제한 없음. 일반 차량과 동일. 2021.02.15.
			//$(opener.document).find("#sel_a_b_1 option[value='directInput']").prop("disabled", true);					
			$(opener.document).find("#sel_a_b_2 option[value='48']").prop("disabled", false);
			//$(opener.document).find("#sel_a_b_2 option[value='60']").prop("disabled", true);		// 테슬라 차량 대여 기간 제한 없음. 일반 차량과 동일. 2021.02.15.
			//$(opener.document).find("#sel_a_b_2 option[value='directInput']").prop("disabled", true);					
			$(opener.document).find("#sel_a_b_3 option[value='48']").prop("disabled", false);
			//$(opener.document).find("#sel_a_b_3 option[value='60']").prop("disabled", true);		// 테슬라 차량 대여 기간 제한 없음. 일반 차량과 동일. 2021.02.15.
			//$(opener.document).find("#sel_a_b_3 option[value='directInput']").prop("disabled", true);					
			$(opener.document).find("#sel_a_b_4 option[value='48']").prop("disabled", false);
			//$(opener.document).find("#sel_a_b_4 option[value='60']").prop("disabled", true);		// 테슬라 차량 대여 기간 제한 없음. 일반 차량과 동일. 2021.02.15.
			//$(opener.document).find("#sel_a_b_4 option[value='directInput']").prop("disabled", true);
			
			//대여기간 input
			// 테슬라 차량 대여 기간 제한 없음. 일반 차량과 동일. 2021.02.15.
			//$(opener.document).find("#a_b_1").attr("readonly", true);
			//$(opener.document).find("#a_b_2").attr("readonly", true);
			//$(opener.document).find("#a_b_3").attr("readonly", true);
			//$(opener.document).find("#a_b_4").attr("readonly", true);
			
			//주행거리 selectbox
			/* $(opener.document).find("#sel_agree_dist_1 option[value='35000']").hide();
			$(opener.document).find("#sel_agree_dist_1 option[value='40000']").hide();
			$(opener.document).find("#sel_agree_dist_1 option[value='45000']").hide();
			$(opener.document).find("#sel_agree_dist_1 option[value='50000']").hide();
			$(opener.document).find("#sel_agree_dist_2 option[value='35000']").hide();
			$(opener.document).find("#sel_agree_dist_2 option[value='40000']").hide();
			$(opener.document).find("#sel_agree_dist_2 option[value='45000']").hide();
			$(opener.document).find("#sel_agree_dist_2 option[value='50000']").hide();
			$(opener.document).find("#sel_agree_dist_3 option[value='35000']").hide();
			$(opener.document).find("#sel_agree_dist_3 option[value='40000']").hide();
			$(opener.document).find("#sel_agree_dist_3 option[value='45000']").hide();
			$(opener.document).find("#sel_agree_dist_3 option[value='50000']").hide();
			$(opener.document).find("#sel_agree_dist_4 option[value='35000']").hide();
			$(opener.document).find("#sel_agree_dist_4 option[value='40000']").hide();
			$(opener.document).find("#sel_agree_dist_4 option[value='45000']").hide();
			$(opener.document).find("#sel_agree_dist_4 option[value='50000']").hide(); */
			
			/* $(opener.document).find("#sel_agree_dist_1 option[value='35000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_1 option[value='40000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_1 option[value='45000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_1 option[value='50000']").prop("disabled", true); */
			// $(opener.document).find("#sel_agree_dist_1 option[value='directInput']").prop("disabled", true); 	// 테슬라 차량 적용약정운행거리 직접입력 허용(10000~30000) 2021.02.15.
			/* $(opener.document).find("#sel_agree_dist_2 option[value='35000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_2 option[value='40000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_2 option[value='45000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_2 option[value='50000']").prop("disabled", true); */
			// $(opener.document).find("#sel_agree_dist_2 option[value='directInput']").prop("disabled", true);		// 테슬라 차량 적용약정운행거리 직접입력 허용(10000~30000) 2021.02.15.
			/* $(opener.document).find("#sel_agree_dist_3 option[value='35000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_3 option[value='40000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_3 option[value='45000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_3 option[value='50000']").prop("disabled", true); */
			// $(opener.document).find("#sel_agree_dist_3 option[value='directInput']").prop("disabled", true);		// 테슬라 차량 적용약정운행거리 직접입력 허용(10000~30000) 2021.02.15.
			/* $(opener.document).find("#sel_agree_dist_4 option[value='35000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_4 option[value='40000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_4 option[value='45000']").prop("disabled", true);
			$(opener.document).find("#sel_agree_dist_4 option[value='50000']").prop("disabled", true); */
			// $(opener.document).find("#sel_agree_dist_4 option[value='directInput']").prop("disabled", true);		// 테슬라 차량 적용약정운행거리 직접입력 허용(10000~30000) 2021.02.15.		
			
			//주행거리 input
			// 테슬라 차량 적용약정운행거리 직접입력 허용(10000~30000) 2021.02.15.
			//$(opener.document).find("#agree_dist_1").attr("readonly", true);
			//$(opener.document).find("#agree_dist_2").attr("readonly", true);
			//$(opener.document).find("#agree_dist_3").attr("readonly", true);
			//$(opener.document).find("#agree_dist_4").attr("readonly", true);
			
			//적용잔가 text
			$(opener.document).find("#ro_13_0_display_3").css("display", "");
			$(opener.document).find("#ro_13_1_display_3").css("display", "");
			$(opener.document).find("#ro_13_2_display_3").css("display", "");
			$(opener.document).find("#ro_13_3_display_3").css("display", "");				
			
		} else {
			
			//대여기간 selectbox
			$(opener.document).find("#sel_a_b_1 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_2 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_3 option[value='48']").prop("selected", "selected");
			$(opener.document).find("#sel_a_b_4 option[value='48']").prop("selected", "selected");
			
			$(opener.document).find("#a_b_1").val("48");
			$(opener.document).find("#a_b_2").val("48");
			$(opener.document).find("#a_b_3").val("48");
			$(opener.document).find("#a_b_4").val("48");
			
			$(opener.document).find("#sel_agree_dist_1 option[value='35000']").show();
			$(opener.document).find("#sel_agree_dist_1 option[value='40000']").show();
			$(opener.document).find("#sel_agree_dist_1 option[value='45000']").show();
			$(opener.document).find("#sel_agree_dist_1 option[value='50000']").show();
			$(opener.document).find("#sel_agree_dist_2 option[value='35000']").show();
			$(opener.document).find("#sel_agree_dist_2 option[value='40000']").show();
			$(opener.document).find("#sel_agree_dist_2 option[value='45000']").show();
			$(opener.document).find("#sel_agree_dist_2 option[value='50000']").show();
			$(opener.document).find("#sel_agree_dist_3 option[value='35000']").show();
			$(opener.document).find("#sel_agree_dist_3 option[value='40000']").show();
			$(opener.document).find("#sel_agree_dist_3 option[value='45000']").show();
			$(opener.document).find("#sel_agree_dist_3 option[value='50000']").show();
			$(opener.document).find("#sel_agree_dist_4 option[value='35000']").show();
			$(opener.document).find("#sel_agree_dist_4 option[value='40000']").show();
			$(opener.document).find("#sel_agree_dist_4 option[value='45000']").show();
			$(opener.document).find("#sel_agree_dist_4 option[value='50000']").show();
			
			$(opener.document).find("#sel_a_b_1 option[value='48']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_1 option[value='60']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_1 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_2 option[value='48']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_2 option[value='60']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_2 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_3 option[value='48']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_3 option[value='60']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_3 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_4 option[value='48']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_4 option[value='60']").prop("disabled", false);
			$(opener.document).find("#sel_a_b_4 option[value='directInput']").prop("disabled", false);
					
			
			//대여기간 input
			$(opener.document).find("#a_b_1").attr("readonly", false);
			$(opener.document).find("#a_b_2").attr("readonly", false);
			$(opener.document).find("#a_b_3").attr("readonly", false);
			$(opener.document).find("#a_b_4").attr("readonly", false);
			
			//주행거리 selectbox
			$(opener.document).find("#sel_agree_dist_1 option[value='35000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_1 option[value='40000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_1 option[value='45000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_1 option[value='50000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_1 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_2 option[value='35000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_2 option[value='40000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_2 option[value='45000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_2 option[value='50000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_2 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_3 option[value='35000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_3 option[value='40000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_3 option[value='45000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_3 option[value='50000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_3 option[value='directInput']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_4 option[value='35000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_4 option[value='40000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_4 option[value='45000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_4 option[value='50000']").prop("disabled", false);
			$(opener.document).find("#sel_agree_dist_4 option[value='directInput']").prop("disabled", false);
			
			//주행거리 input
			$(opener.document).find("#agree_dist_1").attr("readonly", false);
			$(opener.document).find("#agree_dist_2").attr("readonly", false);
			$(opener.document).find("#agree_dist_3").attr("readonly", false);
			$(opener.document).find("#agree_dist_4").attr("readonly", false);
			
			//적용잔가 text
			$(opener.document).find("#ro_13_0_display_3").css("display", "none");
			$(opener.document).find("#ro_13_1_display_3").css("display", "none");
			$(opener.document).find("#ro_13_2_display_3").css("display", "none");
			$(opener.document).find("#ro_13_3_display_3").css("display", "none");
			
		}
		
		//보증금
		$(opener.document).find("#sel_rg_8_2").attr("disabled", false);
		$(opener.document).find("#rg_8_2").attr("disabled", false);
		$(opener.document).find("#rg_8_amt_2").attr("disabled", false);
		//선납금
		$(opener.document).find("#pp_per_2").attr("disabled", false);
		$(opener.document).find("#pp_amt_2").attr("disabled", false);
		//개시대여료
		$(opener.document).find("#g_10_2").attr("disabled", false);
		//보증보험
		$(opener.document).find("#gi_per_2").attr("disabled", false);
		$(opener.document).find("#gi_amt_2").attr("disabled", false);
		//영업수당
		$(opener.document).find("#sel_o_11_2").attr("disabled", false);
		$(opener.document).find("#o_11_2").attr("disabled", false);
		//대여료DC
		$(opener.document).find("#fee_dc_per_2").attr("disabled", false);
		
		for (var i = 0; i <= 3; i++) {
			//대여상품 선택 일괄 처리
			fm.a_a[i].options[1].selected = true;
			
			//매입옵션 선택 일괄 처리
			fm.opt_chk[i].options[1].selected = true;
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
		
		fm.ins_per[0].options[0].selected = true;	
		fm.ins_per[1].options[0].selected = true;	
		fm.ins_per[2].options[0].selected = true;	
		fm.ins_per[3].options[0].selected = true;			
		
		fm.jg_f.value = jg_f*100;
		fm.jg_g.value = jg_g*100;
		//20120901부터 영업수당율 최대3% 이내에서 선택가능 - 디폴트 0%
		fm.jg_f.value = 0;
		fm.jg_g.value = 0;
		//수입차구분
		fm.jg_w.value = jg_w;
		if(jg_w == '1'){
			fm.car_ja[0].value = '500,000';
			fm.car_ja[1].value = '500,000';
			fm.car_ja[2].value = '500,000';
			fm.car_ja[3].value = '500,000';
		}else{
			fm.car_ja[0].value = '300,000';
			fm.car_ja[1].value = '300,000';
			fm.car_ja[2].value = '300,000';
			fm.car_ja[3].value = '300,000';			
		}
		
		//연료구분
		fm.jg_b.value = jg_b;
		
		//표준약정운행거리
		var b_agree_dist = 30000;
		
		if(<%=rent_dt%> >= 20220415){
			b_agree_dist = 23000;
		}
		
		//디젤 +5000
		if(jg_b=='1')		b_agree_dist = b_agree_dist + 5000;				
		//LPG엔진 +10000 -> 20190418 +5000
		if(jg_b=='2')				b_agree_dist = b_agree_dist + 5000;
		fm.b_agree_dist[0].value = parseDecimal(b_agree_dist);
		fm.b_agree_dist[1].value = parseDecimal(b_agree_dist);
		fm.b_agree_dist[2].value = parseDecimal(b_agree_dist);
		fm.b_agree_dist[3].value = parseDecimal(b_agree_dist);
		//적용약정운행거리
		var agree_dist = b_agree_dist;	
		/* if (car_comp_id == "0056") { // 테슬라는 20000 고정
			agree_dist = 20000;
		} */
		fm.agree_dist[0].value = parseDecimal(agree_dist);
		fm.agree_dist[1].value = parseDecimal(agree_dist);
		fm.agree_dist[2].value = parseDecimal(agree_dist);
		fm.agree_dist[3].value = parseDecimal(agree_dist);
		//적용약정운행거리 셀렉트박스 세팅(2018.03.12)
		if(agree_dist==10000){			$(opener.document).find(".sel_a_dist").val("10000").attr("selected", "selected");	}
		else if(agree_dist==15000){		$(opener.document).find(".sel_a_dist").val("15000").attr("selected", "selected");	}
		else if(agree_dist==20000){		$(opener.document).find(".sel_a_dist").val("20000").attr("selected", "selected");	}
		else if(agree_dist==25000){		$(opener.document).find(".sel_a_dist").val("25000").attr("selected", "selected");	}
		else if(agree_dist==30000){		$(opener.document).find(".sel_a_dist").val("30000").attr("selected", "selected");	}
		else if(agree_dist==35000){		$(opener.document).find(".sel_a_dist").val("35000").attr("selected", "selected");	}
		else if(agree_dist==40000){		$(opener.document).find(".sel_a_dist").val("40000").attr("selected", "selected");	}
		else if(agree_dist==45000){		$(opener.document).find(".sel_a_dist").val("45000").attr("selected", "selected");	}
		else if(agree_dist==50000){		$(opener.document).find(".sel_a_dist").val("50000").attr("selected", "selected");	}
		else if(agree_dist==23000){		$(opener.document).find(".sel_a_dist").val("23000").attr("selected", "selected");	}
		else if(agree_dist==28000){		$(opener.document).find(".sel_a_dist").val("28000").attr("selected", "selected");	}
		
		//렌트,리스운영여부
		fm.jg_h.value = jg_h;
		fm.jg_i.value = jg_i;
		fm.jg_tuix_st.value = jg_tuix_st;
		fm.jg_tuix_opt_st.value = '';
		//차선이탈 제어형
		fm.lkas_yn.value = lkas_yn;
		fm.lkas_yn_opt_st.value = '';
		//차선이탈 경고형
		fm.ldws_yn.value = ldws_yn;
		fm.ldws_yn_opt_st.value = '';
		//긴급제동 제어형
		fm.aeb_yn.value = aeb_yn;
		fm.aeb_yn_opt_st.value = '';
		//긴급제동 경고형
		fm.fcw_yn.value = fcw_yn;
		fm.fcw_yn_opt_st.value = '';
		
		fm.garnish_yn.value = garnish_yn;		// 가니쉬 (옵션)
		fm.garnish_yn_opt_st.value = '';		// 가니쉬 (옵션)

		fm.hook_yn.value = hook_yn;		// 견인고리 (옵션)
		fm.hook_yn_opt_st.value = '';		// 견인고리 (옵션)
		
		// 차량정보 - 비고란
		var car_etc_ment = "";
		// 1차 탁송 시 TP 불가 차량(100% 로드 탁송 차량)
		var first_tp_code = [
			"6014711", "6014712", "7014311", "7014312", "7014313", "7014314", "8014311", "8014312",
			"9014311", "9014312", "9014313", "9014314", "9015433", "9015436", "9025433", "9025437", "9025439",
			"6024413", "6024414", "6024415", "7024413", "7024414"
		];
		// 비고란에 아무 표기도 하지 않는 차종(출고지->고객에게 로드로 바로 인도하는 차량).
		var empty_etc_code = [
			"9017311", "9017312", "9017313", "9017314", "9017315", "9018111", "9018112"
		];
		
		if(first_tp_code.indexOf(jg_code) > -1){
			car_etc_ment = "1차 탁송(출고지 → 당사 신차인수지)시 차종 특성으로 인해 TP(TransPorter) 탁송이 불가하여 로드(Road)로 탁송되며 탁송거리만큼 주행거리가 발생됩니다.";
		} else if(empty_etc_code.indexOf(jg_code) > -1){
			car_etc_ment = "";
		} else if(Number(jg_code) > 9000000 && Number(jg_code) < 9900000){
			car_etc_ment = "1차 탁송(출고지 → 당사 신차인수지)시 차종 특성으로 인해 TP(TransPorter) 탁송이 불가할 수 있으며 로드(Road) 탁송시 탁송거리만큼 주행거리가 발생됩니다.";
		}
		
		if(car_etc != ''){
			fm.car_etc.value = car_etc + "\n" + car_etc_ment;
		} else {
			fm.car_etc.value = car_etc_ment;
		}
		fm.car_etc2.value = car_etc2;
		
		
		var etc_jg_code_match = false;
		var etc_jg_code = [
			"2179", 
   			"4115", "4116", "4117", "4149", "4150", "4160", 
   			"4264", "4265", 
   			"5155", "5156", "5171", "5172", "5173", 
   			"5229", "5230", "5271", "5272", "5273", "5274", 
   			"5351", "5352",
   			"6134", "6135", "6136", "6137", "6161", "6162", "6163", 
   			"6255", "6256", "6271", "6272",
   			
   			"2013714", 
   			"4012621", "4012622", "4012623", "4016311", "4016312", "4016313", 
   			"4024121", "4024122", 
   			"5018411", "5018412", "6018111", "6018112", "6018113", 
   			"5026111", "5026112", "6022411", "6022412", "6022413", "6022414", 
   			"3053511", "3053512",
   			"6016111", "6016112", "6016113", "6016114", "6018116", "6018117", "6018118", 
   			"6024411", "6024412", "6022416", "6022417"
		];
		
		for (var j = 0; j < etc_jg_code.length; j++) {
			if (etc_jg_code[j] == jg_code) {
				etc_jg_code_match = true;
			}
		}
		
		//20201020 개소세환원문구 모든차종에대해 표기로 변경됨에 따라 아래 견적서 개소세환원문구 표기여부 임시 주석처리
		/* if (jg_w == "1" || (jg_g_7 == "1" || jg_g_7 == "2") || etc_jg_code_match == true) {
			$(opener.document).find("#info_st option[value='']").prop("disabled", false);			
			$(opener.document).find("#info_st option[value='N']").prop("disabled", true);
			
			$(opener.document).find("#info_st").val("").attr("selected", "selected");
		} else {
			if (jg_3 > 0) {
				$(opener.document).find("#info_st option[value='']").prop("disabled", false);
				$(opener.document).find("#info_st option[value='N']").prop("disabled", false);
				
				$(opener.document).find("#info_st").val("N").attr("selected", "selected");
			} else {
				$(opener.document).find("#info_st option[value='']").prop("disabled", true);
				$(opener.document).find("#info_st option[value='N']").prop("disabled", false);
				
				$(opener.document).find("#info_st").val("N").attr("selected", "selected");
			}
		} */
		
		opener.setO11();
		opener.SetComEmpYn();
		<%}else if(idx.equals("2")){%>
		var fm1 = document.form1;
		var flag = false;
		var flag2 = false;
		
		for(var i=0; i<fm1.elements.length; i++){
			var ck = fm1.elements[i];
			if(ck.name == "car_s_seq"){
				var ck_value = ck.value;
				if(ck_value.indexOf('필수선택') > 0) flag = true;
			}
		}
		if(nm.indexOf('필수선택') > 0) flag2 = true;
		if( flag && !flag2 ){
			alert('필수 옵션을 선택하세요.');
			return;
		}
		
		fm.opt.value = nm;
		fm.opt_seq.value = id;
		fm.opt_amt.value = parseDecimal(amt);	
		if (jg_opt_yn == "N") {
			fm.opt_amt_m.value = parseDecimal(amt);	
		} else {
			fm.opt_amt_m.value = "0";
		}
		fm.jg_opt_st.value = jg_opt_st;
		fm.jg_tuix_opt_st.value = jg_tuix_st;
		fm.lkas_yn_opt_st.value = lkas_yn;//차선이탈 제어형
		fm.ldws_yn_opt_st.value = ldws_yn;//차선이탈 경고형
		fm.aeb_yn_opt_st.value = aeb_yn;//긴급제동 제어형
		fm.fcw_yn_opt_st.value = fcw_yn;//긴급제동 경고형	
		fm.garnish_yn_opt_st.value = garnish_yn;		// 가니쉬 (옵션)
		fm.hook_yn_opt_st.value = hook_yn;		// 가니쉬 (옵션)
		opener.setO11();
		opener.SetComEmpYn();
		<%}else if(idx.equals("3")){%>
		<%}else if(idx.equals("4")){%>
		fm.dc.value = nm;
		fm.dc_seq.value = id;
		fm.dc_amt.value = parseDecimal(amt);
		<%}else if(idx.equals("5")){%>
		fm.conti_rat.value = nm;
		fm.conti_rat_seq.value = seq;
		<%}%>
		fm.o_1.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value)) - toInt(parseDigit(fm.tax_dc_amt.value)));
		
		self.close();
		
		
		opener.location.href="javascript:setEst_yn(1)";
	}
	
	function setDcCode(car_b_dt, car_d, car_d_seq, car_d_per, car_d_p, ls_yn, car_d_per2, car_d_p2, car_d_per_b, car_d_per_b2, esti_d_etc){
		var fm = opener.document.form1;				
		var dc_amt 		= 0;
		var dc_amt2 	= 0;
		var car_price 	= toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)); // - toInt(parseDigit(fm.tax_dc_amt.value)) 20191002 개소세감면액 미반영 차량가격으로 함.
		
		//dc율
		dc_amt 		= (car_price*car_d_per/100);
		
		//dc금액
		if(car_d_p>0){
			dc_amt 	= dc_amt+car_d_p;
		}
		
		if(car_d_per_b == '2'){
			//dc율
			dc_amt 	= ((car_price-car_d_p)*car_d_per/100)+car_d_p;
		}
		
		if(ls_yn == 'Y'){
			//dc율
			dc_amt2 = (car_price*car_d_per2/100);
			//dc금액
			if(car_d_p2>0){
				dc_amt2 	= dc_amt2+car_d_p2;
			}
			if(car_d_per_b2 == '2'){
				dc_amt2 = ((car_price-car_d_p2)*car_d_per2/100)+car_d_p2;
			}
		}
		
		fm.dc.value 		= '';
		fm.dc_seq.value 	= car_b_dt+''+car_d_seq;
		fm.dc_amt.value 	= parseDecimal(dc_amt);
		fm.dc_amt2.value 	= parseDecimal(dc_amt2);
		fm.esti_d_etc.value = esti_d_etc;
		fm.ls_yn.value 		= ls_yn;		
		fm.o_1.value 			= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value))  - toInt(parseDigit(fm.tax_dc_amt.value)));
		fm.o_12.value 		= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt2.value)) - toInt(parseDigit(fm.tax_dc_amt.value)));
		self.close();
	}	
	
	function save(){
		var ofm = opener.document.form1;
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var codes="";
		var amts=0;
		var amts_m=0;
		var opts="";	
		var jg_opt_sts= "";	
		var jg_tuix_sts= "";
		var lkas_yn_sts="";
		var ldws_yn_sts="";
		var aeb_yn_sts="";
		var fcw_yn_sts="";
		var jg_opt_yns= "";
		var garnish_yn_sts="";	// 가니쉬 
		var hook_yn_sts="";	// 견인고리 옵션
		var o_split;
		var flag = false;
		var flag2 = false;
		
		<%if(idx.equals("2")){%>
				
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			
			if(ck.name == "car_s_seq"){		
				var ck_value = ck.value;
				if(ck_value.indexOf('필수선택') > 0) flag = true;
								
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes 	+= o_split[0];
					opts 	+= "["+o_split[1]+"]  ";
					amts 	+= toInt(o_split[2]);
					jg_opt_sts = o_split[3];
					jg_tuix_sts = o_split[4];
					lkas_yn_sts = o_split[5];
					ldws_yn_sts = o_split[6];
					aeb_yn_sts = o_split[7];
					fcw_yn_sts = o_split[8];
					jg_opt_yns = o_split[9];
					garnish_yn_sts = o_split[10];
					hook_yn_sts = o_split[11];
					
					if (jg_opt_yns == "N") {
						amts_m += toInt(o_split[2]);
					}
					
					//조정잔가
					if(jg_opt_sts != ''){		
						var o_split2;
						o_split2 = ofm.jg_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_opt_sts) jg_opt_sts ='';
						}
						if(jg_opt_sts != ''){
							if(ofm.jg_opt_st.value == ''){
								ofm.jg_opt_st.value = jg_opt_sts;	
							}else{
								ofm.jg_opt_st.value = ofm.jg_opt_st.value+'/'+jg_opt_sts;
							}
						}
					}
					//tuix/tuon 옵션여부
					if(jg_tuix_sts != ''){
						var o_split2;
						o_split2 = ofm.jg_tuix_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_tuix_sts) jg_tuix_sts ='';
						}
						if(jg_tuix_sts != ''){
							if(ofm.jg_tuix_opt_st.value == ''){
								ofm.jg_tuix_opt_st.value = jg_tuix_sts;	
							}else{
								ofm.jg_tuix_opt_st.value = ofm.jg_tuix_opt_st.value+'/'+jg_tuix_sts;
							}
						}
					}
					//차선이탈 제어형 옵션여부
					if(lkas_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.lkas_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==lkas_yn_sts) lkas_yn_sts ='';
						}
						if(lkas_yn_sts != ''){
							if(ofm.lkas_yn_opt_st.value == ''){
								ofm.lkas_yn_opt_st.value = lkas_yn_sts;	
							}else{
								ofm.lkas_yn_opt_st.value = ofm.lkas_yn_opt_st.value+'/'+lkas_yn_sts;
							}
						}
					}
					//차선이탈 경고형 옵션여부
					if(ldws_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.ldws_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==ldws_yn_sts) ldws_yn_sts ='';
						}
						if(ldws_yn_sts != ''){
							if(ofm.ldws_yn_opt_st.value == ''){
								ofm.ldws_yn_opt_st.value = ldws_yn_sts;	
							}else{
								ofm.ldws_yn_opt_st.value = ofm.ldws_yn_opt_st.value+'/'+ldws_yn_sts;
							}
						}
					}
					//긴급제동 제어형 옵션여부
					if(aeb_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.aeb_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==aeb_yn_sts) aeb_yn_sts ='';
						}
						if(aeb_yn_sts != ''){
							if(ofm.aeb_yn_opt_st.value == ''){
								ofm.aeb_yn_opt_st.value = aeb_yn_sts;	
							}else{
								ofm.aeb_yn_opt_st.value = ofm.aeb_yn_opt_st.value+'/'+aeb_yn_sts;
							}
						}
					}
					//긴급제동 경고형 옵션여부
					if(fcw_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.fcw_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==fcw_yn_sts) fcw_yn_sts ='';
						}
						if(fcw_yn_sts != ''){
							if(ofm.fcw_yn_opt_st.value == ''){
								ofm.fcw_yn_opt_st.value = fcw_yn_sts;	
							}else{
								ofm.fcw_yn_opt_st.value = ofm.fcw_yn_opt_st.value+'/'+fcw_yn_sts;
							}
						}
					}		
					//가니쉬 옵션여부
					if(garnish_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.garnish_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==garnish_yn_sts) garnish_yn_sts ='';
						}
						if(garnish_yn_sts != ''){
							if(ofm.garnish_yn_opt_st.value == ''){
								ofm.garnish_yn_opt_st.value = garnish_yn_sts;	
							}else{
								ofm.garnish_yn_opt_st.value = ofm.garnish_yn_opt_st.value+'/'+garnish_yn_sts;
							}
						}
					}
					//견인고리 옵션여부
					if(hook_yn_sts != ''){
						var o_split2;
						o_split2 = ofm.hook_yn_opt_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==hook_yn_sts) hook_yn_sts ='';
						}
						if(hook_yn_sts != ''){
							if(ofm.hook_yn_opt_st.value == ''){
								ofm.hook_yn_opt_st.value = hook_yn_sts;	
							}else{
								ofm.hook_yn_opt_st.value = ofm.hook_yn_opt_st.value+'/'+hook_yn_sts;
							}
						}
					}
					
					if(ck_value.indexOf('필수선택') > 0) flag2 = true;
				}
			}
		}
		
		if( flag && !flag2 ){
			alert('필수 옵션을 선택하세요.');
			return;
		}
		
		if(fm.dir_nm.value == ''){
		
			if(cnt == 0){
		 		alert("선택사양을 선택하세요.");
				return;
			}
		}else{
			opts 	+= "["+fm.dir_nm.value+"]  ";
			amts 	+= toInt(parseDigit(fm.dir_amt.value));	
		
		}
				
		ofm.opt.value = opts;
		ofm.opt_seq.value = codes;
		ofm.opt_amt.value = parseDecimal(amts);	
		ofm.opt_amt_m.value = parseDecimal(amts_m);	
		
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));		
		

		
		<%}else if(idx.equals("3")){%>
				
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_s_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes 	+= o_split[0];
					opts 	+= o_split[1];
					amts 	+= toInt(o_split[2]);		
					jg_opt_sts = o_split[3];
					
					//조정잔가
					if(jg_opt_sts != ''){		
						var o_split2;
						o_split2 = ofm.jg_col_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_opt_sts) jg_opt_sts ='';
						}
						if(jg_opt_sts != ''){
							if(ofm.jg_col_st.value == ''){
								ofm.jg_col_st.value = jg_opt_sts;	
							}else{
								ofm.jg_col_st.value = ofm.jg_col_st.value+'/'+jg_opt_sts;
							}
						}
					}
					
				}
			}
		}
				

		if(cnt == 0){
		 	alert("외장색상을 선택하세요.");
			return;
		}
				
		ofm.col.value = opts;
		ofm.col_seq.value = codes;
		ofm.col_amt.value = parseDecimal(amts);
		
		
		
				
		codes="";
		amts=0;	
		opts="";
		jg_opt_sts="";	
		
		codes2="";
		amts2=0;	
		opts2="";
		jg_opt_sts2="";	
		
		o_split;
		
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_in_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes 	+= o_split[0];
					opts 	+= o_split[1];
					amts 	+= toInt(o_split[2]);
					jg_opt_sts = o_split[3];					
					
					//조정잔가
					if(jg_opt_sts != ''){		
						var o_split2;
						o_split2 = ofm.jg_col_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_opt_sts) jg_opt_sts ='';
						}
						if(jg_opt_sts != ''){
							if(ofm.jg_col_st.value == ''){
								ofm.jg_col_st.value = jg_opt_sts;	
							}else{
								ofm.jg_col_st.value = ofm.jg_col_st.value+'/'+jg_opt_sts;
							}
						}
					}
						
				}
			}
		}
		
		for(var z=0 ; z<len ; z++){
			var ck=fm.elements[z];		
			if(ck.name == "car_gar_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes2 	+= o_split[0];
					opts2 	+= o_split[1];
					amts2 	+= toInt(o_split[2]);
					jg_opt_sts2 = o_split[3];					
					
					//조정잔가
					if(jg_opt_sts != ''){		
						var o_split2;
						o_split2 = ofm.jg_col_st.value.split("/");	
						for(var j in o_split2){   
							if(o_split2[j]==jg_opt_sts) jg_opt_sts ='';
						}
						if(jg_opt_sts != ''){
							if(ofm.jg_col_st.value == ''){
								ofm.jg_col_st.value = jg_opt_sts;	
							}else{
								ofm.jg_col_st.value = ofm.jg_col_st.value+'/'+jg_opt_sts;
							}
						}
					}
						
				}
			}
		}
		
		ofm.in_col.value = opts;
		ofm.garnish_col.value = opts2;
		
		ofm.col_amt.value = parseDecimal(toInt(parseDigit(ofm.col_amt.value)) + amts + amts2);				
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));				
		
		<%}%>
		
		
		
		self.close();
	}
	

	function setOptSum(){
		var ofm = opener.document.form1;
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var amts=0;	
		var o_split;
		<%if(idx.equals("2")){%>
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_s_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					amts 	+= toInt(o_split[2]);	
				}
			}
		}
		tr_opt_sum.style.display='';
		fm.v_opt_amt.value = parseDecimal(amts);
		fm.v_car_amt.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)));
		//fm.v_o_1.value = parseDecimal(toInt(parseDigit(fm.v_car_amt.value)) + toInt(parseDigit(fm.v_opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));		
		fm.v_o_1.value = parseDecimal(toInt(parseDigit(fm.v_car_amt.value)) + toInt(parseDigit(fm.v_opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)));		
		//개소세 감면액이 있는 경우 개소세 감면전 보여짐/ 없는경우 숨김
		if (toInt(parseDigit(ofm.tax_dc_amt.value)) == 0) {
			$("#tax_amt_text").css("display", "none");
		} else {
			$("#tax_amt_text").css("display", "");
		}
		
		<%}%>
	}
	
	//사양보기 버튼(2018.01.18)
	function view_spec(car_id, car_seq){
		var car_comp_id = '<%=car_comp_id%>';
		var code = '<%=car_cd%>';
		//var car_id = $("#car_id").val();
		var valus = "?car_comp_id="+car_comp_id+"&code="+code+"&car_id="+car_id+"&car_seq="+car_seq;
		window.open("esti_mng_view_opt.jsp"+valus,"car_b_inc", "left=300, top=100, width=1000, height=600, scrollbars=yes");
	}
	
	//tuix/tuon 옵션 펼치기/접기
	function tuix_click() {				
		var plain_txt = $("#tuix").text().trim();
		
		if (plain_txt == "TUIX/TUON 옵션 보기") {			
			$(".hide").css("display", "");
			$("#tuix").text("TUIX/TUON 옵션 접기");
		} else {
			$(".hide").css("display", "none");
			$("#tuix").text("TUIX/TUON 옵션 보기");
		}
	}
	
	//20200313 포터 일렉트릭, 봉고 EV, 모델3 전체선택. 그 외에는 광주, 대구만 선택가능
	// 20210218. 전기차 고객주소지 포터EV, 봉고EV는 서울만, 그 외 전체 선택 가능하도록 수정. 
	// 20210518. 전기 화물차 외 전기차 전체 고객주소지 선택 가능.
	function autoEcarLocationDisSel(jg_g_7, jg_code) {
		
		var opt_size = $(opener.document).find("#ecar_loc_st_1 option").size();
		
		if (jg_g_7 == "3") {
			
			// 모든 전기차 고객주소지 국고보조금限지원 견적 항목 사용 안 함 22.01.06
			$(opener.document).find("#ecar_loc_st_1 option[value='12']").css("display", 'none');
			$(opener.document).find("#ecar_loc_st_2 option[value='12']").css("display", 'none');
			$(opener.document).find("#ecar_loc_st_3 option[value='12']").css("display", 'none');
			$(opener.document).find("#ecar_loc_st_4 option[value='12']").css("display", 'none');
			
			if ( Number(jg_code) > 8000000 ){ // 전기화물차
				
				// 전기화물차 선택 시 보조금 없는 견적 항목 미노출
				$(opener.document).find("#ecar_loc_st_1 option[value='13']").css("display", 'none');
				$(opener.document).find("#ecar_loc_st_2 option[value='13']").css("display", 'none');
				$(opener.document).find("#ecar_loc_st_3 option[value='13']").css("display", 'none');
				$(opener.document).find("#ecar_loc_st_4 option[value='13']").css("display", 'none');
				
				for (var i = 0; i < opt_size; i++) {
					var ecar_loc_st_idx_val = $(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").val();
					
					// 전기화물차 국고보조금 지원, 보조금 없는 견적 외 모든 고객주소지 선택 가능. 20220106
					$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").css("background-color", "");
				}
				
			} else {		// 전기화물차 외 전기차(= 전기승용차)
			
				// 전기승용차 선택 시 보조금 없는 견적 항목 노출
				$(opener.document).find("#ecar_loc_st_1 option[value='13']").css("display", 'block');
				$(opener.document).find("#ecar_loc_st_2 option[value='13']").css("display", 'block');
				$(opener.document).find("#ecar_loc_st_3 option[value='13']").css("display", 'block');
				$(opener.document).find("#ecar_loc_st_4 option[value='13']").css("display", 'block');
				
				// 전기승용차 모든 전기차 고객주소지 노출
				for (var i=0; i < opt_size; i++) {
					var ecar_loc_st_idx_val = $(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").val();
					
// 						$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").prop("disabled", true);
// 						$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").css("background-color", "#E5E5E5");
						
// 						$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").prop("disabled", true);
// 						$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").css("background-color", "#E5E5E5");
						
// 						$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").prop("disabled", true);
// 						$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").css("background-color", "#E5E5E5");
						
// 						$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").prop("disabled", true);
// 						$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").css("background-color", "#E5E5E5");

					$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").css("background-color", "");
					
					$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").prop("disabled", false);
					$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").css("background-color", "");
				}
			}
		} else {
			for (var i=0; i < opt_size; i++) {
				$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").prop("disabled", false);
				$(opener.document).find("#ecar_loc_st_1 option:eq("+i+")").css("background-color", "");
				
				$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").prop("disabled", false);
				$(opener.document).find("#ecar_loc_st_2 option:eq("+i+")").css("background-color", "");
				
				$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").prop("disabled", false);
				$(opener.document).find("#ecar_loc_st_3 option:eq("+i+")").css("background-color", "");
				
				$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").prop("disabled", false);
				$(opener.document).find("#ecar_loc_st_4 option:eq("+i+")").css("background-color", "");
			}
		}
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='size' value='<%=size%>'>
<input type='hidden' name='jg_g_7' value='<%=jg_g_7%>'>
<input type='hidden' name='print_type' value='<%=print_type%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5><%if(idx.equals("1")){%>차종<%}else if(idx.equals("2")){%>옵션<%}else if(idx.equals("3")){%>색상<%}else if(idx.equals("4")){%>제조사DC<%}else if(idx.equals("5")){%>연비<%}%></span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <% if(idx.equals("5")){%>
    <tr>
    	<td></td>
    </tr>
    <tr>
    	<td style="text-align:right;">
    		※ <span style="font-weight:bold;color:#ee1f46;">연비 미선택 가능</span>: 연비 선택시에만 견적서상에 연비관련 라인이 추가됩니다</br>
    		※ 타이어 <span style="font-weight:bold;color:#ee1f46;">휠 사이즈</span>에 따라 연비가 차이남<span style="font-weight:bold;color:#ee1f46;">(옵션선택시 주의 요망)</span>
    	</td>
    </tr>
    <%} %>
    <tr> 
        <td class=h></td>
    </tr>
    <!--외장색상-->
    <%if(idx.equals("3")){%>
    <tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>외장색상</span></td>
    </tr>    
    <%}%>    
    <tr> 
        <td class=line2></td>
    </tr>
    <%if(idx.equals("4")){//제조사DC%>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width=5%>연번</td>
                    <td class="title" width=30%>D/C구분</td>					
                    <td class="title" width=20%>금액</td>
                    <td class="title" width=30%>비고</td>
                    <td class="title" width=15%>기준일자</td>
                </tr>
                <%for(int i = 0 ; i < size ; i++){
    			Hashtable var = (Hashtable)vars.elementAt(i);%>		
                <tr> 
                    <td align="center"><%=i+1%></td>
		    		<td align="center"><%=var.get("CAR_D")%></td>					
                    <td>&nbsp;
			<a href="javascript:setDcCode('<%=var.get("CAR_B_DT")%>', '<%=var.get("CAR_D")%>', '<%=var.get("CAR_D_SEQ")%>', <%=var.get("CAR_D_PER")%>, <%=var.get("CAR_D_P")%>, '<%=var.get("LS_YN")%>', <%=var.get("CAR_D_PER2")%>, <%=var.get("CAR_D_P2")%>, '<%=var.get("CAR_D_PER_B")%>', '<%=var.get("CAR_D_PER_B2")%>', '<%=var.get("ESTI_D_ETC")%>');">
			<%if(String.valueOf(var.get("LS_YN")).equals("Y")){%>
			    [렌트]<%=var.get("CAR_D_PER")%>% + <%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P")))%>원
			    &nbsp;
			    [리스DC]<%=var.get("CAR_D_PER2")%>% + <%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P2")))%>원
			<%}else{%>
			    <%if(String.valueOf(var.get("CAR_D_PER")).equals("0") && !String.valueOf(var.get("CAR_D_P")).equals("0")){%>
				<%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P")))%>원
			    <%}else if(!String.valueOf(var.get("CAR_D_PER")).equals("0") && String.valueOf(var.get("CAR_D_P")).equals("0")){%>
				<%=var.get("CAR_D_PER")%>%
			    <%}else if(!String.valueOf(var.get("CAR_D_PER")).equals("0") && !String.valueOf(var.get("CAR_D_P")).equals("0")){%>						  
				<%=var.get("CAR_D_PER")%>% + <%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P")))%>원
			    <%}else{%>					
				0원
			    <%}%>						  						  
			<%}%>
		        </a>
		    </td>
		    <td><pre style="white-space: pre-wrap; padding: 5px 10px;"><%=var.get("CAR_D_ETC")%></pre></td>					
		    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(var.get("CAR_D_DT")))%>
			<%if(!String.valueOf(var.get("CAR_D_DT2")).equals("")){%><br>~ <%=AddUtil.ChangeDate2(String.valueOf(var.get("CAR_D_DT2")))%><%}%>
		    </td>
                </tr>
                <%}%>
                		
            </table>
        </td>
    </tr>	
    <%}else if(idx.equals("5")){ //연비 %>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr> 
                    <td class="title" width=10%>연번</td>
                    <td class="title" width=25%>엔진</td>					
                    <td class="title" width=35%>복합연비</td>
                    <td class="title" width=30%>비고</td>
                </tr>
                 <%for(int i = 0 ; i < size ; i++){
    			Hashtable var = (Hashtable)vars.elementAt(i);%>		
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td><%=var.get("ENGINE")%></td>
                    <td><a href="javascript:setCode('<%=var.get("CAR_CD")%>','<%=var.get("CAR_K_SEQ")%>','<%=var.get("CAR_K")%>','','','','','','','','','','','','','','','','','','','','','','','','')"><%=var.get("CAR_K")%></a></td>
                    <td><%=var.get("CAR_K_ETC")%></td>
                </tr>
                <%} %>
            </table>
        </td>
    </tr>    
    <%}else{%>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width=5%><%if(idx.equals("2") || idx.equals("3")) {%>선택 <%}else{%>연번 <%}%></td>
                    <td class="title" width=34%>종류</td>
		    <%if(idx.equals("1")){%>
					<td class="title" width=5%>년형</td>										
					<td class="title" width=13%>금액</td>
					<%if (duty_free_count > 0 && duty_free_count2 > 0) {%>
					<td class="title" width=13%>면세차가</td>
					<%}%>					
					<td class="title" width=12%>기준일자</td>	
			<%}else if(idx.equals("3")){%>	
					<td class="title" width=10%>색상이미지</td>
					<td class="title" width=10%>금액</td>											
		    <%}else{%>
					<td class="title" width=20%>금액</td>					
		    <%}%>
					<td class="title" width=41%>비고</td>			
                </tr>
            
            
            
            
            <%if (idx.equals("2")) {%>
	            <%for (int i = 0 ; i < size ; i++) {
						Hashtable var = (Hashtable)vars.elementAt(i);
						
						if (String.valueOf(var.get("JG_TUIX_ST")).equals("Y")) {
							tuix_count++;
						}
	   			%>
		   			<%if (String.valueOf(var.get("JG_TUIX_ST")).equals("")) {%>
		   			<tr>
	   					<td align="center">
	   						<input type="checkbox" name="car_s_seq" onClick="javascript:setOptSum();" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>||<%=var.get("LKAS_YN")%>||<%=var.get("LDWS_YN")%>||<%=var.get("AEB_YN")%>||<%=var.get("FCW_YN")%>||<%=var.get("JG_OPT_YN")%>||<%=var.get("GARNISH_YN")%>||<%=var.get("HOOK_YN")%>'>
	   					</td>
	   					<td>&nbsp;
	   						<a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("JG_CODE")%>', '<%=var.get("JG_F")%>', '<%=var.get("JG_G")%>', '<%=var.get("JG_3")%>', '<%=var.get("JG_W")%>', '<%=var.get("JG_H")%>', '<%=var.get("JG_I")%>', '<%=var.get("JG_B")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("JG_G_7")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("ETC")%>', '<%=var.get("ETC2")%>', '<%=var.get("CAR_B_P2")%>', '<%=var.get("DUTY_FREE_OPT")%>', '<%=var.get("JG_OPT_YN")%>', '<%=var.get("GARNISH_YN")%>', '<%=var.get("HOOK_YN")%>');">
	   							<font <%if(var.get("IS_NECESSARY").equals("0") || var.get("IS_OPTIONAL").equals("0")){ %>color="red"<%} %>>
	   							<%=var.get("NM")%>
	   							</font>
	   						</a>
	   					</td>
	   					<td align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원</td>
	   					<td>&nbsp;<%=var.get("ETC")%>
				        <%if (AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20151013) {%>
					        <%if (!String.valueOf(var.get("JG_OPT_ST")).equals("") && (idx.equals("2")||idx.equals("3")) ) { //옵션,색상%>
					            <%if (!String.valueOf(var.get("ETC")).equals("")) {%>
					            <br>
					            <%}%>				            		            		            
				            	<%=e_db.getEstiJgOptVarJgOpt8(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
					            <br>
				            	<%=e_db.getEstiJgOptVarJgOpt9(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
					        <%}%>
				        <%}%>
			    		</td>
	   				</tr>
		   			<%}%>
				<%}%>
				
				<%if (tuix_count > 0) {%>
					<tr>
						<td colspan="4" style="height: 40px;">
							<div id="tuix" onclick="tuix_click();">
								TUIX/TUON 옵션 보기
							</div>
						</td>
					</tr>
				<%}%>
					
	            <%for (int i = 0 ; i < size ; i++) {
						Hashtable var = (Hashtable)vars.elementAt(i);
	   			%>
		   			<%if (String.valueOf(var.get("JG_TUIX_ST")).equals("Y")) {%>
		   			<tr class="hide" style="display: none;">
	   					<td align="center">
	   						<input type="checkbox" name="car_s_seq" onClick="javascript:setOptSum();" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>||<%=var.get("LKAS_YN")%>||<%=var.get("LDWS_YN")%>||<%=var.get("AEB_YN")%>||<%=var.get("FCW_YN")%>||<%=var.get("JG_OPT_YN")%>||<%=var.get("GARNISH_YN")%>||<%=var.get("HOOK_YN")%>'>
	   					</td>
	   					<td>&nbsp;
	   						<a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("JG_CODE")%>', '<%=var.get("JG_F")%>', '<%=var.get("JG_G")%>', '<%=var.get("JG_3")%>', '<%=var.get("JG_W")%>', '<%=var.get("JG_H")%>', '<%=var.get("JG_I")%>', '<%=var.get("JG_B")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("JG_G_7")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("ETC")%>', '<%=var.get("ETC2")%>', '<%=var.get("CAR_B_P2")%>', '<%=var.get("DUTY_FREE_OPT")%>', '<%=var.get("JG_OPT_YN")%>', '<%=var.get("GARNISH_YN")%>', '<%=var.get("HOOK_YN")%>');"><%=var.get("NM")%></a>
	   					</td>
	   					<td align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원</td>
	   					<td>&nbsp;<%=var.get("ETC")%>
				        <%if (AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20151013) {%>
					        <%if (!String.valueOf(var.get("JG_OPT_ST")).equals("") && (idx.equals("2")||idx.equals("3")) ) { //옵션,색상%>
					            <%if (!String.valueOf(var.get("ETC")).equals("")) {%>
					            <br>
					            <%}%>				            		            		            
				            	<%=e_db.getEstiJgOptVarJgOpt8(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
					            <br>
				            	<%=e_db.getEstiJgOptVarJgOpt9(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
					        <%}%>
				        <%}%>
			    		</td>
	   				</tr>
		   			<%}%>
				<%}%>
            <%} else {%>
	            <%for (int i = 0 ; i < size ; i++) {
						Hashtable var = (Hashtable)vars.elementAt(i);
	   			%>
	   			<tr>
	   				<td align="center">
   					<%if (idx.equals("3")) {%>
                        <input type="radio" name="car_s_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>||<%=var.get("LKAS_YN")%>||<%=var.get("LDWS_YN")%>||<%=var.get("AEB_YN")%>||<%=var.get("FCW_YN")%>||<%=var.get("HOOK_YN")%>'>
                    <%} else {%>
                        <%=i+1%>
                    <%}%>
	   				</td>
	   				<td>&nbsp;
                    <%if (idx.equals("3")) {%>
                        <%=var.get("NM")%>
                    <%} else if(idx.equals("1")) {%>
                       	<table style="margin-top: -15px;">
                       		<tr>
                       			<td width="85%"><a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("JG_CODE")%>', '<%=var.get("JG_F")%>', '<%=var.get("JG_G")%>', '<%=var.get("JG_3")%>', '<%=var.get("JG_W")%>', '<%=var.get("JG_H")%>', '<%=var.get("JG_I")%>', '<%=var.get("JG_B")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("JG_G_7")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("ETC")%>', '<%=var.get("ETC2")%>', '<%=var.get("CAR_B_P2")%>', '<%=var.get("DUTY_FREE_OPT")%>', '', '<%=var.get("GARNISH_YN")%>', '<%=var.get("HOOK_YN")%>', '<%=var.get("JG_G_15")%>');"><%=var.get("NM")%></a></td>
                       			<td><input type="button" class="button" value="사양" onclick="javascript:view_spec('<%=var.get("ID")%>', '<%=var.get("SEQ")%>');"></td>
                       		</tr>
                       	</table>
                   	<%} else {%>
                        <a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("JG_CODE")%>', '<%=var.get("JG_F")%>', '<%=var.get("JG_G")%>', '<%=var.get("JG_3")%>', '<%=var.get("JG_W")%>', '<%=var.get("JG_H")%>', '<%=var.get("JG_I")%>', '<%=var.get("JG_B")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("JG_G_7")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("ETC")%>', '<%=var.get("ETC2")%>', '<%=var.get("CAR_B_P2")%>', '<%=var.get("DUTY_FREE_OPT")%>', '', '<%=var.get("GARNISH_YN")%>', '<%=var.get("HOOK_YN")%>');"><%=var.get("NM")%></a>
                   	<%}%>
                    </td>
                    
                    <%if (idx.equals("1")) {%>
					<td align="center"><%=var.get("CAR_Y_FORM")%></td>
					<%} else if(idx.equals("3")) {%>
					<td align=center>
						<%//색상이미지 등록
							String content_code = "CAR_COL";
							String content_seq  = car_comp_id+"^"+car_cd+"^"+var.get("CAR_U_SEQ")+"^"+var.get("CAR_C_SEQ");
			              	
							Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
							int attach_vt_size = attach_vt.size();	
			                  
							if (attach_vt_size > 0) {
								for (int j = 0 ; j < attach_vt_size ; j++) {
									Hashtable ht = (Hashtable)attach_vt.elementAt(j);%> 
									<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="60" height="20"> 
							<%}
							} else {%> 
							없음
						<%}%>
					</td>
					<%}%>
					<td align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원</td>		
		    	<%if (idx.equals("1")) {%>
			    
		    		<%if (duty_free_count > 0 && duty_free_count2 > 0) {%>
			        <td align="right">
			        	<%if (var.get("DUTY_FREE_OPT").equals("0")) {%>		        	
				        	<%if (car_comp_id.equals("0001")) {%>
			        				<%=AddUtil.parseDecimal(String.valueOf(var.get("HYUNDAI_DUTY_FREE_AMT")))%>원
				        	<%} else {%>
						        	<%=AddUtil.parseDecimal(String.valueOf(var.get("DUTY_FREE_AMT")))%>원
				        	<%}%>
			        	<%} else {%>
			        			<%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원
			        	<%}%>
	        		</td>
        			<%}%>
	        		
		    	<%}%>
			    
			    <%if(idx.equals("1")){%>
			        <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(var.get("B_DT")))%></td>						
			    <%}%>
		    		<td>&nbsp;<%=var.get("ETC")%>
			        <%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20151013){%>
				        <%if(!String.valueOf(var.get("JG_OPT_ST")).equals("") && (idx.equals("2")||idx.equals("3")) ){ //옵션,색상%>
				            <%if(!String.valueOf(var.get("ETC")).equals("")){%><br><%}%>		            		            
				            	<%=e_db.getEstiJgOptVarJgOpt8(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
				            <br>
				            	<%=e_db.getEstiJgOptVarJgOpt9(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
				        <%}%>
			        <%}%>
		    		</td>
	   			</tr>
				<%}%>
   			<%}%>
              
              
              
              
              <%if(idx.equals("2") || idx.equals("3")){%>
                <tr> 
                    <td class="title" style="height: 40px;">-</td>
                    <td >&nbsp;                
                            <%if(idx.equals("2")){%>
                            <input type="text" name="dir_nm" value="" size="30" class=text>
                            <%}else{%>
                            외장
                            <input type="text" name="dir_nm" value="" size="15" class=text>
                            내장
                            <input type="text" name="dir_nm2" value="" size="10" class=text>
                            <%}%>  
                            <a href="javascript:setCodeDir();">직접입력</a>                          
                    </td>
                  <%if(idx.equals("3")){%>  
                  	<td>&nbsp; </td>
                  <%}%>
		    <td align=right><input type="text" name="dir_amt" value="" size="10" class=num>원</td>
		    <td >&nbsp; </td>
                </tr>                                                
                <%}%>                                	
            </table>
        </td>
    </tr>
    <tr>
    	<td class=h></td>
    </tr>
    

    
	<!--내장색상-->
	<%if(idx.equals("3")){
		vars = e_db.getCarSubList("3_in", car_comp_id, car_cd, car_id, car_seq, a_a);
		size = vars.size();		
	%>
	<tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>내장색상</span></td>
	</tr>    
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width=5%>선택</td>
                    <td class="title" width=34%>종류</td>
                    <td class="title" width=20%>금액</td>					
		    		<td class="title" width=41%>비고</td>			
                </tr>
                <%for(int i = 0 ; i < size ; i++){
    			Hashtable var = (Hashtable)vars.elementAt(i);%>		
                <tr> 
                    <td align="center">
						<input type="radio" name="car_in_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>'>
                    </td>
                    <td>&nbsp;<%=var.get("NM")%></td>					
                    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원</td>						
		    		<td>&nbsp;<%=var.get("ETC")%></td>
                </tr>
                <%}%>		
            </table>
        </td>
    </tr>    
	<%}%>
	
	<!--가니쉬색상-->
	<%if(idx.equals("3")){
		vars = e_db.getCarSubList("3_gar", car_comp_id, car_cd, car_id, car_seq, a_a);
		size = vars.size();		
	%>
	<tr>
    	<td class=h></td>
    </tr>
	<tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>가니쉬색상</span></td>
	</tr>    
    <tr <%if (garnish_yn_opt_st.equals("")) {%>style="display: none;"<%}%>> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width=5%>선택</td>
                    <td class="title" width=34%>종류</td>
                    <td class="title" width=20%>금액</td>					
		    		<td class="title" width=41%>비고</td>			
                </tr>
                <%for(int i = 0 ; i < size ; i++){
    			Hashtable var = (Hashtable)vars.elementAt(i);%>		
                <tr> 
                    <td align="center">
						<input type="radio" name="car_gar_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>'>
                    </td>
                    <td>&nbsp;<%=var.get("NM")%></td>					
                    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원</td>						
		    		<td>&nbsp;<%=var.get("ETC")%></td>
                </tr>
                <%}%>		
            </table>
        </td>
    </tr>    
	<%}%>
        
<%}%>
    
    <%if(idx.equals("2") || idx.equals("3")){%>
    <tr> 
        <td align="right"> 
            <a href="javascript:save();"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>
        </td>
    </tr>          
    <%}else{%>  
    <tr> 
        <td align="right"> <a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>  
    	<%if(idx.equals("1")){%>
		    <%if (duty_free_count > 0 && duty_free_count2 > 0) {%>
		    <tr>
		        <td align="left">
		        	※ 차량가격 : 제조사 가격표와 동일하게 표기<br>
					&nbsp;-  렌터카용/장애인용 LPG 차량가격: 개별소비세 면세차가로 표기,&nbsp;&nbsp;&nbsp;일반인용 LPG 차량가격: 개별소비세 과세차가로 표기<br><br>
					
					※ 개별소비세 면세차가 : 실제 렌터카사에서 구입하는 가격으로 장기렌트 견적시 견적 기준이 되는 가격<br>
					&nbsp;- 렌터카용, 장애인용, 일반인용 LPG 차량가격이 혼재되어 있을 경우 개별소비세 면세차가로 가격을 비교해야 정확한 비교가 됩니다.
		        </td>
		    </tr>  
		    <%}%>
	    <%}%>
	    
    <%}%>  
    
    <%if(idx.equals("2")){%>
    <tr id=tr_opt_sum style="display:none"> 
        <td>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td width=5%>&nbsp;</td>
                    <td width=34%>옵션 금액 합계</td>
                    <td width=20% align=right><input type="text" name="v_opt_amt" value="0" size="10" class=whitenum>원</td>
                    <td width=41%>&nbsp;</td>
                </tr>    
                <tr> 
                    <td>&nbsp;</td>
                    <td>차종 금액(기본차량가격)</td>
                    <td align=right><input type="text" name="v_car_amt" value="0" size="10" class=whitenum>원</td>
                    <td>&nbsp;</td>
                </tr>    
                <tr> 
                    <td>&nbsp;</td>
                    <td>차량가격(합계) <span id="tax_amt_text" style="display: none;">개소세 감면전</span></td>
                    <td align=right><input type="text" name="v_o_1" value="0" size="10" class=whitenum>원</td>
                    <td>&nbsp;</td>
                </tr>    
    <%}%>
</table>
</form>

<!-- 참고 정보 뿌려주기 20161107 조경숙 -->
<%	
	//색상 선택 시 차종 비고 보여주기
	if(idx.equals("3")){
	    Vector carEtc = e_db.getCarSubList("3_1", car_comp_id, car_cd, car_id, car_seq, a_a);
%>
	
	<table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
            <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>해당 차종 참고사항</span></span></td>
            <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
    </table>
<%	    
	    for(int j=0; j<carEtc.size(); j++){
	    	Hashtable carEtcTable = (Hashtable)carEtc.elementAt(j);
%>
			<p style="font-size:12px; padding:15px;">
				<%=(String)carEtcTable.get("ETC")%>
			</p>
<%
	    }

		//색상표 보여주기(20180629)
		Vector scanList = c_db.getAcarAttachFileList("CAR_COL_CAT",car_comp_id+"^"+car_cd+"^%",-1);
		int scanListSize = scanList.size();
%>
		<div style="margin-bottom: 5px; font-size: 14px;"><b>&lt; <%=car_nm %> 색상표 &gt;</b></div>
		<table width=100% border=0 cellpadding=0 cellspacing=0 class="inner-table">
			<tr>
				<td class="title" width="4%">연번</td>
				<td class="title" width="30%">파일이름</td>
				<td class="title" width="15%">등록일자</td>
				<td class="title" width="*">비고</td>
			</tr>
<%		if(scanListSize>0){	%>
<%			for(int i=0; i<scanListSize; i++){ %>
			<%	Hashtable carColCat = (Hashtable)scanList.elementAt(i); %>
			<%	CommonEtcBean etc_bean = new CommonEtcBean();  
					etc_bean = c_db.getCommonEtc("acar_attach_file","content_code","CAR_COL_CAT","content_seq",String.valueOf(carColCat.get("CONTENT_SEQ")),"","","","");
			%>
			<tr>
				<td align="center"><%=i+1%></td>
				<td align="center"><a href="javascript:openPopF('<%=carColCat.get("FILE_TYPE")%>','<%=carColCat.get("SEQ")%>');" title='보기' ><%=carColCat.get("FILE_NAME")%></a></td>
				<td align="center"><%=String.valueOf(carColCat.get("REG_DATE")).substring(0,10)%></td>
				<td align="left">&nbsp;<%=etc_bean.getEtc_content()%></td>
			</tr>
	<%		} %>			
<%		}else{%>
		<tr>
			<td></td>
			<td colspan="3" align="center">아직 등록된 참고 색상표가 없습니다.</td>
		</tr>
<%		} %>	
		</table>
<%	}%>
<%
	//연비에 차종 사양 display
	if(idx.equals("5")){
    
	    Hashtable car_b = a_cmb.getCar_b(car_id, car_seq);
		String car_b1 = (String)car_b.get("CAR_B");
		
		Hashtable ht2 = a_cmb.getCar_b((String)car_b.get("CAR_B_INC_ID"), (String)car_b.get("CAR_B_INC_SEQ"));
		String car_b2 = (String)ht2.get("CAR_B");
		
		Hashtable ht3 = a_cmb.getCar_b((String)ht2.get("CAR_B_INC_ID"), (String)ht2.get("CAR_B_INC_SEQ"));
		String car_b3 = (String)ht3.get("CAR_B");
		
		Hashtable ht4 = a_cmb.getCar_b((String)ht3.get("CAR_B_INC_ID"), (String)ht3.get("CAR_B_INC_SEQ"));
		String car_b4 = (String)ht4.get("CAR_B");

%>
	<table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
            <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>연비 참고사항</span></span></td>
            <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
    </table>
    <br/>
    <table class="inner-table">
    	<colgroup>
    		<col width="15%"/>
    		<col width="*"/>
    	</colgroup>
    	<thead>
    		<tr>
    			<td class="line" colspan="2" style="background-color:#b0baec;padding:0px;height:2;"></td>
    		</tr>
    		<tr>
    			<th>구분</th>
    			<th>기본 품목</th>
    		</tr>
    	</thead>
    	<%if(!String.valueOf(car_b.get("CAR_B")).equals("null")){%>
    	<tr>
    		<th><%=(String)car_b.get("CAR_NAME")%>&nbsp;<span class="default-title">(선택 트림)</span></th>
    		<td>
    			<%if(!String.valueOf(ht2.get("CAR_NAME")).equals("null")){%>	
	    			<span class="parent-desc"><%=(String)ht2.get("CAR_NAME")%> 기본사양품목 및</span><br>
	    		<%} %>
	    		<%=car_b1%>
    		</td>
    	</tr>
    	<%} %>
    	<%if(!String.valueOf(ht2.get("CAR_B")).equals("null")){%>
    	<tr>
    		<th><%=(String)ht2.get("CAR_NAME")%></th>
    		<td>
    			<%if(!String.valueOf(ht3.get("CAR_NAME")).equals("null")){%>
	    			<span class="parent-desc"><%=(String)ht3.get("CAR_NAME")%> 기본사양품목 및</span><br>
	    		<%} %>
	    		<%=car_b2%>
    		</td>
    	</tr>
    	<%} %>
    	 <%if(!String.valueOf(ht3.get("CAR_B")).equals("null")){%>
    	 <tr>
    	 	<th><%=(String)ht3.get("CAR_NAME")%></th>
    	 	<td>
    	 		<%if(!String.valueOf(ht4.get("CAR_NAME")).equals("null")){%>
	    			<span class="parent-desc"><%=(String)ht4.get("CAR_NAME")%> 기본사양품목 및</span><br>
	    		<%} %>
	    		<%=car_b3%>
    	 	</td>
    	 </tr>
    	 <%} %>
    	 <%if(!String.valueOf(ht4.get("CAR_B")).equals("null")){%>
    	 <tr>
    	 	<th><%=(String)ht4.get("CAR_NAME")%></th>
    	 	<td>
    	 		<%=car_b4%>
    	 	</td>
    	 </tr>
    	 <%} %>
    </table>
<%} %>
</td>
</tr>
</table>
</form>
</body>
<script language="JavaScript">
<!--
	var ofm = opener.document.form1;
	
	// 초기화 
	
	<%if(idx.equals("1")){%>
		ofm.car_name.value 	= '';
		ofm.car_id.value 	= '';
		ofm.car_seq.value 	= '';
		ofm.car_amt.value 	= '0';
		ofm.jg_tuix_st.value 	= '';
		ofm.lkas_yn.value 	= '';//차선이탈 제어형
		ofm.ldws_yn.value 	= '';//차선이탈 경고형
		ofm.aeb_yn.value 	= '';//긴급제동 제어형
		ofm.fcw_yn.value 	= '';//긴급제동 경고형
		ofm.hook_yn.value 	= '';//견인고리
		ofm.o_1.value 	= '0';
		
		ofm.conti_rat.value 	= '';	
		ofm.conti_rat_seq.value 	= '';	
		ofm.dc.value 	= '';	
		ofm.dc_seq.value 	= '';	
		ofm.dc_amt.value 	= '0';	
		ofm.esti_d_etc.value 	= '';	
		ofm.tax_dc_amt.value 	= '0';	
	<%}%>
	
	<%if(idx.equals("2")){%>
		/* 
		ofm.jg_tuix_st.value 	= '';
		ofm.lkas_yn.value 	= '';//차선이탈 제어형
		ofm.ldws_yn.value 	= '';//차선이탈 경고형
		ofm.aeb_yn.value 	= '';//긴급제동 제어형
		ofm.fcw_yn.value 	= '';//긴급제동 경고형 
		*/
		
		ofm.jg_tuix_st.value 	= '<%=tmp_jg_tuix_st%>';
		ofm.lkas_yn.value 	= '<%=tmp_lkas_yn%>';//차선이탈 제어형
		ofm.ldws_yn.value 	= '<%=tmp_ldws_yn%>';//차선이탈 경고형
		ofm.aeb_yn.value 	= '<%=tmp_aeb_yn%>';//긴급제동 제어형
		ofm.fcw_yn.value 	= '<%=tmp_fcw_yn%>';//긴급제동 경고형
		ofm.hook_yn.value 	= '<%=tmp_hook_yn%>';//긴급제동 경고형
	<%}%>
		
	<%if(idx.equals("1") || idx.equals("2")){%>
		ofm.opt.value 		= '';
		ofm.opt_seq.value 	= '';
		ofm.opt_amt.value 	= '0';			
		ofm.opt_amt_m.value 	= '0';
		ofm.jg_opt_st.value 	= '';	
		ofm.jg_tuix_opt_st.value 	= '';
		ofm.lkas_yn_opt_st.value 	= '';//차선이탈 제어형
		ofm.ldws_yn_opt_st.value 	= '';//차선이탈 경고형
		ofm.aeb_yn_opt_st.value 	= '';//긴급제동 제어형
		ofm.fcw_yn_opt_st.value 	= '';//긴급제동 경고형
		ofm.hook_yn_opt_st.value 	= '';//견인고리
		
		ofm.garnish_col.value	= '';
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));
	<%}%>
	
	<%if(idx.equals("1") || idx.equals("3")){%>
		ofm.col.value 		= '';
		ofm.in_col.value	= '';
		ofm.garnish_col.value	= '';
		ofm.col_seq.value 	= '';
		ofm.col_amt.value 	= '0';				
		ofm.jg_col_st.value 	= '';	
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));
	<%}%>
	
//-->
</script>
</html>