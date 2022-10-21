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
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");


	String user_id		= ck_acar_id;
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String car_gubun 	= request.getParameter("car_gubun")==null?"":request.getParameter("car_gubun");
	
	String tae_car_mng_id 	= request.getParameter("tae_car_mng_id")==null?"":request.getParameter("tae_car_mng_id");
	String tae_car_id 	= request.getParameter("tae_car_id")==null?"":request.getParameter("tae_car_id");
	String tae_car_seq 	= request.getParameter("tae_car_seq")==null?"":request.getParameter("tae_car_seq");
	String tae_car_rent_st 	= request.getParameter("tae_car_rent_st")==null?"":request.getParameter("tae_car_rent_st");
	String tae_car_rent_et 	= request.getParameter("tae_car_rent_et")==null?"":request.getParameter("tae_car_rent_et");
	
	String ext_esti_st 	= request.getParameter("ext_esti_st")==null?"":request.getParameter("ext_esti_st");
	
	String fee_start_dt = "";
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
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
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	String rent_way = ext_fee.getRent_way();
	
	ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));

	//이행보증보험
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//임의연장
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	
	fee_start_dt = rs_db.addDay(ext_fee.getRent_end_dt(), 1);
	
	//마지막연장 재견적
	if(ext_esti_st.equals("re")){
		fee_start_dt = ext_fee.getRent_start_dt();
		ext_fee 	= a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size-1));	
		fee_etcs 	= a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size-1));
		gins 			= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size-1));		
	}
	
	String fee_type = "fee";
	
	if(im_vt_size>0){
		Hashtable im_ht = (Hashtable)im_vt.elementAt(im_vt_size-1);
		if(AddUtil.parseInt(String.valueOf(im_ht.get("RENT_END_DT"))) > AddUtil.parseInt(ext_fee.getRent_end_dt())){
			//fee_start_dt = rs_db.addDay(String.valueOf(im_ht.get("RENT_END_DT")), 1);
			fee_type = "fee_im";
		}
	}
	
	
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
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//중고차잔가 정보		
	Hashtable sh_ht = new Hashtable();
	Hashtable carOld 	= c_db.getOld(cr_bean.getInit_reg_dt(), fee_start_dt);
	
	//재리스차량기본정보테이블
	Hashtable ht = shDb.getShBase(base.getCar_mng_id());
			
	//차량정보-여러테이블 조인 조회
	Hashtable ht2 = shDb.getBase(base.getCar_mng_id(), fee_start_dt);
			
	//최초 계약시 주행거리(보유차)가 있으면 
	if(AddUtil.parseDouble(String.valueOf(ht2.get("TOT_DIST")))>0 && f_fee_etc.getOver_bas_km() > 0){
		Hashtable carOld2 	= c_db.getOld(fee.getRent_start_dt(), String.valueOf(ht2.get("SERV_DT")));
		double start_serv_mon = (AddUtil.parseDouble(String.valueOf(carOld2.get("YEAR")))*12)+AddUtil.parseDouble(String.valueOf(carOld2.get("MONTH")));
		//가장 최근의 주행거리가 최초 계약 대여개시일(보유차)로부터 3개월 초과
		if(start_serv_mon>3){
			Hashtable ht3 = shDb.getBase(base.getCar_mng_id(), fee_start_dt, "1", fee.getRent_start_dt(), f_fee_etc.getOver_bas_km(), f_fee_etc.getAgree_dist());
			ht2.put("TODAY_DIST", String.valueOf(ht3.get("TODAY_DIST")));
		//가장 최근의 주행거리가 최초 계약 대여개시일(보유차)로부터 3개월 이내	
		}else{
			Hashtable ht3 = shDb.getBase(base.getCar_mng_id(), fee_start_dt, "2", fee.getRent_start_dt(), f_fee_etc.getOver_bas_km(), f_fee_etc.getAgree_dist());
			ht2.put("TODAY_DIST", String.valueOf(ht3.get("TODAY_DIST")));
		}
	}
			
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
		if(!String.valueOf(ht2.get("TAX_DC_AMT")).equals(String.valueOf(ht.get("TAX_DC_AMT")))) 						chk++;
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
	
	String tr_display_dt = "none";
	String tr_display    = "none";
	
	//견적담당자
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	if(nm_db.getWorkAuthUser("전산팀",user_id)){
		tr_display_dt 	= "";
		tr_display 	= "";
	}
	
	
	
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
	
	//20211126 여유분 1개월 더 줌 (생산일 기준으로하면 더 줘야 함) - 김광수팀장요청
	car_end_dt_max = c_db.addMonth(car_end_dt_max, -1);
	
	//만기매칭대차인 경우는 대차시작일부터 주행거리계산--
	String taecha_st_dt = "";
	taecha_st_dt = ac_db.getClsEtcTaeChaStartDt(rent_mng_id, rent_l_cd, base.getCar_mng_id() );	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type-"text/css>
