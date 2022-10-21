<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
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
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String garnish_yn_opt_st = request.getParameter("garnish_yn_opt_st")==null?"":request.getParameter("garnish_yn_opt_st");
	String hook_yn_opt_st = request.getParameter("hook_yn_opt_st")==null?"":request.getParameter("hook_yn_opt_st");
	
	//차종변수별 리스트
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	Vector vars = e_db.getCarSubListLcRent(idx, car_comp_id, car_cd, car_id, car_seq, a_a, t_wd);
	int size = vars.size();
	
	//tuix/tuon 카운트
	int tuix_count = 0;
	
	if(idx.equals("2")||idx.equals("3")){
		//차명정보
		cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
		
	}	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<style>
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
	function setCode(id, seq, nm, amt, s_st, dpm, jg_opt_st, auto_yn, car_b, end_dt, jg_tuix_st, lkas_yn, ldws_yn, aeb_yn, fcw_yn, jg_opt_yn, garnish_yn, hook_yn){
		var fm = opener.document.form1;
		
		// del
		//alert(lkas_yn + '\n' + ldws_yn + '\n' + aeb_yn + '\n' +fcw_yn);
				
		<%if(idx.equals("1")){%>
		if(end_dt == 'N'){
			if(!confirm('이 차종은 단산된 차종으로 재고 확인 바랍니다.')){	return;	}	
		}
		fm.car_name.value = nm;
		fm.car_id.value = id;
		fm.car_seq.value = seq;
		fm.car_amt.value = parseDecimal(amt);
		fm.car_s_amt.value =  parseDecimal(sup_amt(amt));
		fm.car_v_amt.value =  parseDecimal(amt-sup_amt(amt));	
		fm.auto_yn.value = auto_yn;
		fm.car_b.value = car_b;
		fm.jg_tuix_st.value = jg_tuix_st;
		fm.jg_tuix_opt_st.value = '';
		fm.lkas_yn.value = lkas_yn;		// 차선이탈 제어형 (차종포함)
		fm.lkas_yn_opt_st.value = '';	// 차선이탈 제어형 (옵션)
		fm.ldws_yn.value = ldws_yn;	// 차선이탈 경고형 (차종포함)
		fm.ldws_yn_opt_st.value = '';	//	차선이탈 경고형 (옵션)
		fm.aeb_yn.value = aeb_yn;		// 긴급제동 제어형 (차종포함)
		fm.aeb_yn_opt_st.value = '';	// 긴급제동 제어형 (옵션)
		fm.fcw_yn.value = fcw_yn;		// 긴급제동 경고형 (차종포함)
		fm.fcw_yn_opt_st.value = '';		// 긴급제동 경고형 (옵션)
		fm.garnish_yn_opt_st.value = '';		// 가니쉬 (옵션)
		fm.garnish_yn.value = garnish_yn;		// 가니쉬 (옵션)
		fm.hook_yn_opt_st.value = '';		// 견인고리 (옵션)
		fm.hook_yn.value = hook_yn;		// 견인고리 (옵션)
		<%	if(from_page.equals("/fms2/lc_rent/lc_cng_car_frame.jsp")||from_page.equals("/fms2/lc_rent/reset_car.jsp")){%>
		fm.s_st.value = s_st;
		fm.dpm.value = dpm;
		fm.opt.value = '';
		fm.opt_seq.value = '';			
		fm.opt_s_amt.value = '';
		fm.opt_v_amt.value = '';
		fm.opt_amt.value = '';
		fm.opt_amt_m.value = '';
		fm.jg_opt_st.value = '';		
		fm.col.value = '';
		fm.col_seq.value = '';			
		fm.col_s_amt.value = '';
		fm.col_v_amt.value = '';
		fm.col_amt.value = '';		
		fm.jg_col_st.value = '';
		<%	}%>	
		<%}else if(idx.equals("2")){%>
		fm.opt.value = nm;
		fm.opt_seq.value = id;
		fm.opt_amt.value = parseDecimal(amt);
		if (jg_opt_yn == "N") {
			fm.opt_amt_m.value = parseDecimal(amt);	
		} else {
			fm.opt_amt_m.value = "0";
		}
		fm.opt_s_amt.value =  parseDecimal(sup_amt(amt));
		fm.opt_v_amt.value =  parseDecimal(amt-sup_amt(amt));	
		fm.jg_opt_st.value = jg_opt_st;	
		fm.jg_tuix_opt_st.value = jg_tuix_st;
		fm.lkas_yn_opt_st.value = lkas_yn;		// 차선이탈 제어형 (옵션)
		fm.ldws_yn_opt_st.value = ldws_yn;		//	차선이탈 경고형 (옵션)
		fm.aeb_yn_opt_st.value = aeb_yn;		// 긴급제동 제어형 (옵션)
		fm.fcw_yn_opt_st.value = fcw_yn;		// 긴급제동 경고형 (옵션)
		fm.garnish_yn_opt_st.value = garnish_yn;		// 가니쉬 (옵션)
		fm.hook_yn_opt_st.value = hook_yn;		// 견인고리 (옵션)
		<%}else if(idx.equals("3")){%>
		fm.col.value = nm;
		fm.col_seq.value = id;
		fm.col_amt.value = parseDecimal(amt);
		fm.col_s_amt.value =  parseDecimal(sup_amt(amt));
		fm.col_v_amt.value =  parseDecimal(amt-sup_amt(amt));	
		fm.jg_col_st.value = jg_opt_st;		
		<%}else if(idx.equals("5")){%>
		fm.conti_rat.value = nm;
		fm.conti_rat_seq.value = seq;
		<%}%>
		
		fm.o_1.value 		= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)));
		fm.o_1_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_s_amt.value)) + toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.col_s_amt.value)));
		fm.o_1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_v_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)) + toInt(parseDigit(fm.col_v_amt.value)));		
		
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
		var lkas_yn_sts="";	// 차선이탈 제어형 옵션
		var ldws_yn_sts="";	// 차선이탈 경고형 옵션
		var aeb_yn_sts="";	// 긴급제동 제어형 옵션
		var fcw_yn_sts="";	// 긴급제동 경고형 옵션
		var jg_opt_yns= "";
		var garnish_yn_sts="";	// 가니쉬 옵션
		var hook_yn_sts="";	// 견인고리 옵션
		var o_split;
		
		<%if(idx.equals("2")){%>
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];	
			
			if(ck.name == "car_s_seq"){		
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
				}
			}
		}	
		if(cnt == 0){
//		 	alert("선택사양을 선택하세요.");
//			return;
		}
		ofm.opt.value 		= opts;
		ofm.opt_seq.value 	= codes;
		ofm.opt_amt.value 	= parseDecimal(amts);
		ofm.opt_amt_m.value = parseDecimal(amts_m);	
		ofm.opt_s_amt.value 	= parseDecimal(sup_amt(amts));
		ofm.opt_v_amt.value 	= parseDecimal(amts-sup_amt(amts));				
		ofm.o_1.value 		= parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)));		
		ofm.o_1_s_amt.value 	= parseDecimal(toInt(parseDigit(ofm.car_s_amt.value)) + toInt(parseDigit(ofm.opt_s_amt.value)) + toInt(parseDigit(ofm.col_s_amt.value)));
		ofm.o_1_v_amt.value 	= parseDecimal(toInt(parseDigit(ofm.car_v_amt.value)) + toInt(parseDigit(ofm.opt_v_amt.value)) + toInt(parseDigit(ofm.col_v_amt.value)));	
		
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
//		 	alert("외장색상을 선택하세요.");
//			return;
		}
				
		ofm.col.value = opts;
		ofm.col_seq.value = codes;
		ofm.col_amt.value = parseDecimal(amts);
				
		codes="";
		amts=0;	
		opts="";
		
		codes2="";
		amts2=0;	
		opts2="";
		
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
				}
			}
		}
		
		for(var z=0 ; z<len; z++){
			var ck=fm.elements[z];		
			if(ck.name == "car_gar_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes2 	+= o_split[0];
					opts2 	+= o_split[1];
					amts2 	+= toInt(o_split[2]);
				}
			}
		}
		
		ofm.in_col.value = opts;
		ofm.garnish_col.value = opts2;
		
		ofm.col_amt.value 	= parseDecimal(toInt(parseDigit(ofm.col_amt.value)) + amts + amts2);				
		ofm.col_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(ofm.col_amt.value))));
		ofm.col_v_amt.value 	= parseDecimal(toInt(parseDigit(ofm.col_amt.value))-sup_amt(toInt(parseDigit(ofm.col_amt.value))));				
		ofm.o_1.value 		= parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)));		
		ofm.o_1_s_amt.value 	= parseDecimal(toInt(parseDigit(ofm.car_s_amt.value)) + toInt(parseDigit(ofm.opt_s_amt.value)) + toInt(parseDigit(ofm.col_s_amt.value)));
		ofm.o_1_v_amt.value 	= parseDecimal(toInt(parseDigit(ofm.car_v_amt.value)) + toInt(parseDigit(ofm.opt_v_amt.value)) + toInt(parseDigit(ofm.col_v_amt.value)));		
		
		<%}%>
				
		self.close();
	}
	
	function search(){
		var fm = document.form1;
		if(fm.t_wd.value == '') { alert('검색어를 입력하십시오.'); return; }
		fm.action = 'search_esti_sub_list.jsp';
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
	
	function old_car(){
		var fm = document.form1;
		fm.action = 'search_esti_sub_oldcar_list.jsp';
		fm.submit();
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
	
//-->
</script>
</head>
<body>
<form name='form1' action='search_esti_sub_list.jsp' method='post'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='a_a' value='<%=a_a%>'>
<input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
<input type='hidden' name='car_cd' value='<%=car_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='car_seq' value='<%=car_seq%>'>
<input type='hidden' name='car_nm' value='<%=car_nm%>'>
<input type='hidden' name='size' value='<%=size%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5><%if(idx.equals("1")){%>차종<%}else if(idx.equals("2")){%>옵션<%}else if(idx.equals("3")){%>색상<%}%> </span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr> 
        <td align="right"> <font color=red> → 현재데이타</font> | <a href="javascript:old_car();">모든데이타</a>&nbsp;</td>
    </tr>      
    <tr> 
        <td>&nbsp;&nbsp; <%if(idx.equals("1")){%><img src=/acar/images/center/arrow_cj_p.gif align=absmiddle><%}else if(idx.equals("2")){%><img src=/acar/images/center/arrow_op_p.gif align=absmiddle><%}else if(idx.equals("3")){%><img src=/acar/images/center/arrow_color_p.gif align=absmiddle><%}%> &nbsp;<input type='text' name='t_wd' size='35' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()'>&nbsp;<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr> 
        <td>※ 최근 업데이트 기준의 사용중인 모델만 나옵니다. 리스트에 없으면 차종명 혹은 가격을 입력하고 모든데이타를 클릭하여 검색하세요.</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width="5%"><%if(idx.equals("2") || idx.equals("3")){%>선택<%}else{%>연번<%}%></td>
                    <td class="title" width="40%">
                    	<%if(idx.equals("1")){%>차종<%}else if(idx.equals("2")){%>옵션<%}else if(idx.equals("3")){%>색상<%}else if(idx.equals("5")){%>엔진<%}%>
                    </td>
                    <%if(idx.equals("1")){%>
                    <td class="title" width="5%">연식</td>			
                    <td class="title" width="15%">가격</td>
                    <td class="title" width="10%">기준일자</td>
                    <%}else if(idx.equals("5")){ %>
                   
                    <td class="title" width="25%">복합연비</td>
                    <%}else{%>
                    <td class="title" width="15%">가격</td>
                    <td class="title" width="15%">기준일자</td>			
                    <%}%>
                    <td class="title" width="25%">비고</td>			
                </tr>
                
		<%if (idx.equals("2")) {%>		
			<%for(int i = 0 ; i < size ; i++){
					Hashtable var = (Hashtable)vars.elementAt(i);
   				
	   				if (String.valueOf(var.get("JG_TUIX_ST")).equals("Y")) {
						tuix_count++;
					}
			%>
   				<%if (String.valueOf(var.get("JG_TUIX_ST")).equals("")) {%>
   				<tr>
   					<td align="center">
   						<input type="checkbox" name="car_s_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>||<%=var.get("LKAS_YN")%>||<%=var.get("LDWS_YN")%>||<%=var.get("AEB_YN")%>||<%=var.get("FCW_YN")%>||<%=var.get("JG_OPT_YN")%>||<%=var.get("GARNISH_YN")%>||<%=var.get("HOOK_YN")%>'>
   					</td>
   					<td>&nbsp;
   						<a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("DPM")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("AUTO_YN")%>', '<%=var.get("CAR_B")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("JG_OPT_YN")%>', '<%=var.get("GARNISH_YN")%>', '<%=var.get("HOOK_YN")%>');"><%=var.get("NM")%></a>
   					</td>
   					<td align="right">&nbsp;<%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원&nbsp;&nbsp;</td>						
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(var.get("BASE_DT")))%></td>									
                    <td align="center"><%=var.get("ETC")%></td>
   				</tr>
   				<%}%>
   		  	<%}%>
   		  	
   		  	<%if (tuix_count > 0) {%>
				<tr>
					<td colspan="5" style="height: 40px;">
						<div id="tuix" onclick="tuix_click();">
							TUIX/TUON 옵션 보기
						</div>
					</td>
				</tr>
			<%}%>
			
			<%for(int i = 0 ; i < size ; i++){
					Hashtable var = (Hashtable)vars.elementAt(i);   				
			%>
   				<%if (String.valueOf(var.get("JG_TUIX_ST")).equals("Y")) {%>
   				<tr class="hide" style="display: none;">
   					<td align="center">
   						<input type="checkbox" name="car_s_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>||<%=var.get("LKAS_YN")%>||<%=var.get("LDWS_YN")%>||<%=var.get("AEB_YN")%>||<%=var.get("FCW_YN")%>||<%=var.get("JG_OPT_YN")%>||<%=var.get("GARNISH_YN")%>||<%=var.get("HOOK_YN")%>'>
   					</td>
   					<td>&nbsp;
   						<a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("DPM")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("AUTO_YN")%>', '<%=var.get("CAR_B")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("JG_OPT_YN")%>', '<%=var.get("GARNISH_YN")%>', '<%=var.get("HOOK_YN")%>');"><%=var.get("NM")%></a>
   					</td>
   					<td align="right">&nbsp;<%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원&nbsp;&nbsp;</td>						
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(var.get("BASE_DT")))%></td>									
                    <td align="center"><%=var.get("ETC")%></td>
   				</tr>
   				<%}%>
   		  	<%}%>
   		  	
		<%} else {%>  
		
           	<%for(int i = 0 ; i < size ; i++){
   				Hashtable var = (Hashtable)vars.elementAt(i);%>
                <tr> 
                    <td align="center">
                        <%if(idx.equals("2")){%>
                            <input type="checkbox" name="car_s_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>||<%=var.get("LKAS_YN")%>||<%=var.get("LDWS_YN")%>||<%=var.get("AEB_YN")%>||<%=var.get("FCW_YN")%>||<%=var.get("JG_OPT_YN")%>||<%=var.get("GARNISH_YN")%>||<%=var.get("HOOK_YN")%>'>
                        <%}else if(idx.equals("3")){%>
                            <input type="radio" name="car_s_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>'>
                        <%}else{%>            
                            <%=i+1%>
                        <%}%>
                    </td>
                    <td>&nbsp;
                        <%if(idx.equals("3")){%>
                        <%=var.get("NM")%>
                        <%}else if(idx.equals("5")){%>
                        <%=var.get("ENGINE") %>
                        <%}else{%>
                        <a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("DPM")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("AUTO_YN")%>', '<%=var.get("CAR_B")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '', '<%=var.get("GARNISH_YN")%>', '<%=var.get("HOOK_YN")%>');"><%=var.get("NM")%></a>
                        <%}%>
                    </td>
                    <%if(idx.equals("1")){%>
                    <td align="center"><%=var.get("CAR_Y_FORM")%></td>									
                    <%}else if(idx.equals("5")){%>
                    <td align="center"><a href="javascript:setCode('<%=var.get("CAR_CD")%>','<%=var.get("CAR_SEQ")%>','<%=var.get("CAR_K")%>','','','','','','','','','','','','','','','')"><%=var.get("CAR_K")%></a></td>
                    <%} %>
                    <%if(idx.equals("5")){%>
                    <td><%=var.get("CAR_K_ETC")%></td>
                    <%}else{ %>
                    <td align="right">&nbsp;<%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원&nbsp;&nbsp;</td>						
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(var.get("BASE_DT")))%></td>									
                    <td align="center"><%=var.get("ETC")%></td>
                    <%} %>									
                </tr>
              <%}%>	
              
        <%}%>
              	
            </table>
        </td>
    </tr>
        <!--내장색상-->
        <%if(idx.equals("3")){
        	vars = e_db.getCarSubListLcRent("3_in", car_comp_id, car_cd, car_id, car_seq, a_a, t_wd);
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
                    <td class="title" width=28%>금액</td>					
		    <td class="title" width=33%>비고</td>			
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
        	vars = e_db.getCarSubListLcRent("3_gar", car_comp_id, car_cd, car_id, car_seq, a_a, t_wd);
		size = vars.size();	
        %>
    <tr <%if (garnish_yn_opt_st.equals("")) {%>style="display: none;"<%}%>>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>가니쉬색상</span></td>
    </tr>    
    <tr <%if (garnish_yn_opt_st.equals("")) {%>style="display: none;"<%}%>> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class="title" width=5%>선택</td>
                    <td class="title" width=34%>종류</td>
                    <td class="title" width=28%>금액</td>					
		    <td class="title" width=33%>비고</td>			
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
    <%if(idx.equals("2") || idx.equals("3")){%>
    <tr> 
        <td align="right"> 
            <a href="javascript:save();"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>
        </td>
    </tr>  
    <%}else{%>  
    <tr> 
        <td align="right"><a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>  
    <%}%>  
      
    
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
		ofm.lkas_yn.value		= '';	// 차선이탈 제어형
		ofm.ldws_yn.value	= '';	// 차선이탈 경고형
		ofm.aeb_yn.value		= '';	// 긴급제동 제어형
		ofm.fcw_yn.value		= '';	// 긴급제동 경고형
		ofm.hook_yn.value		= '';	// 견인고리
		ofm.o_1.value 	= '0';
		ofm.o_1_s_amt.value 	= '0';
		ofm.o_1_v_amt.value 	= '0';
		
		ofm.conti_rat.value 	= '';	
		ofm.conti_rat_seq.value 	= '';	
	<%}%>
		
	<%if(idx.equals("1") || idx.equals("2")){%>		
		ofm.opt.value 		= '';
		ofm.opt_seq.value 	= '';
		ofm.opt_amt.value 	= '0';
		ofm.opt_amt_m.value 	= '0';
		ofm.jg_opt_st.value 	= '';	
		ofm.jg_tuix_opt_st.value 	= '';
		ofm.lkas_yn_opt_st.value	= '';	// 차선이탈 제어형
		ofm.ldws_yn_opt_st.value	= '';	// 차선이탈 경고형
		ofm.aeb_yn_opt_st.value 	= '';	// 긴급제동 제어형
		ofm.fcw_yn_opt_st.value 	= '';	// 긴급제동 경고형
		ofm.garnish_yn_opt_st.value 	= '';	// 가니쉬
		ofm.hook_yn_opt_st.value 	= '';	// 견인고리
		
		ofm.garnish_col.value	= '';
		
		ofm.o_1.value 		= parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)));		
		ofm.o_1_s_amt.value 	= parseDecimal(toInt(parseDigit(ofm.car_s_amt.value)) + toInt(parseDigit(ofm.opt_s_amt.value)) + toInt(parseDigit(ofm.col_s_amt.value)));
		ofm.o_1_v_amt.value 	= parseDecimal(toInt(parseDigit(ofm.car_v_amt.value)) + toInt(parseDigit(ofm.opt_v_amt.value)) + toInt(parseDigit(ofm.col_v_amt.value)));
	<%}%>
	
	<%if(idx.equals("1") || idx.equals("3")){%>
		ofm.col.value 		= '';
		ofm.in_col.value	= '';
		ofm.garnish_col.value	= '';
		ofm.col_seq.value 	= '';
		ofm.col_amt.value 	= '0';				
		ofm.jg_col_st.value 	= '';
		
		ofm.o_1.value 		= parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)));		
		ofm.o_1_s_amt.value 	= parseDecimal(toInt(parseDigit(ofm.car_s_amt.value)) + toInt(parseDigit(ofm.opt_s_amt.value)) + toInt(parseDigit(ofm.col_s_amt.value)));
		ofm.o_1_v_amt.value 	= parseDecimal(toInt(parseDigit(ofm.car_v_amt.value)) + toInt(parseDigit(ofm.opt_v_amt.value)) + toInt(parseDigit(ofm.col_v_amt.value)));		
	<%}%>
	
//-->
</script>
</html>