<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_office.*, card.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//자동차기본정보-기본차량
	CarMstBean cm_bean2 = new CarMstBean();
	if(!cm_bean.getCar_b_inc_id().equals("")){
		cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	}
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
		
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//연대보증인정보
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	
	//영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//출고영업소정보
	CarOffBean co_bean = new CarOffBean();
	if(!emp2.getCar_off_id().equals("")){
		co_bean = cod.getCarOffBean(emp2.getCar_off_id());
	}
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//사전계출계약
	CarOffPreBean cop_bean = cop_db.getCarOffPreCont(rent_l_cd);
	
	//금융사리스트
	CodeBean[] banks2 = c_db.getCodeAll("0003");
	int bank_size2 = banks2.length;	
		
	//카드종류 리스트 조회
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();		
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
  	//전기차 고객주소지
  	CodeBean[] code34 = c_db.getCodeAll3("0034");
  	int code34_size = code34.length;	
	
  	//수소차 고객주소지
  	CodeBean[] code37 = c_db.getCodeAll3("0037");
  	int code37_size = code37.length;	
  
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
	
	String o_3 		= edb.getEstiSikVarCase("1", "", "o_3");
	
	String print_car_st_yn = "";
	Hashtable tax_print_car = al_db.getTaxPrintCarStChk(base.getClient_id());
	if(AddUtil.parseInt(String.valueOf(tax_print_car.get("TOT_CNT")))>1 && !client.getPrint_car_st().equals("1") && !client.getPrint_st().equals("1") &&
					      ( cm_bean.getS_st().equals("100") || cm_bean.getS_st().equals("101") || cm_bean.getS_st().equals("409") 
						    || cm_bean.getS_st().equals("601") || cm_bean.getS_st().equals("602") 
							|| cm_bean.getS_st().equals("700") || cm_bean.getS_st().equals("701") || cm_bean.getS_st().equals("702") 
							|| cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("802") 
							|| cm_bean.getS_st().equals("803") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("812") ) 
	 ){//'100','101','601','602','701','702','801','802','803','811','812'	
	 	print_car_st_yn = "Y";
	 }
	 
	//기본DC 가져오기
	String car_d_dt = "";	
	car_d_dt = edb.getDc_b_dt(cm_bean.getCar_comp_id()+""+cm_bean.getCode(), "dc", base.getRent_dt(), cm_bean.getCar_b_dt());
	CarDcBean cd_bean = cmb.getCarDcBaseCase(cm_bean.getCar_comp_id(), cm_bean.getCode(), car_d_dt, cm_bean.getCar_b_dt());	
	
	//이름조회
	int user_idx = 0;

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
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
		window.open("/agent/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step3.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
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
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.car_cs_amt){ 		//차량기본가격 공급가
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) * 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cs_amt){ 	//선택사항 공급가
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) * 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cs_amt){ 	//색상 공급가
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) * 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.sd_cs_amt){ 	//탁송료 공급가
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) * 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
		}else if(obj==fm.dc_cs_amt){ 	//매출DC 공급가
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) * 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));			
		}else if(obj==fm.car_fs_amt){ 	//면세차량가격 공급가
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) * 0.1 );
			fm.car_f_amt.value	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));			
		}else if(obj==fm.tax_dc_s_amt){ 	//친환경차 개소세 감면액 공급가
			fm.tax_dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) * 0.1 );
			fm.tax_dc_amt.value		= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));			
		}

		else if(obj==fm.car_cv_amt){ 	//차량기본가격 부가세
			fm.car_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) / 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cv_amt){ 	//선택사항 부가세
			fm.opt_cs_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cv_amt.value)) / 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cv_amt){ 	//색상 부가세
			fm.col_cs_amt.value = parseDecimal(toInt(parseDigit(fm.col_cv_amt.value)) / 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.sd_cv_amt){ 	//탁송료 부가세
			fm.sd_cs_amt.value = parseDecimal(toInt(parseDigit(fm.sd_cv_amt.value)) / 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
		}else if(obj==fm.dc_cv_amt){ 	//매출DC 부가세
			fm.dc_cs_amt.value = parseDecimal(toInt(parseDigit(fm.dc_cv_amt.value)) / 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));
		}else if(obj==fm.car_fv_amt){ 	//면세차량가격 부가세
			fm.car_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) / 0.1 );
			fm.car_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));
		}else if(obj==fm.tax_dc_v_amt){ 	//친환경차 개소세 감면액 부가세
			fm.tax_dc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_v_amt.value)) / 0.1 );
			fm.tax_dc_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));
		}

		else if(obj==fm.car_c_amt){ 	//차량기본가격 합계
			fm.car_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_cs_amt.value)));			
		}else if(obj==fm.opt_c_amt){ 	//선택사항 합계
			fm.opt_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.opt_cs_amt.value)));			
		}else if(obj==fm.col_c_amt){ 	//색상 합계
			fm.col_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.col_cs_amt.value)));			
		}else if(obj==fm.sd_c_amt){ 	//탁송료 합계
			fm.sd_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.sd_cs_amt.value)));			
		}else if(obj==fm.dc_c_amt){ 	//매출DC 합계
			fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));			
		}else if(obj==fm.car_f_amt){ 	//면세차량가격 합계
			fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_fs_amt.value)));			
		}else if(obj==fm.tax_dc_amt){ 	//친환경차 개소세 감면액 합계
			fm.tax_dc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.tax_dc_v_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));			
		}
		
		sum_tax_amt();
		sum_car_c_amt();
		sum_car_f_amt();
		
	}

	//차량 특소세 자동계산
	function set_tax_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.spe_tax){ 	//특소세
			fm.edu_tax.value = parseDecimal(toInt(parseDigit(obj.value))*(30/100));		
		}
		fm.tot_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value)) + toInt(parseDigit(fm.edu_tax.value)) );					
	}

	//보증보험료 자동계산
	function set_gi_amt(){
		var fm = document.form1;
		sum_pp_amt();		
	}

	//차량 특소세 합계
	function sum_tax_amt(){
		var fm = document.form1;
		
		if(toInt(parseDigit(fm.spe_tax.value)) >  0){	return; }
		
		if(toInt(parseDigit(fm.car_f_amt.value)) == 0){	sum_car_f_amt(); }
		
		var purc_gu 		= fm.purc_gu.value;		
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_c_price = setCarPrice('car_c_price');
		var car_f_price = setCarPrice('car_f_price');
		var a_e 	= toInt(s_st);
		var o_1 	= car_c_price;
		setVar_o_123(car_f_price);
		if(purc_gu == '1'){//과세1
			fm.spe_tax.value = parseDecimal(car_c_price-toInt(fm.v_o_3.value));
			fm.pay_st[1].selected = true;
		}else{//과세2(면세)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>' == '5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){			
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
		
		fm.tot_cs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)));		
	}
	
	//차량 구입가 합계
	function sum_car_f_amt_b(){
		var fm = document.form1;
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );
	}
		
	//차가 구입가 합계
	function sum_car_f_amt(){
		var fm = document.form1;
		
		var purc_gu 		= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
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
				fm.car_f_amt.value = parseDecimal(<%=cm_bean.getCar_b_p2()%> + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
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
		sum_car_f_amt_b();
		sum_tax_amt();
		
		var car_price2 = setCarPrice('car_price2');
		var s_dc_amt = setDcAmt2(car_price2);
		car_price2 = car_price2 - s_dc_amt - toInt(parseDigit(fm.tax_dc_amt.value));

		//채권확보
		if(car_price2 <= 45000000)		fm.credit_per.value = '20';
		else if(car_price2 > 45000000)	fm.credit_per.value = '25';
		if(toInt(<%=cm_bean.getCar_comp_id()%>) > 6){
			fm.credit_per.value = '25';
		}else{
			fm.credit_per.value = '20';
		}
		//전기차는 기본 보증금에서 10% 빼준다
   	    if('<%=ej_bean.getJg_g_7()%>' == '3'){ fm.credit_per.value = toInt(fm.credit_per.value)-10; }
		//수소차는 기본 보증금에서 15% 빼준다
   	    if('<%=ej_bean.getJg_g_7()%>' == '4'){ fm.credit_per.value = toInt(fm.credit_per.value)-15; }
		var credit_per = toInt(fm.credit_per.value)/100;
		fm.credit_amt.value = parseDecimal(car_price2*credit_per);
		fm.commi_car_amt.value = parseDecimal(car_price - toInt(parseDigit(fm.tax_dc_amt.value)));
	}	
	
	//매출DC
	function search_dc(){
		var fm = document.form1;
		window.open("search_dc.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&car_fs_amt="+fm.car_fs_amt.value+"&car_fv_amt="+fm.car_fv_amt.value, "COMP_DC", "left=100, top=100, height=200, width=800, scrollbars=yes, status=yes");
	}
	
	//피보험자-고객 디스플레이
	function display_ip(){
		var fm = document.form1;
		var insur_per = fm.insur_per.options[fm.insur_per.selectedIndex].value;
		if(insur_per == '1'){ 				//아마존카
			tr_ip.style.display	= 'none';
			tr_ip2.style.display	= 'none';
		}else{						//고객
			tr_ip.style.display	= '';
			tr_ip2.style.display	= '';
		}		
	}	
		
	//보험가입사항 자동셋팅
	function set_insur_serv(){
		var fm = document.form1;
		
		var car_b  	= replaceString(" ","",fm.car_b.value)+replaceString(" ","",fm.opt.value);
		var car_nm  	= '<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%><%=cm_bean.getCar_name()%>'

		if(car_b.indexOf("운전석에어백") != -1)	{ fm.air_ds_yn.value 	= "Y";	}
		if(car_b.indexOf("조수석에어백") != -1)	{ fm.air_as_yn.value 	= "Y";	}
			
		if(fm.insurant.value == '1'){
			fm.pro_yn.checked 		= true;
		}
		if(fm.insur_per.value == '2' || '<%=ej_bean.getJg_k()%>' == '0'){
			fm.ac_dae_yn.checked 		= false;
		}else{
			fm.ac_dae_yn.checked 		= true;		
		}
		<% if(fee.getRent_way().equals("1")){%>
		fm.main_yn.checked 		= true;
		fm.ma_dae_yn.checked 		= true;
		<% }%>
	}
	
	//보증보험 디스플레이
	function display_gi(){
		var fm = document.form1;
		if(fm.gi_st[0].checked == true){				//가입
			tr_gi1.style.display		= '';
		}else{								//면제
			tr_gi1.style.display		= 'none';
			fm.gi_amt.value = 0;	
			fm.gi_fee.value = 0;	
			set_fee_amt(fm.grt_s_amt);
		}		
	}	
	
	//대여기간 셋팅
	function set_cont_date(obj){
		var fm = document.form1;
		var rent_way = fm.rent_way.value;
		
		if(fm.con_mon.value == ''){
			return;
		}
					
		fm.action='/fms2/lc_rent/get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();
	
	}
	
	//등록/수정: 차량가격 입력시 자동계산으로 가게..
	function enter_fee(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_fee_amt(obj);
	}	
	//등록/수정: 공급가, 부가세, 합계 입력시 자동계산
	function set_fee_amt(obj)
	{
		var fm = document.form1;	
		
		var car_price = setCarPrice('car_price2');
		var s_dc_amt = setDcAmt2(car_price);
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));
				
		car_price = car_price - s_dc_amt;
		
		//보증금---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//보증금 공급가
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value 	= fm.grt_s_amt.value;
			fm.gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			sum_pp_amt();			
		}else if(obj==fm.grt_amt){ 		//보증금 합계
			obj.value = parseDecimal(obj.value);
			fm.grt_s_amt.value 	= fm.grt_amt.value;
			fm.gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			sum_pp_amt();		
		//선납금---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt){ 	//선납금 공급가
			obj.value = parseDecimal(obj.value);
			fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
			fm.pere_r_per.value = replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			sum_pp_amt();			
		}else if(obj==fm.pp_v_amt){ 	//선납금 부가세
			obj.value = parseDecimal(obj.value);
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
			fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			sum_pp_amt();	
		}else if(obj==fm.pp_amt){ 		//선납금 합계
			obj.value = parseDecimal(obj.value);
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));			
			fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
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
			fm.ja_r_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
		}else if(obj==fm.ja_r_s_amt){ 	//적용잔가 공급가
			obj.value = parseDecimal(obj.value);
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) * 0.1 );
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
		}else if(obj==fm.ja_r_v_amt){ 	//적용잔가 부가세
			obj.value = parseDecimal(obj.value);
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
		}else if(obj==fm.ja_r_amt){		//적용잔가 합계
			obj.value = parseDecimal(obj.value);
			fm.ja_r_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
			fm.app_ja.value 		= replaceFloatRound(toInt(parseDigit(fm.ja_r_amt.value)) / car_price );
		//매입옵션율---------------------------------------------------------------------------------			
		}else if(obj==fm.opt_s_amt){ 	//매입옵션 공급가
			obj.value = parseDecimal(obj.value);
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) * 0.1 );
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));			
			fm.opt_per.value 		= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
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
				fm.opt_chk[1].checked = true;
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked = true;				
			}
		}else if(obj==fm.opt_v_amt){ 	//매입옵션 부가세
			obj.value = parseDecimal(obj.value);
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
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
				fm.opt_chk[1].checked = true;	
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked = true;				
			}			
		}else if(obj==fm.opt_amt){ 		//매입옵션 합계
			obj.value = parseDecimal(obj.value);
			fm.opt_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));			
			fm.opt_per.value 		= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
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
				fm.opt_chk[1].checked = true;	
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked = true;				
			}
		//계약대여료---------------------------------------------------------------------------------
		}else if(obj==fm.fee_s_amt){ 	//계약대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1 );
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
		}else if(obj==fm.fee_v_amt){ 	//계약대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.fee_amt.value		= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.fee_amt){ 		//계약대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));			
			dc_fee_amt();
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
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
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>' == '5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
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
	
	//특소세전차량가 가져가기
	function setVar_o_123(car_price){
		var o_1 = car_price;
		//차종별 특소세율
		var o_2 = <%=ej_bean.getJg_3()%>;
		//특소세전차량가 o_3 = o_1/(1+o_2), 차량가격/(1+특소세율);
		var o_3 = Math.round(<%=o_3%>);
		fm.v_o_1.value = o_1;
		fm.v_o_2.value = o_2;
		fm.v_o_3.value = o_3;
	}

	
	//선수금 합계
	function sum_pp_amt(){
		var fm = document.form1;
		
		fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );
		
		var car_price = setCarPrice('car_price2');
		var s_dc_amt 	= setDcAmt(car_price);
		
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));
				
		car_price = car_price - s_dc_amt;		
        	
								
		var pp_price 	= toInt(parseDigit(fm.tot_pp_amt.value)) + toInt(parseDigit(fm.gi_amt.value));
		if(pp_price>0 && car_price>0){
			fm.credit_r_per.value = parseFloatCipher3(pp_price / car_price * 100, 1);
			fm.credit_r_amt.value = parseDecimal(pp_price);
			fm.credit_amt.value = parseDecimal(car_price*toInt(fm.credit_per.value)/100);
		}
	}
	
	//영업수당계산
	function setCommi(){
		var fm = document.form1;
		
		var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));
		var comm_r_rt 	= toFloat(fm.comm_r_rt.value);
		
		fm.commi_car_amt.value 	= parseDecimal(car_price);
		fm.commi.value 		= parseDecimal(th_round(car_price*comm_r_rt/100));				
	}
	
	//대여료 DC율 계산
	function dc_fee_amt(){
		var fm = document.form1;
		
		var pp_s_amt	= toInt(parseDigit(fm.pp_s_amt.value));		//선납금
		var fee_s_amt	= toInt(parseDigit(fm.fee_s_amt.value));	//월대여료(적용)
		var inv_s_amt	= toInt(parseDigit(fm.inv_s_amt.value));	//정상대여료(견적)
		var con_mon	= toInt(parseDigit(fm.con_mon.value));		//대여기간 
		var dc_ra;
		
	}	
	
	//규정대여료 계산 (견적)
	function estimate(rent_st, st){
		var fm = document.form1;
		
		if(fm.con_mon.value == '')		{ alert('이용기간을 입력하십시오.');		return;}
		if(fm.driving_age.value == '')		{ alert('운전자연령을 선택하십시오.');		return;}
		if(fm.gcp_kd.value == '')		{ alert('대물배상을 선택하십시오.');		return;}
		
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.car_gu.value == '1' && fm.dir_pur_yn[0].checked == false && fm.dir_pur_yn[1].checked == false){	alert('특판출고여부를 선택하여 주십시오.'); fm.dir_pur_yn[0].focus(); return; }		
		
		// 테슬라 차량 대여기간 제한 없음. 20210225
		<%-- if ('<%=cm_bean.getCar_comp_id()%>' == '0056') {
			if(fm.con_mon.value > 48) {
				alert('테슬라차량의 경우 48개월 이상 견적이 불가 합니다.');
				fm.con_mon.focus();
				return;
			}
		} --%>
		
		fm.fee_rent_st.value = rent_st;
		
		//신차만 처리
		if(fm.car_gu.value == '1' ){
		
			var v_ch_327 = 0;
			var v_ch_315 = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value)); 
			var v_ch_326 = v_ch_315/(1+<%=ej_bean.getJg_3()%>);
			var v_bk_122 = 0;
			<%if(!ej_bean.getJg_w().equals("1")){%>
			<%	if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
			//if('<%=ej_bean.getJg_2()%>'=='1') v_ch_326 = v_ch_315; //일반승용LPG일때
			if('<%=ej_bean.getJg_g_7()%>'=='1') v_bk_122 = 1300000;
			if('<%=ej_bean.getJg_g_7()%>'=='2') v_bk_122 = 1300000;
			if('<%=ej_bean.getJg_g_7()%>'=='3') v_bk_122 = 3900000;
			if('<%=ej_bean.getJg_g_7()%>'=='4') v_bk_122 = 5200000;
			if(v_ch_315-v_ch_326<v_bk_122*1.1) 	v_ch_327 = v_ch_315-v_ch_326;
			else                         		v_ch_327 = v_bk_122*1.1;
			v_ch_327 = getCutRoundNumber(v_ch_327,0);
			if('<%=cm_bean.getJg_code()%>'=='2361' || '<%=cm_bean.getJg_code()%>'=='2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111')	v_ch_327 = 0;//볼트EV
			if('<%=cm_bean.getJg_code()%>'=='9133' || '<%=cm_bean.getJg_code()%>'=='9015435' || '<%=cm_bean.getJg_code()%>'=='9015436' || '<%=cm_bean.getJg_code()%>'=='9015437')	v_ch_327 = 0;//포터일렉
			fm.tax_dc_amt.value 	= parseDecimal(v_ch_327);
			set_car_amt(fm.tax_dc_amt);
	  		<%	}%>
  			<%}%>	
  		
			//개소세 한시적 감면 20200301~20200630
	  		var bk_175 = 0.7;     //감면율
		  	var bk_176 = 1430000; //개소세 감면 한도(교육세포함,부가세포함)
		  	var bk_177 = 0;
	  		<%if(!ej_bean.getJg_w().equals("1")){ //수입차제외%>
		  	<%		if(cm_bean.getDuty_free_opt().equals("1")){//면세가표기차량 제오%>
		  	<%		}else{%>
						if(v_ch_315<33471429){
							bk_177 = v_ch_326*<%=ej_bean.getJg_3()%>*bk_175;	
						}else{
							bk_177 = bk_176;
						}	 
						bk_177 = getCutRoundNumber(bk_177,-4);
						if('<%=cm_bean.getJg_code()%>'=='2361' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='5033111')	bk_177 = 0;//볼트EV
						//20200701 감면종료
						bk_177 = 0;
		  	<%		}%>
		  	<%}%>
	  	
	    	//감면 미적용 개별소비세(인하한도 초과금액) 20210101~20210630**********************
		  	var bk_216 = 0;
		  	if(<%=base.getRent_dt()%> >= 20210101){
	  		<%if(!ej_bean.getJg_w().equals("1")){ //수입차제외%>
		  	<%		if(cm_bean.getDuty_free_opt().equals("1")){//면세가표기차량 제오%>
		  	<%		}else{%>
						if(v_ch_315-v_ch_326>0 && (v_ch_326/1.1)>66666666){
							bk_216 = ((v_ch_326/1.1)-66666666)*0.0195*1.1;	
						}	    					
	// 					if(v_ch_315-v_ch_326>0 && v_ch_315>76669999){
	// 						bk_216 = (v_ch_315-76669999)*0.0195;	
	// 					}	    					
						bk_216 = getCutRoundNumber(bk_216,-4);		
	  		<%		}%>
		  	<%}%>
		  	}
	  	
	  		var ch327Nbk177 = ch_327;
	  	
		  	if(bk_177>0){
		  		if(v_ch_315-v_ch_326<bk_177+(bk_122*1.1)) 	ch327Nbk177 = v_ch_315-v_ch_326;
				else                         				ch327Nbk177 = bk_177+(bk_122*1.1);
	  		
		  		fm.tax_dc_amt.value 	= parseDecimal(ch327Nbk177);
				set_car_amt(fm.tax_dc_amt);
	  			
	  		}
		  	if(bk_216>0){
		  		if(v_ch_315-v_ch_326<-bk_216+(bk_122*1.1)) 	ch327Nbk177 = v_ch_315-v_ch_326;
				else                         				ch327Nbk177 = -bk_216+(bk_122*1.1);
	  		
	  			fm.tax_dc_amt.value    = parseDecimal(ch327Nbk177);			
	  			set_car_amt(fm.tax_dc_amt);
	  		}
		  	
		}  	
		
		var car_price = setCarPrice('car_price2');
		
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
		
		var s_dc_amt 	= setDcAmt(car_price);
		
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));    	
		
		fm.o_1.value 		= car_price - s_dc_amt;
		fm.t_dc_amt.value 	= s_dc_amt;
		fm.esti_stat.value 	= st;
		
		//특판출고일때 dc미반영
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dir_pur_yn[0].checked == true){
			fm.o_1.value 		= car_price;
			fm.t_dc_amt.value 	= 0;			
			
			if(<%=base.getRent_dt()%> >= 20130501){
				s_dc_amt = <%=cd_bean.getCar_d_p()%>;
				var s_dc_per = <%=cd_bean.getCar_d_per()%>;
				if(s_dc_per > 0){
					s_dc_amt = (car_price*s_dc_per/100)+s_dc_amt;					
				}
				fm.o_1.value 		= car_price - s_dc_amt;
				fm.t_dc_amt.value 	= s_dc_amt;
			}
			
		}
		
		//20150626 리스기본식만 보험계약자 고객 선택가능, 보험계약자가 고객이면 피보험자도 고객이여야 한다.			
		if('<%=base.getCar_st()%><%=fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('보험계약자 고객이면 피보험자도 고객이여야 합니다.');
				return;					
			}
		}else{
			if(fm.insurant.value == '2'){
				alert('보험계약자 고객은 리스기본식만 가능합니다.');
				return;
			}			
		}			
						
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}



		fm.ro_13.value 		= fm.opt_per.value;
		fm.o_13_amt.value 	= fm.opt_amt.value;
		fm.o_13.value 		= 0;	
		
		fm.action='get_fee_estimate_20090901.jsp';			

		
		<%	if(cm_bean.getJg_code().equals("")){%>
			alert("차종잔가코드가 없습니다. 차종관리에서 입력하십시오.");
			return;
		<%	}%>		
		
				<%if(ej_bean.getJg_g_7().equals("3")){//전기차%>
				if(fm.ecar_loc_st.value == ''){	
					alert("전기차 고객주소지를 선택하십시오.");
					return;			
				}else{
					
					//1.서울, 2.파주, 3.부산, 4.김해, 5.대전, 6.포천, 7.인천, 8.제주, 9.광주, 10.대구
					
					// 기존 전기화물차(등록지: 서울) 외 모든 전기차 고객 주소지와 관련 없이 인천으로 등록. 2021.02.18.
					// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주서지는 인천 등록. 20210224
					// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주소지는 부산 등록. 20210520
					// 고객주소지에 관계 없이 전기화물차면 실등록지역 대구, 전기승용차면 실등록지역 인천 등록. 20220519
					<%if ( Integer.parseInt(cm_bean.getJg_code()) > 8000000 ) {%>
							fm.car_ext.value = '10';	// 대구
					<%} else {%>
							fm.car_ext.value = '7';		// 인천
					<%}%>
				}
				<%}%>
				
				<%if(ej_bean.getJg_g_7().equals("4")){//수소차%>
				if(fm.hcar_loc_st.value == ''){
					alert("수소차 고객주소지를 선택하십시오.");
					return;			
				}else{
					fm.car_ext.value = '1';
				}
				//인천 -> 인천 등록
				if(fm.hcar_loc_st.value == '1'){	
					fm.car_ext.value = '7';
				}
				//대전 리스 -> 리스는 대전 등록
				if(fm.hcar_loc_st.value == '3'  && fm.car_st.value == '3'){	
					fm.car_ext.value = '5';
				}
				//광주/전남/전북 -> 광주 등록
				if(fm.hcar_loc_st.value == '4'){	
					fm.car_ext.value = '9';
				}
				//부산/울산/경남 -> 부산 등록
				if(fm.hcar_loc_st.value == '6'){	
					fm.car_ext.value = '3';
				}
				//20190701 수소차는 인천등록
				//fm.car_ext.value = '7';
				fm.car_ext.value = '7'; //20191206 수소차는 모두 인천
				//fm.car_ext.value = '1'; //20200324 수소차는 모두 인천 -> 서울로 등록
				<%}%>
		
		<%-- <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//친환경차-연료종류%>
		if(fm.eco_e_tag.value == ''){	
			alert("맑은서울스티커 발급(남산터널 이용 전자태그)을 선택하십시오.");
			return;
		}		
		/* if(fm.eco_e_tag.value == '1'){
			fm.car_ext.value = '1'; //맑은서울스티커 발급시 서울등록
		} */
		
			<%if(ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//친환경차:연료종류%>
			if(fm.eco_e_tag.value == '1'){
				alert("전기차/수소차는 현재 맑은서울스티커 발급(남산터널 이용 전자태그)이 불가합니다.");
				return;
			}
			<%}else{%>
			if(fm.eco_e_tag.value == '1'){
				fm.car_ext.value = '1'; //맑은서울스티커 발급시 서울등록
			}
			<%}%>
		
		<%}%> --%>
		
		if(fm.opt_amt.value == '0'){	
			if(!confirm('매입옵션이 없습니다. 입력이 누락된 것인지 확인하십시오. 계속하시겠습니까?'))  return;
		}	
		
		
		if(confirm('영업수당 계약조건 '+fm.comm_r_rt.value+'%로 견적됩니다. 계속하시겠습니까?')){
			fm.submit();
		}
		
		dc_fee_amt();
	}
	
	//출고지연대차 디스플레이
	function display_tae(){
		var fm = document.form1;
		if(fm.prv_dlv_yn[0].checked == true){			//없다
			tr_tae2.style.display		= 'none';
		}else{							//있다
			tr_tae2.style.display		= '';
		}		
	}		

	//출고지연차 조회
	function car_search(st)
	{
		var fm = document.form1;
		window.open("search_res_car.jsp?taecha=Y&client_id=<%=base.getClient_id()%>", "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");
	}	
	
	//영업소담당자 조회
	function search_emp(st){		
		var fm = document.form1;		
		var one_self = "N";		
		var pur_bus_st = "4";
		if(fm.one_self[0].checked == true) one_self = "Y";		
		window.open("search_emp.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&gubun="+st+"&one_self="+one_self+"&pur_bus_st="+pur_bus_st+"&car_comp_id=<%=cm_bean.getCar_comp_id()%>", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");	
	}
	
	//영업소담당자 입력취소
	function cancel_emp(st){
		var fm = document.form1;
		if(st == 'BUS'){
			fm.emp_nm[0].value = '';
			fm.emp_id[0].value = '';
			fm.car_off_nm[0].value = '';
			fm.car_off_id[0].value = '';
			fm.car_off_st[0].value = '';
			fm.cust_st.value = '';
			fm.comm_rt.value = '';
			fm.comm_r_rt.value = '';
			fm.ch_remark.value = '';
			fm.ch_sac_id.value = '';
			fm.emp_bank.value = '';
			fm.emp_bank_cd.value = '';
			fm.emp_acc_no.value = '';
			fm.emp_acc_nm.value = '';
		}else{
			fm.emp_nm[1].value = '';
			fm.emp_id[1].value = '';
			fm.car_off_nm[1].value = '';
			fm.car_off_id[1].value = '';
			fm.car_off_st[1].value = '';
		}		
	}
	//출고 영업소담당자를 영업 영업소담당자 상동처리
	function set_emp_sam(){
		var fm = document.form1;
		if(fm.emp_chk.checked == true){			
			fm.emp_nm[1].value = fm.emp_nm[0].value;
			fm.emp_id[1].value = fm.emp_id[0].value;
			fm.car_off_nm[1].value = fm.car_off_nm[0].value;
			fm.car_off_st[1].value = fm.car_off_st[0].value;		
		}else{
			cancel_emp('DLV');
		}
	}
	
	// 첨단안전장치 변경을 막아놓은 상태에서 서브밋 전송 전 첨단안전장치 select box 비활성화 해제 설정	2018.01.24
	function before_submit(){
		$("#lkas_yn").prop("disabled", false);
		$("#ldws_yn").prop("disabled", false);
		$("#aeb_yn").prop("disabled", false);
		$("#fcw_yn").prop("disabled", false);
		$("#hook_yn").prop("disabled", false);
		$("#ev_yn").prop("disabled", false);
		$("#legal_yn").prop("disabled", false);
	}
	
	//등록
	function save(){
		var fm = document.form1;
		
		if(fm.color.value == '')				{ alert('대여차량-색상을 입력하십시오.'); 				fm.color.focus(); 		return; }
		if(fm.car_gu.value == '1'){//신차
				if(fm.in_col.value == ''){ alert('대여차량-내장색상을 입력하십시오.');fm.in_col.focus();return; }	
		}
		if(fm.car_ext.value == '')				{ alert('대여차량-등록지역을 입력하십시오.'); 				fm.car_ext.focus(); 		return; }
		
				<%if(ej_bean.getJg_g_7().equals("3")){//전기차%>
					if(fm.ecar_loc_st.value == ''){	
						alert("전기차 고객주소지를 선택하십시오.");
						return;			
					}else{
						
						//1.서울, 2.파주, 3.부산, 4.김해, 5.대전, 6.포천, 7.인천, 8.제주, 9.광주, 10.대구
						
						// 기존 전기화물차(등록지: 서울) 외 모든 전기차 고객 주소지와 관련 없이 인천으로 등록. 2021.02.18.
						// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주서지는 인천 등록. 20210224
						// 고객주소지에 관계 없이 전기화물차면 실등록지역 대구, 전기승용차면 실등록지역 인천 등록. 20220519
						<% if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {%>
	// 						fm.car_ext.value = '7'; // 전기화물차 인천 등록. 20210729
							fm.car_ext.value = '10'; // 전기화물차 대구 등록. 20220519
						<%} else {%>
								fm.car_ext.value = '7';
						<%}%>
						
					}
				<%}%>
				
				<%if(ej_bean.getJg_g_7().equals("4")){//수소차%>
				if(fm.hcar_loc_st.value == ''){
					alert("수소차 고객주소지를 선택하십시오.");
					return;			
				}else{
					fm.car_ext.value = '1';
				}
				//인천 -> 인천 등록
				if(fm.hcar_loc_st.value == '1'){	
					fm.car_ext.value = '7';
				}
				//대전 리스 -> 리스는 대전 등록
				if(fm.hcar_loc_st.value == '3'  && fm.car_st.value == '3'){	
					fm.car_ext.value = '5';
				}
				//광주/전남/전북 -> 광주 등록
				if(fm.hcar_loc_st.value == '4'){	
					fm.car_ext.value = '9';
				}
				//부산/울산/경남 -> 부산 등록
				if(fm.hcar_loc_st.value == '6'){	
					fm.car_ext.value = '3';
				}
				//20190701 수소차는 인천등록
				//fm.car_ext.value = '7';
				fm.car_ext.value = '7'; //20191206 수소차는 모두 인천
				//fm.car_ext.value = '1'; //20200324 수소차는 모두 인천 -> 서울로 등록
				<%}%>
		
		<%-- <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//친환경차-연료종류%>
		if(fm.eco_e_tag.value == ''){	
			alert("맑은서울스티커 발급(남산터널 이용 전자태그)을 선택하십시오.");
			return;
		}		
		/* if(fm.eco_e_tag.value == '1'){
			fm.car_ext.value = '1'; //맑은서울스티커 발급시 서울등록
		} */
		
			<%if(ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//친환경차:연료종류%>
			if(fm.eco_e_tag.value == '1'){
				alert("전기차/수소차는 현재 맑은서울스티커 발급(남산터널 이용 전자태그)이 불가합니다.");
				return;
			}
			<%}else{%>
			if(fm.eco_e_tag.value == '1'){
				fm.car_ext.value = '1'; //맑은서울스티커 발급시 서울등록
			}
			<%}%>
		
		<%}%> --%>
				
		// 고급썬팅 추가 2017.12.26
		if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
			alert('전면썬팅(기본형), 전면썬팅 미시공 할인, 고급썬팅(전면포함) 중 하나만 체크하세요.'); fm.tint_s_yn.focus(); return;
		}
		if(fm.tint_s_yn.checked == true && fm.tint_ps_yn.checked == true){
			alert('전면썬팅(기본형)과 고급썬팅(전면포함) 중 하나만 체크하세요.'); fm.tint_s_yn.focus(); return;
		}
		if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true){
			alert('전면썬팅(기본형)과 전면썬팅 미시공 할인 중 하나만 체크하세요.'); fm.tint_s_yn.focus(); return;
		}
		if(fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
			alert('전면썬팅 미시공 할인과 고급썬팅(전면포함) 중 하나만 체크하세요.'); fm.tint_ps_yn.focus(); return;
		}
		if(fm.tint_ps_yn.checked == true && fm.tint_ps_amt.value < 1){
			alert('고급썬팅 금액을 입력하세요.'); fm.tint_ps_amt.focus(); return;
		}
		
		if(fm.tint_s_yn.checked == true && toInt(fm.tint_s_per.value) < 50 && '<%=ej_bean.getJg_w()%>' != '1'){
			//alert('대여차량-용품-전면썬팅은 국산차는 투과율이 50% 이상만 가능합니다.'); 				fm.tint_s_per.focus(); 		return;
		}
		
		if(fm.tint_bn_yn.checked == true && fm.tint_bn_nm.value == ''){
			alert('블랙박스 미제공 할인 사유을 선택하십시오.'); fm.tint_bn_nm.focus(); return;
		}
		
		
		var car_c_amt = toInt(parseDigit(fm.car_c_amt.value));
		var car_f_amt = toInt(parseDigit(fm.car_f_amt.value));
		
		if(car_c_amt == 0)					{ alert('차량가격-소비자가 기본가격을 입력하십시오.'); 			fm.car_c_amt.focus(); 		return; }
		if(car_f_amt == 0)					{ alert('차량가격-구입가 차량가격을 입력하십시오.'); 			fm.car_f_amt.focus(); 		return; }			
		
		//계약서상 제조사 할인후 차량가격 표기여부, 신차만. (20190911)
		<%if(base.getCar_gu().equals("1")){%>
			if(fm.dc_view_yn.checked==true){
				if(fm.view_car_dc.value==""||fm.view_car_dc.value==0){
					alert("전자 계약서상 제조사 할인 후 차량가격 병행 표기 여부 체크!\n\n-> [제조사 할인 후 차량가격] 을 입력해주세요.");	fm.view_car_dc.focus();	return;
				}
			}else{
				fm.view_car_dc.value="";
			}
		<%}%> 
		
		if(fm.insur_per.value == '')				{ alert('보험사항-피보험자를 입력하십시오.'); 			fm.insur_per.focus(); 		return; }
		if(fm.driving_age.value == '')				{ alert('보험사항-운전자연령을 입력하십시오.'); 			fm.driving_age.focus(); 	return; }
		<%if(client.getClient_st().equals("1") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
			if(fm.com_emp_yn.value == '')			{ alert('보험사항-임직원운전한정특약 가입여부를 입력하십시오.');		fm.com_emp_yn.focus(); 		return; }
		<%}else if(AddUtil.parseInt(client.getClient_st()) >2 && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>
			//개인사업자 업무전용차량 제한없음
			if(fm.com_emp_yn.value == '')			{ alert('보험사항-임직원운전한정특약 가입여부를 입력하십시오.');		fm.com_emp_yn.focus(); 		return; }
		<%}else{%>
			if(fm.com_emp_yn.value == 'Y')			{ alert('보험사항-임직원운전한정특약 가입대상이 아닌데 가입으로 되어 있습니다. 확인하십시오.');	fm.com_emp_yn.focus(); 	return; }
		<%}%>
		if(fm.gcp_kd.value == '')				{ alert('보험사항-대물배상 가입금액을 입력하십시오.'); 			fm.gcp_kd.focus(); 		return; }
		if(fm.bacdt_kd.value == '')				{ alert('보험사항-자기신체사고 가입금액을 입력하십시오.'); 		fm.bacdt_kd.focus(); 		return; }
		if(fm.canoisr_yn.value == '')				{ alert('보험사항-무보험차상해 가입여부를 입력하십시오.'); 		fm.canoisr_yn.focus(); 		return; }
		if(fm.cacdt_yn.value == '')				{ alert('보험사항-자기차량손해 가입여부를 입력하십시오.'); 		fm.cacdt_yn.focus(); 		return; }
		if(fm.eme_yn.value == '')				{ alert('보험사항-긴급출동 가입여부를 입력하십시오.'); 			fm.eme_yn.focus(); 		return; }
		
		//20150626 리스기본식만 보험계약자 고객 선택가능, 보험계약자가 고객이면 피보험자도 고객이여야 한다.			
		if('<%=base.getCar_st()%><%=fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('보험계약자 고객이면 피보험자도 고객이여야 합니다.');
				return;					
			}
		}else{
			if(fm.insurant.value == '2'){
				alert('보험계약자 고객은 리스기본식만 가능합니다.');
				return;
			}			
		}	
				
		var car_ja 	= toInt(parseDigit(fm.car_ja.value));
		
		if(car_ja == 0)						{ alert('보험사항-자차면책금을 입력하십시오.'); 			fm.car_ja.focus(); 		return; }
		
		<%if(ej_bean.getJg_w().equals("1")){//수입차%>
		if(fm.car_ja.value != fm.imm_amt.value){
			if(fm.ja_reason.value == '')			{ alert('보험사항-자차면책금 변경사유를 입력하십시오.'); 		fm.ja_reason.focus(); 		return; }
			if(fm.rea_appr_id.value == '')			{ alert('보험사항-자차면책금 변경 결재자를 입력하십시오.'); 		fm.rea_appr_id.focus(); 	return; }
		}
		<%}else{%>
		if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'<%if(base.getCar_st().equals("3")){%> && fm.car_ja.value != '100,000'<%}%>){
			if(fm.ja_reason.value == '')			{ alert('보험사항-자차면책금 변경사유를 입력하십시오.'); 		fm.ja_reason.focus(); 		return; }
			if(fm.rea_appr_id.value == '')			{ alert('보험사항-자차면책금 변경 결재자를 입력하십시오.'); 		fm.rea_appr_id.focus(); 	return; }
		}			
		<%}%>			
			

		if(fm.insur_per.value == '2'){
			if(fm.ip_insur.value == '')			{ alert('보험사항-입보회사 보험사명을 입력하십시오.'); 			fm.ip_insur.focus(); 		return; }
			if(fm.ip_agent.value == '')			{ alert('보험사항-입보회사 대리점명을 입력하십시오.'); 			fm.ip_agent.focus(); 		return; }
			if(fm.ip_dam.value == '')			{ alert('보험사항-입보회사 담당자명을 입력하십시오.'); 			fm.ip_dam.focus(); 		return; }
			if(fm.ip_tel.value == '')			{ alert('보험사항-입보회사 연락처를 입력하십시오.'); 			fm.ip_tel.focus(); 		return; }
		}
		
		if(fm.gi_st[0].checked == true){//가입
			var gi_amt 	= toInt(parseDigit(fm.gi_amt.value));
			//var gi_fee 	= toInt(parseDigit(fm.gi_fee.value));
			if(gi_amt == 0)					{ alert('보증보험-가입금액을 입력하십시오.'); 			fm.gi_amt.focus(); 		return; }
			//if(gi_fee == 0)					{ alert('보증보험-보증보험료를 입력하십시오.'); 			fm.gi_fee.focus(); 		return; }
		}
			
		if(fm.con_mon.value == '')				{ alert('대여요금-이용기간을 입력하십시오.'); 			fm.con_mon.focus(); 		return; }
		if(toInt(parseDigit(fm.tot_pp_amt.value))>0 && fm.pp_est_dt.value == ''){ alert('선수금 입금예정일을 입력하십시오.'); 	fm.pp_est_dt.focus(); 		return;	}
		
		if(toInt(parseDigit(fm.credit_r_amt.value))>0 && ( fm.credit_sac_id.value == '' || fm.credit_sac_dt.value == '' )) 
									{ alert('채권확보 결재자와 결재일자를 입력하십시오.'); 			fm.credit_sac_dt.focus(); 	return;}			
		

													
		if(toInt(parseDigit(fm.ja_amt.value)) == 0 && toInt(parseDigit(fm.ja_r_amt.value)) > 0){
			fm.ja_s_amt.value 	= fm.ja_r_s_amt.value;
			fm.ja_v_amt.value 	= fm.ja_r_v_amt.value;
			fm.ja_amt.value 	= fm.ja_r_amt.value;
			fm.max_ja.value 	= fm.app_ja.value;								
		}
			
		if(fm.max_ja.value == '')				{ alert('대여요금-최대잔가율을 입력하십시오.'); 			fm.max_ja.focus(); 		return; }
		var ja_r_amt = toInt(parseDigit(fm.ja_r_amt.value));
		if(toInt(fm.app_ja.value) < 1 && ja_r_amt > 100000)				{ alert('대여요금-적용잔가율을 입력하십시오.'); 			fm.app_ja.focus(); 		return; }				
		if(ja_r_amt == 0)						{ alert('대여요금-잔존가치금액을 입력하십시오.'); 			fm.ja_r_amt.focus(); 		return; }
		if(fm.opt_chk[0].checked == false && fm.opt_chk[1].checked == false){ alert('대여요금-매입옵션 여부를 입력하십시오.'); 		fm.opt_chk.focus(); 		return; }
		if(fm.opt_chk[1].checked == true){
			var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
			if(opt_amt == 0)				{ alert('대여요금-매입옵션금액을 입력하십시오.'); 			fm.opt_amt.focus(); 		return; }
		}
		if(fm.opt_chk[0].checked == true){
			var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
			if(opt_amt > 0)						{ alert('대여요금-매입옵션없음으로 되어 있으나 매입옵션금액이 있습니다. 확인하십시오.');	fm.opt_amt.focus(); 		return; }
			//fm.opt_s_amt.value = 0;
			//fm.opt_v_amt.value = 0;
			//fm.opt_amt.value = 0;
			//fm.opt_per.value = 0;
		}
		if(toInt(fm.cls_r_per.value) < 1)			{ alert('대여요금-중도해지위약율 확인하십시오.'); 		 	fm.cls_r_per.focus(); 		return;	}
		
		var fee_amt = toInt(parseDigit(fm.fee_amt.value));
		var inv_amt = toInt(parseDigit(fm.inv_amt.value));
		var pp_amt = toInt(parseDigit(fm.pp_amt.value));
		if(fm.fee_chk.value == '') fm.fee_chk.value = '0';
		if(fm.pp_chk.value == '' && pp_amt >0) fm.pp_chk.value = '1';
		if(pp_amt == 0) fm.pp_chk.value = '';
		if(fm.fee_chk.value == '0' && fee_amt == 0)		{ alert('대여요금-대여료 계약금액을 입력하십시오.'); 			fm.fee_amt.focus(); 		return; }
		if(fm.fee_chk.value == '0' && inv_amt == 0)					{ alert('대여요금-대여료 규정금액을 입력하십시오.'); 			fm.inv_amt.focus(); 		return; }
		
		if(toFloat(parseDigit(fm.dc_ra.value))*100>0 && ( fm.dc_ra_st.value == '' || fm.dc_ra_sac_id.value == '' )) 
									{ alert('대여요금-대여료DC 적용근거, 결재자와 결재일자를 입력하십시오.'); 	fm.dc_ra_st.focus(); 		return;}			
			
		if(toFloat(parseDigit(fm.comm_r_rt.value))>0 && toInt(parseDigit(fm.commi_car_amt.value))==0){
			alert('영업수당 적용수수료율(계약조건)이 있으나 영업수당금액 산출을 위한 산출기준 금액이 없습니다. 확인하십시오.'); return;
		}
		
		//특판출고(실적이관가능)이면 영업수당은 없다.
		if(<%=base.getRent_dt()%> >= 20190610 && toFloat(parseDigit(fm.comm_r_rt.value))>0 && '<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true && fm.dir_pur_yn[0].checked == true && fm.dir_pur_commi_yn.value == 'Y'){
			alert('현대차이면서 법인고객이고 출고보전수당이 있는 특판출고는 영업수당이 없습니다.'); return;
		}
					
		if(fm.car_gu.value == '1' && fm.agree_dist.value !='미적용'){//신차
			if(fm.agree_dist.value == '0')		{ alert('대여요금-약정운행거리를 입력하십시오.'); 			fm.agree_dist.focus(); 		return; }
			if(fm.over_run_amt.value == '0')	{ alert('대여요금-초과운행부담금을 입력하십시오.'); 			fm.over_run_amt.focus(); 	return; }
			<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
				if(fm.rtn_run_amt_yn.value == '')									{ alert('대여요금-환급대여료적용여부를 입력하십시오.'); 	fm.rtn_run_amt_yn.focus(); 	return; }	
				if(fm.rtn_run_amt.value == '0' && fm.rtn_run_amt_yn.value == '0')	{ alert('대여요금-환급대여료를 입력하십시오.'); 			fm.rtn_run_amt.focus(); 	return; }
				if(toInt(parseDigit(fm.rtn_run_amt.value)) > 0 && fm.rtn_run_amt_yn.value == '1')	{ alert('대여요금-환급대여료미적용이므로 환급대여료 0원 처리합니다.'); fm.rtn_run_amt.value = 0; }
			<%}%>
		}
			
		<%if(base.getRent_st().equals("3")){%>
			//대차 보증금 승계 
			if(fm.grt_suc_yn.value == '0' && fm.grt_suc_l_cd.value !='' && (toInt(parseDigit(fm.grt_suc_o_amt.value))==0 || toInt(parseDigit(fm.grt_suc_r_amt.value))==0)){
				alert('대차 보증금 승계입니다. 기존보증금과 승계보증금을 입력하십시오.'); fm.grt_suc_o_amt.focus(); return;
			}
			if(fm.grt_suc_yn.value == '0' && fm.grt_suc_l_cd.value == ''){
				alert('대차 보증금 승계입니다. 대차원계약을 선택하십시오.'); fm.grt_suc_l_cd.focus(); return;
			}
			if(fm.grt_suc_yn.value == '' && fm.grt_suc_l_cd.value != '' && toInt(parseDigit(fm.grt_suc_r_amt.value))>0){
				alert('대차 보증금 승계여부를 선택하십시오.'); fm.grt_suc_yn.focus(); return;
			}			
			if(fm.grt_suc_yn.value == '0' && toInt(parseDigit(fm.grt_s_amt.value)) < toInt(parseDigit(fm.grt_suc_r_amt.value))){
				alert('대차 보증금 승계입니다. 승계보증금이 계약 보증금보다 큽니다. 확인하십시오.'); fm.grt_suc_r_amt.focus(); return;
			}
		<%}%>
			
		if(fm.fee_pay_tm.value == '')				{ alert('대여요금-납입횟수를 입력하십시오.'); 				fm.fee_pay_tm.focus(); 		return; }
		if(fm.fee_sh.value == '')				{ alert('대여요금-수금구분를 입력하십시오.'); 				fm.fee_sh.focus(); 		return; }
		if(fm.fee_pay_st.value == '')				{ alert('대여요금-납부방법을 입력하십시오.'); 				fm.fee_pay_st.focus(); 		return; }
		if(fm.fee_pay_st.value != '1' && fm.cms_not_cau.value == ''){ alert('납부방법이 자동이체가 아닌 경우 CMS미실행사유를 입력하십시오.'); fm.cms_not_cau.focus(); return; }
		if(fm.def_st.value == '')				{ alert('대여요금-거치여부를 입력하십시오.'); 				fm.def_st.focus(); 		return; }
		if(fm.def_st.value == 'Y'){
			if(fm.def_remark.value == '')			{ alert('대여요금-거치사유를 입력하십시오.');				fm.def_remark.focus();		return; }
			if(fm.def_sac_id.value == '')			{ alert('대여요금-거치 결재자를 입력하십시오.');			fm.def_sac_id.focus();		return; }
		}
			
		if(fm.fee_pay_st.value == '1'){
			if(fm.cms_bank_cd.value == '')	{ alert('대여요금-CMS 거래은행을 입력하십시오.'); 			fm.cms_bank_cd.focus(); 		return; }
			if(fm.cms_acc_no.value != '')		{ 
					if ( !checkInputNumber("CMS 계좌번호", fm.cms_acc_no.value) ) {		
						fm.cms_acc_no.focus(); 		return; 
					}
					//휴대폰,연락처 동일여부 확인
					if(replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getM_tel()%>") || replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getO_tel()%>")){
						alert("계좌번호가 휴대폰 혹은 연락처와 같습니다. 평생계좌번호는 자동이체가 안됩니다.");
						fm.cms_acc_no.focus(); 		return; 
					}
			}	
			if(fm.cms_dep_nm.value == '')			{ alert('대여요금-CMS 예금주를 입력하십시오.'); 				fm.cms_dep_nm.focus(); 		return; }				
			if(fm.cms_dep_ssn.value == '')			{ alert('대여요금-CMS 예금주 생년월일/사업자번호를 입력하십시오.'); 	fm.cms_dep_ssn.focus(); 	return; }		
			//예금주 생년월일은 6자리			
			if(replaceString("-","",fm.cms_dep_ssn.value).length == 8){
				alert('대여요금-CMS 예금주 생년월일은 6자리입니다.'); return;
			}
		}
			
		if(fm.tax_type[1].checked == true && '<%=site.getEnp_no()%>' == ''){ fm.tax_type[0].checked = true; }
		if(fm.rec_st.value == '')				{ alert('세금계산서-청구서수령방법을 입력하십시오.');			fm.rec_st.focus(); 		return; }
		if(fm.rec_st.value == '1'){
			if(fm.ele_tax_st.value == '')			{alert('세금계산서-전자세금계산서 시스템을 입력하십시오.'); 		fm.ele_tax_st.focus();		return; }
			if(fm.ele_tax_st.value == '2'){
				if(fm.tax_extra.value == '')		{ alert('세금계산서-전자세금계산서 별도시스템 이름을 입력하십시오.'); 	fm.tax_extra.focus(); 		return; }
			}
			<%	if(print_car_st_yn.equals("Y")){%>
			if(fm.print_car_st.value == '')			{alert('세금계산서-계산서별도발행구분을 입력하십시오.'); 		fm.print_car_st.focus();	return; }
			<%	}%>
		}
		
		if(fm.prv_dlv_yn[1].checked == true){
			if(fm.tae_car_no.value == '')		{ alert('출고전대차-자동차를 선택하십시오.'); 				fm.tae_car_no.focus(); 		return; }					
			if(fm.tae_car_rent_st.value == '')	{ alert('출고전대차-대여개시일을 입력하십시오.'); 			fm.tae_car_rent_st.focus(); 	return; }
			if(fm.tae_req_st.value == '')		{ alert('출고전대차-청구여부를 선택하십시오.'); 			fm.tae_req_st.focus(); 		return; }
			if(fm.tae_req_st.value == '1'){
				if(toInt(parseDigit(fm.tae_rent_fee.value)) == 0)	{ alert('출고전대차-월대여료를 입력하십시오.'); 			fm.tae_rent_fee.focus(); 	return; }
				if(toInt(parseDigit(fm.tae_rent_inv.value)) == 0)	{ alert('출고전대차-정상요금을 입력하십시오.'); 			fm.tae_rent_inv.focus(); 	return; }
				if(fm.tae_est_id.value == '')	{ alert('출고전대차-정상요금 계산하기를 하십시오.'); 			fm.tae_rent_inv.focus(); 	return; }
				/*
				if(fm.tae_rent_fee_st[0].checked == false && fm.tae_rent_fee_st[1].checked == false){
					alert('출고전대차 견적서 <출고전 신차 대여 계약 해지시 요금정산> 항목에 월렌트 정상요금이 표기되어 있는 경우에 월렌트 정상요금을 입력하고, 월렌트 정상요금이 표기되어 있지 않은 경우에는 ㅇ견적서에 표기되어 있지 않음에 체크해주세요.'); return;
				}else{
					if(fm.tae_rent_fee_st[0].checked == true){
						if(toInt(parseDigit(fm.tae_rent_fee_cls.value)) == 0){ alert('신차 해지시 요금정산(월렌트정상요금)을 입력하십시오.'); return;									}
						if(toInt(parseDigit(fm.tae_rent_fee.value)) >= toInt(parseDigit(fm.tae_rent_fee_cls.value)))	{ alert('신차 해지시 요금정산(월렌트정상요금)값이 출고지연대차 월대여료보다 크지 않습니다. 확인하십시오.'); 			fm.tae_rent_fee_cls.focus(); 	return; }
					}else{
						fm.tae_rent_fee_cls.value = 0;
					}								
				}
				*/
				if(fm.tae_tae_st.value == '')	{ alert('출고전대차-계산서발행여부를 선택하십시오.'); 			fm.tae_tae_st.focus(); 		return; }						
			}
			if(fm.tae_sac_id.value == '')		{ alert('출고전대차-결재자를 선택하십시오.'); 				fm.tae_sac_id.focus(); 		return; }
		}

			
		if(fm.emp_id[0].value != ''){
			if(fm.comm_rt.value == '' || fm.comm_rt.value == '0')	{ 
				fm.comm_rt.value = 3.0;
			}			
			if(fm.comm_r_rt.value == '')		{ alert('영업담당영업사원-영업수당 적용수수료율를 입력하십시오.'); 	fm.comm_r_rt.focus(); 		return; }
			if(toFloat(fm.comm_rt.value) < toFloat(fm.comm_r_rt.value)){ //최대수수료율보다 적용수수료율이 더 클수는 없다.
				alert('영업담당영업사원-영업수당 최대수수료율보다 적용수수료율이 더 클수 는 없습니다. 확인하십시오.'); 		fm.comm_rt.focus(); return;
			}
			
										
		}
		
		
		
		//기타(자체)
		if(fm.dir_pur_yn[0].checked == false){
			var con_amt 		= toInt(parseDigit(fm.con_amt.value));
			//if(con_amt > 0){
			//	if(fm.con_bank.value == '' || fm.con_acc_no.value == '' || fm.con_acc_nm.value == ''){
			//		alert('출고영업소에 차량대금(계약금)를 지급할 계좌를 입력하십시오.'); return;
			//	}
			//}
			if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value == '법인판매팀장'){
				alert('현대 법인판매팀장인데 특판이 아닙니다. 출고영업소를 확인하십시오.'); return;											
			}
			if(fm.dir_pur_commi_yn.value == 'Y'){
				alert('출고보전수당이 있고 특판출고(실적이관가능)인데 특판이 아닙니다. 특판출고여부 혹은 출고보전수당 출고구분을 확인하십시오.'); return;
			}
			if(fm.dir_pur_commi_yn.value == 'N'){
				alert('출고보전수당이 있고 특판출고(실적이관가능)인데 특판이 아닙니다. 특판출고여부 혹은 출고보전수당 출고구분을 확인하십시오.'); return;
			}
		//특판출고		
		}else{
			if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value == ''){
				//현대자동차 특판
				alert('출고영업소를 입력하십시오.'); return;											
			}
			if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value != '030849'){
					alert('특판출고 선택되었으나 출고영업소가 법인판촉팀이 아닙니다. 확인하십시오.'); return;						
			}
			if('<%=cm_bean.getCar_comp_id()%>' == '0003' && fm.emp_id[1].value != '038036'){
					alert('특판출고 선택되었으나 출고영업소가 법인판매팀이 아닙니다. 확인하십시오.'); return;
			}
			if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value != '법인판매팀장'){
				alert('현대 특판인데 법인판매팀장 아닙니다. 출고영업소를 확인하십시오.'); return;											
			}
			if(fm.dir_pur_commi_yn.value == '2'){
				alert('출고보전수당이 있고 자체출고대리점출고인데 특판입니다. 특판출고여부 혹은 출고보전수당 출고구분을 확인하십시오.'); return;
			}
		}
		
		if(fm.emp_id[1].value != ''){
			if(fm.con_amt.value == '' || fm.con_amt.value == '0')	{
				
			}else{	
				if(fm.trf_st0.value == '')			{ alert('출고영업소-선수금 지급수단을 선택하십시오.'); 	fm.trf_st0.focus(); 		return; }
				if(fm.trf_st0.value == '1'){
					if(fm.con_bank.value == '') 	{ alert('출고영업소-선수금 지급금융사를 입력하십시오.'); 	fm.con_bank.focus(); 		return; }
					if(fm.con_acc_no.value == '') 	{ alert('출고영업소-선수금 계좌번호를 입력하십시오.'); 	fm.con_acc_no.focus(); 		return; }
					if(fm.con_acc_nm.value == '') 	{ alert('출고영업소-선수금 계좌예금주를 입력하십시오.'); 	fm.con_acc_nm.focus(); 		return; }					
				}	
				if(fm.con_est_dt.value == '') 	{ alert('출고영업소-선수금 지급예정일을 입력하십시오.'); 	fm.con_est_dt.focus(); 		return; }
			}			
			if(fm.trf_amt5.value == '' || fm.trf_amt5.value == '0')	{
				
			}else{	
				if(fm.trf_st5.value == '')			{ alert('임시운행보험료 지급수단을 선택하십시오.'); 	fm.trf_st5.focus(); 		return; }
				if(fm.trf_st5.value == '1'){
					if(fm.card_kind5.value == '') 	{ alert('임시운행보험료 지급금융사를 입력하십시오.'); 	fm.card_kind5.focus(); 		return; }
					if(fm.cardno5.value == '') 		{ alert('임시운행보험료 계좌번호를 입력하십시오.'); 	fm.cardno5.focus(); 		return; }
					if(fm.trf_cont5.value == '') 	{ alert('임시운행보험료 계좌예금주를 입력하십시오.'); 	fm.trf_cont5.focus(); 		return; }					
				}	
				if(fm.trf_est_dt5.value == '') 	{ alert('임시운행보험료 지급예정일을 입력하십시오.'); 	fm.trf_est_dt5.focus(); 	return; }
			}	
		}
		
		var checkSymbol = false;
		var symbol = "<>\"'\\";		// 입력 제한 대상인 특수 문자(<, >, ', ")
		var con_etc = fm.con_etc.value;
		for(var i=0; i<con_etc.length; i++){
			if(symbol.indexOf(con_etc.charAt(i)) != -1) 	checkSymbol = true;
		}
		if(checkSymbol){		// 특약사항 기재란 일부 특수 문자 입력 제한 처리 수정 2020.01.03.
			alert('대여요금-특약사항 기재 내용에는 특수 문자 중 <, >, \', "\를 사용할 수 없습니다.'); return;
		}
		
		if (con_etc.indexOf("*,***") != -1) {
			alert('대여요금-특약사항 기재 내용 중 월대여료 인상금액 입력을 확인하세요.'); return;
		}
			
		if(toFloat(fm.v_comm_rt.value) > 0 ) setCommi();
			
			
		if(inv_amt > 0 && toFloat(fm.dc_ra.value) == 0) dc_fee_amt();		
			
		
		
		if(confirm('4단계를 등록하시겠습니까?')){	
			before_submit();	// 서브밋전 첨단안전장치 select box disable 해제	2018.01.24
			fm.action='lc_reg_step4_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}							
	}
	
		
	//출고전대차 규정대여료 계산 (견적)
	function estimate_taecha(st){
		var fm = document.form1;
		
		if(fm.tae_car_mng_id.value == '')	{ alert('출고전대차 차량을 선택하십시오.');	return;}		
		
		fm.esti_stat.value 	= st;
				
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}		

		fm.action='get_fee_estimate_taecha.jsp';			
							
		fm.submit();
	}	
	
	//견적서인쇄
	function TaechaEstiPrint(est_id){ 
		
		var fm = document.form1;  
		
		var SUBWIN="/acar/secondhand_hp/estimate.jsp?from_page=/agent/lc_rent/lc_t_frame.jsp&est_id="+est_id;  	
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 		
	}		
	
		
	//물적사고할증기준 선택에 따라 자기부담금 셋팅
	function setCacdtMeAmt(){
		var fm = document.form1;
		fm.cacdt_memin_amt.value = toInt(fm.cacdt_mebase_amt.value)*0.1;		
		if(toInt(fm.cacdt_mebase_amt.value) >0){
			fm.cacdt_me_amt.value = 50;
		}
	}	
	
	function search_cms(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		
	}				
	
	//대차보증금승계조회
	function search_grt_suc()
	{
		var fm = document.form1;	
		window.open("/agent/car_pur/s_grt_suc.jsp?from_page=/fms2/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>", "SERV_GRT_OFF", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}					
	
	//직원조회
	function User_search(nm, idx)
	{
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/agent/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP_Y&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}		
	//만나이계산하기
	function age_search()
	{
		var fm = document.form1;
		
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');		
		fm.action = "/agent/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();		
	}
	
	function OpenImg(url){
  	var img=new Image();
  	var OpenWindow=window.open('','_blank', 'width=1000, height=760, menubars=no, scrollbars=auto');
  	OpenWindow.document.write("<style>body{margin:0px;}</style><img src='"+url+"' width='990'>");
 }
	
	//출고보전수당
	function cng_input(){
		var fm = document.form1;		
		if('<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true ){ // && fm.dir_pur_yn[0].checked == true
			if(fm.dir_pur_commi_yn.value == ''){
				if('<%=ej_bean.getJg_g_7()%>' == '3' || '<%=ej_bean.getJg_g_7()%>' == '4'){
					fm.dir_pur_commi_yn.value = 'N';
				}else{
					fm.dir_pur_commi_yn.value = 'Y';
				}	
				//기타(자체)
				if(fm.dir_pur_yn[0].checked == false){
					fm.dir_pur_commi_yn.value = '2';
				}
			}
		}else{												
			fm.dir_pur_commi_yn.value = '';
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
<body leftmargin="15">
<form action='lc_reg_step4_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="opt"			value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"			value="<%=cm_bean.getCar_b()%><%=cm_bean2.getCar_b()%>">
  <input type='hidden' name="s_st" 			value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="rent_way" 			value="<%=fee.getRent_way()%>">  
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
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="o_1"			value="">
  <input type='hidden' name="ro_13"			value="">  
  <input type='hidden' name="o_13"			value="">  
  <input type='hidden' name="o_13_amt"			value="">    
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name="rent_dt"			value="<%=base.getRent_dt()%>">
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">    
  <input type='hidden' name="client_id"			value="<%=base.getClient_id()%>">       
  <input type='hidden' name="from_page"			value="car_rent">  
  <input type='hidden' name="est_from"			value="lc_reg">      
  <input type='hidden' name="ins_chk1"			value="">        
  <input type='hidden' name="ins_chk2"			value="">          
  <input type='hidden' name="ins_chk3"			value="">            
  <input type='hidden' name="ins_chk4"			value="">              
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">              
  <input type='hidden' name="fee_rent_st"		value="">  
  <input type='hidden' name="r_max_agree_dist"		value="">   
  <input type='hidden' name="print_car_st_yn"		value="<%=print_car_st_yn%>">  
  <input type='hidden' name="v_o_1"			value="">
  <input type='hidden' name="v_o_2"			value="">
  <input type='hidden' name="v_o_3"			value="">
   
                   
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td align='left'>&nbsp;&nbsp; <span class=style2> <font color=red>[4단계]</font> 계약사항</span></td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
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
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr>
                    <td class=title>계약일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>계약구분</td>
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;
					  에이젼트
					  <input type='hidden' name='bus_st' 	value='<%=base.getBus_st()%>'>				
		    		</td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<b><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}%></b></td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<b><%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></b></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%><%if(!base.getAgent_emp_id().equals("")){%>&nbsp;(계약진행담당자:<%=c_db.getNameById(base.getAgent_emp_id(),"CAR_OFF_EMP")%>)<%}%></td>
                    <td class=title>영업대리인</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
                    <td class=title>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>상호</td>
                    <td>&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%></a></td>
                    <td class=title>대표자</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                    <td class=title>지점/현장</td>
                    <td>&nbsp;<%=site.getR_site()%></td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여차량</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	  
                <tr>
                    <td width='13%' class='title'>자동차회사</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class='title' width="10%">차명</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class='title' width='10%'>차종</td>
                    <td>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class='title'>소분류 </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%></td>
                    <td class='title' width="10%">차종코드</td>
                    <td>&nbsp;[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></td>
                    <td class='title'>배기량</td>
                    <td>&nbsp;<%=cm_bean.getDpm()%>cc</td>
                </tr>
                <tr>
                    <td class='title'>기본사양</td>
                    <td colspan="5" align=center>
                        <table width=98% cellpadding=3 cellspacing=3 border=0>
                            <tr>
                                <td>
        			  <%if(!cm_bean2.getCar_name().equals("")){%><span title='<%=cm_bean2.getCar_b()%>'><font color='#999999'><%=cm_bean2.getCar_name()%>외&nbsp;</font></span><%}%>
        			  <%=cm_bean.getCar_b()%></td>
        		    </tr>
                        </table>
                    </td>
                </tr>		  
                <tr>
                    <td class='title'>옵션</td>
                    <td colspan="5">&nbsp;
        			  <%=car.getOpt()%><input type='hidden' name='opt_code' value='<%=car.getOpt_code()%>'></td>
                </tr>
                <tr>
                    <td class='title'> 색상</td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='color' size='50' class='default' value='<%=car.getColo()%>'>
                      &nbsp;&nbsp;&nbsp;
		      (내장색상(시트): <input type='text' name="in_col" size='20' class='text' value='<%=car.getIn_col()%>'> )                        
                      &nbsp;&nbsp;&nbsp;
		      (가니쉬: <input type='text' name="garnish_col" size='20' class='text' value='<%=car.getGarnish_col()%>'> )                        
                    </td>
                </tr>
                <tr>
                	<td class="title">연비</td>
                	<td colspan="5">&nbsp;<%=car.getConti_rat()%></td>
                </tr>
                <%if(ej_bean.getJg_g_7().equals("3")){//전기차%>
                <tr>
                    <td class='title'>전기차 고객주소지</td>
                    <td colspan="5">&nbsp;
                        <select name="ecar_loc_st">
                    	  <option value=""  <%if(pur.getEcar_loc_st().equals(""))%>selected<%%>>선택</option>
                    	  <%for(int i = 0 ; i < code34_size ; i++){
                            CodeBean code = code34[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getEcar_loc_st().equals(code.getNm_cd())){%>selected<%}%> <%if(Integer.parseInt(cm_bean.getJg_code()) > 8000000 && (code.getNm_cd().equals("12") || code.getNm_cd().equals("13"))){ %>style='display: none;'<%} %>><%= code.getNm()%></option>
                        <%}%>        
                      </select>
        			  </td>
                </tr>	
                <%}%> 
                <%if(ej_bean.getJg_g_7().equals("4")){//수소차%>
                <tr>
                    <td class='title'>수소차 고객주소지</td>
                    <td colspan="5">&nbsp;
                        <select name="hcar_loc_st">
                    	  <option value=""  <%if(pur.getHcar_loc_st().equals(""))%>selected<%%>>선택</option>
                    	  <%for(int i = 0 ; i < code37_size ; i++){
                            CodeBean code = code37[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getHcar_loc_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>        
                      </select>
        			  </td>
                </tr>	
                <%}%>                 
                <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//친환경차-연료종류 %>
                <tr <%if (ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%>style="display: none;"<%}%>>
                    <%-- <td class='title'>맑은서울스티커 발급<br>(남산터널 이용 전자태그)</td>
                    <td colspan="5">&nbsp;
                        <select name="eco_e_tag" id="eco_e_tag">
                        <option value="0" <%if(car.getEco_e_tag().equals("") || car.getEco_e_tag().equals("0"))%>selected<%%>>미발급</option>
                        <option value="1" <%if(car.getEco_e_tag().equals("1"))%>selected<%%>>발급</option>
                      </select>
                      &nbsp;※ 친환경차 고객 중 남산터널 실이용자만 발급 선택, 하이브리드/플러그인 하이브리드 차량의 경우 서울등록으로 대여료가 소폭 상승됨.
        			      </td> --%>
        			<input type="hidden" name="eco_e_tag" id="eco_e_tag" value="<%=car.getEco_e_tag()%>">
                </tr>		
                <%}%>	                                           
                <tr>
                    <td class='title'> 차량인수지</td>
                    <td <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>colspan="3"<%} else { %>colspan="5"<% } %>>&nbsp;
						<select name="udt_st" class='default'>
							<option value=''>선택</option>
							<option value="1" <%if(base.getBrch_id().equals("S1")||base.getBrch_id().equals("S2")||base.getBrch_id().equals("I1")||base.getBrch_id().equals("K3"))%> selected<%%>>서울본사</option>
							<option value="2" <%if(base.getBrch_id().equals("B1"))%> selected<%%>>부산지점</option>
							<option value="3" <%if(base.getBrch_id().equals("D1"))%> selected<%%>>대전지점</option>				
							<option value="5" <%if(base.getBrch_id().equals("G1"))%> selected<%%>>대구지점</option>
							<option value="6" <%if(base.getBrch_id().equals("J1"))%> selected<%%>>광주지점</option>				
							<option value="4" >고객</option>
						</select>
        			  &nbsp; 인수시 탁송료 :
        			  <input type='text' name='cons_amt1' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> 원 (고객인수일 때는 직접 입력하세요.)
        			  
        			 	<%if (car.getHipass_yn().equals("")) { // 20181012 하이패스여부 (기존값 유지를 위해 select에서 input으로 히든 처리)%>
							<input type="hidden" name="hipass_yn" value="">
						<%} else {%>
							<input type="hidden" name="hipass_yn" value="<%=car.getHipass_yn()%>">
						<%}%>
						
						<%if (!(base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001"))) {%>
							<%if (car.getBluelink_yn().equals("")) {%>
								<input type="hidden" name="bluelink_yn" value="">
							<%} else {%>
								<input type="hidden" name="bluelink_yn" value="<%=car.getBluelink_yn()%>">
							<%}%>
						<%}%>
                    </td>
                    <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>
	                    <td class='title'>블루링크여부</td>
	                    <td>&nbsp;
	                        <select name="bluelink_yn">
	                            <option value='Y' <%if(car.getBluelink_yn().equals("Y"))%>selected<%%>>있음</option>
	                            <option value='N' <%if(car.getBluelink_yn().equals("N") || car.getBluelink_yn().equals(""))%>selected<%%>>없음</option>
	                        </select>
	                        <span style="font-size : 8pt; letter-spacing: -0.6px;">&nbsp;※ 있음선택시 블루링크 가입 안내문 알림톡발송(스케줄생성시)</span>
	                    </td>
                    <% } %>
                </tr>
                <tr>
                    <td class='title'>등록지역</td>
                    <td colspan="3" >&nbsp;
                      <select name="car_ext" id="car_ext" class='default'>
                        <option value=''>선택</option>
                        <%if(ej_bean.getJg_g_7().equals("3")){//전기차%>
                        		<option value='1' selected>서울</option>
                        		<option value='7'>인천</option>
                        		<option value='5'>대전</option>
                        		<option value='9'>광주</option>
                        		<option value='10'>대구</option>
                        		<option value='3'>부산</option>
                        <%}else if(ej_bean.getJg_g_7().equals("4")){//수소차%>
                        		<!-- <option value='1' selected>서울</option> -->
                        		<option value='7' selected>인천</option>
                        <%}else{%>
								<option value='7' selected>인천</option>
							<%	if(ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")){//하이브리드 친환경차%>
                        		<option value='1'>서울</option>
                        	<%	}%> 
						<%}%>
                      </select></td>
                    <td class='title'>썬팅</td>
                    <td>&nbsp;
                      <input type='text' name="sun_per" value='<%=car.getSun_per()%>' size="4" maxlength="4" class='text'>
        			  %</td>
                </tr>
                <tr>
                    <td class='title'>LPG키트</td>
                    <td colspan="5" >
        			    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="80">&nbsp;
                                  <select name='lpg_yn'>
                                    <option value="">선택</option>
                                    <option value="Y" <%if(car.getLpg_yn().equals("Y")) out.println("selected");%>>장착</option>
                                    <option value="N" <%if(car.getLpg_yn().equals("N")) out.println("selected");%>>미장착 </option>
                                  </select>
                              </td>
                              <td width="110">&nbsp;
                                  <select name='lpg_setter'>
                                    <option value=''>선택</option>
                                    <option value='1' <%if(car.getLpg_setter().equals("1")){%> selected <%}%>>고객장착</option>
                                    <option value='2' <%if(car.getLpg_setter().equals("2")){%> selected <%}%>>월대여료포함</option>
                                  </select>
                              </td>
                              <td width="110">&nbsp;
                                  <select name='lpg_kit'>
                                    <option value=''>선택</option>
            						<%if(ej_bean.getJg_e().equals("1")){%>
                                    <option value='1' <%if(car.getLpg_kit().equals("1")){%> selected <%}%>>간접분사</option>
            						<%}%>
            						<%if(ej_bean.getJg_e1()>0){%>
                                    <option value='2' <%if(car.getLpg_kit().equals("2")){%> selected <%}%>>직접분사</option>
            						<%}%>
            						<%if(ej_bean.getJg_e().equals("3")){%>
                                    <option value='3' <%if(car.getLpg_kit().equals("3")){%> selected <%}%>>장착불가</option>
            						<%}%>
                                  </select>
                              </td>
                              <td>&nbsp;
                                  <input type='text' name='lpg_price' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getLpg_price())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
            					  원 </td>
                            </tr>
                        </table>
        			</td>
                </tr>	
                <tr>
                    <td class='title'><span class="title1">출고후추가장착</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='add_opt' size='45' class="text" value='<%=car.getAdd_opt()%>'>
        				&nbsp;<input type='text' name='add_opt_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  원&nbsp;<span style="font-size : 8pt;"><font color="#666666">(부가세포함금액,견적반영분,LPG키트제외,네비게이션 등)</font></span>
                    </td>
                </tr>
                <tr>
                    <td class='title'><span class="title1">견적반영용품</span></td>
                    <td colspan="5">&nbsp;
                      <label><input type="checkbox" name="tint_b_yn" value="Y" <%if(car.getTint_b_yn().equals("Y")){%>checked<%}%>> 2채널 블랙박스</label>
                      &nbsp;
                      <label><input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y") || !(cm_bean.getCar_comp_id().equals("0056") || cm_bean.getCar_comp_id().equals("0057") ||  (Integer.parseInt(cm_bean.getJg_code()) > 9017300 && Integer.parseInt(cm_bean.getJg_code()) < 9018200)) ){%>checked<%}%>> 전면 썬팅(기본형)</label>,
                      &nbsp;
                      가시광선투과율 :
                      <input type='text' name="tint_s_per" value='<%=car.getTint_s_per()%>' size="4" maxlength="4" class='text'>
        	      % 
      		      &nbsp;
      		      <label><input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> 고급썬팅(전면포함)</label>
      		      &nbsp;&nbsp;내용 <input type="text" name="tint_ps_nm" size="10" value='<%=car.getTint_ps_nm()%>'>
      		      &nbsp; 용품점 지급금액 <input type="text" name="tint_ps_amt" size="10" value='<%=car.getTint_ps_amt()%>'> 원 (부가세별도)      		      
      		      <br>
      		      &nbsp;
      		      	  <label><input type="checkbox" name="tint_sn_yn" value="Y" <%if(car.getTint_sn_yn().equals("Y")){%>checked<%}%>> 전면썬팅 미시공 할인</label>
      		      	  <label><input type="checkbox" name="tint_bn_yn" value="Y" <%if(car.getTint_bn_yn().equals("Y")){%>checked<%}%>> 블랙박스 미제공 할인      		      	   
                  		&nbsp; 할인사유 : 
                  		<select name="tint_bn_nm">
                  		<option value=""  <%if (car.getTint_bn_nm().equals("")){%>selected<%}%>>선택</option>
                  		<option value="2" <%if (car.getTint_bn_nm().equals("2")){%>selected<%}%>>고객장착</option>
                   		<option value="1" <%if (car.getTint_bn_nm().equals("1")){%>selected<%}%>>빌트인캠</option>                   		
                   		</select>
      		      	  </label>
					  <label><input type="checkbox" name="tint_cons_yn" value="Y" <%if(car.getTint_cons_yn().equals("Y")){%>checked<%}%>> 추가탁송료등 </label>
                      <input type="text" name="tint_cons_amt" class='num' size="10" value='<%=car.getTint_cons_amt()%>'> 원
                      <label <%if(!car.getTint_n_yn().equals("Y")){%>style="display: none;"<%}%>>&nbsp;<input type="checkbox" name="tint_n_yn" value="Y" <%if(car.getTint_n_yn().equals("Y")){%>checked<%}%>> 거치형 내비게이션</label>
                      <%if(ej_bean.getJg_g_7().equals("3")){//전기차%>
      		      &nbsp;
                      <label <%if(!car.getTint_eb_yn().equals("Y")){%>style="display: none;"<%}%>>&nbsp;<input type="checkbox" name="tint_eb_yn" value="Y" <%if(car.getTint_eb_yn().equals("Y")){%>checked<%}%>> 이동형 충전기(전기차)</label>
                      <%}%>   
                      &nbsp;
                      	<label> 번호판구분</label>
                      	<!-- <label> 신형번호판신청</label> -->
                      	<select name="new_license_plate">
                      		<%if( !( (Integer.parseInt(ej_bean.getSh_code()) > 9018110 && Integer.parseInt(ej_bean.getSh_code()) < 9018999) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")
                      				|| cm_bean.getCar_comp_id().equals("0044") || cm_bean.getCar_comp_id().equals("0007") || cm_bean.getCar_comp_id().equals("0025") || cm_bean.getCar_comp_id().equals("0033") || cm_bean.getCar_comp_id().equals("0048")) ){ %>
                      		<option value="1" <%if (car.getNew_license_plate().equals("") || car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>신형</option>
                      		<% } %>
                      		<option value="0" <%if (car.getNew_license_plate().equals("0")) {%>selected<%}%>>구형</option>
                      		<%-- <option value="" <%if (car.getNew_license_plate().equals("")) {%>selected<%}%>>요청없음</option>
                      		<option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>신청</option> --%>
<%--                       		<option value="1" <%if (car.getNew_license_plate().equals("1")) {%>selected<%}%>>수도권</option> --%>
<%--                       		<option value="2" <%if (car.getNew_license_plate().equals("2")) {%>selected<%}%>>대전/대구/광주/부산</option> --%>
                      	</select>                   
                    </td>
                </tr>                
                <tr>
                    <td class='title'><span class="title1">서비스품목</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='extra_set' size='45' class="text" value='<%=car.getExtra_set()%>'>
        				&nbsp;<input type='text' name='extra_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getExtra_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  원&nbsp;<span style="font-size : 8pt;"><font color="#666666">(부가세포함금액,견적미반영분)</font></span>
        					  &nbsp;<input type="checkbox" name="serv_b_yn" value="Y" <%if(car.getServ_b_yn().equals("Y")){%>checked<%}%>> 블랙박스 (2015년8월1일부터)
        					  <%if(ej_bean.getJg_g_7().equals("3")){%>
								&nbsp;<input type="checkbox" name="serv_sc_yn" value="Y" <%if(car.getServ_sc_yn().equals("Y")){%>checked<%}%>> 고정형충전기
							  <%} %>
                    </td>
                </tr>
                <tr>
                    <td class='title'>비고</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='5' cols='90' class=default name='remark'><%=car.getRemark()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td><font color="#666666">* LPG키트 : LPG키트 추가장착시 입력 / * 추가장착 : LPG키트외 추가장착시 입력</font></td>
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
                <td class='title'>과세구분</td>
                <td colspan="3">&nbsp;
    			<%if(base.getCar_st().equals("3")){%>
    			과세<input type='hidden' name="purc_gu" value="1">
    			<%}else{
    				if(cm_bean.getS_st().equals("401") || cm_bean.getS_st().equals("402") || cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("821")){%>
    				비과세<input type='hidden' name="purc_gu" value="0">
    			<%	}else{%>
    				면세<input type='hidden' name="purc_gu" value="0">
    			<%	}%>
    			<%}%>                    			    		
                </td>
                <td class='title'>출처</td>
                <td colspan="3">&nbsp;<%String car_origin = car.getCar_origin();%>
    			<%	if(car_origin.equals("")){
    					code_bean = c_db.getCodeBean("0001", cm_bean.getCar_comp_id(), "");
    					car_origin = code_bean.getApp_st();
    				}%>
    			<%if(car_origin.equals("1")){%>국산<%}else if(car_origin.equals("2")){%>수입<%}%>
    			<input type='hidden' name="car_origin" value="<%=car_origin%>"></td>
              </tr>
              <tr>
                <td width="13%" rowspan="2" class='title'>구분 </td>
                <td colspan="3" class='title'>소비자가격</td>
                <td width="10%" rowspan="2" class='title'>구분</td>
                <td colspan="3" class='title'>구입가격</td>
              </tr>
              <tr>
                <td width="13%" class='title'>공급가</td>
                <td width="13%" class='title'>부가세</td>
                <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_c_amt()" onMouseOver="window.status=''; return true" title="소비자가 합계 계산하기">합계</a></span></td>
                <td width="13%" class='title'>공급가</td>
                <td width="12%" class='title'>부가세</td>
                <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_f_amt()" onMouseOver="window.status=''; return true" title="구입가 합계 계산하기">합계</a></span></td>
              </tr>
              <tr>
                <td class='title'> 기본가격</td>
                <td>&nbsp;
                  <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td class=title>차량가격</td>
                <td>&nbsp;
                  <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
              </tr>
              <tr>
                <td height="12" class='title'>옵션</td>
                <td>&nbsp;
                  <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type="hidden" name="opt_amt_m" value="<%=AddUtil.parseDecimal(car.getOpt_amt_m())%>">
                  <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
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
                  <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td class=title><span class="b"><a href="javascript:search_dc()" onMouseOver="window.status=''; return true" title="클릭하세요">매출D/C</a></span></td>
                <td>&nbsp;
                  <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' readonly maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
    				원</td>
                <td>&nbsp;
                  <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' readonly maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
    				원</td>
                <td>&nbsp;
                  <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' readonly maxlength='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
    				원</td>
              </tr>
              <tr id=tr_ecar_dc <%if(car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//친환경차%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'> 개소세 감면액</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>                  
              <tr>
                <td align="center" class='title_p'>합계</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_cs_amt' size='10' value='' class='fixnum' readonly>
    			    원</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_cv_amt' size='10' value='' class='fixnum' readonly>
    				원</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_c_amt' size='10' value='' class='fixnum'  readonly>
    				원</td>
                <td align='center' class='title_p'>합계</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_fs_amt' size='10' value='' class='fixnum' readonly>
    				원</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_fv_amt' size='10' value='' class='fixnum' readonly>
    				원</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_f_amt' size='10' value='' class='fixnum'  readonly>
    				원</td>
              </tr>
              <tr id=tr_sptax style='display:none'>
                <td class='title'>납부여부</td>
                <td>&nbsp;
                  <select name='pay_st'>
                    <option value="">선택</option>
                    <option value="1" <%if(car.getPay_st().equals("1")){%> selected <%}%>>과세</option>
                    <option value="2" <%if(car.getPay_st().equals("2")){%> selected <%}%>>면세</option>
                  </select>
                </td>
                <td class='title'>특소세</td>
                <td >&nbsp;
                  <input type='text' name='spe_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax())%>' maxlength='7' class='fixnum' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
    				원</td>
                <td class='title'>교육세</td>
                <td >&nbsp;
                  <input type='text' name='edu_tax' size='10' value='<%=AddUtil.parseDecimal(car.getEdu_tax())%>' maxlength='7' class='fixnum' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
    				원</td>
                <td class='title'>합계</td>
                <td >&nbsp;
                  <input type='text' name='tot_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax()+car.getEdu_tax())%>' maxlength='7' class='fixnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>
    				원</td>
              </tr>
            </table>		
	    </td>
    </tr>
    <!-- 제조사 할인 후 차량가격 표시(20190911)- 신차이고 신규계약인 경우만 -->
    <%if(base.getCar_gu().equals("1")){ %>
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
    <%if(ej_bean.getJg_w().equals("1")){//수입차%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수입차 견적시 적용</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>카드결제금액</td>
                    <td>&nbsp;
                        <input type='text' name='import_card_amt' value='<%= AddUtil.parseDecimal(car.getImport_card_amt())%>'size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    </td>
                    <td width="10%" class='title'>Cash Back금액</td>
                    <td>&nbsp;
        		<input type='text' name='import_cash_back' value='<%= AddUtil.parseDecimal(car.getImport_cash_back())%>'size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
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
                        <input type='text' name='ecar_pur_sub_amt' readonly value='<%= AddUtil.parseDecimal(car.getEcar_pur_sub_amt())%>' size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    </td>
                    <td width="10%" class='title'>보조금수령방식</td>
                    <td>&nbsp;
        		            <select name='ecar_pur_sub_st'  disabled>
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
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험사항</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td width="13%"  class=title>보험계약자</td>
                <td width="20%">&nbsp;
                    <select name='insurant' class='default'>                      
                      <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>아마존카</option>
                  </select></td>
                <td width="10%"  class=title>피보험자</td>
                <td colspan='3'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                    <select name='insur_per' onChange='javascript:display_ip(); set_insur_serv();' class='default'>
                      <option value="">선택</option>
                      <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>아마존카</option>
                      <%if(car_st.equals("3")){%>
                      <!--  <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>고객</option>-->
                      <%}%>
                  </select></td>
              </tr>
              <tr> 
                <td width="13%" class=title>운전자범위</td>
                <td width="20%" class=''>&nbsp;
    		  <select name='driving_ext'>
                      <option value="">선택</option>
                      <option value="1" <%if(base.getDriving_ext().equals("1") || base.getDriving_ext().equals("")){%> selected <%}%>>모든사람</option>
                      <%if(car_st.equals("3")){%>
                      <option value="2" <%if(base.getDriving_ext().equals("2")){%> selected <%}%>>가족한정</option>
                      <option value="3" <%if(base.getDriving_ext().equals("3")){%> selected <%}%>>기타</option>
                      <%}%>
                  </select>			
    			</td>
                <td width="10%" class=title >운전자연령</td>
                <td>&nbsp;
                    <select name='driving_age'>
                      <option value="">선택</option>
                      <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>만26세이상</option>
                      <%if(car_st.equals("3")){%>
                      <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>만24세이상</option>
                      <%}%>
                      <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>만21세이상</option>
                      <%if(car_st.equals("3")){%>
                      <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>모든운전자</option>
		      <option value=''>=피보험자고객=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>만30세이상</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>만35세이상</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>만43세이상</option>						
		      <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>만48세이상</option>
		      <%}%>
                  </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a></td>
                <td class=title >임직원운전한정특약</td>
                <td class=''>&nbsp;
                  <select name='com_emp_yn'>
                    <option value="">선택</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>가입</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>미가입</option>
                  </select></td>                    
              </tr>              
              <tr>
                <td width="13%" class=title>대인배상</td>
                <td width="20%">&nbsp; 무한(대인배상Ⅰ,Ⅱ)</td>
                <td width="10%" class=title>대물배상</td>
                <td width="20%" class=''>&nbsp;
                    <select name='gcp_kd'>
                      <option value="">선택</option>
                      <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                      <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1억원</option>
                      <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2억원</option>
					  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3억원</option>
                      <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5억원</option>					  
                  </select></td>
                <td width="10%" class=title >자기신체사고</td>
                <td class=''>&nbsp;
                    <select name='bacdt_kd'>
                      <option value="">선택</option>                      
                      <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1억원</option>
                  </select></td>
              </tr>
              <tr>
                <td  class=title>무보험차상해</td>
                <td>&nbsp;<%if(cont_etc.getCanoisr_yn().equals("")) cont_etc.setCanoisr_yn("Y");%>
                  <select name='canoisr_yn'>
                    <option value="">선택</option>
                    <option value="Y" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> selected <%}%>>가입</option>
                    <option value="N" <%if(cont_etc.getCanoisr_yn().equals("N")){%> selected <%}%>>미가입</option>
                  </select>            </td>
                <td class=title>자기차량손해</td>
                <td class=''>&nbsp;<%if(cont_etc.getCacdt_yn().equals("")) cont_etc.setCacdt_yn("N");%>
                  <select name='cacdt_yn' class='default'>
                    <option value="">선택</option>
                    <option value="Y" <%if(cont_etc.getCacdt_yn().equals("Y")){%> selected <%}%>>가입</option>
                    <option value="N" <%if(cont_etc.getCacdt_yn().equals("N")){%> selected <%}%>>미가입</option>
                  </select>              </td>
                <td class=title >긴급출동</td>
                <td class=''>&nbsp;<%if(cont_etc.getEme_yn().equals("")) cont_etc.setEme_yn("N");%>
                  <select name='eme_yn'>
                    <option value="">선택</option>
                    <option value="Y" <%if(cont_etc.getEme_yn().equals("Y")){%> selected <%}%>>가입</option>
                    <option value="N" <%if(cont_etc.getEme_yn().equals("N")){%> selected <%}%>>미가입</option>
                  </select></td>
              </tr>
              <tr>
                <td  class=title>자차면책금</td>
                <td>&nbsp;
    			<input type='text' size='12' maxlength='10' name='car_ja' class='num' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			원</td>
                <td class=title>변경사유</td>
                <td class=''>&nbsp;
                  <input type='text' size='18' name='ja_reason' class='text' value='<%=cont_etc.getJa_reason()%>'></td>
                <td class=title >결재자</td>
                <td class=''>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getRea_appr_id(), "USER")%>" size="12"> 
			<input type="hidden" name="rea_appr_id" value="<%=cont_etc.getRea_appr_id()%>">
			<a href="javascript:User_search('rea_appr_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>				
			<% user_idx++;%>
                    (기본 <input type='text' size='6' maxlength='10' name='imm_amt' class='whitenum' value='<%if(car.getCar_origin().equals("2")){%>500,000<%}else{%>300,000<%}%>' readonly>원) </td>
              </tr>
              <tr>
                <td  class=title>자동차</td>
                <td colspan="5">&nbsp;
    			  <select name="air_ds_yn">
                    <option value="">선택</option>
                    <option value="Y" <%if(cm_bean.getAir_ds_yn().equals("Y")){%> selected <%}%>>유</option>
                    <option value="N" <%if(cm_bean.getAir_ds_yn().equals("N")){%> selected <%}%>>무</option>
                  </select>
    				운전석에어백
    			  <select name="air_as_yn">
                    <option value="">선택</option>
                    <option value="Y" <%if(cm_bean.getAir_as_yn().equals("Y")){%> selected <%}%>>유</option>
                    <option value="N" <%if(cm_bean.getAir_as_yn().equals("N")){%> selected <%}%>>무</option>
                  </select>	
    				조수석에어백
    			 &nbsp; 			
                      <select name="blackbox_yn">
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getBlackbox_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			블랙박스  
        			<br/>		
        			&nbsp; 	
                      <select name="lkas_yn" id="lkas_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getLkas_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getLkas_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			차선이탈(제어형)	
        			&nbsp; 			
                      <select name="ldws_yn" id="ldws_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getLdws_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getLdws_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			차선이탈(경고형)	
        			&nbsp; 			
                      <select name="aeb_yn" id="aeb_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getAeb_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getAeb_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			긴급제동(제어형)	
        			&nbsp; 			
                      <select name="fcw_yn" id="fcw_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getFcw_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getFcw_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			긴급제동(경고형)	
        			&nbsp; 			
                      <select name="ev_yn" id="ev_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getEv_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getEv_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			전기자동차	
        			<br/>
        			&nbsp; 	
					  <select name="hook_yn" id="hook_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getHook_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getHook_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			견인고리(트레일러용)
        			&nbsp; 			
                      <select name="legal_yn" id="legal_yn" >
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getLegal_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getLegal_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>	
        			법률비용지원금(고급형)
        			&nbsp; 			
        			<select name="top_cng_yn" id="top_cng_yn" >
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getTop_cng_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getTop_cng_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			탑차(견인고리)
        			<br/>        				
        				&nbsp;  
        				기타장치 : 
                      <input type="text" class="text" name="others_device" value="<%=cont_etc.getOthers_device()%>" size="50">     
                  </td>
              </tr>
              <tr>
                <td  class=title>차량관리<br>서&nbsp;비&nbsp;스<br>제공범위</td>
                <td colspan="5">&nbsp;
                	<%if(Integer.parseInt(base.getRent_dt()) < 20210322){%>
                      		<input type="checkbox" name="ac_dae_yn" 	value="Y" <%if(cont_etc.getAc_dae_yn().equals("Y")){%>checked<%}%>>
                    <%} else {%>
                      		<input type="hidden" name="ac_dae_yn" value="Y" >
                      		&nbsp;* 
                    <%} %>  
                      		사고대차서비스(피해사고시 제외)<br>
        			  &nbsp;
        			  <%if(Integer.parseInt(base.getRent_dt()) < 20210322){%>
        			  		<input type="checkbox" name="pro_yn" 		value="Y" <%if(cont_etc.getPro_yn().equals("Y")){%>checked<%}%>>
        			  <%} else {%>
                      		<input type="hidden" name="pro_yn" value="Y" >
                      		&nbsp;* 
                      <%} %>  
        			  교통사고 발생시 사고처리 업무대행 (보험사 관련 업무 등) <br>
        			  &nbsp;
        			  <input type="checkbox" name="main_yn" 	value="Y" <%if(cont_etc.getMain_yn().equals("Y")){%>checked<%}%>> 
                      		  일체의 정비서비스(각종 내구성부품/소모품  점검,교환,수리) * 제조사 차량 취급설명서 기준 <br>
        			  &nbsp;
        			  <input type="checkbox" name="ma_dae_yn" 	value="Y" <%if(cont_etc.getMa_dae_yn().equals("Y")){%>checked<%}%>> 
                      		  정비대차서비스(4시간 이상 정비공장 입고시) <br>
    			  </td>
              </tr>
              <tr id=tr_ip style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                <td  class=title>입보회사</td>
                <td colspan="5">
                    <table width="100%" border="0" cellpadding="0">
                      <tr>
                        <td width="100%">&nbsp;보험사  :
                            <input type='text' name='ip_insur' value='<%=cont_etc.getIp_insur()%>' size='12' class='text'>
              				&nbsp;대리점 : 
              				<input type='text' name='ip_agent' value='<%=cont_etc.getIp_agent()%>' size='15' class='text'>
              				&nbsp;담당자 :
              				<input type='text' name='ip_dam' value='<%=cont_etc.getIp_dam()%>' size='10' class='text'>
        					&nbsp;연락처 :
        					<input type='text' name='ip_tel' value='<%=cont_etc.getIp_tel()%>' size='13' class='text'>
        					</td>
                      </tr>
                    </table>
                 </td>
                </tr>
              <tr id=tr_ip2 style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                <td  class=title>차량손해</td>
                <td colspan="5">
                    <table width="100%" border="0" cellpadding="0">
                      <tr>
                        <td width="100%">&nbsp;물적사고할증기준
					  <select name='cacdt_mebase_amt' onChange="javascript:setCacdtMeAmt();" align="absmiddle">
					    <option value=""    <%if(cont_etc.getCacdt_mebase_amt()==0  ){%>selected<%}%>>선택</option>
					    <option value="50"  <%if(cont_etc.getCacdt_mebase_amt()==50 ){%>selected<%}%>>50만원</option>
					    <option value="100" <%if(cont_etc.getCacdt_mebase_amt()==100){%>selected<%}%>>100만원</option>
					    <option value="150" <%if(cont_etc.getCacdt_mebase_amt()==150){%>selected<%}%>>150만원</option>
					    <option value="200" <%if(cont_etc.getCacdt_mebase_amt()==200){%>selected<%}%>>200만원</option>
					  </select>
					  / (최대)자기부담금 
                      <input type='text' size='6' name='cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(cont_etc.getCacdt_me_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                      만원 
					  / (최소)자기부담금  
                      <select name='cacdt_memin_amt'>
                        <option value=""   <%if(cont_etc.getCacdt_memin_amt()==0 ){%>selected<%}%>>선택</option>
                        <option value="5"  <%if(cont_etc.getCacdt_memin_amt()==5 ){%>selected<%}%>>5만원</option>
                        <option value="10" <%if(cont_etc.getCacdt_memin_amt()==10){%>selected<%}%>>10만원</option>
                        <option value="15" <%if(cont_etc.getCacdt_memin_amt()==15){%>selected<%}%>>15만원</option>
                        <option value="20" <%if(cont_etc.getCacdt_memin_amt()==20){%>selected<%}%>>20만원</option>
                      </select>      
                			    </td>
                      </tr>
                    </table>
                 </td>
                </tr>				
                <tr>
                      <td class='title'>비고</td>
                      <td colspan="5">&nbsp;
                        <textarea rows='3' cols='90' class=default name='others'><%=base.getOthers()%></textarea></td>
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
	<tr id=tr_gi style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td class=title width="13%">가입여부</td>
                <td colspan="5">&nbsp;
                    <input type='radio' name="gi_st" value='1' onClick="javascript:display_gi()" <%if(gins.getGi_st().equals("1")){%> checked <%}%>>
              		가입
              		<input type='radio' name="gi_st" value='0' onClick="javascript:display_gi()" <%if(gins.getGi_st().equals("0")){%> checked <%}%>>
              		면제 </td>
              </tr>
              <tr id=tr_gi1 style="display:<%if(gins.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                <td class=title>발행지점</td>
                <td width="20%">&nbsp;<input type='hidden' name='gi_no' value='<%=gins.getGi_no()%>'>
    			   <input type='text' name='gi_jijum' value='<%=gins.getGi_jijum()%>' size='12' class='text'>
                </td>
                <td width="10%" class='title'>가입금액</td>
                <td width="20%" >&nbsp;
                    <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt()'>
              		원</td>
                <td class=title >보증보험료</td>
                <td>&nbsp;
                    <input type='text' name='gi_fee' size='9' maxlength='20' class='whitenum' readonly value='<%=AddUtil.parseDecimal(gins.getGi_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
              		원</td>
              </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금</span></td>
    </tr>
              <%
              		int e_agree_dist =0;
              	
              		//20151211 신차,재리스 모두 표준약정운행거리 조정
              	
              		fee_etc.setAgree_dist(30000);
              		
              		if(AddUtil.parseInt(base.getRent_dt()) >= 20220415){
            			fee_etc.setAgree_dist(23000);
            		}
              		
			//디젤 +5000
			if(ej_bean.getJg_b().equals("1")){
				fee_etc.setAgree_dist(fee_etc.getAgree_dist()+5000);
			}				
			
			//LPG +10000 -> 20190418 +5000
			if(ej_bean.getJg_b().equals("2")){
				fee_etc.setAgree_dist(fee_etc.getAgree_dist()+5000);
			}
			
			e_agree_dist = fee_etc.getAgree_dist();
					
			//테슬라 약정운행거리 2만 고정 - 20190801 초과부담금 450원 고정
// 			if(cm_bean.getJg_code().equals("4854") || cm_bean.getJg_code().equals("5866") || cm_bean.getJg_code().equals("3871") || cm_bean.getJg_code().equals("4314111") || cm_bean.getJg_code().equals("6316111") || cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("3313112") || cm_bean.getJg_code().equals("3313113") || cm_bean.getJg_code().equals("3313114")){
			if(cm_bean.getCar_comp_id().equals("0056")){
				if(AddUtil.parseDecimal(fee_etc.getAgree_dist()).equals("0")){
			//		fee_etc.setAgree_dist(20000);
					fee_etc.setOver_run_amt(450);
				}
			} 
			
              %>                  
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td width="13%" align="center" class=title>이용기간</td>
                <td colspan='3'>&nbsp;
                    <input type='text' name="con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 개월
					 <input type='hidden' name='rent_start_dt' value='<%=fee.getRent_start_dt()%>'>
					 <input type='hidden' name='rent_end_dt' value='<%=fee.getRent_end_dt()%>'>					 					 
					 </td>
              </tr>
              <tr>
                <td width="13%" align="center" class=title>판정신용등급</td>
                <td width="20%">&nbsp;
    			  <input type='hidden' name='dec_gr' value='<%=cont_etc.getDec_gr()%>'>
    			  <input type='hidden' name='spr_kd' value='<%=base.getSpr_kd()%>'>
    			  <% if(base.getSpr_kd().equals("3")) out.print("신설법인"); 	%>
                  <% if(base.getSpr_kd().equals("0")) out.print("일반고객"); 	%>
                  <% if(base.getSpr_kd().equals("1")) out.print("우량기업"); 	%>
                  <% if(base.getSpr_kd().equals("2")) out.print("초우량기업");  %>
    			</td>
                <td width="10%" class=title>연대보증</td>
                <td >&nbsp;
    			<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%>
    			대표자 : 보증 /
    			<%}%>
    			연대보증 :
    			<%if(cont_etc.getGuar_st().equals("1")){%>
    			(<%=gur_size%>)명
    			<%	if(gur_size > 0){
    		  			for(int i = 0 ; i < gur_size ; i++){
    						Hashtable gur = (Hashtable)gurs.elementAt(i);%>	
    					<%=gur.get("GUR_NM")%>&nbsp;
    					<%	}%>
    					
    			<%	}%>
    			<%}else{%>
    			면제
    			<%}%>
    			</td>
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
                <td align='center'><input type='text' size='11' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">차가의
                    <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fee.getGur_p_per()%>' readonly>
    				  % </td>
                <td align='center'><input type='hidden' name='gur_per' value=''><input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>'>                
					<%if(base.getRent_st().equals("3")){%>
					대차 보증금 승계여부 :
					<select name='grt_suc_yn'>
                              <option value="">선택</option>
                              <option value="0">승계</option>
                              <option value="1">별도</option>
                            </select>	
					<%}%>		
					</td>
              </tr>
              <tr>
                <td class='title' colspan="2">선납금</td>
                <td align="center"><input type='text' size='11' name='pp_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getPp_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='pp_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='pp_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">차가의
                    <input type='text' size='4' name='pere_r_per' class='fixnum' value='<%=fee.getPere_r_per()%>' readonly>
    				  % </td>
                <td align='center'><input type='hidden' name='pere_per' value=''>
           선납금 계산서발행구분 :
					<select name='pp_chk'>
                              <option value="">선택</option>
                              <option value="1">납부일시발행</option>
                              <option value="0">매월균등발행</option>
                            </select>                	
                	</td>
              </tr>
              <tr>
                <td class='title' colspan="2">개시대여료</td>
                <td align="center"><input type='text' size='11' name='ifee_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='ifee_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='ifee_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">마지막
                    <input type='text' size='2' name='pere_r_mth' class='fixnum' value='<%=fee.getPere_r_mth()%>' readonly>
    				  개월치 대여료 </td>
                <td align='center'>-<input type='hidden' name='pere_mth' value=''></td>
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
                      <input type='text' size='11' name='pp_est_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fee.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                </td>
                <td align='center'>&nbsp;</td>
              </tr>
              <tr>
    		<td class='title' colspan="2">총채권확보</td>
                <td colspan='3'>&nbsp;
                        결재자 : <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etc.getCredit_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="credit_sac_id" value="<%=fee_etc.getCredit_sac_id()%>">
			<a href="javascript:User_search('credit_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
			&nbsp;&nbsp;&nbsp;&nbsp;
			결재일자 : <input type='text' size='11' name='credit_sac_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fee_etc.getCredit_sac_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                </td>						
                <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='' readonly>%
    			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='fixnum' readonly>원(보증보험포함)</td>
                <td align='center'><input type='text' size='4' name='credit_per' class='fixnum' value='' readonly>%
    			<input type='text' size='10' name='credit_amt' maxlength='10' class='fixnum' readonly>원</td>
              </tr>
             
              <tr>
                <td rowspan="2" class='title'>운행<br>
                  거리</td>              
                <!--20130605 약정운행주행거리 운영-->              
                <td class='title' colspan="2"><span class="title1">약정운행거리</span></td>
                <td colspan="4">&nbsp;
		  <input type='text' name='agree_dist' size='8' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>'>
                  km이하/1년,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (약정이하운행시) 환급대여료  <input type='text' name='rtn_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)
                  <%//	if ((nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
                  <!--
                  <select name='rtn_run_amt_yn'>        
                    <option value="">선택</option>                      
                    <option value="0" <%if(fee_etc.getRtn_run_amt_yn().equals("0")||fee_etc.getRtn_run_amt_yn().equals(""))%>selected<%%>>환급대여료적용</option>
                    <option value="1" <%if(fee_etc.getRtn_run_amt_yn().equals("1"))%>selected<%%>>환급대여료미적용</option>                    
                  </select>
                  -->
                  <%//	}else{ %>
                  ※환급대여료적용
                  <input type="hidden" name="rtn_run_amt_yn" value="0">
                  <%//	} %>
                  <%}else{ %>
                  <input type="hidden" name="rtn_run_amt" value="<%=fee_etc.getRtn_run_amt()%>">
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etc.getRtn_run_amt_yn()%>">
                  <%} %>  
                  <br>&nbsp;                
                  (약정초과운행시) 초과운행대여료 <input type='text' name='over_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  매입옵션 행사시 환급대여료 : 기본식은 미지급, 일반식은 40%만 지급
                  <%} %>
                  <br>&nbsp;                  
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>만 납부
                  <!-- 
                  초과 1km당 (<input type='text' name='over_run_amt' size='3' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원)의 초과운행부담금이 부과됨 (대여종료시)	
                  <br>&nbsp;
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 50%만 납부
                   -->
                  <input type="hidden" name="agree_dist_yn" value="<%=fee_etc.getAgree_dist_yn()%>">
                  <!--                   
                  <select name='agree_dist_yn'>                              
                    <option value=""  <%if(fee_etc.getAgree_dist_yn().equals(""))%>selected<%%>>선택</option>
                    <option value="1" <%if(fee_etc.getAgree_dist_yn().equals("1"))%>selected<%%>>전액면제(기본식)</option>
                    <option value="2" <%if(fee_etc.getAgree_dist_yn().equals("2"))%>selected<%%>>50%만 납부(일반식)</option>
                    <option value="3" <%if(fee_etc.getAgree_dist_yn().equals("3"))%>selected<%%>>매입옵션 없음(기본식,일반식)</option>
                  </select>
                  -->
                  <!--	
                  <br>&nbsp;
                  ※ 약정운행거리 미적용시 약정운행거리에 <input type='text' name='ex_agree_dist' size='5' class='defaultnum' value='미적용' >과 같이 입력하면 됩니다.                  
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  ※ 예상 운행거리 <input type='text' name='cust_est_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getCust_est_km())%>' >
                  km/1년
                  -->
                </td>
                <td align='center'>                                      
                	<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                	<input type='text' name='e_rtn_run_amt' size='2' class='whitenum' value='0' >/1km<br>&nbsp;
                	<%}else{ %>
                  	<input type="hidden" name="e_rtn_run_amt" value="0">
                  	<%} %>   
                    <input type='text' name='e_over_run_amt' size='2' class='whitenum' value='0' >/1km<br>&nbsp;
                    <input type='text' name='e_agree_dist_yn' size='15' class='whitetext' value='' >
                </td>
              </tr>  
                <tr>
                    <td class='title' colspan="2" style="font-size : 8pt;">보유차주행거리</td>
                    <td colspan="6">&nbsp;
                        <input type='text' name='over_bas_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_bas_km())%>' >
                        km
                        (재리스 계약시점 대여차량 주행거리, 계약서 기재 값)
                    </td>
                </tr>	
              <tr>
                <td rowspan="4" class='title'>잔<br>
                  가</td>
                <td class='title' colspan="2">표준 최대잔가</td>
                <td align="center">-</td>
                <td align="center">-</td>
                <td align='center'>-</td>
                <td align="center">차가의
    			  <input type='text' size='4' name='b_max_ja' maxlength='10' class='<%if(base.getCar_gu().equals("1")){%>fix<%}else{%>default<%}%>num' value='<%=fee.getB_max_ja()%>' <%if(base.getCar_gu().equals("1")){%>readonly<%}%>>
    			  % </td>
                <td align='center'><input type='text' name='e_agree_dist' size='6' class='whitenum' value='<%=e_agree_dist%>' >km/1년</td>
              </tr>                              
              <tr>
                <td class='title' colspan="2">조정 최대잔가</td>
                <td align="center"><input type='text' size='11' name='ja_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='ja_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='ja_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_s_amt()+fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">차가의
    			  <input type='text' size='4' name='max_ja' maxlength='10' readonly class='fixnum' value='<%=fee.getMax_ja()%>' readonly>
    			  % </td>
                <td align='center'><input type='text' name='r_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' >km/1년</td>
              </tr>
              <tr>
                <td class='title' colspan="2">매입옵션</td>
                <td align="center"><input type='text' size='11' name='opt_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='opt_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='opt_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">차가의
                    <input type='text' size='4' name='opt_per' class='defaultnum' value='<%=fee.getOpt_per()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  % </td>
                <td align='center'>
    			  <input type='radio' name="opt_chk" value='0' <%if(fee.getOpt_chk().equals("0")){%> checked <%}%>>
                  없음
                  <input type='radio' name="opt_chk" value='1' <%if(fee.getOpt_chk().equals("1")){%> checked <%}%>>
    	 		  있음
                </td>
              </tr>
              <tr>
                <td class='title' colspan="2">적용잔가</td>
                <td align="center"><input type='text' size='11' name='ja_r_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='ja_r_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='ja_r_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_s_amt()+fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">차가의
    			  <input type='text' size='4' name='app_ja' maxlength='10' readonly class="defaultnum" value='<%=fee.getApp_ja()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    			  % </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td rowspan="6" class='title'>대<br>여<br>료</td>
                <td class='title' colspan="2">계약요금</td>
                <td align="center" ><input type='text' size='11'  name='fee_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center" ><input type='text' size='11'  name='fee_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center' ><input type='text' size='11'  name='fee_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">-</td>
                <td align='center'>
				월대여료납입방식 :
					  <select name='fee_chk'>
                              <option value="">선택</option>
                              <option value="0" <%if(fee.getFee_chk().equals("0"))%>selected<%%>>매월납입</option>
                              <option value="1" <%if(fee.getFee_chk().equals("1"))%>selected<%%>>일시완납</option>
                            </select>	
							</td>
              </tr>
              <!-- 운전자추가요금/월보험료(고객피보험) 적용 (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">정<br>상<br>대<br>여<br>료</td>
	                <td class='title'>정상요금</td>
	                <td align="center" ><input type='text' size='11' name='inv_s_amt' maxlength='10' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  원</td>
	                <td align="center" ><input type='text' size='11' name='inv_v_amt' maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  원</td>
	                <td align='center' ><input type='text' size='11' maxlength='10' name='inv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_s_amt()+fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  원</td>
	                <td align="center">-</td>
	                <td align='center'>&nbsp;
	    			  <span class="b"><a href="javascript:estimate('<%=fee.getRent_st()%>','account')" onMouseOver="window.status=''; return true" title="견적하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
	                </td>
               </tr>
               <tr>
                    <td class='title'>월보험료(고객피보험)</td>
                    <td align="center" ><input type='text' size='11' name='ins_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getIns_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='11' name='ins_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fee.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='11' maxlength='10'  name='ins_amt' class='num' value='<%=AddUtil.parseDecimal(fee.getIns_s_amt()+fee.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center">&nbsp;월보험료(공급가) = 년간보험료
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='num' value='<%=AddUtil.parseDecimal(fee.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 원/12</td>
                    <td align='center'>-<!-- 자동차보험 관련 특약 약정서<br> -->
                    	<%-- <a href="javascript:reqdoc('<%=fees.getRent_l_cd()%>','<%=fees.getRent_mng_id()%>','<%=fees.getRent_st()%>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> --%>
                    </td>
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
                    	<input type='text' size='11' name='tinv_s_amt' maxlength='11' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_s_amt() + fee.getIns_s_amt() + fee_etc.getDriver_add_amt())%>'> 원 
                    </td>
                    <td align="center" >
                       	<input type='text' size='11' name='tinv_v_amt'  maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_v_amt() + fee.getIns_v_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center' >
                    	<input type='text' size='11' maxlength='10'  name='tinv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_s_amt() + fee.getInv_v_amt() + fee.getIns_s_amt() + fee.getIns_v_amt() + fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>
              
        	<tr>
                <td class='title' colspan="2">대여료DC</td>
                <td colspan='3'>&nbsp;
                    결재자 : 
                        <input name="user_nm" type="text" class="text"  readonly value="" size="12"> 
			<input type="hidden" name="dc_ra_sac_id" value="">
			<a href="javascript:User_search('dc_ra_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
		    &nbsp;&nbsp;&nbsp;&nbsp;
		    결재일자 : 	
		    <input type='text' size='11' name='bas_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fee.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
                </td>                                
                <td align="center">                
                    적용근거 : <select name='dc_ra_st'>
                        <option value=''>선택</option>
                        <option value='1' selected>정상DC조건</option>
                        <option value='2'>특별DC</option>
                    </select>
                    기타 : <input type='text' size='20' name='dc_ra_etc' class="text" value=''>
                </td>
                <td align='center'>DC율 <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value='<%=fee.getDc_ra()%>'>%
                	<input type="hidden" name="dc_ra_amt" value="0">
                	</td>
              </tr>                             
              <tr id=tr_emp_bus style="display:''">
                <%-- <td rowspan="<%if(rent_st.equals("3")){%>4<%}else{%>3<%}%>" class='title'>기<br>타</td> --%>
                <td rowspan="<%if(rent_st.equals("3")){%>3<%}else{%>2<%}%>" class='title'>기<br>타</td>
                <td class='title' colspan="2">영업수당</td>
                <td colspan="2" align="center">산출기준:
    			  <select name='commi_car_st'>
                    <option value='1' selected>차량가격</option>
                  </select>
    			</td>
                <td align='center'><input type='text' size='11' name='commi_car_amt' maxlength='11' class='defaultnum' value='' onBlur="javascript:setCommi()">
    				  원</td>
                <td align="center">
                    <input type='text' name="comm_r_rt" value='<%//=emp1.getComm_r_rt()%>' size="3"  maxlength='3' class='defaultnum' onBlur='javascript:setCommi()'>
    		      %</td>
                <td align='center'>
    				[최대 <input type='text' name="comm_rt" value='<%//=emp1.getComm_rt()%>' size="3"  maxlength='3' class='fixnum' readonly>
    			  %]</td>
              </tr>
              <tr>
                <td class='title' colspan="2">중도해지위약율</td>
                <td colspan="2" align="center">-</td>
                <td align='center'>-</td>
                <td align="center">잔여기간 대여료의
                    <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=fee.getCls_r_per()%>'>
    				  %</td>
                <td align='center'><font color="#FF0000">
    				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='<%=fee.getCls_per()%>'>%
					,필요위약금율[<input type='text' size='3' name='cls_n_per' maxlength='10' class='fixnum' value='<%=fee.getCls_n_per()%>'>%]
					</font></span></td>
              </tr>
                <%-- <tr>
                    <td class='title'>운전자추가요금</td>
                    <td colspan="6">&nbsp;
                    	<input type='text' size='10' name='driver_add_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt())%>'>
        				  원 (공급가)</td>                  
                </tr> --%>              
				<%	if(base.getRent_st().equals("3")){
						//대차원계약정보
						Hashtable suc_cont = new Hashtable();
						if(!cont_etc.getGrt_suc_l_cd().equals("")){
							suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
						}
					%>
              <tr>
                    <td class='title'  colspan="2" style="font-size : 8pt;">대차원계약</td>
                    <td colspan="6">&nbsp;
                                          <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>					  
					  &nbsp;계약번호 : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;차종코드별변수 차명 : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[대차보증금승계]</b>
					  &nbsp;기존보증금 : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>원
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  승계보증금 : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum'  onBlur="javascript:document.form1.grt_suc_cha_amt.value=parseDecimal(toInt(parseDigit(document.form1.grt_suc_o_amt.value))-toInt(parseDigit(document.form1.grt_suc_r_amt.value)));">원
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(약정보증금 차액 <input type='text' name='grt_suc_cha_amt' size='10' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>' class='whitenum'>)</font>
					  <%}else{ %>
					  <input type='hidden' name='grt_suc_cha_amt' 	value=''>
					  <%} %>	
        			</td>
        			<%	}%>
              </tr>					  			  
			  <input type='hidden' name='bus_agnt_r_per' 	value='<%//=fee_etc.getBus_agnt_r_per()%>'>
			  <input type='hidden' name='bus_agnt_per' 	value='<%//=fee_etc.getBus_agnt_per()%>'>
			  <input type='hidden' name='cls_n_mon' 	value='<%//=fee_etc.getCls_n_mon()%>'>
			  <input type='hidden' name='cls_n_amt' 	value='<%//=fee_etc.getCls_n_amt()%>'>
			  <input type='hidden' name='min_agree_dist' 	value='<%//=fee_etc.getMin_agree_dist()%>'>
			  <input type='hidden' name='max_agree_dist' 	value='<%//=fee_etc.getMax_agree_dist()%>'>
			  <input type='hidden' name='over_run_day' 	value='<%//=fee_etc.getOver_run_day()%>'>
			  <input type='hidden' name='over_serv_amt' 	value='<%//=fee_etc.getOver_serv_amt()%>'>
			  <input type="hidden" name="fee_sac_id" value="<%=fee.getFee_sac_id()%>">

                <tr>
                    <td colspan="3" class='title'>계약서 특약사항 기재 내용</td>
                    <td colspan="6">
                    	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
                    			<%
                    				String con_etc_text = "2023년 1월 1일 이후 신차가 출고되어 한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우 월대여료가";
                    				String con_etc_text2 = "지자체 보조금 소진 또는 변경, 차량 출고지연 등으로 대여료가 변경되거나 계약진행이 불가능 할 수 있습니다.";
                    			%>
				                <textarea rows='5' cols='90' name='con_etc' ><%if( ej_bean.getJg_3() > 0){ %>※ 2023년 1월 1일 이후 신차가 출고되어 한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우 월대여료가 <%if( !(ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")) ){ %>*,***원(공급가) <%} %>인상됩니다.<%}
					  				if(ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){
					  					String con_etc_value = "";
// 					  					if(cm_bean.getJg_code().equals("3313112")|| cm_bean.getJg_code().equals("3313113")|| cm_bean.getJg_code().equals("3313114")
// 					  						|| cm_bean.getJg_code().equals("5315111") || cm_bean.getJg_code().equals("5315112") || cm_bean.getJg_code().equals("5315113")
// 					  						){
					  					if(cm_bean.getCar_comp_id().equals("0056")){
					  						con_etc_value = "※ 환율, 연식, 세율 등의 변동이나 제조사 가격정책에 따라 차량가격이 변경될 경우 대여료가 변경될 수 있습니다. 또한 보조금의 소진 또는 변경시 대여료가 변경되거나  계약진행이 불가능 할 수 있습니다.";
					  					} else{
					  						con_etc_value = "※ 지자체 보조금 소진 또는 변경, 차량 출고지연 등으로 대여료가 변경되거나 계약진행이 불가능 할 수 있습니다.";
					  					}%><%=con_etc_value%><%}
                    				if(!fee_etc.getCon_etc().equals("")&&!fee_etc.getCon_etc().contains(con_etc_text)&&!fee_etc.getCon_etc().contains(con_etc_text2)) {
                    				%><%=fee_etc.getCon_etc()%><%} %></textarea>
                    		</div>
                   		</div>
                      	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
					  		<div style="display: table-cell; vertical-align: middle;">
                      		<%if (base.getCar_gu().equals("1") && AddUtil.parseInt(AddUtil.getDate(4)) >= 20200831 && AddUtil.parseInt(AddUtil.getDate(4)) < 20210101) {//개소세 한시적 인하 기간 %>                 
		                      	<!-- <input type="button" onclick="setMentConEtc('0')" value="개별소비세 인상금액 안내문구"> -->
		                      	<%if (ej_bean.getJg_3() > 0) {%>
						  		<!-- <input type="button" onclick="setMentConEtc('1')" value="개별소비세율 환원시 안내문구">&nbsp; -->
								<%}%>
								<%if (ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")) {%>
						  		<input type="button" onclick="setMentConEtc('2')" value="하이브리드 취득세 감면혜택축소 안내문구">
								<%}%>
								<%if (ej_bean.getJg_3() > 0 && (ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2"))) {%>
						  		<!-- <br><br>
						  		<input type="button" onclick="setMentConEtc('3')" value="개별소비세율 환원 및 하이브리드 취득세 감면혜택축소 안내문구"> -->
								<%}%>
						  	<%}%>
						  	<%if(base.getCar_gu().equals("0")){%>
								<input type="button" onclick="setMentConEtc('4')" value="재리스 품질보증 안내문구">
							<%}%>
		                		<%-- <%if( ej_bean.getJg_3() > 0 && (
					  					cm_bean.getJg_code().equals("4022311") || cm_bean.getJg_code().equals("4022312") || cm_bean.getJg_code().equals("4022313") || cm_bean.getJg_code().equals("4022314")
					  					 || cm_bean.getJg_code().equals("5014123") || cm_bean.getJg_code().equals("5018411") || cm_bean.getJg_code().equals("5018412") || cm_bean.getJg_code().equals("5018413")
					  					 || cm_bean.getJg_code().equals("6022410") || cm_bean.getJg_code().equals("6022415") || cm_bean.getJg_code().equals("6022418") || cm_bean.getJg_code().equals("4217013") || cm_bean.getJg_code().equals("3516312")
					  					 || cm_bean.getJg_code().equals("4519221") || cm_bean.getJg_code().equals("4519222") || cm_bean.getJg_code().equals("4519223") || cm_bean.getJg_code().equals("5514112")
					  					 || cm_bean.getJg_code().equals("6516213") || cm_bean.getJg_code().equals("6516214") || cm_bean.getJg_code().equals("6516215") || cm_bean.getJg_code().equals("6519213") || cm_bean.getJg_code().equals("6519214")
					  					 || cm_bean.getJg_code().equals("5028511") || cm_bean.getJg_code().equals("5028512")
					  					 || cm_bean.getJg_code().equals("4016314") || cm_bean.getJg_code().equals("6012423") || cm_bean.getJg_code().equals("6012424") || cm_bean.getJg_code().equals("6012428") || cm_bean.getJg_code().equals("6012429")
				                		 || cm_bean.getJg_code().equals("6022421") || cm_bean.getJg_code().equals("6022422") || cm_bean.getJg_code().equals("6022423") || cm_bean.getJg_code().equals("6022424") || cm_bean.getJg_code().equals("6022426") || cm_bean.getJg_code().equals("6022427")
				                		 || cm_bean.getJg_code().equals("6024411") || cm_bean.getJg_code().equals("6024412") || cm_bean.getJg_code().equals("6024413") || cm_bean.getJg_code().equals("6024414") || cm_bean.getJg_code().equals("6024415")
				                		 || cm_bean.getJg_code().equals("5028513") || cm_bean.getJg_code().equals("5018414") || cm_bean.getJg_code().equals("5018415") || cm_bean.getJg_code().equals("5018416")
					  				) ){ %>
			                		<input type="button" onclick="setMentConEtc('5')" value="개별소비세율 환원시 안내문구">
								<%}%> --%>
							  	<script>
								function setMentConEtc(idx) {
									/* if (idx == "0") {
										document.form1.con_etc.value = "개별소비세 한시적 세액 70% 감면(2020.3~6월) 기간을 초과하여, 개별소비세율이 3.5%(2020.7~12월)로 조정되어 출고시 월대여료가 *,***원(공급가) 인상됩니다.";
									} */
									if (idx == "1") {
										document.form1.con_etc.value = "※ 2021년1월1일 이후 신차가 출고되어 한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우 월대여료가 *,***원(공급가) 인상됩니다.";
									}
									if (idx == "2") {
										document.form1.con_etc.value = "※ 2021년1월1일 이후 신차가 출고되면 하이브리드 자동차 취득세 감면 혜택 축소에 따라 월대여료가 *,***원(공급가) 인상됩니다.";
									}
									if (idx == "3") {
										document.form1.con_etc.value = "※ 2021년1월1일 이후 신차가 출고되어 한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우 월대여료가 *,***원(공급가) 인상됩니다. ※ 2021년1월1일 이후 신차가 출고되면 하이브리드 자동차 취득세 감면 혜택 축소에 따라 월대여료가 *,***원(공급가) 인상됩니다.";
									}
									if (idx == "4") {
										document.form1.con_etc.value = "※ 엔진, 변속기 : 2개월/5,000Km 품질보증 (기간 또는 주행거리 중 먼저 도래한 것을 보증기간 만료로 간주)";
									}
									if (idx == "5") {
										document.form1.con_etc.value = "※ 2023년 1월 1일 이후 신차가 출고되어 한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우 월대여료가 *,***원(공급가) 인상됩니다.";
									} 
								}
							  	</script>	   
					  		</div>
				  		</div>
                    </td>
                </tr>			              
              	<tr>
	                <td colspan="3" class='title'>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
	                <td colspan="5">
	                	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
			                  	<textarea rows='5' cols='90' class=default name='fee_cdt'><%=fee.getFee_cdt()%></textarea>
                    		</div>
                   		</div>
					</td>
              	</tr>			
              	<tr>
	                <td colspan="3" class='title'>비고<br>(해지 관련)</td>
	                <td colspan="5">
	                	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
			                  	<textarea rows='5' cols='90' class=default name='cls_etc'><%=cont_etc.getCls_etc()%></textarea>
                    		</div>
                   		</div>
					</td>
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
            				    <td align="center"><input type='text' size='12' name='bc_b_e1' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_e1()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				    <td align="center">E-2</td>
            				    <td align="center">bc_b_e2</td>				  
            				    <td>&nbsp;경매장예상낙찰가격</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e2' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_e2()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				  <td align="center">U</td>
            				  <td align="center">bc_b_u</td>				  
            				  <td>&nbsp;기타비용</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_u' maxlength='10' class='num' value='<%=fee_etc.getBc_b_u()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='bc_b_u_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_u_cont()%>'>
            				  </td>
            				</tr>							
            		        <tr>
            				  <td align="center">G</td>
            				  <td align="center">bc_b_g</td>				  
            				  <td>&nbsp;기타수익</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_g' maxlength='10' class='num' value='<%=fee_etc.getBc_b_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='bc_b_g_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_g_cont()%>'>
            				  </td>
            				</tr>
            		        <tr>
            				  <td align="center">AC</td>
            				  <td align="center">bc_b_ac</td>				  
            				  <td>&nbsp;기타 영업효율반영값</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_ac' maxlength='10' class='num' value='<%=fee_etc.getBc_b_ac()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='bc_b_ac_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_ac_cont()%>'></td>
            				</tr>
            		        <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_etc</td>				  
            				  <td>&nbsp;정산유의사항</td>
            				  <td align="center"><textarea rows='5' cols='70' name='bc_etc'><%=fee_etc.getBc_etc()%></textarea></td>
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
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>납입방법</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>	
    <tr id=tr_fee2 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="3%" rowspan="5" class='title'>대<br>여<br>료<br>납<br>입<br>방<br>법</td>
                <td width="10%" class='title'>납입횟수</td>
                <td width="20%">&nbsp;
                  <input type='text' size='3' name='fee_pay_tm' value='<%=fee.getFee_pay_tm()%>' maxlength='2' class='default' >
    				회 </td>
                <td width="10%" class='title'>납입일자</td>
                <td width="20%">&nbsp;매월
                  <select name='fee_est_day'>
                    <option value="">선택</option>
                    <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                    <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                    <% } %>
                    <option value='99' <%if(fee.getFee_est_day().equals("99")){%> selected <%}%>> 말일 </option>
					<option value='98' <%if(fee.getFee_est_day().equals("98")){%> selected <%}%>> 대여개시일 </option>
                  </select></td>
                <td width="10%" class='title'>납입기간</td>
                <td>&nbsp;
                  <input type='text' name='fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
    				~
    			  <input type='text' name='fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
              </tr>		  		  		  
              <tr>
                <td width="10%" class='title'>수금구분</td>
                <td width="20%">&nbsp;
                  <select name='fee_sh'>
                    <option value="">선택</option>
                    <option value="0" <%if(fee.getFee_sh().equals("0")){%> selected <%}%>>후불</option>
                    <option value="1" <%if(fee.getFee_sh().equals("1")){%> selected <%}%>>선불</option>
                  </select></td>
                <td width="10%" class='title'>납부방법</td>
                <td>&nbsp;
                  <select name='fee_pay_st'>
                    <option value=''>선택</option>
                    <option value='1' <%if(fee.getFee_pay_st().equals("1")){%> selected <%}%>>자동이체</option>
                    <option value='2' <%if(fee.getFee_pay_st().equals("2")){%> selected <%}%>>무통장입금</option>
                    <option value='4' <%if(fee.getFee_pay_st().equals("4")){%> selected <%}%>>수금</option>
                    <option value='5' <%if(fee.getFee_pay_st().equals("5")){%> selected <%}%>>기타</option>
                  </select></td>
    			  <td class='title'>CMS미실행</td>
    			  <td>&nbsp;
    			    사유 : <input type='text' name='cms_not_cau' size='25' value='<%//=fee_etc.getCms_not_cau()%>' class='text'>
    			  </td>
                </tr>		  		  		  
              <tr>
                <td class='title'>거치여부</td>
                <td colspan="3">&nbsp;
                <select name='def_st'>
                  <option value="N" <%if(fee.getDef_st().equals("N")){%> selected <%}%>>없음</option>
                  <option value="Y" <%if(fee.getDef_st().equals("Y")){%> selected <%}%>>있음</option>
                </select>
    			 사유 :            
    			 <input type='text' name='def_remark' size='40' value='<%=fee.getDef_remark()%>' class='text'>
    			</td>
                <td class='title'>결재자</td>
                <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee.getDef_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="def_sac_id" value="<%=fee.getDef_sac_id()%>">
			<a href="javascript:User_search('def_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
                  </td>
              </tr>
              <tr>
                <td class='title'>자동이체
                    <br><span class="b"><a href="javascript:search_cms('')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                </td>
                <td colspan="5"><table width="100%" border="0" cellpadding="0">
    			  <tr>
    			    <td>&nbsp;
					거래은행 : 
					    <input type='hidden' name="cms_bank" 			value="<%=cms.getCms_bank()%>">
    				  <select name='cms_bank_cd'>
                    <option value=''>선택</option>
                    <%	if(bank_size > 0){
    											for(int i = 0 ; i < bank_size ; i++){
    												CodeBean bank = banks[i];	
    												//신규인경우 미사용은행 제외
    												if(bank.getUse_yn().equals("N"))	 continue;
    												if(cms.getCms_bank().equals("")){
        						%>			
                    <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}else{%>
                    <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}%>
                    <%		}
    					 					}%>
                  </select>
    				&nbsp;&nbsp;
    				계좌번호 : 
    			      <input type='text' name='cms_acc_no' value='<%=cms.getCms_acc_no()%>' size='20' class='text'>
    			      
    			      &nbsp;&nbsp;예 금 주 :
    			      <input type='text' name='cms_dep_nm' value='<%if(cms.getCms_dep_nm().equals("")){%><%=client.getFirm_nm()%><%}else{%><%=cms.getCms_dep_nm()%><%}%>' size='20' class='text'>
    					  
					  <br><br>
    			      &nbsp;
					  예금주 생년월일/사업자번호 :
					  <%	if(cms.getCms_dep_ssn().equals("")){
					  			if(client.getClient_st().equals("1")) 	cms.setCms_dep_ssn(client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3());
								else                                   	cms.setCms_dep_ssn(client.getSsn1());					  
				  		}
					  %>
    			      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
					  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
						<script>
							function openDaumPostcode() {
								new daum.Postcode({
									oncomplete: function(data) {
										document.getElementById('t_zip').value = data.zonecode;
										document.getElementById('t_addr').value = data.address +" ("+ data.buildingName+")";
										
									}
								}).open();
							}
						</script>
    				  &nbsp;&nbsp;예금주 주소 : 
					  <input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%if(cms.getCms_dep_post().equals("")){%><%=client.getO_zip()%><%}else{%><%=cms.getCms_dep_post()%><%}%>">
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="65" value="<%if(cms.getCms_dep_addr().equals("")){%><%=client.getO_addr()%><%}else{%><%=cms.getCms_dep_addr()%><%}%>">
						
					  <br><br>
    			      &nbsp;
					  연락전화 :
    			      <input type='text' name='cms_tel' size='15' class='text' value="<%if(cms.getCms_tel().equals("")){%><%= client.getO_tel()%><%}else{%><%=cms.getCms_tel()%><%}%>">

    			      &nbsp;&nbsp;휴대폰 :
    			      <input type='text' name='cms_m_tel' size='15' class='text' value="<%if(cms.getCms_m_tel().equals("")){%><%= client.getM_tel()%><%}else{%><%=cms.getCms_m_tel()%><%}%>">
    					  
    			      &nbsp;&nbsp;이메일 :
    			      <input type='text' name='cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%if(cms.getCms_email().equals("")){%><%= client.getCon_agnt_email()%><%}else{%><%=cms.getCms_email()%><%}%>">
    					  
					  
    			       </td>
    			    </tr>
    			</table>
    			</td>
              </tr>
              <tr>
                <td class='title'>통장입금</td>
                <td colspan="5">&nbsp; 
                  <select name='fee_bank'>
                    <option value=''>선택</option>
                    <%if(bank_size > 0){
    										for(int j = 0 ; j < bank_size ; j++){
    											CodeBean bank = banks[j];
    											//신규인경우 미사용은행 제외
 													if(bank.getUse_yn().equals("N"))	 continue;
    								%>
                          <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%= bank.getNm()%> </option>
                    <%	}
    									}
    								%>
                  </select>
                </td>
              </tr>
            </table>
        </td>
    </tr>		
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_tax style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="13%" class='title'>공급받는자</td>
                <td width="20%">&nbsp;<%if(base.getTax_type().equals("")) base.setTax_type("1"); %>
                  <input type="radio" name="tax_type" value="1" <% if(base.getTax_type().equals("1")) out.print("checked"); %>>
    			    본사
    		      <input type="radio" name="tax_type" value="2" <% if(base.getTax_type().equals("2")) out.print("checked"); %>>
    		    	지점 </td>
                <td width="10%" class='title' style="font-size : 8pt;">청구서수령방법</td>
                <td width="20%">&nbsp;<%if(client.getEtax_not_cau().equals("")) cont_etc.setRec_st("1"); else cont_etc.setRec_st("2");%>
                  <select name='rec_st' class='default'>
                    <option value="">선택</option>					
                    <option value="1" <% if(cont_etc.getRec_st().equals("1")) out.print("selected"); %>>이메일</option>
                    <option value="2" <% if(cont_etc.getRec_st().equals("2")) out.print("selected"); %>>우편</option>
                    <option value="3" <% if(cont_etc.getRec_st().equals("3")) out.print("selected"); %>>수령안함</option>
                  </select>
                </td>
                <td width="10%" class='title' style="font-size : 8pt;">전자세금계산서</td>
                <td>&nbsp;<%if(cont_etc.getRec_st().equals("1") && cont_etc.getEle_tax_st().equals("")) cont_etc.setEle_tax_st("1");%>
                  <select name='ele_tax_st' class='default'>
                    <option value="">선택</option>
                    <option value="1" <% if(cont_etc.getEle_tax_st().equals("1")) out.print("selected"); %>>당사시스템</option>
                    <option value="2" <% if(cont_etc.getEle_tax_st().equals("2")) out.print("selected"); %>>별도시스템</option>
                  </select>
                  <input type='text' name='tax_extra' maxlength='10' size='15' value='<%=cont_etc.getTax_extra()%>' class='text'>
    			</td>
              </tr>
			  <!--부가세환급차량이 추가 되었을 경우에 부가세환급차량 계산서 별도 발금에 대해 묻는다.-->
			  <%	if(print_car_st_yn.equals("Y")){%>
			  <tr>
                <td width="13%" class='title'>계산서별도발행구분</td>			  
			    <td colspan='5'>&nbsp;
				  <select name='print_car_st'>
                    <option value="">선택</option>				  
                    <option value=''  >없음</option>
                    <option value='1' selected>승합/화물/9인승/경차</option>							
                  </select>	
				  <font color=red>* '<%=cm_bean.getCar_nm()%>' 차량은 부가세환급대상 차량입니다. 부가세환급할경우 계산별도발행구분을 [승합/화물/9인승/경차]로 선택하십시오.</font>
				</td>	
			  </tr>
			  <%	}%>		
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>지연대차</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_tae1 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="13%" class=title>대차여부</td>
                <td width="20%">&nbsp;<%if(fee.getPrv_dlv_yn().equals("")) fee.setPrv_dlv_yn("N"); %>
                  <input type='radio' name="prv_dlv_yn" value='N' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%>>
                  없다
                  <input type='radio' name="prv_dlv_yn" value='Y' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%>>
    	 		있다
    		    </td>
                <td width="10%" class=title style="font-size : 8pt;">대차기간포함여부</td>
                <td>&nbsp; &nbsp;<%if(fee.getPrv_dlv_yn().equals("Y") && fee.getPrv_mon_yn().equals("")) fee.setPrv_mon_yn("0"); %>
                  <input type='radio' name="prv_mon_yn" value='0' <%if(fee.getPrv_mon_yn().equals("0")){%> checked <%}%> >
                  미포함
                  <input type='radio' name="prv_mon_yn" value='1' <%if(fee.getPrv_mon_yn().equals("1")){%> checked <%}%> >
    	 		포함
    		    </td>			
              </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_tae2 style="display:<%if(fee.getPrv_dlv_yn().equals("Y") && !base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
              <tr>
                <td width="13%" class=title>차량번호</td>
                <td width="20%">&nbsp;
                  <input type='text' name='tae_car_no' size='12' class='text' readonly value='<%=taecha.getCar_no()%>'>
                  <span class="b"><a href="javascript:car_search('taecha')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span> 
    			  <input type='hidden' name='tae_no'		 value='<%=taecha.getNo()%>'>				    
    			  <input type='hidden' name='tae_car_mng_id' value='<%=taecha.getCar_mng_id()%>'>
    			  <input type='hidden' name='tae_car_id'	 value='<%=taecha.getCar_id()%>'>
    			  <input type='hidden' name='tae_car_seq'	 value='<%=taecha.getCar_seq()%>'>
				  <input type='hidden' name='tae_s_cd'	 	 value='<%=taecha.getRent_s_cd()%>'>
    			</td>
                <td width="10%" class='title'>차명</td>
                <td>&nbsp;
                  <input type="text" name="tae_car_nm" size="15" maxlength='10' readonly class=whitetext value='<%=taecha.getCar_nm()%>'></td>
                <td class='title'>최초등록일</td>
                <td>&nbsp; 
                  <input type="text" name="tae_init_reg_dt" size="15" maxlength='10' readonly class=whitetext value='<%=taecha.getInit_reg_dt()%>'></td>
              </tr>
              <tr>
                <td class=title>대여개시일</td>
                <td>&nbsp;
                  <input type='text' name='tae_car_rent_st' class='text' size='11' maxlength='10' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                <td class='title'>대여만료일</td>
                <td >&nbsp;
                  <input type='text' name='tae_car_rent_et' class='text' size='11' maxlength='10' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
    			  &nbsp;</td>
    			  <td class='title'>대여료선입금여부</td>
                <td>&nbsp;
                	<input type='radio' name="tae_f_req_yn" value='Y' <%if(taecha.getF_req_yn().equals("Y")){%> checked <%}%> >
                  선입금
                  <input type='radio' name="tae_f_req_yn" value='N' <%if(taecha.getF_req_yn().equals("N")||taecha.getF_req_yn().equals("")){%> checked <%}%> >
    	 		        후입금
    	 		        </td>
              </tr>
              <tr>
                <td class=title>월대여료</td>
                <td colspan='3'>&nbsp;
                  <input type='text' name='tae_rent_fee' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			  원(vat포함) 
    			</td>
                <td class=title>정상요금</td>
                <td >&nbsp;
                      <input type='text' name='tae_rent_inv' class='whitenum' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_inv())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원(vat포함) 
					  <span class="b"><a href="javascript:estimate_taecha('account')" onMouseOver="window.status=''; return true" title="견적하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
        			  <input type='hidden' name='tae_rent_inv_s'	 value=''>
        			  <input type='hidden' name='tae_rent_inv_v'	 value=''>					  
					  <input type='hidden' name='tae_est_id'	 	 value='<%=taecha.getEst_id()%>'>					  					  
        		</td>				
              </tr>	
              	              
              <tr>
                    <td class=title>신차해지시요금정산</td>
                    <td colspan='5' >&nbsp;
                      <input type='radio' name="tae_rent_fee_st" value='1' <%if(taecha.getRent_fee_st().equals("1")||taecha.getRent_fee_st().equals("")){%> checked <%}%> >
                                      월렌트정상요금
                      <input type='text' name='tae_rent_fee_cls' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원(vat포함)                 
                      <input type='radio' name="tae_rent_fee_st" value='0' <%if(taecha.getRent_fee_st().equals("0")){%> checked <%}%>  >
    	 		          견적서에 표기되어 있지 않음                      				  					 
        			</td>                   
              </tr>		                
              <tr>
                <td class=title>청구여부</td>
                <td>&nbsp;
                  <select name='tae_req_st'>
                    <option value="">선택</option>
                    <option value="1" <% if(taecha.getReq_st().equals("1")) out.print("selected");%>>청구</option>
                    <option value="0" <% if(taecha.getReq_st().equals("0")) out.print("selected");%>>무상대차</option>
                  </select></td>
                <td class='title' style="font-size : 8pt;">계산서발행여부</td>
                <td>&nbsp;
                  <select name='tae_tae_st'>
                    <option value="">선택</option>
                    <option value="1" <% if(taecha.getTae_st().equals("1")) out.print("selected");%>>발행</option>
                    <option value="0" <% if(taecha.getTae_st().equals("0")) out.print("selected");%>>미발행</option>
                  </select></td>
                <td class='title'>결재자</td>
                <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(taecha.getTae_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="tae_sac_id" value="<%=taecha.getTae_sac_id()%>">
			<a href="javascript:User_search('tae_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>	
			<% user_idx++;%>
    			</td>
              </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업사원</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_emp_bus style="display:''"> 	
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
                	<td width="3%" rowspan="6" class='title'>영<br>
     			  	업</td>
					<td class='title'>영업구분</td>
					<td colspan='5'>&nbsp;
						<label><input type='radio' name="pur_bus_st" value='4' checked >
						에이전트</label>                  
					</td>
				</tr>
				<tr id="dlv_con_commi_yn_tr">
					<td class='title'>출고보전수당 지급여부</td>
					<td colspan='5'>&nbsp;
						<label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input()">
						없음</label>　　
						<label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input()">
						있음</label>
              		<table>
              		   <tr>              		   
              		       <td>&nbsp;
              		           <select name='dir_pur_commi_yn'>
                          <option  value="">선택</option>
                          <option value="Y" <%if(cont_etc.getDir_pur_commi_yn().equals("Y")){%>selected<%}%>>특판출고(실적이관가능)</option>
                          <option value="N" <%if(cont_etc.getDir_pur_commi_yn().equals("N")){%>selected<%}%>>특판출고(실적이관불가능)</option>
                          <option value="2" <%if(cont_etc.getDir_pur_commi_yn().equals("2")){%>selected<%}%>>자체출고대리점출고</option>
                        </select>                        
              		       </td> 
              		   </tr>
              		</table>						
					</td>
				</tr>	            
				<tr>                
                	<td width="10%" class='title'>영업담당</td>
                	<td width="20%" >&nbsp;
                  	<input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp1.getEmp_nm()%>' readonly>
    		  		<input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>
    				</td>
                <td width="10%" class='title'>영업소명</td>
                <td width="20%">&nbsp;
                  <%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>
                  <input type='text' name='car_off_nm' size='15' value='<%=emp1.getCar_off_nm()%>' class='whitetext' readonly>
				  <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'>
				  </td>
                <td width="10%" class='title'>구분</td>
                <td>&nbsp;
                  <input type='text' name='car_off_st' size='15' value='<%=emp1.getCar_off_st()%>' class='whitetext' readonly>
                </td>
              </tr>
              <tr>
                <td class='title'>소득구분</td>
                <td >&nbsp;
                  <input type='text' name='cust_st' size='15' value='<%=emp1.getCust_st()%>' class='whitetext' readonly></td>
                <td class='title'>최대수수료율</td>
                <td>&nbsp;
                  <input type='text' name="v_comm_rt" value='<%=emp1.getComm_rt()%>' size="3" class='whitenum' readonly>
    			  % 
    			</td>
                <td class='title'>적용수수료율</td>
                <td>&nbsp;
                  <input type='text' name="v_comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="3" class='whitenum' readonly>
    		      % 
    			  <input type='hidden' name='commi' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>'>
    			</td>
              </tr>
              <tr>
                <td class='title'>변경사유</td>
                <td colspan="3" >&nbsp;
    		      <input type='text' name="ch_remark" value='<%=emp1.getCh_remark()%>' size="40" class='text'>
                </td>
                <td class='title'>결재자</td>
                <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(emp1.getCh_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ch_sac_id" value="<%=emp1.getCh_sac_id()%>">
			<a href="javascript:User_search('ch_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>	
			<% user_idx++;%>
    			</td>
              </tr>
              <tr>
                <td class='title'>은행명</td>
                <td >&nbsp;
                	<input type='hidden' name="emp_bank" value="<%=emp1.getEmp_bank()%>">
    		      <select name='emp_bank_cd'>
                    <option value=''>선택</option>
                    <%	if(bank_size > 0){
    											for(int i = 0 ; i < bank_size ; i++){
    												CodeBean bank = banks[i];
    												//신규인경우 미사용은행 제외
   													if(bank.getUse_yn().equals("N"))	 continue;
    								%>
                    <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%		}
    										}
    								%>
                  </select>
    			</td>
                <td class='title'>계좌번호</td>
                <td>&nbsp;
                  <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="22" class='text'>
    			</td>
                <td class='title'>예금주명</td>
                <td colspan="2">&nbsp;
                  <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="20" class='text'>
    			</td>
              </tr>		  
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업사원-출고담당</span> <%if(!cop_bean.getRent_l_cd().equals("")){%>&nbsp;<font color=red>(사전계약 <%=cop_bean.getCom_con_no()%>)</font><%}%></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_emp_dlv style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
              <tr>
                <td width="3%" rowspan="4" class='title'>출<br>
                  고</td>
                <td class='title'>출고구분</td>
                <td>&nbsp;      
                  <label><input type='radio' name="one_self" value='Y' >
                  자체출고</label>
                  <label><input type='radio' name="one_self" value='N' checked >
                  영업사원출고</label>                                                         
                </td>
                <td class='title'>특판출고여부</td>
                <td>&nbsp;
                    <input type='radio' name="dir_pur_yn" value='Y' onClick="javascript:cng_input()">
        				특판
        	    <input type='radio' name="dir_pur_yn" value='' onClick="javascript:cng_input()">
        				기타(자체)
        	</td>  
        	<td class='title'>출고요청일</td>
                <td>&nbsp;
                		  <input type='text' name='pur_req_dt' value='' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		 &nbsp;
        		  <input type="checkbox" name="pur_req_yn" value="Y">				  
        				출고요청한다
    			</td>			
              </tr>		            			
              <tr>
                
                <td width="10%" class='title'>출고담당</td>
                <td width="20%" >&nbsp;
                  <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp2.getEmp_nm()%>' readonly>
    			  <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
                  <span class="b"><a href="javascript:search_emp('DLV')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
    			  <span class="b"><a href="javascript:cancel_emp('DLV')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
                  <input type='checkbox' name="emp_chk" onClick="javascript:set_emp_sam()"><font size='1'>상동</font></td>
                <td width="10%" class='title'>영업소명</td>
                <td width="20%">&nbsp;
                  <%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%>
                  <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
				  <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
    			</td>
                <td width="10%" class='title'>구분</td>
                <td>&nbsp;
                  <input type='text' name='car_off_st' size='15' value='<%=emp2.getCar_off_st()%>' class='whitetext' readonly>
                </td>
              </tr>
              
              <tr>
                <td class='title'>계약금</td>
                <td colspan="5">&nbsp;
                	금액 : 
				     <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원	
                     &nbsp;
                     지급수단 :
                     <select name="trf_st0" class='default'>
                        <option value="">==선택==</option>
        				<option value="3" <%if(pur.getTrf_st0().equals("3")) out.println("selected");%>>카드</option>
        				<option value="1" <%if(pur.getTrf_st0().equals("1")) out.println("selected");%>>현금</option>        				
        			  </select> 
                     &nbsp;
                    금융사 :
					<select name='con_bank' class='default'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>	
                    </select>
				  	&nbsp;
				  	계좌종류 :
				  	<select name="acc_st0" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getAcc_st0().equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(pur.getAcc_st0().equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					예금주 : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
        			<br>
        			&nbsp;
        			지급요청일 :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(pur.getCon_est_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
					  <%if(!pur.getCon_pay_dt().equals("")){%>	
					  &nbsp;&nbsp;(계약금지급일:<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>)
					  <%}%>        			
    			</td>															
              </tr>
              <tr>				
                <td class='title'>임시운행보험료</td>
                <td colspan='5'>&nbsp;
                  금액 : 
				     <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원	
                     &nbsp;
                     지급수단 :
                     <select name="trf_st5" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getTrf_st5().equals("1")) out.println("selected");%>>현금</option>        				
        				<option value="3" <%if(pur.getTrf_st5().equals("3")) out.println("selected");%>>카드</option>
        			  </select> 
                     &nbsp;
                    금융사 :
					<select name='card_kind5' class='default'>
                        <option value=''>선택</option>                        
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(pur.getCard_kind5().equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>	
                    </select>
				  	&nbsp;
				  	계좌종류 :
				  	<select name="acc_st5" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getAcc_st5().equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(pur.getAcc_st5().equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='cardno5' value='<%=pur.getCardno5()%>' size='20' class='text'>
					&nbsp;
					예금주 : 
        			<input type='text' name='trf_cont5' value='<%=pur.getTrf_cont5()%>' size='20' class='text'>
        			<br>
        			&nbsp;
        			지급요청일 :
        			<input type='text' name='trf_est_dt5' value='<%= AddUtil.ChangeDate2(pur.getTrf_est_dt5())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
				    <!--<input type="button" class="button" id="b_tmp_ins_amt" value='현대해상 보험료 보기' onclick="javascript:OpenImg('/acar/images/center/tmp_ins_amts.jpg');">-->
    			</td>				
              </tr>    
  
            </table>
        </td>
    </tr>
    <tr>
	    <td>* 출고영업소에 선수금 및 임시운행보험료를 지급할 카드/계좌정보를 입력하십시오.(특판은 제외) 개인명의 계좌는 사용할 수 없습니다. 카드는 지급수단과 지급요청일만 입력하십시오. </td>
    </tr>
    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>
	<tr>
        <td>&nbsp;</td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<iframe src="about:blank" name="i_no2" width="100%" height="100" frameborder="0" noresize></iframe>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script language="JavaScript">
<!--	

	
 	var fm = document.form1;
 	
 	//수입차 차종관리 면세차가외 디폴트 처리
 	<%if(car.getCar_origin().equals("2")){%>
 	fm.car_f_amt.value = parseDecimal(<%=cm_bean.getCar_b_p2()%> + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
 	set_car_amt(fm.car_f_amt);
 	<%if(base.getCar_st().equals("3")){%>
 	fm.dc_c_amt.value = <%=cm_bean.getL_dc_amt()%>;
 	<%}else{%>
 	fm.dc_c_amt.value = <%=cm_bean.getR_dc_amt()%>;
 	<%}%>
 	fm.s_dc1_re.value = '판매자정상조건';
 	fm.s_dc1_yn.value = 'Y';
 	fm.s_dc1_amt.value = fm.dc_c_amt.value;
 	set_car_amt(fm.dc_c_amt);
 	<%}%>
	
	if(fm.bas_dt.value == ''){
		fm.bas_dt.value = '<%=AddUtil.ChangeDate2(base.getReg_dt())%>';
	}
	
	fm.opt_chk[0].checked = true;
	
	cng_input();
	
	//추천등록지역
	fm.car_ext.value = '7';		//20130130 모두 인천등록
	
	<%if(ej_bean.getJg_g_7().equals("3")){//전기차는 서울등록%>
	fm.car_ext.value = '1';
	<%}%>	
	<%if(ej_bean.getJg_g_7().equals("4")){//수소차는 서울등록 20190701 인천등록%>
	fm.car_ext.value = '1';
	<%}%>	

	
	//20120901부터 영업수당율 최대3% 이내에서 선택가능
	fm.comm_rt.value = 3.0;
	fm.v_comm_rt.value = fm.comm_rt.value;
	fm.comm_r_rt.value = 0.0;
	fm.v_comm_r_rt.value = 0.0;
	
	//20191212
	if('<%=cm_bean.getJg_code()%>'=='9133' || '<%=cm_bean.getJg_code()%>'=='9015435' || '<%=cm_bean.getJg_code()%>'=='9015436' || '<%=cm_bean.getJg_code()%>'=='9015437'){
		sum_car_c_amt();
		sum_car_f_amt();
	}		
	
	//20190605 테슬라 고정 조건 - 20190801 초과부담금 450원 고정
<%-- 	if('<%=cm_bean.getJg_code()%>'=='4854' || '<%=cm_bean.getJg_code()%>'=='5866' || '<%=cm_bean.getJg_code()%>'=='3871' || '<%=cm_bean.getJg_code()%>'=='4314111' || '<%=cm_bean.getJg_code()%>'=='6316111' || '<%=cm_bean.getJg_code()%>'=='3313111' || '<%=cm_bean.getJg_code()%>'=='3313112' || '<%=cm_bean.getJg_code()%>'=='3313113' || '<%=cm_bean.getJg_code()%>'=='3313114'){ --%>
	if('<%=cm_bean.getCar_comp_id()%>'=='0056'){
	//	fm.con_mon.value = '36';
	//	fm.agree_dist.value = '20000';
		fm.over_run_amt.value = '450';
	}		
	
	//개소세감면액
	var ch_327 = 0;		
	var ch_315 = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value)); 
	var ch_326 = ch_315/(1+<%=ej_bean.getJg_3()%>);
	var bk_122 = 0;
	<%if(!ej_bean.getJg_w().equals("1")){%>
	<%	if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
	if(<%=ej_bean.getJg_3()%>*100 > 0){
		//if('<%=ej_bean.getJg_2()%>'=='1') ch_326 = ch_315; //일반승용LPG일때
		
		if('<%=ej_bean.getJg_g_7()%>'=='1') bk_122 = 1300000;
		if('<%=ej_bean.getJg_g_7()%>'=='2') bk_122 = 1300000;
		if('<%=ej_bean.getJg_g_7()%>'=='3') bk_122 = 3900000;
		if('<%=ej_bean.getJg_g_7()%>'=='4') bk_122 = 5200000;
		if(ch_315-ch_326<bk_122*1.1) 	ch_327 = ch_315-ch_326;
		else                         	ch_327 = bk_122*1.1;
		ch_327 = getCutRoundNumber(ch_327,0);
		if('<%=cm_bean.getJg_code()%>'=='2361' || '<%=cm_bean.getJg_code()%>'=='2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111')	ch_327 = 0;//볼트EV
		if('<%=cm_bean.getJg_code()%>'=='9133' || '<%=cm_bean.getJg_code()%>'=='9015435' || '<%=cm_bean.getJg_code()%>'=='9015436' || '<%=cm_bean.getJg_code()%>'=='9015437')	ch_327 = 0;//포터일레트릭
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
	//20200701 감면종료
	bk_177 = 0;
	
	//감면 미적용 개별소비세(인하한도 초과금액) 20210101~20210630**********************
  	var bk_216 = 0;
  	if(<%=base.getRent_dt()%> >= 20210101){
  	<%if(!ej_bean.getJg_w().equals("1")){ //수입차제외%>
  	<%		if(cm_bean.getDuty_free_opt().equals("1")){//면세가표기차량 제오%>
  	<%		}else{%>
				if(ch_315-ch_326>0 && ch_326/1.1>66666666){
					bk_216 = ((ch_326/1.1)-66666666) * 0.0195 * 1.1;	
				}	    					
				bk_216 = getCutRoundNumber(bk_216,-4);						
  	<%		}%>
  	<%}%>
  	}
	
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
  	
  	
  
  	
	sum_car_c_amt();
	sum_car_f_amt();
	sum_tax_amt();
	set_insur_serv();
	sum_pp_amt();	
	
	
	//반올림
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}	
	
	// 맑은서울스티커 발급 선택 시 등록지역을 서울로 자동 변경
	$("#eco_e_tag").change(function() {
		if($("#eco_e_tag").val() == "1"){
			$("#car_ext").val("1").prop("selected", true);
		}
	});
	
	//페이지 로드 시 출고보전수당 지급여부 초기화		2017. 12. 06
	document.addEventListener("DOMContentLoaded", function(){
		var dlv_con_commi_yn_val = $("input[name=dlv_con_commi_yn]:checked").val();
		if(dlv_con_commi_yn_val == "Y"){															// 출고보전수당 지급여부 -> 있음 선택
			$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// 출고구분 -> 자체출고 선택
			$("input[name='one_self']:radio[value='N']").prop("disabled", true);		// 출고구분 -> 영업사원출고 비황성화
		}else if(dlv_con_commi_yn_val == "N"){													// 출고보전수당 지급여부 -> 없음 일 경우
			$("input[name='one_self']:radio[value='N']").prop("disabled", false);	// 출고구분 -> 영업사원출고 활성화
			$("input[name='one_self']:radio[value='N']").prop("checked", true);	// 출고구분 -> 영업사원출고 선택
		}
	});
	
	// 출고보전수당		2017. 12. 06
	var one_self_no = $("input[name='one_self']:radio[value='N']");		// 출고구분 영업사원출고
	$("input[name=dlv_con_commi_yn]").change(function(){
		if($(this).val() == "Y"){																			// 영업구분에서 영업사원영업, 에이전트 선택 후 > 출고보전수당 지급여부 있음 선택 시
			$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// 출고구분 자체출고 선택
			one_self_no.prop("disabled", true);														// 출고구분 영업사원출고 비활성화
		}else{																										// 영업구분에서 영업사원영업, 에이전트 선택 후 > 출고보전수당 지급여부 없음 선택 시
			one_self_no.prop("disabled", false);														// 출고구분 영업사원출고 활성화
			one_self_no.prop("checked", true);														// 출고구분 영업사원출고 선택
		}
	});	
	
//-->
</script>
</body>
</html>
