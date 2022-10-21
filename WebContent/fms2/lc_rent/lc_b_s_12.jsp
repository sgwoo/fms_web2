<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.con_ins.*, acar.ext.*, acar.im_email.*,acar.insur.*, acar.doc_settle.* "%>
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
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
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
	
	DocSettleBean doc = d_db.getDocSettleCommi("1", rent_l_cd);

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
	var popObj = null;
	function replaceFloatRound(per){return Math.round(per*1000)/10;}
	function replaceFloatRound2(per){return Math.round(per*10)/10;}
	//대차보증금승계조회
	function search_grt_suc(){window.open("/fms2/car_pur/s_grt_suc.jsp?from_page=/fms2/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>","SERV_GRT_OFF","left=10,top=10,width=800,height=500,scrollbars=yes,status=yes,resizable=yes");}
	//대차보증금승계취소
	function cancel_grt_suc(){var fm=document.form1;fm.grt_suc_l_cd.value='';fm.grt_suc_m_id.value='';fm.grt_suc_c_no.value='';fm.grt_suc_o_amt.value='';fm.grt_suc_r_amt.value='';}
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
			if(fm.opt_chk[0].checked == true)	st = '0'; //없음
			else if(fm.opt_chk[1].checked == true)	st = '1'; //있음
		}
		if(st == '0'){
			fm.app_ja.value = fm.max_ja.value;
			fm.ja_r_s_amt.value = fm.ja_s_amt.value;
			fm.ja_r_v_amt.value = fm.ja_v_amt.value;
			fm.ja_r_amt.value = fm.ja_amt.value;
			fm.opt_s_amt.value = 0;
			fm.opt_v_amt.value = 0;
			fm.opt_amt.value = 0;
			fm.opt_per.value = 0;
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
		set_fee_amt(fm.opt_amt, rent_dt);
		if(fm.con_mon.value == '')					{ alert('이용기간을 입력하십시오.');			return;}
		if(fm.driving_age.value == '')			{ alert('운전자연령을 선택하십시오.');		return;}
		if(fm.gcp_kd.value == '')						{ alert('대물배상을 선택하십시오.');			return;}
		
		// 테슬라 차량 대여기간 제한 없음. 20210225
		<%-- if ('<%=cm_bean.getCar_comp_id()%>' == '0056' && '<%=base.getCar_st()%>' != '5') {
			if(fm.con_mon.value > 48) {
				alert('테슬라차량의 경우 48개월 이상 견적이 불가 합니다.');
				fm.con_mon.focus();
				return;
			}
		} --%>
		
		var agree_dist 		= toInt(parseDigit(fm.agree_dist.value));
		fm.fee_rent_st.value = rent_st;
		fm.fee_rent_dt.value = rent_dt;
		if(toInt(rent_st) > 1)  fm.fee_rent_dt.value = rent_start_dt;
		if(fm.car_gu.value == '1' && fm.fee_size.value == '1' && fm.one_self.value == '')	{	alert('출고구분을 선택하여 주십시오.');  return; }
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
		<%if(!base.getCar_st().equals("5")){%>
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
	  <%}%>
	  
			<%if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차제외 %>
			if(<%=base.getRent_dt()%> >= 20190215 && <%=base.getRent_dt()%> < 20191217){
				if(fm.return_select.value == ''){ alert('전기차 인수/반납 유형을 선택하십시오.'); return; }
				//일반식은 인수/반납 선택형을 할수 없다.
				if('<%=fees.getRent_way()%>' == '1' && fm.return_select.value == '0'){
					alert('일반식은 전기차 인수/반납 선택형을 선택할 수 없습니다. ');
					return;
				}
				//인수/반납 선택형 - 매입옵션있음
				if(fm.return_select.value == '0'){
					fm.opt_chk[1].checked = true;	
				//반납형 - 매입옵션없음	
				}else if(fm.return_select.value == '1'){
					fm.opt_chk[0].checked = true;	
					fm.opt_s_amt.value = 0;
					fm.opt_v_amt.value = 0;
					fm.opt_amt.value = 0;
					fm.opt_per.value = 0;
				}
				opt_display('', '');				
			}
			<%}%>				  
	  
		fm.ro_13.value 			= fm.app_ja.value;
		fm.o_13_amt.value 	= fm.ja_r_amt.value;
		if(toInt(parseDigit(fm.ja_r_amt.value)) > toInt(parseDigit(fm.ja_amt.value))){
			fm.ro_13.value 			= fm.max_ja.value;
			fm.o_13_amt.value 	= fm.ja_amt.value;
		}
		fm.o_13.value 		= fm.max_ja.value;
		
		if(st == 'view'){fm.target = '_blank';}else{fm.target = 'i_no';}
		//20150626 리스기본식만 보험계약자 고객 선택가능, 보험계약자가 고객이면 피보험자도 고객이여야 한다.
		if('<%=base.getCar_st()%><%=fees.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){alert('보험계약자 고객이면 피보험자도 고객이여야 합니다.');return;}
		}else{
			if(toInt(rent_st) == 1 && fm.insurant.value == '2'){alert('보험계약자 고객은 리스기본식만 가능합니다.');	return;}
		}
		
		
		if(toInt(rent_st) > 1){//연장
			fm.o_1.value				= fm.sh_amt.value;
			fm.ro_13.value 			= fm.opt_per.value;
			fm.o_13_amt.value 	= fm.opt_amt.value;
			fm.o_13.value 			= 0;
			if(toInt(parseDigit(fm.fee_opt_amt.value)) > 0) fm.o_1.value	= fm.fee_opt_amt.value;
			if(toInt(fm.o_1.value) == 0){ alert('중고차가를 입력하십시오.'); return;}
			fm.action='get_fee_estimate_20090901.jsp';
			if(toInt(fm.fee_rent_dt.value) < 20090924){
				fm.action='get_fee_estimate.jsp';	
			}
		}else{
			if(fm.car_gu.value != '1'){//재리스&중고차
				fm.o_1.value	= fm.sh_amt.value;
				fm.ro_13.value 			= fm.opt_per.value;
				fm.o_13_amt.value 	= fm.opt_amt.value;
				fm.o_13.value 			= 0;
				if(toInt(fm.o_1.value) == 0){ alert('중고차가를 입력하십시오.'); return;}
				
				<%if (fees.getRent_st().equals("1") && base.getCar_gu().equals("0")) {%>
				if (fm.br_from_st.value == "") {
					alert('재리스 지점간 이동 출발을 선택해 주세요.');
					return;
				} else {
					if (fm.br_from_st.value == "9") {
						fm.br_from.value = "";
					} else {
						fm.br_from.value = fm.br_from_st.value;
					}
				}
				
				if (fm.br_to_st.value == "") {
					alert('재리스 지점간 이동 도착을 선택해 주세요.');
					return;
				} else {
					if (fm.br_to_st.value == "9") {
						fm.br_to.value = "";
					} else {
						fm.br_to.value = fm.br_to_st.value;
					}
				}
				<%}%>
				
				fm.action='get_fee_estimate_20090901.jsp';
				if(toInt(fm.fee_rent_dt.value) < 20090924){
					fm.action='get_fee_estimate.jsp';
				}
			}else{//신차	
				fm.ro_13.value 		= fm.opt_per.value;
				fm.o_13_amt.value 	= fm.opt_amt.value;
				fm.o_13.value 		= 0;
				fm.action='get_fee_estimate_20090901.jsp';
				if(toInt(fm.fee_rent_dt.value) < 20090924){
					fm.action='get_fee_estimate.jsp';
				}
				
				<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id) || nm_db.getWorkAuthUser("본사영업팀장",user_id) || nm_db.getWorkAuthUser("본사영업부팀장",user_id)){%>
				<%	if(base.getCar_gu().equals("1") && !base.getDlv_dt().equals("") && fees.getRent_st().equals("1")){%>
				//출고일자 기준 견적하기
				if(fm.bc_dlv_yn.checked == true){
					fm.fee_rent_dt.value = '<%=base.getDlv_dt()%>';
				}
				<%	}%>
				<%}%>
			}
		}
		
		
		
		<%if(cm_bean.getJg_code().equals("")){%>alert("차종잔가코드가 없습니다. 차종관리에서 입력하십시오.");return;	<%}%>
		if(toInt(rent_st) > 1){//연장
			fm.submit();
		}else{
			if(fm.car_gu.value != '1'){//재리스&중고차
				fm.submit();
			}else{
				if(confirm('영업수당 계약조건 '+fm.comm_r_rt.value+'%로 견적됩니다. 계속하시겠습니까?')){
					if(fm.one_self.value == 'Y' && confirm('자체출고로 견적됩니다. 계속하시겠습니까?')){	fm.submit();}
					if(fm.one_self.value == 'N' && confirm('영업사원출고로 견적됩니다. 계속하시겠습니까?')){fm.submit();}
				}
			}
		}
	}

	//영업수당계산
	function setCommi(){
		var fm = document.form1;
		var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));
		var comm_r_rt 	= toFloat(fm.comm_r_rt.value);
		fm.commi.value = parseDecimal(th_round(car_price*comm_r_rt/100));
	}

	//수정
	function update(idx){
		var fm = document.form1;
		
		<%//if(!ck_acar_id.equals("000029")){%>

				if(fm.car_st.value != '2'){
					if(fm.con_mon.value == ''){alert('대여요금-이용기간을 입력하십시오.');fm.con_mon.focus();return;}
					
					<%if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차제외 %>
					if(<%=base.getRent_dt()%> >= 20190215 && <%=base.getRent_dt()%> < 20191217){
						if(fm.return_select.value == ''){ alert('전기차 인수/반납 유형을 선택하십시오.'); return; }
						//일반식은 인수/반납 선택형을 할수 없다.
						if('<%=fees.getRent_way()%>' == '1' && fm.return_select.value == '0'){
							alert('일반식은 전기차 인수/반납 선택형을 선택할 수 없습니다. ');
							return;
						}//인수/반납 선택형 - 매입옵션있음
						if(fm.return_select.value == '0'){
							fm.opt_chk[1].checked = true;	
						//반납형 - 매입옵션없음	
						}else if(fm.return_select.value == '1'){
							fm.opt_chk[0].checked = true;	
							fm.opt_s_amt.value = 0;
							fm.opt_v_amt.value = 0;
							fm.opt_amt.value = 0;
							fm.opt_per.value = 0;
						}else{
							alert('전기차 인수/반납 유형을 선택하십시오.');
							return;
						}
						opt_display('', '');						
					}
					<%}%>			
								
					if(toInt(parseDigit(fm.ja_amt.value)) == 0 && toInt(parseDigit(fm.ja_r_amt.value)) > 0){
						fm.ja_s_amt.value = fm.ja_r_s_amt.value;
						fm.ja_v_amt.value = fm.ja_r_v_amt.value;
						fm.ja_amt.value = fm.ja_r_amt.value;
						fm.max_ja.value = fm.app_ja.value;
					}
					<%if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계") && !String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>
					if(fm.max_ja.value == ''){alert('대여요금-최대잔가율을 입력하십시오.');fm.max_ja.focus();return;}
					var ja_amt = toInt(parseDigit(fm.ja_amt.value));
					if(fm.car_st.value != '5' && toInt(fm.cls_r_per.value) < 1){alert('대여요금-중도해지위약율를 확인하십시오.');fm.cls_r_per.focus();return;}
					var fee_amt = toInt(parseDigit(fm.fee_amt.value));
					var inv_amt = toInt(parseDigit(fm.inv_amt.value));
					var pp_amt = toInt(parseDigit(fm.pp_amt.value));
					if(pp_amt == 0) fm.pp_chk.value = '';
					var agree_dist = toInt(parseDigit(fm.agree_dist.value));
					var over_run_amt = toInt(parseDigit(fm.over_run_amt.value));
					var rtn_run_amt = toInt(parseDigit(fm.rtn_run_amt.value));
					<%if(!base.getCar_st().equals("5")){%>
						if(fm.car_gu.value == '1' && fm.agree_dist.value !='미적용'){//신차
							<%if(AddUtil.parseInt(base.getRent_dt()) > 20130604){%>
								if(agree_dist == 0){alert('대여요금-약정운행거리를 입력하십시오.');fm.agree_dist.focus();return;}
								if(over_run_amt == 0){alert('대여요금-초과운행부담금을 입력하십시오.');fm.over_run_amt.focus();return;}
							<%}%>
							<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
								if(fm.rtn_run_amt_yn.value == '')								{ alert('대여요금-환급대여료적용여부를 입력하십시오.'); 	fm.rtn_run_amt_yn.focus(); 	return; }	
								if(rtn_run_amt == 0 && fm.rtn_run_amt_yn.value == '0')			{ alert('대여요금-환급대여료를 입력하십시오.'); 			fm.rtn_run_amt.focus();return;}
								if(rtn_run_amt > 0 && fm.rtn_run_amt_yn.value == '1')			{ alert('대여요금-환급대여료미적용이므로 환급대여료 0원 처리합니다.'); fm.rtn_run_amt.value = 0; }
							<%}%>
						}
						if(fm.car_gu.value == '0' && fm.agree_dist.value !='미적용'){//재리스
							<%if(AddUtil.parseInt(base.getRent_dt()) > 20140724){%>
								if(agree_dist == 0){ alert('대여요금-약정운행거리를 입력하십시오.');fm.agree_dist.focus();return;}
								if(over_run_amt == 0){ alert('대여요금-초과운행부담금을 입력하십시오.');fm.over_run_amt.focus();return;}
							<%}%>
							<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
								if(fm.rtn_run_amt_yn.value == '')								{ alert('대여요금-환급대여료적용여부를 입력하십시오.'); 	fm.rtn_run_amt_yn.focus(); 	return; }	
								if(rtn_run_amt == 0 && fm.rtn_run_amt_yn.value == '0')			{ alert('대여요금-환급대여료를 입력하십시오.');			fm.rtn_run_amt.focus();return;}
								if(rtn_run_amt > 0 && fm.rtn_run_amt_yn.value == '1')			{ alert('대여요금-환급대여료미적용이므로 환급대여료 0원 처리합니다.'); fm.rtn_run_amt.value = 0; }
							<%}%>
						}
						if(fm.car_gu.value == '0'){//재리스
							var over_bas_km = toInt(parseDigit(fm.over_bas_km.value));
						
							<%if (fees.getRent_st().equals("1") && base.getCar_gu().equals("0")) {%>
							if (fm.br_from_st.value == "") {
								alert('재리스 지점간 이동 출발을 선택해 주세요.');
								return;
							} else {
								if (fm.br_from_st.value == "9") {
									fm.br_from.value = "";
								} else {
									fm.br_from.value = fm.br_from_st.value;
								}
							}
							
							if (fm.br_to_st.value == "") {
								alert('재리스 지점간 이동 도착을 선택해 주세요.');
								return;
							} else {
								if (fm.br_to_st.value == "9") {
									fm.br_to.value = "";
								} else {
									fm.br_to.value = fm.br_to_st.value;
								}
							}
							<%}%>
						
							<%if(fee_size==1){%>
							if(over_bas_km == 0){ alert('대여요금-보유차 계약시점 주행거리를 입력하십시오.');fm.over_bas_km.focus();return;}
							<%}%>
						}
					if(fm.fee_pay_tm.value == ''){ alert('대여요금-납입횟수를 입력하십시오.'); 				fm.fee_pay_tm.focus(); 		return; }
					fm.tax_dc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.tax_dc_amt.value))));
					fm.tax_dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.tax_dc_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
					
					<%	if(base.getCar_gu().equals("1") && fee_size==1){%>
					//특판출고(실적이관가능)이면 영업수당은 없다.
					if(<%=base.getRent_dt()%> >= 20190610 && toFloat(parseDigit(fm.comm_r_rt.value))>0 && '<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && '<%=cont_etc.getDlv_con_commi_yn()%>' == 'Y' && '<%=cont_etc.getDir_pur_commi_yn()%>' == 'Y' && '<%=pur.getDir_pur_yn()%>' == 'Y' && '<%=pur.getPur_bus_st()%>' != '1'){
						alert('현대차이면서 법인고객이고 출고보전수당이 있는 특판출고는 영업수당이 없습니다.'); return;
					}					
					<%	}%>
					

					
					
					<%}%>
					<%}%>
				}
				
		//매입옵션여부에 따른 점검
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
		
		<%//}%>
		
		fm.idx.value = idx;
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_b_s_a.jsp';		
			fm.target='_self';
			fm.submit();
		}							
	}
	
	//직원조회
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();
	}
	
	//대여료 DC율 계산
	function dc_fee_amt(){
		//정상요금에서 계산함. 20170310 소스정리
	}		
	
	function estimates_view(rent_st, reg_code){
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?car_gu=<%=base.getCar_gu()%>&rent_st="+rent_st+"&est_code="+reg_code+"&esti_table=estimate";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//특약요청서 열기
	function reqdoc(rent_l_cd, rent_mng_id, rent_st){
		var url = 'lc_b_s_reqdoc.jsp?rent_l_cd='+rent_l_cd+'&rent_mng_id='+rent_mng_id+'&rent_st='+rent_st;
		window.open(url, "popupView", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
	}
	
	//수정
	function update_item(st, rent_st){
		var cmd = "입금선수금 수정";
		if(st == 'grt_amt' || st == 'pp_amt' || st == 'ifee_amt'){
			alert('선수금 변경후 대여료 정상요금 재계산하십시오.');
			if(st == 'pp_amt'){
				<%if(fees.getPp_chk().equals("0")){%>cmd = "매월균등발행 입금선수금 수정"<%}%>		
			}
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st+"&cmd="+cmd, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650");
		}
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
  <input type='hidden' name="est_from"			value="lc_b_u">
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
  <input type='hidden' name="driving_age" value="<%=base.getDriving_age()%>">
  <input type='hidden' name="gcp_kd" value="<%=base.getGcp_kd()%>">
  <%
  	if(cont_etc.getInsur_per().equals("")) 	cont_etc.setInsur_per("1");
  	if(cont_etc.getInsurant().equals("")) 	cont_etc.setInsurant("1");
  %>
  <input type='hidden' name="insurant" value="<%=cont_etc.getInsurant()%>">
  <input type='hidden' name="insur_per" value="<%=cont_etc.getInsur_per()%>">
  <input type='hidden' name="add_opt_amt" value="<%=car.getAdd_opt_amt()%>">
  <input type='hidden' name="sh_km" 		value="<%=fee_etc.getSh_km()%>">
  <input type='hidden' name="udt_st" 		value="<%=pur.getUdt_st()%>">
  <input type='hidden' name="car_c_amt" 		value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">
  <input type='hidden' name="opt" 		value="<%=car.getOpt_code()%>">
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
  <input type='hidden' name="tint_sn_yn" 		value="<%=car.getTint_sn_yn()%>">
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
  <!-- <input type='hidden' name="br_from_st"		value="">
  <input type='hidden' name="br_to_st"			value=""> -->
  <input type='hidden' name="san_st"			value="<%=san_st%>">
       
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금</span></td>
    </tr>

	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <!-- 재리스는 차량인도예정일 입력 -->
              <%if(fees.getRent_st().equals("1") && base.getCar_gu().equals("0")){ %>
              <tr>
                <td width="13%" align="center" class=title>차량인도예정일</td>
                <td colspan='5'>&nbsp;
                    <input type='text' size='12' name='car_deli_est_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
					 (재리스계약일 때 차량인도예정일 전날 보험변경합니다. 인도 확정시 다시 확인하십시오.)
					 </td>
              </tr>              
              <%}%>
              <tr>
                <td width="13%" align="center" class=title>계약일자</td>
                <td width="20%">&nbsp;
					  <%if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("5년이상계약점검자",user_id)  || nm_db.getWorkAuthUser("전산팀",user_id)  || user_id.equals(base.getBus_id())){%>
        			  <input type="text" name="ext_rent_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_dt())%>" size='12' maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(fees.getRent_dt())%>
					  <input type='hidden' name='ext_rent_dt' 	value='<%=fees.getRent_dt()%>'>
					  <%}%>				
				  
				</td>
                <td width="10%" align="center" class=title>계약담당자</td>
                <td >&nbsp;    
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fees.getExt_agnt(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_agnt" value="<%=fees.getExt_agnt()%>">			
			<a href="javascript:User_search('ext_agnt', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
                </td>
                <td width="10%" align="center" class=title>영업대리인</td>
                <td >&nbsp;                  
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etc.getBus_agnt_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_bus_agnt_id" value="<%=fee_etc.getBus_agnt_id()%>">			
			<a href="javascript:User_search('ext_bus_agnt_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>               
                </td>
              </tr>				
              <tr>
                <td width="13%" align="center" class=title>이용기간</td>
                <td width="20%">&nbsp;
                    <input type='text' name="con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 개월</td>
                <td width="10%" align="center" class=title>대여개시일</td>
                <td width="20%">&nbsp;
                  <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size='12' maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);' readonly></td>
                <td width="10%" align="center" class=title>대여만료일</td>
                <td>&nbsp;
                  <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size='12' maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);' readonly></td>
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
                    <td align='center'><input type='text' size='12' maxlength='10' name='grt_s_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum'  readonly<%}else{%>class='num'  onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%}%>>
        				  원</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_gur_p_per' class='fixnum' value='<%=fees.getF_gur_p_per()%>' readonly>
    				            %
    				            <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>
    				            <br><font color=red>※ 입금된 보증금은 별도 변경만 가능합니다.</font>
    				            <a href="javascript:update_item('grt_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %>
        				    </td>
                    <td align='center'>
					<%if(fee_size==1 && base.getRent_st().equals("3")){%>
					  대차 보증금 승계여부 :
					  <select name='grt_suc_yn'>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0"))%>selected<%%>>승계</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1"))%>selected<%%>>별도</option>
                            </select>	
					<%}else{%>					
        			    <%if(fees.getRent_st().equals("1")){%>
        				<input type='hidden' name='grt_suc_yn' value='<%= fees.getGrt_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='grt_suc_yn'>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0")){%>selected<%}%>>승계</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1")){%>selected<%}%>>별도</option>
                            </select>			  
        				<%}%>
					<%}%>
        				<input type='hidden' name='gur_per' value=''>
        				<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'></td>
                </tr>
                <%  pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1"); %>
                <tr>
                    <td class='title' colspan="2">선납금</td>
                    <td align="center"><input type='text' size='12' name='pp_s_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align="center"><input type='text' size='12' name='pp_v_amt' maxlength='10' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align='center'><input type='text' size='12' name='pp_amt'   maxlength='11' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='pere_r_per' class='fixnum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_pere_r_per' class='fixnum' value='<%=fees.getF_pere_r_per()%>' readonly>
    				            %  
    				            <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>
    				            <br><font color=red>※ 입금된 선납금은 별도 변경만 가능합니다.</font>
    				            <a href="javascript:update_item('pp_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %>
        				    </td>
                    <td align='center'><input type='hidden' name='pere_per' value=''>
           선납금 계산서발행구분 :
					<select name='pp_chk'>
                              <option value="">선택</option>
                              <option value="1" <%if(fees.getPp_chk().equals("1")){%>selected<%}%>>납부일시발행</option>
                              <option value="0" <%if(fees.getPp_chk().equals("0")){%>selected<%}%>>매월균등발행</option>
                            </select>                       	
                    </td>
                </tr>
                <%  pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2"); %>
                <tr>
                    <td class='title' colspan="2">개시대여료</td>
                    <td align="center"><input type='text' size='12' name='ifee_s_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align="center"><input type='text' size='12' name='ifee_v_amt' maxlength='10'  value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align='center'><input type='text' size='12' name='ifee_amt' maxlength='11'  value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">마지막
                        <input type='text' size='2' name='pere_r_mth' class='fixnum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  개월치 대여료 
        				  <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>
    				            <br><font color=red>※ 입금된 개시대여료는 별도 변경만 가능합니다.</font>
    				            <a href="javascript:update_item('ifee_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %>
        				  </td>
                    <td align='center'>
        			    <%if(fees.getRent_st().equals("1")){%>
        				<input type='hidden' name='ifee_suc_yn' value='<%= fees.getIfee_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='ifee_suc_yn'>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getIfee_suc_yn().equals("0")){%>selected<%}%>>승계</option>
                              <option value="1" <%if(fees.getIfee_suc_yn().equals("1")){%>selected<%}%>>별도</option>
                            </select>			  
        				<%}%>
        			    <input type='hidden' name='pere_mth' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">합계</td>
                    <td align="center"><input type='text' size='12' name='tot_pp_s_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='12' name='tot_pp_v_amt' maxlength='10' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='12' name='tot_pp_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">입금예정일 :
                          <input type='text' size='12' name='pp_est_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fees.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align='center'>&nbsp;
					<%	ExtScdBean suc = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fees.getRent_st(), "5", "1");//승계수수료 기존 등록 여부 조회
						if(suc == null || suc.getRent_l_cd().equals("")){
							
						}else{%>	
					승계수수료 입금여부 : <%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "5")%>
					<%	}%>
					</td>
                </tr>
                <tr>
        	    <td class='title' colspan="2">총채권확보</td>
                    <td colspan='3'>&nbsp;
                        결재자 : <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etc.getCredit_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="credit_sac_id" value="<%=fee_etc.getCredit_sac_id()%>">
			<a href="javascript:User_search('credit_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
			&nbsp;&nbsp;&nbsp;&nbsp;
			결재일자 : <input type='text' size='12' name='credit_sac_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fee_etc.getCredit_sac_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>				
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='<%=fees.getCredit_r_per()%>' readonly>%
        			<input type='text' size='12' name='credit_r_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>원(보증보험포함)</td>
                    <td align='center'><input type='text' size='4' name='credit_per' class='fixnum' value='<%=fees.getCredit_per()%>' readonly>%
        			<input type='text' size='12' name='credit_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_amt())%>' readonly>원</td>
                </tr>
                <tr>
                    <td rowspan="2" class='title'>운행<br>
                      거리</td>              
              <!--20130605 약정운행주행거리 운영-->    
                <td class='title' colspan="2"><span class="title1">약정운행거리</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='agree_dist' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' >
                  km이하/1년,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (약정이하운행시) 환급대여료  <input type='text' name='rtn_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)
                  <%	if ((nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
                  <select name='rtn_run_amt_yn'>        
                    <option value="">선택</option>                      
                    <option value="0" <%if(fee_etc.getRtn_run_amt_yn().equals("0")||fee_etc.getRtn_run_amt_yn().equals(""))%>selected<%%>>환급대여료적용</option>
                    <option value="1" <%if(fee_etc.getRtn_run_amt_yn().equals("1"))%>selected<%%>>환급대여료미적용</option>                    
                  </select>
                  <%	}else{ %>
                  <%		if(fee_etc.getRtn_run_amt_yn().equals("")){
                	  			fee_etc.setRtn_run_amt_yn("0");
                  			} 
                  %>
                  <%if(fee_etc.getRtn_run_amt_yn().equals("0")){%>※환급대여료적용<%}else if(fee_etc.getRtn_run_amt_yn().equals("1")){%>※환급대여료미적용<%} %>
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etc.getRtn_run_amt_yn()%>">
                  <%	} %>
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
                  초과 1km당 (<input type='text' name='over_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
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
                  <%if(AddUtil.parseInt(fees.getRent_dt()) > 20130604){
                  	
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
                    <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                    <input type='text' name='e_rtn_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>' >/1km,<br>&nbsp;
                    <%}else{ %>
                  	<input type="hidden" name="e_rtn_run_amt" value="<%=e_bean.getRtn_run_amt()%>">
                  	<%} %> 
                    <input type='text' name='e_over_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' >/1km,<br>&nbsp;
                    <input type='text' name='e_agree_dist_yn' size='15' class='whitetext' value='<%=e_agree_dist_yn%>' >
                  <%}%>
                </td>
              </tr>   
                <tr>
                    <td class='title' colspan="2" style="font-size : 8pt;">보유차주행거리</td>
                    <%if (fees.getRent_st().equals("1") && base.getCar_gu().equals("0")) {%>
                    <td colspan="4">&nbsp;
                        <input type='text' name='over_bas_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_bas_km())%>' >
                        km
                        (재리스 계약시점 대여차량 주행거리, 계약서 기재 값)
                    </td>
                    <td colspan="2" align="center">
                    	※ 재리스 지점간 이동 :&nbsp;
                    	출발&nbsp;
                    	<select name="br_from_st" class="default">
                    		<option value="" <%if (fee_etc.getBr_from_st().equals("")) {%>selected<%}%>>선택</option>
                    		<option value="9" <%if (fee_etc.getBr_from_st().equals("9")) {%>selected<%}%>>지점간이동없음</option>
                    		<option value="0" <%if (fee_etc.getBr_from_st().equals("0")) {%>selected<%}%>>서울</option>
                    		<option value="1" <%if (fee_etc.getBr_from_st().equals("1")) {%>selected<%}%>>대전</option>
                    		<option value="2" <%if (fee_etc.getBr_from_st().equals("2")) {%>selected<%}%>>대구</option>
                    		<option value="3" <%if (fee_etc.getBr_from_st().equals("3")) {%>selected<%}%>>광주</option>
                    		<option value="4" <%if (fee_etc.getBr_from_st().equals("4")) {%>selected<%}%>>부산</option>
                    	</select>
                    	&nbsp;&nbsp;
                    	도착&nbsp;
                    	<select name="br_to_st" class="default">
                    		<option value="" <%if (fee_etc.getBr_to_st().equals("")) {%>selected<%}%>>선택</option>
                    		<option value="9" <%if (fee_etc.getBr_to_st().equals("9")) {%>selected<%}%>>지점간이동없음</option>
                    		<option value="0" <%if (fee_etc.getBr_to_st().equals("0")) {%>selected<%}%>>서울</option>
                    		<option value="1" <%if (fee_etc.getBr_to_st().equals("1")) {%>selected<%}%>>대전</option>
                    		<option value="2" <%if (fee_etc.getBr_to_st().equals("2")) {%>selected<%}%>>대구</option>
                    		<option value="3" <%if (fee_etc.getBr_to_st().equals("3")) {%>selected<%}%>>광주</option>
                    		<option value="4" <%if (fee_etc.getBr_to_st().equals("4")) {%>selected<%}%>>부산</option>
                    	</select>
                    </td>
                    <%} else {%>
                    <td colspan="6">&nbsp;
                        <input type='text' name='over_bas_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_bas_km())%>' >
                        km
                        (재리스 계약시점 대여차량 주행거리, 계약서 기재 값)
                    </td>
                    <%}%>
                </tr>	                         
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
                    <td align="center"><input type='text' size='12' name='ja_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='12' name='ja_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='12' name='ja_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='max_ja' maxlength='10' readonly class='fixnum' value='<%=fees.getMax_ja()%>'>
        			  % </td>
                    <td align='center'>
                                  <input type='text' name='r_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' >km/1년
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
                    <td align="center"><input type='text' size='12' name='ja_r_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='12' name='ja_r_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='12' name='ja_r_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='app_ja' maxlength='10' readonly class="defaultnum" value='<%=fees.getApp_ja()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}%>
                <tr>
                    <td rowspan="6" class='title'>대<br>여<br>료</td>
                    <td class='title' colspan="2">계약요금</td>
                    <td align="center" ><input type='text' size='12'  name='fee_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='12'  name='fee_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='12'  name='fee_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>
					월대여료납입방식 :
					  <select name='fee_chk'>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getFee_chk().equals("0"))%>selected<%%>>매월납입</option>
                              <option value="1" <%if(fees.getFee_chk().equals("1"))%>selected<%%>>일시완납</option>
                            </select>	
					</td>
                </tr>
                <!-- 운전자추가요금/월보험료(고객피보험) 적용 (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">정<br>상<br>대<br>여<br>료</td>
                    <td class='title'>정상요금</td>
                    <td align="center" ><input type='text' size='12' name='inv_s_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='12' name='inv_v_amt' readonly maxlength='9' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='12' maxlength='10' readonly name='inv_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">
                    	<%if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4"))){//전기차,수소차%>
                    	<input type="hidden" name="ecar_pur_sub_yn" value="N"> 
                    	<%}%>
                    	
                    	<%EstimateBean esti = e_db.getEstimateCase(fee_etc.getBc_est_id()); 	%>
                    	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
                            <%if((now_stat.equals("계약승계") || now_stat.equals("차종변경")) && !fees.getRent_dt().equals(String.valueOf(begin.get("CLS_DT")))){%>
                            ※ 계약승계이거나 차종변경은 계산하지 않습니다.
                            <%}else{%>
                            	<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id) || nm_db.getWorkAuthUser("본사영업팀장",user_id) || nm_db.getWorkAuthUser("본사영업부팀장",user_id)){%>
                            	<%	if(base.getCar_gu().equals("1") && !base.getDlv_dt().equals("") && fees.getRent_st().equals("1")){%>
                            	<input type="checkbox" name="bc_dlv_yn" value="Y" <%if(fee_etc.getBc_dlv_yn().equals("Y")){%> checked <%}%> >출고일자기준
                            	<%	}else if(base.getCar_gu().equals("1") && fees.getRent_st().equals("1")){%>
                            	<!-- ※ 견적기준일 <input type="text" name="est_rent_dt" value="<%=esti.getRent_dt()%>" size="12" class=text>
                            	 -->
                            	 <input type='hidden' name="est_rent_dt" value="">
                            	<%	} %>
                            	<%}%>
                            <%}%>
		                <%}%>	
                    </td>
                    <td align='center'>&nbsp;
                        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
                            <%if((now_stat.equals("계약승계") || now_stat.equals("차종변경")) && !fees.getRent_dt().equals(String.valueOf(begin.get("CLS_DT")))){%>

                            <%}else{%>
        			              <span class="b"><a href="javascript:estimate('<%=fees.getRent_st()%>', '<%=fees.getRent_dt()%>', '<%=fees.getRent_start_dt()%>', 'account')" onMouseOver="window.status=''; return true" title="견적하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>	
                            <%}%>
					                  
		                    <%if(!esti.getReg_code().equals("")){%>
					              &nbsp;&nbsp;
        			              <span class="b"><a href="javascript:estimates_view('<%=fees.getRent_st()%>', '<%=esti.getReg_code()%>')" onMouseOver="window.status=''; return true" title="견적결과 보기"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>					                  
					        <%}%>
			            <%}%>		  
                    </td>
                </tr>
                <tr>
                    <td class='title'>월보험료(고객피보험)</td>
                    <td align="center" ><input type='text' size='12'  name='ins_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='12'  name='ins_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='12'  name='ins_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt()+fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">&nbsp;월보험료(공급가) = 년간보험료
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 원/12</td>
                    <td align='center'>자동차보험 관련 특약 약정서 &nbsp;&nbsp;&nbsp;&nbsp;
                    	<a href="javascript:reqdoc('<%=fees.getRent_l_cd()%>','<%=fees.getRent_mng_id()%>','<%=fees.getRent_st()%>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                    </td>
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
                   
        		<tr>
	                <td class='title' colspan="2">대여료DC</td>
	                <td colspan='3'>&nbsp;
	                    결재자 : 
	                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etc.getDc_ra_sac_id(), "USER")%>" size="12"> 
				<input type="hidden" name="dc_ra_sac_id" value="<%=fee_etc.getDc_ra_sac_id()%>">
				<a href="javascript:User_search('dc_ra_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
				<% user_idx++;%>
			    &nbsp;&nbsp;&nbsp;&nbsp;
			    결재일자 : 	
			    <input type='text' size='12' name='bas_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fees.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
	                
	                </td>                    
	                <td align='center'>-</td>            
	                <td align="center">
	                    적용근거 : <select name='dc_ra_st'>
	                        <option value=''>선택</option>
	                        <option value='1' <%if(fee_etc.getDc_ra_st().equals("1")){%>selected<%}%>>정상DC조건</option>
	                        <option value='2' <%if(fee_etc.getDc_ra_st().equals("2")){%>selected<%}%>>특별DC</option>
	                    </select>
	                    &nbsp;
			    기타 : 
			    <input type='text' size='18' name='dc_ra_etc' class="text" value='<%=fee_etc.getDc_ra_etc()%>'>
	                </td>
	                <td align='center'>
	                    DC율 <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value='<%=fees.getDc_ra()%>'>%
                    DC금액 <input type='text' size='6' name='dc_ra_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt()+fees.getIns_s_amt()+fees.getIns_v_amt()+fee_etc.getDriver_add_amt()+fee_etc.getDriver_add_v_amt()-fees.getFee_s_amt()-fees.getFee_v_amt())%>'>
	        				  원
	                </td>
              </tr>                    
				<%		int fee_etc_rowspan = 1;
				    	if(fees.getRent_st().equals("1")) fee_etc_rowspan = fee_etc_rowspan+2;//대차계약일때 원계약정보
				    	//운전자추가요금추가
		    			//fee_etc_rowspan++;
				%>
       
                <tr>
                    <td rowspan="<%=fee_etc_rowspan%>" class='title'>기<br>
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
				      <%if(fees.getRent_st().equals("1")){%>
                <tr>
                    <td class='title' colspan="2">영업수당</td>
                    <td colspan="2" align="center">
        			  산출기준:
        			  <select name='commi_car_st'>
                        <option value='1' <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>selected<%}%>>차량가격</option>
                      </select>
        			</td>
                    <td align='center'><input type='text' size='12' name='commi_car_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' <%if(!doc.getDoc_step().equals("3")){%>onBlur="javascript:setCommi()"<%}%>>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">
                        <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> <%if(!doc.getDoc_step().equals("3")){%>class='defaultnum' onBlur='javascript:setCommi()'<%}else{%>class='fixnum' readonly<%}%>>  
        		      %</td>
                    <td align='center'>
        				        <input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='fixnum' <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id)){%><%}else{%>readonly<%}%>>
        			  %</td>
                </tr>
                <%}%>
                
				<%if(fees.getRent_st().equals("1")){
					//대차원계약정보
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}  
					%>                                  
                <tr>
                    <td class='title' colspan="2" style="font-size : 8pt;">대차원계약</td>
                    <td colspan="6">&nbsp;
					  <b>[원계약정보]</b>
					  <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;계약번호 : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='grt_suc_c_no' size='12' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;차종코드별변수 차명 : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <span class="b"><a href="javascript:cancel_grt_suc()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[대차보증금승계]</b>
					  &nbsp;기존보증금 : <input type='text' name='grt_suc_o_amt' size='12' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>원
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  승계보증금 : <input type='text' name='grt_suc_r_amt' size='12' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum'  onBlur="javascript:document.form1.grt_suc_cha_amt.value=parseDecimal(toInt(parseDigit(document.form1.grt_suc_o_amt.value))-toInt(parseDigit(document.form1.grt_suc_r_amt.value)));">원
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(약정보증금 차액 <input type='text' name='grt_suc_cha_amt' size='10' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>' class='whitenum'>)</font>
					  <%}else{ %>
					  <input type='hidden' name='grt_suc_cha_amt' 	value=''>
					  <%} %>					  	
        			</td>
                </tr>						
				<%}else{%>	
				<input type='hidden' name='commi_car_st' 	value='<%=emp1.getCommi_car_st()%>'>							
				<input type='hidden' name='commi_car_amt' 	value='<%=emp1.getCommi_car_amt()%>'>							
				<input type='hidden' name='comm_r_rt' 		value='<%=emp1.getComm_r_rt()%>'>							
				<input type='hidden' name='comm_rt' 		value='<%=emp1.getComm_rt()%>'>							
				<%}%>
				<input type='hidden' name='commi' 		value='<%=emp1.getCommi()%>'>							
			  <input type='hidden' name='bus_agnt_r_per' 	value='<%=fee_etc.getBus_agnt_r_per()%>'>
			  <input type='hidden' name='bus_agnt_per' 	value='<%=fee_etc.getBus_agnt_per()%>'>
			  <input type='hidden' name='cls_n_mon' 	value='<%=fee_etc.getCls_n_mon()%>'>
			  <input type='hidden' name='cls_n_amt' 	value='<%=fee_etc.getCls_n_amt()%>'>			 
			  <input type='hidden' name='over_serv_amt' 	value='<%=fee_etc.getOver_serv_amt()%>'>
			  <input type='hidden' name='over_run_day' 		value='<%=fee_etc.getOver_run_day()%>'>              				
			  <input type="hidden" name="fee_sac_id" value="<%=fees.getFee_sac_id()%>">				
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
                <tr>
                    <td colspan="3" class='title'>계약서 특약사항 기재 내용</td>
                    <td colspan="6">
                    	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
		                      	<textarea rows='5' cols='90' name='con_etc' ><%=fee_etc.getCon_etc()%></textarea>                      
                    		</div>
                   		</div>
                      	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
					  		<div style="display: table-cell; vertical-align: middle;">
	                      	<%-- <%if (base.getCar_gu().equals("1") && base.getCar_mng_id().equals("") && fee_etc.getCon_etc().indexOf("개별소비세 한시적 감면(2020.3~6월) 관련 법률") == -1 && AddUtil.parseInt(AddUtil.getDate(4)) < 20210115) {//개소세 한시적 인하 기간 %> --%>
	                      	<%if (base.getCar_gu().equals("1") && base.getCar_mng_id().equals("") && AddUtil.parseInt(AddUtil.getDate(4)) < 20210101) {//개소세 한시적 인하 기간 %>
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
							  	<script>  src.indexOf(",", sp);
								function setMentConEtc(idx) {
									//document.form1.con_etc.value = '개별소비세 한시적 감면기간(2020.3~6월)을 초과하여 출고 될 경우 대여료는 인상됩니다.';
									if (idx == "0") {
										document.form1.con_etc.value = '개별소비세 한시적 세액 70% 감면(2020.3~6월) 기간을 초과하여, 개별소비세율이 3.5%(2020.7~12월)로 조정되어 출고시 월대여료가 *,***원(공급가) 인상됩니다.';
									}
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
										document.form1.con_etc.value = "※ 2022년 1월 1일 이후 신차가 출고되어 한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우 월대여료가 *,***원(공급가) 인상됩니다.";
									} 
								}
							  	</script>
					  		</div>
				  		</div>
                    </td>
                </tr>			
                <tr>
                    <td colspan="3" class='title'>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td colspan="6">
                    	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
                    			<textarea rows='5' cols='90' name='fee_cdt'><%=fees.getFee_cdt()%></textarea>
                    		</div>
                   		</div>
                    </td>
                </tr>		
                <%if(fee_etc.getRent_st().equals("1")){%>	    
                <tr>
                    <td colspan="3" class='title'>비고<br>(해지 관련)</td>
                    <td colspan="6">
                    	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
                    			<textarea rows='5' cols='90' name='cls_etc'><%=cont_etc.getCls_etc()%></textarea>
                    		</div>
                   		</div>
                    </td>
                </tr>
                <%}%>
            </table>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>납입횟수</td>
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='fee_pay_tm' value='<%=fees.getFee_pay_tm()%>' maxlength='2' class='text' >
        				회 </td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="20%">&nbsp;매월
                      <select name='fee_est_day'>
                        <option value="">선택</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                        <option value='<%=i%>' <%if(fees.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                        <% } %>
                        <option value='99' <%if(fees.getFee_est_day().equals("99")){%> selected <%}%>> 말일 </option>
						<option value='98' <%if(fees.getFee_est_day().equals("98")){%> selected <%}%>> 대여개시일 </option>
                      </select></td>
                    <td width="10%" class='title'>납입기간</td>
                    <td>&nbsp;
                      <input type='text' name='fee_pay_start_dt' maxlength='10' size='12' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
        			  <input type='text' name='fee_pay_end_dt' maxlength='10' size='12' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>		
            </table>				  				
	    </td>
    </tr>			

	<%if(acar_de.equals("1000")){ %>
	<input type='hidden' name="bc_s_a"	value="<%=fee_etc.getBc_s_a()%>">
	<input type='hidden' name="bc_b_e1"	value="<%=fee_etc.getBc_b_e1()%>">
	<input type='hidden' name="bc_b_e2"	value="<%=fee_etc.getBc_b_e2()%>">
	<input type='hidden' name="bc_b_u"	value="<%=fee_etc.getBc_b_u()%>">
	<input type='hidden' name="bc_b_g"	value="<%=fee_etc.getBc_b_g()%>">
	<input type='hidden' name="bc_b_ac"	value="<%=fee_etc.getBc_b_ac()%>">
	<input type='hidden' name="bc_etc"	value="<%=fee_etc.getBc_etc()%>">
	<input type='hidden' name="bc_b_t"	value="<%=fee_etc.getBc_b_t()%>">
	<input type='hidden' name="bc_b_u_cont"	value="<%=fee_etc.getBc_b_u_cont()%>">
	<input type='hidden' name="bc_b_g_cont"	value="<%=fee_etc.getBc_b_g_cont()%>">
	<input type='hidden' name="bc_b_ac_cont" value="<%=fee_etc.getBc_b_ac_cont()%>">
	<%}else{ %>	
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
            				<input type='hidden' name='bc_s_a' 	value='<%=fee_etc.getBc_s_a()%>'>
            		        <tr>
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
            		        <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_b_t</td>				  
            				  <td>&nbsp;용품사양</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_t' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getBc_b_t())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
            				</tr>
        		        </table>		
    			    </td>						
		        </tr>
            </table>
	    </td>
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
		
    <%if(ck_acar_id.equals("000029") || u_chk==0){%>
		<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||   auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('12')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
		<tr>	
		<%}%>
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
	var fm = document.form1;
	
  <%if(fee_opt_amt>0){//연장계약시 매입옵션이 있는 경우%>
	fm.fee_opt_amt.value = <%=fee_opt_amt%>;
  <%}%>
  
	<%if(!base.getCar_st().equals("2")){%>
	sum_pp_amt();
	<%}%>

//-->
</script>
</body>
</html>
