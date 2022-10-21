<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		var fm = document.form1;	
		if(fm.save_dt.value != ''){ alert("이미 마감 등록된 부채현황입니다."); return; }
		if(!confirm('마감하시겠습니까?'))
			return;
		fm.target='i_no';
		fm.submit();		
	}	

	//처음 셋팅하기
	function set_debt(){
		var p_fm = parent.document.form1;			
		var fm = document.form1;
		var b_size = toInt(fm.deb1_size.value);
		var c_size = toInt(fm.deb2_size.value);
		var g_size = toInt(fm.deb3_size.value);		
		fm.tot_size.value = b_size+c_size+g_size;		
		for(i=0; i<b_size+c_size+g_size; i++){ 
			if(fm.save_dt.value == ''){
				//이자별도
//				fm.plan_amt[i].value = parseDecimal(toInt(parseDigit(fm.plan_prn[i].value)) + toInt(parseDigit(fm.plan_int[i].value)));
//				fm.pay_amt[i].value = parseDecimal(toInt(parseDigit(fm.pay_prn[i].value)) + toInt(parseDigit(fm.pay_int[i].value)));			
				//차월이월차입금
				fm.over_amt[i].value = parseDecimal(toInt(parseDigit(fm.last_amt[i].value)) + toInt(parseDigit(fm.new_amt[i].value)) - toInt(parseDigit(fm.pay_prn[i].value)));
				alert("차월이월차입금=전기이울"+fm.last_amt[i].value+"+신규"+fm.new_amt[i].vlaue+"상환원금"+fm.pay_prn[i].value+"/상환할부금"+fm.pay_amt[i].value);
				//당월잔액
				fm.jan_amt[i].value = parseDecimal(toInt(parseDigit(fm.plan_amt[i].value)) - toInt(parseDigit(fm.pay_amt[i].value)));			
			}
			//소계
			fm.t_last_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.last_amt[i].value)) + toInt(parseDigit(fm.h_last_amt[i].value)));
			fm.t_over_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.over_amt[i].value)) + toInt(parseDigit(fm.h_over_amt[i].value)));
			fm.t_new_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.new_amt[i].value)) + toInt(parseDigit(fm.h_new_amt[i].value)));
			fm.t_plan_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.plan_amt[i].value)) + toInt(parseDigit(fm.h_plan_amt[i].value)));
			fm.t_pay_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.pay_amt[i].value)) + toInt(parseDigit(fm.h_pay_amt[i].value)));
			fm.t_jan_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.jan_amt[i].value)) + toInt(parseDigit(fm.h_jan_amt[i].value)));			
			//은행 합계
			if(i < b_size){
 				//소계(운전자금잔액빼기)
				fm.t_last_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.t_last_amt[i].value)) - toInt(parseDigit(fm.j_last_amt[i].value)));
				fm.t_over_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.t_over_amt[i].value)) - toInt(parseDigit(fm.j_over_amt[i].value)));
				fm.t_new_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.t_new_amt[i].value)) - toInt(parseDigit(fm.j_new_amt[i].value)));
				fm.t_plan_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.t_plan_amt[i].value)) - toInt(parseDigit(fm.j_plan_amt[i].value)));
				fm.t_pay_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.t_pay_amt[i].value)) - toInt(parseDigit(fm.j_pay_amt[i].value)));
				fm.t_jan_amt[i].value 	= parseDecimal(toInt(parseDigit(fm.t_jan_amt[i].value)) - toInt(parseDigit(fm.j_jan_amt[i].value)));						
				//합계 -시설자금
				fm.b_last_amt.value = parseDecimal(toInt(parseDigit(fm.b_last_amt.value)) + toInt(parseDigit(fm.last_amt[i].value)));
				fm.b_over_amt.value = parseDecimal(toInt(parseDigit(fm.b_over_amt.value)) + toInt(parseDigit(fm.over_amt[i].value)));
				fm.b_new_amt.value 	= parseDecimal(toInt(parseDigit(fm.b_new_amt.value)) + toInt(parseDigit(fm.new_amt[i].value)));
				fm.b_plan_amt.value = parseDecimal(toInt(parseDigit(fm.b_plan_amt.value)) + toInt(parseDigit(fm.plan_amt[i].value)));
				fm.b_pay_amt.value 	= parseDecimal(toInt(parseDigit(fm.b_pay_amt.value)) + toInt(parseDigit(fm.pay_amt[i].value)));
				fm.b_jan_amt.value 	= parseDecimal(toInt(parseDigit(fm.b_jan_amt.value)) + toInt(parseDigit(fm.jan_amt[i].value)));
				//합계 -운전자금 한도
				fm.bh_last_amt.value= parseDecimal(toInt(parseDigit(fm.bh_last_amt.value)) + toInt(parseDigit(fm.h_last_amt[i].value)));
				fm.bh_over_amt.value= parseDecimal(toInt(parseDigit(fm.bh_over_amt.value)) + toInt(parseDigit(fm.h_over_amt[i].value)));
				fm.bh_new_amt.value = parseDecimal(toInt(parseDigit(fm.bh_new_amt.value)) + toInt(parseDigit(fm.h_new_amt[i].value)));
				fm.bh_plan_amt.value= parseDecimal(toInt(parseDigit(fm.bh_plan_amt.value)) + toInt(parseDigit(fm.h_plan_amt[i].value)));
				fm.bh_pay_amt.value = parseDecimal(toInt(parseDigit(fm.bh_pay_amt.value)) + toInt(parseDigit(fm.h_pay_amt[i].value)));
				fm.bh_jan_amt.value = parseDecimal(toInt(parseDigit(fm.bh_jan_amt.value)) + toInt(parseDigit(fm.h_jan_amt[i].value)));
				//합계 -운전자금 잔액
				fm.bj_last_amt.value= parseDecimal(toInt(parseDigit(fm.bj_last_amt.value)) + toInt(parseDigit(fm.j_last_amt[i].value)));
				fm.bj_over_amt.value= parseDecimal(toInt(parseDigit(fm.bj_over_amt.value)) + toInt(parseDigit(fm.j_over_amt[i].value)));
				fm.bj_new_amt.value = parseDecimal(toInt(parseDigit(fm.bj_new_amt.value)) + toInt(parseDigit(fm.j_new_amt[i].value)));
				fm.bj_plan_amt.value= parseDecimal(toInt(parseDigit(fm.bj_plan_amt.value)) + toInt(parseDigit(fm.j_plan_amt[i].value)));
				fm.bj_pay_amt.value = parseDecimal(toInt(parseDigit(fm.bj_pay_amt.value)) + toInt(parseDigit(fm.j_pay_amt[i].value)));
				fm.bj_jan_amt.value = parseDecimal(toInt(parseDigit(fm.bj_jan_amt.value)) + toInt(parseDigit(fm.j_jan_amt[i].value)));
				//합계 -소계
				fm.bt_last_amt.value= parseDecimal(toInt(parseDigit(fm.bt_last_amt.value)) + toInt(parseDigit(fm.t_last_amt[i].value)));
				fm.bt_over_amt.value= parseDecimal(toInt(parseDigit(fm.bt_over_amt.value)) + toInt(parseDigit(fm.t_over_amt[i].value)));
				fm.bt_new_amt.value = parseDecimal(toInt(parseDigit(fm.bt_new_amt.value)) + toInt(parseDigit(fm.t_new_amt[i].value)));
				fm.bt_plan_amt.value= parseDecimal(toInt(parseDigit(fm.bt_plan_amt.value)) + toInt(parseDigit(fm.t_plan_amt[i].value)));
				fm.bt_pay_amt.value = parseDecimal(toInt(parseDigit(fm.bt_pay_amt.value)) + toInt(parseDigit(fm.t_pay_amt[i].value)));
				fm.bt_jan_amt.value = parseDecimal(toInt(parseDigit(fm.bt_jan_amt.value)) + toInt(parseDigit(fm.t_jan_amt[i].value)));
			}else if(i >= b_size && i < b_size+c_size){
				//합계 -시설자금
				fm.c_last_amt.value = parseDecimal(toInt(parseDigit(fm.c_last_amt.value)) + toInt(parseDigit(fm.last_amt[i].value)));
				fm.c_over_amt.value = parseDecimal(toInt(parseDigit(fm.c_over_amt.value)) + toInt(parseDigit(fm.over_amt[i].value)));
				fm.c_new_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_new_amt.value)) + toInt(parseDigit(fm.new_amt[i].value)));
				fm.c_plan_amt.value = parseDecimal(toInt(parseDigit(fm.c_plan_amt.value)) + toInt(parseDigit(fm.plan_amt[i].value)));
				fm.c_pay_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_pay_amt.value)) + toInt(parseDigit(fm.pay_amt[i].value)));
				fm.c_jan_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_jan_amt.value)) + toInt(parseDigit(fm.jan_amt[i].value)));
				//합계 -운전자금 한도
				fm.ch_last_amt.value= parseDecimal(toInt(parseDigit(fm.ch_last_amt.value)) + toInt(parseDigit(fm.h_last_amt[i].value)));
				fm.ch_over_amt.value= parseDecimal(toInt(parseDigit(fm.ch_over_amt.value)) + toInt(parseDigit(fm.h_over_amt[i].value)));
				fm.ch_new_amt.value = parseDecimal(toInt(parseDigit(fm.ch_new_amt.value)) + toInt(parseDigit(fm.h_new_amt[i].value)));
				fm.ch_plan_amt.value= parseDecimal(toInt(parseDigit(fm.ch_plan_amt.value)) + toInt(parseDigit(fm.h_plan_amt[i].value)));
				fm.ch_pay_amt.value = parseDecimal(toInt(parseDigit(fm.ch_pay_amt.value)) + toInt(parseDigit(fm.h_pay_amt[i].value)));
				fm.ch_jan_amt.value = parseDecimal(toInt(parseDigit(fm.ch_jan_amt.value)) + toInt(parseDigit(fm.h_jan_amt[i].value)));
				//합계 -소계
				fm.ct_last_amt.value= parseDecimal(toInt(parseDigit(fm.ct_last_amt.value)) + toInt(parseDigit(fm.t_last_amt[i].value)));
				fm.ct_over_amt.value= parseDecimal(toInt(parseDigit(fm.ct_over_amt.value)) + toInt(parseDigit(fm.t_over_amt[i].value)));
				fm.ct_new_amt.value = parseDecimal(toInt(parseDigit(fm.ct_new_amt.value)) + toInt(parseDigit(fm.t_new_amt[i].value)));
				fm.ct_plan_amt.value= parseDecimal(toInt(parseDigit(fm.ct_plan_amt.value)) + toInt(parseDigit(fm.t_plan_amt[i].value)));
				fm.ct_pay_amt.value = parseDecimal(toInt(parseDigit(fm.ct_pay_amt.value)) + toInt(parseDigit(fm.t_pay_amt[i].value)));
				fm.ct_jan_amt.value = parseDecimal(toInt(parseDigit(fm.ct_jan_amt.value)) + toInt(parseDigit(fm.t_jan_amt[i].value)));
			}else{
				//합계 -시설자금
				fm.g_last_amt.value = parseDecimal(toInt(parseDigit(fm.g_last_amt.value)) + toInt(parseDigit(fm.last_amt[i].value)));
				fm.g_over_amt.value = parseDecimal(toInt(parseDigit(fm.g_over_amt.value)) + toInt(parseDigit(fm.over_amt[i].value)));
				fm.g_new_amt.value 	= parseDecimal(toInt(parseDigit(fm.g_new_amt.value)) + toInt(parseDigit(fm.new_amt[i].value)));
				fm.g_plan_amt.value = parseDecimal(toInt(parseDigit(fm.g_plan_amt.value)) + toInt(parseDigit(fm.plan_amt[i].value)));
				fm.g_pay_amt.value 	= parseDecimal(toInt(parseDigit(fm.g_pay_amt.value)) + toInt(parseDigit(fm.pay_amt[i].value)));
				fm.g_jan_amt.value 	= parseDecimal(toInt(parseDigit(fm.g_jan_amt.value)) + toInt(parseDigit(fm.jan_amt[i].value)));
				//합계 -운전자금 한도
				fm.gh_last_amt.value= parseDecimal(toInt(parseDigit(fm.gh_last_amt.value)) + toInt(parseDigit(fm.h_last_amt[i].value)));
				fm.gh_over_amt.value= parseDecimal(toInt(parseDigit(fm.gh_over_amt.value)) + toInt(parseDigit(fm.h_over_amt[i].value)));
				fm.gh_new_amt.value = parseDecimal(toInt(parseDigit(fm.gh_new_amt.value)) + toInt(parseDigit(fm.h_new_amt[i].value)));
				fm.gh_plan_amt.value= parseDecimal(toInt(parseDigit(fm.gh_plan_amt.value)) + toInt(parseDigit(fm.h_plan_amt[i].value)));
				fm.gh_pay_amt.value = parseDecimal(toInt(parseDigit(fm.gh_pay_amt.value)) + toInt(parseDigit(fm.h_pay_amt[i].value)));
				fm.gh_jan_amt.value = parseDecimal(toInt(parseDigit(fm.gh_jan_amt.value)) + toInt(parseDigit(fm.h_jan_amt[i].value)));
				//합계 -소계
				fm.gt_last_amt.value= parseDecimal(toInt(parseDigit(fm.gt_last_amt.value)) + toInt(parseDigit(fm.t_last_amt[i].value)));
				fm.gt_over_amt.value= parseDecimal(toInt(parseDigit(fm.gt_over_amt.value)) + toInt(parseDigit(fm.t_over_amt[i].value)));
				fm.gt_new_amt.value = parseDecimal(toInt(parseDigit(fm.gt_new_amt.value)) + toInt(parseDigit(fm.t_new_amt[i].value)));
				fm.gt_plan_amt.value= parseDecimal(toInt(parseDigit(fm.gt_plan_amt.value)) + toInt(parseDigit(fm.t_plan_amt[i].value)));
				fm.gt_pay_amt.value = parseDecimal(toInt(parseDigit(fm.gt_pay_amt.value)) + toInt(parseDigit(fm.t_pay_amt[i].value)));
				fm.gt_jan_amt.value = parseDecimal(toInt(parseDigit(fm.gt_jan_amt.value)) + toInt(parseDigit(fm.t_jan_amt[i].value)));
			}	
		}
		
		//총계
		set_tot_amt();
	}
	
	//운전자금 입력받아 합계 구하기
	function set_b_amt(idx, obj){
		return;
		var p_fm = parent.document.form1;		
		var fm = document.form1;
		var b_size = toInt(fm.deb1_size.value);
		obj.value = parseDecimal(obj.value);
		if(obj == fm.h_last_amt){
			fm.h_over_amt[idx].value = obj.value;		
		}else{
			fm.j_over_amt[idx].value = obj.value;
		}
		fm.t_last_amt[idx].value = parseDecimal(toInt(parseDigit(fm.last_amt[idx].value)) + toInt(parseDigit(fm.h_last_amt[idx].value)) - toInt(parseDigit(fm.j_last_amt[idx].value)));
		fm.t_over_amt[idx].value = parseDecimal(toInt(parseDigit(fm.over_amt[idx].value)) + toInt(parseDigit(fm.h_over_amt[idx].value)) - toInt(parseDigit(fm.j_last_amt[idx].value)));

		fm.b_last_amt.value = "0";
		fm.b_over_amt.value = "0";
		fm.b_new_amt.value 	= "0";
		fm.b_plan_amt.value = "0";
		fm.b_pay_amt.value 	= "0";
		fm.b_jan_amt.value 	= "0";
		fm.bh_last_amt.value= "0";
		fm.bh_over_amt.value= "0";
		fm.bh_new_amt.value = "0";
		fm.bh_plan_amt.value= "0";
		fm.bh_pay_amt.value = "0";
		fm.bh_jan_amt.value = "0";
		fm.bj_last_amt.value= "0";
		fm.bj_over_amt.value= "0";
		fm.bj_new_amt.value = "0";
		fm.bj_plan_amt.value= "0";
		fm.bj_pay_amt.value = "0";
		fm.bj_jan_amt.value = "0";
		fm.bt_last_amt.value= "0";
		fm.bt_over_amt.value= "0";
		fm.bt_new_amt.value = "0";
		fm.bt_plan_amt.value= "0";
		fm.bt_pay_amt.value = "0";
		fm.bt_jan_amt.value = "0";
	
		for(i=0; i<b_size; i++){
			//합계 -시설자금
			fm.b_last_amt.value = parseDecimal(toInt(parseDigit(fm.b_last_amt.value)) + toInt(parseDigit(fm.last_amt[i].value)));
			fm.b_over_amt.value = parseDecimal(toInt(parseDigit(fm.b_over_amt.value)) + toInt(parseDigit(fm.over_amt[i].value)));
			fm.b_new_amt.value 	= parseDecimal(toInt(parseDigit(fm.b_new_amt.value)) + toInt(parseDigit(fm.new_amt[i].value)));
			fm.b_plan_amt.value = parseDecimal(toInt(parseDigit(fm.b_plan_amt.value)) + toInt(parseDigit(fm.plan_amt[i].value)));
			fm.b_pay_amt.value 	= parseDecimal(toInt(parseDigit(fm.b_pay_amt.value)) + toInt(parseDigit(fm.pay_amt[i].value)));
			fm.b_jan_amt.value 	= parseDecimal(toInt(parseDigit(fm.b_jan_amt.value)) + toInt(parseDigit(fm.jan_amt[i].value)));
			//합계 -운전자금 한도
			fm.bh_last_amt.value= parseDecimal(toInt(parseDigit(fm.bh_last_amt.value)) + toInt(parseDigit(fm.h_last_amt[i].value)));
			fm.bh_over_amt.value= parseDecimal(toInt(parseDigit(fm.bh_over_amt.value)) + toInt(parseDigit(fm.h_over_amt[i].value)));
			fm.bh_new_amt.value = parseDecimal(toInt(parseDigit(fm.bh_new_amt.value)) + toInt(parseDigit(fm.h_new_amt[i].value)));
			fm.bh_plan_amt.value= parseDecimal(toInt(parseDigit(fm.bh_plan_amt.value)) + toInt(parseDigit(fm.h_plan_amt[i].value)));
			fm.bh_pay_amt.value = parseDecimal(toInt(parseDigit(fm.bh_pay_amt.value)) + toInt(parseDigit(fm.h_pay_amt[i].value)));
			fm.bh_jan_amt.value = parseDecimal(toInt(parseDigit(fm.bh_jan_amt.value)) + toInt(parseDigit(fm.h_jan_amt[i].value)));
			//합계 -운전자금 잔액
			fm.bj_last_amt.value= parseDecimal(toInt(parseDigit(fm.bj_last_amt.value)) + toInt(parseDigit(fm.j_last_amt[i].value)));
			fm.bj_over_amt.value= parseDecimal(toInt(parseDigit(fm.bj_over_amt.value)) + toInt(parseDigit(fm.j_over_amt[i].value)));
			fm.bj_new_amt.value = parseDecimal(toInt(parseDigit(fm.bj_new_amt.value)) + toInt(parseDigit(fm.j_new_amt[i].value)));
			fm.bj_plan_amt.value= parseDecimal(toInt(parseDigit(fm.bj_plan_amt.value)) + toInt(parseDigit(fm.j_plan_amt[i].value)));
			fm.bj_pay_amt.value = parseDecimal(toInt(parseDigit(fm.bj_pay_amt.value)) + toInt(parseDigit(fm.j_pay_amt[i].value)));
			fm.bj_jan_amt.value = parseDecimal(toInt(parseDigit(fm.bj_jan_amt.value)) + toInt(parseDigit(fm.j_jan_amt[i].value)));
			//합계 -소계
			fm.bt_last_amt.value= parseDecimal(toInt(parseDigit(fm.bt_last_amt.value)) + toInt(parseDigit(fm.t_last_amt[i].value)));
			fm.bt_over_amt.value= parseDecimal(toInt(parseDigit(fm.bt_over_amt.value)) + toInt(parseDigit(fm.t_over_amt[i].value)));
			fm.bt_new_amt.value = parseDecimal(toInt(parseDigit(fm.bt_new_amt.value)) + toInt(parseDigit(fm.t_new_amt[i].value)));
			fm.bt_plan_amt.value= parseDecimal(toInt(parseDigit(fm.bt_plan_amt.value)) + toInt(parseDigit(fm.t_plan_amt[i].value)));
			fm.bt_pay_amt.value = parseDecimal(toInt(parseDigit(fm.bt_pay_amt.value)) + toInt(parseDigit(fm.t_pay_amt[i].value)));
			fm.bt_jan_amt.value = parseDecimal(toInt(parseDigit(fm.bt_jan_amt.value)) + toInt(parseDigit(fm.t_jan_amt[i].value)));
		}
		
		//총계
		set_tot_amt();
	}
	
	//운전자금 입력받아 합계 구하기-캐피탈
	function set_c_amt(idx, obj){
		return;
		var p_fm = parent.document.form1;			
		var fm = document.form1;
		var b_size = toInt(fm.deb1_size.value);
		var c_size = toInt(fm.deb2_size.value);		
		obj.value = parseDecimal(obj.value);
		fm.h_over_amt[b_size+idx].value = obj.value;		
		fm.t_last_amt[b_size+idx].value = parseDecimal(toInt(parseDigit(fm.last_amt[b_size+idx].value)) + toInt(parseDigit(fm.h_last_amt[b_size+idx].value)));
		fm.t_over_amt[b_size+idx].value = parseDecimal(toInt(parseDigit(fm.over_amt[b_size+idx].value)) + toInt(parseDigit(fm.h_over_amt[b_size+idx].value)));

		fm.c_last_amt.value = "0";
		fm.c_over_amt.value = "0";
		fm.c_new_amt.value 	= "0";
		fm.c_plan_amt.value = "0";
		fm.c_pay_amt.value 	= "0";
		fm.c_jan_amt.value 	= "0";
		fm.ch_last_amt.value= "0";
		fm.ch_over_amt.value= "0";
		fm.ch_new_amt.value = "0";
		fm.ch_plan_amt.value= "0";
		fm.ch_pay_amt.value = "0";
		fm.ch_jan_amt.value = "0";
		fm.ct_last_amt.value= "0";
		fm.ct_over_amt.value= "0";
		fm.ct_new_amt.value = "0";
		fm.ct_plan_amt.value= "0";
		fm.ct_pay_amt.value = "0";
		fm.ct_jan_amt.value = "0";
		
		for(i=b_size; i<b_size+c_size; i++){
			//합계 -시설자금
			fm.c_last_amt.value = parseDecimal(toInt(parseDigit(fm.c_last_amt.value)) + toInt(parseDigit(fm.last_amt[i].value)));
			fm.c_over_amt.value = parseDecimal(toInt(parseDigit(fm.c_over_amt.value)) + toInt(parseDigit(fm.over_amt[i].value)));
			fm.c_new_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_new_amt.value)) + toInt(parseDigit(fm.new_amt[i].value)));
			fm.c_plan_amt.value = parseDecimal(toInt(parseDigit(fm.c_plan_amt.value)) + toInt(parseDigit(fm.plan_amt[i].value)));
			fm.c_pay_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_pay_amt.value)) + toInt(parseDigit(fm.pay_amt[i].value)));
			fm.c_jan_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_jan_amt.value)) + toInt(parseDigit(fm.jan_amt[i].value)));
			//합계 -운전자금 한도
			fm.ch_last_amt.value= parseDecimal(toInt(parseDigit(fm.ch_last_amt.value)) + toInt(parseDigit(fm.h_last_amt[i].value)));
			fm.ch_over_amt.value= parseDecimal(toInt(parseDigit(fm.ch_over_amt.value)) + toInt(parseDigit(fm.h_over_amt[i].value)));
			fm.ch_new_amt.value = parseDecimal(toInt(parseDigit(fm.ch_new_amt.value)) + toInt(parseDigit(fm.h_new_amt[i].value)));
			fm.ch_plan_amt.value= parseDecimal(toInt(parseDigit(fm.ch_plan_amt.value)) + toInt(parseDigit(fm.h_plan_amt[i].value)));
			fm.ch_pay_amt.value = parseDecimal(toInt(parseDigit(fm.ch_pay_amt.value)) + toInt(parseDigit(fm.h_pay_amt[i].value)));
			fm.ch_jan_amt.value = parseDecimal(toInt(parseDigit(fm.ch_jan_amt.value)) + toInt(parseDigit(fm.h_jan_amt[i].value)));
			//합계 -소계
			fm.ct_last_amt.value= parseDecimal(toInt(parseDigit(fm.ct_last_amt.value)) + toInt(parseDigit(fm.t_last_amt[i].value)));
			fm.ct_over_amt.value= parseDecimal(toInt(parseDigit(fm.ct_over_amt.value)) + toInt(parseDigit(fm.t_over_amt[i].value)));
			fm.ct_new_amt.value = parseDecimal(toInt(parseDigit(fm.ct_new_amt.value)) + toInt(parseDigit(fm.t_new_amt[i].value)));
			fm.ct_plan_amt.value= parseDecimal(toInt(parseDigit(fm.ct_plan_amt.value)) + toInt(parseDigit(fm.t_plan_amt[i].value)));
			fm.ct_pay_amt.value = parseDecimal(toInt(parseDigit(fm.ct_pay_amt.value)) + toInt(parseDigit(fm.t_pay_amt[i].value)));
			fm.ct_jan_amt.value = parseDecimal(toInt(parseDigit(fm.ct_jan_amt.value)) + toInt(parseDigit(fm.t_jan_amt[i].value)));
		}
		//총계
		set_tot_amt();
	}	
	
	//운전자금 입력받아 합계 구하기
	function set_g_amt(idx, obj){
		return;
		var p_fm = parent.document.form1;			
		var fm = document.form1;
		var b_size = toInt(fm.deb1_size.value);
		var c_size = toInt(fm.deb2_size.value);		
		var g_size = toInt(fm.deb3_size.value);				
		obj.value = parseDecimal(obj.value);
		fm.h_over_amt[b_size+c_size+idx].value = obj.value;		
		fm.t_last_amt[b_size+c_size+idx].value = parseDecimal(toInt(parseDigit(fm.last_amt[b_size+c_size+idx].value)) + toInt(parseDigit(fm.h_last_amt[b_size+c_size+idx].value)));
		fm.t_over_amt[b_size+c_size+idx].value = parseDecimal(toInt(parseDigit(fm.over_amt[b_size+c_size+idx].value)) + toInt(parseDigit(fm.h_over_amt[b_size+c_size+idx].value)));

		fm.g_last_amt.value = "0";
		fm.g_over_amt.value = "0";
		fm.g_new_amt.value 	= "0";
		fm.g_plan_amt.value = "0";
		fm.g_pay_amt.value 	= "0";
		fm.g_jan_amt.value 	= "0";
		fm.gh_last_amt.value= "0";
		fm.gh_over_amt.value= "0";
		fm.gh_new_amt.value = "0";
		fm.gh_plan_amt.value= "0";
		fm.gh_pay_amt.value = "0";
		fm.gh_jan_amt.value = "0";
		fm.gt_last_amt.value= "0";
		fm.gt_over_amt.value= "0";
		fm.gt_new_amt.value = "0";
		fm.gt_plan_amt.value= "0";
		fm.gt_pay_amt.value = "0";
		fm.gt_jan_amt.value = "0";
		
		for(i=b_size+c_size; i<b_size+c_size+g_size; i++){
			//합계 -시설자금
			fm.g_last_amt.value = parseDecimal(toInt(parseDigit(fm.g_last_amt.value)) + toInt(parseDigit(fm.last_amt[i].value)));
			fm.g_over_amt.value = parseDecimal(toInt(parseDigit(fm.g_over_amt.value)) + toInt(parseDigit(fm.over_amt[i].value)));
			fm.g_new_amt.value 	= parseDecimal(toInt(parseDigit(fm.g_new_amt.value)) + toInt(parseDigit(fm.new_amt[i].value)));
			fm.g_plan_amt.value = parseDecimal(toInt(parseDigit(fm.g_plan_amt.value)) + toInt(parseDigit(fm.plan_amt[i].value)));
			fm.g_pay_amt.value 	= parseDecimal(toInt(parseDigit(fm.g_pay_amt.value)) + toInt(parseDigit(fm.pay_amt[i].value)));
			fm.g_jan_amt.value 	= parseDecimal(toInt(parseDigit(fm.g_jan_amt.value)) + toInt(parseDigit(fm.jan_amt[i].value)));
			//합계 -운전자금 한도
			fm.gh_last_amt.value= parseDecimal(toInt(parseDigit(fm.gh_last_amt.value)) + toInt(parseDigit(fm.h_last_amt[i].value)));
			fm.gh_over_amt.value= parseDecimal(toInt(parseDigit(fm.gh_over_amt.value)) + toInt(parseDigit(fm.h_over_amt[i].value)));
			fm.gh_new_amt.value = parseDecimal(toInt(parseDigit(fm.gh_new_amt.value)) + toInt(parseDigit(fm.h_new_amt[i].value)));
			fm.gh_plan_amt.value= parseDecimal(toInt(parseDigit(fm.gh_plan_amt.value)) + toInt(parseDigit(fm.h_plan_amt[i].value)));
			fm.gh_pay_amt.value = parseDecimal(toInt(parseDigit(fm.gh_pay_amt.value)) + toInt(parseDigit(fm.h_pay_amt[i].value)));
			fm.gh_jan_amt.value = parseDecimal(toInt(parseDigit(fm.gh_jan_amt.value)) + toInt(parseDigit(fm.h_jan_amt[i].value)));
			//합계 -소계
			fm.gt_last_amt.value= parseDecimal(toInt(parseDigit(fm.gt_last_amt.value)) + toInt(parseDigit(fm.t_last_amt[i].value)));
			fm.gt_over_amt.value= parseDecimal(toInt(parseDigit(fm.gt_over_amt.value)) + toInt(parseDigit(fm.t_over_amt[i].value)));
			fm.gt_new_amt.value = parseDecimal(toInt(parseDigit(fm.gt_new_amt.value)) + toInt(parseDigit(fm.t_new_amt[i].value)));
			fm.gt_plan_amt.value= parseDecimal(toInt(parseDigit(fm.gt_plan_amt.value)) + toInt(parseDigit(fm.t_plan_amt[i].value)));
			fm.gt_pay_amt.value = parseDecimal(toInt(parseDigit(fm.gt_pay_amt.value)) + toInt(parseDigit(fm.t_pay_amt[i].value)));
			fm.gt_jan_amt.value = parseDecimal(toInt(parseDigit(fm.gt_jan_amt.value)) + toInt(parseDigit(fm.t_jan_amt[i].value)));
		}
		//총계
		set_tot_amt();
	}	
	
	function set_tot_amt(){
		var p_fm = parent.document.form1;		
		var fm = document.form1;
		
		//총계
		p_fm.tot_last_amt.value= parseDecimal(toInt(parseDigit(fm.bt_last_amt.value)) + toInt(parseDigit(fm.ct_last_amt.value)) + toInt(parseDigit(fm.gt_last_amt.value)));
		p_fm.tot_over_amt.value= parseDecimal(toInt(parseDigit(fm.bt_over_amt.value)) + toInt(parseDigit(fm.ct_over_amt.value)) + toInt(parseDigit(fm.gt_over_amt.value)));
		p_fm.tot_new_amt.value = parseDecimal(toInt(parseDigit(fm.bt_new_amt.value))  + toInt(parseDigit(fm.ct_new_amt.value))  + toInt(parseDigit(fm.gt_new_amt.value)));
		p_fm.tot_plan_amt.value= parseDecimal(toInt(parseDigit(fm.bt_plan_amt.value)) + toInt(parseDigit(fm.ct_plan_amt.value)) + toInt(parseDigit(fm.gt_plan_amt.value)));
		p_fm.tot_pay_amt.value = parseDecimal(toInt(parseDigit(fm.bt_pay_amt.value))  + toInt(parseDigit(fm.ct_pay_amt.value))  + toInt(parseDigit(fm.gt_pay_amt.value)));
		p_fm.tot_jan_amt.value = parseDecimal(toInt(parseDigit(fm.bt_jan_amt.value))  + toInt(parseDigit(fm.ct_jan_amt.value))  + toInt(parseDigit(fm.gt_jan_amt.value)));		
		
		//총계에서 운전자금은 뺀다.
		//p_fm.tot_last_amt.value= parseDecimal(toInt(parseDigit(p_fm.tot_last_amt.value)) - toInt(parseDigit(fm.bh_last_amt.value)) + toInt(parseDigit(fm.bj_last_amt.value)));		
		//p_fm.tot_over_amt.value= parseDecimal(toInt(parseDigit(p_fm.tot_over_amt.value)) - toInt(parseDigit(fm.bh_over_amt.value)) + toInt(parseDigit(fm.bj_over_amt.value)));
		
	}
	
		
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String st = "1";
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//은행 부채현황
	Vector deb1s = ad_db.getStatDebt(br_id, save_dt, "1");
	int deb1_size = deb1s.size();
	//기타금융기관 부채현황
	Vector deb2s = ad_db.getStatDebt(br_id, save_dt, "2");
	int deb2_size = deb2s.size();
	//그외 기타 부채현황
	Vector deb3s = ad_db.getStatDebt(br_id, save_dt, "3");
	int deb3_size = deb3s.size();
