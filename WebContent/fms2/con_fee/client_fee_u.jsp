<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
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
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
	//4. 변수----------------------------
	
	//중고차잔가 정보
	Hashtable janga 	= shDb.getJanga_20070528(base.getCar_mng_id());
	Hashtable carOld 	= c_db.getOld(cr_bean.getInit_reg_dt(), ext_fee.getRent_end_dt());
	
	//신)중고차잔가코드 20070316
//	Vector jgVarList = edb.getEstiJgVarList();
//	int jgVarList_size = jgVarList.size();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	
	String a_a = "";
	if(base.getCar_st().equals("1")){ a_a = "2"; }
	if(base.getCar_st().equals("3")){ a_a = "1"; }
	String a_e = cm_bean.getS_st();
	
	
	
	String o_3 		= edb.getEstiSikVarCase("1", "", "o_3");
	
	String var_seq = "";
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//리스트
	function list(){
		var fm = document.form1;	
		if(fm.from_page.value != '') 	fm.action = fm.from_page.value;
		else 							fm.action = 'lc_b_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
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
	
	//대여기간 셋팅
	function set_cont_date(obj){
		var fm = document.form1;
		var rent_way = fm.rent_way.value;
		
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;

		if(obj == fm.rent_start_dt){
			//fm.rent_start_dt.value = ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value);
		}
		if(obj == fm.con_mon && rent_way == '1'){
			fm.fee_pay_tm.value = toInt(fm.con_mon.value)-3;
			fm.rent_start_dt.value = ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value);
		}
		if(obj == fm.con_mon && rent_way != '1'){
			fm.fee_pay_tm.value = fm.con_mon.value;
			fm.rent_start_dt.value = ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value);
		}	
		
		if(ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
					
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
		
		//보증금---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//보증금 공급가
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value 	= fm.grt_s_amt.value;
			//if(toInt(parseDigit(fm.grt_s_amt.value)) > 0){
				fm.gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / car_price * 100, 1);
			//}
			sum_pp_amt();			
		}else if(obj==fm.grt_amt){ 		//보증금 합계
			obj.value = parseDecimal(obj.value);
			fm.grt_s_amt.value 	= fm.grt_amt.value;
			//if(toInt(parseDigit(fm.grt_s_amt.value)) > 0){
				fm.gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / car_price * 100, 1);
				
			//}
			sum_pp_amt();		
		//선납금---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt){ 	//선납금 공급가
			obj.value = parseDecimal(obj.value);
			fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			//if(toInt(parseDigit(fm.pp_amt.value)) > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
			//}
			sum_pp_amt();			
		}else if(obj==fm.pp_v_amt){ 	//선납금 부가세
			obj.value = parseDecimal(obj.value);
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			//if(toInt(parseDigit(fm.pp_amt.value)) > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
			//}		
			sum_pp_amt();	
		}else if(obj==fm.pp_amt){ 		//선납금 합계
			obj.value = parseDecimal(obj.value);
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));			
					
			//if(toInt(parseDigit(fm.pp_amt.value)) > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
			//}			
			sum_pp_amt();
		//개시대여료---------------------------------------------------------------------------------			
		}else if(obj==fm.ifee_s_amt){ 	//개시대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.ifee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) * 0.1 );
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
		
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
			}			
			sum_pp_amt();
		}else if(obj==fm.ifee_v_amt){ 	//개시대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
		
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
				
			}	
			sum_pp_amt();					
		}else if(obj==fm.ifee_amt){ 	//개시대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
			fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));			
					
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));	
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);			
			}	
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
			//fm.app_ja.value 		= parseFloatCipher3(toInt(parseDigit(fm.ja_amt.value)) / car_price * 100, 2);
		}else if(obj==fm.ja_r_v_amt){ 	//적용잔가 부가세
			obj.value = parseDecimal(obj.value);
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
		}else if(obj==fm.ja_r_amt){		//적용잔가 합계
			obj.value = parseDecimal(obj.value);
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
			fm.app_ja.value 		= parseFloatCipher3(toInt(parseDigit(fm.ja_r_amt.value)) / car_price * 100, 1);
		//매입옵션율---------------------------------------------------------------------------------			
		}else if(obj==fm.opt_s_amt){ 	//매입옵션 공급가
			obj.value = parseDecimal(obj.value);
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) * 0.1 );
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));			
			fm.opt_per.value 		= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / car_price * 100, 1);
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
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
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
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
			fm.opt_per.value 		= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / car_price * 100, 1);
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
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
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			}
		}else if(obj==fm.fee_v_amt){ 	//계약대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.fee_amt.value		= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.fee_amt){ 		//계약대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));			
			dc_fee_amt();
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			}
		//규정대여료---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//규정대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.inv_v_amt){ 	//규정대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value		= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.inv_amt){ 		//규정대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
			dc_fee_amt();
		}
		
	}	
	
	//선수금 합계
	function sum_pp_amt(){
		var fm = document.form1;
		
		fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		
		
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));	
		car_price 		= toInt(parseDigit(fm.sh_amt.value));		
		
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
	
	//규정대여료 계산 (견적)
	function estimate(st){
		var fm = document.form1;
	
		if(toInt(fm.app_ja.value) == 0)	{ alert('적용잔가율를 입력하십시오.'); 		return;	}
		if(toInt(fm.ja_amt.value) == 0)	{ alert('적용잔가금액을 입력하십시오.'); 	return;	}		
		if(fm.rent_dt.value == '')		{ alert('연장계약일자를 입력하십시오.'); 	return; }
		if(fm.car_mng_id.value == '')	{ alert('챠랑이 선택되지 않았습니다. 확인하십시오.'); 	return; }		
		
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));
		var s_dc_amt = 0;
		
		if(fm.s_dc1_yn.value == 'Y' && toInt(fm.s_dc1_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_yn.value == 'Y' && toInt(fm.s_dc2_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_yn.value == 'Y' && toInt(fm.s_dc3_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc3_amt.value));
		
		if(fm.s_dc1_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
						
		fm.o_1.value 		= car_price - s_dc_amt;
		fm.t_dc_amt.value 	= s_dc_amt;
		fm.esti_stat.value 	= st;
		
		fm.action='get_fee_secondhand.jsp';
		
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}

		fm.submit();

	}
	
	//결재하기
	function sanction(){
		var fm = document.form1;
		if(toInt(fm.chk_cnt.value) > 0){
			alert('입력값 체크 결과 확인이 필요한 항목이 '+toInt(fm.chk_cnt.value)+'건 발생했습니다.');
//			return;
		}
		
		fm.idx.value = 'sanction';
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='lc_b_u_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}									
	}

	//등록
	function update(){
		var fm = document.form1;
			
		fm.idx.value = 'ext_fee';
			
		if(confirm('수정하시겠습니까?')){	
		
			fm.action='lc_b_u_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}							
	}

	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
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
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=100, top=100, width=850, height=450, scrollbars=yes");
	}		
	//차량가격
	function view_car_amt(rent_mng_id, rent_l_cd)
	{		
		window.open("/fms2/lc_rent/view_car_amt.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&cmd=view", "VIEW_CAR_AMT", "left=100, top=100, width=850, height=450, scrollbars=yes");
	}		
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
//		theURL = "http://211.52.73.84/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//스캔등록
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//삭제하기
	function remove(seq, st_nm){
		fm = document.form1;
		fm.remove_seq.value = seq;
		if(!confirm(st_nm+".pdf 파일을 삭제하시겠습니까?"))		return;		
		fm.idx.value = 'ext_fee';
		fm.target = "i_no";
		fm.action='reg_scan.jsp';
		fm.submit();
	}	
	
	//스캔관리 보기
	function view_scan(){
		window.open("scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
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
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
  <input type='hidden' name="remove_seq"		value="">  
  <input type='hidden' name="idx"				value="">  
  <input type='hidden' name="chk_cnt"			value="">    
  <input type='hidden' name="scan_cnt"			value="">      
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
	  <td align='left'><font color="navy">영업지원 -> </font><font color="navy">계약관리</font> -> <font color="red">미결계약</font></td>
    </tr>
    <tr>
	  <td align='right'><a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
	</tr>  
	<%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계") || String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>
    <tr>
	  <td>[변경전 원계약]</td>
	</tr>		
    <tr> 
      <td class=line> 		
        <table border="0" cellspacing="1" cellpadding='0' width=100%>		
		  <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>
          <tr> 
            <td class=title width=13%>변경구분</td>
            <td width=20%>&nbsp;<%=begin.get("CLS_ST")%></td>
            <td class=title width=10%>변경일자</td>
            <td width=20%>&nbsp;<%=begin.get("CLS_DT")%></td>
            <td class=title width=10%>고객</td>
            <td>&nbsp;<%=begin.get("FIRM_NM")%></td>
          </tr>
		  <%}else if(String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>
          <tr> 
            <td class=title width=13%>변경구분</td>
            <td width=20%>&nbsp;<%=begin.get("CLS_ST")%></td>
            <td class=title width=10%>변경일자</td>
            <td width=20%>&nbsp;<%=begin.get("CLS_DT")%></td>
            <td class=title width=10%>자동차</td>
            <td>&nbsp;<%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%></td>
          </tr>
		  <%}%>
        </table>		
	  </td>
	</tr>
    <tr>
	  <td>&nbsp;</td>
	</tr>	
    <%}%>			
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
            <td>&nbsp;<%String cont_rent_st = base.getRent_st();%><%if(cont_rent_st.equals("1")){%>신규<%}else if(cont_rent_st.equals("3")){%>대차<%}else if(cont_rent_st.equals("4")){%>증차<%}%></td>
            <td class=title>영업구분</td>
            <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이전트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
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
            <td>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a></td>
            <td class=title>차명</td>
            <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
			<font color="#999999">(차종코드:<%=cm_bean.getJg_code()%>)</font>
			</td>
          </tr>
        </table>
	  </td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
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
            <td style="font-size : 8pt;" align="center"><%if(ext_fee.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>			
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>원&nbsp;</td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>원&nbsp;</td>
            <td style="font-size : 8pt;" align="center"><%if(ext_fee.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>원&nbsp;</td>
            <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
          </tr>
		  <%}}%>
        </table>
		<%}%>
	  </td>
	</tr>
	<tr>
	  <td align="right"><hr></td>
	</tr>	
	<tr>
	  <td>▣ 차량가격 </td>
	</tr>	
    <tr> 
      <td class=line> 			  
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width='13%' class='title'> 신차소비자가 </td>
            <td width="20%">&nbsp;
				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(fee_etc.getSh_car_amt())%>'size='10' class='num'>
				  원&nbsp;<font size='7' color='#999999'><a href="javascript:view_car_amt('<%=rent_mng_id%>','<%=rent_l_cd%>')">more</a></font></td>
            <td class='title' width="10%">최초등록일</td>
            <td width="20%">&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
            <td class='title' width='10%'>차령</td>
            <td>&nbsp;<input type='text' name='sh_year' value='<%=fee_etc.getSh_year()%>'size='1' class='text'>년
				  <input type='text' name='sh_month' value='<%=fee_etc.getSh_month()%>'size='2' class='text'>개월
				  <input type='text' name='sh_day' value='<%=fee_etc.getSh_day()%>'size='2' class='text'>일
				  (<input type='text' name='sh_day_bas_dt' value='<%= AddUtil.ChangeDate2(fee_etc.getSh_day_bas_dt()) %>'size='11' class='text'>)</td>
          </tr>
          <tr>
            <td class='title'>중고차가</td>
            <td>&nbsp;
                      <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(fee_etc.getSh_amt()) %>'size='10' class='num'>
					  원					  
            </td>
            <td class='title' width="10%">잔가율</td>
            <td>&nbsp;
			  
				  <input type='text' name='sh_ja' value='<%=fee_etc.getSh_ja()%>'size='4' class='num'>
			%</td>
            <td class='title'>주행거리</td>
            <td>&nbsp;
                      <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(fee_etc.getSh_km()) %>' class='num' >					   
                    km(<input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2(fee_etc.getSh_km_bas_dt()) %>' class='text' >)</td>
          </tr>
        </table>
	  </td>
    </tr>
	<tr>
	  <td>▣ 연장 대여요금</td>
    </tr>
	  <input type='hidden' name="rent_st" value="<%=rent_st%>">
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="13%" align="center" class=title>계약일자</td>
            <td width="20%">&nbsp;
			  <input type="text" name="rent_dt" value="<%=AddUtil.ChangeDate2(ext_fee.getRent_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'></td>
            <td width="10%" align="center" class=title>계약담당자</td>
            <td colspan="3">&nbsp;
			  <select name='ext_agnt'>
                <option value="">선택</option>
                <%if(user_size > 0){
					for(int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>' <%if(ext_fee.getExt_agnt().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%	}
				}		%>
              </select></td>
          </tr>
          <tr>
            <td width="13%" align="center" class=title>이용기간</td>
            <td width="20%">&nbsp;
                <input type='text' name="con_mon" value='<%=ext_fee.getCon_mon()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
    			 개월</td>
            <td width="10%" align="center" class=title>대여개시일</td>
            <td width="20%">&nbsp;
              <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate4(this, this.value); set_cont_date(this);'></td>
            <td width="10%" align="center" class=title>대여만료일</td>
            <td>&nbsp;
              <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate4(this, this.value);'></td>
          </tr>
          <tr>
            <td align="center" class=title>판정신용등급</td>
            <td>&nbsp;
			  <input type='hidden' name='spr_kd' value='<%=base.getSpr_kd()%>'>
			  <% if(base.getSpr_kd().equals("3")){ out.print("신설법인"); 	}%>
              <% if(base.getSpr_kd().equals("0")){ out.print("일반고객"); 	}%>
              <% if(base.getSpr_kd().equals("1")){ out.print("우량기업"); 	}%>
              <% if(base.getSpr_kd().equals("2")){ out.print("초우량기업");  }%>
			</td>
            <td class=title>연대보증</td>
            <td colspan="3">&nbsp;
			<%if(cont_etc.getClient_guar_st().equals("1")){%>
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
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td colspan="2" class='title'>구분</td>
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
            <td width="10%" class='title'>보증금</td>
            <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' >
				  원</td>
            <td align='center'>-</td>
            <td align='center'><input type='text' size='10' maxlength='10' name='grt_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' >
				  원 </td>
            <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, ext_fee.getRent_st(), "0")%></td>
            <td align="center">차가의
                <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=ext_fee.getGur_p_per()%>'>
				  % </td>
            <td align='center'>
			  <select name='grt_suc_yn' onChange="javascript:display_suc('grt')">
                      <option value="">선택</option>
                      <option value="0" <%if(ext_fee.getGrt_suc_yn().equals("0")){%>selected<%}%>>승계</option>
                      <option value="1" <%if(ext_fee.getGrt_suc_yn().equals("1")){%>selected<%}%>>별도</option>
                    </select>	
			  <input type='hidden' name='gur_per' value=''>
			</td>
          </tr>
          <tr>
            <td class='title'>선납금</td>
            <td align="center"><input type='text' size='10' name='pp_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getPp_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' >
				  원</td>
            <td align="center"><input type='text' size='9' name='pp_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' >
				  원</td>
            <td align='center'><input type='text' size='10' name='pp_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' >
				  원 </td>
            <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, ext_fee.getRent_st(), "1")%></td>
            <td align="center">차가의
                <input type='text' size='4' name='pere_r_per' class='fixnum' value='<%=ext_fee.getPere_r_per()%>'>
				  % </td>
            <td align='center'>-<input type='hidden' name='pere_per' value=''></td>
          </tr>
          <tr>
            <td class='title'>개시대여료</td>
            <td align="center"><input type='text' size='10' name='ifee_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align="center"><input type='text' size='9' name='ifee_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align='center'><input type='text' size='10' name='ifee_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' >
				  원 </td>
            <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, ext_fee.getRent_st(), "2")%></td>
            <td align="center">마지막
                <input type='text' size='2' name='pere_r_mth' class='fixnum' value='<%=ext_fee.getPere_r_mth()%>'>
				  개월치 대여료 </td>
            <td align='center'>
			  <select name='ifee_suc_yn' onChange="javascript:display_suc('ifee')">
                      <option value="">선택</option>
                      <option value="0" <%if(ext_fee.getIfee_suc_yn().equals("0")){%>selected<%}%>>승계</option>
                      <option value="1" <%if(ext_fee.getIfee_suc_yn().equals("1")){%>selected<%}%>>별도</option>
                    </select>
			  <input type='hidden' name='pere_mth' value=''></td>
          </tr>
          <tr>
            <td class='title'>합계</td>
            <td align="center"><input type='text' size='10' name='tot_pp_s_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
				  원</td>
            <td align="center"><input type='text' size='9' name='tot_pp_v_amt' maxlength='10' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
				  원</td>
            <td align='center'><input type='text' size='10' name='tot_pp_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
				  원</td>
            <td align='center'>-</td>
            <td align="center">입금예정일 :
                  <input type='text' size='12' name='pp_est_dt' maxlength='12' class="text" value='<%=AddUtil.ChangeDate2(ext_fee.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td align='center'>&nbsp;</td>
          </tr>
          <tr>
            <td class='title'>총채권확보</td>
            <td align='center'>-</td>
            <td align='center'>-</td>
            <td align='center'>-</td>						
            <td align='center'>-</td>									
            <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='<%=ext_fee.getCredit_r_per()%>' >%
			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(ext_fee.getCredit_r_amt())%>' >원(보증보험포함)</td>
            <td align='center'><input type='text' size='4' name='credit_per' class='fixnum' value='<%=ext_fee.getCredit_per()%>' >%
			<input type='text' size='10' name='credit_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(ext_fee.getCredit_r_amt())%>' >원</td>
          </tr>
          <tr>
            <td rowspan="3" class='title'>잔<br>
              가</td>
            <td class='title'>최대잔가</td>
            <td align="center"><input type='text' size='10' name='ja_s_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(ext_fee.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align="center"><input type='text' size='9' name='ja_v_amt' maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(ext_fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align='center'><input type='text' size='10' name='ja_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(ext_fee.getJa_s_amt()+ext_fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align='center'>-</td>
            <td align='center'>
			  최대잔가율:차가의
                  <input type='text' size='4' name='max_ja' maxlength='10' class=defaultnum value='<%=ext_fee.getMax_ja()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
                  %</td>
            <td align='center'><!--<span class="b"><a href="javascript:set_janga()" onMouseOver="window.status=''; return true" title="최대잔가율 계산하기">계산하기</a></span>--></td>
          </tr>
          <tr>
            <td class='title'>매입옵션</td>
            <td align="center"><input type='text' size='10' name='opt_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align="center"><input type='text' size='9' name='opt_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align='center'><input type='text' size='10' name='opt_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align='center'>-</td>
            <td align="center">차가의
                <input type='text' size='4' name='opt_per' class='whitenum' value='<%=ext_fee.getOpt_per()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  % </td>
            <td align='center'>
			  <input type='radio' name="opt_chk" value='0' <%if(ext_fee.getOpt_chk().equals("0")){%> checked <%}%>>
              없음
              <input type='radio' name="opt_chk" value='1' <%if(ext_fee.getOpt_chk().equals("1")){%> checked <%}%>>
	 		  있음</td>
          </tr>
          <tr>
            <td class='title'>적용잔가</td>
            <td align="center"><input type='text' size='10' name='ja_r_s_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(ext_fee.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align="center"><input type='text' size='9' name='ja_r_v_amt' maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(ext_fee.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align='center'><input type='text' size='10' name='ja_r_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(ext_fee.getJa_r_s_amt()+ext_fee.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align='center'>-</td>				  
            <td align="center">차가의
			  <input type='text' size='4' name='app_ja' maxlength='10' class="defaultnum" value='<%=ext_fee.getApp_ja()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
			  % </td>
            <td align='center'>-</td>
          </tr>		  
          <tr>
            <td rowspan="2" class='title'>대<br>
              여<br>
              료</td>
            <td class='title'>계약요금</td>
            <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
				  원</td>
            <td align="center" ><input type='text' size='9'  name='fee_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
				  원</td>
            <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
				  원</td>
            <td align='center'>-</td>
            <td align="center">DC율:
              <input type='text' size='4' name='dc_ra' maxlength='10' class="num" value='<%=ext_fee.getDc_ra()%>'>
            </font>%</span></td>
            <td align='center'>-</td>
          </tr>
          <tr>
            <td class='title'>정상요금</td>
            <td align="center" ><input type='text' size='10' name='inv_s_amt' maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(ext_fee.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align="center" ><input type='text' size='9' name='inv_v_amt' maxlength='9' class='defaultnum' value='<%=AddUtil.parseDecimal(ext_fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align='center' ><input type='text' size='10' maxlength='10' name='inv_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(ext_fee.getInv_s_amt()+ext_fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  원</td>
            <td align='center'>-</td>
            <td align="center">기준일자<span class="contents1_1">
              <input type='text' size='12' name='bas_dt' maxlength='12' class="text" value='<%=AddUtil.ChangeDate2(ext_fee.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
            </span></td>
            <td align='center'>&nbsp;
			  <span class="b"><a href="javascript:estimate('account')" onMouseOver="window.status=''; return true" title="견적하기">계산하기</a></span>
			  &nbsp;&nbsp;
			  <span class="b"><a href="javascript:estimate('view')" onMouseOver="window.status=''; return true" title="견적계산식 보기">보기</a></span>
            </td>
          </tr>
          <tr>
            <td colspan="2" class='title'>중도해지위약율</td>
            <td colspan="2" align="center">-</td>
            <td align='center'>-</td>
            <td align='center'>-</td>
            <td align='center'><font color="#FF0000">
				<input type='text' size='3' name='cls_r_per' maxlength='10' class='num' value='<%=ext_fee.getCls_r_per()%>'>%</font></span></td>
            <td align="center">잔여기간 대여료의
                <input type='text' size='3' name='cls_per' maxlength='10'  class='num' value='<%=ext_fee.getCls_per()%>'>
				  %</td>
          </tr>
          <tr>
            <td colspan="2" class='title'>결재자</td>
            <td colspan="6">&nbsp;<select name='fee_sac_id'>
                <option value="">선택</option>
                <%if(user_size > 0){
					for(int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>' <%if(ext_fee.getFee_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%	}
				}		%>
              </select></td>
          </tr>
          <tr>
            <td colspan="2" class='title'>비고</td>
            <td colspan="6">&nbsp;<textarea rows='5' cols='90' name='fee_cdt'><%=ext_fee.getFee_cdt()%></textarea></td>
          </tr>
        </table>		
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width="13%" class='title'>납입횟수</td>
            <td width="20%">&nbsp;
              <input type='text' size='3' name='fee_pay_tm' value='<%=ext_fee.getFee_pay_tm()%>' maxlength='2' class='text' >
				회 </td>
            <td width="10%" class='title'>납입일자</td>
            <td width="20%">&nbsp;매월
              <select name='fee_est_day'>
                <option value="">선택</option>
                <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                <option value='<%=i%>' <%if(ext_fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                <% } %>
                <option value='99' <%if(ext_fee.getFee_est_day().equals("99")){%> selected <%}%>> 말일 </option>
				<option value='98' <%if(ext_fee.getFee_est_day().equals("98")){%> selected <%}%>> 대여개시일 </option>
              </select></td>
            <td width="10%" class='title'>납입기간</td>
            <td>&nbsp;
              <input type='text' name='fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(ext_fee.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
				~
			  <input type='text' name='fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(ext_fee.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>		  		  	
          <tr>
            <td width="13%" class='title'>1회차납입일</td>
            <td width="20%">&nbsp;
              <input type='text' name='fee_fst_dt' value='<%=AddUtil.ChangeDate2(ext_fee.getFee_fst_dt())%>' maxlength='12' size='12' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
				</td>
            <td width="10%" class='title'>1회차납입액</td>
            <td colspan="3">&nbsp;
			  <input type='text' name='fee_fst_amt' value='<%=AddUtil.parseDecimal(ext_fee.getFee_fst_amt())%>' maxlength='10' size='10' class='num'>원
              </td>
          </tr>		  		  		  		  		  	  
		</table>		
	  </td>
	</tr>			

    <tr>
      <td>&nbsp;</td>
    </tr>
	<%for(int i=1; i<=10; i++){//입력값 점검%>
	<tr id=tr_chk<%=i%> style='display:none'>
	  <td><input type='text' name="chk<%=i%>" value='' size="100" class='redtext'></td>
	</tr>	
	<%}%>		
    <tr>
	  <td align='center'>
	  <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	  <%if(nm_db.getWorkAuthUser("계약결재",user_id)){%>	
	  <input type="button" name="b_selete" value="결재" onClick="javascript:sanction();">
	  <%}%>	
	  &nbsp;&nbsp;<input type="button" name="b_selete" value="수정" onClick="javascript:update();">	  	
	  <%}%>
	  </td>
	</tr>		
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
		
	fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
	fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
	fm.tot_pp_amt.value = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		
		
	cont_chk();
		
	function cont_chk(){
		
		fm.scan_cnt.value = <%=scan_cnt%>;	
		
		if(toInt(fm.scan_cnt.value) == 0){
			fm.chk1.value = '* 연장 계약서 스캔이 없습니다. --> 결재 조건이 충족되지 않습니다.';
			tr_chk1.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		
		//필수이력 체크
		if(fm.fee_sac_id.value == ''){
			fm.chk2.value = '* 대여요금 결재자가 없습니다.';
			tr_chk2.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}	
						
		if(fm.opt_chk.value == ''){
			fm.chk3.value = '* 매입옵션 유무가 없습니다.';
			tr_chk3.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		if(fm.opt_chk.value == '1' && (fm.opt_per.value == '' || toInt(parseDigit(fm.opt_amt.value))==0)){
			fm.chk4.value = '* 매입옵션율 또는 매입옵션금액이 없습니다.';
			tr_chk4.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		if(fm.cls_r_per.value == ''){
			fm.chk5.value = '* 중도해지위약율이 없습니다.';
			tr_chk5.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}

		
		
	}
		
	//바로가기
	var s_fm 	= parent.parent.top_menu.document.form1;
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
		
//-->
</script>
</body>
</html>
