<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, card.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.con_ins.*, acar.secondhand.*, acar.offls_pre.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="ins" class="acar.con_ins.InsurBean" scope="page"/>
<jsp:useBean id="oh_db" scope="session" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String old_rent_mng_id 	= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 	= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//자동차기본정보-기본차량
	CarMstBean cm_bean2 = new CarMstBean();
	if(!cm_bean.getCar_b_inc_id().equals("")){
		cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	}
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//보험정보
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");

	//월렌트정보
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
	
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//신용카드 자동출금
	ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
	
	
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP", "Y");
	int user_size = users.size();
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
	
	//최근 홈페이지 적용대여료
	Hashtable hp = oh_db.getSecondhandCaseRm("", "", base.getCar_mng_id());	
		 
	//견적정보
	String est_id = String.valueOf(hp.get("RM1_ID"));
	if(est_id.equals("") || est_id.equals("null")){
		est_id = shDb.getSearchEstIdShRm(base.getCar_mng_id(), "21", "1", "", String.valueOf(hp.get("REAL_KM")), String.valueOf(hp.get("UPLOAD_DT")), String.valueOf(hp.get("RM1")), String.valueOf(hp.get("REG_CODE")));
	}
	e_bean = e_db.getEstimateShCase(est_id);		

	out.println("est_id="+est_id);
	out.println("rm="+String.valueOf(hp.get("RM1")));

		 
	Hashtable sh_ht = new Hashtable();
	Hashtable sh_ht2 = new Hashtable();
	Hashtable carOld = new Hashtable();
	
	//차량정보
	sh_ht = shDb.getShBase(base.getCar_mng_id());
	//차량등록 경과기간(차령)
	carOld 	= c_db.getOld(cr_bean.getInit_reg_dt());		
	//차량정보
	sh_ht2 = shDb.getBase(base.getCar_mng_id(), base.getRent_dt(), (String)sh_ht.get("SERV_DT"));	
	
	String print_car_st_yn = "";
	Hashtable tax_print_car = al_db.getTaxPrintCarStChk(base.getClient_id());	
	if(
					      ( cm_bean.getS_st().equals("100") || cm_bean.getS_st().equals("101") || cm_bean.getS_st().equals("409") 
						    || cm_bean.getS_st().equals("601") || cm_bean.getS_st().equals("602") 
							|| cm_bean.getS_st().equals("700") || cm_bean.getS_st().equals("701") || cm_bean.getS_st().equals("702") 
							|| cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("802") 
							|| cm_bean.getS_st().equals("803") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("812") ) 
	 ){//'100','101','601','602','701','702','801','802','803','811','812'	
	 	print_car_st_yn = "Y";
	 }	
	
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
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step3.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		

	//자동차등록정보 보기
	function view_car()
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}	
		
	//대여기간 셋팅
	function set_cont_date(obj){
		var fm = document.form1;

		if(obj == fm.con_mon || obj == fm.con_day){
					
			fm.v_con_mon.value = fm.con_mon.value;
			fm.v_con_day.value = fm.con_day.value;					
			
			set_sum_amt();	
		}
			
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
		
		var car_price 	= toInt(parseDigit(fm.sh_amt.value));
		
		//보증금---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//보증금 공급가
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value = fm.grt_s_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value = replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			}

		//정상대여료---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//정상대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();			
		}else if(obj==fm.inv_v_amt){ 	//정상대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.inv_amt){ 	//정상대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
			dc_fee_amt();			
		//D/C---------------------------------------------------------------------------------
		}else if(obj==fm.dc_s_amt){ 	//D/C 공급가
			obj.value = parseDecimal(obj.value);
			fm.dc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) * 0.1 );
			fm.dc_amt.value	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));			
			dc_fee_amt();			
		}else if(obj==fm.dc_v_amt){ 	//D/C 부가세
			obj.value = parseDecimal(obj.value);
			fm.dc_amt.value	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.dc_amt){ 	//D/C 합계
			obj.value = parseDecimal(obj.value);
			fm.dc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.dc_amt.value))));
			fm.dc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)));			
			dc_fee_amt();			
		//내비게이션---------------------------------------------------------------------------------
		}else if(obj==fm.navi_s_amt){ 	//내비게이션 공급가
			obj.value = parseDecimal(obj.value);
			fm.navi_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) * 0.1 );
			fm.navi_amt.value	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value)));			
		}else if(obj==fm.navi_v_amt){ 	//내비게이션 부가세
			obj.value = parseDecimal(obj.value);
			fm.navi_amt.value	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value)));			
		}else if(obj==fm.navi_amt){ 	//내비게이션 합계
			obj.value = parseDecimal(obj.value);
			fm.navi_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.navi_amt.value))));
			fm.navi_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.navi_amt.value)) - toInt(parseDigit(fm.navi_s_amt.value)));			
		//기타---------------------------------------------------------------------------------
		}else if(obj==fm.etc_s_amt){ 	//기타 공급가
			obj.value = parseDecimal(obj.value);
			fm.etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) * 0.1 );
			fm.etc_amt.value	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));			
		}else if(obj==fm.etc_v_amt){ 	//기타 부가세
			obj.value = parseDecimal(obj.value);
			fm.etc_amt.value	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));			
		}else if(obj==fm.etc_amt){ 	//기타 합계
			obj.value = parseDecimal(obj.value);
			fm.etc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.etc_amt.value))));
			fm.etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_amt.value)) - toInt(parseDigit(fm.etc_s_amt.value)));			
		//배차료---------------------------------------------------------------------------------
		}else if(obj==fm.cons1_s_amt){ 	//배차료 공급가
			obj.value = parseDecimal(obj.value);
			fm.cons1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) * 0.1 );
			fm.cons1_amt.value	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));			
		}else if(obj==fm.cons1_v_amt){ 	//배차료 부가세
			obj.value = parseDecimal(obj.value);
			fm.cons1_amt.value	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));			
		}else if(obj==fm.cons1_amt){ 	//배차료 합계
			obj.value = parseDecimal(obj.value);
			fm.cons1_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.cons1_amt.value))));
			fm.cons1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons1_amt.value)) - toInt(parseDigit(fm.cons1_s_amt.value)));			
		//반차료---------------------------------------------------------------------------------
		}else if(obj==fm.cons2_s_amt){ 	//배차료 공급가
			obj.value = parseDecimal(obj.value);
			fm.cons2_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) * 0.1 );
			fm.cons2_amt.value	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));			
		}else if(obj==fm.cons2_v_amt){ 	//배차료 부가세
			obj.value = parseDecimal(obj.value);
			fm.cons2_amt.value	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));			
		}else if(obj==fm.cons2_amt){ 	//배차료 합계
			obj.value = parseDecimal(obj.value);
			fm.cons2_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.cons2_amt.value))));
			fm.cons2_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons2_amt.value)) - toInt(parseDigit(fm.cons2_s_amt.value)));			
		}
		
		set_sum_amt();	
		
	}	
	
	//합계계산
	function set_sum_amt(){
		var fm = document.form1;
		
		var amt_per = 0;
		
		//할인율
		var amt_per = 0;									
		if(toInt(fm.con_mon.value)==1){
			amt_per = (4/100)*toInt(fm.con_day.value)/30;
		}		
		if(toInt(fm.con_mon.value)==2){
			amt_per = (4/100) + ((2/100)*toInt(fm.con_day.value)/30);
		}							
		if(toInt(fm.con_mon.value) > 2){
			amt_per = 6/100;
		}					
		amt_per = parseDecimal(amt_per*1000)/1000;				
		fm.amt_per.value = amt_per;	
		
		fm.inv_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 ) ;
		fm.inv_amt.value 	= parseDecimal( toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)) );
				
		
		//월대여료 합계
		fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.navi_s_amt.value))+ toInt(parseDigit(fm.etc_s_amt.value)));
		fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) - toInt(parseDigit(fm.dc_v_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value))+ toInt(parseDigit(fm.etc_v_amt.value)));
		fm.fee_amt.value   = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)) );
		//대여료 총액
		fm.t_fee_s_amt.value = parseDecimal((toInt(parseDigit(fm.fee_s_amt.value))*toInt(fm.con_mon.value)) + (toInt(parseDigit(fm.fee_s_amt.value))/30*toInt(fm.con_day.value)));
		fm.t_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) * 0.1 );
		fm.t_fee_amt.value   = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) + toInt(parseDigit(fm.t_fee_v_amt.value)) );
		//합계
		fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) + toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons2_s_amt.value)));
		fm.rent_tot_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_v_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));
		fm.rent_tot_amt.value   = parseDecimal(toInt(parseDigit(fm.rent_tot_s_amt.value)) + toInt(parseDigit(fm.rent_tot_v_amt.value)) );
		
		f_paid_way_display();
	}		
	
	//대여료 DC율 계산
	function dc_fee_amt(){
		var fm = document.form1;
		
		var inv_amt	= toInt(parseDigit(fm.inv_s_amt.value))+toInt(parseDigit(fm.inv_v_amt.value));		//정상대여료
		var dc_amt	= toInt(parseDigit(fm.dc_s_amt.value))+toInt(parseDigit(fm.dc_v_amt.value));		//DC금액
		var dc_ra;
						
		if(inv_amt > 0 && dc_amt > 0){			
			dc_ra = replaceFloatRound(dc_amt / inv_amt );
			fm.dc_ra.value = dc_ra;
		}
	}		
		
	//내비게이션유무
	function obj_display(st, value){
		var fm = document.form1;	
		
		if(st == 'navi'){
			if(value == 'Y'){
				fm.navi_s_amt.value 	= '25,000';
				fm.navi_v_amt.value 	= '2,500';
				fm.navi_amt.value	= '27,500';		
			}else if(value == 'N'){
				fm.navi_s_amt.value 	= '0';
				fm.navi_v_amt.value 	= '0';
				fm.navi_amt.value	= '0';		
			}	
		}else if(st == 'cons1'){
			if(value == 'Y'){
				fm.cons1_s_amt.value 	= '20,000';
				fm.cons1_v_amt.value 	= '2,000';
				fm.cons1_amt.value	= '22,000';		
			}else if(value == 'N'){
				fm.cons1_s_amt.value 	= '0';
				fm.cons1_v_amt.value 	= '0';
				fm.cons1_amt.value	= '0';		
			}
		}else if(st == 'cons2'){
			if(value == 'Y'){
				fm.cons2_s_amt.value 	= '20,000';
				fm.cons2_v_amt.value 	= '2,000';
				fm.cons2_amt.value	= '22,000';		
			}else if(value == 'N'){
				fm.cons2_s_amt.value 	= '0';
				fm.cons2_v_amt.value 	= '0';
				fm.cons2_amt.value	= '0';		
			}				
		}
		set_sum_amt();			
	}	
	
	//최초결제방식 셋팅
	function f_paid_way_display(){
		var fm = document.form1;
		
		//1개월치
		if(fm.f_paid_way.value == '1'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) + toInt(parseDigit(fm.cons1_amt.value)) );
		//총액	
		}else if(fm.f_paid_way.value == '2'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_amt.value)) + toInt(parseDigit(fm.cons1_amt.value)) );
		}
		
		//반차료 최초포함여부
		if(fm.f_paid_way2.value == '1'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.f_rent_tot_amt.value)) + toInt(parseDigit(fm.cons2_amt.value)));
		}					
	}				

	function search_cms(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		
	}

	function search_card_cms(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_card_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		
	}
	
	//등록
	function save(){
		var fm = document.form1;
				
		if(fm.driving_age.value == '')				{ alert('보험사항-운전자연령을 입력하십시오.'); 			fm.driving_age.focus(); 	return; }
		
		<%if(client.getClient_st().equals("1") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	 
			if(fm.com_emp_yn.value == '')					{ alert('보험사항-임직원운전한정특약 가입여부를 입력하십시오.');		fm.com_emp_yn.focus(); 		return; }
		<%}else if(AddUtil.parseInt(client.getClient_st()) >2 && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>
			//개인사업자 업무전용차량 제한없음
			if(fm.com_emp_yn.value == '')					{ alert('보험사항-임직원운전한정특약 가입여부를 입력하십시오.');		fm.com_emp_yn.focus(); 		return; }
		<%}else{%>
			if(fm.com_emp_yn.value == 'Y')				{ alert('보험사항-임직원운전한정특약 가입대상이 아닌데 가입으로 되어 있습니다. 확인하십시오.');	fm.com_emp_yn.focus(); 	return; }
		<%}%>
				
		if(fm.gcp_kd.value == '')				{ alert('보험사항-대물배상 가입금액을 입력하십시오.'); 			fm.gcp_kd.focus(); 		return; }
		if(fm.bacdt_kd.value == '')				{ alert('보험사항-자기신체사고 가입금액을 입력하십시오.'); 		fm.bacdt_kd.focus(); 		return; }
		if(fm.canoisr_yn.value == '')				{ alert('보험사항-무보험차상해 가입여부를 입력하십시오.'); 		fm.canoisr_yn.focus(); 		return; }
		if(fm.cacdt_yn.value == '')				{ alert('보험사항-자기차량손해 가입여부를 입력하십시오.'); 		fm.cacdt_yn.focus(); 		return; }
		if(fm.eme_yn.value == '')				{ alert('보험사항-긴급출동 가입여부를 입력하십시오.'); 			fm.eme_yn.focus(); 		return; }
		

		<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
		if(fm.driving_age.value=='1' && fm.age_scp.value!='1')	{ alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';}
		if(fm.driving_age.value=='3' && fm.age_scp.value!='4')	{ alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}
		if(fm.driving_age.value=='0' && fm.age_scp.value!='2')	{ alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}
		if(fm.driving_age.value=='2' && fm.age_scp.value!='3')	{ alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}
		if(fm.driving_age.value=='5' && fm.age_scp.value!='5')	{ alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}			
		if(fm.driving_age.value=='6' && fm.age_scp.value!='6')	{ alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}			
		if(fm.driving_age.value=='7' && fm.age_scp.value!='7')	{ alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}			
		if(fm.driving_age.value=='8' && fm.age_scp.value!='8')	{ alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}												
			
		if(fm.gcp_kd.value=='3' && fm.vins_gcp_kd.value!='6')	{ alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk2.value =	'보험 대물보상이 현재 가입과 약정이 틀립니다.';		}
		if(fm.gcp_kd.value=='2' && fm.vins_gcp_kd.value!='3')	{ alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk2.value =	'보험 대물보상이 현재 가입과 약정이 틀립니다.';		}
		if(fm.gcp_kd.value=='1' && fm.vins_gcp_kd.value!='4')	{ alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk2.value =	'보험 대물보상이 현재 가입과 약정이 틀립니다.';		}
		if(fm.gcp_kd.value=='4' && fm.vins_gcp_kd.value!='7')	{ alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk2.value =	'보험 대물보상이 현재 가입과 약정이 틀립니다.';		}			
			
		if(fm.bacdt_kd.value=='2' && fm.vins_bacdt_kd.value!='6'){ alert('보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk3.value =	'보험 자기신체사고가 현재 가입과 약정이 틀립니다.';	}
		if(fm.bacdt_kd.value=='1' && fm.vins_bacdt_kd.value!='5'){ alert('보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk3.value =	'보험 자기신체사고가 현재 가입과 약정이 틀립니다.';	}
		if(fm.bacdt_kd.value=='9' && fm.vins_bacdt_kd.value!='9'){ alert('보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk3.value =	'보험 자기신체사고가 현재 가입과 약정이 틀립니다.';	}
		
		if(fm.con_f_nm.value=='1' && fm.insur_per.value!='1')	{ alert('보험 피보험자가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk4.value =	'보험 피보험자가 현재 가입과 약정이 틀립니다.';		}
		if(fm.con_f_nm.value=='2' && fm.insur_per.value!='2')	{ alert('보험 피보험자가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk4.value =	'보험 피보험자가 현재 가입과 약정이 틀립니다.';		}
		<%}%>		
		
		var car_ja 	= toInt(parseDigit(fm.car_ja.value));
		
		if(car_ja == 0)						{ alert('보험사항-자차면책금을 입력하십시오.'); 		fm.car_ja.focus(); 		return; }
		<%if(car.getCar_origin().equals("2")){//수입차%>
		if(fm.car_ja.value != fm.imm_amt.value){
			if(fm.ja_reason.value == '')			{ alert('보험사항-자차면책금 변경사유를 입력하십시오.'); 	fm.ja_reason.focus(); 		return; }
			if(fm.rea_appr_id.value == '')			{ alert('보험사항-자차면책금 변경 결재자를 입력하십시오.'); 	fm.rea_appr_id.focus(); 	return; }
		}
		<%}else{%>
		if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'){
			if(fm.ja_reason.value == '')			{ alert('보험사항-자차면책금 변경사유를 입력하십시오.'); 	fm.ja_reason.focus(); 		return; }
			if(fm.rea_appr_id.value == '')			{ alert('보험사항-자차면책금 변경 결재자를 입력하십시오.'); 	fm.rea_appr_id.focus(); 	return; }
		}			
		<%}%>			
			
		
		if(fm.con_mon.value == '')				{ alert('대여요금-이용기간을 입력하십시오.'); 			fm.con_mon.focus(); 		return; }
		
				
		var fee_amt 	= toInt(parseDigit(fm.fee_amt.value));
		var inv_amt 	= toInt(parseDigit(fm.inv_amt.value));		
		var agree_dist 	= toInt(parseDigit(fm.agree_dist.value));
		var over_run_amt= toInt(parseDigit(fm.over_run_amt.value));		
		
		if(inv_amt == 0)	{ alert('대여요금-정상대여료를 입력하십시오.'); 	fm.inv_amt.focus(); 		return; }
		if(fee_amt == 0)	{ alert('대여요금-월대여료를 확인하십시오.'); 		fm.inv_amt.focus(); 		return; }
		if(agree_dist == 0)	{ alert('대여요금-약정운행거리를 입력하십시오.'); 	fm.agree_dist.focus(); 		return; }
		if(over_run_amt == 0)	{ alert('대여요금-초과운행부담금을 입력하십시오.'); 	fm.over_run_amt.focus(); 	return; }
		
		if(fm.f_paid_way.value == '')				{ alert('대여요금-최초결제방식을 입력하십시오.');		fm.f_paid_way.focus(); 		return; }
		if(toInt(parseDigit(fm.f_rent_tot_amt.value)) == '0')	{ alert('대여요금-최초결제금액을 입력하십시오.'); 		fm.f_rent_tot_amt.focus(); 	return; }						
		
		if(toInt(fm.cls_r_per.value) < 1)			{ alert('대여요금-중도해지위약율 확인하십시오.'); 		fm.cls_r_per.focus(); 		return; }	
			
		if(fm.fee_pay_tm.value == '')				{ alert('대여요금-납입횟수를 입력하십시오.'); 			fm.fee_pay_tm.focus(); 		return; }
		if(fm.fee_sh.value == '')				{ alert('대여요금-수금구분를 입력하십시오.'); 			fm.fee_sh.focus(); 		return; }
		if(fm.fee_pay_st.value == '')				{ alert('대여요금-납부방법을 입력하십시오.'); 			fm.fee_pay_st.focus(); 		return; }		
		if(fm.def_st.value == '')				{ alert('대여요금-거치여부를 입력하십시오.'); 			fm.def_st.focus(); 		return; }
		if(fm.def_st.value == 'Y'){
			if(fm.def_remark.value == '')			{ alert('대여요금-거치사유를 입력하십시오.');			fm.def_remark.focus();		return; }
			if(fm.def_sac_id.value == '')			{ alert('대여요금-거치 결재자를 입력하십시오.');		fm.def_sac_id.focus();		return; }
		}
			
		if(fm.fee_pay_st.value == '1'){
			if(fm.cms_bank_cd.value == '')	{ alert('대여요금-CMS 거래은행을 입력하십시오.'); 		fm.cms_bank_cd.focus(); 		return; }
			if(fm.cms_acc_no.value == '')		{ alert('대여요금-CMS 계좌번호를 입력하십시오.'); 		fm.cms_acc_no.focus(); 		return; }
			if(fm.cms_acc_no.value != '')		{ 
				fm.cms_acc_no.value = replaceString(" ","",fm.cms_acc_no.value);
				if ( !checkInputNumber("CMS 계좌번호", fm.cms_acc_no.value) ) {		
					fm.cms_acc_no.focus(); 		return; 
				}
				//휴대폰,연락처 동일여부 확인
				if(replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getM_tel()%>") || replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getO_tel()%>")){
					alert("계좌번호가 휴대폰 혹은 연락처와 같습니다. 평생계좌번호는 자동이체가 안됩니다.");
					fm.cms_acc_no.focus(); 		return; 
				}
			}
			if(fm.cms_dep_nm.value == '')			{ alert('대여요금-CMS 예금주를 입력하십시오.'); 		fm.cms_dep_nm.focus(); 		return; }				
			if(fm.cms_dep_ssn.value == '')			{ alert('대여요금-CMS 예금주 생년월일/사업자번호를 입력하십시오.'); fm.cms_dep_ssn.focus(); 	return; }
			
			//예금주 생년월일은 6자리			
			if(replaceString("-","",fm.cms_dep_ssn.value).length == 8){
				alert('대여요금-CMS 예금주 생년월일은 6자리입니다.'); return;
			}
			
			if(fm.c_cms_acc_no.value != '')		{ 
				fm.c_cms_acc_no.value = replaceString(" ","",fm.c_cms_acc_no.value);
				if ( !checkInputNumber("카드번호", fm.c_cms_acc_no.value) ) {		
					fm.c_cms_acc_no.focus(); 		return; 
				}
			}
		}
			
		if(fm.tax_type[1].checked == true && '<%=site.getEnp_no()%>' == ''){ fm.tax_type[0].checked = true; }
		
		if(fm.rec_st.value == '')				{ alert('세금계산서-청구서수령방법을 입력하십시오.');		fm.rec_st.focus(); 		return; }
		if(fm.rec_st.value == '1'){
			if(fm.ele_tax_st.value == '')			{ alert('세금계산서-전자세금계산서 시스템을 입력하십시오.'); 	fm.ele_tax_st.focus();		return; }
			if(fm.ele_tax_st.value == '2'){
				if(fm.tax_extra.value == '')		{ alert('세금계산서-전자세금계산서 별도시스템 이름을 입력하십시오.'); fm.tax_extra.focus(); 	return; }
			}
			<%	if(print_car_st_yn.equals("Y")){%>
			if(fm.print_car_st.value == '')			{ alert('세금계산서-계산서별도발행구분을 입력하십시오.'); 	fm.print_car_st.focus();	return; }
			<%	}%>
		}
		
		//할인율
		var amt_per = 0;									
		if(toInt(fm.con_mon.value)==1){
			amt_per = (4/100)*toInt(fm.con_day.value)/30;
		}		
		if(toInt(fm.con_mon.value)==2){
			amt_per = (4/100) + ((2/100)*toInt(fm.con_day.value)/30);
		}							
		if(toInt(fm.con_mon.value) > 2){
			amt_per = 6/100;
		}					
		amt_per = parseDecimal(amt_per*1000)/1000;				
		fm.amt_per.value = amt_per;		
			
		
		if(confirm('4단계를 등록하시겠습니까?')){	
			fm.action='lc_reg_step4_rm_a.jsp';		
			//fm.target='i_no';
			fm.submit();
		}							
	}
	
	function set_loc(loc_num, st){
		var fm = document.form1;	
		var loc_nm = '';
		
		if(loc_num == '1')		loc_nm = '영남주차장';
		else if(loc_num == '2')		loc_nm = '대전지점 주차장';
		else if(loc_num == '3')		loc_nm = '부산지점 주차장';
		else if(loc_num == '4')		loc_nm = '광주지점 주차장';
		else if(loc_num == '5')		loc_nm = '대구지점 주차장';
						
		if(loc_nm != ''){
			if(st == 'deli')		fm.deli_loc.value = loc_nm;
			else if(st == 'ret')		fm.ret_loc.value = loc_nm;
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
<body leftmargin="15">
<form action='/acar/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">  
  <input type='hidden' name="mode"			value="lc_rent">
  <input type='hidden' name="rent_dt"			value="">  
  <input type='hidden' name="rent_st"			value="1">  
  <input type='hidden' name="a_b"			value="">
  <input type='hidden' name="fee_opt_amt"		value="">
  <input type='hidden' name="cust_sh_car_amt"	value="">
</form>
<form action='lc_reg_step4_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="old_rent_mng_id" 		value="<%=old_rent_mng_id%>">
  <input type='hidden' name="old_rent_l_cd" 		value="<%=old_rent_l_cd%>">
  <input type='hidden' name="opt"			value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"			value="<%=cm_bean.getCar_b()%><%=cm_bean2.getCar_b()%>">
  <input type='hidden' name="s_st" 			value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="rent_way" 			value="<%=fee.getRent_way()%>">  
  <input type='hidden' name="dpm" 			value="<%=cm_bean.getDpm()%>">
  <input type='hidden' name="car_end_dt"		value="<%=cr_bean.getCar_end_dt()%>">
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
  <input type='hidden' name='est_id' 			value='<%=est_id%>'>
  <input type='hidden' name="amt_per"			value="">  
                   
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
					<select name="bus_st">
                        <option value="">선택</option>
                        <option value="1" <%if(base.getBus_st().equals("1")){%>selected<%}%>>인터넷</option>
                        <option value="8" <%if(base.getBus_st().equals("8")){%>selected<%}%>>모바일</option>
                        <option value="5" <%if(base.getBus_st().equals("5")){%>selected<%}%>>전화상담</option>                        
                        <option value="2" <%if(base.getBus_st().equals("2")){%>selected<%}%>>영업사원</option>
                        <option value="7" <%if(base.getBus_st().equals("7")){%>selected<%}%>>에이젼트</option>                        
                        <option value="6" <%if(base.getBus_st().equals("6")){%>selected<%}%>>기존업체</option>
                        <option value="3" <%if(base.getBus_st().equals("3")){%>selected<%}%>>업체소개</option>
                        <option value="4" <%if(base.getBus_st().equals("4")){%>selected<%}%>>catalog</option>
                        
                      </select>					
					</td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}else if(car_gu.equals("3")){%>월렌트<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<b><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("4")){%>월렌트<%}else if(car_st.equals("5")){%>업무대여<%}%></b></td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<b><%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></b></td>
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
    		    <%if(!cr_bean.getCar_no().equals("")){%>
    		    <tr>
        		    <td width='13%' class='title'> 차량번호 </td>
        		    <td width="20%">&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a></td>
                	<td class='title' width="10%">관리번호</td>
        		    <td>&nbsp;<%=cr_bean.getCar_doc_no()%>&nbsp;(<%String car_ext = cr_bean.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%>)</td>
        		    <td width="10%" class='title'><%if(cr_bean.getCar_use().equals("1")){%>차령만료일<%}else{%>최초등록일<%}%></td>
        		    <td>&nbsp;<%if(cr_bean.getCar_use().equals("1")){%><font color=red><b><%=cr_bean.getCar_end_dt()%></b></font><%}else{%><%=cr_bean.getInit_reg_dt()%><%}%></td>
    		    </tr>			  
    		    <tr>
        		    <td class='title'> 검사유효기간 </td>
        		    <td>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%></b></td>
                	<td class='title'>점검유효기간</td>
        		    <td colspan='3'>&nbsp;<b><%=cr_bean.getTest_st_dt()%>~<%=cr_bean.getTest_end_dt()%></b></td>
    		    </tr>			  
    		    <%}%>	  
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
                    <td>&nbsp;<%=cr_bean.getDpm()%>cc</td>
                </tr>
                <tr>
                    <td class='title'>기본사양</td>
                    <td colspan="5" align=center>
                        <table width=98% cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style='height:5'></td>
                            </tr>
                            <tr>
                                <td>
        			  <%if(!cm_bean2.getCar_name().equals("")){%><span title='<%=cm_bean2.getCar_b()%>'><font color='#999999'><%=cm_bean2.getCar_name()%>외&nbsp;</font></span><%}%>
        			  <%=cm_bean.getCar_b()%></td>
        			        <tr>
                                <td style='height:3'></td>
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
                      <input type='text' name='color' size='50' class='whitetext' value='<%=car.getColo()%>'>
                      &nbsp;&nbsp;&nbsp;
					  (내장색상(시트): <input type='text' name="in_col" size='20' class='whitetext' value='<%=car.getIn_col()%>'> )                        
                      &nbsp;&nbsp;&nbsp;
					  (가니쉬: <input type='text' name="garnish_col" size='20' class='whitetext' value='<%=car.getGarnish_col()%>'> )                        
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
        <td class=h></td>
    </tr>    
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량가격</span></td>
    </tr>
    <tr id=tr_car0 style="display:''"> 
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
                        <input type='text' name='sh_day_bas_dt' value='<%= AddUtil.ChangeDate2(base.getRent_dt()) %>'size='11' class='default'  onBlur='javascript:this.value=ChangeDate(this.value);'>
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
                <%if(!cr_bean.getDist_cng().equals("")){%>
                <tr>
                  <td class='title'>계기판교체</td>
                  <td colspan="5">&nbsp;
                    <font color=green><%=cr_bean.getDist_cng()%></font></td>
                </tr>                
                <%}%>                
            </table>
	    </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험사항</span></td>
	</tr>
	<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
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
                    <td width="20%">&nbsp;
                        <select name='conr_nm' disabled>
                          <option value="1" <%if(ins.getConr_nm().equals("아마존카")){%> selected <%}%>>아마존카</option>
                          <option value="2" <%if(!ins.getConr_nm().equals("아마존카")){%> selected <%}%>>고객</option>
                        </select></td>				
                    <td width="10%" class=title >피보험자</td>
                    <td colspan='3'>&nbsp;
                        <select name='con_f_nm' disabled>
                          <option value="1" <%if(ins.getCon_f_nm().equals("아마존카")){%> selected <%}%>>아마존카</option>
                          <option value="2" <%if(!ins.getCon_f_nm().equals("아마존카")){%> selected <%}%>>고객</option>
                        </select></td>		
                </tr>                  
                <tr>
                    <td width="13%" class=title >운전자연령</td>
                    <td width="20%">&nbsp;
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
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30세이상</option>				
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35세이상</option>				
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
                                <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000만원&nbsp;&nbsp;&nbsp;</option>
                                <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000만원</option>
                                <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500만원</option>
                                <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000만원</option>				
                              </select></td>
                    <td width="10%" class=title >자기신체사고</td>
                    <td>&nbsp;
                        <select name='vins_bacdt_kd' disabled>
                                <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3억원</option>
                                <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1억5천만원</option>
                                <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1억원</option>
                                <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000만원</option>
                                <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000만원</option>
                                <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500만원</option>
                                <option value="9" <%if(ins.getVins_bacdt_kd().equals("9")){%>selected<%}%>>미가입</option>
                              </select></td>
                </tr>
            </table>
	    </td>		
	</tr>
    <tr>
	    <td style='height:5'></td>
	</tr>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;2. 계약서에 약정된 보험조건</td>
	</tr>		
	<%}%>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="13%"  class=title>보험계약자</td>
                    <td width="20%">&nbsp;
                        <select name='insurant'>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>아마존카</option>
                      </select></td>
                    <td width="10%"  class=title>피보험자</td>
                    <td colspan='3'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per' onChange='javascript:display_ip()'>
                          <option value="">선택</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>아마존카</option>
                          <!--  <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>고객</option>-->
                      </select></td>
                </tr>                        
              <tr> 
                <td width="13%" class=title>운전자범위</td>
                <td width="20%" class=''>&nbsp;
    				<select name='driving_ext'>
                      <option value="">선택</option>
                      <option value="1" <%if(base.getDriving_ext().equals("1") || base.getDriving_ext().equals("")){%> selected <%}%>>모든사람</option>
                      <option value="2" <%if(base.getDriving_ext().equals("2")){%> selected <%}%>>가족한정</option>
                      <option value="3" <%if(base.getDriving_ext().equals("3")){%> selected <%}%>>기타</option>
                  </select>			
    			</td>
                <td width="10%" class=title >운전자연령</td>
                <td>&nbsp;
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
                <td class=title >임직원운전한정특약</td>
                <td class=''>&nbsp;<%if(client.getClient_st().equals("1") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){ cont_etc.setCom_emp_yn("Y"); }%>
                  <select name='com_emp_yn'>
                    <option value="">선택</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>가입</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>미가입</option>
                  </select></td>                    
              </tr>
              <tr>
                <td  class=title>대인배상</td>
                <td>&nbsp; 무한(대인배상Ⅰ,Ⅱ)</td>
                <td class=title>대물배상</td>
                <td class=''>&nbsp;
                    <select name='gcp_kd'>
                      <option value="">선택</option>
                      <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                      <option value="2" <% if(base.getGcp_kd().equals("2")||base.getGcp_kd().equals("")) out.print("selected"); %>>1억원</option>
                      <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2억원</option>
					  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3억원</option>
                      <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5억원</option>					  
                  </select></td>
                <td width="10%" class=title >자기신체사고</td>
                <td class=''>&nbsp;
                    <select name='bacdt_kd'>
                      <option value="">선택</option>
                      <!--<option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5천만원</option>-->
                      <option value="2" <% if(base.getBacdt_kd().equals("2")||base.getBacdt_kd().equals("")) out.print("selected"); %>>1억원</option>
                      <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>미가입</option>
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
                <td>&nbsp;<%if(base.getCar_ja()==0) base.setCar_ja(300000);%>
    			<input type='text' size='12' maxlength='10' name='car_ja' class='num' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			원</td>
                <td class=title>변경사유</td>
                <td class=''>&nbsp;
                  <input type='text' size='18' name='ja_reason' class='text' value='<%=cont_etc.getJa_reason()%>'></td>
                <td class=title >결재자</td>
                <td class=''>&nbsp;
                    <select name='rea_appr_id'>
                      <option value="">선택</option>
                    <%if(user_size > 0){
    					for(int i = 0 ; i < user_size ; i++){
    						Hashtable user = (Hashtable)users.elementAt(i); %>
                    <option value='<%=user.get("USER_ID")%>' <%if(cont_etc.getRea_appr_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                    <%	}
    				}		%>
                  </select> 
                    (기본 <input type='text' size='6' maxlength='10' name='imm_amt' class='whitenum' value='<%if(car.getCar_origin().equals("2")){%>500,000<%}else{%>300,000<%}%>' readonly>원) </td>
              </tr>
              <tr>
                <td  class=title>휴차보상료</td>
                <td colspan='5'>&nbsp;
                    <select name="my_accid_yn">
                        <option value="Y" selected>고객부담</option>
                        <option value="N">면제</option>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차/반차 예정사항</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td width="13%"  class=title>배차시간</td>
                <td width="37%">&nbsp;<input type='text' size='11' name='deli_plan_dt' maxlength='10' class='default' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='deli_plan_h' class='default' value='00'>
                    시
                    <input type='text' size='2' name='deli_plan_m' class='default' value='00'>
                    분
                    </td>
                <td width="13%" class=title>반차시간</td>
                <td width="37%" class=''>&nbsp;<input type='text' size='11' name='ret_plan_dt' maxlength='10' class='default' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='ret_plan_h' class='default' value='00'>
                    시
                    <input type='text' size='2' name='ret_plan_m' class='default' value='00'>
                    분
                    </td>
              </tr>
              <tr> 
                <td width="13%"  class=title>배차장소</td>
                <td width="37%">&nbsp;<input type='text' size='30' name='deli_loc' class='default' value=''  onBlur="javscript:set_loc(this.value, 'deli');">
                      </td>
                <td width="13%" class=title>반차장소</td>
                <td width="37%" class=''>&nbsp;<input type='text' size='30' name='ret_loc' class='default' value=''   onBlur="javscript:set_loc(this.value, 'ret');">
                      </td>
              </tr>          
            </table>
        </td>
    </tr>	    
    <tr>
        <td>* 배/반차 장소 번호 자동입력 : 1 - 영남주차장, 2 - 대전지점 주차장, 3 - 부산지점 주차장, 4 - 광주지점 주차장, 5 - 대구지점 주차장 </td>
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
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td width="13%" align="center" class=title>이용기간</td>
                <td  >&nbsp; <!--width="26%"-->
                    <%if(AddUtil.parseInt(base.getRent_dt()) > 20140228){%>		
                    1개월
        	    <input type='hidden' name="con_day"	value="0">      		 
        	    <input type='hidden' name="con_mon"	value="1">      		         			 
                    <%}else{%>                    
                    <input type='text' name="con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 개월        	            	    
        	    <input type='text' name="con_day" value='<%=fee_etc.getCon_day()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 일
        	    <%}%>		 
    	    	    <input type='hidden' name='rent_start_dt' value='<%=fee.getRent_start_dt()%>'>
		    <input type='hidden' name='rent_end_dt' value='<%=fee.getRent_end_dt()%>'>					 
					 (대여개시일 등은 신차대여개시 처리할때 입력합니다. 최초 계약은 1개월입니다.)		 
		 </td>		
		 <!--		
                <td width="13%" align="center" class=title>대여개시일</td>
                <td width="15%">&nbsp;
                  <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);'></td>
                <td width="13%" align="center" class=title>대여만료일</td>
                <td width="20%">&nbsp;
                  <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fee.getRent_end_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'></td>				
                  -->
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
                <td class='title' width='20%'>정상조건</td>
              </tr>
             <tr>               
                <td colspan='2' class='title'>보증금</td>
                <td align='center'>-</td>
                <td align='center'>-</td>
                <td align='center'><input type='text' size='11' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">차가의
                    <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fee.getGur_p_per()%>' readonly>
    				  % </td>
                <td align='center'><input type='hidden' name='gur_per' value='0'><input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>'>
		    <%if(base.getRent_st().equals("3")){%>
			대차 보증금 승계여부 :
			<select name='grt_suc_yn'>
                            <option value="">선택</option>
                            <option value="0">승계</option>
                            <option value="1">별도</option>
                        </select>	
		    <%}else{%>		
		    -
		    <input type='hidden' name='grt_suc_yn' value=''>
		    <%}%>
		</td>
              </tr>       
              <%
              		if(fee.getInv_s_amt() == 0){
              			fee.setInv_s_amt(e_bean.getFee_s_amt());
              			fee.setInv_v_amt(e_bean.getFee_v_amt());
              		}
              %>       
              <tr>
                <td width="3%" rowspan="5" class='title'>월<br>
                  대<br>여<br>료</td>
                <td width="10%" class='title'>정상대여료</td>
                 <td align="center"><input type='text' size='11' name='inv_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='inv_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='inv_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getInv_s_amt()+fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>

                <td align="center">-</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>D/C</td>
                <td align="center">-<input type='text' size='10' name='dc_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">-<input type='text' size='10' name='dc_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-<input type='text' size='10' name='dc_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt()+fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">DC율:
                  <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value='<%=fee.getDc_ra()%>'>
                </font>%</span></td>
                <td align='center'>-</td>
              </tr>              
              <tr>
                <td class='title'>내비게이션</td>
                <td align="center"><input type='text' size='11' name='navi_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='navi_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='navi_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt()+fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">
                  <input type='radio' name="navi_yn" value='N' onclick="javascript:obj_display('navi','N')" <%if(fee_rm.getNavi_yn().equals("0")||fee_rm.getNavi_yn().equals("")){%> checked <%}%>>
                  없음
                  <input type='radio' name="navi_yn" value='Y' onclick="javascript:obj_display('navi','Y')" <%if(fee_rm.getNavi_yn().equals("1")){%> checked <%}%>>
    	 	  있음
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>기타</td>
                <td align="center"><input type='text' size='11' name='etc_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='etc_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='etc_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt()+fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">
                    <input type='text' size='40' name='etc_cont' class='text' value='<%=fee_rm.getEtc_cont()%>'>
    				  </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>합계</td>
                <td align="center"><input type='text' size='11' name='fee_s_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='fee_v_amt' maxlength='10' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='fee_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">-</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>대여료총액</td>
                <td align="center"><input type='text' size='11' name='t_fee_s_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='t_fee_v_amt' maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='t_fee_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' name="v_con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        			 개월
        	    <!--<input type='text' name="v_con_day" value='<%=fee_etc.getCon_day()%>' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        	    일-->
        	    <input type='hidden' name="v_con_day"	value="0">   
        			 </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>배차료</td>
                <td align="center"><input type='text' size='11' name='cons1_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='cons1_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='cons1_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">
                  <input type='radio' name="cons1_yn" value='N' onclick="javascript:obj_display('cons1','N')" <%if(fee_rm.getCons1_yn().equals("0")||fee_rm.getCons1_yn().equals("")){%> checked <%}%>>
                  없음
                  <input type='radio' name="cons1_yn" value='Y' onclick="javascript:obj_display('cons1','Y')" <%if(fee_rm.getCons1_yn().equals("1")){%> checked <%}%>>
    	 	  있음 
    	 	</td>
                <td align='center'>
    			  
                </td>
              </tr>
              <tr>
                <td colspan="2" class='title'>반차료</td>
                <td align="center"><input type='text' size='11' name='cons2_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='cons2_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='cons2_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">
                  <input type='radio' name="cons2_yn" value='N' onclick="javascript:obj_display('cons2','N')" <%if(fee_rm.getCons2_yn().equals("0")||fee_rm.getCons2_yn().equals("0")){%> checked <%}%>>
                  없음
                  <input type='radio' name="cons2_yn" value='Y' onclick="javascript:obj_display('cons2','Y')" <%if(fee_rm.getCons2_yn().equals("1")){%> checked <%}%>>
    	 	  있음 
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>합계</td>
                <td align="center"><input type='text' size='11' name='rent_tot_s_amt' maxlength='11' class='fixnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='rent_tot_v_amt' maxlength='10' class='fixnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='rent_tot_amt' maxlength='11' class='fixnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"> </td>
                <td align='center'>-</td>
              </tr>              
              <tr id=tr_emp_bus style="display:''">
                <td rowspan="<%if(rent_st.equals("3")){%>4<%}else{%>3<%}%>" class='title'>기<br>타</td>                             
                <td class='title'><span class="title1">최초결제금액</span></td>
                <td align='center'><input type="text" name="f_rent_tot_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>" size="11" class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원		  
                </td>                
                <td colspan='3'>&nbsp;&nbsp;&nbsp;
                     * 최초결제방식 : <select name="f_paid_way" onchange="javascript:f_paid_way_display();">
                        <option value="">==선택==</option>			  
                        <option value="1">1개월치</option>
                        <option value="2">총액</option>
                      </select>
                      &nbsp; 반차료
                      <select name="f_paid_way2" onchange="javascript:f_paid_way_display();">
                        <option value="">==선택==</option>
                        <option value="1">포함</option>
                        <option value="2">미포함</option>
                      </select>          
                      &nbsp;&nbsp;&nbsp;
                      * 예약금 : <input type="text" name="f_con_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_con_amt())%>" size="11" class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원	
                  
                </td>                
                <td align='center'>-</td>
              </tr>  
              <tr>
                <td class='title'><span class="title1">약정운행거리</span></td>
                <td colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='text' name='agree_dist' size='8' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>'>
                  km이하/1개월,
                  초과시 1km당 (<input type='text' name='over_run_amt' size='3' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원)의 추가요금이 부과됩니다.
                </td>
                <td align='center'>-</td>
              </tr>                                   
              <tr>
                <td class='title'>중도해지위약율</td>
                <td colspan="3" align="center">실이용기간이 1개월 이상일 경우</td>                
                <td align="center">잔여기간 대여료의
                    <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=fee.getCls_r_per()%>'>
    				  %</td>
                <td align='center'><font color="#FF0000">
    				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='<%=fee.getCls_per()%>'>%					
					</font></span></td>
              </tr>
              <%if(rent_st.equals("3")){%>
				<%	//대차원계약정보
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}
					%>			  
              <tr>
                    <td class='title' style="font-size : 8pt;">대차원계약</td>
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
					  승계보증금 : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum' >원
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(약정보증금 차액 <input type='text' name='grt_suc_cha_amt' size='10' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>' class='whitenum'>)</font>
					  <%}else{ %>
					  <input type='hidden' name='grt_suc_cha_amt' 	value=''>
					  <%} %>
        			</td>
              </tr>	
              <%}%>
              
              <tr>
                <td colspan="2" class='title'>비고<br>(일반적인 내용)</td>
                <td colspan="5">&nbsp;
                  <textarea rows='5' cols='90' class=default name='fee_cdt'><%=fee.getFee_cdt()%></textarea></td>
              </tr>			
              <tr>
                <td colspan="3" class='title'>비고<br>(해지 관련)</td>
                <td colspan="5">&nbsp;
                  <textarea rows='5' cols='90' class=default name='cls_etc'><%=cont_etc.getCls_etc()%></textarea></td>
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
    <tr id=tr_fee2 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="3%" rowspan="6" class='title'>대<br>여<br>료<br>납<br>입<br>방<br>법</td>
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
                    <option value="1" <%if(fee.getFee_sh().equals("1")||fee.getFee_sh().equals("")){%> selected <%}%>>선불</option>
                  </select></td>
                <td width="10%" class='title'>납부방법</td>
                <td>&nbsp;
                  <select name='fee_pay_st'>
                    <option value=''>선택</option>
                    <option value='1' <%if(fee.getFee_pay_st().equals("1") || !cms.getCms_bank().equals("")){%> selected <%}%>>자동이체</option>
                    <option value='2' <%if(fee.getFee_pay_st().equals("2")){%> selected <%}%>>무통장입금</option>                    
                    <option value='4' <%if(fee.getFee_pay_st().equals("4")){%> selected <%}%>>수금</option>
                    <option value='5' <%if(fee.getFee_pay_st().equals("5")){%> selected <%}%>>기타</option>
                    <option value='6' <%if(fee.getFee_pay_st().equals("6") || fee.getFee_pay_st().equals("")){%> selected <%}%>>카드</option>
                  </select></td>
    			  <td class='title'>CMS미실행</td>
    			  <td>&nbsp;
    			    사유 : <input type='text' name='cms_not_cau' size='25' value='월렌트<%//=fee_etc.getCms_not_cau()%>' class='text'>
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
                  <select name='def_sac_id'>
                    <option value="">선택</option>
                    <%if(user_size > 0){
    					for(int i = 0 ; i < user_size ; i++){
    						Hashtable user = (Hashtable)users.elementAt(i); %>
                    <option value='<%=user.get("USER_ID")%>' <%if(fee.getDef_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                    <%	}
    				}		%>
                  </select></td>
              </tr>
              <tr>
                <td class='title'>자동이체
                    <br><span class="b"><a href="javascript:search_cms('0')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                </td>
                <td colspan="5"><table width="100%" border="0" cellpadding="0">
    			  <tr>
    			    <td>&nbsp;
					거래은행 : 
					    <input type='hidden' name="cms_bank" value="<%=cms.getCms_bank()%>"> 
    				  <select name='cms_bank_cd'>
                    <option value=''>선택</option>
                    <%	if(bank_size > 0){
    											for(int i = 0 ; i < bank_size ; i++){
    												CodeBean bank = banks[i];	
    												//신규인경우 미사용은행 제외
   													if(bank.getUse_yn().equals("N"))	 continue;
    												if(cms.getCms_bank().equals("")){%>
                    <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}else{%>
                    <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}%>
                    <%		}
    										}
    								%>
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
					  			if(client.getClient_st().equals("2")) 	cms.setCms_dep_ssn(client.getSsn1());
								else                                   	cms.setCms_dep_ssn(client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3());
					  		}
					  %>
    			      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
					  
    				  &nbsp;&nbsp;예금주 주소 : 
					  <input type='text' name="cms_zip" value='<%if(cms.getCms_dep_post().equals("")){%><%=client.getO_zip()%><%}else{%><%=cms.getCms_dep_post()%><%}%>' size="7" class='text'>
                      <input type='text' name="cms_addr" value='<%if(cms.getCms_dep_addr().equals("")){%><%=client.getO_addr()%><%}else{%><%=cms.getCms_dep_addr()%><%}%>' size="50" class='text'>			

					  <br><br>
    			      &nbsp;
					  연락전화 :
    			      <input type='text' name='cms_tel' size='15' class='text' value="<%if(cms.getCms_tel().equals("")){%><%= client.getO_tel()%><%}else{%><%=cms.getCms_tel()%><%}%>">

    			      &nbsp;&nbsp;휴대폰 :
    			      <input type='text' name='cms_m_tel' size='15' class='text' value="<%if(cms.getCms_m_tel().equals("")){%><%= client.getM_tel()%><%}else{%><%=cms.getCms_m_tel()%><%}%>">
    					  
    			      &nbsp;&nbsp;이메일 :
    			      <input type='text' name='cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%if(cms.getCms_email().equals("")){%><%= client.getCon_agnt_email()%><%}else{%><%=cms.getCms_email()%><%}%>">
    			      
    			      <br><br>
    			      &nbsp;
					  최초인출일자 :
    			      <input type='text' name='cms_start_dt' size='11' class='text' value="<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
    					  
					  
    			       </td>
    			    </tr>
    			    
    			</table>
    			</td>
              </tr>
              <tr>
                <td class='title'>신용카드 자동출금
                    <br><span class="b"><a href="javascript:search_card_cms('1')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                </td>
                <td colspan="5"><table width="100%" border="0" cellpadding="0">
    			  <tr>
    			    <td>&nbsp;
					카드사 : 
					    <input type='text' name='c_cms_bank' value='<%=card_cms.getCms_bank()%>' size='20' class='text'>					    
    				&nbsp;&nbsp;
    				카드번호 : 
    			      <input type='text' name='c_cms_acc_no' value='<%=card_cms.getCms_acc_no()%>' size='20' class='text'>    			      
					  <br><br>

    			      &nbsp;
    			      카드주 본인명 :
    			      <input type='text' name='c_cms_dep_nm' value='<%if(card_cms.getCms_dep_nm().equals("")){%><%=client.getClient_nm()%><%}else{%><%=card_cms.getCms_dep_nm()%><%}%>' size='20' class='text'>

    			      &nbsp;&nbsp;
					  카드주 생년월일 :
					  <%	if(card_cms.getCms_dep_ssn().equals("")){
					  			if(client.getClient_st().equals("2")) 	card_cms.setCms_dep_ssn(client.getSsn1());
					  		}
					  %>
    			      <input type='text' name='c_cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(card_cms.getCms_dep_ssn())%>">

    			      &nbsp;&nbsp;
    				사업자번호(사업자인경우) : 
    			      <input type='text' name='c_enp_no' value='<%if(card_cms.getC_enp_no().equals("") && !client.getClient_st().equals("2")){%><%=client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3()%><%}else{%><%=card_cms.getC_enp_no()%><%}%>' size='12' class='text'>
					  
					  <br><br>
    			      &nbsp;
					  신청인 성명 :
					      <input type='text' name='c_firm_nm' value='<%if(card_cms.getC_firm_nm().equals("")){%><%=client.getFirm_nm()%><%}else{%><%=card_cms.getC_firm_nm()%><%}%>' size='19' class='text'>

    			      &nbsp;&nbsp;
    				  주소 : 
					  <input type='text' name="c_cms_zip" value='<%if(card_cms.getCms_dep_post().equals("")){%><%=client.getO_zip()%><%}else{%><%=card_cms.getCms_dep_post()%><%}%>' size="7" class='text'>
                      <input type='text' name="c_cms_addr" value='<%if(card_cms.getCms_dep_addr().equals("")){%><%=client.getO_addr()%><%}else{%><%=card_cms.getCms_dep_addr()%><%}%>' size="60" class='text'>

					  <br><br>
    			      &nbsp;
					  연락전화 :
    			      <input type='text' name='c_cms_tel' size='15' class='text' value="<%if(card_cms.getCms_tel().equals("")){%><%= client.getO_tel()%><%}else{%><%=card_cms.getCms_tel()%><%}%>">

    			      &nbsp;&nbsp;휴대폰 :
    			      <input type='text' name='c_cms_m_tel' size='15' class='text' value="<%if(card_cms.getCms_m_tel().equals("")){%><%= client.getM_tel()%><%}else{%><%=card_cms.getCms_m_tel()%><%}%>">
    					  
    			      &nbsp;&nbsp;이메일 :
    			      <input type='text' name='c_cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%if(card_cms.getCms_email().equals("")){%><%= client.getCon_agnt_email()%><%}else{%><%=card_cms.getCms_email()%><%}%>">
    			      
    			      <br><br>
    			      &nbsp;
					  최초인출일자 :
    			      <input type='text' name='c_cms_start_dt' size='11' class='text' value="<%=AddUtil.ChangeDate2(card_cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
    					  
					  
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
    <tr id=tr_tax style="display:''"> 
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
                    <option value='1' <%if(client.getPrint_car_st().equals("1") || client.getPrint_car_st().equals("")) out.println("selected");%>>승합/화물/9인승/경차</option>							
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
    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>   
    <tr>
	<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
    </tr>
    <%}%>
    <tr>
        <td>&nbsp;</td>
    </tr>
	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
    <tr>
        <td align='right'>
	        <a href="lc_reg_step2_rm.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>" target='d_content'><img src=/acar/images/center/button_2step.gif align=absmiddle border=0></a>&nbsp;</a>	        
	        <a href="lc_b_u_rm.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>" target='d_content'><img src=/acar/images/center/button_mig.gif align=absmiddle border=0></a>&nbsp;  
	        <a href="lc_c_frame.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>
	    </td>
    </tr>
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<iframe src="about:blank" name="i_no2" width="100%" height="100" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	
	fm.sh_ja.value = replaceFloatRound(toInt(parseDigit(fm.sh_amt.value)) / toInt(parseDigit(fm.sh_car_amt.value)) );
	
	fm.con_mon.value = '1';
	fm.con_day.value = '0';
	
	fm.v_con_mon.value = '1';
	fm.v_con_day.value = '0';

	fm.inv_s_amt.value 	= '<%=AddUtil.parseDecimal(String.valueOf(hp.get("RM1")))%>';
	
	set_fee_amt(fm.inv_s_amt);
	
	//fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
	//fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));	
			 		
	if(fm.cls_per.value == ''){
		fm.cls_per.value = '10';
	}
	if(fm.cls_r_per.value == '0.0'){
		fm.cls_r_per.value = '10';
	}	
	
//-->
</script>
</body>
</html>
