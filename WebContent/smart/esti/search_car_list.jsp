<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS Client_Info</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40Px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}


/* 둥근테이블 시작 */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}
        
#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}





/* 내용테이블 */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:16px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
#cbtn { text-align:center; margin:15px 0 0 0;}



</style>

</head>

<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>

<%@ include file="/smart/cookies.jsp" %>

<%
	//String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();

	//차종변수별 리스트	
	Vector vars = e_db.getCarSubList(idx, car_comp_id, car_cd, car_id, car_seq, a_a);
	int size = vars.size();
	
	
	
	if(idx.equals("2")||idx.equals("3")){
		//차명정보
		cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
		//차종변수
		ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	}	
%>


<script language="JavaScript" src="/include/common.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript">
<!--
	function setCode(id, seq, nm, amt, s_st, jg_code, jg_f, jg_g, jg_w, jg_b, jg_opt_st, jg_g_7, end_dt, jg_tuix_st, lkas_yn, ldws_yn, aeb_yn, fcw_yn, car_etc, jg_opt_yn, hook_yn){
		var fm = opener.document.form1;				
		<%if(idx.equals("1")){%>
		if(end_dt == 'N'){
			if(!confirm('이 차종은 단산된 차종으로 재고 확인 바랍니다.')){	return;	}	
		}
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
		fm.in_col.value = '';
		fm.col_seq.value = '';
		fm.col_amt.value = '0';		
		fm.jg_col_st.value = '';		
		fm.dc.value = '';
		fm.dc_seq.value = '';
		fm.dc_amt.value = '0';
		fm.dc_amt2.value = '0';
		fm.ls_yn.value = '';		
		fm.jg_g_7.value = jg_g_7;
		fm.tax_dc_amt.value = 0;
		fm.ecar_loc_st.options[0].selected = true;
		if(jg_g_7=='3'){
			fm.loc_st.options[0].selected = true;
		}else{
			opener.LocStSet();
		}
		if(jg_g_7=='1' || jg_g_7=='2' || jg_g_7=='3' || jg_g_7=='4'){
			fm.eco_e_tag.options[1].selected = true;
		}else{
			fm.eco_e_tag.options[0].selected = true;
		}
		fm.jg_code.value = jg_code;
		fm.ins_per.options[0].selected = true;	
		fm.jg_f.value = jg_f*100;
		fm.jg_g.value = jg_g*100;
		//20120901부터 영업수당율 최대3% 이내에서 선택가능 - 디폴트 0%
		fm.jg_f.value = 0;
		fm.jg_g.value = 0;	
		//수입차구분
		fm.jg_w.value = jg_w;
		if(jg_w == '1'){
			fm.car_ja.value = '500,000';
		}else{
			fm.car_ja.value = '300,000';
		}	
		//연료구분
		fm.jg_b.value = jg_b;
		
		//표준약정운행거리
		var b_agree_dist = 30000;	
		
		if(<%=AddUtil.getDate(4)%> >= 20220415){
			b_agree_dist = 23000;
		}
		
		//디젤 +5000
		if(jg_b=='1')		b_agree_dist = b_agree_dist + 5000;				
		//LPG엔진 +10000 -> 20190418 +5000
		if(jg_b=='2')				b_agree_dist = b_agree_dist + 5000;
		fm.b_agree_dist.value = parseDecimal(b_agree_dist);
		//적용약정운행거리
		var agree_dist = b_agree_dist;
		if(b_agree_dist==20000){
			$(opener.document).find("#agree_dist_s1").val("20000").attr("selected", "selected");
			$(opener.document).find("#agree_dist_s2_span").val("").css("display", "none");
		}else if(b_agree_dist==30000){
			$(opener.document).find("#agree_dist_s1").val("30000").attr("selected", "selected");
			$(opener.document).find("#agree_dist_s2_span").val("").css("display", "none");
		}else if(b_agree_dist==40000){
			$(opener.document).find("#agree_dist_s1").val("40000").attr("selected", "selected");
			$(opener.document).find("#agree_dist_s2_span").val("").css("display", "none");
		}else{
			$(opener.document).find("#agree_dist_s1").val("").attr("selected", "selected");
			$(opener.document).find("#agree_dist_s2_span").val("").css("display", "inline");
			fm.agree_dist_s2.value = parseDecimal(agree_dist);
		}
		
		fm.agree_dist.value = parseDecimal(agree_dist);						
		fm.jg_tuix_st.value = jg_tuix_st;
		fm.jg_tuix_opt_st.value = '';
		fm.lkas_yn.value = lkas_yn;
		fm.lkas_yn_opt_st.value = '';
		fm.ldws_yn.value = ldws_yn;
		fm.ldws_yn_opt_st.value = '';
		fm.aeb_yn.value = aeb_yn;
		fm.aeb_yn_opt_st.value = '';
		fm.fcw_yn.value = fcw_yn;
		fm.fcw_yn_opt_st.value = '';
		fm.hook_yn.value = hook_yn;
		fm.hook_yn_opt_st.value = '';
		fm.car_etc.value = car_etc;
		opener.setO11();
		<%}else if(idx.equals("2")){%>
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
		fm.lkas_yn_opt_st.value = lkas_yn;
		fm.ldws_yn_opt_st.value = ldws_yn;
		fm.aeb_yn_opt_st.value = aeb_yn;
		fm.fcw_yn_opt_st.value = fcw_yn;
		fm.hook_yn_opt_st.value = hook_yn;
		<%}else if(idx.equals("3")){%>
		fm.col.value = nm;
		fm.col_seq.value = id;
		fm.col_amt.value = parseDecimal(amt);
		fm.jg_col_st.value = jg_opt_st;	
		<%}else if(idx.equals("4")){%>
		fm.dc.value = nm;
		fm.dc_seq.value = id;
		fm.dc_amt.value = parseDecimal(amt);
		<%}else if(idx.equals("5")){%>
		fm.conti_rat_seq.value = seq;
		fm.conti_rat.value = nm;
		<%}%>
		fm.o_1.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value)) - toInt(parseDigit(fm.tax_dc_amt.value)));
		self.close();
	}
	
	function setDcCode(car_b_dt, car_d, car_d_seq, car_d_per, car_d_p, ls_yn, car_d_per2, car_d_p2, car_d_per_b, car_d_per_b2){
		var fm = opener.document.form1;				
		var dc_amt 		= 0;
		var dc_amt2 	= 0;
		var car_price 	= toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)); // - toInt(parseDigit(fm.tax_dc_amt.value)) 20191002 개소세감면액 미반영 차량가격으로 함.
		
		dc_amt 		= (car_price*car_d_per/100)+car_d_p;
		
		if(car_d_per_b == '2'){
			dc_amt 	= ((car_price-car_d_p)*car_d_per/100)+car_d_p;
		}
		
		if(ls_yn == 'Y'){
			dc_amt2 = (car_price*car_d_per2/100)+car_d_p2;
			if(car_d_per_b2 == '2'){
				dc_amt2 = ((car_price-car_d_p2)*car_d_per2/100)+car_d_p2;
			}
		}
		
		
		fm.dc.value 		= '';
		fm.dc_seq.value 	= car_b_dt+''+car_d_seq;
		fm.dc_amt.value 	= parseDecimal(dc_amt);
		fm.dc_amt2.value 	= parseDecimal(dc_amt2);
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
		var lkas_yn_sts="";	// 차선이탈 제어형 옵션
		var ldws_yn_sts="";	// 차선이탈 경고형 옵션
		var aeb_yn_sts="";	// 긴급제동 제어형 옵션
		var fcw_yn_sts="";	// 긴급제동 경고형 옵션
		var hook_yn_sts="";	// 견인고리 옵션
		var jg_opt_yns= "";
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
					hook_yn_sts = o_split[10];
					
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
					//긴급제동 경고형 옵션여부
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
		 	alert("선택사양을 선택하세요.");
			return;
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
		
		ofm.in_col.value = opts;
		
		ofm.col_amt.value = parseDecimal(toInt(parseDigit(ofm.col_amt.value)) + amts);				
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));				
		
		<%}%>
		
			
		self.close();
	}
	