%>
<form action="stat_debt_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='deb1_size' value='<%=deb1_size%>'>
<input type='hidden' name='deb2_size' value='<%=deb2_size%>'>
<input type='hidden' name='deb3_size' value='<%=deb3_size%>'>
<input type='hidden' name='tot_size' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

    <tr>
	    <td class='line'>		
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
              <%for (int i = 0 ; i < deb1_size ; i++){
    				Hashtable deb1 = (Hashtable)deb1s.elementAt(i);
    				String cpt_cd = (String)deb1.get("CPT_CD");    				
					String h_amt = (String)deb1.get("WHAN_AMT");
					String j_amt = (String)deb1.get("J_AMT");
					//20210119 운전자금 관리 안한다.
					h_amt = "0";
					j_amt = "0";
					/*
    				String whan = "0";
    				if(String.valueOf(deb1.get("WHAN_AMT")).equals("0")){
    					if(cpt_cd.equals("0005")) whan = "800,000,000";
    					else if(cpt_cd.equals("0004")) whan = "0";
    					else if(cpt_cd.equals("0001")) whan = "0";
    					else if(cpt_cd.equals("0007")) whan = "300,000,000";
    				}else{
    					whan = AddUtil.parseDecimal2(String.valueOf(deb1.get("WHAN_AMT")));
    				}
					*/%>
                <tr> 
                    <%if(i == 0){%>
                    <td align="center" width=7% rowspan="<%=4*(deb1_size+1)%>">은행</td>
                    <%}%>
                    <td align="center" width=3% rowspan="4"><%=i+1%></td>
                    <td align="center" width=15% rowspan="4"><%=c_db.getNameById(String.valueOf(deb1.get("CPT_CD")), "BANK")%>
                      <input type='hidden' name='cpt_cd' value='<%=deb1.get("CPT_CD")%>'>					  
                    </td>
                    <td align="center" colspan="2">시설자금</td>
                    <td align="center" width=10%> 
                      <input type="text" name="last_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb1.get("LAST_MON_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center" width=10%> 
                      <input type="text" name="over_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb1.get("OVER_MON_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center" width=10%> 
                      <input type="text" name="new_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_NEW_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center" width=10%> 
                      <input type="text" name="plan_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_PLAN_AMT")))%>" class="whitenum">
        			  <input type="hidden" name="plan_prn" value="<%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_PLAN_AMT")))%>">
          			  <input type="hidden" name="plan_int" value="<%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_PLAN_INT_AMT")))%>">
                    </td>
                    <td align="center" width=10%> 
                      <input type="text" name="pay_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_PAY_AMT")))%>" class="whitenum">
        			  <input type="hidden" name="pay_prn" value="<%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_PAY_AMT")))%>">
          			  <input type="hidden" name="pay_int" value="<%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_PAY_INT_AMT")))%>">
                    </td>
                    <td align="center" width=10%> 
                      <input type="text" name="jan_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_JAN_AMT")))%>" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td align="center" rowspan="2">운전<br>
                      자금					  
					</td>
                    <td align="center">한도</td>
                    <td align="center">
                      <input type="text" name="h_last_amt" size="13" value="<%=AddUtil.parseDecimal2(h_amt)%>" class="num" onBlur="javascript:set_b_amt(<%=i%>, this)">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_over_amt" size="13" value="<%=AddUtil.parseDecimal2(h_amt)%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_new_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_plan_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_pay_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_jan_amt" size="13" value="0" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td align="center">잔액</td>
                    <td align="center">
                      <input type="text" name="j_last_amt" size="13" value="<%=AddUtil.parseDecimal2(j_amt)%>" class="num" onBlur="javascript:set_b_amt(<%=i%>, this)">
                    </td>
                    <td align="center"> 
                      <input type="text" name="j_over_amt" size="13" value="<%=AddUtil.parseDecimal2(j_amt)%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="j_new_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="j_plan_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="j_pay_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="j_jan_amt" size="13" value="0" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="is"  align="center" colspan="2">소계</td>
                    <td class="is"  align="center">
                      <input type="text" name="t_last_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_over_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_new_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_plan_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_pay_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_jan_amt" size="13" value="" class="isnum">
                    </td>
                </tr>
                <%}		  %>
                <tr> 
                    <td align="center" rowspan="4" colspan="2">합계</td>
                    <td align="center" colspan="2">시설자금</td>
                    <td align="center">
                      <input type="text" name="b_last_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="b_over_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="b_new_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="b_plan_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="b_pay_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="b_jan_amt" size="13" value="" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td align="center" rowspan="2">운전<br>
                      자금</td>
                    <td align="center">한도</td>
                    <td align="center">
                      <input type="text" name="bh_last_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="bh_over_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="bh_new_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="bh_plan_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="bh_pay_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="bh_jan_amt" size="13" value="0" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td align="center">잔액</td>
                    <td align="center">
                      <input type="text" name="bj_last_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="bj_over_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="bj_new_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="bj_plan_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="bj_pay_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="bj_jan_amt" size="13" value="0" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title_p"  align="center" colspan="2">소계</td>
                    <td class="title_p"  align="center">
                      <input type="text" name="bt_last_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center"> 
                      <input type="text" name="bt_over_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center"> 
                      <input type="text" name="bt_new_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center"> 
                      <input type="text" name="bt_plan_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center"> 
                      <input type="text" name="bt_pay_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center"> 
                      <input type="text" name="bt_jan_amt" size="13" value="" class="whitenum">
                    </td>
                </tr>
              <%for (int i = 0 ; i < deb2_size ; i++){
    				Hashtable deb2 = (Hashtable)deb2s.elementAt(i);%>
                <tr> 
                <%if(i == 0){%>
                    <td align="center" rowspan="<%=3*(deb2_size+1)%>">은행을<br>제외한<br>기타<br>
                      기관</td>
                    <%}%>
                    <td align="center" width=3% rowspan="3"><%=i+1%></td>
                    <td align="center" rowspan="3"><%=c_db.getNameById(String.valueOf(deb2.get("CPT_CD")), "BANK")%>
                      <input type='hidden' name='cpt_cd' value='<%=deb2.get("CPT_CD")%>'>
                    </td>
                    <td align="center" colspan="2">시설자금</td>
                    <td align="center"> 
                      <input type="text" name="last_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("LAST_MON_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="over_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("OVER_MON_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="new_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_NEW_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="plan_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PLAN_AMT")))%>" class="whitenum">
        			  <input type="hidden" name="plan_prn" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PLAN_AMT")))%>">
          			  <input type="hidden" name="plan_int" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PLAN_INT_AMT")))%>">
                    </td>
                    <td align="center"> 
                      <input type="text" name="pay_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PAY_AMT")))%>" class="whitenum">
        			  <input type="hidden" name="pay_prn" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PAY_AMT")))%>">
          			  <input type="hidden" name="pay_int" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PAY_INT_AMT")))%>">
                    </td>
                    <td align="center"> 
                      <input type="text" name="jan_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_JAN_AMT")))%>" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td align="center" colspan="2">기타</td>
                    <td align="center">
                      <input type="text" name="h_last_amt" size="13" value="0" class="num" onBlur="javascript:set_c_amt(<%=i%>, this)">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_over_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_new_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_plan_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_pay_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_jan_amt" size="13" value="0" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="is"  align="center" colspan="2">소계</td>
                    <td class="is"  align="center">
                      <input type="text" name="t_last_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_over_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_new_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_plan_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_pay_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_jan_amt" size="13" value="" class="isnum">
                    </td>
                </tr>
                <%	}%>
                <tr> 
                    <td align="center" rowspan="3" colspan="2">합계</td>
                    <td align="center" colspan="2">시설자금</td>
                    <td align="center">
                      <input type="text" name="c_last_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="c_over_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="c_new_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="c_plan_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="c_pay_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="c_jan_amt" size="13" value="" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td align="center" colspan="2">기타</td>
                    <td align="center">
                      <input type="text" name="ch_last_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="ch_over_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="ch_new_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="ch_plan_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="ch_pay_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="ch_jan_amt" size="13" value="0" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title_p"  align="center" colspan="2">합계</td>
                    <td class="title_p"  align="center"> 
                      <input type="text" name="ct_last_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center">
                      <input type="text" name="ct_over_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center">
                      <input type="text" name="ct_new_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center">
                      <input type="text" name="ct_plan_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center">
                      <input type="text" name="ct_pay_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center">
                      <input type="text" name="ct_jan_amt" size="13" value="" class="whitenum">
                    </td>
                </tr>		  
                <%for (int i = 0 ; i < deb3_size ; i++){
				Hashtable deb3 = (Hashtable)deb3s.elementAt(i);%>
                <tr> 
                    <%if(i == 0){%>
                    <td align="center" rowspan="<%=3*(deb3_size+1)%>">기타</td>
                    <%}%>
                    <td align="center" width=3% rowspan="3"><%=i+1%></td>
                    <td align="center" rowspan="3"><%=c_db.getNameById(String.valueOf(deb3.get("CPT_CD")), "BANK")%>
                      <input type='hidden' name='cpt_cd' value='<%=deb3.get("CPT_CD")%>'>
                    </td>
                    <td align="center" colspan="2">시설자금</td>
                    <td align="center"> 
                      <input type="text" name="last_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb3.get("LAST_MON_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="over_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb3.get("OVER_MON_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="new_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_NEW_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="plan_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_PLAN_AMT")))%>" class="whitenum">
        			  <input type="hidden" name="plan_prn" value="<%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_PLAN_AMT")))%>">
          			  <input type="hidden" name="plan_int" value="<%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_PLAN_INT_AMT")))%>">
                    </td>
                    <td align="center"> 
                      <input type="text" name="pay_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_PAY_AMT")))%>" class="whitenum">
        			  <input type="hidden" name="pay_prn" value="<%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_PAY_AMT")))%>">
          			  <input type="hidden" name="pay_int" value="<%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_PAY_INT_AMT")))%>">
                    </td>
                    <td align="center"> 
                      <input type="text" name="jan_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_JAN_AMT")))%>" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td align="center" colspan="2">기타</td>
                    <td align="center">
                      <input type="text" name="h_last_amt" size="13" value="0" class="num" onBlur="javascript:set_g_amt(<%=i%>, this)">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_over_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_new_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_plan_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_pay_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="h_jan_amt" size="13" value="0" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="is"  align="center" colspan="2">소계</td>
                    <td class="is"  align="center">
                      <input type="text" name="t_last_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_over_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_new_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_plan_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_pay_amt" size="13" value="" class="isnum">
                    </td>
                    <td class="is"  align="center"> 
                      <input type="text" name="t_jan_amt" size="13" value="" class="isnum">
                    </td>
                </tr>
                <tr> 
                    <td align="center" rowspan="3" colspan="2">합계</td>
                    <td align="center" colspan="2">시설자금</td>
                    <td align="center">
                      <input type="text" name="g_last_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="g_over_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="g_new_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="g_plan_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="g_pay_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="g_jan_amt" size="13" value="" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td align="center" colspan="2">기타</td>
                    <td align="center">
                      <input type="text" name="gh_last_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="gh_over_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="gh_new_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="gh_plan_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="gh_pay_amt" size="13" value="0" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="gh_jan_amt" size="13" value="0" class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title_p"  align="center" colspan="2">소계</td>
                    <td class="title_p"  align="center"> 
                      <input type="text" name="gt_last_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center">
                      <input type="text" name="gt_over_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center">
                      <input type="text" name="gt_new_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center">
                      <input type="text" name="gt_plan_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center">
                      <input type="text" name="gt_pay_amt" size="13" value="" class="whitenum">
                    </td>
                    <td class="title_p"  align="center">
                      <input type="text" name="gt_jan_amt" size="13" value="" class="whitenum">
                    </td>
                </tr>
				<%}%>				
                <%if(deb3_size==0){%>		  				
				<input type='hidden' name="gt_last_amt" value='0'>
				<input type='hidden' name="gt_over_amt" value='0'>
				<input type='hidden' name="gt_new_amt" value='0'>
				<input type='hidden' name="gt_plan_amt" value='0'>
				<input type='hidden' name="gt_pay_amt" value='0'>
				<input type='hidden' name="gt_jan_amt" value='0'>
				<%}%>
            </table>
		</td>
	</tr>
</table>		
</form>
<script language='javascript'>
<!--
	set_debt();
	
	//parent.i_view.height = <%=deb1_size+deb2_size+deb2_size%>*80;
//-->
</script>
</body>
</html>
