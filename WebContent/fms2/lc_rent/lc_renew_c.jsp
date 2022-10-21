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
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="ai_db2" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "10");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String fee_start_dt = "";
	String ext_fee_start_dt = "";
	String im_fee_start_dt = "";
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	//if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
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
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	ext_fee_start_dt = rs_db.addDay(ext_fee.getRent_end_dt(), 1);
	fee_start_dt = ext_fee_start_dt;
	
	//임의연장
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	int im_vt_size = im_vt.size();
	String im_end_dt = "";
	for(int i = 0 ; i < im_vt_size ; i++){
  	Hashtable im_ht = (Hashtable)im_vt.elementAt(i);
  	im_end_dt = String.valueOf(im_ht.get("RENT_END_DT"));
  }
  if(im_vt_size >0 && AddUtil.parseInt(ext_fee.getRent_end_dt()) < AddUtil.parseInt(im_end_dt)){
  	im_fee_start_dt = rs_db.addDay(im_end_dt, 1);
  	fee_start_dt = im_fee_start_dt;
  }
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//fee_etc
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//차량이용자
	CarMgrBean mgr1 = a_db.getCarMgr(rent_mng_id, rent_l_cd, "차량이용자");
	
	
	//4. 변수----------------------------
	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
		
	String a_e = cm_bean.getS_st();
	
	
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
		if(chk >0){
			ht2.put("SECONDHAND_DT", fee_start_dt);
			//sh_base table update
			int count = shDb.updateShBase(ht2);
		}
	}
	//차량정보
	sh_ht = shDb.getShBase(base.getCar_mng_id());
		
	int fee_opt_amt = 0;
	
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
	
	//20211126 여유분 1개월 더 줌 (생산일 기준으로하면 더 줘야 함) - 김광수팀장요청
	car_end_dt_max = c_db.addMonth(car_end_dt_max, -1);
	
	
	//고객피보험자 보험 최종계약종료일과 최종보험 만료일이 같은경우 보험등록이 먼저 되어야 한다.
	String ins_cust_chk = "";
	
	if(!ins.getCon_f_nm().equals("아마존카") && ins.getIns_exp_dt().equals(ext_fee.getRent_end_dt())){
		ins_cust_chk = "Y";	
	}
	
	//신용등급 없는 경우 처리
	if(base.getSpr_kd().equals("")){
   if(base.getCar_gu().equals("0")) base.setSpr_kd("1"); //재리스-우량기업
   if(base.getCar_gu().equals("1")) base.setSpr_kd("2"); //신차-초우량기업
  }
	if(cont_etc.getDec_gr().equals("")){
   if(base.getCar_gu().equals("0")) cont_etc.setDec_gr("1"); //재리스-우량기업
   if(base.getCar_gu().equals("1")) cont_etc.setDec_gr("2"); //신차-초우량기업
  }  
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

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
	
	function cng_stat_dt_input(){
		var fm = document.form1;
		<%if(im_vt_size >0 && AddUtil.parseInt(ext_fee.getRent_end_dt()) < AddUtil.parseInt(im_end_dt)){%>
				if(fm.start_dt_st[0].checked == true){
					fm.bas_dt.value 				= '<%= AddUtil.ChangeDate2(ext_fee_start_dt) %>';
					fm.rent_start_dt.value 	= '<%= AddUtil.ChangeDate2(ext_fee_start_dt) %>';		
					fm.sh_day_bas_dt.value 	= '<%= AddUtil.ChangeDate2(ext_fee_start_dt) %>';
				}else{
					fm.bas_dt.value 				= '<%= AddUtil.ChangeDate2(im_fee_start_dt) %>';
					fm.rent_start_dt.value 	= '<%= AddUtil.ChangeDate2(im_fee_start_dt) %>';	
					fm.sh_day_bas_dt.value 	= '<%= AddUtil.ChangeDate2(im_fee_start_dt) %>';	
				}
				
				set_cont_date(fm.con_mon);
		<%}%>
	}
	
	//대여기간 셋팅
	function set_cont_date(obj){
		var fm = document.form1;
		var rent_way = fm.rent_way.value;
		
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;
		
		<%if(im_vt_size >0 && AddUtil.parseInt(ext_fee.getRent_end_dt()) < AddUtil.parseInt(im_end_dt)){%>
			if(fm.start_dt_st[0].checked == false && fm.start_dt_st[1].checked == false){
				alert('임의연장기간 포함 여부를 선택하십시오.'); 
				fm.con_mon.value = '';
				fm.rent_start_dt.value = '';
				fm.start_dt_st[0].focus();
				return;	
			}
		<%}%>

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
		
		if(obj == fm.con_mon){
			getSecondhandCarAmt_h();
		}
		
	
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
		
		var f_car_price = car_price;
					
		car_price 	= toInt(parseDigit(fm.sh_amt.value));
		
		<%if(ext_fee.getOpt_s_amt()>0){%>
		car_price	= <%=ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt()%>;		
		<%}%>
						
		//보증금---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//보증금 공급가
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value 	= fm.grt_s_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / car_price * 100, 1);
				fm.f_gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / f_car_price * 100, 1);
			}
			sum_pp_amt();			
		}else if(obj==fm.grt_amt){ 		//보증금 합계
			obj.value = parseDecimal(obj.value);
			fm.grt_s_amt.value 	= fm.grt_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / car_price * 100, 1);
				fm.f_gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / f_car_price * 100, 1);				
			}
			sum_pp_amt();		
		//선납금---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt){ 	//선납금 공급가
			obj.value = parseDecimal(obj.value);
			fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
				fm.f_pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / f_car_price * 100, 1);
			}
			sum_pp_amt();			
		}else if(obj==fm.pp_v_amt){ 	//선납금 부가세
			obj.value = parseDecimal(obj.value);
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
				fm.f_pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / f_car_price * 100, 1);
			}		
			sum_pp_amt();	
		}else if(obj==fm.pp_amt){ 		//선납금 합계
			obj.value = parseDecimal(obj.value);
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));			
					
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
				fm.f_pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / f_car_price * 100, 1);
			}			
			sum_pp_amt();
		//개시대여료---------------------------------------------------------------------------------			
		}else if(obj==fm.ifee_s_amt){ 	//개시대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.ifee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) * 0.1 );
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
			sum_pp_amt();
		}else if(obj==fm.ifee_v_amt){ 	//개시대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
			sum_pp_amt();					
		}else if(obj==fm.ifee_amt){ 	//개시대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
			fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));			
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));	
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);			
			sum_pp_amt();		
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
				fm.f_opt_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / f_car_price * 100, 1);
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
				fm.f_opt_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / f_car_price * 100, 1);
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
		//계약대여료---------------------------------------------------------------------------------
		}else if(obj==fm.fee_s_amt){ 	//계약대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1 );
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
			//if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			//}
		}else if(obj==fm.fee_v_amt){ 	//계약대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.fee_amt.value		= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.fee_amt){ 		//계약대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));			
			dc_fee_amt();
			//if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			//}
		//원보험대여료---------------------------------------------------------------------------------
		}else if(obj==fm.ins_s_amt){ 	//원보험대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.ins_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) * 0.1 );
			fm.ins_amt.value	= parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)));			
			

			
			dc_fee_amt();
			setTinv_amt();
	 	}else if(obj==fm.ins_v_amt){ 
	 		//원보험대여료 부가세
	 		obj.value = parseDecimal(obj.value);
			fm.ins_amt.value = parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)));	
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.ins_amt){ 		//원보험대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.ins_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_amt.value))));
			fm.ins_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_amt.value)) - toInt(parseDigit(fm.ins_s_amt.value)));	
			dc_fee_amt();
			setTinv_amt();
			/* if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)); 
			} */
		//총보험료---------------------------------------------------------------------------------
		}else if(obj==fm.ins_total_amt){
			obj.value = parseDecimal(obj.value);
			fm.ins_total_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_total_amt.value)));
		//규정대여료---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//규정대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.inv_v_amt){ 	//규정대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value		= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.inv_amt){ 		//규정대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
			
		//운전자 추가요금(2018.03.30)-------------------------------------------------------------------	
		}else if(obj==fm.driver_add_amt){	//운전자추가요금 공급가
			obj.value = parseDecimal(obj.value);
			fm.driver_add_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) * 0.1 );
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.driver_add_v_amt){ 	//운전자추가요금 부가세
			obj.value = parseDecimal(obj.value);
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.driver_add_total_amt){ //운전자추가요금 합계			
			obj.value = parseDecimal(obj.value);
			fm.driver_add_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.driver_add_total_amt.value))));
			fm.driver_add_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.driver_add_total_amt.value)) - toInt(parseDigit(fm.driver_add_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}
		
	}
	
	//정상요금합계 구하기
	function setTinv_amt(){
		fm.tinv_s_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.driver_add_amt.value)));
		fm.tinv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));
		fm.tinv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) + toInt(parseDigit(fm.ins_amt.value)) + toInt(parseDigit(fm.driver_add_total_amt.value)));
	}
	
	//선수금 합계
	function sum_pp_amt(){
		var fm = document.form1;
		
		fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		
		
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
		var pp_price 	= toInt(parseDigit(fm.tot_pp_amt.value)) + toInt(parseDigit(fm.gi_amt.value));
		fm.credit_r_per.value = parseFloatCipher3(pp_price / car_price * 100, 1);
		fm.credit_r_amt.value = parseDecimal(pp_price);
	}
	
	//대여료 DC율 계산
	function dc_fee_amt(){
		var fm = document.form1;
		
		var pp_s_amt	= toInt(parseDigit(fm.pp_s_amt.value));		//선납금
		var fee_s_amt	= toInt(parseDigit(fm.fee_s_amt.value));	//월대여료(적용)
		var inv_s_amt	= toInt(parseDigit(fm.inv_s_amt.value));	//정상대여료(견적)
		var con_mon		= toInt(parseDigit(fm.con_mon.value));		//대여기간 
		var dc_ra;
		
		//정상요금에서 계산함.
		if(<%=base.getRent_dt()%> < 20150512){		
			if(inv_s_amt > 0){
				dc_ra = (1 - (pp_s_amt+fee_s_amt*con_mon)/(pp_s_amt+inv_s_amt*con_mon))*100;
				fm.dc_ra.value = parseFloatCipher3(dc_ra,1);
			}
		}
	}	
	
	//잔존가치율 셋팅
	function set_janga(){
		var fm = document.form1;	
		
		if(fm.rent_dt.value == ''){	alert('계약일자를 입력하십시오.'); return;}
		if(fm.con_mon.value == ''){	alert('이용기간을 입력하십시오.'); return;}		
		
		var fm2 = document.sh_form;	
		fm2.rent_dt.value 		= fm.rent_start_dt.value;
		fm2.a_b.value 			= fm.con_mon.value;
		fm2.fee_opt_amt.value 	= fm.fee_opt_amt.value;
		fm2.action='/acar/secondhand/getSecondhandJanga.jsp';
		fm2.target='i_no2';
		fm2.submit();			
	}	
	
	//규정대여료 계산 (견적)
	function estimate(st){
		var fm = document.form1;
		set_fee_amt(fm.opt_amt);
		if(fm.rent_dt.value == '')		{ alert('연장계약일자를 입력하십시오.'); 	return; }
		if(fm.car_mng_id.value == '')	{ alert('챠랑이 선택되지 않았습니다. 확인하십시오.'); 	return; }		
		
		if(fm.insurant.value == '1' && fm.insur_per.value == '2'){
			if(fm.ins_s_amt.value == '0' || fm.ins_s_amt.value =='' ) {confirm('원보험료를 입력하지 않았습니다. 계속 진행하시겠습니까?');		return; };
			if(fm.ins_v_amt.value == '0' || fm.ins_v_amt.value =='') {confirm('원보험료를 입력하지 않았습니다. 계속 진행하시겠습니까?');		return; };
		}
		
		//20150626 리스기본식만 보험계약자 고객 선택가능, 보험계약자가 고객이면 피보험자도 고객이여야 한다.			
		if('<%=base.getCar_st()%><%=ext_fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('보험계약자 고객이면 피보험자도 고객이여야 합니다.');
				return;					
			}
		}else{
			//if(fm.insurant.value == '2'){
			//	alert('보험계약자 고객은 리스기본식만 가능합니다.');
			//	return;
			//}			
		}			
		
		fm.o_13.value 		= fm.app_ja.value;
		fm.o_13_amt.value 	= fm.ja_r_amt.value;
		
		fm.ro_13.value 		= fm.max_ja.value;
		
		fm.grt_amt.value 	= fm.grt_s_amt.value;
		
		<%if(ext_fee.getOpt_s_amt()>0){%>
		fm.o_1.value	= <%=ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt()%>;		
		<%}else{%>
		fm.o_1.value	= fm.sh_amt.value;
		<%}%>

		fm.esti_stat.value 	= st;
		
		fm.fee_rent_dt.value = replaceString("-","",fm.rent_start_dt.value);
		
		
		//중고차가격 재계산
		fm.sh_day_bas_dt.value = replaceString("-","",fm.rent_start_dt.value);		
		getSecondhandCarAmt_h();
		
		set_fee_amt(fm.grt_s_amt);
		

		fm.ro_13.value 		= fm.opt_per.value;
		fm.o_13_amt.value 	= fm.opt_amt.value;
		fm.o_13.value 		= 0;	
		fm.action='get_fee_estimate_20090901.jsp';	
		
		
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}

		fm.submit();

	}
	

	//등록
	function save(idx){
		var fm = document.form1;
		
			if(toInt(parseDigit(fm.grt_s_amt.value))>0){
				set_fee_amt(fm.grt_s_amt);
			}
			
			if(fm.con_mon.value == '')				{ alert('대여요금-이용기간을 입력하십시오.'); 					fm.con_mon.focus(); 		return; }
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
		
			if(fm.driving_age.value == '')			{ alert('보험사항-운전자연령을 입력하십시오.'); 			fm.driving_age.focus(); 	return; }
			if(fm.gcp_kd.value == '')				{ alert('보험사항-대물배상 가입금액을 입력하십시오.'); 		fm.gcp_kd.focus(); 			return; }
			if(fm.bacdt_kd.value == '')				{ alert('보험사항-자기신체사고 가입금액을 입력하십시오.'); 	fm.bacdt_kd.focus(); 		return; }
			
			<%if((base.getCar_st().equals("5") || client.getClient_st().equals("1")) && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	 
				if(fm.com_emp_yn.value == '')			{ alert('보험사항-임직원운전한정특약 가입여부를 입력하십시오.');	fm.com_emp_yn.focus(); 		return; }
			<%}else if(AddUtil.parseInt(client.getClient_st()) >2 && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>
				//개인사업자 업무전용차량 제한없음
				if(fm.com_emp_yn.value == '')			{ alert('보험사항-임직원운전한정특약 가입여부를 입력하십시오.');	fm.com_emp_yn.focus(); 		return; }
			<%}else{%>
				if(fm.com_emp_yn.value == 'Y')			{ alert('보험사항-임직원운전한정특약 가입대상이 아닌데 가입으로 되어 있습니다. 확인하십시오.');	fm.com_emp_yn.focus(); 	return; }
			<%}%>
			
		
			if(fm.driving_age.value=='1' && fm.age_scp.value!='1'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}
			if(fm.driving_age.value=='3' && fm.age_scp.value!='4'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}
			if(fm.driving_age.value=='0' && fm.age_scp.value!='2'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}
			if(fm.driving_age.value=='2' && fm.age_scp.value!='3'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}
			if(fm.driving_age.value=='5' && fm.age_scp.value!='5'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}			
			if(fm.driving_age.value=='6' && fm.age_scp.value!='6'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}			
			if(fm.driving_age.value=='7' && fm.age_scp.value!='7'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}			
			if(fm.driving_age.value=='8' && fm.age_scp.value!='8'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}												
			
			if(fm.gcp_kd.value=='2' && fm.vins_gcp_kd.value!='3'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'대물보상 ';		}
			if(fm.gcp_kd.value=='1' && fm.vins_gcp_kd.value!='4'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'대물보상 ';		}
			if(fm.gcp_kd.value=='3' && fm.vins_gcp_kd.value!='6'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'대물보상 ';		}
			if(fm.gcp_kd.value=='4' && fm.vins_gcp_kd.value!='7'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'대물보상 ';		}			
			
			if(fm.bacdt_kd.value=='2' && fm.vins_bacdt_kd.value!='6'){	alert('보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk3.value =	'자기신체사고 ';	}
			if(fm.bacdt_kd.value=='1' && fm.vins_bacdt_kd.value!='5'){	alert('보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk3.value =	'자기신체사고 ';	}
			if(fm.bacdt_kd.value=='9' && fm.vins_bacdt_kd.value!='9'){	alert('보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk3.value =	'자기신체사고 ';	}
		
			
			if(fm.con_mon.value == '')				{ alert('대여요금-이용기간을 입력하십시오.'); 					fm.con_mon.focus(); 		return; }
			if(fm.ext_agnt.value == '')				{ alert('대여요금-계약담당자를 입력하십시오.'); 					fm.ext_agnt.focus(); 		return; }
			if(fm.rent_end_dt.value == '')		{ alert('대여요금-계약만료일을 입력하십시오.'); 					fm.rent_end_dt.focus(); 		return; }
			
			if(fm.ext_agnt.value.substring(0,1) == '1')		{ alert('계약담당자가 부서로 선택되었습니다. 확인해주세요.'); return; }		
			
			
			
			if(toInt(parseDigit(fm.fee_amt.value))>0){
			
				if(fm.app_ja.value == '')				{ alert('대여요금-적용잔가율을 입력하십시오.'); 			fm.app_ja.focus(); 			return; }
				var ja_amt = toInt(parseDigit(fm.ja_amt.value));
				if(ja_amt == 0)							{ alert('대여요금-잔존가치금액을 입력하십시오.'); 			fm.ja_amt.focus(); 			return; }
				//if(fm.opt_chk.value == '')				{ alert('대여요금-매입옵션 여부를 입력하십시오.'); 			fm.opt_chk.focus(); 		return; }				
				//if(fm.opt_chk.value == '1'){
				if(fm.opt_chk[0].checked == false && fm.opt_chk[1].checked == false)				{ alert('대여요금-매입옵션 여부를 입력하십시오.'); 			fm.opt_chk.focus(); 		return; }
				if(fm.opt_chk[1].checked == true){
					if(fm.opt_per.value == '')			{ alert('대여요금-매입옵션율를 입력하십시오.'); 			fm.opt_per.focus(); 		return; }
					var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
					if(opt_amt == 0)					{ alert('대여요금-매입옵션금액을 입력하십시오.'); 			fm.opt_amt.focus(); 		return; }
				}
				if(fm.opt_chk[0].checked == true){
					var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
					if(opt_amt > 0)						{ alert('대여요금-매입옵션없음으로 되어 있으나 매입옵션금액이 있습니다. 확인하십시오.');	fm.opt_amt.focus(); 		return; }
					//fm.opt_s_amt.value = 0;
					//fm.opt_v_amt.value = 0;
					//fm.opt_amt.value = 0;
					//fm.opt_per.value = 0;
				}
				if(fm.cls_r_per.value == '')			{ alert('대여요금-중도해지위약율 입력하십시오.'); 			fm.cls_r_per.focus(); 		return; }
				var fee_amt = toInt(parseDigit(fm.fee_amt.value));
				var inv_amt = toInt(parseDigit(fm.inv_amt.value));
				if(inv_amt == 0)						{ alert('대여요금-대여료 규정금액을 입력하십시오.'); 		fm.inv_amt.focus(); 		return; }
				if(fm.fee_sac_id.value == '')			{ alert('대여요금-요금 결재자를 입력하십시오.'); 			fm.fee_sac_id.focus(); 		return; }
				if(fm.fee_pay_tm.value == '')			{ alert('대여요금-납입횟수를 입력하십시오.'); 				fm.fee_pay_tm.focus(); 		return; }
				
				if(fm.fee_est_day.value == '')			{ alert('대여요금-납입일자를 입력하십시오.'); 				fm.fee_est_day.focus(); 	return; }
			}
			//연장숭계관련
			var grt_amt = toInt(parseDigit(fm.grt_s_amt.value));
			var ifee_amt = toInt(parseDigit(fm.ifee_amt.value));
		
			if (grt_amt > 0 ) {
				if(fm.grt_suc_yn.value == '')			{ alert('보증금-정상조건을 선택하십시오.'); 			fm.grt_suc_yn.focus(); 		return; }
				//직전계약의 보증금이 없다면 별도 20180711
				if(toInt(parseDigit(fm.ext_grt_amt.value))==0)				{ fm.grt_suc_yn.value = '1'; }
				//직전계약의 보증금과 연장계약의 보증금이 같다면 승계 20180711
				if(grt_amt == toInt(parseDigit(fm.ext_grt_amt.value))){ fm.grt_suc_yn.value = '0'; }
			}else{
				if(fm.grt_suc_yn.value != '')			{ fm.grt_suc_yn.value = '' }
			}
			
			if (ifee_amt > 0 ) {
				if(fm.ifee_suc_yn.value == '')			{ alert('개시대여료-정상조건을 선택하십시오.'); 		fm.ifee_suc_yn.focus(); 	return; }
			}		
			
			//영업용차량일 경우 차령만료일 체크해서 연장만료일자 경과를 할 경우 등록이 안되도록 한다.
			<%if(!ck_acar_id.equals("000029") && !ck_acar_id.equals("000026") && cr_bean.getCar_use().equals("1")){%>
			if(toInt(replaceString('-','','<%=car_end_dt_max%>')) < toInt(replaceString('-','',fm.rent_end_dt.value)) ){
				alert('대여기간 만료일이 차령만료일보다 큽니다. 확인하십시오.'); 						fm.rent_end_dt.focus(); 	return;
			}
			<%}%>
			
			<%if(client.getClient_st().equals("2") || client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")){%>
				
				if(fm.lic_no.value == '' && fm.mgr_lic_no.value == ''){
					alert('개인,개인사업자는 운전면허번호를 입력하십시오.');
					return;
				}
				if(fm.lic_no.value != '' && fm.lic_no.value.length < 12){
					alert('계약자 운전면허번호를 정확히 입력하십시오.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_no.value.length < 12){
					alert('차량이용자 운전면허번호를 정확히 입력하십시오.');
					return;
				}			
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_emp.value == ''){
					alert('차량이용자 운전면허번호 이름을 입력하십시오.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_rel.value == ''){
					alert('차량이용자 운전면허번호 관계를 입력하십시오.');
					return;
				}
    	<%}%>
    	
    	
    	if(fm.gi_st[0].checked == false && fm.gi_st[1].checked == false){	
    		alert('보증보험 가입여부를 선택하십시오.'); fm.gi_st[0].focus(); return; 
    	}
			
		if(toInt(parseDigit(fm.grt_s_amt.value))==0 && fm.gi_st[1].checked == true){
			if(!confirm('보증금이 없고 보증보험 면제로 되어 있습니다. 연장 등록을 진행하시겠습니까?')){	return;	}	
		}			
	
		
		if(confirm('등록하시겠습니까?')){	
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action='lc_renew_c_a.jsp';		
			fm.target='i_no';
//			fm.target='d_content';
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
		}else if(st == 'ifee'){
			if(fm.ifee_suc_yn.value == '0'){
				fm.ifee_s_amt.value = '<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt())%>';
				fm.ifee_v_amt.value = '<%=AddUtil.parseDecimal(ext_fee.getIfee_v_amt())%>';
				fm.ifee_amt.value   = '<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>';
				set_fee_amt(fm.ifee_s_amt);
			}
		}		
	}
	//대여요금
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=100, top=100, width=850, height=650, scrollbars=yes");
	}		
	//차량가격
	function view_car_amt(rent_mng_id, rent_l_cd)
	{		
		window.open("/fms2/lc_rent/view_car_amt.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&cmd=view", "VIEW_CAR_AMT", "left=100, top=100, width=850, height=450, scrollbars=yes");
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
		
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "i_no2";
//		fm.target = "_blank";
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
				
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "_blank";
		fm.submit();
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
<form action='lc_b_u_a.jsp' name="form1" method='post'>
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
  <input type='hidden' name="firm_nm"				value="<%=client.getFirm_nm()%>">    
  <input type='hidden' name='client_st' 		value='<%=client.getClient_st()%>'>              
  <input type='hidden' name="fee_rent_st"		value="<%=fee_size+1%>">      
  <input type='hidden' name="fee_rent_dt"		value="">              
  <input type='hidden' name="ext_fee_start_dt"	value="<%=ext_fee_start_dt%>">              
  <input type='hidden' name="im_fee_start_dt"	value="<%=im_fee_start_dt%>">              
  <input type='hidden' name="im_end_dt"			value="<%=im_end_dt%>">                
  <!-- 2018.04.02 추가 -->
  <input type="hidden" name="e_rtn_run_amt"	value="">
  <input type="hidden" name="e_rtn_run_amt_yn"	value="">
  <input type="hidden" name="e_over_run_amt"	value="">
  <input type="hidden" name="e_agree_dist"		value="">
  <input type="hidden" name="r_agree_dist"		value="">
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
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
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
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
	    <td class=h></td>
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
        					Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>
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
    <%		if(ins_cust_chk.equals("Y")){%>
    <tr>
        <td><font color=red>* 고객이 피보험자인 계약건의 연장은 사전에 보험갱신이 먼저 이루어지고 나서 연장등록 및 결재요청을 할 수 있습니다.</font></td>
    </tr>    
	<tr>
	    <td class=h></td>
	</tr>    
    <%		}%>    	

    <%if(im_vt_size >0 && AddUtil.parseInt(ext_fee.getRent_end_dt()) < AddUtil.parseInt(im_end_dt)){%>
    <tr>
        <td><font color=red>* 임의연장이 있습니다. 임의연장기간 포함여부를 선택하여 입력하십시오. 대여기간이 맞는지 확인해주세요.</font></td>
    </tr>    
	<tr>
	    <td class=h></td>
	</tr>    
    <%		}%>       

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
        				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("CAR_AMT"))+AddUtil.parseInt((String)sh_ht.get("OPT_AMT"))+AddUtil.parseInt((String)sh_ht.get("COL_AMT")))%>' size='10' class='defaultnum' readonly>
        				  원&nbsp;<font size='7' color='#999999'><a href="javascript:view_car_amt('<%=rent_mng_id%>','<%=rent_l_cd%>')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></font></td>
                    <td class='title' width="10%">잔가율</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='sh_ja' value=''size='4' class='defaultnum' readonly>
%</td>
                    <td class='title' width='10%'>중고차가</td>
                    <td>&nbsp;
                      <input type='text' name='sh_amt' value=''size='10' class='defaultnum' readonly>
원
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
                    일 (<input type='text' name='sh_init_reg_dt' value='<%=cr_bean.getInit_reg_dt()%>' size='11' class='white' readonly> ~
                    <input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(fee_start_dt)%>' size='11' class='white' readonly>
                  )</td>
                </tr>
                <tr>
                  <td class='title'>적용주행거리</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TODAY_DIST")) %>' class='defaultnum' >
km
/ 확인주행거리 <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TOT_DIST")) %>' class='defaultnum' >
km(
<input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2((String)sh_ht.get("SERV_DT")) %>' class='default' >
)</td>
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
                <%if(im_vt_size >0 && AddUtil.parseInt(ext_fee.getRent_end_dt()) < AddUtil.parseInt(im_end_dt)){%>
                <tr>
                    <td width="13%" align="center" class=title>임의연장기간포함여부</td>
                    <td colspan='5'>&nbsp;
                    	<input type='radio' name="start_dt_st" value='1' onClick="javascript:cng_stat_dt_input()">
                  		미포함
                  		<input type='radio' name="start_dt_st" value='2' onClick="javascript:cng_stat_dt_input()">
                  		포함
                        </td>
                </tr>     
                <%}%>                
                <tr>
                    <td width="13%" align="center" class=title>이용기간</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="con_mon" value='' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this); '>
            			 개월</td>
                    <td width="13%" align="center" class=title>관리구분</td>
                    <td colspan='3'>&nbsp;
                    	  <select name="rent_way">                            
                            <option value='1' <%if(ext_fee.getRent_way().equals("1")){%>selected<%}%>>일반식</option>                            
                            <option value='3' <%if(ext_fee.getRent_way().equals("3")){%>selected<%}%>>기본식</option>
                        </select>
            			  </td>
                </tr>

                <tr>
                    <td width="13%" align="center" class=title>대여개시일</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="rent_start_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);'></td>
                    <td width="10%" align="center" class=title>대여만료일</td>
                    <td colspan='3'>&nbsp;
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
                    <td colspan="3" class='title'>구분</td>
                    <td class='title' width='13%'>공급가</td>
                    <td class='title' width='13%'>부가세</td>
                    <td class='title' width='13%'>합계</td>
                    <td class='title' width="28%">계약조건</td>
                    <td class='title' width='20%'>정상조건</td>
                </tr>
                <tr>
                    <td width="3%" rowspan="5" class='title'>선<br>
                      수</td>
                    <td width="10%" class='title' colspan="2">보증금</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='11' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_gur_p_per' class='fixnum' value='' readonly>
    				            %  
        				    </td>
                    <td align='center'>
        			    <input type='hidden' name='gur_per' value=''>
        				<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>'>
        				<input type='hidden' name='ext_grt_amt' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>'>
        				<select name='grt_suc_yn' onChange="javascript:display_suc('grt')">
                              <option value=""  <%if(ext_fee.getGrt_amt_s()==0)%>selected<%%>>선택</option>
                              <option value="0" <%if(ext_fee.getGrt_amt_s()> 0)%>selected<%%>>승계</option>
                              <option value="1">별도</option>
                            </select>				
                            (승계여부를 승계로 하면 기존 보증금 스케줄을 연동시키고, 별도를 선택하면 신규 스케줄이 생성됩니다.)
        				</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">선납금</td>
                    <td align="center"><input type='text' size='11' name='pp_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='11' name='pp_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='11' name='pp_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='pere_r_per' class='fixnum' value='' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_pere_r_per' class='fixnum' value='' readonly>
    				            %  
        				    </td>
        				  
                    <td align='center'>-<input type='hidden' name='pere_per' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">개시대여료</td>
                    <td align="center"><input type='text' size='11' name='ifee_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='11' name='ifee_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='11' name='ifee_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">마지막
                        <input type='text' size='2' name='pere_r_mth' class='fixnum' value='' readonly>
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
                    <td class='title' colspan="2">합계</td>
                    <td align="center"><input type='text' size='11' name='tot_pp_s_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='11' name='tot_pp_v_amt' maxlength='10' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='11' name='tot_pp_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">입금예정일 :
                          <input type='text' size='11' name='pp_est_dt' maxlength='10' class="text" value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align='center'>&nbsp;</td>
                </tr>
                <tr>
        			<td class='title' colspan="2">총채권확보</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>						
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='' readonly>%
        			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='fixnum' value='' readonly>원(보증보험포함)</td>
                    <td align='center'>
        			<input type='hidden' name="credit_per"			value="">
        			<input type='hidden' name="credit_amt"			value="">
        			</td>
                </tr>
                <tr>
                    <td rowspan="3" class='title'>잔<br>
                      가</td>
                    <td class='title' colspan="2">최대잔가</td>
                    <td align="center"><input type='text' size='11' name='ja_s_amt' readonly maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='11' name='ja_v_amt' readonly maxlength='10' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='11' name='ja_amt' readonly maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='max_ja' maxlength='10' readonly class='fixnum' value='' readonly>
        			  % </td>
                    <td align='center'>
					<%	if(AddUtil.parseInt(fee_start_dt) < 20090924){%>		
    			    <span class="b"><a href="javascript:set_janga()" onMouseOver="window.status=''; return true" title="최대잔가율 계산하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
					<%	}else{%>
					<span class="b">정상요금 계산에 포함되어있습니다. </span>
					<%	}%>
					</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">매입옵션</td>
                    <td align="center"><input type='text' size='11' name='opt_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='11' name='opt_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='11' name='opt_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='opt_per' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				        % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_opt_per' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				            % 
        				    </td>
                    <td align='center'>
        			  <input type='radio' name="opt_chk" value='0' <%if(ext_fee.getOpt_chk().equals("0")){%> checked <%}%>>
                      없음
                      <input type='radio' name="opt_chk" value='1' <%if(ext_fee.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		  있음
                    </td>
                </tr>
                <tr>
                    <td class='title' colspan="2">적용잔가</td>
                    <td align="center"><input type='text' size='11' name='ja_r_s_amt' readonly maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center"><input type='text' size='11' name='ja_r_v_amt' readonly maxlength='10' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'><input type='text' size='11' name='ja_r_amt' readonly maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='app_ja' maxlength='10' readonly class="defaultnum" value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <tr>
                    <td rowspan="5" class='title'>대<br>여<br>료</td>
                    <td class='title' colspan="2">계약요금</td>
                    <td align="center" ><input type='text' size='11'  name='fee_s_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='11'  name='fee_v_amt' maxlength='9' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='11'  name='fee_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">DC율:
                      <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value=''>
                      <input type="hidden" name="dc_ra_amt" value="0">
                    </font>%</span></td>
                    <td align='center'>-</td>
                </tr>
                <!-- 운전자추가요금/월보험료(고객피보험) 적용 (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">정<br>상<br>대<br>여<br>료</td>
                    <td class='title'>정상요금</td>
                    <td align="center" ><input type='text' size='11' name='inv_s_amt' readonly maxlength='10' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='11' name='inv_v_amt' readonly maxlength='9' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='11' maxlength='10' readonly name='inv_amt' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">기준일자<span class="contents1_1">
                      <input type='text' size='11' name='bas_dt' maxlength='10' readonly class="fix" value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </span></td>
                    <td align='center'>&nbsp;
                                  <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
        			  <span class="b"><a href="javascript:estimate('account')" onMouseOver="window.status=''; return true" title="견적하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
        			  <%}%>
					  <!--
        			  &nbsp;&nbsp;
        			  <span class="b"><a href="javascript:estimate('view')" onMouseOver="window.status=''; return true" title="견적계산식 보기"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
					  -->
                    </td>
                </tr>
                <tr>
                    <td class='title'>월보험료(고객피보험)</td>
                    <td align="center" ><input type='text' size='11' name='ins_s_amt'  maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='11' name='ins_v_amt'  maxlength='9' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='11' maxlength='10'  name='ins_amt' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">&nbsp;월보험료(공급가) = 년간보험료
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 원/12</td>
                    <td align='center'></td>
                </tr>
                <tr>
	                <td class='title'>운전자추가요금</td>
	                <td align="center" >
	                	<input type='text' size='11' name='driver_add_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원 
	                </td>
	                <td align="center" >
	                	<input type='text' size='11' name='driver_add_v_amt'  maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
	                </td>
	                <td align='center' >
	                	<input type='text' size='11' maxlength='10'  name='driver_add_total_amt' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
	                </td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	            </tr>
                <tr>
                    <td class='title'>정상요금 합계</td>
                    <td align="center" >
                    	<input type='text' size='11' name='tinv_s_amt' maxlength='11' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(ext_fee.getInv_s_amt() + ext_fee.getIns_s_amt() + fee_etc.getDriver_add_amt())%>'> 원 
                    </td>
                    <td align="center" >
                       	<input type='text' size='11' name='tinv_v_amt'  maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(ext_fee.getInv_v_amt() + ext_fee.getIns_v_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center' >
                    	<input type='text' size='11' maxlength='10'  name='tinv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(ext_fee.getInv_s_amt() + ext_fee.getInv_v_amt() + ext_fee.getIns_s_amt() + ext_fee.getIns_v_amt() + fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>
                
                <tr>
                    <td colspan="3" class='title'>영업대리인실적</td>
                    <td colspan="2" align="center">-</td>
        			<td align='center'>-</td>
                    <td align="center">
                        <input type='text' size='3' name='bus_agnt_r_per' maxlength='10'  class='defaultnum' value=''>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='bus_agnt_per' maxlength='10' class='defaultnum' value=''>%</font></span></td>
                </tr>		  
                <%
                	//20140101 위약율 20% 고정
                	ext_fee.setCls_per("20");
                %>
                <tr>
                    <td class='title' colspan="3">중도해지위약율</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align="center">잔여기간 대여료의
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=ext_fee.getCls_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='20'>%
						,필요위약금율[<input type='text' size='3' name='cls_n_per' maxlength='10' class='fixnum' value=''>%]
						</font></span></td>
                </tr>
                <%-- <tr>
                    <td colspan="3" class='title'>운전자추가요금</td>
                    <td colspan="5">&nbsp;
                    	<input type='text' size='10' name='driver_add_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt())%>'>
        				  원 (공급가)</td>                  
                </tr> --%>                  
                				<input type='hidden' name='agree_dist' 			value='<%=fee_etc.getAgree_dist()%>'>
                				<input type='hidden' name='rtn_run_amt' 		value='<%=fee_etc.getRtn_run_amt()%>'>
                				<input type='hidden' name='rtn_run_amt_yn' 		value='<%=fee_etc.getRtn_run_amt_yn()%>'>
								<input type='hidden' name='over_run_amt' 		value='<%=fee_etc.getOver_run_amt()%>'>
								<input type='hidden' name='agree_dist_yn' 	value='<%=fee_etc.getAgree_dist_yn()%>'>								
                <tr>
                    <td colspan="3" class='title'>중도해지</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align="center">위약면제기간 : 
        				<input type='text' size='3' name='cls_n_mon' maxlength='10'  class='defaultnum' value=''>
        				  개월</td>
                    <td align='center'>-</td>				  
                </tr>		  		  
                <tr>
                    <td colspan="3" class='title'>결재자</td>
                    <td colspan="5">&nbsp;
                      <select name='fee_sac_id'>
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
                    <td colspan="3" class='title'>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td colspan="5">&nbsp;
                      <textarea rows='5' cols='90' name='fee_cdt'></textarea></td>
                </tr>			
                <tr>
                    <td colspan="3" class='title'>계약서 특약사항 기재 내용</td>
                    <td colspan="5">&nbsp;
                      <textarea rows='5' cols='90' name='con_etc'></textarea></td>
                </tr>			
            </table>
	    </td>
    </tr>
    <tr></tr><tr></tr>
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding='0' width=100%>
    		    <tr>
        		    <td class=line width="100%">
        			    <table border="0" cellspacing="1" cellpadding='0' width=100%>
            		        <tr>
            				  <td width="5%" class=title>기호</td>
            				  <td width="10%" class=title>코드</td>				  
            				  <td width="35%" class=title>이름</td>
            				  <td width="50%" class=title>값</td>
            				</tr>
            				    <td align="center">E-1</td>
            				    <td align="center">bc_b_e1</td>				  
            				    <td>&nbsp;낙찰예상가대비현재가치산출승수의기간반영율</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e1' maxlength='10' class=fixnum value='<%//=fee_etc.getBc_b_e1()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				    <td align="center">E-2</td>
            				    <td align="center">bc_b_e2</td>				  
            				    <td>&nbsp;경매장예상낙찰가격</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e2' maxlength='10' class=fixnum value='<%//=fee_etc.getBc_b_e2()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				  <td align="center">U</td>
            				  <td align="center">bc_b_u</td>				  
            				  <td>&nbsp;기타비용</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_u' maxlength='10' class='num' value='<%//=fee_etc.getBc_b_u()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='bc_b_u_cont' maxlength='150' class=text value='<%//=fee_etc.getBc_b_u_cont()%>'>
            				  </td>
            				</tr>							
            		        <tr>
            				  <td align="center">G</td>
            				  <td align="center">bc_b_g</td>				  
            				  <td>&nbsp;기타수익</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_g' maxlength='10' class='num' value='<%//=fee_etc.getBc_b_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='bc_b_g_cont' maxlength='150' class=text value='<%//=fee_etc.getBc_b_g_cont()%>'>
            				  </td>
            				</tr>
            		        <tr>
            				  <td align="center">AC</td>
            				  <td align="center">bc_b_ac</td>				  
            				  <td>&nbsp;기타 영업효율반영값</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_ac' maxlength='10' class='num' value='<%//=fee_etc.getBc_b_ac()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='bc_b_ac_cont' maxlength='150' class=text value='<%//=fee_etc.getBc_b_ac_cont()%>'></td>
            				</tr>
            		        <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_etc</td>				  
            				  <td>&nbsp;정산유의사항</td>
            				  <td align="center"><textarea rows='5' cols='70' name='bc_etc'><%//=fee_etc.getBc_etc()%></textarea></td>
            				</tr>
        		        </table>		
    			    </td>						
		        </tr>
            </table>
	    </td>
    </tr>		
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
                        <option value='<%=i%>'  <%if(ext_fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                        <% } %>
                        <option value='99' <%if(ext_fee.getFee_est_day().equals("99")){%> selected <%}%> > 말일 </option>
						<option value='98' <%if(ext_fee.getFee_est_day().equals("98")){%> selected <%}%> > 대여개시일 </option>
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
                      <input type='text' name='fee_fst_dt' value='<%//=AddUtil.ChangeDate2(ext_fee.getFee_fst_dt())%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				</td>
                    <td width="10%" class='title'>1회차납입액</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' name='fee_fst_amt' value='<%//=AddUtil.parseDecimal(ext_fee.getFee_fst_amt())%>' maxlength='10' size='10' class='num'>원
                      </td>
                </tr>		  		  		  		  		  	  		    		  		  
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보증보험</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">가입여부</td>
                    <td colspan="5">&nbsp;
                        <input type='radio' name="gi_st" value='1' >
                  		가입
                  		<input type='radio' name="gi_st" value='0' >
                  		면제 </td>
                </tr>                
                <tr>
                    <td class=title>발행지점</td>
                    <td width="20%">&nbsp;<input type='hidden' name='gi_no' value=''>
        			   <input type='text' name='gi_jijum' value='' size='12' class='text'>
                    </td>
                    <td width="10%" class='title'>가입금액</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		원</td>
                    <td class=title >보증보험료</td>
                    <td>&nbsp;
                        <input type='text' name='gi_fee' size='9' maxlength='20' class='whitenum' readonly value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		원</td>
                </tr>	
            </table>
        </td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험사항</span></td>
	</tr>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;1. 현재 가입된 보험조건</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title >보험계약자</td>
                    <td width="15%">&nbsp;
                        <input type='text' name='conr_nm' value='<%=ins.getConr_nm()%>' size='30' class='whitetext' disabled>
					</td>
                    <td width="10%" class=title >피보험자</td>
                    <td width="15%">&nbsp;
                        <input type='text' name='con_f_nm' value='<%=ins.getCon_f_nm()%>' size='30' class='whitetext' disabled>
                        &nbsp;&nbsp;&nbsp;
                        <%if(ins_cust_chk.equals("Y")){%><font color=red>보험기간 : <%=AddUtil.ChangeDate2(ins.getIns_start_dt())%> ~ <%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%></font><%}%>
					</td>       
                    <td width="10%" class=title >임직원운전한정특약</td>
                    <td>&nbsp;
                        <select name='i_com_emp_yn' disabled>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
					</td>					            
                </tr>            
                <tr>
                    <td width="13%" class=title >운전자연령</td>
                    <td width="15%">&nbsp;
                        <select name='age_scp' disabled>
                                <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21세이상 
                                </option>
                                <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>24세이상 
                                </option>
                                <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26세이상 
                                </option>
                                <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>전연령 
                                </option>
								<option value=''>=피보험자고객=</option>				
								        <option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>22세이상</option>	
								        <option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>28세이상</option>	
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30세이상</option>	
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35세이상</option>
                        <option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>35세이상~49세이하</option>	
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>43세이상</option>
						<option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>48세이상</option>
                              </select></td>
                    <td width="10%" class=title >대물배상</td>
                    <td width="15%">&nbsp;
                        <select name='vins_gcp_kd' disabled>
                                <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5억원</option>
				<option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3억원</option>
				<option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2억원</option>
				<option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1억원</option>
                                <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5천만원</option>
                                <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3천만원</option>
                                <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1천5백만원</option>
                                <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1천만원</option>				
                              </select></td>
                    <td width="10%" class=title >자기신체사고</td>
                    <td>&nbsp;
                        <select name='vins_bacdt_kd' disabled>
                                <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3억원</option>
                                <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1억5천만원</option>
                                <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1억원</option>
                                <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5천만원</option>
                                <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3천만원</option>
                                <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1천5백만원</option>
                                <option value="9" <%if(ins.getVins_bacdt_kd().equals("9")){%>selected<%}%>>미가입</option>
                              </select></td>
                </tr>
            </table>
	    </td>		
	</tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;2. 계약서에 약정된 보험조건</td>
	</tr>		
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                    <td width="13%" class=title >보험계약자</td>
                    <td width="15%">&nbsp;
                        <select name='insurant'>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>아마존카</option>
                          <%if(cont_etc.getInsurant().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsurant().equals("2")){%> selected <%}%>>고객</option>
                          <%}%>
                      </select>					  
		    </td>			  
                    <td width="10%" class=title >피보험자</td>
                    <td width="15%">&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per'>
                          <option value="">선택</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>아마존카</option>
                          <%if(car_st.equals("3") && cont_etc.getInsur_per().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>고객</option>
                          <%}%>
                      </select>					
		    </td>			  		
                    <td width="10%" class=title >임직원운전한정특약</td>
                    <td>&nbsp;
                        <select name='com_emp_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
					</td>		    			
              </tr>            
              <tr> 
                <td width="13%" class=title >운전자연령</td>
                <td width="15%">&nbsp;
                    <select name='driving_age'>
                      <option value="">선택</option>
                      <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26세이상</option>
                      <%if(car_st.equals("3")){%>
                      <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24세이상</option>
                      <%}%>
                      <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21세이상</option>
                      <%if(car_st.equals("3")){%>
                      <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>모든운전자</option>
		      <option value=''>=피보험자고객=</option>				
								        <option value='9'  <%if(base.getDriving_age().equals("9")){%>selected<%}%>>22세이상</option>	
								        <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>28세이상</option>	
                        <option value='5'  <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30세이상</option>				
                        <option value='6'  <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35세이상</option>				
                        <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>35세이상~49세이하</option>	
                        <option value='7'  <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43세이상</option>						
		                    <option value='8'  <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48세이상</option>
		      <%}%>
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
                <td>&nbsp;
                    <select name='bacdt_kd'>
                      <option value="">선택</option>
                      <option value="2" <% if(base.getBacdt_kd().equals("2") || base.getBacdt_kd().equals("1")) out.print("selected"); %>>1억원</option>
                      <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>미가입</option>
                      <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                  </select></td>
              </tr>
            </table>
        </td>
    </tr>		
    <%if(client.getClient_st().equals("2") || client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")){%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객</span></td>
	  </tr>    
    <tr>
	    <td class=line2></td>
	</tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">계약자 운전면허번호</td>
                    <td>&nbsp;
                        <input type='text' name='lic_no' value='<%//=base.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;(개인,개인사업자)
			&nbsp;※ 계약자(<%=client.getClient_nm()%>)의 운전면허번호를 기재 </td>
                </tr>
                <tr>
                    <td class=title width="13%">차량이용자 운전면허번호</td>
                    <td>&nbsp;
			<input type='text' name='mgr_lic_no' value='<%//=base.getMgr_lic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;이름
			<input type='text' name='mgr_lic_emp' value='<%//=base.getMgr_lic_emp()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;관계
			<input type='text' name='mgr_lic_rel' value='<%//=base.getMgr_lic_rel()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;(개인,개인사업자)
			&nbsp;※ 계약자가 운전면허가 없는 경우 차량이용자의 운전면허를 입력   </td>
                </tr>     
                         
            </table>
        </td>
    </tr>  	  
    <%}%>        
<%--     <%if(client.getClient_st().equals("1")){%> --%>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 공동임차</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id='tr_client_share_st'> 
<%--     <tr id=tr_client_share_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">  --%>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>공동임차여부</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_share_st" value='1' <%if(cont_etc.getClient_share_st().equals("1"))%>checked<%%>>
        				있다
        	      <input type='radio' name="client_share_st" value='2' <%if(!cont_etc.getClient_share_st().equals("1"))%>checked<%%>>
        				없다</td>
                </tr>
            </table>  
        </td>
    </tr>  
<%--     <%}%>          --%>
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>			
    <%		if(ins_cust_chk.equals("Y")){%>
    <tr>
        <td>&nbsp;</td>
    </tr>    
    <tr>
        <td><font color=red>* 고객이 피보험자인 계약건의 연장은 사전에 보험갱신이 먼저 이루어지고 나서 연장등록 및 결재요청을 할 수 있습니다.</font></td>
    </tr>    
    <%		}else{%>    
    <tr>
        <td>* 등록처리후 미결및요청현황의 세부페이지로 넘어갑니다.
		&nbsp;</td>
    </tr>
    <%//			if(fee_size==9){ %>
    <!-- rent_st 사이즈 업 
    <tr>
		<td align="right"><font color=red>※ 최대 8회까지 연장계약된 상태입니다.(최초계약부터 10건 제한) 임의연장 등록하십시오.</font></td>
    </tr>
     -->	
    <%//			}else{ %>
    <tr>
		<td align="right"><a id="submitLink" href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
    </tr>	
    <%//			} %>
    <%		}%>
    <%}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<iframe src="about:blank" name="i_no2" width="100%" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	if(fm.bas_dt.value == ''){
		fm.bas_dt.value 			= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';
		fm.rent_dt.value 			= '<%= AddUtil.getDate() %>';
		fm.rent_start_dt.value 			= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';		
	}

<%	if(ext_fee.getOpt_s_amt()>0){//연장계약시 매입옵션이 있는 경우%>		
	fm.fee_opt_amt.value = <%=ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt()%>;
<%	}%>

	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	//중고차가격 계산
	getSecondhandCarAmt_h();	
	<%}%>
	
//-->
</script>
</body>
</html>
