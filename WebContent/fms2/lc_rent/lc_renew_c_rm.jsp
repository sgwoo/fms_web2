<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*, acar.res_search.*, acar.con_ins.*, acar.secondhand.*, acar.offls_pre.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ins" class="acar.con_ins.InsurBean" scope="page"/>
<jsp:useBean id="ai_db2" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="oh_db" scope="session" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "02", "10", "07");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String fee_start_dt = "";
	
	
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//연대보증인정보
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//보험정보
		String ins_st = ai_db2.getInsSt(base.getCar_mng_id());
		ins = ai_db2.getIns(base.getCar_mng_id(), ins_st);
	}
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	fee_start_dt = rs_db.addDay(ext_fee.getRent_end_dt(), 1);
	
	//월렌트정보
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//임의연장
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	String im_end_dt = "";
	
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	
	//4. 변수----------------------------
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//최근 홈페이지 적용대여료
	Hashtable hp = oh_db.getSecondhandCase_20090901("", "", base.getCar_mng_id());	
	 
	//견적정보
	String est_id = shDb.getSearchEstIdShRm(base.getCar_mng_id(), "21", "1", "", String.valueOf(hp.get("REAL_KM")), String.valueOf(hp.get("UPLOAD_DT")), String.valueOf(hp.get("RM1")), String.valueOf(hp.get("REG_CODE")));
	e_bean = edb.getEstimateShCase(est_id);		
		 
	Hashtable sh_ht = new Hashtable();
	Hashtable sh_ht2 = new Hashtable();
	Hashtable carOld = new Hashtable();
	
	//차량정보
	sh_ht = shDb.getShBase(base.getCar_mng_id());
	//차량등록 경과기간(차령)
	carOld 	= c_db.getOld(cr_bean.getInit_reg_dt());		
	//차량정보
	sh_ht2 = shDb.getBase(base.getCar_mng_id(), base.getRent_dt(), (String)sh_ht.get("SERV_DT"));	

	String ext_reg_chk	= "";
	
	//차령만료일 최대연장 반영분
	String car_end_dt_max = cr_bean.getInit_reg_dt();
	//2000cc미만은 5+2=7년
	car_end_dt_max = c_db.addMonth(car_end_dt_max, 82);
	//비LPG -1개월
	if(!ej_bean.getJg_b().equals("2")){
		car_end_dt_max = c_db.addMonth(car_end_dt_max, 1);
	}	
	//2000cc초과는 8+2=10년
	if(AddUtil.parseInt(cr_bean.getDpm()) > 2000){
		car_end_dt_max = c_db.addMonth(car_end_dt_max, 36);
	}
	//car_end_dt_max = c_db.addDay(car_end_dt_max, -1);

	if(!cr_bean.getCar_end_dt().equals("") && cr_bean.getCar_end_yn().equals("Y")){
	//	car_end_dt_max = c_db.addDay(cr_bean.getCar_end_dt(), -2);
	}
	
	//20211126 여유분 1개월 더 줌 (생산일 기준으로하면 더 줘야 함) - 김광수팀장요청
	car_end_dt_max = c_db.addMonth(car_end_dt_max, -1);

	//전월대여료(임의연장 포함)	
	String last_month_start_dt 	= ext_fee.getRent_start_dt();
	int last_month_fee_s_amt 	= ext_fee.getFee_s_amt();
	int last_month_fee_v_amt 	= ext_fee.getFee_v_amt();
		
		
	//발행작업스케줄-신차
	Vector fee_scd = ScdMngDb.getFeeScdTaxScd("", "3", ext_fee.getRent_st(), "", "", rent_mng_id, rent_l_cd, base.getCar_mng_id(), "", "1");
	int fee_scd_size = fee_scd.size();	
	
	String f_use_s_dt = "";	
	String f_use_e_dt = "";	
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
	
	//고객 보기
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("선택된 고객이 없습니다."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//지점/현장 보기
	function view_site()
	{
		var fm = document.form1;
		if(fm.site_id.value == ""){ alert("선택된 지점이 없습니다."); return;}
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//길이 체크
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
	}
	
//대여기간 셋팅 거꾸로 -경선대리님 추가요청
function set_use_date(){
	var fm = document.form1; 
	fm.rent_end_dt.value = ChangeDate(fm.rent_end_dt.value);
	var start_date = fm.rent_start_dt.value.replace(/-/gi,"");
	var end_date = fm.rent_end_dt.value.replace(/-/gi,"");
	if(eval(start_date)>eval(end_date)){
		alert("대여만료일은 대여개시일 이후만 입력할 수 있습니다 "); fm.rent_end_dt.value=''; fm.rent_end_dt.focus();  return;
	}else{
		fm.action='get_fee_nodisplay2.jsp';
		fm.target='i_no';
		fm.submit();
	}
}
	
	//대여기간 셋팅
	function set_cont_date(){
		var fm = document.form1;
		//경선대리님 추가요청
			if(fm.con_mon.value==''){
				fm.con_mon.value='0';
			}
		//추가요청끝			
		fm.rent_start_dt.value = ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value);
		
		fm.v_con_mon.value = fm.con_mon.value;
		fm.v_con_day.value = fm.con_day.value;	
		
		//최초계약 월대여료 대비 5%할인적용
		<%if(AddUtil.parseInt(base.getRent_dt()) >= 20140301 && AddUtil.parseInt(base.getRent_dt()) < 20150317){%>	
			if(fm.v_con_mon.value == '0'){		
				fm.fee_amt.value = toInt(parseDigit(fm.last_month_fee_s_amt.value)) + toInt(parseDigit(fm.last_month_fee_v_amt.value));
			}else{
				fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>*0.95;
			}
		
		//최초계약 월대여료 대비 3%할인적용
		<%}else if(AddUtil.parseInt(base.getRent_dt()) >= 20150317 && AddUtil.parseInt(base.getRent_dt()) < 20170728){%>	
			if(fm.v_con_mon.value == '0'){		
				fm.fee_amt.value = toInt(parseDigit(fm.last_month_fee_s_amt.value)) + toInt(parseDigit(fm.last_month_fee_v_amt.value));
			}else{
				fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>*0.97;
			}
									
		//신용카드 자동출금, 할인없음
		<%}else if(AddUtil.parseInt(base.getRent_dt()) >= 20170728){%>	
				fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>;

		<%}else{%>								
			fm.fee_amt.value = <%=ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt()%>;
		<%}%>
				
		
		//fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
						
		
		set_fee_amt(fm.fee_amt);		
				
		set_sum_amt();	
				
								
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;

		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
			
		fm.action='get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();
	}
		

	
	//차량가격 입력시 자동계산으로 가게..
	function enter_fee(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_fee_amt(obj);
	}	
	//공급가, 부가세, 합계 입력시 자동계산
	function set_fee_amt(obj)
	{
		var fm = document.form1;	
		var car_price 	= toInt(parseDigit(fm.sh_amt.value));
		
		
		//보증금---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//보증금 공급가
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value = fm.grt_s_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value = replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			}

		//월대여료---------------------------------------------------------------------------------
		}else if(obj==fm.fee_amt){ 	//정상대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.fee_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));			
			dc_fee_amt();			

		}
		
		set_sum_amt();	
		
	}	
	
	//합계계산
	function set_sum_amt(){
		var fm = document.form1;
				
		//대여료 총액
		if(toInt(fm.con_mon.value)==1 && toInt(fm.con_day.value)==0){
			fm.t_fee_amt.value   = fm.fee_amt.value;
			fm.t_fee_s_amt.value = fm.fee_s_amt.value;
			fm.t_fee_v_amt.value = fm.fee_v_amt.value;					
		}else{					
			fm.t_fee_amt.value   = (toInt(parseDigit(fm.fee_amt.value))*toInt(fm.con_mon.value)) + (toInt(parseDigit(fm.fee_amt.value))/30*toInt(fm.con_day.value));			
			//fm.t_fee_amt.value   = parseDecimal(bak_th_rnd(toInt(parseDigit(fm.t_fee_amt.value))));
			fm.t_fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.t_fee_amt.value))));
			fm.t_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_amt.value)) - toInt(parseDigit(fm.t_fee_s_amt.value)));												
			fm.t_fee_amt.value   = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value))+ toInt(parseDigit(fm.t_fee_v_amt.value)));
		}
				
	}		
	
	//대여료 DC율 계산
	function dc_fee_amt(){
		var fm = document.form1;
	}		
	

	

	//등록
	function save(idx){
		var fm = document.form1;
		
		
			if(fm.con_mon.value == '' && fm.con_day.value == '')	{ alert('대여요금-이용기간을 입력하십시오.'); 				fm.con_mon.focus(); 		return; }
			if(fm.ext_agnt.value == '')				{ alert('대여요금-계약담당자를 입력하십시오.'); 					fm.ext_agnt.focus(); 		return; }
			if(fm.rent_start_dt.value == '')	{ alert('대여요금-대여개시일을 입력하십시오.'); 					fm.rent_start_dt.focus(); 	return; }
			if(fm.rent_end_dt.value == '')		{ alert('대여요금-대여만료일을 입력하십시오.'); 					fm.rent_end_dt.focus(); 		return; }
			if(fm.ext_agnt.value.substring(0,1) == '1')		{ alert('계약담당자가 부서로 선택되었습니다. 확인해주세요.'); return; }
		
			<%	//임의연장이 최종일때 fee_stat_dt
				if(im_vt_size>0){%>
			if(	toInt(replaceString('-','',fm.im_fee_start_dt.value)) > toInt(replaceString('-','',fm.rent_start_dt.value)) ){
				if(!confirm('임의연장이 있는 계약입니다. 임의연장 대여만료일('+ChangeDate(fm.im_end_dt.value)+')과 기존 정상계약의 대여만료일(<%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%>)을 확인하시고, 입력한 대여개시일자('+fm.rent_start_dt.value+')가 맞는지 확인하시기 바랍니다.'))			
					return;
			}
			<%	}%>
			
			if(toInt(parseDigit(fm.fee_amt.value))>0){

				var fee_amt = toInt(parseDigit(fm.fee_amt.value));
				if(fee_amt == 0)				{ alert('대여요금-대여료총액을 입력하십시오.'); 			fm.fee_amt.focus(); 		return; }
				if(fm.fee_pay_tm.value == '' || fm.fee_pay_tm.value == '0')			{ alert('대여요금-납입횟수를 입력하십시오.'); 				fm.fee_pay_tm.focus(); 		return; }
				if(fm.fee_est_day.value == '')			{ alert('대여요금-납입일자를 입력하십시오.'); 				fm.fee_est_day.focus(); 	return; }
				if(fm.fee_fst_dt.value == '')			{ alert('대여요금-1회차납입일을 입력하십시오.');			fm.fee_fst_dt.focus(); 	return; }

			}
			//연장숭계관련
			var grt_amt = toInt(parseDigit(fm.grt_s_amt.value));
					
			if (grt_amt > 0 ) {
				if(fm.grt_suc_yn.value == '')			{ alert('보증금-정상조건을 선택하십시오.'); 			fm.grt_suc_yn.focus(); 		return; }
			}
		
			//영업용차량일 경우 차령만료일 체크해서 연장만료일자 경과를 할 경우 등록이 안되도록 한다.
			<%if(!ck_acar_id.equals("000029") && !ck_acar_id.equals("000026") && cr_bean.getCar_use().equals("1")){%>
			if(toInt(replaceString('-','','<%=car_end_dt_max%>')) < toInt(replaceString('-','',fm.rent_end_dt.value)) ){
				alert('대여기간 만료일이 차령만료일보다 큽니다. 확인하십시오.'); 						fm.rent_end_dt.focus(); 	return;
			}
			<%}%>			
		
		if(confirm('등록하시겠습니까?')){	
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action='lc_renew_c_rm_a.jsp';		
			fm.target='i_no';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}							
	}

	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	
	
	//승계여부에 따른 디스플레이
	function display_suc(st){
		var fm = document.form1;
		if(st == 'grt'){
			if(fm.grt_suc_yn.value == '0'){
				fm.grt_s_amt.value  = '<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>';
				set_fee_amt(fm.grt_s_amt);
			}
		}		
	}
	
	//대여요금
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee_rm.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=100, top=100, width=950, height=650, scrollbars=yes");
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