//-->
</script>

<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='size' value='<%=size%>'>

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login"><%if(idx.equals("1")){%>차종<%}else if(idx.equals("2")){%>옵션<%}else if(idx.equals("3")){%>외장색상<%}else{%>제조사DC<%}%></div>
			<div id="gnb_home"></div>
            
        </div>
    </div>
    <div id="contents">
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
<%if(idx.equals("4")){//제조사DC%>
              <%for(int i = 0 ; i < size ; i++){
    				Hashtable var = (Hashtable)vars.elementAt(i);%>		
					
						<tr>
							<th valign=top><%=i+1%>&nbsp;
							<%=var.get("CAR_D")%>&nbsp;
					&nbsp;<a href="javascript:setDcCode('<%=var.get("CAR_B_DT")%>', '<%=var.get("CAR_D")%>', '<%=var.get("CAR_D_SEQ")%>', <%=var.get("CAR_D_PER")%>, <%=var.get("CAR_D_P")%>, '<%=var.get("LS_YN")%>', <%=var.get("CAR_D_PER2")%>, <%=var.get("CAR_D_P2")%>, '<%=var.get("CAR_D_PER_B")%>', '<%=var.get("CAR_D_PER_B2")%>');">
					    <%if(String.valueOf(var.get("LS_YN")).equals("Y")){%>
						  [렌트]<%=var.get("CAR_D_PER")%>% + <%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P")))%>원
						  &nbsp;[리스DC] <%=var.get("CAR_D_PER2")%>% + <%=AddUtil.parseDecimal(String.valueOf(var.get("CAR_D_P2")))%>원
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
					</th>
							<td valign=top align="right"><%=AddUtil.ChangeDate2(String.valueOf(var.get("CAR_D_DT")))%></td>
						</tr>
              <%}%>				
<%}else if(idx.equals("5")){ %>
				<%for(int i = 0 ; i < size ; i++){
    				Hashtable var = (Hashtable)vars.elementAt(i);%>
    				<tr>
    					<th valign=top><%= i+1%></th>
    					<td><%=var.get("ENGINE")%></td>
    					<td><a href="javascript:setCode('<%=var.get("CAR_CD")%>','<%=var.get("CAR_K_SEQ")%>','<%=var.get("CAR_K")%>','','','','','','','','','','','','','','','','','','')"><%=var.get("CAR_K")%></a></td>
    					<td><%=var.get("CAR_K_ETC")%></td>
    				</tr>
    				
    			<%} %>		
<%}else{%>					
              <%for(int i = 0 ; i < size ; i++){
    				Hashtable var = (Hashtable)vars.elementAt(i);%>		
					
						<tr>
							<th valign=top>
							<%if(idx.equals("2")){%>
                            <input type="checkbox" name="car_s_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>||<%=var.get("LKAS_YN")%>||<%=var.get("LDWS_YN")%>||<%=var.get("AEB_YN")%>||<%=var.get("FCW_YN")%>||<%=var.get("JG_OPT_YN")%>||<%=var.get("HOOK_YN")%>'>
                        <%}else if(idx.equals("3")){%>
                            <input type="radio" name="car_s_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>||<%=var.get("JG_TUIX_ST")%>'>
                        <%}else{%>
                            <%=i+1%>
                        <%}%>
                        
                        &nbsp;
                        
                        <%if(idx.equals("3")){%>
                        <%=var.get("NM")%>
                        &nbsp;(<%=var.get("ETC")%>)                                                    
                        <%}else{%>                          
                            <a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>', '<%=var.get("JG_CODE")%>', '<%=var.get("JG_F")%>', '<%=var.get("JG_G")%>', '<%=var.get("JG_W")%>', '<%=var.get("JG_B")%>', '<%=var.get("JG_OPT_ST")%>', '<%=var.get("JG_G_7")%>', '<%=var.get("END_DT")%>', '<%=var.get("JG_TUIX_ST")%>', '<%=var.get("LKAS_YN")%>', '<%=var.get("LDWS_YN")%>', '<%=var.get("AEB_YN")%>', '<%=var.get("FCW_YN")%>', '<%=var.get("ETC")%>', '<%=var.get("JG_OPT_YN")%>', '<%=var.get("HOOK_YN")%>');"><%=var.get("NM")%><%if(idx.equals("1") && !String.valueOf(var.get("CAR_Y_FORM")).equals("")){%> [<%=var.get("CAR_Y_FORM")%>]<%}%></a>
                        <%}%> 
                                                  
                        <%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20151013){%>
			<%if(!String.valueOf(var.get("JG_OPT_ST")).equals("") && (idx.equals("2")||idx.equals("3")) ){ //옵션,색상%>
		            <br>		            
		            <%=e_db.getEstiJgOptVarJgOpt8(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
		            <br>		            
		            <%=e_db.getEstiJgOptVarJgOpt9(ej_bean.getSh_code(), ej_bean.getSeq(), String.valueOf(var.get("JG_OPT_ST")))%>
		        <%}%>		                        
		        <%}%>		                        
					
					</th>
							<td valign=top align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원</td>
						</tr>
              <%}%>								
<%}%>			  
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
	</div>
	
        <!--내장색상-->
        <%if(idx.equals("3")){
		vars = e_db.getCarSubList("3_in", car_comp_id, car_cd, car_id, car_seq, a_a);
		size = vars.size();		
        %>
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">내장색상</div>
			<div id="gnb_home"></div>
            
        </div>
    </div>        
    <div id="contents">
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">        
              <%for(int i = 0 ; i < size ; i++){
    				Hashtable var = (Hashtable)vars.elementAt(i);%>		
					
						<tr>
							<th valign=top>
							<input type="radio" name="car_in_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>||<%=var.get("JG_OPT_ST")%>'>
                        
                        &nbsp;
                        
                        <%=var.get("NM")%>
                        &nbsp;(<%=var.get("ETC")%>)
                        
                        
					
					</th>
							<td valign=top align="right"><%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원</td>
						</tr>
              <%}%>	        
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
	</div>        	
	<%}%>			          
	
	<%if(idx.equals("2") || idx.equals("3")){%>
	<div id="cbtn"><a href="javascript:save();"><img src=/smart/images/btn_cfm.gif align=absmiddle border=0></a></div>		
	<%}%>
	<div id="footer"></div>  
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
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
		
		ofm.conti_rat.value 	= '';	
		ofm.conti_rat_seq.value 	= '';	
		ofm.dc.value 	= '';	
		ofm.dc_seq.value 	= '';	
		ofm.dc_amt.value 	= '0';	
		ofm.tax_dc_amt.value 	= '0';	
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
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));
	<%}%>
	
	<%if(idx.equals("1") || idx.equals("3")){%>
		ofm.col.value 		= '';
		ofm.in_col.value	= '';
		ofm.col_seq.value 	= '';
		ofm.col_amt.value 	= '0';				
		ofm.jg_col_st.value 	= '';	
		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)) - toInt(parseDigit(ofm.tax_dc_amt.value)));
	<%}%>
	
//-->
</script>
</html>