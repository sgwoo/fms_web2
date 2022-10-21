<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.ext.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//연대보증인정보
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//2. 자동차--------------------------
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	
	//3. 대여-----------------------------
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//신용카드 자동출금
	ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//출고지연대차 리스트
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
	
	//영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//임의연장
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	
	//4. 변수----------------------------
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String a_a = "";
	if(base.getCar_st().equals("1")) a_a = "2";
	if(base.getCar_st().equals("3")) a_a = "1";	
	em_bean = edb.getEstiCommVarCase(a_a, "");
	
	
	
	from_page = "/fms2/lc_rent/lc_c_c_fee.jsp";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	function replaceFloatRound2(per){
		return Math.round(per*10)/10;	
	}

	//수정
	function update(st, rent_st){
		if(st == 'grt_amt' || st == 'pp_amt' || st == 'ifee_amt' || st == 'fee_amt' || st == 'inv_amt' || st == 'opt_amt'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650");
		}else if(st == 'rent_start_new'){
			var fm = document.form1;		
			fm.target='d_content';
			fm.action='lc_c_u_start.jsp';
			fm.submit();
		}else if(st == 'taecha'){
			var height = 600;
			window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&taecha_no="+rent_st, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes");			
		}else{
			var height = 600;
			if(st == 'car') 				height = 400;
			else if(st == 'car_amt') 		height = 350;
			else if(st == 'insur') 			height = 500;
			else if(st == 'gi') 			height = 250;
			else if(st == 'fee') 			height = 800;
			else if(st == 'taecha_info') 	height = 600;
			window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes");
		}
	}

	//대여료 DC율 계산
	function dc_fee_amt(){
		var fm = document.form1;
		
		var pp_s_amt	= toInt(parseDigit(fm.pp_s_amt.value));		//선납금
		var fee_s_amt	= toInt(parseDigit(fm.fee_s_amt.value));	//월대여료(적용)
		var inv_s_amt	= toInt(parseDigit(fm.inv_s_amt.value));	//정상대여료(견적)
		var con_mon		= toInt(parseDigit(fm.con_mon.value));		//대여기간 
		var dc_ra;
		
		if(<%=base.getRent_dt()%> >= 20080501){
			if(inv_s_amt > 0){
				dc_ra = (1 - (pp_s_amt+fee_s_amt*con_mon)/(pp_s_amt+inv_s_amt*con_mon))*100;
				fm.dc_ra.value = parseFloatCipher3(dc_ra,1);
			}
		}
	}	
	
	//선수금 합계
	function sum_pp_amt(){
		var fm = document.form1;
		
		fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		

		//계약채권확보
		if(toInt(parseDigit(fm.credit_r_amt.value))==0){
			var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value));
			var pp_price 	= toInt(parseDigit(fm.tot_pp_amt.value)) + toInt(parseDigit(fm.gi_amt.value));
			fm.credit_r_per.value = replaceFloatRound(pp_price / car_price );
			fm.credit_r_amt.value = parseDecimal(pp_price);
		}

		//규정채권확보
		if(toInt(parseDigit(fm.credit_amt.value))==0){
			var car_st 		= fm.car_st.value;
			if(car_st == '1'){
				if(car_price < 25000000)									fm.credit_per.value = '20';
				else if(car_price > 25000000 && car_price2 < 35000000)		fm.credit_per.value = '30';
				else if(car_price > 35000000)								fm.credit_per.value = '25';
			}else if(car_st == '3'){
				if(car_price < 25000000)									fm.credit_per.value = '30';
				else if(car_price > 25000000 && car_price2 < 35000000)		fm.credit_per.value = '35';
				else if(car_price > 35000000)								fm.credit_per.value = '40';		
			}
			var credit_per = toInt(fm.credit_per.value)/100;
			fm.credit_amt.value = parseDecimal(car_price*credit_per);		
		}
		
	}
	
	//규정대여료 계산 (견적)
	function estimate(st, idx){
		var fm = document.form1;
		
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value));
		var s_dc_amt = 0;
		s_dc_amt = toInt(parseDigit(fm.dc_c_amt.value))
		
		//일반 과세차 렌트견적시 매출D/C금액 특소세율반영---------------	
		var purc_gu 	= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;			
		if(purc_gu == ''){	alert("과세구분을 선택하십시오."); return; }				
		if(purc_gu == '1'){//과세1
		}else{//과세2(면세) 
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				var a_e = toInt(s_st);
				var o_1 = car_price;
				//차종별 특소세율
				var o_2 = <%=ej_bean.getJg_3()%>;			
				//메출D/C 면세분 반영 = 매출D/C*(1+특소세율);
				s_dc_amt = Math.round(s_dc_amt*(1+o_2));
			}				
		}
		//--------------------------------------------------------------
		
		fm.o_1.value 		= car_price - s_dc_amt;
		fm.t_dc_amt.value 	= s_dc_amt;
		fm.esti_stat.value 	= st;
		fm.from_page.value  = 'car_rent';
		
		var rent_dt = 0;

		<%if(fee_size == 1){%>
			fm.con_mon.value	= fm.con_mons.value;
			rent_dt = parseInt(replaceString("-","",document.form1.rent_dt.value));
			fm.fee_rent_st.value = '1';	
		<%}else{%>
			fm.con_mon.value	= fm.con_mons[idx-1].value;					
			
			fm.rent_st.value = idx;			
			fm.fee_rent_st.value = idx;						
			fm.sh_rent_dt.value = document.form1.rent_dt[idx-1].value;
			rent_dt = parseInt(replaceString("-","",document.form1.rent_dt[idx-1].value));
		<%}%>
		
		fm.o_13.value 		= fm.app_ja.value;
		fm.o_13_amt.value 	= fm.ja_r_amt.value;
		
		if(<%=base.getRent_dt()%> >= 20080501){
			if(toInt(parseDigit(fm.ja_r_amt.value)) > toInt(parseDigit(fm.ja_amt.value))){
				fm.o_13.value 		= fm.max_ja.value;
				fm.o_13_amt.value 	= fm.ja_amt.value;
			}			
		}
				
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}
		
		if(fm.car_gu.value == '0' || fm.rent_st.value != '1'){//재리스
			fm.o_1.value	= fm.sh_amt.value;
			fm.esti_stat.value 	= st;
			//fm.action='get_fee_secondhand.jsp';
			fm.action='get_fee_estimate.jsp';
			fm.submit();
		}else{						
			if(rent_dt >= 20070316){
				fm.action='get_fee_estimate.jsp';
				fm.submit();
			}else{
				alert('계약일이 2007년3월16일 이전인 견적은 확인할 수 없습니다.');
			}			
		}
	}
	
	//영업효율견적 계산 (견적)
	function estimate_cmp(st, idx){
		var fm = document.form1;
		
		fm.fee_rent_st.value = idx;
		fm.esti_stat.value 	= st;
		fm.from_page.value  = 'car_rent';
		
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}
		
		var rent_dt = 0;

		<%if(fee_size == 1){%>
			rent_dt = parseInt(replaceString("-","",document.form1.rent_dt.value));
		<%}else{%>
			rent_dt = parseInt(replaceString("-","",document.form1.rent_dt[idx-1].value));
		<%}%>
		
		if(rent_dt >= 20070316){
			fm.action='get_fee_estimate_cmp.jsp';
			fm.submit();
		}else{
			alert('계약일이 2007년3월16일 이전인 견적은 확인할 수 없습니다.');
		}			
	}	
	
	//신용평가 보기
	function view_eval(){
		var fm = document.form1;
		window.open("/fms2/lc_rent/view_eval.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_c_c_fee.jsp&client_id="+fm.client_id.value+"&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value, "VIEW_EVAL", "left=50, top=50, width=850, height=600");
	}
	
	
	//임의연장 계약서
	function view_scan_res2(c_id, m_id, l_cd){
		window.open("/fms2/lc_rent/lc_im_doc_print.jsp?c_id="+c_id+"&rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&mode=fine_doc", "VIEW_SCAN_RES2", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}	
	
	//견적서보기
	function EstiView(rent_st, est_id){
		var SUBWIN="/acar/main_car_hp/estimate_fms.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
		
		if('<%=base.getCar_gu()%>' == '0' || rent_st != '1'){
			SUBWIN="/acar/secondhand_hp/estimate_fms.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
		}
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");				
	}
	
	//연장견적
	function add_rent_esti_s(ext_esti_st){
		window.open("search_car_esti_s.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&ext_esti_st="+ext_esti_st, "CAR_ESTI_S", "left=0, top=0, width=1128, height=950, status=yes, scrollbars=yes");	
	}	
	
	//전자문서 전송하기
	function go_edoc(link_table, link_type, link_rent_st, link_im_seq){
		var fm = document.form1;			
		fm.link_table.value 	= link_table;
		fm.link_type.value 	= link_type;
		fm.link_rent_st.value 	= link_rent_st;
		fm.link_im_seq.value 	= link_im_seq;
		window.open('about:blank', "EDOC_LINK", "left=0, top=0, width=900, height=500, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "EDOC_LINK";
		fm.action = "reg_edoc_link.jsp";
		fm.submit();		
	}	
	
	//특약요청서 열기
	function reqdoc(rent_l_cd, rent_mng_id, rent_st){
		var url = 'lc_b_s_reqdoc.jsp?rent_l_cd='+rent_l_cd+'&rent_mng_id='+rent_mng_id+'&rent_st='+rent_st;
		window.open(url, "popupView", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
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
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">    
  <input type='hidden' name="rent_way" 			value="<%=ext_fee.getRent_way()%>">  
  <input type='hidden' name="dpm" 				value="<%=cm_bean.getDpm()%>">
  <input type='hidden' name="s_dc1_re" 			value="<%=car.getS_dc1_re()%>">
  <input type='hidden' name="s_dc1_yn" 			value="<%=car.getS_dc1_yn()%>">
  <input type='hidden' name="s_dc1_amt"			value="<%=car.getS_dc1_amt()%>">
  <input type='hidden' name="s_dc2_re" 			value="<%=car.getS_dc2_re()%>">
  <input type='hidden' name="s_dc2_yn" 			value="<%=car.getS_dc2_yn()%>">
  <input type='hidden' name="s_dc2_amt"			value="<%=car.getS_dc2_amt()%>">
  <input type='hidden' name="s_dc3_re" 			value="<%=car.getS_dc3_re()%>">
  <input type='hidden' name="s_dc3_yn" 			value="<%=car.getS_dc3_yn()%>">
  <input type='hidden' name="s_dc3_amt"			value="<%=car.getS_dc3_amt()%>">
  <input type='hidden' name="s_dc1_re_etc"		value="<%=car.getS_dc1_re_etc()%>">  
  <input type='hidden' name="s_dc2_re_etc"		value="<%=car.getS_dc2_re_etc()%>">  
  <input type='hidden' name="s_dc3_re_etc"		value="<%=car.getS_dc3_re_etc()%>">      
  <input type='hidden' name="s_dc1_per"			value="<%=car.getS_dc1_per()%>">  
  <input type='hidden' name="s_dc2_per"			value="<%=car.getS_dc2_per()%>">  
  <input type='hidden' name="s_dc3_per"			value="<%=car.getS_dc3_per()%>">        
  <input type='hidden' name="car_end_dt"		value="<%=cr_bean.getCar_end_dt()%>">
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name="gur_size"			value="<%=gur_size%>">  
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="dec_gr"			value="<%=cont_etc.getDec_gr()%>"> 
  <input type='hidden' name="o_1"				value="">
  <input type='hidden' name="o_13"				value="">  
  <input type='hidden' name="o_13_amt"			value="">    
  <input type='hidden' name="rent_dt"			value="<%=base.getRent_dt()%>">
  <input type='hidden' name="car_ja"			value="<%=base.getCar_ja()%>">  
  <input type='hidden' name="gcp_kd"			value="<%=base.getGcp_kd()%>">    
  <input type='hidden' name="driving_age"		value="<%=base.getDriving_age()%>">    
  <input type='hidden' name="eme_yn"			value="<%=cont_etc.getEme_yn()%>">
  <input type='hidden' name="car_ext"			value="<%=car.getCar_ext()%>">
  <input type='hidden' name="gi_st"				value="<%=gins.getGi_st()%>">  
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="con_mon"			value="">  
  <input type='hidden' name="t_dc_amt"			value="">  
    
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">    
  <input type='hidden' name="car_cs_amt"		value="<%=car.getCar_cs_amt()%>">
  <input type='hidden' name="car_cv_amt"		value="<%=car.getCar_cv_amt()%>">
  <input type='hidden' name="car_c_amt"			value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">  
  <input type='hidden' name="car_fs_amt"		value="<%=car.getCar_fs_amt()%>">
  <input type='hidden' name="car_fv_amt"		value="<%=car.getCar_fv_amt()%>">
  <input type='hidden' name="car_f_amt"			value="<%=car.getCar_fs_amt()+car.getCar_fv_amt()%>">    
  <input type='hidden' name="opt_cs_amt"		value="<%=car.getOpt_cs_amt()%>">
  <input type='hidden' name="opt_cv_amt"		value="<%=car.getOpt_cv_amt()%>">
  <input type='hidden' name="opt_c_amt"			value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">  
  <input type='hidden' name="sd_cs_amt"			value="<%=car.getSd_cs_amt()%>">
  <input type='hidden' name="sd_cv_amt"			value="<%=car.getSd_cv_amt()%>">
  <input type='hidden' name="sd_c_amt"			value="<%=car.getSd_cs_amt()+car.getSd_cv_amt()%>">  
  <input type='hidden' name="col_cs_amt"		value="<%=car.getClr_cs_amt()%>">
  <input type='hidden' name="col_cv_amt"		value="<%=car.getClr_cv_amt()%>">
  <input type='hidden' name="col_c_amt"			value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">  
  <input type='hidden' name="dc_cs_amt"			value="<%=car.getDc_cs_amt()%>">
  <input type='hidden' name="dc_cv_amt"			value="<%=car.getDc_cv_amt()%>">
  <input type='hidden' name="dc_c_amt"			value="<%=car.getDc_cs_amt()+car.getDc_cv_amt()%>">  
    
  <input type='hidden' name="rent_st"			value="<%=fee_size%>">      
  <input type='hidden' name="sh_amt"			value="<%=fee_etc.getSh_amt()%>">      
  <input type='hidden' name="add_opt_amt"		value="<%=car.getAdd_opt_amt()%>">  
  <input type="hidden" name="lpg_price"  		value="<%=car.getLpg_price()%>"> 
  <input type='hidden' name="sh_rent_dt"		value="">
  <input type='hidden' name="fee_rent_st"		value="">  
  <input type='hidden' name="link_table"		value="">  
  <input type='hidden' name="link_type"			value="">  
  <input type='hidden' name="link_rent_st"		value="">  
  <input type='hidden' name="link_im_seq"		value="">  
  
    
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
<%if(!base.getCar_st().equals("2")){%>
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보증보험</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	<%	
		for(int f=1; f<=fee_size ; f++){
			ContGiInsBean ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));
	%>                  
                <tr>
                    <td class=title width="13%"><%if(!ext_gin.getRent_st().equals("1") && !ext_gin.getRent_st().equals("")){%><%=AddUtil.parseInt(ext_gin.getRent_st())-1%>차 연장 <%}%>가입금액</td>
                    <td colspan="5">&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>원</td>
                </tr>
	<%	}%>
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>   
<%}%>
  	<%		for(int i=1; i<=fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i));
				ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(i));
				
				%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(i >1){%><%=i-1%>차 연장 <%}%>대여요금 <%if(base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("연장대여료계산",user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%>&nbsp;<a href="javascript:update('fee','<%=i%>')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( 회계업무 : 보증금, 선납금, 개시대여료, 계약대여료, 정상대여료 수정 )</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <%if(i==1 && base.getCar_gu().equals("0")){ %>
              <tr>
                <td width="13%" align="center" class=title>차량인도예정일</td>
                <td colspan='5'>&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_est_dt())%>                    
					 (재리스계약일 때 차량인도예정일 전날 보험변경합니다. 인도 확정시 다시 확인하십시오.)
					 </td>
              </tr>   
              <%} %>
            	<%if(i<fee_size){%>
                <tr>
                    <td width="13%" align="center" class=title>계약일자</td>
                    <td width="20%">&nbsp;<%if(i >1){%><%=AddUtil.ChangeDate2(fees.getRent_dt())%><input type="hidden" name="rent_dt" value="<%=fees.getRent_dt()%>"><%}else{%><%=AddUtil.ChangeDate2(base.getRent_dt())%><%}%></td>
                    <td width="10%" align="center" class=title>계약담당자</td>
                    <td>&nbsp;<%if(i >1){%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}else{%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}%></td>
                    <td width="10%" align="center" class=title>영업대리인</td>
                    <td>&nbsp;<%if(i >1){%><%=c_db.getNameById(fee_etcs.getBus_agnt_id(),"USER")%><%}else{%><%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%><%}%></td>
                </tr>
                <%}else{%>
                <tr>
                    <td width="13%" align="center" class=title>계약일자</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_dt())%><input type="hidden" name="rent_dt" value="<%=fees.getRent_dt()%>"></td>
                    <td width="10%" align="center" class=title>계약담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(fees.getExt_agnt(),"USER")%></td>
                    <td width="10%" align="center" class=title>영업대리인</td>
                    <td>&nbsp;<%=c_db.getNameById(fee_etcs.getBus_agnt_id(),"USER")%></td>
                </tr>                
                <%}%>
                <tr>
                    <td width="13%" align="center" class=title>이용기간</td>
                    <td width="20%">&nbsp;<%=fees.getCon_mon()%>개월<input type='hidden' name="con_mons" value="<%=fees.getCon_mon()%>"></td>
                    <td width="10%" align="center" class=title>대여개시일</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>
					  <%if(!base.getUse_yn().equals("N") && i == 1 && fees.getRent_start_dt().equals("") && (user_id.equals(base.getBus_id()) || user_id.equals(base.getBus_id2()) || user_id.equals(cont_etc.getBus_agnt_id()) || nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("에이전트관리",user_id))){%>
					    <a href="javascript:update('rent_start_new','');" title='신차 대여개시 처리'><img src=/acar/images/center/button_in_schl.gif align=absmiddle border=0></a>
					  <%}%>
					  
					</td>
                    <td width="10%" align="center" class=title>대여만료일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                </tr>
    		    <%if(i == 1){%>
                <tr>
                    <td width="13%" align="center" class=title>신용등급</td>
                    <td width="20%"><%if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());%>
        			  &nbsp;<input type='hidden' name="spr_kd" value="<%=cont_etc.getDec_gr()%>">
                      <%-- <% if(cont_etc.getDec_gr().equals("0")) out.print("일반고객"); 	%>
                      <% if(cont_etc.getDec_gr().equals("1")) out.print("우량기업"); 	%>
                      <% if(cont_etc.getDec_gr().equals("2")) out.print("초우량기업");  %>
        			  <% if(cont_etc.getDec_gr().equals("3")) out.print("신설법인"); 	%> --%>
        			  <% if (cont_etc.getDec_gr().equals("0")) { %>
        			  	일반고객
        			  <% } else if (cont_etc.getDec_gr().equals("1")) { %>
        			  	우량기업
        			  <% } else if (cont_etc.getDec_gr().equals("2")) { %>
        			  	초우량기업
        			  <% } else if (cont_etc.getDec_gr().equals("3")) { %>
        			  	신설법인
        			  <% } %>
        			  <a href="javascript:view_eval()"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                    <td width="10%" align="center" class=title>연대보증</td>
                    <td colspan="3">&nbsp;<%if(client.getClient_st().equals("1")){%>대표:<%if(cont_etc.getClient_guar_st().equals("1")){%>입보<%}else if(cont_etc.getClient_guar_st().equals("2")){%>면제<%}%><%}%><%if(gur_size>0){%>/연대보증:<%=gur_size%>명<%}%></td>
                </tr>
    		  <%}%>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="3" class='title'>구분</td>
                    <td class='title' width='11%'>공급가</td>
                    <td class='title' width='11%'>부가세</td>
                    <td class='title' width='14%'>합계</td>
                    <td class='title' width='4%'>입금</td>			
                    <td width="27%" class='title'>계약조건</td>
                    <td class='title' width='20%'>정상조건</td>
                </tr>
                <tr>
                    <td width="3%" rowspan="5" class='title'>선<br>
                      수</td>
                    <td width="10%" class='title' colspan="2">보증금</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 <%if(nm_db.getWorkAuthUser("회계업무",user_id)){%><a href="javascript:update('grt_amt', '<%=i%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a><%}%></td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='gur_p_per' class='whitenum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_gur_p_per' class='whitenum' value='<%=fees.getF_gur_p_per()%>' readonly>
    				            %
        				    </td>
                    <td align='center'>
					  <%if(base.getRent_st().equals("3") && fees.getRent_st().equals("1")){%>대차 보증금 승계여부 :<%}%>
        			  <%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%><input type='hidden' name='gur_per' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">선납금</td>
                    <td align="center"><input type='text' size='10' name='pp_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='pp_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='pp_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 <%if(nm_db.getWorkAuthUser("회계업무",user_id)){%><a href="javascript:update('pp_amt', '<%=i%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a><%}%></td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='pere_r_per' class='whitenum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_pere_r_per' class='whitenum' value='<%=fees.getF_pere_r_per()%>' readonly>
    				            %  
        				    </td>
                    <td align='center'>-<input type='hidden' name='pere_per' value=''>
                    	선납금 계산서발행구분 : <%if(fees.getPp_chk().equals("1")){%>납부일시발행<%}else if(fees.getPp_chk().equals("0")){%>매월균등발행<%}else{%>-<%}%>
                    </td>
                </tr>
                <tr>
                    <td class='title' colspan="2">개시대여료</td>
                    <td align="center"><input type='text' size='10' name='ifee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='ifee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ifee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 <%if(nm_db.getWorkAuthUser("회계업무",user_id)){%><a href="javascript:update('ifee_amt', '<%=i%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a><%}%></td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2")%></td>
                    <td align="center">마지막
                        <input type='text' size='2' name='pere_r_mth' class='whitenum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  개월치 대여료 </td>
                    <td align='center'><%if(fees.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%><input type='hidden' name='pere_mth' value=''></td>
                </tr>
                        <%	String credit_pay_dt="";
                        
                        	if(fees.getRent_st().equals("1")){
                        
                        		Hashtable ext0 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, fees.getRent_st(), "0");
        				Hashtable ext1 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, fees.getRent_st(), "1");
        				Hashtable ext2 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, fees.getRent_st(), "2");
        			
        				int pp_amt0 	= fees.getGrt_amt_s();
        				int pp_amt1 	= fees.getPp_s_amt()+fees.getPp_v_amt();
        				int pp_amt2 	= fees.getIfee_s_amt()+fees.getIfee_v_amt();
        				int pp_pay_amt0 = AddUtil.parseInt(String.valueOf(ext0.get("PAY_AMT")));
        				int pp_pay_amt1 = AddUtil.parseInt(String.valueOf(ext1.get("PAY_AMT")));
        				int pp_pay_amt2 = AddUtil.parseInt(String.valueOf(ext2.get("PAY_AMT")));
        				
        				
        				if((pp_amt0+pp_amt1+pp_amt2-pp_pay_amt0-pp_pay_amt1-pp_pay_amt2) > 0){
        					credit_pay_dt = "";
        				}else{
        					credit_pay_dt = String.valueOf(ext0.get("MAX_PAY_DT"));
        					
        					if(AddUtil.parseInt(credit_pay_dt) < AddUtil.parseInt(String.valueOf(ext1.get("MAX_PAY_DT"))))	credit_pay_dt = String.valueOf(ext1.get("MAX_PAY_DT"));
        					if(AddUtil.parseInt(credit_pay_dt) < AddUtil.parseInt(String.valueOf(ext2.get("MAX_PAY_DT"))))	credit_pay_dt = String.valueOf(ext2.get("MAX_PAY_DT"));
        					
        				}
        				
        			}
        		%>
                <tr>
                    <td class='title' colspan="2">합계</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_s_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='tot_pp_v_amt' maxlength='10' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='tot_pp_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td align='center'>-</td>
                    <td align="center">
                        <%if(credit_pay_dt.equals("")){%>
	                    입금예정일 :
                          <input type='text' size='11' name='pp_est_dt' maxlength='10' class="whitetext" value='<%=AddUtil.ChangeDate2(fees.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <%}else{%>
        	            <input type='hidden' name="pp_est_dt" value="<%=fees.getPp_est_dt()%>">  
        	            입금완료일 : <%=AddUtil.ChangeDate2(credit_pay_dt)%>                          
                        <%}%>
                    </td>
                    <td align='center'>&nbsp;
					<%	ExtScdBean suc = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fees.getRent_st(), "5", "1");//승계수수료 기존 등록 여부 조회
						if(suc == null || suc.getRent_l_cd().equals("")){%>
					<%	}else{%>	
					승계수수료 입금여부 : <%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "5")%>
					<%	}%>					
					</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">총채권확보</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>						
                    <td align='center'>-</td>									
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='whitenum' value='<%=fees.getCredit_r_per()%>' readonly>%
        			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>원(보증보험포함)</td>
                    <td align='center'><input type='text' size='4' name='credit_per' class='whitenum' value='<%=fees.getCredit_per()%>' readonly>%
        			<input type='text' size='10' name='credit_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getCredit_amt())%>' readonly>원</td>
                </tr>
                <tr>
                    <td rowspan="3" class='title'>잔<br>
                      가</td>
                    <td class='title' colspan="2">최대잔가</td>
                    <td align="center"><input type='text' size='10' name='ja_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='ja_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td align='center'>-</td>
                    <td align='center'>
        			  최대잔가율:차가의
                          <input type='text' size='4' name='max_ja' maxlength='10' class='whitenum' value='<%=fees.getMax_ja()%>' readonly>
                          %</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">매입옵션</td>
                    <td align="center"><input type='text' size='10' name='opt_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='opt_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='opt_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 <%if(nm_db.getWorkAuthUser("회계업무",user_id)){%><a href="javascript:update('opt_amt', '<%=i%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a><%}%></td>
                    <td align='center'>-</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='opt_per' class='whitenum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_opt_per' class='whitenum' value='<%=fees.getF_opt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
    				            %  
        				    </td>
                    <td align='center'><%String opt_chk = fees.getOpt_chk();%><%if(opt_chk.equals("0")){%>없음<%}else if(opt_chk.equals("1")){%>있음<%}%></td>
                </tr>
                <%if(fee_etcs.getReturn_select().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//전기차,수소차  20190701  || ej_bean.getJg_g_7().equals("4") 수소차제외 %>
                <tr>
                    <td class='title' colspan="2">적용잔가</td>
                    <td align="center"><input type='text' size='10' name='i_ja_r_s_amt' readonly maxlength='11' class='whitenum' value='-' >
        				  원</td>
                    <td align="center"><input type='text' size='10' name='i_ja_r_v_amt' readonly maxlength='10' class='whitenum' value='-' >
        				  원</td>
                    <td align='center'><input type='text' size='10' name='i_ja_r_amt' readonly maxlength='11' class='whitenum' value='-' >
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='i_app_ja' maxlength='10' readonly class="whitenum" value='-'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <input type="hidden" name="ja_r_s_amt" value='<%=fees.getJa_r_s_amt()%>'>
                <input type="hidden" name="ja_r_v_amt" value='<%=fees.getJa_r_v_amt()%>'>
                <input type="hidden" name="ja_r_amt" value='<%=fees.getJa_r_s_amt()+fees.getJa_r_v_amt()%>'>
                <input type="hidden" name="app_ja" value='<%=fees.getApp_ja()%>'>
                <%}else{%>
                <tr>
                    <td class='title' colspan="2">적용잔가</td>
                    <td align="center"><input type='text' size='10' name='ja_r_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='ja_r_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_r_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td align='center'>-</td>				  
                    <td align="center">차가의
        			  <input type='text' size='4' name='app_ja' maxlength='10' class="whitenum" value='<%=fees.getApp_ja()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>		  
                <%}%>
                <tr>
                    <td rowspan="5" class='title'>대<br>여<br>료</td>
                    <td class='title' colspan="2">계약요금</td>
                    <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9'  name='fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 <%if(nm_db.getWorkAuthUser("회계업무",user_id)){%><a href="javascript:update('fee_amt', '<%=i%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a><%}%></td>
                    <td align='center'>-</td>
                    <td align="center">DC율:
                      <input type='text' size='4' name='dc_ra' maxlength='10' class="whitenum" value='<%=fees.getDc_ra()%>'>
                    </font>%</span></td>
                    <td align='center'>
                        <%if(fees.getFee_chk().equals("0")){%>매월납입<%}%>
                        <%if(fees.getFee_chk().equals("1")){%>일시완납<%}%>
                    </td>
                </tr>
                <!-- 운전자추가요금/월보험료(고객피보험) 적용 (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">정<br>상<br>대<br>여<br>료</td>
                    <td class='title'>정상요금</td>
                    <td align="center" ><input type='text' size='10' name='inv_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9' name='inv_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='inv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 <%if(nm_db.getWorkAuthUser("회계업무",user_id)){%><a href="javascript:update('inv_amt', '<%=i%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a><%}%></td>
                    <td align='center'>-</td>
                    <td align="center">기준일자<span class="contents1_1">
                      <input type='text' size='11' name='bas_dt' maxlength='10' class="whitetext" value='<%=AddUtil.ChangeDate2(fees.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </span></td>
                    <td align='center'>&nbsp;
        			  <%if(i==1 && car.getLpg_price()>0){%>LPG장착 추가대여료<%=AddUtil.parseDecimal(car.getLpg_price())%>원<%}%>
        			  
        			  <%if(!fee_etcs.getBc_est_id().equals("")){%>
        			  <a href="javascript:EstiView('<%=fee_etcs.getRent_st()%>','<%=fee_etcs.getBc_est_id()%>')" title='견적서 보기'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
        			  <%}%>
        			  
        			  <!-- 마지막 연장 재견적 -->
        			  <%if(!fee_etcs.getRent_st().equals("1") && fee_etcs.getRent_st().equals(Integer.toString(fee_size)) && AddUtil.parseInt(fees.getRent_dt()) <= AddUtil.parseInt(AddUtil.getDate(4)) && AddUtil.parseInt(AddUtil.getDate(4)) < AddUtil.parseInt(AddUtil.replace(c_db.addMonth(fees.getRent_dt(), 1),"-", ""))){%>
        			  &nbsp;&nbsp;&nbsp;<a href="javascript:add_rent_esti_s('re');" class="btn" title='연장 재견적하기'><img src=/acar/images/center/button_est_yj.gif align=absmiddle border=0></a>&nbsp;        			  
        			  <%}%>
                    </td>
                </tr>	
                <tr>
                    <td class='title'>월보험료(고객피보험)</td>
                    <td align="center" ><input type='text' size='10' name='ins_s_amt'  maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9' name='ins_v_amt'  maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10'  name='ins_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt()+fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원
        			</td>
                    <td align="center">-</td>
                    <td align="center">&nbsp;월보험료(공급가) = 년간보험료
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_total_amt())%>' >    
					 원/12</td>
                    <td align='center'>자동차보험 관련 특약 약정서<br>
                    	<a href="javascript:reqdoc('<%=fees.getRent_l_cd()%>','<%=fees.getRent_mng_id()%>','<%=fees.getRent_st()%>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                    </td>
                </tr>
                <tr>
                    <td class='title'>운전자추가요금</td>
                    <td align="center" >
                    	<input type='text' size='10' name='driver_add_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>' > 원 
                    </td>
                    <td align="center" >
                    	<input type='text' size='10' name='driver_add_v_amt'  maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center' >
                    	<input type='text' size='10' maxlength='10'  name='driver_add_total_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>         
                <tr>
                    <td class='title'>정상요금 합계</td>
                    <td align="center" >
                    	<input type='text' size='10' name='tinv_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getIns_s_amt() + fee_etcs.getDriver_add_amt())%>'> 원 
                    </td>
                    <td align="center" >
                       	<input type='text' size='10' name='tinv_v_amt'  maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center' >
                    	<input type='text' size='10' maxlength='10'  name='tinv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getInv_v_amt() + fees.getIns_s_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>                
	            
              <!--20130605 약정운행주행거리 운영-->    
              <%if(AddUtil.parseInt(fees.getRent_dt()) > 20130604){%>          
              <tr>
                <td colspan="3" class='title'><span class="title1">약정운행거리</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='agree_dist' size='8' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  km이하/1년,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (약정이하운행시) 환급대여료  <input type='text' name='rtn_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)
                  <%if(fee_etcs.getRtn_run_amt_yn().equals("0")){%>※환급대여료적용<%}else if(fee_etcs.getRtn_run_amt_yn().equals("1")){%>※환급대여료미적용<%} %>
                  <%} %>    
                  <br>&nbsp;              
                  (약정초과운행시) 초과운행대여료 <input type='text' name='over_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  매입옵션 행사시 환급대여료 : 기본식은 미지급, 일반식은 40%만 지급
                  <%} %>
                  <br>&nbsp;                  
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>만 납부
                  <!-- 
                  초과 1km당 (<input type='text' name='over_run_amt' size='3' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원)의 초과운행부담금이 부과됨 (대여종료시)	
                  <br>&nbsp;
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 50%만 납부
                   -->
                  <!-- <%if(fee_etcs.getAgree_dist_yn().equals("1")){%>전액면제(기본식)<%}else if(fee_etcs.getAgree_dist_yn().equals("2")){%>50%만 납부(일반식)<%}else if(fee_etcs.getAgree_dist_yn().equals("3")){%>매입옵션 없음(기본식,일반식)<%}else{%>-<%}%> -->
                </td>
                <td align='center'>
                  <%if(AddUtil.parseInt(fees.getRent_dt()) > 20130604){
                  	e_bean = edb.getEstimateCase(fee_etcs.getBc_est_id());
                  	String e_agree_dist_yn = "매입옵션 없음(기본식,일반식)";
                  	if(e_bean.getOpt_chk().equals("1")){
                  		if(e_bean.getA_a().equals("12") || e_bean.getA_a().equals("22")){
                  			e_agree_dist_yn = "전액면제(기본식)";
                  		}else{
							if(AddUtil.parseInt(base.getRent_dt()) > 20220414){
								e_agree_dist_yn = "40%만납부(일반식)";
							}else{
								e_agree_dist_yn = "50%만납부(일반식)";
							}                  			
                  		}
                  	}
                  %>
                    <%if(base.getCar_gu().equals("1")){%>
                    <input type='text' name='e_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>' >/1년, <br>&nbsp;
                    <%}%>
                    <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                    <input type='text' name='e_rtn_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>' >/1km,<br>&nbsp;
                    <%}%>
                    <input type='text' name='e_over_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' >/1km,<br>&nbsp;
                    <input type='text' name='e_agree_dist_yn' size='15' class='whitetext' value='<%=e_agree_dist_yn%>' >
                  <%}%>
                </td>
              </tr>     
              <tr>
                <td colspan="3" class='title'><span class="title1">보유차주행거리</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='over_bas_km' size='8' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_bas_km())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  km
                        (재리스 계약시점 보유차 주행거리, 계약서 기재 값),
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        예상 주행거리 <input type='text' name='cust_est_km' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getCust_est_km())%>' >
                        km/1년
                </td>
                <td align='center'></td>
              </tr>                   
              <%}%>	                
		        <%if(i==1){%>
                <tr>
                    <td colspan="3" class='title'>영업수당</td>
                    <td colspan="2" align="center">
        			  산출기준: <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>차량가격<%}%>
        			</td>
                    <td align='center'><input type='text' size='11' name='commi_car_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">
        				  원</td>
                    <td align='center'>-</td>				  
                    <td align="center">
                        <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='whitenum' onBlur='javascript:setCommi()'>
        		      %</td>
                    <td align='center'>
        				<input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum'>
        			  %</td>
                </tr>		
		        <%}%>  				
                <tr>
                    <td colspan="3" class='title'>중도해지위약율</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">잔여기간 대여료의
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='whitenum' value='<%=fees.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='whitenum' value='<%=fees.getCls_per()%>'>%
						,필요위약금율[<input type='text' size='3' name='cls_n_per' maxlength='10' class='fixnum' value='<%=fees.getCls_n_per()%>'>%]
						</font></span></td>
                </tr>		  
                <tr>
                    <td colspan="3" class='title'>운전자추가요금</td>
                    <td colspan="6">&nbsp;
                    	<input type='text' size='10' name='driver_add_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>'>
        				  원 (공급가)</td>                  
                </tr>                  
				<%if(i==1 && fees.getRent_st().equals("1")){
					//대차원계약정보
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}%>
                <tr>
                    <td colspan="3" class='title'>대차원계약</td>
                    <td colspan="6">&nbsp;
					  [원계약정보]&nbsp;&nbsp;
        			  계약번호 : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;차종코드별변수 차명 : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[대차보증금승계]</b>
					  &nbsp;기존보증금 : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>원
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  승계보증금 : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='whitenum' >원
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  				<font color=red>(약정보증금 차액 <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  			<%} %>
        			</td>
                </tr>		
		        <%}%>  	
		        
	        								
							
						
                <tr>
                    <td colspan="3" class='title'>결재자</td>
                    <td colspan="6">&nbsp;<%=c_db.getNameById(fees.getFee_sac_id(),"USER")%></td>
                </tr>
                <tr>
                    <td colspan="3" class='title'>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td colspan="6">&nbsp;<%=HtmlUtil.htmlBR(fees.getFee_cdt())%></td>
                </tr>
                <tr>
                    <td colspan="3" class='title'>계약서 특약사항 기재 내용</td>
                    <td colspan="6">&nbsp;<%=HtmlUtil.htmlBR(fee_etcs.getCon_etc())%></td>
                </tr>
            </table>		
	    </td>
    </tr>
    <tr></tr><tr></tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>납입횟수</td>
                    <td width="20%">&nbsp;<%=fees.getFee_pay_tm()%>회 </td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="20%">&nbsp;<%if(fees.getFee_est_day().equals("98")){%>대여개시일<%}else{%>매월<%if(fees.getFee_est_day().equals("99")){%> 말일 <%}else{%><%=fees.getFee_est_day()%>일<%}%><%}%></td>
                    <td width="10%" class='title'>납입기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>~<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%></td>
                </tr>		  	
                <tr>
                    <td width="13%" class='title'>1회차납입일</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fees.getFee_fst_dt())%></td>
                    <td width="10%" class='title'>1회차납입액</td>
                    <td colspan="3">&nbsp;<%=AddUtil.parseDecimal(fees.getFee_fst_amt())%>원</td>
                </tr>		  		  		  		  	  		  
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>			
	<%}%>
	
	<%if(im_vt_size>0){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>임의연장</span> <a href="javascript:view_scan_res2('<%=base.getCar_mng_id()%>','<%=base.getRent_mng_id()%>','<%=base.getRent_l_cd()%>')" onMouseOver="window.status=''; return true"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="임의계약서 보기"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class=title width="13%">연번</td>
                    <td class=title width="20%">회차</td>			
                    <td class=title width="37%">대여기간</td>
                    <td class=title width="15%">등록자</td>
                    <td class=title width="15%">등록일</td>                    
                  </tr>
        		  <%	for(int i = 0 ; i < im_vt_size ; i++){
        					Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td><!-- 연번 -->
                    <td align='center'><%=im_ht.get("ADD_TM")%>회차</td><!-- 회차 -->
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_END_DT")))%></td><!-- 대여기간 -->
                    <td align='center'><%=im_ht.get("USER_NM")%></td><!-- 등록자 -->
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("REG_DT")))%></td><!-- 등록일 -->
                  </tr>
        		  <%	} %>
            </table>
        </td>
    </tr>				
    <tr>
        <td class=h></td>
    </tr>			
	<%}%>
		
	<tr id=tr_fee3 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>납입방법 <%if(user_id.equals("000000") || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%><a href="javascript:update('pay_way','')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( 회계업무권한 : 납입방법 수정 )</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>					
    <tr id=tr_fee2 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>수금구분</td>
                    <td width="20%">&nbsp;<%String fee_sh = fee.getFee_sh();%><%if(fee_sh.equals("0")){%>후불<%}else if(fee_sh.equals("1")){%>선불<%}%></td>
                    <td width="10%" class='title'>납부방법</td>
                    <td width="20%">&nbsp;<%String fee_pay_st = fee.getFee_pay_st();%><%if(fee_pay_st.equals("1")){%>자동이체<%}else if(fee_pay_st.equals("2")){%>무통장입금<%}else if(fee_pay_st.equals("3")){%>지로<%}else if(fee_pay_st.equals("4")){%>수금<%}else if(fee_pay_st.equals("5")){%>기타<%}else if(fee_pay_st.equals("6")){%>카드<%}%></td>
        			<td width="10%" class='title'>CMS미실행</td>
        			<td>&nbsp;사유 : <%=fee_etc.getCms_not_cau()%></td>
                </tr>		  		  		  
                <tr>
                    <td class='title'>거치여부</td>
                    <td colspan="3">&nbsp;<%String def_st = fee.getDef_st();%><%if(def_st.equals("N")){%>없음<%}else if(def_st.equals("Y")){%>없음<%}%>
                    &nbsp;&nbsp;&nbsp;&nbsp;사유 : <%=fee.getDef_remark()%></td>
                    <td width="10%" class='title'>결재자</td>
                    <td>&nbsp;<%=c_db.getNameById(fee.getDef_sac_id(),"USER")%></td>
                </tr>
                <tr>
                    <td class='title'>자동이체</td>
                    <td colspan="5">
                        <table width="500" border="0" cellpadding="0">
        			        <tr>
                			    <td>&nbsp;계좌번호 : 
                			      <%=cms.getCms_acc_no()%>
                			      (은행:<%=cms.getCms_bank()%>) </td>
        			        </tr>
        			        <tr>
                			    <td>&nbsp;예 금 주 :&nbsp;<%=cms.getCms_dep_nm()%>			      
                				  &nbsp;&nbsp;
                				  / 결제일자 : 매월 <%=cms.getCms_day()%>일								  
								  </td>
        			        </tr>
        			        <tr>
                			    <td>&nbsp;신청일자 : <%=cms.getApp_dt()%></td>
        			        </tr>							
        			    </table>
        			</td>
                </tr>
                <tr>
                    <td class='title'>통장입금</td>
                    <td colspan="5">&nbsp;<%=c_db.getNameById(fee.getFee_bank(), "BANK")%></td>
                </tr>
                <!-- CMS 추가 (2018.01.24) -->
                <tr>
                    <td class='title'>CMS</td>
                    <td colspan="5" style="padding: 5px;">
                    	<%if(!cms.getCms_bank().equals("")){%>
							<b><%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%></b>
   			 				 <%if(!cms.getApp_dt().equals("")&&cms.getApp_dt()!=null){%>
   			 				 &nbsp; 신청일 : <%=AddUtil.ChangeDate2(cms.getApp_dt())%>
   			 				 <%} %>
   			 			<%}else{%>
   			 			[-]
   			 			<%}%>
                    </td>
                </tr>
                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(fee.getFee_pay_st().equals("6") && base.getRent_l_cd().equals("G120HNGR00164")){%>
	<tr id=tr_fee3 >
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용카드 자동출금 </span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>					
    <tr id=tr_fee2 > 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>신용카드 자동출금</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
        			        <tr>
                			    <td>&nbsp;신용카드 : 
                			      <%=card_cms.getCms_acc_no()%>
                			      (카드사:<%=card_cms.getCms_bank()%>) </td>
        			        </tr>
        			        <tr>
                			    <td>&nbsp;카드주 성명 :&nbsp;<%=card_cms.getCms_dep_nm()%>			      
                				  &nbsp;&nbsp;
                				  / 결제일자 : 매월 <%=card_cms.getCms_day()%>일								  
								  </td>
        			        </tr>
        			        <tr>
                			    <td>&nbsp;최초인출일자 : <%=AddUtil.ChangeDate2(card_cms.getCms_start_dt())%></td>
        			        </tr>	
        			        <tr>
                			    <td>&nbsp;신청일자 : <%=card_cms.getApp_dt()%></td>
        			        </tr>							
        			    </table>
        			</td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>        
    <%} %>			
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서 <%if(base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%><a href="javascript:update('tax','')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( 회계업무권한 : 청구서발행정보 수정 )</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_tax style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>공급받는자</td>
                    <td width="20%">&nbsp;
                      <input type="radio" name="tax_type" value="1" <% if(base.getTax_type().equals("1")) out.print("checked"); %> disabled>
        			    본사
        		      <input type="radio" name="tax_type" value="2" <% if(base.getTax_type().equals("2")) out.print("checked"); %> disabled>
        		    	지점 </td>
                    <td width="10%" class='title' style="font-size : 8pt;">청구서수령방법</td>
                    <td width="20%">&nbsp;<%String rec_st = cont_etc.getRec_st();%><%if(rec_st.equals("1")){%>이메일<%}else if(rec_st.equals("2")){%>우편<%}else if(rec_st.equals("3")){%>수령안함<%}%></td>
                    <td width="10%" class='title' style="font-size : 8pt;">전자세금계산서</td>
                    <td>&nbsp;<%String ele_tax_st = cont_etc.getEle_tax_st();%><%if(ele_tax_st.equals("1")){%>당사시스템<%}else if(ele_tax_st.equals("2")){%>별도시스템<%}%>
                      &nbsp;<%=cont_etc.getTax_extra()%>
        			</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>공급자</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(fee.getBr_id(), "BRCH")%></td>
                    <td width="10%" class='title'>청구구분</td>
                    <td width="20%">&nbsp;<%String fee_st = fee.getFee_st();%><%if(fee_st.equals("0")){%>미정<%}else if(fee_st.equals("1")){%>청구<%}else if(fee_st.equals("2")){%>영수<%}%></td>
                    <td width="10%" class='title'>영수일자</td>
                    <td>&nbsp;<%String rc_day = fee.getRc_day();%><%if(fee.getRc_day().equals("99"))rc_day="말";%><%=rc_day%>일</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>익월여부</td>
                    <td>&nbsp;<input type='checkbox' name='c_next_yn' <%if(fee.getNext_yn().equals("Y")){%>checked<%}%>></td>
                    <td width="10%" class='title'>발행기한</td>
                    <td colspan="3">&nbsp;<%=fee.getLeave_day()%>일</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고전대차 
	        <%if(cr_bean.getCar_no().equals(taecha.getCar_no())){%><font color=red>(만기매칭대차)</font><%}%>	        
	        <%if(user_id.equals("000000") || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%><a href="javascript:update('taecha_info','')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%></span></td>
	</tr>
    <tr id=tr_tae1 style="display:<%if(fee.getPrv_dlv_yn().equals("Y") && !base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 style='height:1'></td>
                </tr>
                <tr>
                    <td width="13%" class=title>출고전대차여부</td>
                    <td width="20%">&nbsp; &nbsp;
                      <input type='radio' name="prv_dlv_yn" value='N' <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%> disabled>
                      없다
                      <input type='radio' name="prv_dlv_yn" value='Y' <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%> disabled>
        	 		있다  <%=ta_vt_size %>
        		    </td>
                    <td width="10%" class=title style="font-size : 8pt;">대차기간포함여부</td>
                    <td>&nbsp; &nbsp;
                      <input type='radio' name="prv_mon_yn" value='0' <%if(fee.getPrv_mon_yn().equals("0")){%> checked <%}%> disabled>
                      미포함
                      <input type='radio' name="prv_mon_yn" value='1' <%if(fee.getPrv_mon_yn().equals("1")){%> checked <%}%> disabled>
        	 		포함
        		    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(fee.getPrv_dlv_yn().equals("Y") || ta_vt_size > 0){%>
    <%	for(int i = 0 ; i < ta_vt_size ; i++){
			Hashtable ht = (Hashtable)ta_vt.elementAt(i);
       		taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, ht.get("NO")+"");
    %>   
    <tr>
	    <td align='right'>        
	        <%if(user_id.equals("000000") || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%><a href="javascript:update('taecha','<%=ht.get("NO")+""%>')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%></span></td>
	</tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td width="13%" class=title>차량번호</td>
                    <td width="20%">&nbsp;<%=taecha.getCar_no()%>
        			  <input type='hidden' name='tae_no'		 value='<%=taecha.getNo()%>'>				    
        			  <input type='hidden' name='tae_car_mng_id' value='<%=taecha.getCar_mng_id()%>'>
        			  <input type='hidden' name='tae_car_id'	 value='<%=taecha.getCar_id()%>'>
        			  <input type='hidden' name='tae_car_seq'	 value='<%=taecha.getCar_seq()%>'>
        			</td>
                    <td width="10%" class='title'>차명</td>
                    <td>&nbsp;<%=taecha.getCar_nm()%></td>
                    <td class='title'>최초등록일</td>
                    <td>&nbsp;<%=taecha.getInit_reg_dt()%></td>
                </tr>
                <tr>
                    <td class=title>대여개시일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></td>
                    <td class='title'>대여만료일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></td>
                    <td class='title'>대여료선입금여부</td>
                <td>&nbsp;
                	<%if(taecha.getF_req_yn().equals("Y")){%> 선입금 <%}%>
                  <%if(taecha.getF_req_yn().equals("N")||taecha.getF_req_yn().equals("")){%> 후입금 <%}%>
    	 		        </td>                    
                </tr>
                <tr>
                    <td class=title >월대여료</td>
                    <td colspan='3'>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>원(vat포함) 
        			</td>
                    <td class=title >정상요금</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_inv())%>원(vat포함) 
        			</td>
                </tr>	
                <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
                <%}else{%>
                <tr>
                    <td class=title >신차해지시요금정산</td>
                    <td colspan='5'> 
                      <%if(taecha.getRent_fee_st().equals("1")){%> 월렌트정상요금                                      
                      <%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>
        			  원(vat포함)                 
        			  <%}%>
                      <%if(taecha.getRent_fee_st().equals("0")){%> 견적서에 표기되어 있지 않음    <%}%>    	 		           
        			</td>
                </tr>					
                <%}%>
                <tr>
                    <td class=title>1회차납입일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_dt())%></td>
                    <td class='title'>납입횟수</td>
                    <td width="20%" >&nbsp;<%=taecha.getCar_rent_tm()%>회</td>
                    <td width="10%" class=title >누적주행거리</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getCar_km())%>km
        			</td>
                </tr>
                <tr>
                    <td class=title>배차담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(taecha.getBae_user_id(),"USER")%></td>
                    <td class='title'>반차담당자</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(taecha.getBan_user_id(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>청구여부</td>
                    <td>&nbsp;<%String tae_req_st = taecha.getReq_st();%><%if(tae_req_st.equals("1")){%>청구<%}else if(tae_req_st.equals("0")){%>무상대차<%}%></td>
                    <td class='title' style="font-size : 8pt;">계산서발행여부</td>
                    <td>&nbsp;<%String tae_tae_st = taecha.getTae_st();%><%if(tae_tae_st.equals("1")){%>발행<%}else if(tae_tae_st.equals("0")){%>미발행<%}%></td>
                    <td class='title'>결재자</td>
                    <td>&nbsp;<%=c_db.getNameById(taecha.getTae_sac_id(),"USER")%></td>
                </tr>
                
            </table>           
        </td>
    </tr>
    <%if(base.getRent_st().equals("3") && !taecha.getEnd_rent_link_sac_id().equals("")){%>
                <tr>
	    			<td>	        
	        			* 만기매칭 입력할 때  "출고전대차"  대여개시일 / 대여만료일 차이가 35일 이상, 또는 신차요금 보다 30% 이상 차이가 발생하면 출고지연대차 입력된 "월대여료"를 기준으로  출고지연대차 스케줄을 반영한다.<br> 
	        			* 결재자 : <%=c_db.getNameById(taecha.getEnd_rent_link_sac_id(),"USER")%>	           
	    			</td> 
				<tr>		 
                <%} %> 
    <%} %>
	<tr>
	    <td><font color="#CCCCCC">※ 출고지연대차 대여개시일과 월대여료가 입력되어야 영업캠페인에 적용됩니다.</font></td>
	</tr>	
	<%} %>
    <tr>
	    <td align='right'>        
	        <%if(user_id.equals("000000") || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("회계업무",user_id)){%><a href="javascript:update('taecha','<%=ta_vt_size%>')"><img src=/acar/images/center/button_plus.gif align=absmiddle border=0></a><%}%></span></td>
	</tr> 
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

	//바로가기
	var s_fm = parent.parent.top_menu.document.form1;
	var fm 		= document.form1;	
	s_fm.auth_rw.value 	= fm.auth_rw.value;
	s_fm.user_id.value 	= fm.user_id.value;
	s_fm.br_id.value 	= fm.br_id.value;		
	s_fm.m_id.value 	= fm.rent_mng_id.value;
	s_fm.l_cd.value 	= fm.rent_l_cd.value;	
	s_fm.c_id.value 	= fm.car_mng_id.value;
	s_fm.client_id.value = fm.client_id.value;
	s_fm.accid_id.value = "";
	s_fm.serv_id.value 	= "";
	s_fm.seq_no.value 	= "";
	
	<%if(!base.getCar_st().equals("2")){%>
	
		<%	if(fee_size == 1){%>
			if(toInt(parseDigit(fm.ja_r_amt.value)) == 0 && toInt(parseDigit(fm.opt_amt.value)) > 0){
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;						
				fm.app_ja.value 	= fm.opt_per.value;
			}
	
			fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
			fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
			fm.tot_pp_amt.value   = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		
	
		<%	}else{
				for(int i=0; i<fee_size; i++){%>
			if(toInt(parseDigit(fm.ja_r_amt[<%=i%>].value)) == 0 && toInt(parseDigit(fm.opt_amt[<%=i%>].value)) > 0){
				fm.ja_r_s_amt[<%=i%>].value = fm.opt_s_amt[<%=i%>].value;
				fm.ja_r_v_amt[<%=i%>].value = fm.opt_v_amt[<%=i%>].value;
				fm.ja_r_amt[<%=i%>].value 	= fm.opt_amt[<%=i%>].value;						
				fm.app_ja[<%=i%>].value 	= fm.opt_per[<%=i%>].value;
			}
	
			fm.tot_pp_s_amt[<%=i%>].value = parseDecimal(toInt(parseDigit(fm.grt_s_amt[<%=i%>].value)) + toInt(parseDigit(fm.pp_s_amt[<%=i%>].value)) + toInt(parseDigit(fm.ifee_s_amt[<%=i%>].value)));
			fm.tot_pp_v_amt[<%=i%>].value = parseDecimal(toInt(parseDigit(fm.pp_v_amt[<%=i%>].value)) + toInt(parseDigit(fm.ifee_v_amt[<%=i%>].value)) );
			fm.tot_pp_amt[<%=i%>].value   = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt[<%=i%>].value)) + toInt(parseDigit(fm.tot_pp_v_amt[<%=i%>].value)) );		
	
		<%		}
			}%>
	<%}%>
	
//-->
</script>
</body>
</html>