<!--	
input.whitetextredb		{ text-align:left; font-size : 9pt; background-color:#ffffff; border-color:##ffffff; border-width:0; color:#ff0000;  font-weight:bold;}
//-->
</style>
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
	
	//예상주행거리 재계산
	function getTotDist_h(){
		var fm = document.sh_form;
		var fm2 = document.form1;		
		fm.a_b.value 		= fm2.con_mon.value;
		fm.rent_dt.value 	= replaceString('-','',fm2.rent_start_dt.value);
		fm.today_dist.value = fm2.sh_km.value;
		fm.fee_opt_amt.value = fm2.fee_opt_amt.value;
		fm.action = "/acar/secondhand/getTotDistSet.jsp";
		fm.target = "i_no2";
		fm.submit();
	}

	//중고차가격 계산하기-숨어서
	function getSecondhandCarAmt_h(){
		var fm = document.sh_form;
		var fm2 = document.form1;	
		
		fm2.sh_amt.value = '0'; //초기화
		
		fm.a_b.value 		= fm2.con_mon.value;
		fm.rent_dt.value 	= replaceString('-','',fm2.rent_start_dt.value);
		fm.today_dist.value = fm2.sh_km.value;
		fm.fee_opt_amt.value = fm2.fee_opt_amt.value;
		
		if(fm.a_b.value == '' || fm.a_b.value == '0')	return;
		if(fm.rent_dt.value == '')			return;
		if(toInt(fm.a_b.value) > 24){ alert('24개월 미만만 연장견적됩니다.'); 	return; }
		if(toInt(fm.a_b.value) == 0){ alert('0개월 이상만 연장견적됩니다.'); 	return; }
		
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
		fm.fee_opt_amt.value = fm2.fee_opt_amt.value;
		fm.mode.value 		= 'view';
		
		if(fm.a_b.value == '' || fm.a_b.value == '0')	return;
		if(fm.rent_dt.value == '')						return;
		if(toInt(fm.a_b.value) > 24){ alert('24개월 미만만 연장견적됩니다.'); return; }
		
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
		
		if(toInt(fm.con_mon.value) > 24){
//			alert('24개월 미만만 연장견적됩니다.');
//			fm.con_mon.value = '24';
			return;
		}
		
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
		var car_price 	= toInt(parseDigit(fm.o_1.value));
		
		
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
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
		}else if(obj==fm.ifee_v_amt){ 	//개시대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
		}else if(obj==fm.ifee_amt){ 	//개시대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
			fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));			
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));	
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);			
		//적용잔가율---------------------------------------------------------------------------------			
		}else if(obj==fm.app_ja){ 		//적용잔가율
			fm.ja_r_amt.value 		= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.app_ja.value) /100,-3) );
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
		}else if(obj==fm.ja_r_s_amt){ 	//적용잔가 공급가
			obj.value = parseDecimal(obj.value);
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) * 0.1 );
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
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
				fm.opt_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / car_price * 100, 1);
			}
			if(toInt(parseDigit(fm.opt_amt.value))==0){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			<%if(!acar_de.equals("1000")){%>
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//있다
			}else{
				fm.opt_chk[0].checked = true;//없다
			}
			<%}%>
		}else if(obj==fm.opt_v_amt){ 	//매입옵션 부가세
			obj.value = parseDecimal(obj.value);
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
			if(toInt(parseDigit(fm.opt_amt.value))==0){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			<%if(!acar_de.equals("1000")){%>
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//있다
			}else{
				fm.opt_chk[0].checked = true;//없다
			}			
			<%}%>
		}else if(obj==fm.opt_amt){ 		//매입옵션 합계
			obj.value = parseDecimal(obj.value);
			fm.opt_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));	
			if(car_price > 0){				
				fm.opt_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / car_price * 100, 1);
			}
			if(toInt(parseDigit(fm.opt_amt.value))==0){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			<%if(!acar_de.equals("1000")){%>
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//있다
			}else{
				fm.opt_chk[0].checked = true;//없다
			}			
			<%}%>
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
	
	//매입옵션
	function display_opt(){
		var fm = document.form1;
		fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.o_1.value)) * toFloat(fm.opt_per.value) / 100 );
		fm.opt_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
		fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));	
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
		
		//일반식차량 주행거리 과다 점검
		<%if(rent_way.equals("1")){%>
		var dist_chk_var = 0;
		<%	if(base.getCar_gu().equals("1")){ //신차%>
			dist_chk_var = getCutRoundNumber(toInt(parseDigit(fm.sh_km.value)) / (toInt(parseDigit(fm.o_rent_days.value)) /365),0);
		<%	}else{ //재리스%>
			dist_chk_var = getCutRoundNumber((toInt(parseDigit(fm.sh_km.value)) - toInt(parseDigit(fm.o_over_bas_km.value))) / (toInt(parseDigit(fm.o_rent_days.value)) /365),0);
		<%	}%>
		if(dist_chk_var > 35000){
			if(confirm('일반식 차량의 주행거리가 과다(년간 35,000km이상) 하니,\n\n영업팀장의 사전승인을 맡은 후 연장 계약 진행바랍니다.\n\n사전승인을 맡았습니까?')){
				
			}else{
				return;
			}
		}
		<%}%>			
		
		//20220613 기존 일반식일때는 1년미만 기본식견적은 안된다
		if(fm.f_rent_way.value == '1' && (toInt(fm.t_con_mon.value)+toInt(fm.con_mon.value)) <= 12 && (fm.a_a.value == '22' || fm.a_a.value == '12')){
			alert('기존 일반식계약을 기본식 1년미만으로 견적할 수 없습니다.'); 	return;
		}
		
		//20220613 기존 일반식일때는 1년이상 기본식견적이면 상의하라는 문구
		if(fm.f_rent_way.value == '1' && (toInt(fm.t_con_mon.value)+toInt(fm.con_mon.value)) > 12 && (fm.a_a.value == '22' || fm.a_a.value == '12')){
			if(confirm('일반식 -> 기본식 연장견적 이므로 영업팀장과 상의하세요\n\n견적진행하시겠습니까?')){
				
			}else{
				return;
			}			
		}
		
	
		if(fm.rent_dt.value == '')	{ alert('연장계약일자를 입력하십시오.'); 	return; }
		if(fm.rent_start_dt.value == '')	{ alert('연장대여개시일을 입력하십시오.'); 	return; }
		if(fm.car_mng_id.value == '')	{ alert('차량이 선택되지 않았습니다. 확인하십시오.'); 	return; }	
		if(toInt(fm.con_mon.value) > 24){ alert('24개월 미만만 연장견적됩니다.'); return; }	
		if(fm.sh_amt.value == '0' || fm.sh_amt.value == ''){ alert('중고차가 계산이 아직 안되어 있습니다.'); getSecondhandCarAmt_h(); return; }
		
		//영업용차량일 경우 차령만료일 체크해서 연장만료일자 경과를 할 경우 등록이 안되도록 한다.
		<%if(!ck_acar_id.equals("000029") && !ck_acar_id.equals("000026") && cr_bean.getCar_use().equals("1")){%>
		if(toInt(replaceString('-','','<%=car_end_dt_max%>')) < toInt(replaceString('-','',fm.rent_end_dt.value)) ){
			alert('대여기간 만료일이 차령만료일보다 큽니다. 확인하십시오.'); 						fm.rent_end_dt.focus(); 	return;
		}
		<%}%>		
		
		//20150626 리스기본식만 보험계약자 고객 선택가능, 보험계약자가 고객이면 피보험자도 고객이여야 한다.			
		if('<%=base.getCar_st()%><%=ext_fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('보험계약자 고객이면 피보험자도 고객이여야 합니다.');
				return;					
			}
		}
		
			
		fm.grt_amt.value 	= fm.grt_s_amt.value;
		
		fm.esti_stat.value 	= st;
		
		fm.fee_rent_dt.value = replaceString("-","",fm.rent_start_dt.value);
		
		set_fee_amt(fm.grt_s_amt);
		
		fm.ro_13.value 		= fm.opt_per.value;
		fm.o_13_amt.value 	= fm.opt_amt.value;
		fm.o_13.value 		= 0;	
		

		fm.action='search_car_esti_s_a.jsp';		
		
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}
		
		//20161101 매입옵션 없는 계약건 연장계약 견적시 매입옵션 부여 여부 제한
		<%if(!acar_de.equals("1000")){%>
		if(toInt(parseDigit(fm.fee_opt_amt.value))==0 && fm.opt_chk[1].checked == true ){
			if('<%=base.getCar_gu()%>'=='0' && '<%=ej_bean.getJg_b()%>' ==2){
				alert('기존계약의 매입옵션이 없습니다.\n\nLPG차량 재리스 연장시 매입옵션을 부여할 수 없습니다.');
				return;
			}else{
				if(confirm('기존계약의 매입옵션이 없습니다.\n\n연장계약의 매입옵션 부여시 반드시 영업팀장님에게 사전승인를 맡으시기 바랍니다.\n\n사전승인을 맡았습니까?')){
					
				}else{
					return;
				}
			}
		}
		<%}%>
		
		if(confirm('현재 진행중인 계약의 다음 연장을 견적합니다.\n\n견적하시겠습니까?')){	
			fm.submit();
		}
	}
	
	//견적이력
	function view_car_esti_h(){
		var fm = document.form1;
		var SUBWIN="view_car_esti_list.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+fm.fee_rent_st.value;
		window.open(SUBWIN, "CarEstiHistory", "left=50, top=50, width=1200, height=800, scrollbars=yes, status=yes");
	}
	
	//초과운행거리 상세보기	
	function view_over_agree(){
		var fm = document.form1;
		var SUBWIN="view_over_agree.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=ext_fee.getRent_st()%>&tot_dist=<%=sh_ht.get("TODAY_DIST")%>";
		window.open(SUBWIN, "ViewOverAgree", "left=50, top=50, width=850, height=700, scrollbars=yes, status=yes");
	}

	//거래처 연체금액
	function view_dlyamt(client_id)
	{
		window.open('/acar/account/stat_settle_sc_in_view_sub_list_client.jsp?client_id='+client_id, "CLIENT_DLVAMT", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
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
  <input type='hidden' name="from_page"			value="/fms2/lc_rent/search_car_esti_s.jsp">          
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
  <input type='hidden' name='gi_st' 			value='<%=gins.getGi_st()%>'>  
  <input type='hidden' name='gi_amt' 			value='<%=gins.getGi_amt()%>'>    
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
  <input type="hidden" name="tax_dc_s_amt"   		value="<%=car.getTax_dc_s_amt()%>">  
  <input type="hidden" name="tax_dc_v_amt"   		value="<%=car.getTax_dc_v_amt()%>">    
  <input type="hidden" name="tax_dc_amt"   		value="<%=car.getTax_dc_s_amt()+car.getTax_dc_v_amt()%>">        
  <input type="hidden" name="spe_tax"   		value="<%=car.getSpe_tax()%>">  
  <input type="hidden" name="edu_tax"   		value="<%=car.getEdu_tax()%>">
  <input type="hidden" name="tot_tax"   		value="<%=car.getSpe_tax()+car.getEdu_tax()%>">
  <input type='hidden' name="ro_13"				value="">  
  <input type='hidden' name="o_13"				value="">  
  <input type='hidden' name="o_13_amt"			value="">      
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
    
  <input type='hidden' name="est_from"			value="lc_renew">      
  <input type='hidden' name="ins_chk1"			value="">        
  <input type='hidden' name="ins_chk2"			value="">          
  <input type='hidden' name="ins_chk3"			value="">   
  <input type='hidden' name="ins_chk4"			value="">                         
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">   
  <%if(ext_esti_st.equals("re")){%>
  <input type='hidden' name="fee_rent_st"		value="<%=fee_size%>">
  <%}else{%>
  <input type='hidden' name="fee_rent_st"		value="<%=fee_size+1%>">
  <%}%>
  <input type='hidden' name="fee_rent_dt"		value="">              
  <input type='hidden' name="bc_b_e1"			value="">                
  <input type='hidden' name="bc_b_e2"			value="">     
  <input type='hidden' name="fee_type"			value="<%=fee_type%>">  
  <input type='hidden' name="com_emp_yn"	value="<%=cont_etc.getCom_emp_yn()%>">	   
             
        
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
                      <% 	if(base.getSpr_kd().equals("")){
                      			if(base.getCar_gu().equals("0")) base.setSpr_kd("1"); //재리스-우량기업
                      			if(base.getCar_gu().equals("1")) base.setSpr_kd("2"); //신차-초우량기업
                      		}
                      %>
                      <% if(base.getSpr_kd().equals("3")) out.print("신설법인"); 	%>
                      <% if(base.getSpr_kd().equals("0")) out.print("일반고객"); 	%>
                      <% if(base.getSpr_kd().equals("1")) out.print("우량기업"); 	%>
                      <% if(base.getSpr_kd().equals("2")) out.print("초우량기업");  %>
					</font></b>)
					</td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<b><font color='#990000'><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></font></b></td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<b><font color='#990000'><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></font></b></td>
                </tr>
                <tr>
                    <td class=title>차량번호</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class=title>차명</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class=title>신차등록일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
                    <td class=title>차령만료일</td>
                    <td>&nbsp;<b><font color='#990000'><%=AddUtil.ChangeDate2(cr_bean.getCar_end_dt())%></font></b>
                    <td class=title>차종코드</td>
                    <td>&nbsp;<b><font color='#990000'><%=cm_bean.getJg_code()%></font></b>
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
                        <%if(ins.getAge_scp().equals("9")){%>22세이상<%}%>
                        <%if(ins.getAge_scp().equals("10")){%>28세이상<%}%>
                        <%if(ins.getAge_scp().equals("11")){%>35세이상~49세이하<%}%>
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
    <% 	String f_rent_way = "";
    	int t_con_mon = 0;
    %>
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
    				
    				if(i==0){
    					f_rent_way = fees.getRent_way();
    				}
    				
    				t_con_mon += AddUtil.parseInt(fees.getCon_mon());
    				
    				//마지마연장 재견적
					if(ext_esti_st.equals("re")){
						if((i+2)==fee_size)			fee_opt_amt = fees.getOpt_s_amt()+fees.getOpt_v_amt(); //마지막연장 재견
					}else{				
	    				if(fee_size >0 && (i+1)==fee_size)	fee_opt_amt = fees.getOpt_s_amt()+fees.getOpt_v_amt(); //새로운연장 견적
    				}
    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>개월</td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>원</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>원</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>원</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>원</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right">
					<%if(fee_size >1 && (i+1)==(fee_size)){%>
					<b><font color='#990000'><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>원</font></b>
					<%}else{%>
					<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>원
					<%}%>
					</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
    		  <%}}%>
            </table>
		<%}%>
	    </td>
	</tr>
	<input type='hidden' name="f_rent_way"	value="<%=f_rent_way%>">
	<input type='hidden' name="t_con_mon"	value="<%=t_con_mon%>">
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납채권</span>
	    	- <input type="button" class="button" id="bad_amt" value='채권보기' onclick="javascript:view_dlyamt('<%=base.getClient_id()%>');">
	    	</td>
	</tr>		
	<input type='hidden' name="con_f_nm"		value="<%=ins.getCon_f_nm()%>">
	<input type='hidden' name="age_scp"			value="<%=ins.getAge_scp()%>">	
	<input type='hidden' name="vins_gcp_kd"		value="<%=ins.getVins_gcp_kd()%>">	
	<input type='hidden' name="vins_bacdt_kd"	value="<%=ins.getVins_bacdt_kd()%>">	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량가격 <%=fee_opt_amt%></span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr id=tr_1 style="display:''">
                    <td width='13%' class='title'> 기존가격 </td>
                    <td width="15%">&nbsp;
					  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("CAR_AMT")))%>원</td>
                    <td class='title' width="12%">선택사양</td>
                    <td width="13%">&nbsp;
					  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("OPT_AMT")))%>원</td>
                    <td class='title' width='10%'>색상</td>
                    <td width="12%">&nbsp;
					  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("COL_AMT")))%>원</td>
                    <td class='title' width='10%'>개소세감면</td>
                    <td width="15%">&nbsp;	
					  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("TAX_DC_AMT")))%>원</td>
                </tr>	
                <tr id=tr_1 style="display:''">
                    <td class='title' width='10%'>신차소비자가</td>
                    <td colspan='7'>&nbsp;	
					  <input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("CAR_AMT"))+AddUtil.parseInt((String)sh_ht.get("OPT_AMT"))+AddUtil.parseInt((String)sh_ht.get("COL_AMT"))-AddUtil.parseInt((String)sh_ht.get("TAX_DC_AMT")))%>' size='10' class='whitenum' readonly>
        				원&nbsp;				  
					</td>					  
                </tr>	                
                <tr>
                    <td width='13%' class='title'> 중고차가 </td>
                    <td colspan='7'>&nbsp;
					  <input type='text' name='sh_amt' value=''size='10' class='whitenum' readonly>
					  원
					  &nbsp;&nbsp;&nbsp;				  	
					  (잔가율: <input type='text' name='sh_ja' value=''size='4' class='whitenum' readonly>
						%,  예상주행거리 기준 )
					  <%if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id)){%>
						&nbsp;&nbsp;<span class="b"><a href="javascript:getSecondhandCarAmt()" onMouseOver="window.status=''; return true" title="중고차가 계산하기"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
					  <%}%>							
					</td>                    				  
                </tr>													
                <tr>
                    <td width='13%' class='title'> 적용차가 </td>
                    <td colspan='7'>&nbsp;
					  <input type='text' name='o_1' value=''size='10' class='whitenum'>
					  원
					  &nbsp;&nbsp;&nbsp;
					  (기존 매입옵션이 있으면 기존 매입옵션값, 없으면 현재 중고차가격이 적용됩니다.)					  
					</td>                    				  
                </tr>							
                <tr id=tr_1 style='display:<%=tr_display%>'>
                    <td class='title' width='10%'>차령</td>
                    <td colspan='5'>&nbsp;                      
						<input type='text' name='sh_year' value='<%=carOld.get("YEAR")%>' size='1' class='white' readonly>
                    년
                    <input type='text' name='sh_month' value='<%=carOld.get("MONTH")%>' size='2' class='white' readonly>
                    개월
                    <input type='text' name='sh_day' value='<%=carOld.get("DAY")%>' size='2' class='white' readonly>
                    일 &nbsp;  
					(
					신차등록일 <input type='text' name='sh_init_reg_dt' value='<%=cr_bean.getInit_reg_dt()%>' size='11' class='white' readonly> ~
                    대여개시일 <input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(fee_start_dt)%>' size='11' class='white' readonly>
                  )
					</td>
					<td class='title' width='10%'>기존매입옵션</td>
					<td >&nbsp;
					  <input type='text' name='fee_opt_amt' value=''size='10' class='whitenum'>
					  원
					</td>
                </tr>
                
                <!--초과운행부담금 산출-->
                <tr>
                    <td class='title' width='13%'>연간약정운행거리</td>
                    <td>&nbsp;
						<input type='text' name='o_agree_dist' size='6' value='<%=AddUtil.parseDecimal(f_fee_etc.getAgree_dist())%>' class='whitenum' readonly>
					km이하/1년
					</td>
                    <td class='title'>약정운행거리(한도)</td>
                    <td colspan='3'>&nbsp;
						<input type='text' name='o_y_agree_dist' size='6' value='' class='whitenum' readonly>
					km (연장약정운행거리*대여일수<input type='text' name='o_rent_days' size='2' value='' class='whitenum' readonly>/365)
					</td>					
                    <td class='title' width='13%'>최초주행거리(보유차)</td>
                    <td>&nbsp;
						<input type='text' name='o_over_bas_km' size='6' value='<%=AddUtil.parseDecimal(f_fee_etc.getOver_bas_km())%>' class='whitenum' readonly>
					km
					</td>
                </tr>
                <tr>
                    <td class='title' width='13%'>초과운행거리 산출기준</td>
                    <td colspan='7'>&nbsp;
						<input type='text' name='o_b_agree_dist' size='6' value='' class='whitenum' readonly>
					km (약정운행거리(한도)+최초주행거리(보유차)+서비스마일리지(1000km))
					</td>
                </tr>                
                
                <tr>
                    <td class='title' width='13%'>예상주행거리</td>
                    <td colspan='7'>&nbsp;                      
						<input type='text' name='o_sh_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TODAY_DIST")) %>' class='whitenum' readonly>
					km
					&nbsp;&nbsp; 
					(실견적은 아래의 "적용주행거리" 값 기준으로 계산됩니다.)
					</td>
                </tr>				
                
                <tr>
                    <td class='title' width='13%'>초과운행거리</td>
                    <td colspan='7'>&nbsp;
						<input type='text' name='o_over_agree_dist' size='6' value='' class='whitenum' readonly>
					km &nbsp;&nbsp; 
					<input type='text' name='o_over_agree_dist_nm' size='6' value='' class='whitetextredb' readonly>
					&nbsp;&nbsp; 
					<input type="button" class="button" id="over_agree_pop" value='상세보기' onclick="javascript:view_over_agree();">
					&nbsp;&nbsp; 
					(예상주행거리-초과운행거리 산출기준(주행거리)
					</td>
                </tr>   
                                
                <tr id=tr_1 style='display:<%=tr_display%>'>
                    <td width="13%" class='title'> 최근주행거리 </td>
                    <td  colspan='7'>&nbsp;
        			  <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TOT_DIST")) %>' class='whitenum' >
					km
					(
					기준일자 <input type='text' name='sh_km_bas_dt' size='10' value='<%= AddUtil.ChangeDate2((String)sh_ht.get("SERV_DT")) %>' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value);'>
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
        <td>* 위 초과운행거리는 예상주행거리를 기준으로 계산한 참고값입니다.</td>
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
					    			<% String s_a_a= "";
												if(base.getCar_st().equals("1")) 			s_a_a = "2";
												else                             			s_a_a = "1";
												if(ext_fee.getRent_way().equals("1")) s_a_a = s_a_a+"1";
												else                              		s_a_a = s_a_a+"2";
										%>
							        
                      <select <%if(!acar_de.equals("1000")){%>name="a_a"<%}else{%>name="s_a_a" disabled<%}%> class="default">
                        <%for(int i = 0 ; i < good_size ; i++){
        					         CodeBean good = goods[i];
        					         //기본식고객은 기본식만
        					         if(ext_fee.getRent_way().equals("3") && (good.getNm_cd().equals("21")||good.getNm_cd().equals("11"))) continue;
        					         //영업용차량은 장기렌트만
        					         if(base.getCar_st().equals("1") && (good.getNm_cd().equals("11")||good.getNm_cd().equals("12"))) continue;
        					         //자가용차량은 리스계약만
        					         if(base.getCar_st().equals("3") && (good.getNm_cd().equals("21")||good.getNm_cd().equals("22"))) continue;
        					      %>
                        <option value='<%= good.getNm_cd()%>' <%if(s_a_a.equals(good.getNm_cd()))%>selected<%%>><%= good.getNm()%></option>
                        <%}%>
                      </select>
                    
							        <%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="a_a" value="<%=s_a_a%>">
							        <%}%>
                    
                    </td>
                <td width="10%" class=title >신용등급</td>
                <td width="12%">&nbsp;
				      <select name="spr_yn" class="default">
                  			<option value='3' <%if(base.getSpr_kd().equals("3"))%>selected<%%>>신설법인</option>
                  			<option value='0' <%if(base.getSpr_kd().equals("0"))%>selected<%%>>일반고객</option>
                  			<option value='1' <%if(base.getSpr_kd().equals("1")||base.getSpr_kd().equals(""))%>selected<%%>>우량기업</option>
                  			<option value='2' <%if(base.getSpr_kd().equals("2"))%>selected<%%>>초우량기업</option>
                      </select>
                      <%//20211214 에이전트 연장견적도 신용등급 선택가능하게%>
                      <!-- 
                      <select <%if(!acar_de.equals("1000")){%>name="spr_yn"<%}else{%>name="s_spr_yn" disabled<%}%> class="default">
                  			<option value='3' <%if(base.getSpr_kd().equals("3"))%>selected<%%>>신설법인</option>
                  			<option value='0' <%if(base.getSpr_kd().equals("0"))%>selected<%%>>일반고객</option>
                  			<option value='1' <%if(base.getSpr_kd().equals("1")||base.getSpr_kd().equals(""))%>selected<%%>>우량기업</option>
                  			<option value='2' <%if(base.getSpr_kd().equals("2"))%>selected<%%>>초우량기업</option>
                      </select>
                      <%if(acar_de.equals("1000")){%>
						<input type='hidden' name="spr_yn" value="<%=base.getSpr_kd()%>">
					  <%}%>
					  -->							        
                    </td>
                <td width="10%" class=title>보험계약자</td>
                <td width="15%">&nbsp;<%if(cont_etc.getInsurant().equals("")) cont_etc.setInsurant("1");%>
                        <select <%if(!acar_de.equals("1000")){%>name='insurant'<%}else{%>name="s_insurant" disabled<%}%> class="default">                          
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>아마존카</option>
                          <%if(cont_etc.getInsurant().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsurant().equals("2")){%> selected <%}%>>고객</option>
                          <%}%>
                      </select>
                      <%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="insurant" value="<%=cont_etc.getInsurant()%>">
							        <%}%>
                    </td>
                <td width="10%" class=title>피보험자</td>
                <td width="15%">&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select <%if(!acar_de.equals("1000")){%>name='insur_per'<%}else{%>name="s_insur_per" disabled<%}%> class="default">
                          <option value="">선택</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>아마존카</option>
                          <%if(car_st.equals("3") && cont_etc.getInsur_per().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>고객</option>
                          <%}%>
                      </select>
                      <%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="insur_per" value="<%=cont_etc.getInsur_per()%>">
							        <%}%>
                    </td>                    
              </tr>
              <tr> 
                <td width="13%" class=title >자차면책금</td>
                <td width="15%">&nbsp;
                	<%if(acar_de.equals("1000")){%>
							        <%=AddUtil.parseDecimal(base.getCar_ja())%>원
							        <input type='hidden' name="car_ja" value="<%=base.getCar_ja()%>">
							    <%}else{%>
				          <input type="text" name="car_ja" class='defaultnum' size="10" value="<%=AddUtil.parseDecimal(base.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                          원
                  <%}%>
                    </td>
                <td width="10%" class=title >운전자연령</td>
                <td width="12%">&nbsp;
                    <select <%if(!acar_de.equals("1000")){%>name='driving_age'<%}else{%>name="s_driving_age" disabled<%}%> class="default">
                      <option value="">선택</option>
                      <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26세이상</option>
                      <%if(car_st.equals("3")){%>
                      <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24세이상</option>
                      <%}%>
                      <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21세이상</option>
                      <%if(car_st.equals("3")){%>
                      <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>모든운전자</option>
                      <option value=''>=피보험자고객=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30세이상</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35세이상</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43세이상</option>						
                      <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48세이상</option>
                      <option value='9' <%if(base.getDriving_age().equals("9")){%>selected<%}%>>22세이상</option>					  
                      <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>28세이상</option>					  
                      <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>35세이상~49세이하</option>					  
		                  <%}%>
                  </select>
                  		<%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="driving_age" value="<%=base.getDriving_age()%>">
							        <%}%>
                  </td>
                <td width="10%" class=title>대물배상</td>
                <td width="15%">&nbsp;
                    <select <%if(!acar_de.equals("1000")){%>name='gcp_kd'<%}else{%>name="s_gcp_kd" disabled<%}%> class="default">
                      <option value="">선택</option>
                          <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                          <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1억원</option>
                          <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2억원</option>
                          <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3억원</option>
                          <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5억원</option>						  
                    </select>
                  		<%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="gcp_kd" value="<%=base.getGcp_kd()%>">
							        <%}%>                  
                  </td>
                <td width="10%" class=title >자기신체사고</td>
                <td width="15%">&nbsp;
                    <select <%if(!acar_de.equals("1000")){%>name='bacdt_kd'<%}else{%>name="s_bacdt_kd" disabled<%}%> class="default">
                      <option value="">선택</option>
                      <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1억원</option>
                      <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>미가입</option>
                      <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                  </select>
                  		<%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="bacdt_kd" value="<%=base.getBacdt_kd()%>">
							        <%}%>
                  </td>
              </tr>		
              <tr> 
                    <td width="13%" class=title>이용기간</td>
                    <td width="15%">&nbsp;
                        <input type='text' name="con_mon" value='' size="4" maxlength="2" class='defaultnum' onChange='javascript:set_cont_date(this); getSecondhandCarAmt_h();'>
            			 개월</td>			  
                <td width="10%" class=title >보증금</td>
                <td width="12%">&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        <%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>원
							        <input type='hidden' name="grt_s_amt" value="<%=ext_fee.getGrt_amt_s()%>">
							    <%}else{%>                	
                    <input type='text' size='11' maxlength='10' name='grt_s_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원
        				  <%}%>
        				  </td>
                <td width="10%" class=title>선납금</td>
                <td width="15%">&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        -
							        <input type='hidden' name="pp_amt" value="0">
							    <%}else{%>                      	
                    <input type='text' size='11' name='pp_amt' maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원
        				  <%}%>
        				  </td>
                <td width="10%" class=title >개시대여료</td>
                <td width="15%">&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        -
							        <input type='hidden' name="pere_r_mth" value="0">
							    <%}else{%>                   	
                    <input type='text' size='2' name='pere_r_mth' class='defaultnum' value=''>
        				  개월치 대여료
        				  <%}%>
        				  </td>
              </tr>		
              <tr> 
                    <td width="13%" class=title >적용주행거리</td>
                    <td width="15%">&nbsp;
					  <input type='text' name='sh_km' size='10' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TODAY_DIST")) %>' class='defaultnum' onBlur='javascript:getSecondhandCarAmt_h()' >
					km</td>			                
                <td width="10%" class=title >적용잔가</td>
                <td width="12%">&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        -
							        <input type='hidden' name="opt_per" value="0">
							    <%}else{%>                           	
				              <input type='text' size='6' name='opt_per' class='defaultnum' value='' onBlur="javascript:display_opt()">
        				  %
        				  <%}%>
                    </td>
                <td width="10%" class=title>매입옵션</td>
                <td width="15%">&nbsp;
                	
                  <%if(acar_de.equals("1000")){%>
										<%	if(fee_opt_amt>0){//연장계약시 매입옵션이 있는 경우%>		
											부여
							        <input type='hidden' name="opt_chk" value="1">
										<%	}else{%>
											미부여
							        <input type='hidden' name="opt_chk" value="0">
										<%	}%>
							    <%}else{%>                           	
				              <input type='radio' name="opt_chk" value='0'>
                      미부여
                      <input type='radio' name="opt_chk" value='1'>
        	 		        부여
        				  <%}%>
                </td>
                <td width="10%" class=title >대여료D/C</td>
                <td width="15%">&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        -
							        <input type='hidden' name="fee_dc_per" value="0">
							    <%}else{%>                   	                	
                   대여료의 <input type='text' size='4' name='fee_dc_per' maxlength='4' class='defaultnum' value=''>%
                  <%}%> 
                   </td>
              </tr>		
              <tr> 
                    <td width="13%" class=title >운전자추가요금</td>
                    <td>&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        <%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>원(공급가)
							        <input type='hidden' name="driver_add_amt" value="<%=fee_etcs.getDriver_add_amt()%>">
							    <%}else{%>
					            <input type='text' name='driver_add_amt' size='5' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>' class='defaultnum'>
					            원(공급가)
					        <%}%>
					</td>			                
              	
                <td width="10%" class=title >견적담당자</td>
                <td colspan='5'>&nbsp;
				  <select <%if(!acar_de.equals("1000")){%>name='damdang_id'<%}else{%>name="s_damdang_id" disabled<%}%> class=default>            
                        <option value="">미지정</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); 
        					%>
          			    <option value='<%=user.get("USER_ID")%>' <% if((!acar_de.equals("1000") && base.getBus_id2().equals(user.get("USER_ID"))) || (acar_de.equals("1000") && user_id.equals(user.get("USER_ID")))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>	  
        			        <%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="damdang_id" value="<%=user_id%>">
							        <%}%>
                    </td>                
              </tr>							  	
			  
            </table>
        </td>
    </tr>
    <tr>
        <td>* 적용잔가율=매입옵션율, 미입력시 계산된 최대잔가율을 적용합니다. </td>
    </tr>				
    <tr>
        <td>* 이용기간은 24개월이내에서 견적 가능합니다.</td>
    </tr>				
    <%if(base.getCar_gu().equals("0") && fee_opt_amt == 0){%>
    <tr>
        <td><font color=red>* 매입옵션이 없는 재리스 계약은 연장시 매입옵션을 부여할 수 없습니다.</font></td>
    </tr>
    <%}%>
	<%if(fee_type.equals("fee_im")){
		tr_display_dt = "";
	%>
    <tr>
        <td><font color=red>* 최종 대여가 임의연장입니다. 견적서에 대여개시일을 표시하지 않습니다.</font></td>
    </tr>				
	<%}%>
    <tr>
        <td class=h></td>
    </tr>	
	<!--
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> 대여요금</span></td>
    </tr>
	-->
	    <input type='hidden' name="rent_st" value="<%=fee_size+1%>">
    <tr id=tr_2 style='display:<%=tr_display_dt%>'>
        <td class=line2></td>
    </tr>
    <tr id=tr_3 style='display:<%=tr_display_dt%>'> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="13%" align="center" class=title>계약일자</td>
                    <td width="20%">&nbsp;
					<input type="text" name="rent_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>
                        </td>
                    <td width="10%" align="center" class=title>대여개시일</td>
					<td width="20%">&nbsp;
					<input type="text" name="rent_start_dt" value="" size="11" maxlength='10' class=default onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this); getTotDist_h();'>
                    </td>
					<td width="20%">&nbsp;
                      </td>
                    <td width="10%" align="center" class=title>대여만료일</td>
                    <td>&nbsp;
                    <input type="text" name="rent_end_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>
            </table>
        </td>
    </tr>
    <!--
	<tr></tr>
	<tr></tr>
	-->
    <tr id=tr_4 style='display:<%=tr_display%>'>
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
                    <td align='center'></td>
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
                    <td align='center'></td>
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
                         </td>
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
                    <td align='center'><input type='text' size='11' name='opt_amt' maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">차가의
                        </td>
                    <td align='center'>
        			  
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
                    <td align="center">차가의<input type='text' size='4' name='app_ja' maxlength='10' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        			  % 
        			  </td>
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
                      
					  <input type='hidden' name="bas_dt"		value="">
                    </span></td>
                    <td align='center'>&nbsp;
        			  <span class="b"><a href="javascript:estimate('account')" onMouseOver="window.status=''; return true" title="견적하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>					  
                    </td>
                </tr>
            </table>
	    </td>
    </tr>
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6") || base.getBus_id().equals(ck_acar_id) ) {%>
    <tr> 
      <td align=center><a href="javascript:estimate('account');"><img src=/acar/images/center/button_est.gif border=0 align=absmiddle></a> 
      </td>
    </tr>	
    <%}%>
	
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
		fm.rent_start_dt.value 			= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';				
	}