<form action='lc_b_u_a.jsp' name="form1" id = "form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">
  <input type='hidden' name="car_ext" 			value="<%=car.getCar_ext()%>">
  <input type='hidden' name="udt_st" 			value="<%=pur.getUdt_st()%>">  
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
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="dec_gr"			value="<%=cont_etc.getDec_gr()%>"> 
  <input type='hidden' name='spr_kd' 			value='<%=base.getSpr_kd()%>'>
  <input type="hidden" name="car_cs_amt"   		value="<%=car.getCar_cs_amt()%>">  
  <input type="hidden" name="car_cv_amt"   		value="<%=car.getCar_cv_amt()%>">
  <input type="hidden" name="car_c_amt"   		value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">  
  <input type="hidden" name="car_fs_amt"   		value="<%=car.getCar_fs_amt()%>">  
  <input type="hidden" name="car_fv_amt"   		value="<%=car.getCar_fv_amt()%>">    
  <input type="hidden" name="car_f_amt"   		value="<%=car.getCar_fs_amt()+car.getCar_fv_amt()%>">      
  <input type="hidden" name="opt_cs_amt"   		value="<%=car.getOpt_cs_amt()%>">  
  <input type="hidden" name="opt_cv_amt"   		value="<%=car.getOpt_cv_amt()%>">    
  <input type="hidden" name="opt_c_amt"   		value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">    
  <input type="hidden" name="sd_cs_amt"   		value="<%=car.getSd_cs_amt()%>">  
  <input type="hidden" name="sd_cv_amt"   		value="<%=car.getSd_cv_amt()%>">    
  <input type="hidden" name="sd_c_amt"   		value="<%=car.getSd_cs_amt()+car.getSd_cv_amt()%>">      
  <input type="hidden" name="col_cs_amt"   		value="<%=car.getClr_cs_amt()%>">  
  <input type="hidden" name="col_cv_amt"   		value="<%=car.getClr_cv_amt()%>">    
  <input type="hidden" name="col_c_amt"   		value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">      
  <input type="hidden" name="dc_cs_amt"   		value="<%=car.getDc_cs_amt()%>">  
  <input type="hidden" name="dc_cv_amt"   		value="<%=car.getDc_cv_amt()%>">    
  <input type="hidden" name="dc_c_amt"   		value="<%=car.getDc_cs_amt()+car.getDc_cv_amt()%>">        
  <input type="hidden" name="spe_tax"   		value="<%=car.getSpe_tax()%>">  
  <input type="hidden" name="edu_tax"   		value="<%=car.getEdu_tax()%>">
  <input type="hidden" name="tot_tax"   		value="<%=car.getSpe_tax()+car.getEdu_tax()%>">
  <input type='hidden' name="o_1"				value="">
  <input type='hidden' name="ro_13"				value="">  
  <input type='hidden' name="o_13"				value="">  
  <input type='hidden' name="o_13_amt"			value="">      
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
    
  <input type='hidden' name="est_from"			value="lc_renew">      
  <input type='hidden' name="fee_opt_amt"		value="">  
  
  <input type='hidden' name="ins_chk1"			value="">        
  <input type='hidden' name="ins_chk2"			value="">          
  <input type='hidden' name="ins_chk3"			value="">   
  <input type='hidden' name="ins_chk4"			value="">                         
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">              
  <input type='hidden' name="fee_rent_st"		value="<%=fee_size+1%>">      
  <input type='hidden' name="fee_rent_dt"		value="">              
  <input type='hidden' name="im_fee_start_dt"	value="">              
  <input type='hidden' name="im_end_dt"			value="">                
        
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td class=title>영업대리인</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
                    <td class=title>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>계약일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>계약구분</td>
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이젼트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}else if(car_gu.equals("3")){%>월렌트<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("4")){%>월렌트<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></td>
                </tr>
                <tr>
                    <td class=title>상호</td>
                    <td>&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%></a></td>
                    <td class=title>대표자</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                    <td class=title>지점/현장</td>
                    <td>&nbsp;<a href='javascript:view_site()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=site.getR_site()%></a></td>
                </tr>
                <tr>
                    <td class=title>차량번호</td>
                    <td>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a>
					    &nbsp;&nbsp;&nbsp;
						<b><font color="#999999">[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></font></b>
					</td>
                    <td class=title>차명</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                    <td class=title>차령만료일</td>
                    <td>&nbsp;<font color=red><b><%=AddUtil.ChangeDate2(cr_bean.getCar_end_dt())%></b></font>
                    	<%if(cr_bean.getCar_use().equals("1")){
							int car_end_d_day = c_db.getCar_D_day("car_end_dt", base.getCar_mng_id());
						%>
						<%if(car_end_d_day <= 30){ %><font color=red>(D-day <%=car_end_d_day%>일)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_end_d_day%>일<%}} %>
						<%} %>
                    </td>
                </tr>
                <%	
        		    	int car_maint_d_day = c_db.getCar_D_day("car_maint_dt", base.getCar_mng_id());
				%>
                <tr>
                    <td class=title>검사유효기간</td>
                    <td colspan='5'>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%> <%if(car_maint_d_day <= 30){ %><font color=red>(D-day <%=car_maint_d_day%>일)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_maint_d_day%>일<%}} %></b></td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
		<% if(!base.getCar_st().equals("2")){%>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="2">연번</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">계약일자</td>
                    <td style="font-size : 8pt;" width="6%" class=title rowspan="2">이용기간</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">대여개시일</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">대여만료일</td>
                    <td style="font-size : 8pt;" width="7%" class=title rowspan="2">계약담당</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">월대여료</td>
                    <td style="font-size : 8pt;" class=title colspan="2">보증금</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">선납금</td>
                    <td style="font-size : 8pt;" class=title colspan="2">개시대여료</td>
                    <td style="font-size : 8pt;" class=title colspan="2">매입옵션</td>
                </tr>
                <tr>
                    <td style="font-size : 8pt;" width="10%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="3%" class=title>승계</td>
                    <td style="font-size : 8pt;" width="10%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="3%" class=title>승계</td>
                    <td style="font-size : 8pt;" width="10%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="3%" class=title>%</td>			
                </tr>
    		  <%for(int i=0; i<fee_size; i++){
    				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));    				
    				
    				//담당자 재량에 일자연장후 추가연장 가능으로 변경	
    				//if(i+1==fee_size && AddUtil.parseInt(base.getRent_dt()) > 20140228 && fees.getCon_mon().equals("0")) ext_reg_chk = "N";    				
    				    				
    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 8pt;" align="center"><a href="javascript:view_fee('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=fees.getRent_st()%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>개월</td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
    		  <%}}%>
            </table>
		<%}%>
	    </td>
	</tr>
    <%if(ext_reg_chk.equals("N")){%>			
    <tr>
	<td><font color=red>* 20140225일 최초계약분부터 일자단위 연장계약시 추가연장 불가입니다.</font></td>
    </tr>
</table>
</form>    	
    <%		if(1==1) return;
    	}%>	
    	
    	
	<%if(fee_scd_size>0){
			int start_size = fee_scd_size-3;
			if(start_size < 0)	start_size = 0;
			%>  	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>최종스케줄 3회분</span></td>
	</tr>
	<tr>
	    <td colspan="2" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>	 
                <tr>
                    <td width='5%' rowspan="2" class='title'>회차</td>
                    <td colspan="2" rowspan="2" class='title'>사용기간</td>
                    <td width="13%" rowspan="2" class='title'>월대여료</td>
                    <td colspan="3" class='title'>스케줄</td>
                    <td colspan="2" class='title'>거래명세서</td>					
                    <td colspan="2" class='title'>계산서</td>
                </tr>
                <tr>
                  <td width="10%" class='title'>발행예정일</td>
                  <td width="10%" class='title'>세금일자</td>
                  <td width="10%" class='title'>입금예정일</td>
                  <td width="8%" class='title'>발급일자</td>
                  <td width="8%" class='title'>예정일자</td>
                  <td width="8%" class='title'>발행일자</td>
                  <td width="8%" class='title'>출력일자</td>
                </tr>
        		<%	for(int j = start_size ; j < fee_scd_size ; j++){
        					Hashtable ht = (Hashtable)fee_scd.elementAt(j);
        					
        					//마지막 전월 금액 찾기
        					String mons = c_db.getMons(String.valueOf(ht.get("USE_E_DT")), String.valueOf(ht.get("USE_S_DT")));
        					
        					
        					        					
        					        					
        					if(AddUtil.parseFloat(mons) >= 1){
        						last_month_fee_s_amt 	= AddUtil.parseInt(String.valueOf(ht.get("FEE_S_AMT")));
										last_month_fee_v_amt 	= AddUtil.parseInt(String.valueOf(ht.get("FEE_V_AMT")));
        					}
        					
        					if(j == fee_scd_size-1){
										f_use_s_dt 	=  c_db.addDay  (String.valueOf(ht.get("USE_E_DT")), 1);
										f_use_e_dt 	=  c_db.addMonth(String.valueOf(ht.get("USE_E_DT")), 1);
										
									}
			%>
                <tr>
                    <td align="center"><%=ht.get("FEE_TM")%></td>
                    <td align="center" width="10%" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td align="center" width="10%" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원&nbsp;&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ITEM_DT")))%><%if(!String.valueOf(ht.get("ITEM_DT")).equals("")){%><br><font color='999999'>(<%=ht.get("ITEM_ID")%>)</font><%}%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_EST_DT")))%></td>										
                    <td align="center">
        		    <%if(AddUtil.parseInt(AddUtil.dateFormat("yyyyMMdd")) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))){%>
        		    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
          		    <%}else{%>					
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
					<%}%>
					<%if(!String.valueOf(ht.get("TAX_DT")).equals("")){%><br><font color='999999'>(<%=ht.get("TAX_NO")%>)</font><%}%>
        		    </td>
                    <td align="center">
        		    <%if(String.valueOf(ht.get("PRINT_DT")).equals("")){%>
        		    <%	if(AddUtil.parseInt(AddUtil.dateFormat("yyyyMMdd")) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))){%>
        		    	<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
          		    <%	}else{%>
						<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
					<%	}%>
        		    <%}else{%>
        		    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%>
        		    <%}%>
        		    </td>
                </tr>
        		<%	}%>
            </table>
	    </td>
    </tr>	
	<%}%>
    <input type='hidden' name="last_month_fee_s_amt" value="<%=last_month_fee_s_amt%>">
    <input type='hidden' name="last_month_fee_v_amt" value="<%=last_month_fee_v_amt%>">

	    	
	<%if(im_vt_size>0){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>임의연장</span></td>
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
        				Hashtable im_ht = (Hashtable)im_vt.elementAt(i);
					im_end_dt = String.valueOf(im_ht.get("RENT_END_DT"));%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=im_ht.get("ADD_TM")%>회차</td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_END_DT")))%></td>
                    <td align='center'><%=im_ht.get("USER_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("REG_DT")))%></td>
                  </tr>
        		  <%	} %>
            </table>
        </td>
    </tr>				
	<%}%>	
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td style='background-color:e5e5e5; height:1;'></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량가격</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> 신차소비자가 </td>
                    <td width="20%">&nbsp;
        		<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("CAR_AMT"))+AddUtil.parseInt((String)sh_ht.get("OPT_AMT"))+AddUtil.parseInt((String)sh_ht.get("COL_AMT")))%>'size='10' class='defaultnum' readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
        		원 
        		<input type='hidden' name="view_car_amt" value=""></td>
                    <td class='title' width="10%">잔가율</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='sh_ja' value=''size='4' class='defaultnum' readonly>%</td>
                    <td class='title' width='10%'>중고차가</td>
                    <td>&nbsp;
                      <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(e_bean.getO_1()) %>'size='10' class='defaultnum' readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                </tr>            
                <tr>
                    <td class='title'>차령</td>
                    <td colspan="5">&nbsp;
			<input type='text' name='sh_year' value='<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("YEAR")%><%}%>'size='1' class='default' >
                        년
                        <input type='text' name='sh_month' value='<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("MONTH")%><%}%>'size='2' class='default' >
                        개월
                        <input type='text' name='sh_day' value='<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("DAY")%><%}%>'size='2' class='default' >
                        일 (
                        <input type='text' name='sh_init_reg_dt' size='11' value='<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%>' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                        ~
                        <input type='text' name='sh_day_bas_dt' value='<%= AddUtil.ChangeDate2(fee_start_dt) %>'size='11' class='default'  onBlur='javascript:this.value=ChangeDate(this.value);'>
                        )                  
					</td>
                </tr>
                <tr>
                  <td class='title'>주행거리</td>
                  <td colspan="5">&nbsp;
				    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(e_bean.getToday_dist()) %>' class='defaultnum' >
                        km / 확인주행거리
                          <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TOT_DIST")) %>' class='defaultnum' >
                        km (
                        <input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2((String)sh_ht.get("SERV_DT")) %>' class='default'  onBlur='javascript:this.value=ChangeDate(this.value);'>
                        )
                        
					</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    

    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연장 대여요금</span></td>
    </tr>
	    <input type='hidden' name="rent_st" value="<%=fee_size+1%>">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="13%" align="center" class=title>계약일자</td>
                    <td width="20%">&nbsp;
        			  <input type="text" name="rent_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value); getSecondhandCarAmt_h();'></td>
                    <td width="10%" align="center" class=title>계약담당자</td>
                    <td>&nbsp;
        			  <select name='ext_agnt'>
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>
        			<td width="10%" align="center" class=title>영업대리인</td>
                    <td>&nbsp;
        			  <select name='bus_agnt_id' onchange="javascript:if(this.value!=''){ document.form1.bus_agnt_r_per.value='20';document.form1.bus_agnt_per.value='20'; }else{ document.form1.bus_agnt_r_per.value='';document.form1.bus_agnt_per.value=''; }">
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>			  
                </tr>
                <tr>
                    <td width="13%" align="center" class=title>이용기간</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="con_mon" value='' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this);'>
            			 개월
            			 <input type='text' name="con_day" value='' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 일
        			 </td>
                    <td width="10%" align="center" class=title>대여개시일</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="rent_start_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);'></td>
                    <td width="10%" align="center" class=title>대여만료일</td>
                    <td>&nbsp;
                    <input type="text" name="rent_end_dt" value="" size="11" maxlength='10' class=text onChange='javascript:set_use_date(this);'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>구분</td>
                    <td class='title' width='13%'>공급가</td>
                    <td class='title' width='13%'>부가세</td>
                    <td class='title' width='13%'>합계</td>
                    <td class='title' width="28%">계약조건</td>
                    <td class='title' width='20%'>정상조건</td>
                </tr>
                <tr>
                    <td class='title'>보증금</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='11' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='' readonly>
        				  % </td>
                    <td align='center'>
        			    <input type='hidden' name='gur_per' value=''>
        				<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>'>
        				<select name='grt_suc_yn' onChange="javascript:display_suc('grt')">
                              <option value=""  <%if(ext_fee.getGrt_amt_s()==0)%>selected<%%>>선택</option>
                              <option value="0" <%if(ext_fee.getGrt_amt_s()> 0)%>selected<%%>>승계</option>
                              <option value="1">별도</option>
                            </select>				
        				</td>
                </tr> 

              <tr>
                <td class='title'>월대여료</td>
                <td align="center"><input type='text' size='11' name='fee_s_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='fee_v_amt' maxlength='10' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='fee_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">(금액조정은 합계금액으로 하세요)</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>대여료총액</td>
                <td align="center"><input type='text' size='11' name='t_fee_s_amt' maxlength='11' class='defaultnum' value='<%//=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='t_fee_v_amt' maxlength='10' class='defaultnum' value='<%//=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='t_fee_amt' maxlength='11' class='defaultnum' value='<%//=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' name="v_con_mon" value='' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        			 개월
        	    <input type='text' name="v_con_day" value='' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        			 일</td>
                <td align='center'>-</td>
              </tr>
              <input type='hidden' name="cons1_s_amt" value="0">
              <input type='hidden' name="cons1_v_amt" value="0">
              <input type='hidden' name="cons1_amt" value="0">
              <input type='hidden' name="cons1_yn" value="N">

                <tr>
                    <td class='title'>비고</td>
                    <td colspan="5">&nbsp;
                      <textarea rows='5' cols='90' name='fee_cdt'></textarea></td>
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
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='fee_pay_tm' value='' maxlength='1' class='text' >
        				회 </td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="20%">&nbsp;매월
                      <select name='fee_est_day'>
                        <option value="">선택</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                        <option value='<%=i%>'  <%if(fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                        <% } %>
                        <option value='99' > 말일 </option>
						<option value='98' > 대여개시일 </option>
                      </select></td>
                    <td width="10%" class='title'>납입기간</td>
                    <td>&nbsp;
                      <input type='text' name='fee_pay_start_dt' maxlength='10' size='11' value='' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
    			        <input type='text' name='fee_pay_end_dt' maxlength='10' size='11' value='' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>		
                <tr>
                    <td width="13%" class='title'>1회차납입일</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='fee_fst_dt' value='<%//=AddUtil.ChangeDate2(ext_fee.getFee_fst_dt())%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        				</td>
                    <td width="10%" class='title'>1회차납입액</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' name='fee_fst_amt' value='<%//=AddUtil.parseDecimal(ext_fee.getFee_fst_amt())%>' maxlength='10' size='10' class='num'>원
                      </td>
                </tr>	
                <tr>
                    <td width="13%" class='title'>스케줄생성여부<font color=red>*</font></td>
                    <td colspan="5">&nbsp;
                      <input type="checkbox" name="scd_reg_yn" value="Y" checked>
					</td>
                </tr> 	  		  		  		  		  	  		    		  		  
            </table>
        </td>
    </tr>	
    <%if(ext_reg_chk.equals("N")){%>			
    <tr>
	<td align="right"><font color=red>* 20140225일부터 일자단위 연장계약시 추가연장 불가입니다.</font></td>
    </tr>	
    <%}else{%>
    <%    if(!auth_rw.equals("1")){%>
    <tr>
	<td align="right"><a id="submitLink" href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
    </tr>	
    <%    }%>	
    <%}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<iframe src="about:blank" name="i_no2" width="100%" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	
	fm.sh_ja.value = replaceFloatRound(toInt(parseDigit(fm.sh_amt.value)) / toInt(parseDigit(fm.sh_car_amt.value)) );
		
	fm.rent_dt.value 		= '<%= AddUtil.getDate() %>';
	//fm.rent_start_dt.value 	= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';		
	fm.rent_start_dt.value 		= '<%= AddUtil.ChangeDate2(f_use_s_dt) %>';	
	fm.rent_end_dt.value 		= '<%= AddUtil.ChangeDate2(f_use_e_dt) %>';	
	
		
	//임의연장이 최종일때 fee_stat_dt
	<%if(im_vt_size>0){%>
	//fm.im_fee_start_dt.value    	= '<%=rs_db.addDay(im_end_dt, 1)%>';
	//fm.im_end_dt.value		= '<%=im_end_dt%>';
	<%}%>				
	
	//set_cont_date();
	
	fm.con_mon.value = '1';
	fm.con_day.value = '0';	


	//20140301 최초계약 월대여료 대비 5%할인적용 -> 20150317 3% 적용 -> 20170728 할인없음
	<%if(AddUtil.parseInt(base.getRent_dt()) >= 20140301 && AddUtil.parseInt(base.getRent_dt()) < 20150317){%>	
		
	fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>*0.95;
	fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
	set_fee_amt(fm.fee_amt);
	
	<%}else if(AddUtil.parseInt(base.getRent_dt()) >= 20150317 && AddUtil.parseInt(base.getRent_dt()) < 20170728){%>	
		
	fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>*0.97;
	fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
	set_fee_amt(fm.fee_amt);

	<%}else if(AddUtil.parseInt(base.getRent_dt()) >= 20170728){%>	
		
	fm.fee_amt.value = <%=fee.getFee_s_amt()+fee.getFee_v_amt()%>;
	//fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
	set_fee_amt(fm.fee_amt);

	<%}else{%>

	fm.fee_amt.value = <%=ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt()%>;
	//fm.fee_amt.value = bak_th_rnd(toInt(fm.fee_amt.value));
	set_fee_amt(fm.fee_amt);
	
	<%}%>
	
	
//-->
</script>
</body>
</html>
