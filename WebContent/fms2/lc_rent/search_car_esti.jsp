<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*, acar.res_search.*, acar.con_ins.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ins" class="acar.con_ins.InsurBean" scope="page"/>
<jsp:useBean id="ai_db2" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%	
	String user_id		= ck_acar_id;
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String car_gubun 	= request.getParameter("car_gubun")==null?"":request.getParameter("car_gubun");
	
	String tae_car_mng_id 	= request.getParameter("tae_car_mng_id")==null?"":request.getParameter("tae_car_mng_id");
	String tae_car_id 		= request.getParameter("tae_car_id")==null?"":request.getParameter("tae_car_id");
	String tae_car_seq 		= request.getParameter("tae_car_seq")==null?"":request.getParameter("tae_car_seq");
	String tae_car_rent_st 	= request.getParameter("tae_car_rent_st")==null?"":request.getParameter("tae_car_rent_st");
	String tae_car_rent_et 	= request.getParameter("tae_car_rent_et")==null?"":request.getParameter("tae_car_rent_et");
	
	String fee_start_dt = "";
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	fee_start_dt = rs_db.addDay(ext_fee.getRent_end_dt(), 1);
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	

	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	
	if(car_gubun.equals("taecha")){
		fee_start_dt 	= tae_car_rent_st;
		car 			= a_db.getContCarMaxNew(tae_car_mng_id);
		cm_bean 		= cmb.getCarNmCase(tae_car_id, tae_car_seq);
		base.setCar_mng_id(tae_car_mng_id);
	}
	
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//보험정보
		String ins_st = ai_db2.getInsSt(base.getCar_mng_id());
		ins = ai_db2.getIns(base.getCar_mng_id(), ins_st);
	}
	
	
	//4. 변수----------------------------
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//중고차잔가 정보		
	Hashtable sh_ht = new Hashtable();
	Hashtable carOld 	= c_db.getOld(cr_bean.getInit_reg_dt(), fee_start_dt);
	
			//재리스차량기본정보테이블
			Hashtable ht = shDb.getShBase(base.getCar_mng_id());
			
			//차량정보-여러테이블 조인 조회
			Hashtable ht2 = shDb.getBase(base.getCar_mng_id(), fee_start_dt);
			
			if(String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
				ht2.put("REG_ID", user_id);
				ht2.put("SECONDHAND_DT", fee_start_dt);
				//sh_base table insert
				int count = shDb.insertShBase(ht2);
			}else{
				int chk = 0;
				if(!String.valueOf(ht2.get("SECONDHAND_DT")).equals(fee_start_dt)) 									chk++;
				if(!String.valueOf(ht2.get("BEFORE_ONE_YEAR")).equals(String.valueOf(ht.get("BEFORE_ONE_YEAR")))) 	chk++;
				if(!String.valueOf(ht2.get("SERV_DT")).equals(String.valueOf(ht.get("SERV_DT")))) 					chk++;
				if(!String.valueOf(ht2.get("TOT_DIST")).equals(String.valueOf(ht.get("TOT_DIST")))) 				chk++;
				if(!String.valueOf(ht2.get("TODAY_DIST")).equals(String.valueOf(ht.get("TODAY_DIST")))) 			chk++;
				if(!String.valueOf(ht2.get("PARK")).equals(String.valueOf(ht.get("PARK")))) 						chk++;
				if(chk >0){
					ht2.put("SECONDHAND_DT", fee_start_dt);
					//sh_base table update
					int count = shDb.updateShBase(ht2);
				}
			}
		//차량정보
		sh_ht = shDb.getShBase(base.getCar_mng_id());
		
	int fee_opt_amt = 0;
	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* 코드 구분:대여상품명 */
	int good_size = goods.length;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//길이 체크
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
	}
	
	//중고차가격 계산하기-숨어서
	function getSecondhandCarAmt_h(){
		var fm = document.sh_form;
		var fm2 = document.form1;		
		
		fm.a_b.value 		= fm2.con_mon.value;
		fm.rent_dt.value 	= replaceString('-','',fm2.rent_start_dt.value);
		fm.today_dist.value = fm2.sh_km.value;
		
		if(fm.a_b.value == '' || fm.a_b.value == '0')	return;
		if(fm.rent_dt.value == '')						return;
		
		if(fm2.car_gubun.value=='taecha') fm.rent_st.value 	= '1';//재리스
		
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "i_no2";
		fm.submit();
	}
		
	//중고차가격 계산하기-숨어서
	function getSecondhandCarAmt(){
		var fm = document.sh_form;
		var fm2 = document.form1;		
		
		fm.a_b.value 		= fm2.con_mon.value;
		fm.rent_dt.value 	= replaceString('-','',fm2.rent_start_dt.value);
		fm.today_dist.value = fm2.sh_km.value;
		fm.mode.value 		= 'view';
		
		if(fm.a_b.value == '' || fm.a_b.value == '0')	return;
		if(fm.rent_dt.value == '')						return;
		
		if(fm2.car_gubun.value=='taecha') fm.rent_st.value 	= '1';//재리스
				
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "_blank";
		fm.submit();
	}		
	
	//주행거리추정치		
	function getSecondhandCarDist(rent_dt, serv_dt, tot_dist){
		var fm = document.form1;
		rent_dt = fm.sh_day_bas_dt.value;
		serv_dt = fm.sh_km_bas_dt.value;
		tot_dist = fm.sh_tot_km.value;
		var height = 300;
		window.open("search_todaydist.jsp?car_mng_id=<%=base.getCar_mng_id()%>&rent_dt="+rent_dt+"&serv_dt="+serv_dt+"&tot_dist="+tot_dist, "VIEW_DIST", "left=0, top=0, width=650, height="+height+", scrollbars=yes");
	}
			
	//정비이력보기
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=base.getCar_mng_id()%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}
					
	//대여기간 셋팅
	function set_cont_date(obj){
		var fm = document.form1;
		var rent_way = fm.rent_way.value;
		
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;

		if(obj == fm.rent_start_dt){
//			fm.rent_start_dt.value = ChangeDate(fm.rent_start_dt.value);	
		}
		if(obj == fm.con_mon && rent_way == '1'){
			fm.fee_pay_tm.value = toInt(fm.con_mon.value)-3;
			fm.rent_start_dt.value = ChangeDate(fm.rent_start_dt.value);	
		}	
		if(obj == fm.con_mon && rent_way != '1'){
			fm.fee_pay_tm.value = fm.con_mon.value;
			fm.rent_start_dt.value = ChangeDate(fm.rent_start_dt.value);	
		}	
		
		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
					
		fm.action='get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();
	
	}
	
	//반올림
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
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
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
					
		car_price 	= toInt(parseDigit(fm.sh_amt.value));
		
		<%if(!car_gubun.equals("taecha") && ext_fee.getOpt_s_amt()>0){%>
		car_price	= <%=ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt()%>;		
		<%}%>
				
		
		//보증금---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//보증금 공급가
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value 	= fm.grt_s_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / car_price * 100, 1);
			}
		}else if(obj==fm.grt_amt){ 		//보증금 합계
			obj.value = parseDecimal(obj.value);
			fm.grt_s_amt.value 	= fm.grt_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / car_price * 100, 1);
				
			}
		//선납금---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt){ 	//선납금 공급가
			obj.value = parseDecimal(obj.value);
			fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
			}
		}else if(obj==fm.pp_v_amt){ 	//선납금 부가세
			obj.value = parseDecimal(obj.value);
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
			}		
		}else if(obj==fm.pp_amt){ 		//선납금 합계
			obj.value = parseDecimal(obj.value);
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));			
					
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
			}			
		//개시대여료---------------------------------------------------------------------------------			
		}else if(obj==fm.ifee_s_amt){ 	//개시대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.ifee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) * 0.1 );
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
		
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
			}			
		}else if(obj==fm.ifee_v_amt){ 	//개시대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
		
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
				
			}	
		}else if(obj==fm.ifee_amt){ 	//개시대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
			fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));			
					
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));	
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);			
			}	
		//적용잔가율---------------------------------------------------------------------------------			
		}else if(obj==fm.app_ja){ 		//적용잔가율
			fm.ja_r_amt.value 		= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.app_ja.value) /100,-3) );
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
		}else if(obj==fm.ja_r_s_amt){ 	//적용잔가 공급가
			obj.value = parseDecimal(obj.value);
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) * 0.1 );
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
			//fm.app_ja.value 		= parseFloatCipher3(toInt(parseDigit(fm.ja_amt.value)) / car_price * 100, 1);
		}else if(obj==fm.ja_r_v_amt){ 	//적용잔가 부가세
			obj.value = parseDecimal(obj.value);
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
		}else if(obj==fm.ja_r_amt){		//적용잔가 합계
			obj.value = parseDecimal(obj.value);
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));	
			if(car_price > 0){		
				fm.app_ja.value 		= parseFloatCipher3(toInt(parseDigit(fm.ja_r_amt.value)) / car_price * 100, 1);
			}
		//매입옵션율---------------------------------------------------------------------------------			
		}else if(obj==fm.opt_s_amt){ 	//매입옵션 공급가
			obj.value = parseDecimal(obj.value);
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) * 0.1 );
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));		
			if(car_price > 0){			
				fm.opt_per.value 		= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / car_price * 100, 1);
			}
			if(toInt(parseDigit(fm.opt_amt.value))==0 || toInt(parseDigit(fm.opt_amt.value)) >toInt(parseDigit(fm.ja_amt.value))){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//있다
			}else{
				fm.opt_chk[0].checked = true;//없다
			}
		}else if(obj==fm.opt_v_amt){ 	//매입옵션 부가세
			obj.value = parseDecimal(obj.value);
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
			if(toInt(parseDigit(fm.opt_amt.value))==0 || toInt(parseDigit(fm.opt_amt.value)) >toInt(parseDigit(fm.ja_amt.value))){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//있다
			}else{
				fm.opt_chk[0].checked = true;//없다
			}			
		}else if(obj==fm.opt_amt){ 		//매입옵션 합계
			obj.value = parseDecimal(obj.value);
			fm.opt_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));	
			if(car_price > 0){				
				fm.opt_per.value 		= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / car_price * 100, 1);
			}
			if(toInt(parseDigit(fm.opt_amt.value))==0 || toInt(parseDigit(fm.opt_amt.value)) >toInt(parseDigit(fm.ja_amt.value))){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//있다
			}else{
				fm.opt_chk[0].checked = true;//없다
			}			
		//규정대여료---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//규정대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
		}else if(obj==fm.inv_v_amt){ 	//규정대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value		= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
		}else if(obj==fm.inv_amt){ 		//규정대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
		}		
	}	
	
	//승계여부에 따른 디스플레이
	function display_suc(st){
		var fm = document.form1;
		if(st == 'grt'){
			if(fm.grt_suc_yn.value == '0'){
				fm.grt_s_amt.value  = '<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>';
				set_fee_amt(fm.grt_s_amt);
			}
		}else if(st == 'ifee'){
			if(fm.ifee_suc_yn.value == '0'){
				fm.ifee_s_amt.value = '<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt())%>';
				fm.ifee_v_amt.value = '<%=AddUtil.parseDecimal(ext_fee.getIfee_v_amt())%>';
				fm.ifee_amt.value   = '<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>';
				set_fee_amt(fm.ifee_s_amt);
			}
		}		
	}	
		
	//규정대여료 계산 (견적)
	function estimate(st){
		var fm = document.form1;
		
		set_fee_amt(fm.opt_amt);
	
		if(fm.rent_dt.value == '')		{ alert('연장계약일자를 입력하십시오.'); 	return; }
		if(fm.car_mng_id.value == '')	{ alert('챠랑이 선택되지 않았습니다. 확인하십시오.'); 	return; }		
		
		fm.o_13.value 		= fm.app_ja.value;
		fm.o_13_amt.value 	= fm.ja_r_amt.value;
		
		fm.ro_13.value 		= fm.max_ja.value;
		
		fm.grt_amt.value 	= fm.grt_s_amt.value;
		
		<%if(!car_gubun.equals("taecha") && ext_fee.getOpt_s_amt()>0){%>
		fm.o_1.value	= <%=ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt()%>;		
		<%}else{%>
		fm.o_1.value	= fm.sh_amt.value;
		<%}%>

		fm.esti_stat.value 	= st;
		
		fm.fee_rent_dt.value = replaceString("-","",fm.rent_start_dt.value);
		
		set_fee_amt(fm.grt_s_amt);
		
		fm.ro_13.value 		= fm.opt_per.value;
		fm.o_13_amt.value 	= fm.opt_amt.value;
		fm.o_13.value 		= 0;	
		
		fm.action='search_car_esti_a.jsp';		
		
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}

		fm.submit();

	}
	
	//견적이력
	function view_car_esti_h(){
		var SUBWIN="view_car_esti_list.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";  	
		window.open(SUBWIN, "CarEstiHistory", "left=50, top=50, width=1200, height=800, scrollbars=yes, status=yes"); 		
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
<form action='/acar/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">  
  <input type='hidden' name="mode"				value="lc_rent">    
  <input type='hidden' name="rent_st"			value="2"><!--연장견적-->      
  <input type='hidden' name="rent_dt"			value="">        
  <input type='hidden' name="a_b"				value="">  
  <input type='hidden' name="fee_opt_amt"		value="">      
  <input type='hidden' name="today_dist"		value="">        
</form>
<form action='' name="form1" method='post'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="car_gubun" 		value="<%=car_gubun%>">  
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">
  <input type='hidden' name="car_ext" 			value="<%=cr_bean.getCar_ext()%>">
  <input type='hidden' name="udt_st" 			value="<%=pur.getUdt_st()%>">  
  <input type='hidden' name="rent_way" 			value="<%=ext_fee.getRent_way()%>">
  <input type='hidden' name="fee_pay_tm" 		value="<%=ext_fee.getFee_pay_tm()%>">
  <input type='hidden' name="fee_pay_start_dt" 	value="">
  <input type='hidden' name="fee_pay_end_dt" 	value="">
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
  <input type='hidden' name='gi_st' 			value='<%=gins.getGi_st()%>'>  
  <input type='hidden' name='gi_amt' 			value='<%=gins.getGi_amt()%>'>    
  <input type='hidden' name='driving_age' 		value='<%=base.getDriving_age()%>'>
  <input type='hidden' name='gcp_kd' 			value='<%=base.getGcp_kd()%>'>
  <!--차가계산-->
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
  <input type='hidden' name="bc_b_e1"			value="">                
  <input type='hidden' name="bc_b_e2"			value="">                
        
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5><%if(car_gubun.equals("taecha")){%>출고지연대차<%}else{%>연장<%}%> 견적</span></span> : <%if(car_gubun.equals("taecha")){%>출고지연대차<%}else{%>연장<%}%> 견적</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>  
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>계약일자</td>
                    <td width=20%>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title width=10%>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr> 
                    <td class=title>상호</td>
                    <td>&nbsp;<%=client.getFirm_nm()%>
					(<b><font color='#990000'>
					  <% if(base.getSpr_kd().equals("3")) out.print("신설법인"); 	%>
                      <% if(base.getSpr_kd().equals("0")) out.print("일반고객"); 	%>
                      <% if(base.getSpr_kd().equals("1")) out.print("우량기업"); 	%>
                      <% if(base.getSpr_kd().equals("2")) out.print("초우량기업");  %>
					</font></b>)
					</td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<b><font color='#990000'><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></font></b></td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<b><font color='#990000'><%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></font></b></td>
                </tr>
                <tr>
                    <td class=title>차량번호</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class=title>차명</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
					&nbsp;&nbsp;&nbsp;
					<b><font color="#999999">[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></font></b>
        			</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title >피보험자</td>
                    <td width="20%">&nbsp;<b><font color='#990000'><%=ins.getCon_f_nm()%></font></b></td>
                    <td width="10%" class=title >운전자연령</td>
                    <td width="12%">&nbsp;
                        <%if(ins.getAge_scp().equals("1")){%>21세이상<%}%> 
                        <%if(ins.getAge_scp().equals("4")){%>24세이상<%}%> 
                        <%if(ins.getAge_scp().equals("2")){%>26세이상<%}%> 
                        <%if(ins.getAge_scp().equals("3")){%>전연령<%}%> 
                        <%if(ins.getAge_scp().equals("5")){%>30세이상<%}%>
                        <%if(ins.getAge_scp().equals("6")){%>35세이상<%}%>
                        <%if(ins.getAge_scp().equals("7")){%>43세이상<%}%>
						<%if(ins.getAge_scp().equals("8")){%>48세이상<%}%>
                    </td>
                    <td width="10%" class=title >대물배상</td>
                    <td width="12%">&nbsp;
                        <%if(ins.getVins_gcp_kd().equals("6")){%>5억원     <%}%>
						<%if(ins.getVins_gcp_kd().equals("7")){%>2억원     <%}%>
						<%if(ins.getVins_gcp_kd().equals("3")){%>1억원     <%}%>
                        <%if(ins.getVins_gcp_kd().equals("4")){%>5천만원   <%}%>
                        <%if(ins.getVins_gcp_kd().equals("1")){%>3천만원   <%}%>
                        <%if(ins.getVins_gcp_kd().equals("2")){%>1천5백만원<%}%>
                        <%if(ins.getVins_gcp_kd().equals("5")){%>1천만원   <%}%>
					</td>
                    <td width="10%" class=title >자기신체사고</td>
                    <td>&nbsp;
                        <%if(ins.getVins_bacdt_kd().equals("1")){%>3억원      <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("2")){%>1억5천만원 <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("6")){%>1억원      <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("5")){%>5천만원    <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("3")){%>3천만원    <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("4")){%>1천5백만원 <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("9")){%>미가입 <%}%>
					</td>
                </tr>
				<tr>
				    <td class=title>자기차량손해</td>
					<td colspan='5'>&nbsp;
					<%if(ins.getVins_cacdt_cm_amt()>0){%>
					<b><font color='#990000'>
					가입 ( 차량 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>만원, 자기부담금 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>만원)
                    </font></b>
					<%}else{%>
                    -
                    <%}%></td>
					<td class=title>자차면책금</td>
					<td>&nbsp;
					  <%=AddUtil.parseDecimal(base.getCar_ja())%>원</td>
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
    				if(fee_size >1 && (i+1)==(fee_size-1))	fee_opt_amt = fees.getOpt_s_amt()+fees.getOpt_v_amt();
    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></td>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선택사항</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                    <td width="13%" class=title >대여상품</td>
                    <td width="15%">&nbsp;
					    <%	String s_a_a= "";
							if(base.getCar_st().equals("1")) 		s_a_a = "2";
							else                             		s_a_a = "1";
							if(ext_fee.getRent_way().equals("1")) 	s_a_a = s_a_a+"1";
							else                              		s_a_a = s_a_a+"2";
							%>
                      <select name="s_a_a">
                        <%for(int i = 0 ; i < good_size ; i++){
        					CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>' <%if(s_a_a.equals(good.getNm_cd()))%>selected<%%>><%= good.getNm()%></option>
                        <%}%>
                      </select></td>			  
                <td width="10%" class=title >신용등급</td>
                <td width="12%">&nbsp;
				      <select name="s_spr_yn">
                  			<option value='3' <%if(base.getSpr_kd().equals("3"))%>selected<%%>>신설법인</option>
                  			<option value='0' <%if(base.getSpr_kd().equals("0"))%>selected<%%>>일반고객</option>
                  			<option value='1' <%if(base.getSpr_kd().equals("1")||base.getSpr_kd().equals(""))%>selected<%%>>우량기업</option>
                  			<option value='2' <%if(base.getSpr_kd().equals("2"))%>selected<%%>>초우량기업</option>
                      </select>
                    </td>
                <td width="10%" class=title>자차면책금</td>
                <td width="15%">&nbsp;
				<input type="text" name="s_car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(base.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                          원 
                    </td>
                <td width="10%" class=title >차령만료일</td>
                <td width="15%">&nbsp;
				  <b><font color='#990000'><%=AddUtil.ChangeDate2(cr_bean.getCar_end_dt())%></font></b>
                    </td>
              </tr>
                <tr> 
                    <td width="13%" class=title>보험계약자</td>
                    <td width="15%">&nbsp;<%if(cont_etc.getInsurant().equals("")) cont_etc.setInsurant("1");%>
                        <select name='insurant'>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>아마존카</option>
                          <%if(cont_etc.getInsurant().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsurant().equals("2")){%> selected <%}%>>고객</option>
                          <%}%>
                      </select></td>
                    <td width="10%"  class=title>피보험자</td>
                    <td colspan='5'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per' onChange='javascript:display_ip()'>
                          <option value="">선택</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>아마존카</option>
                          <%if(cont_etc.getInsur_per().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>고객</option>
                          <%}%>
                      </select></td>
                </tr>
              <tr> 
                <td width="13%" class=title >운전자연령</td>
                <td width="15%">&nbsp;
                    <select name='driving_age'>
                      <option value="">선택</option>
                      <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26세이상</option>
                      <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24세이상</option>
                      <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21세이상</option>
                      <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>모든운전자</option>
					  <option value=''>=피보험자고객=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30세이상</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35세이상</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43세이상</option>						
					  <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48세이상</option>					  						  					  
                  </select></td>
                <td width="10%" class=title>대물배상</td>
                <td width="15%">&nbsp;
                    <select name='gcp_kd'>
                      <option value="">선택</option>
                      <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                      <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1억원</option>
					  <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2억원</option>
					  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3억원</option>
					  <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5억원</option>
                  </select></td>
                <td width="10%" class=title >자기신체사고</td>
                <td colspan='3'>&nbsp;
                    <select name='bacdt_kd'>
                      <option value="">선택</option>
                      <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                      <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1억원</option>
                      <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>미가입</option>
                  </select></td>
              </tr>			  
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>	
	<input type='hidden' name="con_f_nm"		value="<%=ins.getCon_f_nm()%>">
	<input type='hidden' name="age_scp"			value="<%=ins.getAge_scp()%>">	
	<input type='hidden' name="vins_gcp_kd"		value="<%=ins.getVins_gcp_kd()%>">	
	<input type='hidden' name="vins_bacdt_kd"	value="<%=ins.getVins_bacdt_kd()%>">	
	<input type='hidden' name="car_ja"			value="<%=base.getCar_ja()%>">	
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
                    <td width='13%' class='title'> 기존가격 </td>
                    <td width="20%">&nbsp;
					  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("CAR_AMT")))%>원</td>
                    <td class='title' width="10%">선택사양</td>
                    <td width="20%">&nbsp;
					  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("OPT_AMT")))%>원</td>
                    <td class='title' width='10%'>색상</td>
                    <td>&nbsp;
					  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("COL_AMT")))%>원</td>
                </tr>			
                <tr>
                    <td width='13%' class='title'> 신차소비자가 </td>
                    <td width="20%">&nbsp;
        			  <input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("CAR_AMT"))+AddUtil.parseInt((String)sh_ht.get("OPT_AMT"))+AddUtil.parseInt((String)sh_ht.get("COL_AMT")))%>' size='10' class='defaultnum' readonly>
        				원&nbsp;</td>
                    <td class='title' width="10%">잔가율</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='sh_ja' value=''size='4' class='defaultnum' readonly>
						%</td>
                    <td class='title' width='10%'>중고차가</td>
                    <td>&nbsp;
                      <input type='text' name='sh_amt' value=''size='10' class='defaultnum' readonly>
						원
						
						<span class="b"><a href="javascript:getSecondhandCarAmt()" onMouseOver="window.status=''; return true" title="중고차가 계산하기"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
						
					</td>
                </tr>
                <tr>
                  <td class='title'>차령</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_year' value='<%=carOld.get("YEAR")%>' size='1' class='white' readonly>
                    년
                    <input type='text' name='sh_month' value='<%=carOld.get("MONTH")%>' size='2' class='white' readonly>
                    개월
                    <input type='text' name='sh_day' value='<%=carOld.get("DAY")%>' size='2' class='white' readonly>
                    일 (
					신차등록일 <input type='text' name='sh_init_reg_dt' value='<%=cr_bean.getInit_reg_dt()%>' size='11' class='white' readonly> ~
                    대여개시일 <input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(fee_start_dt)%>' size='11' class='white' readonly>
                  )</td>
                </tr>
                <tr>
                  <td class='title'>적용주행거리</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TODAY_DIST")) %>' class='defaultnum' onBlur='javascript:getSecondhandCarAmt_h();'>
					km
					/ 확인주행거리 <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TOT_DIST")) %>' class='defaultnum' >
					km(
					<input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2((String)sh_ht.get("SERV_DT")) %>' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
					)
					<span class="b"><a href="javascript:getSecondhandCarDist('','','')" onMouseOver="window.status=''; return true" title="중고차가 계산하기"><img src=/acar/images/center/button_in_jhgl.gif align=absmiddle border=0></a></span>
        			  &nbsp;&nbsp;
					  <span class="b"><a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="정비내역보기"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a></span>
					</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(car_gubun.equals("taecha")){%>출고지연대차<%}else{%>연장<%}%> 대여요금</span></td>
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
                    <td colspan="5">&nbsp;
        			  <input type="text" name="rent_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value); getSecondhandCarAmt_h();'></td>                    		  
                </tr>
                <tr>
                    <td width="13%" align="center" class=title>이용기간</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="con_mon" value='' size="4" maxlength="2" class='defaultnum' onChange='javascript:set_cont_date(this); getSecondhandCarAmt_h();'>
            			 개월</td>
                    <td width="10%" align="center" class=title>대여개시일</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="rent_start_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);'></td>
                    <td width="10%" align="center" class=title>대여만료일</td>
                    <td>&nbsp;
                    <input type="text" name="rent_end_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title'>구분</td>
                    <td class='title' width='13%'>공급가</td>
                    <td class='title' width='13%'>부가세</td>
                    <td class='title' width='13%'>합계</td>
                    <td class='title' width="28%">계약조건</td>
                    <td class='title' width='20%'>-</td>
                </tr>
                <tr>
                    <td width="3%" rowspan="3" class='title'>선<br>
                      수</td>
                    <td width="10%" class='title'>보증금</td>
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
                              <option value=""  <%if(fee.getGrt_amt_s()==0)%>selected<%%>>선택</option>
                              <option value="0" <%if(fee.getGrt_amt_s()> 0)%>selected<%%>>승계</option>
                              <option value="1">별도</option>
                            </select>				
        				</td>
                </tr>
                <tr>
                    <td class='title'>선납금</td>
                    <td align="center"><input type='text' size='11' name='pp_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='11' name='pp_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='11' name='pp_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='pere_r_per' class='fixnum' value='' readonly>
        				  % </td>
                    <td align='center'>-<input type='hidden' name='pere_per' value=''></td>
                </tr>
                <tr>
                    <td class='title'>개시대여료</td>
                    <td align="center"><input type='text' size='11' name='ifee_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='11' name='ifee_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='11' name='ifee_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">마지막
                        <input type='text' size='2' name='pere_r_mth' class='num' value=''>
        				  개월치 대여료 </td>
                    <td align='center'>
        			    <input type='hidden' name='pere_mth' value=''>
        				<select name='ifee_suc_yn' onChange="javascript:display_suc('ifee')">
                              <option value="">선택</option>
                              <option value="0">승계</option>
                              <option value="1">별도</option>
                            </select>
        				</td>
                </tr>
                <tr>
                    <td rowspan="3" class='title'>잔<br>
                      가</td>
                    <td class='title'>최대잔가</td>
                    <td align="center"><input type='text' size='10' name='ja_s_amt' maxlength='11' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='ja_v_amt' maxlength='10' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_amt' maxlength='11' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td align='center'>
        			  최대잔가율:차가의
                          <input type='text' size='4' name='max_ja' maxlength='10' class='whitenum' value='' readonly>
                          %</td>
                    <td align='center'>-</td>
                </tr>    
                <tr>
                    <td class='title'>매입옵션</td>
                    <td align="center"><input type='text' size='11' name='opt_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='11' name='opt_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='11' name='opt_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='opt_per' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  % </td>
                    <td align='center'>
        			  <input type='radio' name="opt_chk" value='0'>
                      없음
                      <input type='radio' name="opt_chk" value='1'>
        	 		  있음
                    </td>
                </tr>
                <tr>
                    <td class='title'>적용잔가</td>
                    <td align="center"><input type='text' size='10' name='ja_r_s_amt' maxlength='11' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='9' name='ja_r_v_amt' maxlength='10' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_r_amt' maxlength='11' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='app_ja' maxlength='10' class="whitenum" value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        			  % </td>
                    <td align='center'>-</td>				  
                </tr>		  				
                <tr>
                    <td colspan='2' class='title'>대여료 정상요금</td>
                    <td align="center" ><input type='text' size='11' name='inv_s_amt' maxlength='10' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='11' name='inv_v_amt' maxlength='9' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='11' maxlength='10' name='inv_amt' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">할인율<span class="contents1_1">
                      <input type='text' size='4' name='fee_dc_per' maxlength='4' class="num" value=''>%
					  <input type='hidden' name="bas_dt"		value="">
                    </span></td>
                    <td align='center'>&nbsp;
        			  <span class="b"><a href="javascript:estimate('account')" onMouseOver="window.status=''; return true" title="견적하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
					  
					  <span class="b"><a href="javascript:estimate('view')" onMouseOver="window.status=''; return true" title="견적하기">[확인]</a></span>
					  
                    </td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
		<td>* 이용기간을 입력하면 중고차가 및 대여기간이 계산됩니다.</td>
	</tr>
    <tr>
        <td>* 24개월이내에서 견적 가능합니다.</td>
    </tr>						
	
    <tr>
		<td align="right"><a href="javascript:view_car_esti_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a></td>
	</tr>	
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<iframe src="about:blank" name="i_no2" width="100%" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

	var fm = document.form1;
	
	if(fm.bas_dt.value == ''){
		fm.bas_dt.value 			= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';
		fm.rent_dt.value 			= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';
		fm.rent_start_dt.value 		= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';				
	}

<%	if(!car_gubun.equals("taecha") && ext_fee.getOpt_s_amt()>0){//연장계약시 매입옵션이 있는 경우%>		
	fm.fee_opt_amt.value = <%=ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt()%>;
	//fm.opt_chk[1].checked = true;
<%	}%>
	
	
	//디폴트 12개월
	fm.con_mon.value = '12';
	set_cont_date(fm.con_mon); 
	getSecondhandCarAmt_h();
//-->
</script>
</body>
</html>

