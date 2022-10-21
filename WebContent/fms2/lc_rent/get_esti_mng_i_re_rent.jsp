<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.con_ins.*, acar.ext.*, acar.im_email.*,acar.insur.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase"	scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="ae_db" class="acar.ext.AddExtDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();

	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "01", "08");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");
	String fee_rent_st = request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	//자동차기본정보-기본차량
	CarMstBean cm_bean2 = cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		ins = ai_db.getInsCase(base.getCar_mng_id(), ai_db.getInsSt(base.getCar_mng_id()));//보험정보
	}
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	if(fee_size > 1) rent_st = Integer.toString(fee_size);
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//차량기본정보
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	//마지막대여정보
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//이행보증보험
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	//영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");	
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());	
	
	//업무대여 기본식
	if(base.getCar_st().equals("5") && fees.getRent_way().equals("")){
		fees.setRent_way("3");
	}
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	String a_a = "2";	
	if(base.getCar_st().equals("3")) a_a = "1";
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
	
	String o_3 = edb.getEstiSikVarCase("1", "", "o_3");
	//String gi_fee = edb.getEstiSikVarCase("1", "", "gi_fee");//보증보험료
	Hashtable sh_ht = new Hashtable();
	Hashtable carOld 	= c_db.getOld(cr_bean.getInit_reg_dt());//차량등록 경과기간(차령)
	//잔가 차량정보
	Hashtable sh_var = shDb.getShBaseVar(base.getCar_mng_id());
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+Integer.toString(fee_size)+"&from_page="+from_page;
	String valus_t = valus;
	int fee_opt_amt = 0;
	for(int f=1; f<=fee_size; f++){
		ContFeeBean fees2 = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
		if(fee_size >1 && f==(fee_size-1)){
			fee_opt_amt = fees2.getOpt_s_amt()+fees2.getOpt_v_amt();
		}
	}
	//기본DC 가져오기
	String car_d_dt = e_db.getDc_b_dt(cm_bean.getCar_comp_id()+""+cm_bean.getCode(), "dc", base.getRent_dt(), cm_bean.getCar_b_dt());
	CarDcBean cd_bean = cmb.getCarDcBaseCase(cm_bean.getCar_comp_id(), cm_bean.getCode(), car_d_dt, cm_bean.getCar_b_dt());
	//이름조회
	int user_idx = 0;
	
	e_bean = e_db.getEstimateCase(fee_etc.getBc_est_id()); 
	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* 코드 구분:대여상품명 */
	int good_size = goods.length;
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	function replaceFloatRound(per){return Math.round(per*1000)/10;}
	function replaceFloatRound2(per){return Math.round(per*10)/10;}
	//특소세전차량가 가져가기
	function setVar_o_123(car_price){
		var fm = document.form1;	
		var o_1 = car_price;
		//차종별 특소세율
		var o_2 = <%=ej_bean.getJg_3()%>;
		//특소세전차량가 o_3 = o_1/(1+o_2), 차량가격/(1+특소세율);
		var o_3 = Math.round(<%=o_3%>);
		fm.v_o_1.value = o_1;
		fm.v_o_2.value = o_2;
		fm.v_o_3.value = o_3;
	}
	//대여기간 셋팅
	function set_cont_date(obj){
		var fm = document.form1;	
		var rent_way = <%=fees.getRent_way()%>;
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == '')) return;
		if(obj == fm.con_mon){ fm.rent_start_dt.value = ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value); }
		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
		fm.action='get_fee_nodisplay.jsp';
		fm.target='i_no';
		//if(<%=fees.getRent_st()%>!='1'){
			fm.submit();	
		//}
	}
	
	//반올림
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}	
	
	//등록/수정: 차량가격 입력시 자동계산으로 가게..
	function enter_fee(obj, rent_dt){
		var keyValue = event.keyCode;
		
		if (keyValue =='13') set_fee_amt(obj, rent_dt);
	}	
	//등록/수정: 공급가, 부가세, 합계 입력시 자동계산
	function set_fee_amt(obj, rent_dt)
	{
		var fm = document.form1;
		var car_price = setCarPrice('car_price2');
		var s_dc_amt = setDcAmt2(car_price);
		if(rent_dt == '') rent_dt = <%=base.getRent_dt()%>;
		car_price = car_price - s_dc_amt - toInt(parseDigit(fm.tax_dc_amt.value));
		//특판출고 
		//20190513 DC금액 면세가반영안한다.
		//20190816 특판은 견적서 차가
		<%if(!base.getCar_st().equals("5")){%>
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dir_pur_yn.value == 'Y'){
		//	s_dc_amt = <%=cd_bean.getCar_d_p()%>;
		//	var s_dc_per = <%=cd_bean.getCar_d_per()%>;
		//	if(s_dc_per > 0){ s_dc_amt = (car_price*s_dc_per/100)+s_dc_amt; }
			car_price = <%=e_bean.getO_1()%>;
		}
		//car_price = car_price - s_dc_amt;
		<%}%>
		var f_car_price = car_price;
		if(fm.car_gu.value != '1'){ car_price = toInt(parseDigit(fm.sh_amt.value)); }
		if(<%=fee_size%> > 1){
			car_price = toInt(parseDigit(fm.sh_amt.value));
			if(toInt(parseDigit(fm.fee_opt_amt.value)) > 0) car_price	= toInt(parseDigit(fm.fee_opt_amt.value));
		}
		
		obj.value = parseDecimal(obj.value);
		//보증금---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt || obj==fm.grt_amt){
			if(obj==fm.grt_s_amt)	 fm.grt_amt.value 	 = fm.grt_s_amt.value;	//공급가
			if(obj==fm.grt_amt)		 fm.grt_s_amt.value = fm.grt_amt.value;		//합계
			if(car_price > 0){
				fm.gur_p_per.value 	 = replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
				fm.f_gur_p_per.value = replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / f_car_price );
			}
		//선납금---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt || obj==fm.pp_v_amt || obj==fm.pp_amt){
			if(obj==fm.pp_s_amt){ 	//선납금 공급가
				fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
				fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));
			}
			if(obj==fm.pp_v_amt){ 	//선납금 부가세
				fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));
			}
			if(obj==fm.pp_amt){ 	//선납금 합계
				fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
				fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));
			}
			if(car_price > 0){
				fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
				fm.f_pere_r_per.value = replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / f_car_price );
			}
		//개시대여료---------------------------------------------------------------------------------
		}else if(obj==fm.ifee_s_amt || obj==fm.ifee_v_amt || obj==fm.ifee_amt){
			if(obj==fm.ifee_s_amt){ 	//개시대여료 공급가
				fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) * 0.1 );
				fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));
			}
			if(obj==fm.ifee_v_amt){ 	//개시대여료 부가세
				fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));
			}
			if(obj==fm.ifee_amt){ 	  //개시대여료 합계
				fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
				fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));
			}
			fm.pere_r_mth.value = Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
			fm.fee_pay_tm.value = toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
		//최대잔가율---------------------------------------------------------------------------------
		}else if(obj==fm.max_ja){ 		//최대잔가율
			fm.ja_amt.value 	  = parseDecimal(getCutRoundNumber(car_price * toFloat(fm.max_ja.value) /100,-3) );
			fm.ja_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_amt.value))));
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_amt.value)) - toInt(parseDigit(fm.ja_s_amt.value)));
		}else if(obj==fm.ja_s_amt){ 	//최대잔가 공급가
			obj.value = parseDecimal(obj.value);
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) * 0.1 );
			fm.ja_amt.value		  = parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) + toInt(parseDigit(fm.ja_v_amt.value)));
		}else if(obj==fm.ja_v_amt){ 	//최대잔가 부가세
			obj.value = parseDecimal(obj.value);
			fm.ja_amt.value		  = parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) + toInt(parseDigit(fm.ja_v_amt.value)));
		}else if(obj==fm.ja_amt){		//최대잔가 합계
			obj.value = parseDecimal(obj.value);
			fm.ja_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_amt.value))));
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_amt.value)) - toInt(parseDigit(fm.ja_s_amt.value)));
			if(car_price > 0){
				fm.max_ja.value 	= replaceFloatRound(toInt(parseDigit(fm.ja_amt.value)) / car_price );
			}
		//적용잔가율---------------------------------------------------------------------------------
		}else if(obj==fm.app_ja){ 		//적용잔가율
			fm.ja_r_amt.value 		= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.app_ja.value) /100,-3) );
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));
		}else if(obj==fm.ja_r_s_amt){ 	//적용잔가 공급가
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) * 0.1 );
			fm.ja_r_amt.value		  = parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));
		}else if(obj==fm.ja_r_v_amt){ 	//적용잔가 부가세
			fm.ja_r_amt.value		  = parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));
		}else if(obj==fm.ja_r_amt){		//적용잔가 합계
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));
			if(car_price > 0){	
				fm.app_ja.value 		= replaceFloatRound(toInt(parseDigit(fm.ja_r_amt.value)) / car_price );
			}
		//매입옵션율---------------------------------------------------------------------------------
		}else if(obj==fm.opt_s_amt){ 	//매입옵션 공급가
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) * 0.1 );
			fm.opt_amt.value		  = parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
			if(car_price > 0){
				fm.opt_per.value 	  = replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
				fm.f_opt_per.value 	= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / f_car_price );
			}
		}else if(obj==fm.opt_v_amt){ 	//매입옵션 부가세
			fm.opt_amt.value		  = parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
		}else if(obj==fm.opt_amt){ 		//매입옵션 합계
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				fm.opt_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
				fm.opt_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));
				if(car_price > 0){
					fm.opt_per.value 	 = replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
					fm.f_opt_per.value = replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / f_car_price );
				}
			}
		//계약대여료---------------------------------------------------------------------------------
		}else if(obj==fm.fee_s_amt){ 	//계약대여료 공급가
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1 );
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
			fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
		}else if(obj==fm.fee_v_amt){ 	//계약대여료 부가세
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_amt){ 		//계약대여료 합계
			fm.fee_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));
			fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
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
		//총보험료---------------------------------------------------------------------------------
		}else if(obj==fm.ins_total_amt){
			obj.value = parseDecimal(obj.value);
			fm.ins_total_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_total_amt.value)));
		//규정대여료---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//규정대여료 공급가
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));
			setTinv_amt();
		}else if(obj==fm.inv_v_amt){ 	//규정대여료 부가세
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));
			setTinv_amt();
		}else if(obj==fm.inv_amt){ 		//규정대여료 합계
			fm.inv_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));
			setTinv_amt();
		//운전자 추가요금(2018.03.30)-------------------------------------------------------------------	
		}else if(obj==fm.driver_add_amt){	//운전자추가요금 공급가
			fm.driver_add_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) * 0.1 );
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));
			setTinv_amt();
		}else if(obj==fm.driver_add_v_amt){ 	//운전자추가요금 부가세
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));
			setTinv_amt();
		}else if(obj==fm.driver_add_total_amt){ //운전자추가요금 합계
			fm.driver_add_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.driver_add_total_amt.value))));
			fm.driver_add_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.driver_add_total_amt.value)) - toInt(parseDigit(fm.driver_add_amt.value)));
			setTinv_amt();
		}
	
		if(obj==fm.opt_s_amt || obj==fm.opt_v_amt || obj==fm.opt_amt){ 	//매입옵션
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(rent_dt >= 20080501 && toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){
					//연장일때는 매입옵션이 적용잔가
					if(<%=fee_size%> > 1){
						fm.app_ja.value = fm.opt_per.value;
						fm.ja_r_s_amt.value = fm.opt_s_amt.value;
						fm.ja_r_v_amt.value = fm.opt_v_amt.value;
						fm.ja_r_amt.value = fm.opt_amt.value;
					}else{
						fm.app_ja.value = fm.max_ja.value;
						fm.ja_r_s_amt.value = fm.ja_s_amt.value;
						fm.ja_r_v_amt.value = fm.ja_v_amt.value;
						fm.ja_r_amt.value = fm.ja_amt.value;
					}
				}else{
					fm.app_ja.value = fm.opt_per.value;
					fm.ja_r_s_amt.value = fm.opt_s_amt.value;
					fm.ja_r_v_amt.value = fm.opt_v_amt.value;
					fm.ja_r_amt.value = fm.opt_amt.value;
				}
				fm.opt_chk[1].checked = true;
			}else{
				fm.app_ja.value = fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value = fm.ja_amt.value;
				fm.opt_chk[0].checked = true;
			}
		}
		sum_pp_amt();
	}
	
	//정상요금합계 구하기
	function setTinv_amt(){
		fm.tinv_s_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.driver_add_amt.value)));
		fm.tinv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));
		fm.tinv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) + toInt(parseDigit(fm.ins_amt.value)) + toInt(parseDigit(fm.driver_add_total_amt.value)));
	}
	
	//매입옵션유무
	function opt_display(st, rent_dt){
		var fm = document.form1;
		if(rent_dt == '') rent_dt = <%=base.getRent_dt()%>;
		if(st == ''){
			if(fm.opt_chk[0].checked == true)	st = '0';
			else if(fm.opt_chk[1].checked == true)	st = '1';
		}
		if(st == '0'){
			fm.app_ja.value = fm.max_ja.value;
			fm.ja_r_s_amt.value = fm.ja_s_amt.value;
			fm.ja_r_v_amt.value = fm.ja_v_amt.value;
			fm.ja_r_amt.value = fm.ja_amt.value;
		}else if(st == '1'){
			if(rent_dt >= 20080501 && toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){
				fm.app_ja.value = fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value = fm.ja_amt.value;
			}else{		
				fm.app_ja.value = fm.opt_per.value;
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value = fm.opt_amt.value;
			}
		}
	}
	//차량가격 가져가기
	function setCarPrice(st){
		var fm = document.form1;
		var car_price = 0;
		if(st == 'car_c_price')		car_price = <%=car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()%>;
		if(st == 'car_price2')		car_price	= <%=car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()+car.getAdd_opt_amt()%>;
		return car_price;
	}
	//DC금액 가져가기
	function setDcAmt(car_price){
		var fm = document.form1;		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
		//일반 과세차 렌트견적시 매출D/C금액 특소세율반영---------------
		var purc_gu 	= fm.purc_gu.value;
		var s_st 			= fm.s_st.value;
		if(purc_gu == ''){	alert("과세구분을 선택하십시오."); return; }
		if(purc_gu == '1'){//과세1
		}else{//과세2(면세) 
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				setVar_o_123(car_price);
				//메출D/C 면세분 반영 = 매출D/C*(1+특소세율);
				s_dc_amt = Math.round(s_dc_amt*(1+toFloat(fm.v_o_2.value)));
			}
		}
		//수입차
		if('<%=ej_bean.getJg_w()%>'=='1'){ s_dc_amt = 0; }
		return s_dc_amt;
	}	
	//DC금액 가져가기
	function setDcAmt2(car_price){
		var fm = document.form1;		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));		
		//수입차
		if('<%=ej_bean.getJg_w()%>'=='1'){ s_dc_amt = 0; }
		return s_dc_amt;
	}		
	//선수금 합계
	function sum_pp_amt(){
		var fm = document.form1;
		fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value   = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );
		var car_price = setCarPrice('car_price2');
		var s_dc_amt 	= setDcAmt2(car_price);
    	car_price = car_price - s_dc_amt - toInt(parseDigit(fm.tax_dc_amt.value));
		if(fm.car_gu.value != '1'){
			car_price 	= toInt(parseDigit(fm.sh_amt.value));
		}
		if(<%=fee_size%> > 1){
			car_price 	= toInt(parseDigit(fm.sh_amt.value));
			if(toInt(parseDigit(fm.fee_opt_amt.value)) > 0) car_price	= toInt(parseDigit(fm.fee_opt_amt.value));
		}
		var pp_price 	= toInt(parseDigit(fm.tot_pp_amt.value)) + toInt(parseDigit(fm.gi_amt.value));
		if(pp_price>0 || car_price>0){
			fm.credit_r_per.value = replaceFloatRound(pp_price / car_price );
			fm.credit_r_amt.value = parseDecimal(pp_price);
		}
	}
	//규정대여료 계산 (견적) 
	function estimate(rent_st, rent_dt, rent_start_dt, st){
		var fm = document.form1;
		
		var agree_dist 		= toInt(parseDigit(fm.new_agree_dist.value));
		
		if(agree_dist == 0){
			alert('변경 약정운행거리를 입력하십시오.');			return;
		}
		
		if(toInt(parseDigit(fm.old_agree_dist.value)) == toInt(parseDigit(fm.new_agree_dist.value))){
			alert('변경 약정운행거리가 기존 약정운행거리와 같습니다. 확인하십시오.');			return;
		}
			
		fm.fee_rent_st.value = rent_st;
		fm.fee_rent_dt.value = rent_dt;
		
		var car_price 	= setCarPrice('car_price2');
		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
				
		//일반 과세차 렌트견적시 매출D/C금액 특소세율반영---------------
		var purc_gu 	= fm.purc_gu.value;
		var s_st 			= fm.s_st.value;
		if(purc_gu == ''){	alert("과세구분을 선택하십시오."); return; }
		
		if(purc_gu == '1'){//과세1
		}else{//과세2(면세)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				setVar_o_123(car_price);
				//매출D/C 면세분 반영 = 매출D/C*(1+특소세율);	수입차DC는 제외				
				if(<%=base.getRent_dt()%> >= 20130501 && '<%=ej_bean.getJg_w()%>'=='1'){
				}else{
					s_dc_amt = Math.round(s_dc_amt*(1+toFloat(fm.v_o_2.value)));
				}
			}
		}
		
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));
		fm.o_1.value 				= car_price - s_dc_amt;
		fm.t_dc_amt.value 	= s_dc_amt;
		fm.esti_stat.value 	= st;
		
		//특판출고
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dir_pur_yn.value == 'Y'){
			fm.o_1.value 			= car_price;
			fm.t_dc_amt.value = 0;
			s_dc_amt = <%=cd_bean.getCar_d_p()%>;
			var s_dc_per = <%=cd_bean.getCar_d_per()%>;
			if(s_dc_per > 0){
				s_dc_amt = (car_price*s_dc_per/100)+s_dc_amt;
			}
			fm.o_1.value 			= car_price - s_dc_amt;
			fm.t_dc_amt.value = s_dc_amt;
		}
		
	  	
		
		//신차	
		fm.ro_13.value 		= fm.opt_per.value;
		fm.o_13_amt.value 	= fm.opt_amt.value;
		fm.o_13.value 		= 0;
		fm.action='get_fee_estimate_newcar_re.jsp';		
		fm.target = 'inner';
		//fm.target = '_blank';
		fm.submit();
		
	}

	//영업수당계산
	function setCommi(){
		var fm = document.form1;
		var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));
		var comm_r_rt 	= toFloat(fm.comm_r_rt.value);
		fm.commi.value = parseDecimal(th_round(car_price*comm_r_rt/100));
	}

	//대여료 DC율 계산
	function dc_fee_amt(){
		//정상요금에서 계산함. 20170310 소스정리
	}		
	
	//만나이계산하기
	function age_search()
	{
		var fm = document.form1;
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=460,height=250,left=370,top=200');		
		fm.action = "search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();		
	}		
	
	//견적이력
	function view_car_esti_h(){
		var fm = document.form1;
		var SUBWIN="view_car_esti_list.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=1";
		window.open(SUBWIN, "CarEstiHistory", "left=50, top=50, width=1200, height=800, scrollbars=yes, status=yes");
	}	
	
	//직원조회
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.user_nm.value;		
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
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
<body>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>   
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>    
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_12.jsp'>   
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="s_st" 					value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="dpm" 					value="<%=cm_bean.getDpm()%>">
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
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">      
  <input type='hidden' name="client_st" 		value="<%=client.getClient_st()%>">     
  <input type='hidden' name="o_1"			value="">
  <input type='hidden' name="ro_13"			value="">  
  <input type='hidden' name="o_13"			value="">  
  <input type='hidden' name="o_13_amt"			value="">    
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
  <input type='hidden' name="idx"			value="">  
  <input type='hidden' name="scan_cnt"			value="">    
  <input type='hidden' name="chk_cnt"			value="">
  <input type='hidden' name="car_id"			value="<%=cm_bean.getCar_id()%>">  
  <input type='hidden' name="car_id2"			value="<%=cm_bean2.getCar_id()%>">    
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>
  <input type='hidden' name="remove_seq"		value="">  
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">    
  <input type='hidden' name="est_from"			value="lc_b_u_re">
  <input type='hidden' name="fee_opt_amt"		value="">  
  <input type='hidden' name="rent_mng_id2"		value="">    
  <input type='hidden' name="rent_l_cd2"		value="">      
  <input type='hidden' name="fee_rent_st"		value="<%=rent_st%>">        
  <input type='hidden' name="fee_rent_dt"		value="">          
  <input type='hidden' name="now_stat"			value="<%=now_stat%>">            
  <input type='hidden' name="v_o_1"			value="">
  <input type='hidden' name="v_o_2"			value="">
  <input type='hidden' name="v_o_3"			value="">
  <input type='hidden' name="car_cng_yn"		value="<%=cont_etc.getCar_cng_yn()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">
  <input type='hidden' name="tax_dc_amt" 		value="<%=car.getTax_dc_s_amt()+car.getTax_dc_v_amt()%>">
  <input type='hidden' name="tax_dc_s_amt" 	value="<%=car.getTax_dc_s_amt()%>">
  <input type='hidden' name="tax_dc_v_amt" 	value="<%=car.getTax_dc_v_amt()%>">
  <input type='hidden' name="dir_pur_yn" 		value="<%=pur.getDir_pur_yn()%>">
  <input type='hidden' name="one_self" 		value="<%=pur.getOne_self()%>">
  <input type='hidden' name="sh_amt" 		value="<%=fee_etc.getSh_amt()%>">
  <input type='hidden' name="gi_amt" 		value="<%=gins.getGi_amt()%>">
  <input type='hidden' name="gi_st" 		value="<%=gins.getGi_st()%>">
  <!-- <input type='hidden' name="driving_age" value="<%=base.getDriving_age()%>"> -->
  <!-- <input type='hidden' name="gcp_kd" value="<%=base.getGcp_kd()%>"> -->  
  <input type='hidden' name="insurant" value="<%=cont_etc.getInsurant()%>">
  <input type='hidden' name="insur_per" value="<%=cont_etc.getInsur_per()%>">
  <input type='hidden' name="add_opt_amt" value="<%=car.getAdd_opt_amt()%>">
  <input type='hidden' name="sh_km" 		value="<%=fee_etc.getSh_km()%>">
  <input type='hidden' name="udt_st" 		value="<%=pur.getUdt_st()%>">
  <input type='hidden' name="car_c_amt" 		value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">
  <input type='hidden' name="opt" 		value="<%=car.getOpt()%>">
  <input type='hidden' name="opt_c_amt" 		value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">
  <input type="hidden" name="opt_amt_m" value="<%=car.getOpt_amt_m()%>">	
  <input type='hidden' name="color" 		value="<%=car.getColo()%>">
  <input type='hidden' name="col_c_amt" 		value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">
  <input type='hidden' name="car_st" 		value="<%=base.getCar_st()%>">
  <input type='hidden' name="rent_way" 		value="<%=fees.getRent_way()%>">
  <input type='hidden' name="car_ext" 		value="<%=car.getCar_ext()%>">
  <input type='hidden' name="eme_yn" 		value="<%=cont_etc.getEme_yn()%>">
  <input type='hidden' name="car_ja" 		value="<%=base.getCar_ja()%>">
  <input type='hidden' name="spr_kd" 		value="<%=base.getSpr_kd()%>">
  <input type='hidden' name="ecar_loc_st" 		value="<%=pur.getEcar_loc_st()%>">
  <input type='hidden' name="hcar_loc_st" 		value="<%=pur.getHcar_loc_st()%>">
  <input type='hidden' name="eco_e_tag" 		value="<%=car.getEco_e_tag()%>">
  <input type='hidden' name="tint_b_yn" 		value="<%=car.getTint_b_yn()%>">
  <input type='hidden' name="tint_s_yn" 		value="<%=car.getTint_s_yn()%>">
  <input type='hidden' name="tint_n_yn" 		value="<%=car.getTint_n_yn()%>">
  <input type='hidden' name="tint_bn_yn" 		value="<%=car.getTint_bn_yn()%>">
  <input type='hidden' name="new_license_plate" 		value="<%=car.getNew_license_plate()%>">
  <input type='hidden' name="tint_cons_yn" 		value="<%=car.getTint_cons_yn()%>">
  <input type='hidden' name="tint_cons_amt"		value="<%=car.getTint_cons_amt()%>">
  <input type='hidden' name="tint_eb_yn" 		value="<%=car.getTint_eb_yn()%>">
  <input type='hidden' name="tint_ps_yn" 		value="<%=car.getTint_ps_yn()%>">
  <input type='hidden' name="tint_ps_nm" 		value="<%=car.getTint_ps_nm()%>">
  <input type='hidden' name="tint_ps_amt" 	value="<%=car.getTint_ps_amt()%>">
  <input type='hidden' name="ecar_pur_sub_amt" value="<%=car.getEcar_pur_sub_amt()%>">
  <input type='hidden' name="ecar_pur_sub_st" value="<%=car.getEcar_pur_sub_st()%>">
  <input type='hidden' name="h_ecar_pur_sub_amt" value="<%=car.getEcar_pur_sub_amt()%>">
  <input type='hidden' name="h_ecar_pur_sub_st" value="<%=car.getEcar_pur_sub_st()%>">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">  
  <input type='hidden' name="br_from"			value="">
  <input type='hidden' name="br_to"				value="">
  <input type='hidden' name="car_no"			value="<%=cr_bean.getCar_no()%>">
  
  
       