<%	if(fee_opt_amt>0){//연장계약시 매입옵션이 있는 경우%>		
	fm.fee_opt_amt.value = parseDecimal(<%=fee_opt_amt%>);
	<%if(!acar_de.equals("1000")){%>
	fm.opt_chk[1].checked = true;
	<%}%>
	fm.o_1.value	= parseDecimal(fm.fee_opt_amt.value);		
<%	}else{%>
	<%if(!acar_de.equals("1000")){%>
	fm.opt_chk[0].checked = true;
	<%}%>
<%	}%>
	
	if(fm.udt_st.value == ''){
		if('<%=user_bean.getBr_id()%>'=='S1') fm.udt_st.value = '1';
		if('<%=user_bean.getBr_id()%>'=='B1') fm.udt_st.value = '2';
		if('<%=user_bean.getBr_id()%>'=='D1') fm.udt_st.value = '3';
	}
	
	//디폴트 12개월
	fm.con_mon.value = '12';
	set_cont_date(fm.con_mon); 
	getSecondhandCarAmt_h();
	
	//초과운행
	var fw_917 = getRentTime('l', '<%=fee.getRent_start_dt()%>', '<%=ext_fee.getRent_end_dt()%>');
	
	if ( '<%=taecha_st_dt%>'  != '' )  {
		fw_917 = getRentTime('l', '<%=taecha_st_dt%>', '<%=ext_fee.getRent_end_dt()%>');
	}
	
	fm.o_rent_days.value = fw_917;
	
	fm.o_y_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_agree_dist.value))*fw_917/365);
	
	fm.o_b_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_y_agree_dist.value))+toInt(parseDigit(fm.o_over_bas_km.value))+1000);
	
	fm.o_over_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_sh_km.value))-toInt(parseDigit(fm.o_b_agree_dist.value)));
	if(toInt(parseDigit(fm.o_over_agree_dist.value)) <=0){
		fm.o_over_agree_dist_nm.value = '한도내';
	}
	if(toInt(parseDigit(fm.o_over_agree_dist.value)) >0){
		fm.o_over_agree_dist_nm.value = '한도초과';
	}
		
		
	//일수 구하기
	function getRentTime(gubun, d1, d2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var rent_time = "";
		var t1;
		var t2;
		var t3;		
		t1 = getDateFromString(replaceString('-','',d1)).getTime();
		t2 = getDateFromString(replaceString('-','',d2)).getTime();
		t3 = t2 - t1;			
		if(gubun=='m') return parseInt(t3/m);
		if(gubun=='l') return parseInt(t3/l);
		if(gubun=='lh') return parseInt(t3/lh);
		if(gubun=='lm') return parseInt(t3/lm);		
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}			
	
//-->
</script>
</body>
</html>

