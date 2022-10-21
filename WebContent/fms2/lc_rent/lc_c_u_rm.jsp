<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.fee.*, card.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
		
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//월렌트정보
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, rent_st);
	
	ContFeeBean feeb = new ContFeeBean();
		
	if(!rent_st.equals("1")){
		feeb = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(AddUtil.parseInt(rent_st)-1));	
	}
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));	
	
	//차량기본정보
	ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	//차량기본정보
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//월렌트정보
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
		
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//신용카드 자동출금
	ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
	
	
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	

	
	//문서품의
	DocSettleBean commi_doc = d_db.getDocSettleCommi("1", rent_l_cd);
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	

	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); //영업담당자 리스트
	int user_size = users.size();
	
	
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	

	
	if(rent_st.equals("")) rent_st = "1";
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
		
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

	//대차보증금승계조회
	function search_grt_suc()
	{
		var fm = document.form1;	
		window.open("/fms2/car_pur/s_grt_suc.jsp?from_page=/fms2/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>", "SERV_GRT_OFF", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}		
	//대차보증금승계취소
	function cancel_grt_suc()
	{
		var fm = document.form1;
		fm.grt_suc_l_cd.value = '';
		fm.grt_suc_m_id.value = '';
		fm.grt_suc_c_no.value = '';
		fm.grt_suc_o_amt.value = '';
		fm.grt_suc_r_amt.value = '';
	}	
		
	
	//길이 체크
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
	}
	
		



	
	//대여기간 셋팅
	function set_cont_date(){
		var fm = document.form1;
					
		fm.rent_start_dt.value = ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value);
		
		<%if(cng_item.equals("fee")){%>	
		
		fm.v_con_mon.value = fm.con_mon.value;
		fm.v_con_day.value = fm.con_day.value;					
		
		set_sum_amt();	
		
		<%}%>
			

			
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;

		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
			
		fm.action='get_fee_nodisplay.jsp';
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
		
		
		var car_price 	= toInt(parseDigit(fm.sh_amt.value));
		
		//보증금---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//보증금 공급가
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value = fm.grt_s_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value = replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			}

		//정상대여료---------------------------------------------------------------------------------
		<%if(rent_st.equals("1")){%> 
		}else if(obj==fm.inv_s_amt){ 	//정상대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			//dc_fee_amt();			
		}else if(obj==fm.inv_v_amt){ 	//정상대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			//dc_fee_amt();
		}else if(obj==fm.inv_amt){ 	//정상대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
			//dc_fee_amt();	
		<%}else{%>			
		
		}else if(obj==fm.fee_s_amt){ 	//정상대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1 );
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));									
			//dc_fee_amt();			
		}else if(obj==fm.fee_v_amt){ 	//정상대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			//dc_fee_amt();
		}else if(obj==fm.fee_amt){ 	//정상대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.fee_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));			
			//dc_fee_amt();	
		<%}%>
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
		
		
		<%if(rent_st.equals("1")){%> 
		//월대여료 합계
		fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.navi_s_amt.value))+ toInt(parseDigit(fm.etc_s_amt.value)));
		fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) - toInt(parseDigit(fm.dc_v_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value))+ toInt(parseDigit(fm.etc_v_amt.value)));
		fm.fee_amt.value   = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)) );
		<%}%>
		//대여료 총액
		if(fm.v_con_mon.value == '1' && fm.v_con_day.value=='0'){
			fm.t_fee_s_amt.value = fm.fee_s_amt.value;
			fm.t_fee_v_amt.value = fm.fee_v_amt.value;
			fm.t_fee_amt.value   = fm.fee_amt.value;			
		}else{
			fm.t_fee_s_amt.value = parseDecimal_hun_th_rnd((toInt(parseDigit(fm.fee_s_amt.value))*toInt(fm.con_mon.value)) + (toInt(parseDigit(fm.fee_s_amt.value))/30*toInt(fm.con_day.value)));
			fm.t_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) * 0.1 );
			fm.t_fee_amt.value   = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) + toInt(parseDigit(fm.t_fee_v_amt.value)) );			
		}
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
	


	//수정
	function update(){
		var fm = document.form1;
		
		var cng_item = fm.cng_item.value;
		
		<% if(cng_item.equals("fee")){%>		
		

		<%}else if(cng_item.equals("deli")){%>		
		

		<%}else if(cng_item.equals("rent_start")){%>		
		
				
				if(toInt(fm.car_ret_chk.value) > 0)		{ alert('대여개시-예약시스템에 반차 미처리분이 있습니다. 먼저 반차처리후에 대여개시 하십시오.'); return; }
				if(fm.con_mon.value == '')			{ alert('대여개시-이용기간을 입력하십시오.'); 				fm.con_mon.focus(); 		return; }
				if(fm.rent_start_dt.value == '')		{ alert('대여개시-대여개시일을 입력하십시오.'); 			fm.rent_start_dt.focus(); 	return; }
				if(fm.rent_end_dt.value == '')			{ alert('대여개시-대여만료일을 입력하십시오.'); 			fm.rent_end_dt.focus(); 	return; }				
				
				//[입력값 체크]1.대여개시일 현재보다 한달이상 차이가 나면 안된다.
				var est_day = getRentTime('m', fm.rent_start_dt.value, '<%=AddUtil.getDate()%>');				
				if( est_day > 1 || est_day < -1){ 
					alert('입력하신 대여개시일이 현재날짜와 한달이상 차이납니다.\n\n확인하십시오.'); 				fm.rent_start_dt.focus(); 	return; 
				}
				
				
				
					if(fm.fee_pay_tm.value == '')		{ alert('대여개시-납입횟수를 입력하십시오.'); 				fm.fee_pay_tm.focus(); 		return; }
					if(fm.fee_est_day.value == '')		{ alert('대여개시-납일일자를 입력하십시오.'); 				fm.fee_est_day.focus(); 	return; }
					if(fm.fee_pay_start_dt.value == '')	{ alert('대여개시-납입기간을 입력하십시오.'); 				fm.fee_pay_start_dt.focus();	return; }
					if(fm.fee_pay_end_dt.value == '')	{ alert('대여개시-납입기간을 입력하십시오.'); 				fm.fee_pay_end_dt.focus(); 	return; }
					
					if(fm.fee_fst_dt.value == '')			{ alert('대여개시-1회차납입일을 입력하십시오.'); 			fm.fee_fst_dt.focus(); 		return; }
				
					//[입력값 체크]2.첫회차납입일이 대여개시일보다 클수는 없다.
					est_day = getRentTime('d', fm.rent_start_dt.value, fm.fee_fst_dt.value);
					if( est_day < -2){ 
						alert('입력하신 첫회차납입일이 대여개시일보다 작습니다. \n\n확인하십시오.');					fm.fee_fst_dt.focus(); 		return;
					}				
					if( est_day > 10){ 
						alert('입력하신 첫회차납입일이 대여개시일보다 10일 이상 차이가 납니다. \n\n확인하십시오.');					fm.fee_fst_dt.focus(); 		return;
					}							
					
					if(fm.cms_type[0].checked == false && fm.cms_type[1].checked == false){		
						alert('2회차 청구방식을 선택하십시오.'); return;
					}
					
										
		<%}else if(cng_item.equals("pay_way")){%>					
			
			<%if(f_fee_rm.getCms_type().equals("cms")){%>
				
			if(fm.cms_acc_no.value == '')		{ alert('자동이체-계좌번호를 입력하십시오.'); 				fm.cms_acc_no.focus(); 		return; }
			if(fm.cms_acc_no.value != '')			{ 
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
			if(fm.cms_bank_cd.value == '')	{ alert('자동이체-은행을 입력하십시오.'); 				fm.cms_bank_cd.focus(); 		return; }
			if(fm.cms_dep_nm.value == '')		{ alert('자동이체-예금주를 입력하십시오.'); 				fm.cms_dep_nm.focus(); 		return; }
					
			<%}%>
			
		<%}else if(cng_item.equals("pay_way3")){%>
				
			if(fm.c_cms_acc_no.value != '')		{ 
				fm.c_cms_acc_no.value = replaceString(" ","",fm.c_cms_acc_no.value);
				if ( !checkInputNumber("카드번호", fm.c_cms_acc_no.value) ) {		
					fm.c_cms_acc_no.focus(); 		return; 
				}
			}
			
		<%}%>

				
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_c_u_rm_a.jsp';		
			fm.target='i_no';
			//fm.target = '_blank';
			
			//if(fm.user_id.value == '000029') fm.target='_blank';
			
			fm.submit();
		}							
		
		
		
	}

			
	
	//대여일수 구하기
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;		
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
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
<form action='lc_b_u_rm_a.jsp' name="form1" method='post'>
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
  <input type='hidden' name='cng_item'	 		value='<%=cng_item%>'>     
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="car_st"			value="<%=base.getCar_st()%>">  
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name='client_id' 		value="<%=base.getClient_id()%>">
  <input type='hidden' name="client_st" 		value="<%=client.getClient_st()%>">      
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="idx"			value="">  
  <input type='hidden' name="scan_cnt"			value="">    
  <input type='hidden' name="chk_cnt"			value="">    
  <input type='hidden' name="est_from"			value="lc_c_u">      
  <input type='hidden' name="fee_rent_st"		value="">        
  <input type='hidden' name="car_no" 			value="<%=cr_bean.getCar_no()%>">      
  <input type='hidden' name="c_firm_nm" 		value="<%=client.getFirm_nm()%>">      
  <input type='hidden' name="c_client_nm" 		value="<%=client.getClient_nm()%>">      
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약서수정</span></span></td>
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
                    <td class=title width=10%>상호</td>
                    <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>차명<%}else{%>차량번호<%}%></td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>
        			</td>
                </tr>
    		</table>
	    </td>
	</tr>  	  
	<tr>
	    <td align="right">&nbsp;</td>
	<tr>
	<%if(cng_item.equals("deli")){%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차/반차 예정사항</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <%
    	String plan_dt = "";
	String plan_h = "";
	String plan_m = "";
    %>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td width="13%"  class=title>누적주행거리</td>
                <td colspan='3'>&nbsp;<input type='text' name='sh_km' size='3' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(f_fee_etc.getSh_km())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>km</td>
              </tr>                   
              <tr> 
                <td width="13%"  class=title>배차시간</td>
    <%
	if(f_fee_rm.getDeli_plan_dt().length() == 12){
		plan_dt = f_fee_rm.getDeli_plan_dt().substring(0,8);
		plan_h 	= f_fee_rm.getDeli_plan_dt().substring(8,10);
		plan_m	= f_fee_rm.getDeli_plan_dt().substring(10,12);
	}
    %>                
                <td width="37%">&nbsp;<input type='text' size='11' name='deli_plan_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(plan_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='deli_plan_h' class='default' value='<%=plan_h%>'>
                    시
                    <input type='text' size='2' name='deli_plan_m' class='default' value='<%=plan_m%>'>
                    분
                    </td>
                <td width="13%" class=title>반차시간</td>
    <%
    	plan_dt = "";
    	plan_h = "";
    	plan_m = "";
	if(f_fee_rm.getRet_plan_dt().length() == 12){
		plan_dt = f_fee_rm.getRet_plan_dt().substring(0,8);
		plan_h 	= f_fee_rm.getRet_plan_dt().substring(8,10);
		plan_m	= f_fee_rm.getRet_plan_dt().substring(10,12);
	}
    %>                
                
                <td width="37%" class=''>&nbsp;<input type='text' size='11' name='ret_plan_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(plan_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='ret_plan_h' class='default' value='<%=plan_h%>'>
                    시
                    <input type='text' size='2' name='ret_plan_m' class='default' value='<%=plan_m%>'>
                    분
                    </td>
              </tr>
              <tr> 
                <td width="13%"  class=title>배차장소</td>
                <td width="37%">&nbsp;<input type='text' size='30' name='deli_loc' class='default' value='<%=f_fee_rm.getDeli_loc()%>' onBlur="javscript:set_loc(this.value, 'deli');">
                      </td>
                <td width="13%" class=title>반차장소</td>
                <td width="37%">&nbsp;<input type='text' size='30' name='ret_loc' class='default' value='<%=f_fee_rm.getRet_loc()%>' onBlur="javscript:set_loc(this.value, 'ret');">
                      </td>
              </tr>          
            </table>
        </td>
    </tr>	
    <tr>
        <td>* 배/반차 장소 번호 자동입력 : 1 - 영남주차장, 2 - 대전지점 주차장, 3 - 부산지점 주차장, 4 - 광주지점 주차장, 5 - 대구지점 주차장 </td>
    </tr>          	
	
	
	<%}%>

	<%if(cng_item.equals("fee")){%>	
  <input type='hidden' name='rent_st' 			value='<%=rent_st%>'> 	
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">  
  <input type='hidden' name='sh_amt' 			value='<%=fee_etcs.getSh_amt()%>'> 
  <input type='hidden' name='amt_per' 			value='<%=fee_rm.getAmt_per()%>'> 

	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
    		    <%if(!fees.getRent_st().equals("1")){%>
                <tr>
                    <td width="13%" align="center" class=title>계약일자</td>
                    <td width="20%">&nbsp;
					  <%if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
        			  <input type="text" name="rent_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(fees.getRent_dt())%>
					  <input type='hidden' name='rent_dt' 	value='<%=fees.getRent_dt()%>'>
					  <%}%>							
        			</td>
                    <td width="10%" align="center" class=title>계약담당자</td>
                    <td>&nbsp;
        			  <select name='ext_agnt'>
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(fees.getExt_agnt().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>
                    <td width="10%" align="center" class=title>영업대리인</td>
                    <td>&nbsp;
        			  <select name='bus_agnt_id'>
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(fee_etcs.getBus_agnt_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>			  
                </tr>
    		<%}else{%>
                <tr>
                    <td width="13%" align="center" class=title>차량인도일</td>
                    <td colspan='5'>&nbsp;
        			  <input type="text" name="car_deli_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                    </td>			  
                </tr>			
			<%}%>
                <tr>
                    <td width="13%" align="center" class=title>이용기간</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="con_mon" value='<%=fees.getCon_mon()%>' <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id) || nm_db.getWorkAuthUser("스케줄변경담당자",ck_acar_id)){%><%}else{%>readonly<%}%> size="4" maxlength="2" class='text' onChange='javascript:set_cont_date()'>
            			 개월
            		<input type='text' name="con_day" value='<%=fee_etcs.getCon_day()%>' <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id) || nm_db.getWorkAuthUser("스케줄변경담당자",ck_acar_id)){%><%}else{%>readonly<%}%> size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 일		 
            	    </td>
                    <td width="10%" align="center" class=title>대여개시일</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id) || nm_db.getWorkAuthUser("스케줄변경담당자",ck_acar_id)){%><%}else{%>readonly<%}%> size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date();'></td>
                    <td width="10%" align="center" class=title>대여만료일</td>
                    <td>&nbsp;
                    <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id) || nm_db.getWorkAuthUser("스케줄변경담당자",ck_acar_id)){%><%}else{%>readonly<%}%> size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
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
                    <td colspan='2' class='title'>보증금</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % </td>
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
        		<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'>
        	    </td>
                </tr>   
              <%if(fees.getRent_st().equals("1")){%>          
              <tr>
                <td width="3%" rowspan="5" class='title'>월<br>
                  대<br>여<br>료</td>
                <td width="10%" class='title'>정상대여료</td>
                 <td align="center"><input type='text' size='11' name='inv_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='inv_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='inv_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>

                <td align="center">-</td>
                <td align='center'>-</td>
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
    		<td align='center'>-</td>		  
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
                <td align='center'>-</td>
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
                <td align='center'>-</td>
                <td align="center">
                    <input type='text' size='40' name='etc_cont' class='text' value='<%=fee_rm.getEtc_cont()%>'>
    				  </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>합계</td>
                <td align="center"><input type='text' size='11' name='fee_s_amt' maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='fee_v_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='fee_amt' maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">-</td>
                <td align='center'>-</td>
              </tr>
              <%}else{%>
              <tr>
                <td colspan="2" class='title'>월대여료</td>
                <td align="center"><input type='text' size='11' name='fee_s_amt' maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='fee_v_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='fee_amt' maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">-</td>
                <td align='center'>-</td>
              </tr>              
              <%}%>
              <tr>
                <td colspan="2" class='title'>대여료총액</td>
                <td align="center"><input type='text' size='11' name='t_fee_s_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='t_fee_v_amt' maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='t_fee_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center"><input type='text' name="v_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        			 개월
        	    <input type='text' name="v_con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        			 일</td>
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
                <td align='center'>-</td>
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
                <td align='center'>-</td>
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
                <td align="center"><input type='text' size='11' name='rent_tot_s_amt' maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='rent_tot_v_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='rent_tot_amt' maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt()+fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center"> </td>
                <td align='center'>-</td>
              </tr>              
              <tr id=tr_emp_bus style="display:''">
                <td rowspan="<%if(rent_st.equals("3")){%>4<%}else{%>3<%}%>" class='title'>기<br>타</td>                             
                <td class='title'><span class="title1">최초결제금액</span></td>
                <td align='center'><input type="text" name="f_rent_tot_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>" size="11" class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원		  
                </td>                
                <td colspan='4'>&nbsp;&nbsp;&nbsp;
                     * 최초결제방식 : <select name="f_paid_way" onchange="javascript:f_paid_way_display();">
                        <option value="">==선택==</option>			  
                        <option value="1" <%if(fee_rm.getF_paid_way().equals("1")){%>selected<%}%>>1개월치</option>
                        <option value="2" <%if(fee_rm.getF_paid_way().equals("2")){%>selected<%}%>>총액</option>
                      </select>
                      &nbsp; 반차료
                      <select name="f_paid_way2" onchange="javascript:f_paid_way_display();">
                        <option value="">==선택==</option>
                        <option value="1" <%if(fee_rm.getF_paid_way2().equals("1")){%>selected<%}%>>포함</option>
                        <option value="2" <%if(fee_rm.getF_paid_way2().equals("2")){%>selected<%}%>>미포함</option>
                      </select>          
                      &nbsp;&nbsp;&nbsp;
                      * 예약금 : <input type="text" name="f_con_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_con_amt())%>" size="11" class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원	
                  
                </td>                
                <td align='center'>-</td>
              </tr>  
              <tr>
                <td class='title'><span class="title1">약정운행거리</span></td>
                <td colspan="5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='text' name='agree_dist' size='8' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>'>
                  km이하/1개월,
                  초과시 1km당 (<input type='text' name='over_run_amt' size='3' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원)의 추가요금이 부과됩니다.
                </td>
                <td align='center'>-</td>
              </tr>                                   
              <tr>
                <td class='title'>중도해지위약율</td>
                <td colspan="4" align="center">실이용기간이 1개월 이상일 경우</td>                
                <td align="center">잔여기간 대여료의
                    <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=fee.getCls_r_per()%>'>
    				  %</td>
                <td align='center'><font color="#FF0000">
    				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='<%=fee.getCls_per()%>'>%					
					</font></span></td>
              </tr>
    		    <%if(rent_st.equals("1")){
					//대차원계약정보
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}%>
                <tr>
                    <td colspan="2" class='title'>대차원계약</td>
                    <td colspan="6">&nbsp;
					  <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;계약번호 : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;차종코드별변수 차명 : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;					  
					  <span class="b"><a href="javascript:cancel_grt_suc()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[대차보증금승계]</b>
					  &nbsp;기존보증금 : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>원
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  승계보증금 : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum' >원
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  				<font color=red>(약정보증금 차액 <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  			<%} %>	
        			</td>
                </tr>		
    		    <%}%>  	
    		        		    																						  		    
                <tr>
                    <td colspan="2" class='title'>비고</td>
                    <td colspan="6">&nbsp;<textarea rows='5' cols='90' name='fee_cdt'><%=fees.getFee_cdt()%></textarea></td>
                </tr>
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
                      <input type='text' name='fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
    			        <input type='text' name='fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>		  		  	
                <tr>
                    <td width="13%" class='title'>1회차납입일</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='fee_fst_dt' value='<%=AddUtil.ChangeDate2(fees.getFee_fst_dt())%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				</td>
                    <td width="10%" class='title'>1회차납입액</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' name='fee_fst_amt' value='<%=AddUtil.parseDecimal(fees.getFee_fst_amt())%>' maxlength='10' size='10' class='num'>원
                      </td>
                </tr>		  		  		  		  		  	  
    		</table>		
	    </td>
    </tr>
			