<table border='0' cellspacing='0' cellpadding='0' width='1200'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>신차개시후 약정거리 변경</span></span></td>
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
                    <td>&nbsp;<b><font color='#990000'><%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></font></b></td>
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
                    <td width="3%" class=title rowspan="2">연번</td>
                    <td width="10%" class=title rowspan="2">계약일자</td>
                    <td width="6%" class=title rowspan="2">이용기간</td>
                    <td width="8%" class=title rowspan="2">대여개시일</td>
                    <td width="8%" class=title rowspan="2">대여만료일</td>
                    <td width="7%" class=title rowspan="2">계약담당</td>
                    <td width="9%" class=title rowspan="2">월대여료</td>
                    <td class=title colspan="2">보증금</td>
                    <td width="10%" class=title rowspan="2">선납금</td>
                    <td class=title colspan="2">개시대여료</td>
                    <td class=title colspan="2">매입옵션</td>
                </tr>
                <tr>
                    <td width="10%" class=title>금액</td>
                    <td width="3%" class=title>승계</td>
                    <td width="10%" class=title>금액</td>
                    <td width="3%" class=title>승계</td>
                    <td width="10%" class=title>금액</td>
                    <td width="3%" class=title>%</td>			
                </tr>
                
                
    		  <%for(int i=0; i<fee_size; i++){
    				 
    				fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
    				
    				if(fee_size >0 && (i+1)==fee_size)	fee_opt_amt = fees.getOpt_s_amt()+fees.getOpt_v_amt(); //새로운연장 견적
    				
    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></td>
                    <td align="center"><%=fees.getCon_mon()%>개월</td>
                    <td align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                    <td align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>원</td>
                    <td align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>원</td>
                    <td align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>			
                    <td align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>원</td>
                    <td align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>원</td>
                    <td align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>
                    <td align="right">
					<%if(fee_size >1 && (i+1)==(fee_size)){%>
					<b><font color='#990000'><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>원</font></b>
					<%}else{%>
					<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>원
					<%}%>
					</td>
                    <td align="center"><%=fees.getOpt_per()%></td>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title >약정운행거리</td>
                    <td>&nbsp;
                    	<b><%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%></b>km이하/1년,
                  		<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  		<br>&nbsp;
                  		(약정이하운행시) 환급대여료  <b><%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%></b>원/1km (부가세별도)
                  		<%if(fee_etc.getRtn_run_amt_yn().equals("1")){%> ※ 환급대여료미적용<%} %>
                  		<%} %>    
                  		<br>&nbsp;              
                  		(약정초과운행시) 초과운행대여료 <b><%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%></b>원/1km (부가세별도)                  	
                  		<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  		<br>&nbsp;                  
                  		매입옵션 행사시 환급대여료 : 기본식은 미지급, 일반식은 40%만 지급
                  		<%} %>
                  		<br>&nbsp;                  
                  		매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>만 납부
                    </td>                    
                </tr>
            </table>
	    </td>		
	</tr>	
	<tr>
	    <td class=h></td>
	</tr>  	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>약정운행거리 변경</span></td>
	</tr>    
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="33%" class='title'><span class="title1">변경항목</span></td>
                    <td width="33%" class='title'><span class="title1">기 존</span></td>
                    <td width="34%" class='title'><span class="title1">변 경</span></td>
                </tr>   
                <tr>    
                    <td align="center">약정운행거리 변경</td>
                    <td align="center">&nbsp;
		               <input type='text' name='old_agree_dist' size='6' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' readonly >
                        km이하/1년            
                    </td>
                    <td align="center">&nbsp;
		               <input type='text' name='new_agree_dist' size='6' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' >
                        km이하/1년            
                    </td>
              </tr>   
            </table>
         </td>
     </tr>
	<tr>
	    <td class=h></td>
	</tr>  
	<tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="33%" class=title >약정운행거리 변경일자</td>
                    <td>&nbsp;
                    	<input type='text' name='cng_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(AddUtil.getDate(4)) %>' onBlur='javascript: this.value = ChangeDate(this.value);'>
                    </td>                    
                </tr>
            </table>
	    </td>		
	</tr>	
	<tr>
	    <td class=h></td>
	</tr>  
	<tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="33%" class=title >변경요청서 회신 담당자</td>
                    <td>&nbsp;
                    	<input name="user_nm" type="text" class="text"  readonly value="<%=session_user_nm%>" size="12"> 
						<input type="hidden" name="reg_id" value="<%=ck_acar_id%>">			
						<a href="javascript:User_search('reg_id', '');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>			
                    </td>                    
                </tr>
            </table>
	    </td>		
	</tr>	
    <%
  		int modify_deadline_mon = (AddUtil.parseInt(fees.getCon_mon())/12)+1; //계약년수+1개월
    	modify_deadline_mon = 6; //20220426 환급대여료 적용 6개월이내
 		String modify_deadline = c_db.addMonth(fees.getRent_start_dt(), modify_deadline_mon);
    %>     
     <tr>
	    <td>※ 약정운행거리 변경은 대여개시후 6개월 이내에 1회에 한해서 변경가능합니다. 
	    <!-- ( <%=fees.getCon_mon()%>개월 <%=AddUtil.parseInt(fees.getCon_mon())/12%>년 계약으로 <%=AddUtil.parseInt(fees.getCon_mon())/12%>+1 -> <b>(대여개시후 <%=(AddUtil.parseInt(fees.getCon_mon())/12)+1 %>개월 이내(변경기한<%=modify_deadline%>) 1회에 한해 변경가능)</b>-->   
	      <b>( 대여개시후 6개월 이내 (변경기한 <%=modify_deadline%>) 변경가능) </b>
	    </td>
	 </tr>
	 <tr>
	    <td>※ 계약요금과 정상요금이 차이가 나는 경우 (증.대차 할인, 제조사DC 반영여부, 견적일차이, 세율변동, 운전자 추가 등) 약정운행거리 변경 계산시에도 그 금액 차이를 그대로 계산값에 반영하였습니다. </td>
	 </tr>	
	 <!-- 
	<%	if(AddUtil.parseInt(modify_deadline) < AddUtil.getDate2(4)){ %>
     <tr>
	    <td><font color=red>※ 약정운행거리 변경기한 <%=modify_deadline%> 입니다.</font></td>
	</tr>
	<%	}%>
	<%	int modify_cnt = edb.getNewCarRentEstiReCnt(rent_l_cd); %>
	<%	if(modify_cnt > 0){ %>
     <tr>
	    <td><font color=red>※ 약정운행거리 변경계산이 <%=modify_cnt%>회 입니다.</font></td>
	</tr>
	<%	}%>
	 -->	
	<%  int cnt3 = 0; %>
	<%	if( (fees.getMax_ja() - fees.getApp_ja()) > 3){
			cnt3++;
	%>
    <tr>
	    <td><font color=red>※ 매입옵션을 조정 최대잔가보다 낮게 계약한 건의 약정운행거리 조정은 권용식과장에게 문의하세요.</font></td>
	</tr>
	<%	} %>
		
     <!-- --------------------------------------------------------------------------------------------------------------------- -->	
    <tr> 
        <td id=tr_1 style='display:none'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>        		
                <td align="center" class=title>대여상품</td>
                <td>&nbsp;
					    			<% String s_a_a= "";
												if(base.getCar_st().equals("1")) 			s_a_a = "2";
												else                             			s_a_a = "1";
												if(fees.getRent_way().equals("1")) 			s_a_a = s_a_a+"1";
												else                              			s_a_a = s_a_a+"2";
										%>
							        
                      <select name="a_a" class="default">
                        <%for(int i = 0 ; i < good_size ; i++){
        					         CodeBean good = goods[i];
        					         //기본식고객은 기본식만
        					         if(fees.getRent_way().equals("3") && (good.getNm_cd().equals("21")||good.getNm_cd().equals("11"))) continue;
        					         //영업용차량은 장기렌트만
        					         if(base.getCar_st().equals("1") && (good.getNm_cd().equals("11")||good.getNm_cd().equals("12"))) continue;
        					         //자가용차량은 리스계약만
        					         if(base.getCar_st().equals("3") && (good.getNm_cd().equals("21")||good.getNm_cd().equals("22"))) continue;
        					      %>
                        <option value='<%= good.getNm_cd()%>' <%if(s_a_a.equals(good.getNm_cd()))%>selected<%%>><%= good.getNm()%></option>
                        <%}%>
                      </select>
                    </td>
              </tr>            			
              <tr>
                <td width="13%" align="center" class=title>이용기간</td>
                <td>&nbsp;
                    <input type='text' name="con_mon" value='<%=fees.getCon_mon()%>' size="6" maxlength="2" class='num' onChange='javascript:set_cont_date(this)'>
        			 개월
        			 <input type='hidden' name="rent_start_dt"	value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>">
        			 <input type='hidden' name="rent_end_dt"	value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>">
        		</td>
              </tr>
              <tr>
                <td width="13%" align="center" class=title>표준약정 운행거리</td>
                <td>&nbsp;
                    <input type='text' name='b_agree_dist' size='6' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' readonly>
                    km이하/1년
        		</td>
              </tr>              

                <tr>
                <td class='title'><span class="title1">적용약정 운행거리</span></td>
                <td>&nbsp;
		  <input type='text' name='agree_dist' size='6' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' >
                  km이하/1년,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (약정이하운행시) 환급대여료  <input type='text' name='rtn_run_amt' size='2' maxlength='20' class='fixnum' value='<%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)
                  <%	if ((nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
                  <select name='rtn_run_amt_yn'>        
                    <option value="">선택</option>                      
                    <option value="0" <%if(fee_etc.getRtn_run_amt_yn().equals("0")||fee_etc.getRtn_run_amt_yn().equals(""))%>selected<%%>>환급대여료적용</option>
                    <option value="1" <%if(fee_etc.getRtn_run_amt_yn().equals("1"))%>selected<%%>>환급대여료미적용</option>                    
                  </select>
                  <%	}else{ %>
                  <%if(fee_etc.getRtn_run_amt_yn().equals("0")){%>※환급대여료적용<%}else if(fee_etc.getRtn_run_amt_yn().equals("1")){%>※환급대여료미적용<%} %>
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etc.getRtn_run_amt_yn()%>">
                  <%	} %>
                  <%}else{ %>
                  <input type="hidden" name="rtn_run_amt" value="<%=fee_etc.getRtn_run_amt()%>">
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etc.getRtn_run_amt_yn()%>">
                  <%} %>  
                  <br>&nbsp;                
                  (약정초과운행시) 초과운행대여료 <input type='text' name='over_run_amt' size='2' maxlength='20' class='fixnum' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  매입옵션 행사시 환급대여료 : 기본식은 미지급, 일반식은 40%만 지급
                  <%} %>
                  <br>&nbsp;                  
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>만 납부
                  <!-- 
                  초과 1km당 (<input type='text' name='over_run_amt' size='2' maxlength='20' class='fixnum' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원)의 초과운행부담금이 부과됨 (대여종료시)	
                  <br>&nbsp;
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 50%만 납부
                   -->
                  <input type="hidden" name="agree_dist_yn" value="<%=fee_etc.getAgree_dist_yn()%>">                 
                  <br>&nbsp;
                  ※ 약정운행거리 미적용시 약정운행거리에 <input type='text' name='ex_agree_dist' size='5' class='fixnum' value='미적용' >과 같이 입력하면 됩니다.                       
                </td>
              </tr>  
                <tr>                   
                    <td class=title >운전자연령</td>
                    <td>&nbsp;
                        <select name='driving_age'>
                          <option value="">선택</option>
                          <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>만26세이상</option>
                          <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>만24세이상</option>
                          <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>만21세이상</option>
                          <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>모든운전자</option>
					  <option value=''>=피보험자고객=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>만30세이상</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>만35세이상</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>만43세이상</option>						
					  <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>만48세이상</option>					  						  
					  <option value='9' <%if(base.getDriving_age().equals("9")){%>selected<%}%>>만22세이상</option>					  						  
					  <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>만28세이상</option>					  						  
					  <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>만35세이상~만49세이하</option>					  						  
                      </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a></td>                
                </tr>                   
                <tr>
                    <td class=title>대물배상</td>
                    <td class=''>&nbsp;
                        <select name='gcp_kd'>
                          <option value="">선택</option>
                          <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                          <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1억원</option>
						  <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2억원</option>
						  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3억원</option>
                          <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5억원</option>						  
                      </select></td>
              </tr>  
            </table>
         </td>
     </tr>
    <tr>
        <td class=h></td>
    </tr>
     <tr id=tr_2 style='display:none'>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="3" class='title'>구분</td>
                    <td class='title' width='11%'>공급가</td>
                    <td class='title' width='11%'>부가세</td>
                    <td class='title' width='13%'>합계</td>
                    <td class='title' width='4%'>입금</td>
                    <td class='title' width="28%">계약조건</td>
                    <td class='title' width='20%'>정상조건</td>
                </tr>
                <% String pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0"); %>
                <tr>
                    <td width="3%" rowspan="5" class='title'>선<br>
                      수</td>
                    <td width="10%" class='title' colspan="2">보증금</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='12' maxlength='10' name='grt_s_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' class='num'  onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_gur_p_per' class='fixnum' value='<%=fees.getF_gur_p_per()%>' readonly>
    				            %
    				            
        				    </td>
                    <td align='center'>					
        				<input type='hidden' name='grt_suc_yn' value='<%= fees.getGrt_suc_yn() %>'>-        				
        				<input type='hidden' name='gur_per' value=''>
        				<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'></td>
                </tr>
                <%  pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1"); %>
                <tr>
                    <td class='title' colspan="2">선납금</td>
                    <td align="center"><input type='text' size='12' name='pp_s_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' class='fixnum' readonly onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='12' name='pp_v_amt' maxlength='10' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' class='fixnum' readonly  onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='12' name='pp_amt'   maxlength='11' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='pere_r_per' class='fixnum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % 
        				&nbsp;&nbsp;&nbsp;신차의
    				    <input type='text' size='4' name='f_pere_r_per' class='fixnum' value='<%=fees.getF_pere_r_per()%>' readonly>
    				      %      				           
        			</td>
                    <td align='center'><input type='hidden' name='pere_per' value=''><input type='hidden' name='pp_chk' value='<%=fees.getPp_chk()%>'></td>
                </tr>
                <%  pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2"); %>
                <tr>
                    <td class='title' colspan="2">개시대여료</td>
                    <td align="center"><input type='text' size='12' name='ifee_s_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' class='fixnum' readonly onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='12' name='ifee_v_amt' maxlength='10'  value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' class='fixnum' readonly onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='12' name='ifee_amt' maxlength='11'  value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' class='fixnum'  readonly onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">마지막
                        <input type='text' size='2' name='pere_r_mth' class='fixnum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  개월치 대여료         				  
        			</td>
                    <td align='center'>
        				<input type='hidden' name='ifee_suc_yn' value='<%= fees.getIfee_suc_yn() %>'>
        			    <input type='hidden' name='pere_mth' value=''>
        			</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">합계</td>
                    <td align="center"><input type='text' size='12' name='tot_pp_s_amt' maxlength='11' class='fixnum' readonly onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='12' name='tot_pp_v_amt' maxlength='10' class='fixnum' readonly onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='12' name='tot_pp_amt' maxlength='11' class='fixnum' readonly onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center"></td>
                    <td align='center'>&nbsp;</td>
                </tr>
                <tr>
        	    <td class='title' colspan="2">총채권확보</td>
                    <td colspan='3'>&nbsp;</td>				
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='<%=fees.getCredit_r_per()%>' readonly>%
        			<input type='text' size='12' name='credit_r_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>원(보증보험포함)</td>
                    <td align='center'><input type='text' size='4' name='credit_per' class='fixnum' value='<%=fees.getCredit_per()%>' readonly>%
        			<input type='text' size='12' name='credit_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_amt())%>' readonly>원</td>
                </tr>
            </table>
         </td>
     </tr>
    <tr>
        <td class=h></td>
    </tr>
    <!-- 안보임 -->
     <tr id=tr_1 style='display:none'>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                                
                <tr>
                    <td rowspan="4" class='title'>잔<br>
                      가</td>
                    <td class='title' colspan="2">표준 최대잔가</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='b_max_ja' maxlength='10' class='fixnum' value='<%=fees.getB_max_ja()%>'>
        			  % </td>
                    <td align='center'>                        
                        <input type='text' name='e_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' >km/1년                        
                    </td>
                </tr>                
                <tr>
                    <td class='title' colspan="2">조정 최대잔가</td>
                    <td align="center"><input type='text' size='12' name='ja_s_amt' readonly maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='12' name='ja_v_amt' readonly maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='12' name='ja_amt' readonly maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='max_ja' maxlength='10' readonly class='fixnum' value='<%=fees.getMax_ja()%>'>
        			  % </td>
                    <td align='center'>
                                  <input type='text' name='r_agree_dist' size='6' class='fixnum' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' >km/1년
        			</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">매입옵션</td>
                    <td align="center"><input type='text' size='12' name='opt_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='12' name='opt_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='12' name='opt_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='opt_per' class='defaultnum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_opt_per' class='defaultnum' value='<%=fees.getF_opt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
    				            %  
        				    </td>
                    <td align='center'>
        			  <input type='radio' name="opt_chk" value='0' <%if(fees.getOpt_chk().equals("0")){%> checked <%}%> onClick="javascript:opt_display('0', <%=fees.getRent_dt()%>)">
                      없음
                      <input type='radio' name="opt_chk" value='1' <%if(fees.getOpt_chk().equals("1")){%> checked <%}%> onclick="javascript:opt_display('1', <%=fees.getRent_dt()%>)">
        	 		  있음
                    </td>
                </tr>
                <%if(fee_etc.getReturn_select().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차제외 %>
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
                    <td align="center"><input type='text' size='12' name='ja_r_s_amt' readonly maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='12' name='ja_r_v_amt' readonly maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='12' name='ja_r_amt' readonly maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='app_ja' maxlength='10' readonly class="fixnum" value='<%=fees.getApp_ja()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}%>
                <tr>
                    <td rowspan="6" class='title'>대<br>여<br>료</td>
                    <td class='title' colspan="2">계약요금</td>
                    <td align="center" ><input type='text' size='12'  name='fee_s_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='12'  name='fee_v_amt' maxlength='9' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='12'  name='fee_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'></td>
                </tr>
                <!-- 운전자추가요금/월보험료(고객피보험) 적용 (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">정<br>상<br>대<br>여<br>료</td>
                    <td class='title'>정상요금</td>
                    <td align="center" ><input type='text' size='12' name='inv_s_amt' readonly maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='12' name='inv_v_amt' readonly maxlength='9' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='12' maxlength='10' readonly name='inv_amt' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">
                    	<%if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4"))){//전기차,수소차%>
                    	<input type="hidden" name="ecar_pur_sub_yn" value="N"> 
                    	<%}%>
                    </td>
                    <td align='center'>&nbsp;
        			        <span class="b"><a href="javascript:estimate('<%=fees.getRent_st()%>', '<%=base.getReg_dt()%>', '<%=fees.getRent_start_dt()%>', 'account')" onMouseOver="window.status=''; return true" title="견적하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>	
                    </td>
                </tr>
                <tr>
                    <td class='title'>월보험료(고객피보험)</td>
                    <td align="center" ><input type='text' size='12'  name='ins_s_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='12'  name='ins_v_amt' maxlength='9' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='12'  name='ins_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt()+fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">&nbsp;월보험료(공급가) = 년간보험료
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 원/12</td>
                    <td align='center'></td>
                </tr>
                <tr>
	                <td class='title'>운전자추가요금</td>
	                <td align='center' >
	                	<input type='text' size='12' name='driver_add_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원 
	                </td>
	                <td align="center" >
	                	<input type='text' size='12' name='driver_add_v_amt'  maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
	                </td>
	                <td align='center' >
	                	<input type='text' size='12' maxlength='10'  name='driver_add_total_amt' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
	                </td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	            </tr>
	            <tr>
                    <td class='title'>정상요금 합계</td>
                    <td align='center' >
                    	<input type='text' size='12' name='tinv_s_amt' maxlength='11' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getIns_s_amt() + fee_etc.getDriver_add_amt())%>'> 원 
                    </td>
                    <td align="center" >
                       	<input type='text' size='12' name='tinv_v_amt'  maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_v_amt() + fees.getIns_v_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center' >
                    	<input type='text' size='12' maxlength='10'  name='tinv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getInv_v_amt() + fees.getIns_s_amt() + fees.getIns_v_amt() + fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>
                <input type='hidden' name='ctr_s_amt' 	value='<%=fees.getFee_s_amt()-fees.getInv_s_amt() %>'>    
                <input type='hidden' name='ctr_v_amt' 	value='<%=fees.getFee_v_amt()-fees.getInv_v_amt() %>'>
        		<tr>
	                <td class='title' colspan="2">대여료DC</td>
	                <td colspan='3'>&nbsp; </td>                    
	                <td align='center'>-</td>            
	                <td align="center"></td>
	                <td align='center'>
	                    DC율 <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value='<%=fees.getDc_ra()%>'>%
                    DC금액 <input type='text' size='6' name='dc_ra_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt()+fees.getIns_s_amt()+fees.getIns_v_amt()+fee_etc.getDriver_add_amt()+fee_etc.getDriver_add_v_amt()-fees.getFee_s_amt()-fees.getFee_v_amt())%>'>
	        				  원
	                </td>
              </tr>                    
                <tr>
                    <td rowspan="2" class='title'>기<br>
                      타</td>                     
                    <td class='title' colspan="2" style="font-size : 8pt;">중도해지위약율</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">잔여기간 대여료의
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=fees.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='<%=fees.getCls_per()%>'>%
						,필요위약금율[<input type='text' size='3' name='cls_n_per' maxlength='10' class='fixnum' value='<%=fees.getCls_n_per()%>'>%]
						</font></span></td>
                </tr>	
                <tr>
                    <td class='title' colspan="2">영업수당</td>
                    <td colspan="2" align="center"></td>
                    <td align='center'></td>
                    <td align='center'>-</td>
                    <td align="center">
                        <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='defaultnum' onBlur='javascript:setCommi()'>
        		      %</td>
                    <td align='center'>
        				        <input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='fixnum' <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id)){%><%}else{%>readonly<%}%>>
        			  %</td>
                </tr>
 	            <%if(ej_bean.getJg_g_7().equals("3")){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차제외 %>
                <tr>
                    <td colspan="3" class='title'>전기차 인수/반납 유형</td>
                    <td colspan="6">&nbsp;
                    	<select name='return_select'>
                        <option value=''>선택</option>
                        <option value='0' <%if(fee_etc.getReturn_select().equals("0")){%>selected<%}%>>인수/반납 선택형</option>
                        <option value='1' <%if(fee_etc.getReturn_select().equals("1")){%>selected<%}%>>반납형</option>
                    	</select>
                    </td>
                </tr>		
                <%}%>
            </table>			  				
	    </td>
    </tr>	
    <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("엑셀견적관리자",user_id)){ %>
    <tr>
		<td align="right">
		
		  ( 계약요금 - 정상요금 = <%=AddUtil.parseDecimal(fees.getFee_s_amt()+ fees.getFee_v_amt()-fees.getInv_s_amt()-fees.getInv_v_amt())%> )
		
		<a href="javascript:view_car_esti_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a></td>
	</tr>	
    <%} %>		
		
    <% int u_chk = 0;%>
    
    <%if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계") && !String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>
    
	    <%if(base.getCar_gu().equals("1") && pur.getOne_self().equals("")){ u_chk++;%>
			<tr>
	  	  <td><font color=red>출고구분이 없습니다.</font></td>
			<tr>	
  	  <%}%>	
    	<%if(car.getPurc_gu().equals("")){ u_chk++;%>
			<tr>
		    <td><font color=red>과세구분이 없습니다.</font></td>
			<tr>
			<%}%>
  	  <%if(base.getDriving_age().equals("")){ u_chk++;%>
			<tr>
		    <td><font color=red>운전자연령이 없습니다.</font></td>
			<tr>
			<%}%>
			
		<%}%>
		
	
	<%if(cnt3==0){ %>
    <tr> 
      <td align=center colspan="2">
         <input type="button" class="button" value="계산하기" onclick="javascript:estimate('<%=fees.getRent_st()%>', '<%=base.getReg_dt()%>', '<%=fees.getRent_start_dt()%>', 'account');">      
      </td>
    </tr>		
    <%} %>
	<tr>
	    <td>
    		<table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>
        			<td>
        			  <iframe src="about:blank" name="inner" width="100%" height="600" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
        			</td>
    		    </tr>
    		</table>
	    </td>
	</tr>    
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
  sum_pp_amt();
//-->
</script>
</body>
</html>
