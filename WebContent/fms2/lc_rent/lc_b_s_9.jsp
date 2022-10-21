<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.user_mng.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase"	scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	

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
	}
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	if(fee_size > 1) rent_st = Integer.toString(fee_size);
		
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String o_3 = edb.getEstiSikVarCase("1", "", "o_3");
	
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
		if(get_length(f)>max_len){alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');}
	}
	//자동차출고가격 
	function update_car_f_amt(){
		window.open("/acar/car_register/register_pur_id.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "CAR_F_AMT", "left=10, top=10, width=1010, height=300, scrollbars=yes, status=yes, resizable=yes");
	}	
	//등록/수정: 차량가격 입력시 자동계산으로 가게..
	function enter_car(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_car_amt(obj);
	}	
	//등록/수정: 공급가, 부가세, 합계 입력시 자동계산
	function set_car_amt(obj)
	{
		var fm = document.form1;
		obj.value = parseDecimal(obj.value);
		if(obj==fm.car_cs_amt){//차량기본가격 공급가
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) * 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cs_amt){//선택사항 공급가
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) * 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cs_amt){//색상 공급가
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) * 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.sd_cs_amt){//탁송료 공급가
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) * 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
		}else if(obj==fm.dc_cs_amt){//매출DC 공급가
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) * 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));
		}else if(obj==fm.car_fs_amt){//면세차량가격 공급가
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) * 0.1 );
			fm.car_f_amt.value	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));
		}else if(obj==fm.tax_dc_s_amt){//친환경차 개소세 감면액 공급가
			fm.tax_dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) * 0.1 );
			fm.tax_dc_amt.value		= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));
		}else if(obj==fm.car_cv_amt){//차량기본가격 부가세
			fm.car_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) / 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cv_amt){//선택사항 부가세
			fm.opt_cs_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cv_amt.value)) / 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cv_amt){//색상 부가세
			fm.col_cs_amt.value = parseDecimal(toInt(parseDigit(fm.col_cv_amt.value)) / 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.sd_cv_amt){//탁송료 부가세
			fm.sd_cs_amt.value = parseDecimal(toInt(parseDigit(fm.sd_cv_amt.value)) / 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
		}else if(obj==fm.dc_cv_amt){//매출DC 부가세
			fm.dc_cs_amt.value = parseDecimal(toInt(parseDigit(fm.dc_cv_amt.value)) / 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));
		}else if(obj==fm.car_fv_amt){//면세차량가격 부가세
			fm.car_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) / 0.1 );
			fm.car_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));
		}else if(obj==fm.tax_dc_v_amt){//친환경차 개소세 감면액 부가세
			fm.tax_dc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_v_amt.value)) / 0.1 );
			fm.tax_dc_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));
		}else if(obj==fm.car_c_amt){//차량기본가격 합계
			fm.car_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_cs_amt.value)));
		}else if(obj==fm.opt_c_amt){//선택사항 합계
			fm.opt_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.opt_cs_amt.value)));
		}else if(obj==fm.col_c_amt){//색상 합계
			fm.col_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.col_cs_amt.value)));
		}else if(obj==fm.sd_c_amt){//탁송료 합계
			fm.sd_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.sd_cs_amt.value)));
		}else if(obj==fm.dc_c_amt){//매출DC 합계
			fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));
		}else if(obj==fm.car_f_amt){//면세차량가격 합계
			fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_fs_amt.value)));
		}else if(obj==fm.tax_dc_amt){//친환경차 개소세 감면액 합계
			fm.tax_dc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.tax_dc_v_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		}
		sum_tax_amt();
		sum_car_c_amt();
		sum_car_f_amt();
	}
	//차량 특소세 자동계산
	function set_tax_amt(obj){
		var fm = document.form1;
		obj.value = parseDecimal(obj.value);
		if(obj==fm.spe_tax){//특소세
			fm.edu_tax.value = parseDecimal(toInt(parseDigit(obj.value))*(30/100));
		}
		fm.tot_tax.value = parseDecimal(toInt(parseDigit(fm.spe_tax.value)) + toInt(parseDigit(fm.edu_tax.value)) );
	}
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
	//차량 특소세 합계
	function sum_tax_amt(){
		var fm = document.form1;
		if(toInt(parseDigit(fm.car_f_amt.value)) == 0){	sum_car_f_amt(); }
		var purc_gu = fm.purc_gu.value;
		var car_st = <%=base.getCar_st()%>;
		var s_st = fm.s_st.value;
		var dpm = fm.dpm.value;
		var car_c_price = setCarPrice('car_c_price');
		var car_f_price = setCarPrice('car_f_price');
		var a_e = toInt(s_st);
		setVar_o_123(car_f_price);
		if(purc_gu == '1'){//과세1
			fm.tot_tax.value = parseDecimal(car_c_price-toInt(fm.v_o_3.value));
			fm.pay_st[1].selected = true;
		}else{//과세2(면세) 
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
				fm.tot_tax.value = parseDecimal(Math.round(toInt(fm.v_o_1.value)*toFloat(fm.v_o_2.value)));
			}else{
				fm.tot_tax.value = parseDecimal(car_c_price-toInt(parseDigit(fm.car_f_amt.value)));
			}
			fm.pay_st[2].selected = true;
		}
		fm.spe_tax.value 	= parseDecimal(toInt(parseDigit(fm.tot_tax.value))/6.5*5);
		fm.edu_tax.value 	= parseDecimal(toInt(parseDigit(fm.tot_tax.value)) - toInt(parseDigit(fm.spe_tax.value)) );
	}
	//차량 소비자가 합계
	function sum_car_c_amt(){
		var fm = document.form1;
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );
	}
	//차량 구입가 합계
	function sum_car_f_amt(){
		var fm = document.form1;
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );
	}

	//차가 구입가 합계
	function sum_car_f_amt2(){
		var fm = document.form1;
		var purc_gu = fm.purc_gu.value;
		var car_st = <%=base.getCar_st()%>;
		var s_st = fm.s_st.value;
		var dpm = fm.dpm.value;
		var car_price = setCarPrice('car_c_price');
		if(fm.dc_cs_amt.value == '' && fm.dc_c_amt.value != '0') set_car_amt(fm.dc_c_amt);
		fm.car_fs_amt.value = parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)));
		fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.tot_cv_amt.value)));
		fm.car_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_c_amt.value)));
		if(purc_gu == ''){	alert("과세구분을 선택하십시오."); return; }
		if(purc_gu == '1'){//과세1
		}else{//과세2(면세)
      //수입차
			if('<%=ej_bean.getJg_w()%>'=='1'){
				fm.car_f_amt.value  = parseDecimal(<%=cm_bean.getCar_b_p2()%>);
				fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.car_f_amt.value))));
				fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_fs_amt.value)));
			}else if('<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				setVar_o_123(car_price);
				fm.car_f_amt.value  = parseDecimal(toInt(fm.v_o_3.value));
				fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.car_f_amt.value))));
				fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_fs_amt.value)));
			}
		}
		sum_car_f_amt();
		sum_tax_amt();
	}
	//매출DC
	function search_dc(){
		window.open("search_dc.jsp?rent_mng_id="+document.form1.rent_mng_id.value+"&rent_l_cd="+document.form1.rent_l_cd.value+"&car_fs_amt="+document.form1.car_fs_amt.value+"&car_fv_amt="+document.form1.car_fv_amt.value, "COMP_DC", "left=100, top=100, height=200, width=800, scrollbars=yes, status=yes");
	}
	//차량가격 가져가기
	function setCarPrice(st){
		var fm = document.form1;
		var car_price = 0;
		if(st == 'car_c_price')		car_price = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));
		if(st == 'car_price2')		car_price	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value));
		if(st == 'car_f_price')		car_price = toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
		//수입차DC는 제외
		if(st == 'car_f_price' && <%=base.getRent_dt()%> >= 20130501 && '<%=ej_bean.getJg_w()%>'=='1'){
			car_price 	= toInt(parseDigit(fm.car_f_amt.value));
		}
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
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
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

	//수정
	function update(idx){
		var fm = document.form1;
		if(<%=base.getRent_dt()%> > 20070831){

				if(fm.car_gu.value == '1'){//신차
					var car_c_amt = toInt(parseDigit(fm.car_c_amt.value));
					var car_f_amt = toInt(parseDigit(fm.car_f_amt.value));
					if(fm.purc_gu.value == ''){alert('차량가격-과세구분을 입력하십시오.');fm.purc_gu.focus();return;}
					if(car_c_amt == 0){alert('차량가격-소비자가 기본가격을 입력하십시오.');	fm.car_c_amt.focus();return;}
					if(car_f_amt == 0){alert('차량가격-구입가 차량가격을 입력하십시오.');fm.car_f_amt.focus();return;}
					
					<%if(!nm_db.getWorkAuthUser("출고일자등록",user_id) && !ej_bean.getJg_w().equals("1")){//수입차제외%>
					var chk_car_amt1 = Math.abs(toInt(parseDigit(fm.o_car_c_amt.value))-toInt(parseDigit(fm.car_c_amt.value)));
					if(chk_car_amt1 > 50000){
						alert('차량가격 소비자가 기본가격 수정 변동값이 ±50,000원이 넘습니다. 확인하십시오.');
						return;
					}
					var chk_car_amt2 = Math.abs(toInt(parseDigit(fm.o_car_f_amt.value))-toInt(parseDigit(fm.car_f_amt.value)));
					if(toInt(parseDigit(fm.car_f_amt.value)) > 0 && chk_car_amt2 > 50000){
						alert('차량가격 구입가격 수정 변동값이 ±50,000원이 넘습니다. 확인하십시오.');
						return;
					}	
					<%}%>
				}
		}
		//계약서상 제조사 할인후 차량가격 표기여부, 신차만. (20190911)
		<%if(base.getCar_gu().equals("1") && fee_size<=1){%>
			if(fm.dc_view_yn.checked==true){
				if(fm.view_car_dc.value==""||fm.view_car_dc.value==0){
					alert("전자 계약서상 제조사 할인 후 차량가격 병행 표기 여부 체크!\n\n-> [제조사 할인 후 차량가격] 을 입력해주세요.");	fm.view_car_dc.focus();	return;
				}
			}else{
				fm.view_car_dc.value="";
			}
		<%}%>
		
		fm.idx.value = idx;
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_b_s_a.jsp';		
			fm.target='_self';
			fm.submit();
		}
	}
	
	//제조사 할인 후 차량가격표기 폼
	function span_dc_view(){
		var fm = document.form1;
		if(fm.dc_view_yn.checked==true){	$("#span_dc_view").css("display","");				}
		else{												$("#span_dc_view").css("display","none");		}
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

<form action='lc_b_s_a.jsp' name="form1" method='post'>
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
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_9.jsp'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="opt"			value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"			value="<%=AddUtil.replace(cm_bean.getCar_b()," ","")%><%=AddUtil.replace(cm_bean2.getCar_b()," ","")%>">
  <input type='hidden' name="s_st" 			value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="dpm" 			value="<%=cm_bean.getDpm()%>">
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
  <input type='hidden' name="fin_seq" 			value="">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">      
  <input type='hidden' name="gur_size"			value="">     
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
    
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">    
  <input type='hidden' name="est_from"			value="lc_b_u">
  <input type='hidden' name="fee_opt_amt"		value="">  
  <input type='hidden' name="rent_mng_id2"		value="">    
  <input type='hidden' name="rent_l_cd2"		value="">      
  <input type='hidden' name="fee_rent_st"		value="<%=rent_st%>">        
  <input type='hidden' name="fee_rent_dt"		value="">          
  <input type='hidden' name="ins_chk1"			value="">        
  <input type='hidden' name="ins_chk2"			value="">          
  <input type='hidden' name="ins_chk3"			value="">            
  <input type='hidden' name="ins_chk4"			value="">            
  <input type='hidden' name="ins_chk5"			value="">            
  <input type='hidden' name="now_stat"			value="<%=now_stat%>">            
  <input type='hidden' name="v_o_1"			value="">
  <input type='hidden' name="v_o_2"			value="">
  <input type='hidden' name="v_o_3"			value="">
  <input type='hidden' name="car_cng_yn"		value="<%=cont_etc.getCar_cng_yn()%>">
  <input type='hidden' name="add_opt_amt"		value="<%=car.getAdd_opt_amt()%>">  
  <input type='hidden' name="extra_amt"			value="<%=car.getExtra_amt()%>">  
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>미결계약</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
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
    <tr id=tr_car1 style="display:<%if(!base.getCar_gu().equals("0")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>과세구분</td>
                    <td colspan="3">&nbsp;
                      <select name="purc_gu">
                        <option value=''>선택</option>
                        <option value='1' <%if(car.getPurc_gu().equals("1")){%> selected <%}%>>과세</option>
                        <option value='0' <%if(car.getPurc_gu().equals("0")){%> selected <%}%>>면세</option>
                      </select></td>
                    <td class='title'>출처</td>
                    <td colspan="3">&nbsp;
        			  <%String car_origin = car.getCar_origin();%>
        			  <%if(car_origin.equals("")){
        			  		if(!cm_bean.getCar_comp_id().equals("")){
        						code_bean = c_db.getCodeBean("0001", cm_bean.getCar_comp_id(), "");
        					}
        					car_origin = code_bean.getApp_st();
        				}%>
        			<select name="car_origin">
                        <option value="">선택</option>
                        <option value="1" <%if(car_origin.equals("1")){%> selected <%}%>>국산</option>
                        <option value="2" <%if(car_origin.equals("2")){%> selected <%}%>>수입</option>
                      </select></td>
                </tr>
                <tr>
                    <td width="13%" rowspan="2" class='title'>구분 </td>
                    <td colspan="3" class='title'>소비자가격</td>
                    <td width="10%" rowspan="2" class='title'>구분</td>
                    <td colspan="3" class='title'>구입가격<a href="javascript:update_car_f_amt()"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a></td>
                </tr>
                <tr>
                    <td width="13%" class='title'>공급가</td>
                    <td width="13%" class='title'>부가세</td>
                    <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_c_amt()" onMouseOver="window.status=''; return true" title="소비자가 합계 계산하기">합계</a></span></td>
                    <td width="13%" class='title'>공급가</td>
                    <td width="12%" class='title'>부가세</td>
                    <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_f_amt()" onMouseOver="window.status=''; return true" title="구입가 합계 계산하기">합계</a></span>&nbsp;<span class="b"><a href="javascript:sum_car_f_amt2()" onMouseOver="window.status=''; return true" title="구입가 계산하기">계산</a></span></td>
                </tr>
                <tr>
                    <td class='title'> 기본가격</td>
                    <td>&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title>차량가격</td>
                    <td>&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                </tr>
                <input type="hidden" name="o_car_c_amt" value="<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>">
                <input type="hidden" name="o_car_f_amt" value="<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>">
                <tr>
                    <td height="12" class='title'>옵션</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title>탁송료</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                </tr>
                <tr>
                    <td height="26" class='title'> 색상</td>
                    <td>&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title><span class="b"><a href="javascript:search_dc()" onMouseOver="window.status=''; return true" title="클릭하세요">매출D/C</a></span></td>
                    <td>&nbsp;
                      <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' readonly maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				원</td>
                    <td>&nbsp;
                      <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' readonly maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				원</td>
                    <td>&nbsp;
                      <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' readonly maxlength='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				원</td>
                </tr> 
              <tr id=tr_ecar_dc <%if(base.getDlv_dt().equals("") || car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//친환경차%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'>개소세 감면액</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>                       
                <tr>
                    <td align="center" class='title_p'>합계</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
        			    원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
        				원</td>
                    <td align='center' class='title_p'>합계</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  readonly>
        				원</td>
                </tr>
                <tr>
                    <td class='title'>납부여부</td>
                    <td>&nbsp;
                      <select name='pay_st'>
                        <option value="">선택</option>
                        <option value="1" <%if(car.getPay_st().equals("1")){%> selected <%}%>>과세</option>
                        <option value="2" <%if(car.getPay_st().equals("2")){%> selected <%}%>>면세</option>
                      </select>
                    </td>
                    <td class='title'><a href="javascript:sum_tax_amt()" onMouseOver="window.status=''; return true" title="구입가 합계 계산하기">특소세</a></td>
                    <td >&nbsp;
                      <input type='text' name='spe_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
        				원</td>
                    <td class='title'>교육세</td>
                    <td >&nbsp;
                      <input type='text' name='edu_tax' size='10' value='<%=AddUtil.parseDecimal(car.getEdu_tax())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
        				원</td>
                    <td class='title'>합계</td>
                    <td >&nbsp;
                      <input type='text' name='tot_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax()+car.getEdu_tax())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'>
        				원</td>
                </tr>
            </table>		
	    </td>
    </tr>
    <%if(ej_bean.getJg_w().equals("1")){//수입차%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수입차 견적시 적용</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>카드결제금액</td>
                    <td width="27%">&nbsp;
                        <input type='text' name='import_card_amt' value='<%= AddUtil.parseDecimal(car.getImport_card_amt())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    </td>
                    <td width="10%" class='title'>Cash Back금액</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='import_cash_back' value='<%= AddUtil.parseDecimal(car.getImport_cash_back())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
        	    </td>	
        	    <td width="10%" class='title'>탁송썬팅비용등</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='import_bank_amt' value='<%= AddUtil.parseDecimal(car.getImport_bank_amt())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
        	    </td>	

                </tr>
            </table>
	    </td>
    </tr>      
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수입차 실발생 금액</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>-</td>
                    <td width="27%">&nbsp;                        
                    </td>
                    <td width="10%" class='title'>Cash Back금액</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='r_import_cash_back' value='<%= AddUtil.parseDecimal(car.getR_import_cash_back())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
        	    </td>	
        	    <td width="10%" class='title'>탁송썬팅비용등</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='r_import_bank_amt' value='<%= AddUtil.parseDecimal(car.getR_import_bank_amt())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
        	    </td>	

                </tr>
            </table>
	    </td>
    </tr>          
    <%}%> 
    <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//친환경차%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>친환경차</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>구매보조금</td>
                    <td width="27%">&nbsp;
                        <input type='text' name='ecar_pur_sub_amt' value='<%= AddUtil.parseDecimal(car.getEcar_pur_sub_amt())%>' size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    </td>
                    <td width="10%" class='title'>보조금수령방식</td>
                    <td>&nbsp;
        		            <select name='ecar_pur_sub_st'  <%if(nm_db.getWorkAuthUser("전산팀",user_id)||nm_db.getWorkAuthUser("계약변경관리",user_id)||nm_db.getWorkAuthUser("엑셀견적관리자",user_id)){%><%}else{%>disabled<%}%>>
        		            	<option value="">선택</option>
                          <option value="1" <%if(car.getEcar_pur_sub_st().equals("1")){%> selected <%}%>>제조사 차량대금 공제</option>
                          <option value="2" <%if(car.getEcar_pur_sub_st().equals("2")){%> selected <%}%>>아마존카 직접 수령</option>
                        </select> 
                        <input type='hidden' name="h_ecar_pur_sub_amt"	value="<%=car.getEcar_pur_sub_amt()%>">
                        <input type='hidden' name="h_ecar_pur_sub_st"		value="<%=car.getEcar_pur_sub_st()%>">
        	          </td>	                    
                </tr>
            </table>
	    </td>
    </tr>                 
    <%}%>
    <!-- 제조사 할인 후 차량가격 표시(20190911)- 신차이고 신규/증차/대차계약인 경우만 -->
    <%if(base.getCar_gu().equals("1") && fee_size<=1){ %>
    <tr>
  		<td>
  			<font color="#666666">* 전자 계약서상 제조사 할인 후 차량가격 병행 표기 여부</font>
  			<input type="checkbox" name="dc_view_yn" id="dc_view_yn" <%if(cont_etc.getView_car_dc()!=0){%>checked<%}%> onclick="javascript:span_dc_view();">&nbsp;&nbsp;&nbsp;
  			<span id="span_dc_view" style="display:<%if(cont_etc.getView_car_dc()==0){%> none<%}else{%><%}%>;">
  				<font color="#666666">제조사 할인 후 차량가격 
  					<input type="text" size="10" name="view_car_dc" value="<%=cont_etc.getView_car_dc()%>" onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown='javascript:enter_car(this)'>원
  				</font>
  			</span>
  		</td>
  	</tr>
  	<%}%>                           
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||   auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('9')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
	<tr>	
</table>
  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
	var fm = document.form1;

/*
<%if(base.getDlv_dt().equals("") || car.getTax_dc_s_amt()==0){//친환경차%>
	//신차
	if(fm.car_gu.value == '1'){
		//개소세감면액
		var ch_327 = 0;		
		var ch_315 = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value)); 
		var ch_326 = ch_315/(1+<%=ej_bean.getJg_3()%>);
		var bk_122 = 0;
		<%if(!ej_bean.getJg_w().equals("1")){%>
		<%	if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
		if(<%=ej_bean.getJg_3()%>*100 > 0){
			if('<%=ej_bean.getJg_g_7()%>'=='1') bk_122 = 1300000;
			if('<%=ej_bean.getJg_g_7()%>'=='2') bk_122 = 1300000;
			if('<%=ej_bean.getJg_g_7()%>'=='3') bk_122 = 3900000;
			if('<%=ej_bean.getJg_g_7()%>'=='4') bk_122 = 5200000;
			if(ch_315-ch_326<bk_122*1.1) 	ch_327 = ch_315-ch_326;
			else                         	ch_327 = bk_122*1.1;
			ch_327 = getCutRoundNumber(ch_327,0);
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111')	ch_327 = 0;//볼트EV
			if('<%=cm_bean.getJg_code()%>'=='9133' || '<%=cm_bean.getJg_code()%>'=='9015435' || '<%=cm_bean.getJg_code()%>'=='9015436' || '<%=cm_bean.getJg_code()%>'=='9015437')	ch_327 = 0;//포터일렉
			fm.tax_dc_amt.value 	= parseDecimal(ch_327);
			set_car_amt(fm.tax_dc_amt);
		}
  		<%	}%>
  		<%}%>		
		//개소세 한시적 감면 20200301~20200630
		var bk_175 = 0.7;     //감면율
		var bk_176 = 1430000; //개소세 감면 한도(교육세포함,부가세포함)
		var bk_177 = 0;
		<%if(!ej_bean.getJg_w().equals("1")){ //수입차제외%>
		<%		if(cm_bean.getDuty_free_opt().equals("1")){//면세가표기차량 제오%>
		<%		}else{%>
					if(ch_315<33471429){
						bk_177 = ch_326*<%=ej_bean.getJg_3()%>*bk_175;	
					}else{
						bk_177 = bk_176;
					}
					bk_177 = getCutRoundNumber(bk_177,-4);
					if('<%=cm_bean.getJg_code()%>'=='2361' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='5033111')	bk_177 = 0;//볼트EV
		<%		}%>
		<%}%>
		
		<%	if(base.getDlv_dt().equals("")){
				base.setDlv_dt("99999999");
			}
		%>
		
		if(<%=base.getRent_dt()%> > 20200630 || '<%=base.getDlv_dt()%>' == '' || <%=base.getDlv_dt()%> > 20200630 ){
			//20200701 감면종료
			bk_177 = 0;
		}
		
		//감면 미적용 개별소비세(인하한도 초과금액) 20210101~20210630**********************
	  	var bk_216 = 0;
	  	<%if(!ej_bean.getJg_w().equals("1")){ //수입차제외%>
	  	<%		if(cm_bean.getDuty_free_opt().equals("1")){//면세가표기차량 제오%>
	  	<%		}else{%>
					if(ch_315-ch_326>0 && (ch_326/1.1)>66666666){
						bk_216 = ((ch_326/1.1)-66666666)*0.0195*1.1;	
					}	    					
					bk_216 = getCutRoundNumber(bk_216,-4);						
	  	<%		}%>
	  	<%}%>
		
		var ch327Nbk177 = ch_327;
  	
  		if(bk_177>0){
  			if(ch_315-ch_326<bk_177+(bk_122*1.1)) 	ch327Nbk177 = ch_315-ch_326;
			else                         			ch327Nbk177 = bk_177+(bk_122*1.1);
  			
  			fm.tax_dc_amt.value 	= parseDecimal(ch327Nbk177);
			set_car_amt(fm.tax_dc_amt);
			tr_ecar_dc.style.display	= '';
  		}
  		if(bk_216>0){
  	  		if(ch_315-ch_326<-bk_216+(bk_122*1.1)) 	ch327Nbk177 = ch_315-ch_326;
  			else                         			ch327Nbk177 = -bk_216+(bk_122*1.1);
  	  		
  	  		fm.tax_dc_amt.value 	= parseDecimal(ch327Nbk177);
  			set_car_amt(fm.tax_dc_amt);
  			tr_ecar_dc.style.display	= '';  		
  	  	}
  		if(bk_177+bk_216==0 && fm.tax_dc_amt.value != 0){
  			fm.tax_dc_amt.value 	= parseDecimal(ch327Nbk177);
			set_car_amt(fm.tax_dc_amt);
  		}
  		
	}
	<%}%>
*/	
	sum_car_c_amt();
	sum_car_f_amt();
	
	//반올림
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}
//-->
</script>
</body>
</html>