<script language="JavaScript">
<!--		
	var fm = document.form1;
//-->
</script>	
	<%} %>	

	<%if(cng_item.equals("rent_start")){
			
			int car_ret_chk = 0;
			
			//재리스일때 예약시스템 반차종료 확인
			if(base.getCar_gu().equals("0")){
				car_ret_chk = rs_db.getCarRetChk(base.getCar_mng_id());
			}
			
			%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여개시</span> (<font color=red>*</font>필수입력)</td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<input type='hidden' name="rent_way"			value="<%=fees.getRent_way()%>">
	<input type='hidden' name="car_ret_chk"			value="<%=car_ret_chk%>">
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="13%" align="center" class=title>이용기간</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='fix' onBlur='javascript:set_cont_date()'>개월
                        <input type='text' name="con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='fix' onChange='javascript:set_cont_date()'>일	
        	    </td>
                    <td width="10%" align="center" class=title>대여개시일<font color=red>*</font></td>
                    <td width="20%">&nbsp;
                      <input type="text" name="rent_start_dt" value="" size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date();'></td>
                    <td width="10%" align="center" class=title>대여만료일<font color=red>*</font></td>
                    <td>&nbsp;
                    <input type="text" name="rent_end_dt" value="" size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>
				<%if(fee.getFee_s_amt()>0 && !fee.getFee_chk().equals("1") ){%>
                <tr>
                    <td width="13%" class='title'>납입횟수<font color=red>*</font></td>
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='fee_pay_tm' value='<%=fee.getFee_pay_tm()%>' maxlength='2' class='text' >
        				회 </td>
                    <td width="10%" class='title'>납입일자<font color=red>*</font></td>
                    <td colspan="3">&nbsp;매월
                      <select name='fee_est_day'>
                        <option value="">선택</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                        <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                        <% } %>
                        <option value='99' <%if(fee.getFee_est_day().equals("99")){%> selected <%}%>> 말일 </option>
						<option value='98' <%if(fee.getFee_est_day().equals("98")){%> selected <%}%>> 대여개시일 </option>
                      </select></td>
                </tr>		  		  		  		  
                <tr>
                    <td width="10%" class='title'>납입기간<font color=red>*</font></td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
    			    <input type='text' name='fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
					&nbsp;&nbsp;<font color='#CCCCCC'>(납입횟수, 1회차납입일을 입력하면 자동처리됩니다.)</font>
					</td>
                </tr>	
				<%}else{%>	  	
				  <input type='hidden' name='fee_pay_tm' 			value='<%=fee.getFee_pay_tm()%>'>  
				  <input type='hidden' name='fee_est_day' 			value='<%=fee.getFee_est_day()%>'>  
				  <input type='hidden' name='fee_fst_dt' 			value='<%=fee.getFee_fst_dt()%>'>  
				  <input type='hidden' name='fee_fst_amt' 			value='<%=fee.getFee_fst_amt()%>'>  
				  <input type='hidden' name='fee_pay_start_dt' 		value='<%=fee.getFee_pay_start_dt()%>'>  
				  <input type='hidden' name='fee_pay_end_dt' 		value='<%=fee.getFee_pay_end_dt()%>'>  
				<%}%>
                <tr>
                    <td width="10%" class='title'>차량인도일<font color=red>*</font></td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='car_deli_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
					&nbsp;&nbsp;<font color='#CCCCCC'>(실제 고객에게 인도되는 날짜를 입력하십시오.)</font>
					</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>1회차납입일<font color=red>*</font></td>
                    <td width="20%">&nbsp;
                        <input type='text' name='fee_fst_dt' value='<%=fee.getFee_fst_dt()%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value); set_cont_date();'>
        		    </td>
                    <td width="10%" class='title'>1회차납입액</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' name='fee_fst_amt' value='<%=AddUtil.parseDecimal(fee.getFee_fst_amt())%>' maxlength='10' size='10' class='num'>원
                    </td>
                </tr>		
                <tr>
                    <td width="10%" class='title'>2회차청구방식<font color=red>*</font></td>
                    <td colspan="5">&nbsp;
                      <input type='radio' name="cms_type" value='card' checked>
     				  신용카드
      			  <input type='radio' name="cms_type" value='cms'>
      			  CMS 
					</td>
                </tr>
                
                <%	//기존대여스케줄 대여횟수 최대값
			int max_fee_tm = a_db.getMax_fee_tm(rent_mng_id, rent_l_cd);
			if(max_fee_tm==0){%>
                <tr>
                    <td width="10%" class='title'>스케줄생성여부<font color=red>*</font></td>
                    <td colspan="5">&nbsp;
                      <input type="checkbox" name="scd_reg_yn" value="Y" checked>
					</td>
                </tr>                
                <%	}%>
                <tr>
                    <td width="10%" class='title'>안내문자여부<font color=red>*</font></td>
                    <td colspan="5">&nbsp;
                      <input type="checkbox" name="sms_reg_yn" value="Y" checked onclick="return false;" >
					</td>
                </tr>                
                
            </table>
	    </td>
	</tr>	
    <tr>
	    <!--<td>* 고객 계약담당자에게 영업담당자 배정에 대한 문자를 보냅니다. ([월렌트] 00000(차량번호) 대여개시일은 000, 차량 담당자는 000, 연락처는 000 입니다. (주)아마존카)</td>-->
	     <td>* 고객 계약담당자에게 아마존카 월렌트 사용시 유의사항 안내 문자를 보냅니다.(필수)</td>
	    <td></td>
	</tr>	

	
	<%} %>	
	
	
	
	<%if(cng_item.equals("pay_way")){%>		
	<tr id=tr_fee3 >
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동이체</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>						
    <tr id=tr_fee2> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		  <%if(cms.getApp_dt().equals("") || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("CMS관리",user_id) || nm_db.getWorkAuthUser("출금담당",user_id)){%>
              <tr>
                <td class='title'>자동이체
                  <br><span class="b"><a href="javascript:search_cms('')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                </td>
                <td colspan="5"><table width="100%" border="0" cellpadding="0">
    			  <tr>
    			    <td>&nbsp;계좌번호 : 
    			      <input type='text' name='cms_acc_no' value='<%=cms.getCms_acc_no()%>' size='30' class='text'>
    			      (
    			      <input type='hidden' name="cms_bank" 			value="<%=cms.getCms_bank()%>">
    			      <select name='cms_bank_cd'>
                    <option value=''>선택</option>
                    <%	if(bank_size > 0){
    											for(int i = 0 ; i < bank_size ; i++){
    												CodeBean bank = banks[i];	
    												if(cms.getCms_bank().equals("")){
    													//신규인경우 미사용은행 제외
   														if(bank.getUse_yn().equals("N"))	 continue;
    								%>
                    <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}else{%>
                    <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}%>
                    <%		}
    										}
    								%>
                  </select>    
    			       ) </td>
    			    </tr>
    			  <tr>
    			    <td>&nbsp;예 금 주 :&nbsp;
    			      <input type='text' name='cms_dep_nm' value='<%=cms.getCms_dep_nm()%>' size='30' class='text'>
    				  &nbsp;&nbsp;
    				  / 결제일자 : 매월
    			      <select name='cms_day'>
        			      <option value="">선택</option>
						    <%for(int i=1; i<=31; i++){%>
                        	<option value="<%=i%>"  <%if(cms.getCms_day().equals(String.valueOf(i)))%>selected<%%>><%=i%></option>
							<%}%>						
                      	  </select>
    			일
    				  </td>
    			    </tr>
        			  <tr>
        			    <td>&nbsp;예금주 생년월일/사업자번호 :
    			      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
					  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
						<script>
							function openDaumPostcode() {
								new daum.Postcode({
									oncomplete: function(data) {
										document.getElementById('t_zip').value = data.zonecode;
										document.getElementById('t_addr').value = data.address;
										
									}
								}).open();
							}
						</script>
    			      &nbsp;&nbsp;예금주 주소 : 
					  
					  <input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=cms.getCms_dep_post()%>">
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="50" value="<%=cms.getCms_dep_addr()%>">
        				  </td>
        			    </tr>			
        			  <tr>
        			    <td>&nbsp;연락전화 :
    			      <input type='text' name='cms_tel' size='15' class='text' value="<%=cms.getCms_tel()%>">

    			      &nbsp;&nbsp;휴대폰 :
    			      <input type='text' name='cms_m_tel' size='15' class='text' value="<%=cms.getCms_m_tel()%>">
    					  
    			      &nbsp;&nbsp;이메일 :
    			      <input type='text' name='cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%=cms.getCms_email()%>">	

        				  </td>
        			    </tr>	
        			    <tr>
        			    <td>&nbsp;최초인출일자 :
    			      <input type='text' name='cms_start_dt' size='11' class='text' value="<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>

    			     

        				  </td>
        			    </tr>	    			    
    			</table>
    			</td>
              </tr>

              
    		 <%}%>
            </table>
        </td>
    </tr>			
	<%} %>	
	
	
	<%if(cng_item.equals("pay_way3")){%>		
	<tr id=tr_fee3 >
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용카드 자동출금</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>						
    <tr id=tr_fee2> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		  <%if(card_cms.getApp_dt().equals("") || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("CMS관리",user_id) || nm_db.getWorkAuthUser("신용카드자동출금",user_id)){%>
              <tr>
                <td class='title'>신용카드 자동출금
                  <br><span class="b"><a href="javascript:search_card_cms('')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                </td>
                <td colspan="5"><table width="100%" border="0" cellpadding="0">
    			  <tr>
    			    <td>&nbsp;카드번호 : 
    			      <input type='text' name='c_cms_acc_no' value='<%=card_cms.getCms_acc_no()%>' size='30' class='text'>
    			      (
    			      카드사 : <input type='text' name='c_cms_bank' value='<%=card_cms.getCms_bank()%>' size='20' class='text'>
    			       ) 
               &nbsp;&nbsp;결제일자 : 매월
    			      <select name='c_cms_day'>
        			      <option value="">선택</option>
						    <%for(int i=1; i<=31; i++){%>
                        	<option value="<%=i%>"  <%if(card_cms.getCms_day().equals(String.valueOf(i)))%>selected<%%>><%=i%></option>
							<%}%>						
                      	  </select>
    			일    			       
    			       </td>
    			    </tr>
    			  <tr>
    			    <td>&nbsp;카드주 성명 :&nbsp;
    			      <input type='text' name='c_cms_dep_nm' value='<%=card_cms.getCms_dep_nm()%>' size='30' class='text'>
              &nbsp;&nbsp;카드주 생년월일 :
    			      <input type='text' name='c_cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(card_cms.getCms_dep_ssn())%>">
					  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
						<script>
							function openDaumPostcode() {
								new daum.Postcode({
									oncomplete: function(data) {
										document.getElementById('t_zip').value = data.zonecode;
										document.getElementById('t_addr').value = data.address;
										
									}
								}).open();
							}
						</script>
						<br>
    			      &nbsp;신청인 주소 : 
					  <input type="button" onclick="openDaumPostcode()" value="우편번호 찾기">
					  <input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=card_cms.getCms_dep_post()%>">
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="50" value="<%=card_cms.getCms_dep_addr()%>">
        				  </td>
        			    </tr>			
        			  <tr>
        			    <td>&nbsp;연락전화 :
    			      <input type='text' name='c_cms_tel' size='15' class='text' value="<%=card_cms.getCms_tel()%>">

    			      &nbsp;&nbsp;휴대폰 :
    			      <input type='text' name='c_cms_m_tel' size='15' class='text' value="<%=card_cms.getCms_m_tel()%>">
    					  
    			      &nbsp;&nbsp;이메일 :
    			      <input type='text' name='c_cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%=card_cms.getCms_email()%>">	

        				  </td>
        			    </tr>	
        			    <tr>
        			    <td>&nbsp;최초인출일자 :
    			      <input type='text' name='c_cms_start_dt' size='11' class='text' value="<%=AddUtil.ChangeDate2(card_cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>

    			     

        				  </td>
        			    </tr>	    			    
    			</table>
    			</td>
              </tr>
              
    		 <%}%>
            </table>
        </td>
    </tr>			
	<%} %>		
		

    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>	
    <tr>
	    <td align='center'>
	        <%if(cng_item.equals("pay_way") && !cms.getApp_dt().equals("")){%>	
	        
	        <%}else{%>
	        <%    if(!auth_rw.equals("1")){%>
	  	<a href='javascript:update();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
	  	&nbsp;
	  	<%    }%>
	  	<%}%>
	  	<a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 
			  	</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	fm.fee_fst_amt.value = '<%=AddUtil.parseDecimal(f_fee_rm.getF_rent_tot_amt())%>';
//-->
</script>
</body>
</html>
